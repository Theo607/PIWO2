#include "protocol.h"

void protocol_init_packet(Packet *pkt, uint8_t target, uint8_t type) {
    if (!pkt) return;
    
    pkt->start_marker = 0xAA;
    pkt->sender_id    = 0;
    pkt->target_id    = target;
    pkt->msg_type     = type;
    pkt->length       = 0;
    
    for (int i = 0; i < 16; i++) {
        pkt->payload[i] = 0;
    }
    
    pkt->crc16 = 0;
}

uint16_t protocol_calculate_crc(const uint8_t *data, uint16_t length) {
    uint16_t crc = 0xFFFF;
    
    for (uint16_t i = 0; i < length; i++) {
        crc ^= ((uint16_t)data[i] << 8);
        for (uint8_t j = 0; j < 8; j++) {
            if (crc & 0x8000) {
                crc = (crc << 1) ^ 0x1021;
            } else {
                crc = crc << 1;
            }
        }
    }
    
    return crc;
}

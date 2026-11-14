#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <stdint.h>

typedef struct __attribute__((packed)) {
    uint8_t start_marker;  // e.g., 0xAA
    uint8_t sender_id;     // 0 for TX, or specific node ID
    uint8_t target_id;     // 0xFF for broadcast
    uint8_t msg_type;      // Data type indicator
    uint8_t length;        // Payload length
    uint8_t payload[16];   // Data bytes
    uint16_t crc16;        // Checksum
} Packet;

void protocol_init_packet(Packet *pkt, uint8_t target, uint8_t type);
uint16_t protocol_calculate_crc(const uint8_t *data, uint16_t length);

#endif

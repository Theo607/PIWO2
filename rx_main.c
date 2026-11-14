#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/usart.h>
#include "protocol.h"

#define MY_NODE_ID 0x02  // Unique ID

static void clock_setup(void) {
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_USART2);
}

static void usart_setup(void) {
    // PA2 = TX, PA3 = RX (USART2 on Nucleo-F411RE)
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO2 | GPIO3);
    gpio_set_af(GPIOA, GPIO_AF7, GPIO2 | GPIO3);

    usart_set_baudrate(USART2, 9600);
    usart_set_databits(USART2, 8);
    usart_set_stopbits(USART2, USART_STOPBITS_1);
    usart_set_parity(USART2, USART_PARITY_NONE);
    usart_set_flow_control(USART2, USART_FLOWCONTROL_NONE);
    usart_set_mode(USART2, USART_MODE_RX);

    usart_enable(USART2);
}

int main(void) {
    clock_setup();
    usart_setup();

    // LED (PA5) visual feedback on valid packet 
    gpio_mode_setup(GPIOA, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO5);

    while (1) {
        Packet pkt;
        uint8_t *ptr = (uint8_t *)&pkt;

	// Block until marker 0xAA
        do {
            ptr[0] = usart_recv_blocking(USART2);
        } while (ptr[0] != 0xAA);

        // Read
        for (unsigned int i = 1; i < sizeof(Packet); i++) {
            ptr[i] = usart_recv_blocking(USART2);
        }

        uint16_t received_crc = pkt.crc16;

        uint16_t calculated_crc = protocol_calculate_crc((uint8_t *)&pkt, sizeof(Packet) - sizeof(uint16_t));

        if (calculated_crc == received_crc) {
            if (pkt.target_id == MY_NODE_ID || pkt.target_id == 0xFF) {
                // Valid packet 
                gpio_toggle(GPIOA, GPIO5);
            }
        }
    }
}

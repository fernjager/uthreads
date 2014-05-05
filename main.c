/* -----------------------------------------------------------------------
 * Title: Led blinking reaction on pressed switch (I/O)
 * Hardware: ATtin85
 -----------------------------------------------------------------------*/



#define F_CPU 1000000UL // Define software reference clock for delay duration
// Must be write before call delay.h
#include <avr/io.h>
#include <inttypes.h>
#include <avr/interrupt.h>

#include <util/delay.h>

#define MAX_THREADS 5
volatile uint8_t totalThreads;
volatile uint8_t currentThread;
volatile uint8_t savedStates[MAX_THREADS][34]; // 32 registers + status + PC


void dummyFunction(void* f){
	PORTB=*((uint8_t*)f);
}

/*
ISR(TIMER1_COMPA_vect){
	PORTB ^= (1<<PB3);
}

ISR(TIMER0_COMPA_vect){
        PORTB ^= (1<<PB3);
}

void setupISR(){
	cli();
	// reset timer1 counter value
	TCNT1 = 0;
	GTCCR |= (1<<PSR1);

        // if we're equal to this value
        OCR1A = 61;	
	OCR1C = 61;

	// prescale CPU/16384, and clear timer on compare
	TCCR1 |= (1<<CTC1) | (1<<CS10) | (1<<CS11) | (1<<CS12) | (1<<CS13); 
	
	// compare against OCR1A
	TIMSK |= (1<<OCIE1A);
        sei();

        cli();

        // reset timer1 counter value
        TCNT0 = 0;
        GTCCR |= (1<<PSR0);

        // if we're equal to this value
        OCR0A = 0xFF;
	
	// prescale CPU/1024, and clear timer on compare
        TCCR0A |= (1<<WGM01);
	TCCR0B |= (1<<CS02) | (1<<CS00);

        // compare against OCR0A
        TIMSK |= (1<<OCIE0A);
        sei();
}

void blinkA(){
        while(1){
                _delay_ms(1000);
		PORTB ^= (1<<PB3);
        }
}

void blinkB(){
        while(1){
		_delay_ms(1000);
		PORTB ^= (1<<PB4);
        }
}
*/
int main( void )
{
//	DDRB = 0x18; 
//	setupISR();
//	blinkB();
	uint8_t arg = 5;
	addThread(dummyFunction, (void*)&arg);
}


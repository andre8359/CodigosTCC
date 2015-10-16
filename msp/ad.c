#include <msp430g2553.h>
#include <legacymsp430.h>


#define ANALOG_IN BIT0
#define ANALOG_INCH INCH_0

volatile unsigned char microsegs;
volatile long int sensorValue = 0;

void Atraso(volatile unsigned int x);

void InitAD(void)
{
        ADC10AE0 = ANALOG_IN;
        ADC10CTL1 = ANALOG_INCH + SHS_0 + ADC10DIV_0 + ADC10SSEL_3 + CONSEQ_2;
        ADC10CTL0 = SREF_0 + ADC10SHT_0 + ADC10IE + ADC10ON;
        ADC10CTL0 |= ENC;
}

int main (void)
{
        WDTCTL = WDTPW + WDTHOLD;

        BCSCTL1 = CALBC1_1MHZ;
        DCOCTL = CALDCO_1MHZ;

        InitAD();

        for(;;)
        {
                Atraso(1000);
                ADC10CTL0 |= ADC10SC;
                _BIS_SR(LPM0_bits+GIE);

        }
	return 0;
}

interrupt(ADC10_VECTOR) ADC_ISR(void)
{
        ADC10CTL0 &= ~ADC10SC;
        sensorValue = ADC10MEM;

        LPM0_EXIT;
}
interrupt(TIMER0_A1_VECTOR) TA1_ISR(void)
{
        if(microsegs) microsegs--;
        else
        {
                TACTL &= ~(MC0+MC1);
                LPM0_EXIT;
        }
        TACTL &= ~TAIFG;
}
void Atraso(volatile unsigned int x)
{
        TACCR0 = 999;
        TACTL = TASSEL_2 + ID_0 + MC_1 + TAIE;
        microsegs = x;
        // Entrar em modo de baixo consumo
        _BIS_SR(LPM0_bits+GIE);
}

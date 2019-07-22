Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C65705AE
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 18:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfGVQsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 12:48:16 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38934 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbfGVQsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 12:48:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id u17so17930289pgi.6
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 09:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dXkVqTAM5JdoWwohYeTGIN9bFmqbyhgkT/ueQaecvOY=;
        b=e+UsjLWHjVfNSmy99jTEeTqnQFMILBgcxw2NNaZIeI8hqhG1er/cCUYFW4VdgvJ2i1
         +wN2uHpETYi36ZLSl0AueodtH1YFRbtrL5q1P/zeVOc+GS5dRTbhsiwgx4lH4xmqXYFP
         H7jlo2xET1BB08WUZwoY7SgkSp40NndhQ3xcFH1AMePbV3/aYlYysJ8E6UHDlBL1rcvZ
         xMVr1FHi6xMV3MfWE54Os4VFsCoeX1Kf8Z3IyBUQy65HxpJD1geNdyxgYbN+Lkj0gHR2
         uGh+/yHWPShSSAWTWtgwe8E1e8ny8TUkjWdtGsaQEK5C2fUpBdrjUCkrxo8my0jdPk7t
         Gw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dXkVqTAM5JdoWwohYeTGIN9bFmqbyhgkT/ueQaecvOY=;
        b=KiM5N4O58DirQ8+zdRVKXTxwpM6OVsxPvtvmJK5i9IkzPebGwE0dqNEFTmb5uijY0O
         ob+4grpktRdYBqu3GKSbNsVM3tqYIqameh1LePC2Wpmti4bmP4dJ6wiWkHe7Q1ZCFwI4
         Vs+uEW7aoeLqI+iFGqJW8WAvMfyZi5HHPMLRbjVQfr2lbm492ZzMNsOtuFT1jJ3bbcTc
         vnzvkaxGq/nQC670BGXKSc+np+fuQ41UAzwXfPzr5C2TfyoXfGtY4sfYsahwb1hgWPx2
         RFx2ZdQSEJzlxM7mpQU+N6RhXjsy+bxVijud2WmbKJsKkKifsXaayS+A7Sfo4q2wrqj2
         VdLQ==
X-Gm-Message-State: APjAAAU63tu+HgECDL9KR56ETs3GvuozaYNzAFSYpfAP1BpvmRSt2KrA
        FC6PG7oWt8fQBKl0vs3N74g=
X-Google-Smtp-Source: APXvYqweyM5YlqJBP99S4gca0K2ZF+Us3CoSInJD+7WWrXiW8I1JmzL98PJb0kUj/w/t7yVfKCOU9w==
X-Received: by 2002:a62:764d:: with SMTP id r74mr1216517pfc.110.1563814095328;
        Mon, 22 Jul 2019 09:48:15 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y8sm37909836pfn.52.2019.07.22.09.48.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 09:48:14 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH v2] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190722082702.rsjb3hick6524yoc@kamzik.brq.redhat.com>
Date:   Mon, 22 Jul 2019 09:48:13 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B09DB17E-1B25-4C77-8B75-CE98A2288B42@gmail.com>
References: <20190721122841.21416-1-nadav.amit@gmail.com>
 <20190722082702.rsjb3hick6524yoc@kamzik.brq.redhat.com>
To:     Andrew Jones <drjones@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 22, 2019, at 1:27 AM, Andrew Jones <drjones@redhat.com> wrote:
>=20
> On Sun, Jul 21, 2019 at 05:28:41AM -0700, Nadav Amit wrote:
>> Enable to run the tests when test-device is not present (e.g.,
>> bare-metal). Users can provide the number of CPUs and ram size =
through
>> kernel parameters.
>>=20
>> On Ubuntu, for example, the tests can be run by copying a test to the
>> boot directory (/boot) and adding a menuentry to grub (editing
>> /etc/grub.d/40_custom):
>>=20
>>  menuentry 'idt_test' {
>> 	set root=3D'ROOT'
>> 	multiboot BOOT_RELATIVE/idt_test.flat
>> 	module params.initrd
>>  }
>>=20
>> Replace ROOT with `grub-probe --target=3Dbios_hints /boot` and
>> BOOT_RELATIVE with `grub-mkrelpath /boot`, and run update-grub.
>>=20
>> params.initrd, which would be located on the boot directory should
>> describe the machine. For example for a 4 core machines with 4GB of
>> memory:
>>=20
>>  NR_CPUS=3D4
>>  MEMSIZE=3D4096
>>  TEST_DEVICE=3D0
>>  BOOTLOADER=3D1
>>=20
>> Since we do not really use E820, using more than 4GB is likely to =
fail
>> due to holes.
>>=20
>> Remember that the output goes to the serial port.
>>=20
>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>=20
>> ---
>>=20
>> v1->v2:
>> * Using initrd to hold configuration override [Andrew]
>> * Adapting vmx, tscdeadline_latency not to ignore the first argument
>>   on native
>> ---
>> lib/x86/fwcfg.c           | 32 ++++++++++++++++++++++++++++++++
>> lib/x86/fwcfg.h           | 16 ++++++++++++++++
>> x86/apic.c                |  4 +++-
>> x86/cstart64.S            |  8 ++++++--
>> x86/eventinj.c            | 20 ++++++++++++++++----
>> x86/tscdeadline_latency.c |  8 +++++---
>> x86/vmx.c                 |  7 +++++--
>> x86/vmx_tests.c           |  5 +++++
>> 8 files changed, 88 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
>> index c52b445..5f85acf 100644
>> --- a/lib/x86/fwcfg.c
>> +++ b/lib/x86/fwcfg.c
>> @@ -1,14 +1,46 @@
>> #include "fwcfg.h"
>> #include "smp.h"
>> +#include "libcflat.h"
>>=20
>> static struct spinlock lock;
>>=20
>> +static long fw_override[FW_CFG_MAX_ENTRY];
>> +
>> +bool no_test_device;
>> +bool bootloader;
>> +
>> +void read_cfg_override(void)
>> +{
>> +	const char *str;
>> +	int i;
>> +
>> +	/* Initialize to negative value that would be considered as =
invalid */
>> +	for (i =3D 0; i < FW_CFG_MAX_ENTRY; i++)
>> +		fw_override[i] =3D -1;
>> +
>> +	if ((str =3D getenv("NR_CPUS")))
>> +		fw_override[FW_CFG_NB_CPUS] =3D atol(str);
>> +
>> +	/* MEMSIZE is in megabytes */
>> +	if ((str =3D getenv("MEMSIZE")))
>> +		fw_override[FW_CFG_RAM_SIZE] =3D atol(str) * 1024 * =
1024;
>> +
>> +	if ((str =3D getenv("TEST_DEVICE")))
>> +		no_test_device =3D !atol(str);
>> +
>> +	if ((str =3D getenv("BOOTLOADER")))
>> +		bootloader =3D !!atol(str);
>> +}
>> +
>> static uint64_t fwcfg_get_u(uint16_t index, int bytes)
>> {
>>     uint64_t r =3D 0;
>>     uint8_t b;
>>     int i;
>>=20
>> +    if (fw_override[index] >=3D 0)
>> +	    return fw_override[index];
>> +
>>     spin_lock(&lock);
>>     asm volatile ("out %0, %1" : : "a"(index), =
"d"((uint16_t)BIOS_CFG_IOPORT));
>>     for (i =3D 0; i < bytes; ++i) {
>> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
>> index e0836ca..587aa95 100644
>> --- a/lib/x86/fwcfg.h
>> +++ b/lib/x86/fwcfg.h
>> @@ -2,6 +2,7 @@
>> #define FWCFG_H
>>=20
>> #include <stdint.h>
>> +#include <stdbool.h>
>>=20
>> #define FW_CFG_SIGNATURE        0x00
>> #define FW_CFG_ID               0x01
>> @@ -33,6 +34,21 @@
>> #define FW_CFG_SMBIOS_ENTRIES (FW_CFG_ARCH_LOCAL + 1)
>> #define FW_CFG_IRQ0_OVERRIDE (FW_CFG_ARCH_LOCAL + 2)
>>=20
>> +extern bool no_test_device;
>> +extern bool bootloader;
>> +
>> +void read_cfg_override(void);
>> +
>> +static inline bool test_device_enabled(void)
>> +{
>> +	return !no_test_device;
>> +}
>> +
>> +static inline bool using_bootloader(void)
>> +{
>> +	return bootloader;
>> +}
>> +
>> uint8_t fwcfg_get_u8(unsigned index);
>> uint16_t fwcfg_get_u16(unsigned index);
>> uint32_t fwcfg_get_u32(unsigned index);
>> diff --git a/x86/apic.c b/x86/apic.c
>> index 7617351..f01a5e7 100644
>> --- a/x86/apic.c
>> +++ b/x86/apic.c
>> @@ -6,6 +6,7 @@
>> #include "isr.h"
>> #include "msr.h"
>> #include "atomic.h"
>> +#include "fwcfg.h"
>>=20
>> #define MAX_TPR			0xf
>>=20
>> @@ -655,7 +656,8 @@ int main(void)
>>=20
>>     test_self_ipi();
>>     test_physical_broadcast();
>> -    test_pv_ipi();
>> +    if (test_device_enabled())
>> +        test_pv_ipi();
>>=20
>>     test_sti_nmi();
>>     test_multiple_nmi();
>> diff --git a/x86/cstart64.S b/x86/cstart64.S
>> index 1889c6b..23c1bd4 100644
>> --- a/x86/cstart64.S
>> +++ b/x86/cstart64.S
>> @@ -246,8 +246,6 @@ start64:
>> 	call mask_pic_interrupts
>> 	call enable_apic
>> 	call save_id
>> -	call smp_init
>> -	call enable_x2apic
>> 	mov mb_boot_info(%rip), %rbx
>> 	mov %rbx, %rdi
>> 	call setup_multiboot
>> @@ -255,6 +253,12 @@ start64:
>> 	mov mb_cmdline(%rbx), %eax
>> 	mov %rax, __args(%rip)
>> 	call __setup_args
>=20
> [Marking this place to reference below]
>=20
>> +
>> +	/* Read the configuration before running smp_init */
>> +	call read_cfg_override
>> +	call smp_init
>> +	call enable_x2apic
>> +
>> 	mov __argc(%rip), %edi
>> 	lea __argv(%rip), %rsi
>> 	lea __environ(%rip), %rdx
>> diff --git a/x86/eventinj.c b/x86/eventinj.c
>> index 901b9db..9e4dbec 100644
>> --- a/x86/eventinj.c
>> +++ b/x86/eventinj.c
>> @@ -8,6 +8,7 @@
>> #include "vmalloc.h"
>> #include "alloc_page.h"
>> #include "delay.h"
>> +#include "fwcfg.h"
>>=20
>> #ifdef __x86_64__
>> #  define R "r"
>> @@ -28,10 +29,15 @@ static void apic_self_nmi(void)
>> 	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | =
APIC_INT_ASSERT, 0);
>> }
>>=20
>> -#define flush_phys_addr(__s) outl(__s, 0xe4)
>> +#define flush_phys_addr(__s) do {					=
\
>> +		if (test_device_enabled())				=
\
>> +			outl(__s, 0xe4);				=
\
>> +	} while (0)
>> +
>> #define flush_stack() do {						=
\
>> 		int __l;						=
\
>> -		flush_phys_addr(virt_to_phys(&__l));			=
\
>> +		if (test_device_enabled())				=
\
>> +			flush_phys_addr(virt_to_phys(&__l));		=
\
>=20
> nit: This shouldn't be necessary as the condition is already embedded.

Indeed. Will fix.

>=20
>> } while (0)
>>=20
>> extern char isr_iret_ip[];
>> @@ -136,6 +142,8 @@ extern void do_iret(ulong phys_stack, void =
*virt_stack);
>> // Return to same privilege level won't pop SS or SP, so
>> // save it in RDX while we run on the nested stack
>>=20
>> +extern bool no_test_device;
>> +
>> asm("do_iret:"
>> #ifdef __x86_64__
>> 	"mov %rdi, %rax \n\t"		// phys_stack
>> @@ -148,10 +156,14 @@ asm("do_iret:"
>> 	"pushf"W" \n\t"
>> 	"mov %cs, %ecx \n\t"
>> 	"push"W" %"R "cx \n\t"
>> -	"push"W" $1f \n\t"
>> +	"push"W" $2f \n\t"
>> +
>> +	"cmpb $0, no_test_device\n\t"	// see if need to flush
>> +	"jnz 1f\n\t"
>> 	"outl %eax, $0xe4 \n\t"		// flush page
>> +	"1: \n\t"
>> 	"iret"W" \n\t"
>> -	"1: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
>> +	"2: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
>> 	"ret\n\t"
>>    );
>>=20
>> diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
>> index 4ee5917..4a9889a 100644
>> --- a/x86/tscdeadline_latency.c
>> +++ b/x86/tscdeadline_latency.c
>> @@ -21,6 +21,7 @@
>>  */
>>=20
>> #include "libcflat.h"
>> +#include "fwcfg.h"
>> #include "apic.h"
>> #include "vm.h"
>> #include "smp.h"
>> @@ -103,6 +104,7 @@ static void test_tsc_deadline_timer(void)
>> int main(int argc, char **argv)
>> {
>>     int i, size;
>> +    int first_arg =3D using_bootloader() ? 0 : 1;
>>=20
>>     setup_vm();
>>     smp_init();
>> @@ -111,9 +113,9 @@ int main(int argc, char **argv)
>>=20
>>     mask_pic_interrupts();
>>=20
>> -    delta =3D argc <=3D 1 ? 200000 : atol(argv[1]);
>> -    size =3D argc <=3D 2 ? TABLE_SIZE : atol(argv[2]);
>> -    breakmax =3D argc <=3D 3 ? 0 : atol(argv[3]);
>> +    delta =3D argc <=3D first_arg + 1 ? 200000 : atol(argv[first_arg =
+ 1]);
>> +    size =3D argc <=3D first_arg + 2 ? TABLE_SIZE : =
atol(argv[first_arg + 2]);
>> +    breakmax =3D argc <=3D first_arg + 3 ? 0 : atol(argv[first_arg + =
3]);
>>     printf("breakmax=3D%d\n", breakmax);
>>     test_tsc_deadline_timer();
>>     irq_enable();
>> diff --git a/x86/vmx.c b/x86/vmx.c
>> index 872ba11..a10b0fb 100644
>> --- a/x86/vmx.c
>> +++ b/x86/vmx.c
>> @@ -29,6 +29,7 @@
>>  */
>>=20
>> #include "libcflat.h"
>> +#include "fwcfg.h"
>> #include "processor.h"
>> #include "alloc_page.h"
>> #include "vm.h"
>> @@ -1919,8 +1920,10 @@ int main(int argc, const char *argv[])
>> 	/* We want xAPIC mode to test MMIO passthrough from L1 (us) to =
L2.  */
>> 	reset_apic();
>>=20
>> -	argv++;
>> -	argc--;
>> +	if (!using_bootloader()) {
>> +		argv++;
>> +		argc--;
>> +	}
>=20
> If you read the cfg overrides before calling __setup_args (marked =
above),
> then you could conditionally call __setup_args, as is done now, when
> using_booloader() is true, but when it's false, you could create a =
fake
> auxinfo.progname, and then call setup_args_progname instead. That =
would
> provide you a first arg, of whatever the fake auxinfo.progname is, and
> then you can avoid shuffling args in the unit tests.

It is the other way around - when running with a bootloader, I would =
need to=20
call setup_args_progname().

Anyhow, I can try doing something along the lines you suggested. I would
like to do one thing differently - are you ok with moving the bootloader
check into setup_args() instead? It is only used by x86 setup_env() at =
the
moment and I think it should make sense in general, and it would =
simplify
the code.


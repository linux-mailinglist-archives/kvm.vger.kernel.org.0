Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15706973B3
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 09:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfHUHjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 03:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfHUHjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 03:39:10 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CF37C057F23
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 07:39:09 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id g2so520197wmk.5
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 00:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xWGJ1pVO0cN35fAw8B/s2F9EqVbBiTBoHb9dOo2451E=;
        b=tUboor+ytoBJLZ2TNvY5R+sbeHHzDk4VhZNGoy8ozhdV2NazR7Q+XYj/pRJZ2pXpf4
         lG0o63CAv4kxQF6Szvc4CR1mLlmEsulgEu0n/5y0pNow+zgEBD4MbjQIY+3kFknWsFRY
         Q2XiM7Drtzqp+8+P1x7Un99E3Up0JACTEnYvGcaPdKV35xpp/sH3Ys76YFjNGKA1WOcY
         hppvcNWsdsbIzLxKfidH5xlUpWWdjHJ4mVFvpmubQ/BexWqKHojmtBXXNLqUZ/Uwo3Yt
         9rnPdP6MI5ldJzduDnk18GD2BXkAns3KSk77ZxRy9RJWUyxIaQ8/7H3CoKMK70cPsDm4
         ZIcw==
X-Gm-Message-State: APjAAAVxcNuxncZRUpUdDM+MsdiQt60DhTubs/xl7fE0uoLakoqXTmZJ
        eSG+jMkvAFDs6wIdi0i3As1T4W4lg9QaCPcv6lTAV+whppZcMzGeUa9KyDbx/6MOjEwUQdyaVwe
        XbOr9CObEFAdU
X-Received: by 2002:adf:fe4f:: with SMTP id m15mr38890483wrs.36.1566373148037;
        Wed, 21 Aug 2019 00:39:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyRpVrBExr3AemxQbVvuVBpgHpcbXzowCFkxXyPk+xeJaE6/ciLNYn2kyPIdSy0hHcfk0NW5g==
X-Received: by 2002:adf:fe4f:: with SMTP id m15mr38890462wrs.36.1566373147640;
        Wed, 21 Aug 2019 00:39:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id s64sm6220293wmf.16.2019.08.21.00.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2019 00:39:06 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v3] x86: Support environments without
 test-devices
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>
References: <20190722225540.43572-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a41240ec-9ab7-7b2d-e9ef-05d20ae7a7f0@redhat.com>
Date:   Wed, 21 Aug 2019 09:39:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190722225540.43572-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/07/19 00:55, Nadav Amit wrote:
> Enable to run the tests when test-device is not present (e.g.,
> bare-metal). Users can provide the number of CPUs and ram size through
> kernel parameters.
> 
> On Ubuntu that uses grub, for example, the tests can be run by copying a
> test to the boot directory (/boot) and adding a menu-entry to grub
> (e.g., by editing /etc/grub.d/40_custom):
> 
>   menuentry 'idt_test' {
> 	set root='[ROOT]'
> 	multiboot [BOOT_RELATIVE]/[TEST].flat [PARAMETERS]
> 	module params.initrd
>   }
> 
> Replace:
>   * [ROOT] with `grub-probe --target=bios_hints /boot`
>   * [BOOT_RELATIVE] with `grub-mkrelpath /boot`
>   * [TEST] with the test executed
>   * [PARAMETERS] with the test parameters
> 
> params.initrd, which would be located on the boot directory should
> describe the machine and tell the test infrastructure that a test
> device is not present and boot-loader was used (the bootloader and qemu
> deliver test . For example for a 4 core machines with 4GB of
> memory:
> 
>   NR_CPUS=4
>   MEMSIZE=4096
>   TEST_DEVICE=0
>   BOOTLOADER=1
> 
> Since we do not really use E820, using more than 4GB is likely to fail
> due to holes.
> 
> Finally, do not forget to run update-grub. Remember that the output goes
> to the serial port.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> 
> ---
> 
> v2->v3:
>  * Adding argument to argv when bootloader is used [Andrew]
>  * Avoid unnecessary check of test-device availability [Andrew]
> 
> v1->v2:
>  * Using initrd to hold configuration override [Andrew]
>  * Adapting vmx, tscdeadline_latency not to ignore the first argument
>    on native
> ---
>  lib/argv.c      | 13 +++++++++----
>  lib/argv.h      |  1 +
>  lib/x86/fwcfg.c | 28 ++++++++++++++++++++++++++++
>  lib/x86/fwcfg.h | 10 ++++++++++
>  lib/x86/setup.c |  5 +++++
>  x86/apic.c      |  4 +++-
>  x86/cstart64.S  |  8 ++++++--
>  x86/eventinj.c  | 17 ++++++++++++++---
>  x86/vmx_tests.c |  5 +++++
>  9 files changed, 81 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/argv.c b/lib/argv.c
> index f0e183a..0312d74 100644
> --- a/lib/argv.c
> +++ b/lib/argv.c
> @@ -53,12 +53,17 @@ static void setup_args(const char *args)
>  	__setup_args();
>  }
>  
> -void setup_args_progname(const char *args)
> +void add_setup_arg(const char *arg)
>  {
> -	__argv[0] = copy_ptr;
> -	strcpy(__argv[0], auxinfo.progname);
> -	copy_ptr += strlen(auxinfo.progname) + 1;
> +	__argv[__argc] = copy_ptr;
> +	strcpy(__argv[__argc], arg);
> +	copy_ptr += strlen(arg) + 1;
>  	++__argc;
> +}
> +
> +void setup_args_progname(const char *args)
> +{
> +	add_setup_arg(auxinfo.progname);
>  	setup_args(args);
>  }
>  
> diff --git a/lib/argv.h b/lib/argv.h
> index 2104dd4..e5fcf84 100644
> --- a/lib/argv.h
> +++ b/lib/argv.h
> @@ -8,3 +8,4 @@
>  extern void __setup_args(void);
>  extern void setup_args_progname(const char *args);
>  extern void setup_env(char *env, int size);
> +extern void add_setup_arg(const char *arg);
> diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
> index c52b445..d8d797f 100644
> --- a/lib/x86/fwcfg.c
> +++ b/lib/x86/fwcfg.c
> @@ -1,14 +1,42 @@
>  #include "fwcfg.h"
>  #include "smp.h"
> +#include "libcflat.h"
>  
>  static struct spinlock lock;
>  
> +static long fw_override[FW_CFG_MAX_ENTRY];
> +
> +bool no_test_device;
> +
> +void read_cfg_override(void)
> +{
> +	const char *str;
> +	int i;
> +
> +	/* Initialize to negative value that would be considered as invalid */
> +	for (i = 0; i < FW_CFG_MAX_ENTRY; i++)
> +		fw_override[i] = -1;
> +
> +	if ((str = getenv("NR_CPUS")))
> +		fw_override[FW_CFG_NB_CPUS] = atol(str);
> +
> +	/* MEMSIZE is in megabytes */
> +	if ((str = getenv("MEMSIZE")))
> +		fw_override[FW_CFG_RAM_SIZE] = atol(str) * 1024 * 1024;
> +
> +	if ((str = getenv("TEST_DEVICE")))
> +		no_test_device = !atol(str);
> +}
> +
>  static uint64_t fwcfg_get_u(uint16_t index, int bytes)
>  {
>      uint64_t r = 0;
>      uint8_t b;
>      int i;
>  
> +    if (fw_override[index] >= 0)
> +	    return fw_override[index];
> +
>      spin_lock(&lock);
>      asm volatile ("out %0, %1" : : "a"(index), "d"((uint16_t)BIOS_CFG_IOPORT));
>      for (i = 0; i < bytes; ++i) {
> diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
> index e0836ca..88dc7a7 100644
> --- a/lib/x86/fwcfg.h
> +++ b/lib/x86/fwcfg.h
> @@ -2,6 +2,7 @@
>  #define FWCFG_H
>  
>  #include <stdint.h>
> +#include <stdbool.h>
>  
>  #define FW_CFG_SIGNATURE        0x00
>  #define FW_CFG_ID               0x01
> @@ -33,6 +34,15 @@
>  #define FW_CFG_SMBIOS_ENTRIES (FW_CFG_ARCH_LOCAL + 1)
>  #define FW_CFG_IRQ0_OVERRIDE (FW_CFG_ARCH_LOCAL + 2)
>  
> +extern bool no_test_device;
> +
> +void read_cfg_override(void);
> +
> +static inline bool test_device_enabled(void)
> +{
> +	return !no_test_device;
> +}
> +
>  uint8_t fwcfg_get_u8(unsigned index);
>  uint16_t fwcfg_get_u16(unsigned index);
>  uint32_t fwcfg_get_u32(unsigned index);
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 28bbcf4..3a2741a 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -8,6 +8,7 @@
>  #include "libcflat.h"
>  #include "fwcfg.h"
>  #include "alloc_phys.h"
> +#include "argv.h"
>  
>  extern char edata;
>  
> @@ -66,7 +67,11 @@ void setup_libcflat(void)
>  	if (initrd) {
>  		/* environ is currently the only file in the initrd */
>  		u32 size = MIN(initrd_size, ENV_SIZE);
> +		const char *str;
> +
>  		memcpy(env, initrd, size);
>  		setup_env(env, size);
> +		if ((str = getenv("BOOTLOADER")) && atol(str) != 0)
> +			add_setup_arg("bootloader");
>  	}
>  }
> diff --git a/x86/apic.c b/x86/apic.c
> index 7617351..f01a5e7 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -6,6 +6,7 @@
>  #include "isr.h"
>  #include "msr.h"
>  #include "atomic.h"
> +#include "fwcfg.h"
>  
>  #define MAX_TPR			0xf
>  
> @@ -655,7 +656,8 @@ int main(void)
>  
>      test_self_ipi();
>      test_physical_broadcast();
> -    test_pv_ipi();
> +    if (test_device_enabled())
> +        test_pv_ipi();
>  
>      test_sti_nmi();
>      test_multiple_nmi();
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 1889c6b..23c1bd4 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -246,8 +246,6 @@ start64:
>  	call mask_pic_interrupts
>  	call enable_apic
>  	call save_id
> -	call smp_init
> -	call enable_x2apic
>  	mov mb_boot_info(%rip), %rbx
>  	mov %rbx, %rdi
>  	call setup_multiboot
> @@ -255,6 +253,12 @@ start64:
>  	mov mb_cmdline(%rbx), %eax
>  	mov %rax, __args(%rip)
>  	call __setup_args
> +
> +	/* Read the configuration before running smp_init */
> +	call read_cfg_override
> +	call smp_init
> +	call enable_x2apic
> +
>  	mov __argc(%rip), %edi
>  	lea __argv(%rip), %rsi
>  	lea __environ(%rip), %rdx
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index 901b9db..c38848e 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -8,6 +8,7 @@
>  #include "vmalloc.h"
>  #include "alloc_page.h"
>  #include "delay.h"
> +#include "fwcfg.h"
>  
>  #ifdef __x86_64__
>  #  define R "r"
> @@ -28,7 +29,11 @@ static void apic_self_nmi(void)
>  	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
>  }
>  
> -#define flush_phys_addr(__s) outl(__s, 0xe4)
> +#define flush_phys_addr(__s) do {					\
> +		if (test_device_enabled())				\
> +			outl(__s, 0xe4);				\
> +	} while (0)
> +
>  #define flush_stack() do {						\
>  		int __l;						\
>  		flush_phys_addr(virt_to_phys(&__l));			\
> @@ -136,6 +141,8 @@ extern void do_iret(ulong phys_stack, void *virt_stack);
>  // Return to same privilege level won't pop SS or SP, so
>  // save it in RDX while we run on the nested stack
>  
> +extern bool no_test_device;
> +
>  asm("do_iret:"
>  #ifdef __x86_64__
>  	"mov %rdi, %rax \n\t"		// phys_stack
> @@ -148,10 +155,14 @@ asm("do_iret:"
>  	"pushf"W" \n\t"
>  	"mov %cs, %ecx \n\t"
>  	"push"W" %"R "cx \n\t"
> -	"push"W" $1f \n\t"
> +	"push"W" $2f \n\t"
> +
> +	"cmpb $0, no_test_device\n\t"	// see if need to flush
> +	"jnz 1f\n\t"
>  	"outl %eax, $0xe4 \n\t"		// flush page
> +	"1: \n\t"
>  	"iret"W" \n\t"
> -	"1: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
> +	"2: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
>  	"ret\n\t"
>     );
>  
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 8ad2674..c4b37ca 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8162,6 +8162,11 @@ static void vmx_apic_passthrough(bool set_irq_line_from_thread)
>  		return;
>  	}
>  
> +	/* Test device is required for generating IRQs */
> +	if (!test_device_enabled()) {
> +		report_skip(__func__);
> +		return;
> +	}
>  	u64 cpu_ctrl_0 = CPU_SECONDARY;
>  	u64 cpu_ctrl_1 = 0;
>  
> 

Pushed, thanks.

Paolo

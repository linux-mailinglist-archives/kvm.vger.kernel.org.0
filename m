Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167F32D82AC
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 00:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407109AbgLKXWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 18:22:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393219AbgLKXVq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 18:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607728818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8jMbNAg7d0UVa0wFUR505j3FjjG6UCAw4MfAr1Vbik=;
        b=FWfcOqP3b3gGuzhgU1Hp845ScoXgK0cpmiIp8UtgAD62gywUHf2c8LEYzGNhY7N0fwkMGG
        rTDiYhecXIpRFtMUAAgQBYVGRvfn+AQkHoG1swUyib1wKtgLHJQ/x8BD2hwsnpDNZwTIXm
        M6cLZGk1PPJnwcYy11cUs8jA/mgChg8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-KLX_tF1oMd2-SUG2wteExQ-1; Fri, 11 Dec 2020 18:20:17 -0500
X-MC-Unique: KLX_tF1oMd2-SUG2wteExQ-1
Received: by mail-ej1-f70.google.com with SMTP id k3so3290147ejr.16
        for <kvm@vger.kernel.org>; Fri, 11 Dec 2020 15:20:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I8jMbNAg7d0UVa0wFUR505j3FjjG6UCAw4MfAr1Vbik=;
        b=ESRva6SGKBPH9/LVWLGPOQHB0xgrbt8whA3Y/r3/UZ3lfq7D/GpDNkuqFXKVG9eAJW
         l2ifxbzDLNdXLWdd1Ba7yICRLPmWblEMjF/0BsnoehhOTYzNpnL1CzD1fMW6wbkMP1n1
         Hs+w1y+URrPZmy42dPR3KTInCoTwE8THPqS5KJh39d3m+6xXPWcDk239CyK54Js40X/r
         wZFnFIJw0YTr6nnoVVLrM8NAcsAdBwKIum8IJxrzvhVXITYnshAOq5CBe+6S3niS5Rot
         g3CsqfsMe1821MieQckWS1EaHbcRNN8dkXPcgxVUT+Xi7Xb8HfPd5DxmncpQAYkdGEOx
         4jog==
X-Gm-Message-State: AOAM530Dd3pppHTSAQuJm0RZwOX1ydcnpgEH014gFeJfqhLlGrzeGEzk
        jIpBAFb3J83YovVGZKRrT654jd56c1SHXh2Al594U+fxic3Mdqznim3L+53jygVYz59ANs3qI7k
        zhvstIRN8m2CB
X-Received: by 2002:aa7:da03:: with SMTP id r3mr14068266eds.155.1607728815961;
        Fri, 11 Dec 2020 15:20:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx41FH9rAnWjhTUPqGMawUB30mtG0Nu/SbKQHdRwiToO/vQLHpIanD6MvD6gm4zemzw5QV6cQ==
X-Received: by 2002:aa7:da03:: with SMTP id r3mr14068257eds.155.1607728815792;
        Fri, 11 Dec 2020 15:20:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 35sm8578679ede.0.2020.12.11.15.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 15:20:15 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: add regression test for posted
 interrupts
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20201006212556.882066-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <18085741-6370-bde6-0f28-fa788d5b68e5@redhat.com>
Date:   Sat, 12 Dec 2020 00:20:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201006212556.882066-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/20 23:25, Oliver Upton wrote:
> If a guest blocks interrupts for the entirety of running in root mode
> (RFLAGS.IF=0), a pending interrupt corresponding to the posted-interrupt
> vector set in the VMCS should result in an interrupt posting to the vIRR
> at VM-entry. However, on KVM this is not the case. The pending interrupt
> is not recognized as the posted-interrupt vector and instead results in
> an external interrupt VM-exit.
> 
> Add a regression test to exercise this issue.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>

I am a bit confused.  Is this testing the KVM or the bare metal 
behavior?  Or was this fixed in KVM already?

Paolo

> ---
>   lib/x86/asm/bitops.h |  8 +++++
>   x86/vmx_tests.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 84 insertions(+)
> 
> diff --git a/lib/x86/asm/bitops.h b/lib/x86/asm/bitops.h
> index 13a25ec9853d..ce5743538f65 100644
> --- a/lib/x86/asm/bitops.h
> +++ b/lib/x86/asm/bitops.h
> @@ -13,4 +13,12 @@
>   
>   #define HAVE_BUILTIN_FLS 1
>   
> +static inline void test_and_set_bit(long nr, unsigned long *addr)
> +{
> +	asm volatile("lock; bts %1, %0"
> +		     : "+m" (*addr)
> +		     : "Ir" (nr)
> +		     : "memory");
> +}
> +
>   #endif
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index d2084ae9e8ce..9ba9a5d452a2 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -10430,6 +10430,81 @@ static void atomic_switch_overflow_msrs_test(void)
>   		test_skip("Test is only supported on KVM");
>   }
>   
> +#define PI_VECTOR 0xe0
> +#define PI_TEST_VECTOR 0x21
> +
> +static void enable_posted_interrupts(void)
> +{
> +	void *pi_desc = alloc_page();
> +
> +	vmcs_set_bits(PIN_CONTROLS, PIN_POST_INTR);
> +	vmcs_set_bits(EXI_CONTROLS, EXI_INTA);
> +	vmcs_write(PINV, PI_VECTOR);
> +	vmcs_write(POSTED_INTR_DESC_ADDR, (u64)pi_desc);
> +}
> +
> +static unsigned long *get_pi_desc(void)
> +{
> +	return (unsigned long *)vmcs_read(POSTED_INTR_DESC_ADDR);
> +}
> +
> +static void post_interrupt(u8 vector, u32 dest)
> +{
> +	unsigned long *pi_desc = get_pi_desc();
> +
> +	test_and_set_bit(vector, pi_desc);
> +	test_and_set_bit(256, pi_desc);
> +	apic_icr_write(PI_VECTOR, dest);
> +}
> +
> +static struct vmx_posted_interrupt_test_args {
> +	bool isr_fired;
> +} vmx_posted_interrupt_test_args;
> +
> +static void vmx_posted_interrupt_test_isr(isr_regs_t *regs)
> +{
> +	volatile struct vmx_posted_interrupt_test_args *args
> +			= &vmx_posted_interrupt_test_args;
> +
> +	args->isr_fired = true;
> +	eoi();
> +}
> +
> +static void vmx_posted_interrupt_test_guest(void)
> +{
> +	handle_irq(PI_TEST_VECTOR, vmx_posted_interrupt_test_isr);
> +	irq_enable();
> +	vmcall();
> +	asm volatile("nop");
> +	vmcall();
> +}
> +
> +static void vmx_posted_interrupt_test(void)
> +{
> +	volatile struct vmx_posted_interrupt_test_args *args
> +			= &vmx_posted_interrupt_test_args;
> +
> +	if (!cpu_has_apicv()) {
> +		report_skip(__func__);
> +		return;
> +	}
> +
> +	enable_vid();
> +	enable_posted_interrupts();
> +	test_set_guest(vmx_posted_interrupt_test_guest);
> +
> +	enter_guest();
> +	skip_exit_vmcall();
> +
> +	irq_disable();
> +	post_interrupt(PI_TEST_VECTOR, apic_id());
> +	enter_guest();
> +
> +	skip_exit_vmcall();
> +	TEST_ASSERT(args->isr_fired);
> +	enter_guest();
> +}
> +
>   #define TEST(name) { #name, .v2 = name }
>   
>   /* name/init/guest_main/exit_handler/syscall_handler/guest_regs */
> @@ -10533,5 +10608,6 @@ struct vmx_test vmx_tests[] = {
>   	TEST(rdtsc_vmexit_diff_test),
>   	TEST(vmx_mtf_test),
>   	TEST(vmx_mtf_pdpte_test),
> +	TEST(vmx_posted_interrupt_test),
>   	{ NULL, NULL, NULL, NULL, NULL, {0} },
>   };
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E97B610FEDF
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 14:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfLCNeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 08:34:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30008 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725848AbfLCNeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 08:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575380056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=icYwjD9GmEJM9WhRVWU4rKoVqAWOvDFWsB0IDRS8j/4=;
        b=NgKu10fI1WaUr+IWvGpWpa1abYreK7zwSbzpuoxc64Em3Q9RCqPjEnsNAMJAxXNa9WJnm7
        Jl9n08mGx94aioTSZYSUZZ1C8rpr/RQSv6nTjp1JL0YQJp0hcJme+vLoamMJua8EZnaDjP
        +BcI7RY5/YEUnipf0bfhtTjXPhiQ95M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-9FyrhaKDOC-OmWlIOCONQg-1; Tue, 03 Dec 2019 08:34:12 -0500
Received: by mail-wm1-f70.google.com with SMTP id b131so918842wmd.9
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 05:34:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=icYwjD9GmEJM9WhRVWU4rKoVqAWOvDFWsB0IDRS8j/4=;
        b=RvAdqM7b6TfLnJDTw+pR329M7fgu24rRcx9don+S4ccuWLrFQrVQAFC4AutearmEgc
         BRFzzKs5LcxpSkTvrDRkhtt8pz3N5Br0aowyTN9WP1DivUpGIes4ObacKvsJ3j5I2Ngm
         I2g5iUCTP/Le+fAQFLrNc1DwC5y+nKmrpuJu1lhQxbnBqmB66JdMev8pQvge0lYkX9kF
         Qhvz9tefhcgT1JXVjNbigKZWhqF7RDry5g7OkhZNYUvl+jAJ/UD5toKu//zVhQkaZRd3
         41LKbi6qO2mGXN5KYzbxeBApKGBmstBbyEAtDIqqar6IH/LqAkl3E1YFrNsRhWHTUPCP
         dpIQ==
X-Gm-Message-State: APjAAAU2Pl7OmGU5v62Lt/rHUYDmdXLtMJepT3XC/ph0GRI4Djh1ZmTf
        3NS5L+rDBNodaWs0PQTlXZUOP3RJiQmsqmAxJLJ6ykfx9Jcp7eKCVkTwa0485dCR5yo0Mt+/JZT
        d3lhJ7l/ligkb
X-Received: by 2002:adf:a746:: with SMTP id e6mr5428146wrd.329.1575380051399;
        Tue, 03 Dec 2019 05:34:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxp+GN7HPv+pBuvf3ZimMgzT3a2lSmm4jN0xCVEYKMh1WbHEY/PVyMv0vFZJZ4V/G7UKZ7yig==
X-Received: by 2002:adf:a746:: with SMTP id e6mr5428118wrd.329.1575380050985;
        Tue, 03 Dec 2019 05:34:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id b10sm3686848wrt.90.2019.12.03.05.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 05:34:10 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] svm: Verify the effect of V_INTR_MASKING
 on INTR interrupts
To:     Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org
References: <20191203132426.21244-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fed4c647-8ed7-3653-d790-26261c3671d3@redhat.com>
Date:   Tue, 3 Dec 2019 14:34:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191203132426.21244-1-cavery@redhat.com>
Content-Language: en-US
X-MC-Unique: 9FyrhaKDOC-OmWlIOCONQg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/19 14:24, Cathy Avery wrote:
> The test confirms the influence of the V_INTR_MASKING bit
> on RFLAGS.IF. The expectation is while running a guest
> with V_INTR_MASKING cleared to zero:
> 
> - EFLAGS.IF controls both virtual and physical interrupts.
> 
> While running a guest with V_INTR_MASKING set to 1:
> 
> - The host EFLAGS.IF at the time of the VMRUN is saved and
>   controls physical interrupts while the guest is running.
> 
> - The guest value of EFLAGS.IF controls virtual interrupts only.
> 
> As discussed previously, this patch also modifies the vmrun
> loop ( test_run ) to allow running with HIF=0

Looks good, just a couple nits below.

> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  x86/svm.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 104 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 0360d8d..fb5796f 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -44,6 +44,8 @@ u64 runs;
>  u8 *io_bitmap;
>  u8 io_bitmap_area[16384];
>  
> +u64 set_host_if = 1;

"u8 set_host_if;" here

> +
>  #define MSR_BITMAP_SIZE 8192
>  
>  u8 *msr_bitmap;
> @@ -266,21 +268,24 @@ static void test_run(struct test *test, struct vmcb *vmcb)


... "set_host_if = 1;" before invoking the ->prepare function...

>          tsc_start = rdtsc();
>          asm volatile (
>              "clgi \n\t"
> +            "cmp $0, set_host_if\n\t"

... and cmpb here.

> +            "jz 1f\n\t"
> +            "sti \n\t"
> +            "1: \n\t"
>              "vmload \n\t"
>              "mov regs+0x80, %%r15\n\t"  // rflags
>              "mov %%r15, 0x170(%0)\n\t"
>              "mov regs, %%r15\n\t"       // rax
>              "mov %%r15, 0x1f8(%0)\n\t"
>              LOAD_GPR_C
> -            "sti \n\t"		// only used if V_INTR_MASKING=1
>              "vmrun \n\t"
> -            "cli \n\t"
>              SAVE_GPR_C
>              "mov 0x170(%0), %%r15\n\t"  // rflags
>              "mov %%r15, regs+0x80\n\t"
>              "mov 0x1f8(%0), %%r15\n\t"  // rax
>              "mov %%r15, regs\n\t"
>              "vmsave \n\t"
> +            "cli \n\t"
>              "stgi"
>              : : "a"(vmcb_phys)
>              : "rbx", "rcx", "rdx", "rsi",
> @@ -307,6 +312,7 @@ static bool default_supported(void)
>  static void default_prepare(struct test *test)
>  {
>      vmcb_ident(test->vmcb);
> +    cli();

I think this is not needed, perhaps it's a relic of rebasing your
previous patch?

Thanks,

Paolo

>  }
>  
>  static bool default_finished(struct test *test)
> @@ -1386,6 +1392,99 @@ static bool pending_event_check(struct test *test)
>      return get_test_stage(test) == 2;
>  }
>  
> +static void pending_event_prepare_vmask(struct test *test)
> +{
> +    default_prepare(test);
> +
> +    pending_event_ipi_fired = false;
> +
> +    set_host_if = 0;
> +
> +    handle_irq(0xf1, pending_event_ipi_isr);
> +
> +    apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
> +              APIC_DM_FIXED | 0xf1, 0);
> +
> +    set_test_stage(test, 0);
> +}
> +
> +static void pending_event_test_vmask(struct test *test)
> +{
> +    if (pending_event_ipi_fired == true) {
> +        set_test_stage(test, -1);
> +        report("Interrupt preceeded guest", false);
> +        vmmcall();
> +    }
> +
> +    irq_enable();
> +    asm volatile ("nop");
> +    irq_disable();
> +
> +    if (pending_event_ipi_fired != true) {
> +        set_test_stage(test, -1);
> +        report("Interrupt not triggered by guest", false);
> +    }
> +
> +    vmmcall();
> +
> +    irq_enable();
> +    asm volatile ("nop");
> +    irq_disable();
> +}
> +
> +static bool pending_event_finished_vmask(struct test *test)
> +{
> +    if ( test->vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +        report("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x", false,
> +                test->vmcb->control.exit_code);
> +        return true;
> +    }
> +
> +    switch (get_test_stage(test)) {
> +    case 0:
> +        test->vmcb->save.rip += 3;
> +
> +        pending_event_ipi_fired = false;
> +
> +        test->vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
> +
> +        apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
> +              APIC_DM_FIXED | 0xf1, 0);
> +
> +        break;
> +
> +    case 1:
> +        if (pending_event_ipi_fired == true) {
> +            report("Interrupt triggered by guest", false);
> +            return true;
> +        }
> +
> +        irq_enable();
> +        asm volatile ("nop");
> +        irq_disable();
> +
> +        if (pending_event_ipi_fired != true) {
> +            report("Interrupt not triggered by host", false);
> +            return true;
> +        }
> +
> +        break;
> +
> +    default:
> +        return true;
> +    }
> +
> +    inc_test_stage(test);
> +
> +    return get_test_stage(test) == 2;
> +}
> +
> +static bool pending_event_check_vmask(struct test *test)
> +{
> +    set_host_if = 1;
> +    return get_test_stage(test) == 2;
> +}
> +
>  static struct test tests[] = {
>      { "null", default_supported, default_prepare, null_test,
>        default_finished, null_check },
> @@ -1438,6 +1537,9 @@ static struct test tests[] = {
>        lat_svm_insn_finished, lat_svm_insn_check },
>      { "pending_event", default_supported, pending_event_prepare,
>        pending_event_test, pending_event_finished, pending_event_check },
> +    { "pending_event_vmask", default_supported, pending_event_prepare_vmask,
> +      pending_event_test_vmask, pending_event_finished_vmask,
> +      pending_event_check_vmask },
>  };
>  
>  int main(int ac, char **av)
> 


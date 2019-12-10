Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3471C118E6E
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 18:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfLJRAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 12:00:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38979 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727606AbfLJRAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 12:00:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575997252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dKxEj3WwsfHlb/kelIrf9EZIufYGgkLGW1jwzvfC5Uw=;
        b=SoDxIZh2M2NeqoFU/gnc2vC6i7uXCLZguMAHtcLNJ10+hmMlvHFHy/GufgjpUE22gt7aNY
        Vee/g2/JyrD3iLfbTmYuDEjx9LiHjcX8fS4M9V/AEGlRfbfjOx5wJ2emUqbUC30rZOQRI8
        noGgnsabtcinaOi4L5cgZoBJVIBXRp4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-wic6y8OtP1Wt4lQxSsbpbA-1; Tue, 10 Dec 2019 12:00:50 -0500
Received: by mail-wr1-f72.google.com with SMTP id r2so9182153wrp.7
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 09:00:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKxEj3WwsfHlb/kelIrf9EZIufYGgkLGW1jwzvfC5Uw=;
        b=QYy+In+q/caiNZRVbbK+ZeJc3E9IHyAM7Hmy8naODe4asEsAgMYwJDi+SCUWQFUhX7
         uYx2qAZQ6t5d5ZfeLYD3dloAr8Ra8L8b8JNd80HROnQPyxJlP3wSR+XQrhHtRRomc2ot
         btLNM32IauUUWXB3Z6TK6bwJhbh/NAAf0u7E0NTpJ9aGWBqqH5Lzaez0ucttXwgIkDLA
         8HxSO/RUsbDATGT1+0kbsMynGvQl1nn3nDwa4aY8mQJ61JMQ/CE93M77K0T60jpKNhLp
         2pP+R9yC73F1YeF8o9ndoIt5Tpud0m6LZnkSXrqrpyvD2oMAmmiQPICS9UtplAsMzNVd
         6LfA==
X-Gm-Message-State: APjAAAWxBz20gJ+tec7rayf9ll44iaZjD2Q7SDJTmoaC3bwmw9XZdUJs
        Chj9C+uF5/cTJYibvJumPPZMYHhfOQ7c7VK2mZENTw3EbB3mPfOuo7F22iCJrH/n3TSf3Pqbjsz
        O16nzplCI9qn8
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr4311386wrs.42.1575997249316;
        Tue, 10 Dec 2019 09:00:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNFD+9XgtGjK0XwbykUplrVYPSBT+0UNOjmKl3zb2/57RmhXl4Fz+511rgJWkTPt0EMu4hhw==
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr4311367wrs.42.1575997249049;
        Tue, 10 Dec 2019 09:00:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id b67sm3862505wmc.38.2019.12.10.09.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 09:00:48 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests v2] svm: Verify the effect of
 V_INTR_MASKING on INTR interrupts
To:     Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org
References: <20191203162532.24209-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4b6217e1-8e52-67e6-5420-a74136d28cc1@redhat.com>
Date:   Tue, 10 Dec 2019 18:00:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191203162532.24209-1-cavery@redhat.com>
Content-Language: en-US
X-MC-Unique: wic6y8OtP1Wt4lQxSsbpbA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/12/19 17:25, Cathy Avery wrote:
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
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
> 
> v2: Added suggested changes to set_host_if etc.
> ---
>  x86/svm.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 103 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 0360d8d..626179c 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -44,6 +44,8 @@ u64 runs;
>  u8 *io_bitmap;
>  u8 io_bitmap_area[16384];
>  
> +u8 set_host_if;
> +
>  #define MSR_BITMAP_SIZE 8192
>  
>  u8 *msr_bitmap;
> @@ -258,6 +260,7 @@ static void test_run(struct test *test, struct vmcb *vmcb)
>  
>      irq_disable();
>      test->vmcb = vmcb;
> +    set_host_if = 1;
>      test->prepare(test);
>      vmcb->save.rip = (ulong)test_thunk;
>      vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
> @@ -266,21 +269,24 @@ static void test_run(struct test *test, struct vmcb *vmcb)
>          tsc_start = rdtsc();
>          asm volatile (
>              "clgi \n\t"
> +            "cmpb $0, set_host_if\n\t"
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
> @@ -1386,6 +1392,98 @@ static bool pending_event_check(struct test *test)
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
> +    return get_test_stage(test) == 2;
> +}
> +
>  static struct test tests[] = {
>      { "null", default_supported, default_prepare, null_test,
>        default_finished, null_check },
> @@ -1438,6 +1536,9 @@ static struct test tests[] = {
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

Applied, thanks.

Paolo


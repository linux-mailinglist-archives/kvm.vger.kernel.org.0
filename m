Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93AB49F6DD
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 11:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbiA1KLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 05:11:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbiA1KLI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 05:11:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643364667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ftAxoZ8l66pQJfMv013oarcB/wsJNFYuUcY7jIPaDc=;
        b=TrsW5k8MklROAbSVbDkMPojnkqD9+3t2Oppcb3iRQUc/dhbrWZJgR18vAiWqVqGW6E8N5P
        ZYSMH8X06b7wMNsxKvY75bINeLU3lM/SYCWM33S9EUMyYpEfhW/EHXmTtefG9USEMpNy85
        5X6B87BZ0t4YILvtck/qyFHH9aFdOzM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-RBUSH8-QONK__-I32h6wJw-1; Fri, 28 Jan 2022 05:11:05 -0500
X-MC-Unique: RBUSH8-QONK__-I32h6wJw-1
Received: by mail-ej1-f69.google.com with SMTP id v2-20020a1709062f0200b006a5f725efc1so2649557eji.23
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 02:11:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5ftAxoZ8l66pQJfMv013oarcB/wsJNFYuUcY7jIPaDc=;
        b=qa6iE70G/IKXhSnp1jbRFT5aVvxjG0SgIU9gp92QhZL6A2FwUKeSdHqdevfd0c28OF
         1NjMNFjv2LrSWl6LrsZHuBBjQTmRjwG8iWZFRAPHKBtxbZqBRRbQFp4JGbaHcjLskd65
         JW4J3Rhvvlyqh16G/X6asg//UEY00+yyxuEpGNBtnL7DVXl/7xAG1mRN+JVWcZbb6LWN
         3Hw/YahV+YHzOP2Qt/KNYrfylN0I9g3fBOX4wPwC27nr9FpBJBE5W2Ibx4wqvlUvFFRH
         UdZ4s7tnNBrsYSdqpysPg8g1k/rMnEXG+n7pg6NbNlerA4G4NJFeJ/ZkTG6fKYLSD4X5
         lhJw==
X-Gm-Message-State: AOAM531ysznLjVzK20INrdX05+cLXzGVKahJAOx+KC78Gset+BH6282w
        vwoBh6N0QIv8ovyvbr0QE4Nb4sFh+ThbGXnpH6ygr4GZ9XvR0U6UZr6lEWceLRPyzQVCrTOKo7h
        rpsuEXL+wfgse
X-Received: by 2002:a05:6402:270f:: with SMTP id y15mr7449095edd.409.1643364664567;
        Fri, 28 Jan 2022 02:11:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpCkiRE3imz5Y58rF0ZGgHv7D7U+9UL9IaPSpsrP6cE399BD0M1e4FOfsPm/RfxZiypjvxjg==
X-Received: by 2002:a05:6402:270f:: with SMTP id y15mr7449072edd.409.1643364664269;
        Fri, 28 Jan 2022 02:11:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z8sm9700104ejc.197.2022.01.28.02.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 02:11:03 -0800 (PST)
Message-ID: <152db376-b0f3-3102-233c-a0dbb4011d0c@redhat.com>
Date:   Fri, 28 Jan 2022 11:11:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 01/22] KVM: x86: Drop unnecessary and confusing
 KVM_X86_OP_NULL macro
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
References: <20220128005208.4008533-1-seanjc@google.com>
 <20220128005208.4008533-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220128005208.4008533-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/22 01:51, Sean Christopherson wrote:
> Drop KVM_X86_OP_NULL, which is superfluous and confusing.  The macro is
> just a "pass-through" to KVM_X86_OP; it was added with the intent of
> actually using it in the future, but that obviously never happened.  The
> name is confusing because its intended use was to provide a way for
> vendor implementations to specify a NULL pointer, and even if it were
> used, wouldn't necessarily be synonymous with declaring a kvm_x86_op as
> DEFINE_STATIC_CALL_NULL.
> 
> Lastly, actually using KVM_X86_OP_NULL as intended isn't a maintanable
> approach, e.g. bleeds vendor details into common x86 code, and would
> either be prone to bit rot or would require modifying common x86 code
> when modifying a vendor implementation.

I have some patches that redefine KVM_X86_OP_NULL as "must be used with 
static_call_cond".  That's a more interesting definition, as it can be 
used to WARN if KVM_X86_OP is used with a NULL function pointer.

Paolo

> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h | 76 ++++++++++++++----------------
>   arch/x86/include/asm/kvm_host.h    |  2 -
>   arch/x86/kvm/x86.c                 |  1 -
>   3 files changed, 35 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 631d5040b31e..e07151b2d1f6 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -1,25 +1,20 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
> -#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_NULL)
> +#ifndef KVM_X86_OP
>   BUILD_BUG_ON(1)
>   #endif
>   
>   /*
> - * KVM_X86_OP() and KVM_X86_OP_NULL() are used to help generate
> - * "static_call()"s. They are also intended for use when defining
> - * the vmx/svm kvm_x86_ops. KVM_X86_OP() can be used for those
> - * functions that follow the [svm|vmx]_func_name convention.
> - * KVM_X86_OP_NULL() can leave a NULL definition for the
> - * case where there is no definition or a function name that
> - * doesn't match the typical naming convention is supplied.
> + * Invoke KVM_X86_OP() on all functions in struct kvm_x86_ops, e.g. to generate
> + * static_call declarations, definitions and updates.
>    */
> -KVM_X86_OP_NULL(hardware_enable)
> -KVM_X86_OP_NULL(hardware_disable)
> -KVM_X86_OP_NULL(hardware_unsetup)
> -KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
> +KVM_X86_OP(hardware_enable)
> +KVM_X86_OP(hardware_disable)
> +KVM_X86_OP(hardware_unsetup)
> +KVM_X86_OP(cpu_has_accelerated_tpr)
>   KVM_X86_OP(has_emulated_msr)
>   KVM_X86_OP(vcpu_after_set_cpuid)
>   KVM_X86_OP(vm_init)
> -KVM_X86_OP_NULL(vm_destroy)
> +KVM_X86_OP(vm_destroy)
>   KVM_X86_OP(vcpu_create)
>   KVM_X86_OP(vcpu_free)
>   KVM_X86_OP(vcpu_reset)
> @@ -33,9 +28,9 @@ KVM_X86_OP(get_segment_base)
>   KVM_X86_OP(get_segment)
>   KVM_X86_OP(get_cpl)
>   KVM_X86_OP(set_segment)
> -KVM_X86_OP_NULL(get_cs_db_l_bits)
> +KVM_X86_OP(get_cs_db_l_bits)
>   KVM_X86_OP(set_cr0)
> -KVM_X86_OP_NULL(post_set_cr3)
> +KVM_X86_OP(post_set_cr3)
>   KVM_X86_OP(is_valid_cr4)
>   KVM_X86_OP(set_cr4)
>   KVM_X86_OP(set_efer)
> @@ -51,15 +46,15 @@ KVM_X86_OP(set_rflags)
>   KVM_X86_OP(get_if_flag)
>   KVM_X86_OP(tlb_flush_all)
>   KVM_X86_OP(tlb_flush_current)
> -KVM_X86_OP_NULL(tlb_remote_flush)
> -KVM_X86_OP_NULL(tlb_remote_flush_with_range)
> +KVM_X86_OP(tlb_remote_flush)
> +KVM_X86_OP(tlb_remote_flush_with_range)
>   KVM_X86_OP(tlb_flush_gva)
>   KVM_X86_OP(tlb_flush_guest)
>   KVM_X86_OP(vcpu_pre_run)
>   KVM_X86_OP(run)
> -KVM_X86_OP_NULL(handle_exit)
> -KVM_X86_OP_NULL(skip_emulated_instruction)
> -KVM_X86_OP_NULL(update_emulated_instruction)
> +KVM_X86_OP(handle_exit)
> +KVM_X86_OP(skip_emulated_instruction)
> +KVM_X86_OP(update_emulated_instruction)
>   KVM_X86_OP(set_interrupt_shadow)
>   KVM_X86_OP(get_interrupt_shadow)
>   KVM_X86_OP(patch_hypercall)
> @@ -78,17 +73,17 @@ KVM_X86_OP(check_apicv_inhibit_reasons)
>   KVM_X86_OP(refresh_apicv_exec_ctrl)
>   KVM_X86_OP(hwapic_irr_update)
>   KVM_X86_OP(hwapic_isr_update)
> -KVM_X86_OP_NULL(guest_apic_has_interrupt)
> +KVM_X86_OP(guest_apic_has_interrupt)
>   KVM_X86_OP(load_eoi_exitmap)
>   KVM_X86_OP(set_virtual_apic_mode)
> -KVM_X86_OP_NULL(set_apic_access_page_addr)
> +KVM_X86_OP(set_apic_access_page_addr)
>   KVM_X86_OP(deliver_posted_interrupt)
> -KVM_X86_OP_NULL(sync_pir_to_irr)
> +KVM_X86_OP(sync_pir_to_irr)
>   KVM_X86_OP(set_tss_addr)
>   KVM_X86_OP(set_identity_map_addr)
>   KVM_X86_OP(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
> -KVM_X86_OP_NULL(has_wbinvd_exit)
> +KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
>   KVM_X86_OP(get_l2_tsc_multiplier)
>   KVM_X86_OP(write_tsc_offset)
> @@ -96,32 +91,31 @@ KVM_X86_OP(write_tsc_multiplier)
>   KVM_X86_OP(get_exit_info)
>   KVM_X86_OP(check_intercept)
>   KVM_X86_OP(handle_exit_irqoff)
> -KVM_X86_OP_NULL(request_immediate_exit)
> +KVM_X86_OP(request_immediate_exit)
>   KVM_X86_OP(sched_in)
> -KVM_X86_OP_NULL(update_cpu_dirty_logging)
> -KVM_X86_OP_NULL(vcpu_blocking)
> -KVM_X86_OP_NULL(vcpu_unblocking)
> -KVM_X86_OP_NULL(update_pi_irte)
> -KVM_X86_OP_NULL(start_assignment)
> -KVM_X86_OP_NULL(apicv_post_state_restore)
> -KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
> -KVM_X86_OP_NULL(set_hv_timer)
> -KVM_X86_OP_NULL(cancel_hv_timer)
> +KVM_X86_OP(update_cpu_dirty_logging)
> +KVM_X86_OP(vcpu_blocking)
> +KVM_X86_OP(vcpu_unblocking)
> +KVM_X86_OP(update_pi_irte)
> +KVM_X86_OP(start_assignment)
> +KVM_X86_OP(apicv_post_state_restore)
> +KVM_X86_OP(dy_apicv_has_pending_interrupt)
> +KVM_X86_OP(set_hv_timer)
> +KVM_X86_OP(cancel_hv_timer)
>   KVM_X86_OP(setup_mce)
>   KVM_X86_OP(smi_allowed)
>   KVM_X86_OP(enter_smm)
>   KVM_X86_OP(leave_smm)
>   KVM_X86_OP(enable_smi_window)
> -KVM_X86_OP_NULL(mem_enc_op)
> -KVM_X86_OP_NULL(mem_enc_reg_region)
> -KVM_X86_OP_NULL(mem_enc_unreg_region)
> +KVM_X86_OP(mem_enc_op)
> +KVM_X86_OP(mem_enc_reg_region)
> +KVM_X86_OP(mem_enc_unreg_region)
>   KVM_X86_OP(get_msr_feature)
>   KVM_X86_OP(can_emulate_instruction)
>   KVM_X86_OP(apic_init_signal_blocked)
> -KVM_X86_OP_NULL(enable_direct_tlbflush)
> -KVM_X86_OP_NULL(migrate_timers)
> +KVM_X86_OP(enable_direct_tlbflush)
> +KVM_X86_OP(migrate_timers)
>   KVM_X86_OP(msr_filter_changed)
> -KVM_X86_OP_NULL(complete_emulated_msr)
> +KVM_X86_OP(complete_emulated_msr)
>   
>   #undef KVM_X86_OP
> -#undef KVM_X86_OP_NULL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b2c3721b1c98..756806d2e801 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1538,14 +1538,12 @@ extern struct kvm_x86_ops kvm_x86_ops;
>   
>   #define KVM_X86_OP(func) \
>   	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
> -#define KVM_X86_OP_NULL KVM_X86_OP
>   #include <asm/kvm-x86-ops.h>
>   
>   static inline void kvm_ops_static_call_update(void)
>   {
>   #define KVM_X86_OP(func) \
>   	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
> -#define KVM_X86_OP_NULL KVM_X86_OP
>   #include <asm/kvm-x86-ops.h>
>   }
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8033eca6f3a1..ebab514ec82a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -129,7 +129,6 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
>   #define KVM_X86_OP(func)					     \
>   	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
>   				*(((struct kvm_x86_ops *)0)->func));
> -#define KVM_X86_OP_NULL KVM_X86_OP
>   #include <asm/kvm-x86-ops.h>
>   EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
>   EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);


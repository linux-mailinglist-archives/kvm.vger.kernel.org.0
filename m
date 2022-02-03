Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593124A8BCB
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 19:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353530AbiBCSkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 13:40:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234230AbiBCSkc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 13:40:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643913631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=di4FajHoZmn68gaJnUS8pnDPTefePlaVCP34o2CQYSk=;
        b=IJjiHOdjPFi3kNEn5ciqWzU4qQa1jYUsFiWdqTQ67/ywjvlFsUfZ6/ls1UbV2cMdUtnJs8
        D0c07h2y91tfZe0p8rvhON15JJ23XEuK2eA1YE1+OYO41B6+878VzwYzfYPmKl/IozFUR6
        f1yTRY/TCgT85OqtRLRRs8V+lKOBl6k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-vNCyoR4_M3Sd8eNQUaHmAg-1; Thu, 03 Feb 2022 13:40:30 -0500
X-MC-Unique: vNCyoR4_M3Sd8eNQUaHmAg-1
Received: by mail-ed1-f72.google.com with SMTP id ed6-20020a056402294600b004090fd8a936so1903907edb.23
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 10:40:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=di4FajHoZmn68gaJnUS8pnDPTefePlaVCP34o2CQYSk=;
        b=NeIwFqhKeaX2JVekC5yKZsQX3oJIdGKJih11njq+gV6zO+9qPYtJnbmGvgTIhGa10T
         SGM1tl9XP7mTKkGg5ZKqoBo42nGIO5ILOwBhbeHla1BL0wVnLW2K9m04qUC4PjGVVzvc
         DLJQ8wTV5TWwvvF2QAjf91q7QC/egdkd+5WzXOsQH1MUnEW0Y1Qo/gtAPGMxkp0unyBl
         HN8afg/c7twanPK6gPVQto7kF19zH5ZRmaGXOZhwYBuN6nA7cQSaevkmIAIUIzcyUHw5
         +xGhx6r2OMA56fIvI/rF/DnaqK3gqw7+ZutlhkGZcM058cIWpl0JwTZ22wJPBh86XqO/
         1obg==
X-Gm-Message-State: AOAM531B4OEbz1DVK7m9Bzq37UjjTQuDEfJrqF/L+E1KwxVPfs2Izg8H
        SjsNP96zLM4rWhmjmfKtwcOZyUrKvCFxjFT5BjA7TniRwNUTlFj3gnrelFufCXq7WzIMswOILBi
        hC8Mxl1m43qxR
X-Received: by 2002:a17:907:9620:: with SMTP id gb32mr30134972ejc.436.1643913629051;
        Thu, 03 Feb 2022 10:40:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygj6by+fjqx6dVgIa48/Eqf3NwrHdB9it2DxvG7W7p4qjr+p2zgu0sIQixhzKyeiCs3nAdqQ==
X-Received: by 2002:a17:907:9620:: with SMTP id gb32mr30134957ejc.436.1643913628774;
        Thu, 03 Feb 2022 10:40:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id x31sm22783949ede.26.2022.02.03.10.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 10:40:28 -0800 (PST)
Message-ID: <745fc750-cd52-af1e-4e5e-0644ff3be007@redhat.com>
Date:   Thu, 3 Feb 2022 19:40:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5/5] KVM: x86: allow defining return-0 static calls
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Peter Zijlstra <peterz@infradead.org>
References: <20220202181813.1103496-1-pbonzini@redhat.com>
 <20220202181813.1103496-6-pbonzini@redhat.com>
In-Reply-To: <20220202181813.1103496-6-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/22 19:18, Paolo Bonzini wrote:
> A few vendor callbacks are only used by VMX, but they return an integer
> or bool value.  Introduce KVM_X86_OP_RET0 for them: a NULL value in
> struct kvm_x86_ops will be changed to __static_call_return0.

This also needs EXPORT_SYMBOL_GPL(__static_call_ret0).  Peter, any 
objections?

Paolo

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h | 13 +++++++------
>   arch/x86/include/asm/kvm_host.h    |  4 ++++
>   arch/x86/kvm/svm/avic.c            |  5 -----
>   arch/x86/kvm/svm/svm.c             | 26 --------------------------
>   arch/x86/kvm/x86.c                 |  2 +-
>   5 files changed, 12 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 843bd9efd2ae..89fa5dd21f34 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -13,7 +13,7 @@ BUILD_BUG_ON(1)
>   KVM_X86_OP(hardware_enable)
>   KVM_X86_OP(hardware_disable)
>   KVM_X86_OP(hardware_unsetup)
> -KVM_X86_OP(cpu_has_accelerated_tpr)
> +KVM_X86_OP_RET0(cpu_has_accelerated_tpr)
>   KVM_X86_OP(has_emulated_msr)
>   KVM_X86_OP(vcpu_after_set_cpuid)
>   KVM_X86_OP(vm_init)
> @@ -76,15 +76,15 @@ KVM_X86_OP(check_apicv_inhibit_reasons)
>   KVM_X86_OP(refresh_apicv_exec_ctrl)
>   KVM_X86_OP_NULL(hwapic_irr_update)
>   KVM_X86_OP_NULL(hwapic_isr_update)
> -KVM_X86_OP_NULL(guest_apic_has_interrupt)
> +KVM_X86_OP_RET0(guest_apic_has_interrupt)
>   KVM_X86_OP(load_eoi_exitmap)
>   KVM_X86_OP(set_virtual_apic_mode)
>   KVM_X86_OP_NULL(set_apic_access_page_addr)
>   KVM_X86_OP(deliver_interrupt)
>   KVM_X86_OP_NULL(sync_pir_to_irr)
> -KVM_X86_OP(set_tss_addr)
> -KVM_X86_OP(set_identity_map_addr)
> -KVM_X86_OP(get_mt_mask)
> +KVM_X86_OP_RET0(set_tss_addr)
> +KVM_X86_OP_RET0(set_identity_map_addr)
> +KVM_X86_OP_RET0(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
>   KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
> @@ -102,7 +102,7 @@ KVM_X86_OP_NULL(vcpu_unblocking)
>   KVM_X86_OP_NULL(pi_update_irte)
>   KVM_X86_OP_NULL(pi_start_assignment)
>   KVM_X86_OP_NULL(apicv_post_state_restore)
> -KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
> +KVM_X86_OP_RET0(dy_apicv_has_pending_interrupt)
>   KVM_X86_OP_NULL(set_hv_timer)
>   KVM_X86_OP_NULL(cancel_hv_timer)
>   KVM_X86_OP(setup_mce)
> @@ -126,3 +126,4 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
>   
>   #undef KVM_X86_OP
>   #undef KVM_X86_OP_NULL
> +#undef KVM_X86_OP_RET0
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 61faeb57889c..e7e5bd9a984d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1540,6 +1540,7 @@ extern struct kvm_x86_ops kvm_x86_ops;
>   #define KVM_X86_OP(func) \
>   	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
>   #define KVM_X86_OP_NULL KVM_X86_OP
> +#define KVM_X86_OP_RET0 KVM_X86_OP
>   #include <asm/kvm-x86-ops.h>
>   
>   static inline void kvm_ops_static_call_update(void)
> @@ -1548,6 +1549,9 @@ static inline void kvm_ops_static_call_update(void)
>   	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
>   #define KVM_X86_OP(func) \
>   	WARN_ON(!kvm_x86_ops.func); KVM_X86_OP_NULL(func)
> +#define KVM_X86_OP_RET0(func) \
> +	static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
> +			   (typeof(kvm_x86_ops.func)) __static_call_return0);
>   #include <asm/kvm-x86-ops.h>
>   }
>   
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index b49ee6f34fe7..c82457793fc8 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -707,11 +707,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
>   	return 0;
>   }
>   
> -bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
> -{
> -	return false;
> -}
> -
>   static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
>   {
>   	unsigned long flags;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ab50d73b1e2e..5f75f50b861c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3479,16 +3479,6 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>   	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>   }
>   
> -static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
> -{
> -	return 0;
> -}
> -
> -static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
> -{
> -	return 0;
> -}
> -
>   static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3863,11 +3853,6 @@ static int __init svm_check_processor_compat(void)
>   	return 0;
>   }
>   
> -static bool svm_cpu_has_accelerated_tpr(void)
> -{
> -	return false;
> -}
> -
>   /*
>    * The kvm parameter can be NULL (module initialization, or invocation before
>    * VM creation). Be sure to check the kvm parameter before using it.
> @@ -3890,11 +3875,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
>   	return true;
>   }
>   
> -static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> -{
> -	return 0;
> -}
> -
>   static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4470,7 +4450,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.hardware_unsetup = svm_hardware_unsetup,
>   	.hardware_enable = svm_hardware_enable,
>   	.hardware_disable = svm_hardware_disable,
> -	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
>   	.has_emulated_msr = svm_has_emulated_msr,
>   
>   	.vcpu_create = svm_vcpu_create,
> @@ -4542,10 +4521,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.load_eoi_exitmap = avic_load_eoi_exitmap,
>   	.apicv_post_state_restore = avic_apicv_post_state_restore,
>   
> -	.set_tss_addr = svm_set_tss_addr,
> -	.set_identity_map_addr = svm_set_identity_map_addr,
> -	.get_mt_mask = svm_get_mt_mask,
> -
>   	.get_exit_info = svm_get_exit_info,
>   
>   	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
> @@ -4570,7 +4545,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.nested_ops = &svm_nested_ops,
>   
>   	.deliver_interrupt = svm_deliver_interrupt,
> -	.dy_apicv_has_pending_interrupt = avic_dy_apicv_has_pending_interrupt,
>   	.pi_update_irte = avic_pi_update_irte,
>   	.setup_mce = svm_setup_mce,
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a527cffd0a2b..2daca3dd128a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -129,6 +129,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
>   	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
>   				*(((struct kvm_x86_ops *)0)->func));
>   #define KVM_X86_OP_NULL KVM_X86_OP
> +#define KVM_X86_OP_RET0 KVM_X86_OP
>   #include <asm/kvm-x86-ops.h>
>   EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
>   EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
> @@ -12057,7 +12058,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>   {
>   	return (is_guest_mode(vcpu) &&
> -			kvm_x86_ops.guest_apic_has_interrupt &&
>   			static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
>   }
>   


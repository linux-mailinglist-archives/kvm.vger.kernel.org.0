Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC6C502BAA
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354390AbiDOOXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354391AbiDOOXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:23:20 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54286B714B;
        Fri, 15 Apr 2022 07:20:51 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t25so10065351edt.9;
        Fri, 15 Apr 2022 07:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dDTNeDwgQ2f80QO3HetILVqPBHzxNlqvwgKs3yn95RA=;
        b=DKPD9N5DwDdOtwkxKbKcj+naMh13L/OlgZeouUBvp1dJhaCrEo0+0flLzE/QdsMwKY
         4vOx2QGnaVRrQVNg5AB+ULFy3FuuQ/mt78Kw58HFE5e/z3EAb45PNq2RCQ1/8Q++Dwiy
         UPrZ+zrexKAKsvfxIZjcgcS+b/CUUtoCcTaGFkfzPex0Cx6ILQWQmWBojSPk0hrJemOo
         vY8MyMGgsgFJV5P72LtVrK45ZZc5LklEUBEIVuEXKCmcweT7qooNqroJkinmt1EcPG9X
         p6EgZqE2dMzgCa/Th15LIO1SFbFEHG+T1/u/pLRid/f7iLEi7H/mYXhmnVP8hqRdmNuX
         zJBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dDTNeDwgQ2f80QO3HetILVqPBHzxNlqvwgKs3yn95RA=;
        b=w51jJdrF+8chQOmyFWhVFGMNid8mRnnbP003U4xmWhDEGlsc8JEp/Qizh7F0R8rX0n
         K1dptHCoqLDWups1uCuuQFfoGLs0NUgYpnvE/+JvJt04CZ6LTgdrftGcQS/miDpD4azi
         MILwza0OL1Ro+/Ch1PoqAYbF2lbYvVCFJDUhlzO6lxKqLDkwWXLz3mZ08UaeTHpKXR8s
         RfRpkgW8x/qX/1O1S2OqPAgyZ0WVePzoTvVfbVVuI5zF9q84CUbdQrGHoJHJ6AUarDVA
         50AE/R6S4sb/07JUl7GjWcmfaT+YdT5Ra+I7KbAkKT7HBdDixbfXKFobbvEw1kPYlTdN
         yRcQ==
X-Gm-Message-State: AOAM530FxokE8uIijRoGD8Sb9/S86lpJSeKE4Qx3tOFujfAFgNMN5Q5E
        9CbpnVJYBcO9mvo0OknWgIU=
X-Google-Smtp-Source: ABdhPJySUaYgeQY0Nk/j9jZcTJaOOGGp/hR4T6ft5F7ar7z1ClTP27jTy55KL06uEyg9ZKLUr9wohA==
X-Received: by 2002:a05:6402:5186:b0:419:651e:5137 with SMTP id q6-20020a056402518600b00419651e5137mr8620048edd.335.1650032449870;
        Fri, 15 Apr 2022 07:20:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id q16-20020a170906145000b006bdaf981589sm1717244ejc.81.2022.04.15.07.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 07:20:49 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3fb5839e-a3f5-38ed-571c-945282373831@redhat.com>
Date:   Fri, 15 Apr 2022 16:20:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 084/104] KVM: TDX: Add a place holder to handle TDX
 VM exit
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <4028626d69d461a70838f060d6a1566089d630c3.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4028626d69d461a70838f060d6a1566089d630c3.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Wire up handle_exit and handle_exit_irqoff methods and add a place holder
> to handle VM exit.  Add helper functions to get exit info, exit
> qualification, etc.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 35 +++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 79 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h | 11 ++++++
>   3 files changed, 122 insertions(+), 3 deletions(-)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index aa84c13f8ee1..1e65406e3882 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -148,6 +148,23 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	return vmx_vcpu_load(vcpu, cpu);
>   }
>   
> +static int vt_handle_exit(struct kvm_vcpu *vcpu,
> +			     enum exit_fastpath_completion fastpath)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_handle_exit(vcpu, fastpath);
> +
> +	return vmx_handle_exit(vcpu, fastpath);
> +}
> +
> +static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_handle_exit_irqoff(vcpu);
> +
> +	vmx_handle_exit_irqoff(vcpu);
> +}
> +
>   static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -340,6 +357,18 @@ static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
>   	vmx_request_immediate_exit(vcpu);
>   }
>   
> +static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
> +			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_get_exit_info(vcpu, reason, info1, info2, intr_info,
> +				error_code);
> +		return;
> +	}
> +
> +	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
> +}
> +
>   static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -411,7 +440,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.vcpu_pre_run = vmx_vcpu_pre_run,
>   	.run = vt_vcpu_run,
> -	.handle_exit = vmx_handle_exit,
> +	.handle_exit = vt_handle_exit,
>   	.skip_emulated_instruction = vmx_skip_emulated_instruction,
>   	.update_emulated_instruction = vmx_update_emulated_instruction,
>   	.set_interrupt_shadow = vt_set_interrupt_shadow,
> @@ -446,7 +475,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.set_identity_map_addr = vmx_set_identity_map_addr,
>   	.get_mt_mask = vmx_get_mt_mask,
>   
> -	.get_exit_info = vmx_get_exit_info,
> +	.get_exit_info = vt_get_exit_info,
>   
>   	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
>   
> @@ -460,7 +489,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.load_mmu_pgd = vt_load_mmu_pgd,
>   
>   	.check_intercept = vmx_check_intercept,
> -	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> +	.handle_exit_irqoff = vt_handle_exit_irqoff,
>   
>   	.request_immediate_exit = vt_request_immediate_exit,
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 273898de9f7a..155208a8d768 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -68,6 +68,26 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
>   	return pa;
>   }
>   
> +static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_rcx_read(vcpu);
> +}
> +
> +static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_rdx_read(vcpu);
> +}
> +
> +static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_r8_read(vcpu);
> +}
> +
> +static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_r9_read(vcpu);
> +}
> +
>   static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
>   {
>   	return tdx->tdvpr.added;
> @@ -768,6 +788,25 @@ void tdx_inject_nmi(struct kvm_vcpu *vcpu)
>   	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
>   }
>   
> +void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	u16 exit_reason = tdx->exit_reason.basic;
> +
> +	if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
> +		vmx_handle_exception_nmi_irqoff(vcpu, tdexit_intr_info(vcpu));
> +	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +		vmx_handle_external_interrupt_irqoff(vcpu,
> +						     tdexit_intr_info(vcpu));
> +}
> +
> +static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +	vcpu->mmio_needed = 0;
> +	return 0;
> +}
> +
>   void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>   {
>   	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> @@ -1042,6 +1081,46 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>   	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
>   }
>   
> +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> +{
> +	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
> +
> +	if (unlikely(exit_reason.non_recoverable || exit_reason.error)) {
> +		if (exit_reason.basic == EXIT_REASON_TRIPLE_FAULT)
> +			return tdx_handle_triple_fault(vcpu);
> +
> +		kvm_pr_unimpl("TD exit 0x%llx, %d\n",
> +			exit_reason.full, exit_reason.basic);
> +		goto unhandled_exit;
> +	}
> +
> +	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
> +
> +	switch (exit_reason.basic) {
> +	default:
> +		break;
> +	}
> +
> +unhandled_exit:
> +	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> +	vcpu->run->hw.hardware_exit_reason = exit_reason.full;
> +	return 0;
> +}
> +
> +void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
> +		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	*reason = tdx->exit_reason.full;
> +
> +	*info1 = tdexit_exit_qual(vcpu);
> +	*info2 = tdexit_ext_exit_qual(vcpu);
> +
> +	*intr_info = tdexit_intr_info(vcpu);
> +	*error_code = 0;
> +}
> +
>   static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 31be5e8a1d5c..c0a34186bc37 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -146,11 +146,16 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
>   void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_put(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
> +void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu);
> +int tdx_handle_exit(struct kvm_vcpu *vcpu,
> +		enum exit_fastpath_completion fastpath);
>   
>   void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
>   void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>   			   int trig_mode, int vector);
>   void tdx_inject_nmi(struct kvm_vcpu *vcpu);
> +void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
> +		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -177,11 +182,17 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTP
>   static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
> +static inline void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu) {}
> +static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
> +		enum exit_fastpath_completion fastpath) { return 0; }
>   
>   static inline void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_deliver_interrupt(
>   	struct kvm_lapic *apic, int delivery_mode, int trig_mode, int vector) {}
>   static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_get_exit_info(
> +	struct kvm_vcpu *vcpu, u32 *reason, u64 *info1, u64 *info2,
> +	u32 *intr_info, u32 *error_code) {}
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }


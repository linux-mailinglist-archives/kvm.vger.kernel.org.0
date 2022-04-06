Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C351A4F637C
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbiDFPgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbiDFPgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:36:10 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1626923A38E;
        Wed,  6 Apr 2022 05:50:11 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id ot30so3957640ejb.12;
        Wed, 06 Apr 2022 05:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pt7TSd6r3SW8sWMAv1Z42CcZcZBRQY+EvLVZF6kLVQU=;
        b=hDIvPV6La1NpZZdp3z0+Raf6hxISsksF3jFajI1oSi8tjYg2Fdv5li0Ox2rJ8cl2cV
         RMbmMA/Qt8vJ9ZBCHXQg4oiBF42le6LjBRix9m62O+Zgp7XQ1D0LKzWgZCfkjBhhsPe0
         b4nBi4pyGRCwUzVH2X3f6B0XTuH8/UePbSjKp71F1vMlaHd08E31Nr7PVOqGGkuU/Tb7
         LT81vJnk3rqYUZaE1tOeWz1KSFHbEF4zLGdlKtCdztLDOvkiZ69A+n9N493RNiM7D6LT
         8xws12oq5HTstIviXDrxRo1AQ5Rhfpe++FpkOg+QvX32jwNEs3yi2sAO9isyQd2wOBCX
         StNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pt7TSd6r3SW8sWMAv1Z42CcZcZBRQY+EvLVZF6kLVQU=;
        b=67KwtjZprayjPkzuv7u+B3jlOh6s3lSH8Lt0/w5+RBHvoXZHlzV78bnajQSxdsEl4Z
         Xs7MVjmr+lDhakBR8UulbsXA0GdooNNgUL23Qo853C4hkjN/41cyDRgLZIH29ecwVKBO
         RrSFguItCAwudoS+0Kt8UZ0jdOTgZF9Q87lETXovCAfsUzNAwtPaBN7RHG4w7rH6yulZ
         VRU0veTViB2Djdxk6jzXNL/HkfjWUg5okTQW0kl9rqHqI/GqVWy4DqxGXWT1/K3m9lTg
         8fKig4gJyOtMhYC35lfKnsloXJ5IuS4ac6+XS6Qm81blkeySrjo9oQH0fzVLTKx/8B2G
         t3kA==
X-Gm-Message-State: AOAM532jugdULJQUONzIWLL6H+OKK5tCsk1hgln1Y0fdlXcP+GhjpnEl
        LBg7DRo3sOrpmM3UMuEaQ3o=
X-Google-Smtp-Source: ABdhPJxLFYIz0sE8S4r3i6TpCZYTrcSl8W+cBteXQ8DWjDacZeW9QPvhkKGj6nXbo/mVoAHtGCzCHA==
X-Received: by 2002:a17:906:9744:b0:6da:9e49:9fe3 with SMTP id o4-20020a170906974400b006da9e499fe3mr8142350ejy.319.1649249275204;
        Wed, 06 Apr 2022 05:47:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 22-20020a17090600d600b006dfbc46efabsm6553037eji.126.2022.04.06.05.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 05:47:54 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <1f1de653-4d6a-74f1-c14f-7a2268bc8dc0@redhat.com>
Date:   Wed, 6 Apr 2022 14:47:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 080/104] KVM: TDX: Implement methods to inject NMI
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c88c21250feaf720cc718ecfcd483d93b65819d3.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <c88c21250feaf720cc718ecfcd483d93b65819d3.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX vcpu control structure defines one bit for pending NMI for VMM to
> inject NMI by setting the bit without knowing TDX vcpu NMI states.  Because
> the vcpu state is protected, VMM can't know about NMI states of TDX vcpu.
> The TDX module handles actual injection and NMI states transition.
> 
> Add methods for NMI and treat NMI can be injected always.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 62 +++++++++++++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/tdx.c     |  5 +++
>   arch/x86/kvm/vmx/x86_ops.h |  2 ++
>   3 files changed, 64 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 404a260796e4..aa84c13f8ee1 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -216,6 +216,58 @@ static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
>   	vmx_flush_tlb_guest(vcpu);
>   }
>   
> +static void vt_inject_nmi(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_inject_nmi(vcpu);
> +
> +	vmx_inject_nmi(vcpu);
> +}
> +
> +static int vt_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> +{
> +	/*
> +	 * The TDX module manages NMI windows and NMI reinjection, and hides NMI
> +	 * blocking, all KVM can do is throw an NMI over the wall.
> +	 */
> +	if (is_td_vcpu(vcpu))
> +		return true;
> +
> +	return vmx_nmi_allowed(vcpu, for_injection);
> +}
> +
> +static bool vt_get_nmi_mask(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Assume NMIs are always unmasked.  KVM could query PEND_NMI and treat
> +	 * NMIs as masked if a previous NMI is still pending, but SEAMCALLs are
> +	 * expensive and the end result is unchanged as the only relevant usage
> +	 * of get_nmi_mask() is to limit the number of pending NMIs, i.e. it
> +	 * only changes whether KVM or the TDX module drops an NMI.
> +	 */
> +	if (is_td_vcpu(vcpu))
> +		return false;
> +
> +	return vmx_get_nmi_mask(vcpu);
> +}
> +
> +static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_set_nmi_mask(vcpu, masked);
> +}
> +
> +static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
> +{
> +	/* Refer the comment in vt_get_nmi_mask(). */
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_enable_nmi_window(vcpu);
> +}
> +
>   static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>   			int pgd_level)
>   {
> @@ -366,14 +418,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.get_interrupt_shadow = vt_get_interrupt_shadow,
>   	.patch_hypercall = vmx_patch_hypercall,
>   	.set_irq = vt_inject_irq,
> -	.set_nmi = vmx_inject_nmi,
> +	.set_nmi = vt_inject_nmi,
>   	.queue_exception = vmx_queue_exception,
>   	.cancel_injection = vt_cancel_injection,
>   	.interrupt_allowed = vt_interrupt_allowed,
> -	.nmi_allowed = vmx_nmi_allowed,
> -	.get_nmi_mask = vmx_get_nmi_mask,
> -	.set_nmi_mask = vmx_set_nmi_mask,
> -	.enable_nmi_window = vmx_enable_nmi_window,
> +	.nmi_allowed = vt_nmi_allowed,
> +	.get_nmi_mask = vt_get_nmi_mask,
> +	.set_nmi_mask = vt_set_nmi_mask,
> +	.enable_nmi_window = vt_enable_nmi_window,
>   	.enable_irq_window = vt_enable_irq_window,
>   	.update_cr8_intercept = vmx_update_cr8_intercept,
>   	.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index bdc658ca9e4f..273898de9f7a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -763,6 +763,11 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   	return EXIT_FASTPATH_NONE;
>   }
>   
> +void tdx_inject_nmi(struct kvm_vcpu *vcpu)
> +{
> +	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
> +}
> +
>   void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>   {
>   	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index c3768a20347f..31be5e8a1d5c 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -150,6 +150,7 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
>   void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>   			   int trig_mode, int vector);
> +void tdx_inject_nmi(struct kvm_vcpu *vcpu);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -180,6 +181,7 @@ static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_deliver_interrupt(
>   	struct kvm_lapic *apic, int delivery_mode, int trig_mode, int vector) {}
> +static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

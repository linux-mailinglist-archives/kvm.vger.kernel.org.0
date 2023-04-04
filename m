Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E426D6D62
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbjDDToy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 15:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235521AbjDDTov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 15:44:51 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C439F49EE;
        Tue,  4 Apr 2023 12:44:43 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id bx10so16772245ljb.8;
        Tue, 04 Apr 2023 12:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680637482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pVJ/oO4PqWgUVJGYQiE2Bs2VeBx12O+BQ7ywAf2OeI=;
        b=d4bCpbuTo4Hk2csI5f4OrZOYm45OiRWEEdDk4GVWhp5e0hEmSWIE9o+nW59/Xi2GLE
         EBMZtjZRnGAY/RWWwDWXm3zjJmklBNNbgEWtdNMVmA5ju5Ua5amIi1AXZ26mFfgHuwn9
         IM0t83Po8yZVT3oKyPFDzXsta/z8jmDqhwV3PAhT8TIi6vG1AyEvP5/95+LNjl7yDdKk
         1Xl+zfyjuUMdaAU17XWLmHgATMiI/sjWUEp5+8eB30MtjHz6CPOlsAkB9A38575WLldZ
         dT72f1Yerq19+pMrx0oTbobqHSwP4vnQc3Pw7g6fmSmJvNwjUZ8F2G6BS1lrv1yhxuN7
         v0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680637482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1pVJ/oO4PqWgUVJGYQiE2Bs2VeBx12O+BQ7ywAf2OeI=;
        b=h+bE7oV6VmSc4JISVNYtQ8PFJmE2wNmWnB4tCUhs7AGd8/PHs+ZWDvvH0/M2LyB8U6
         U1Aln6obMTPV/LfSwvKm8EaH8eT/qoDiY7Ril4E+ZUAYFmXNDkHLXRqSUjVheZNz3Qqz
         0yVLqJxYHSYmyXLUW4MA0PK4H6t3go+h/PTDYjSJztT6NrirLPSRTLKOLsoEBPfsOgfM
         pXLGZ6rpA+TVTuFTcjDE0xExsj6MU38nCQbq3X84lTQPkOIDVvkjesFjKkIZDO51+Phk
         ov25VzyI5qTRmWlDFnSRbYi33cXlqal67cvjf9+BCiIhnmiopCBvIs6OGPZboLwwyLaY
         H3HA==
X-Gm-Message-State: AAQBX9eZKjZzPTA/cpoa+jXgF/OtUCVCoB7l4twcrF27ve1bTsLETbUS
        Tz+VBxXI2B2tiNAA/MkiNKU=
X-Google-Smtp-Source: AKy350YIKtuHWE+uukfkqQ0YBkQtpDukJ98ET5dzlWjwnjWfnFpnAwLq2+HqY4IlmVrUm1QBWwSSIA==
X-Received: by 2002:a05:651c:1502:b0:2a6:4f81:a62a with SMTP id e2-20020a05651c150200b002a64f81a62amr75535ljf.1.1680637481800;
        Tue, 04 Apr 2023 12:44:41 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id v5-20020a197405000000b004cf6c56fdb5sm2462709lfe.232.2023.04.04.12.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 12:44:41 -0700 (PDT)
Date:   Tue, 4 Apr 2023 22:44:38 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 024/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230404224438.00000ac3.zhi.wang.linux@gmail.com>
In-Reply-To: <275b44ed878beae218db5ad9365af7e2571c0c68.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <275b44ed878beae218db5ad9365af7e2571c0c68.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:55:48 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
> structures, initialize it that doesn't require TDX SEAMCALL.  TDX specific
> vcpu initialization will be implemented as independent KVM_TDX_INIT_VCPU
> so that when error occurs it's easy to determine which component has the
> issue, KVM or TDX.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes v11 -> v12:
> - add more comments in tdx_vcpu_reset().
> - use KVM_BUG_ON()
> 
> Changes v10 -> v11:
> - NULL check of kvmalloc_array() in tdx_vcpu_reset. Move it to
>   tdx_vcpu_create()
> ---
>  arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++----
>  arch/x86/kvm/vmx/tdx.c     | 49 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/x86_ops.h | 10 ++++++++
>  arch/x86/kvm/x86.c         |  2 ++
>  4 files changed, 101 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index e57b36902313..e9fd4e80b67d 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -97,6 +97,42 @@ static void vt_vm_free(struct kvm *kvm)
>  		tdx_vm_free(kvm);
>  }
>  
> +static int vt_vcpu_precreate(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return 0;
> +
> +	return vmx_vcpu_precreate(kvm);
> +}
> +
> +static int vt_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_create(vcpu);
> +
> +	return vmx_vcpu_create(vcpu);
> +}
> +
> +static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_free(vcpu);
> +		return;
> +	}
> +
> +	vmx_vcpu_free(vcpu);
> +}
> +
> +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_reset(vcpu, init_event);
> +		return;
> +	}
> +
> +	vmx_vcpu_reset(vcpu, init_event);
> +}
> +
>  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	if (!is_td(kvm))
> @@ -137,10 +173,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.vm_destroy = vt_vm_destroy,
>  	.vm_free = vt_vm_free,
>  
> -	.vcpu_precreate = vmx_vcpu_precreate,
> -	.vcpu_create = vmx_vcpu_create,
> -	.vcpu_free = vmx_vcpu_free,
> -	.vcpu_reset = vmx_vcpu_reset,
> +	.vcpu_precreate = vt_vcpu_precreate,
> +	.vcpu_create = vt_vcpu_create,
> +	.vcpu_free = vt_vcpu_free,
> +	.vcpu_reset = vt_vcpu_reset,
>  
>  	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
>  	.vcpu_load = vmx_vcpu_load,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index aeec8bcf8921..4fec35f4f5b2 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -321,6 +321,55 @@ int tdx_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * On cpu creation, cpuid entry is blank.  Forcibly enable
> +	 * X2APIC feature to allow X2APIC.
> +	 * Because vcpu_reset() can't return error, allocation is done here.
> +	 */
> +	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
> +	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
> +
> +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> +	if (!vcpu->arch.apic)
> +		return -EINVAL;
> +
> +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> +
> +	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> +
> +	vcpu->arch.cr0_guest_owned_bits = -1ul;
> +	vcpu->arch.cr4_guest_owned_bits = -1ul;
> +
> +	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
> +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> +	vcpu->arch.guest_state_protected =
> +		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
> +
> +	return 0;
> +}
> +
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	/* This is stub for now.  More logic will come. */
> +}
> +
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +
> +	/* Ignore INIT silently because TDX doesn't support INIT event. */
> +	if (init_event)
> +		return;
> +
> +	/* This is stub for now. More logic will come here. */
> +
> +	/*
> +	 * Don't update mp_state to runnable because more initialization
> +	 * is needed by TDX_VCPU_INIT.
> +	 */
           ^
             guess this comment belongs to the later patch.
> +}
> +
>  int tdx_dev_ioctl(void __user *argp)
>  {
>  	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 544f99141f8f..1669c95d8249 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -149,7 +149,12 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>  int tdx_vm_init(struct kvm *kvm);
>  void tdx_mmu_release_hkid(struct kvm *kvm);
>  void tdx_vm_free(struct kvm *kvm);
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> +
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
>  static inline void tdx_hardware_unsetup(void) {}
> @@ -163,7 +168,12 @@ static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
>  static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
>  static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
>  static inline void tdx_vm_free(struct kvm *kvm) {}
> +
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
> +
> +static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
> +static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>  #endif
>  
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1d5d920302b..0ba15a9e126f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -496,6 +496,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	kvm_recalculate_apic_map(vcpu->kvm);
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(kvm_set_apic_base);
>  
>  /*
>   * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> @@ -12170,6 +12171,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
>  {
>  	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
>  
>  bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
>  {


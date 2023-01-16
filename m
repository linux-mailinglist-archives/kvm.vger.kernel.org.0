Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4133666C5F0
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 17:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjAPQMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 11:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjAPQLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 11:11:51 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C152A177;
        Mon, 16 Jan 2023 08:07:23 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id g14so30389866ljh.10;
        Mon, 16 Jan 2023 08:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXc23bmCxG5po7osEcqfCOuw4YGk+Pm4CKLTuwQSl9w=;
        b=EVgJ7CdVDuIhT15uajggGniri9asjMeYDbR6QPO0vpC22FyfL0NSgh2ithyR6HriKr
         gCiB+QBx9tqeE4OuG28JUYpMJOFoXahBdSVkhDvs0oDxh3dw0dCvNTcRdQ3xDEn5SawV
         FM0x5/TtGp0dSTXh8gHdO4Wb1CNmQIbzmcIIQezywtYqmnPLY49tN+8R0XLWoxliacKJ
         pFt8kHKqGsut6UVJ+h1VXjub+Oooywh5DwFRH88JvreQIw/IW5mEEe9Ptvwrlwr2gvrT
         hj4/hvXoidiay0Mvmdd4IwtKNK6SKeJ3iu5kfhtLqFm+yiLoHIn98b+30qr83B1Vig/y
         Fonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OXc23bmCxG5po7osEcqfCOuw4YGk+Pm4CKLTuwQSl9w=;
        b=iu3ENe9UMV4N673+M5nyR9HDlp36FdDVR/5dvuKgnJkkiQWy/VIv/3aOu68XlmiMOl
         j/8ro8xkfsX0Ee8rIoaDbpRf4v/YhKd1eJ5HbtVGpgVn1avlTFREwlrRfWNEF8faDs9N
         nM1/YapGYMqu6aoSO4ZjUv7y5nSs4UIBw3F4wy0dQwdg34NwpuQAxnVa4Pz+QdsqGOWf
         7o46ljx71BpmZ64hxMdR1qnrElO4cuzBlROHpcVi8pB22quY7xX1t/o/Z5gxeLkQ3ZaK
         rOPhqqwSQNZUXxOPzdnLo6et2ohFbag0mJ8qRJM9VvVX1HyjSseGXFTpTiZgYkLqS1IR
         VI5Q==
X-Gm-Message-State: AFqh2krG/xKw1OR/VYfjSGsRdy0OqsoADjkygdcNhnrfMX9Du7+Joks3
        K6Xk1IdbyC5059QUH5DAWXo=
X-Google-Smtp-Source: AMrXdXtitBcAkV5imDH5DI8ARH1Xu0byc0Ka+FLCaD5TVutura2sFyYQXe35dE21ba3vY9z4Rx02XQ==
X-Received: by 2002:a2e:2a04:0:b0:277:a4b:56c9 with SMTP id q4-20020a2e2a04000000b002770a4b56c9mr26906ljq.0.1673885241243;
        Mon, 16 Jan 2023 08:07:21 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id f27-20020a2eb5bb000000b0027fd72dd6a1sm1628731ljn.70.2023.01.16.08.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:07:21 -0800 (PST)
Date:   Mon, 16 Jan 2023 18:07:19 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v11 024/113] KVM: TDX: Do TDX specific vcpu
 initialization
Message-ID: <20230116180719.000057c4@gmail.com>
In-Reply-To: <c8f51a32315dce7d4f48d9ae6668da249e22a432.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <c8f51a32315dce7d4f48d9ae6668da249e22a432.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:32 -0800
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TD guest vcpu need to be configured before ready to run which requests
> addtional information from Device model (e.g. qemu), one 64bit value is
> passed to vcpu's RCX as an initial value.  Repurpose KVM_MEMORY_ENCRYPT_OP
> to vcpu-scope and add new sub-commands KVM_TDX_INIT_VCPU under it for such
> additional vcpu configuration.
> 

Better add more details for this mystic value to save the review efforts.

For exmaple, refining the above part as:

----

TD hands-off block(HOB) is used to pass the information from VMM to
TD virtual firmware(TDVF). Before KVM calls Intel TDX module to launch
TDVF, the address of HOB must be placed in the guest RCX.

Extend KVM_MEMORY_ENCRYPT_OP to vcpu-scope and add new... so that
TDH.VP.INIT can take the address of HOB from QEMU and place it in the
guest RCX when initializing a TDX vCPU.

----

The below paragraph seems repeating the end of the first paragraph. Guess
it can be refined or removed.


> Add callback for kvm vCPU-scoped operations of KVM_MEMORY_ENCRYPT_OP and
> add a new subcommand, KVM_TDX_INIT_VCPU, for further vcpu initialization.
>


PS: I am curious if the value of guest RCX on each VCPU will be configured
differently? (It seems they are the same according to the code of tdx-qemu)

If yes, then it is just an approach to configure the value (even it is
through TDH.VP.XXX). It should be configured in the domain level in KVM. The
TDX vCPU creation and initialization can be moved into tdx_vcpu_create()
and TDH.VP.INIT can take the value from a per-vm data structure.
 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h    |   1 +
>  arch/x86/include/asm/kvm_host.h       |   1 +
>  arch/x86/include/uapi/asm/kvm.h       |   1 +
>  arch/x86/kvm/vmx/main.c               |   9 ++
>  arch/x86/kvm/vmx/tdx.c                | 147 +++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h                |   7 ++
>  arch/x86/kvm/vmx/x86_ops.h            |  10 +-
>  arch/x86/kvm/x86.c                    |   6 ++
>  tools/arch/x86/include/uapi/asm/kvm.h |   1 +
>  9 files changed, 178 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 1a27f3aee982..e3e9b1c2599b 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -123,6 +123,7 @@ KVM_X86_OP(enable_smi_window)
>  #endif
>  KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
> +KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
>  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
>  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
>  KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 30f4ddb18548..35773f925cc5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1698,6 +1698,7 @@ struct kvm_x86_ops {
>  
>  	int (*dev_mem_enc_ioctl)(void __user *argp);
>  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> +	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
>  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index b8f28d86d4fd..9236c1699c48 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -536,6 +536,7 @@ struct kvm_pmu_event_filter {
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
>  	KVM_TDX_INIT_VM,
> +	KVM_TDX_INIT_VCPU,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 59813ca05f36..23b3ffc3fe23 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -103,6 +103,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	return tdx_vm_ioctl(kvm, argp);
>  }
>  
> +static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> +{
> +	if (!is_td_vcpu(vcpu))
> +		return -EINVAL;
> +
> +	return tdx_vcpu_ioctl(vcpu, argp);
> +}
> +
>  struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.name = KBUILD_MODNAME,
>  
> @@ -249,6 +257,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  
>  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
>  	.mem_enc_ioctl = vt_mem_enc_ioctl,
> +	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
>  };
>  
>  struct kvm_x86_init_ops vt_init_ops __initdata = {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 099f0737a5aa..e2f5a07ad4e5 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -49,6 +49,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
>  	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
>  }
>  
> +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> +{
> +	return tdx->tdvpr_pa;
> +}
> +
>  static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
>  {
>  	return kvm_tdx->tdr_pa;
> @@ -65,6 +70,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
>  	return kvm_tdx->hkid > 0;
>  }
>  
> +static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->finalized;
> +}
> +
>  static void tdx_clear_page(unsigned long page_pa)
>  {
>  	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> @@ -327,7 +337,21 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>  {
> -	/* This is stub for now.  More logic will come. */
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	int i;
> +
> +	/* Can't reclaim or free pages if teardown failed. */
> +	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
> +		return;
> +

Should we have an WARN_ON_ONCE here?

> +	if (tdx->tdvpx_pa) {
> +		for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> +			tdx_reclaim_td_page(tdx->tdvpx_pa[i]);
> +		kfree(tdx->tdvpx_pa);
> +		tdx->tdvpx_pa = NULL;
> +	}
> +	tdx_reclaim_td_page(tdx->tdvpr_pa);
> +	tdx->tdvpr_pa = 0;
>  }
>  
>  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> @@ -337,6 +361,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	/* TDX doesn't support INIT event. */
>  	if (WARN_ON_ONCE(init_event))
>  		goto td_bugged;
> +	if (WARN_ON_ONCE(is_td_vcpu_created(to_tdx(vcpu))))
> +		goto td_bugged;
>  
>  	/* TDX rquires X2APIC. */
>  	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> @@ -791,6 +817,125 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	return r;
>  }
>  
> +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	unsigned long *tdvpx_pa = NULL;
> +	unsigned long tdvpr_pa;
> +	unsigned long va;
> +	int ret, i;
> +	u64 err;
> +
> +	if (is_td_vcpu_created(tdx))
> +		return -EINVAL;
> +
> +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!va)
> +		return -ENOMEM;
> +	tdvpr_pa = __pa(va);
> +
> +	tdvpx_pa = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx_pa),
> +			   GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!tdvpx_pa) {
> +		ret = -ENOMEM;
> +		goto free_tdvpr;
> +	}
> +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +		if (!va)
> +			goto free_tdvpx;
> +		tdvpx_pa[i] = __pa(va);
> +	}
> +
> +	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
> +	if (WARN_ON_ONCE(err)) {
> +		ret = -EIO;
> +		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> +		goto td_bugged_free_tdvpx;
> +	}
> +	tdx->tdvpr_pa = tdvpr_pa;
> +
> +	tdx->tdvpx_pa = tdvpx_pa;
> +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> +		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
> +		if (WARN_ON_ONCE(err)) {
> +			ret = -EIO;
> +			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> +			for (; i < tdx_caps.tdvpx_nr_pages; i++) {
> +				free_page((unsigned long)__va(tdvpx_pa[i]));
> +				tdvpx_pa[i] = 0;
> +			}
> +			goto td_bugged;
> +		}
> +	}
> +
> +	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
> +	if (WARN_ON_ONCE(err)) {
> +		ret = -EIO;
> +		pr_tdx_error(TDH_VP_INIT, err, NULL);
> +		goto td_bugged;
> +	}
> +
> +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +
> +	return 0;
> +
> +td_bugged_free_tdvpx:
> +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> +		free_page((unsigned long)__va(tdvpx_pa[i]));
> +		tdvpx_pa[i] = 0;
> +	}
> +	kfree(tdvpx_pa);
> +td_bugged:
> +	vcpu->kvm->vm_bugged = true;
> +	return ret;
> +
> +free_tdvpx:
> +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> +		if (tdvpx_pa[i])
> +			free_page((unsigned long)__va(tdvpx_pa[i]));
> +	kfree(tdvpx_pa);
> +	tdx->tdvpx_pa = NULL;
> +free_tdvpr:
> +	if (tdvpr_pa)
> +		free_page((unsigned long)__va(tdvpr_pa));
> +	tdx->tdvpr_pa = 0;
> +
> +	return ret;
> +}

Same comments with using vm_bugged in the previous patch.

> +
> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct kvm_tdx_cmd cmd;
> +	int ret;
> +
> +	if (tdx->vcpu_initialized)
> +		return -EINVAL;
> +
> +	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> +		return -EFAULT;
> +
> +	if (cmd.error || cmd.unused)
> +		return -EINVAL;
> +
> +	/* Currently only KVM_TDX_INTI_VCPU is defined for vcpu operation. */
> +	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
> +		return -EINVAL;
> +
> +	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
> +	if (ret)
> +		return ret;
> +
> +	tdx->vcpu_initialized = true;
> +	return 0;
> +}
> +
>  static int __init tdx_module_setup(void)
>  {
>  	const struct tdsysinfo_struct *tdsysinfo;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index af7fdc1516d5..e909883d60fa 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -17,12 +17,19 @@ struct kvm_tdx {
>  	u64 xfam;
>  	int hkid;
>  
> +	bool finalized;
> +
>  	u64 tsc_offset;
>  };
>  
>  struct vcpu_tdx {
>  	struct kvm_vcpu	vcpu;
>  
> +	unsigned long tdvpr_pa;
> +	unsigned long *tdvpx_pa;
> +
> +	bool vcpu_initialized;
> +
>  	/*
>  	 * Dummy to make pmu_intel not corrupt memory.
>  	 * TODO: Support PMU for TDX.  Future work.
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 37ab2cfd35bc..fba8d0800597 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -148,11 +148,12 @@ int tdx_vm_init(struct kvm *kvm);
>  void tdx_mmu_release_hkid(struct kvm *kvm);
>  void tdx_vm_free(struct kvm *kvm);
>  
> -int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> -
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +
> +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
>  static inline void tdx_hardware_unsetup(void) {}
> @@ -165,11 +166,12 @@ static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
>  static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
>  static inline void tdx_vm_free(struct kvm *kvm) {}
>  
> -static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
> -
>  static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>  static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>  static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +
> +static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
> +static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>  #endif
>  
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e8bc66031a1d..d548d3af6428 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5976,6 +5976,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_SET_DEVICE_ATTR:
>  		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
>  		break;
> +	case KVM_MEMORY_ENCRYPT_OP:
> +		r = -ENOTTY;
> +		if (!kvm_x86_ops.vcpu_mem_enc_ioctl)
> +			goto out;
> +		r = kvm_x86_ops.vcpu_mem_enc_ioctl(vcpu, argp);
> +		break;
>  	default:
>  		r = -EINVAL;
>  	}
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index eb800965b589..6971f1288043 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
>  enum kvm_tdx_cmd_id {
>  	KVM_TDX_CAPABILITIES = 0,
>  	KVM_TDX_INIT_VM,
> +	KVM_TDX_INIT_VCPU,
>  
>  	KVM_TDX_CMD_NR_MAX,
>  };


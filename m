Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753256A579C
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 12:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjB1LR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 06:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjB1LR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 06:17:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCBD35A0;
        Tue, 28 Feb 2023 03:17:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id k21-20020a17090aaa1500b002376652e160so9264599pjq.0;
        Tue, 28 Feb 2023 03:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9vrwH5EkwNuZbI7b5St4iV/e2vDAe+9+jHa7R6moW0=;
        b=d6dYbb18WIzNGMzVqJYzOxtmMAzvAlVD4UsSBQWzFDButWR+3PQSOnI2qKnwYntBNz
         zfbOsRQNFThgUB+0mBvo+IEmneG7XCtIJCaKn/gWnlai2hQnvs3F0GquETXdty7175Vv
         abP4IxQSpCgzbvjtrzKpxLp0kRApanwty34byFqBPOHswLDQjzFvDT/94g247jaU2UJh
         XPbo0CbSZ4x9kVaZ22a8Ch5QXuhZiY13u6ByMpA9gCjCNU8J4fSjHe8znYddYH+NA2Gp
         fVgz+ECbYkIsd+wxYv8trKIWdE7c87246WFJLAHFc//qzlh2rawhcOmyL3ZhLpi198I9
         NxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9vrwH5EkwNuZbI7b5St4iV/e2vDAe+9+jHa7R6moW0=;
        b=ot+7JFq49eINFeIeFJOzfVGw/QoQY1M/aDbVluNVaOHwWDCGymOXkXzqxZi6tq8jyj
         dRy+UaK3Yg9wVWBOEin9ohSBxpPIaQNza8XybvYMHGeG+hBgLF6fWE3DHNu3IJzqZYC0
         udSNfIlrz/AajrambJvFs8M1RVcpFCjFvOGJsZ6Je4LMuLuN3xTAjWESSXIZi9sOMD/W
         Vh8dhxT5u9O9fzXZD/vlUJ64O/jNnJ1F0nhj2KUByh83gEefIijGqdVW02h0P/c9J9xE
         yRjGKjBZWCveWLkTECp3tN3kQ/w8IQZvV44CeISvQmCFCryTCAlevMgIuOdeGJTVLHw8
         w9Sg==
X-Gm-Message-State: AO0yUKVf5Z8HcX2Grf7VfllGENN7832AhrEuuRAuGTHrKdbo5ev55c2H
        zdhX+IHhymq8zjZlSl3oilekt/HnmYc=
X-Google-Smtp-Source: AK7set+20J8nWwvcKdRI2wYMHvuv5Bgcjc7F1NUw4JHSVhR9Hi42qR/g3s7N8IkOaPVlPdivZclyCw==
X-Received: by 2002:a17:902:ecc7:b0:19c:9fa5:af00 with SMTP id a7-20020a170902ecc700b0019c9fa5af00mr2150991plh.2.1677583074318;
        Tue, 28 Feb 2023 03:17:54 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id y20-20020a170902ed5400b0019c2cf12d15sm6308766plb.116.2023.02.28.03.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:17:53 -0800 (PST)
Date:   Tue, 28 Feb 2023 03:17:52 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v11 024/113] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <20230228111752.GW4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <c8f51a32315dce7d4f48d9ae6668da249e22a432.1673539699.git.isaku.yamahata@intel.com>
 <20230116180719.000057c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230116180719.000057c4@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 06:07:19PM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Thu, 12 Jan 2023 08:31:32 -0800
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TD guest vcpu need to be configured before ready to run which requests
> > addtional information from Device model (e.g. qemu), one 64bit value is
> > passed to vcpu's RCX as an initial value.  Repurpose KVM_MEMORY_ENCRYPT_OP
> > to vcpu-scope and add new sub-commands KVM_TDX_INIT_VCPU under it for such
> > additional vcpu configuration.
> > 
> 
> Better add more details for this mystic value to save the review efforts.
> 
> For exmaple, refining the above part as:
> 
> ----
> 
> TD hands-off block(HOB) is used to pass the information from VMM to
> TD virtual firmware(TDVF). Before KVM calls Intel TDX module to launch
> TDVF, the address of HOB must be placed in the guest RCX.
> 
> Extend KVM_MEMORY_ENCRYPT_OP to vcpu-scope and add new... so that
> TDH.VP.INIT can take the address of HOB from QEMU and place it in the
> guest RCX when initializing a TDX vCPU.
> 
> ----
> 
> The below paragraph seems repeating the end of the first paragraph. Guess
> it can be refined or removed.
> 
> 
> > Add callback for kvm vCPU-scoped operations of KVM_MEMORY_ENCRYPT_OP and
> > add a new subcommand, KVM_TDX_INIT_VCPU, for further vcpu initialization.
> >

I don't think it's good idea to mention about new terminology HOB and TDVF.
We can say, VMM can pass one parameter.
Here is the updated one.

    TD guest vcpu needs TDX specific initialization before running.  Repurpose
    KVM_MEMORY_ENCRYPT_OP to vcpu-scope, add a new sub-command
    KVM_TDX_INIT_VCPU, and implement the callback for it.


> PS: I am curious if the value of guest RCX on each VCPU will be configured
> differently? (It seems they are the same according to the code of tdx-qemu)
> 
> If yes, then it is just an approach to configure the value (even it is
> through TDH.VP.XXX). It should be configured in the domain level in KVM. The
> TDX vCPU creation and initialization can be moved into tdx_vcpu_create()
> and TDH.VP.INIT can take the value from a per-vm data structure.

RCX can be set for each VCPUs as ABI (or TDX SEAMCALL API) between VMM and vcpu
initial value.  It's convention between user space VMM(qemu) and guest
firmware(TDVF) to pass same RCX value for all vcpu.  So KVM shouldn't enforce
same RCX value for all vcpus.  KVM should allow user space VMM to set the value
for each vcpus.


> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h    |   1 +
> >  arch/x86/include/asm/kvm_host.h       |   1 +
> >  arch/x86/include/uapi/asm/kvm.h       |   1 +
> >  arch/x86/kvm/vmx/main.c               |   9 ++
> >  arch/x86/kvm/vmx/tdx.c                | 147 +++++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/tdx.h                |   7 ++
> >  arch/x86/kvm/vmx/x86_ops.h            |  10 +-
> >  arch/x86/kvm/x86.c                    |   6 ++
> >  tools/arch/x86/include/uapi/asm/kvm.h |   1 +
> >  9 files changed, 178 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 1a27f3aee982..e3e9b1c2599b 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -123,6 +123,7 @@ KVM_X86_OP(enable_smi_window)
> >  #endif
> >  KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
> >  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
> > +KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
> >  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
> >  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> >  KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 30f4ddb18548..35773f925cc5 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1698,6 +1698,7 @@ struct kvm_x86_ops {
> >  
> >  	int (*dev_mem_enc_ioctl)(void __user *argp);
> >  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> > +	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
> >  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> >  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> >  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index b8f28d86d4fd..9236c1699c48 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -536,6 +536,7 @@ struct kvm_pmu_event_filter {
> >  enum kvm_tdx_cmd_id {
> >  	KVM_TDX_CAPABILITIES = 0,
> >  	KVM_TDX_INIT_VM,
> > +	KVM_TDX_INIT_VCPU,
> >  
> >  	KVM_TDX_CMD_NR_MAX,
> >  };
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 59813ca05f36..23b3ffc3fe23 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -103,6 +103,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> >  	return tdx_vm_ioctl(kvm, argp);
> >  }
> >  
> > +static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> > +{
> > +	if (!is_td_vcpu(vcpu))
> > +		return -EINVAL;
> > +
> > +	return tdx_vcpu_ioctl(vcpu, argp);
> > +}
> > +
> >  struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.name = KBUILD_MODNAME,
> >  
> > @@ -249,6 +257,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  
> >  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
> >  	.mem_enc_ioctl = vt_mem_enc_ioctl,
> > +	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
> >  };
> >  
> >  struct kvm_x86_init_ops vt_init_ops __initdata = {
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 099f0737a5aa..e2f5a07ad4e5 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -49,6 +49,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> >  	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> >  }
> >  
> > +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> > +{
> > +	return tdx->tdvpr_pa;
> > +}
> > +
> >  static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> >  {
> >  	return kvm_tdx->tdr_pa;
> > @@ -65,6 +70,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> >  	return kvm_tdx->hkid > 0;
> >  }
> >  
> > +static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->finalized;
> > +}
> > +
> >  static void tdx_clear_page(unsigned long page_pa)
> >  {
> >  	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > @@ -327,7 +337,21 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >  
> >  void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> >  {
> > -	/* This is stub for now.  More logic will come. */
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	int i;
> > +
> > +	/* Can't reclaim or free pages if teardown failed. */
> > +	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
> > +		return;
> > +
> 
> Should we have an WARN_ON_ONCE here?

No.  In normal case, it can come with hkid already reclaimed.


> > +	if (tdx->tdvpx_pa) {
> > +		for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> > +			tdx_reclaim_td_page(tdx->tdvpx_pa[i]);
> > +		kfree(tdx->tdvpx_pa);
> > +		tdx->tdvpx_pa = NULL;
> > +	}
> > +	tdx_reclaim_td_page(tdx->tdvpr_pa);
> > +	tdx->tdvpr_pa = 0;
> >  }
> >  
> >  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > @@ -337,6 +361,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  	/* TDX doesn't support INIT event. */
> >  	if (WARN_ON_ONCE(init_event))
> >  		goto td_bugged;
> > +	if (WARN_ON_ONCE(is_td_vcpu_created(to_tdx(vcpu))))
> > +		goto td_bugged;
> >  
> >  	/* TDX rquires X2APIC. */
> >  	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> > @@ -791,6 +817,125 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> >  	return r;
> >  }
> >  
> > +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	unsigned long *tdvpx_pa = NULL;
> > +	unsigned long tdvpr_pa;
> > +	unsigned long va;
> > +	int ret, i;
> > +	u64 err;
> > +
> > +	if (is_td_vcpu_created(tdx))
> > +		return -EINVAL;
> > +
> > +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +	if (!va)
> > +		return -ENOMEM;
> > +	tdvpr_pa = __pa(va);
> > +
> > +	tdvpx_pa = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx_pa),
> > +			   GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > +	if (!tdvpx_pa) {
> > +		ret = -ENOMEM;
> > +		goto free_tdvpr;
> > +	}
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +		if (!va)
> > +			goto free_tdvpx;
> > +		tdvpx_pa[i] = __pa(va);
> > +	}
> > +
> > +	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
> > +	if (WARN_ON_ONCE(err)) {
> > +		ret = -EIO;
> > +		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> > +		goto td_bugged_free_tdvpx;
> > +	}
> > +	tdx->tdvpr_pa = tdvpr_pa;
> > +
> > +	tdx->tdvpx_pa = tdvpx_pa;
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
> > +		if (WARN_ON_ONCE(err)) {
> > +			ret = -EIO;
> > +			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> > +			for (; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +				free_page((unsigned long)__va(tdvpx_pa[i]));
> > +				tdvpx_pa[i] = 0;
> > +			}
> > +			goto td_bugged;
> > +		}
> > +	}
> > +
> > +	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
> > +	if (WARN_ON_ONCE(err)) {
> > +		ret = -EIO;
> > +		pr_tdx_error(TDH_VP_INIT, err, NULL);
> > +		goto td_bugged;
> > +	}
> > +
> > +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > +
> > +	return 0;
> > +
> > +td_bugged_free_tdvpx:
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > +		free_page((unsigned long)__va(tdvpx_pa[i]));
> > +		tdvpx_pa[i] = 0;
> > +	}
> > +	kfree(tdvpx_pa);
> > +td_bugged:
> > +	vcpu->kvm->vm_bugged = true;
> > +	return ret;
> > +
> > +free_tdvpx:
> > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> > +		if (tdvpx_pa[i])
> > +			free_page((unsigned long)__va(tdvpx_pa[i]));
> > +	kfree(tdvpx_pa);
> > +	tdx->tdvpx_pa = NULL;
> > +free_tdvpr:
> > +	if (tdvpr_pa)
> > +		free_page((unsigned long)__va(tdvpr_pa));
> > +	tdx->tdvpr_pa = 0;
> > +
> > +	return ret;
> > +}
> 
> Same comments with using vm_bugged in the previous patch.

I converted it to KVM_BUG_ON().
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

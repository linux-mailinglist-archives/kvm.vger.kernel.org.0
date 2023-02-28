Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3995E6A5EAA
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 19:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjB1SVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 13:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjB1SVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 13:21:23 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B5513D40;
        Tue, 28 Feb 2023 10:21:21 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id i28so1668111lfv.0;
        Tue, 28 Feb 2023 10:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677608479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9D3Hrt4tz6wKMiGCR7OnXuxwREKZkbo1Ll/0j2Mmck=;
        b=AcXJrx6x2tUIHLJ59iNBi1hFn1NisFxjziNlH5b+iHqMII3d4tl1wRgIaeNckG79bX
         hlJjKc0IqFr5tB/icxD7GpklRnO+mM4mfT1VhXqq6sl7PEyTcscJPZsb7kZaQx0IPDUo
         rW9AXuc9+dOoXFXPjLeIa6xFsrOYjXiag8pyWZDXfOfMxZVzQRGuz7WrpSsSYGCFTmjb
         EkVy+2InXfS1STXHRAFQIGc+xzT5KwsDXsR91SMhda7gtTYqsNQTyM1aBbTfVzTC6vi/
         FDhQ40P51agRp4CPo9LI9U2uA9nkOFWXQIuy0gl+wJQXxA+CyDrRK25YnDQmPbHx2Cgs
         9N5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677608479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9D3Hrt4tz6wKMiGCR7OnXuxwREKZkbo1Ll/0j2Mmck=;
        b=kSGTOxZU6l2Aj2Ruz7xHBzu+0pMUY/iMT67rtmvO2fQVOBXlqFo3LhqpaNkg5YAYE5
         KGh9IRkykpq7l5YBQEPGt+ORD8tzLJXIBstwpE7Hu8ZeiWQ89AGsMIWhMSViu0BHXtRn
         sjd+3O30zCCQBqW8zRVlycR5xiDZ+PgbeCohPZCWRa52a/hlG2rTojFC4S+ZoVqVdEQ6
         hWo/FZ3D/G9ViFaGB9d8dWlazHA1UarM7z5rWkFhb8/3LNIytm2T4yLW/ytIlBo4Xc5Z
         JAxdYHJjdpzCyfm7f8ZLXhRipToQEnEvYEgtMoYJqjRiwetnWOJDYFyIeVNb0OsLUHj1
         bkDg==
X-Gm-Message-State: AO0yUKUoJu+pi5ytO7V0JfzjUXsgFLe0fiOhaMKUSJp7lADj5Ai7Fywh
        sZ/phPvFmfOSzaWrf5avVLY=
X-Google-Smtp-Source: AK7set8bcJGE2OoyQB+NbTiYg/7h2rKZ3k/7GVnvqRk4q11K435ng4Rs1Xd5KQzaIi5XTubaY+ZAqw==
X-Received: by 2002:ac2:5197:0:b0:4b5:3e6e:382e with SMTP id u23-20020ac25197000000b004b53e6e382emr868703lfi.4.1677608479158;
        Tue, 28 Feb 2023 10:21:19 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id e8-20020a056512090800b004b5adb59ed5sm1416128lft.297.2023.02.28.10.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 10:21:18 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Tue, 28 Feb 2023 20:21:17 +0200
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v11 024/113] KVM: TDX: Do TDX specific vcpu
 initialization
Message-ID: <20230228202117.00001284@intel.com>
In-Reply-To: <20230228111752.GW4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <c8f51a32315dce7d4f48d9ae6668da249e22a432.1673539699.git.isaku.yamahata@intel.com>
        <20230116180719.000057c4@gmail.com>
        <20230228111752.GW4175971@ls.amr.corp.intel.com>
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

On Tue, 28 Feb 2023 03:17:52 -0800
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Mon, Jan 16, 2023 at 06:07:19PM +0200,
> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> 
> > On Thu, 12 Jan 2023 08:31:32 -0800
> > isaku.yamahata@intel.com wrote:
> > 
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > TD guest vcpu need to be configured before ready to run which requests
> > > addtional information from Device model (e.g. qemu), one 64bit value is
> > > passed to vcpu's RCX as an initial value.  Repurpose KVM_MEMORY_ENCRYPT_OP
> > > to vcpu-scope and add new sub-commands KVM_TDX_INIT_VCPU under it for such
> > > additional vcpu configuration.
> > > 
> > 
> > Better add more details for this mystic value to save the review efforts.
> > 
> > For exmaple, refining the above part as:
> > 
> > ----
> > 
> > TD hands-off block(HOB) is used to pass the information from VMM to
> > TD virtual firmware(TDVF). Before KVM calls Intel TDX module to launch
> > TDVF, the address of HOB must be placed in the guest RCX.
> > 
> > Extend KVM_MEMORY_ENCRYPT_OP to vcpu-scope and add new... so that
> > TDH.VP.INIT can take the address of HOB from QEMU and place it in the
> > guest RCX when initializing a TDX vCPU.
> > 
> > ----
> > 
> > The below paragraph seems repeating the end of the first paragraph. Guess
> > it can be refined or removed.
> > 
> > 
> > > Add callback for kvm vCPU-scoped operations of KVM_MEMORY_ENCRYPT_OP and
> > > add a new subcommand, KVM_TDX_INIT_VCPU, for further vcpu initialization.
> > >
> 
> I don't think it's good idea to mention about new terminology HOB and TDVF.
> We can say, VMM can pass one parameter.
> Here is the updated one.
> 
>     TD guest vcpu needs TDX specific initialization before running.  Repurpose
>     KVM_MEMORY_ENCRYPT_OP to vcpu-scope, add a new sub-command
>     KVM_TDX_INIT_VCPU, and implement the callback for it.
>

Based on the experience of reviewing this patch, I think it depends on:

1) If the reviewer needs to understand the meaning of this parameter to review
this patch? If yes, a brief description of what it is (even one sentence) is
much better than "one parameter". If no, better mention the pointer, like
"Refer XXX spec for more details of xxx". (No need to mention chapter
according to Sean's maintainer book).

Direct and informative comment is always helpful for reviewing.

2) If describing this new terminology helps on the reviewing following patches?
If the following patches modify logic around this? If yes, should take this
opportunity to educate the reviewer with brief descriptions. If no, a pointer
is good enough.

> 
> > PS: I am curious if the value of guest RCX on each VCPU will be configured
> > differently? (It seems they are the same according to the code of tdx-qemu)
> > 
> > If yes, then it is just an approach to configure the value (even it is
> > through TDH.VP.XXX). It should be configured in the domain level in KVM. The
> > TDX vCPU creation and initialization can be moved into tdx_vcpu_create()
> > and TDH.VP.INIT can take the value from a per-vm data structure.
> 
> RCX can be set for each VCPUs as ABI (or TDX SEAMCALL API) between VMM and vcpu
> initial value.  It's convention between user space VMM(qemu) and guest
> firmware(TDVF) to pass same RCX value for all vcpu.  So KVM shouldn't enforce
> same RCX value for all vcpus.  KVM should allow user space VMM to set the value
> for each vcpus.
> 

I see. That makes sense then.

> 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/include/asm/kvm-x86-ops.h    |   1 +
> > >  arch/x86/include/asm/kvm_host.h       |   1 +
> > >  arch/x86/include/uapi/asm/kvm.h       |   1 +
> > >  arch/x86/kvm/vmx/main.c               |   9 ++
> > >  arch/x86/kvm/vmx/tdx.c                | 147 +++++++++++++++++++++++++-
> > >  arch/x86/kvm/vmx/tdx.h                |   7 ++
> > >  arch/x86/kvm/vmx/x86_ops.h            |  10 +-
> > >  arch/x86/kvm/x86.c                    |   6 ++
> > >  tools/arch/x86/include/uapi/asm/kvm.h |   1 +
> > >  9 files changed, 178 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > index 1a27f3aee982..e3e9b1c2599b 100644
> > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > @@ -123,6 +123,7 @@ KVM_X86_OP(enable_smi_window)
> > >  #endif
> > >  KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
> > >  KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
> > > +KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
> > >  KVM_X86_OP_OPTIONAL(mem_enc_register_region)
> > >  KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
> > >  KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 30f4ddb18548..35773f925cc5 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1698,6 +1698,7 @@ struct kvm_x86_ops {
> > >  
> > >  	int (*dev_mem_enc_ioctl)(void __user *argp);
> > >  	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> > > +	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
> > >  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> > >  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> > >  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> > > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > > index b8f28d86d4fd..9236c1699c48 100644
> > > --- a/arch/x86/include/uapi/asm/kvm.h
> > > +++ b/arch/x86/include/uapi/asm/kvm.h
> > > @@ -536,6 +536,7 @@ struct kvm_pmu_event_filter {
> > >  enum kvm_tdx_cmd_id {
> > >  	KVM_TDX_CAPABILITIES = 0,
> > >  	KVM_TDX_INIT_VM,
> > > +	KVM_TDX_INIT_VCPU,
> > >  
> > >  	KVM_TDX_CMD_NR_MAX,
> > >  };
> > > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > > index 59813ca05f36..23b3ffc3fe23 100644
> > > --- a/arch/x86/kvm/vmx/main.c
> > > +++ b/arch/x86/kvm/vmx/main.c
> > > @@ -103,6 +103,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> > >  	return tdx_vm_ioctl(kvm, argp);
> > >  }
> > >  
> > > +static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> > > +{
> > > +	if (!is_td_vcpu(vcpu))
> > > +		return -EINVAL;
> > > +
> > > +	return tdx_vcpu_ioctl(vcpu, argp);
> > > +}
> > > +
> > >  struct kvm_x86_ops vt_x86_ops __initdata = {
> > >  	.name = KBUILD_MODNAME,
> > >  
> > > @@ -249,6 +257,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> > >  
> > >  	.dev_mem_enc_ioctl = tdx_dev_ioctl,
> > >  	.mem_enc_ioctl = vt_mem_enc_ioctl,
> > > +	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
> > >  };
> > >  
> > >  struct kvm_x86_init_ops vt_init_ops __initdata = {
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 099f0737a5aa..e2f5a07ad4e5 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -49,6 +49,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> > >  	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> > >  }
> > >  
> > > +static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
> > > +{
> > > +	return tdx->tdvpr_pa;
> > > +}
> > > +
> > >  static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> > >  {
> > >  	return kvm_tdx->tdr_pa;
> > > @@ -65,6 +70,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> > >  	return kvm_tdx->hkid > 0;
> > >  }
> > >  
> > > +static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
> > > +{
> > > +	return kvm_tdx->finalized;
> > > +}
> > > +
> > >  static void tdx_clear_page(unsigned long page_pa)
> > >  {
> > >  	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> > > @@ -327,7 +337,21 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > >  
> > >  void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> > >  {
> > > -	/* This is stub for now.  More logic will come. */
> > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > +	int i;
> > > +
> > > +	/* Can't reclaim or free pages if teardown failed. */
> > > +	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
> > > +		return;
> > > +
> > 
> > Should we have an WARN_ON_ONCE here?
> 
> No.  In normal case, it can come with hkid already reclaimed.
> 
> 
> > > +	if (tdx->tdvpx_pa) {
> > > +		for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> > > +			tdx_reclaim_td_page(tdx->tdvpx_pa[i]);
> > > +		kfree(tdx->tdvpx_pa);
> > > +		tdx->tdvpx_pa = NULL;
> > > +	}
> > > +	tdx_reclaim_td_page(tdx->tdvpr_pa);
> > > +	tdx->tdvpr_pa = 0;
> > >  }
> > >  
> > >  void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > @@ -337,6 +361,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > >  	/* TDX doesn't support INIT event. */
> > >  	if (WARN_ON_ONCE(init_event))
> > >  		goto td_bugged;
> > > +	if (WARN_ON_ONCE(is_td_vcpu_created(to_tdx(vcpu))))
> > > +		goto td_bugged;
> > >  
> > >  	/* TDX rquires X2APIC. */
> > >  	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> > > @@ -791,6 +817,125 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> > >  	return r;
> > >  }
> > >  
> > > +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> > > +{
> > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > +	unsigned long *tdvpx_pa = NULL;
> > > +	unsigned long tdvpr_pa;
> > > +	unsigned long va;
> > > +	int ret, i;
> > > +	u64 err;
> > > +
> > > +	if (is_td_vcpu_created(tdx))
> > > +		return -EINVAL;
> > > +
> > > +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > +	if (!va)
> > > +		return -ENOMEM;
> > > +	tdvpr_pa = __pa(va);
> > > +
> > > +	tdvpx_pa = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx_pa),
> > > +			   GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > > +	if (!tdvpx_pa) {
> > > +		ret = -ENOMEM;
> > > +		goto free_tdvpr;
> > > +	}
> > > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > > +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > > +		if (!va)
> > > +			goto free_tdvpx;
> > > +		tdvpx_pa[i] = __pa(va);
> > > +	}
> > > +
> > > +	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
> > > +	if (WARN_ON_ONCE(err)) {
> > > +		ret = -EIO;
> > > +		pr_tdx_error(TDH_VP_CREATE, err, NULL);
> > > +		goto td_bugged_free_tdvpx;
> > > +	}
> > > +	tdx->tdvpr_pa = tdvpr_pa;
> > > +
> > > +	tdx->tdvpx_pa = tdvpx_pa;
> > > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > > +		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
> > > +		if (WARN_ON_ONCE(err)) {
> > > +			ret = -EIO;
> > > +			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> > > +			for (; i < tdx_caps.tdvpx_nr_pages; i++) {
> > > +				free_page((unsigned long)__va(tdvpx_pa[i]));
> > > +				tdvpx_pa[i] = 0;
> > > +			}
> > > +			goto td_bugged;
> > > +		}
> > > +	}
> > > +
> > > +	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
> > > +	if (WARN_ON_ONCE(err)) {
> > > +		ret = -EIO;
> > > +		pr_tdx_error(TDH_VP_INIT, err, NULL);
> > > +		goto td_bugged;
> > > +	}
> > > +
> > > +	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > > +
> > > +	return 0;
> > > +
> > > +td_bugged_free_tdvpx:
> > > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> > > +		free_page((unsigned long)__va(tdvpx_pa[i]));
> > > +		tdvpx_pa[i] = 0;
> > > +	}
> > > +	kfree(tdvpx_pa);
> > > +td_bugged:
> > > +	vcpu->kvm->vm_bugged = true;
> > > +	return ret;
> > > +
> > > +free_tdvpx:
> > > +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
> > > +		if (tdvpx_pa[i])
> > > +			free_page((unsigned long)__va(tdvpx_pa[i]));
> > > +	kfree(tdvpx_pa);
> > > +	tdx->tdvpx_pa = NULL;
> > > +free_tdvpr:
> > > +	if (tdvpr_pa)
> > > +		free_page((unsigned long)__va(tdvpr_pa));
> > > +	tdx->tdvpr_pa = 0;
> > > +
> > > +	return ret;
> > > +}
> > 
> > Same comments with using vm_bugged in the previous patch.
> 
> I converted it to KVM_BUG_ON().


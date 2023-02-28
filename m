Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032CE6A5776
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 12:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjB1LGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 06:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjB1LGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 06:06:36 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7DA3ABE;
        Tue, 28 Feb 2023 03:06:35 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y2so9384305pjg.3;
        Tue, 28 Feb 2023 03:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bvm36jEtxsjOED1mtOtwojZpdWddplJxOZnpRXDzWDw=;
        b=KzzWos9fuGTDMCs6y0xH3HRrCE5mLcFihPrconwhq+QCcBC4pWDNKodtXXuJvvzyuR
         /LWzXNmC6wWCZOKGXeMRF+NylZAcuiR5+znWAGGobNx+KPsqCU1zaXWu3CYi1NxcNdYv
         NgT6hZQGmUk34EJG24vuNmkNTLZX5zQdFRdtkjzubWaSSRT7uyhF2xYjnl8C6ZC88YNv
         PeWvJCpEKjI0BYCvIjlmO9Ew4sRSCxBmn/lYTWlClN7vfHr15NQ6j6w7ZEn4utpjgjut
         vRpPgcXdswr5stowAP8MIy7yEn4pv5d1mi/rOExwx65D3Ml8u/7A9xvzRcc/olexf2mF
         4jVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bvm36jEtxsjOED1mtOtwojZpdWddplJxOZnpRXDzWDw=;
        b=xIomMJ06Ra5BEmjrREV30u50qDc2hL38r6IgT6rkgeHhz8j6bzIev2cg8xjHc7Etjj
         lgO+fDc6yMLFI/N0pFvBk0N9J/+uDQpxsWohzxXmsp8DaiuLUy8ECVgaqM+4PGpGdGYv
         mFE3Tgj9ul+QM3vJkbU51hcfR5DW781apVAsrLos+o+sblb/+AljNci1NzeOQfHLSFXc
         QFzZreqkK8l6B0y7gJSX3sBMYhJyaTNFmlnlD9dOTyQ7UMgCuBSVQQ2WBR9pjtOy152e
         AoI6Z9Tp3Cw/yjsJWVuji0fN+eUFNwKABpfS7bMbfPz7JYeDmx5g1tv1sTe1lV93pTKA
         KvBw==
X-Gm-Message-State: AO0yUKVITG7OXaqTu2mOZU0CnwcHuTd4QPtChVkJ+YWkQyko384E75CU
        1Y3CRU0fqU1hdP7BvCnUS+Y=
X-Google-Smtp-Source: AK7set/V0gZ4d5+d6LDbQquSz4/CAYQAR1LC0vZM7MFpb7GZho2ejiRNPXoDfVRuEC1RxYD7eVFmKg==
X-Received: by 2002:a17:90a:3e4f:b0:237:bf05:40b with SMTP id t15-20020a17090a3e4f00b00237bf05040bmr2814072pjm.20.1677582394314;
        Tue, 28 Feb 2023 03:06:34 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id x25-20020a63b219000000b00502ecc282e2sm5476821pge.5.2023.02.28.03.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:06:33 -0800 (PST)
Date:   Tue, 28 Feb 2023 03:06:32 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230228110632.GV4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
 <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 12:45:09AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:31 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
> > structures, partially initialize it.  
> > 
> 
> Why partially initialize it?  Shouldn't a better way be either: 1) not
> initialize at all, or; 2) fully initialize? 
> 
> Can you put more _why_ here?
> 
> 
> > Allocate pages of TDX vcpu for the
> > TDX module.  Actual donation TDX vcpu pages to the TDX module is not done
> > yet.
> 
> Also, can you explain _why_ it is not done here?
> 
> > 
> > In the case of the conventional case, cpuid is empty at the initialization.
> > and cpuid is configured after the vcpu initialization.  Because TDX
> > supports only X2APIC mode, cpuid is forcibly initialized to support X2APIC
> > on the vcpu initialization.
> 
> Don't quite understand here.  As you said CPUID entries are configured later in
> KVM_SET_CPUID2, so what's the point of initializing CPUID to support x2api> Are you suggesting KVM_SET_CPUID2 will be somehow rejected for TDX guest, or
> there will be special handling to make sure the CPUID initialized here won't be
> overwritten later?
> 
> Please explain clearly here.

Here is the updated one.

    The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
    structures, initialize it that doesn't require TDX SEAMCALL.  TDX specific
    vcpuid initialization will be implemented as independent KVM_TDX_INIT_VCPU
    so that when error occurs it's easy to determine which component has the
    issue, KVM or TDX.
    
    In the case of the conventional case, cpuid is empty at the initialization.
    and cpuid is configured after the vcpu initialization.  Because TDX
    supports only X2APIC mode, cpuid is forcibly set to support X2APIC and APIC
    BASE MSR is forcibly set to X2APIC mode.  The MSR will be read only for
    guest TD.  Because kvm_arch_vcpu_create() also initializes kvm MMU that
    depends on local apic settings.  So x2apic needs to be initialized to
    X2APIC mode by vcpu_reset method before KVM mmu initialization.



> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 557a609c5147..099f0737a5aa 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -281,6 +281,81 @@ int tdx_vm_init(struct kvm *kvm)
> >  	return 0;
> >  }
> >  
> > +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpuid_entry2 *e;
> > +
> > +	/*
> > +	 * On cpu creation, cpuid entry is blank.  Forcibly enable
> > +	 * X2APIC feature to allow X2APIC.
> > +	 * Because vcpu_reset() can't return error, allocation is done here.
> > +	 */
> > +	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
> > +	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
> > +	e = kvmalloc_array(1, sizeof(*e), GFP_KERNEL_ACCOUNT);
> 
> You don't need to use kvmalloc_array() when only allocating one entry.

I'll make it kvmalloc() and add comment on kvmalloc(), not kmalloc().


> > +	if (!e)
> > +		return -ENOMEM;
> > +	*e  = (struct kvm_cpuid_entry2) {
> > +		.function = 1,	/* Features for X2APIC */
> > +		.index = 0,
> > +		.eax = 0,
> > +		.ebx = 0,
> > +		.ecx = 1ULL << 21,	/* X2APIC */
> > +		.edx = 0,
> > +	};
> > +	vcpu->arch.cpuid_entries = e;
> > +	vcpu->arch.cpuid_nent = 1;
> 
> As mentioned above, why doing it here? Won't be this be overwritten later in
> KVM_SET_CPUID2?

Yes, user space VMM can overwrite cpuid[0x1] and APIC base MSR.  But it doesn't
matter because it's a bug of user space VMM. user space VMM has to keep the
consistency of cpuid and MSRs.
Because TDX module virtualizes cpuid[0x1].x2apic to fixed 1, KVM value doesn't
matter after vcpu creation.
Because KVM virtualizes APIC base as read only to guest, cpuid[0x1].x2apic
doesn't matter after vcpu creation as long as user space VMM keeps KVM APIC BASE
value.

I'll add a comment.


> > +
> > +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> > +	if (!vcpu->arch.apic)
> > +		return -EINVAL;
> 
> If this is hit, what happens to the CPUID entry allocated above?  It's
> absolutely not clear here in this patch.

It's memory leak. I'll move the check before memory allocation.


> > +
> > +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> > +
> > +	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> > +
> > +	vcpu->arch.cr0_guest_owned_bits = -1ul;
> > +	vcpu->arch.cr4_guest_owned_bits = -1ul;
> > +
> > +	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
> > +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> > +	vcpu->arch.guest_state_protected =
> > +		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
> > +
> > +	return 0;
> > +}
> > +
> > +void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> > +{
> > +	/* This is stub for now.  More logic will come. */
> > +}
> > +
> > +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > +{
> > +	struct msr_data apic_base_msr;
> > +
> > +	/* TDX doesn't support INIT event. */
> > +	if (WARN_ON_ONCE(init_event))
> > +		goto td_bugged;
> 
> Should we use KVM_BUG_ON()?
>
> Again, it appears this depends on how KVM handles INIT, which is done in a later
> patch far way:
> 
> [PATCH v11 102/113] KVM: TDX: Silently ignore INIT/SIPI
> 
> And there's no material explaining how it is handled in either changelog or
> comment, so to me it's not reviewable.

I'll convert them to KVM_BUG_ON().  With this patch, I'll remove WARN_ON_ONCE()
and add KVM_BUG_ON() with the later patch.


> > +
> > +	/* TDX rquires X2APIC. */
> > +	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
> > +	if (kvm_vcpu_is_reset_bsp(vcpu))
> > +		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
> > +	apic_base_msr.host_initiated = true;
> > +	if (WARN_ON_ONCE(kvm_set_apic_base(vcpu, &apic_base_msr)))
> > +		goto td_bugged;
> 
> I think we have KVM_BUG_ON()?
> 
> TDX requires a lot more staff then just x2apic, why only x2apic is done here,
> particularly in _this_ patch?

After this callback, kvm mmu initialization follows.  It depends on apic
setting.  X2APIC is only devication from the common logic kvm_lapic_reset().
I'll add a comment.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

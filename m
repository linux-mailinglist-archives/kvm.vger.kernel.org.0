Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E75664E20E
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 20:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiLOT7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 14:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLOT7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 14:59:16 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DD853ED9;
        Thu, 15 Dec 2022 11:59:13 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x2so65120plb.13;
        Thu, 15 Dec 2022 11:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9SPkdwUMkUMdWGv7jHpNwzrs36+96TUyHuEWVYgx9uM=;
        b=qex6xAxuFNacceHB7AD/PRB6BQ7skqj8Y1BLaEfGvsiHjRAiswLDmLhSAUF54rFiAx
         c9aNbbEg7jUBjm33b1gMFikCS/QpdeCFiOhkg3gduFy+Zta0Q94mc9Ve67RAQW3dkYTS
         iKrwWpKjINkqdjyjs+p6zcFN4BVOaDv5nDuW8KY++og6+VMohSeWknMabJYbDWPK7qi/
         N/wu3YSarlOxKlEpWu3kWnK+eUrQ7Bng3qAYc/rpIm3b/d1cFWDmUL23szPZrcBU8gpP
         KtOs00u1Id83IC4zh5kXf97lzc2/0Qqv2IcsjcWE9s+v6GIJj5/VHh6e535g6PJx7RoG
         4djg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SPkdwUMkUMdWGv7jHpNwzrs36+96TUyHuEWVYgx9uM=;
        b=p9Rlcn23/aOFU3TL2D92ZnoAB0D9tm5FZdLEJo+EZyjovRHlf/7BELQ7MdWycZZa7t
         mHr9gYSfIrPPR0iI6DBeaRCpyXaMwnKwf0yElEmUZte+4MtxZyXWPTCXPTeefCulROU9
         YUcr7HcNmfWD2V8fg5BdCWoNE5ZQ7y0S1i8FVKa12UWGRzgSUc8fab81MPA8o/S++qfL
         sDYDBtNXMcVQWuMb0j4zFJQUfCgoNWs/bOk3xE1P7EhNwymKkpqnV3cnFhyj7zsnoEJ2
         oygpjltpD1uOXkF1ADQcQfHDDB1YZRs+d6Zk+hCJrbjouaBJW9FrowV3314o39547Ncy
         NZgg==
X-Gm-Message-State: ANoB5pmPXlL551ySGFwmSotTn5T+KkDaoSLYQ3T2eJiHYWNlj3JwIkdp
        MEff5qb1G7dZCj7HXVeSZ1H9HEn2bDA=
X-Google-Smtp-Source: AA0mqf407NQrbHsOmEswkC+Jm+pcS9i4374mrBi61ELezlnOvmXNY+H8WPSeEqEDQoVm1YgLEU0x2A==
X-Received: by 2002:a17:902:e194:b0:189:aab9:cd80 with SMTP id y20-20020a170902e19400b00189aab9cd80mr25803593pla.64.1671134353252;
        Thu, 15 Dec 2022 11:59:13 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d2c900b00176b84eb29asm2788plc.301.2022.12.15.11.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 11:59:12 -0800 (PST)
Date:   Thu, 15 Dec 2022 11:59:11 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
Message-ID: <20221215195911.GE3632095@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
 <20221123123659.0000593c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221123123659.0000593c@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 12:36:59PM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Sat, 29 Oct 2022 23:22:17 -0700
> isaku.yamahata@intel.com wrote:
> 
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > As the first step to create TDX guest, create/destroy VM struct.
> > Assign TDX private Host Key ID (HKID) to the TDX guest for memory
> > encryption and allocate extra pages for the TDX guest. On
> > destruction, free allocated pages, and HKID.
> > 
> > Before tearing down private page tables, TDX requires some resources
> > of the guest TD to be destroyed (i.e. keyID must have been reclaimed,
> > etc).  Add flush_shadow_all_private callback before tearing down
> > private page tables for it.
> > 
> > Add a second kvm_x86_ops hook in kvm_arch_destroy_vm() to support
> > TDX's destruction path, which needs to first put the VM into a
> > teardown state, then free per-vCPU resources, and finally free per-VM
> > resources.
> > 
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm-x86-ops.h |   2 +
> >  arch/x86/include/asm/kvm_host.h    |   2 +
> >  arch/x86/kvm/vmx/main.c            |  34 ++-
> >  arch/x86/kvm/vmx/tdx.c             | 411
> > +++++++++++++++++++++++++++++ arch/x86/kvm/vmx/tdx.h             |
> > 2 + arch/x86/kvm/vmx/x86_ops.h         |  11 +
> >  arch/x86/kvm/x86.c                 |   8 +
> >  7 files changed, 467 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h
> > b/arch/x86/include/asm/kvm-x86-ops.h index 8a5c5ae70bc5..3a29a6b31ee8
> > 100644 --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -21,7 +21,9 @@ KVM_X86_OP(has_emulated_msr)
> >  KVM_X86_OP(vcpu_after_set_cpuid)
> >  KVM_X86_OP(is_vm_type_supported)
> >  KVM_X86_OP(vm_init)
> > +KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
> >  KVM_X86_OP_OPTIONAL(vm_destroy)
> > +KVM_X86_OP_OPTIONAL(vm_free)
> >  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> >  KVM_X86_OP(vcpu_create)
> >  KVM_X86_OP(vcpu_free)
> > diff --git a/arch/x86/include/asm/kvm_host.h
> > b/arch/x86/include/asm/kvm_host.h index 2a41a93a80f3..2870155ce6fb
> > 100644 --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1472,7 +1472,9 @@ struct kvm_x86_ops {
> >  	bool (*is_vm_type_supported)(unsigned long vm_type);
> >  	unsigned int vm_size;
> >  	int (*vm_init)(struct kvm *kvm);
> > +	void (*flush_shadow_all_private)(struct kvm *kvm);
> >  	void (*vm_destroy)(struct kvm *kvm);
> > +	void (*vm_free)(struct kvm *kvm);
> >  
> >  	/* Create, but do not attach this VCPU */
> >  	int (*vcpu_precreate)(struct kvm *kvm);
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 0900ff2f2390..d01a946a18cf 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -29,18 +29,44 @@ static __init int vt_hardware_setup(void)
> >  	return 0;
> >  }
> >  
> > +static void vt_hardware_unsetup(void)
> > +{
> > +	tdx_hardware_unsetup();
> > +	vmx_hardware_unsetup();
> > +}
> > +
> >  static int vt_vm_init(struct kvm *kvm)
> >  {
> >  	if (is_td(kvm))
> > -		return -EOPNOTSUPP;	/* Not ready to create
> > guest TD yet. */
> > +		return tdx_vm_init(kvm);
> >  
> >  	return vmx_vm_init(kvm);
> >  }
> >  
> > +static void vt_flush_shadow_all_private(struct kvm *kvm)
> > +{
> > +	if (is_td(kvm))
> > +		return tdx_mmu_release_hkid(kvm);
> > +}
> > +
> > +static void vt_vm_destroy(struct kvm *kvm)
> > +{
> > +	if (is_td(kvm))
> > +		return;
> > +
> > +	vmx_vm_destroy(kvm);
> > +}
> > +
> > +static void vt_vm_free(struct kvm *kvm)
> > +{
> > +	if (is_td(kvm))
> > +		return tdx_vm_free(kvm);
> > +}
> > +
> >  struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.name = "kvm_intel",
> >  
> > -	.hardware_unsetup = vmx_hardware_unsetup,
> > +	.hardware_unsetup = vt_hardware_unsetup,
> >  	.check_processor_compatibility =
> > vmx_check_processor_compatibility, 
> >  	.hardware_enable = vmx_hardware_enable,
> > @@ -50,7 +76,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.is_vm_type_supported = vt_is_vm_type_supported,
> >  	.vm_size = sizeof(struct kvm_vmx),
> >  	.vm_init = vt_vm_init,
> > -	.vm_destroy = vmx_vm_destroy,
> > +	.flush_shadow_all_private = vt_flush_shadow_all_private,
> > +	.vm_destroy = vt_vm_destroy,
> > +	.vm_free = vt_vm_free,
> >  
> >  	.vcpu_precreate = vmx_vcpu_precreate,
> >  	.vcpu_create = vmx_vcpu_create,
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 530e72f85762..ec88dde0d300 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -32,6 +32,401 @@ struct tdx_capabilities {
> >  /* Capabilities of KVM + the TDX module. */
> >  static struct tdx_capabilities tdx_caps;
> >  
> > +/*
> > + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> > + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a
> > global lock
> > + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is
> > returned without
> > + * spinning or waiting due to a constraint on execution time.  It's
> > caller's
> > + * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use
> > this mutex
> > + * to avoid race in TDX module because the kernel knows better about
> > scheduling.
> > + */
> > +static DEFINE_MUTEX(tdx_lock);
> > +static struct mutex *tdx_mng_key_config_lock;
> > +
> > +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> > +{
> > +	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> > +}
> > +
> > +static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->tdr.added;
> > +}
> > +
> > +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> > +{
> > +	tdx_keyid_free(kvm_tdx->hkid);
> > +	kvm_tdx->hkid = -1;
> > +}
> > +
> > +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> > +{
> > +	return kvm_tdx->hkid > 0;
> > +}
> > +
> > +static void tdx_clear_page(unsigned long page)
> > +{
> > +	const void *zero_page = (const void *)
> > __va(page_to_phys(ZERO_PAGE(0)));
> > +	unsigned long i;
> > +
> > +	/*
> > +	 * Zeroing the page is only necessary for systems with
> > MKTME-i:
> > +	 * when re-assign one page from old keyid to a new keyid,
> > MOVDIR64B is
> > +	 * required to clear/write the page with new keyid to
> > prevent integrity
> > +	 * error when read on the page with new keyid.
> > +	 *
> > +	 * The cache line could be poisoned (even without MKTME-i),
> > clear the
> > +	 * poison bit.
> > +	 */
> > +	for (i = 0; i < PAGE_SIZE; i += 64)
> > +		movdir64b((void *)(page + i), zero_page);
> 
> In patch 11, the clflush is used on the movdir64b target. Should we
> also use the clflush here?
> 
> I suppose the clflush is to prevent the unexpected cacheline writeback
> after the movdir64b.

No, clflush doesn't work.  The cache with HKID set needs to be flushed and
(potential) poison needs to be cleared. In host OS/VMM, clflush flushes on cache
with HKID=0 (or HKID of MKTME). clflush doesn't clear poison.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

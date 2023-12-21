Return-Path: <kvm+bounces-4971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB0281AC88
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 03:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73DE9287093
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 02:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C054404;
	Thu, 21 Dec 2023 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hz2VW0RL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73594184C
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbdad99096fso462932276.2
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 18:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703124777; x=1703729577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qZL4eZ6u9CkNNM8zLim6V4IndhkBqKjZUwKwl+b+dig=;
        b=Hz2VW0RLT2wu1n6xcs1cm6UhLe1h8ll/pa54CAUjY09etFDQyvnmK7L9axYzKKVbCn
         FlTRemeJ0+MMRmnBbqk0azbkpFEqbCJaIpUGvDc7dMtZ8wsnNauVe8BbjLA+UGlNMchV
         lmclyOQ0363DR9+77iJFQh6RNapZL5IU3vA9pIXcJTfjrw4gstnQtDktoZX4y3NvOVVt
         DRwM175xWXPRk4QEOi74mNXThiFTfLBiNhQEH/AwXMob2Awms+3ZBk0lvGtOsCryJ/vc
         HaPyIESvw7JWjWOOpoqYcbNOzq9adQpkiKJI3acon+2kqXp00mgoWpTvkbvNzD0u59i2
         B/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703124777; x=1703729577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qZL4eZ6u9CkNNM8zLim6V4IndhkBqKjZUwKwl+b+dig=;
        b=dAdLTlfUpdx/dIjoqQKhSf2KwX9pnmAtqvUV+zRJFwEMNB8/OKq0M40QLlE1BLvalF
         Wrjxp7RlQt4a8vQFIMGYBr1qD9fch1zm7DCdCHPCfbg99vNNwDlWo+jRxH5J1Tym7sUA
         r0gQESwLhcXl525uS3dxa5Kqq5tpamTMSiowxL0eX06dUwTbdERc6ImG4U4K7RkwrLcB
         YgkQ9fMcvdm8G3KkZBC+/pmUT5Q6kzUZ/U+cQ+EN8nWX8Cohk9/J/C58aaD5YOJcmEzi
         sApBIbLoHvFme5BOuBmo3gnUsqRQYjzM+jPwU9u5CqJGRt2HhEtsgxvXkMsN12LMShSa
         OhMg==
X-Gm-Message-State: AOJu0Yyx5d98ii/VnXyWiIDHOqffiDpdjHgbOsu80s2jUWb0Vlf9KUlN
	WAwuKCmm5hNl9A0sHnzw7+Xe+gCQZiU=
X-Google-Smtp-Source: AGHT+IHZcmSZfB7sL8/DN2qPbVmszZ2Jby/ac3YVH1l0ZSD4QHL8Y190bGfTeBcn+OFXVpkLGzQYnrzycAs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:664d:0:b0:dbd:bf0f:6fff with SMTP id
 z13-20020a25664d000000b00dbdbf0f6fffmr260745ybm.1.1703124777494; Wed, 20 Dec
 2023 18:12:57 -0800 (PST)
Date: Wed, 20 Dec 2023 18:12:55 -0800
In-Reply-To: <ZYJOTLwreD+8l4gU@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214103520.7198-1-yan.y.zhao@intel.com> <BN9PR11MB5276BE04CBB6D07039086D658C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZXzx1zXfZ6GV9TgI@google.com> <ZYEbhadnn6+clzX9@yzhao56-desk.sh.intel.com> <ZYJOTLwreD+8l4gU@yzhao56-desk.sh.intel.com>
Message-ID: <ZYOfJ_QWG01aL8Hl@google.com>
Subject: Re: [RFC PATCH] KVM: Introduce KVM VIRTIO device
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "olvaffe@gmail.com" <olvaffe@gmail.com>, 
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Zhenyu Z Wang <zhenyu.z.wang@intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"wanpengli@tencent.com" <wanpengli@tencent.com>, "jmattson@google.com" <jmattson@google.com>, 
	"joro@8bytes.org" <joro@8bytes.org>, 
	"gurchetansingh@chromium.org" <gurchetansingh@chromium.org>, "kraxel@redhat.com" <kraxel@redhat.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 20, 2023, Yan Zhao wrote:
> On Tue, Dec 19, 2023 at 12:26:45PM +0800, Yan Zhao wrote:
> > On Mon, Dec 18, 2023 at 07:08:51AM -0800, Sean Christopherson wrote:
> > > > > Implementation Consideration
> > > > > ===
> > > > > There is a previous series [1] from google to serve the same purpose to
> > > > > let KVM be aware of virtio GPU's noncoherent DMA status. That series
> > > > > requires a new memslot flag, and special memslots in user space.
> > > > > 
> > > > > We don't choose to use memslot flag to request honoring guest memory
> > > > > type.
> > > > 
> > > > memslot flag has the potential to restrict the impact e.g. when using
> > > > clflush-before-read in migration?
> > > 
> > > Yep, exactly.  E.g. if KVM needs to ensure coherency when freeing memory back to
> > > the host kernel, then the memslot flag will allow for a much more targeted
> > > operation.
> > > 
> > > > Of course the implication is to honor guest type only for the selected slot
> > > > in KVM instead of applying to the entire guest memory as in previous series
> > > > (which selects this way because vmx_get_mt_mask() is in perf-critical path
> > > > hence not good to check memslot flag?)
> > > 
> > > Checking a memslot flag won't impact performance.  KVM already has the memslot
> > > when creating SPTEs, e.g. the sole caller of vmx_get_mt_mask(), make_spte(), has
> > > access to the memslot.
> > > 
> > > That isn't coincidental, KVM _must_ have the memslot to construct the SPTE, e.g.
> > > to retrieve the associated PFN, update write-tracking for shadow pages, etc.
> > > 
> > Hi Sean,
> > Do you prefer to introduce a memslot flag KVM_MEM_DMA or KVM_MEM_WC?
> > For KVM_MEM_DMA, KVM needs to
> > (a) search VMA for vma->vm_page_prot and convert it to page cache mode (with
> >     pgprot2cachemode()? ), or
> > (b) look up memtype of the PFN, by calling lookup_memtype(), similar to that in
> >     pat_pfn_immune_to_uc_mtrr().
> > 
> > But pgprot2cachemode() and lookup_memtype() are not exported by x86 code now.
> > 
> > For KVM_MEM_WC, it requires user to ensure the memory is actually mapped
> > to WC, right?
> > 
> > Then, vmx_get_mt_mask() just ignores guest PAT and programs host PAT as EPT type
> > for the special memslot only, as below.
> > Is this understanding correct?
> > 
> > static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > {
> >         if (is_mmio)                                                                           
> >                 return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;                          
> >                                                                                                
> >         if (gfn_in_dma_slot(vcpu->kvm, gfn)) {                                                 
> >                 u8 type = MTRR_TYPE_WRCOMB;                                      
> >                 //u8 type = pat_pfn_memtype(pfn);                                
> >                 return (type << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;       
> >         }                                                                                      
> >                                                                                                
> >         if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))                            
> >                 return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;         
> >                                                                                                
> >         if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {                                             
> >                 if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))               
> >                         return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;                      
> >                 else                                                                           
> >                         return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) | 
> >                                 VMX_EPT_IPAT_BIT;                                
> >         }                                                                        
> >                                                                                  
> >         return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
> > }
> > 
> > BTW, since the special memslot must be exposed to guest as virtio GPU BAR in
> > order to prevent other guest drivers from access, I wonder if it's better to
> > include some keyword like VIRTIO_GPU_BAR in memslot flag name.
> Another choice is to add a memslot flag KVM_MEM_HONOR_GUEST_PAT, then user
> (e.g. QEMU) does special treatment to this kind of memslots (e.g. skipping
> reading/writing to them in general paths).
> 
> @@ -7589,26 +7589,29 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>         if (is_mmio)
>                 return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> 
> +       if (in_slot_honor_guest_pat(vcpu->kvm, gfn))
> +               return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;

This is more along the lines of what I was thinking, though the name should be
something like KVM_MEM_NON_COHERENT_DMA, i.e. not x86 specific and not contradictory
for AMD (which already honors guest PAT).

I also vote to deliberately ignore MTRRs, i.e. start us on the path of ripping
those out.  This is a new feature, so we have the luxury of defining KVM's ABI
for that feature, i.e. can state that on x86 it honors guest PAT, but not MTRRs.

Like so?

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d21f55f323ea..ed527acb2bd3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7575,7 +7575,8 @@ static int vmx_vm_init(struct kvm *kvm)
        return 0;
 }
 
-static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio,
+                         struct kvm_memory_slot *slot)
 {
        /* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
         * memory aliases with conflicting memory types and sometimes MCEs.
@@ -7598,6 +7599,9 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
        if (is_mmio)
                return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
 
+       if (kvm_memslot_has_non_coherent_dma(slot))
+               return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+
        if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
                return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

I like the idea of pulling the memtype from the host, but if we can make that
work then I don't see the need for a special memslot flag, i.e. just do it for
*all* SPTEs on VMX.  I don't think we need a VMA for that, e.g. we should be able
to get the memtype from the host PTEs, just like we do the page size.

KVM_MEM_WC is a hard "no" for me.  It's far too x86 centric, and as you alluded
to, it requires coordination from the guest, i.e. is effectively limited to
paravirt scenarios.

> +
>         if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
>                 return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> 
>         if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
>                 if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>                         return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
>                 else
>                         return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) |
>                                 VMX_EPT_IPAT_BIT;
>         }
> 
>         return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
>  }


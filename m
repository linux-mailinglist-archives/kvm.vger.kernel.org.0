Return-Path: <kvm+bounces-17489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B444F8C6F6E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03C1C28252A
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 195A2A59;
	Thu, 16 May 2024 00:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ivNUOV3C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F8017C;
	Thu, 16 May 2024 00:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715818534; cv=none; b=Jxjbyucd40WLJaTEZQ8UD+TOjj4yaBeELAHNrw89EoCI/uJ2a6RzgCgVilqHXalHddgZ4q/+YS/GnH09yRVg8urmAGYSnYA4iJl8VsgSFZTeB9lUd+hLuvl23eim2nGEbLG/Kar8wzRVIOWWVoxSCdygM6xLZQF3w3mwxCeI1Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715818534; c=relaxed/simple;
	bh=CbbtpWNEhDYP2JuFVm4WYWW5TJbGoKiTw0/Gn300tRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wp8jHayNMw+sNhmzTeZ7yvAXh2WbPEXOPiRA94EYiBye6usxSUFRmDSFjBSgGP5eYl6mzbu6qNvw+V6+8t5XYIgWKqQGrzRWPGipNcFsiPD1pS8Cs4r02xmPEQJ/ea0RpCux3iNmLMcv1WXBDPyc/mhCYTkyjIVsqznDiwbDyBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ivNUOV3C; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715818533; x=1747354533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CbbtpWNEhDYP2JuFVm4WYWW5TJbGoKiTw0/Gn300tRA=;
  b=ivNUOV3CmunianLC7YEIq797dGkmvnFnGnJu0016qqGTT490B7Jjaa1Z
   8AEulxcME+MGeaDipSLCxgEiGVxSvGyI7Dy6pAcTZdEyyWXiEPn5RL0I5
   6BUPNZk2pg/bp7LhDopY9JOOST35InYtyoODBLNWg8+PuDnmTVlrVQgZn
   9Kklp84vj28FxiFeUF2DrWUXZuGlC/LAK9rGgeoq2ygdPCBTE0yldfY8D
   IjQ3fwKcZwTuQPZ3rv6CuMReDLKvaewNEdqHrRbVQY1nnv5CGynBXb2s8
   Jqx9NxxLAPDqtFtXgid96b5wRYyKli+BuZqbWI+Su//mimUdI61CzWjDL
   A==;
X-CSE-ConnectionGUID: 25NWFQq3ThCG+qbasT6WLg==
X-CSE-MsgGUID: iSvLJnAcTASqv+hfbCMzaQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12024567"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="12024567"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:15:33 -0700
X-CSE-ConnectionGUID: RO/37sHURWK1j5vNhlS/KQ==
X-CSE-MsgGUID: YH5Ks6qSRA+cKrysZEVVSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31241602"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:15:31 -0700
Date: Wed, 15 May 2024 17:15:30 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, erdemaktas@google.com, sagis@google.com,
	yan.y.zhao@intel.com, dmatlack@google.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Message-ID: <20240516001530.GG168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <ZkTWDfuYD-ThdYe6@google.com>
 <20240515162240.GC168153@ls.amr.corp.intel.com>
 <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eab9201e-702e-46bc-9782-d6dfe3da2127@intel.com>

On Thu, May 16, 2024 at 10:17:50AM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On 16/05/2024 4:22 am, Isaku Yamahata wrote:
> > On Wed, May 15, 2024 at 08:34:37AM -0700,
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index d5cf5b15a10e..808805b3478d 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -6528,8 +6528,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> > > >   	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
> > > > -	if (tdp_mmu_enabled)
> > > > +	if (tdp_mmu_enabled) {
> > > > +		/*
> > > > +		 * kvm_zap_gfn_range() is used when MTRR or PAT memory
> > > > +		 * type was changed.  TDX can't handle zapping the private
> > > > +		 * mapping, but it's ok because KVM doesn't support either of
> > > > +		 * those features for TDX. In case a new caller appears, BUG
> > > > +		 * the VM if it's called for solutions with private aliases.
> > > > +		 */
> > > > +		KVM_BUG_ON(kvm_gfn_shared_mask(kvm), kvm);
> > > 
> > > Please stop using kvm_gfn_shared_mask() as a proxy for "is this TDX".  Using a
> > > generic name quite obviously doesn't prevent TDX details for bleeding into common
> > > code, and dancing around things just makes it all unnecessarily confusing.
> > > 
> > > If we can't avoid bleeding TDX details into common code, my vote is to bite the
> > > bullet and simply check vm_type.
> > 
> > TDX has several aspects related to the TDP MMU.
> > 1) Based on the faulting GPA, determine which KVM page table to walk.
> >     (private-vs-shared)
> > 2) Need to call TDX SEAMCALL to operate on Secure-EPT instead of direct memory
> >     load/store.  TDP MMU needs hooks for it.
> > 3) The tables must be zapped from the leaf. not the root or the middle.
> > 
> > For 1) and 2), what about something like this?  TDX backend code will set
> > kvm->arch.has_mirrored_pt = true; I think we will use kvm_gfn_shared_mask() only
> > for address conversion (shared<->private).
> > 
> > For 1), maybe we can add struct kvm_page_fault.walk_mirrored_pt
> >          (or whatever preferable name)?
> > 
> > For 3), flag of memslot handles it.
> > 
> > ---
> >   arch/x86/include/asm/kvm_host.h | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index aabf1648a56a..218b575d24bd 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1289,6 +1289,7 @@ struct kvm_arch {
> >   	u8 vm_type;
> >   	bool has_private_mem;
> >   	bool has_protected_state;
> > +	bool has_mirrored_pt;
> >   	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> >   	struct list_head active_mmu_pages;
> >   	struct list_head zapped_obsolete_pages;
> > @@ -2171,8 +2172,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >   #ifdef CONFIG_KVM_PRIVATE_MEM
> >   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> > +#define kvm_arch_has_mirrored_pt(kvm) ((kvm)->arch.has_mirrored_pt)
> >   #else
> >   #define kvm_arch_has_private_mem(kvm) false
> > +#define kvm_arch_has_mirrored_pt(kvm) false
> >   #endif
> >   static inline u16 kvm_read_ldt(void)
> 
> I think this 'has_mirrored_pt' (or a better name) is better, because it
> clearly conveys it is for the "page table", but not the actual page that any
> page table entry maps to.
> 
> AFAICT we need to split the concept of "private page table itself" and the
> "memory type of the actual GFN".
> 
> E.g., both SEV-SNP and TDX has concept of "private memory" (obviously), but
> I was told only TDX uses a dedicated private page table which isn't directly
> accessible for KVV.  SEV-SNP on the other hand just uses normal page table +
> additional HW managed table to make sure the security.

kvm_mmu_page_role.is_private is not good name now. Probably is_mirrored_pt or
need_callback or whatever makes sense.


> In other words, I think we should decide whether to invoke TDP MMU callback
> for private mapping (the page table itself may just be normal one) depending
> on the fault->is_private, but not whether the page table is private:
> 
> 	if (fault->is_private && kvm_x86_ops->set_private_spte)
> 		kvm_x86_set_private_spte(...);
> 	else
> 		tdp_mmu_set_spte_atomic(...);

This doesn't work for two reasons.

- We need to pass down struct kvm_page_fault fault deep only for this.
  We could change the code in such way.

- We don't have struct kvm_page_fault fault for zapping case.
  We could create a dummy one and pass it around.
  
Essentially the issue is how to pass down is_private or stash the info
somewhere or determine it somehow.  Options I think of are

- Pass around fault:
  Con: fault isn't passed down 
  Con: Create fake fault for zapping case

- Stash it in struct tdp_iter and pass around iter:
  Pro: work for zapping case
  Con: we need to change the code to pass down tdp_iter

- Pass around is_private (or mirrored_pt or whatever):
  Pro: Don't need to add member to some structure
  Con: We need to pass it around still.

- Stash it in kvm_mmu_page:
  The patch series uses kvm_mmu_page.role.
  Pro: We don't need to pass around because we know struct kvm_mmu_page
  Con: Need to twist root page allocation

- Use gfn. kvm_is_private_gfn(kvm, gfn):
  Con: The use of gfn is confusing.  It's too TDX specific.


> And the 'has_mirrored_pt' should be only used to select the root of the page
> table that we want to operate on.

We can add one more bool to struct kvm_page_fault.follow_mirrored_pt or
something to represent it.  We can initialize it in __kvm_mmu_do_page_fault().

.follow_mirrored_pt = kvm->arch.has_mirrored_pt && kvm_is_private_gpa(gpa);


> This also gives a chance that if there's anything special needs to be done
> for page allocated for the "non-leaf" middle page table for SEV-SNP, it can
> just fit.

Can you please elaborate on this?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>


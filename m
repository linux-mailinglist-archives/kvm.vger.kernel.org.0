Return-Path: <kvm+bounces-26777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D98E97765E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 03:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E37A1C23B46
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 01:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF364C6C;
	Fri, 13 Sep 2024 01:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hbinJR/c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EC6A59;
	Fri, 13 Sep 2024 01:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726190536; cv=none; b=M8chQXBwCBnML066o4+zof63IbLmtQDaVdCE+SrwSQPtjUEuwdL3bEKuf7hufGu5WFhPVudKWhxsnSOa2PQb8MBKS/rbMLfY1d66a5OigVNWATKPF6EpdL4BfH6E/aBU4iT9/Ppx8j4ewZ8JOc/ZZtD/TlGiuIDODcZ+qKHlils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726190536; c=relaxed/simple;
	bh=yRH5tf+ZvOsKwZDNQrzD6xeTVcBtRzuN9s8qBocLsOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZpP3QtJeGefNekcMVBX6dBsDoS6zb8ICANbCwsMqzzC062ldIjIvS98nyerM2G3quSJhdS7SBWVGnPgfVyNBkM+BNfWPjvzLtceFXXhCJ/ABcsjQ1J0fNBlWwLa6+spkrV6lwQ4uCUrNwdk9rNji6EINAhdcgw1iG871sZmbX9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hbinJR/c; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726190534; x=1757726534;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yRH5tf+ZvOsKwZDNQrzD6xeTVcBtRzuN9s8qBocLsOo=;
  b=hbinJR/cxD9HUePfryVQeyp2MGMfnNSUU1rOHZozGOEq45hSX4gUK+Hr
   1jKewzUp38I1KJZXA63GzEVQpyHzxZghtnVI3kwYIyhWqI2AgJDq6md1b
   X1mkQsPMw4N2Es7qZBLMKNl/jGX+yCCQ7AmfW3cDM/tyzJbuxRIPt5AJI
   z8gHqN3mFGSrG+DT7NG2Lk6HrmX01kYyOw89IOyuChOFgLRDE09te6yQa
   PZx47cMFS5cJaOegg5wAYTTF2d7Hqr99GVXTggx4YiiwdYtJ2MHqCA3OU
   oyV5WmtMWcHxpFyPFeGVvyuYptWHNO2iPQjBkXLu8EVX8aMqLfAzmW+Wr
   w==;
X-CSE-ConnectionGUID: 69Nld+vcTlK4kW9mb/qCCg==
X-CSE-MsgGUID: e26Si0shSxaR+1GOZwpZ4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="47594688"
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="47594688"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 18:22:13 -0700
X-CSE-ConnectionGUID: 1w8QNgEPR/WPGAoBTa3jcg==
X-CSE-MsgGUID: tQllv47DS+CnnL7+3jsRfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="67982903"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 18:22:12 -0700
Date: Thu, 12 Sep 2024 18:22:12 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	sagis@google.com, chao.gao@intel.com, pbonzini@redhat.com,
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
Message-ID: <ZuOTxGa58QUy0qbI@ls.amr.corp.intel.com>
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuOCXarfAwPjYj19@google.com>

On Thu, Sep 12, 2024 at 05:07:57PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Sep 12, 2024, Isaku Yamahata wrote:
> > KVM MMU behavior
> > ================
> > The leaf SPTE state machine is coded in make_spte().  Consider AD bits and
> > the present bits for simplicity.  The two functionalities and AD bits
> > support are related in this context.  unsync (manipulate D bit and W bit,
> > and handle write protect fault) and access tracking (manipulate A bit and
> > present bit, and hand handle page fault).  (We don't consider dirty page
> > tracking for now as it's future work of TDX KVM.)
> > 
> > * If AD bit is enabled:
> > D bit state change for dirty page tracking
> > On the first EPT violation without prefetch,
> > - D bits are set.
> > - Make SPTE writable as TDX supports only RXW (or if write fault).
> >   (TDX KVM doesn't support write protection at this state. It's future work.)
> > 
> > On the second EPT violation.
> > - clear D bits if write fault.
> 
> Heh, I was literally just writing changelogs for patches to address this (I told
> Sagi I would do it "this week"; that was four weeks ago).
> 
> This is a bug in make_spte().  Replacing a W=1,D=1 SPTE with a W=1,D=0 SPTE is
> nonsensical.  And I'm pretty sure it's an outright but for the TDP MMU (see below).
> 
> Right now, the fixes for make_spte() are sitting toward the end of the massive
> kvm_follow_pfn() rework (80+ patches and counting), but despite the size, I am
> fairly confident that series can land in 6.13 (lots and lots of small patches).

Thanks for addressing this.


> ---
> Author:     Sean Christopherson <seanjc@google.com>
> AuthorDate: Thu Sep 12 16:23:21 2024 -0700
> Commit:     Sean Christopherson <seanjc@google.com>
> CommitDate: Thu Sep 12 16:35:06 2024 -0700
> 
>     KVM: x86/mmu: Flush TLBs if resolving a TDP MMU fault clears W or D bits
>     
>     Do a remote TLB flush if installing a leaf SPTE overwrites an existing
>     leaf SPTE (with the same target pfn) and clears the Writable bit or the
>     Dirty bit.  KVM isn't _supposed_ to clear Writable or Dirty bits in such
>     a scenario, but make_spte() has a flaw where it will fail to set the Dirty
>     if the existing SPTE is writable.
>     
>     E.g. if two vCPUs race to handle faults, the KVM will install a W=1,D=1
>     SPTE for the first vCPU, and then overwrite it with a W=1,D=0 SPTE for the
>     second vCPU.  If the first vCPU (or another vCPU) accesses memory using
>     the W=1,D=1 SPTE, i.e. creates a writable, dirty TLB entry, and that is
>     the only SPTE that is dirty at the time of the next relevant clearing of
>     the dirty logs, then clear_dirty_gfn_range() will not modify any SPTEs
>     because it sees the D=0 SPTE, and thus will complete the clearing of the
>     dirty logs without performing a TLB flush.
>     
>     Opportunistically harden the TDP MMU against clearing the Writable bit as
>     well, both to prevent similar bugs for write-protection, but also so that
>     the logic can eventually be deduplicated into spte.c (mmu_spte_update() in
>     the shadow MMU has similar logic).
>     
>     Fix the bug in the TDP MMU's page fault handler even though make_spte() is
>     clearly doing odd things, e.g. it marks the page dirty in its slot but
>     doesn't set the Dirty bit.  Precisely because replacing a leaf SPTE with
>     another leaf SPTE is so rare, the cost of hardening KVM against such bugs
>     is negligible.  The make_spte() will be addressed in a future commit.
>     
>     Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
>     Cc: David Matlack <dmatlack@google.com>
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3b996c1fdaab..7c6d1c610f0e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1038,7 +1038,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>         else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
>                 return RET_PF_RETRY;
>         else if (is_shadow_present_pte(iter->old_spte) &&
> -                !is_last_spte(iter->old_spte, iter->level))
> +                (!is_last_spte(iter->old_spte, iter->level) ||
> +                 (is_mmu_writable_spte(old_spte) && !is_writable_pte(new_spte)) ||
> +                 (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))))
>                 kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level);
>  
>         /*
> ---
> 
> >  arch/x86/kvm/mmu/spte.h    |  6 ++++++
> >  arch/x86/kvm/mmu/tdp_mmu.c | 28 +++++++++++++++++++++++++---
> >  2 files changed, 31 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index a72f0e3bde17..1726f8ec5a50 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -214,6 +214,12 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
> >   */
> >  #define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> >  
> > +#define EXTERNAL_SPTE_IGNORE_CHANGE_MASK		\
> > +	(shadow_acc_track_mask |			\
> > +	 (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<		\
> > +	  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) |		\
> 
> Just make TDX require A/D bits, there's no reason to care about access tracking.

Ok.


> > +	 shadow_dirty_mask | shadow_accessed_mask)
> > +
> >  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
> >  static_assert(!(FROZEN_SPTE & SPTE_MMU_PRESENT_MASK));
> >  
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 019b43723d90..cfb82ede8982 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -503,8 +503,6 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
> >  	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> >  	int ret = 0;
> >  
> > -	KVM_BUG_ON(was_present, kvm);
> > -
> >  	lockdep_assert_held(&kvm->mmu_lock);
> >  	/*
> >  	 * We need to lock out other updates to the SPTE until the external
> > @@ -519,10 +517,34 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
> >  	 * external page table, or leaf.
> >  	 */
> >  	if (is_leaf) {
> > -		ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
> > +		/*
> > +		 * SPTE is state machine with software available bits used.
> > +		 * Check if the change is interesting to the backend.
> > +		 */
> > +		if (!was_present)
> > +			ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
> > +		else {
> > +			/*
> > +			 * The external PTEs don't need updates for some bits,
> > +			 * but if others are changed, bug the VM.
> > +			 */
> > +			if (KVM_BUG_ON(~EXTERNAL_SPTE_IGNORE_CHANGE_MASK &
> 
> There's no reason to bug the VM.  WARN, yes (maybe), but not bug the VM.  And I
> think this should be short-circuited somewhere further up the chain, i.e. not
> just for TDX.
> 
> One idea would be to WARN and skip setting the SPTE in tdp_mmu_map_handle_target_level().
> I.e. WARN and ignore 1=>0 transitions for Writable and Dirty bits, and then drop
> the TLB flush (assuming the above patch lands).

Ok, let me give it a try.


> > +				       (old_spte ^ new_spte), kvm)) {
> 
> Curly braces are unnecessary.

Will fix.


> > +				ret = -EIO;
> > +			}
> > +		}
> > +
> > +		/*
> > +		 * The backend shouldn't return an error except EAGAIN.
> > +		 * It's hard to debug without those info.
> > +		 */
> > +		if (ret && ret != EAGAIN)
> > +			pr_debug("gfn 0x%llx old_spte 0x%llx new_spte 0x%llx level %d\n",
> > +				 gfn, old_spte, new_spte, level);
> 
> Please no.  Not in upstream.  Yeah, for development it's fine, but sprinkling
> printks all over the MMU eventually just results in stale printks, e.g. see all
> of the pgprintk crud that got ripped out a while back.

Ok, will remove it.


> >  	} else {
> >  		void *external_spt = get_external_spt(gfn, new_spte, level);
> >  
> > +		KVM_BUG_ON(was_present, kvm);
> >  		KVM_BUG_ON(!external_spt, kvm);
> >  		ret = static_call(kvm_x86_link_external_spt)(kvm, gfn, level, external_spt);
> >  	}
> > 
> > base-commit: d2c7662a6ea1c325a9ae878b3f1a265264bcd18b
> > -- 
> > 2.45.2
> > 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>


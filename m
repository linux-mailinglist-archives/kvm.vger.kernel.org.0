Return-Path: <kvm+bounces-13489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF1F4897841
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 20:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F6FFB3EFB3
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D84C152E19;
	Wed,  3 Apr 2024 18:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LOHQ4EFB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAA41C33;
	Wed,  3 Apr 2024 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167313; cv=none; b=N6C3ZFZ9ZDi723q4IWrkQsIRrQ3R8nsGBtbBCqJh7vy3K31+kWB/F/toF5C4zTbENO1v+kz1tRVxERJZvVHFx27E/XQWec20W6o/ZuuR7DwkIKW4cB21mGXWC1Q0PlX1m+GaaTPRvNHf1v0EZOw1DR6NvRU1IffNmxYvUBut/zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167313; c=relaxed/simple;
	bh=Oc8GUmQjJrBN3DiOeh6zjN29dpmqnQFaYQWjAS8Slys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xn5bpP85ukEvZAADV7U7Bbx/vNv85+HywyWH4QzBX8YLeNyrHJUYQDxEDLowggkH/qV88QvAKehGIJoqe0bLQ3/udoualg2ARKMoxIOz7MWF55N4HkqvOEWyKzKwXhtLq4FmG16t5juHzAq1UiujxKuv8/Kg6cpyM/HihVhUcxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LOHQ4EFB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712167311; x=1743703311;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Oc8GUmQjJrBN3DiOeh6zjN29dpmqnQFaYQWjAS8Slys=;
  b=LOHQ4EFBQ0IOm+SwK9Z6KOixGxGF+jDLDRyLWCXzMTe++Y0R//hnnF/R
   vPSc5nlivv9ql57kyAJ/OaaTo/sLKxPzhH0PND2ves3Rf+qpVDvR5+l2F
   fzK05df2DCk6Eu6L5Z3gOLB735tVhkCy2vowk2Z2SPVWdaH71d4lLzrnY
   qTMvpIo2+7fb0ry65npJwskrVjhigNwKKyWAbylCdAlyC20U4hFY/0Nja
   pIJVttxDoi8QEtG+5TAgZ6mM5SC20UtYtzViidXbNocBSNx9xMqMNbSDA
   sV19hBELXMZqFS4IDaTBUV2BP4ZOHOMsV/V67z4AFOzPyBFlua49mNSHe
   Q==;
X-CSE-ConnectionGUID: wKfWkHWNQqW46tlnLVYfKg==
X-CSE-MsgGUID: W3crFeKeSDSQA7mXqJXWAg==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7286304"
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="7286304"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 11:01:51 -0700
X-CSE-ConnectionGUID: /IzuR5vXQnW4MqoN+Vg50Q==
X-CSE-MsgGUID: PIZbA5RFSjuNddIh96E9zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="23002870"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 11:01:50 -0700
Date: Wed, 3 Apr 2024 11:01:49 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Message-ID: <20240403180149.GH2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
 <e10d121e-c813-47b0-849d-0dde92c4d49a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e10d121e-c813-47b0-849d-0dde92c4d49a@linux.intel.com>

On Tue, Apr 02, 2024 at 05:13:23PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Implement hooks of TDP MMU for TDX backend.  TLB flush, TLB shootdown,
> > propagating the change private EPT entry to Secure EPT and freeing Secure
> > EPT page. TLB flush handles both shared EPT and private EPT.  It flushes
> > shared EPT same as VMX.  It also waits for the TDX TLB shootdown.  For the
> > hook to free Secure EPT page, unlinks the Secure EPT page from the Secure
> > EPT so that the page can be freed to OS.
> > 
> > Propagate the entry change to Secure EPT.  The possible entry changes are
> > present -> non-present(zapping) and non-present -> present(population).  On
> > population just link the Secure EPT page or the private guest page to the
> > Secure EPT by TDX SEAMCALL. Because TDP MMU allows concurrent
> > zapping/population, zapping requires synchronous TLB shoot down with the
> > frozen EPT entry.  It zaps the secure entry, increments TLB counter, sends
> > IPI to remote vcpus to trigger TLB flush, and then unlinks the private
> > guest page from the Secure EPT. For simplicity, batched zapping with
> > exclude lock is handled as concurrent zapping.  Although it's inefficient,
> > it can be optimized in the future.
> > 
> > For MMIO SPTE, the spte value changes as follows.
> > initial value (suppress VE bit is set)
> > -> Guest issues MMIO and triggers EPT violation
> > -> KVM updates SPTE value to MMIO value (suppress VE bit is cleared)
> > -> Guest MMIO resumes.  It triggers VE exception in guest TD
> > -> Guest VE handler issues TDG.VP.VMCALL<MMIO>
> > -> KVM handles MMIO
> > -> Guest VE handler resumes its execution after MMIO instruction
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > v19:
> > - Compile fix when CONFIG_HYPERV != y.
> >    It's due to the following patch.  Catch it up.
> >    https://lore.kernel.org/all/20231018192325.1893896-1-seanjc@google.com/
> > - Add comments on tlb shootdown to explan the sequence.
> > - Use gmem_max_level callback, delete tdp_max_page_level.
> > 
> > v18:
> > - rename tdx_sept_page_aug() -> tdx_mem_page_aug()
> > - checkpatch: space => tab
> > 
> > v15 -> v16:
> > - Add the handling of TD_ATTR_SEPT_VE_DISABLE case.
> > 
> > v14 -> v15:
> > - Implemented tdx_flush_tlb_current()
> > - Removed unnecessary invept in tdx_flush_tlb().  It was carry over
> >    from the very old code base.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/mmu/spte.c    |   3 +-
> >   arch/x86/kvm/vmx/main.c    |  91 ++++++++-
> >   arch/x86/kvm/vmx/tdx.c     | 372 +++++++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/tdx.h     |   2 +-
> >   arch/x86/kvm/vmx/tdx_ops.h |   6 +
> >   arch/x86/kvm/vmx/x86_ops.h |  13 ++
> >   6 files changed, 481 insertions(+), 6 deletions(-)
> > 
> [...]
> 
> > +static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
> > +				      enum pg_level level)
> > +{
> > +	int tdx_level = pg_level_to_tdx_sept_level(level);
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
> > +	struct tdx_module_args out;
> > +	u64 err;
> > +
> > +	/* This can be called when destructing guest TD after freeing HKID. */
> > +	if (unlikely(!is_hkid_assigned(kvm_tdx)))
> > +		return 0;
> > +
> > +	/* For now large page isn't supported yet. */
> > +	WARN_ON_ONCE(level != PG_LEVEL_4K);
> > +	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
> > +	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> > +		return -EAGAIN;
> > +	if (KVM_BUG_ON(err, kvm)) {
> > +		pr_tdx_error(TDH_MEM_RANGE_BLOCK, err, &out);
> > +		return -EIO;
> > +	}
> > +	return 0;
> > +}
> > +
> > +/*
> > + * TLB shoot down procedure:
> > + * There is a global epoch counter and each vcpu has local epoch counter.
> > + * - TDH.MEM.RANGE.BLOCK(TDR. level, range) on one vcpu
> > + *   This blocks the subsequenct creation of TLB translation on that range.
> > + *   This corresponds to clear the present bit(all RXW) in EPT entry
> > + * - TDH.MEM.TRACK(TDR): advances the epoch counter which is global.
> > + * - IPI to remote vcpus
> > + * - TDExit and re-entry with TDH.VP.ENTER on remote vcpus
> > + * - On re-entry, TDX module compares the local epoch counter with the global
> > + *   epoch counter.  If the local epoch counter is older than the global epoch
> > + *   counter, update the local epoch counter and flushes TLB.
> > + */
> > +static void tdx_track(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	u64 err;
> > +
> > +	KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm);
> > +	/* If TD isn't finalized, it's before any vcpu running. */
> > +	if (unlikely(!is_td_finalized(kvm_tdx)))
> > +		return;
> > +
> > +	/*
> > +	 * tdx_flush_tlb() waits for this function to issue TDH.MEM.TRACK() by
> > +	 * the counter.  The counter is used instead of bool because multiple
> > +	 * TDH_MEM_TRACK() can be issued concurrently by multiple vcpus.
> 
> Which case will have concurrent issues of TDH_MEM_TRACK() by multiple vcpus?
> For now, zapping is holding write lock.
> Promotion/demotion may have concurrent issues of TDH_MEM_TRACK(), but it's
> not supported yet.

You're right. Large page support will use it.  With the assumption of only
single vcpu issuing tlb flush, The alternative is boolean + memory barrier.
I prefer to keep atomic_t and drop this comment than boolean + memory barrier
because we will eventually switch to atomic_t.


> > +	 *
> > +	 * optimization: The TLB shoot down procedure described in The TDX
> > +	 * specification is, TDH.MEM.TRACK(), send IPI to remote vcpus, confirm
> > +	 * all remote vcpus exit to VMM, and execute vcpu, both local and
> > +	 * remote.  Twist the sequence to reduce IPI overhead as follows.
> > +	 *
> > +	 * local			remote
> > +	 * -----			------
> > +	 * increment tdh_mem_track
> > +	 *
> > +	 * request KVM_REQ_TLB_FLUSH
> > +	 * send IPI
> > +	 *
> > +	 *				TDEXIT to KVM due to IPI
> > +	 *
> > +	 *				IPI handler calls tdx_flush_tlb()
> > +	 *                              to process KVM_REQ_TLB_FLUSH.
> > +	 *				spin wait for tdh_mem_track == 0
> > +	 *
> > +	 * TDH.MEM.TRACK()
> > +	 *
> > +	 * decrement tdh_mem_track
> > +	 *
> > +	 *				complete KVM_REQ_TLB_FLUSH
> > +	 *
> > +	 * TDH.VP.ENTER to flush tlbs	TDH.VP.ENTER to flush tlbs
> > +	 */
> > +	atomic_inc(&kvm_tdx->tdh_mem_track);
> > +	/*
> > +	 * KVM_REQ_TLB_FLUSH waits for the empty IPI handler, ack_flush(), with
> > +	 * KVM_REQUEST_WAIT.
> > +	 */
> > +	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
> > +
> > +	do {
> > +		err = tdh_mem_track(kvm_tdx->tdr_pa);
> > +	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
> > +
> > +	/* Release remote vcpu waiting for TDH.MEM.TRACK in tdx_flush_tlb(). */
> > +	atomic_dec(&kvm_tdx->tdh_mem_track);
> > +
> > +	if (KVM_BUG_ON(err, kvm))
> > +		pr_tdx_error(TDH_MEM_TRACK, err, NULL);
> > +
> > +}
> > +
> > +static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
> > +				     enum pg_level level, void *private_spt)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +
> > +	/*
> > +	 * The HKID assigned to this TD was already freed and cache was
> > +	 * already flushed. We don't have to flush again.
> > +	 */
> > +	if (!is_hkid_assigned(kvm_tdx))
> > +		return tdx_reclaim_page(__pa(private_spt));
> > +
> > +	/*
> > +	 * free_private_spt() is (obviously) called when a shadow page is being
> > +	 * zapped.  KVM doesn't (yet) zap private SPs while the TD is active.
> > +	 * Note: This function is for private shadow page.  Not for private
> > +	 * guest page.   private guest page can be zapped during TD is active.
> > +	 * shared <-> private conversion and slot move/deletion.
> > +	 */
> > +	KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm);
> 
> At this point, is_hkid_assigned(kvm_tdx) is always true.

Yes, will drop this KVM_BUG_ON().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>


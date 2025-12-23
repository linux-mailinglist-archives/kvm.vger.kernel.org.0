Return-Path: <kvm+bounces-66630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D36D1CDAD71
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:35:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F07F302C219
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA392F12CE;
	Tue, 23 Dec 2025 23:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uhbKu6l1"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E092728A1E6
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766532942; cv=none; b=GexfCikVX1biVMrO37+x4HXMV1U1Pk777G9ghK59VFwUk1rJKgihpblXH0TKKGvwfpnGoNRNNDtRXX1qaSqqqzeZH+U/x60NMcEKaj0suhuAI5xXffKRPbMjG82GgIO2HJEra/dAsDDQB67GEJGDkdW0waP0b0aE+IPDHjFDo1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766532942; c=relaxed/simple;
	bh=bOVxG0m8Dr7cYNi8Hi7H1zNdhkCoLWggjhszEljz7Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0uL5zATN/stVUE45yA6GAYUiYfm3mDMPpt3XgujB/ISTG4XjzE8bXN6HDM1S2pxQnoDpkNBiPof2/nYWFf9aH5MFT1plxm3km9AZYzdii9My++le2LE1MJJxO1GhtFJD7FjKNZkWcYe7REbyVGLMJ/maijxfmMewv7/8rTecSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uhbKu6l1; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 23 Dec 2025 23:35:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766532928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YAjQNoKhWASKDLQMVIwMZYAn3cDQY8mz2aRNJp62Bc0=;
	b=uhbKu6l1UZBCLiJ1Aobp4UNiblT4tI5t5YRMmSdhxfGzxEB3vbfJcnI0cmfFnnUS3M5KUE
	dmqnefNF4Eb5vRbqnmyrW+u2O19o3YRcUkUB11+1Sp6SpBV6OyZhBb6GXIPmy28JGE1bQP
	RmMdCvcVteO7mwu03Gy2GCKZO0dDWmI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/16] KVM: selftests: Stop setting AD bits on nested
 EPTs on creation
Message-ID: <xjyrcutcnv2vrctv2zl5unn5bxn266kab72rfog4o43ox5vrax@xk7tip2az3ru>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-6-yosry.ahmed@linux.dev>
 <aUsXDKeYorxt7VMM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUsXDKeYorxt7VMM@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 23, 2025 at 02:26:20PM -0800, Sean Christopherson wrote:
> On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > When new nested EPTs are created, the AD bits are set. This was
> > introduced by commit 094444204570 ("selftests: kvm: add test for dirty
> > logging inside nested guests"), which introduced vmx_dirty_log_test.
> > 
> > It's unclear why that was needed at the time, but regardless, the test
> > seems to pass without them so probably no longer needed.
> > dirty_log_perf_test (with -n to run in L2) also passes, and these are
> > the only tests currently using nested EPT mappings.
> 
> Please, please don't take the approach of "beat on it until it passes".  Yes,
> Paolo's changelog and comment from 094444204570 are awful, and yes, figuring out
> what Paolo _likely_ intended requires a lot of guesswork and esoteric shadow MMU
> knowledge, but _at best_, modifying code without having at least a plausible
> explanation only adds to the confusion, and at worst is actively dangerous.
> 
> As you've discovered a few times now, there is plenty of code in KVM and its
> tests that elicit a WTF?!!? response from pretty much everyone, i.e. odds are
> good you'll run into something along these lines again, sooner or later.  If/when
> that happens, and you can't unravel the mystery, please send a mail with a question
> instead of sending a patch that papers over the issue.  E.g. casting "raise dead"
> on the original thread is totally acceptable (and probably even encouraged).
> That _might_ be a slower and/or more painful approach, but it's generally safer,
> e.g. it's all too easy for a maintainer to speed read and apply a seemingly
> uninteresting patch like this.

That's fair, I am used to sending a patch that potentially does the
wrong thing than a question, because people tend to be more responsive
to wrong patches :) 

That being said, I should have made this much more obvious, like add RFC
or DO NOT MERGE to the patch title, rather than subtly burying it in the
commit log.

> 
> In this case, I strongly suspect that what Paolo was _trying_ to do was coerce
> KVM into creating a writable SPTE in response to the initial READ.  I.e. in the
> vmx_dirty_log_test's L2 code, setting the Dirty bit in the guest stage-2 PTE is
> necessary to get KVM to install a writable SPTE on the READ_ONCE():
> 
>   static void l2_guest_code(u64 *a, u64 *b)
>   {
> 	READ_ONCE(*a);
> 	WRITE_ONCE(*a, 1);
> 	GUEST_SYNC(true);
> 	GUEST_SYNC(false);
>  
> 	...
>   }
> 
> When handling a read fault in FNAME(walk_addr_generic)(), KVM adjusts the guest
> PTE access protections via FNAME(protect_clean_gpte):
> 
> 	if (!write_fault)
> 		FNAME(protect_clean_gpte)(mmu, &walker->pte_access, pte);
> 	else
> 		/*
> 		 * On a write fault, fold the dirty bit into accessed_dirty.
> 		 * For modes without A/D bits support accessed_dirty will be
> 		 * always clear.
> 		 */
> 		accessed_dirty &= pte >>
> 			(PT_GUEST_DIRTY_SHIFT - PT_GUEST_ACCESSED_SHIFT);
> 
> 
> where FNAME(protect_clean_gpte) is:
> 
> 	unsigned mask;
> 
> 	/* dirty bit is not supported, so no need to track it */
> 	if (!PT_HAVE_ACCESSED_DIRTY(mmu))
> 		return;
> 
> 	BUILD_BUG_ON(PT_WRITABLE_MASK != ACC_WRITE_MASK);
> 
> 	mask = (unsigned)~ACC_WRITE_MASK;
> 	/* Allow write access to dirty gptes */
> 	mask |= (gpte >> (PT_GUEST_DIRTY_SHIFT - PT_WRITABLE_SHIFT)) &
> 		PT_WRITABLE_MASK;
> 	*access &= mask;
> 
> The idea is that KVM can elide a VM-Exit on a READ=>WRITE sequence by making the
> SPTE writable on the READ fault if the guest PTEs allow the page to be written.
> But KVM can only do that if the guest Dirty bit is '1'; if the Dirty bit is '0',
> then KVM needs to intercept the next write in order to emulate the Dirty assist.
> 
> I emphasized "trying" above because, in the context of the dirty logging test,
> simply establishing a writable SPTE on the READ_ONCE() doesn't meaningfully improve
> coverage without checking KVM's behavior after the READ_ONCE().  E.g. KVM marks
> GFNs as dirty (in the dirty bitmap) when creating writable SPTEs, and so doing
> READ+WRITE and _then_ checking the dirty bitmap would hide the KVM PML bug that
> the test was written to find.
> 
> The second part of the L2 guest code:
> 
> 	WRITE_ONCE(*b, 1);
> 	GUEST_SYNC(true);
> 	WRITE_ONCE(*b, 1);
> 	GUEST_SYNC(true);
> 	GUEST_SYNC(false);
> 
> _does_ trigger and detect the KVM bug, but with a WRITE=>CHECK=>WRITE=>CHECK
> sequence instead of READ=>CHECK=>WRITE=>CHECK.  I.e. even if there was a false
> pass in the first phase, as written the second phase will detect the bug,
> assuming the bug affects WRITE=>WRITE and READ=>WRITE equally.  Which isn't a
> great assumption, but it was the case for the PML bug.
> 
> All that said, for this patch, I think it makes sense to drop the A/D code from
> the common APIs, because (a) it will be trivially easy to have the test set them
> as needed once the common APIs are used for TDP mappings, and (b) temporarily
> dropping the code doesn't affect the test coverage in practice.

Thanks a lot for digging and finding all of this. I agree that it's
better to add the coverage properly on top of the series, and have
a separate test case for initializing the PTEs with the dirty bit for
KVM to create a writeable PTE on READ.

> 
> --
> Stop setting Accessed/Dirty bits when creating EPT entries for L2 so that
> the stage-1 and stage-2 (a.k.a. TDP) page table APIs can use common code
> without bleeding the EPT hack into the common APIs.
> 
> While commit 094444204570 ("selftests: kvm: add test for dirty logging
> inside nested guests") is _very_ light on details, the most likely
> explanation is that vmx_dirty_log_test was attempting to avoid taking an
> EPT Violation on the first _write_ from L2.
> 
>   static void l2_guest_code(u64 *a, u64 *b)
>   {
> 	READ_ONCE(*a);
> 	WRITE_ONCE(*a, 1);   <===
> 	GUEST_SYNC(true);
> 
> 	...
>   }
> 
> When handling read faults in the shadow MMU, KVM opportunistically creates
> a writable SPTE if the mapping can be writable *and* the gPTE is dirty (or
> doesn't support the Dirty bit), i.e. if KVM doesn't need to intercept
> writes in order to emulate Dirty-bit updates.  By setting A/D bits in the
> test's EPT entries, the above READ+WRITE will fault only on the read, and
> in theory expose the bug fixed by KVM commit 1f4e5fc83a42 ("KVM: x86: fix
> nested guest live migration with PML").  If the Dirty bit is NOT set, the
> test will get a false pass due; though again, in theory.
> 
> However, the test is flawed (and always was, at least in the versions
> posted publicly), as KVM (correctly) marks the corresponding L1 GFN as
> dirty (in the dirty bitmap) when creating the writable SPTE.  I.e. without
> a check on the dirty bitmap after the READ_ONCE(), the check after the
> first WRITE_ONCE() will get a false pass due to the dirty bitmap/log having
> been updated by the read fault, not by PML.
> 
> Furthermore, the subsequent behavior in the test's l2_guest_code()
> effectively hides the flawed test behavior, as the straight writes to a
> new L2 GPA fault also trigger the KVM bug, and so the test will still
> detect the failure due to lack of isolation between the two testcases
> (Read=>Write vs. Write=>Write).
> 
> 	WRITE_ONCE(*b, 1);
> 	GUEST_SYNC(true);
> 	WRITE_ONCE(*b, 1);
> 	GUEST_SYNC(true);
> 	GUEST_SYNC(false);
> 
> Punt on fixing vmx_dirty_log_test for the moment as it will be easier to
> properly fix the test once the TDP code uses the common MMU APIs, at which
> point it will be trivially easy for the test to retrieve the EPT PTE and
> set the Dirty bit as needed.
> --

Looks good to me, a significant improvement over what I had :') 


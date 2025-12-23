Return-Path: <kvm+bounces-66631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F5BFCDAD77
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 336A2302D299
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750D82F5A34;
	Tue, 23 Dec 2025 23:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q1AtCjaH"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96872F39B5
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766533130; cv=none; b=hnAA541p3xO3ovquLZogQ6smLmCWbXMK46ZBygu1gWXA579qf9mswt5xawnloqZ60sfCOEYURimfPiC9qx7EhJ30crAGpYhr1AwECk+mzIBOI+vW7EIRvz/dKLxI19cY1aka1gyKpGE3dOlYzfSE1oAOsHqZ7InFIk7oG/nZPmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766533130; c=relaxed/simple;
	bh=9PnI7GZf6vjGOxc83T9kYDc5XW6/qfA8GRJ/QySgafw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Baa6lab0jGCF+2U4aCVPFwqFyuqrveX9/qKVxhgWZs8mybOyGfwpZLtc0Li6tZrJq7hot87koEh3VRzyIH4QXGKVMd0wAhpj3yDkJLxwo8CGOLncFTR0lfQameESc1aACAl7kkn/54DbZz9A8KbAsLezAQe3JXb5/YPUHKlm7pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q1AtCjaH; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 23 Dec 2025 23:38:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766533116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sy+m0ME9GvuoApEAA9l8deHqOrgufXjrNPXyDGTdFjA=;
	b=Q1AtCjaHQ2L7395QS6s2I8IO87/Z1cU0wMX+HJog78xfpGsvOqihwl5GEqTedZ1NYZINz0
	JEx/BObCJ0Qf5bQTwTIQat8yEcf9FRDMdYNlfBgo2J7c6G/s3a6xiENcnmTS1ZYo78BBTI
	3DE2UH6wCIs+XwtBf7y6adjtg236kvQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/16] KVM: selftests: Introduce struct kvm_mmu
Message-ID: <yq7u5tot4mr67pxiu7frq62ndk2mpzwjir5264alva3jhcd6z5@mgaew5c3vms7>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-7-yosry.ahmed@linux.dev>
 <aUsXw9m4g-Pn7LtO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUsXw9m4g-Pn7LtO@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 23, 2025 at 02:29:23PM -0800, Sean Christopherson wrote:
> On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > In preparation for generalizing the virt mapping functions to work with
> > TDP page tables, introduce struct kvm_mmu. This struct currently only
> > holds the root GPA and number of page table levels. Parameterize virt
> > mapping functions by the kvm_mmu, and use the root GPA and page table
> > levels instead of hardcoding vm->pgd and vm->pgtable_levels.
> > 
> > There's a subtle change here, instead of checking that the parent
> > pointer is the address of the vm->pgd, check if the value pointed at by
> > the parent pointer is the root GPA (i.e. the value of vm->pgd in this
> > case). No change in behavior expected.
> > 
> > Opportunistically, switch the ordering of the checks in the assertion in
> > virt_get_pte(), as it makes more sense to check if the parent PTE is the
> > root (in which case, not a PTE) before checking the present flag.
> > 
> > vm->arch.mmu is dynamically allocated to avoid a circular dependency
> > chain if kvm_util_arch.h includes processor.h for the struct definition:
> > kvm_util_arch.h -> processor.h -> kvm_util.h -> kvm_util_arch.h
> > 
> > No functional change intended.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  .../selftests/kvm/include/x86/kvm_util_arch.h |  4 ++
> >  .../selftests/kvm/include/x86/processor.h     |  8 ++-
> >  .../testing/selftests/kvm/lib/x86/processor.c | 61 +++++++++++++------
> >  3 files changed, 53 insertions(+), 20 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> > index 972bb1c4ab4c..d8808fa33faa 100644
> > --- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> > +++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> > @@ -10,6 +10,8 @@
> >  
> >  extern bool is_forced_emulation_enabled;
> >  
> > +struct kvm_mmu;
> > +
> >  struct kvm_vm_arch {
> >  	vm_vaddr_t gdt;
> >  	vm_vaddr_t tss;
> > @@ -19,6 +21,8 @@ struct kvm_vm_arch {
> >  	uint64_t s_bit;
> >  	int sev_fd;
> >  	bool is_pt_protected;
> > +
> > +	struct kvm_mmu *mmu;
> 
> No, put kvm_mmu in common code and create kvm_vm.mmu.  This makes the "mmu" object
> a weird copy of state that's already in kvm_vm (pgd, pgd_created, and pgtable_levels),
> and more importantly makes it _way_ to easy to botch the x86 MMU code (speaking
> from first hand experience), e.g. due to grabbing vm->pgtable_levels instead of
> the mmu's version.  I don't see an easy way to _completely_ guard against goofs
> like that, but it's easy-ish to audit code the code for instance of "vm->mmu.",
> and adding a common kvm_mmu avoids the weird duplicate code.

Do you mean move pgd, pgd_created, and pgtable_levels into kvm_mmu? If
yes, that makes sense to me and is obviously an improvement over what
it's in this patch.

I didn't immediately make the connection, but in hindsight it's obvious
that having some of the state in kvm_vm_arch and some in kvm_vm is
fragile.


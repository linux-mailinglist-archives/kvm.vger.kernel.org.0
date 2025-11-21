Return-Path: <kvm+bounces-64016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D14E3C76B99
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id C2AB63148C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCFF1F0E32;
	Fri, 21 Nov 2025 00:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G5rx9hqy"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1380F1AF0AF
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684307; cv=none; b=mrsQyTDu42AA2lSJ+sxsNtNOez7Ww2ltWBlX7oH3rnYScxo8OLUSfJJ5XKfK/EwpvP4P2FGeuz7qRc4Y0gXMKhe1fD3tXabI6lYz//odvKURTf78PV6bzviTqUzQpptJ4lWNaphZhfuSae8qMjDrtnCVxK4O/HqKaUW6DYZ+V4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684307; c=relaxed/simple;
	bh=TDrQFe6n1C/sZpqE5gNXxo+UwvIawF6vv/G2gT9qqro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCybyviABBNkkm9YVy9ddOdWpI6M56ljN/efi+dGpOjPz+4R5kBhVuw7iqvJTPKsER14A5MXelGMpWjwev0NbmFrFbmZzmnNh0RM1HIrg37HMRxfASW5fw4eSqHGGNru4uP2USSfM7JNbKo9/n/rsEa0MYqgADopBiK8wzndGM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G5rx9hqy; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 21 Nov 2025 00:18:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763684293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pHY28D2T6de3pRwGvadwuoaCe2XElK7swBWlrGUdPjQ=;
	b=G5rx9hqy1dsKbGPt3Gj3Je+m2pkUc26LXMPHLjQ8sCr2pL5jIB4JVbt2ZVs67YWpwBefqo
	B3X4Z6Nx6j4xlKxVmNifaiC2jUgHPkmsXj/B+pmA+UXsnZSEFmEjJqXPQEKnj+MdOd+9Bj
	ZkfdhW7oFc5HxKuFmS5F4q/KsNse4dE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/23] KVM: selftests: Parameterize the PTE bitmasks
 for virt mapping functions
Message-ID: <hyrk2lejyxrwcl5oudwkuqch7jwzgo3eoummopordtz5ryhklu@vrq5ratttux7>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <20251021074736.1324328-13-yosry.ahmed@linux.dev>
 <aR-tP8YBftwZA3DD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR-tP8YBftwZA3DD@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 20, 2025 at 04:07:27PM -0800, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> > @@ -1367,8 +1357,6 @@ static inline bool kvm_is_ignore_msrs(void)
> >  	return get_kvm_param_bool("ignore_msrs");
> >  }
> >  
> > -uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
> > -				    int *level);
> >  uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
> >  
> >  uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
> > @@ -1451,7 +1439,20 @@ enum pg_level {
> >  #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
> >  #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
> >  
> > -void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
> > +struct pte_masks {
> > +	uint64_t present;
> > +	uint64_t writeable;
> > +	uint64_t user;
> > +	uint64_t accessed;
> > +	uint64_t dirty;
> > +	uint64_t large;
> 
> Ugh, "large".  I vote for "huge" or "hugepage", as that's for more ubiquitous in
> the kernel.

"huge" sounds good.

> 
> > +	uint64_t nx;
> 
> The values themselves should be const, e.g. to communicate that they are fixed
> values.
> 
> > +};
> > +
> > +extern const struct pte_masks x86_pte_masks;
> 
> > -void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
> > +void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> > +		   int level, const struct pte_masks *masks)
> >  {
> >  	const uint64_t pg_size = PG_LEVEL_SIZE(level);
> >  	uint64_t *pte = &vm->pgd;
> > @@ -246,16 +259,16 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
> >  	 * early if a hugepage was created.
> >  	 */
> >  	for (current_level = vm->pgtable_levels; current_level > PG_LEVEL_4K; current_level--) {
> > -		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level);
> > -		if (*pte & PTE_LARGE_MASK)
> > +		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level, masks);
> > +		if (*pte & masks->large)
> >  			return;
> >  	}
> >  
> >  	/* Fill in page table entry. */
> > -	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
> > -	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
> > +	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K, masks);
> > +	TEST_ASSERT(!(*pte & masks->present),
> 
> I think accessors would help for the "read" cases?  E.g.
> 
> 	TEST_ASSERT(!is_present_pte(mmu, *pte)
> 
> or maybe go with a slightly atypical ordering of:
> 
> 	TEST_ASSERT(!is_present_pte(*pte, mmu),
> 
> The second one seems more readable.

How about is_present_pte(mmu, pte)? Any objections to passing in the
pointer?

> 
> >  		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
> > -	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
> > +	*pte = masks->present | masks->writeable | (paddr & PHYSICAL_PAGE_MASK);
> 
> Hrm.  I don't love the masks->lowercase style, but I don't hate it either.  One
> idea would be to add macros to grab the correct bit, e.g.
> 
> 	*pte = PTE_PRESENT(mmu) | PTE_WRITABLE(mmu) | (paddr & PHYSICAL_PAGE_MASK);

I like this one best, I think. Abstracts the masks away completely,
which is nice.

> 
> Alternatively, assuming we add "struct kvm_mmu", we could grab the "pte_masks"
> structure locally as "m" and do this?  Note sure the super-shorthand is a net
> positive though.
> 
> 	*pte = PTE_PRESENT(m) | PTE_WRITABLE(m) | (paddr & PHYSICAL_PAGE_MASK);
> 
> Or we could YELL REALLY LOUDLY in the fields themselves, e.g.
> 
> 	*pte = m->PRESENT | m->WRITABLE | (paddr & PHYSICAL_PAGE_MASK);
> 
> but that looks kinda weird to me.
> 
> I don't have a super strong preference, though I'm leaning towards accessor
> functions with macros for retrieving the bits.
> 
> >  	/*
> >  	 * Neither SEV nor TDX supports shared page tables, so only the final
> 
> Hiding just out of sight is this code:
> 
> 	/*
> 	 * Neither SEV nor TDX supports shared page tables, so only the final
> 	 * leaf PTE needs manually set the C/S-bit.
> 	 */
> 	if (vm_is_gpa_protected(vm, paddr))
> 		*pte |= vm->arch.c_bit;
> 	else
> 		*pte |= vm->arch.s_bit;
> 
> The C-bit (enCrypted) and S-bit (Shared) values need to be moved into the masks/mmu
> context as well.  In practice, they'll both be zero when creating nested mappings
> since KVM doesn't support nested VMs with encrypted memory, but it's still wrong,
> e.g. the Shared bit doesn't exist in EPT.

Will add, thanks!


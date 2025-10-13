Return-Path: <kvm+bounces-59951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A002ABD6B6B
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AB8C405780
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 23:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1383E2FE058;
	Mon, 13 Oct 2025 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mmAI5Pvp"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F4621CC55
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760397231; cv=none; b=EQTDCeAQEdnnhGwusVRQNy9RKfWqNbe/QeLSOKqUk74eBGsn3H8LakIQbMCMjk6hMdCgADKDtbc75IEZO15MpNsx2fDt5orjw9vhesz9FqAw65frQu8FOAov96UKCU2n3VB3wB6gbzfng1i2Jdcg/KuYXNGt9Rk2zViCtN4EzHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760397231; c=relaxed/simple;
	bh=Crd/6+faO0VmSeJYjBD0B8iA8nAphwudTku8gDmY7ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTmKGBYc3EaFknKloN59iiRY/y5aGdh/upGjaBPZ+7YmiTuQQpz1xtbE/07+B2iJD9/xofxc9HKXjVcXMHVVKIEYqQ1VYgfCpQKnNR+a/QwGn/DAcU9/hXEASYX0Gc7Ry7a8Yq0RjDbq0YMHoAVUIkOZe5JWHVkVXS8MofxHFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mmAI5Pvp; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 13 Oct 2025 23:13:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760397225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CewOr8v6ktZEwt5LSAXhGz0m2E8hzX+Ljv2EDTU2BU=;
	b=mmAI5PvpN6r2aWgD4Hk5SInNnkQIeof9jwC2+vOiltoPVyMeLrb/wGVaN/uUQn3nkN0Mej
	mVafDHH79UN7A3cRQ3ft36hlAsWJzCFfVfTik8OCRPB9LaOynlbOuqBHHNpBM2PNqDXZA7
	UyIQBFIK8RmUudRnUxrkIN2ujWphyqA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] KVM: selftests: Use 'leaf' instead of hugepage to
 describe EPT entries
Message-ID: <zfhwufkxrv4uqibspjstsqruuz5mgd4t765c3cobh374bmfqwy@welriubpwp6t>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
 <20251001145816.1414855-9-yosry.ahmed@linux.dev>
 <aO1yJHcKC85mo0PQ@google.com>
 <ivkoh7hdl7fcp5fmehmf3kv6ebqitozunbricyed5tkt7z3ngr@qvmaytpzrskw>
 <aO2EFiOHSuvmHvq_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO2EFiOHSuvmHvq_@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 13, 2025 at 03:58:30PM -0700, Sean Christopherson wrote:
> On Mon, Oct 13, 2025, Yosry Ahmed wrote:
> > On Mon, Oct 13, 2025 at 02:41:56PM -0700, Sean Christopherson wrote:
> > > On Wed, Oct 01, 2025, Yosry Ahmed wrote:
> > > > From: Yosry Ahmed <yosryahmed@google.com>
> > > > 
> > > > The assertions use 'hugepage' to describe a terminal EPT entry, but
> > > > 'leaf' is more accruate as a PG_LEVEL_4K EPT entry is a leaf but not a
> > > > hugepage.
> > > 
> > > Yes, it's more accurate, but also less precise.  I'm guessing the assert message
> > > and comment talked about hugepages because that's the type of mappings that
> > > caused problems at the time.
> > 
> > Given that it refers to PG_LEVEL_4K entries too, I wouldn't call it less
> > precise. All callers actually create 4K mappings so it is never actually
> > a hugepage in the current context :D
> 
> nested_identity_map_1g()?

Yeah I missed this one.

> 
> > > Ah, actually, I bet the code was copy+pasted from virt_create_upper_pte(), in
> > > which case the assumptions about wanting to create a hupage are both accurate
> > > and precise.
> > > 
> > > > The distincion will be useful in coming changes that will pass
> > > > the value around and 'leaf' is clearer than hugepage or page_size.
> > > 
> > > What value?
> > 
> > 'leaf'. The following changes will pass 'leaf' in as a boolean instead
> > of checking 'current_level == target_level' here. So passing in
> > 'hugepage' would be inaccurate, and 'page_size' is not as clear (but
> > still works).
> > 
> > > 
> > > > Leave the EPT bit named page_size to keep it conforming to the manual.
> > > > 
> > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > ---
> > > >  tools/testing/selftests/kvm/lib/x86/vmx.c | 10 +++++-----
> > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > index 04c4b97bcd1e7..673756b27e903 100644
> > > > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > > > @@ -380,15 +380,15 @@ static void nested_create_pte(struct kvm_vm *vm,
> > > >  			pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
> > > >  	} else {
> > > >  		/*
> > > > -		 * Entry already present.  Assert that the caller doesn't want
> > > > -		 * a hugepage at this level, and that there isn't a hugepage at
> > > > -		 * this level.
> > > > +		 * Entry already present.  Assert that the caller doesn't want a
> > > > +		 * leaf entry at this level, and that there isn't a leaf entry
> > > > +		 * at this level.
> > > >  		 */
> > > >  		TEST_ASSERT(current_level != target_level,
> > > > -			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx",
> > > > +			    "Cannot create leaf entry at level: %u, nested_paddr: 0x%lx",
> > > >  			    current_level, nested_paddr);
> > > >  		TEST_ASSERT(!pte->page_size,
> > > > -			    "Cannot create page table at level: %u, nested_paddr: 0x%lx",
> > > > +			    "Leaf entry already exists at level: %u, nested_paddr: 0x%lx",
> > > 
> > > This change is flat out wrong.  The existing PRESENT PTE _might_ be a 4KiB leaf
> > > entry, but it might also be an existing non-leaf page table.
> > 
> > Hmm if pte->page_size is true then it has to be a leaf page table,
> > right?
> 
> No, because bit 7 is ignored by hardware for 4KiB entries.  I.e. it can be 0 or
> 1 depending on the whims of software.  Ugh, this code uses bit 7 to flag leaf
> entries.  That's lovely.

That's not my fault :P

> 
> > If it's an existing non-leaf page table we shouldn't fail,
> 
> Ah, right, current_level can never be less than target_level because the first
> assert will fail on iteration-1.
> 
> > the assertion here is when we try to override a leaf page table IIUC.
> >
> > > Instead of hacking on the nested code, can we instead tweak __virt_pg_map() to
> > > work with nested TDP?  At a glance, it's already quite close, e.g. "just" needs
> > > to be taught about EPT RWX bits and allow the call to pass in the root pointer.
> > 
> > That would be ideal, I'll take a look. In case I don't have time for
> > that unification, can this be a follow-up change?
> 
> Part of me wants to be nice and say "yes", but most of me wants to say "no".

So.. which part won?

> 
> Struct overlays for PTEs suck.  At best, they generate poor code and obfuscate
> simple logic (e.g. vm->page_size vs pte->page_size is a confusion that simply
> should not be possible).  At worst, they lead to hard-to-debug issues like the
> one that led to commit f18b4aebe107 ("kvm: selftests: do not use bitfields larger
> than 32-bits for PTEs").
> 
> eptPageTableEntry obviously isn't your fault, but nptPageTableEntry is. :-D
> And I suspect the hardest part of unificiation will be adding the globals to
> deal with variable bit positions that are currently being handled by the struct
> overlays.

I have no problem getting rid of eptPageTableEntry and using bitmasks
and whatnot on a uint64_t PTE (assuming that's what you are asking for
here).

But I think tweaking __virt_pg_map() will involve more than that, or
maybe I just didn't look close enough yet.


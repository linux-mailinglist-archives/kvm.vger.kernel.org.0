Return-Path: <kvm+bounces-59947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C429BD69B5
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 00:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CF883A3E71
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 22:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC882FE57F;
	Mon, 13 Oct 2025 22:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BsqtxRKS"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054CC2EFDBA
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 22:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394331; cv=none; b=HCrj78Ghg5+/XhlWL312bV0ennte38K0AmNQLPTocwy5tqSu1vDH3KJCOR/APqXRVISnZj/iuJDLPqQU9Doa2a4mJ18ThVIb4i+wjMaYzA7Bp5poS9Sb4zdChXWSQ8vGbRqUdoqc7UgGOdpVzVl/IUNLi0CopXgG8u1plPtJqPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394331; c=relaxed/simple;
	bh=Jf/RCp0W1R16T+LuSWIfFdr0PYVVcukWFSiYEsqCGpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6kt3VQXOGySY6o0dKqoFAyQsQGvuUYcOm1m3ulnu99oMzdP0kefkoSUFkNVdwy66fdkCuinjCDasJril1s1ZAxZt9k8lzV2c3F8dIEf+jj6dQx/qN2IJWmhe+auC/P+sLVY+uDV4xrBFbZxTuEVfabRKKFAS41dcevaJYHXYZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BsqtxRKS; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 13 Oct 2025 22:25:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760394326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0EgIJNgp76TDPohMkfuZZJN+3BausRPObvIACd4fJ9g=;
	b=BsqtxRKSrb4BBYtkyjI9Tp+ncPvykLYTCsnlENGKok9jyeIFE99Io7/SZCxf5Rbr3QDoN6
	wPNl6PbzJJrOiAPZVBaurS23LIZ/4nq7RkiE4xE9FINcabn+0FVrmGCwNvWNn76Q1TsQYP
	DPgUyx2bgSde0k8ups9L7z1CU7KrysY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] KVM: selftests: Use 'leaf' instead of hugepage to
 describe EPT entries
Message-ID: <ivkoh7hdl7fcp5fmehmf3kv6ebqitozunbricyed5tkt7z3ngr@qvmaytpzrskw>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
 <20251001145816.1414855-9-yosry.ahmed@linux.dev>
 <aO1yJHcKC85mo0PQ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO1yJHcKC85mo0PQ@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 13, 2025 at 02:41:56PM -0700, Sean Christopherson wrote:
> On Wed, Oct 01, 2025, Yosry Ahmed wrote:
> > From: Yosry Ahmed <yosryahmed@google.com>
> > 
> > The assertions use 'hugepage' to describe a terminal EPT entry, but
> > 'leaf' is more accruate as a PG_LEVEL_4K EPT entry is a leaf but not a
> > hugepage.
> 
> Yes, it's more accurate, but also less precise.  I'm guessing the assert message
> and comment talked about hugepages because that's the type of mappings that
> caused problems at the time.

Given that it refers to PG_LEVEL_4K entries too, I wouldn't call it less
precise. All callers actually create 4K mappings so it is never actually
a hugepage in the current context :D

> 
> Ah, actually, I bet the code was copy+pasted from virt_create_upper_pte(), in
> which case the assumptions about wanting to create a hupage are both accurate
> and precise.
> 
> > The distincion will be useful in coming changes that will pass
> > the value around and 'leaf' is clearer than hugepage or page_size.
> 
> What value?

'leaf'. The following changes will pass 'leaf' in as a boolean instead
of checking 'current_level == target_level' here. So passing in
'hugepage' would be inaccurate, and 'page_size' is not as clear (but
still works).

> 
> > Leave the EPT bit named page_size to keep it conforming to the manual.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  tools/testing/selftests/kvm/lib/x86/vmx.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > index 04c4b97bcd1e7..673756b27e903 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> > @@ -380,15 +380,15 @@ static void nested_create_pte(struct kvm_vm *vm,
> >  			pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
> >  	} else {
> >  		/*
> > -		 * Entry already present.  Assert that the caller doesn't want
> > -		 * a hugepage at this level, and that there isn't a hugepage at
> > -		 * this level.
> > +		 * Entry already present.  Assert that the caller doesn't want a
> > +		 * leaf entry at this level, and that there isn't a leaf entry
> > +		 * at this level.
> >  		 */
> >  		TEST_ASSERT(current_level != target_level,
> > -			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx",
> > +			    "Cannot create leaf entry at level: %u, nested_paddr: 0x%lx",
> >  			    current_level, nested_paddr);
> >  		TEST_ASSERT(!pte->page_size,
> > -			    "Cannot create page table at level: %u, nested_paddr: 0x%lx",
> > +			    "Leaf entry already exists at level: %u, nested_paddr: 0x%lx",
> 
> This change is flat out wrong.  The existing PRESENT PTE _might_ be a 4KiB leaf
> entry, but it might also be an existing non-leaf page table.

Hmm if pte->page_size is true then it has to be a leaf page table,
right?

If it's an existing non-leaf page table we shouldn't fail, the assertion
here is when we try to override a leaf page table IIUC.

> 
> Instead of hacking on the nested code, can we instead tweak __virt_pg_map() to
> work with nested TDP?  At a glance, it's already quite close, e.g. "just" needs
> to be taught about EPT RWX bits and allow the call to pass in the root pointer.

That would be ideal, I'll take a look. In case I don't have time for
that unification, can this be a follow-up change?

> 
> >  			    current_level, nested_paddr);
> >  	}
> >  }
> > -- 
> > 2.51.0.618.g983fd99d29-goog
> > 


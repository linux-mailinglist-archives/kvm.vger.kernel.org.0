Return-Path: <kvm+bounces-66632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAFCCDAD7A
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:40:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7934A300461B
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1EA2F6927;
	Tue, 23 Dec 2025 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BVOIocZh"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B904223BCF7;
	Tue, 23 Dec 2025 23:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766533238; cv=none; b=j+dKM3Ll5kaidzBiFa92s9IWz9fLQPccbLh+NiyLJLZqgID85E1V0I1HMb+pmfTvh4+zY8CnweznyVUlPc4aqGEaXGLiyiPJM+C/npXvFQw3WoQQbbcMma90mXtCwsnHVxIjSF/Cp1TtVP8ETz0mMGsC8Dtwz1KSK7z1+cECdNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766533238; c=relaxed/simple;
	bh=qmzV1zXCY3Si6cX+GM06TkroCzvpDV6suF5ZcPcKmt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQUhhPBIu3npio8m9ywgghexCd4HiPpXlVkh7C25z+zD7eOCocKeVAbjm4OM1OGQT2X6EFM7vme4Pb6kvbu+rOSZ/+oW5p7VhAjxj9k3jcLdj1INNvQZV9y0z8rjhIyOR/6cRqKO4xFcJtuI2Fbjw0oMpmfDYJxlhWO3wLUhT7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BVOIocZh; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 23 Dec 2025 23:40:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766533234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+DXOvwI6tf5lZvUMVfExHVaH+eQMLnVa0FkpkFY4SOs=;
	b=BVOIocZhP1/lwIZSxmwe2CXUyR82ape3gbDHsLZ7jEjB8ugZpg6V0c90VHvp+ltHPbGS0m
	Imal5odPUnNAx2SrcMDpctXjDFQ9QB1QwDdMmmj7e0WrlAX895wil4m3sA2zuQ0nMJmgux
	fqNkNiFl8rjVKTHWO1xtbJTOA6X1sUw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/16] KVM: selftests: Move PTE bitmasks to kvm_mmu
Message-ID: <qsj5cleufe4ljlfi7zq77ted6utdgaqzcwuifjeik5hnbvqzvi@xitzlce5si6o>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-8-yosry.ahmed@linux.dev>
 <aUsYSvd2gBOKt9fo@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUsYSvd2gBOKt9fo@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 23, 2025 at 02:31:38PM -0800, Sean Christopherson wrote:
> On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > @@ -1449,11 +1439,44 @@ enum pg_level {
> >  #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
> >  #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
> >  
> > +struct pte_masks {
> > +	uint64_t present;
> > +	uint64_t writable;
> > +	uint64_t user;
> > +	uint64_t accessed;
> > +	uint64_t dirty;
> > +	uint64_t huge;
> > +	uint64_t nx;
> > +	uint64_t c;
> > +	uint64_t s;
> > +};
> > +
> >  struct kvm_mmu {
> >  	uint64_t root_gpa;
> >  	int pgtable_levels;
> > +	struct pte_masks pte_masks;
> 
> And then introduce kvm_mmu_arch so that x86 can shove pte_masks into the mmu.

Makes sense.

> 
> >  };
> >  
> > +#define PTE_PRESENT_MASK(mmu) ((mmu)->pte_masks.present)
> > +#define PTE_WRITABLE_MASK(mmu) ((mmu)->pte_masks.writable)
> > +#define PTE_USER_MASK(mmu) ((mmu)->pte_masks.user)
> > +#define PTE_ACCESSED_MASK(mmu) ((mmu)->pte_masks.accessed)
> > +#define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
> > +#define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
> > +#define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
> > +#define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
> > +#define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
> > +
> > +#define pte_present(mmu, pte) (!!(*(pte) & PTE_PRESENT_MASK(mmu)))
> 
> I very, very strongly prefer is_present_pte(), is_huge_pte(), etc.

These were modeled after the kernel accessors (e.g. in
arch/x86/include/asm/pgtable.h). I think it's clearer if we use the same
naming here, but I don't feel as strongly as you -- so fine either way.

> 
> > +#define pte_writable(mmu, pte) (!!(*(pte) & PTE_WRITABLE_MASK(mmu)))
> > +#define pte_user(mmu, pte) (!!(*(pte) & PTE_USER_MASK(mmu)))
> > +#define pte_accessed(mmu, pte) (!!(*(pte) & PTE_ACCESSED_MASK(mmu)))
> > +#define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
> > +#define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
> > +#define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
> > +#define pte_c(mmu, pte) (!!(*(pte) & PTE_C_MASK(mmu)))
> > +#define pte_s(mmu, pte) (!!(*(pte) & PTE_S_MASK(mmu)))


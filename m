Return-Path: <kvm+bounces-19252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F30B39027F4
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 19:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 991D91F22E56
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 17:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C16149007;
	Mon, 10 Jun 2024 17:46:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1A055884;
	Mon, 10 Jun 2024 17:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718041572; cv=none; b=PdoUx0wCmRK02XjfQwp+mLBVNQzFnQbbPR0uoYKRoFfvzJFyQsxJwA3wn2OpDvc4u42v8ZZFzyc8WnKwI0PXGWwGJutulprcLO2yoJgV/WKTtg9npPVteHpj8w0BIoDlWI0BkE5GuIEIhzP2h8tZFbJfX3JrjCUd2wfjdJSyEpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718041572; c=relaxed/simple;
	bh=Rpc1vYA+Vsw5eEf1wrOwknnjMSPbRupjy7yAinzLOC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ibZFa8g5q7gNr/6dnm2iZQYl/87sSPu7fDCCAhMFv9bgB1tn8wWeYAlmX7oiJtpN2WI/XWy3V/KIhBoY5gspfKKLWAEXrM2+ZgoumSD2D4m6YtGnwHhnARkmlbIgJ/aim2pwdePM6VIc4y6Dc2Sr6xTJa0tnv1rVO5Rshz44EzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB9FC2BBFC;
	Mon, 10 Jun 2024 17:46:08 +0000 (UTC)
Date: Mon, 10 Jun 2024 18:46:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Steven Price <steven.price@arm.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 00/14] arm64: Support for running as a guest in Arm CCA
Message-ID: <Zmc73jAL2XdLU49P@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <SN6PR02MB415739D48B10C26D2673F3FED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <ZmMjam3-L807AFR-@arm.com>
 <SN6PR02MB41571B5C2C9C59B0DF5F4E7ED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <ZmbWpNOc7MiJEjqL@arm.com>
 <SN6PR02MB4157E83EAFA5EBEF5C5889BFD4C62@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB4157E83EAFA5EBEF5C5889BFD4C62@SN6PR02MB4157.namprd02.prod.outlook.com>

On Mon, Jun 10, 2024 at 05:03:44PM +0000, Michael Kelley wrote:
> From: Catalin Marinas <catalin.marinas@arm.com> Sent: Monday, June 10, 2024 3:34 AM
> > I wonder whether something like __GFP_DECRYPTED could be used to get
> > shared memory from the allocation time and avoid having to change the
> > vmalloc() ranges. This way functions like netvsc_init_buf() would get
> > decrypted memory from the start and vmbus_establish_gpadl() would not
> > need to call set_memory_decrypted() on a vmalloc() address.
> 
> I would not have any conceptual objections to such an approach. But I'm
> certainly not an expert in that area so I'm not sure what it would take
> to make that work for vmalloc(). I presume that __GFP_DECRYPTED
> should also work for kmalloc()?
> 
> I've seen the separate discussion about a designated pool of decrypted
> memory, to avoid always allocating a new page and decrypting when a
> smaller allocation is sufficient. If such a pool could also work for page size
> or larger allocations, it would have the additional benefit of concentrating
> decrypted allocations in fewer 2 Meg large pages vs. scattering wherever
> and forcing the break-up of more large page mappings in the direct map.

Yeah, my quick, not fully tested hack here:

https://lore.kernel.org/linux-arm-kernel/ZmNJdSxSz-sYpVgI@arm.com/

It's the underlying page allocator that gives back decrypted pages when
the flag is passed, so it should work for alloc_pages() and friends. The
kmalloc() changes only ensure that we have separate caches for this
memory and they are not merged. It needs some more work on kmem_cache,
maybe introducing a SLAB_DECRYPTED flag as well as not to rely on the
GFP flag.

For vmalloc(), we'd need a pgprot_decrypted() macro to ensure the
decrypted pages are marked with the appropriate attributes (arch
specific), otherwise it's fairly easy to wire up if alloc_pages() gives
back decrypted memory.

> I'll note that netvsc devices can be added or removed from a running VM.
> The vmalloc() memory allocated by netvsc_init_buf() can be freed, and/or
> additional calls to netvsc_init_buf() can be made at any time -- they aren't
> limited to initial Linux boot.  So the mechanism for getting decrypted
> memory at allocation time must be reasonably dynamic.

I think the above should work. But, of course, we'd have to get this
past the mm maintainers, it's likely that I missed something.

> Rejecting vmalloc() addresses may work for the moment -- I don't know
> when CCA guests might be tried on Hyper-V.  The original SEV-SNP and TDX
> work started that way as well. :-) Handling the vmalloc() case was added
> later, though I think on x86 the machinery to also flip all the alias PTEs was
> already mostly or completely in place, probably for other reasons. So
> fixing the vmalloc() case was more about not assuming that the underlying
> physical address range is contiguous. Instead, each page must be processed
> independently, which was straightforward.

There may be a slight performance impact but I guess that's not on a
critical path. Walking the page tables and changing the vmalloc ptes
should be fine but for each page, we'd have to break the linear map,
flush the TLBs, re-create the linear map. Those TLBs may become a
bottleneck, especially on hardware with lots of CPUs and the
microarchitecture. Note that even with a __GFP_DECRYPTED attribute, we'd
still need to go for individual pages in the linear map.

-- 
Catalin


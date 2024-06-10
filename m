Return-Path: <kvm+bounces-19179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D8D901F7A
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D10791C2118C
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78157A724;
	Mon, 10 Jun 2024 10:34:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6144278289;
	Mon, 10 Jun 2024 10:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718015658; cv=none; b=YlDBc7IqFCRIYj7c6H+3ShpY0tH8qMka69a03p7REK89msl8ZWcY9XY8AqnaWB03g2CBLlZzWw7bvN1/1g3+klscoYx13Q0Pxa15OwEKMfRQEvS93MGY0EhEQTf42Pg9aGYySNUo9iY2BmkXxwX3OhV63MP0zSYv8xw/G5XeqYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718015658; c=relaxed/simple;
	bh=XtWJks2i9IAdE5AHADeeOUmGvpns41q5F8q5JRssxmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=daGmnfa7lEr2p1A4q6XQjdJvdn+44Oi3hr/dqBys5/9btDGquJZMUTOPa3ChNxJXTqBon+oldyaWcCM/wvqpPZsW5lLj2VY6/JRofsJLJmocN4WYrNY19MN2CiwRA4quvOiE5FGdeVlcm3MC7rV/gevuMTjUVwxz1nI2GF49Ba4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C0DC4AF1A;
	Mon, 10 Jun 2024 10:34:14 +0000 (UTC)
Date: Mon, 10 Jun 2024 11:34:12 +0100
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
Message-ID: <ZmbWpNOc7MiJEjqL@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <SN6PR02MB415739D48B10C26D2673F3FED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
 <ZmMjam3-L807AFR-@arm.com>
 <SN6PR02MB41571B5C2C9C59B0DF5F4E7ED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB41571B5C2C9C59B0DF5F4E7ED4FB2@SN6PR02MB4157.namprd02.prod.outlook.com>

On Fri, Jun 07, 2024 at 04:36:18PM +0000, Michael Kelley wrote:
> From: Catalin Marinas <catalin.marinas@arm.com> Sent: Friday, June 7, 2024 8:13 AM
> > On Fri, Jun 07, 2024 at 01:38:15AM +0000, Michael Kelley wrote:
> > > In the case of a vmalloc() address, load_unaligned_zeropad() could still
> > > make an access to the underlying pages through the linear address. In
> > > CoCo guests on x86, both the vmalloc PTE and the linear map PTE are
> > > flipped, so the load_unaligned_zeropad() problem can occur only during
> > > the transition between decrypted and encrypted. But even then, the
> > > exception handlers have code to fixup this case and allow everything to
> > > proceed normally.
> > >
> > > I haven't looked at the code in your patches, but do you handle that case,
> > > or somehow prevent it?
> > 
> > If we can guarantee that only full a vm_struct area is changed at a
> > time, the vmap guard page would prevent this issue (not sure we can
> > though). Otherwise I think we either change the set_memory_*() code to
> > deal with the other mappings or we handle the exception.
> 
> I don't think the vmap guard pages help. The vmalloc() memory consists
> of individual pages that are scattered throughout the direct map. The stray
> reference from load_unaligned_zeropad() will originate in a kmalloc'ed
> memory page that precedes one of these scattered individual pages, and
> will use a direct map kernel vaddr.  So the guard page in vmalloc space don't
> come into play. At least in the Hyper-V use case, an entire vmalloc allocation
> *is* flipped as a unit, so the guard pages do prevent a stray reference from
> load_unaligned_zeropad() that originates in vmalloc space. At one
> point I looked to see if load_unaligned_zeropad() is ever used on vmalloc
> addresses.  I think the answer was "no",  making the guard page question
> moot, but I'm not sure. :-(

My point was about load_unaligned_zeropad() originating in the vmalloc
space. What I had in mind is changing the underlying linear map via
set_memory_*() while we have live vmalloc() mappings. But I forgot about
the case you mentioned in a previous thread: set_memory_*() being called
on vmalloc()'ed memory directly:

https://lore.kernel.org/r/SN6PR02MB41578D7BFEDE33BD2E8246EFD4E92@SN6PR02MB4157.namprd02.prod.outlook.com/

I wonder whether something like __GFP_DECRYPTED could be used to get
shared memory from the allocation time and avoid having to change the
vmalloc() ranges. This way functions like netvsc_init_buf() would get
decrypted memory from the start and vmbus_establish_gpadl() would not
need to call set_memory_decrypted() on a vmalloc() address.

> Another thought: The use of load_unaligned_zeropad() is conditional on
> CONFIG_DCACHE_WORD_ACCESS. There are #ifdef'ed alternate
> implementations that don't use load_unaligned_zeropad() if it is not
> enabled. I looked at just disabling it in CoCo VMs, but I don't know the
> performance impact. I speculated that the benefits were more noticeable
> in processors from a decade or more ago, and perhaps less so now, but
> never did any measurements. There was also a snag in that x86-only
> code has a usage of load_unaligned_zeropad() without an alternate
> implementation, so I never went fully down that path. But arm64 would
> probably "just work" if it were disabled.

We shouldn't penalise the performance, especially as I expect a single
image to run both as a guest or a host. However, I think now the linear
map is handled correctly since we make the PTE invalid before making the
page shared and this would force the fault path through the one that
safely handles load_unaligned_zeropad(). Steven's patches also currently
reject non-linear-map addresses, I guess this would be a separate
addition.

> > We also have potential user mappings, do we need to do anything about
> > them?
> 
> I'm unclear on the scenario here.  Would memory with a user mapping
> ever be flipped between decrypted and encrypted while the user mapping
> existed? 

Maybe it doesn't matter. Do we expect it the underlying pages to be
flipped while live mappings other than the linear map exist? I assume
not, one would first allocate and configure the memory in the kernel
before some remap_pfn_range() to user with the appropriate pgprot.

-- 
Catalin


Return-Path: <kvm+bounces-20285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52A3912797
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:25:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FBDB28CB77
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB6A286A8;
	Fri, 21 Jun 2024 14:24:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56A92BD05;
	Fri, 21 Jun 2024 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718979894; cv=none; b=qPN5tw+N3MWPviqIvYmkE9QsYna6ARb2qbX+mrZksjpcEKkHUtYkPg58jFqQJws3YxB0vt2+k4ChuO3WnBUAHP309ZNFopnrLDyN1cSNri5GcF/UfKHt96fnqMQ2z0U4uRD7KfGsMawl2oTI6GGk+d84r0OHuw8NaI9v0FOf1TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718979894; c=relaxed/simple;
	bh=RETRueEd8Da5F+dDTZp/iAAmWnyQ+pHFqet8mPxwiRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCuR3vbSAsCrSfCF9ekxsoVbrw6j6w8Ug1C7iHrBNgTYHifwYiySZFx1y/O2bxjmjyI016Ugf03JSsZQKDxS47mcnWpGyybf8jkXSbBD2YuJqdW1ai4XpV5NHpQaa9CgJF6KP5E92jz0m8yzV6xvYsaCvnHuXkkHqs1nQdem4i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D65C4AF07;
	Fri, 21 Jun 2024 14:24:50 +0000 (UTC)
Date: Fri, 21 Jun 2024 15:24:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
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
Subject: Re: [PATCH v3 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Message-ID: <ZnWNMM2LqBwkfHwe@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-13-steven.price@arm.com>
 <86a5jzld9g.wl-maz@kernel.org>
 <4c363476-e5b5-42ff-9f30-a02a92b6751b@arm.com>
 <867cf2l6in.wl-maz@kernel.org>
 <ZmICEN8JvWM7M9Ch@arm.com>
 <ZmNJdSxSz-sYpVgI@arm.com>
 <SN6PR02MB41578FDF4DD1013FEF690069D4CE2@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB41578FDF4DD1013FEF690069D4CE2@SN6PR02MB4157.namprd02.prod.outlook.com>

Hi Michael,

All good points below, thanks.

On Tue, Jun 18, 2024 at 04:04:17PM +0000, Michael Kelley wrote:
> As someone who has spent time in Linux code on the x86 side that
> manages memory shared between the guest and host, a GFP_DECRYPTED
> flag on the memory allocation calls seems very useful. Here are my
> general comments, some of which are probably obvious, but I thought
> I'd write them down anyway.
> 
> 1)  The impetus in this case is to efficiently allow sub-page allocations.
> But on x86, there's also an issue in that the x86 direct map uses large
> page mappings, which must be split if any 4K page in the large page
> is decrypted. Ideally, we could cluster such decrypted pages into the
> same large page(s) vs. just grabbing any 4K page, and reduce the
> number of splits. I haven't looked at how feasible that is to implement
> in the context of the existing allocator code, so this is aspirational.

It might be doable, though it's a lot more intrusive than just a GFP
flag. However, such memory cannot be used for any other things than
sharing data with the host.

> 2) GFP_DECRYPTED should work for the three memory allocation
> interfaces and their variants: alloc_pages(), kmalloc(), and vmalloc().

Yes. There are two main aspects: (1) the page allocation + linear map
change and (2) additional mapping attributes like in the vmalloc() case.

> 3) The current paradigm is to allocate memory and call
> set_memory_decrypted(). Then do the reverse when freeing memory.
> Using GFP_DECRYPTED on the allocation, and having the re-encryption
> done automatically when freeing certainly simplifies the call sites.
> The error handling at the call sites is additional messiness that gets
> much simpler.
> 
> 4) GFP_DECRYPTED should be silently ignored when not running
> in a CoCo VM. Drivers that need decrypted memory in a CoCo VM
> always set this flag, and work normally as if the flag isn't set when
> not in a CoCo VM. This is how set_memory_decrypted()/encrypted()
> work today. Drivers call them in all cases, and they are no-ops
> when not in a CoCo VM.

Yes, this should be straightforward. Maybe simplified further to avoid
creating additional kmalloc() caches if these functions are not
supported, though we seem to be missing some generic
arch_has_mem_encrypt() API.

> 5) The implementation of GFP_DECRYPTED must correctly handle
> errors from set_memory_decrypted()/encrypted() as I've described
> separately on this thread.

Good point, I completely missed this aspect.

I'll prepare some patches and post them next week to get feedback from
the mm folk.

Thanks.

-- 
Catalin


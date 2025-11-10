Return-Path: <kvm+bounces-62575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB6EC489D9
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3823A3A29AD
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3BB3195EB;
	Mon, 10 Nov 2025 18:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="cl9XAEFB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VcH8kvUY"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFC12DECC2;
	Mon, 10 Nov 2025 18:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799886; cv=none; b=Qze/KBpSN+0TzHh3xBVpP5WPg+8epoVrihHaqJx3mGudVhuSDOS6kIuvQWJ3B2TnabvbineObuM3bD8cfvjzEKzUD9MnlbHrJ3wYW+p01oVmrNVqIrMOXMFFp56ib3hNZAmnmcWdTkzCCANyCeeEHPXu3+hW2U5Rl05w3KcHZFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799886; c=relaxed/simple;
	bh=zspJnCQxK4K7uUc4qnAm9wXMc+7WL20mQ6Qc7lGPTcU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MqRbdvsqKhnN4ZOCQO0JyUCW8l3b0wiV2DZizol5JpOnvTk1y2RA0+gSgIucxzsxtI4igWMy+Txl4ZAHlnh3bTNVOaKENQleSl0rZC5z/WogSN/VDgmC0FqEh5ZhU3pm7ha1gqCqKCOaK7FbRqXIzsu6C1fP4R75QS7Q606zFLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=cl9XAEFB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VcH8kvUY; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 85DEA1D001E3;
	Mon, 10 Nov 2025 13:38:01 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 10 Nov 2025 13:38:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762799881;
	 x=1762886281; bh=eMKjXJVti11Y2CN6F7Pq9i7z+MqTZx1e+eE7f+6hcwM=; b=
	cl9XAEFBFHS4AzsUA17kd42VlAjYAVlKWfFNiznhSvD5OyTctq7g+xMyjTEGILP1
	kAdjE59ijjfJk26/hiCbJ/R8Cl/0kAy22cRXWjalIOnh44tq63rLAuWojPs+yYHd
	6BSycHXBJGYxZgOpj0VE36/KDl2td2SHP+hfrW8pn3qCZrTA7cllCfJjIwflMoHQ
	yf4NB5Oc4T7q9WOHaynfW7bmIUM6p22QG/vlL4rjesTtbO0joglcK8d+4fisrySV
	etlZxTwN5TJKZd4iCKkiJ6qxBpenEj5mPIlvagNqAugWmLG0FgN4/olLNJVhSWNl
	Zf35jdOp0J1TbkzCiHrDiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762799881; x=
	1762886281; bh=eMKjXJVti11Y2CN6F7Pq9i7z+MqTZx1e+eE7f+6hcwM=; b=V
	cH8kvUYCCpKQCKvHCbo6Yv1nyvx4CyjS3hTf+38RhOT5vrpVOpmPTxcXJ49K29Y5
	8KXSPCRefuJCZcbio9Xj8oUzzLITfw+MutU5b+iSnx/YopMdpyk5t5WQUbFjtUY4
	CqLUdV0gfbVvC8McuvKcG10mzWeSn6g6awomrhsXlsZWwHNaHO7IySbxBGEiYQX7
	6z6gNef1iLrq073K51CTK2rHfbULTbRYRcmBDqDmxV+36XTjmSVo345CHsOOGNMp
	OEsz1zfyRzy5c8oyngrB0uBgtl57mOg0JYBPO5+KD11qwPfp75iah54ICTnArIhU
	oOvh9PkfmBOfiSRPbgANQ==
X-ME-Sender: <xms:CDESabNoZSWiof0Ox2ftOMRVz3-R5rLIzcQs6tENJs-7pcUwqThBFw>
    <xme:CDESaWs1uC1uK9h7IWlaQda5OcXh68N34cUnnVdwFGmM2wG6falnT9RgcRtXpstCD
    o6B7hRFcW1g5oFhbdcJBCVoJKRu48fSz0ByTFBCua1z_K6dCbNz>
X-ME-Received: <xmr:CDESaWb_QI8Ctmq8rR-iXEq5kyG_rm-vTE1SSUm6Ecog17vt8T2WYIiL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleeltdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhephedvtdeuveejudffjeefudfhueefjedvtefgffdtieeiudfhjeejhffhfeeu
    vedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughmrg
    htlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthhopegrmhgrshhtrhhosehfsgdr
    tghomhdprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehkvhhmsehv
    ghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:CDESaQzZMlgvFT1GMAXt8smoGNAp4J9dQ_bWfRitbp8y8RQks3ztCw>
    <xmx:CDESaWg2hboCwA2BVQvuNcfylB6v5NeEHFgQychvfyj9jNXO_cby2g>
    <xmx:CDESaUl2vVzOQeAsGqq9Cn6BGLQ6l9DYvlxmy02nF_XTP1UCWYUIGQ>
    <xmx:CDESaUhh7Jy4Zu0imVmFYpuzAItGaSRdKj7toxOsci8j8P9tfHXe3Q>
    <xmx:CTESadN4Udm0C1vRIRlx4OPmw9idgsThuPp_W0fDd63f_H51GC4N7UnJ>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Nov 2025 13:38:00 -0500 (EST)
Date: Mon, 10 Nov 2025 11:37:57 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Mastro <amastro@fb.com>, Alex Williamson
 <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if
 mapping returns -EINVAL
Message-ID: <20251110113757.22b320b8.alex@shazbot.org>
In-Reply-To: <aRIoKJk0uwLD-yGr@google.com>
References: <20251107222058.2009244-1-dmatlack@google.com>
	<aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
	<aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com>
	<20251108143710.318702ec.alex@shazbot.org>
	<aQ/sShi4MWr6+f5l@devgpu015.cco6.facebook.com>
	<20251110081709.53b70993.alex@shazbot.org>
	<aRIXboz5X4KKq/8R@devgpu015.cco6.facebook.com>
	<aRIoKJk0uwLD-yGr@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Nov 2025 18:00:08 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2025-11-10 08:48 AM, Alex Mastro wrote:
> > On Mon, Nov 10, 2025 at 08:17:09AM -0700, Alex Williamson wrote:  
> > > On Sat, 8 Nov 2025 17:20:10 -0800
> > > Alex Mastro <amastro@fb.com> wrote:
> > >   
> > > > On Sat, Nov 08, 2025 at 02:37:10PM -0700, Alex Williamson wrote:  
> > > > > On Sat, 8 Nov 2025 12:19:48 -0800
> > > > > Alex Mastro <amastro@fb.com> wrote:    
> > > > > > Here's my attempt at adding some machinery to query iova ranges, with
> > > > > > normalization to iommufd's struct. I kept the vfio capability chain stuff
> > > > > > relatively generic so we can use it for other things in the future if needed.    
> > > > > 
> > > > > Seems we were both hacking on this, I hadn't seen you posted this
> > > > > before sending:
> > > > > 
> > > > > https://lore.kernel.org/kvm/20251108212954.26477-1-alex@shazbot.org/T/#u
> > > > > 
> > > > > Maybe we can combine the best merits of each.  Thanks,    
> > > > 
> > > > Yes! I have been thinking along the following lines
> > > > - Your idea to change the end of address space test to allocate at the end of
> > > >   the supported range is better and more general than my idea of skipping the
> > > >   test if ~(iova_t)0 is out of bounds. We should do that.
> > > > - Introducing the concept iova allocator makes sense.
> > > > - I think it's worthwhile to keep common test concepts like vfio_pci_device
> > > >   less opinionated/stateful so as not to close the door on certain categories of
> > > >   testing in the future. For example, if we ever wanted to test IOVA range
> > > >   contraction after binding additional devices to an IOAS or vfio container.  
> > > 
> > > Yes, fetching the IOVA ranges should really occur after all the devices
> > > are attached to the container/ioas rather than in device init.  We need
> > > another layer of abstraction for the shared IOMMU state.  We can
> > > probably work on that incrementally.  
> 
> I am working on pulling the iommu state out of struct vfio_pci_device
> here:
> 
>   https://lore.kernel.org/kvm/20251008232531.1152035-5-dmatlack@google.com/
> 
> But if we keep the iova allocator a separate object, then we can
> introduce it mosty indepently from this series. I imagine the only thing
> that will change is passing a struct iommu * instead of a struct
> vfio_pci_device * when initializing the allocator.
> 
> > > 
> > > I certainly like the idea of testing range contraction, but I don't
> > > know where we can reliably see that behavior.  
> > 
> > I'm not sure about the exact testing strategy for that yet either actually.
> >   
> > > > - What do you think about making the concept of an IOVA allocator something
> > > >   standalone for which tests that need it can create one? I think it would
> > > >   compose pretty cleanly on top of my vfio_pci_iova_ranges().  
> > > 
> > > Yep, that sounds good.  Obviously what's there is just the simplest
> > > possible linear, aligned allocator with no attempt to fill gaps or
> > > track allocations for freeing.  We're not likely to exhaust the address
> > > space in an individual unit test, I just wanted to relieve the test
> > > from the burden of coming up with a valid IOVA, while leaving some
> > > degree of geometry info for exploring the boundaries.  
> > 
> > Keeping the simple linear allocator makes sense to me.
> >   
> > > Are you interested in generating a combined v2?  
> > 
> > Sure -- I can put up a v2 series which stages like so
> > - adds stateless low level iova ranges queries
> > - adds iova allocator utility object
> > - fixes end of ranges tests, uses iova allocator instead of iova=vaddr   
> 
> +1 to getting rid of iova=vaddr.
> 
> But note that the HugeTLB tests in vfio_dma_mapping_test.c have
> alignment requirements to pass on Intel (since it validates the pages
> are mapped at the right level in the I/O page tables using the Intel
> debugfs interface).
> 
> > > TBH I'm not sure that just marking a test as skipped based on the DMA
> > > mapping return is worthwhile with a couple proposals to add IOVA range
> > > support already on the table.  Thanks,  
> > 
> > I'll put up the new series rooted on linux-vfio/next soon.  
> 
> I think we should try to get vfio_dma_mapping_test back to passing in
> time for Linux 6.18, since the newly failing test was added in 6.18.
> 
> The sequence I was imagining was:
> 
>  1. Merge the quick fix to skip the test into 6.18.

We'd still have the iova=vaddr failure on some platforms, but could
hack around that by hard coding some "well supporteD" IOVA like 0 or
4GB.

>  2. Split struct iommu from struct vfio_pci_device.
>  3. Add iova allocator.
> 
> AlexW, how much time do we have to get AlexM's series ready? I am fine
> with doing (3), then (2), and dropping (1) if there's enough time.

I'll certainly agree that it'd be a much better precedent if the self
test were initially working, but also we should not increase the scope
beyond what we need to make it work for v6.18.  If we can get that done
in the next day or two, add it to linux-next mid-week, and get Linus to
pull for rc6, I think that'd be reasonable.  Thanks,

Alex


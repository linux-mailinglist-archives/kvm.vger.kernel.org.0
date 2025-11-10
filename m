Return-Path: <kvm+bounces-62514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F82C478AC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ECD53A9176
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086993176E1;
	Mon, 10 Nov 2025 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="f9fhjJR7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="naSbSQBX"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F331619A;
	Mon, 10 Nov 2025 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762787835; cv=none; b=ZggLwR+PpunrO+DlWdU0gEq7vntkzjgX3mLTW+jOv1O93uJ375Rl+iPtWdQ5LeUZeFFrxwxy2UYGtynp2lTyiPmf2bAuj8ENzUHAGRP1h8zOdeFKobuLVZc6pPEafPbKlJs+KCapiHDcTJ0YVsoPfkhUahKFY05YxzWxCUt2mxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762787835; c=relaxed/simple;
	bh=QlQmt4D2iwHk3N/1VccN/hYS+pGqAP/JSyAMTi2HYvw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DcmpBmEnvsCkuPEvo2btrK3gxryRRdLvXwO0IW2UuPuvD4x21WmcOoZobSuu9b3xLiqgFKW3AbmHBqD8ZuINUO0Rea8YvU5BXN1kxJzdxMHQrZSHL3Dn0o96aKXFC7mA3yjOW82IxlAEfYUyhyUQcB6FYFW3vItLiqv4iT6kGjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=f9fhjJR7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=naSbSQBX; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 082A714001E5;
	Mon, 10 Nov 2025 10:17:12 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 10 Nov 2025 10:17:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762787832;
	 x=1762874232; bh=DkO5IDX69Odi+UOI9bn5z/Yb7WRSva6uQJJnS0kixiU=; b=
	f9fhjJR7EXurZ6aIBZ1RexZkbhknu8L8I/YLOkJa4ssncCeLvcdTYYtj3o5IPL+u
	t62fwa631IvTQVITh0OjC1/Mfl6WC1tIE7cFoHVxUzSB18RyUwZyH2Lz0yyoobof
	xTKfOt9vZmVolpl33Q2xSsTm9W9w4nEFLBAJezyez6jHwdUAkXFEyGS+GqR9XZOJ
	vf0jZP9DW7AJ7hlo/x/EPQzPXgg3+tZlm+yhqeaTZFbNXIVfRALy1cjHba31wPvZ
	dYv+DZWz8W25CUVjabNQqQ2qYdt7pU9Fqqp/6dgRwzTHmqAX9QE6oDZeOp3BUFWI
	LBnM4U3jq3gwj8ZrElX9UQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762787832; x=
	1762874232; bh=DkO5IDX69Odi+UOI9bn5z/Yb7WRSva6uQJJnS0kixiU=; b=n
	aSbSQBXK+z9Q1UHYRBoIbjIu/NqwmnIOGsbHJUGOm/3GW/j5e+SRn+cYd0bElQ+1
	IVugsv6BHWTLkIg8bMcXrTpGYPbzDRP0CadjgkgqOX7uO5hcJURbNuJDX3JiGgan
	ZSzfvyQ3IsG8UHbAk+bEvXNhLgO6j9hRyvnEqQvW1wwNrI15rabomIhju57933Jk
	wdEuqsATHXhG/Gnvx9K7/FsZTzZrYl74L+DIXyicywh7Hi4OzIeB8xzAaAA0PjaL
	IwuUiUcUpOBlFF+V0RxqpCmwSTBgTwz5NWQrVYUi69dQwoqpr2Qv9m8eyU6039Lv
	EfRqSrbnSgUjAtafAMR0g==
X-ME-Sender: <xms:9wESaYRU0vPSpich5WuyQ8bZfOzgOS1iDwErGCTdHdvCsh8sb-4Rhg>
    <xme:9wESafEDGg5dORvPnZPGRVok_hmhhWTR-TKd1d09-YU7ySTsAtHBD1YBPnZH0GScj
    aDkkKFHPFHEJLyCOnIt40BfbeTlMLkKUaE8p8NP6zlCtbH4aGcvu_8>
X-ME-Received: <xmr:9wESadECQGcgok36eg2x1nZX7V9Z1vN9eqdLLAga_7qvw1-k3NWERNTN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleekieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhephedvtdeuveejudffjeefudfhueefjedvtefgffdtieeiudfhjeejhffhfeeu
    vedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghmrg
    hsthhrohesfhgsrdgtohhmpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhlvgdr
    tghomhdprhgtphhtthhopegrlhgvgidrfihilhhlihgrmhhsohhnsehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehkvhhmsehv
    ghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:9wESadQXpd4n3z2gUxL5rymJJEAHNmc0j3K9hnO-RoGIQAuCLnTtAA>
    <xmx:9wESaeITLP1BTL_XsBIH6zYAIdcZDkV6TFBIOfxAWWPJ9co-4xIsIQ>
    <xmx:9wESaYaHx7RBqggVckQPQfzKTFgQAYq-HVCCN9Sp5sWS2fxoolacrA>
    <xmx:9wESaQ_0gksJU--13NzOG3ByRZs1JtX79Za_hVCJC2pawW4afBBo7A>
    <xmx:9wESaaA_YKcrjkju0fJSfl2esDzKUTibJQaspx4HDpEYuopyCg5mPokW>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Nov 2025 10:17:10 -0500 (EST)
Date: Mon, 10 Nov 2025 08:17:09 -0700
From: Alex Williamson <alex@shazbot.org>
To: Alex Mastro <amastro@fb.com>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson
 <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if
 mapping returns -EINVAL
Message-ID: <20251110081709.53b70993.alex@shazbot.org>
In-Reply-To: <aQ/sShi4MWr6+f5l@devgpu015.cco6.facebook.com>
References: <20251107222058.2009244-1-dmatlack@google.com>
	<aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
	<aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com>
	<20251108143710.318702ec.alex@shazbot.org>
	<aQ/sShi4MWr6+f5l@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 8 Nov 2025 17:20:10 -0800
Alex Mastro <amastro@fb.com> wrote:

> On Sat, Nov 08, 2025 at 02:37:10PM -0700, Alex Williamson wrote:
> > On Sat, 8 Nov 2025 12:19:48 -0800
> > Alex Mastro <amastro@fb.com> wrote:  
> > > Here's my attempt at adding some machinery to query iova ranges, with
> > > normalization to iommufd's struct. I kept the vfio capability chain stuff
> > > relatively generic so we can use it for other things in the future if needed.  
> > 
> > Seems we were both hacking on this, I hadn't seen you posted this
> > before sending:
> > 
> > https://lore.kernel.org/kvm/20251108212954.26477-1-alex@shazbot.org/T/#u
> > 
> > Maybe we can combine the best merits of each.  Thanks,  
> 
> Yes! I have been thinking along the following lines
> - Your idea to change the end of address space test to allocate at the end of
>   the supported range is better and more general than my idea of skipping the
>   test if ~(iova_t)0 is out of bounds. We should do that.
> - Introducing the concept iova allocator makes sense.
> - I think it's worthwhile to keep common test concepts like vfio_pci_device
>   less opinionated/stateful so as not to close the door on certain categories of
>   testing in the future. For example, if we ever wanted to test IOVA range
>   contraction after binding additional devices to an IOAS or vfio container.

Yes, fetching the IOVA ranges should really occur after all the devices
are attached to the container/ioas rather than in device init.  We need
another layer of abstraction for the shared IOMMU state.  We can
probably work on that incrementally.

I certainly like the idea of testing range contraction, but I don't
know where we can reliably see that behavior.

> - What do you think about making the concept of an IOVA allocator something
>   standalone for which tests that need it can create one? I think it would
>   compose pretty cleanly on top of my vfio_pci_iova_ranges().

Yep, that sounds good.  Obviously what's there is just the simplest
possible linear, aligned allocator with no attempt to fill gaps or
track allocations for freeing.  We're not likely to exhaust the address
space in an individual unit test, I just wanted to relieve the test
from the burden of coming up with a valid IOVA, while leaving some
degree of geometry info for exploring the boundaries.

Are you interested in generating a combined v2?

TBH I'm not sure that just marking a test as skipped based on the DMA
mapping return is worthwhile with a couple proposals to add IOVA range
support already on the table.  Thanks,

Alex


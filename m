Return-Path: <kvm+bounces-60572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D9996BF3C62
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 23:36:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 486074E24B5
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 21:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2892ED84C;
	Mon, 20 Oct 2025 21:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="RXotOpLY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L1HmZAjA"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706772DAFDE;
	Mon, 20 Oct 2025 21:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760996203; cv=none; b=eY2Hmv5h822/83JBOpmTv30Kn3TMjh7YMVXayg9QEXxJAuiQY6dm9gtNi7Z/zaOakhcoYJAjluj2n4F47EahnRqWXi5VfTxMjdfdkwzVaf7lQdUhsAorTnuOtCLIfoHPcwZCZokxnnLbRnEgqGKnOAbSIuaPwMJBllxIeiiAB9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760996203; c=relaxed/simple;
	bh=iZuTD5RiWVWphXNNGnlMBnB3WDltkiLbJtRklXeI8Nk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JIUnhPUQ09o8LZt+2IIjFNChFziYts+rnSNMs7/PElKvpIliIZAXnECMwQM+8R4zeQCjC7IYhEceM9w5/Z8RzXgTobmkrjKkWlPty8IXIcTjZr6iFKwZtvLbAnEdyYF0AU2cGwAvC3SVIc/8Wby4hCFrCeXM8NxJ6We2MQM2NUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=RXotOpLY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L1HmZAjA; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3E11B14001BA;
	Mon, 20 Oct 2025 17:36:39 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 20 Oct 2025 17:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1760996199;
	 x=1761082599; bh=jRUujCet7fvARjwGlDg+oiZlT8oT/xbGvKPfGfsxa9E=; b=
	RXotOpLYSWZ1dlEh8ePPEVFk0fgsuebocrDMLC/wZ40xR6WvuELLRSAMABeZp05w
	6B8/NO9Y8J8+EWjtqj8Ag88Y0DULOR/KXFH/NvMvji++nyl7u1otcG4pTQiCEtdD
	txky4JzlpozU56/Y1gEa/kH5P/9XM7rXGk6U/CpA1nw9DAomwIOjCRbO0f0sAe3z
	BLlP0Q6FG3f5kPqpwh7G7glKmfHo2aix8cl5OdbYmeLaSyVr0jI9iU7G6FYU7+37
	d/MlnoZwIYZ7+osQ9BicrvBROkt8IsH5/VAlKHH424NeLZTzXHU9ruNAV9OXRbY0
	lJ2UiVzlRKMT7tKmN+jNjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760996199; x=
	1761082599; bh=jRUujCet7fvARjwGlDg+oiZlT8oT/xbGvKPfGfsxa9E=; b=L
	1HmZAjAlanUjAYYvHuqzHuaSw5+TdVmNDrffgmxE/1jFjYLufg6IYW+jIdQlM4uM
	ANIJIWNzypzZP8RXHyfX/9atLFzuCJhzn3svcTDsIq6gSedidc5XDBlgc3yR7qUx
	7lDsBq8ZG5KeiPWGJlhHOh4D37aeRJw3O1x/VZ184B0/HNBnHCpAjHTOoNkNy8QT
	MBJonNjpC79NifTuTxewQ66w/2YFHOs12brN1bCQ39dkgwZaAtp/WL5gV2Vwof5F
	UpzJrxoa8jugbDqBYznaYaKm6ciwX2Ct2qdlOTWxZV/rGWipW+45DhR6DA/E720o
	Rd7iX8wNQYR8wol8Ih95Q==
X-ME-Sender: <xms:Zqv2aATxRHwx70MoTSJKrWcSbTqF9DddrNrk_3hc2_oqBeIBWKt5EA>
    <xme:Zqv2aHGmgWWA0yhtp3FV4Eimfxma8Fw-BHPOALfweXRaUZkThsMAKBjsq6oY6etvW
    ziCIi4cm6l8EZmLVe0_iC13Ll-8TWZooTVJCuG_qUIb4hk33aEPriE>
X-ME-Received: <xmr:Zqv2aFEzX4iTfPYyt0_n_K0ypEwceLJ_ApLvjipWZOMpjxbPx-f-Ga1Bkos>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeekledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeeipdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegrmhgrshhtrhhosehfsgdrtghomhdprhgtphhtthhope
    grlhgvjhgrnhgurhhordhjrdhjihhmvghnvgiisehorhgrtghlvgdrtghomhdprhgtphht
    thhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:Zqv2aFS-f7QyLxgpWHmxZbjqSB_mimzmPRQQ3lcNYQnyv-vmzRz77w>
    <xmx:Zqv2aGL42_p_FKKBWEXJdtmppfQcB_kd0kgdHavADTeu_4C3WpK-aw>
    <xmx:Zqv2aAbS9mVOmkET-MtuaTJoXY8nin2j7NFQiBaI2Db1IxLoB65AmA>
    <xmx:Zqv2aI-slOeCZjDay4ZQviUqhc3sdUYeC1mxTLkRzxgpyjHRpXBSTQ>
    <xmx:Z6v2aJMBw-p_q6mU3u3ciRgbXX91hlj8GVz7QjO-BsiKPUkQPJ1I81uX>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Oct 2025 17:36:37 -0400 (EDT)
Date: Mon, 20 Oct 2025 15:36:33 -0600
From: Alex Williamson <alex@shazbot.org>
To: Alex Mastro <amastro@fb.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <20251020153633.33bf6de4@shazbot.org>
In-Reply-To: <aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
	<20251015132452.321477fa@shazbot.org>
	<3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
	<aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
	<20251016160138.374c8cfb@shazbot.org>
	<aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Oct 2025 09:29:26 -0700
Alex Mastro <amastro@fb.com> wrote:

> On Thu, Oct 16, 2025 at 04:01:38PM -0600, Alex Williamson wrote:
> > That mechanism for triggering replay requires a specific hardware
> > configuration, but we can easily trigger it through code
> > instrumentation, ex:
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 5167bec14e36..2cb19ddbb524 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2368,7 +2368,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >                     d->enforce_cache_coherency ==
> >                             domain->enforce_cache_coherency) {
> >                         iommu_detach_group(domain->domain, group->iommu_group);
> > -                       if (!iommu_attach_group(d->domain,
> > +                       if (0 && !iommu_attach_group(d->domain,
> >                                                 group->iommu_group)) {
> >                                 list_add(&group->next, &d->group_list);
> >                                 iommu_domain_free(domain->domain);
> > 
> > We might consider whether it's useful for testing purposes to expose a
> > mechanism to toggle this.  For a unit test, if we create a container,
> > add a group, and build up some suspect mappings, if we then add another
> > group to the container with the above bypass we should trigger the
> > replay.  
> 
> Thanks for the tip. I did this, and validated via bpftrace-ing iommu_map that
> the container's mappings (one of which lies at the end of address space) are
> replayed correctly. Without the fix, the loop body
> 
> while (iova < dma->iova + dma->size) { ... iommu_map() ... }
> 
> would never be entered for the end of address space mapping due to
> 
> dma->iova + dma->size == 0
> 
> $ sudo bpftrace -e 'kprobe:iommu_map { printf("pid=%d comm=%s domain=%p iova=%p paddr=%p size=%p prot=%p gfp=%p\n", pid, comm, (void*)arg0, (void*)arg1, (void*)arg2, (void*)arg3, (void*)arg4, (void*)arg5); }'
> Attached 1 probe
> # original mappings
> pid=616477 comm=test_dma_map_un domain=0xff11012805dac210 iova=0x10000000000 paddr=0x12ecfdd0000 size=0x1000 prot=0x7 gfp=0x400cc0
> pid=616477 comm=test_dma_map_un domain=0xff11012805dac210 iova=0x10000001000 paddr=0x12ecfdd0000 size=0x1000 prot=0x7 gfp=0x400cc0
> pid=616477 comm=test_dma_map_un domain=0xff11012805dac210 iova=0xfffffffffffff000 paddr=0x12ecfdd0000 size=0x1000 prot=0x7 gfp=0x400cc0
> # replayed mapping
> pid=616477 comm=test_dma_map_un domain=0xff11012805dab610 iova=0x10000000000 paddr=0x12ecfdd0000 size=0x1000 prot=0x7 gfp=0x400cc0
> pid=616477 comm=test_dma_map_un domain=0xff11012805dab610 iova=0x10000001000 paddr=0x12ecfdd0000 size=0x1000 prot=0x7 gfp=0x400cc0
> pid=616477 comm=test_dma_map_un domain=0xff11012805dab610 iova=0xfffffffffffff000 paddr=0x12ecfdd0000 size=0x1000 prot=0x7 gfp=0x400cc0
> 
> > In general though the replay shouldn't have a mechanism to trigger
> > overflows, we're simply iterating the current set of mappings that have
> > already been validated and applying them to a new domain.  
> 
> Agree. Overflow means that some other invariant has broken, and nonsensical
> vfio_dma have infiltrated iommu->dma_list. The combination of iommu->lock
> serialization + overflow checks elsewhere should have prevented that.
> 
> > In any case, we can all take a second look at the changes there.  
> Thanks!

Thanks for the further testing.  Looking again at the changes, it still
looks good to me.

I do note that we're missing a Fixes: tag.  I think we've had hints of
this issue all the way back to the original implementation, so perhaps
the last commit should include:

Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")

Unless you've identified a more specific target.

Along with the tag, it would probably be useful in that same commit to
expand on the scope of the issue in the commit log.  I believe we allow
mappings to be created at the top of the address space that cannot be
removed via ioctl, but such inconsistency should result in an
application error due to the failed ioctl and does not affect cleanup
on release.  Should we also therefore expand the DMA mapping tests in
tools/testing/selftests/vfio to include an end of address space test?
Thanks,

Alex


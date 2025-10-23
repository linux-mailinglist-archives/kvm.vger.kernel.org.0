Return-Path: <kvm+bounces-60930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C2230C03AED
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 00:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 222A64E9F08
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 22:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61872279346;
	Thu, 23 Oct 2025 22:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Ed9vr+HO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jaAt03e6"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BFA204C36;
	Thu, 23 Oct 2025 22:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761258810; cv=none; b=LE6Xf1sCX7roGXqibgmswEvJF4GQ2wtv0nmnGwyukaf+7c6L0aeWxIdNXeGDx3IPkMg+o5A3CnhsTg9rRUzfgtMpzA4ZQxGILgyoJu5796dsA5h9nvkLaIEhInDNLU7g426ymH6TgkaggHho+7+E5zeXwb0DCpXNnSxxza35wto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761258810; c=relaxed/simple;
	bh=wHeu1yF1p3wpkFMLunIV0NwiUDjLA+J9TETIjtRCo0U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k3jq+h11M8k9aLd+X3jCUqeoSvSlF4X0JdQ9gD90f/w5Bhjy4MgMLvAlemCWjM1lfNASCwy3pcYULoUvvhAZftHbSp7/pjLvN4xxiT5EvQ1Fq16HKwmJIN+2/ZkPLdq0lfxqBe+UQyeBd5C/0bPX4oedFnKZV6bSIzG9O7ZTkTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Ed9vr+HO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jaAt03e6; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id A48AA1D000B9;
	Thu, 23 Oct 2025 18:33:26 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 23 Oct 2025 18:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761258806;
	 x=1761345206; bh=ELlRqBy9gE8vE3ScqttKzzJSJi83zmYaSSKZkAgDXP4=; b=
	Ed9vr+HOv0rQ08IO3ISDPMIVmJg07eoIidRnH2mNLy1JbNREI6SXoqti6W3Md0GS
	qT9LPDamCbHIRHQE2yYnid+xN5IWfmv1MY1JQm5OzTCa/ipdAOdLk05mFOwxe8/0
	OBeibCciA+6HzRfsm25EQxpdUbDBrRQZs6zZhPLzpVjHxn/vkSC2MS+pGH68QdtZ
	xhMrk2GaGkSvCU9/NJBlUkLnANfcUZOe6bui05NXH03l4a8PZFv+8WNXWC7JOod/
	4yRjFzJuYmHoiIGdEN2Sy0Kh5V5V0DQHRk2CV9vppZY6X0INzxnF4s0gulDHU9Yk
	izQMtOHoIL+IWLwEGdgLkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1761258806; x=
	1761345206; bh=ELlRqBy9gE8vE3ScqttKzzJSJi83zmYaSSKZkAgDXP4=; b=j
	aAt03e6SnEOV7et1mm6tv6XTGmtpADuyDbkSmwhNbgHLx02tx3c2zyv8f04N33Qj
	b0ZuRy1x5tOJZSFSjt7TX13EsscIeeTBGtUKTxjCFjd0lqqCpAka347jQSdujbE2
	d58xw+OQWsSFGCPbaUr2mkwOjvOeXtN2ESExAkLRgZREl5qps8yHsKDO4/o+UZRP
	Lhf2akkRvWH/YRtfGFJstWZB5fyU7OsWS5JVbk+KoLqv149jIdqN7COAwfuszxqU
	UaN2CimdGQAO6E+lRoEW0u2Id7xqGn4oOkrm52ZYiCctpV6ri3ImS4pO62xWmPhT
	hoh4orDbnHAH2nHQFVDtg==
X-ME-Sender: <xms:Na36aPONhw2vyRFtbrf-BlFKJFS_q1TXsKv11383mEogeKen511tQg>
    <xme:Na36aDQyMQYfpzNybhCMc0TD02LG4B0MNLf5E81w9MtK1riWEHvd7OGsUtbG0o_i0
    g6WqLXEmp4oF4_TOIx4F50jiOgbSR4VSEV7Muoq_5lZbKEcDdnDvg>
X-ME-Received: <xmr:Na36aFjncpwma58pbGuAFXNyA9PDgsVVx75vfyn8DZ0PR6T_r90piHdKQYY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeejieeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:Na36aE-vFf0E6KgMglfDesvhIJp_2LMwcypqycw8kUefJMl28L4i5A>
    <xmx:Na36aEEVmWow93Ju6qoT5fSS_qNeahjCfe14VSvKSq3CehEPeFuOag>
    <xmx:Na36aPl2AOEq7i9Ffr1R1mAwBzqc1G00zzEXtrvFoUJxrmMT9z2bkg>
    <xmx:Na36aAY65r7YC_rrsFmNmXSHUXbA_1xA-aGOfIF_xipEAAMzbd9edg>
    <xmx:Nq36aGrNhMeFXA6GR3WqjJtOPCAxjK8h_ujd-MnfOwfQ_VC2VCv7_aNh>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 18:33:25 -0400 (EDT)
Date: Thu, 23 Oct 2025 16:33:22 -0600
From: Alex Williamson <alex@shazbot.org>
To: Alex Mastro <amastro@fb.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <20251023163322.77c9848c@shazbot.org>
In-Reply-To: <aPqVdAB9F9Go5X3n@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
	<20251015132452.321477fa@shazbot.org>
	<3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
	<aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
	<20251016160138.374c8cfb@shazbot.org>
	<aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
	<20251020153633.33bf6de4@shazbot.org>
	<aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
	<aPqVdAB9F9Go5X3n@devgpu012.nha5.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Oct 2025 13:52:04 -0700
Alex Mastro <amastro@fb.com> wrote:

> One point to clarify
> 
> > On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:  
> > > Along with the tag, it would probably be useful in that same commit to
> > > expand on the scope of the issue in the commit log.  I believe we allow
> > > mappings to be created at the top of the address space that cannot be
> > > removed via ioctl,  
> 
> True
> 
> > > but such inconsistency should result in an application error due to the
> > > failed ioctl  
> 
> Actually, the ioctl does not fail in the sense that the caller gets an errno.
> Attempting to unmap a range ending at the end of address space succeeds (returns
> zero), but unmaps zero bytes. An application would only detect this if it
> explicitly checked the out size field of vfio_iommu_type1_dma_unmap. Or
> attempted to create another overlapping mapping on top of the ranges it expected
> to be unmapped.

Yes, the ioctl doesn't fail but the returned unmap size exposes the
inconsistency.  This is because we don't require a 1:1 unmap, an unmap
can span multiple mappings, or none.  Prior to TYPE1v2 we even allowed
splitting previous mappings.  I agree that it obfuscates the
application detecting the error, but I'm not sure there's much we can
do about it given the uAPI.  Let's document the scenario as best we
can.  Thanks,

Alex


> Annotated below:
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 916cad80941c..039cba5a38ca 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -165,19 +165,27 @@ vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>  				      dma_addr_t start, size_t size)
>  {
> +	// start == ~(dma_addr_t)0
> +	// size == 0
>  	struct rb_node *node = iommu->dma_list.rb_node;
>  
>  	while (node) {
>  		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>  
> +		// never true because all dma->iova < ~(dma_addr_t)0
>  		if (start + size <= dma->iova)
>  			node = node->rb_left;
> +		// traverses right until we get to the end of address space
> +		// dma, then we walk off the end because
> +		// ~(dma_addr_t)0 >= 0 == true
> +		// node = NULL
>  		else if (start >= dma->iova + dma->size)
>  			node = node->rb_right;
>  		else
>  			return dma;
>  	}
>  
> +	// This happens
>  	return NULL;
>  }
>  
> @@ -201,6 +209,8 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
>  			node = node->rb_right;
>  		}
>  	}
> +	// iova >= start + size == true, due to overflow to zero => no first
> +	// node found
>  	if (res && size && dma_res->iova >= start + size)
>  		res = NULL;
>  	return res;
> @@ -1397,6 +1407,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (iova || size)
>  			goto unlock;
>  		size = U64_MAX;
> +	// end of address space unmap passes these checks
>  	} else if (!size || size & (pgsize - 1) ||
>  		   iova + size - 1 < iova || size > SIZE_MAX) {
>  		goto unlock;
> @@ -1442,18 +1453,23 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	 * mappings within the range.
>  	 */
>  	if (iommu->v2 && !unmap_all) {
> +		// passes this check as long as the unmap start doesn't split an
> +		// existing dma
>  		dma = vfio_find_dma(iommu, iova, 1);
>  		if (dma && dma->iova != iova)
>  			goto unlock;
>  
> +		// dma = NULL, we pass this check
>  		dma = vfio_find_dma(iommu, iova + size - 1, 0);
>  		if (dma && dma->iova + dma->size != iova + size)
>  			goto unlock;
>  	}
>  
>  	ret = 0;
> +	// n = NULL
>  	n = first_n = vfio_find_dma_first_node(iommu, iova, size);
>  
> +	// loop body never entered
>  	while (n) {
>  		dma = rb_entry(n, struct vfio_dma, node);
>  		if (dma->iova >= iova + size)
> @@ -1513,6 +1529,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	/* Report how much was unmapped */
>  	unmap->size = unmapped;
>  
> +	// return 0
>  	return ret;
>  }
>  
> 



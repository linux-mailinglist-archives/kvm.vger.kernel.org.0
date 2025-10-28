Return-Path: <kvm+bounces-61366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C3820C17443
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 00:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4BD9D4F7840
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FAB369996;
	Tue, 28 Oct 2025 23:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Q6goO9JB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FbV3PhcN"
X-Original-To: kvm@vger.kernel.org
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9AD2DCF58;
	Tue, 28 Oct 2025 23:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692512; cv=none; b=T/sVBOICKs4gGxinEm07HKqgjTt5pQJpzr/gRMoAVbDkLwJ9E0QLpAnlyfnXN25aSMm+tMc1DYsugbMWnjWh9S5L19bVXONOkTKSQWGSvJWafLC1Q680iu3gQdCk3sxF9+NG9NOqp/33Bwh/Wr76ncpfwTnHDhVmW00XSrM74pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692512; c=relaxed/simple;
	bh=GEmVIyvcZswex1xK/L5E5FO8yRYC8c1DtcVExW6fUv4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYwEUKqKmD7MOjv6gqxbsecJ0NNqskx6Zn2YJ7JLQBCYDZyalC8vCB4ur1bZv2jkslrltrXGipnDrPND7HJeBZwrfuy3ezSTGi4FDvJcowr6jZijLICr8n+Ah6uDd77Y9w6J5HCUH0Wkj/xPetZeH/i0s7oBD5rW2u0EQ8cIUdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Q6goO9JB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FbV3PhcN; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 0E92213800E5;
	Tue, 28 Oct 2025 19:01:47 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 28 Oct 2025 19:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761692507;
	 x=1761699707; bh=5900kUawE28awK0nhR2lAl8X3tlct7jD5QZ76Kkfoxg=; b=
	Q6goO9JBM0VI8q0yGzpov1QTjO4aPNn6+zMXI5gX0RFuy0hAPRE1Ae5qMxRmuqON
	vo8jgaJTQSvSAv9nzXoo6tALCt/1NkEPViAybKsMPFHGq6TLdZhI8WCNwrJ6VFVy
	JZpvJdHoc3iNIerc6Hf+3B0Feg+dsSdP1ZhigW7llHwSMpm0HLJLFHcPNA4G1+sP
	JIt07vtZiOByQDr895lZYO1weWpbo18gbPYTj/G6CMA7did2LvTp01Se3ODbUpPx
	hnu8wi6RuB4/zAht0Tm3TMiERxdfrpzJ1WJmL2ygzYKIUzZzBrTkgTLKiqrEzj3R
	zLgJmEJs7JZ+JnDcDO52Gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1761692507; x=
	1761699707; bh=5900kUawE28awK0nhR2lAl8X3tlct7jD5QZ76Kkfoxg=; b=F
	bV3PhcNkw5F5hzW52DtPdYk+A2XkInHxkOTkj6kiZtyn1Wf7Dfi/yZw1MyOKkgxB
	d254NSy8E5IS4hVV/Bo+IQNiTkoSXsX1Z14YZ2+7HTl+5uEqmeyAirh+JTWn51f9
	cno+M6isQ/H1OXRiK2Coa3b8ap7Avg6+qj1Wkje87773rrPO4OXbHaOOWCkDdGMi
	67q9Vp6Ep1i+PrYHWA0dkXU//yBbcrxkwxAY0MH4doMEmxO0LYWDb16rN1GYrXYu
	x531igJA3rAndVgTJ2MrGQPerBrJ3Ow6s2kZfJs0VC53otKcTwY3IlJEVb9O3qiA
	9VCb/W1K38haxxyOSUHeQ==
X-ME-Sender: <xms:WksBaXtj3PQsy_8xvUya1nJELrY0cxi3jKHTym_XrVECWMJJlS80vg>
    <xme:WksBaRxNiIYjA8cxVJrr2ldyKvR4dnsediEPqbxUiXT9PW3EwXW5rXSU8BJvXVFMN
    LpQ35GoDeIHfZ2PfhyT4df2Cid8VouWNw3MxNARZQgnE7jA_24fSOs>
X-ME-Received: <xmr:WksBaSDMlYFhw6kCUFmwMr2mqv5jestBGrjxLfLR8oazA-7NW3V8FgdtxSs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduiedvuddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucfrhhhishhhihhnghdqkffkrfgprhhtucdliedtjedmne
    cujfgurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgig
    ucghihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrf
    grthhtvghrnhephedvtdeuveejudffjeefudfhueefjedvtefgffdtieeiudfhjeejhffh
    feeuvedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhr
    ghdpnhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprg
    hmrghsthhrohesfhgsrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhr
    tghpthhtoheprghlvghjrghnughrohdrjhdrjhhimhgvnhgviiesohhrrggtlhgvrdgtoh
    hmpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthho
    pehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkh
    gvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:WksBaXfI3D4xGjhbiOaxmrswB8-UJZby7RaPUv7zKgkDUcC4qlgx_Q>
    <xmx:WksBaUm72C19mZFKW6K9fB4cQXAclw0KuDduIkISCSYG9IkMBqZUFw>
    <xmx:WksBaWFYpTE3xf96BspHeAbPdNXJlJmeAA8s1ttu0M2V_yX8carLGw>
    <xmx:WksBaU6jfTP3DLrerwZx4e_itdI2TumrpK3tRxbAfblmRL-f-Lw1Kw>
    <xmx:W0sBaYR4nzu425PvkDZ_V5d46SD_hhMibMDoaRaX7yxPa6EYq5IQZhFY>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Oct 2025 19:01:45 -0400 (EDT)
Date: Tue, 28 Oct 2025 17:01:44 -0600
From: Alex Williamson <alex@shazbot.org>
To: Alex Mastro <amastro@fb.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Alejandro Jimenez
 <alejandro.j.jimenez@oracle.com>, David Matlack <dmatlack@google.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/5] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <20251028170144.6a33a107@shazbot.org>
In-Reply-To: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>
References: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Oct 2025 09:14:59 -0700
Alex Mastro <amastro@fb.com> wrote:

> This patch series aims to fix vfio_iommu_type.c to support
> VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA operations targeting IOVA
> ranges which lie against the addressable limit. i.e. ranges where
> iova_start + iova_size would overflow to exactly zero.
> 
> Today, the VFIO UAPI has an inconsistency: The
> VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE capability of VFIO_IOMMU_GET_INFO
> reports that ranges up to the end of the address space are available
> for use, but are not really due to bugs in handling boundary conditions.
> 
> For example:
> 
> vfio_find_dma_first_node() is called to find the first dma node to unmap
> given an unmap range of [iova..iova+size). The check at the end of the
> function intends to test if the dma result lies beyond the end of the
> unmap range. The condition is incorrectly satisfied when iova+size
> overflows to zero, causing the function to return NULL.
> 
> The same issue happens inside vfio_dma_do_unmap()'s while loop.
> 
> This bug was also reported by Alejandro Jimenez in [1][2].
> 
> Of primary concern are locations in the current code which perform
> comparisons against (iova + size) expressions, where overflow to zero
> is possible.
> 
> The initial list of candidate locations to audit was taken from the
> following:
> 
> $ rg 'iova.*\+.*size' -n drivers/vfio/vfio_iommu_type1.c | rg -v '\- 1'
> 173:            else if (start >= dma->iova + dma->size)
> 192:            if (start < dma->iova + dma->size) {
> 216:            if (new->iova + new->size <= dma->iova)
> 1060:   dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
> 1233:   if (dma && dma->iova + dma->size != iova + size)
> 1380:           if (dma && dma->iova + dma->size != iova + size)
> 1501:           ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
> 1504:                   vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
> 1721:           while (iova < dma->iova + dma->size) {
> 1743:                           i = iova + size;
> 1744:                           while (i < dma->iova + dma->size &&
> 1754:                           size_t n = dma->iova + dma->size - iova;
> 1785:                   iova += size;
> 1810:           while (iova < dma->iova + dma->size) {
> 1823:                   i = iova + size;
> 1824:                   while (i < dma->iova + dma->size &&
> 2919:           if (range.iova + range.size < range.iova)
> 
> This series spends the first couple commits making mechanical
> preparations before the fix lands in the third commit. Selftests are
> added in the last two commits.
> 
> [1] https://lore.kernel.org/qemu-devel/20250919213515.917111-1-alejandro.j.jimenez@oracle.com/
> [2] https://lore.kernel.org/all/68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com/
> 
> Signed-off-by: Alex Mastro <amastro@fb.com>
> 
> ---
> Changes in v6:
> - Fix nits in selftests
> - Clarify function calls with '()' in commit messages
> - Link to v5: https://lore.kernel.org/r/20251027-fix-unmap-v5-0-4f0fcf8ffb7d@fb.com

Applied to vfio for-linus branch for v6.18.  Thanks!

Alex


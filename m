Return-Path: <kvm+bounces-62100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B55E4C37702
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 20:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3A6B34E6F7F
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 19:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E4B320A3F;
	Wed,  5 Nov 2025 19:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="FKhwSZN9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XLMNZT7P"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9337299AB5
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 19:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762369601; cv=none; b=lCljNWc4DKLahl3EMVl2h4VPsDXv9Mt9NbbmIBird/xDP1eBySV5Qh+zeh69PDPs19bIpFD/YLlVZYb5TtoZMf8SpHpJZfLa4rT7mnB2zA20u7fqDwpMTvaKZKIabdjv0DLd7rF3Htqyf5DAtD1ayZM69/zv/pFnScCQzukjjvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762369601; c=relaxed/simple;
	bh=MBekS82VXAuTjli1bsQTvJsTBmKL9qlic3Kwg7XID4k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hpXkeZxKcLeyFEw5GZgWe+AGOJYwM2vLiJhO1R/C3AeSj0HbUY62QZjdsgitZPZPFmSq6Es54Mb6LJgnFsYWb/yFNjtYr955LbkTZQRQ1prtP2iLUZbt/2aXXJLBW9mxYjHO9UkdtdnhrBcgKQIrZaoDb3gN6K90pIU5azkF8b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=FKhwSZN9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XLMNZT7P; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 01351EC0290;
	Wed,  5 Nov 2025 14:06:37 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 05 Nov 2025 14:06:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762369596;
	 x=1762455996; bh=effwJ3GhBH8MdmmMsCH2KSzUZkLzM1/gHLmaOmoZ3g0=; b=
	FKhwSZN996aLc3XkFmDlvsVKiaNFn83m8Mds2UR9M1djn6LBRot1SrfBtkfZ/+C7
	mdY6EFOR7d4TznWWF4r2YWf8jvWuk8Pr7bddgJPrMtFDEkiqFZ8E11DnfRXD+Z63
	rXwG6Wm769xzWlWww5hTWOw05JyLAkLUnEI34Ntnk9O0QRwda89VLzTe59KAIn/s
	DvsTrgasVIF9Ac0Q6/WOkRoWHRZx44VjOKcUydkh4KT6zUjy7KdO1EiaUaNroGYY
	bh3HXbMGMERkLn3PKn40Rgn7xl6ZSF8UVOZW5lxYMBbQi7csXA20KAZc2TX5BPwv
	yE91y6CLQ2nS6R7IKk+DpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762369596; x=
	1762455996; bh=effwJ3GhBH8MdmmMsCH2KSzUZkLzM1/gHLmaOmoZ3g0=; b=X
	LMNZT7Pe0GjcY2VTtrqliRt2Q44NdEio15CycMbnSOLTBYcaMTiivgydk/14VfbS
	G2yqGnTIJtP/1JY/dqGIQn72HxKEQ2JrvjEeGBBoJw9amRU2Xzef2W5dUDIU8NFX
	exntoMvlH4hMGKD3RKw4o8J/qVp6pyx1MlX9ThJ5qxKjH7U3WuO6kf1n/WaDEWyN
	aV+hH7TwJCdunmyOncoDcke01169rnzn46X86MkqMJhx1LaYADj2wP11RD6KivVo
	0UbkDMw8flAyhVqtyiA59CmvkuJolbtmjs/8xH6/9VvQKef4DO8+cH6H9HcY9+yS
	pffHHLnDwVY0rtT7vRxJw==
X-ME-Sender: <xms:PKALadRGFeJwVVT3_uS_wq5h3MGeaR7NASbGpWQkJ8J0KkArD5B9Qg>
    <xme:PKALaafhknsTznjkqI4fpUspM_MH10-p4Luwd-ZHldZmGXkafiXDng2ER3tNFkzsJ
    T1ehyFk4iXJjo4kdecMF4cfG30agTrNWD3-7t1SLX8FRuu3aqEiqzs>
X-ME-Received: <xmr:PKALacp4_bSNvnn08FSL8pKV85nbH9do5CzaRZGWsPUDckqPD4UP8CN4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeegjedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhephedvtdeuveejudffjeefudfhueefjedvtefgffdtieeiudfhjeejhffhfeeu
    vedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdp
    nhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughmrg
    htlhgrtghksehgohhoghhlvgdrtghomhdprhgtphhtthhopegrlhgvgidrfihilhhlihgr
    mhhsohhnsehrvgguhhgrthdrtghomhdprhgtphhtthhopehjghhgsehnvhhiughirgdrtg
    homhdprhgtphhtthhopehjrhhhihhlkhgvsehgohhoghhlvgdrtghomhdprhgtphhtthho
    pehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhhiphhinhhshh
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:PKALab9ZlzQG2jLORkZvfMhAjMYXWwkwHCqWedkl6HIHU-T-PJDSjA>
    <xmx:PKALaYefnCNjBfOfyQt3XdMxKuGZBy8g_A6yxg7S3rTAYwGPVLIAiQ>
    <xmx:PKALaVJVp5LsdpH39XySSK6qRWZrewhzT_VhoBsLr9r0KHFrxdR3VA>
    <xmx:PKALaYh2h5mekk8sNlpjYGFsFjz-BGobfeLtl9gXrQTb0lCwZEW6pQ>
    <xmx:PKALaV1MLhuL5vJrbZNkL0nbnhslQ_b87_0nVa3adFcA9yHn6JNVyf9U>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Nov 2025 14:06:35 -0500 (EST)
Date: Wed, 5 Nov 2025 12:06:34 -0700
From: Alex Williamson <alex@shazbot.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
 <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
 Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 00/12] vfio: selftests: Support for multi-device tests
Message-ID: <20251105120634.3aca5a6b.alex@shazbot.org>
In-Reply-To: <20251008232531.1152035-1-dmatlack@google.com>
References: <20251008232531.1152035-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Oct 2025 23:25:19 +0000
David Matlack <dmatlack@google.com> wrote:

> This series adds support for tests that use multiple devices, and adds
> one new test, vfio_pci_device_init_perf_test, which measures parallel
> device initialization time to demonstrate the improvement from commit
> e908f58b6beb ("vfio/pci: Separate SR-IOV VF dev_set").
> 
> This series also breaks apart the monolithic vfio_util.h and
> vfio_pci_device.c into separate files, to account for all the new code.
> This required some code motion so the diffstat looks large. The final
> layout is more granular and provides a better separation of the IOMMU
> code from the device code.

Hi David,

This series doesn't apply to mainline currently and I see you have some
self-comments that suggests this is still a WIP, so I'll drop it and
look for a v2.  I believe
https://lore.kernel.org/kvm/20250912222525.2515416-2-dmatlack@google.com/
is still in play though and does apply.  Thanks,

Alex


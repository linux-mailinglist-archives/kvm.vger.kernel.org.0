Return-Path: <kvm+bounces-63075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7A4C5A794
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3338F353040
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D000242AA6;
	Thu, 13 Nov 2025 23:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="FEpkeBXo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vyWCLJmz"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7536A2D73B4;
	Thu, 13 Nov 2025 23:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075320; cv=none; b=WJT/VFM0d5n6QajmAW9FXJSFzXgF4VLdjF6X/yiw3nZYh59aKrX8j77iu7VaMf4mfCGaVLoiMkvs89XwQmtp4dQSn0IKHmXUomTt/6H8CeNJD5XUhC5PAh5MJEGp+upWC7yzHdF+jDLwCJsAb3SfXfG9PtOWQr2F3B/9SUAOD9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075320; c=relaxed/simple;
	bh=8uDsGqET8+NyvFPxGAFe5D3fK58fc0TPIHvDxbbSRwI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=k7PKUcP9Lb5GMGfq7Xu2+0CF9WDcPqibh5BDw+VOm6qXwt9PPHB7e9nIl2ZCVGwRch5HAuQUQWKdrUtNpxYZ6VhdhFkXj0MhgYzwcbcu4u0YBWDmpYZjxsI/92+v1yNFk6A5qf+azyf1Wfw11vux201dNCB/9c/TpS55SFxg/MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=FEpkeBXo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vyWCLJmz; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 871A3EC01CD;
	Thu, 13 Nov 2025 18:08:35 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 13 Nov 2025 18:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1763075315; x=1763161715; bh=2d
	pn2d4/Pb1rJ8t1cOb1bvqpeuXgS2YBECPmGW3t7lQ=; b=FEpkeBXoqkjlWGGvll
	3nWrhJg4yUKdM94QKqx4/iaTMx32gZgXqVah5bmSqHp+gU4gLLMmP00qkP9Rn86h
	1WOjVXUY1Pcj+yZgiho2VhmGBtKivHyT4O9kmcgdX0ArSnxj/ZrmS2mD3LFVSJO6
	rQNbOQg4GtETdyIWDYsQFWgVKV8Igq7tXaQnxwfWgXc1er9NR7fFCm1TcKKxMxJF
	Ch08TfUVSRgXALJyqm5ppYpFatj7Fdvpz1nNQXMi9gajT5ycTTjds1OsrUDPISB9
	sx4tUuJZVJXEpO5JEVEBsgLex4iQO/C5eRreAQg8fEvzjeEJelnMskgKWduZvAbY
	JtHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1763075315; x=1763161715; bh=2dpn2d4/Pb1rJ8t1cOb1bvqpeuXg
	S2YBECPmGW3t7lQ=; b=vyWCLJmzo9VkJ1QDc/FNPcmr8er1evoC6Bktqj9ikpmV
	z0bDlZUzRKf9ocQEO5bUK1mh2q4i/UXXn0342zOAqAJuorRSY0D4uvDA87itc7HV
	nohtKJfuS8lb7TlRIrXBo07ynVdKJWh1h7ebfoVWIf2owwDAUOnJfwaKjmXfXs5w
	soRPFh+AwmAXZj9O9gOsWDIOrh19aLASw7ZuM+mcDIy5DNwApPR6yxJDVgMyITaI
	2aFrTQmrsV9is4GdPvey8zXZaJoFGic15Rm/Wv1bt+WGP/et3hI3itONBhS6wTOW
	tXkV1JeCyFyU0VReu35QutLoPnzXp7CKUX4cqDPxjg==
X-ME-Sender: <xms:8mQWaaY9P5OUiP_XnOSJwox-j5v6p2rOQisaMTiNHBByiS460lb4Bw>
    <xme:8mQWae6N-dGDGhqYxfvHaZ5ZMG9UXFMEnxxUrtoQlOdx9mscqlSu0ktEaSNxRhLx5
    9h-cG3UzXJwcp3JIoc-PBLr6jpjJ1Td7jYRP5sFIgcgVQhJm-j6>
X-ME-Received: <xmr:8mQWaVD_Qg2fp6WnwkRECHySRb2tL00IbfMQci2TQ3G8Fkg43KbskXMG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtdekvdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucghihhl
    lhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrthhtvg
    hrnhepieefgeeileehheeuhefghefhgfehvdfgtdeiffeuhfdvvdekhefhueeuudfffeel
    necuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgs
    pghrtghpthhtohephedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhorhhvrg
    hlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvh
    hmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghmrghsthhrohesfhgs
    rdgtohhmpdhrtghpthhtohepughmrghtlhgrtghksehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:82QWacfupJhwYRSchnqG7eWMDMTy3oxTa4cxiJj-5oMGxQMp5bBH4Q>
    <xmx:82QWacK8bTSYWtNGmaJQlIGZsE-JDaemKP8crFKSVhdha2BEwh4Nsw>
    <xmx:82QWaf3rmCA59KYGdNtsOQ2GQYwfd-oi5D9hr-nAJgN5mC0HZ_E3sg>
    <xmx:82QWaWgjIYG2YIdAsu9-rlGNCLGcaBiqu0DD3en4fEWon9gnJTr_RA>
    <xmx:82QWaQXkXHH5RmtuaLwUjT662hdnD8ibT0YkhlSXQOTGgBjPwkSbHZ4X>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Nov 2025 18:08:34 -0500 (EST)
Date: Thu, 13 Nov 2025 16:08:31 -0700
From: Alex Williamson <alex@shazbot.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Alex Mastro <amastro@fb.com>,
 David Matlack <dmatlack@google.com>
Subject: [GIT PULL] VFIO fixes for v6.18-rc6
Message-ID: <20251113160831.775d61dd.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are a few last fixes for the new vfio selftests for v6.18.  This
hopefully starts us off with a good precedent that the tests will
generally pass by removing some assumptions about the IOMMU address
width.  Thanks,

Alex

The following changes since commit 6146a0f1dfae5d37442a9ddcba012add260bceb0:

  Linux 6.18-rc4 (2025-11-02 11:28:02 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc6

for you to fetch changes up to d323ad739666761646048fca587734f4ae64f2c8:

  vfio: selftests: replace iova=vaddr with allocated iovas (2025-11-12 08:04:42 -0700)

----------------------------------------------------------------
VFIO fixes for v6.18-rc6

 - Fix vfio selftests to remove the expectation that the IOMMU
   supports a 64-bit IOVA space.  These manifest both in the original
   set of tests introduced this development cycle in identity mapping
   the IOVA to buffer virtual address space, as well as the more
   recent boundary testing.  Implement facilities for collecting the
   valid IOVA ranges from the backend, implement a simple IOVA
   allocator, and use the information for determining extents.
   (Alex Mastro)

----------------------------------------------------------------
Alex Mastro (4):
      vfio: selftests: add iova range query helpers
      vfio: selftests: fix map limit tests to use last available iova
      vfio: selftests: add iova allocator
      vfio: selftests: replace iova=vaddr with allocated iovas

 .../testing/selftests/vfio/lib/include/vfio_util.h |  19 +-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 246 ++++++++++++++++++++-
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |  20 +-
 .../testing/selftests/vfio/vfio_pci_driver_test.c  |  12 +-
 4 files changed, 288 insertions(+), 9 deletions(-)


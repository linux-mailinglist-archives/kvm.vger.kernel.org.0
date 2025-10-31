Return-Path: <kvm+bounces-61728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B084C26E05
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 21:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F23223A8979
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 20:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A0A328619;
	Fri, 31 Oct 2025 20:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="RhUgj4wm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OQxt5+1i"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3AE18BC3D;
	Fri, 31 Oct 2025 20:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761941875; cv=none; b=fE8KbZCvIJG2ZJyR7j8wUUB9wUnu1ShZA+tHsg6IOuxzJlHRIUjMsPcpNcZmIcJ1bTXb8UUXH0xD8lAYX/SQgaGb0yCMSCcuvlC2uCAnkojS9zqawzWNEKVQHEXm2LANN2LUuwgR6YVUGknC89u0xbbKYHOEftwvFSxqnuexa7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761941875; c=relaxed/simple;
	bh=Bz0yzeZQKrfsxOHq72XZfOEz//gtiTMA6VjTcyy/jws=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=QN4GmGnXiNyf3vJVr59vzlh93OVr15pY1dIYI6shaxS8ts7GHJfba1v+QVYgrEffUSc9fEE6OnKhN2AU6LKanxm4yVdKkGu3+W7KocqTLMAt4hYmqETbTLZDldUiOQEB1DbjN5cIvnvwxD5sqlGLIOJFqg/nIJM+rxDbQ4GMA2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=RhUgj4wm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OQxt5+1i; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 976F0EC016E;
	Fri, 31 Oct 2025 16:17:50 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 31 Oct 2025 16:17:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1761941870; x=1762028270; bh=Ld
	g6f8Dfob7yJj01FzUu/RFUP9hmk1XczWYXSzoAcQM=; b=RhUgj4wmFcK0UZmYnz
	NOvr7fBdUMUiophWN8d3w+DmE3QlpQCPDM1TO347k9o9Vg4p70KwFF8TQ45/QJer
	nGl8ySlsiPjjqAAq0bRxEfJi/3AxKqPld3dDWvXOnVomvE79x1WJwnj+ePcYPiU8
	l4yNTaGEVQ8VNWBR3w6ERb/MOuvp/wU7RlwWLBK+zJNnDvrbqyogFKJ+IqBP+Zhy
	NgxcYqnlFhIfL6A0hDMq/IJj8K+3dKQt6jZUMNR7LEcEqpgl4Cy4gGcQV4+iV/fb
	Y+Y2wgUQNSOwZEWBx/Wft84Pvd/AWOYBeqEffXK/xUWAhjQ+m/S1l6MqSaYCkNeG
	2MYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1761941870; x=1762028270; bh=Ldg6f8Dfob7yJj01FzUu/RFUP9hm
	k1XczWYXSzoAcQM=; b=OQxt5+1i0PpxQb82WU6e6cv64I+6BXz7Exeu1MRtXRG2
	XTZBG7ei/q2IERboR+Fm6ecQp0/bnpmr/h+alHZb5K38m3c6Uf81yCvlMyfnu4Zi
	fWop9zpjts6m4Pg2wVU3jEBAA6YEJUDigv+qdaMY4Omi3AgUJGeRE53NoCKUwPIl
	IWCj/Rt5CkrseT/fTTfKjVHTBm/VjQNSCo/cr3l23NWYPe6gbi9pJDS8hpJ04hiY
	j6Ucw3L4PIMvhKRefodn+9ypgbOBQO8jf7p1icv9831Ei29AiJ1xzOUs6YdbfAI3
	mWV2q2VFmKOXzGiArn7qS+EYdPfFSVhoJsgg9T4ixg==
X-ME-Sender: <xms:bhkFaeGmv_2HIPfzz6iwGPs2r2km3agAG99mCvHxpOUfrJ91s4-JSw>
    <xme:bhkFadJBFAknOkM8f3sj1XaHtui5SHki81m8VwqBtJwgMW8PLNaZam2Rn4u9wmIb7
    pVZhdjmRQAFQwjC2SUoUB7HgfNzQxHqZU5Az3-rHCqcM2Fi4Jwv>
X-ME-Received: <xmr:bhkFaSnom4eEdsw6DmkBfA-3KWZfakaGX3ZDHjup4dJ4dZLGrA05dBnoQLs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujedtgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucghihhl
    lhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrthhtvg
    hrnhepieefgeeileehheeuhefghefhgfehvdfgtdeiffeuhfdvvdekhefhueeuudfffeel
    necuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgs
    pghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhorhhvrg
    hlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehkvhhm
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvg
    hlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghmrghsthhrohesfhgs
    rdgtohhm
X-ME-Proxy: <xmx:bhkFaVT9WLIe-tXb2qXfJ3qlsG5eGCzu7eLHW__THJ6THLeRJK_IEA>
    <xmx:bhkFaUJo2MwMx_QEblqPDTMJr1tV_FaqIxtqfoiq4AyZZxVThfkvzQ>
    <xmx:bhkFabCW1BmWvCJXbmRAJjNDjZFFU6Zxaoe2q9HRQUG2j6hJexOKng>
    <xmx:bhkFadDbOCyYHwPkBwzU_OOWaQpNWsF33Dr-Mcn82saPsdg7uqkO0Q>
    <xmx:bhkFaVUhBt_jq2iVeG1qV9gAY6MU9P38Y57m5VQHwpu_pHiJKbPtExTB>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Oct 2025 16:17:49 -0400 (EDT)
Date: Fri, 31 Oct 2025 14:17:47 -0600
From: Alex Williamson <alex@shazbot.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, amastro@fb.com
Subject: [GIT PULL] VFIO update for v6.18-rc4
Message-ID: <20251031141747.1fd01a0a@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa:

  Linux 6.18-rc3 (2025-10-26 15:59:49 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc4

for you to fetch changes up to de8d1f2fd5a510bf2c1c25b84e1a718a0f0af105:

  vfio: selftests: add end of address space DMA map/unmap tests (2025-10-28 15:54:41 -0600)

----------------------------------------------------------------
VFIO update for v6.18-rc4

 - Fix overflows in vfio type1 backend for mappings at the end of the
   64-bit address space, resulting in leaked pinned memory.  New
   selftest support included to avoid such issues in the future.
   (Alex Mastro)

----------------------------------------------------------------
Alex Mastro (5):
      vfio/type1: sanitize for overflow using check_*_overflow()
      vfio/type1: move iova increment to unmap_unpin_*() caller
      vfio/type1: handle DMA map/unmap up to the addressable limit
      vfio: selftests: update DMA map/unmap helpers to support more test kinds
      vfio: selftests: add end of address space DMA map/unmap tests

 drivers/vfio/vfio_iommu_type1.c                     | 173 +++++++++++++--------
 .../testing/selftests/vfio/lib/include/vfio_util.h  |  27 +++-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c  | 104 ++++++++++---
 .../testing/selftests/vfio/vfio_dma_mapping_test.c  |  95 ++++++++++-
 4 files changed, 308 insertions(+), 91 deletions(-)


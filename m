Return-Path: <kvm+bounces-71011-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yAbWIwdDjml3BQEAu9opvQ
	(envelope-from <kvm+bounces-71011-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:15:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E5AA01312C6
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:15:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2503230AD96D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 21:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FF132A3CA;
	Thu, 12 Feb 2026 21:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="FGf2AskK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MihaTIo1"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBEA824BD;
	Thu, 12 Feb 2026 21:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770930933; cv=none; b=G8m2EHMNC7y4phl7T55sKpbCP2TaXDIh4RGyvIESOq6+K09YB4GEO0FQR5oMbymlUbDFjc4ctBbqc9rxHLsFBoDPQOXDRdZPxarAZlGhRWuEcaluuHpnS9O9KQFBgUez3u8O6x7PqsPpzRuTlg9lz2tG1QSfVlPNPM9Mfw6ONzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770930933; c=relaxed/simple;
	bh=awRmJUhm3LZD9fm8qk4fOW9xobZ5JROHppBnXcabENA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=fYx2SNgSA+gtvtWqL6fkjV5o7NzUjweyHyaoDwtxHxP9oMBrtMAJ6/avuLY5V0ozo5hx2b6C4398q31UEgwfe14utwqwgXwlTqImaGDLtPcVt2S1gMNZaQzjBWDTF76H0G/o7kjRypTqlFlRsVOpcGhg0jmiRfBH+vrTp6Q4/04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=FGf2AskK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MihaTIo1; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6178A7A015B;
	Thu, 12 Feb 2026 16:15:29 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 12 Feb 2026 16:15:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1770930928; x=1771017328; bh=y6
	B0EEGW3ls4a1sYyBBKoZwIvRi3Sv9pnh1nPSmAZj8=; b=FGf2AskKPYr7cWzQkE
	IPeJmiZ3af1BSERwHRapc0pwAZ9TtuRnds1rLNihgmTvsF3x+dQ/joDmY3iSVQMV
	wFO5AahA+YeIJYQDae0CRSFvgQxJZv3H4t1Ge68CWG8CQ4oiMo3mRuau0kBVWp6P
	fGUcxXUUVFS1IFs+MgGTfiJF7Ayplp9Q5qc3uOz1ZB5ev8FzhfrEiQt3N10nfua8
	0Dx0spQzAHngCCeGK2iOo3Hizxko4Ge17/MP4trs+foYw1Jl3Akd7zzbvzASS/RG
	zI8xxpOv/CvD2iTrJh9UzlOz6Vcz4zUqLjDF4avDge3w2cxSrjwL7ujDI7gyW80s
	u6oQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1770930928; x=1771017328; bh=y6B0EEGW3ls4a1sYyBBKoZwIvRi3
	Sv9pnh1nPSmAZj8=; b=MihaTIo10t9zmVwA4UrXWSSH5z9nma11f5sOk6WPwHaE
	41EiGwhc2Ob+KMHw7Dg5BawcQ1lFkQcqjGezDKpCp6/4euUROdoMIqF/z+qEgNIn
	sObmYVesVQ0ja1ra+uBM1yg32CDNABLSMO3tjlTf4TrHNs1X3fMkogZHr/qb/IGq
	pIbvHRvU9OZXVmaPNHWzVPFNQQOrAZJ9oEJHnVsOW7cInp5mlhxt7ylcCAvhpA/o
	+l9kBq60xM3S0uO4f7akPohDHKbG+BnEhrqqKgEmDxQqFhJobux0NJ/Rg8gWxk8O
	uv96cp50pWXMXeZGiaNITGxkauiinR4kOVNdTseULQ==
X-ME-Sender: <xms:70KOadJG8i8L_2y2gSiNJWYCEridPmsfLqqs11fXSxEQYsNKx91aPA>
    <xme:70KOaW_hgFQYJ4InCsRiK8qJrVRIrPK_JY5ApbloKik41sQtgeJH_lOuzpYP91UUq
    ge7NkCKIF6jkQng5-yFvLeEJ6UwIRVtC2MkuOMfHrOI-oB-AG5yDxU>
X-ME-Received: <xmr:70KOaQLs_oa8I8IIimfPZ1OqLJ0szUuX8dkxI6vFnQdpi9MEhBbwsKOtCvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdeigedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicuhghi
    lhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrghtth
    gvrhhnpeefuddtvdefhfevtefffeejhfevudekiedtteevkedujefggfeuueeuieehgedu
    vdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhh
    rgiisghothdrohhrghdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpd
    hrtghpthhtoheprghlvgigsehshhgriigsohhtrdhorhhgpdhrtghpthhtohepthhorhhv
    rghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehk
    vhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:70KOabmWAh_wdxrMk9T9tJmizYaRg79lv98nOYOJkIq4ETwk_7NK5g>
    <xmx:70KOaUN2-28_lTYlPXWWEMIEAv9kv_mdv2sqeTfw_jdS1Swc4XNMKA>
    <xmx:70KOaR1zQtXrXsWr-jVaL0xMXk9U4EYNAyKHMLJVUgdslxA1F6aRtQ>
    <xmx:70KOaTmkhWiIaDEBENsGCrfxRnowMFucd-zHqD1ILuyBqxWiO1CB_A>
    <xmx:8EKOaeua9mkGF9juuZTUrIUk4fN1T79GAU8U8UjyYl5PTX4RmL4AYIjs>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Feb 2026 16:15:27 -0500 (EST)
Date: Thu, 12 Feb 2026 14:15:25 -0700
From: Alex Williamson <alex@shazbot.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: alex@shazbot.org, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v7.0-rc1
Message-ID: <20260212141525.6974025b@shazbot.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm2,messagingengine.com:s=fm3];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71011-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E5AA01312C6
X-Rspamd-Action: no action

Hi Linus,

There are a couple unusual block file changes here that come via a
shared branch from Jens[1].  Otherwise a small cycle with the bulk in
selftests and reintroducing poison handling in the nvgrace-gpu driver.
The rest are fixes, cleanups, and some dmabuf structure consolidation.
Thanks,

Alex

[1]https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=
=3Dfor-7.0/blk-pvec

The following changes since commit 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7:

  Linux 6.19-rc6 (2026-01-18 15:42:45 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v7.0-rc1

for you to fetch changes up to 96ca4caf9066f5ebd35b561a521af588a8eb0215:

  vfio/fsl-mc: add myself as maintainer (2026-02-06 15:08:06 -0700)

----------------------------------------------------------------
VFIO updates for v7.0-rc1

 - Update outdated mdev comment referencing the renamed
   mdev_type_add() function. (Julia Lawall)

 - Introduce selftest support for IOMMU mapping of PCI MMIO BARs.
   (Alex Mastro)

 - Relax selftest assertion relative to differences in huge page
   handling between legacy (v1) TYPE1 IOMMU mapping behavior and
   the compatibility mode supported by IOMMUFD. (David Matlack)

 - Reintroduce memory poison handling support for non-struct-page-
   backed memory in the nvgrace-gpu variant driver. (Ankit Agrawal)

 - Replace dma_buf_phys_vec with phys_vec to avoid duplicate
   structure and semantics. (Leon Romanovsky)

 - Add missing upstream bridge locking across PCI function reset,
   resolving an assertion failure when secondary bus reset is used
   to provide that reset. (Anthony Pighin)

 - Fixes to hisi_acc vfio-pci variant driver to resolve corner case
   issues related to resets, repeated migration, and error injection
   scenarios. (Longfang Liu, Weili Qian)

 - Restrict vfio selftest builds to arm64 and x86_64, resolving
   compiler warnings on 32-bit archs. (Ted Logan)

 - Un-deprecate the fsl-mc vfio bus driver as a new maintainer has
   stepped up. (Ioana Ciornei)

----------------------------------------------------------------
Alex Mastro (3):
      vfio: selftests: Centralize IOMMU mode name definitions
      vfio: selftests: Align BAR mmaps for efficient IOMMU mapping
      vfio: selftests: Add vfio_dma_mapping_mmio_test

Alex Williamson (1):
      Merge tag 'common_phys_vec_via_vfio' into v6.20/vfio/next

Ankit Agrawal (2):
      mm: add stubs for PFNMAP memory failure registration functions
      vfio/nvgrace-gpu: register device memory for poison handling

Anthony Pighin (Nokia) (1):
      vfio/pci: Lock upstream bridge for vfio_pci_core_disable()

David Matlack (1):
      vfio: selftests: Drop IOMMU mapping size assertions for VFIO_TYPE1_IO=
MMU

Ioana Ciornei (1):
      vfio/fsl-mc: add myself as maintainer

Julia Lawall (1):
      vfio/mdev: update outdated comment

Leon Romanovsky (1):
      types: reuse common phys_vec type instead of DMABUF open=E2=80=91code=
d variant

Longfang Liu (3):
      hisi_acc_vfio_pci: update status after RAS error
      hisi_acc_vfio_pci: resolve duplicate migration states
      hisi_acc_vfio_pci: fix the queue parameter anomaly issue

Ted Logan (1):
      vfio: selftests: only build tests on arm64 and x86_64

Weili Qian (1):
      hisi_acc_vfio_pci: fix VF reset timeout issue

 MAINTAINERS                                        |   3 +-
 block/blk-mq-dma.c                                 |  11 +-
 drivers/dma-buf/dma-buf-mapping.c                  |   6 +-
 drivers/iommu/iommufd/io_pagetable.h               |   2 +-
 drivers/iommu/iommufd/iommufd_private.h            |   5 +-
 drivers/iommu/iommufd/pages.c                      |   4 +-
 drivers/iommu/iommufd/selftest.c                   |   2 +-
 drivers/nvme/host/pci.c                            |   4 +-
 drivers/vfio/fsl-mc/Kconfig                        |   5 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |   2 -
 drivers/vfio/mdev/mdev_sysfs.c                     |   2 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |  30 ++++-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h     |   2 +
 drivers/vfio/pci/nvgrace-gpu/main.c                | 115 ++++++++++++++++-
 drivers/vfio/pci/vfio_pci_core.c                   |  17 ++-
 drivers/vfio/pci/vfio_pci_dmabuf.c                 |   8 +-
 include/linux/dma-buf-mapping.h                    |   2 +-
 include/linux/dma-buf.h                            |  10 --
 include/linux/memory-failure.h                     |  13 +-
 include/linux/types.h                              |   5 +
 include/linux/vfio_pci_core.h                      |  13 +-
 tools/testing/selftests/vfio/Makefile              |  10 ++
 tools/testing/selftests/vfio/lib/include/libvfio.h |   9 ++
 .../selftests/vfio/lib/include/libvfio/iommu.h     |   6 +
 tools/testing/selftests/vfio/lib/iommu.c           |  12 +-
 tools/testing/selftests/vfio/lib/libvfio.c         |  25 ++++
 tools/testing/selftests/vfio/lib/vfio_pci_device.c |  24 +++-
 .../selftests/vfio/vfio_dma_mapping_mmio_test.c    | 143 +++++++++++++++++=
++++
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |   8 +-
 29 files changed, 423 insertions(+), 75 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test=
.c


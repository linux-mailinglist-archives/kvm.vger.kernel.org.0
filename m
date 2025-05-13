Return-Path: <kvm+bounces-46341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE681AB5329
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE2101895B91
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8730227EC76;
	Tue, 13 May 2025 10:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sTbryI3X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2E627E7E1
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747133301; cv=none; b=PwSmPSjXedofnWLEdQGDWEi0FTLwKd3kYHK/bEL8AVvGYv5P8RvJPKyHsjsBYYhZffr9DNqorjyBbTrVAzxecwHXL//ekkElu+9luOYhBHYAMWlDaH5d64K4TqPj5yM8gW5+QjMujxhAQA/qfPtDusG9+opnftR1/mGLC9YUmX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747133301; c=relaxed/simple;
	bh=JPjFjZhSy+BMwg8kEBhG+DnC/ysEhCd6NzAEhbQ4liA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WXHwTHZCy/DPnaMcoDqbVMOR51IPcftw+F+7gGSvLz3Alp7dd8w+KR8lEM+Vmjk0ucqn4jfbZEXv7FxDXjJ+DKgZAh/KxrC843s5sPtOYhjfNVuN3Om6VJBkhMm8D+gz0WFZXPWFUleMDcoce5WCOg8132kfyabQ8yUz+QW1MFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sTbryI3X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA2AC4CEEB;
	Tue, 13 May 2025 10:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747133301;
	bh=JPjFjZhSy+BMwg8kEBhG+DnC/ysEhCd6NzAEhbQ4liA=;
	h=From:To:Cc:Subject:Date:From;
	b=sTbryI3X0qn+cqI44N1ljPBKNu86qJHSmF4fHCSUMOvtKygPSUvBeSYbo4ouxYqzV
	 ytWISeN8scxJQyN+6SUDtbivIZyu+XJQAjzhBVkCXR0nuHB5rfQeVq30qrLI86EWC8
	 Dy6NIMa9a83sfz8camm6Mmmm7sLhd5Heh1Bm5j+nJmxmPSJZweJ64CsR03eap6KYE6
	 pcNTASory8LU+CfdurCPmNY/Yyf0uLWSIiUt8R6U1rTYonUBGCZVMo5EdCaoFfemuo
	 Ro6kiZJO39P/IQOBPGqHw+bPnQKqHBc8JLQMHJs0s360I9aE+2NkBWt+YXKUaOoCyg
	 RZvAIpv4IJxoA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	kvm@vger.kernel.org,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [GIT PULL] Please pull mlx5 VFIO PCI DMA conversion
Date: Tue, 13 May 2025 13:48:10 +0300
Message-ID: <20250513104811.265533-1-leon@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Alex,

Please accept this pull request, which presents subset of new DMA-API
patchset [1] specific for VFIO subsystem.

It is based on Marek's dma-mapping-for-6.16-two-step-api branch, so merging
now will allow us to reduce possible rebase errors in mlx5 vfio code and give
enough time to start to work on second driver conversion. Such conversion will
allow us to generalize the API for VFIO kernel drivers, in similiar way that
was done for RDMA, HMM and block layers.

Thanks

[1] [PATCH v10 00/24] Provide a new two step DMA mapping API
https://lore.kernel.org/all/cover.1745831017.git.leon@kernel.org/

----------------------------------------------------------------
The following changes since commit 3ee7d9496342246f4353716f6bbf64c945ff6e2d:

  docs: core-api: document the IOVA-based API (2025-05-06 08:36:54 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/vfio-dma-two-step

for you to fetch changes up to 855c89a25e1756b7699b863afd4d6afcbd0de0d6:

  vfio/mlx5: Enable the DMA link API (2025-05-13 03:58:27 -0400)

----------------------------------------------------------------
Convert mlx5 VFIO PCI driver to new two step DMA API

This PR is based on newly accepted DMA API, which allows us
to avoid building scatter-gather lists just to batch mapping
and unmapping of pages.

VFIO PCI live migration code is building a very large "page list"
for the device. Instead of allocating a scatter list entry per
allocated page it can just allocate an array of 'struct page *',
saving a large amount of memory.

Signed-off-by: Leon Romanovsky <leon@kernel.org>

----------------------------------------------------------------
Leon Romanovsky (3):
      vfio/mlx5: Explicitly use number of pages instead of allocated length
      vfio/mlx5: Rewrite create mkey flow to allow better code reuse
      vfio/mlx5: Enable the DMA link API

 drivers/vfio/pci/mlx5/cmd.c  | 375 +++++++++++++++++++++----------------------
 drivers/vfio/pci/mlx5/cmd.h  |  35 ++--
 drivers/vfio/pci/mlx5/main.c |  87 +++++-----
 3 files changed, 239 insertions(+), 258 deletions(-)


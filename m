Return-Path: <kvm+bounces-68444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DBDA3D396F1
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 15:17:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8ADA730074AB
	for <lists+kvm@lfdr.de>; Sun, 18 Jan 2026 14:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7749E33508B;
	Sun, 18 Jan 2026 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJbr+/P+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0223723C4FD;
	Sun, 18 Jan 2026 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768745806; cv=none; b=vDisPyR6cOwvXVe83DAtsbEV6rkjDDong5tqDyjsQUbKYMQpDNtpoXDDXyHMWTcjFXHKucrEFRkq4A/a+1Mhd1qK9RwM6MJFqs6UFvrfzqLQ3YXSeA+BnGm7E2sPYNAikJp4lK6z3HFpBkmwCcL0++Ji4wIXk2y4oQAjx3TJXLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768745806; c=relaxed/simple;
	bh=UudtuDq34MYJqWXnxCgj7hLDUtpJxnIbpapqDIrG7M8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=empfCv4QnpTFFLIcNYzOxa8+ZZmZuRbWDmPdWOqixCqzDqmhpbM2KFdzQnl6ZXBpEQ2SPglg0gH5gE3o6qRFUtf3I4kfjlFYgghvgVoV00MeiWOiWDlf903jXsu9qYyQPVw2p23uFNtoXoxFvdlfC7nlDCr72/+zFOaH+14GBek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJbr+/P+; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768745805; x=1800281805;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=UudtuDq34MYJqWXnxCgj7hLDUtpJxnIbpapqDIrG7M8=;
  b=gJbr+/P+MKHPZ+tCx6H9X5e2RxJAHi3CMH/0d98U3N9fSxupLpY1QeHk
   nhTtMSlFMBM2s6+wxdRTnK1q1Wm/5sDwBDci7YgKYPHic+ePCdk1Ei+TY
   ZK5ruH5VRkpUsPN2LZTR6CDPWygkzubawuZvsFkGCKVpLOTua1J4UkAQ6
   amx34nH8NyNv5S9OwfFzHi56quMtC3ROjMXF5Y6GpVCNlYpZG+Uix2eTa
   1oL97e7laPoCuL4s6yGf+t6kDk90o0YXElzHKKC0vznw/Kwri9Gm5VIVJ
   Bi9XUwmPuKzgU027EKzo/ub4YuiKUk2h3UkNfGoSORJrY4SbSFh09Q+wt
   Q==;
X-CSE-ConnectionGUID: cxlFMF7aRQ+Wjs/HIc2ppw==
X-CSE-MsgGUID: lwoC0vpySvyi0QR4zUsjWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="80279019"
X-IronPort-AV: E=Sophos;i="6.21,235,1763452800"; 
   d="scan'208";a="80279019"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 06:16:44 -0800
X-CSE-ConnectionGUID: uEuCMJyAT1SPhq5oFgFZ9A==
X-CSE-MsgGUID: YCbX+3UhScWByywIYHhhTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,235,1763452800"; 
   d="scan'208";a="205264188"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO [10.245.244.5]) ([10.245.244.5])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 06:16:38 -0800
Message-ID: <f115c91bbc9c6087d8b32917b9e24e3363a91f33.camel@linux.intel.com>
Subject: Re: [PATCH v2 0/4] dma-buf: document revoke mechanism to invalidate
 shared buffers
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Leon Romanovsky <leon@kernel.org>, Sumit Semwal
 <sumit.semwal@linaro.org>,  Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, Alex Deucher <alexander.deucher@amd.com>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Gerd Hoffmann
 <kraxel@redhat.com>,  Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu	
 <olvaffe@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
  Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Lucas De Marchi	 <lucas.demarchi@intel.com>, Rodrigo
 Vivi <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
 <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
 <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Alex Williamson
 <alex@shazbot.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev, 
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org
Date: Sun, 18 Jan 2026 15:16:25 +0100
In-Reply-To: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi, Leon,

On Sun, 2026-01-18 at 14:08 +0200, Leon Romanovsky wrote:
> Changelog:
> v2:
> =C2=A0* Changed series to document the revoke semantics instead of
> =C2=A0=C2=A0 implementing it.
> v1:
> https://patch.msgid.link/20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.=
com
>=20
> ---------------------------------------------------------------------
> ----
> This series documents a dma-buf =E2=80=9Crevoke=E2=80=9D mechanism: to al=
low a dma-
> buf
> exporter to explicitly invalidate (=E2=80=9Ckill=E2=80=9D) a shared buffe=
r after it
> has
> been distributed to importers, so that further CPU and device access
> is
> prevented and importers reliably observe failure.
>=20
> The change in this series is to properly document and use existing
> core
> =E2=80=9Crevoked=E2=80=9D state on the dma-buf object and a corresponding=
 exporter-
> triggered
> revoke operation. Once a dma-buf is revoked, new access paths are
> blocked so
> that attempts to DMA-map, vmap, or mmap the buffer fail in a
> consistent way.

This sounds like it does not match how many GPU-drivers use the
move_notify() callback.

move_notify() would typically invalidate any device maps and any
asynchronous part of that invalidation would be complete when the dma-
buf's reservation object becomes idle WRT DMA_RESV_USAGE_BOOKKEEP
fences.

However, the importer could, after obtaining the resv lock, obtain a
new map using dma_buf_map_attachment(), and I'd assume the CPU maps
work in the same way, I.E. move_notify() does not *permanently* revoke
importer access.

/Thomas


>=20
> Thanks
>=20
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: linux-kernel@vger.kernel.org
> Cc: amd-gfx@lists.freedesktop.org
> Cc: virtualization@lists.linux.dev
> Cc: intel-xe@lists.freedesktop.org
> Cc: linux-rdma@vger.kernel.org
> Cc: iommu@lists.linux.dev
> Cc: kvm@vger.kernel.org
> To: Sumit Semwal <sumit.semwal@linaro.org>
> To: Christian K=C3=B6nig <christian.koenig@amd.com>
> To: Alex Deucher <alexander.deucher@amd.com>
> To: David Airlie <airlied@gmail.com>
> To: Simona Vetter <simona@ffwll.ch>
> To: Gerd Hoffmann <kraxel@redhat.com>
> To: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> To: Gurchetan Singh <gurchetansingh@chromium.org>
> To: Chia-I Wu <olvaffe@gmail.com>
> To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> To: Maxime Ripard <mripard@kernel.org>
> To: Thomas Zimmermann <tzimmermann@suse.de>
> To: Lucas De Marchi <lucas.demarchi@intel.com>
> To: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> To: Rodrigo Vivi <rodrigo.vivi@intel.com>
> To: Jason Gunthorpe <jgg@ziepe.ca>
> To: Leon Romanovsky <leon@kernel.org>
> To: Kevin Tian <kevin.tian@intel.com>
> To: Joerg Roedel <joro@8bytes.org>
> To: Will Deacon <will@kernel.org>
> To: Robin Murphy <robin.murphy@arm.com>
> To: Alex Williamson <alex@shazbot.org>
>=20
> ---
> Leon Romanovsky (4):
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dma-buf: Rename .move_notify() callback to=
 a clearer identifier
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dma-buf: Document revoke semantics
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iommufd: Require DMABUF revoke semantics
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vfio: Add pinned interface to perform revo=
ke semantics
>=20
> =C2=A0drivers/dma-buf/dma-buf.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
6 +++---
> =C2=A0drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c |=C2=A0 4 ++--
> =C2=A0drivers/gpu/drm/virtio/virtgpu_prime.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 2 +-
> =C2=A0drivers/gpu/drm/xe/tests/xe_dma_buf.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 6 +++---
> =C2=A0drivers/gpu/drm/xe/xe_dma_buf.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0drivers/infiniband/core/umem_dmabuf.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 4 ++--
> =C2=A0drivers/infiniband/hw/mlx5/mr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0drivers/iommu/iommufd/pages.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 +++++++++--
> =C2=A0drivers/vfio/pci/vfio_pci_dmabuf.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 16 ++++++++++++++++
> =C2=A0include/linux/dma-buf.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 25
> ++++++++++++++++++++++---
> =C2=A010 files changed, 60 insertions(+), 18 deletions(-)
> ---
> base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
> change-id: 20251221-dmabuf-revoke-b90ef16e4236
>=20
> Best regards,
> --=C2=A0=20
> Leon Romanovsky <leonro@nvidia.com>
>=20



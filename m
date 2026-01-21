Return-Path: <kvm+bounces-68694-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6GUZB8+fcGlyYgAAu9opvQ
	(envelope-from <kvm+bounces-68694-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:43:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A0F37549C3
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3E7C38A0C82
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C701B3A1CFC;
	Wed, 21 Jan 2026 09:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FSyJ3XAB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7061423A8A;
	Wed, 21 Jan 2026 09:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768988193; cv=none; b=rrBREvZlqnVdeL91J2rPYukXigSaWSkKjLPVbNR+9QpDseEPFMD1oxNzVhZc15QdhMZ0ReDu2eLp54GQbIr69Cn5NiAelTmuXcEYWkfhxUievtIVmQXF8XYtr8zEji0totT/dLfL2djOkT32IgPVJicmyp1DT9CAvi0q+HUjYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768988193; c=relaxed/simple;
	bh=qL9iu/H5hpUrP/X6+ggfEAqN7pCzi7K6vLcfE1tY/YA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QuMmbgvBSplIwaHBmYOhCah9o6mbgs0+4sM12+qf8KZVl+QWC0VqjoW28tDsF9Z0URh373txQLnwWDhU7nW++w91wz7XHyAl9X6j71ceX12LCXsDldf/qUiOKYp7p83+F5yOiZA1R2drugTRp1Obep5AFJ0zCTjCAhf1IXZDLMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FSyJ3XAB; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768988193; x=1800524193;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=qL9iu/H5hpUrP/X6+ggfEAqN7pCzi7K6vLcfE1tY/YA=;
  b=FSyJ3XABb80ljOMJ/9cIeF4UIV7Wc08X14kjDXKRuftGTzDNK8Y4X2XU
   0G8v+Lw7k+ZdcnX6uh1X7aps7oAyREQK69o1aniGj9cRsYwPO2P0zaguP
   J189q6oXW3mck9vrMwe9CwMB9R9XKgVcwOCqu9AeJry6dK+w5Ibi+Bnys
   u9iZifGC4W9P4rKzsOERVWoduqxsEuWQ78b0Tpf71xlU6pRr2PFjTFnnD
   5VxsGpsG1zJ+h8CcG7nf0h7SGz2ghRvCFZbWe2/TaBNJY6w/Au5by0s1R
   B8kqxDw4x3eTiRlWWGK9sy3nJ/c2RvADXVd5KxfiZ6fN667wW1sCN1uht
   w==;
X-CSE-ConnectionGUID: MtkL4GoCR0iUSVgX+NMF+A==
X-CSE-MsgGUID: R92cg/2mTz+dZvIX24XR6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="87624107"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="87624107"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 01:36:32 -0800
X-CSE-ConnectionGUID: 60Hy4B3ETOyz27yzkkUGrg==
X-CSE-MsgGUID: Cg2+ahF4Sdui1FjdHXerRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206639396"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO [10.245.245.107]) ([10.245.245.107])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 01:36:24 -0800
Message-ID: <107464758df9444a465a3a9e387f5a42827aff51.camel@linux.intel.com>
Subject: Re: [PATCH v3 6/7] vfio: Wait for dma-buf invalidation to complete
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Leon
 Romanovsky <leon@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>, Alex
 Deucher	 <alexander.deucher@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter	 <simona@ffwll.ch>, Gerd Hoffmann <kraxel@redhat.com>, Dmitry
 Osipenko	 <dmitry.osipenko@collabora.com>, Gurchetan Singh
 <gurchetansingh@chromium.org>,  Chia-I Wu <olvaffe@gmail.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard	
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Lucas De
 Marchi	 <lucas.demarchi@intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Joerg
 Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy
 <robin.murphy@arm.com>, Felix Kuehling	 <Felix.Kuehling@amd.com>, Alex
 Williamson <alex@shazbot.org>, Ankit Agrawal	 <ankita@nvidia.com>, Vivek
 Kasireddy <vivek.kasireddy@intel.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev, 
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org
Date: Wed, 21 Jan 2026 10:36:09 +0100
In-Reply-To: <b129f0c1-b61e-4efb-9e25-d8cdadaca1b3@amd.com>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
	 <20260120-dmabuf-revoke-v3-6-b7e0b07b8214@nvidia.com>
	 <b129f0c1-b61e-4efb-9e25-d8cdadaca1b3@amd.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68694-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[amd.com,kernel.org,linaro.org,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.hellstrom@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,intel.com:dkim,amd.com:email,nvidia.com:email]
X-Rspamd-Queue-Id: A0F37549C3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi, Christian,

On Wed, 2026-01-21 at 10:20 +0100, Christian K=C3=B6nig wrote:
> On 1/20/26 15:07, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> >=20
> > dma-buf invalidation is performed asynchronously by hardware, so
> > VFIO must
> > wait until all affected objects have been fully invalidated.
> >=20
> > Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO
> > regions")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>=20
> Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com>
>=20
> Please also keep in mind that the while this wait for all fences for
> correctness you also need to keep the mapping valid until
> dma_buf_unmap_attachment() was called.

I'm wondering shouldn't we require DMA_RESV_USAGE_BOOKKEEP here, as
*any* unsignaled fence could indicate access through the map?

/Thomas

>=20
> In other words you can only redirect the DMA-addresses previously
> given out into nirvana (or a dummy memory or similar), but you still
> need to avoid re-using them for something else.
>=20
> Regards,
> Christian.
>=20
> > ---
> > =C2=A0drivers/vfio/pci/vfio_pci_dmabuf.c | 5 +++++
> > =C2=A01 file changed, 5 insertions(+)
> >=20
> > diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c
> > b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > index d4d0f7d08c53..33bc6a1909dd 100644
> > --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> > +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > @@ -321,6 +321,9 @@ void vfio_pci_dma_buf_move(struct
> > vfio_pci_core_device *vdev, bool revoked)
> > =C2=A0			dma_resv_lock(priv->dmabuf->resv, NULL);
> > =C2=A0			priv->revoked =3D revoked;
> > =C2=A0			dma_buf_move_notify(priv->dmabuf);
> > +			dma_resv_wait_timeout(priv->dmabuf->resv,
> > +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > DMA_RESV_USAGE_KERNEL, false,
> > +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > MAX_SCHEDULE_TIMEOUT);
> > =C2=A0			dma_resv_unlock(priv->dmabuf->resv);
> > =C2=A0		}
> > =C2=A0		fput(priv->dmabuf->file);
> > @@ -342,6 +345,8 @@ void vfio_pci_dma_buf_cleanup(struct
> > vfio_pci_core_device *vdev)
> > =C2=A0		priv->vdev =3D NULL;
> > =C2=A0		priv->revoked =3D true;
> > =C2=A0		dma_buf_move_notify(priv->dmabuf);
> > +		dma_resv_wait_timeout(priv->dmabuf->resv,
> > DMA_RESV_USAGE_KERNEL,
> > +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 false,
> > MAX_SCHEDULE_TIMEOUT);
> > =C2=A0		dma_resv_unlock(priv->dmabuf->resv);
> > =C2=A0		vfio_device_put_registration(&vdev->vdev);
> > =C2=A0		fput(priv->dmabuf->file);
> >=20


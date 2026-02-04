Return-Path: <kvm+bounces-70189-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDauEvUxg2kwjAMAu9opvQ
	(envelope-from <kvm+bounces-70189-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:48:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0A9E54C1
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 12:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0D7AF3006981
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 11:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E013ECBD5;
	Wed,  4 Feb 2026 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbYlDQxV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC172C3745;
	Wed,  4 Feb 2026 11:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770205674; cv=none; b=VZd0hcfGdXvRuH1AxdpCyabczL3qaS8NUQdFTFBS9mFgOVcKdYqIoel+ujfbZiQsXJqq4fAF7k+Fa5W5oRroDRNGJuJPaVg8t2OSB0ooaBqdsfVx7F7bSWtBiwHsNlruhCpRVjwZlAXI4C+8pbeBhgSbcZY2Br6IJ+wr/8Jd+ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770205674; c=relaxed/simple;
	bh=rPbKYkwfcWB5lqs9Gv5YueZqMCBOM7yviLRmQArria8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pyM47rsJotLNb+PZ32wa2yNSknF9MgczqB4bTANwvKyIBNeqmkFNpkOroVL8+XLW19t0nAnHDPGR8RbkuaIupI88Ipk7R7yq8CL2XBVbbZFiifcXFMYsFkvBDWKXccVf2XCK7C53vC7cRJ109zglGaYBJDyKOnSUAMyPSaYJ6R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbYlDQxV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79FCC4CEF7;
	Wed,  4 Feb 2026 11:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770205674;
	bh=rPbKYkwfcWB5lqs9Gv5YueZqMCBOM7yviLRmQArria8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gbYlDQxVBeta/CNJyWa9MgeMWc8AZVaz/Hqh50dxhpDoTN1L69OChpApl6XkULIi6
	 NKDHElSpJ3087qW1UgR3Qd1rMmOeJjNykE0aHGpknmYrydT3vaew7r0gqrRjJ7W678
	 UDYv62OnYV2+8whi9PQWZ5jczYgPNcfZPw0UE5IyEFudBWVmucwnDa3AiZp6JDoVfN
	 2IA6q0TFbgskZI35/tRemeJn+janbOtDtphRvg1kyfWm4CA/Ultkf4AZhhi+V/VA3e
	 a4n7hXHn5AWWJK9HRujiYMgAxR9LD249ZcIrZwTSuHkzBVCcfL5/GUQYXrpMK0XvRa
	 4TY71rz996rFw==
Date: Wed, 4 Feb 2026 13:47:51 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260204114751.GF6771@unreal>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260202160425.GO34749@unreal>
 <20260204081630.GA6771@unreal>
 <6d5c392b-596b-4341-9992-aa4b26001804@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d5c392b-596b-4341-9992-aa4b26001804@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70189-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 6F0A9E54C1
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:54:13AM +0100, Christian König wrote:
> On 2/4/26 09:16, Leon Romanovsky wrote:
> > On Mon, Feb 02, 2026 at 06:04:25PM +0200, Leon Romanovsky wrote:
> >> On Sat, Jan 31, 2026 at 07:34:10AM +0200, Leon Romanovsky wrote:
> >>> Changelog:
> >>> v7:
> >>
> >> <...>
> >>
> >>> Leon Romanovsky (8):
> >>>       dma-buf: Rename .move_notify() callback to a clearer identifier
> >>>       dma-buf: Rename dma_buf_move_notify() to dma_buf_invalidate_mappings()
> >>>       dma-buf: Always build with DMABUF_MOVE_NOTIFY
> >>>       vfio: Wait for dma-buf invalidation to complete
> >>>       dma-buf: Make .invalidate_mapping() truly optional
> >>>       dma-buf: Add dma_buf_attach_revocable()
> >>>       vfio: Permit VFIO to work with pinned importers
> >>>       iommufd: Add dma_buf_pin()
> >>>
> >>>  drivers/dma-buf/Kconfig                     | 12 -----
> >>>  drivers/dma-buf/dma-buf.c                   | 69 ++++++++++++++++++++-----
> >>>  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 ++---
> >>>  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |  2 +-
> >>>  drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
> >>>  drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
> >>>  drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++-
> >>>  drivers/gpu/drm/xe/xe_bo.c                  |  2 +-
> >>>  drivers/gpu/drm/xe/xe_dma_buf.c             | 14 ++---
> >>>  drivers/infiniband/core/umem_dmabuf.c       | 13 -----
> >>>  drivers/infiniband/hw/mlx5/mr.c             |  2 +-
> >>>  drivers/iommu/iommufd/pages.c               | 11 +++-
> >>>  drivers/iommu/iommufd/selftest.c            |  2 +-
> >>>  drivers/vfio/pci/vfio_pci_dmabuf.c          | 80 ++++++++++++++++++++++-------
> >>>  include/linux/dma-buf.h                     | 17 +++---
> >>>  15 files changed, 153 insertions(+), 96 deletions(-)
> >>
> >> Christian,
> >>
> >> Given the ongoing discussion around patch v5, I'm a bit unclear on the
> >> current state. Is the series ready for merging, or do you need me to
> >> rework anything further?
> > 
> > Christian,
> > 
> > Let's not miss the merge window for work that is already ready.
> 
> Mhm, sounds like AMDs mail servers never send my last mail out.
> 
> As far as I can see all patches have an reviewed-by, I also gave an rb on patch #6 (should that mail never got out as well). The discussion on patch v5 is just orthogonal I think, the handling was there even completely before this patch set.
> 
> For upstreaming as long as the VFIO and infiniband folks don't object I would like to take that through the drm-misc branch (like every other DMA-buf change).

Infiniband folks don't object :).

> 
> So as long as nobody objects I can push that today, but I can't promise that Dave/Linus will take it for the 6.20 window.

Let's give it a try, at the very least.

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > Thanks
> > 
> >>
> >> Thanks
> >>
> 
> 


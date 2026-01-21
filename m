Return-Path: <kvm+bounces-68702-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIbzK2WqcGnwYwAAu9opvQ
	(envelope-from <kvm+bounces-68702-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 11:28:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6302E55345
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 11:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CF9186430A6
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F3E48A2B1;
	Wed, 21 Jan 2026 10:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5mnHwlZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37896481FC3;
	Wed, 21 Jan 2026 10:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768990467; cv=none; b=URAKnxQfKFt0kVE0q2dtRklh+F7fsnMiUtNKMvgr6im+ZnHqX3/t8Lq52xnlXN/dWsptY8Wi+cVC7oSR81kzC0hNM1MMmp4e6snrIG4+NpzmCsxyJutIZUcKYZHkSD9b8blmVz5Ne0HVZhgzGAkZVxQS1ZoqRNWzqLAOAQLGhno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768990467; c=relaxed/simple;
	bh=Tfo/OWueoKu8rex7Tl9fDhj3HYw8PFEJM2EofHNagw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDDnkdHMnvKDwMluaYUq6aceQ1Jz0nuJJGboAbkS0BPACVoZvOx0lCCPQU5NxoYHrcUwuJ4nbyB9PjKUy1u799Hna1Il5SJ6Qxdy6YnOKI8yfzbN9k0N2IF3um4HFPUsWWaTMGogHELNSydC1WFLZjc4xZLmELmCere2ckcZh9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5mnHwlZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DD7C19422;
	Wed, 21 Jan 2026 10:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768990466;
	bh=Tfo/OWueoKu8rex7Tl9fDhj3HYw8PFEJM2EofHNagw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N5mnHwlZ4VBOzCaF2qAu+DjTaYQWAFbky4+JT2mBLPGjrNKxQ+fM9k9d6IllOUceW
	 j1tAd0RJdJnA6QxkAhArkPbFRodriKbgtOU4tbyG0Ur1/cdjnP09GyrxTAfwHP4xnP
	 X2So8WSV2cSYLZ1AZt0vyY20Gne5NDjhKQIqOjY28If9yXQcsOj1ST1qi7+CzWJcpx
	 Bps75wKKBhcc5ddkolv1NkPvv+0fB5Nv0q0I8EgTvOodoH6D+g2E7dAFxYKe7BHlLR
	 hPLlN+CWPcGoGBCvh/VKV743I73C6D0fJrJ2uaTEJdSDWeaB+0vclUS32VmzRQQIbg
	 QHhoM3gbQHIKg==
Date: Wed, 21 Jan 2026 12:14:21 +0200
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
Subject: Re: [PATCH v3 2/7] dma-buf: Always build with DMABUF_MOVE_NOTIFY
Message-ID: <20260121101421.GZ13201@unreal>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-2-b7e0b07b8214@nvidia.com>
 <24c7a7e6-b1bd-4407-b62d-4d9ea4cdeee4@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24c7a7e6-b1bd-4407-b62d-4d9ea4cdeee4@amd.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68702-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,amd.com:email,nvidia.com:email]
X-Rspamd-Queue-Id: 6302E55345
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 09:55:38AM +0100, Christian König wrote:
> On 1/20/26 15:07, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > DMABUF_MOVE_NOTIFY was introduced in 2018 and has been marked as
> > experimental and disabled by default ever since. Six years later,
> > all new importers implement this callback.
> > 
> > It is therefore reasonable to drop CONFIG_DMABUF_MOVE_NOTIFY and
> > always build DMABUF with support for it enabled.
> > 
> > Suggested-by: Christian König <christian.koenig@amd.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/dma-buf/Kconfig                     | 12 ------------
> >  drivers/dma-buf/dma-buf.c                   | 12 ++----------
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 10 +++-------
> >  drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
> >  drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  3 +--
> >  drivers/gpu/drm/xe/xe_dma_buf.c             | 12 ++++--------
> >  6 files changed, 11 insertions(+), 40 deletions(-)
> > 
> > diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
> > index b46eb8a552d7..84d5e9b24e20 100644
> > --- a/drivers/dma-buf/Kconfig
> > +++ b/drivers/dma-buf/Kconfig
> > @@ -40,18 +40,6 @@ config UDMABUF
> >  	  A driver to let userspace turn memfd regions into dma-bufs.
> >  	  Qemu can use this to create host dmabufs for guest framebuffers.
> >  
> > -config DMABUF_MOVE_NOTIFY
> > -	bool "Move notify between drivers (EXPERIMENTAL)"
> > -	default n
> > -	depends on DMA_SHARED_BUFFER
> > -	help
> > -	  Don't pin buffers if the dynamic DMA-buf interface is available on
> > -	  both the exporter as well as the importer. This fixes a security
> > -	  problem where userspace is able to pin unrestricted amounts of memory
> > -	  through DMA-buf.
> > -	  This is marked experimental because we don't yet have a consistent
> > -	  execution context and memory management between drivers.
> > -
> >  config DMABUF_DEBUG
> >  	bool "DMA-BUF debug checks"
> >  	depends on DMA_SHARED_BUFFER
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index 59cc647bf40e..cd3b60ce4863 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -837,18 +837,10 @@ static void mangle_sg_table(struct sg_table *sg_table)
> >  
> >  }
> >  
> > -static inline bool
> > -dma_buf_attachment_is_dynamic(struct dma_buf_attachment *attach)
> 
> I would rather like to keep the wrapper and even add some explanation what it means when true is returned.

We have different opinion here. I don't like single line functions which
are called only twice. I'll keep this function to ensure progress the
series.

Thanks

> 
> Apart from that looks good to me.
> 
> Regards,
> Christian.


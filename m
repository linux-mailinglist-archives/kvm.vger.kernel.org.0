Return-Path: <kvm+bounces-68683-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wOGUN7aHcGkEYQAAu9opvQ
	(envelope-from <kvm+bounces-68683-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:00:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DEC6532EA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8BE454F1396
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 07:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA10538A731;
	Wed, 21 Jan 2026 07:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfyuJlQZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C403D522D;
	Wed, 21 Jan 2026 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768982375; cv=none; b=nfDDEPWk8OqJnlCDq6cZAfeSqxnbUyJS/p4of2OeG5MLPnUIu+gngIm/ZkW4VUy7wqNSON8H/OZ37iHzuCD5Q7b53kLOn3ZUP85UWQD/+BszYKFL7Jrv+OsR8xmTVTV6FZvKG7t1PTx/yHn3aRRaaXHd+a4exfhR5bcrwsWs65M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768982375; c=relaxed/simple;
	bh=lEy1yZ/ijqL0f8O4r3b/+kmhBy9GW/pNUeqgzBHM/dA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=naQthyK+orayeVtgZKBRYosB74QZWGSwwlEDiKF4JHjDqnvUx5BzqTrWcfCxFZxZ+ZvlZs9eq2x0wOw+JIt/CkOqkAXxWcVsghqTATF1PsiKPFWEiZOmKZ0lu3TcdNRPyYdxk96WyxfQX8aieYplF8oflBHlIvu9V19tt7ivnpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfyuJlQZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A6FC116D0;
	Wed, 21 Jan 2026 07:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768982374;
	bh=lEy1yZ/ijqL0f8O4r3b/+kmhBy9GW/pNUeqgzBHM/dA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dfyuJlQZbT+khgy1UNrCtf//gRr41b5TeKPoiYg80AS6Fc/HmDd3VwtiI+5NSenuw
	 2Spobvzc4gCbVDeqXVaQQbRwrS6+CHKVy3XbpOJDk9mphG7a3wdXKInoc7n0OfcKWE
	 8SWHbICqvKTijL1hBIfRy4blDhgnKn5Fu+boDiKbghi+pmOrn0ZdSCoarjSE6+E1nR
	 24AKgBy+Kh5VI/MLAyjcYTcRF130zk6/0Xf1/w1d4GVohJUI57MraMOfQ3eptReL80
	 6JZuVHv3OQrm+n2zA8FnYBMhG1FJ8jnjl2gjc7wulNG8aRh7RUGCDXECKS4I2EibU8
	 Rp2oext3FgQ8w==
Date: Wed, 21 Jan 2026 09:59:29 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
Subject: Re: [PATCH v3 6/7] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260121075929.GU13201@unreal>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-6-b7e0b07b8214@nvidia.com>
 <aW/pQmOO8komCgOK@lstrano-desk.jf.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aW/pQmOO8komCgOK@lstrano-desk.jf.intel.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68683-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 5DEC6532EA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 12:44:50PM -0800, Matthew Brost wrote:
> On Tue, Jan 20, 2026 at 04:07:06PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > dma-buf invalidation is performed asynchronously by hardware, so VFIO must
> > wait until all affected objects have been fully invalidated.
> > 
> > Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_dmabuf.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > index d4d0f7d08c53..33bc6a1909dd 100644
> > --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> > +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > @@ -321,6 +321,9 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
> >  			dma_resv_lock(priv->dmabuf->resv, NULL);
> >  			priv->revoked = revoked;
> >  			dma_buf_move_notify(priv->dmabuf);
> > +			dma_resv_wait_timeout(priv->dmabuf->resv,
> > +					      DMA_RESV_USAGE_KERNEL, false,
> > +					      MAX_SCHEDULE_TIMEOUT);
> 
> Should we explicitly call out in the dma_buf_move_notify() /
> invalidate_mappings kernel-doc that KERNEL slots are the mechanism
> for communicating asynchronous dma_buf_move_notify /
> invalidate_mappings events via fences?
> 
> Yes, this is probably implied, but it wouldn’t hurt to state this
> explicitly as part of the cross-driver contract.
> 
> Here is what we have now:
> 
>  	 * - Dynamic importers should set fences for any access that they can't
> 	 *   disable immediately from their &dma_buf_attach_ops.invalidate_mappings
>  	 *   callback.

I believe I documented this in patch 4:
https://lore.kernel.org/all/20260120-dmabuf-revoke-v3-4-b7e0b07b8214@nvidia.com/"
Is there anything else that should be added?

  1275 /**
  1276  * dma_buf_move_notify - notify attachments that DMA-buf is moving
  1277  *
  1278  * @dmabuf:     [in]    buffer which is moving
  1279  *
  1280  * Informs all attachments that they need to destroy and recreate all their
  1281  * mappings. If the attachment is dynamic then the dynamic importer is expected
  1282  * to invalidate any caches it has of the mapping result and perform a new
  1283  * mapping request before allowing HW to do any further DMA.
  1284  *
  1285  * If the attachment is pinned then this informs the pinned importer that
  1286  * the underlying mapping is no longer available. Pinned importers may take
  1287  * this is as a permanent revocation so exporters should not trigger it
  1288  * lightly.
  1289  *
  1290  * For legacy pinned importers that cannot support invalidation this is a NOP.
  1291  * Drivers can call dma_buf_attach_revocable() to determine if the importer
  1292  * supports this.
  1293  *
  1294  * NOTE: The invalidation triggers asynchronous HW operation and the callers
  1295  * need to wait for this operation to complete by calling
  1296  * to dma_resv_wait_timeout().
  1297  */

Thanks


> 
> Matt
> 
> >  			dma_resv_unlock(priv->dmabuf->resv);
> >  		}
> >  		fput(priv->dmabuf->file);
> > @@ -342,6 +345,8 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
> >  		priv->vdev = NULL;
> >  		priv->revoked = true;
> >  		dma_buf_move_notify(priv->dmabuf);
> > +		dma_resv_wait_timeout(priv->dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> > +				      false, MAX_SCHEDULE_TIMEOUT);
> >  		dma_resv_unlock(priv->dmabuf->resv);
> >  		vfio_device_put_registration(&vdev->vdev);
> >  		fput(priv->dmabuf->file);
> > 
> > -- 
> > 2.52.0
> > 


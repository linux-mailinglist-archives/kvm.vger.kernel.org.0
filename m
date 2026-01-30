Return-Path: <kvm+bounces-69702-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGGYLGWqfGkaOQIAu9opvQ
	(envelope-from <kvm+bounces-69702-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:56:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55677BAC54
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BF94930022EC
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 12:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BEC37F11E;
	Fri, 30 Jan 2026 12:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJzfef1m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D67A296BD7;
	Fri, 30 Jan 2026 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769777751; cv=none; b=fZFuPe7ai6+1RkcnYwDABKTouPqXqpPxV+EYiQRiAta9bf8GPSZxcfc6lHkPisFd3z8xT61CYX8jWrK52vUBTtpoxlgQ/yjbxs6pw3EN9s2q19m4d80QMq7MTc6vtVZBbYSXrM5sSMjx1EEe+ZFPluErWlkCknEpPTGgyPJVcJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769777751; c=relaxed/simple;
	bh=TRVxNgALhdVq3UF72R4/tO5tMWCJQNOfxrwhinpqw5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElLucwvyTj6kJS8LTtjomSUQth/DML41NrlCxHUI8cuGY+bs4pRKiJLfCz+ba+b1aAm/4KRQVby9hQqhWZnZK7qTw3KbVMYFWHvU2msZepLZ7njscP2abggp/KXkfRj0s3fxmuEqjDQOqaLGhhBHe29KxAUefwpJqc2TEdRu5MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJzfef1m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03C8C4CEF7;
	Fri, 30 Jan 2026 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769777750;
	bh=TRVxNgALhdVq3UF72R4/tO5tMWCJQNOfxrwhinpqw5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WJzfef1mFWJvqqhgoKwPzjVYx5BqBw33sBFl2eKDp/Pfvj7OIsA58ekqM8jdY3BK0
	 73Zf1ip4BeZTomQHhEjAraKiVgniCQCWfXnfLxvj9a/O/9oU8Z9NkWoMKtCCTYeCFF
	 p2oXro+vc40lycbeKRa73+LghlplIp7Ams11CYwswNZzSY/7PwnmIoPtYvMVs9gpe8
	 yx38R1aQxwUojvoiPQaCUXtWo6l8WJdKvIUidBM6L71DxpGdbxjw95NVRiDXP8aj08
	 Scro6rXSvN7lLNXRce64nJxQhqvN5iJEhuGUtC+eZIxMtOGr27eOhNa4t+m02fVjfH
	 M/lOMNd6BTANA==
Date: Fri, 30 Jan 2026 14:55:45 +0200
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
Subject: Re: [PATCH v5 5/8] dma-buf: Make .invalidate_mapping() truly optional
Message-ID: <20260130125545.GN10992@unreal>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-5-f98fca917e96@nvidia.com>
 <3dec1de0-0e5b-4a47-b2cc-949edea16328@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3dec1de0-0e5b-4a47-b2cc-949edea16328@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69702-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 55677BAC54
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 09:30:05AM +0100, Christian König wrote:
> On 1/24/26 20:14, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The .invalidate_mapping() callback is documented as optional, yet it
> > effectively became mandatory whenever importer_ops were provided. This
> > led to cases where RDMA non-ODP code had to supply an empty stub.
> > 
> > Relax the checks in the dma-buf core so the callback can be omitted,
> > allowing RDMA code to drop the unnecessary function.
> > 
> > Removing the stub allows the next patch to tell that RDMA does not support
> > .invalidate_mapping() by checking for a NULL op.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/dma-buf/dma-buf.c             |  6 ++----
> >  drivers/infiniband/core/umem_dmabuf.c | 13 -------------
> >  2 files changed, 2 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index cd68c1c0bfd7..1629312d364a 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -947,9 +947,6 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
> >  	if (WARN_ON(!dmabuf || !dev))
> >  		return ERR_PTR(-EINVAL);
> >  
> > -	if (WARN_ON(importer_ops && !importer_ops->invalidate_mappings))
> > -		return ERR_PTR(-EINVAL);
> > -
> >  	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
> >  	if (!attach)
> >  		return ERR_PTR(-ENOMEM);
> > @@ -1260,7 +1257,8 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
> >  	dma_resv_assert_held(dmabuf->resv);
> >  
> >  	list_for_each_entry(attach, &dmabuf->attachments, node)
> > -		if (attach->importer_ops)
> > +		if (attach->importer_ops &&
> > +		    attach->importer_ops->invalidate_mappings)
> >  			attach->importer_ops->invalidate_mappings(attach);
> >  }
> >  EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
> > diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
> > index d77a739cfe7a..256e34c15e6b 100644
> > --- a/drivers/infiniband/core/umem_dmabuf.c
> > +++ b/drivers/infiniband/core/umem_dmabuf.c
> > @@ -129,9 +129,6 @@ ib_umem_dmabuf_get_with_dma_device(struct ib_device *device,
> >  	if (check_add_overflow(offset, (unsigned long)size, &end))
> >  		return ret;
> >  
> > -	if (unlikely(!ops || !ops->invalidate_mappings))
> 
> You should probably keep "if (unlikely(!ops)).." here.

The unlikely is useless in this path.

> 
> Apart from that the patch looks good to me.
> 
> Regards,
> Christian.
> 
> > -		return ret;
> > -
> >  	dmabuf = dma_buf_get(fd);
> >  	if (IS_ERR(dmabuf))
> >  		return ERR_CAST(dmabuf);
> > @@ -184,18 +181,8 @@ struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
> >  }
> >  EXPORT_SYMBOL(ib_umem_dmabuf_get);
> >  
> > -static void
> > -ib_umem_dmabuf_unsupported_move_notify(struct dma_buf_attachment *attach)
> > -{
> > -	struct ib_umem_dmabuf *umem_dmabuf = attach->importer_priv;
> > -
> > -	ibdev_warn_ratelimited(umem_dmabuf->umem.ibdev,
> > -			       "Invalidate callback should not be called when memory is pinned\n");
> > -}
> > -
> >  static struct dma_buf_attach_ops ib_umem_dmabuf_attach_pinned_ops = {
> >  	.allow_peer2peer = true,
> > -	.invalidate_mappings = ib_umem_dmabuf_unsupported_move_notify,
> >  };
> >  
> >  struct ib_umem_dmabuf *
> > 
> 


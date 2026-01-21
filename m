Return-Path: <kvm+bounces-68690-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UIvBEhKbcGlyYgAAu9opvQ
	(envelope-from <kvm+bounces-68690-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:23:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D8A544D8
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E0395846290
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F8F47A0C1;
	Wed, 21 Jan 2026 09:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFx5mfJf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6804523AE9B;
	Wed, 21 Jan 2026 09:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768986868; cv=none; b=o7UqG4Br+rdIAlNo51uDgoeDuUqJKxFsNEaU6tQOKQ1isAqD7mniGCIUGNQTfkSWyISYUDu3DEJFUXkQUqF2V568AFgsad3N1/l/9TicaMzrbnDUjbcMKO9ex4oTzGJf6C4QSuuSkv85EUMSIw3Q7eni3SU9Y7ntAeoj7qJymUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768986868; c=relaxed/simple;
	bh=lkxSsg325o6Y+SdMNgqIjpVEFcBa4/ALLRUPgSh2DSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RwESB3GPqZncEabjRJLuITrzTad9qla8jdi63CpUasA9u8HlwahsN3KE7D7wBrKvYwjuDQ71luqsoqUB9/UP62lGwXHYY+tmydq6/9uMPvEX4/EUmu1MiiQN1YYx1vFGj3KkzU848mXw8H2/RVmuODDkExKeXIXoPu3IEYmg67E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFx5mfJf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C475C116D0;
	Wed, 21 Jan 2026 09:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768986867;
	bh=lkxSsg325o6Y+SdMNgqIjpVEFcBa4/ALLRUPgSh2DSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hFx5mfJfrvbZ1IbosMhxQ9ll+jp2S67M4l88fKAHfoK1pU2zC/d4iFNMP0wl+3Dn3
	 b9Qf/kr9pBcANjcA7m2St0p7poT6TCmVjJt4ojtfqyPeefTsFFN9M/DK1kJ3aHij+v
	 oGzDTHYv1dFlArm/REbTBeBeSbOMbD8cQymlnTKzNY+yz5cj5BrBcRs+34/mavmVUL
	 /bf49KY9oabpHoj1MXKY3BK6GK44fF8YbS4P8bDesv2egQYUaIQlJ6xwZb0QwYBrUf
	 qrPPc3Z6O4+3sBXl/V4VnIxhgzxJ0eefehaK1FwfyXZPrdb6NshWB6LYjaYfv3GA3Y
	 PlHRAtfN6IyPg==
Date: Wed, 21 Jan 2026 11:14:23 +0200
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
Subject: Re: [PATCH v3 3/7] dma-buf: Document RDMA non-ODP
 invalidate_mapping() special case
Message-ID: <20260121091423.GY13201@unreal>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-3-b7e0b07b8214@nvidia.com>
 <4fe42e7e-846c-4aae-8274-3e9a5e7f9a6d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fe42e7e-846c-4aae-8274-3e9a5e7f9a6d@amd.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68690-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,nvidia.com:email]
X-Rspamd-Queue-Id: F1D8A544D8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 09:59:59AM +0100, Christian König wrote:
> On 1/20/26 15:07, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The .invalidate_mapping() callback is documented as optional, yet it
> > effectively became mandatory whenever importer_ops were provided. This
> > led to cases where RDMA non-ODP code had to supply an empty stub just to
> > provide allow_peer2peer.
> > 
> > Document this behavior by creating a dedicated export for the
> > dma_buf_unsupported_invalidate_mappings() function. This function is
> > intended solely for the RDMA non-ODP case and must not be used by any
> > other dma-buf importer.
> > 
> > This makes it possible to rely on a valid .invalidate_mappings()
> > callback to determine whether an importer supports revocation.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/dma-buf/dma-buf.c             | 14 ++++++++++++++
> >  drivers/infiniband/core/umem_dmabuf.c | 11 +----------
> >  include/linux/dma-buf.h               |  4 +++-
> >  3 files changed, 18 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index cd3b60ce4863..c4fa35034b92 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -1238,6 +1238,20 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
> >  }
> >  EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
> >  
> > +/*
> > + * This function shouldn't be used by anyone except RDMA non-ODP case.
> > + * The reason to it is UAPI mistake where dma-buf was exported to the
> > + * userspace without knowing that .invalidate_mappings() can be called
> > + * for pinned memory too.
> > + *
> > + * This warning shouldn't be seen in real production scenario.
> > + */
> > +void dma_buf_unsupported_invalidate_mappings(struct dma_buf_attachment *attach)
> > +{
> > +	pr_warn("Invalidate callback should not be called when memory is pinned\n");
> > +}
> > +EXPORT_SYMBOL_FOR_MODULES(dma_buf_unsupported_invalidate_mappings, "ib_uverbs");
> > +
> 
> Well that is exactly the opposite of what I had in mind.
> 
> The RDMA non-ODP case should explicitly not provide an invalidate_mappings callback, but only the dma_buf_attach_ops with allow_peer2peer set to true.
> 
> This is done to explicitly note that RDMA non-ODP can't do invalidation's.

We want to achieve two goals:
1. Provide a meaningful warning to developers, rather than failing later
   because dma_buf_move_notify() was called on this problematic imported dma-buf.
2. Require all users to supply a valid .invalidate_mapping().

If I allow empty .invalidate_mapping(), this check will go too:
   932 struct dma_buf_attachment *
   933 dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
   934                        const struct dma_buf_attach_ops *importer_ops,
   935                        void *importer_priv)
...
   943         if (WARN_ON(importer_ops && !importer_ops->invalidate_mappings))
   944                 return ERR_PTR(-EINVAL);

And it is important part of dma-buf.

Thanks


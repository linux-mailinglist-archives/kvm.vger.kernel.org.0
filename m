Return-Path: <kvm+bounces-70252-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WO3iE9WFg2llowMAu9opvQ
	(envelope-from <kvm+bounces-70252-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:45:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E195FEB16F
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:45:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3A66305EC25
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 17:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3373AEF39;
	Wed,  4 Feb 2026 17:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5sNk7Yo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711C33A7834;
	Wed,  4 Feb 2026 17:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770226923; cv=none; b=THcUyAUjHejffvhIg/pTJcFHeqUO39oJ1QfIs+Qx56aBkb69BhokjkhG/TvkddwSUwqPv8bEwMtEXhGM32x8lKlMFi5jN2Yz/xUswc6ODyqXTS077jtmSR5Dfew7zrJd3LiT/lCwsWlyfUMpNR/QSKt86F4IEdVVohevQtf1Zhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770226923; c=relaxed/simple;
	bh=p787FwvtGxpTW7O+BZ6Vp7w3LWjZ2nLdxL1PN/deDRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgKoU7/kpi8gLctsDnT5NcBgGNPPjhyDz3Io+how6t4ohpNX0jx6bVQ8BefeUyCq0aAea6U5Nfo2BRiagn0PC8G0dl3pPyAinBDtFEirhYSWD1ALV66ISPQWz22A3E37VW/Q+B0lBdms6fEN8cFhxb3aJ1AVqvjAs0g7ASb3MFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5sNk7Yo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABA4C116C6;
	Wed,  4 Feb 2026 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770226923;
	bh=p787FwvtGxpTW7O+BZ6Vp7w3LWjZ2nLdxL1PN/deDRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y5sNk7YoVaiqLlGkRnVYCRSjbVUtYvArX7zLCO0dq9LARndPLPkwL0xKjxvhVq2pl
	 pgr4rff3JEaU3JLLY7edp68Rr5VjQNRFRIZw6ETH1AWCgHbDlIgcwwCbRdGpZq90He
	 UBGguXZpA1L9b22GpsmfUiUI6FVFJHrnHxBSkzjTXt8+gPdExzOi/eNdc/MOnPKf+Q
	 Aqee+/IUEM/rzCbcV2pID1uVCuOkkwM8e3efDB9obdYx+OCQEmWJ2i50cYE/5zVVM8
	 c8QctwcWyxr4Q1eq9txWCJRRhfIJWW7V5DaeHqHDoUVdtavrJVOMe40HRuZ2LaARJz
	 CejQKWN5h2JEg==
Date: Wed, 4 Feb 2026 19:41:57 +0200
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
Subject: Re: [PATCH v7 7/8] vfio: Permit VFIO to work with pinned importers
Message-ID: <20260204174157.GA12201@unreal>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260131-dmabuf-revoke-v7-7-463d956bd527@nvidia.com>
 <fb9bf53a-7962-451a-bac2-c61eb52c7a0f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb9bf53a-7962-451a-bac2-c61eb52c7a0f@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70252-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[shazbot.org:email,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email,amd.com:email]
X-Rspamd-Queue-Id: E195FEB16F
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 05:21:45PM +0100, Christian König wrote:
> On 1/31/26 06:34, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Till now VFIO has rejected pinned importers, largely to avoid being used
> > with the RDMA pinned importer that cannot handle a move_notify() to revoke
> > access.
> > 
> > Using dma_buf_attach_revocable() it can tell the difference between pinned
> > importers that support the flow described in dma_buf_invalidate_mappings()
> > and those that don't.
> > 
> > Thus permit compatible pinned importers.
> > 
> > This is one of two items IOMMUFD requires to remove its private interface
> > to VFIO's dma-buf.
> > 
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Alex Williamson <alex@shazbot.org>
> > Reviewed-by: Christian König <christian.koenig@amd.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_dmabuf.c | 15 +++------------
> >  1 file changed, 3 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > index 78d47e260f34..a5fb80e068ee 100644
> > --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> > +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > @@ -22,16 +22,6 @@ struct vfio_pci_dma_buf {
> >  	u8 revoked : 1;
> >  };
> >  
> > -static int vfio_pci_dma_buf_pin(struct dma_buf_attachment *attachment)
> > -{
> > -	return -EOPNOTSUPP;
> > -}
> > -
> > -static void vfio_pci_dma_buf_unpin(struct dma_buf_attachment *attachment)
> > -{
> > -	/* Do nothing */
> > -}
> > -
> 
> This chunk here doesn't want to apply to drm-misc-next, my educated guess is that the patch adding those lines is missing in that tree.
> 
> How should we handle that? Patches 1-3 have already been pushed to drm-misc-next and I would rather like to push patches 4-6 through that branch as well.

There is no need for a backmerge; it should go in through the shared
branch. Alex has created the tag vfio-v6.19-rc8, which is v6.19-rc6 plus
the VFIO pin patch.

You need to merge this tag into drm-misc-next. That will ensure that
Linus, DRM, and VFIO all see the same SHA-1, and that patches 5–6 can be
applied afterward.

Thanks

> 
> I can request a backmerge from the drm-misc-next maintainers, but then we clearly don't get that upstream this week.
> 
> Regards,
> Christian.
> 
> >  static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
> >  				   struct dma_buf_attachment *attachment)
> >  {
> > @@ -43,6 +33,9 @@ static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
> >  	if (priv->revoked)
> >  		return -ENODEV;
> >  
> > +	if (!dma_buf_attach_revocable(attachment))
> > +		return -EOPNOTSUPP;
> > +
> >  	return 0;
> >  }
> >  
> > @@ -107,8 +100,6 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
> >  }
> >  
> >  static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
> > -	.pin = vfio_pci_dma_buf_pin,
> > -	.unpin = vfio_pci_dma_buf_unpin,
> >  	.attach = vfio_pci_dma_buf_attach,
> >  	.map_dma_buf = vfio_pci_dma_buf_map,
> >  	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
> > 
> 
> 


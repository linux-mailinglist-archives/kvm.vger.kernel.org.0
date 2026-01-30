Return-Path: <kvm+bounces-69703-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SI5jB42sfGkaOQIAu9opvQ
	(envelope-from <kvm+bounces-69703-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:05:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9238BADCB
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F026930530EE
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A094C2D9EC8;
	Fri, 30 Jan 2026 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NifBrC6N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47522C0260;
	Fri, 30 Jan 2026 13:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769778095; cv=none; b=mL8O+VI92g+Sr429klOkodOx6ulXqK3cDnYiuezZi5rJK9N233AMH15y12Bfn8kAjANhH//ZDXbXT8/HjC3l2NDeGV+WBkmLVwEZNkQxWlsW3Qs1DU4AwLUfiWVxpOlRou/MVsGXf5ydSo/oRKE40P/Fo7PSwc6ftaP6sK2gUsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769778095; c=relaxed/simple;
	bh=G9gqcm5xvvohqtK7Hn6zZekh4h/DHomGvNcfw1+6iRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTorCxIq+8uYBCywcBzFy8GXB78vOjXURq08E0uL2QxeUT2h8qKUzZIFZA5NdJmAduHdnEM5D1MqB316ExfnM3XwTs7zL2+sU9XuV0p9RLA/7U88JZcKdIk2oq69CAqwtChVKgHKvOJeUVG0J825SdL6le/O7JfeN8gGo2ytn9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NifBrC6N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34801C4CEF7;
	Fri, 30 Jan 2026 13:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769778095;
	bh=G9gqcm5xvvohqtK7Hn6zZekh4h/DHomGvNcfw1+6iRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NifBrC6N9IdxcdIqlbLTrHVC34TgjUy8tFu+8gsA8K04kfGHFlRId0Fwx0sVA7YXj
	 m1SG4yWIlHuUPz78RzlapuF7YENxIdsTS3/tehFYWKg3xM1KqHAigpk7CtIM5S9X0B
	 zkTYYLzL61zodPhrmUG5sgxFDL4WwXQnv0lCastQLGnEnRfDGqqJLDAuyfWqErBs0Z
	 E3aOzmmKa2KuIDIBmnSNYqi0R16rBLgyr1308Yo2VEFcG0oO6iN/M6C+McO2ttZrN1
	 FUIUGT8Bg4X681eJYxB3qV7hPJhy3EaSAkWEQH/NPFUNwFb5RWkC3CORC/lqjuPOZI
	 7wA7gzOJFC1mg==
Date: Fri, 30 Jan 2026 15:01:31 +0200
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
Subject: Re: [PATCH v5 4/8] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260130130131.GO10992@unreal>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-4-f98fca917e96@nvidia.com>
 <31872c87-5cba-4081-8196-72cc839c6122@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31872c87-5cba-4081-8196-72cc839c6122@amd.com>
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
	TAGGED_FROM(0.00)[bounces-69703-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: B9238BADCB
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 09:30:59AM +0100, Christian König wrote:
> On 1/24/26 20:14, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > dma-buf invalidation is handled asynchronously by the hardware, so VFIO
> > must wait until all affected objects have been fully invalidated.
> > 
> > In addition, the dma-buf exporter is expecting that all importers unmap any
> > buffers they previously mapped.
> > 
> > Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_dmabuf.c | 71 ++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 68 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > index d8ceafabef48..485515629fe4 100644
> > --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> > +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > @@ -17,6 +17,8 @@ struct vfio_pci_dma_buf {
> >  	struct dma_buf_phys_vec *phys_vec;
> >  	struct p2pdma_provider *provider;
> >  	u32 nr_ranges;
> > +	struct kref kref;
> > +	struct completion comp;
> >  	u8 revoked : 1;
> >  };
> >  
> > @@ -44,27 +46,46 @@ static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
> >  	return 0;
> >  }
> >  
> > +static void vfio_pci_dma_buf_done(struct kref *kref)
> > +{
> > +	struct vfio_pci_dma_buf *priv =
> > +		container_of(kref, struct vfio_pci_dma_buf, kref);
> > +
> > +	complete(&priv->comp);
> > +}
> > +
> >  static struct sg_table *
> >  vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
> >  		     enum dma_data_direction dir)
> >  {
> >  	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
> > +	struct sg_table *ret;
> >  
> >  	dma_resv_assert_held(priv->dmabuf->resv);
> >  
> >  	if (priv->revoked)
> >  		return ERR_PTR(-ENODEV);
> >  
> > -	return dma_buf_phys_vec_to_sgt(attachment, priv->provider,
> > -				       priv->phys_vec, priv->nr_ranges,
> > -				       priv->size, dir);
> > +	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
> > +				      priv->phys_vec, priv->nr_ranges,
> > +				      priv->size, dir);
> > +	if (IS_ERR(ret))
> > +		return ret;
> > +
> > +	kref_get(&priv->kref);
> > +	return ret;
> >  }
> >  
> >  static void vfio_pci_dma_buf_unmap(struct dma_buf_attachment *attachment,
> >  				   struct sg_table *sgt,
> >  				   enum dma_data_direction dir)
> >  {
> > +	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
> > +
> > +	dma_resv_assert_held(priv->dmabuf->resv);
> > +
> >  	dma_buf_free_sgt(attachment, sgt, dir);
> > +	kref_put(&priv->kref, vfio_pci_dma_buf_done);
> >  }
> >  
> >  static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
> > @@ -287,6 +308,9 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
> >  		goto err_dev_put;
> >  	}
> >  
> > +	kref_init(&priv->kref);
> > +	init_completion(&priv->comp);
> > +
> >  	/* dma_buf_put() now frees priv */
> >  	INIT_LIST_HEAD(&priv->dmabufs_elm);
> >  	down_write(&vdev->memory_lock);
> > @@ -326,6 +350,8 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
> >  	lockdep_assert_held_write(&vdev->memory_lock);
> >  
> >  	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
> > +		unsigned long wait;
> > +
> >  		if (!get_file_active(&priv->dmabuf->file))
> >  			continue;
> >  
> > @@ -333,7 +359,37 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
> >  			dma_resv_lock(priv->dmabuf->resv, NULL);
> >  			priv->revoked = revoked;
> >  			dma_buf_invalidate_mappings(priv->dmabuf);
> > +			dma_resv_wait_timeout(priv->dmabuf->resv,
> > +					      DMA_RESV_USAGE_BOOKKEEP, false,
> > +					      MAX_SCHEDULE_TIMEOUT);
> >  			dma_resv_unlock(priv->dmabuf->resv);
> > +			if (revoked) {
> > +				kref_put(&priv->kref, vfio_pci_dma_buf_done);
> > +				/* Let's wait till all DMA unmap are completed. */
> > +				wait = wait_for_completion_timeout(
> > +					&priv->comp, secs_to_jiffies(1));
> > +				/*
> > +				 * If you see this WARN_ON, it means that
> > +				 * importer didn't call unmap in response to
> > +				 * dma_buf_invalidate_mappings() which is not
> > +				 * allowed.
> > +				 */
> > +				WARN(!wait,
> > +				     "Timed out waiting for DMABUF unmap, importer has a broken invalidate_mapping()");
> 
> You can do the revoke to do your resource management, for example re-use the backing store for something else.
> 
> But it is mandatory that you keep the mapping around indefinitely until the importer closes it.
> 
> Before that you can't do things like runtime PM or remove or anything which would make the DMA addresses invalid.
> 
> As far as I can see vfio_pci_dma_buf_move() is used exactly for that use case so this here is an absolutely clear NAK from my side for this approach.
> 
> You can either split up the functionality of vfio_pci_dma_buf_move() into vfio_pci_dma_buf_invalidate_mappings() and vfio_pci_dma_buf_flush() and then call the later whenever necessary or you keep it in one function and block everybody until the importer has dropped all mappings.

No problem, I can change it to be:

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index d087d018d547..53772a84c93b 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -357,23 +357,7 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
                        dma_resv_unlock(priv->dmabuf->resv);
                        if (revoked) {
                                kref_put(&priv->kref, vfio_pci_dma_buf_done);
-                               /*
-                                * Let's wait for 1 second till all DMA unmap
-                                * are completed. It is supposed to catch dma-buf
-                                * importers which lied about their support
-                                * of dmabuf revoke. See dma_buf_invalidate_mappings()
-                                * for the expected behaviour.
-                                */
-                               wait = wait_for_completion_timeout(
-                                       &priv->comp, secs_to_jiffies(1));
-                               /*
-                                * If you see this WARN_ON, it means that
-                                * importer didn't call unmap in response to
-                                * dma_buf_invalidate_mappings() which is not
-                                * allowed.
-                                */
-                               WARN(!wait,
-                                    "Timed out waiting for DMABUF unmap, importer has a broken invalidate_mapping()");
+                               wait_for_completion(&priv->comp);
                        } else {
                                /*
                                 * Kref is initialize again, because when revoke

Do you want me to send v6?

Thanks

> 
> > +			} else {
> > +				/*
> > +				 * Kref is initialize again, because when revoke
> > +				 * was performed the reference counter was decreased
> > +				 * to zero to trigger completion.
> > +				 */
> > +				kref_init(&priv->kref);
> > +				/*
> > +				 * There is no need to wait as no mapping was
> > +				 * performed when the previous status was
> > +				 * priv->revoked == true.
> > +				 */
> > +				reinit_completion(&priv->comp);
> > +			}
> >  		}
> >  		fput(priv->dmabuf->file);
> 
> This is also extremely questionable. Why doesn't the dmabuf have a reference while on the linked list?
> 
> Regards,
> Christian.
> 
> >  	}
> > @@ -346,6 +402,8 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
> >  
> >  	down_write(&vdev->memory_lock);
> >  	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
> > +		unsigned long wait;
> > +
> >  		if (!get_file_active(&priv->dmabuf->file))
> >  			continue;
> >  
> > @@ -354,7 +412,14 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
> >  		priv->vdev = NULL;
> >  		priv->revoked = true;
> >  		dma_buf_invalidate_mappings(priv->dmabuf);
> > +		dma_resv_wait_timeout(priv->dmabuf->resv,
> > +				      DMA_RESV_USAGE_BOOKKEEP, false,
> > +				      MAX_SCHEDULE_TIMEOUT);
> >  		dma_resv_unlock(priv->dmabuf->resv);
> > +		kref_put(&priv->kref, vfio_pci_dma_buf_done);
> > +		wait = wait_for_completion_timeout(&priv->comp,
> > +						   secs_to_jiffies(1));
> > +		WARN_ON(!wait);
> >  		vfio_device_put_registration(&vdev->vdev);
> >  		fput(priv->dmabuf->file);
> >  	}
> > 
> 
> 


Return-Path: <kvm+bounces-69711-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGIJDha1fGm7OQIAu9opvQ
	(envelope-from <kvm+bounces-69711-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:41:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5610BB3FE
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF3B1305F3C3
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6944930F92D;
	Fri, 30 Jan 2026 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8c5ft4i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739D9303C87;
	Fri, 30 Jan 2026 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769780258; cv=none; b=vADr3q96FXHguj1P8q/sOV+ExUz3Cx5Cl7Gj2d94IjdpHtqz75iDldrNE9ycgTIzk0RKqdu1jfe7w3kp1Wyu2ahdlC0AJjAJvHLvzPLxvGLUu7ZEcV3ve1TIVLZw0LpU6U6uUJNvlYIuW1EqCxrFj9DLAvCZpb2ODgNQti8CaXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769780258; c=relaxed/simple;
	bh=+QM2qm9n4iaFpnhJwfs3GnPxSGtlBrgmoDMGbKtOF5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIQODOaACz1yfQBCbMhlOEflhWrQ+QFzKLN+xZnLJxVVAYwnaY7rQfcElGhxIsd6cQwlFukIivbbVOtZE0IPnVqYKwtSPKE+EJNshmicgbksR1jbyjy4UUKExNbvMlXCOnq6an1eZLBeSupJxbQT1dADQhaUqlSC8lr4OQGtg6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8c5ft4i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E95AC116C6;
	Fri, 30 Jan 2026 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769780258;
	bh=+QM2qm9n4iaFpnhJwfs3GnPxSGtlBrgmoDMGbKtOF5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8c5ft4ii7n/SVPjuDA8ZsDerXppJvgtaBTHv6z+wRYKJMw++zFUSHOhcvHYB7IzY
	 z1e2yJVMdpc3lLi2iGaxMPPJvRcvZMjntndllw7+86OO2An0KaQHif/mT8D015x2Mc
	 ADyyNFuS5CwfJCv+OB80JZSrQJ71BKV1mgzzhD1wOrIGm7pPu7Q++d+fgSBpE6yDxD
	 K+NjdKno0cU347prhDQMECMqq9XTBYjXNORvp2nFgHHYnY1EtPvhsxBiweYPy+bBnd
	 5OQ/4PgYe8erlbuv1LrBPKHQSRlDuU3k1GvKMhJy1I/PWu4YAEzr6RgxF2qB4rB8AK
	 Xj6gxdxffZAjw==
From: Leon Romanovsky <leon@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v6 2/8] dma-buf: Rename dma_buf_move_notify() to dma_buf_invalidate_mappings()
Date: Fri, 30 Jan 2026 15:37:18 +0200
Message-ID: <20260130-dmabuf-revoke-v6-2-06278f9b7bf0@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260130-dmabuf-revoke-v6-0-06278f9b7bf0@nvidia.com>
References: <20260130-dmabuf-revoke-v6-0-06278f9b7bf0@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-47773
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69711-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,nvidia.com:mid,nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D5610BB3FE
X-Rspamd-Action: no action

From: Leon Romanovsky <leonro@nvidia.com>

Along with renaming the .move_notify() callback, rename the corresponding
dma-buf core function. This makes the expected behavior clear to exporters
calling this function.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/dma-buf.c                  | 8 ++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 2 +-
 drivers/gpu/drm/xe/xe_bo.c                 | 2 +-
 drivers/iommu/iommufd/selftest.c           | 2 +-
 drivers/vfio/pci/vfio_pci_dmabuf.c         | 4 ++--
 include/linux/dma-buf.h                    | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 59cc647bf40e..e12db540c413 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -912,7 +912,7 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  * 3. Exporters must hold the dma-buf reservation lock when calling these
  *    functions:
  *
- *     - dma_buf_move_notify()
+ *     - dma_buf_invalidate_mappings()
  */
 
 /**
@@ -1247,14 +1247,14 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
 EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
 
 /**
- * dma_buf_move_notify - notify attachments that DMA-buf is moving
+ * dma_buf_invalidate_mappings - notify attachments that DMA-buf is moving
  *
  * @dmabuf:	[in]	buffer which is moving
  *
  * Informs all attachments that they need to destroy and recreate all their
  * mappings.
  */
-void dma_buf_move_notify(struct dma_buf *dmabuf)
+void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 {
 	struct dma_buf_attachment *attach;
 
@@ -1264,7 +1264,7 @@ void dma_buf_move_notify(struct dma_buf *dmabuf)
 		if (attach->importer_ops)
 			attach->importer_ops->invalidate_mappings(attach);
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_move_notify, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
 
 /**
  * DOC: cpu access
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index e08f58de4b17..f73dc99d1887 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1270,7 +1270,7 @@ void amdgpu_bo_move_notify(struct ttm_buffer_object *bo,
 
 	if (abo->tbo.base.dma_buf && !drm_gem_is_imported(&abo->tbo.base) &&
 	    old_mem && old_mem->mem_type != TTM_PL_SYSTEM)
-		dma_buf_move_notify(abo->tbo.base.dma_buf);
+		dma_buf_invalidate_mappings(abo->tbo.base.dma_buf);
 
 	/* move_notify is called before move happens */
 	trace_amdgpu_bo_move(abo, new_mem ? new_mem->mem_type : -1,
diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index bf4ee976b680..7d02cd9a8501 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -819,7 +819,7 @@ static int xe_bo_move_notify(struct xe_bo *bo,
 
 	/* Don't call move_notify() for imported dma-bufs. */
 	if (ttm_bo->base.dma_buf && !ttm_bo->base.import_attach)
-		dma_buf_move_notify(ttm_bo->base.dma_buf);
+		dma_buf_invalidate_mappings(ttm_bo->base.dma_buf);
 
 	/*
 	 * TTM has already nuked the mmap for us (see ttm_bo_unmap_virtual),
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 550ff36dec3a..f60cbd5328cc 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -2081,7 +2081,7 @@ static int iommufd_test_dmabuf_revoke(struct iommufd_ucmd *ucmd, int fd,
 	priv = dmabuf->priv;
 	dma_resv_lock(dmabuf->resv, NULL);
 	priv->revoked = revoked;
-	dma_buf_move_notify(dmabuf);
+	dma_buf_invalidate_mappings(dmabuf);
 	dma_resv_unlock(dmabuf->resv);
 
 err_put:
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index 4be4a85005cb..d8ceafabef48 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -332,7 +332,7 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
 		if (priv->revoked != revoked) {
 			dma_resv_lock(priv->dmabuf->resv, NULL);
 			priv->revoked = revoked;
-			dma_buf_move_notify(priv->dmabuf);
+			dma_buf_invalidate_mappings(priv->dmabuf);
 			dma_resv_unlock(priv->dmabuf->resv);
 		}
 		fput(priv->dmabuf->file);
@@ -353,7 +353,7 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
 		list_del_init(&priv->dmabufs_elm);
 		priv->vdev = NULL;
 		priv->revoked = true;
-		dma_buf_move_notify(priv->dmabuf);
+		dma_buf_invalidate_mappings(priv->dmabuf);
 		dma_resv_unlock(priv->dmabuf->resv);
 		vfio_device_put_registration(&vdev->vdev);
 		fput(priv->dmabuf->file);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 1b397635c793..d5c3ce2b3aa4 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -600,7 +600,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
 					enum dma_data_direction);
 void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
 				enum dma_data_direction);
-void dma_buf_move_notify(struct dma_buf *dma_buf);
+void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 			     enum dma_data_direction dir);
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,

-- 
2.52.0



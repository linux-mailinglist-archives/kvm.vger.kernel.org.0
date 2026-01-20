Return-Path: <kvm+bounces-68616-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCRlLEpFcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68616-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:29:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2235E10E
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:29:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4C17D92C260
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A18443E9D7;
	Tue, 20 Jan 2026 14:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9FPLJNH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DB042EEDE;
	Tue, 20 Jan 2026 14:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918038; cv=none; b=sP/XpyfF4vVWds77KSc8ImTl9YWkoJZBrQRkqTY/PG6t/15We+fOKPvRqUSOO8gKBcWESXJ72Rpph62dtlUHMYOT8SV3fdQ6yfK0/k5XhAANW77aiEbuzQ9Z7uuy2hmPKVVZbMA1Q7Yxbdhpy+GUkC03vAqSABVCfMA3dgyWgqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918038; c=relaxed/simple;
	bh=ROKkB0mIS7khlsv4KQDOsZjX4a+rHO4aJnOw0MFmrm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QhjteGRkiu+XR4fC1LCwMdmswioFFca1vvqs7R9wmNpuxO912BgsXlze1oW0ACbZLdIZ4s5HSFEANjnbPRB4+8uGKpAd3sshRAnAwSo5irxL4bZcray06BxJ7n15KIueztg4k1MWF7cgIAiC3qpAA+0AqxQ5Xv+zuO552c5J5bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9FPLJNH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347A2C16AAE;
	Tue, 20 Jan 2026 14:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768918037;
	bh=ROKkB0mIS7khlsv4KQDOsZjX4a+rHO4aJnOw0MFmrm0=;
	h=From:To:Cc:Subject:Date:From;
	b=Z9FPLJNHtjmg+g+XBBXJHq1bk31q3tuCG8U641sPe5PuEyRi4qoevHZQgLWvE3BeV
	 NHcVnzAv548oIrOaPpNs4fPlzIzY8D6OAgDy24afQIILoJ5sUJRw4C9U44GL1Jk1Gs
	 6mqU9Gb2bBQDbKFny5CeMgMjvN3hpdZnU3hUFMqdq7O8rVtRv92lUsTZvkNBoFIycl
	 RYDK/SoQiG5vtv2N1Wn7zoWr52yIAtUVuf58teP6LzB3tVY3Xrzd0h81xYeR4xRJwD
	 Brafxmuv73RoqMNIrYdIQvZy7BhjYWgDSpoh6V83F3ly/524nRWpBY6F66Y2zu5aT3
	 /oAR4obsvM6mA==
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
Subject: [PATCH v3 0/7] dma-buf: Use revoke mechanism to invalidate shared buffers
Date: Tue, 20 Jan 2026 16:07:00 +0200
Message-ID: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20251221-dmabuf-revoke-b90ef16e4236
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DATE_IN_PAST(1.00)[31];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68616-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,nvidia.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 3D2235E10E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Changelog:
v3:
 * Used Jason's wordings for commits and cover letter.
 * Removed IOMMUFD patch.
 * Renamed dma_buf_attachment_is_revoke() to be dma_buf_attach_revocable().
 * Added patch to remove CONFIG_DMABUF_MOVE_NOTIFY.
 * Added Reviewed-by tags.
 * Called to dma_resv_wait_timeout() after dma_buf_move_notify() in VFIO.
 * Added dma_buf_attach_revocable() check to VFIO DMABUF attach function.
 * Slightly changed commit messages.
v2: https://patch.msgid.link/20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com
 * Changed series to document the revoke semantics instead of
   implementing it.
v1: https://patch.msgid.link/20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com

-------------------------------------------------------------------------
This series documents a dma-buf “revoke” mechanism: to allow a dma-buf
exporter to explicitly invalidate (“kill”) a shared buffer after it has
been distributed to importers, so that further CPU and device access is
prevented and importers reliably observe failure.

The change in this series is to properly document and use existing core
“revoked” state on the dma-buf object and a corresponding exporter-triggered
revoke operation.

dma-buf has quietly allowed calling move_notify on pinned dma-bufs, even
though legacy importers using dma_buf_attach() would simply ignore
these calls.

RDMA saw this and needed to use allow_peer2peer=true, so implemented a
new-style pinned importer with an explicitly non-working move_notify()
callback.

This has been tolerable because the existing exporters are thought to
only call move_notify() on a pinned DMABUF under RAS events and we
have been willing to tolerate the UAF that results by allowing the
importer to continue to use the mapping in this rare case.

VFIO wants to implement a pin supporting exporter that will issue a
revoking move_notify() around FLRs and a few other user triggerable
operations. Since this is much more common we are not willing to
tolerate the security UAF caused by interworking with non-move_notify()
supporting drivers. Thus till now VFIO has required dynamic importers,
even though it never actually moves the buffer location.

To allow VFIO to work with pinned importers, according to how dma-buf
was intended, we need to allow VFIO to detect if an importer is legacy
or RDMA and does not actually implement move_notify().

Introduce a new function that exporters can call to detect these less
capable importers. VFIO can then refuse to accept them during attach.

In theory all exporters that call move_notify() on pinned dma-buf's
should call this function, however that would break a number of widely
used NIC/GPU flows. Thus for now do not spread this further than VFIO
until we can understand how much of RDMA can implement the full
semantic.

In the process clarify how move_notify is intended to be used with
pinned dma-bufs.

Thanks

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (7):
      dma-buf: Rename .move_notify() callback to a clearer identifier
      dma-buf: Always build with DMABUF_MOVE_NOTIFY
      dma-buf: Document RDMA non-ODP invalidate_mapping() special case
      dma-buf: Add check function for revoke semantics
      iommufd: Pin dma-buf importer for revoke semantics
      vfio: Wait for dma-buf invalidation to complete
      vfio: Validate dma-buf revocation semantics

 drivers/dma-buf/Kconfig                     | 12 -----
 drivers/dma-buf/dma-buf.c                   | 69 +++++++++++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 +++---
 drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
 drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
 drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++-
 drivers/gpu/drm/xe/xe_dma_buf.c             | 14 +++---
 drivers/infiniband/core/umem_dmabuf.c       | 13 +-----
 drivers/infiniband/hw/mlx5/mr.c             |  2 +-
 drivers/iommu/iommufd/pages.c               | 11 ++++-
 drivers/vfio/pci/vfio_pci_dmabuf.c          |  8 ++++
 include/linux/dma-buf.h                     |  9 ++--
 12 files changed, 96 insertions(+), 67 deletions(-)
---
base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
change-id: 20251221-dmabuf-revoke-b90ef16e4236

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>



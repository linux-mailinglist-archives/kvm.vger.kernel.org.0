Return-Path: <kvm+bounces-591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D94F67E142D
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 16:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A223A2813C1
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 15:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE2B1173C;
	Sun,  5 Nov 2023 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iRoVaLL4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06118801
	for <kvm@vger.kernel.org>; Sun,  5 Nov 2023 15:58:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0167CDE
	for <kvm@vger.kernel.org>; Sun,  5 Nov 2023 07:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699199900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gm8P+4qqkq3fie/1BXBTuSMj+CMA8LATFFDY5rV8ORw=;
	b=iRoVaLL4ZpxQqZpqg35eHA56K0DlXNQ1WcOq5EiX38bxtfsd18tT7muxeKrxHKoEBj/9bs
	37bjm4CbvzFaDpbD8pelcb81k3dMts7Lqmi6Kk421QYSRnp6a63fx+SPVaEqrr5D00FtwG
	8t6GH8aAPmAWv+OeYOZkvaRDglovqw8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-yRH5UhFvNvyB9osGbGmezg-1; Sun, 05 Nov 2023 10:58:18 -0500
X-MC-Unique: yRH5UhFvNvyB9osGbGmezg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-543f1c6dcaeso2763760a12.1
        for <kvm@vger.kernel.org>; Sun, 05 Nov 2023 07:58:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699199897; x=1699804697;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gm8P+4qqkq3fie/1BXBTuSMj+CMA8LATFFDY5rV8ORw=;
        b=e68qw5aRYbJoOJiGy9YcgT6MhRQMSwtdYLoAL829ll8X2EGblTMFRGSpWTti8Cdl6e
         FK7TvzDF9wJXIF7YcJPeUcQzImAxEMqbCCljKohkMAKoDRkswtZ/UDwog/qU6VjRTmX1
         XxPu3vGh5D2fTJddwGqwljbO1NYDmsYMuX5Z6L363XjZq8fQACxrSDz0AOLsWzVd8J/A
         yFmashQY7ke57JL8PMnOpp0cn6UcucsJrQYTPAN+cvL+z5FX6jwN5lCKafDQbTgb0deK
         VBqPS/x9ViHunGpDaoZ2vKW5cx9VhbV9xkE2GLQju2kotu+2ndWWzx1skgMT86aN4Qc+
         Zvwg==
X-Gm-Message-State: AOJu0YzDZDzCT4iuLy7UQkhMo1OjQGGa1UUfUIEfkOvoa4irAjz0Jd+A
	ZR4ecP2e04BohpJHeeizwZKI4zQlb4XisVxKxlfdAIFHBAnt494kW6Pwav4QXF1GoxgD1/Ib3sM
	nY7zFgQB7sC/H
X-Received: by 2002:a17:906:db08:b0:9dd:f5ba:856d with SMTP id xj8-20020a170906db0800b009ddf5ba856dmr3819985ejb.62.1699199897429;
        Sun, 05 Nov 2023 07:58:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEybgJfekAZesQ+akyhDcdHp9NNqn1nBxIeCP8wqicCb5vXKmYeJbRaNub+H3s331kYxYmE9A==
X-Received: by 2002:a17:906:db08:b0:9dd:f5ba:856d with SMTP id xj8-20020a170906db0800b009ddf5ba856dmr3819966ejb.62.1699199896993;
        Sun, 05 Nov 2023 07:58:16 -0800 (PST)
Received: from redhat.com ([2.55.35.234])
        by smtp.gmail.com with ESMTPSA id qw23-20020a1709066a1700b009dd949b75c7sm2460591ejc.151.2023.11.05.07.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Nov 2023 07:58:16 -0800 (PST)
Date: Sun, 5 Nov 2023 10:58:06 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	dtatulea@nvidia.com, eperezma@redhat.com, geert+renesas@glider.be,
	gregkh@linuxfoundation.org, jasowang@redhat.com, leiyang@redhat.com,
	leon@kernel.org, mst@redhat.com, pizhenwei@bytedance.com,
	sgarzare@redhat.com, shannon.nelson@amd.com,
	shawn.shao@jaguarmicro.com, simon.horman@corigine.com,
	si-wei.liu@oracle.com, xieyongji@bytedance.com,
	xuanzhuo@linux.alibaba.com, xueshi.hu@smartx.com
Subject: [GIT PULL] vhost,virtio,vdpa: features, fixes, cleanups
Message-ID: <20231105105806-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent

The following changes since commit ffc253263a1375a65fa6c9f62a893e9767fbebfa:

  Linux 6.6 (2023-10-29 16:31:08 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 86f6c224c97911b4392cb7b402e6a4ed323a449e:

  vdpa_sim: implement .reset_map support (2023-11-01 09:20:00 -0400)

----------------------------------------------------------------
vhost,virtio,vdpa: features, fixes, cleanups

vdpa/mlx5:
	VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK
	new maintainer
vdpa:
	support for vq descriptor mappings
	decouple reset of iotlb mapping from device reset

fixes, cleanups all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dragos Tatulea (14):
      vdpa/mlx5: Expose descriptor group mkey hw capability
      vdpa/mlx5: Create helper function for dma mappings
      vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code
      vdpa/mlx5: Take cvq iotlb lock during refresh
      vdpa/mlx5: Collapse "dvq" mr add/delete functions
      vdpa/mlx5: Rename mr destroy functions
      vdpa/mlx5: Allow creation/deletion of any given mr struct
      vdpa/mlx5: Move mr mutex out of mr struct
      vdpa/mlx5: Improve mr update flow
      vdpa/mlx5: Introduce mr for vq descriptor
      vdpa/mlx5: Enable hw support for vq descriptor mapping
      vdpa/mlx5: Make iotlb helper functions more generic
      vdpa/mlx5: Update cvq iotlb mapping on ASID change
      MAINTAINERS: Add myself as mlx5_vdpa driver

Eugenio Pérez (1):
      mlx5_vdpa: offer VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK

Geert Uytterhoeven (1):
      vhost-scsi: Spelling s/preceeding/preceding/g

Greg Kroah-Hartman (1):
      vduse: make vduse_class constant

Michael S. Tsirkin (1):
      Merge branch 'mlx5-vhost' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git

Shannon Nelson (1):
      virtio: kdoc for struct virtio_pci_modern_device

Shawn.Shao (1):
      vdpa: Update sysfs ABI documentation

Si-Wei Liu (10):
      vdpa: introduce dedicated descriptor group for virtqueue
      vhost-vdpa: introduce descriptor group backend feature
      vhost-vdpa: uAPI to get dedicated descriptor group id
      vdpa: introduce .reset_map operation callback
      vhost-vdpa: reset vendor specific mapping to initial state in .release
      vhost-vdpa: introduce IOTLB_PERSIST backend feature bit
      vdpa: introduce .compat_reset operation callback
      vhost-vdpa: clean iotlb map during reset for older userspace
      vdpa/mlx5: implement .reset_map driver op
      vdpa_sim: implement .reset_map support

Xuan Zhuo (3):
      virtio: add definition of VIRTIO_F_NOTIF_CONFIG_DATA feature bit
      virtio_pci: add build offset check for the new common cfg items
      virtio_pci: add check for common cfg size

Xueshi Hu (1):
      virtio-balloon: correct the comment of virtballoon_migratepage()

zhenwei pi (1):
      virtio-blk: fix implicit overflow on virtio_max_dma_size

 Documentation/ABI/testing/sysfs-bus-vdpa |   4 +-
 MAINTAINERS                              |   6 +
 drivers/block/virtio_blk.c               |   4 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h       |  32 +++--
 drivers/vdpa/mlx5/core/mr.c              | 213 +++++++++++++++++++------------
 drivers/vdpa/mlx5/core/resources.c       |   6 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c        | 137 +++++++++++++++-----
 drivers/vdpa/vdpa_sim/vdpa_sim.c         |  52 ++++++--
 drivers/vdpa/vdpa_user/vduse_dev.c       |  40 +++---
 drivers/vhost/scsi.c                     |   2 +-
 drivers/vhost/vdpa.c                     |  79 +++++++++++-
 drivers/virtio/virtio_balloon.c          |   2 +-
 drivers/virtio/virtio_pci_modern.c       |  36 ++++++
 drivers/virtio/virtio_pci_modern_dev.c   |   6 +-
 drivers/virtio/virtio_vdpa.c             |   2 +-
 include/linux/mlx5/mlx5_ifc.h            |   8 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h       |   7 +-
 include/linux/vdpa.h                     |  41 +++++-
 include/linux/virtio_pci_modern.h        |  35 +++--
 include/uapi/linux/vhost.h               |   8 ++
 include/uapi/linux/vhost_types.h         |   7 +
 include/uapi/linux/virtio_config.h       |   5 +
 22 files changed, 546 insertions(+), 186 deletions(-)



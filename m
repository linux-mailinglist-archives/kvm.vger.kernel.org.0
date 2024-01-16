Return-Path: <kvm+bounces-6344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4DB582F261
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 17:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 999B11F2459F
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFD11CA95;
	Tue, 16 Jan 2024 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFshD34x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6041C6A4
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705422515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=OF/f9SqDfQjcSElQnS0yY6s/dBYlZKzDcj9s0+Wh2f8=;
	b=AFshD34x282Vr2XmVuuol3SNpEAG6rMqPLhY8aAXX/LlXI8gfsXuMOHjA3525reUltdZzN
	HypDg1CmjjPSN/eso24bvkIXSex0LpHfCQNjpL/SqBEHlYhPeUAn74QGRZw9OKZX0kdo9e
	scVvruX6mK1zQAkbBJVDABMYsWtEhYM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-tKmqRuXQNY2kxVuxPIjRdg-1; Tue, 16 Jan 2024 11:28:33 -0500
X-MC-Unique: tKmqRuXQNY2kxVuxPIjRdg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40e863cb806so4132105e9.2
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 08:28:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705422512; x=1706027312;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OF/f9SqDfQjcSElQnS0yY6s/dBYlZKzDcj9s0+Wh2f8=;
        b=nfAqJjP2PIzuK6fJcbuuIdMvbUZhp5eMoOxDQoexikaqrRHVHovK5gLbJK77nuSoiL
         udxPKpilHi1gx+1HgwJdONcGFX4RxLK7gVOfbF2B3ZSLBNYQxmuK2RnLCQmQRiY+/wty
         yqN3042DCPi7V2Bk86jWfxORXJjNxTkCd1FVRIOQLq5+41UW9SGzIsZJpOAP0zV5ujgs
         61UK9eozDlUhBxn/WjqtpJ3ZOsirUAlD3KlmKI5tCRz1H3HoKHXR7lxojLjb1MRkcoot
         SbHFzv/TpKrBDEDjGAJIRwEnY3EKtbUic9IS0TaK5y9Mo7LEUKO2S9X1XjbNe82U0kTm
         x0rw==
X-Gm-Message-State: AOJu0YwSU/qqIizbaoTOHCYE0derbEEU/G9zipNpgidDC1GJtxSeG2sC
	baqpBOdWKwgeiR5A8yoF0+Wlr1PGgJsEnZOj+jYQkIhy0dM1DLQ2DVTsCU9voKB1YlKqJ+kRDjt
	PdEm6E3TUFJU+Ma0BKzDv
X-Received: by 2002:a05:600c:257:b0:40e:7e40:10c6 with SMTP id 23-20020a05600c025700b0040e7e4010c6mr739602wmj.182.1705422512706;
        Tue, 16 Jan 2024 08:28:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4EwY4rnvc1dXkvUnzrtlQb0sW9f8GFlzYKtabODe5zsH9sA7U7cGUZRKyhXjVGQXqLCiWCQ==
X-Received: by 2002:a05:600c:257:b0:40e:7e40:10c6 with SMTP id 23-20020a05600c025700b0040e7e4010c6mr739594wmj.182.1705422512444;
        Tue, 16 Jan 2024 08:28:32 -0800 (PST)
Received: from redhat.com ([2.52.29.192])
        by smtp.gmail.com with ESMTPSA id bg42-20020a05600c3caa00b0040e3733a32bsm23560519wmb.41.2024.01.16.08.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 08:28:31 -0800 (PST)
Date: Tue, 16 Jan 2024 11:28:28 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	changyuanl@google.com, christophe.jaillet@wanadoo.fr,
	dtatulea@nvidia.com, eperezma@redhat.com, jasowang@redhat.com,
	michael.christie@oracle.com, mst@redhat.com,
	pasha.tatashin@soleen.com, rientjes@google.com,
	stevensd@chromium.org, tytso@mit.edu, xuanzhuo@linux.alibaba.com
Subject: [GIT PULL] virtio: features, fixes
Message-ID: <20240116112828-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit b8e0792449928943c15d1af9f63816911d139267:

  virtio_blk: fix snprintf truncation compiler warning (2023-12-04 09:43:53 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to f16d65124380ac6de8055c4a8e5373a1043bb09b:

  vdpa/mlx5: Add mkey leak detection (2024-01-10 13:01:38 -0500)

----------------------------------------------------------------
virtio: features, fixes

vdpa/mlx5: support for resumable vqs
virtio_scsi: mq_poll support
3virtio_pmem: support SHMEM_REGION
virtio_balloon: stay awake while adjusting balloon
virtio: support for no-reset virtio PCI PM

Fixes, cleanups.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Changyuan Lyu (1):
      virtio_pmem: support feature SHMEM_REGION

Christophe JAILLET (2):
      vdpa: Fix an error handling path in eni_vdpa_probe()
      vdpa: Remove usage of the deprecated ida_simple_xx() API

David Stevens (2):
      virtio: Add support for no-reset virtio PCI PM
      virtio_balloon: stay awake while adjusting balloon

Dragos Tatulea (10):
      vdpa: Track device suspended state
      vdpa: Block vq property changes in DRIVER_OK
      vdpa/mlx5: Expose resumable vq capability
      vdpa/mlx5: Allow modifying multiple vq fields in one modify command
      vdpa/mlx5: Introduce per vq and device resume
      vdpa/mlx5: Mark vq addrs for modification in hw vq
      vdpa/mlx5: Mark vq state for modification in hw vq
      vdpa/mlx5: Use vq suspend/resume during .set_map
      vdpa/mlx5: Introduce reference counting to mrs
      vdpa/mlx5: Add mkey leak detection

Mike Christie (1):
      scsi: virtio_scsi: Add mq_poll support

Pasha Tatashin (1):
      vhost-vdpa: account iommu allocations

Xuan Zhuo (1):
      virtio_net: fix missing dma unmap for resize

 drivers/net/virtio_net.c           |  60 +++++------
 drivers/nvdimm/virtio_pmem.c       |  36 ++++++-
 drivers/scsi/virtio_scsi.c         |  78 +++++++++++++-
 drivers/vdpa/alibaba/eni_vdpa.c    |   6 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  10 +-
 drivers/vdpa/mlx5/core/mr.c        |  73 ++++++++++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 209 +++++++++++++++++++++++++++++++++----
 drivers/vdpa/vdpa.c                |   4 +-
 drivers/vhost/vdpa.c               |  26 ++++-
 drivers/virtio/virtio_balloon.c    |  57 ++++++++--
 drivers/virtio/virtio_pci_common.c |  34 +++++-
 include/linux/mlx5/mlx5_ifc.h      |   3 +-
 include/linux/mlx5/mlx5_ifc_vdpa.h |   4 +
 include/uapi/linux/virtio_pmem.h   |   7 ++
 14 files changed, 510 insertions(+), 97 deletions(-)



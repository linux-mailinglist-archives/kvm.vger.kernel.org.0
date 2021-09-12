Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD26407B06
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 02:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbhILAG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Sep 2021 20:06:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhILAGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 11 Sep 2021 20:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631405111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=IT3HnjaxFEROeN2QLWVUnViJA5HfWYlX8v34IjIoBJ4=;
        b=Z/OBVjg3RrCbJV6xKufakfgyAe+ZGsZxm//1dI9zedVKXZSaqRUi246tenC2anS3NlCSjx
        HP8fYzqIuM6IGfAISohpMEFQGsPlkyKlgZPUaYHvn+vWt/vzKbm2xiUWU2O0NB9iBWU29N
        n4zU+dEz1pJ44TW4eJEkbkgdRu0Jp84=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-_psnXOFSMWO7C7GXJ9g4Mw-1; Sat, 11 Sep 2021 20:05:10 -0400
X-MC-Unique: _psnXOFSMWO7C7GXJ9g4Mw-1
Received: by mail-wm1-f70.google.com with SMTP id c187-20020a1c35c4000000b00304b489f2d8so1042301wma.6
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 17:05:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=IT3HnjaxFEROeN2QLWVUnViJA5HfWYlX8v34IjIoBJ4=;
        b=SUo9/IGsLf3khi1KeXEqFi+RP0tZA9/lxYTHiYfpvcWNkNWXLi262GQL5aqSnQ62u1
         lSlqkD+mUQ8wcE7fbtLQ+3Fx6v4dUevinNSPGGrl3gR8X40OQjJuZmmwxU7cjnKNVcLQ
         wy3SpdBHRXycUo7rcm/GLyAMfhbfqv79/HvnZTd5sj9nyplH6HI18f5VTI+obZDQTP8N
         9AD7XAonYG0KVOIglDEwIlPdUltPGjIIZ3BCfy0tXFitZ6TLMZz/8aZw07FS0K/6fca4
         M/k2e+I8hJcutzWmVh8sRH7worf5dmWxh9pjpIIe3JtnnTLYKmGZrKECCD4UMYIaVEfB
         ++MQ==
X-Gm-Message-State: AOAM531CTzikPyeaZf0UXfU0XoBR0iLuNfuaV8Ow7ebax9ClU3zHdUfu
        hVmyVhzUBRxLL4PG4wSMjoENdemi2wHR/OxO9ald9BHxsEkhbe1J4xC5ai6AccnT1h46ZCVbZRN
        Du1rqx1iexvZf
X-Received: by 2002:a7b:cb45:: with SMTP id v5mr4300623wmj.184.1631405109550;
        Sat, 11 Sep 2021 17:05:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJxDHhrbMVL4dF3568IhBCMK63Z2YRX3A33U25nv3obGFgziyRVxdJ4k5PO4+KjiDxM/Zjgg==
X-Received: by 2002:a7b:cb45:: with SMTP id v5mr4300606wmj.184.1631405109371;
        Sat, 11 Sep 2021 17:05:09 -0700 (PDT)
Received: from redhat.com ([2.55.27.174])
        by smtp.gmail.com with ESMTPSA id t18sm2841775wrp.97.2021.09.11.17.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 17:05:08 -0700 (PDT)
Date:   Sat, 11 Sep 2021 20:05:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mgurtovoy@nvidia.com, mst@redhat.com, viresh.kumar@linaro.org,
        wsa@kernel.org, xianting.tian@linux.alibaba.com,
        xieyongji@bytedance.com
Subject: [GIT PULL V2] virtio,vdpa,vhost: features, fixes
Message-ID: <20210911200504-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes from v1:
	dropped vdpa bits until we are sure how they are
	supposed to interact with recent upstream changes

The following changes since commit 7d2a07b769330c34b4deabeed939325c77a7ec2f:

  Linux 5.14 (2021-08-29 15:04:50 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus_v2

for you to fetch changes up to 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d:

  virtio-blk: remove unneeded "likely" statements (2021-09-06 07:20:56 -0400)

----------------------------------------------------------------
virtio,vdpa,vhost: features, fixes

virtio-vsock support for end of record with SEQPACKET
vdpa: mac and mq support for ifcvf and mlx5
vdpa: management netlink for ifcvf
virtio-i2c, gpio dt bindings

misc fixes, cleanups

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Arseny Krasnov (6):
      virtio/vsock: rename 'EOR' to 'EOM' bit.
      virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
      vhost/vsock: support MSG_EOR bit processing
      virtio/vsock: support MSG_EOR bit processing
      af_vsock: rename variables in receive loop
      vsock_test: update message bounds test for MSG_EOR

Cai Huoqing (2):
      vhost scsi: Convert to SPDX identifier
      vdpa: Make use of PFN_PHYS/PFN_UP/PFN_DOWN helper macro

Eli Cohen (6):
      vdpa/mlx5: Remove redundant header file inclusion
      vdpa/mlx5: function prototype modifications in preparation to control VQ
      vdpa/mlx5: Decouple virtqueue callback from struct mlx5_vdpa_virtqueue
      vdpa/mlx5: Ensure valid indices are provided
      vdpa/mlx5: Add support for control VQ and MAC setting
      vdpa/mlx5: Add multiqueue support

Max Gurtovoy (1):
      virtio-blk: remove unneeded "likely" statements

Viresh Kumar (5):
      dt-bindings: virtio: Add binding for virtio devices
      dt-bindings: i2c: Add bindings for i2c-virtio
      dt-bindings: gpio: Add bindings for gpio-virtio
      uapi: virtio_ids: Sync ids with specification
      virtio: Bind virtio device to device-tree node

Xianting Tian (1):
      virtio-balloon: Use virtio_find_vqs() helper

Xie Yongji (1):
      vdpa_sim: Use iova_shift() for the size passed to alloc_iova()

Zhu Lingshan (4):
      vDPA/ifcvf: introduce get_dev_type() which returns virtio dev id
      vDPA/ifcvf: implement management netlink framework for ifcvf
      vDPA/ifcvf: detect and use the onboard number of queues directly
      vDPA/ifcvf: enable multiqueue and control vq

 .../devicetree/bindings/gpio/gpio-virtio.yaml      |  59 +++
 .../devicetree/bindings/i2c/i2c-virtio.yaml        |  51 ++
 Documentation/devicetree/bindings/virtio/mmio.yaml |   3 +-
 .../devicetree/bindings/virtio/virtio-device.yaml  |  41 ++
 drivers/block/virtio_blk.c                         |   4 +-
 drivers/vdpa/Kconfig                               |   1 +
 drivers/vdpa/ifcvf/ifcvf_base.c                    |   8 +-
 drivers/vdpa/ifcvf/ifcvf_base.h                    |  25 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    | 224 ++++++---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |  26 +-
 drivers/vdpa/mlx5/core/mr.c                        |  81 +++-
 drivers/vdpa/mlx5/core/resources.c                 |  35 ++
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 517 ++++++++++++++++++---
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   3 +-
 drivers/vhost/scsi.c                               |  14 +-
 drivers/vhost/vdpa.c                               |  24 +-
 drivers/vhost/vsock.c                              |  28 +-
 drivers/virtio/virtio.c                            |  57 ++-
 drivers/virtio/virtio_balloon.c                    |   4 +-
 include/uapi/linux/virtio_ids.h                    |  12 +
 include/uapi/linux/virtio_vsock.h                  |   3 +-
 net/vmw_vsock/af_vsock.c                           |  10 +-
 net/vmw_vsock/virtio_transport_common.c            |  23 +-
 tools/testing/vsock/vsock_test.c                   |   8 +-
 24 files changed, 1030 insertions(+), 231 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-virtio.yaml
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-virtio.yaml
 create mode 100644 Documentation/devicetree/bindings/virtio/virtio-device.yaml


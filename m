Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7E4449A9
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 21:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhKCUqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 16:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230172AbhKCUqV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 16:46:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635972224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ycJtGdUUCpH0aUUTnC/bRRS7vczLyB6170Uz115xpB0=;
        b=OhSknohhuGMz0aKC9Y7DqfFYwKoz7tw2pItrAnGQSV4PlFtr+HB8r/Lqrk1MSGFRhYXoO8
        dFnD+WP7ynRQZq2FokBLIusH3o6tHiXT+mxPK4YM/1nM68iHOY1KMVTDmOfxXr1LtAO2It
        Un5QE+c2DTwVnvZFUA2ypBv/PmicmvM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-_4yzhOzQNm2zWddsU3IR2Q-1; Wed, 03 Nov 2021 16:43:39 -0400
X-MC-Unique: _4yzhOzQNm2zWddsU3IR2Q-1
Received: by mail-wm1-f69.google.com with SMTP id m1-20020a1ca301000000b003231d5b3c4cso3298798wme.5
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 13:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ycJtGdUUCpH0aUUTnC/bRRS7vczLyB6170Uz115xpB0=;
        b=Lu/g/ML365r7EzrqpTO5bOXqsK07NMwnelOTZW28Rt2gZb5fLU4/alPj3kd96bGend
         YpAR7eqjVddarKwPD9YX8bxnwezrqGDhX3qLj83DysspuJQXCD5EiSAwKbsZmt3V1mkO
         pgzOAZBrxubXuFf0GiFiNVzbgYXwRx/9iISeIEGFl4Qe4F3YrtZQdWPNyvQPSUoOsiL0
         g5yUZpC+jMt8wKEIs4oFpLogpmnp+ItqjT+RJVeQEbhFIBWMs6RZ4nvBYEXjr/8533wd
         O3rt0fAFMGJi9waPt26Y0StkFr8VpbHCjQIDVnJkeTxaCpc6ZakKzRpO6Tdj7CdxvpG8
         Vh7A==
X-Gm-Message-State: AOAM531zOxQi4hIgtn93pqiKdJz4cUUm2LSORZ0SOxkhvwHDBlPoyEo5
        e1XJGYSeeWKD83kQ0BVnAuBv4tK0Q/ArIRrTwLE8Rm5fpaArQcCqit5GU7LavbOLBPg3foHhVOY
        2iMoxgvdcv4en
X-Received: by 2002:a7b:c8d5:: with SMTP id f21mr16301024wml.146.1635972217845;
        Wed, 03 Nov 2021 13:43:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAOxXMQNUWbZpukHMPxGSMFHowFfE8y2JMN+RYHabViAVvjlT9WYHd7lkudlHiVcf5NGesSg==
X-Received: by 2002:a7b:c8d5:: with SMTP id f21mr16300998wml.146.1635972217669;
        Wed, 03 Nov 2021 13:43:37 -0700 (PDT)
Received: from redhat.com ([2.55.17.31])
        by smtp.gmail.com with ESMTPSA id z11sm2978466wrt.58.2021.11.03.13.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:43:37 -0700 (PDT)
Date:   Wed, 3 Nov 2021 16:43:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit@kernel.org, arnd@arndb.de, boqun.feng@gmail.com,
        colin.i.king@gmail.com, colin.i.king@googlemail.com,
        corentin.noel@collabora.com, elic@nvidia.com,
        gustavoars@kernel.org, jasowang@redhat.com, jie.deng@intel.com,
        lkp@intel.com, lvivier@redhat.com, mgurtovoy@nvidia.com,
        mst@redhat.com, pankaj.gupta@ionos.com,
        pankaj.gupta.linux@gmail.com, parav@nvidia.com, paulmck@kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, sgarzare@redhat.com,
        stefanha@redhat.com, tglx@linutronix.de, viresh.kumar@linaro.org,
        wuzongyong@linux.alibaba.com, xuanzhuo@linux.alibaba.com,
        ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject: [GIT PULL] vhost,virtio,vhost: fixes,features
Message-ID: <20211103164332-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 8bb7eca972ad531c9b149c0a51ab43a417385813:

  Linux 5.15 (2021-10-31 13:53:10 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 540061ac79f0302ae91e44e6cd216cbaa3af1757:

  vdpa/mlx5: Forward only packets with allowed MAC address (2021-11-01 05:26:49 -0400)

----------------------------------------------------------------
vhost,virtio,vhost: fixes,features

Hardening work by Jason
vdpa driver for Alibaba ENI
Performance tweaks for virtio blk
virtio rng rework using an internal buffer
mac/mtu programming for mlx5 vdpa
Misc fixes, cleanups

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Colin Ian King (1):
      virtio_blk: Fix spelling mistake: "advertisted" -> "advertised"

Eli Cohen (5):
      vdpa/mlx5: Remove mtu field from vdpa net device
      vdpa/mlx5: Rename control VQ workqueue to vdpa wq
      vdpa/mlx5: Propagate link status from device to vdpa driver
      vdpa/mlx5: Support configuration of MAC
      vdpa/mlx5: Forward only packets with allowed MAC address

Gustavo A. R. Silva (1):
      ALSA: virtio: Replace zero-length array with flexible-array member

Jason Wang (10):
      virtio-blk: validate num_queues during probe
      virtio_console: validate max_nr_ports before trying to use it
      virtio_config: introduce a new .enable_cbs method
      virtio_pci: harden MSI-X interrupts
      virtio-pci: harden INTX interrupts
      virtio_ring: fix typos in vring_desc_extra
      virtio_ring: validate used buffer length
      virtio-net: don't let virtio core to validate used length
      virtio-blk: don't let virtio core to validate used length
      virtio-scsi: don't let virtio core to validate used buffer length

Laurent Vivier (4):
      hwrng: virtio - add an internal buffer
      hwrng: virtio - don't wait on cleanup
      hwrng: virtio - don't waste entropy
      hwrng: virtio - always add a pending request

Max Gurtovoy (2):
      virtio-blk: avoid preallocating big SGL for data
      virtio-blk: add num_request_queues module parameter

Michael S. Tsirkin (3):
      virtio_net: clarify tailroom logic
      virtio_blk: allow 0 as num_request_queues
      virtio_blk: correct types for status handling

Pankaj Gupta (1):
      virtio-pmem: add myself as virtio-pmem maintainer

Parav Pandit (6):
      vdpa: Introduce and use vdpa device get, set config helpers
      vdpa: Introduce query of device config layout
      vdpa: Use kernel coding style for structure comments
      vdpa: Enable user to set mac and mtu of vdpa device
      vdpa_sim_net: Enable user to set mac address and mtu
      vdpa/mlx5: Fix clearing of VIRTIO_NET_F_MAC feature bit

Viresh Kumar (1):
      i2c: virtio: Add support for zero-length requests

Wu Zongyong (8):
      virtio-pci: introduce legacy device module
      vdpa: fix typo
      vp_vdpa: add vq irq offloading support
      vdpa: add new callback get_vq_num_min in vdpa_config_ops
      vdpa: min vq num of vdpa device cannot be greater than max vq num
      virtio_vdpa: setup correct vq size with callbacks get_vq_num_{max,min}
      vdpa: add new attribute VDPA_ATTR_DEV_MIN_VQ_SIZE
      eni_vdpa: add vDPA driver for Alibaba ENI

Xuan Zhuo (2):
      virtio_ring: make virtqueue_add_indirect_packed prettier
      virtio_ring: check desc == NULL when using indirect with packed

Ye Guojin (1):
      virtio-blk: fixup coccinelle warnings

 MAINTAINERS                            |   7 +
 drivers/block/Kconfig                  |   1 +
 drivers/block/virtio_blk.c             | 178 +++++++----
 drivers/char/hw_random/virtio-rng.c    |  84 +++--
 drivers/char/virtio_console.c          |   9 +
 drivers/i2c/busses/i2c-virtio.c        |  56 ++--
 drivers/net/virtio_net.c               |   4 +-
 drivers/scsi/virtio_scsi.c             |   1 +
 drivers/vdpa/Kconfig                   |   8 +
 drivers/vdpa/Makefile                  |   1 +
 drivers/vdpa/alibaba/Makefile          |   3 +
 drivers/vdpa/alibaba/eni_vdpa.c        | 553 +++++++++++++++++++++++++++++++++
 drivers/vdpa/ifcvf/ifcvf_main.c        |   3 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h     |   2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c      | 202 ++++++++++--
 drivers/vdpa/vdpa.c                    | 261 +++++++++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c   |   3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c   |  38 ++-
 drivers/vdpa/vdpa_user/vduse_dev.c     |   3 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c      |  12 +
 drivers/vhost/vdpa.c                   |   3 +-
 drivers/virtio/Kconfig                 |  10 +
 drivers/virtio/Makefile                |   1 +
 drivers/virtio/virtio_pci_common.c     |  58 +++-
 drivers/virtio/virtio_pci_common.h     |  16 +-
 drivers/virtio/virtio_pci_legacy.c     | 106 ++-----
 drivers/virtio/virtio_pci_legacy_dev.c | 220 +++++++++++++
 drivers/virtio/virtio_pci_modern.c     |   6 +-
 drivers/virtio/virtio_ring.c           |  90 +++++-
 drivers/virtio/virtio_vdpa.c           |  19 +-
 include/linux/vdpa.h                   |  53 ++--
 include/linux/virtio.h                 |   2 +
 include/linux/virtio_config.h          |   6 +
 include/linux/virtio_pci_legacy.h      |  42 +++
 include/uapi/linux/vdpa.h              |   7 +
 include/uapi/linux/virtio_i2c.h        |   6 +
 sound/virtio/virtio_pcm_msg.c          |   5 +-
 37 files changed, 1781 insertions(+), 298 deletions(-)
 create mode 100644 drivers/vdpa/alibaba/Makefile
 create mode 100644 drivers/vdpa/alibaba/eni_vdpa.c
 create mode 100644 drivers/virtio/virtio_pci_legacy_dev.c
 create mode 100644 include/linux/virtio_pci_legacy.h


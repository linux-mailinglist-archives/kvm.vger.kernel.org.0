Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF121A852A
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391825AbgDNQgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:36:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35680 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391804AbgDNQg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 12:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586882187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Bma9lzqspxl+HaX8bOFBirR9lSGp5CwUCJdb2i/e18Q=;
        b=dOWLE8WqA4A5HAxi0P3RPoJcrIXAXMmTkLygoAf3Yr4XpYwq+9GylDMk7kPD2Ehcahs316
        2O/OmkgH/FDc/Nq6cj9wV9egccg5EToRhqymPv7sU4WiKr5pt+9wt0CoheGtdJO2yjJtHY
        rOg8yf3kCeB1qnzDlbqbBgTFVISQDSY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-g0kLvAKbOjKW-waCc1_L1w-1; Tue, 14 Apr 2020 12:36:12 -0400
X-MC-Unique: g0kLvAKbOjKW-waCc1_L1w-1
Received: by mail-qk1-f200.google.com with SMTP id f187so10833972qkd.11
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 09:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=Bma9lzqspxl+HaX8bOFBirR9lSGp5CwUCJdb2i/e18Q=;
        b=o+CwTHxpouBhTsY8KaoXRvesfyS1Gp9qTekIs1wP2RuaNg6l+PBqw+JQs+3JFTSVNh
         b/n68YRcyCrIfWoacKJEjPcFehC0RNthJp1bqpHBLP45OvaWQEtSSs8yfopDsKjM3BFK
         YXvJEgfQE1g923e1nhEtFBGJmwlpQqdOVi3bspzrsedTw6POHM+opYHTGkAKnf6IwWsl
         Sml5ngXoBBBguAAULsotIoC7FC01LQxo/xK07wQFzJVw+7TFB3x+3krGBM4C0oenUGKg
         k+UJRGZxMociTDVsDlqXtqwYYk4jtZ7/8mYttZwZuLYKAjNcPi8IFkQVvwO/+PoxtkTZ
         LRZw==
X-Gm-Message-State: AGi0PuaFvI+8oZV3WeP3jwLrlYRVjSX+qn91UdBrQ9OAlRyek4XCHSas
        5XKWp8vKb1JPbDUzqmZPizbB+G8mCCC/deu7k3rnBtvIK/5UdSPcytT25Mm5d5eHtEpvw3XGCvy
        8NveapOB7V/ar
X-Received: by 2002:aed:3968:: with SMTP id l95mr17285847qte.268.1586882172264;
        Tue, 14 Apr 2020 09:36:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypJmGmy3GlXUch/z8/x+Ns406G7xQ35JzF4VsBJ4waQC3oBq6dZNWOjBqM2wZ8BVLIAkuD0c8Q==
X-Received: by 2002:aed:3968:: with SMTP id l95mr17285823qte.268.1586882171965;
        Tue, 14 Apr 2020 09:36:11 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id u126sm10933237qkh.66.2020.04.14.09.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 09:36:11 -0700 (PDT)
Date:   Tue, 14 Apr 2020 12:36:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, arnd@arndb.de, ashutosh.dixit@intel.com,
        bjorn.andersson@linaro.org, elfring@users.sourceforge.net,
        eli@mellanox.com, eperezma@redhat.com, gustavo@embeddedor.com,
        hulkci@huawei.com, jasowang@redhat.com, matej.genci@nutanix.com,
        mst@redhat.com, sfr@canb.auug.org.au, yanaijie@huawei.com,
        yuehaibing@huawei.com
Subject: [GIT PULL] vhost: cleanups and fixes
Message-ID: <20200414123606-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 835a6a649d0dd1b1f46759eb60fff2f63ed253a7:

  virtio-balloon: Revert "virtio-balloon: Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM" (2020-04-07 05:44:57 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to d4a85c2ace895a58dcab687ff49c76719011f58d:

  vdpa: fix comment of vdpa_register_device() (2020-04-13 07:16:41 -0400)

----------------------------------------------------------------
virtio: fixes, cleanups

Some bug fixes.
Cleanup a couple of issues that surfaced meanwhile.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eugenio Pérez (4):
      vhost: Create accessors for virtqueues private_data
      tools/virtio: Add --batch option
      tools/virtio: Add --batch=random option
      tools/virtio: Add --reset=random

Gustavo A. R. Silva (1):
      vhost: vdpa: remove unnecessary null check

Jason Wang (1):
      vdpa: fix comment of vdpa_register_device()

Jason Yan (1):
      vhost: remove set but not used variable 'status'

Markus Elfring (1):
      virtio-mmio: Delete an error message in vm_find_vqs()

Matej Genci (1):
      virtio: add VIRTIO_RING_NO_LEGACY

Michael S. Tsirkin (22):
      vdpa-sim: depend on HAS_DMA
      virtio/test: fix up after IOTLB changes
      vhost: drop vring dependency on iotlb
      tools/virtio: define aligned attribute
      tools/virtio: make asm/barrier.h self contained
      tools/virtio: define __KERNEL__
      virtgpu: pull in uaccess.h
      virtio-rng: pull in slab.h
      remoteproc: pull in slab.h
      virtio_input: pull in slab.h
      rpmsg: pull in slab.h
      remoteproc: pull in slab.h
      virtio: stop using legacy struct vring in kernel
      vhost: force spec specified alignment on types
      virtio: add legacy init/size APIs
      virtio_ring: switch to virtio_legacy_init/size
      tools/virtio: switch to virtio_legacy_init/size
      vop: switch to virtio_legacy_init/size
      remoteproc: switch to virtio_legacy_init/size
      mellanox: switch to virtio_legacy_init/size
      vdpa: allow a 32 bit vq alignment
      vdpa: make vhost, virtio depend on menu

Stephen Rothwell (1):
      drm/virtio: fix up for include file changes

YueHaibing (2):
      vdpa: remove unused variables 'ifcvf' and 'ifcvf_lm'
      vdpasim: Return status in vdpasim_get_status

 drivers/block/virtio_blk.c               |   1 +
 drivers/char/hw_random/virtio-rng.c      |   1 +
 drivers/gpu/drm/virtio/virtgpu_ioctl.c   |   1 +
 drivers/gpu/drm/virtio/virtgpu_kms.c     |   1 +
 drivers/misc/mic/vop/vop_main.c          |   5 +-
 drivers/misc/mic/vop/vop_vringh.c        |   8 ++-
 drivers/platform/mellanox/mlxbf-tmfifo.c |   6 +-
 drivers/remoteproc/remoteproc_core.c     |   2 +-
 drivers/remoteproc/remoteproc_sysfs.c    |   1 +
 drivers/remoteproc/remoteproc_virtio.c   |   2 +-
 drivers/remoteproc/stm32_rproc.c         |   1 +
 drivers/rpmsg/mtk_rpmsg.c                |   1 +
 drivers/vdpa/Kconfig                     |  19 +++---
 drivers/vdpa/ifcvf/ifcvf_base.c          |   2 -
 drivers/vdpa/ifcvf/ifcvf_main.c          |   4 +-
 drivers/vdpa/vdpa.c                      |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c         |   4 +-
 drivers/vhost/Kconfig                    |   5 +-
 drivers/vhost/net.c                      |  28 +++++----
 drivers/vhost/scsi.c                     |  14 ++---
 drivers/vhost/test.c                     |  71 +++++++++++++++++++---
 drivers/vhost/test.h                     |   1 +
 drivers/vhost/vdpa.c                     |   5 --
 drivers/vhost/vhost.h                    |  33 +++++++++-
 drivers/vhost/vringh.c                   |   5 ++
 drivers/vhost/vsock.c                    |  14 ++---
 drivers/virtio/Kconfig                   |   2 +-
 drivers/virtio/virtio_input.c            |   1 +
 drivers/virtio/virtio_mmio.c             |   4 +-
 drivers/virtio/virtio_pci_modern.c       |   1 +
 drivers/virtio/virtio_ring.c             |  15 +++--
 include/linux/vdpa.h                     |   2 +-
 include/linux/virtio.h                   |   1 -
 include/linux/virtio_ring.h              |  46 ++++++++++++++
 include/linux/vringh.h                   |   7 +++
 include/uapi/linux/virtio_ring.h         |  30 ++++++---
 tools/virtio/Makefile                    |   5 +-
 tools/virtio/asm/barrier.h               |   1 +
 tools/virtio/generated/autoconf.h        |   0
 tools/virtio/linux/compiler.h            |   1 +
 tools/virtio/ringtest/virtio_ring_0_9.c  |   6 +-
 tools/virtio/virtio_test.c               | 101 ++++++++++++++++++++++++++-----
 tools/virtio/vringh_test.c               |  18 +++---
 43 files changed, 354 insertions(+), 124 deletions(-)
 create mode 100644 tools/virtio/generated/autoconf.h


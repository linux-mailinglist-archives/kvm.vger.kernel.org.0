Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEDC1B1674
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 22:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgDTUAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 16:00:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726412AbgDTUAL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 16:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587412809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+20lqtsdLoetbi1VKrLQV/f/K/xwxYS/9ftQPVBgJ9o=;
        b=frFIeFvB88aMDcJ6igS/aDBKi3T1xldX3PIzPhYcljPwdZlnLG7mC/DfVFy4pRtHsXNkqh
        oT4AlUgq+BVSudR4M+OUyS7cBGglqO+mzXMFlOl3kwa1ZSGjfYDQnGPSwsoV7Zx8CzNx1R
        nPSK9MeDxRJ9QWn7vTP01Scvgb0NE2g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-TaIhbuThMniXyITOr9DJ1Q-1; Mon, 20 Apr 2020 16:00:06 -0400
X-MC-Unique: TaIhbuThMniXyITOr9DJ1Q-1
Received: by mail-wr1-f71.google.com with SMTP id 11so6297364wrc.3
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 13:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=+20lqtsdLoetbi1VKrLQV/f/K/xwxYS/9ftQPVBgJ9o=;
        b=axM7suSqWe19iVDxQMQoNraTJnZKSjx++FCvXPJPyOCKFYtLBqtUs6q2UpFlxzRHFP
         60baCmILl30jQbJl4ArOW10dmBKTy0LKUrMcm5FdgqGaqG4K2Pju8cpCsx3xA4mnTVeF
         qVFz6i8NrjVCnfpBvqWOnBHagnyNHBA/PL7aNVXgEtvCxZ4uVVAFSWXIaIAPxBEf5TLA
         q20mB5bAGeIFlD2SoM3AB61dBX36wZcUf2ERfQ7tXZQNEr+ywbvdplBzXwXzmUhmidqo
         D1YbEjyPTHbNbNWioTgMcoFe5QftSGkDc+J5tmFzJxP3D+XW0peAZ8eeUDpxUpKhkZoN
         8LxQ==
X-Gm-Message-State: AGi0PuYeeNb1EjvUNcCn5HntD1bTO28UTLHBXRY2Poxf5b7O0nH9+fR7
        miNqdcBwHSxmqLo15H2+jYj3Ta/MYrgbSGz3ODn2J8AXg4a9JoDAMJ2k9nrkf19PMOuMGdfeqAb
        WBvXtGvtq2fty
X-Received: by 2002:adf:f881:: with SMTP id u1mr20010569wrp.348.1587412804909;
        Mon, 20 Apr 2020 13:00:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypJIVhqetK7aUCHYEkuU804XOceo66/cE0Dx1Q5aW14bSOsutRUOmxAsjw6JtGgBkBYwz6DrLg==
X-Received: by 2002:adf:f881:: with SMTP id u1mr20010546wrp.348.1587412804645;
        Mon, 20 Apr 2020 13:00:04 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id m1sm677467wro.64.2020.04.20.13.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 13:00:03 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:00:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexander.h.duyck@linux.intel.com, arnd@arndb.de,
        bjorn.andersson@linaro.org, eli@mellanox.com, eperezma@redhat.com,
        gustavo@embeddedor.com, hulkci@huawei.com, jasowang@redhat.com,
        mst@redhat.com, sfr@canb.auug.org.au, yanaijie@huawei.com,
        yuehaibing@huawei.com
Subject: [GIT PULL v2] vhost: cleanups and fixes
Message-ID: <20200420160001-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to d085eb8ce727e581abf8145244eaa3339021be2f:

  vhost: disable for OABI (2020-04-20 10:19:22 -0400)

Changes from v1:
	Dropped a bunch of cleanups which turned out to be controversial

This has been in next for a while, though I tweaked some commit
logs so the hashes differ.

----------------------------------------------------------------
virtio: fixes, cleanups

Some bug fixes.
Cleanup a couple of issues that surfaced meanwhile.
Disable vhost on ARM with OABI for now - to be fixed
fully later in the cycle or in the next release.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alexander Duyck (1):
      virtio-balloon: Avoid using the word 'report' when referring to free page hinting

Eugenio Pérez (1):
      vhost: Create accessors for virtqueues private_data

Gustavo A. R. Silva (1):
      vhost: vdpa: remove unnecessary null check

Jason Wang (1):
      vdpa: fix comment of vdpa_register_device()

Jason Yan (2):
      vhost: remove set but not used variable 'status'
      virtio-balloon: make virtballoon_free_page_report() static

Michael S. Tsirkin (15):
      vdpa-sim: depend on HAS_DMA
      virtio/test: fix up after IOTLB changes
      tools/virtio: define aligned attribute
      tools/virtio: make asm/barrier.h self contained
      virtgpu: pull in uaccess.h
      virtio-rng: pull in slab.h
      remoteproc: pull in slab.h
      virtio_input: pull in slab.h
      rpmsg: pull in slab.h
      remoteproc: pull in slab.h
      vdpa: allow a 32 bit vq alignment
      vdpa: make vhost, virtio depend on menu
      virtio_blk: add a missing include
      virtio: drop vringh.h dependency
      vhost: disable for OABI

Stephen Rothwell (1):
      drm/virtio: fix up for include file changes

YueHaibing (2):
      vdpa: remove unused variables 'ifcvf' and 'ifcvf_lm'
      vdpasim: Return status in vdpasim_get_status

 drivers/block/virtio_blk.c             |  1 +
 drivers/char/hw_random/virtio-rng.c    |  1 +
 drivers/gpu/drm/virtio/virtgpu_ioctl.c |  1 +
 drivers/gpu/drm/virtio/virtgpu_kms.c   |  1 +
 drivers/misc/mic/Kconfig               |  2 +-
 drivers/net/caif/Kconfig               |  2 +-
 drivers/remoteproc/remoteproc_sysfs.c  |  1 +
 drivers/remoteproc/stm32_rproc.c       |  1 +
 drivers/rpmsg/mtk_rpmsg.c              |  1 +
 drivers/vdpa/Kconfig                   | 18 ++++++------------
 drivers/vdpa/ifcvf/ifcvf_base.c        |  2 --
 drivers/vdpa/ifcvf/ifcvf_main.c        |  4 +---
 drivers/vdpa/vdpa.c                    |  2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c       |  4 ++--
 drivers/vhost/Kconfig                  | 21 ++++++++++++++++-----
 drivers/vhost/net.c                    | 28 +++++++++++++++-------------
 drivers/vhost/scsi.c                   | 14 +++++++-------
 drivers/vhost/test.c                   | 14 +++++++-------
 drivers/vhost/vdpa.c                   |  5 -----
 drivers/vhost/vhost.h                  | 27 +++++++++++++++++++++++++++
 drivers/vhost/vringh.c                 |  5 +++++
 drivers/vhost/vsock.c                  | 14 +++++++-------
 drivers/virtio/Kconfig                 |  2 +-
 drivers/virtio/virtio_balloon.c        |  4 ++--
 drivers/virtio/virtio_input.c          |  1 +
 include/linux/vdpa.h                   |  2 +-
 include/linux/virtio.h                 |  1 -
 include/linux/vringh.h                 |  6 ++++++
 include/uapi/linux/virtio_balloon.h    | 11 +++++++++--
 tools/virtio/Makefile                  |  5 +++--
 tools/virtio/asm/barrier.h             |  1 +
 tools/virtio/generated/autoconf.h      |  0
 tools/virtio/linux/compiler.h          |  1 +
 33 files changed, 128 insertions(+), 75 deletions(-)
 create mode 100644 tools/virtio/generated/autoconf.h


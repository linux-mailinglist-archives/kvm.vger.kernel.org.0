Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A339340C8E
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhCRSL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:11:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232465AbhCRSLw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 14:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616091103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=WP7PnNSr4BR9a1LVBwXMPx5QETfjMgS7zmkwK2xedWo=;
        b=NzuKqqOgrrUtipYBhPeU5Q2FEHhzzOLJUkwgSvy7fVhSymfgrNFNZeW8yX7s6zdwVRKp0t
        SXS1DfZMqHjO8P0DjYeW+UyV//InAzIxZE47n97mSfIxDl/Pt+7N7uua+tPubwTafqJm80
        s8r7cTQuv8yF3GUxHbl3txA9rC4Kp+g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-MyzttdWPPuCOaeZlG7BoCg-1; Thu, 18 Mar 2021 14:11:41 -0400
X-MC-Unique: MyzttdWPPuCOaeZlG7BoCg-1
Received: by mail-wr1-f72.google.com with SMTP id i5so20485233wrp.8
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 11:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WP7PnNSr4BR9a1LVBwXMPx5QETfjMgS7zmkwK2xedWo=;
        b=P+Ex3tx3u8JwXM5o08qKQPKdyzezz2db6izOFQyMc0l63nb5SyG3VBEqB/g7hQ2Tm8
         lCaTS4AUju1rMmZAgZwkqqwWqcfP4pXP+iTNWwd6vw6O/ZKr4BCic/t6pGWXJqa7z9Oi
         0nv5MNhFLuhYb9zeqqOn+C+X4xCMoLjDmFA9Ur1OVM1DxgGzsmURESeNnTC6PRD9sIbp
         q1RfCH3WTqCJo0nHGPXKalv63rxJeBZWjn9GgsvEo3H6hxVzNa38aXof/twlBx7iL/yR
         AmRJVuD1NA3g3TWSRJQ4tQ0I0DztiVpDIiApDSmV3wNpqmSPW+JugzwWe//1Y/bY4vJj
         84qg==
X-Gm-Message-State: AOAM531HHYef7xs8IwhulpYAjrsUhowSu/HD5+EWGTAiuWd1aXfgDDdG
        ufTpNWwgqNzZEy/ypSnnVwk7I37XcmCtOAQIdLS+okx8wYg6O/FUDd+jvWwQk5RyT9kYy3M91TR
        yCQ78zNvg0oFW
X-Received: by 2002:a5d:6810:: with SMTP id w16mr510492wru.333.1616091099217;
        Thu, 18 Mar 2021 11:11:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFTfjChgFyUXnBDg4awB1ZFX0fIcyN9S9XgyGks/aa0h+c9tuWlTuolWTJOqxYehca3p6+ug==
X-Received: by 2002:a5d:6810:: with SMTP id w16mr510479wru.333.1616091099081;
        Thu, 18 Mar 2021 11:11:39 -0700 (PDT)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id s8sm3686155wrn.97.2021.03.18.11.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 11:11:38 -0700 (PDT)
Date:   Thu, 18 Mar 2021 14:11:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gdawar.xilinx@gmail.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, lvivier@redhat.com, mst@redhat.com,
        parav@nvidia.com, sgarzare@redhat.com, stable@vger.kernel.org,
        tangbin@cmss.chinamobile.com, xianting_tian@126.com
Subject: [GIT PULL] vhost: cleanups and fixes
Message-ID: <20210318141135-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 16c10bede8b3d8594279752bf53153491f3f944f:

  virtio-input: add multi-touch support (2021-02-23 07:52:59 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 0bde59c1723a29e294765c96dbe5c7fb639c2f96:

  vhost-vdpa: set v->config_ctx to NULL if eventfd_ctx_fdget() fails (2021-03-14 18:10:07 -0400)

----------------------------------------------------------------
virtio: fixes, cleanups

Some fixes and cleanups all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Gautam Dawar (1):
      vhost_vdpa: fix the missing irq_bypass_unregister_producer() invocation

Jason Wang (1):
      vdpa: set the virtqueue num during register

Laurent Vivier (1):
      vhost: Fix vhost_vq_reset()

Parav Pandit (1):
      vdpa_sim: Skip typecasting from void*

Stefano Garzarella (2):
      vhost-vdpa: fix use-after-free of v->config_ctx
      vhost-vdpa: set v->config_ctx to NULL if eventfd_ctx_fdget() fails

Tang Bin (1):
      virtio-mmio: Use to_virtio_mmio_device() to simply code

Xianting Tian (1):
      virtio: remove export for virtio_config_{enable, disable}

 drivers/vdpa/ifcvf/ifcvf_main.c      |  5 ++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |  4 ++--
 drivers/vdpa/vdpa.c                  | 18 ++++++++++--------
 drivers/vdpa/vdpa_sim/vdpa_sim.c     |  2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  5 ++---
 drivers/vhost/vdpa.c                 | 20 +++++++++++---------
 drivers/vhost/vhost.c                |  2 +-
 drivers/virtio/virtio.c              |  6 ++----
 drivers/virtio/virtio_mmio.c         |  3 +--
 include/linux/vdpa.h                 | 10 +++++-----
 include/linux/virtio.h               |  2 --
 11 files changed, 37 insertions(+), 40 deletions(-)


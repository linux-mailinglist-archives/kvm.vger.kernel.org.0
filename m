Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAEA460843
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 19:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353432AbhK1SD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 13:03:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359177AbhK1SB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 28 Nov 2021 13:01:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638122292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=aw8bghuFT1gVRspF1SIwJ9nxGGoDXPynCf2IvVb5wz8=;
        b=FmT6Ru4bV8beb5Ts/NUHsA/SLvTBIr5FbyjeizS3gU7QSZIiqnILY50D8VblhqGT5Xq7CU
        +mGQ0a/0frxArv0W11Nv+UVn8CxyaSLsOGrX/hu7sOtArHLkOipJLX8g6zsNlLh1LayK5v
        Om6j5Z0vFk1o0TraBU8Mfowhiq7UjTM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-432-yCp8pcxgMHimcFsOjzuyXA-1; Sun, 28 Nov 2021 12:58:10 -0500
X-MC-Unique: yCp8pcxgMHimcFsOjzuyXA-1
Received: by mail-ed1-f69.google.com with SMTP id w4-20020aa7cb44000000b003e7c0f7cfffso11747379edt.2
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 09:58:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=aw8bghuFT1gVRspF1SIwJ9nxGGoDXPynCf2IvVb5wz8=;
        b=elFUG5XyxCqJaZTCkVThdyzOJI25PWKDR6qHQTfzgJm49UoWJZuQ+9G3JI/GqQsFKY
         7FdnA8vsqndGqfBfqWjR6QqrshTjw3iYZ9zeboRm1FiE8WaUGsyBJHsvRQzL8FpsOisF
         Df7ofhuMU7ByQAxj5jxwKvDTQ5yGLJ4lnwqcG3xv0yIH1HOH441mj+HwsbdIlzBSsCU8
         dRSnypOtWegIjWjB2tGYJNr9oXOyEi4G85XONmjHWkyBuBcv1LMCBDWMDPrqfaHarwTL
         at5QWqGvj/q3dzDONVEaxjS+pEdFFl0YBAKKzCjYGYHSIxx+cIo1Y4XEjIofq2kCK0AY
         rZrg==
X-Gm-Message-State: AOAM5313CG5JEHUrGToxV/K/B48gROFdeYhOUdiarfiKONjROXiT3rei
        BtBVr0eIc6w9pzNAXxH0pePX0wbntrKgEYumNFC4CNfTFXq98aWhis86h9aLn6RV7YvJNnVKDbD
        aA82fRAoND133
X-Received: by 2002:a05:6402:35c2:: with SMTP id z2mr67408178edc.92.1638122289272;
        Sun, 28 Nov 2021 09:58:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmcTF6gn5TCzS+/rpoMf1mqbfbhiRbIxVsZL7CgEHFdEJ4mkHhQm2BnrUXrbOR/h6u/h/cxQ==
X-Received: by 2002:a05:6402:35c2:: with SMTP id z2mr67408154edc.92.1638122289105;
        Sun, 28 Nov 2021 09:58:09 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:bc0b:b6a8:e3e8:8431:4d58])
        by smtp.gmail.com with ESMTPSA id oz31sm6090037ejc.35.2021.11.28.09.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 09:58:08 -0800 (PST)
Date:   Sun, 28 Nov 2021 12:58:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, longpeng2@huawei.com, mst@redhat.com,
        pasic@linux.ibm.com, sgarzare@redhat.com, stable@vger.kernel.org,
        wuzongyong@linux.alibaba.com, ye.guojin@zte.com.cn,
        zealci@zte.com.cn
Subject: [GIT PULL] vhost,virtio,vdpa: bugfixes
Message-ID: <20211128125803-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 136057256686de39cc3a07c2e39ef6bc43003ff6:

  Linux 5.16-rc2 (2021-11-21 13:47:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to bb93ce4b150dde79f58e34103cbd1fe829796649:

  vdpa_sim: avoid putting an uninitialized iova_domain (2021-11-24 19:00:29 -0500)

----------------------------------------------------------------
vhost,virtio,vdpa: bugfixes

Misc fixes all over the place.

Revert of virtio used length validation series: the approach taken does
not seem to work, breaking too many guests in the process. We'll need to
do length validation using some other approach.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Longpeng (1):
      vdpa_sim: avoid putting an uninitialized iova_domain

Michael S. Tsirkin (4):
      Revert "virtio-scsi: don't let virtio core to validate used buffer length"
      Revert "virtio-blk: don't let virtio core to validate used length"
      Revert "virtio-net: don't let virtio core to validate used length"
      Revert "virtio_ring: validate used buffer length"

Stefano Garzarella (2):
      vhost/vsock: fix incorrect used length reported to the guest
      vhost/vsock: cleanup removing `len` variable

Wu Zongyong (1):
      vhost-vdpa: clean irqs before reseting vdpa device

Ye Guojin (1):
      virtio-blk: modify the value type of num in virtio_queue_rq()

 drivers/block/virtio_blk.c       |  3 +-
 drivers/net/virtio_net.c         |  1 -
 drivers/scsi/virtio_scsi.c       |  1 -
 drivers/vdpa/vdpa_sim/vdpa_sim.c |  7 +++--
 drivers/vhost/vdpa.c             |  2 +-
 drivers/vhost/vsock.c            |  8 ++----
 drivers/virtio/virtio_ring.c     | 60 ----------------------------------------
 include/linux/virtio.h           |  2 --
 8 files changed, 9 insertions(+), 75 deletions(-)


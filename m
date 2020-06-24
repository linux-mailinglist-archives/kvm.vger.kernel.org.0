Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37301206FB6
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 11:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbgFXJIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 05:08:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23648 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728637AbgFXJIJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jun 2020 05:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592989687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VQoY+UTRP06W0gqpd2Juj7Hxof1/RYyQfXylaOH8G2E=;
        b=F8NLBw5tN6xoouLxkIAmkOlqr/gTHC94CEHbImfOM3BtLo8y9a30kna/RJLZh8V9D0PoGk
        YTB4D8EuRUl/NyUSJIDMmMNSXf0tXjixbnYl741kCOjUhW1u3BjcyhOJjI0lvRvJBkm8oB
        zFnUGAGN/X4oSy2Lfb5IiFN/nHmLWXM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-dj-kGBPRMRG0XPM57Rhjcw-1; Wed, 24 Jun 2020 05:08:05 -0400
X-MC-Unique: dj-kGBPRMRG0XPM57Rhjcw-1
Received: by mail-wr1-f71.google.com with SMTP id g14so2283281wrp.8
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 02:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=VQoY+UTRP06W0gqpd2Juj7Hxof1/RYyQfXylaOH8G2E=;
        b=i6xDhRd7lKyBpgp5BEE1V9G2rkMjm8Bse+HI4fCr6QkQ+0KazJxu6SSKFF8DKPu4e1
         +5If6l4b+x2yFGWJOi8ZS9xSjzpO9yc2ZPRfmJGRFYayE1FP1a4T2j8Yvj+bx15TUBep
         yB2ugtaUY02yKgWcaY8VkrmFHwj53+2FZVqWSoVnDybnJpgTqG5btQsyrZrQLxCsGHS4
         yutVZ69riG8lEvHvyamYWMFKRT8MKW/7YMX7qQfUnQp5k0CzxMYdW7SRUsz8xMPtNoCU
         7y2LTnqnNRMHr3HIfyT0nSCSSyfev1vjUIQnrBNZbXZg8UBOe1IQMWNgwrLT5+cBsqFw
         jJ+g==
X-Gm-Message-State: AOAM532rCMs4t4LE34V1ZoZsdFLdkBVicq0R1rDg9myGJpok5MFNk/5Y
        zn9izpWEjOxQfBzargwEk1XCCoTUT5bGVgRU0ebDn9PWpPWU9dCmIOZGBDLx5/L4T/U7t/Nh7jD
        n4YzKnVlX9gTY
X-Received: by 2002:a7b:cb4c:: with SMTP id v12mr28392153wmj.43.1592989684867;
        Wed, 24 Jun 2020 02:08:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbEhEN966Il4umYMTMjRrrueqoGcM5lQiV/3BTRS9Bm+7+N7X0YZSdV011xkOJs+ZR2fNnFw==
X-Received: by 2002:a7b:cb4c:: with SMTP id v12mr28392130wmj.43.1592989684670;
        Wed, 24 Jun 2020 02:08:04 -0700 (PDT)
Received: from redhat.com ([82.166.20.53])
        by smtp.gmail.com with ESMTPSA id e5sm26714788wrw.19.2020.06.24.02.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 02:08:03 -0700 (PDT)
Date:   Wed, 24 Jun 2020 05:08:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, david@redhat.com, eperezma@redhat.com,
        jasowang@redhat.com, mst@redhat.com, pankaj.gupta.linux@gmail.com,
        teawaterz@linux.alibaba.com
Subject: [GIT PULL] virtio: fixes, tests
Message-ID: <20200624050801-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 48778464bb7d346b47157d21ffde2af6b2d39110:

  Linux 5.8-rc2 (2020-06-21 15:45:29 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to cb91909e48a4809261ef4e967464e2009b214f06:

  tools/virtio: Use tools/include/list.h instead of stubs (2020-06-22 12:34:22 -0400)

----------------------------------------------------------------
virtio: fixes, tests

Fixes all over the place.

This includes a couple of tests that I would normally defer,
but since they have already been helpful in catching some bugs,
don't build for any users at all, and having them
upstream makes life easier for everyone, I think it's
ok even at this late stage.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dan Carpenter (2):
      vhost_vdpa: Fix potential underflow in vhost_vdpa_mmap()
      virtio-mem: silence a static checker warning

David Hildenbrand (1):
      virtio-mem: add memory via add_memory_driver_managed()

Eugenio Pérez (7):
      tools/virtio: Add --batch option
      tools/virtio: Add --batch=random option
      tools/virtio: Add --reset
      tools/virtio: Use __vring_new_virtqueue in virtio_test.c
      tools/virtio: Extract virtqueue initialization in vq_reset
      tools/virtio: Reset index in virtio_test --reset.
      tools/virtio: Use tools/include/list.h instead of stubs

Jason Wang (1):
      vdpa: fix typos in the comments for __vdpa_alloc_device()

 drivers/vdpa/vdpa.c         |   2 +-
 drivers/vhost/test.c        |  57 ++++++++++++++++++
 drivers/vhost/test.h        |   1 +
 drivers/vhost/vdpa.c        |   2 +-
 drivers/virtio/virtio_mem.c |  27 +++++++--
 tools/virtio/linux/kernel.h |   7 +--
 tools/virtio/linux/virtio.h |   5 +-
 tools/virtio/virtio_test.c  | 139 +++++++++++++++++++++++++++++++++++++-------
 tools/virtio/vringh_test.c  |   2 +
 9 files changed, 207 insertions(+), 35 deletions(-)


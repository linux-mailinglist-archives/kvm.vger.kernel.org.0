Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EA24309DD
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 16:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343886AbhJQOvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 10:51:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238007AbhJQOvQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 17 Oct 2021 10:51:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634482146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Ip6ZgePH8xwpK2sHmkpaBxfB7ZKPtwdcnXkOJDJISgI=;
        b=YFWxJ3HRMfFiZkEBYmkUiDf7hTAIiD7VzyXTE8szJXDPl80boNFLdDBmUv80YNO+k43qFA
        TvacWhTNv0A97FRAqSqecJJ05UM7+CCryQdY8GIJe3fMPB5woOXgUm40HafkqTwDBfn3go
        x7yJTHzKQTVRvjgEbJDQlykpZWllXII=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-tzT97R6SO9eFswNBVNdNwg-1; Sun, 17 Oct 2021 10:49:05 -0400
X-MC-Unique: tzT97R6SO9eFswNBVNdNwg-1
Received: by mail-wm1-f69.google.com with SMTP id o196-20020a1ca5cd000000b0030dc197412aso2310836wme.0
        for <kvm@vger.kernel.org>; Sun, 17 Oct 2021 07:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Ip6ZgePH8xwpK2sHmkpaBxfB7ZKPtwdcnXkOJDJISgI=;
        b=ZR14o9EOViEpi2Hb7Qhd66Zx+S7fd60cBDYxsY6N9loLKIyMVaEFDYBgOt1oX7NSWG
         rzOyc7GHshi3h1nMFl/2O/UaWp6/yuDp+wYn9Mb5PZYE+pqNV4S7mZ41vdiVtPnMOAEm
         pM79K3aKI05moHO5hxnrOgHtPlqB7MN4NXuz12nzPXRHewU56fP7S3elW7QxxbiZcJ+f
         E0KtOj6IqwvghA9+RXbidHtJNiSZmpPRbNe0dp+V+uBBD91ywTUNv0gQ//yKGyA2mNmL
         BpAVqOGxVI9Rzt4oeK13+fY9auQ5jt13gW7vKWtGkC12AbvpYoatCCQX62FNSL8V7Ur7
         X46Q==
X-Gm-Message-State: AOAM530QxiXbFViRLh7CzaMzGiyzAawQjlP3mi/PGOZlzVVKHolm5QZi
        +pRw5Auj+S3ATWtGIM6K1sztNOnjlo1GjGwJ8ETCYJ5h5tA8bimksN0W5cKfFkDhgu4Q3I3HFkr
        8oUedQvA/Wpl0
X-Received: by 2002:a05:6000:1683:: with SMTP id y3mr15124353wrd.314.1634482144583;
        Sun, 17 Oct 2021 07:49:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFBg10YCOIJdS2cG0k9v/rSms6MDVN0cXyAC9SocqmtQ9OZq/KfKELZOAfWYN7H7AEZxW3lg==
X-Received: by 2002:a05:6000:1683:: with SMTP id y3mr15124332wrd.314.1634482144347;
        Sun, 17 Oct 2021 07:49:04 -0700 (PDT)
Received: from redhat.com ([2.55.147.75])
        by smtp.gmail.com with ESMTPSA id a2sm11630293wrq.9.2021.10.17.07.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 07:49:03 -0700 (PDT)
Date:   Sun, 17 Oct 2021 10:49:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, jasowang@redhat.com, linux-doc@vger.kernel.org,
        lulu@redhat.com, markver@us.ibm.com, mst@redhat.com,
        pasic@linux.ibm.com, rdunlap@infradead.org, stable@vger.kernel.org,
        wuzongyong@linux.alibaba.com, xieyongji@bytedance.com
Subject: [GIT PULL] virtio,vdpa: fixes
Message-ID: <20211017104900-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit be9c6bad9b46451ba5bb8d366c51e2475f374981:

  vdpa: potential uninitialized return in vhost_vdpa_va_map() (2021-09-14 18:10:43 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to bcef9356fc2e1302daf373c83c826aa27954d128:

  vhost-vdpa: Fix the wrong input in config_cb (2021-10-13 08:42:07 -0400)

----------------------------------------------------------------
virtio,vdpa: fixes

Fixes up some issues in rc5.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Cindy Lu (1):
      vhost-vdpa: Fix the wrong input in config_cb

Halil Pasic (1):
      virtio: write back F_VERSION_1 before validate

Michael S. Tsirkin (1):
      Revert "virtio-blk: Add validation for block size in config space"

Randy Dunlap (1):
      VDUSE: fix documentation underline warning

Wu Zongyong (1):
      vhost_vdpa: unset vq irq before freeing irq

 Documentation/userspace-api/vduse.rst |  2 +-
 drivers/block/virtio_blk.c            | 37 ++++++-----------------------------
 drivers/vhost/vdpa.c                  | 10 +++++-----
 drivers/virtio/virtio.c               | 11 +++++++++++
 4 files changed, 23 insertions(+), 37 deletions(-)


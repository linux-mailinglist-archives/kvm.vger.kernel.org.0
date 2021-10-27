Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D097B43D219
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 22:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbhJ0ULC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 16:11:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243793AbhJ0ULB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 16:11:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635365315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=VJyQQirrZwuNXLBhFZlxTeutqhrfo+TWoiIbs1ysy2s=;
        b=AUyKUHu1Rtv5sX5J2buxGUl5QHgZFsBvyDC7ZecjAZAmY0vCX7FjfuXgWGFR6y6gr/FxSP
        eYScXfNxn9jLADuJHwnbZK4Vp6FZZPNWDoOCx8AKBinorLxKqxv47gQyzYK4V9cFfX430s
        UiiQxcORdYraFc2V/mJiYcX76+vzvYw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-xuF_aoZ_PG2cfvsIoxh7Ng-1; Wed, 27 Oct 2021 16:08:34 -0400
X-MC-Unique: xuF_aoZ_PG2cfvsIoxh7Ng-1
Received: by mail-ed1-f69.google.com with SMTP id s18-20020a056402521200b003dd5902f4f3so3341333edd.23
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 13:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=VJyQQirrZwuNXLBhFZlxTeutqhrfo+TWoiIbs1ysy2s=;
        b=ylLG2YGOSyMKtquD7EsMetxritWwXEgm9kiT4NtTqCCXWL1LRj98++P5HcJt0KJ5Bi
         g2TaX0eIeOhwZfgRP/DNPTWRcWY+VbvISFw/7gt83S2msyQM2A5I+VHnL//wuceMAzla
         9LgTFQnBwMwi2Vqwk7WBqPbD8m19JuL3tI1a9B7t7MOWufLTEG+x07UHy75DkpREAGbV
         9JaZcW3tN0Hv9IyiIsYp3wD4KY0g3hsFzFYDIjTLCfnyty2ho06PXreUnu1evEGtOQ/N
         ClmEu2UK5o7tVwCaHDcpJ8YcuqXqcxlFZq8udRujSb+uasvGcT8WT9whm7V46QNkFjFn
         kKVg==
X-Gm-Message-State: AOAM531a2k3rYSEeAqk7C6/umZ1E7Jz2REEoH4NEJRuG6yKG+qszRZlF
        KjyV/qfUy/p95aAqR2ZBQ1FwuCz5/RH08q3OEAux2njpKVjjNFNTE4/T9QX06suzlrC96DrL5BL
        h/5YuMkIFgjeh
X-Received: by 2002:a17:906:c18d:: with SMTP id g13mr40156609ejz.518.1635365312936;
        Wed, 27 Oct 2021 13:08:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpFHN76pLgh4LdmFOeHgtbBOiaO/TarBKKy+bAQpZOaQQRa5m1hagk9YBfjHLP3LAg3Zp+BQ==
X-Received: by 2002:a17:906:c18d:: with SMTP id g13mr40156577ejz.518.1635365312743;
        Wed, 27 Oct 2021 13:08:32 -0700 (PDT)
Received: from redhat.com ([2.55.137.59])
        by smtp.gmail.com with ESMTPSA id u9sm253017edf.47.2021.10.27.13.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:08:32 -0700 (PDT)
Date:   Wed, 27 Oct 2021 16:08:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, mst@redhat.com, vincent.whitchurch@axis.com,
        xieyongji@bytedance.com
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20211027160829-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 64222515138e43da1fcf288f0289ef1020427b87:

  Merge tag 'drm-fixes-2021-10-22' of git://anongit.freedesktop.org/drm/drm (2021-10-21 19:06:08 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 890d33561337ffeba0d8ba42517e71288cfee2b6:

  virtio-ring: fix DMA metadata flags (2021-10-27 15:54:34 -0400)

----------------------------------------------------------------
virtio: last minute fixes

A couple of fixes that seem important enough to pick at the last moment.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Vincent Whitchurch (1):
      virtio-ring: fix DMA metadata flags

Xie Yongji (2):
      vduse: Disallow injecting interrupt before DRIVER_OK is set
      vduse: Fix race condition between resetting and irq injecting

 drivers/vdpa/vdpa_user/vduse_dev.c | 29 +++++++++++++++++++++++++----
 drivers/virtio/virtio_ring.c       |  2 +-
 2 files changed, 26 insertions(+), 5 deletions(-)


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF2E7908E
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 18:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfG2QQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 12:16:12 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:42425 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbfG2QQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 12:16:12 -0400
Received: by mail-ua1-f66.google.com with SMTP id a97so24147209uaa.9
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 09:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=AyvJSduUmZn33FbpJeTkP5NHm1ThVmp/uEoZugiTS6k=;
        b=MrWs/StL7MBtXv0BkUkElkHs+H6ICKGrGa+6yyCoSJlB2rqMgeTYXDVRvwjqZxSIKx
         kMQYi1ZGCFyZGFDPtjklOYvJMagNOqTGtxxvIIy8RKi9GkTvEVbZ79CM1BX4fJ9cy4yH
         230/VrkrdgulAI7yLBzBoF5t3IagpNVHV5Vkhp8Zod9QbOsxK0W9iWvxYdMsu98p04px
         PB+fFEm03e5TQ02+wij/T0UXvy4fvzAfUCIXTm2dHtwV7tDX4LlSFHtQt3Woeha6ZKcQ
         TAktErNOyt+GyzaMvqRrGiLtkc2R2L1eNi0EDh3tt2nwCqNBTn7IEg6yYJc2NPoqLSuc
         qy9Q==
X-Gm-Message-State: APjAAAX+++Nf8WYdQK/LbZ0J4UlDQaK0TCsjwm5yFgbnRTgMGkyf5qg5
        ptLdzlcuL4j/x2kzgE1nYxXQLA==
X-Google-Smtp-Source: APXvYqwG8Q4XQWblCYfrnvjYrxOZIt94OjzyFiLAXTSDaMhX/fRr5dDybVH26+paFqcxZZfddeveUQ==
X-Received: by 2002:a9f:31a2:: with SMTP id v31mr67985907uad.15.1564416971073;
        Mon, 29 Jul 2019 09:16:11 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id u5sm60539788uah.0.2019.07.29.09.16.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:16:10 -0700 (PDT)
Date:   Mon, 29 Jul 2019 12:16:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.auger@redhat.com, jean-philippe@linaro.org, jroedel@suse.de,
        mst@redhat.com, namit@vmware.com, wei.w.wang@intel.com
Subject: [PULL] vhost,virtio: cleanups and fixes
Message-ID: <20190729121605-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b:

  Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 73f628ec9e6bcc45b77c53fe6d0c0ec55eaf82af:

  vhost: disable metadata prefetch optimization (2019-07-26 07:49:29 -0400)

----------------------------------------------------------------
virtio, vhost: bugfixes

Fixes in the iommu and balloon devices.
Disable the meta-data optimization for now - I hope we can get it fixed
shortly, but there's no point in making users suffer crashes while we
are working on that.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jean-Philippe Brucker (1):
      iommu/virtio: Update to most recent specification

Michael S. Tsirkin (2):
      balloon: fix up comments
      vhost: disable metadata prefetch optimization

Wei Wang (1):
      mm/balloon_compaction: avoid duplicate page removal

 drivers/iommu/virtio-iommu.c      | 40 ++++++++++++++++-------
 drivers/vhost/vhost.h             |  2 +-
 include/uapi/linux/virtio_iommu.h | 32 ++++++++++--------
 mm/balloon_compaction.c           | 69 +++++++++++++++++++++++----------------
 4 files changed, 89 insertions(+), 54 deletions(-)

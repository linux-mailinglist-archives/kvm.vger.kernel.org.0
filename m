Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58CB3688F9
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 00:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbhDVWVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 18:21:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236763AbhDVWU7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 18:20:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619130022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=tgQyxuFNIWv2WFwGCh6y2wdSkYdHkTXHx4X2Bpzjy2I=;
        b=HP+d12yBLmHIipwN9ACa6yrY4L8RxDcVHWE90COWvMT2redh/FX55Bi0zrc5JXHZ6VR1nr
        WlOn5DhHGv+pU0Gn2Zhl8Z4oyConXdvnA+e/xYVMaT30mWABtfnvWMqDbpHc95xEYGQw2k
        JSvFdhahPm+WK4CChyH8Itj3fA5Y+d4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-cxD-MhIfOU6ITGBgG-OYWw-1; Thu, 22 Apr 2021 18:20:21 -0400
X-MC-Unique: cxD-MhIfOU6ITGBgG-OYWw-1
Received: by mail-ed1-f71.google.com with SMTP id z3-20020a05640240c3b029037fb0c2bd3bso17651222edb.23
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 15:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=tgQyxuFNIWv2WFwGCh6y2wdSkYdHkTXHx4X2Bpzjy2I=;
        b=G8LZ38fdR/cqPXrQ1s+bDakX7zyYbRqG1avQRNFJVN7wvQ5nxszNHTKF8itwWP24NA
         6y/vwY832u+tKMepOW5W3FpIqPGSZfIcP4TELSILxED5+4dgwPeQgUPCxl0J5y917faX
         5fWcOaf64VuoQDleV6H6T2YQdrxqbXR9uzcNGZ2U2AALlG+4RJaraIIAAG+pK9GH41h5
         EVEu6WX5UDWNeS+i2YCJYNEpgT39G+bMLbfNiEabAYy36gbSIKxonxyHpW+UQs7pPVH9
         1QZJ3JWwcVwjrige4S+dNGloPr6u7ypBQbuy545TxoFDi+W8BX8Q9o3WFtwCqMF/shW7
         FZAg==
X-Gm-Message-State: AOAM5308JCFQ9dTJLKAmnsWk5D4YF7EOHHFHq9+dS6L4/8zOvvLtRtAZ
        1vCLOaq7UaIJEEZVTvnEojMqHo85jAG4e01ZrPN8Ab+aAkoYzSUTrjo1QmPSp1Oqm0cTwN4faPX
        +pa9b3bRJY1Q4
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr807275edz.184.1619130019727;
        Thu, 22 Apr 2021 15:20:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJy1AtNvC1yqgjKWu6Iev/lJ2pAgqjtkiG2OyAAr4aeu8ke3P5mSsVUhBCU4b2QDNeMyBTxQ==
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr807263edz.184.1619130019602;
        Thu, 22 Apr 2021 15:20:19 -0700 (PDT)
Received: from redhat.com (212.116.168.114.static.012.net.il. [212.116.168.114])
        by smtp.gmail.com with ESMTPSA id u1sm3177747edv.90.2021.04.22.15.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 15:20:18 -0700 (PDT)
Date:   Thu, 22 Apr 2021 18:20:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, jasowang@redhat.com,
        lkp@intel.com, mst@redhat.com, stable@vger.kernel.org,
        xieyongji@bytedance.com
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20210422182016-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit bc04d93ea30a0a8eb2a2648b848cef35d1f6f798:

  vdpa/mlx5: Fix suspend/resume index restoration (2021-04-09 12:08:28 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to be286f84e33da1a7f83142b64dbd86f600e73363:

  vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails (2021-04-22 18:15:31 -0400)

----------------------------------------------------------------
virtio: last minute fixes

Very late in the cycle but both risky if left unfixed and more or less
obvious..

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails

Xie Yongji (1):
      vhost-vdpa: protect concurrent access to vhost device iotlb

 drivers/vdpa/mlx5/core/mr.c | 4 +++-
 drivers/vhost/vdpa.c        | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15ED35A3EE
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 18:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhDIQsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 12:48:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232395AbhDIQsf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 12:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617986902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Chg6IKEuKKojYi7mhUKaMLERMRmxIjzmO/LXSZ+TUHU=;
        b=WE8yyCMnzFRiUCyrXjQmd2y/SFQuk0410KgVwtGc2o4yLRUDXkWPdp/1KlU6ZQaszgf3U1
        utOzKT35fHqb6IG91aMysACGLbVR3/YTePzUez1gCJGcpW7KzASAQw0K/eLrjiumxNGd39
        QMEQcqh4U0AEb6WU8b85bbzYlPMxHGw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-NJ1MqecbMmuydVBFRpmMOw-1; Fri, 09 Apr 2021 12:48:20 -0400
X-MC-Unique: NJ1MqecbMmuydVBFRpmMOw-1
Received: by mail-wm1-f72.google.com with SMTP id b20-20020a7bc2540000b029010f7732a35fso4487998wmj.1
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 09:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Chg6IKEuKKojYi7mhUKaMLERMRmxIjzmO/LXSZ+TUHU=;
        b=sC789iOOoFUn8OkHGpfGGZECIAM4hvYaEhe/R7YKDH1Sye2bDDOP1iWh1+OVSEvbka
         lsIhXjbT5l/qKLQiKgdrzfSuhiftFLzKpCtDFaqawu2hkC0PC/i5yESYN+9uKfW+bafi
         /Y0YUXGlJXLhcejuqKDaES0+5XkzCYyLkv3HKJvM4dI2er2NAOzcJwV5/6/d1g0AXqac
         T29S618h4zrpXcObrngwf+qDAAotMLgDTYxyvxbIzITU5F+62ahg95yxJuSXunVBKBGk
         PlWc6Cwusuj4ayQdgjxLy/zcEYpBwT12/yLx2ZLaRKUEpLD6wOfQARebMVPtH+5B/68v
         KauQ==
X-Gm-Message-State: AOAM530X0hckLe8ajciLo6Qk1rJ2mXzKjNCMLZ4MPMGV29BHejwXkz/I
        QPLRcpaePFMoE7oszkU1NhnwL6P1JYa4MaxJogGSyuMpM3d6CZYWuG1UjeUDbB0lqxQxnbtaVSf
        FWzm56K3h/oUZ
X-Received: by 2002:a1c:9a16:: with SMTP id c22mr7681449wme.7.1617986899514;
        Fri, 09 Apr 2021 09:48:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2SClI5Njn6xjA2MPYxm2kpYJCEchwrX/9+aQChXy3FOe+I3afHnDGXz6jYj0V+5m4e1Tm6w==
X-Received: by 2002:a1c:9a16:: with SMTP id c22mr7681431wme.7.1617986899273;
        Fri, 09 Apr 2021 09:48:19 -0700 (PDT)
Received: from redhat.com ([2a10:800e:f0d3:0:b69b:9fb8:3947:5636])
        by smtp.gmail.com with ESMTPSA id o25sm6618101wmh.1.2021.04.09.09.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 09:48:18 -0700 (PDT)
Date:   Fri, 9 Apr 2021 12:48:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mst@redhat.com,
        si-wei.liu@oracle.com
Subject: [GIT PULL] vdpa/mlx5: last minute fixes
Message-ID: <20210409124816-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit e49d033bddf5b565044e2abe4241353959bc9120:

  Linux 5.12-rc6 (2021-04-04 14:15:36 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to bc04d93ea30a0a8eb2a2648b848cef35d1f6f798:

  vdpa/mlx5: Fix suspend/resume index restoration (2021-04-09 12:08:28 -0400)

----------------------------------------------------------------
vdpa/mlx5: last minute fixes

These all look like something we are better off having
than not ...

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (4):
      vdpa/mlx5: Use the correct dma device when registering memory
      vdpa/mlx5: Retrieve BAR address suitable any function
      vdpa/mlx5: Fix wrong use of bit numbers
      vdpa/mlx5: Fix suspend/resume index restoration

Si-Wei Liu (1):
      vdpa/mlx5: should exclude header length and fcs from mtu

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++++
 drivers/vdpa/mlx5/core/mr.c        |  9 +++++++--
 drivers/vdpa/mlx5/core/resources.c |  3 ++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 40 +++++++++++++++++++++++---------------
 4 files changed, 37 insertions(+), 19 deletions(-)


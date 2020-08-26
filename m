Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FC0252FCD
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 15:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgHZN2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 09:28:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730217AbgHZN20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 09:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598448502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=i67+aNF8QtmkXbZ+5JSUQwpOse6+0MGUqtdEKnlOGYo=;
        b=Q4SObXwIqXhBVDXo5ddCXC0ao/UUQJinuE+m/FsbGLI3qQ9NO3KPWnr+UxBSYRZFjuvx0K
        CEKj815+pBPfN0ZM0xRZB0cT7U2oACkXsfZPc4ACCZZVagm5/G2ZFYV/XnU1LXotHbzTUZ
        jtfJhKTkM72coH1njWVDRfX95WmHkGg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-jcu-5l0KNKe5wqq8ixzCoA-1; Wed, 26 Aug 2020 09:28:20 -0400
X-MC-Unique: jcu-5l0KNKe5wqq8ixzCoA-1
Received: by mail-wm1-f72.google.com with SMTP id c198so775985wme.5
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 06:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=i67+aNF8QtmkXbZ+5JSUQwpOse6+0MGUqtdEKnlOGYo=;
        b=rCl+IdLI2WfYOmhxXU+tyPST82THT8vIvWGcCCs9eoJO7u77hiroTY2KDHpflfJ4v1
         i2Xp/NndAk+7D5gqTEIRCQK4aE4hbv/wXV4Ro8SXy94w9mfLPMmbNYLU79JDMN30tzuW
         95DgFPDGY6ZDm++W3zUwhgKObJLlI/rxT90Iu+tSRptZ5UVBhZ293tX8pfkPkEhY9xvO
         VHphoMQAn9GxPT68h6y/K/o3Yg8kE4qFWY08yREDU1Lp8vN8mE4RYxRzDzQ3jKAfH0YM
         QqgZo1qtWBZxt+f9yWaaN3R2pqN25wDn2pUKOO6aVUwt97yomURyiFxYCJ/O3xUlu0Mk
         hn6A==
X-Gm-Message-State: AOAM531TWB9wJC6FbOL7qhstJDvOaWCNuuu4MzOvBVIeDCjB133h+UZ/
        SYaZHv08dSy5kQMMAV+RWsKMKrGzQvVllxKUQAqST8Hq4l2ExCHNK6Wk/Zkvw34mLvjW9qayEue
        0fvkIV/mltfrl
X-Received: by 2002:a1c:105:: with SMTP id 5mr7557731wmb.83.1598448499405;
        Wed, 26 Aug 2020 06:28:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE5CXik9B/yf7SlhoMl9P+rB1tllMpEuE0RJnSmFjwzWrgc4RXpHi+O77/0mfTHMtg2dZEVQ==
X-Received: by 2002:a1c:105:: with SMTP id 5mr7557705wmb.83.1598448499198;
        Wed, 26 Aug 2020 06:28:19 -0700 (PDT)
Received: from redhat.com (bzq-109-67-46-169.red.bezeqint.net. [109.67.46.169])
        by smtp.gmail.com with ESMTPSA id g62sm5158616wmf.33.2020.08.26.06.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:28:18 -0700 (PDT)
Date:   Wed, 26 Aug 2020 09:27:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        maxime.coquelin@redhat.com, mst@redhat.com,
        natechancellor@gmail.com, rdunlap@infradead.org,
        sgarzare@redhat.com
Subject: [GIT PULL] virtio: bugfixes
Message-ID: <20200826092731-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit d012a7190fc1fd72ed48911e77ca97ba4521bccd:

  Linux 5.9-rc2 (2020-08-23 14:08:43 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to cbb523594eb718944b726ba52bb43a1d66188a17:

  vdpa/mlx5: Avoid warnings about shifts on 32-bit platforms (2020-08-26 08:13:59 -0400)

----------------------------------------------------------------
virtio: bugfixes

A couple vdpa and vhost bugfixes

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jason Wang (2):
      vdpa: ifcvf: return err when fail to request config irq
      vdpa: ifcvf: free config irq in ifcvf_free_irq()

Nathan Chancellor (1):
      vdpa/mlx5: Avoid warnings about shifts on 32-bit platforms

Stefano Garzarella (1):
      vhost-iotlb: fix vhost_iotlb_itree_next() documentation

 drivers/vdpa/ifcvf/ifcvf_base.h   |  2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c   |  9 +++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 50 +++++++++++++++++++--------------------
 drivers/vhost/iotlb.c             |  4 ++--
 4 files changed, 35 insertions(+), 30 deletions(-)


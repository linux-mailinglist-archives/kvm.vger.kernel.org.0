Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9ED41A2F8
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 00:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbhI0Wbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 18:31:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237697AbhI0Wbu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 18:31:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632781811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=eCL0AZojEkxKxjkt+7Wlncn1gJOK+2tgTrPIC34EBbc=;
        b=F7NLL47YIt4QFYMyfG9mA6LIRK8MDfmkWNDV/4Hrm88+O2xvbbS8et8Wem34J7WJk+HRwT
        cUKqhczRQ4e8E2HllC40rphSb0Dqg3gXav8jG0PY3mvz39yKln+VQVrce8HHrpXTRCCH8a
        1+e50a3vBAGFVgrAqSqtpXvzS4VcUQY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-qa-eO2nHNi-wbfmlUUyehw-1; Mon, 27 Sep 2021 18:30:10 -0400
X-MC-Unique: qa-eO2nHNi-wbfmlUUyehw-1
Received: by mail-wm1-f69.google.com with SMTP id l42-20020a05600c1d2a00b0030d02f09530so496300wms.0
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 15:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=eCL0AZojEkxKxjkt+7Wlncn1gJOK+2tgTrPIC34EBbc=;
        b=5r4LA12f0VfXMTcuMwuCv35Vh6bRzbCPdfCf4R3/+Eja0ilW5QJs1Vl3JJvjxkFP6n
         OXCMfhtK0vXRFQ2vFf8pzYuK5sllTW6YOzG364glsWHVBm1Mk3D0WcA1reHbl128Y5FI
         sGd6lnDkKmpS5m2CD/Vzp9AZKtIfGb3VngZ1RbilalNYdrqj26xkApDKXDTVAalfSSdb
         QIKLoEy7fRxJt+3HVNMlpfEXL4clirmAw4HI4FPwR7kh215r64jmVL98W9iAR2mG2N3o
         db00Qywwb2QEiareoGX4987+s5V09oPdfBdnR/piGYgJUTo0KPXuZSMiwpR/hICnLCpF
         eL3g==
X-Gm-Message-State: AOAM530AVc09W0YMq+ZT6jDihTyKR3oscMS5e4b4uxoW7hHVLb8pRl30
        eLesK+cA1LTTEDc/YBmltzkILA/qGKewYHvxpc2VuLDc7TlJSbl06EzgknK0UOtmzcfCm8Mxr79
        64YtHrtDkrC+B
X-Received: by 2002:a05:6000:d2:: with SMTP id q18mr2722609wrx.4.1632781808992;
        Mon, 27 Sep 2021 15:30:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrsPsib+hEYb8pFtjMLnI7CifdC97NAniAu5m3nBLmbR4U5TSkin30Vu44yOu2ox2ibxz4Yg==
X-Received: by 2002:a05:6000:d2:: with SMTP id q18mr2722587wrx.4.1632781808842;
        Mon, 27 Sep 2021 15:30:08 -0700 (PDT)
Received: from redhat.com ([2.55.4.59])
        by smtp.gmail.com with ESMTPSA id w18sm2490799wrt.79.2021.09.27.15.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 15:30:08 -0700 (PDT)
Date:   Mon, 27 Sep 2021 18:30:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        aik@ozlabs.ru, arnd@arndb.de, dan.carpenter@oracle.com,
        elic@nvidia.com, jasowang@redhat.com, linux@roeck-us.net,
        mst@redhat.com, viresh.kumar@linaro.org, xieyongji@bytedance.com
Subject: [GIT PULL] virtio,vdpa: fixes
Message-ID: <20210927183003-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to be9c6bad9b46451ba5bb8d366c51e2475f374981:

  vdpa: potential uninitialized return in vhost_vdpa_va_map() (2021-09-14 18:10:43 -0400)

----------------------------------------------------------------
virtio,vdpa: fixes

Fixes up some issues in rc1.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dan Carpenter (2):
      vduse: missing error code in vduse_init()
      vdpa: potential uninitialized return in vhost_vdpa_va_map()

Eli Cohen (2):
      vdpa/mlx5: Clear ready indication for control VQ
      vdpa/mlx5: Avoid executing set_vq_ready() if device is reset

Michael S. Tsirkin (1):
      virtio: don't fail on !of_device_is_compatible

Xie Yongji (1):
      vduse: Cleanup the old kernel states after reset failure

 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  5 +++++
 drivers/vdpa/vdpa_user/vduse_dev.c | 10 +++++-----
 drivers/vhost/vdpa.c               |  2 +-
 drivers/virtio/virtio.c            |  7 ++++++-
 4 files changed, 17 insertions(+), 7 deletions(-)


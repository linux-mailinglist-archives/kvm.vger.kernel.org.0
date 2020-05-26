Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B463A1DD5B3
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 20:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgEUSIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 14:08:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24329 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728455AbgEUSIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 14:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590084524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CSwVUGMdm1SF/JKvVgrgcJwpikT7dcnsVODRPnenSIQ=;
        b=AwaSGcsE7chVA8hMIziG7fqggYULAnw5C+/8wc4ozWIMOrCSmlOQxM8hW3fBzoNxHtUQFk
        HgT1+YRKn3ZJFgAhhwzW1tvN0kIYNc9n4gMYwas2wYFNHjlBLWuiWdumx9p1kdkT43jeg2
        1ZuAHCDko7riyCWMjUB0L/kef77eRJI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-DWmaO1oqPBCXHcY75imMGg-1; Thu, 21 May 2020 14:08:42 -0400
X-MC-Unique: DWmaO1oqPBCXHcY75imMGg-1
Received: by mail-wr1-f70.google.com with SMTP id h12so3235010wrr.19
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 11:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=CSwVUGMdm1SF/JKvVgrgcJwpikT7dcnsVODRPnenSIQ=;
        b=lJyE+qs+Vg1npAQaXUyxlsIg1af4xMHq6kN17nAo9UV9r7aSLAyDWk267lUKM+kds2
         d7nlOaVgNXIZ2lf51sbb+pPBhDuSwNeldsjHNA6BWAMql1vJObhr2s0uIRdTqVrkhgg3
         5IzRKx7abTNmiIi+yXbF3b1FSgnZSmkKwFOh7G2ltsaNVkPIGVSJKF3PJqsJ6Ewe3r3L
         X6aa+i9vEbcTGPHV+k/ebs9SPDrGsQtlNaDDHF82V6XMUT37W9S4p13kkgiKKVJ7OIxR
         B3VKBt2gnb6AkGvpESxW6GHqQBtAi3J/nxMiRw6eNPznrXvw+EoH8lWjk6QCawyTE+OZ
         nCRA==
X-Gm-Message-State: AOAM532OSQu72E4Bb/1LGMJYMbqmbaxM/SQQ1ovpToxTJg7HOs7DnyRR
        OsrMBu/9ojXerI1d5Kn43uaR7Ed9H66EZe/kOvyBMpUwMFa/lVg2vNm0u64BKeOIowzJLUj3L1B
        IToYY3S1x4owX
X-Received: by 2002:a5d:6087:: with SMTP id w7mr10437015wrt.158.1590084518725;
        Thu, 21 May 2020 11:08:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ9o08gBH7tx0yYBsN8onaJW/OLPfFqqFDCwm2ORoSsfevxSpfrqifuC4Sj9PcOKKkhR/Jqg==
X-Received: by 2002:a5d:6087:: with SMTP id w7mr10436991wrt.158.1590084518323;
        Thu, 21 May 2020 11:08:38 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id j1sm7269700wrm.40.2020.05.21.11.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 11:08:37 -0700 (PDT)
Date:   Thu, 21 May 2020 14:08:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, lkp@intel.com, mst@redhat.com,
        yuehaibing@huawei.com
Subject: [GIT PULL] vhost/vdpa: minor fixes
Message-ID: <20200521140835-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 0b841030625cde5f784dd62aec72d6a766faae70:

  vhost: vsock: kick send_pkt worker once device is started (2020-05-02 10:28:21 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 1b0be99f1a426d9f17ced95c4118c6641a2ff13d:

  vhost: missing __user tags (2020-05-15 11:36:31 -0400)

----------------------------------------------------------------
virtio: build warning fixes

Fix a couple of build warnings.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (1):
      vhost: missing __user tags

YueHaibing (1):
      vdpasim: remove unused variable 'ret'

 drivers/vdpa/vdpa_sim/vdpa_sim.c | 15 +++++++--------
 drivers/vhost/vhost.c            |  4 ++--
 2 files changed, 9 insertions(+), 10 deletions(-)


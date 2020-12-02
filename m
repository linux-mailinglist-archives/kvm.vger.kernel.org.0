Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83662CBBF3
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 12:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgLBLxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 06:53:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbgLBLxU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 06:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606909913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=eZnLI0Wik0eaxTfaNNAVKLQ21xyT2CoTcJpXnx1wngM=;
        b=DYE1A+98W3tnn2+7c23MG14A46HKHLzE2JcPnrB1IW8NYOX7J7eNvmgx2NmXGjfkVQvf0z
        rHexVr8IHFOHwPcjEO5rzYKyq1XN5xBvqS9Yx3rn1jx5szxr/3/lY0xLcVTYzZe0pek1Fm
        Ni5YTJmJNLMoqg5mTcHn52KN7uRR53g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-jrN-og_hOMGzRBsal0RFvw-1; Wed, 02 Dec 2020 06:51:52 -0500
X-MC-Unique: jrN-og_hOMGzRBsal0RFvw-1
Received: by mail-wr1-f71.google.com with SMTP id n13so3488269wrs.10
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 03:51:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=eZnLI0Wik0eaxTfaNNAVKLQ21xyT2CoTcJpXnx1wngM=;
        b=ON0erLv/4UvznCguqdug2ghKBhMMdC2c+sVO7BWwWeIGV9Rz6VaTH902PLTxGte6Dc
         nl6XvWxKIt9GLFqvKw5fbfPnCOfhCY183SIPwdwnVPyUpptzBVPvPgopcU6z0+p1HeN5
         Xumo2gNYbY8vkjRHDZlMSCbnsjAE5o8cnAIo2TImXpKCH0EIPDJpxFtHlOFMSZt32Byd
         DpsANVG1esWpTkaI1MXUihMLXDntclLAeUsl12bR1LDYQbLc9zE/foL1HG/IghNV7Ox7
         JE/z3thChvY0nZAsFimcBXSuuijtzFI484junzutBlixZWRMA1wLs2htt+5xy1h7s+C8
         Y4/g==
X-Gm-Message-State: AOAM533TwMfVZ/JT5Gw0JPFb1TWcTO33NFndjPiT9r5I5pqweZSmabGv
        7120Krgp0VcPxT3NVDiqIZjcRVUsM66zos89IzYJIUL0TvU3SnToYwlfUZwFFlfa4koWNeGdFUP
        TE7CeiUl2mErM
X-Received: by 2002:a05:600c:2106:: with SMTP id u6mr1002271wml.4.1606909911245;
        Wed, 02 Dec 2020 03:51:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDk/79fb5VUyBoaUX2SQVUTrvAjsll90UI65W+kVpuHWCvrrBFwGplb9GAKNlrMm4UMxEqKg==
X-Received: by 2002:a05:600c:2106:: with SMTP id u6mr1002258wml.4.1606909911075;
        Wed, 02 Dec 2020 03:51:51 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id f7sm1766312wmc.1.2020.12.02.03.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 03:51:50 -0800 (PST)
Date:   Wed, 2 Dec 2020 06:51:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, eli@mellanox.com, jasowang@redhat.com,
        leonro@nvidia.com, lkp@intel.com, mst@redhat.com,
        parav@mellanox.com, rdunlap@infradead.org, saeedm@nvidia.com
Subject: [GIT PULL] vdpa: last minute bugfixes
Message-ID: <20201202065147-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A couple of patches of the obviously correct variety.

The following changes since commit ad89653f79f1882d55d9df76c9b2b94f008c4e27:

  vhost-vdpa: fix page pinning leakage in error path (rework) (2020-11-25 04:29:07 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 2c602741b51daa12f8457f222ce9ce9c4825d067:

  vhost_vdpa: return -EFAULT if copy_to_user() fails (2020-12-02 04:36:40 -0500)

----------------------------------------------------------------
vdpa: last minute bugfixes

A couple of fixes that surfaced at the last minute.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dan Carpenter (1):
      vhost_vdpa: return -EFAULT if copy_to_user() fails

Randy Dunlap (1):
      vdpa: mlx5: fix vdpa/vhost dependencies

 drivers/Makefile     | 1 +
 drivers/vdpa/Kconfig | 1 +
 drivers/vhost/vdpa.c | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)


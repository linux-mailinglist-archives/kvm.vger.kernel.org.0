Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD74F3A9A1A
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 14:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhFPMZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 08:25:50 -0400
Received: from mx21.baidu.com ([220.181.3.85]:49226 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232772AbhFPMZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 08:25:49 -0400
Received: from BC-Mail-Ex24.internal.baidu.com (unknown [172.31.51.18])
        by Forcepoint Email with ESMTPS id E44A1A3A8669803FBE47;
        Wed, 16 Jun 2021 20:07:54 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex24.internal.baidu.com (172.31.51.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Wed, 16 Jun 2021 20:07:54 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Wed, 16 Jun 2021 20:07:54 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        "Cai Huoqing" <caihuoqing@baidu.com>
Subject: [PATCH] vhost: add vhost_test to Kconfig & Makefile
Date:   Wed, 16 Jun 2021 20:07:34 +0800
Message-ID: <20210616120734.1050-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex06.internal.baidu.com (10.127.64.16) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running vhost test, make it easier to config

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vhost/Kconfig  | 12 ++++++++++++
 drivers/vhost/Makefile |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 587fbae06182..c93c12843a6f 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -61,6 +61,18 @@ config VHOST_VSOCK
        To compile this driver as a module, choose M here: the module will be called
        vhost_vsock.
 
+config VHOST_TEST
+       tristate "vhost virtio-test driver"
+       depends on EVENTFD
+       select VHOST
+       default n
+       help
+       This kernel module can be loaded in the host kernel to test vhost function
+       with tools/virtio-test.
+
+       To compile this driver as a module, choose M here: the module will be called
+       vhost_test.
+
 config VHOST_VDPA
        tristate "Vhost driver for vDPA-based backend"
        depends on EVENTFD
diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
index f3e1897cce85..cf31c1f2652d 100644
--- a/drivers/vhost/Makefile
+++ b/drivers/vhost/Makefile
@@ -8,6 +8,9 @@ vhost_scsi-y := scsi.o
 obj-$(CONFIG_VHOST_VSOCK) += vhost_vsock.o
 vhost_vsock-y := vsock.o
 
+obj-$(CONFIG_VHOST_TEST) += vhost_test.o
+vhost_test-y := test.o
+
 obj-$(CONFIG_VHOST_RING) += vringh.o
 
 obj-$(CONFIG_VHOST_VDPA) += vhost_vdpa.o
-- 
2.22.0


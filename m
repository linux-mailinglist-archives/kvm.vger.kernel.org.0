Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581233B0009
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 11:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFVJS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 05:18:57 -0400
Received: from mx20.baidu.com ([111.202.115.85]:60692 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229486AbhFVJS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 05:18:57 -0400
Received: from BC-Mail-EX02.internal.baidu.com (unknown [172.31.51.42])
        by Forcepoint Email with ESMTPS id 2747E39B733B00C13CF6;
        Tue, 22 Jun 2021 17:16:36 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX02.internal.baidu.com (172.31.51.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.10; Tue, 22 Jun 2021 17:16:35 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Tue, 22 Jun 2021 17:16:35 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <kraxel@redhat.com>
CC:     <kbuild-all@lists.01.org>, <kvm@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH v2] remove "#include<linux/virtio.h>"
Date:   Tue, 22 Jun 2021 17:16:28 +0800
Message-ID: <20210622091628.523-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex11.internal.baidu.com (172.31.51.51) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virtio_config.h already includes virtio.h. so remove it

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c  | 1 -
 drivers/virtio/virtio.c            | 1 -
 drivers/virtio/virtio_input.c      | 1 -
 drivers/virtio/virtio_mmio.c       | 1 -
 drivers/virtio/virtio_pci_common.h | 1 -
 drivers/virtio/virtio_ring.c       | 3 +--
 drivers/virtio/virtio_vdpa.c       | 1 -
 7 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index c76ebb531212..8cb6fa86f055 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/vdpa.h>
-#include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
 #include <linux/virtio_pci.h>
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 4b15c00c0a0a..06b6c8c86ae5 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#include <linux/virtio.h>
 #include <linux/spinlock.h>
 #include <linux/virtio_config.h>
 #include <linux/module.h>
diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index ce51ae165943..ab8439a94f73 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/module.h>
-#include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <linux/input.h>
 #include <linux/slab.h>
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 56128b9c46eb..5061ff088dd1 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -64,7 +64,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <uapi/linux/virtio_mmio.h>
 #include <linux/virtio_ring.h>
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index beec047a8f8d..acae912fdb12 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -21,7 +21,6 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
 #include <linux/virtio_pci.h>
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 71e16b53e9c1..0dfe9aa0dad9 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -3,9 +3,8 @@
  *
  *  Copyright 2007 Rusty Russell IBM Corporation
  */
-#include <linux/virtio.h>
-#include <linux/virtio_ring.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_ring.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/module.h>
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e28acf482e0c..80f75401296e 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/uuid.h>
-#include <linux/virtio.h>
 #include <linux/vdpa.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_ring.h>
-- 
2.22.0


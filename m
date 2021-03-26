Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2333A34A33F
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 09:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhCZIhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 04:37:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14616 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhCZIhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 04:37:06 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6Fdx6kndz19JfR;
        Fri, 26 Mar 2021 16:35:01 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.179.202) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 16:36:54 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 3/4] vfio/pci: fix a couple of spelling mistakes
Date:   Fri, 26 Mar 2021 16:35:27 +0800
Message-ID: <20210326083528.1329-4-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210326083528.1329-1-thunder.leizhen@huawei.com>
References: <20210326083528.1329-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are several spelling mistakes, as follows:
permision ==> permission
thru ==> through
presense ==> presence

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/vfio/pci/vfio_pci.c         | 2 +-
 drivers/vfio/pci/vfio_pci_config.c  | 2 +-
 drivers/vfio/pci/vfio_pci_nvlink2.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b44578c29..d2ab8b5bc8a86fe 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2409,7 +2409,7 @@ static int __init vfio_pci_init(void)
 {
 	int ret;
 
-	/* Allocate shared config space permision data used by all devices */
+	/* Allocate shared config space permission data used by all devices */
 	ret = vfio_pci_init_perm_bits();
 	if (ret)
 		return ret;
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index a402adee8a21558..d57f037f65b85d4 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -101,7 +101,7 @@
 /*
  * Read/Write Permission Bits - one bit for each bit in capability
  * Any field can be read if it exists, but what is read depends on
- * whether the field is 'virtualized', or just pass thru to the
+ * whether the field is 'virtualized', or just pass through to the
  * hardware.  Any virtualized field is also virtualized for writes.
  * Writes are only permitted if they have a 1 bit here.
  */
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index 9adcf6a8f888575..f276624fec79f68 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -219,7 +219,7 @@ int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
 	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
 
 	/*
-	 * PCI config space does not tell us about NVLink presense but
+	 * PCI config space does not tell us about NVLink presence but
 	 * platform does, use this.
 	 */
 	npu_dev = pnv_pci_get_npu_dev(vdev->pdev, 0);
@@ -402,7 +402,7 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
 	u32 link_speed = 0xff;
 
 	/*
-	 * PCI config space does not tell us about NVLink presense but
+	 * PCI config space does not tell us about NVLink presence but
 	 * platform does, use this.
 	 */
 	if (!pnv_pci_get_gpu_dev(vdev->pdev))
-- 
1.8.3



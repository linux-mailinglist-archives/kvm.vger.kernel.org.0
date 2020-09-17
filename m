Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6707A26D1E4
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 05:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgIQDr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 23:47:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12771 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbgIQDrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 23:47:25 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 23:47:24 EDT
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B9C8432ED3D7CC57E10C;
        Thu, 17 Sep 2020 11:32:08 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.226) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 11:32:02 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] vfio/pci: Remove redundant declaration of vfio_pci_driver
Date:   Thu, 17 Sep 2020 11:31:27 +0800
Message-ID: <20200917033128.872-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It was added by commit 137e5531351d ("vfio/pci: Add sriov_configure
support") and actually unnecessary. Remove it.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 drivers/vfio/pci/vfio_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 1ab1f5cda4ac..da68e2f86622 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1862,7 +1862,6 @@ static const struct vfio_device_ops vfio_pci_ops = {
 
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
-static struct pci_driver vfio_pci_driver;
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
-- 
2.19.1


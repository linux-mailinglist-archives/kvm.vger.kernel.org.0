Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B146271A34
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 06:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgIUEvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 00:51:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13735 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgIUEvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 00:51:36 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ACE0EDAEC123FCDC541F;
        Mon, 21 Sep 2020 12:51:32 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.226) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 12:51:26 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 1/2] vfio/pci: Remove redundant declaration of vfio_pci_driver
Date:   Mon, 21 Sep 2020 12:51:15 +0800
Message-ID: <20200921045116.258-1-yuzenghui@huawei.com>
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
support") but duplicates a forward declaration earlier in the file.

Remove it.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
* From v1:
  - Clarify the commit message per Alex's suggestion.
  - Add Cornelia's R-b tag.

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


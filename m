Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0D33B1A7
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 12:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhCOLqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 07:46:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14342 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhCOLqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 07:46:31 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DzZMp0Wmmz8yZw;
        Mon, 15 Mar 2021 19:44:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 19:46:18 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH] vfio/pci: Remove an unnecessary blank line in vfio_pci_enable
Date:   Mon, 15 Mar 2021 19:34:33 +0800
Message-ID: <1615808073-178604-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This blank line is unnecessary, so remove it.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/vfio/pci/vfio_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b..0619afd 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -378,7 +378,6 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-
 	if (vfio_pci_is_vga(pdev) &&
 	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
-- 
2.8.1


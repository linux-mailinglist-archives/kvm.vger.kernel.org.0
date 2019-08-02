Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C61F7ECFF
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 08:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbfHBG7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 02:59:20 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39045 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389251AbfHBG7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 02:59:19 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 2 Aug 2019 09:59:13 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x726x7pY004367;
        Fri, 2 Aug 2019 09:59:11 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, wankhede@nvidia.com,
        linux-kernel@vger.kernel.org
Cc:     parav@mellanox.com, alex.williamson@redhat.com, cohuck@redhat.com,
        cjia@nvidia.com
Subject: [PATCH 2/2] vfio/mdev: Removed unused and redundant API for mdev name
Date:   Fri,  2 Aug 2019 01:59:05 -0500
Message-Id: <20190802065905.45239-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190802065905.45239-1-parav@mellanox.com>
References: <20190802065905.45239-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no single production driver who is interested in mdev device
name.
Additionally mdev device name is already available using core kernel
API dev_name().

Hence removed unused exported symbol.

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c | 6 ------
 include/linux/mdev.h          | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b558d4cfd082..c2b809cbe59f 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -57,12 +57,6 @@ struct mdev_device *mdev_from_dev(struct device *dev)
 }
 EXPORT_SYMBOL(mdev_from_dev);
 
-const guid_t *mdev_uuid(struct mdev_device *mdev)
-{
-	return &mdev->uuid;
-}
-EXPORT_SYMBOL(mdev_uuid);
-
 /* Should be called holding parent_list_lock */
 static struct mdev_parent *__find_parent_device(struct device *dev)
 {
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78db0..375a5830c3d8 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -131,7 +131,6 @@ struct mdev_driver {
 
 void *mdev_get_drvdata(struct mdev_device *mdev);
 void mdev_set_drvdata(struct mdev_device *mdev, void *data);
-const guid_t *mdev_uuid(struct mdev_device *mdev);
 
 extern struct bus_type mdev_bus_type;
 
-- 
2.21.0.777.g83232e3864


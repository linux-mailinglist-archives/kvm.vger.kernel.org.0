Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B9E1029C
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 00:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfD3Wtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 18:49:49 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45869 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727459AbfD3Wts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 18:49:48 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 May 2019 01:49:43 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x3UMncnW009688;
        Wed, 1 May 2019 01:49:42 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     cjia@nvidia.com, parav@mellanox.com
Subject: [PATCHv2 02/10] vfio/mdev: Removed unused kref
Date:   Tue, 30 Apr 2019 17:49:29 -0500
Message-Id: <20190430224937.57156-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190430224937.57156-1-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unused kref from the mdev_device structure.

Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c    | 1 -
 drivers/vfio/mdev/mdev_private.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 1299d2e72ce2..00ca61392de9 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -311,7 +311,6 @@ int mdev_device_create(struct kobject *kobj,
 	mutex_unlock(&mdev_list_lock);
 
 	mdev->parent = parent;
-	kref_init(&mdev->ref);
 
 	mdev->dev.parent  = dev;
 	mdev->dev.bus     = &mdev_bus_type;
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 379758c52b1b..ddcf9c72bd8a 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -30,7 +30,6 @@ struct mdev_device {
 	struct mdev_parent *parent;
 	guid_t uuid;
 	void *driver_data;
-	struct kref ref;
 	struct list_head next;
 	struct kobject *type_kobj;
 	bool active;
-- 
2.19.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23806102A7
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 00:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfD3WuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 18:50:23 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45934 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727629AbfD3Wt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 18:49:58 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 May 2019 01:49:52 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x3UMncnb009688;
        Wed, 1 May 2019 01:49:50 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com
Cc:     cjia@nvidia.com, parav@mellanox.com
Subject: [PATCHv2 07/10] vfio/mdev: Avoid inline get and put parent helpers
Date:   Tue, 30 Apr 2019 17:49:34 -0500
Message-Id: <20190430224937.57156-8-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190430224937.57156-1-parav@mellanox.com>
References: <20190430224937.57156-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As section 15 of Documentation/process/coding-style.rst clearly
describes that compiler will be able to optimize code.

Hence drop inline for get and put helpers for parent.

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 drivers/vfio/mdev/mdev_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 1a317e409355..1040a4a2dcbc 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -88,7 +88,7 @@ static void mdev_release_parent(struct kref *kref)
 	put_device(dev);
 }
 
-static inline struct mdev_parent *mdev_get_parent(struct mdev_parent *parent)
+static struct mdev_parent *mdev_get_parent(struct mdev_parent *parent)
 {
 	if (parent)
 		kref_get(&parent->ref);
@@ -96,7 +96,7 @@ static inline struct mdev_parent *mdev_get_parent(struct mdev_parent *parent)
 	return parent;
 }
 
-static inline void mdev_put_parent(struct mdev_parent *parent)
+static void mdev_put_parent(struct mdev_parent *parent)
 {
 	if (parent)
 		kref_put(&parent->ref, mdev_release_parent);
-- 
2.19.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729E31246E6
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 13:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLRMbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 07:31:31 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:40550 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbfLRMbb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 07:31:31 -0500
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1ihYU4-0002im-NY; Wed, 18 Dec 2019 12:31:20 +0000
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1ihYU4-00Apur-7O; Wed, 18 Dec 2019 12:31:20 +0000
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     ben.dooks@codethink.co.uk
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/mdev: make create attribute static
Date:   Wed, 18 Dec 2019 12:31:19 +0000
Message-Id: <20191218123119.2582802-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The create attribute is not exported, so make it
static to avoid the following sparse warning:

drivers/vfio/mdev/mdev_sysfs.c:77:1: warning: symbol 'mdev_type_attr_create' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 7570c7602ab4..8ad14e5c02bf 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -74,7 +74,7 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
 	return count;
 }
 
-MDEV_TYPE_ATTR_WO(create);
+static MDEV_TYPE_ATTR_WO(create);
 
 static void mdev_type_release(struct kobject *kobj)
 {
-- 
2.24.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA18D67FDAC
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 09:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjA2Imm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 03:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbjA2Iml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 03:42:41 -0500
X-Greylist: delayed 65 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Jan 2023 00:42:38 PST
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E556CDDD;
        Sun, 29 Jan 2023 00:42:37 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id ZBT00023;
        Sun, 29 Jan 2023 16:41:23 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.16; Sun, 29 Jan 2023 16:41:24 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <kwankhede@nvidia.com>, <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] vfio/mdev: Use sysfs_emit() to instead of sprintf()
Date:   Sun, 29 Jan 2023 03:41:17 -0500
Message-ID: <20230129084117.2384-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   202312916412346fe8f06447fff3b77b970bd2ed67da7
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/vfio/mdev/mdev_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index abe3359dd477..e4490639d383 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -96,7 +96,7 @@ static MDEV_TYPE_ATTR_RO(device_api);
 static ssize_t name_show(struct mdev_type *mtype,
 			 struct mdev_type_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 		mtype->pretty_name ? mtype->pretty_name : mtype->sysfs_name);
 }
 
-- 
2.27.0


Return-Path: <kvm+bounces-73248-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id E0VtJvDurWka9wEAu9opvQ
	(envelope-from <kvm+bounces-73248-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 22:49:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 03886232592
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 22:49:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F54E3011747
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 21:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF550355F49;
	Sun,  8 Mar 2026 21:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="eXrOd83D"
X-Original-To: kvm@vger.kernel.org
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150BB279DB3
	for <kvm@vger.kernel.org>; Sun,  8 Mar 2026 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773006566; cv=none; b=Am7bBkhPgQWkJKIct1T+B9L7Ngpao6WbdxZBTAN0QhWIMwD9z0g6mCEfj7PVGn9iGz8vjU/4c4fN17nB1DiLBpDWRiUK0q/dRRDZ8XTRHNXh7iuaMoTRZPmgisxwFmv4XrcX1I6rG+j4q3n2Hm1TxrUF5KQ+9CiB2FKvqQjjmIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773006566; c=relaxed/simple;
	bh=8eUodJoImyp3FpY1awWiZQWm9hUZMkl7VClTa58uKYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aTvj5PCGkVEw/eswQ9m9KOxl4jFPBm46/skfHjZowRi7LSuw+ufsecTx8bB2Qw7gp1FX7Sqt6ZMqmM/8W5suNPAjNsZiGVIXeO4leRzD0hia9VszEarq52HXqpUMZyVqKZruN8/xTAahqeNxBT8+LUGH9M+qu3KuujgGOtjoTqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=eXrOd83D; arc=none smtp.client-ip=195.121.94.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
X-KPN-MessageId: ab70d234-1b38-11f1-8a98-005056ab378f
Received: from smtp.kpnmail.nl (unknown [10.31.155.37])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id ab70d234-1b38-11f1-8a98-005056ab378f;
	Sun, 08 Mar 2026 22:49:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=/hD77eT0WFhDi8fkYCqVxQSPbeWfWws7rsHE8QnhqoQ=;
	b=eXrOd83DHK5jIx0vfFAe0m1IDqeftPLmovIVXjfIJkVVxJfthR7ZXh8dOu2/JkFLzXQzJIohN50Fy
	 IGqqfcM+Q8TQCSylsFka0RsMku6yXdLJsV/RbMaKe7P0d4ep8LQaJL6iEhk4NOn8XCn6W/j0iLv5Ar
	 ATCS7SMweGCbCPwYhiieHRkF7wWHkPvpbk7XTX210dIajAHQ96XKBhqG4FhVDp8Um820ZzbMFk1fyl
	 a6gvWy9cuGIKvJdKl4hK7kXpUmmih/fuiqiP8nx7MTZ8BudiJ09+8tzfTf/3hpVQzeCg+YZIv4eT4c
	 214brfwQdlKWZdTCESwLw0HKny40xWg==
X-KPN-MID: 33|z3L3e0rFyDUM1v+oDap6aAmV867SHMDOaNaV7jf/6+XAUdcLwO1s7Yk0cq7hrAZ
 qAcSlN+b8Cu5grEIIkrQbnsv8ZV0Je9mcnLpobwAHBLQ=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|T6FDhkZletdXcGyERNjjjxtrbRKu9ulq1yqZMMEbVLbDY2/INX1Z6Z4fId36opD
 fRnUh+SzdCyGhiL57XITJow==
Received: from daedalus.home (unknown [178.229.142.230])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id a8d6e635-1b38-11f1-bdab-005056ab1411;
	Sun, 08 Mar 2026 22:49:23 +0100 (CET)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: gregkh@linuxfoundation.org,
	Kirti Wankhede <kwankhede@nvidia.com>
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	kvm@vger.kernel.org (open list:VFIO MEDIATED DEVICE DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] vfio: mdev: replace mtty_dev->vd_class with a const struct class
Date: Sun,  8 Mar 2026 22:49:39 +0100
Message-ID: <20260308214939.1215682-1-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03886232592
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[xs4all.nl,reject];
	R_DKIM_ALLOW(-0.20)[xs4all.nl:s=xs4all01];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[xs4all.nl];
	FREEMAIL_CC(0.00)[xs4all.nl,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-73248-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jkoolstra@xs4all.nl,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[xs4all.nl:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.983];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

The class_create() call has been deprecated in favor of class_register()
as the driver core now allows for a struct class to be in read-only
memory. Replace mtty_dev->vd_class with a const struct class and drop the
class_create() call.

Compile tested and found no errors/warns in dmesg after enabling
CONFIG_VFIO and CONFIG_SAMPLE_VFIO_MDEV_MTTY.

Link: https://lore.kernel.org/all/2023040244-duffel-pushpin-f738@gregkh/

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
v2: undo whitespace reformating of struct mtty_dev

 samples/vfio-mdev/mtty.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index bd92c38379b8..01a9db84c4ab 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -68,9 +68,12 @@
  * Global Structures
  */
 
+static const struct class mtty_class = {
+	.name	= MTTY_CLASS_NAME
+};
+
 static struct mtty_dev {
 	dev_t		vd_devt;
-	struct class	*vd_class;
 	struct cdev	vd_cdev;
 	struct idr	vd_idr;
 	struct device	dev;
@@ -1980,15 +1983,14 @@ static int __init mtty_dev_init(void)
 	if (ret)
 		goto err_cdev;
 
-	mtty_dev.vd_class = class_create(MTTY_CLASS_NAME);
+	ret = class_register(&mtty_class);
 
-	if (IS_ERR(mtty_dev.vd_class)) {
+	if (ret) {
 		pr_err("Error: failed to register mtty_dev class\n");
-		ret = PTR_ERR(mtty_dev.vd_class);
 		goto err_driver;
 	}
 
-	mtty_dev.dev.class = mtty_dev.vd_class;
+	mtty_dev.dev.class = &mtty_class;
 	mtty_dev.dev.release = mtty_device_release;
 	dev_set_name(&mtty_dev.dev, "%s", MTTY_NAME);
 
@@ -2007,7 +2009,7 @@ static int __init mtty_dev_init(void)
 	device_del(&mtty_dev.dev);
 err_put:
 	put_device(&mtty_dev.dev);
-	class_destroy(mtty_dev.vd_class);
+	class_unregister(&mtty_class);
 err_driver:
 	mdev_unregister_driver(&mtty_driver);
 err_cdev:
@@ -2026,8 +2028,7 @@ static void __exit mtty_dev_exit(void)
 	mdev_unregister_driver(&mtty_driver);
 	cdev_del(&mtty_dev.vd_cdev);
 	unregister_chrdev_region(mtty_dev.vd_devt, MINORMASK + 1);
-	class_destroy(mtty_dev.vd_class);
-	mtty_dev.vd_class = NULL;
+	class_unregister(&mtty_class);
 	pr_info("mtty_dev: Unloaded!\n");
 }
 

base-commit: d466c332e106fe666d1e2f5a24d08e308bebbfa1
-- 
2.53.0



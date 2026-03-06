Return-Path: <kvm+bounces-73157-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Nr4M0smq2n6aAEAu9opvQ
	(envelope-from <kvm+bounces-73157-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 20:08:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FAAE226F14
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 20:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9494C312634B
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 19:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDBD421A1D;
	Fri,  6 Mar 2026 19:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="Amzj5KPf"
X-Original-To: kvm@vger.kernel.org
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3B2421F02
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 19:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772823990; cv=none; b=D5em9QCVxlaJkyJFU6ekWNnoN0lrpShUJkn2vCGosBEyD90L95dssBKJBv+zBwa12RNt7Q0IjZx7yhxmhhjd9rgSkdOdeAPaWJSCwjqeC2N3x3Zi+YpvphM37z4ngopxOjhqNudPMBSE8fEEExa05F19KOFfXalc8jJm3Yx2dgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772823990; c=relaxed/simple;
	bh=CMv+g1vfrTqXWReBv0pZIh3m84HSFZRK46E+iGjoyNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ttm3SWHdsC+bTrwUoOvndc5Ysp/aoXOx5SQt+P79VeF/cB4c+/NtiuovP4iWWw1Nd8D/DjgW9j1rPGrq+bh3WdHcELJSgEjV7gHg4stkvsUgtwpjcL24Bh9UIlKbILzPOJtT8GRqCHiJzTDjs3qVXQYAzYhokEh8F4iG6cQB9rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=Amzj5KPf; arc=none smtp.client-ip=195.121.94.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
X-KPN-MessageId: 8ff0c5dd-198f-11f1-8a98-005056ab378f
Received: from smtp.kpnmail.nl (unknown [10.31.155.38])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 8ff0c5dd-198f-11f1-8a98-005056ab378f;
	Fri, 06 Mar 2026 20:06:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=Z56SMtLYepksDxwqSQj+YPsQI8n1P2G+SyQfrT3KX5Y=;
	b=Amzj5KPf9hQZUsigBlp+mgGnSMuE/889bQUl94JMKQZds5S/P4apOH1yP+29S0TQ9ap4GNrX77G9T
	 LEDUJgn2qgt0B0BcTQ7RyqP72YCfA3YG7pySwJ5eI6iBT3DJP/uQO+SeHDXov4HYogY/tbbvyegbmI
	 +2Zd8c02lWdtChpAEiGPi7f2RLPC6bsd0+xyynyw15KSUcMwAdjSe5byvUcuG5BBPeiQuixuYBvPzD
	 U4lb+O5Zks+Rv/Xx54ORpHxCrwMhbqeKdzM6101n6ZZlJrFajo3+xicf76WPoPN4YZXz7o0NPdQMZH
	 JpaIETAmP5ylwCJ0NifRP/Zk2rMYjDA==
X-KPN-MID: 33|TETzoW3YXOqnoq+BQxMEQbEEC45AzIwfI40F21ptH/DKQ8dqDTVns6gzxJvsDGm
 i1fxN/gduJA+50rQfnRVRAoIdav2roEQ5IwxQdqKWCag=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|OAYGFjakxNZ35aHuHM5GMgB+9vxGqpyZZ9oNJiAeRX0gfZtKmmt9IocLRH00bjw
 wHsxSIVrdLvpu6eAVfFItQQ==
Received: from daedalus.home (unknown [178.229.169.227])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 8ce5196a-198f-11f1-a6ca-005056abf0db;
	Fri, 06 Mar 2026 20:06:21 +0100 (CET)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Alex Williamson <alex@shazbot.org>
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kvm@vger.kernel.org (open list:VFIO DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] vfio: replace vfio->class with a const struct class
Date: Fri,  6 Mar 2026 20:06:28 +0100
Message-ID: <20260306190628.259203-1-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3FAAE226F14
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
	FREEMAIL_CC(0.00)[xs4all.nl,linuxfoundation.org,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-73157-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.982];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,xs4all.nl:dkim,xs4all.nl:email,xs4all.nl:mid]
X-Rspamd-Action: no action

The class_create() call has been deprecated in favor of class_register()
as the driver core now allows for a struct class to be in read-only
memory. Replace vfio->class with a const struct class and drop the
class_create() call.

Compile tested and found no errors/warns in dmesg after enabling
VFIO_GROUP.

Link: https://lore.kernel.org/all/2023040244-duffel-pushpin-f738@gregkh/

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 drivers/vfio/group.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 4f15016d2a5f..d4a53f8c5be0 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -15,8 +15,13 @@
 #include <linux/anon_inodes.h>
 #include "vfio.h"
 
+static char *vfio_devnode(const struct device *, umode_t *);
+static const struct class vfio_class = {
+	.name	= "vfio",
+	.devnode = vfio_devnode
+};
+
 static struct vfio {
-	struct class			*class;
 	struct list_head		group_list;
 	struct mutex			group_lock; /* locks group_list */
 	struct ida			group_ida;
@@ -527,7 +532,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 
 	device_initialize(&group->dev);
 	group->dev.devt = MKDEV(MAJOR(vfio.group_devt), minor);
-	group->dev.class = vfio.class;
+	group->dev.class = &vfio_class;
 	group->dev.release = vfio_group_release;
 	cdev_init(&group->cdev, &vfio_group_fops);
 	group->cdev.owner = THIS_MODULE;
@@ -901,13 +906,9 @@ int __init vfio_group_init(void)
 		return ret;
 
 	/* /dev/vfio/$GROUP */
-	vfio.class = class_create("vfio");
-	if (IS_ERR(vfio.class)) {
-		ret = PTR_ERR(vfio.class);
+	ret = class_register(&vfio_class);
+	if (ret)
 		goto err_group_class;
-	}
-
-	vfio.class->devnode = vfio_devnode;
 
 	ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");
 	if (ret)
@@ -915,8 +916,7 @@ int __init vfio_group_init(void)
 	return 0;
 
 err_alloc_chrdev:
-	class_destroy(vfio.class);
-	vfio.class = NULL;
+	class_unregister(&vfio_class);
 err_group_class:
 	vfio_container_cleanup();
 	return ret;
@@ -927,7 +927,6 @@ void vfio_group_cleanup(void)
 	WARN_ON(!list_empty(&vfio.group_list));
 	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
-	class_destroy(vfio.class);
-	vfio.class = NULL;
+	class_unregister(&vfio_class);
 	vfio_container_cleanup();
 }

base-commit: d466c332e106fe666d1e2f5a24d08e308bebbfa1
-- 
2.53.0



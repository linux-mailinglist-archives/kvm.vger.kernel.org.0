Return-Path: <kvm+bounces-73160-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAVnAuY7q2nIbQEAu9opvQ
	(envelope-from <kvm+bounces-73160-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 21:41:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8E6227966
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 21:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2EC1C3057495
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 20:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFC548094D;
	Fri,  6 Mar 2026 20:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="D7I1XlZi"
X-Original-To: kvm@vger.kernel.org
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2BD36402C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 20:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772829643; cv=none; b=p97hX97186KwGH3KUEr22GHj1I4jmGeEV6bDqBUwNndcH+2QGos5K+/833BPnkXk2smPE5dlGtXPvgJV9NthzKnhKFVGm4YYBehVBQfzcEojzWEkVmPPWZNW/mUcLUEgoaikla1ZFTT/7iUlvtSGpSJYIqHlMn4S82EgH6oi0iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772829643; c=relaxed/simple;
	bh=fZov2wWZ7+pWx/QK209A+8hFUI498HOFP0A9gGM5Dac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I25trouEk4q29nV7Il6Bi2Ei0poiaVrLhBq8dTi80qRL+7w8NAb2P8vm/BF8Sp2BzEB3AZZX/WuHZ5DDJYn0bcifGmUhdLJPSAkbKkCt0gN/3mhLnB4pqq9b6yvJVwlCchuJyUlqiabHgVjkBDjfEqhdShHRABtlkPRfFY57AGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=D7I1XlZi; arc=none smtp.client-ip=195.121.94.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
X-KPN-MessageId: b8b1edd3-199c-11f1-969b-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.40])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id b8b1edd3-199c-11f1-969b-005056abbe64;
	Fri, 06 Mar 2026 21:40:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=7qc9C69HS/+rD+HLj5vcMmhY/AM6OYW4T48tFqLcL8I=;
	b=D7I1XlZiKBRMg4XDy4C1h6HrjpCTVyzLlf+KEXSqfkiGUn5v7iPheaAzY/RdFz+HKrlz62v1B3flB
	 INwrBLngq69XLAJoXp1wuA3AutuuLuTCCugTq4fKSYErkYzg+5hMjWfLFNs4Ne640408qMqFw65Cvy
	 1QERucjNFsaQVy4yI4J/WR5uKINztlqQc5Yr6V4jeYqBWzbLZomE4SMLfFTPhgeXcQ57KBPNl/I/Fl
	 76gEZRQCh67NP9L82EGT+dwF93dQOyIXgwaHlfpJVRExCPfv7tXLM5/tidqSZLjtQ/DPBHIwj03B66
	 sAY4dYsr/PKojCpAJY+ZHuRIXnxYIkQ==
X-KPN-MID: 33|Vwi4mJbVsTJ8w2BJrpDHmGwULaKAXRHxEQYcZNw9mA7bCaZC8LYSU8T9bvZyVf4
 3t2eT3889Pu4Brx/HlDQgak9ACc8hRTFq8+88mX3Q1y8=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|FrO6EcCzp/BZgqo1Gf9OovqORtfd2YhJCuRZoXWEPTmxwShAKU3L6GcYdnAqbJM
 SIg8S6r5n7/opQpBSjd+d3A==
Received: from daedalus.home (unknown [178.229.169.227])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id b561bf91-199c-11f1-b8e3-005056ab7584;
	Fri, 06 Mar 2026 21:40:32 +0100 (CET)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Alex Williamson <alex@shazbot.org>
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kvm@vger.kernel.org (open list:VFIO DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] vfio: replace vfio->device_class with a const struct class
Date: Fri,  6 Mar 2026 21:40:31 +0100
Message-ID: <20260306204032.353452-1-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F8E6227966
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[xs4all.nl,reject];
	R_DKIM_ALLOW(-0.20)[xs4all.nl:s=xs4all01];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[xs4all.nl];
	FREEMAIL_CC(0.00)[xs4all.nl,linuxfoundation.org,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-73160-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,xs4all.nl:dkim,xs4all.nl:email,xs4all.nl:mid]
X-Rspamd-Action: no action

The class_create() call has been deprecated in favor of class_register()
as the driver core now allows for a struct class to be in read-only
memory. Replace vfio->device_class with a const struct class and drop
the class_create() call.

Compile tested with both CONFIG_VFIO_DEVICE_CDEV on and off (and
CONFIG_VFIO on); found no errors/warns in dmesg.

Link: https://lore.kernel.org/all/2023040244-duffel-pushpin-f738@gregkh/

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 drivers/vfio/device_cdev.c |  8 +-------
 drivers/vfio/vfio.h        |  4 ++--
 drivers/vfio/vfio_main.c   | 27 ++++++++++++++++-----------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 8ceca24ac136..f926685a371d 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -293,14 +293,8 @@ int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
 	return 0;
 }
 
-static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
+int vfio_cdev_init(const struct class *device_class)
 {
-	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
-}
-
-int vfio_cdev_init(struct class *device_class)
-{
-	device_class->devnode = vfio_device_devnode;
 	return alloc_chrdev_region(&device_devt, 0,
 				   MINORMASK + 1, "vfio-dev");
 }
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bca..fdc918771b05 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -378,7 +378,7 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
 long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 				struct vfio_device_bind_iommufd __user *arg);
 void vfio_df_unbind_iommufd(struct vfio_device_file *df);
-int vfio_cdev_init(struct class *device_class);
+int vfio_cdev_init(const struct class *device_class);
 void vfio_cdev_cleanup(void);
 #else
 static inline void vfio_init_device_cdev(struct vfio_device *device)
@@ -411,7 +411,7 @@ static inline void vfio_df_unbind_iommufd(struct vfio_device_file *df)
 {
 }
 
-static inline int vfio_cdev_init(struct class *device_class)
+static inline int vfio_cdev_init(const struct class *device_class)
 {
 	return 0;
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 742477546b15..eecf8a1a5237 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -49,7 +49,6 @@
 #define VFIO_MAGIC 0x5646494f /* "VFIO" */
 
 static struct vfio {
-	struct class			*device_class;
 	struct ida			device_ida;
 	struct vfsmount			*vfs_mount;
 	int				fs_count;
@@ -64,6 +63,16 @@ MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  Thi
 
 static DEFINE_XARRAY(vfio_device_set_xa);
 
+static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
+}
+
+static const struct class vfio_device_class = {
+	.name		= "vfio-dev",
+	.devnode	= vfio_device_devnode
+};
+
 int vfio_assign_device_set(struct vfio_device *device, void *set_id)
 {
 	unsigned long idx = (unsigned long)set_id;
@@ -299,7 +308,7 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
 
 	device_initialize(&device->device);
 	device->device.release = vfio_device_release;
-	device->device.class = vfio.device_class;
+	device->device.class = &vfio_device_class;
 	device->device.parent = device->dev;
 	return 0;
 
@@ -1783,13 +1792,11 @@ static int __init vfio_init(void)
 		goto err_virqfd;
 
 	/* /sys/class/vfio-dev/vfioX */
-	vfio.device_class = class_create("vfio-dev");
-	if (IS_ERR(vfio.device_class)) {
-		ret = PTR_ERR(vfio.device_class);
+	ret = class_register(&vfio_device_class);
+	if (ret)
 		goto err_dev_class;
-	}
 
-	ret = vfio_cdev_init(vfio.device_class);
+	ret = vfio_cdev_init(&vfio_device_class);
 	if (ret)
 		goto err_alloc_dev_chrdev;
 
@@ -1798,8 +1805,7 @@ static int __init vfio_init(void)
 	return 0;
 
 err_alloc_dev_chrdev:
-	class_destroy(vfio.device_class);
-	vfio.device_class = NULL;
+	class_unregister(&vfio_device_class);
 err_dev_class:
 	vfio_virqfd_exit();
 err_virqfd:
@@ -1812,8 +1818,7 @@ static void __exit vfio_cleanup(void)
 	vfio_debugfs_remove_root();
 	ida_destroy(&vfio.device_ida);
 	vfio_cdev_cleanup();
-	class_destroy(vfio.device_class);
-	vfio.device_class = NULL;
+	class_unregister(&vfio_device_class);
 	vfio_virqfd_exit();
 	vfio_group_cleanup();
 	xa_destroy(&vfio_device_set_xa);

base-commit: d466c332e106fe666d1e2f5a24d08e308bebbfa1
-- 
2.53.0



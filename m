Return-Path: <kvm+bounces-73243-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAFOG517rWmw3QEAu9opvQ
	(envelope-from <kvm+bounces-73243-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 14:37:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D55D42306FA
	for <lists+kvm@lfdr.de>; Sun, 08 Mar 2026 14:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CD4B4300CFC4
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 13:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4E338550A;
	Sun,  8 Mar 2026 13:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="eAanaU6m"
X-Original-To: kvm@vger.kernel.org
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EE1313E17
	for <kvm@vger.kernel.org>; Sun,  8 Mar 2026 13:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772977050; cv=none; b=sZIaLPJG5Yyg0TG5miJnI2E14e65EOmvhl309j2C/lP4gNaR1BWOd0pASwvDZ7VlAj733jvuWM/wkYRmXMfA95lwplMAOESv/D2hiVmKDqAIn+feU1dVwZPGra2by+ooVImI+GpHpBECQ1zlLtNzoOkWU5IsKlgEgRx1o6uwkAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772977050; c=relaxed/simple;
	bh=0NvfC6vfW8WYD0Nk6N7E/5rGJ2db5KGh3f9xQYzzeOc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yne3QVrmz750ApcjzVEZWQUrsCIlMR+EaLOzZ2+dm4G8kYR0FXrJo0voMgOHu9+RBbXmk6Df64x/Z4o4ySFA9+ra7Hqb5ySUvVPVPAivnU9jcfFrGa7O15faLmJzwpCrtgMjPv773AMS8zpG10A8GxRJ7UQjiRApO7CajZwxh6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=eAanaU6m; arc=none smtp.client-ip=195.121.94.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
X-KPN-MessageId: f248eed0-1af3-11f1-969b-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.39])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id f248eed0-1af3-11f1-969b-005056abbe64;
	Sun, 08 Mar 2026 14:37:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=3tY10PRCxb6Spz7EbJ5jkohqOnUvfcSP7anbBvZfeNY=;
	b=eAanaU6mSxJvrFs+RnW7GLxAGDnqxJw7rASXFTXXf6G3o9JWpygLG/eAuPR4TdZjtsm5Fc9Cg2a4f
	 Pus9G1PbGYci7krebCtcnoAoE6s/+qICqgmVDpPgzxTbuYSfgoPA1V80Gv3s5+haOH6wet7JCtJBoG
	 dnhoWYftR01FourzX5mwkMvGCsgYksSXJPUu3Oy36nbp5hAGAGeaQvLcFQ85Ig5V25xWREt4yTNa8o
	 wyzz3mXc4xpY7+m5q5Dl8xfrOGOXuDCzIlrvNlSK+36/EfKrQ7ByOD/r3DFbjXvZxL3mJFQAm3ogRG
	 z9F7pfNDy85COksrYrvdNpujz3UE5qA==
X-KPN-MID: 33|JRRn5BnP7NQIE72njQ+Uhx5gaQeADMJWO/cc2ll9gBQzkoawKrwEI6ECzrm/MP2
 ro1ndyGrPPLQtwm0zl9lO0G2ZjNB8fnA760gEmFVw/u8=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|JvVbe5geC7FkzHxUFmMGtgvPTQevq4ZabhMT9HBBuUyDZqz0YQMzCElNJ5bFTuu
 JTKcwkN2GyPco2cwJExlVnA==
Received: from daedalus.home (unknown [178.229.45.71])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id ef9dfa17-1af3-11f1-8011-005056ab7447;
	Sun, 08 Mar 2026 14:37:26 +0100 (CET)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: gregkh@linuxfoundation.org,
	Kirti Wankhede <kwankhede@nvidia.com>
Cc: Jori Koolstra <jkoolstra@xs4all.nl>,
	kvm@vger.kernel.org (open list:VFIO MEDIATED DEVICE DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] vfio: mdev: replace mtty_dev->vd_class with a const struct class
Date: Sun,  8 Mar 2026 14:37:33 +0100
Message-ID: <20260308133733.1110551-1-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D55D42306FA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[xs4all.nl,reject];
	R_DKIM_ALLOW(-0.20)[xs4all.nl:s=xs4all01];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[xs4all.nl];
	FREEMAIL_CC(0.00)[xs4all.nl,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-73243-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
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
 samples/vfio-mdev/mtty.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index bd92c38379b8..792f5c212fd1 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -68,13 +68,16 @@
  * Global Structures
  */
 
+static const struct class mtty_class = {
+	.name	= MTTY_CLASS_NAME
+};
+
 static struct mtty_dev {
-	dev_t		vd_devt;
-	struct class	*vd_class;
-	struct cdev	vd_cdev;
-	struct idr	vd_idr;
-	struct device	dev;
-	struct mdev_parent parent;
+	dev_t			vd_devt;
+	struct cdev		vd_cdev;
+	struct idr		vd_idr;
+	struct device		dev;
+	struct mdev_parent	parent;
 } mtty_dev;
 
 struct mdev_region_info {
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



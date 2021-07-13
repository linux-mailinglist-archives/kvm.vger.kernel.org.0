Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4428A3C7713
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 21:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbhGMTif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 15:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbhGMTid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 15:38:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69FCC0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 12:35:42 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3OBj-0001GZ-Ci; Tue, 13 Jul 2021 21:35:27 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3OBi-0006pF-Fy; Tue, 13 Jul 2021 21:35:26 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3OBi-0002eW-El; Tue, 13 Jul 2021 21:35:26 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kernel@pengutronix.de,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 2/5] s390/cio: Make struct css_driver::remove return void
Date:   Tue, 13 Jul 2021 21:35:19 +0200
Message-Id: <20210713193522.1770306-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713193522.1770306-1-u.kleine-koenig@pengutronix.de>
References: <20210713193522.1770306-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=Zzh6Qah9igZDzbjfUk8AwTB4DBF9iwmgRJQWuOwvwcc=; m=NJ6Mrq9SGd+6Raj4Ph3u7WcDxqXD2X9JpTrAqQ6iaJc=; p=dIvXn065WcUeFDWu88dn/CVmtGJ9aRxWBgN4OMyj3Gw=; g=8a2a8dab3e3a8f389794804b23c10178add091b4
X-Patch-Sig: m=pgp; i=uwe@kleine-koenig.org; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDt6s8ACgkQwfwUeK3K7An0oQf/ZfQ yUrakmvnfOkbsvRRby9OZL7kbJcoJTsfhK10XmeK7vNr7SUTe18xxsXM4Fn/Z3+LqpxYxuh4/P1gR a47ZZzpM8y/hHd0LJLg46yP7ZtyDOjp4IeMlEPEGKqUida/daspuZkLQ8vID2WPDqkgmTbw4vtk4j gocCvi0gfIN6YO62ve62UwQkZxj/RQDcwYhEfyHuvQpYTpjlAyDXNjPypKedCJLL8JgNkjRDR0buO oWxiZhBY6gckFfRCiVKCk1zFmXo4LZg7MBgiFXfbAm/DD8tTR2WGjk2MdeamWNII0QnAqaDAUrV01 pN8ZUieP8dzwg/XWSxb98WxKkk0ta1A==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvm@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The driver core ignores the return value of css_remove()
(because there is only little it can do when a device disappears) and
all callbacks return 0 anyhow.

So make it impossible for future drivers to return an unused error code
by changing the remove prototype to return void.

The real motivation for this change is the quest to make struct
bus_type::remove return void, too.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/s390/cio/chsc_sch.c     | 3 +--
 drivers/s390/cio/css.c          | 7 ++++---
 drivers/s390/cio/css.h          | 2 +-
 drivers/s390/cio/device.c       | 5 ++---
 drivers/s390/cio/eadm_sch.c     | 4 +---
 drivers/s390/cio/vfio_ccw_drv.c | 3 +--
 6 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index c42405c620b5..684348d82f08 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -100,7 +100,7 @@ static int chsc_subchannel_probe(struct subchannel *sch)
 	return ret;
 }
 
-static int chsc_subchannel_remove(struct subchannel *sch)
+static void chsc_subchannel_remove(struct subchannel *sch)
 {
 	struct chsc_private *private;
 
@@ -112,7 +112,6 @@ static int chsc_subchannel_remove(struct subchannel *sch)
 		put_device(&sch->dev);
 	}
 	kfree(private);
-	return 0;
 }
 
 static void chsc_subchannel_shutdown(struct subchannel *sch)
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index a974943c27da..092fd1ea5799 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1374,12 +1374,13 @@ static int css_probe(struct device *dev)
 static int css_remove(struct device *dev)
 {
 	struct subchannel *sch;
-	int ret;
 
 	sch = to_subchannel(dev);
-	ret = sch->driver->remove ? sch->driver->remove(sch) : 0;
+	if (sch->driver->remove)
+		sch->driver->remove(sch);
 	sch->driver = NULL;
-	return ret;
+
+	return 0;
 }
 
 static void css_shutdown(struct device *dev)
diff --git a/drivers/s390/cio/css.h b/drivers/s390/cio/css.h
index 2eddfc47f687..c98522cbe276 100644
--- a/drivers/s390/cio/css.h
+++ b/drivers/s390/cio/css.h
@@ -81,7 +81,7 @@ struct css_driver {
 	int (*chp_event)(struct subchannel *, struct chp_link *, int);
 	int (*sch_event)(struct subchannel *, int);
 	int (*probe)(struct subchannel *);
-	int (*remove)(struct subchannel *);
+	void (*remove)(struct subchannel *);
 	void (*shutdown)(struct subchannel *);
 	int (*settle)(void);
 };
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 84f659cafe76..cd5d2d4d8e46 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -137,7 +137,7 @@ static int ccw_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static void io_subchannel_irq(struct subchannel *);
 static int io_subchannel_probe(struct subchannel *);
-static int io_subchannel_remove(struct subchannel *);
+static void io_subchannel_remove(struct subchannel *);
 static void io_subchannel_shutdown(struct subchannel *);
 static int io_subchannel_sch_event(struct subchannel *, int);
 static int io_subchannel_chp_event(struct subchannel *, struct chp_link *,
@@ -1101,7 +1101,7 @@ static int io_subchannel_probe(struct subchannel *sch)
 	return 0;
 }
 
-static int io_subchannel_remove(struct subchannel *sch)
+static void io_subchannel_remove(struct subchannel *sch)
 {
 	struct io_subchannel_private *io_priv = to_io_private(sch);
 	struct ccw_device *cdev;
@@ -1120,7 +1120,6 @@ static int io_subchannel_remove(struct subchannel *sch)
 			  io_priv->dma_area, io_priv->dma_area_dma);
 	kfree(io_priv);
 	sysfs_remove_group(&sch->dev.kobj, &io_subchannel_attr_group);
-	return 0;
 }
 
 static void io_subchannel_verify(struct subchannel *sch)
diff --git a/drivers/s390/cio/eadm_sch.c b/drivers/s390/cio/eadm_sch.c
index c8964e0a23e7..15bdae5981ca 100644
--- a/drivers/s390/cio/eadm_sch.c
+++ b/drivers/s390/cio/eadm_sch.c
@@ -282,7 +282,7 @@ static void eadm_quiesce(struct subchannel *sch)
 	spin_unlock_irq(sch->lock);
 }
 
-static int eadm_subchannel_remove(struct subchannel *sch)
+static void eadm_subchannel_remove(struct subchannel *sch)
 {
 	struct eadm_private *private = get_eadm_private(sch);
 
@@ -297,8 +297,6 @@ static int eadm_subchannel_remove(struct subchannel *sch)
 	spin_unlock_irq(sch->lock);
 
 	kfree(private);
-
-	return 0;
 }
 
 static void eadm_subchannel_shutdown(struct subchannel *sch)
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 9b61e9b131ad..76099bcb765b 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -234,7 +234,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	return ret;
 }
 
-static int vfio_ccw_sch_remove(struct subchannel *sch)
+static void vfio_ccw_sch_remove(struct subchannel *sch)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 	struct vfio_ccw_crw *crw, *temp;
@@ -257,7 +257,6 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
 	VFIO_CCW_MSG_EVENT(4, "unbound from subchannel %x.%x.%04x\n",
 			   sch->schid.cssid, sch->schid.ssid,
 			   sch->schid.sch_no);
-	return 0;
 }
 
 static void vfio_ccw_sch_shutdown(struct subchannel *sch)
-- 
2.30.2


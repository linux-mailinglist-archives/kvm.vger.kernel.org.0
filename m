Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C9F604D1D
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiJSQWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiJSQVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:21:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21063196EDB;
        Wed, 19 Oct 2022 09:21:53 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JFwOdk003117;
        Wed, 19 Oct 2022 16:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZXD2NF3bhb9xa6K8S7PWWXyNpAdQgQN41ZXfCUSfxLA=;
 b=cfLCYZtMWYOFsJm21oqZTrl4tXt/srGxeUu4imP6iDpd8wsELKLL2021z6QgNXNwCjW9
 4ItIxPjualisAo92EnitLuNvK5ZgnH5oDADp2oshbt1TWLLzZZFmbpP8EPdzXgsvJL8i
 iHKJvN6+93OBVj6SBu3IMOcRh+wrED+ElZgOZUMwOpLMxgX2IDwhN0W25NK+c0kBPZ1w
 RdE6OBdP/WNGL5S64L4UhoRpi2uLisLt9zzu+EhwrkfrOpSFcqjuk8cVLrL2YHHbDXNM
 F6R+tksyoJfLoYTeZ4PPwuEpWmgpntDvkC9k593eUhcN4V9skrdqYelbkn4bq03PoTUV hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kambb1b05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:21:45 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JG0dGN008834;
        Wed, 19 Oct 2022 16:21:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kambb1ax3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:21:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JGLTBh015554;
        Wed, 19 Oct 2022 16:21:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg97cx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:21:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JGMBQo52363548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 16:22:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77BB3A404D;
        Wed, 19 Oct 2022 16:21:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5899FA4040;
        Wed, 19 Oct 2022 16:21:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Oct 2022 16:21:38 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id DA8C2E1693; Wed, 19 Oct 2022 18:21:37 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 6/7] vfio/ccw: replace vfio_init_device with _alloc_
Date:   Wed, 19 Oct 2022 18:21:34 +0200
Message-Id: <20221019162135.798901-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221019162135.798901-1-farman@linux.ibm.com>
References: <20221019162135.798901-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AtH2RdMo3ch1mwnGrA92KYP9LojR7_EX
X-Proofpoint-ORIG-GUID: dWtngy90OA-mfsIT0f1Ujgtf3a4TtoZN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have a reasonable separation of structs that follow
the subchannel and mdev lifecycles, there's no reason we can't
call the official vfio_alloc_device routine for our private data,
and behave like everyone else.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 29 -----------------------------
 drivers/s390/cio/vfio_ccw_ops.c     | 28 ++++++++++++++++++----------
 drivers/s390/cio/vfio_ccw_private.h |  3 ---
 drivers/vfio/vfio_main.c            |  3 ---
 4 files changed, 18 insertions(+), 45 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 686a9b9f6731..9bbf41315aca 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -146,35 +146,6 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
 }
 
-struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
-{
-	struct vfio_ccw_private *private;
-
-	private = kzalloc(sizeof(*private), GFP_KERNEL);
-	if (!private)
-		return ERR_PTR(-ENOMEM);
-
-	return private;
-}
-
-void vfio_ccw_free_private(struct vfio_ccw_private *private)
-{
-	struct vfio_ccw_crw *crw, *temp;
-
-	list_for_each_entry_safe(crw, temp, &private->crw, next) {
-		list_del(&crw->next);
-		kfree(crw);
-	}
-
-	kmem_cache_free(vfio_ccw_crw_region, private->crw_region);
-	kmem_cache_free(vfio_ccw_schib_region, private->schib_region);
-	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
-	kmem_cache_free(vfio_ccw_io_region, private->io_region);
-	kfree(private->cp.guest_cp);
-	mutex_destroy(&private->io_mutex);
-	kfree(private);
-}
-
 static void vfio_ccw_free_parent(struct device *dev)
 {
 	struct vfio_ccw_parent *parent = container_of(dev, struct vfio_ccw_parent, dev);
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 261cb8150abb..9619dc35080f 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -103,15 +103,10 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	struct vfio_ccw_private *private;
 	int ret;
 
-	private = vfio_ccw_alloc_private(sch);
-	if (!private)
-		return -ENOMEM;
-
-	ret = vfio_init_device(&private->vdev, &mdev->dev, &vfio_ccw_dev_ops);
-	if (ret) {
-		kfree(private);
-		return ret;
-	}
+	private = vfio_alloc_device(vfio_ccw_private, vdev, &mdev->dev,
+				    &vfio_ccw_dev_ops);
+	if (IS_ERR(private))
+		return PTR_ERR(private);
 
 	dev_set_drvdata(&parent->dev, private);
 
@@ -136,8 +131,21 @@ static void vfio_ccw_mdev_release_dev(struct vfio_device *vdev)
 {
 	struct vfio_ccw_private *private =
 		container_of(vdev, struct vfio_ccw_private, vdev);
+	struct vfio_ccw_crw *crw, *temp;
+
+	list_for_each_entry_safe(crw, temp, &private->crw, next) {
+		list_del(&crw->next);
+		kfree(crw);
+	}
+
+	kmem_cache_free(vfio_ccw_crw_region, private->crw_region);
+	kmem_cache_free(vfio_ccw_schib_region, private->schib_region);
+	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
+	kmem_cache_free(vfio_ccw_io_region, private->io_region);
+	kfree(private->cp.guest_cp);
+	mutex_destroy(&private->io_mutex);
 
-	vfio_ccw_free_private(private);
+	vfio_free_device(vdev);
 }
 
 static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index ddaf6846022d..2ca408881659 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -116,9 +116,6 @@ int vfio_ccw_sch_quiesce(struct subchannel *sch);
 void vfio_ccw_sch_io_todo(struct work_struct *work);
 void vfio_ccw_crw_todo(struct work_struct *work);
 
-struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch);
-void vfio_ccw_free_private(struct vfio_ccw_private *private);
-
 extern struct mdev_driver vfio_ccw_mdev_driver;
 
 /*
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2d168793d4e1..28f36c6d9d3f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -386,8 +386,6 @@ EXPORT_SYMBOL_GPL(_vfio_alloc_device);
 
 /*
  * Initialize a vfio_device so it can be registered to vfio core.
- *
- * Only vfio-ccw driver should call this interface.
  */
 int vfio_init_device(struct vfio_device *device, struct device *dev,
 		     const struct vfio_device_ops *ops)
@@ -422,7 +420,6 @@ int vfio_init_device(struct vfio_device *device, struct device *dev,
 	ida_free(&vfio.device_ida, device->index);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(vfio_init_device);
 
 /*
  * The helper called by driver @release callback to free the device
-- 
2.34.1


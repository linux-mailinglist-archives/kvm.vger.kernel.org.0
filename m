Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7800953BD3C
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 19:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiFBRUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 13:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbiFBRUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 13:20:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D300C20E6C9;
        Thu,  2 Jun 2022 10:19:59 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252GYkN3010326;
        Thu, 2 Jun 2022 17:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MI2glkYqBjj/TAB9V+QWN3VNSRr1SUNWN6ovpKATt+A=;
 b=nJ8P/au8SX+c67TegbRWPl63+PtwxWJmoAQL8gEIsms/76KFuZ5SSbfKbpRnBmaWmBJ3
 Eg02V47qCv4BEda4NlBWPQgyfD8YdR/lZy77rNCQPz/MmNWm8vkLFPo+/xXsqahwe4DO
 9a+45iqOWC+2lZCeWZL/uriHaDyQo3a9IN864Xs28ibf8MO3WABy8oJUu1q+yN4Hwq1M
 9EgNLsd7MNY0KbpEq2+76OUf+idVoirtGVMdL2RtZwgRGn7eaab/exQKollTEWrnP5wv
 dNbtlCvN6rW2zNvBPnPUlqIYpE7ylVR0eHCfSF12O2GsgXDJShCw9L4P4lCepqWXw8pd HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geub97tmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:57 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252HFBWx008895;
        Thu, 2 Jun 2022 17:19:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geub97tm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252H5xkF020918;
        Thu, 2 Jun 2022 17:19:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3gbcae7bcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252HJpgq47645122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 17:19:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10A1DA4062;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E998AA4054;
        Thu,  2 Jun 2022 17:19:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jun 2022 17:19:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id AC04AE078F; Thu,  2 Jun 2022 19:19:50 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Michael Kawano <mkawano@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 01/18] vfio/ccw: Remove UUID from s390 debug log
Date:   Thu,  2 Jun 2022 19:19:31 +0200
Message-Id: <20220602171948.2790690-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o3kacSxcl1W6SfGxTbZSxD2EhfmSTpov
X-Proofpoint-ORIG-GUID: VR_bil0JiIQNjyVsfsNb9X7PKSvge6rq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Kawano <mkawano@linux.ibm.com>

As vfio-ccw devices are created/destroyed, the uuid of the associated
mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost as
they are created using pointers passed by reference.

This is a deliberate design point of s390dbf, but it leaves the uuid
in these traces less than useful. Since the subchannels are more
constant, and are mapped 1:1 with the mdevs, the associated mdev can
be discerned by looking at the device configuration (e.g., mdevctl)
and places, such as kernel messages, where it is statically stored.

Thus, let's just remove the uuid from s390dbf traces. As we were
the only consumer of mdev_uuid(), remove that too.

Cc: Kirti Wankhede <kwankhede@nvidia.com>
Signed-off-by: Michael Kawano <mkawano@linux.ibm.com>
Fixes: 60e05d1cf0875 ("vfio-ccw: add some logging")
Fixes: b7701dfbf9832 ("vfio-ccw: Register a chp_event callback for vfio-ccw")
[farman: reworded commit message, added Fixes: tags]
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c |  5 ++---
 drivers/s390/cio/vfio_ccw_fsm.c | 24 ++++++++++++------------
 drivers/s390/cio/vfio_ccw_ops.c |  8 ++++----
 include/linux/mdev.h            |  4 ----
 4 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index ee182cfb467d..35055eb94115 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/uuid.h>
 #include <linux/mdev.h>
 
 #include <asm/isc.h>
@@ -358,8 +357,8 @@ static int vfio_ccw_chp_event(struct subchannel *sch,
 		return 0;
 
 	trace_vfio_ccw_chp_event(private->sch->schid, mask, event);
-	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
-			   mdev_uuid(private->mdev), sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: mask=0x%x event=%d\n",
+			   sch->schid.cssid,
 			   sch->schid.ssid, sch->schid.sch_no,
 			   mask, event);
 
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index e435a9cd92da..86b23732d899 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -256,8 +256,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		if (orb->tm.b) {
 			io_region->ret_code = -EOPNOTSUPP;
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): transport mode\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: transport mode\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no);
 			errstr = "transport mode";
 			goto err_out;
@@ -266,8 +266,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 					      orb);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): cp_init=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: cp_init=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp init";
@@ -277,8 +277,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		io_region->ret_code = cp_prefetch(&private->cp);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): cp_prefetch=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: cp_prefetch=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp prefetch";
@@ -290,8 +290,8 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		io_region->ret_code = fsm_io_helper(private);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
-					   "%pUl (%x.%x.%04x): fsm_io_helper=%d\n",
-					   mdev_uuid(mdev), schid.cssid,
+					   "sch %x.%x.%04x: fsm_io_helper=%d\n",
+					   schid.cssid,
 					   schid.ssid, schid.sch_no,
 					   io_region->ret_code);
 			errstr = "cp fsm_io_helper";
@@ -301,16 +301,16 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 		return;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_HALT_FUNC) {
 		VFIO_CCW_MSG_EVENT(2,
-				   "%pUl (%x.%x.%04x): halt on io_region\n",
-				   mdev_uuid(mdev), schid.cssid,
+				   "sch %x.%x.%04x: halt on io_region\n",
+				   schid.cssid,
 				   schid.ssid, schid.sch_no);
 		/* halt is handled via the async cmd region */
 		io_region->ret_code = -EOPNOTSUPP;
 		goto err_out;
 	} else if (scsw->cmd.fctl & SCSW_FCTL_CLEAR_FUNC) {
 		VFIO_CCW_MSG_EVENT(2,
-				   "%pUl (%x.%x.%04x): clear on io_region\n",
-				   mdev_uuid(mdev), schid.cssid,
+				   "sch %x.%x.%04x: clear on io_region\n",
+				   schid.cssid,
 				   schid.ssid, schid.sch_no);
 		/* clear is handled via the async cmd region */
 		io_region->ret_code = -EOPNOTSUPP;
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index d8589afac272..bebae21228aa 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -131,8 +131,8 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	private->mdev = mdev;
 	private->state = VFIO_CCW_STATE_IDLE;
 
-	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: create\n",
-			   mdev_uuid(mdev), private->sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
+			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
@@ -154,8 +154,8 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
 
-	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
-			   mdev_uuid(mdev), private->sch->schid.cssid,
+	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: remove\n",
+			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 15d03f6532d0..a5788f592817 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -139,10 +139,6 @@ static inline void mdev_set_drvdata(struct mdev_device *mdev, void *data)
 {
 	mdev->driver_data = data;
 }
-static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
-{
-	return &mdev->uuid;
-}
 
 extern struct bus_type mdev_bus_type;
 
-- 
2.32.0


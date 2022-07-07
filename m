Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A7156A4BD
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbiGGN7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236393AbiGGN5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:57:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3175020180;
        Thu,  7 Jul 2022 06:57:48 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267DaDRS029975;
        Thu, 7 Jul 2022 13:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+KyUAcPZUsFKW9KmyQMBMoHWEy6abffJs2e1N8QL0PM=;
 b=DqnaVVPE33IyUYnpyA8GBmc3VmT7iFkPaHw4j4zYsE16ZvMRXwhSF2pve89xpdxIEzMr
 es3Scx8ngxbiHFGvRqxd9W7tj5484VZGwt0g9Sj/Twk3HsQA0E1GLo/dzCp8kEUczBLI
 AmiTmrtnL2OovEpddXxsS/1WTcAgqOy09CRxdPLMlY9x9egM2L+1WN9QBVWq/nfW/FLH
 yonqXoAtOu+v2w97RX42x0BeU4/B6XwgvYhqzIOamkoWC5vNwQKlfCKXO9T+oZBQiVbP
 fIT7WQT/TotEo1cGCBLaind6drl8esYAvZ/W4cHYQ2Vg5JSu+nVtocNBmfJXVGw6pJke tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h605j1cuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:45 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267DeMpi022867;
        Thu, 7 Jul 2022 13:57:45 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h605j1cu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:45 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267Du4dL008616;
        Thu, 7 Jul 2022 13:57:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujsjnv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267DvdNH8782080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 13:57:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF95C4C040;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E31E4C04A;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 2F7CAE02E8; Thu,  7 Jul 2022 15:57:39 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 11/11] vfio/ccw: Move FSM open/close to MDEV open/close
Date:   Thu,  7 Jul 2022 15:57:37 +0200
Message-Id: <20220707135737.720765-12-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707135737.720765-1-farman@linux.ibm.com>
References: <20220707135737.720765-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 82az0KfhNiqmcTV1wuucH0x-EiK8Jcq0
X-Proofpoint-GUID: gpyF5igWtFmRe8MoA5lER11-r-ivp5kr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Part of the confusion that has existed is the FSM lifecycle of
subchannels between the common CSS driver and the vfio-ccw driver.
During configuration, the FSM state goes from NOT_OPER to STANDBY
to IDLE, but then back to NOT_OPER. For example:

	vfio_ccw_sch_probe:		VFIO_CCW_STATE_NOT_OPER
	vfio_ccw_sch_probe:		VFIO_CCW_STATE_STANDBY
	vfio_ccw_mdev_probe:		VFIO_CCW_STATE_IDLE
	vfio_ccw_mdev_remove:		VFIO_CCW_STATE_NOT_OPER
	vfio_ccw_sch_remove:		VFIO_CCW_STATE_NOT_OPER
	vfio_ccw_sch_shutdown:		VFIO_CCW_STATE_NOT_OPER

Rearrange the open/close events to align with the mdev open/close,
to better manage the memory and state of the devices as time
progresses. Specifically, make mdev_open() perform the FSM open,
and mdev_close() perform the FSM close instead of reset (which is
both close and open).

This makes the NOT_OPER state a dead-end path, indicating the
device is probably not recoverable without fully probing and
re-configuring the device.

This has the nice side-effect of removing a number of special-cases
where the FSM state is managed outside of the FSM itself (such as
the aforementioned mdev_close() routine).

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 11 +++--------
 drivers/s390/cio/vfio_ccw_fsm.c | 34 ++++++++++++++++++++++++---------
 drivers/s390/cio/vfio_ccw_ops.c | 26 +++++++++++--------------
 3 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index f98c9915e73d..4804101ccb0f 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -138,7 +138,7 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
 
 	private->sch = sch;
 	mutex_init(&private->io_mutex);
-	private->state = VFIO_CCW_STATE_NOT_OPER;
+	private->state = VFIO_CCW_STATE_STANDBY;
 	INIT_LIST_HEAD(&private->crw);
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
@@ -222,21 +222,15 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 
 	dev_set_drvdata(&sch->dev, private);
 
-	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
-	if (private->state == VFIO_CCW_STATE_NOT_OPER)
-		goto out_free;
-
 	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
 	if (ret)
-		goto out_disable;
+		goto out_free;
 
 	VFIO_CCW_MSG_EVENT(4, "bound to subchannel %x.%x.%04x\n",
 			   sch->schid.cssid, sch->schid.ssid,
 			   sch->schid.sch_no);
 	return 0;
 
-out_disable:
-	cio_disable_subchannel(sch);
 out_free:
 	dev_set_drvdata(&sch->dev, NULL);
 	vfio_ccw_free_private(private);
@@ -264,6 +258,7 @@ static void vfio_ccw_sch_shutdown(struct subchannel *sch)
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
 }
 
 /**
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 89eb3feffa41..4b8b623df24f 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -175,6 +175,9 @@ static void fsm_notoper(struct vfio_ccw_private *private,
 	 */
 	css_sched_sch_todo(sch, SCH_TODO_UNREG);
 	private->state = VFIO_CCW_STATE_NOT_OPER;
+
+	/* This is usually handled during CLOSE event */
+	cp_free(&private->cp);
 }
 
 /*
@@ -379,9 +382,16 @@ static void fsm_open(struct vfio_ccw_private *private,
 	spin_lock_irq(sch->lock);
 	sch->isc = VFIO_CCW_ISC;
 	ret = cio_enable_subchannel(sch, (u32)(unsigned long)sch);
-	if (!ret)
-		private->state = VFIO_CCW_STATE_STANDBY;
+	if (ret)
+		goto err_unlock;
+
+	private->state = VFIO_CCW_STATE_IDLE;
 	spin_unlock_irq(sch->lock);
+	return;
+
+err_unlock:
+	spin_unlock_irq(sch->lock);
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
 }
 
 static void fsm_close(struct vfio_ccw_private *private,
@@ -393,16 +403,22 @@ static void fsm_close(struct vfio_ccw_private *private,
 	spin_lock_irq(sch->lock);
 
 	if (!sch->schib.pmcw.ena)
-		goto out_unlock;
+		goto err_unlock;
 
 	ret = cio_disable_subchannel(sch);
 	if (ret == -EBUSY)
 		vfio_ccw_sch_quiesce(sch);
+	if (ret)
+		goto err_unlock;
 
-out_unlock:
-	private->state = VFIO_CCW_STATE_NOT_OPER;
+	private->state = VFIO_CCW_STATE_STANDBY;
 	spin_unlock_irq(sch->lock);
 	cp_free(&private->cp);
+	return;
+
+err_unlock:
+	spin_unlock_irq(sch->lock);
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_NOT_OPER);
 }
 
 /*
@@ -414,16 +430,16 @@ fsm_func_t *vfio_ccw_jumptable[NR_VFIO_CCW_STATES][NR_VFIO_CCW_EVENTS] = {
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
 		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
-		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_nop,
 		[VFIO_CCW_EVENT_CLOSE]		= fsm_nop,
 	},
 	[VFIO_CCW_STATE_STANDBY] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
 		[VFIO_CCW_EVENT_IO_REQ]		= fsm_io_error,
 		[VFIO_CCW_EVENT_ASYNC_REQ]	= fsm_async_error,
-		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_irq,
-		[VFIO_CCW_EVENT_OPEN]		= fsm_notoper,
-		[VFIO_CCW_EVENT_CLOSE]		= fsm_close,
+		[VFIO_CCW_EVENT_INTERRUPT]	= fsm_disabled_irq,
+		[VFIO_CCW_EVENT_OPEN]		= fsm_open,
+		[VFIO_CCW_EVENT_CLOSE]		= fsm_notoper,
 	},
 	[VFIO_CCW_STATE_IDLE] = {
 		[VFIO_CCW_EVENT_NOT_OPER]	= fsm_notoper,
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 4673b7ddfe20..bc2176421dc5 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -24,17 +24,12 @@ static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
 	/*
 	 * If the FSM state is seen as Not Operational after closing
 	 * and re-opening the mdev, return an error.
-	 *
-	 * Otherwise, change the FSM from STANDBY to IDLE which is
-	 * normally done by vfio_ccw_mdev_probe() in current lifecycle.
 	 */
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
 	if (private->state == VFIO_CCW_STATE_NOT_OPER)
 		return -EINVAL;
 
-	private->state = VFIO_CCW_STATE_IDLE;
-
 	return 0;
 }
 
@@ -121,8 +116,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	vfio_init_group_dev(&private->vdev, &mdev->dev,
 			    &vfio_ccw_dev_ops);
 
-	private->state = VFIO_CCW_STATE_IDLE;
-
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
 			   private->sch->schid.cssid,
 			   private->sch->schid.ssid,
@@ -137,7 +130,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 err_atomic:
 	vfio_uninit_group_dev(&private->vdev);
 	atomic_inc(&private->avail);
-	private->state = VFIO_CCW_STATE_STANDBY;
 	return ret;
 }
 
@@ -165,6 +157,10 @@ static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
 	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
 	int ret;
 
+	/* Device cannot simply be opened again from this state */
+	if (private->state == VFIO_CCW_STATE_NOT_OPER)
+		return -EINVAL;
+
 	private->nb.notifier_call = vfio_ccw_mdev_notifier;
 
 	ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY,
@@ -184,6 +180,12 @@ static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
 	if (ret)
 		goto out_unregister;
 
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_OPEN);
+	if (private->state == VFIO_CCW_STATE_NOT_OPER) {
+		ret = -EINVAL;
+		goto out_unregister;
+	}
+
 	return ret;
 
 out_unregister:
@@ -197,13 +199,7 @@ static void vfio_ccw_mdev_close_device(struct vfio_device *vdev)
 	struct vfio_ccw_private *private =
 		container_of(vdev, struct vfio_ccw_private, vdev);
 
-	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
-	    (private->state != VFIO_CCW_STATE_STANDBY)) {
-		if (!vfio_ccw_mdev_reset(private))
-			private->state = VFIO_CCW_STATE_STANDBY;
-		/* The state will be NOT_OPER on error. */
-	}
-
+	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
 	vfio_ccw_unregister_dev_regions(private);
 	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY, &private->nb);
 }
-- 
2.34.1


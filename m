Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BF124E182
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHUT54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 15:57:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbgHUT4z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 15:56:55 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LJVjWW093266;
        Fri, 21 Aug 2020 15:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sXk2PXkPC1GfrnqnUAtOL+4rS0fUxLSGoIxQuRimknU=;
 b=Fs84d+aUXGaEnMcxD5qrabSl73CTTyxUo+Axr7lOuyIzrhQI8MlQ0ovNOSVHr5WdIMvY
 3ieE5+s7JJj/5sWb8CCIxpttUBiVfT6fs7HkdAJfr4+aRWTVlNt4SxXtJX8RaOihFNwv
 9MFXHNj3e5U92wfzuliP3iu98g4UDdRC7ayxSJI++iPkoLOROpPlXsm7cK0170QSxjsj
 2dgZZ6jnnvSOQuMNrtVyD/5P0Ov1GjlFlNyn9brY/op7mDR5ZKXawHVmwQsVKjCU5zDo
 RoqW8HBHTDYw0rOTRj6DwdfK+WShbk43/U8RFf68kLkVIQbB+9ikQmeK1hOxMCoWdcRc tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332kse9gjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 15:56:53 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07LJZSP0114205;
        Fri, 21 Aug 2020 15:56:53 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 332kse9gj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 15:56:53 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07LJsPj5005410;
        Fri, 21 Aug 2020 19:56:52 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 3304ceps01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Aug 2020 19:56:52 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07LJunlF58458448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Aug 2020 19:56:49 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42B9C7805E;
        Fri, 21 Aug 2020 19:56:49 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0C897805F;
        Fri, 21 Aug 2020 19:56:47 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.191.76])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 21 Aug 2020 19:56:47 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v10 15/16] s390/vfio-ap: handle probe/remove not due to host AP config changes
Date:   Fri, 21 Aug 2020 15:56:15 -0400
Message-Id: <20200821195616.13554-16-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200821195616.13554-1-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_09:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=3 adultscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AP queue devices are probed or removed for reasons other than changes
to the host AP configuration. For example:

* The state of an AP adapter can be dynamically changed from standby to
  online via the SE or by execution of the SCLP Configure AP command. When
  the state changes, each queue device associated with the card device
  representing the adapter will get created and probed.

* The state of an AP adapter can be dynamically changed from online to
  standby via the SE or by execution of the SCLP Deconfigure AP command.
  When the state changes, each queue device associated with the card device
  representing the adapter will get removed.

* Each queue device associated with a card device will get removed
  when the type of the AP adapter represented by the card device
  dynamically changes.

* Each queue device associated with a card device will get removed
  when the status of the queue represented by the queue device changes
  from operating to check stop.

* AP queue devices can be manually bound to or unbound from the vfio_ap
  device driver by a root user via the sysfs bind/unbind attributes of the
  driver.

In response to a queue device probe or remove that is not the result of a
change to the host's AP configuration, if a KVM guest is using the matrix
mdev to which the APQN of the queue device is assigned, the vfio_ap device
driver must respond accordingly. In an ideal world, the queue device being
probed would be hot plugged into the guest. Likewise, the queue
corresponding to the queue device being removed would
be hot unplugged from the guest. Unfortunately, the AP architecture
precludes plugging or unplugging individual queues, so let's handle
the probe or remove of an AP queue device as follows:

Handling Probe
--------------
There are two requirements that must be met in order to give a
guest access to the queue corresponding to the queue device being probed:

* Each APQN derived from the APID of the queue device and the APQIs of the
  domains already assigned to the guest's AP configuration must reference
  a queue device bound to the vfio_ap device driver.

* Each APQN derived from the APQI of the queue device and the APIDs of the
  adapters assigned to the guest's AP configuration must reference a queue
  device bound to the vfio_ap device driver.

If the above conditions are met, the APQN will be assigned to the guest's
AP configuration and the guest will be given access to the queue.

Handling Remove
---------------
Since the AP architecture precludes us from taking access to an individual
queue from a guest, we are left with the choice of taking access away from
either the adapter or the domain to which the queue is connected. Access to
the adapter will be taken away because it is likely that most of the time,
the remove callback will be invoked because the adapter state has
transitioned from online to standby. In such a case, no queue connected
to the adapter will be available to access.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 84 +++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e6480f31a42b..b6a1e280991d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1682,6 +1682,61 @@ static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
 	}
 }
 
+static bool vfio_ap_mdev_assign_shadow_apid(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apid)
+{
+	unsigned long apqi;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
+			     matrix_mdev->shadow_apcb.aqm_max + 1) {
+		if (!vfio_ap_get_queue(AP_MKQID(apid, apqi)))
+			return false;
+	}
+
+	set_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
+
+	return true;
+}
+
+static bool vfio_ap_mdev_assign_shadow_apqi(struct ap_matrix_mdev *matrix_mdev,
+					    unsigned long apqi)
+{
+	unsigned long apid;
+
+	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
+			     matrix_mdev->shadow_apcb.apm_max + 1) {
+		if (!vfio_ap_get_queue(AP_MKQID(apid, apqi)))
+			return false;
+	}
+
+	set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm);
+
+	return true;
+}
+
+static void vfio_ap_mdev_hot_plug_queue(struct vfio_ap_queue *q)
+{
+	bool commit = false;
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+
+	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
+		return;
+
+	if (!test_bit_inv(apid, q->matrix_mdev->matrix.apm) ||
+	    !test_bit_inv(apqi, q->matrix_mdev->matrix.aqm))
+		return;
+
+	if (!test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm))
+		commit |= vfio_ap_mdev_assign_shadow_apid(q->matrix_mdev, apid);
+
+	if (!test_bit_inv(apqi, q->matrix_mdev->shadow_apcb.aqm))
+		commit |= vfio_ap_mdev_assign_shadow_apqi(q->matrix_mdev, apqi);
+
+	if (commit)
+		vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
+}
+
 int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1695,11 +1750,35 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 	q->apqn = queue->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
+	/* Make sure we're not in the middle of an AP configuration change. */
+	if (!(matrix_dev->flags & AP_MATRIX_CFG_CHG))
+		vfio_ap_mdev_hot_plug_queue(q);
 	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
 
+void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
+{
+	unsigned long apid = AP_QID_CARD(q->apqn);
+	unsigned long apqi = AP_QID_QUEUE(q->apqn);
+
+	if ((q->matrix_mdev == NULL) || !vfio_ap_mdev_has_crycb(q->matrix_mdev))
+		return;
+
+	/*
+	 * If the APQN is assigned to the guest, then let's
+	 * go ahead and unplug the adapter since the
+	 * architecture does not provide a means to unplug
+	 * an individual queue.
+	 */
+	if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm) &&
+	    test_bit_inv(apqi, q->matrix_mdev->shadow_apcb.aqm)) {
+		if (vfio_ap_mdev_unassign_guest_apid(q->matrix_mdev, apid))
+			vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
+	}
+}
+
 void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 {
 	struct vfio_ap_queue *q;
@@ -1707,6 +1786,11 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&queue->ap_dev.device);
+
+	/* Make sure we're not in the middle of an AP configuration change. */
+	if (!(matrix_dev->flags & AP_MATRIX_CFG_CHG))
+		vfio_ap_mdev_hot_unplug_queue(q);
+
 	dev_set_drvdata(&queue->ap_dev.device, NULL);
 	apid = AP_QID_CARD(q->apqn);
 	apqi = AP_QID_QUEUE(q->apqn);
-- 
2.21.1


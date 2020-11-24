Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41C32C3340
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbgKXVk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12876 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387454AbgKXVkq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:46 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLWKxG084508;
        Tue, 24 Nov 2020 16:40:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h3tB9DLGWHzop1yvGxPfELczgXIHJYVV4ngzK3bD1G4=;
 b=D/pPOhph4osBwuwwzzh5/FJvF67OqpP1SZhbf8+uGdOEqjxja7lb3mrv63gfnTMNlpB6
 OWOMzudzvGNL+qv/HqVyXvApzcJLH5xflpi57y0VmF1gxfnZwFPBqph649aJ+jE/Gfqe
 1A9f8YlQt+fN8jcf2zH2u1pJYCsNxS9H714ESRmf2GAqLTjHBsV4aUcG5VEhek8W3ef/
 EUZhgtQFhkEbihPS79sg+sxknOF4xwf+gkjvz6rcttvilIGD9gRvnUQ3stO5wrxw6gJx
 pupezRlWIJor5Uluxbv5qgmap3VtrEtLwikKt7nRGuo7AHRETH9G+HkFBovZA2CpYD4L JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rb1kfuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:45 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLY8xZ093326;
        Tue, 24 Nov 2020 16:40:45 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rb1kfua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:45 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLbXEg016193;
        Tue, 24 Nov 2020 21:40:43 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 34xth92k0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:43 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLeg175178084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:42 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47AF5AE066;
        Tue, 24 Nov 2020 21:40:42 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04063AE05C;
        Tue, 24 Nov 2020 21:40:41 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:40 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Tony Krowiak <akrowiak@stny.rr.com>
Subject: [PATCH v12 13/17] s390/vfio-ap: hot plug/unplug queues on bind/unbind of queue device
Date:   Tue, 24 Nov 2020 16:40:12 -0500
Message-Id: <20201124214016.3013-14-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_08:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=3 bulkscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In response to the probe or remove of a queue device, if a KVM guest is
using the matrix mdev to which the APQN of the queue device is assigned,
the vfio_ap device driver must respond accordingly. In an ideal world, the
queue corresponding to the queue device being probed would be hot plugged
into the guest. Likewise, the queue corresponding to the queue device being
removed would be hot unplugged. Unfortunately, the AP architecture
precludes plugging or unplugging individual queues. The queues to which a
guest is granted access are specified as a matrix of adapter and domain
numbers. The Cartesian product of the adapter and domain numbers assigned
to this matrix comprise the AP queue numbers (APQN) to which the guest will
be granted access; therefore, it becomes obvious that assigning a new
adapter or domain number to the matrix may result in multiple APQNs
getting assigned. Likewise, unassigning an adapter or domain number from
the matrix may result in multiple APQNs getting unassigned. Additionally,
in order to enforce the linux device model requirement that a pass-through
device must be bound to the driver facilitating its passthrough, each new
APQN assigned to the guest's matrix must reference a queue device bound to
the vfio_ap device driver. The following sections articulate the design
for this patch.

Probing a queue device:
----------------------
The goal here is to assign the APQN of the queue being probed to the
guest's matrix if possible by adhering to a set of rules:
* The adapter number (APID) will be assigned to the guest matrix iff:
  1. The adapter is in the host's AP configuration
  2. The APID is not yet assigned to the guest's matrix
  3. Each APQN derived from the APID and the domain numbers (APQI) of
     domains already assigned to the guest's matrix references a queue
     device bound to the vfio_ap device driver
* The domain number (APQI) will be assigned to the guest matrix iff:
  1. The domain is in the host's AP configuration
  2. The APQI is not yet assigned to the guest's matrix
  3. Each APQN derived from the APQI and the APIDs of
     adapters already assigned to the guest's matrix references a queue
     device bound to the vfio_ap device driver

Removing a queue device:
-----------------------
Unassigning the adapter number from the guest's matrix will remove access
to all domains on the adapter from the guest. Unassigning the domain
number from the guest's matrix will remove access to that domain on all
adapters assigned to the guest matrix. If both the adapter and domain are
unassigned from the guest's matrix, That will reduce access to every
adapter for the guest. Since an AP adapter card is the actual hardware
device that gets physically plugged/unplugged, unassigning the adapter
number from the guest's matrix makes the most sense here.

Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 37 +++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4f96b7861607..1179c6af59c6 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1508,6 +1508,23 @@ static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
 	}
 }
 
+
+static void vfio_ap_mdev_hot_plug_queue(struct vfio_ap_queue *q)
+{
+	bool hot_plug = false;
+	unsigned long apid = (unsigned long)AP_QID_CARD(q->apqn);
+	unsigned long apqi = (unsigned long)AP_QID_QUEUE(q->apqn);
+
+	if (q->matrix_mdev == NULL)
+		return;
+
+	hot_plug |= vfio_ap_assign_apid_to_apcb(q->matrix_mdev, apid);
+	hot_plug |= vfio_ap_assign_apqi_to_apcb(q->matrix_mdev, apqi);
+
+	if (hot_plug)
+		vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
+}
+
 /**
  * vfio_ap_mdev_probe_queue:
  *
@@ -1526,11 +1543,30 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	q->apqn = to_ap_queue(&apdev->device)->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	vfio_ap_queue_link_mdev(q);
+	vfio_ap_mdev_hot_plug_queue(q);
 	mutex_unlock(&matrix_dev->lock);
 
 	return 0;
 }
 
+static void vfio_ap_mdev_hot_unplug_queue(struct vfio_ap_queue *q)
+{
+	unsigned long apid;
+	unsigned long apqi;
+
+	if (q->matrix_mdev == NULL)
+		return;
+
+	apid = AP_QID_CARD(q->apqn);
+	apqi = AP_QID_QUEUE(q->apqn);
+
+	if (test_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm) &&
+	    test_bit_inv(apqi, q->matrix_mdev->shadow_apcb.aqm)) {
+		clear_bit_inv(apid, q->matrix_mdev->shadow_apcb.apm);
+		vfio_ap_mdev_commit_shadow_apcb(q->matrix_mdev);
+	}
+}
+
 /**
  * vfio_ap_mdev_remove_queue:
  *
@@ -1544,6 +1580,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 
 	mutex_lock(&matrix_dev->lock);
 	q = dev_get_drvdata(&apdev->device);
+	vfio_ap_mdev_hot_unplug_queue(q);
 	dev_set_drvdata(&apdev->device, NULL);
 	apid = AP_QID_CARD(q->apqn);
 	apqi = AP_QID_QUEUE(q->apqn);
-- 
2.21.1


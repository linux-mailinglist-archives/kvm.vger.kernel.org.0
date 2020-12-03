Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C422CE0F5
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 22:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731516AbgLCVig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 16:38:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731401AbgLCVif (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 16:38:35 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LX00g115821;
        Thu, 3 Dec 2020 16:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=5xi0ktPHLi1lr5LE+kg0/pYOT31VTadV+xm+i4uAEjw=;
 b=LuZsRmJEX7kl8ZPW5x6sVZKtjmPDOW1v8oJbtUUgWPVDxb1rzn+EkAccWi+BRaOV1gOi
 hxw5LPz0Vchz49YoUJ+XGp9tykb6TAM5WEaO7JKhcyQob91NotyRTBJegbeO6AcbiDh5
 72a2XylYVu12XnJfF+xDaNkVy2SaR0Sbr0aNxgH0c72iEBiJ2kYNCd4czMxJzTOeomQE
 HvqRNy+8Kc541+wZkZashBelIFaIp2K8McX+YAOlUmR4lZP7T/V/Wqaw3Sbu8rFMrpOD
 kmSYq6HXf/+JG7rgMLMIuaz2A4vtLqvb6Q4njyUfFfPC94AEozr7rdq5nIu9HF8slzTM GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35773w9uus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 16:37:52 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B3LWxwG115700;
        Thu, 3 Dec 2020 16:37:51 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35773w9uta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 16:37:51 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B3LXBoO025210;
        Thu, 3 Dec 2020 21:37:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 353e688b2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 21:37:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B3LZF8I26608102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 21:35:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B287A52050;
        Thu,  3 Dec 2020 21:35:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 907045204F;
        Thu,  3 Dec 2020 21:35:15 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 15FF1E01DC; Thu,  3 Dec 2020 22:35:15 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 1/2] vfio-mdev: Wire in a request handler for mdev parent
Date:   Thu,  3 Dec 2020 22:35:11 +0100
Message-Id: <20201203213512.49357-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203213512.49357-1-farman@linux.ibm.com>
References: <20201203213512.49357-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_12:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While performing some destructive tests with vfio-ccw, where the
paths to a device are forcible removed and thus the device itself
is unreachable, it is rather easy to end up in an endless loop in
vfio_del_group_dev() due to the lack of a request callback for the
associated device.

In this example, one MDEV (77c) is used by a guest, while another
(77b) is not. The symptom is that the iommu is detached from the
mdev for 77b, but not 77c, until that guest is shutdown:

    [  238.794867] vfio_ccw 0.0.077b: MDEV: Unregistering
    [  238.794996] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: Removing from iommu group 2
    [  238.795001] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: MDEV: detaching iommu
    [  238.795036] vfio_ccw 0.0.077c: MDEV: Unregistering
    ...silence...

Let's wire in the request call back to the mdev device, so that a
device being physically removed from the host can be (gracefully?)
handled by the parent device at the time the device is removed.

Add a message when registering the device if a driver doesn't
provide this callback, so a clue is given that this same loop
may be encountered in a similar situation, and a message when
this occurs instead of the awkward silence noted above.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/vfio/mdev/mdev_core.c |  4 ++++
 drivers/vfio/mdev/vfio_mdev.c | 13 +++++++++++++
 include/linux/mdev.h          |  4 ++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b558d4cfd082..6de97d25a3f8 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -154,6 +154,10 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	if (!dev)
 		return -EINVAL;
 
+	/* Not mandatory, but its absence could be a problem */
+	if (!ops->request)
+		dev_info(dev, "Driver cannot be asked to release device\n");
+
 	mutex_lock(&parent_list_lock);
 
 	/* Check for duplicate */
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 30964a4e0a28..b52eea128549 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -98,6 +98,18 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 	return parent->ops->mmap(mdev, vma);
 }
 
+static void vfio_mdev_request(void *device_data, unsigned int count)
+{
+	struct mdev_device *mdev = device_data;
+	struct mdev_parent *parent = mdev->parent;
+
+	if (parent->ops->request)
+		parent->ops->request(mdev, count);
+	else if (count == 0)
+		dev_notice(mdev_dev(mdev),
+			   "No mdev vendor driver request callback support, blocked until released by user\n");
+}
+
 static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.name		= "vfio-mdev",
 	.open		= vfio_mdev_open,
@@ -106,6 +118,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.read		= vfio_mdev_read,
 	.write		= vfio_mdev_write,
 	.mmap		= vfio_mdev_mmap,
+	.request	= vfio_mdev_request,
 };
 
 static int vfio_mdev_probe(struct device *dev)
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78db0..9004375c462e 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
  * @mmap:		mmap callback
  *			@mdev: mediated device structure
  *			@vma: vma structure
+ * @request:		request callback to release device
+ *			@mdev: mediated device structure
+ *			@count: request sequence number
  * Parent device that support mediated device should be registered with mdev
  * module with mdev_parent_ops structure.
  **/
@@ -92,6 +95,7 @@ struct mdev_parent_ops {
 	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
 			 unsigned long arg);
 	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
+	void	(*request)(struct mdev_device *mdev, unsigned int count);
 };
 
 /* interface for exporting mdev supported type attributes */
-- 
2.17.1


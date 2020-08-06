Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05BE23DF7B
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbgHFRsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:48:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728935AbgHFQfp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Aug 2020 12:35:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 076E296Q092894;
        Thu, 6 Aug 2020 10:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=cK+IFbwDsM2m9d21mk++qrDlBgGZFvrkkmzPVkYIzkw=;
 b=Wy/DxXqmIU1/ZqRoHZPqLu9oj7ath30Pv4e1FvQ7vq46Ful0fvenpSQOtpq0EmuF7yqi
 lXH6qTHYc2W4pkoa2gm56Eb0kse8bu7mNntp3WKrKsnk8yILFR4LvmBRKgfoWc2NRK8+
 iD+vzfe4NuI2f+VDseLvdF7i1/njOKnOjE4WU2tZpJ5YNElm5ItAAmqdidGABGuO7xqR
 Td632cBQQ5WLo7ceohtcYfRcu/HvGe8qSBiJW/AeT+umrvjkCO0BTpjRd5Eewudh88Kw
 pAeYb2wxa/w9KxTe/Fy7K0GB0lA3cmUkmrg5BMWSliJX77Rac9FcabcnNJKiWzlWqbDI eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32qu0w8xkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 10:23:12 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 076E38m9098055;
        Thu, 6 Aug 2020 10:23:11 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32qu0w8xjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 10:23:11 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 076EGXgN027832;
        Thu, 6 Aug 2020 14:23:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 32n018bda0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Aug 2020 14:23:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 076EN59J27721984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Aug 2020 14:23:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AEA6AE053;
        Thu,  6 Aug 2020 14:23:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8AE7AE04D;
        Thu,  6 Aug 2020 14:23:04 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.70])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Aug 2020 14:23:04 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v1 1/1] s390: virtio-ccw: PV needs VIRTIO I/O device protection
Date:   Thu,  6 Aug 2020 16:23:02 +0200
Message-Id: <1596723782-12798-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596723782-12798-1-git-send-email-pmorel@linux.ibm.com>
References: <1596723782-12798-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-06_09:2020-08-06,2020-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 suspectscore=3
 phishscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If protected virtualization is active on s390, the virtio queues are
not accessible to the host, unless VIRTIO_F_IOMMU_PLATFORM has been
negotiated. Use ccw_transport_features() to fail feature negociation
and consequently probe if that's not the case, preventing a host
error on access attempt.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/s390/virtio/virtio_ccw.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 5730572b52cd..cc8d8064c6c4 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -803,11 +803,23 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	return rc;
 }
 
-static void ccw_transport_features(struct virtio_device *vdev)
+static int ccw_transport_features(struct virtio_device *vdev)
 {
-	/*
-	 * Currently nothing to do here.
-	 */
+	if (!is_prot_virt_guest())
+		return 0;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
+		dev_warn(&vdev->dev,
+			 "device must provide VIRTIO_F_VERSION_1\n");
+		return -ENODEV;
+	}
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM)) {
+		dev_warn(&vdev->dev,
+			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
+		return -ENODEV;
+	}
+	return 0;
 }
 
 static int virtio_ccw_finalize_features(struct virtio_device *vdev)
@@ -837,7 +849,9 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	vring_transport_features(vdev);
 
 	/* Give virtio_ccw a chance to accept features. */
-	ccw_transport_features(vdev);
+	ret = ccw_transport_features(vdev);
+	if (ret)
+		goto out_free;
 
 	features->index = 0;
 	features->features = cpu_to_le32((u32)vdev->features);
-- 
2.25.1


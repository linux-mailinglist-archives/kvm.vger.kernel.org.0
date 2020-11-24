Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D802C3335
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbgKXVkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733125AbgKXVkl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:41 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLXiG2008636;
        Tue, 24 Nov 2020 16:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gNq6+oJbAuKJpMimuDw7P4fjoVctFM/Dlwn1GOlFOMc=;
 b=cRzeFr+dSUOxt1MVrnoGraliIthX9bppw/h3k0N7BsSBNi3X/rvRmuKv0Xp/gD9lj5TW
 JNDolHAr1LCKNXucULAHG/pXkKAV1KwearV/43T0OrwTXRF6MOQPp5oHOG+LWmoM2ggA
 3U+x0TV247TcTOH+MDax/3uqQ6MWGMiiGJpQezX6byW+BVuOzsSTpM5+nyKgr7ayYnVR
 YUAfWMfUkfVBO+p4+PubG3Fr1ku6gCVFpaaFqphG/6+NGkaJ+vAaYcx/hUz9d1M1pfAa
 ytm3pYEJaASH3XZXHsvPMUPO8nXmM2fFULkKiaXVP4bH1c5kVN1+J95orl2AX9gYE6zy lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350fe1mxhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:40 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLXsR0009592;
        Tue, 24 Nov 2020 16:40:39 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350fe1mxgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:39 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLbJDj029603;
        Tue, 24 Nov 2020 21:40:38 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03wdc.us.ibm.com with ESMTP id 35133nty4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:38 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLeaZB7537224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:36 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87B68AE05F;
        Tue, 24 Nov 2020 21:40:36 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C8D7AE063;
        Tue, 24 Nov 2020 21:40:35 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:35 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 09/17] s390/vfio-ap: sysfs attribute to display the guest's matrix
Date:   Tue, 24 Nov 2020 16:40:08 -0500
Message-Id: <20201124214016.3013-10-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_09:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 suspectscore=3 mlxscore=0 spamscore=0
 clxscore=1015 adultscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The matrix of adapters and domains configured in a guest's APCB may
differ from the matrix of adapters and domains assigned to the matrix mdev,
so this patch introduces a sysfs attribute to display the matrix of
adapters and domains that are or will be assigned to the APCB of a guest
that is or will be using the matrix mdev. For a matrix mdev denoted by
$uuid, the guest matrix can be displayed as follows:

   cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 51 ++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 89b0e81657ca..a69422d76e7f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1075,29 +1075,24 @@ static ssize_t control_domains_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(control_domains);
 
-static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
-			   char *buf)
+static ssize_t vfio_ap_mdev_matrix_show(struct ap_matrix *matrix, char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	char *bufpos = buf;
 	unsigned long apid;
 	unsigned long apqi;
 	unsigned long apid1;
 	unsigned long apqi1;
-	unsigned long napm_bits = matrix_mdev->matrix.apm_max + 1;
-	unsigned long naqm_bits = matrix_mdev->matrix.aqm_max + 1;
+	unsigned long napm_bits = matrix->apm_max + 1;
+	unsigned long naqm_bits = matrix->aqm_max + 1;
 	int nchars = 0;
 	int n;
 
-	apid1 = find_first_bit_inv(matrix_mdev->matrix.apm, napm_bits);
-	apqi1 = find_first_bit_inv(matrix_mdev->matrix.aqm, naqm_bits);
-
-	mutex_lock(&matrix_dev->lock);
+	apid1 = find_first_bit_inv(matrix->apm, napm_bits);
+	apqi1 = find_first_bit_inv(matrix->aqm, naqm_bits);
 
 	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
-		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
-			for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
+		for_each_set_bit_inv(apid, matrix->apm, napm_bits) {
+			for_each_set_bit_inv(apqi, matrix->aqm,
 					     naqm_bits) {
 				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
 					    apqi);
@@ -1106,25 +1101,52 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 			}
 		}
 	} else if (apid1 < napm_bits) {
-		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
+		for_each_set_bit_inv(apid, matrix->apm, napm_bits) {
 			n = sprintf(bufpos, "%02lx.\n", apid);
 			bufpos += n;
 			nchars += n;
 		}
 	} else if (apqi1 < naqm_bits) {
-		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, naqm_bits) {
+		for_each_set_bit_inv(apqi, matrix->aqm, naqm_bits) {
 			n = sprintf(bufpos, ".%04lx\n", apqi);
 			bufpos += n;
 			nchars += n;
 		}
 	}
 
+	return nchars;
+}
+
+static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	ssize_t nchars;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+
+	mutex_lock(&matrix_dev->lock);
+	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->matrix, buf);
 	mutex_unlock(&matrix_dev->lock);
 
 	return nchars;
 }
 static DEVICE_ATTR_RO(matrix);
 
+static ssize_t guest_matrix_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	ssize_t nchars;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+
+	mutex_lock(&matrix_dev->lock);
+	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->shadow_apcb, buf);
+	mutex_unlock(&matrix_dev->lock);
+
+	return nchars;
+}
+static DEVICE_ATTR_RO(guest_matrix);
+
 static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_assign_adapter.attr,
 	&dev_attr_unassign_adapter.attr,
@@ -1134,6 +1156,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_unassign_control_domain.attr,
 	&dev_attr_control_domains.attr,
 	&dev_attr_matrix.attr,
+	&dev_attr_guest_matrix.attr,
 	NULL,
 };
 
-- 
2.21.1


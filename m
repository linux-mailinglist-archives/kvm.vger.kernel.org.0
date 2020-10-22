Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC3296389
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 19:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902391AbgJVRNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 13:13:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2902380AbgJVRMk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 13:12:40 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MH29Gk054665;
        Thu, 22 Oct 2020 13:12:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gcLZYySwvxnWbRDdjGHe0uIhlOME1LIX5y9Cda/eySo=;
 b=pAhuRmByksQwTzmZK4CDhBpP2dLzZVKXe0ti+9SXCsIwtrjFfLr/LbLMxoTHwyuCCi/2
 yehHWs5Wq8fvUjwqRSc+3Wjv7rUh/pHZSVgEO71QZKrpAzlwtf3ZdNLldUpGIzTO/1rF
 RFUyUnNtYvefpazrk3Nr6STtmFA1+8V23KLR29Xg583zRuso15Gk3l5McYqub08ffvJw
 Btoq9jtL28Ww8QqEaezweGLLkCD+5AglLnhMIBKJM1VRvlhp3EaEchM0q4CjIrecBl2E
 fqJb4pIqYPyhpokmlV66ywx0o75HaeL0RgiSALICsuMbPq5uUnBmT/lH6joF1EAmg2FO Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34b00e2cjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:12:38 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MH3O5a060686;
        Thu, 22 Oct 2020 13:12:37 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34b00e2cj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 13:12:37 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09MHCLYB015375;
        Thu, 22 Oct 2020 17:12:37 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 347r89vbb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 17:12:37 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09MHCXmC58392910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 17:12:33 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6EAB7805C;
        Thu, 22 Oct 2020 17:12:33 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4C8A78068;
        Thu, 22 Oct 2020 17:12:31 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.170.177])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Oct 2020 17:12:31 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v11 07/14] s390/vfio-ap: sysfs attribute to display the guest's matrix
Date:   Thu, 22 Oct 2020 13:12:02 -0400
Message-Id: <20201022171209.19494-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201022171209.19494-1-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_11:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010220108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The matrix of adapters and domains configured in a guest's APCB may
differ from the matrix of adapters and domains assigned to the matrix mdev,
so this patch introduces a sysfs attribute to display the matrix of a guest
using the matrix mdev. For a matrix mdev denoted by $uuid, the crycb for a
guest using the matrix mdev can be displayed as follows:

   cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix

If a guest is not using the matrix mdev at the time the crycb is displayed,
an error (ENODEV) will be returned.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 54 +++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9791761aa7fd..7bad70d7bcef 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1073,29 +1073,24 @@ static ssize_t control_domains_show(struct device *dev,
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
@@ -1104,25 +1099,55 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
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
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+		return -ENODEV;
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
@@ -1132,6 +1157,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_unassign_control_domain.attr,
 	&dev_attr_control_domains.attr,
 	&dev_attr_matrix.attr,
+	&dev_attr_guest_matrix.attr,
 	NULL,
 };
 
-- 
2.21.1


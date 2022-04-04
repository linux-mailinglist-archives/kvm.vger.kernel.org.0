Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD54F1B93
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380229AbiDDVVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379667AbiDDRqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:46:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE0413EBA;
        Mon,  4 Apr 2022 10:44:39 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234He88O029286;
        Mon, 4 Apr 2022 17:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PuQofBb7+tIYgxq4WjR9Y7Armh4WYhCMUVtj9AtLoyE=;
 b=cnS9XcMz+V76DUhFjJ89tylwb5/2riwtL9jR0bJT4QT6CYxyEKjPGup8AcRR7xmJ2XwX
 sx3P8bo4Mq96Or9ER4fFHT1a6xY8WKptJJ2OADHxBRQfj4A1N1/YHLt6S/U2qTRIVc5R
 JnD9HQIGkrVcVSeIHimMxf3zqeCgoM7uEKijoi6YYSg7PmSlr28DVYD1jK4xf8zKxUNw
 /O2TXuCiL8+MlBh4Zi+7WhAuuKlZppqXq5mg86C2SsygVtIMbbHRFKSF8MiM9eShuJr5
 wz88+FWzUN5OfcEuBcGzbDMGNWLcjimEbeP04k00c/QSlpEa2FwNAR+x7MIDV1trvxKh eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f81v978c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:38 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234HicwC022661;
        Mon, 4 Apr 2022 17:44:38 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f81v978b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:38 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234HhLYW026088;
        Mon, 4 Apr 2022 17:44:37 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 3f6e49ng8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:37 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234HiZGc9044354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 17:44:36 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D86C1136055;
        Mon,  4 Apr 2022 17:44:35 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85D99136051;
        Mon,  4 Apr 2022 17:44:33 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 17:44:33 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v5 17/21] vfio-pci/zdev: add function handle to clp base capability
Date:   Mon,  4 Apr 2022 13:43:45 -0400
Message-Id: <20220404174349.58530-18-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404174349.58530-1-mjrosato@linux.ibm.com>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D6dD33uBEkCkzYVDBFpLQLLCmJ-UXAro
X-Proofpoint-ORIG-GUID: bCJlpt2SngnaCmqJ1ZsZTkuTIkibVIHG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0
 mlxlogscore=969 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function handle is a system-wide unique identifier for a zPCI
device.  It is used as input for various zPCI operations.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 5 +++--
 include/uapi/linux/vfio_zdev.h   | 3 +++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index ea4c0d2b0663..4a653ce480c7 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -23,14 +23,15 @@ static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
 {
 	struct vfio_device_info_cap_zpci_base cap = {
 		.header.id = VFIO_DEVICE_INFO_CAP_ZPCI_BASE,
-		.header.version = 1,
+		.header.version = 2,
 		.start_dma = zdev->start_dma,
 		.end_dma = zdev->end_dma,
 		.pchid = zdev->pchid,
 		.vfn = zdev->vfn,
 		.fmb_length = zdev->fmb_length,
 		.pft = zdev->pft,
-		.gid = zdev->pfgid
+		.gid = zdev->pfgid,
+		.fh = zdev->fh
 	};
 
 	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index b4309397b6b2..78c022af3d29 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -29,6 +29,9 @@ struct vfio_device_info_cap_zpci_base {
 	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
 	__u8 pft;		/* PCI Function Type */
 	__u8 gid;		/* PCI function group ID */
+	/* End of version 1 */
+	__u32 fh;		/* PCI function handle */
+	/* End of version 2 */
 };
 
 /**
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03B47ABCF2
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjIWB1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjIWB1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:27:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E75E8
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:27:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38N11NOM008398;
        Sat, 23 Sep 2023 01:27:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=tKwmRXX0zjeQAE+FayNaDOQoJjyZd+6k7hRqWC3E8AY=;
 b=hBQjezhXexi/s14y0iFuXP3UoRXMb/Y9WyORHu33ky1i9mWmr+8HKKlWhGKjOfnY81Jp
 /rZ4EiUtUxEV0FFEeUz3sc4k8bMUQhrOKYGWXvkS3Fh0/M13F4T4AfqUNgf5e6gRM+hO
 9onY62+VG6sEKCtns9zQ5n7QcE1qXDxgniqwaA6Zw5M4jsPBz1sg/VwIKzDl9G3V+/U0
 ohGpHxZRNHoNJmCpFkpaSXnD/u08OiF2Cb0BH4k4QT7hkiE3B/eEntqR7+mp8wXg4L4l
 +EPeIqMKSAx4s8YqIHhLE9lQKQdbVCW6PmQtaroXrV3dvKQqvX/RJ8zlISsgZcff0GKB 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt1k2nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0YBhH007610;
        Sat, 23 Sep 2023 01:27:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhq9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:08 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3gw040930;
        Sat, 23 Sep 2023 01:27:07 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-2;
        Sat, 23 Sep 2023 01:27:07 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 01/19] vfio/iova_bitmap: Export more API symbols
Date:   Sat, 23 Sep 2023 02:24:53 +0100
Message-Id: <20230923012511.10379-2-joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-1-joao.m.martins@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230011
X-Proofpoint-GUID: IqlmCGd1z9nqCMVTS99BgStlL8r8RWrX
X-Proofpoint-ORIG-GUID: IqlmCGd1z9nqCMVTS99BgStlL8r8RWrX
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to move iova_bitmap into iommufd, export the rest of API
symbols that will be used in what could be used by modules, namely:

	iova_bitmap_alloc
	iova_bitmap_free
	iova_bitmap_for_each

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/vfio/iova_bitmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index 0848f920efb7..f54b56388e00 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -268,6 +268,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
 	iova_bitmap_free(bitmap);
 	return ERR_PTR(rc);
 }
+EXPORT_SYMBOL_GPL(iova_bitmap_alloc);
 
 /**
  * iova_bitmap_free() - Frees an IOVA bitmap object
@@ -289,6 +290,7 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
 
 	kfree(bitmap);
 }
+EXPORT_SYMBOL_GPL(iova_bitmap_free);
 
 /*
  * Returns the remaining bitmap indexes from mapped_total_index to process for
@@ -387,6 +389,7 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(iova_bitmap_for_each);
 
 /**
  * iova_bitmap_set() - Records an IOVA range in bitmap
-- 
2.17.2


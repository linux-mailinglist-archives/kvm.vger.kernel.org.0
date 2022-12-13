Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202A664BD6C
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 20:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236886AbiLMTlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 14:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbiLMTlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 14:41:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645FE20F74
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:41:06 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDJJRer008188;
        Tue, 13 Dec 2022 19:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=ca1Aeiv/GpzKwQ2H7J2ePdpWN3K3a2Np5ly/4BfruBs=;
 b=r9ed2LaZ07WoMkgNtFJnCNn5hAXp0s1oDrB5aRWzm98jbhJBO/axhQTeELbqnQPy9SKn
 XMFPuC1HlAfkk1YMVIbpRGCk8P22GyG0J/GV+Iq9EMvlq/q3Z6kMiXmT3zEiUOG116sO
 GVvu/PNv2cUvR8eQlpMy51gBB31QzQtbCv/LNKiIQ/VhDze1Fut7bzwpsvD2hT7JmFXq
 QMc4iGrKFlpUF0i2c7BFraDvauX5+WIwYnXTLelgzxq0W3/+DSQSLm5SWq8x6c+0VU8l
 8bsu0YG2RPXQF0I8nMWh70TKSScwq42WRksaldqpfaHJ5umUhTW2YF4As/S5RA/YlNHJ oA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewr1ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:41:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDJJAWT031109;
        Tue, 13 Dec 2022 19:41:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyesrs23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:41:03 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDJf0Gp028128;
        Tue, 13 Dec 2022 19:41:03 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyesrry8-5;
        Tue, 13 Dec 2022 19:41:03 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 4/5] vfio/type1: revert "implement notify callback"
Date:   Tue, 13 Dec 2022 11:40:58 -0800
Message-Id: <1670960459-415264-5-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130171
X-Proofpoint-GUID: lk8YTyzVVbwOvX3b8VSPCdOtvTXKiMnh
X-Proofpoint-ORIG-GUID: lk8YTyzVVbwOvX3b8VSPCdOtvTXKiMnh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is dead code.  Revert it.
  commit 487ace134053 ("vfio/type1: implement notify callback")

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index d4f961d..2fc0e34 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -75,7 +75,6 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
-	bool			container_open;
 	struct list_head	emulated_iommu_groups;
 };
 
@@ -2538,7 +2537,6 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	INIT_LIST_HEAD(&iommu->iova_list);
 	iommu->dma_list = RB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
-	iommu->container_open = true;
 	mutex_init(&iommu->lock);
 	mutex_init(&iommu->device_list_lock);
 	INIT_LIST_HEAD(&iommu->device_list);
@@ -3137,18 +3135,6 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	return domain;
 }
 
-static void vfio_iommu_type1_notify(void *iommu_data,
-				    enum vfio_iommu_notify_type event)
-{
-	struct vfio_iommu *iommu = iommu_data;
-
-	if (event != VFIO_IOMMU_CONTAINER_CLOSE)
-		return;
-	mutex_lock(&iommu->lock);
-	iommu->container_open = false;
-	mutex_unlock(&iommu->lock);
-}
-
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name			= "vfio-iommu-type1",
 	.owner			= THIS_MODULE,
@@ -3163,7 +3149,6 @@ static void vfio_iommu_type1_notify(void *iommu_data,
 	.unregister_device	= vfio_iommu_type1_unregister_device,
 	.dma_rw			= vfio_iommu_type1_dma_rw,
 	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
-	.notify			= vfio_iommu_type1_notify,
 };
 
 static int __init vfio_iommu_type1_init(void)
-- 
1.8.3.1


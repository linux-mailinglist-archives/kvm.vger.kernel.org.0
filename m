Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4C660D4B1
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 21:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiJYTba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 15:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJYTb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 15:31:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5EBC5121
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 12:31:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PI4knP004138;
        Tue, 25 Oct 2022 19:31:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=WTmvi5E1ydB2DueO3RCr25ejv/fqWOnir6LOICAmbCg=;
 b=T8etbBz1CEOkixBA7mcdvTIr/bHGWrTiPmKqhaqfeo83rRuy6vjJu9+qt1C2mPaf2ELY
 2bW4DIV4nuXLi9GJwtuEREK1vnU3RRA2F8ZPt8vc1iOi6NxNkLrWhv8njw9QLTYCHEDi
 BHsTbgnOiKaHxD1EyidvhqWfQLgsIuoWrdgRvzhga9Bjp0KPaWB4wuiIFtqh6fWBH8eR
 On7KKVi1wzZvjj9THSz/9h+N/bbpu8UyNtzs4+ChcUAuQhx/hC+ZUflFtZF9EFGLN8iU
 NNrkezVNv7fPjo7sXfc6uv9/bMVfrLbOUlIZ+Eg8sLxZNzo7/REFBv8diuwHP6s+j3E9 aA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939d5ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 19:31:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJ5VkR012753;
        Tue, 25 Oct 2022 19:31:24 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-215-98.vpn.oracle.com [10.175.215.98])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3kc6y4y1dp-2;
        Tue, 25 Oct 2022 19:31:24 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v1 1/2] vfio/iova_bitmap: Explicitly include linux/slab.h
Date:   Tue, 25 Oct 2022 20:31:13 +0100
Message-Id: <20221025193114.58695-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20221025193114.58695-1-joao.m.martins@oracle.com>
References: <20221025193114.58695-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_12,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=971 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250110
X-Proofpoint-GUID: FqkSFCltt92RjDE03IcybdTDNJdhMHjb
X-Proofpoint-ORIG-GUID: FqkSFCltt92RjDE03IcybdTDNJdhMHjb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kzalloc/kzfree are used so include `slab.h`. While it happens to work
without it, due to commit 8b9f3ac5b01d ("fs: introduce alloc_inode_sb() to
allocate filesystems specific inode") which indirectly includes via:

. ./include/linux/mm.h
.. ./include/linux/huge_mm.h
... ./include/linux/fs.h
.... ./include/linux/slab.h

Make it explicit should any of its indirect dependencies be dropped/changed
for entirely different reasons as it was the cause prior to commit above
recently (i.e. <= v5.18).

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/vfio/iova_bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index c20ffce1a0fd..389f36cae355 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -5,6 +5,7 @@
  */
 #include <linux/iova_bitmap.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/highmem.h>
 
 #define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
-- 
2.17.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF17C513D24
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352082AbiD1VOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352074AbiD1VOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640B87487C
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:17 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIXQLp025808;
        Thu, 28 Apr 2022 21:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=khn9jqNNydsP7s3WFsonW1D2ncrg4xCkbOvtlKZ3+iI=;
 b=XS4lNGlwlW4ZMehBa5bIqdGuOsmiLPelhF/mmHotD8Z7gTwKrgNi5TMnSCUHXJMpNyL/
 q9w+3+1EmYP//vVIRzfg0Z9EJWXbeRjsvjJVum2euIGtudZB2C2OqKZ9Zdqkrsq5fV5m
 55SqEq2L8nV+MGy+KSMq6VgTjHGP0PzEpgbiNdZUcISRSRsMVTAMKY561kjl0359QYLv
 6nd1KuluhfgQvt8QCpakBnCwA9ek7sOnNNFwSYaKuHZF/T47rG5W5YFcLQIcg//jRE+g
 82doyGi3F65iw7iD8lkt2p8n6nNmMcrYwkfMjQpp4yx8HqaMW+zk/Es/5sl9bO8kqx1/ xQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mwbg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5D8C028602;
        Thu, 28 Apr 2022 21:10:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79nvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbQmevUOmg+1eYrmRmt5pSaLdOFjPF6WNl/qCJmpvg5xuxuD0rKpUKvIHvpwE2XYEqJ+eifH/oWMkAb41RzgVfe4WMvfgLkTsc8y+po7Nq2qyBz9hWr8eDb4K789JVluqTr0RV5J9HdcLonL/SlTaZVkzCBa5FYKngvUCGqADaZIve7ZlxiIVZ8GUjXze1B9b3WGmty63eGOo2IF1MgrycHdmu7BSV+scrdj9StlfW5zzUZw4JYDd567jrxFlIUtRyVaP/wBQuGTXY3wc5ESJzyWBNyXk05fwH2x564lzyt7yCbSb477feJAGP1mXIn4mIGlApLPIhz7NFNieBK+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khn9jqNNydsP7s3WFsonW1D2ncrg4xCkbOvtlKZ3+iI=;
 b=auV3n//Fw4QJaYitmir/k4hPXgCoxYKGg/EPzS9ay7gEaoSLGpV5kJcRvh39GtE+RSaifQBqmHJ7IJaLhIfJ7zU5ReW05pjHS3WAW+7MRVgTbtmEV2Kq4op6An/5/E3bAbXZO7mQpmf8ojRGY8FG2uYdrcx5/kI5uHae9/6kmf6TcjLFXD0J+oWRJzNliKks7P1T3S8MofBe0GhCgzk8hb4rCPLehSWwPb4RX2LEj2N1fBhpdLkupgsbS6JVEmtsbd3xxB1IZpk9dJPWNWr/D+PRh8gSDGAlEeHtkkmukhye0Khowbs4BJB8IjtvaFiEuQRMwCvDvdHtuShIaAxDvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khn9jqNNydsP7s3WFsonW1D2ncrg4xCkbOvtlKZ3+iI=;
 b=Xefa8aVP13uqHowXMmsD1s+4jGdgqGpcb0WMZdX9sCDrpQFnbJ1OAAHjoc1p1TY2591tORxGSydlfZ0e+x1wrxNUBaBSQb5KEoeTyo3Y/OQL1ekz7in1/A1zTqbufi8CQkq18RW5a5DOd+GVBiwiYPcgbeMWfjPSE4yiv4NV1bs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:10:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:10:50 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux-foundation.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC 06/19] iommufd: Dirty tracking IOCTLs for the hw_pagetable
Date:   Thu, 28 Apr 2022 22:09:20 +0100
Message-Id: <20220428210933.3583-7-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9d3b2dc-fb33-4f66-d7a5-08da295b92a3
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB15641A764ABB2134DD5E66C2BBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /j3k3P2kL7WWGPpwxROAul/86FbQ/TcUKiwl//3PgKPLZ2rvzRmOSaWJaJdjnJFWClWv0k77FeqVoEUzaaaVwHVuIUZzGoVaw2D3iGWIUIp7cTj9dcp3OYVsQaNCNblzvmdz+LtcMPVYC+QBdXQUvWm599wvSbuwIyzuCre42zGOy9bKcHamZENnHEqq/hLwjoj0A/rPocb/xG4mKalJ89CN5AYlA0i0+St9RgSgxx2+/RaJl0Dtni9k/VbIaWiBR1SbQ119IjbvzqzEBh5UCimiiBILJ3+oPck6p8XvLtIwYNUIh/MN85QBqERdnqru2e28dMEu+tqBxqBjb9h4m6yXi7nNL+dlKH0GrerX4dVqK77G3Gw9HjwsxD6aTzghLvzBOaXaUJ11j+zTmo88pEMOjAYuVxkZbiFh77k0dmLhb2PBpoz9b64KqYLYO34V/HLrENHb1DSx4bs1ygcTcREFteNta6NmUN1aGWQlWFj0ijuloDMSctHk0i1k+vAQ75SEN07t6oD+yegfb1a3Ucr8YE+t+stucuiILu1UwiZ4xeFyUSPY7B0aaQac5FfWXf6ynDZaxVJ7wnHlEZLhrqMZYbsxeOd8d3pjkiW+SSDgZLbFkZKNYA624iHYRA40idYmd0oUHA5cWz4bUtZFeMO09U0xLTZ+oxg/vtM5gMbc7no61bEAiUAGW69vMDI3RmiYXUYm0hp7/vYmhrCnslGc0cengAbs1z3DPvilQCE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(30864003)(26005)(6512007)(6486002)(6916009)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?57z1VphY8LXhSkV+OqEmZKQgWbTW2nK6XZJtGt1lNQN7aUJBUQIx5YVX3JXp?=
 =?us-ascii?Q?MdeXW8xv8wl991Z/z3qg2oRqetIcluOY/nZ3uoRFGvx8NOHmmCe/POy7Jv7w?=
 =?us-ascii?Q?UpzPBrurLtQtuGs3CwrlwBkU13Su6VfKgjhg3bCFnlgL3mGVPRF1ZFbOiqdQ?=
 =?us-ascii?Q?lldZ2/NALF09efliUEPAbYBr3vW1RFAZvlRsR0GfUpoLXF9O4w8qsQV6PjjI?=
 =?us-ascii?Q?CnZdkh3uVEeUxD2f8rluzVJhYolkTn/LHXtZ4ooKHq1MNccOfi8QiYTU+bkA?=
 =?us-ascii?Q?VcbIxVClxulXneL792lwKx3LRwK0c5TlgoKHrba1MwT/cX6biNQhxAd4TRG0?=
 =?us-ascii?Q?aYeYc3pBksOiq6FcjBgazxbk4HUp+jTQs7/evJ/svg+QoX6oH4Nh9vIzV4S7?=
 =?us-ascii?Q?LJQN0USvQbpV0bLdjjkoKL6iaw4xmkBIh/C3ZFPxQUKMQHXSSpaxmt6RX1ef?=
 =?us-ascii?Q?5Z8Th2pweCof/RxYIbbYKuvUl0VQZCVfB1ezi1Mvsn1xNNr0NQCKiXA4G26w?=
 =?us-ascii?Q?lNWVRs4y0nFin4V4UqlVa/0biVWgx5cyUc+Bwvfk9mYkmVqBx3XAEVKq6+cw?=
 =?us-ascii?Q?te4Xex0IuUGnOjChJOFebPthSsPfrMiKxEgA/z24a7nCWpUSbE4dK59nnsxB?=
 =?us-ascii?Q?qSp+fw0o3cEDzKngNcvbhnSj9Wcix8VZRUZlM763BN4rT9xyFimKAyxygW0F?=
 =?us-ascii?Q?VX8T59bdeACtF78VY+gqwVJX8xG7s9RCe/qpuSLULFBcIQDYz3QDlE9oxRwK?=
 =?us-ascii?Q?5oUBqwDwVffzB/2InigCHh89vFck3q+HlI07F8Dafm7Oee631dSgpX/Fd+RK?=
 =?us-ascii?Q?2YoQTgL5oUmfvxRAeA7PqlT3AYAUoWW/jVpXAH9itpto1u0iiErI+SNKHl3p?=
 =?us-ascii?Q?2XKfjIARben6h0TGhvTw5JOVyN0c3wjGH4jYtpOXQmdwndcJfgXlRJs+Wpzo?=
 =?us-ascii?Q?B8jVTecpApt5Z6h1QrF5yLaz8m9Vos+nFwsolZkU6941VtRgeCEv9njDFJGF?=
 =?us-ascii?Q?UCFQr2cFr/R03jHCF72V5pyJowO67aXeBffBwUMqLcZmSi64FRrNN9Tz1bCM?=
 =?us-ascii?Q?rA4Qb4973/IbapVRYd6ZL2Q7xHZ/UgXPeNUvl4imJ5AIUHCqiIKruxOh2FWV?=
 =?us-ascii?Q?2Pf/sMG6YyB4pW8oYRdH85CGb8oS3Ji3uOgPk0LdwpfUVcE8LhDTSElgjNUy?=
 =?us-ascii?Q?eX1i55E6ruPYeDyiuV0Ye/8n7LNygdUPoLXC1O0r3LOYIDgktRwmbRahgIda?=
 =?us-ascii?Q?T78PUtOeHkbhYWX6klr1dbRc5Cco3PwqPWGoTEwHDP3OYe1FRKiKilOhiRI4?=
 =?us-ascii?Q?C5dNL/Ku05g2C771+4/c4rUGE22agUBOFRMW3e3UUcboqc58x6ByJSfGOXn2?=
 =?us-ascii?Q?sXRByQ24LubRStPDXUD7m8ju56Xy3fhEwCgYUK6NW6Y/s2y4JJbAdqjZV5EC?=
 =?us-ascii?Q?xXc7NZIVi+Tq9mdX9W7leib/CFY9iHTRDQhm94PSMwqFIY5fYiOpN5XoE6NT?=
 =?us-ascii?Q?q7E0uLRvBBHSzXa0UXhS6AqI+z1qLRGw5CXCQCY2WidSnwldioip5xW0jOYl?=
 =?us-ascii?Q?bwlu8lCPO/+xdQGiilzNtj3B+kXo0PFMa3ctuHAPgo6KST3MzLsG+05iJ0M/?=
 =?us-ascii?Q?zsHtY5pxhF3xm41tmLmMHZ86lbLuYVy4i+arogQJU/g4JPEAfPSHPJssT/Dy?=
 =?us-ascii?Q?sRdVrpiD43LDiUyRvAkIXRR8tAztR1JGK9EBQWlQZTBSj3s/pSeKpt/r7MEB?=
 =?us-ascii?Q?KstDF8OoqGzKc5Ely/MT87r3I9L87RA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d3b2dc-fb33-4f66-d7a5-08da295b92a3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:10:50.8133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlWD9vhBKJ5j/ZaWGAGzI57+kwdzk6ird2zT7z/l9TcXg74T0meAp5n3dR0rP9NZ0yCgXXc9ZMfLaUIbuOYW6vFqf0sI7kuhF+omcAIPJoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=965
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: LKofHDMG3dzU6mvOXqtZz9JSxeSCDj2s
X-Proofpoint-ORIG-GUID: LKofHDMG3dzU6mvOXqtZz9JSxeSCDj2s
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every IOMMU driver should be able to implement the needed
iommu domain ops to perform dirty tracking.

Connect a hw_pagetable to the IOMMU core dirty tracking ops.
It exposes all of the functionality for the UAPI:

- Enable/Disable dirty tracking on an IOMMU domain (hw_pagetable id)
- Read the dirtied IOVAs (which clear IOMMU domain bitmap under the hood)
- Unmap and get the dirtied IOVAs

In doing so the previously internal iommufd_dirty_data structure is
moved over as the UAPI intermediate structure for representing iommufd
dirty bitmaps.

Contrary to past incantations the IOVA range to be scanned or unmap is
tied in to the bitmap size, and thus puts the heavy lifting in the
application to make sure it passes a precisedly sized bitmap address as
opposed to allowing base_iova != iova, which simplifies things further.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c    | 79 +++++++++++++++++++++++++
 drivers/iommu/iommufd/ioas.c            | 33 +++++++++++
 drivers/iommu/iommufd/iommufd_private.h | 22 ++++---
 drivers/iommu/iommufd/main.c            |  9 +++
 include/uapi/linux/iommufd.h            | 78 ++++++++++++++++++++++++
 5 files changed, 214 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index bafd7d07918b..943bcc3898a4 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
  */
 #include <linux/iommu.h>
+#include <uapi/linux/iommufd.h>
 
 #include "iommufd_private.h"
 
@@ -140,3 +141,81 @@ void iommufd_hw_pagetable_put(struct iommufd_ctx *ictx,
 	}
 	iommufd_object_destroy_user(ictx, &hwpt->obj);
 }
+
+int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_hwpt_set_dirty *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_ioas *ioas;
+	int rc = -EOPNOTSUPP;
+	bool enable;
+
+	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	ioas = hwpt->ioas;
+	enable = cmd->flags & IOMMU_DIRTY_TRACKING_ENABLED;
+
+	rc = iopt_set_dirty_tracking(&ioas->iopt, hwpt->domain, enable);
+
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
+
+int iommufd_check_iova_range(struct iommufd_ioas *ioas,
+			     struct iommufd_dirty_data *bitmap)
+{
+	unsigned long pgshift, npages;
+	size_t iommu_pgsize;
+	int rc = -EINVAL;
+	u64 bitmap_size;
+
+	pgshift = __ffs(bitmap->page_size);
+	npages = bitmap->length >> pgshift;
+	bitmap_size = dirty_bitmap_bytes(npages);
+
+	if (!npages || (bitmap_size > DIRTY_BITMAP_SIZE_MAX))
+		return rc;
+
+	if (!access_ok((void __user *) bitmap->data, bitmap_size))
+		return rc;
+
+	iommu_pgsize = 1 << __ffs(ioas->iopt.iova_alignment);
+
+	/* allow only smallest supported pgsize */
+	if (bitmap->page_size != iommu_pgsize)
+		return rc;
+
+	if (bitmap->iova & (iommu_pgsize - 1))
+		return rc;
+
+	if (!bitmap->length || bitmap->length & (iommu_pgsize - 1))
+		return rc;
+
+	return 0;
+}
+
+int iommufd_hwpt_get_dirty_iova(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_hwpt_get_dirty_iova *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_ioas *ioas;
+	int rc = -EOPNOTSUPP;
+
+	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	ioas = hwpt->ioas;
+	rc = iommufd_check_iova_range(ioas, &cmd->bitmap);
+	if (rc)
+		goto out_put;
+
+	rc = iopt_read_and_clear_dirty_data(&ioas->iopt, hwpt->domain,
+					    &cmd->bitmap);
+
+out_put:
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 19d6591aa005..50bef46bc0bb 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -243,6 +243,7 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 			rc = -EOVERFLOW;
 			goto out_put;
 		}
+
 		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length, NULL);
 	}
 
@@ -250,3 +251,35 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(&ioas->obj);
 	return rc;
 }
+
+int iommufd_ioas_unmap_dirty(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_unmap_dirty *cmd = ucmd->cmd;
+	struct iommufd_dirty_data *bitmap;
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	/* The bitmaps would be gigantic */
+	bitmap = &cmd->bitmap;
+	if (bitmap->iova == 0 && bitmap->length == U64_MAX)
+		return -EINVAL;
+
+	if (bitmap->iova >= ULONG_MAX || bitmap->length >= ULONG_MAX) {
+		rc = -EOVERFLOW;
+		goto out_put;
+	}
+
+	rc = iommufd_check_iova_range(ioas, bitmap);
+	if (rc)
+		goto out_put;
+
+	rc = iopt_unmap_iova(&ioas->iopt, bitmap->iova, bitmap->length, bitmap);
+
+out_put:
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 3e3a97f623a1..68c77cf4793f 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -10,6 +10,7 @@
 #include <linux/uaccess.h>
 #include <linux/iommu.h>
 #include <linux/uio.h>
+#include <uapi/linux/iommufd.h>
 
 struct iommu_domain;
 struct iommu_group;
@@ -49,13 +50,6 @@ int iopt_map_pages(struct io_pagetable *iopt, struct iopt_pages *pages,
 		   unsigned long length, int iommu_prot, unsigned int flags);
 int iopt_unmap_all(struct io_pagetable *iopt);
 
-struct iommufd_dirty_data {
-	unsigned long iova;
-	unsigned long length;
-	unsigned long page_size;
-	unsigned long *data;
-};
-
 int iopt_set_dirty_tracking(struct io_pagetable *iopt,
 			    struct iommu_domain *domain, bool enable);
 int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
@@ -244,7 +238,10 @@ int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_unmap_dirty(struct iommufd_ucmd *ucmd);
 int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
+int iommufd_check_iova_range(struct iommufd_ioas *ioas,
+			     struct iommufd_dirty_data *bitmap);
 
 /*
  * A HW pagetable is called an iommu_domain inside the kernel. This user object
@@ -263,6 +260,17 @@ struct iommufd_hw_pagetable {
 	struct list_head devices;
 };
 
+static inline struct iommufd_hw_pagetable *iommufd_get_hwpt(
+					struct iommufd_ucmd *ucmd, u32 id)
+{
+	return container_of(iommufd_get_object(ucmd->ictx, id,
+					       IOMMUFD_OBJ_HW_PAGETABLE),
+			    struct iommufd_hw_pagetable, obj);
+}
+int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd);
+int iommufd_hwpt_get_dirty_iova(struct iommufd_ucmd *ucmd);
+int iommufd_hwpt_unmap_dirty(struct iommufd_ucmd *ucmd);
+
 struct iommufd_hw_pagetable *
 iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id,
 			     struct device *dev);
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 0e34426eec9f..4785fc9f4fb3 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -192,7 +192,10 @@ union ucmd_buffer {
 	struct iommu_ioas_iova_ranges iova_ranges;
 	struct iommu_ioas_map map;
 	struct iommu_ioas_unmap unmap;
+	struct iommu_ioas_unmap_dirty unmap_dirty;
 	struct iommu_destroy destroy;
+	struct iommu_hwpt_set_dirty set_dirty;
+	struct iommu_hwpt_get_dirty_iova get_dirty_iova;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
@@ -226,8 +229,14 @@ static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_IOAS_UNMAP, iommufd_ioas_unmap, struct iommu_ioas_unmap,
 		 length),
+	IOCTL_OP(IOMMU_IOAS_UNMAP_DIRTY, iommufd_ioas_unmap_dirty,
+		 struct iommu_ioas_unmap_dirty, bitmap.data),
 	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
 		 __reserved),
+	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
+		 struct iommu_hwpt_set_dirty, __reserved),
+	IOCTL_OP(IOMMU_HWPT_GET_DIRTY_IOVA, iommufd_hwpt_get_dirty_iova,
+		 struct iommu_hwpt_get_dirty_iova, bitmap.data),
 #ifdef CONFIG_IOMMUFD_TEST
 	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
 #endif
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 2c0f5ced4173..01c5da7a1ab7 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -43,6 +43,9 @@ enum {
 	IOMMUFD_CMD_IOAS_COPY,
 	IOMMUFD_CMD_IOAS_UNMAP,
 	IOMMUFD_CMD_VFIO_IOAS,
+	IOMMUFD_CMD_HWPT_SET_DIRTY,
+	IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA,
+	IOMMUFD_CMD_IOAS_UNMAP_DIRTY,
 };
 
 /**
@@ -220,4 +223,79 @@ struct iommu_vfio_ioas {
 	__u16 __reserved;
 };
 #define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
+
+/**
+ * enum iommufd_set_dirty_flags - Flags for steering dirty tracking
+ * @IOMMU_DIRTY_TRACKING_DISABLED: Disables dirty tracking
+ * @IOMMU_DIRTY_TRACKING_ENABLED: Enables dirty tracking
+ */
+enum iommufd_set_dirty_flags {
+	IOMMU_DIRTY_TRACKING_DISABLED = 0,
+	IOMMU_DIRTY_TRACKING_ENABLED = 1 << 0,
+};
+
+/**
+ * struct iommu_hwpt_set_dirty - ioctl(IOMMU_HWPT_SET_DIRTY)
+ * @size: sizeof(struct iommu_hwpt_set_dirty)
+ * @flags: Flags to control dirty tracking status.
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
+ *
+ * Toggle dirty tracking on an HW pagetable.
+ */
+struct iommu_hwpt_set_dirty {
+	__u32 size;
+	__u32 flags;
+	__u32 hwpt_id;
+	__u32 __reserved;
+};
+#define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
+
+/**
+ * struct iommufd_dirty_bitmap - Dirty IOVA tracking bitmap
+ * @iova: base IOVA of the bitmap
+ * @length: IOVA size
+ * @page_size: page size granularity of each bit in the bitmap
+ * @data: bitmap where to set the dirty bits. The bitmap bits each
+ * represent a page_size which you deviate from an arbitrary iova.
+ * Checking a given IOVA is dirty:
+ *
+ *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
+ */
+struct iommufd_dirty_data {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 *data;
+};
+
+/**
+ * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
+ * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
+ * @bitmap: Bitmap of the range of IOVA to read out
+ */
+struct iommu_hwpt_get_dirty_iova {
+	__u32 size;
+	__u32 hwpt_id;
+	struct iommufd_dirty_data bitmap;
+};
+#define IOMMU_HWPT_GET_DIRTY_IOVA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA)
+
+/**
+ * struct iommu_hwpt_unmap - ioctl(IOMMU_HWPT_UNMAP_DIRTY)
+ * @size: sizeof(struct iommu_hwpt_unmap_dirty)
+ * @ioas_id: IOAS ID to unmap the mapping of
+ * @data: Dirty data of the range of IOVA to unmap
+ *
+ * Unmap an IOVA range and return a bitmap of the dirty bits.
+ * The iova/length must exactly match a range
+ * used with IOMMU_IOAS_PAGETABLE_MAP, or be the values 0 & U64_MAX.
+ * In the latter case all IOVAs will be unmaped.
+ */
+struct iommu_ioas_unmap_dirty {
+	__u32 size;
+	__u32 ioas_id;
+	struct iommufd_dirty_data bitmap;
+};
+#define IOMMU_IOAS_UNMAP_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP_DIRTY)
+
 #endif
-- 
2.17.2


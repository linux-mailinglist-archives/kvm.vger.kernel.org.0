Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20F230E43B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhBCUuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:50:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhBCUtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:49:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113KdAmk067581;
        Wed, 3 Feb 2021 20:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=2ZreSZ/bhNS5lb4e8nZsVdrMkQw3askAFxPJQlHc5xY=;
 b=JY9cJI9ZkFlN9vNaSl5K35lgzV+ZpVH8Fh9Gp+LeINbZFLdhMsjdA/bKn1jiE4YpS6Vt
 zcO7bYWKC3zq6mHbK1M/gw+8wmUe3FQU/Wmw/NNACE4moitw5d1ybc2zJ0mYEuwy6MX7
 4TD743/I2dhEP7GucAZ3PG3vnvambPt7WIpY18D0JCS9VErFZl+88i5ErNGUxmkqzEdJ
 zNxcdEbCrUviZY5olotqWT8DngVjOx6tozz2oF+V89ITEWgYSPul+/ubeHXETpbMKPQy
 lZGKN1UCO4ycsljJf34rqQREtBeXvyTEVXiIjyu6EhZuAU2Dd3jgckHGZdev2vj/GrVT qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36cydm255k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 20:48:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113Kj3ic135633;
        Wed, 3 Feb 2021 20:48:15 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by aserp3020.oracle.com with ESMTP id 36dhc1qb23-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 20:48:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5Kdgr09DIzhzZtj2qzlMI1p5qR2jGugM1C+DT4ByWkmQpUqfzDM/VEXD+jrjvF8UMHY8uMyB0l95OC2RAROYRFK/TP017wOU9OtOfUNH3Q1XAcu3imr6NDexbMQHcr5KlYXonzXBuDupbJw3zLpM0ICLWooYc8iYQRJMGoS3qli/vhFPYjrEidNhz3kbTN65y+uHKl/Foz0ZMPYBG92XMtJDcAANwwQNHHDugXi//U3lMT9daWADp6DhXmTabIwGJoDpFWbkw9fB5ZDFEjo8h/tf5BpAEdGNza0tL389QbxqakZHXxfW1Q774/EiX/rs5ELsQPQ0IG/DGDw1+SZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZreSZ/bhNS5lb4e8nZsVdrMkQw3askAFxPJQlHc5xY=;
 b=DJujVk7QF6Ttnulmezs86K7yO3wNYux8OfhkxubUEq8IDa88F3lOmrtLICfHAT8kQ5vlZyq2wQpgLz+wn7dqFUTObO1Je6JKhePBBAwXLyD1Ox2u/MJpZ0NVvTAv7WmudWp+l6EpPZB3nPH3s781rp1uym6E0orXqkK5SlStdFB2mY0zRuw/r7z+HYIa+8pg5daWkvNVuiy6GLpSA38946nHBd+vxpTU6Zse/9fDuVAm1FADXbiDEwfbYTN5n3gGDqXrDPTaQcPU4hJXES/4H64+c6vUhTcoGCI+j+RoQPiWWZtM/c4rMWRGXvDBllDazxAPiE8Pinln6U7RGcrzNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ZreSZ/bhNS5lb4e8nZsVdrMkQw3askAFxPJQlHc5xY=;
 b=JfNiFdcSU//+HJlXAn13tnhjnXYkekikegIwsdwAovBA/b0kiG4HFTND6UtNkc6IDDaGLgSa61M5A7XU/VbsMsO3C4sK+1DhuXwhqXvh9i35e3TPtSzEXXn12SRB5oakgUttPeQfoTITxwKAANp6MzoSBHqxQBVkzwl1PTXfbio=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by CO1PR10MB4691.namprd10.prod.outlook.com (2603:10b6:303:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 3 Feb
 2021 20:48:13 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 20:48:13 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 1/3] vfio/type1: change success value of vaddr_get_pfn()
Date:   Wed,  3 Feb 2021 15:47:54 -0500
Message-Id: <20210203204756.125734-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210203204756.125734-1-daniel.m.jordan@oracle.com>
References: <20210203204756.125734-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: BL1PR13CA0215.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::10) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0215.namprd13.prod.outlook.com (2603:10b6:208:2bf::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 20:48:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee5d1014-c7b5-4aef-a5fa-08d8c8850645
X-MS-TrafficTypeDiagnostic: CO1PR10MB4691:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4691799EE6A0DAA786198AA7D9B49@CO1PR10MB4691.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KkaCzmyKD1VImfgJpF8lqFm+7gARO33QQgvfFFPt7h5VsKQt9ZxEz6q93+/uYxUg9vHvO7W1h6NgAGm5E7w9AZRcnBD0ez0C2GAQIwvPr62Fg8wISq7ecXXeEvjjKUmy75TNgQublPj9HYFEmv874wvIPNjrM/lSEnwWaNY2ImI4NRikNxPVuqL7h1t/W4ehVlqr4i7VmZWyUsKo/oDb5vY5BHQ+Fl576IYBWKJ7Z0nU5w2x2YRQShQ0VGf4cqdpGeU8VbYh9nH4JTLiXHKhxRE48ps4GOqMOW1bzlG3eMKlMPfS/ACrt979pvI9qkVcjVGNzHoDMEVVWbxTdlSet0GVFvWQQi3+HBu035BhYaN5Aa1/V0mMbKI04whhtOlD30okcMq/SZmwgQXY6b4mCKCcUUQVP0M4+7qi5gCBDGnT+B758GJe90Oa5oXX4npbhErWLGVwky3fQuIEhzrZcD6/CYV/9p+MQIZnPbWbSZbH/k/KdUNRX/VVTsW1PhdjD7FOG9klx4bbYQr8wCcD2YUAFBAIremNMzldq5QMn5Z2YY0hyrDKTN/MzX+OyipyKbCPLeTyM00YmSHmkK7GXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(103116003)(6486002)(478600001)(36756003)(107886003)(4326008)(66946007)(8936002)(1076003)(16526019)(5660300002)(110136005)(54906003)(26005)(186003)(6506007)(69590400011)(52116002)(8676002)(86362001)(83380400001)(316002)(2906002)(6512007)(956004)(66476007)(66556008)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lO8YnXDteBPPAdDc7BCpABZ2U/MOoQpVMguxnpOc47mAKgNO3W0zJr8FHTXU?=
 =?us-ascii?Q?SI8E8fask+Su9KvX8N5ZceKQB7qzP4oL6bSAu8VO2pMpDub2X2zyjCs5FmT4?=
 =?us-ascii?Q?D3n6Fd1D58bcotLac/CMkcIkQTckSmVjaH+0llRMUAc6kveIGR+4i7fM+jWt?=
 =?us-ascii?Q?a11R0obtVIlVyldtBY66O/VhDPjxZEjW1hUSXT6xCtAJEh/g+qAxFN9JmCK2?=
 =?us-ascii?Q?PyYEx3MZOXkqGLvpow0tM4BAlX0O0RGhT5iehrzXEmbXFV9bnNk6Otc2yWiB?=
 =?us-ascii?Q?JX/aOJKsNpqaPmQkypTP1NbdWIhWZZrMaS8gL+lwJtJiogmUwWlMsObOIyFo?=
 =?us-ascii?Q?06BACMPp2l76raVku3HYm5MuyTHIRzv4d8x5vcVKEe9ANRVIAE++zaIHwNhl?=
 =?us-ascii?Q?ZhAApVS1J4BFWwIPfoAxna0tpBSCcXH7JNrmxcE+72n/KCW76jmWVBeygIEn?=
 =?us-ascii?Q?+sb/nKp/UD90hemSAsm1c6Uix36zEwRluqCYLXurpbBr0mXBlrhIueoKs9Ic?=
 =?us-ascii?Q?IaHRHPEL0ftDG6KjzJ8l45hyjJhvffwWVNcpuHRxBOGStp2+XMNibLj66RfH?=
 =?us-ascii?Q?4aQLLGVG264IMspavZhyA0FUszf/GdK9IhhJgDl1foWdYmeMAi8oljHfoZyI?=
 =?us-ascii?Q?EDOJCbrEIg5H9LFtVxOiBN0xSNu9wIKzZNNZUtfl0bA8oeEdAtRi41NjEsDN?=
 =?us-ascii?Q?ElJ5vo4nvY9CKSv/DuFWtnyBZyXKe2jh8T6KzgqNbgcKaXCjPA7ZjNYSpw33?=
 =?us-ascii?Q?6HzN3lUKAsiBtYfDcR0Nb2+Y5bCKE+Qiog97yuSEe66XymJE0/XoxGnsYybe?=
 =?us-ascii?Q?tWQbQhw3hkmU7MMj6hr/ShNNDWsmc/bHgs2jPpz+namhz1csgcXwZWtj1hTZ?=
 =?us-ascii?Q?Y2j+mH/GTEe0LmjN83sO2fbYNkfAwyRGPv7bwQsZLaVRaz1aMLfv5RBx9UUD?=
 =?us-ascii?Q?OlKkFM746q+i+YyraNJOFfdDyEL6tnYq5LwFuoC9MtpWG9ER2KSdccQqVglz?=
 =?us-ascii?Q?S4eoZ1cNjXXc8xd/LkZG/RilFViAHdumFsCYfmONwgCRfwQzWr2z2G2wGAPJ?=
 =?us-ascii?Q?6i8nsRZnMKd5IiplyD7PoVRMchXAwXeAFiRMU6WIpdkhRKqPxKj4V//X0Jlp?=
 =?us-ascii?Q?wtrAraCEPouoU0nAQtvkw5asqVInuauBVNI9EOTr5KKT4NeMN9h5I74W1uyW?=
 =?us-ascii?Q?OR80qNlQJ+9nGsnd2H/NzlPdIq7UEnQUDsuUGFZ2cRy+7zYzv5IJowpsvfZn?=
 =?us-ascii?Q?/T9PmRvII/AbkJ0XkZkYNBUcGkhzrwvsLBUtSbPg5cCCPPpKwBXz7UDq4XRU?=
 =?us-ascii?Q?SLZg+HfRNO+LN9paTNgIKta1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5d1014-c7b5-4aef-a5fa-08d8c8850645
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 20:48:13.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8l08Qz9uiQyo4BceVUPkMh6kPS5WT0y7/JFA5s61g/Dtw3UOU1yw+6Q/hKEBkM4wWF7TiTIa7wrE8cMMiGQqacP2rwePfM5ROzn7qBxXaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4691
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030124
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vaddr_get_pfn() simply returns 0 on success.  Have it report the number
of pfns successfully gotten instead, whether from page pinning or
follow_fault_pfn(), which will be used later when batching pinning.

Change the last check in vfio_pin_pages_remote() for consistency with
the other two.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4dedaa9128..4d608bc552a4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -441,6 +441,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 	return ret;
 }
 
+/*
+ * Returns the positive number of pfns successfully obtained or a negative
+ * error code.
+ */
 static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 			 int prot, unsigned long *pfn)
 {
@@ -457,7 +461,6 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 				    page, NULL, NULL);
 	if (ret == 1) {
 		*pfn = page_to_pfn(page[0]);
-		ret = 0;
 		goto done;
 	}
 
@@ -471,8 +474,12 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 		if (ret == -EAGAIN)
 			goto retry;
 
-		if (!ret && !is_invalid_reserved_pfn(*pfn))
-			ret = -EFAULT;
+		if (!ret) {
+			if (is_invalid_reserved_pfn(*pfn))
+				ret = 1;
+			else
+				ret = -EFAULT;
+		}
 	}
 done:
 	mmap_read_unlock(mm);
@@ -498,7 +505,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		return -ENODEV;
 
 	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	pinned++;
@@ -525,7 +532,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
 		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
-		if (ret)
+		if (ret < 0)
 			break;
 
 		if (pfn != *pfn_base + pinned ||
@@ -551,7 +558,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-	if (ret) {
+	if (ret < 0) {
 		if (!rsvd) {
 			for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
 				put_pfn(pfn, dma->prot);
@@ -595,7 +602,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 		return -ENODEV;
 
 	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
-	if (!ret && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
+	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
-- 
2.30.0


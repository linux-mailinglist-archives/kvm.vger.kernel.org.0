Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F78A31FCE7
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 17:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhBSQOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 11:14:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60424 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhBSQOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 11:14:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JGARu3064502;
        Fri, 19 Feb 2021 16:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=I8Eue09ui4c6W079IE76+/dJP1KETRcPp5O8R310Q7Y=;
 b=ZzKt7nWQr2voo4GyAiFjwJ9WbCmS3nl4PLdp+F44lFt1L6vRNelYlSNmlEM6Ai2algno
 g9kxM5rM15GBpAnI3tuh7XdVl86Bw7SZsbBE/sSOAo3i5GWHn+vjC+ObPQxoS05LMywF
 pukWaJI1rtvicO1fFppE7pcEAzfF8FkzyHXim3qLz1BGpA31bZdSdnc4nt865Pvfhr+U
 r0IZBctLt0QdtxVilessjziRR+FUB8NA2kgAeyAaqpnQahc6bC5JADF3Ri7eMnWUS2iV
 0mIF3ojaQnyuC7OKwocWANcPKze9AtZrBi3cFNSUmaSKcNrmj1gt8xDXbQFTJlfGAS72 oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36p49bj6ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 16:13:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JGAWwP166919;
        Fri, 19 Feb 2021 16:13:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2054.outbound.protection.outlook.com [104.47.36.54])
        by aserp3030.oracle.com with ESMTP id 36prbs9rm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 16:13:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlxphXNDtnPFdznuchlB36iJ3M8/wZn+gcHa1UemAe52fV35T7cQRZAkLCAg75QmRySWbPn7Ki+S+s2mLLVxYVRSGyVQQnqPtKP6FTVBGaD85uiSRxUUT49kj6axFLt2g/d3zOcipCukxPeEkEEUP0tJjJds4aTgQK5SPdXmcjEUps9GuAbQObhwu/nvE7l3sH+xaRJf5/95lC2o9xw9BfAaJ94AlkUe3LQNy5xJpnc3RHvxT6g5wcr1exDeFcskXULKB1vnxJOrvTFx5TKidr2Q0B1rWULHkS5ahgDGr8euispabCz5/0Ll/0EuxS8xRknZwoeaUOgzuY06VeyAxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8Eue09ui4c6W079IE76+/dJP1KETRcPp5O8R310Q7Y=;
 b=cpP3TFknoHN2knVRQcpN7W5JNVx9u5L4Pyg6zpYfZJWCbZ9Sl7fySc4VOJfB6xvBOP4JCwdo6FUHE0mt0ztnPtCpdm922Jyv+SIPteVsaxgaA6bkejfvNdVnm1z3AlVN/kz9Tj5FEsg4hZJvsydKiSqIh6Rncfx2vnFIPiQ8nkTcjq7jVQVW/XnpOx0gNlvkJnbrUSVtk/Rz3TRUBdSLD69C+6JjkM95Sjtq+K/R6VRHg0wVr29iM6fTDVkHiMfOaXL34tNDzB5l9vlh6AMO48k36e/W9OrHJKkttntpfRqHD25Y/ZgRqej36syMgser/99oeblqUXm8qcFR4Pv+zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8Eue09ui4c6W079IE76+/dJP1KETRcPp5O8R310Q7Y=;
 b=RGPldKZGB8ucvRPR30QqHGFp3IJO41CXwpYg9tEQ4vEG2q6IkVVT1g5G3xQeLKqEwj8FhqYEp3hybfB/eAJiYAvfSmyNV5y0lh93XqBZLlne+8s+28xfEvOHrtMWB/IKMpxed/ViTg5kDKOhG1aE5LBhxX0QetbB0lVdEJY3Eeg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by CO1PR10MB4595.namprd10.prod.outlook.com (2603:10b6:303:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 19 Feb
 2021 16:13:21 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 16:13:21 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 1/3] vfio/type1: Change success value of vaddr_get_pfn()
Date:   Fri, 19 Feb 2021 11:13:03 -0500
Message-Id: <20210219161305.36522-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
References: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: BL0PR0102CA0052.prod.exchangelabs.com
 (2603:10b6:208:25::29) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by BL0PR0102CA0052.prod.exchangelabs.com (2603:10b6:208:25::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Fri, 19 Feb 2021 16:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fe5d379-5006-49b8-a91e-08d8d4f14672
X-MS-TrafficTypeDiagnostic: CO1PR10MB4595:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4595623BD680EA740A8FD9A0D9849@CO1PR10MB4595.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLEno0DV+1HhyTeqDjM0JGFzGdFkqLuUuRBcws0Ks49nSQjj8yX841N2kQLNp3Yfq2mSBMHAhOsBSgLpJjedd2Zbqcbbxjli1bLUZLO0X9PH8vqcmpHcRY+k53uI5SVL1DP32ob4CXxCWvTYmbK23ET9BObjZYphmOSA3bOlK/6n/78dIQWBtQTPqktKP7g9so3U5Fcd8Fk7uJY4s4VcE28zge8jaqqKOwP6oPlRe/JE1lcUWeC0KMbxxb2Xu8kaOPBiTEcUranGbULzT9CDJIaBEHCP9jFjULJ7oh3/eY/8tE64SaiezKG28JESQZiXo7RaAsVxPUVPhB5Jhq+xWDLH7E6SRyaNvugYmm5v42yQI25fINFrpDpNyNrii8TaTkIcA8nmPAinGMHhx5q6PP+J7q5MvwIsEOIr9Yl397tFC22aOet/LJzbEFgNj7DrDo0P5LKLgA47sds9kafMc7TFB9TBwcTDEr8WYAH1PO0L2X2+zwx6Ul4xoZof6LK9bwGXaZiBNqQkhYtvqldvWrziWv8l3RaD5qXC6tLUDIOABq+V54s2O+YCy+/1KBsm7m2jQ0CimotekvAEBbhWLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(39860400002)(136003)(2906002)(66556008)(66476007)(107886003)(6486002)(66946007)(6506007)(16526019)(186003)(6512007)(6666004)(4326008)(5660300002)(26005)(52116002)(36756003)(316002)(103116003)(83380400001)(54906003)(2616005)(956004)(1076003)(8676002)(478600001)(110136005)(8936002)(86362001)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pdspbllJ6YUI2I3pnWFOSrnKFvs+oIArT7HDQBVPPwmMgb1FM4mT8m9Q3zC7?=
 =?us-ascii?Q?vqiN191R37WS8slEg9mHy8jQXg3Pxhg7a6MOiHpA/IQDpk9L9ZRjHElumtPB?=
 =?us-ascii?Q?6PFCvEao25882coujMj7E51wc7Uoq+UiKQOM6Yph44Gk+13vtHU/jMteZ3kV?=
 =?us-ascii?Q?JUlB7ECCalOkJgr5eU+eFsyKkPZ6MGN3Sow2HuvaZ1Ksc5YpU3OMGuF5+LYQ?=
 =?us-ascii?Q?J/WdCSqU3CetytWxWIqevna1Z4iHcFppKIHA7pC6QiW+AXPcuEGHt1wx3tJj?=
 =?us-ascii?Q?nQWR0zAbMuG5k+CfkEsf5urwME/BWXfCopujWmQHzWewLFLJnZnmYoHg4h+j?=
 =?us-ascii?Q?JJiGfHissKRm+60XVy7G6kimO5ptlwZoLi2+ar0fhcZFsffnXwwkmx2VTrGv?=
 =?us-ascii?Q?D2kAsAx6pKw4CbrTIaWKuu/+MEFu4C90L1+Sfw7x6Y6YkEckvnB75uUV/d4z?=
 =?us-ascii?Q?hbE8SY7BfftIy7TecIld/bOAat1u21RfMfmFb47l9eJOlhKh55/npzBBDYEM?=
 =?us-ascii?Q?e2d0pPtj/RiN1jGAWeN/KUZX4B1WmIpEARFxm9Jfm/Eb/Lwk/l0PlUmy7j6e?=
 =?us-ascii?Q?rSpbECZ5ejYOYm31mmU0eACR+LIwEettJfYuWBjAph7HKQvsjmKHNsGu8jRM?=
 =?us-ascii?Q?mMohN4xTJ31+toblvzVERJ6znzEb7NH0PLnXTyYFc74zScNjBG8DnxtV2nO1?=
 =?us-ascii?Q?JysQg7HDR93f/stsnb0VfXHBLSb4VNsWTBbR/3HYR3UBSxYLwXXWLc7EEsfI?=
 =?us-ascii?Q?LOAIsY7IJRSfwnLfDFxK7N96j+tyvWfevAhU40kSV4SOXnbSf84VXl8bGAoD?=
 =?us-ascii?Q?BMUFLy8R92VAsi92xYTnJ8f5NqSZzaiITjdcPJoIKPspYeWj1mzuLVD+7V7h?=
 =?us-ascii?Q?YyJgOvOcI5bRRrmgEY5twXGtSZ/0gSAfpogk2T6IxDcxd4lI5P9xRZ9KqVpq?=
 =?us-ascii?Q?wCOD9O7lGVc7TGjGbcun/YxSeUrco6aPLtudGrZN9F4f802DrWdyLE3Tbok5?=
 =?us-ascii?Q?IEzAkRcRGU8k+1dvnWscgAjw8YML/XSyovWdxqn4xE0V//h+U5+hY5m5OU0R?=
 =?us-ascii?Q?CyWvVBislHw0HYk6/HAZUY7pxUD/D+KKSbRgqV81KOCVCAZgLeulKiyIBn+4?=
 =?us-ascii?Q?jnZa578lMnHujYl/r//u5kDr7d9uY7mnzGehqOSH37Aq6JbRCu81wI7FA/QM?=
 =?us-ascii?Q?D8eG7d4SKTZCLWANy0k5cRte10z4+vYWvCbHs6++p5lCDR/q3X8eSa27FLlY?=
 =?us-ascii?Q?DA62t3yuzdKPPp0WVPP6WwA9vf2viegYdzOBuL3B1+UssFjrpbbfoWKTwDQ5?=
 =?us-ascii?Q?8fPzNEnhkcs79ek9bibePDlR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe5d379-5006-49b8-a91e-08d8d4f14672
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 16:13:20.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wev8dRjEYgRHkvP9OaDTwHm60CgRXfkbsa2EGS69l4cn+o5fXuDokxBqrRq8ETYI3w9cE5Ez0tqzN0tNeUjyyxZ4E0QGSaPwDbaRz86INwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4595
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190127
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190127
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
index ec9fd95a138b..7abaaad518a6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -485,6 +485,10 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 	return ret;
 }
 
+/*
+ * Returns the positive number of pfns successfully obtained or a negative
+ * error code.
+ */
 static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 			 int prot, unsigned long *pfn)
 {
@@ -501,7 +505,6 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 				    page, NULL, NULL);
 	if (ret == 1) {
 		*pfn = page_to_pfn(page[0]);
-		ret = 0;
 		goto done;
 	}
 
@@ -515,8 +518,12 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
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
@@ -597,7 +604,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		return -ENODEV;
 
 	ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, pfn_base);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	pinned++;
@@ -624,7 +631,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	for (vaddr += PAGE_SIZE, iova += PAGE_SIZE; pinned < npage;
 	     pinned++, vaddr += PAGE_SIZE, iova += PAGE_SIZE) {
 		ret = vaddr_get_pfn(current->mm, vaddr, dma->prot, &pfn);
-		if (ret)
+		if (ret < 0)
 			break;
 
 		if (pfn != *pfn_base + pinned ||
@@ -650,7 +657,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
-	if (ret) {
+	if (ret < 0) {
 		if (!rsvd) {
 			for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
 				put_pfn(pfn, dma->prot);
@@ -694,7 +701,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 		return -ENODEV;
 
 	ret = vaddr_get_pfn(mm, vaddr, dma->prot, pfn_base);
-	if (!ret && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
+	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
-- 
2.30.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41BD3F23DE
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 01:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhHSXyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 19:54:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2642 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233972AbhHSXyr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 19:54:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JNkH2D012599;
        Thu, 19 Aug 2021 23:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=bhjxAZ5P+bzBUsSJKq2APgMuCkbOsayAgCEXev1Q3tk=;
 b=ERCQkw2DkdChiMaJG0U+zMy1yhWR4xq3XVGA8qawU5naFRBAorv/URSlv7C5gyYLuUnm
 uiNKbax+bfmEOc+nDsZV5v7LYyXoUldVqRxoa350kwvtCgVIS0/8B3dWsqHUEaeW9puI
 mOsoC9xpQ5BfJ45tklK8eSosbquI5siF2MMCRQ8OjyctspNdoh30gVm+mqO/snbV+4Hf
 NhcKJJ3X9hZsj384ivHwuZOQopKxydvGJwTfafpbE0QP9E/n0P7Qo0hjnQrzq/009Rm6
 tvhNJS+quePhCamU9j+vddY/I8Qio2z+H2Mf/hqFo52keCCS7HjwTWVB5gJTv6G+jKQK lw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=bhjxAZ5P+bzBUsSJKq2APgMuCkbOsayAgCEXev1Q3tk=;
 b=o4S6EhSgUrVXSb/poz/qj6aHR5WxbV8CQwSqhWwPdHOZU2Lp8aq18Vv6ckwSTOwKgM7V
 59n6SEVsJjaWZSyH3QxSZuBHSgElia9TojYjeCvH3JlcFW0vBGvjJ48QYCQP2cccBb9C
 Wbb4dZTsdTrnyLBPca0r/8UJ5Awux5ATD/HxSzh1ZdA5VBmNTz7SFUtJv0UtysGKGRh+
 vPNklKTdeB+ne5BcTKALY5ftMEmXmSO3uDI48TBliWjgoxVsQ33FzyQtW4U6qJLLUqPm
 DbsPoMUGDhkl34lIJIb0iouv4uaWeXwvILZ/NgYf3kSUGNGwFpY6zkiEw+1wkKoIkKj4 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3agw7t51cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 23:54:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17JNiu0M020308;
        Thu, 19 Aug 2021 23:54:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3020.oracle.com with ESMTP id 3ae5ncgfen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 23:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m93J/VY3dAy1/OmOCT8aeUWorJOnDnZ/z3ZSvr8MWzVCdXsviCx8oflrtgymuYwBRLW58nxvDYWPjLQiowyQjIy4JnFnIPNuPReuzf5FG+PmNWyOL8t1rxK4tXPo4sLGVjBNeydsJuWV8/vT14gDsuur8o9FTPAVuBrdoSbJ3y3kG6ls6wVhTH5jxIvI5knf50MxzbaRnTVjSkRFnmW+dkc+U2ih4COKF/yBGl66M5bh1FAfFVUfXxgVLxM7F92okozpsRLgY1qASqyuBB0P+LrS/mh4YhwnEZfvUSnKBn/QlWAg5R+AS3qtIdjYRCPH5XIwPaTmdva38N2LGNlC8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhjxAZ5P+bzBUsSJKq2APgMuCkbOsayAgCEXev1Q3tk=;
 b=DEBQ66HiFdkJztzKPiqrHSm9fJVmXTfuzinFEu4O2+UgZmP/Uyw8HPJU7Ui9h4j6xQNUyWJMhI8PIodO2mobgiv0pQ5YfL5ZKgymuWvvdmGXUw6/Rk2xQMvxOjTs2VG2j8OrIM4MD2XKrllcMaTcBDJ9gEv3oGbTYPBAFPMvMV5C7jUzcReaMQycDFj7hGuT7PYYoQGeTKzuXBelwCam/bsXRuvchOKLsu1dr5xvu004tW8ztfaeoCQIn9SO/V0rEPM541jwBfVwMIaRyMv90dl0cIhIUS9b+OBJVXwFif+R5F4CvY6TQytq7TT5LEmq0e+d47Cj7IUymdlLqF0kWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhjxAZ5P+bzBUsSJKq2APgMuCkbOsayAgCEXev1Q3tk=;
 b=BP/DOp1YOObb++3tgEQt9RZe+tEg97HqvaJG8rQXWtjqwMlPKdZAqn7fYff0Zn9JfpgHnmq8i96FpICoc16biqSAtzMuiwua68+sO+lVL4v50EVlOxHRSrMsVoVg8MdnnLaAQ2arjzPIzAyJ/WN8SWx5y57OiofKnowwvCncbbM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB3533.namprd10.prod.outlook.com (2603:10b6:208:118::32)
 by MN2PR10MB3135.namprd10.prod.outlook.com (2603:10b6:208:121::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Thu, 19 Aug
 2021 23:54:06 +0000
Received: from MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547]) by MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547%7]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 23:54:06 +0000
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, steven.sistare@oracle.com
Subject: [PATCH] vfio/type1: Fix vfio_find_dma_valid return
Date:   Thu, 19 Aug 2021 16:53:57 -0700
Message-Id: <1629417237-8924-1-git-send-email-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0191.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::16) To MN2PR10MB3533.namprd10.prod.outlook.com
 (2603:10b6:208:118::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-qasparc-x86-2.us.oracle.com (148.87.23.4) by SA0PR11CA0191.namprd11.prod.outlook.com (2603:10b6:806:1bc::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 23:54:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0828a191-8bff-47e6-af7d-08d9636ca0eb
X-MS-TrafficTypeDiagnostic: MN2PR10MB3135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB31350917FB5BA9D9D1DD8026ECC09@MN2PR10MB3135.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e57H1jWOlw/uZlYr9y4KK1+FgSws8XSLbvWiJ2IdeNjq90cU7aEFtlYHDi4cn1Fh9m/503F7HKY6H8sJTLEl69OM1XI4NfwUpmDOSY0Gzs0yWiAAisU69vLRs0pot3sb1AhB3fcXXw8QyjSvYEwk/W3qvShdNpY4qYTxYOk1DoPxcFHI8xHLW3dvLsvOHoZ9TZEiJ2Z8yRb8/zrxJb0tQJbLMwcGG8ajrd9f1Piwx63xaF5wAYYcdPmy9JCyK4KpAfUz19rbpfw5H5hIvoP0qGl4p7gG2/vO2GG34EOYDsUxVwxKDl1k+qcv9/l2xnRXLZP41jhPzRSs1AOVoVG6D+c/6600nxDORJgdrSnxRoP6lg4fDAQR9cem85Sw0f45ivx6H9ss0yGw5BdchOWysNnVRjJmawtYHXqJ4vg9SgyAm1YxXEMAoC3hKBqKeGvFgQxxu6iFTvZ+C5pcwgoKFltDaIg0ovj7QUAdVDZnOwrW49SgICwKvp4OCsFohKS9e1jny8I02zdkYC4AR30x72epJKHz3QNo5X6Wz4LhYRhrg9BU1UUZJf0uPPVEugo+1UFXDljYsZwc1YEkz4w+hQl7cbRMxp3Zf6xvrgyhUx1LjMl8PGK/3ieHP+S5wlBbKbck2jQSISPY2xiSgYEPhx7llP6yCGT9PXwfudrabVS3j8+hOsiY3xursCyqeV3HKpDDefu/75LdtJNP6vsvYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB3533.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(376002)(366004)(107886003)(4326008)(8936002)(36756003)(38100700002)(52116002)(956004)(2616005)(44832011)(26005)(86362001)(6916009)(8676002)(186003)(2906002)(66946007)(5660300002)(316002)(38350700002)(6486002)(7696005)(478600001)(6666004)(66476007)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l+zS/rpa/NcSJJl76ikpYEgZKH1PWs+UqvUukbJZPBenjHpLai8FEauWuCqQ?=
 =?us-ascii?Q?CuTDC011bwgNIKlYEa01YcumD9nfpjr93R40sPHifNQA4PyCcrvDEiCxD5k2?=
 =?us-ascii?Q?ub8pfRAu1F4Runlrt5c6oichRliIPtDixfYd1i50C/tVmVKjJKmf0tjeBon1?=
 =?us-ascii?Q?cf3OfOmVouERMKfDOLKmBnGiJgk++9d72Gm/21lmdkuGnJsxz3YqIGob+htg?=
 =?us-ascii?Q?52dO/azhVqJNPkY554HOK4zwKRrhNHMDE0xJFTsS40EoZNxK98y5bgE+ldc+?=
 =?us-ascii?Q?4DKzDTU97NuLdEhUVxpjVwe/wWYz9Y1TRJlA0AyZNBUHv+4JH8h6SMyDgED/?=
 =?us-ascii?Q?y+dU2LFJQXSPCqA0vpLVee4AD/R9d6GgO7U0lQ+2y+5TECYNOKfzy9illDdK?=
 =?us-ascii?Q?BcMeLPUl9ks6rE47v6flnJ1hKfHiOuhKQ4N/M4j9yAbkRUnGGfErIFuzfFmr?=
 =?us-ascii?Q?rglzCoVpcToo/Ejc7yUmJVd/GcnnsLZGImhQ6yBk5vsDnZU8XmxxWPCUgUBt?=
 =?us-ascii?Q?OT0PyH/HcjzHMZZV+39w7FCTviitGUeW6+rGZ9SD1ZnxHmC+uorUyuiAHihb?=
 =?us-ascii?Q?evRa5L6MT+pJ0YgaL55E3d8V1pHhBitNpwCQypXmjUIknFnuLYqsQPVtIydp?=
 =?us-ascii?Q?b/plXt2wySmEGxU1MG9lfaPD4S/XJKEz5xfETEt9SCpNIpc7UCQi1xrWKP0s?=
 =?us-ascii?Q?j6UXBTjqOhBPODY5SOeQdwQeZsPls6l8mvAukHpJkl+il70mCPoSTkIVIWpE?=
 =?us-ascii?Q?UbJ29d4dNQcPO11U34n5yoj9VkY3xCTIvQosaGwjrtNWERuJ1iVrrl9Dqfbq?=
 =?us-ascii?Q?jHuZYNcUrPzL0w4lui8pYr7HCAmJdCLxIdt6GNIyNjQqbdIHiOK6h5VcM+7w?=
 =?us-ascii?Q?yB+AoFGOctB8A4v3ifVbQodccrwNJxcF+j8sSIABQSfjWew8la2n3VGi5Dan?=
 =?us-ascii?Q?fYpiaGNnqOZ/zOnLkFYOamVrd/tmyyDUkQafj4QccT6jfC5rVz5GNja1wNVp?=
 =?us-ascii?Q?c51atv9BugzewQrLzfY4TlcFl24SzgotDbULCIyxzud62SU29OeqyI9EsFkI?=
 =?us-ascii?Q?BdUGcQSFcRj2GtERdo4Ay/4SLyfmK3CsvavR8hT/2Ah0MZJ+SCUDCwbbtkZ6?=
 =?us-ascii?Q?sn+O6r2Iar2iFA5/PeNbathvkFGJG5F0cJM2AyiHStague2wCUS78v/laJKG?=
 =?us-ascii?Q?1J2lgnwpG7nAFuntt4/LH3EE+7cZy1Edccf3YJskoGI5Ob68q5G9BEZyHBhX?=
 =?us-ascii?Q?bJvQ2z+IO1PZh6y7wNmvxeoY5WnO8SNVW5HlcEl2uhpIXPJTReoZ/xcsDpnI?=
 =?us-ascii?Q?YQj+N14OFYaSeM3TfKvUVKWV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0828a191-8bff-47e6-af7d-08d9636ca0eb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB3533.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 23:54:05.8623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjiBz/kvHPqKpWER94MK9tZQlZ2rTztwCFUsO/3bPob07CyXWlQBtx0InskY0ql8vQ4lOYs8ZUY6lmbxgUvaim3E0Q+An37OPDCzdWx+BqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3135
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190137
X-Proofpoint-ORIG-GUID: d-RTGt9F3oOquEOIRtMluPQkRWJ0q0HM
X-Proofpoint-GUID: d-RTGt9F3oOquEOIRtMluPQkRWJ0q0HM
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix vfio_find_dma_valid to return WAITED on success if it was necessary
to wait which mean iommu lock was dropped and reacquired.  This allows
vfio_iommu_type1_pin_pages to recheck vaddr_invalid_count and possibly
avoid the checking the validity of every vaddr in its list.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a3e925a41b0d..7ca8c4e95da4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -612,6 +612,7 @@ static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
 			       size_t size, struct vfio_dma **dma_p)
 {
 	int ret;
+	int waited = 0;
 
 	do {
 		*dma_p = vfio_find_dma(iommu, start, size);
@@ -620,10 +621,10 @@ static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
 		else if (!(*dma_p)->vaddr_invalid)
 			ret = 0;
 		else
-			ret = vfio_wait(iommu);
+			ret = waited = vfio_wait(iommu);
 	} while (ret > 0);
 
-	return ret;
+	return ret ? ret : waited;
 }
 
 /*
-- 
1.8.3.1


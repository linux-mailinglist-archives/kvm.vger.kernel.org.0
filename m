Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EFF3F4E75
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhHWQgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:36:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:63636 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230154AbhHWQgq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 12:36:46 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NEXww0005562;
        Mon, 23 Aug 2021 16:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=wIbF/8z2UxNbpv5gbzVKP8tHlisq66hq/NGD5T5rEyc=;
 b=RlGjcIiy6DjJoLgymmpnLgOzFrqnKKkz258K+7T/oOESqq0ONzTX10pGnNIYaTeIoWNM
 ZtCnYVMtknWhKSbllWbZWgMxqE3UxQYqMCMQiJIVNSpsdlUiEDKI8HhB1bWmMxyW7JCp
 NuoItr83F1OLTugPuivqh9lSe3D/r87zaJ3tRj9aTBxJRim84+BNC3+mvY6LioZ278WI
 REDuKojuY3+FMZ4mEg+1/ONoY6YLysVNcbscESa3QsFlE/XRzwcFOcRXoygXodLxO7I3
 b7FKcJZdmDa+YXQRMEfHRndUloIs+mxSC20EUUZrya0+lEwZ7i8RRgi8zKOE4Ozexp9/ gg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=wIbF/8z2UxNbpv5gbzVKP8tHlisq66hq/NGD5T5rEyc=;
 b=QVn+WotdzVOfiW/m0SmvAl+yhTkVwylf0nP1Ae/0J9hCHexVzZ6OjZH7s1GnlMRQ7cIk
 +gF5yf/R1X/hrBW0E0hdPQlpi3t0ulZtcDW6B1oqmgi9AdaTcP2WoaDOMlq+7kZ6xTwf
 MoFfLvwRUYwUiqKOcjEJvgddiq1jsGfKuwfHmceYJ8wUtk1JLuyx/2P15oWSq0lj50KI
 mmWnGSkhYxWQ6bKwTj00fPrExtv5MYf6C8u0QkSuvGjs8t63rDjFhjfUpBjLo7YqszdF
 /IpNLEuoGkO0fQtfaJDDDBLHHWVdzVXM8iipE3ro+TxLaAHWPbB+C8FJQYhDkYvsidsl HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akuswj3na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 16:36:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NGV96k096151;
        Mon, 23 Aug 2021 16:36:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3020.oracle.com with ESMTP id 3ajsa3n36e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 16:35:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB/6gpvUyByZf9pC0FC/IomSCDe9LpAgi0CgM6VcxP942aKjg7ikqqU+7Wfk5nJpXdUV8zkwO5hoSIL50d0A7pwDpSkFbgg0zLlthEcYp4JyKOYBSbeqB6hPfQzQ13yEy9ytfdV6UuD71jI4Y9Tr7QpJJfoYhk3FLbeG/34psXYJfJ4+6BdRumn2u0mbmuW6HHjymZdqbsL5gBHUCf+sImwZuo7iUPPNdk7ZoIcciteR34bFsqe5yrz3xdIdPf6BrcqUROiGCA03PdAMC4+aCYszEc3bxIdZGgXTUu2EqjCIaQmbA4SSr0F0I3ZSgVdof940tTaOYgaiT7mdL4v1iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIbF/8z2UxNbpv5gbzVKP8tHlisq66hq/NGD5T5rEyc=;
 b=fD3sqLGlCoRv/tNxWcva04XoxXRD7jnkPS4qDoXp+hgsAzIc8AVgEDsWjGG+cGpK26VV6JTPc8vw2xxlYthaUOoNKoc1SFochBvqMlMMS77hp7gEVEngSXscyG7OORDy127hMO0IljEcbmp9RT6aspxaUioiiIqyqAq0ZO0QKS5Uo7XDvqTETWLpRNRZke38/ZeAjKPi6SvCt2+g+NJulVTG/5jZ5z/yE6aaChmzBnJWXcw6+CANH3lVEtBYEVolIPhEdqFVo4x0jiCJDpYiQlTsqOjRGQMXdYSwBBShT72ECXPhaA0pHAX0aGPV1jjYcrVZsGNYaK62upd8EgCuiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIbF/8z2UxNbpv5gbzVKP8tHlisq66hq/NGD5T5rEyc=;
 b=p0DeDD9e+57OEpWHgw2SHNGrf9NFnxK61TVHBO/9cRRBU1LHboAqTpiWu5glpO+aOK14xw0r3+F6NXhaidV/1ks7GulFN9tYYGgmgX5bRF1IOsmN00k5XsL2G0vzHcDQhOfhjaOgtu2qCB5u28Fmb3botrnAhcNuBpd/I4Be0Zg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB3533.namprd10.prod.outlook.com (2603:10b6:208:118::32)
 by BLAPR10MB5091.namprd10.prod.outlook.com (2603:10b6:208:30e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 16:35:58 +0000
Received: from MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547]) by MN2PR10MB3533.namprd10.prod.outlook.com
 ([fe80::b4a5:da86:b597:8547%7]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 16:35:58 +0000
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, steven.sistare@oracle.com
Subject: [PATCH v3] vfio/type1: Fix vfio_find_dma_valid return
Date:   Mon, 23 Aug 2021 09:35:50 -0700
Message-Id: <1629736550-2388-1-git-send-email-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0060.prod.exchangelabs.com (2603:10b6:a03:94::37)
 To MN2PR10MB3533.namprd10.prod.outlook.com (2603:10b6:208:118::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-qasparc-x86-2.us.oracle.com (148.87.23.12) by BYAPR01CA0060.prod.exchangelabs.com (2603:10b6:a03:94::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 16:35:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47ebc17f-a519-4916-c753-08d9665415a2
X-MS-TrafficTypeDiagnostic: BLAPR10MB5091:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB509139F1F1C0C179BD2077EEECC49@BLAPR10MB5091.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PnhMKXwdbwTxkEE4Yf0mwiMNMcCNF3VZTu1Pi0L5tNaGoNfDDWhyFWFmTVbSYqG7qRryXkpklFUX9d+o7gWym++eQCZVUYED8OPaExIpUZDlFAPGC3K36J7p++vGaNTR/4nKvgIY1FGYJT+ISCMhT8MJTfKJhwQ3fJOmbuEm+wePW20t6h6qD+UH8IUzc+vE3wq9xbG26f8d7mDNYpD8a4NcFDx7lLgAptUD2mZrjwZ1F6mdU22mHN+aSM6Kg8+duKnocZDRJYji8gaAG1etr88woXR4uxk7gDPD7v7EFwgAeFbA3HejTv64MJWrPumBiqNKd1xsXrj4ESaMP6O/2dDEBlhachuScY7wRlojzm2PP0iDpTDOjG9DvAZaYJKeylEBSP9BF4GTo7oaM2CG5l5QqOLOjLzQ3Lm1wfFDTfHrh8UJxc6TTa8qh0Ywuwq/SVUKRR7/t7nOOwxCK1qUFjJWZ3KOtB3yfYo3B5CB46vDFLXQv19ME+JdLhiEP0pLyBy/QFftrEpFN8RG7aCmkQJoDRBzvS4iC/Jb+wiURaS0ptGhYjr2ToVBKgeTChHLKsZhBKXr1D7aVy1SIgVDP8MbfdZ+9jOFGckmPB3BIjaq3Ay8YtaZ63rZszkPsPPGiU/brTBXyuWb994qnyrXdO6s3nXDc/qPL3bYQKuCL+Ac7Vcz3Hq+Eambnnrzj3rHud9LKM/2IvEFrkD2l5es9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB3533.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(376002)(396003)(366004)(26005)(38100700002)(38350700002)(66556008)(66476007)(86362001)(186003)(36756003)(5660300002)(316002)(2616005)(8936002)(107886003)(66946007)(44832011)(2906002)(6916009)(4326008)(52116002)(6666004)(6486002)(478600001)(7696005)(83380400001)(8676002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LHKX9CzjDTFND52EQEUK9dTQoogb6NDuWydHpb5hyxjgO46UWqpgdSHR3YRu?=
 =?us-ascii?Q?jRVS2PDd2BLfqd1K0WbGHaTqsBeAo11BVAaa8jNt1A3oJCn3YtoE2e0tBZHA?=
 =?us-ascii?Q?r5IDtXXhD5/ZdsD5AIj7/T8Ao1ZLNJ3i/ElUnjfhIlpV+afit1MMicfOMj/F?=
 =?us-ascii?Q?dpcT8yyucKEIMRp9Yyh0SDNVAJaqbzSRCQDwmbaDhEJ0WeSyzCXjQXdIEVic?=
 =?us-ascii?Q?FMA7deE6wKFfJsATGGMzbdvLXlOsbmlo+shCAKzMnimV8HzNfymGHVaMPKea?=
 =?us-ascii?Q?Elcf+u7K+oswqEYPLv/5GOHk8Ze4LjYgl5bAb5DIe7gAgFnc21JNJkcJ8+AL?=
 =?us-ascii?Q?OpGR0kkMvrwK5nOTAgo0K5SRn5jksCb6FYmlZdT/FMGo7ISsmmS3cKx+fr1c?=
 =?us-ascii?Q?xMMZBaTFbafycetNJXuNuFoU9YP3ArA+5BZP9b7nX8CjL3QuQ1gIsaLEl09p?=
 =?us-ascii?Q?J3hlN+f9lKkVqTqqovoRaVXW1r+Q0pSth007MiNc667sXrubWiXrhGaZjr24?=
 =?us-ascii?Q?jUPOukRdqSJLTlxi/Pvl3sdNtJVsJi8rm/oSmulyWentLpHSHq/4drbCVYf1?=
 =?us-ascii?Q?ORYdvCSQcIt/CM70MjPHFZo4bmu2z+wt6Hcd/Hum2iZE5jbspQuV7H9/joy3?=
 =?us-ascii?Q?hlwIvaGf0+JwZ6NbtLyLjq72JJ/vTyvChujRLnXt+/Ds6JAx7VjkbR8rFZ8P?=
 =?us-ascii?Q?ZqBWnixqmcDVnx95IKyn6uv97lvPtx28csZPqniERbWluPvLdUin3PlkZ1oO?=
 =?us-ascii?Q?VO6W+vnuqCOXSYrbOXtoEk1ytPJNOTIxXHTkhm2oFmFLG6ZGWAZuKJwvM9K3?=
 =?us-ascii?Q?cXZKtZWaqhhtHd7f3ey0G4ekpkygNF8JQzHzKzFPm90uo6T4/4CtvrwHapGN?=
 =?us-ascii?Q?j0tDNe7I/2ELHlRuowBp38TZRms/AjO7x5f6CIH1a6f1fNzAaQKjDMmaWJVY?=
 =?us-ascii?Q?8E+py6QAh1e3bqZquuLX0WFBQs5qoJzmb2cIFIeU6J5hAg3t4SjbdBlE3m08?=
 =?us-ascii?Q?lJ3ucxY0DrvDW4IEt+sqohEuPJrEUqvlihR9Vh9oZ5FGkRjiJ6gQPdHoAgHT?=
 =?us-ascii?Q?qGG70Sc20Ta2lXPYJTPut5lFeNYYkKfpYVkNk2pycLQTjFZ9bkadB5wCtnlC?=
 =?us-ascii?Q?iMoCTXkqMfZJUq2ZKrpjTGS3qqasLEmKvLugjpB2mijfxn723V+seNS4EMJe?=
 =?us-ascii?Q?0WPpxkCF/a2HgWQVTL0eMXBhOsTre1ZhCUqThb4ilNqHt0b3yoNG+s8q4IWU?=
 =?us-ascii?Q?B0cRAffqDZszvV9vy2UHuJYN1Dv0xwwCpJkPnMEjxbCR7K+nXGn6QlaAdTOz?=
 =?us-ascii?Q?LEnOw+njfTyRR2rilA/MKOM9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ebc17f-a519-4916-c753-08d9665415a2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB3533.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 16:35:57.9429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irW+Uz8rT/ZjLRKd2DsHL6RJWLdfW36qUTgMQTMK25zMpB6FER3jI5lwy3YlSFi9NgPNauhwrfW2Qpy5qKtjwJXGQ7E34axhn5mygXZhWMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5091
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230113
X-Proofpoint-ORIG-GUID: VXkQ3pB-TOtVzJjAVMHVxxaooY7j8bo2
X-Proofpoint-GUID: VXkQ3pB-TOtVzJjAVMHVxxaooY7j8bo2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_find_dma_valid is defined to return WAITED on success if it was
necessary to wait.  However, the loop forgets the WAITED value returned
by vfio_wait() and returns 0 in a later iteration.  Fix it.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Reviewed-by: Steve Sistare <steven.sistare@oracle.com>

---
v3:
  use Steve Sistare's suggested commit text and add his R-b
v2:
  use Alex Williamson's simplified fix

 drivers/vfio/vfio_iommu_type1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4f7c174c7a..0e9217687f5c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -612,17 +612,17 @@ static int vfio_wait(struct vfio_iommu *iommu)
 static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
 			       size_t size, struct vfio_dma **dma_p)
 {
-	int ret;
+	int ret = 0;
 
 	do {
 		*dma_p = vfio_find_dma(iommu, start, size);
 		if (!*dma_p)
-			ret = -EINVAL;
+			return -EINVAL;
 		else if (!(*dma_p)->vaddr_invalid)
-			ret = 0;
+			return ret;
 		else
 			ret = vfio_wait(iommu);
-	} while (ret > 0);
+	} while (ret == WAITED);
 
 	return ret;
 }
-- 
1.8.3.1


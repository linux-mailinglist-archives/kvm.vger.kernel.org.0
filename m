Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037D1348633
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 02:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhCYBGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 21:06:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39704 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhCYBGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 21:06:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P16M1F007896;
        Thu, 25 Mar 2021 01:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XpOE8ZN+Go+AWUAQkjqsOhi4ZvQtbb6sgu81yXU0ItI=;
 b=GoXofFjiwJgFQQwSLqyAU5XKO5IwS8+4kVIz7GlRAwkJw0IL4NfNnluo8vZiALwOlP5f
 J/DZcRkA91N6yV4QfkxFugzyMOEV7+8Wh02iShozUWEIJ03EFSMRcQ1EI0LOJ2YkpgPD
 t/zxOkW17Rs/HwEYP7VvCdZzyzVvzp0k4OZ7UOL79wg16w3GW+8rQKsW9lzCWehoa/L+
 DO7uTXFaqsu0/y9Y2TxT/mcMOXznd4AekTSgDKIfb/GQ+Cs9uvZSveADSO3yhXjQJCrY
 BVIuxmZFjfLbHVtYu/gVDsQ9yjqTNA++snAHlb2r/D5ZnhgjuCd1KVW6uF8/u7b6UwI/ BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37d9pn4mpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 01:06:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P16F3c191037;
        Thu, 25 Mar 2021 01:06:21 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by userp3020.oracle.com with ESMTP id 37dttu21tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 01:06:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HABEH8AhrwgQaQTP/37c7zgDTxH5taRXocGSGe5Fg6xvqOcR6Obc9wRzCMSGagWi9tfxkYwLW1mvhBSIX0e1+5WBKLi7WPZUJoggGzcLKrHTtPEhCgCSRrXZVZgvTgYO1YW6VfHJmkGBDs4m+MmFB5mlNDruddaKnMfGCLrLymUUirhvv1+Bx9UfCsJu+L1Bns+r7EPtGUQZQx8hodNAqNJfgDQUrpeqC0SmfLnRNVUos7RX641/73nmQGBr3z0wz7plHWrJjpJk3fqyOMVmFNgDYHxY8WEstE8SfG3aIHPBoldXDpRzFABBDndvbnk/Uy+RcNdn/pLIPXalQU6lHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpOE8ZN+Go+AWUAQkjqsOhi4ZvQtbb6sgu81yXU0ItI=;
 b=kcvmNjKIOG43OCk+dWhG6nQF/50JYkfcS3bsee0tjZPuQbHp74QC8uwITVpW1tYpxpsq/7sCcjR7MVto5hWs2iC0ZTjUAFxliGb8W+gCrr/0Xn2EfxjT3cBEkqXypMlGYb6sSgquOQfqWLjDQDWSNOTJHaVgYXAXWybXVwGb2H9plAxWQQl9ntWNdu/vo4+nDZHxjn+/cPQsjvSIKePZiljMvO+96+oedGMuiIk3dzCHdZprxvMZ8iitXP/cKYCe2jSrrWUecvnj9bJayw4yDDiON3stM2KhhragUx+U17RDXlGGTBEZqcalGYH3FG7uRgZJfE1odEoBm+5ywk9F3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpOE8ZN+Go+AWUAQkjqsOhi4ZvQtbb6sgu81yXU0ItI=;
 b=NRfI+1ZYGJBN9Or6j7MmnnEIFz8f0M0ZG2OymZdYhSDWryS0Nf6aD6296LKCL4lxynlWa1nOJ8HryXANtmw2q5SdVB8CFalaSdPIr14S1NoE9D6iO1wIAJqSpE8b7GJk8KbmTHHPiBJfPY/w7goBuvhOPpNMFCLczpZRGupM3HU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by MWHPR10MB1903.namprd10.prod.outlook.com (2603:10b6:300:10b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 01:06:09 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 01:06:09 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH] vfio/type1: Empty batch for pfnmap pages
Date:   Wed, 24 Mar 2021 21:05:52 -0400
Message-Id: <20210325010552.185481-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.31.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: BL1PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::10) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0065.namprd13.prod.outlook.com (2603:10b6:208:2b8::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Thu, 25 Mar 2021 01:06:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1be3929-19ec-47ea-5b1d-08d8ef2a2cd2
X-MS-TrafficTypeDiagnostic: MWHPR10MB1903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1903D4A7C38D325B4FEE7672D9629@MWHPR10MB1903.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4A7QFkZ6Phovfm/nn35GV+i2+7DeMuZBguWSU4czXE9VNJxRvy5gTAxdnXs89yChhD9NlmG6RcQqEZu5QTVKP8LvLejYewCE3cmakppQC1Po0QyaKMAfmoKrBspScRe+xEfXDshCXWYjU0Lr6gwqnTFG7EdmdAtfyaKLFWMFoxHpdTuw2btoljqC2MuI9bikHsW2ecJEmysX3RaQ4hiSpalzPhfXbvnRpvkLHfFsYyAvjD29w4y378mypjJZ6jD3dABNn288/AljIzOxH0sXYSmGn4w2kFnweg827QZYY9UFsm7W0LH8bOKw4DyPmBF4OyWrx5ANbIXTiWzokJh79cDGRHt6a22hsICnJg8WX6Plctj8O5msc5hJ6xMFXHKMm63NvJn26PZVfiKFPCuzLc9J05oJCVhINHdoivEXfd+IV88AQN6K5euaFT3mR+goD6yWcrU0ruDEG9RsvE7rJKDEk9l45RqJhj0ofyjC6GoMfAXGPKWmn1kO15V8ur25gc2OR/8y5XXkj6GOL8xmKC4xEvnpKguYmn3zulDHhyKP/rVKvHXnItLru9pm47L+UAPvOrnknneJCEZE1Jx63iYOSySUiJYiE+4VGt/N8pKKOpVAgzfh9xRpczLMbo/PqO2PXWM42WzSl+AopVAIip9nOzNHi64nM0p+CY5QqH3YyAD0mKFwJHZXSnFK4uyybsGmpdukSNPCIsaJcLlSIA5CsKkgkgoJxKO+Nm1s22PvYvGtdv94lBYTUzuwcYkhC/KLtV+c+zL45BjsWK+UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(136003)(366004)(83380400001)(69590400012)(6666004)(107886003)(2906002)(186003)(86362001)(4326008)(54906003)(5660300002)(36756003)(26005)(38100700001)(66946007)(1076003)(8676002)(316002)(16526019)(956004)(6512007)(2616005)(110136005)(66476007)(103116003)(8936002)(66556008)(966005)(52116002)(6506007)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vXm17k0rID+qhzkzwpoIA9umX+Pqom8+q9a7JX2jKD4ClT3yZ6mRV3mhCbxg?=
 =?us-ascii?Q?SNLwOYoauoWwhPtLPn8wp0XitLgUfuSLt8rlpgMbD5IRz5sWwPAXNJ/TjCUG?=
 =?us-ascii?Q?uG6PSX9MTgT7qeZBjWW8cfHmdXspED6tKkZYMMC6D4mL1qhUSp94nKyw79xb?=
 =?us-ascii?Q?7lq9p+i5WTkmaABiM9Qj4l7rMJ5BtTR3prAmcE38QMk4JTCLkcVO1ivrxm7C?=
 =?us-ascii?Q?R80wZFJI+49vd6kiQTTYLTIMWVrQZUKO9764oXclcsIldO9e0nv9BOKsfoFN?=
 =?us-ascii?Q?OwkRaT4jTJvaF2n/N34+weJb9QrRPl0U3g87QdAEMEIhtxlFhiTbqbjxRWIj?=
 =?us-ascii?Q?BNU+eqQ0wK8LdPu1/NNT4JMFerJijR8l6lEigNee11lfvhHNHe/ca3siZZkO?=
 =?us-ascii?Q?PN5+goJ7tBOm1/mNmv3zSCS2xRzuFUjlnKgE/n3OcNskSrJob24kunZg83Vj?=
 =?us-ascii?Q?7kjiUX/PK83o+fjAbKedj0MqnySDuXngHPWTKLYfZaE9YjexA2+1eVFGNaZ2?=
 =?us-ascii?Q?hLkuNSVqZl04iWOXV+Wp4dqJA7pUzvyUJKY5LqkWuOkz4bTjq6MDsDH4xLb2?=
 =?us-ascii?Q?6KlYuUlZxCRI/uGphBboqY1sQcMBDlaRYiKOLjwj3M1bpXRfDNyDX518u0V0?=
 =?us-ascii?Q?fPKS4q3qnLkPLVS1+gOcBIF1MyJ3wquA/TvIT9ftAMtaVwbA8xMzOdocwlWH?=
 =?us-ascii?Q?QU1eDCE9OtMR2+3mshNS1wEPjhEUF+QGBPM9bQDYxTUf/WR4mhZZS0wUt/jh?=
 =?us-ascii?Q?5GMcN0lvY1m2rzLaXrNunD/S0q7c+KPsdvb6e5DDL3LwKJEzcIz9GEP3yK58?=
 =?us-ascii?Q?zrWi1JK8FuulPc0gykoK1od0tpmo4mZT+Vxfuk04/Ju5MOirHI4AxXyQrXBD?=
 =?us-ascii?Q?TmJn36HvNPK9pKsH+uoBtNvnwUDlh7Mchh+Z3asBLTsZatub4wPy+Az3HdRt?=
 =?us-ascii?Q?wzaGVLZKXKppoR8qMK+iCZYJQEkAzAwc+3n17bIqZegAcsGT6ZKblBJdVNM0?=
 =?us-ascii?Q?AX23cQIMt3SPXO3zSN8XZD14J1V+etb3EzqaW1e5GvTaad+cXysMLTPgO0a6?=
 =?us-ascii?Q?K/V3vPaacj25Xit/uu4wjrtiz3YpM/BH7VtfsWsR3SCB6zEZt/uM4YT8LAuZ?=
 =?us-ascii?Q?iJ+JfuUBAP5CW8wSaGTLXuxejrVPDgiYV2eP7Qra42XYw/+QKNc1cywIVgqS?=
 =?us-ascii?Q?YZTO792W5h667Nf8nR+EYWH+IdxHfi+MuvGMPvzo3ACiFoqQM+9cybglXPuA?=
 =?us-ascii?Q?XyrTxWBDIrOvBCr6iXoq/RrFJ8Tj3xePOM9P0pFLtiqosWvYEjknAHP3087D?=
 =?us-ascii?Q?uMdj2PwHU8nxGxfnxPKWzRfa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1be3929-19ec-47ea-5b1d-08d8ef2a2cd2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 01:06:09.6091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bccFwRsA/CvURH7Bzt/XGtWU+2Bx9tl20zTetWOkf4XiysPN30GA8I5GUtJ8ztljKueCobIn5+QNn7iT+tg3zPG1A5AQPo3HhBbl1zp149k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1903
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When vfio_pin_pages_remote() returns with a partial batch consisting of
a single VM_PFNMAP pfn, a subsequent call will unfortunately try
restoring it from batch->pages, resulting in vfio mapping the wrong page
and unbalancing the page refcount.

Prevent the function from returning with this kind of partial batch to
avoid the issue.  There's no explicit check for a VM_PFNMAP pfn because
it's awkward to do so, so infer it from characteristics of the batch
instead.  This may result in occasional false positives but keeps the
code simpler.

Fixes: 4d83de6da265 ("vfio/type1: Batch page pinning")
Link: https://lkml.kernel.org/r/20210323133254.33ed9161@omen.home.shazbot.org/
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---

Alex, I couldn't immediately find a way to trigger this bug, but I can
run your test case if you like.

This is the minimal fix, but it should still protect all calls of
vfio_batch_unpin() from this problem.

 drivers/vfio/vfio_iommu_type1.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index be444407664a..45cbfd4879a5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -739,6 +739,12 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	ret = vfio_lock_acct(dma, lock_acct, false);
 
 unpin_out:
+	if (batch->size == 1 && !batch->offset) {
+		/* May be a VM_PFNMAP pfn, which the batch can't remember. */
+		put_pfn(pfn, dma->prot);
+		batch->size = 0;
+	}
+
 	if (ret < 0) {
 		if (pinned && !rsvd) {
 			for (pfn = *pfn_base ; pinned ; pfn++, pinned--)

base-commit: 84196390620ac0e5070ae36af84c137c6216a7dc
-- 
2.31.0


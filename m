Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21625513D39
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352117AbiD1VPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352085AbiD1VPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:15:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931627C174
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SIQHwV025784;
        Thu, 28 Apr 2022 21:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ygzh5M7pvvlGU25NMZduJiNhwKMrnJIELgifRX+DeUc=;
 b=euOcJs4dlpQBMA+coxzF5DiGmePGxnxmeJqg2pCVgHcbjEnGM+B0PXTB0C9v1v5v68T8
 cLq7xapj6213rAwIzrnKnanP4507Jdt2ny/cBEpGv2PCN8XQJ/Mn9/+6sC4gE0HwqBCh
 2PnCGZhxshEpiQ7gpLn7o6MtxPlYRo8AzI+XXuapZ4EXf7RnmdlgESKDugimf+6I3g9m
 DB6BzzbwnIVVAZxdvnXmd9fLJ3XLX/ke/NVxc4xBh49BZXfVqNViirY9kE9U8/NX5RC9
 hk0hzuIUm4e4JXjL38gO+miljmyxv8mLjbDu/doI2TBQZbvHQWqtTPZx7bOch5Q8HUQ5 mQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mwbgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5EiW028690;
        Thu, 28 Apr 2022 21:11:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79p40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GL5bhjediF8GFiUODSC5L7xBohFcEW0wBO898kU0/m5sFObX06/t0Wwdp5i/rOsly+HybZCzWgN9beNXMse3Hflx/gIVKHqDiG1CE/b/0RMEzS90O92g9NtETUWBA8PwGVYW6nxhXBugmb2For7EFDwpjG9KLbhWLjg7TVeqJp5Bsi75DkAzK6LA4pszXTv5pFrcK1m5EcWwHl0bOHb3FmZCHbZcDJMUPLcLYYTB7EdNKpWNX0wIxyhFuONwEJRLsgVJDfTV/w97m47+kKbOxIBjJ59WFwBlcfiGdP3DGzO3PTof4IAZNTQeRXfhiB2c3E8MXYHMtB8O7op4jx2R3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ygzh5M7pvvlGU25NMZduJiNhwKMrnJIELgifRX+DeUc=;
 b=iQcL/RVZwevbxzm9ZUkmIb4JPXS21jf09LMcksE2gKtvvnGwsdBYl/9+RKVuE1/JXfijI9KDnmRr5NqXQPlcuICKeIt3LXlZUYD9MzzUIFtFxJ1kCn9KjrOnWNjWWi4Z+lJBqOPzXe64BwGv6mBtT0Q8LCokHR4eKwmXOg51ZJYprGGVhyP9TlIXYUVkjtWkjI5wo2s7a6z66lIsn1DNWjYTRUbDcRyzpwv3O29UhmhREuoexXXEfZqLt9ZLPJ7UnBkNRa9Oo6mQr4FsvTZHqtWvGQbcUZrt9P7+1zvwtRDPgQL7OliU0xVYfw+85HYEAjmJhWAydpcXbWgoZlgppQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ygzh5M7pvvlGU25NMZduJiNhwKMrnJIELgifRX+DeUc=;
 b=uEv1ZhbiJ4sgJa7osLAfDLHxKcG41YmItkblgyofIP7DdVEt//nNuCjQ1BTNweAriIhx4qrQ4F6hVW67HGMMayemUoevUP/ldEyIUfGRzMXpvxmPi/GsURNLcr6ifT2Fz+F9avtyq3GH4FhQiOgQxZKcgyei9iKIiFTGOwmW1lw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3341.namprd10.prod.outlook.com (2603:10b6:208:12f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:11:14 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:14 +0000
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
Subject: [PATCH RFC 12/19] iommu/arm-smmu-v3: Add feature detection for HTTU
Date:   Thu, 28 Apr 2022 22:09:26 +0100
Message-Id: <20220428210933.3583-13-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c1b2346-07cd-42a7-82c7-08da295ba08d
X-MS-TrafficTypeDiagnostic: MN2PR10MB3341:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB334152F9994FE673CD554D91BBFD9@MN2PR10MB3341.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JyF6SqtdJ88rj1KMadBPHfGV+ASDGt+mKQYhyGCymqiyFNxe4PGhwgd7QH1wF7QGeEAb19kUOoorZiIEUOgOXE98vlJEJK989Ng0VXZLsAI0SIc1HkJqiITqLynG5F2Z36dCjdORz7LODxV8+huxE2DaJlwEcUVn4UfpQZS7W5F6MwuvX3sGavDIQtZEPJ8FUpSbAQaR+Vthccn0Sug1khMJOKQjdOzuduUI/PL+GMxL+G/Ugfi/kbOQnJ3ylPS/Boq/zJEC6uyCoGretUMD0qR0nXaAaJUFQIWWEjVZuRP68AGJsyEuPLdimrYxmpdzWUYlzcdZxKKozpIBujjNBnC4BNNE7tsyoT+G9y/ak3sNl0anBAVXNPZnw/nWECGrs/TJ+1l8Q6bshq+1bylqkJyO/T+dar2LebYU/uiPRr+xQtcEW7m3opnWk2S1BHx0ofsIO2qvH06guNZ1XcxOMVbbQWqPd1CjlvTU2QuH1qpa6qObstk0nd2+wm5y6I7u1Zs6nWxJia2t5AWTc3+rC1NfsX42U9pmAQzemvxJ3CQGwFE5KmrApUcxlCxMX5jKm2atA+xG3xzTeT7DZ5yoe1EVyLeRw2PgS7d/3ug7HGHfhsJY3yJc4CP4wb2aeaE0Ijr5JYuvHvQjRUTb89V507XsL+OCkETtup1VKt6JBKcytfXZGz/NuFSNxXjUrqNE9a709NuqACfbbba/UHWejw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(6512007)(103116003)(83380400001)(508600001)(1076003)(2616005)(52116002)(26005)(6506007)(6666004)(186003)(2906002)(7416002)(36756003)(316002)(5660300002)(6916009)(86362001)(54906003)(38100700002)(38350700002)(8676002)(4326008)(66476007)(8936002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hU7/qgHYyncMkMLKLqeA54LvGb9aQ+v3eXloXJFTg23f/fDaDqkY7IJqVQTy?=
 =?us-ascii?Q?x2wN8iNnwDvbB+sZfzNabEEB3tXCQbXaY5bjJfmanekQlHy9ejNJY9Jb3Zo1?=
 =?us-ascii?Q?VMlBk1Nz59ZJzKKa5331v50MCmzMl7SdZCuOhncpAd5wD79B9SieW7CMSLj6?=
 =?us-ascii?Q?Ct4iRRoN/AMcPlwtW505BQD6DUeGB9lI4b/o4Ucs3vpvwLJ2N7mFoUrta2gl?=
 =?us-ascii?Q?P20RhNPFoixjgi8asASPtsCFLvWpbT+YXcw+8Mm2zt0DluvMYaE7l/7/2C/u?=
 =?us-ascii?Q?ijyAdSFygDwUxxeiq+LG5XGqMCXlsLvD9sZbhyHxsXGv2T8LyjYtazrAwM9h?=
 =?us-ascii?Q?ZXPSKg/I/Mc8LbP3b4IwDc2FdWHOI1ZhhXh/+hI59rNM/PClB0E2CWyKh+nV?=
 =?us-ascii?Q?+VJXHyzJtuARHj/qF/vKRRL9+rVMhPmXf3vX0eOVAhPR6Ooy4ya9N9wCejlc?=
 =?us-ascii?Q?Upmx5DnI1KAraoWUJKKBtbuJ3r75FOuQ5onoxXjlJsSwJgrIaMHyo9W3UvmM?=
 =?us-ascii?Q?pHdSj8o0HfMD4FumZUZ4YQH0d3stsmjAdv/tFhDBmiWYbMVP8RBBKN+FQaEs?=
 =?us-ascii?Q?fAQlZ+/FYnmpIzgwWSLlvdS9Od2HD+El8GzoZUI3N7MN2X5DhDXJCRLBQ3mv?=
 =?us-ascii?Q?w5JUh7urr3ZnGgck2oxSzosVQ0lqMmzuTszVqzsQLTFNKOFKrMvYiAJp8cBm?=
 =?us-ascii?Q?knybzHAQocRZa1GwzZJzy/cZaituCp30nv+TD4Q7yWAXvvZq7OyQfe0Ndn46?=
 =?us-ascii?Q?4CHZJSSpRqIoblTMlzopy+HhZUaEXZO8bsQNiTYlXUDD0Tc/TnF0WC5ML/Or?=
 =?us-ascii?Q?n/SsIq4BW58n3AecVNNk/LlGynAOzI/eDRSl8AxuM9SWS85wtfrXNUpQJUaU?=
 =?us-ascii?Q?ZRfHb+bB3Pd4aN+aJ6deU2Lq2W7Dz6c9SGKjQ4t2/DO1NTMj6n91szbUlNiT?=
 =?us-ascii?Q?2o8Kes73pWxjKD1HawKKtQRlcbQAtGcPazvO2tT84ReIUEJsFaS1w5BRWaVe?=
 =?us-ascii?Q?3p0dKGDOa4RDrzOv/Ujsutmi3fssEeleSqi4As25kQ2Wne7qHI35WixXwJYf?=
 =?us-ascii?Q?qfS12g0BSq+HVVeTq7Ud4cA4c2o88IKeFUuv0Xz3P0tl/RqJfDw73LXfoF/z?=
 =?us-ascii?Q?ogKOwjeW819nHRsXGveTY/ZS7IMqXlY/xVlWt2Y1kjdJ7yuM1QAdelL0JVwg?=
 =?us-ascii?Q?a4KAqidm2XIJ5uhSCOWmdk37jvhKhvT1ojx6MFdszUVxirnd4E/get3uiRFa?=
 =?us-ascii?Q?FOU2+w9ovmX3qWZ1aPYmMHIJg1yepo2KUxCMsjQtlrSatXlYOiLUkV/s4moJ?=
 =?us-ascii?Q?fP1TRJkOxz19/2UMG9r3i1JfRLQIBJiPcttrkAum6U/BuL1dt0CwEfNp2YO7?=
 =?us-ascii?Q?yV5vrEgfVzZ0Ms6bXiFt32whqpTtbu2wq9R3RyIicAMKE3fnTNLNq/+oczQW?=
 =?us-ascii?Q?CGuaLc5mEKUhIOjJxsBrTVsa9AuRJqObbY9yXohwtFkvs8akPOGtMjFfu254?=
 =?us-ascii?Q?aWY4d59noH/XrhtFQm4ifkVYEqvzlg1IpdoC4lg8YSPLSTv3LGLtqaazgdhf?=
 =?us-ascii?Q?r7M9kbbNsT6b9dAlnnF3LmL2F4i5ba7tYnSSwchHSKWsEWAUUJ89SOFGyrYO?=
 =?us-ascii?Q?QJjOD95ZMcMctdmj4X8FApN0wD3yLdSKQSf8yvWF/k+sizZvjJ1hnb08+XUQ?=
 =?us-ascii?Q?UwBc/LKhl6EZW5jfRu40bki5Na877KdPFA50w3f6cddm30HGsHQ6HIOgP984?=
 =?us-ascii?Q?6AEHjIyYRQwnStmFiwZj4Ds9KweD/CM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1b2346-07cd-42a7-82c7-08da295ba08d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:14.0924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lw927L7oGGCLe2FVegorbo+Al/Rc4GSjyKvL/N18PxVKWSdVpNWdYooWshsw0AVJ2vV/KSSmny7pr5+C6CMWisqnn+gLlf+RY7MVYUfi5zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3341
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: _WkwArK_KYwDhNvm1W7UYRorF4D_ElDH
X-Proofpoint-ORIG-GUID: _WkwArK_KYwDhNvm1W7UYRorF4D_ElDH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

If the SMMU supports it and the kernel was built with HTTU support,
Probe support for Hardware Translation Table Update (HTTU) which is
essentially to enable hardware update of access and dirty flags.

Probe and set the smmu::features for Hardware Dirty and Hardware Access
bits. This is in preparation, to enable it on the context descriptors of
stage 1 format.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
[joaomart: Change commit message to reflect the underlying changes]
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 32 +++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  5 ++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fd49282c03a3..14609ece4e33 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3424,6 +3424,28 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 	return 0;
 }
 
+static void arm_smmu_get_httu(struct arm_smmu_device *smmu, u32 reg)
+{
+	u32 fw_features = smmu->features & (ARM_SMMU_FEAT_HA | ARM_SMMU_FEAT_HD);
+	u32 features = 0;
+
+	switch (FIELD_GET(IDR0_HTTU, reg)) {
+	case IDR0_HTTU_ACCESS_DIRTY:
+		features |= ARM_SMMU_FEAT_HD;
+		fallthrough;
+	case IDR0_HTTU_ACCESS:
+		features |= ARM_SMMU_FEAT_HA;
+	}
+
+	if (smmu->dev->of_node)
+		smmu->features |= features;
+	else if (features != fw_features)
+		/* ACPI IORT sets the HTTU bits */
+		dev_warn(smmu->dev,
+			 "IDR0.HTTU overridden by FW configuration (0x%x)\n",
+			 fw_features);
+}
+
 static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 {
 	u32 reg;
@@ -3484,6 +3506,8 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 			smmu->features |= ARM_SMMU_FEAT_E2H;
 	}
 
+	arm_smmu_get_httu(smmu, reg);
+
 	/*
 	 * The coherency feature as set by FW is used in preference to the ID
 	 * register, but warn on mismatch.
@@ -3669,6 +3693,14 @@ static int arm_smmu_device_acpi_probe(struct platform_device *pdev,
 	if (iort_smmu->flags & ACPI_IORT_SMMU_V3_COHACC_OVERRIDE)
 		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
 
+	switch (FIELD_GET(ACPI_IORT_SMMU_V3_HTTU_OVERRIDE, iort_smmu->flags)) {
+	case IDR0_HTTU_ACCESS_DIRTY:
+		smmu->features |= ARM_SMMU_FEAT_HD;
+		fallthrough;
+	case IDR0_HTTU_ACCESS:
+		smmu->features |= ARM_SMMU_FEAT_HA;
+	}
+
 	return 0;
 }
 #else
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index cd48590ada30..1487a80fdf1b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -33,6 +33,9 @@
 #define IDR0_ASID16			(1 << 12)
 #define IDR0_ATS			(1 << 10)
 #define IDR0_HYP			(1 << 9)
+#define IDR0_HTTU			GENMASK(7, 6)
+#define IDR0_HTTU_ACCESS		1
+#define IDR0_HTTU_ACCESS_DIRTY		2
 #define IDR0_COHACC			(1 << 4)
 #define IDR0_TTF			GENMASK(3, 2)
 #define IDR0_TTF_AARCH64		2
@@ -639,6 +642,8 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_BTM		(1 << 16)
 #define ARM_SMMU_FEAT_SVA		(1 << 17)
 #define ARM_SMMU_FEAT_E2H		(1 << 18)
+#define ARM_SMMU_FEAT_HA		(1 << 19)
+#define ARM_SMMU_FEAT_HD		(1 << 20)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
-- 
2.17.2


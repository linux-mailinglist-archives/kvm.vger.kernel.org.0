Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C33513D3A
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352118AbiD1VP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351560AbiD1VP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:15:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ED17EA24
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:52 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJeCXe011361;
        Thu, 28 Apr 2022 21:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kcT7k0memJPhbVUCWjNmkKpmVTUDndr3S3Cm0TWzEWc=;
 b=o8Z4N8O9CEKhu5cXCFu7nP8hN3FbCTGaEVECwnt8LBwygGzbxPz3gvUGV9R2OKvt5Kb7
 1zL9v2UopgCZ3mYT0cpQiE/crA8JW/JQwt5zpnvNGDgz31L43B5wvbBNV2ou/DddpcBd
 k9iEnVg3dRbuRWpCnzkirPPeVlvTOW6FZwD2y9ccCIYQOvcpIrRKxFNqw/V4QBYMh12T
 1Yvdxv6AbPJryuiBcEXUbwGpkk4LYuJ94OHWPuKBFXoIZ8PXBBRuFZGYkOggO9dCjfvv
 afDUziY25MTbd6cTv67YOwxzOtrp5BGiHIVrQQr6LYIOPCWdVY+ZyLNwMGwFFPR30BfQ HQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4nb53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL5C0c028563;
        Thu, 28 Apr 2022 21:11:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w79p31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:11:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neC9sPwWo1QF819facx3Rbm9FBHxkjDFD0bc2X6DDELjQ2THeradI0sxiDBjchQrEJIh8t+GJmiSw8Uk/+MYy2W43J4eTLW93oNLUr98r96cKa2DSswyqlEBk5HFwoWplyq8edw9+r3wACaebMtcJIPGthudFRWMT1B0WrAnx4JmyocYcl6Qeg6w/ASDtrSDhxY8iJAxlRiMcWkN5EdtzjbHd2VIZ7NZYuIiMSMqN/uDvsnfZiZVJd2UKuZPk0DE/Uor6xgBCNJHDkSnvsWRXG3L8NlpJI5CBZwT3PYx4/8UQv04PKm3vwENdD2z8EanXCjwUKKJqALpXsGYthXXCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcT7k0memJPhbVUCWjNmkKpmVTUDndr3S3Cm0TWzEWc=;
 b=MCySvXAJRJ69501lLKU+WghixT/9t85Z44ZzgNmycR1PeHB9EqRJuTcMDKGGvG7qo0ngwJQoPxSLo2Jm4ItL3QlpESejEUskNvIolYUVFKwhNt4H8Dt+X7Ne40inHKLWtgHR0ZUeHGzJRtE8VC3HyNPyrZyW+lffNag7pbfzvpqx5Q933Nn4XlkLMDIHoHegDSDQXvXy5M+j/N42egMr8OdoGVPyNJpcG3Aw0DMDhO7e6SzmKEoz9FQ3/iskGtpe3NkQaQA8onqSoZx27xtBlQGBZmVaXBM8RZEf/FujAalx5pa7CXE9FcjP4NkcbcbajtnK/UYHkRV4ljG1g6gFlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcT7k0memJPhbVUCWjNmkKpmVTUDndr3S3Cm0TWzEWc=;
 b=hPDZE8F/0+iKCNcjsia1wloNG5l42KKtcJBvB6Y4S/zL/nOlynNEPobfbtaLl1WZprdeqJedQOnVuz9G1/C7fAUN3p78cDakuV1Y8CR7avcHYiTdIhwxwBcT682Vjh28DKMMTzM2TG5uuj6eFyZuIInp6o+Tgn36wPzoWrXTtLM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:11:10 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:11:10 +0000
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
Subject: [PATCH RFC 11/19] iommu/amd: Print access/dirty bits if supported
Date:   Thu, 28 Apr 2022 22:09:25 +0100
Message-Id: <20220428210933.3583-12-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3554a2b8-f17c-40f1-756b-08da295b9e9a
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1564497F9143D9ACCC21C06EBBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +34ylqbzpwnFe0TYjd/xvDd7AMsURidq+KLqH4/i5+OrGfT5jXgeC84jhedSXEt2hjh4dEyRpKid5EN+aIyCQTKm8efj1ozS7Ko2qrzp1z/9N+NCkgyb6I/dGnNP2O6C9BfiL1AMk1H+3vuEYzxdtuo0uaUoCXmNIpxe4PiZmvBpcvY0ZvO8aI1ZPGjmvYz0lF26wzvida2dg0B9KCIH6iXBk9rV8exuUoflGdjkAE6SPM0cUkruRrBLsNW+AnQJlWckG/+/6yrV7Avf49p8GwtmBS61iONZDREVSJv//vuzd0D2NXVLIOdbJKBzDmoJk59ytPMMnlc7oF/NJFjahgljF03elrn9QoCVEUjeG5ScS/8/2llRL5HtRTmtC0hfkDOgZqfsrB9r67b8+7BiYJngsYY0ArYOVRZ5tz1JQHukMi7E1g11F48rU/muVYoZIhHe0cnUFz4XaiD5rcSYcbbhkCMT/TJ+NPzsyW5i9jjamOSWIyhRm3SRGU2tX2NPPSWz6Sxw9g8G+QXc/06xELfCxSBFi9RsfQV1r18wHCpH/55TRxsfw4U3feaRafdI8ulPzcJJRd8JCR8Ok2jmFr7keqG3ZoNWWNNq14MZm8m3W5JDz55upxGW14j+NOzKuhLePH6l0qWZPYm/g678eZzVaJA3nl7pGUrOuZsztogquCXB8QeoH+Xa/zas6UofF0pogpyQpgJFfpj8QVw9aOqoYhXFrFLA3rutMCM/tgg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(4744005)(26005)(6512007)(6486002)(6916009)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8a9mP/e5p3JzTceCn4II5DmJYO1dgwbyWGVsB0OxdqwiTAAzqktGIRpAQWXu?=
 =?us-ascii?Q?TB4EgVHzVue+0g88w7CasaouGqUnI+kfXaSK+FP5eKAxURp3SBMRxVvLYoI6?=
 =?us-ascii?Q?2+VbiP8kRYanJT86D3HClf7H6lPIxjNfjRn5XqCfP5yrGyH/lVn/VfUo+3lE?=
 =?us-ascii?Q?aSRc2HfBY5KBcsahjKZa2BT6ZH4SYmD75P/JNVrB01D0nvzZS1DL4000O1VJ?=
 =?us-ascii?Q?7iceepiDpspg4KCkhxMy7dKNCHoa95qzhqNTGBipTcPRERtIidFipex+zbzM?=
 =?us-ascii?Q?BC3MWn3wPs1fP6nsnZ2sKpAJ41KMfYutdvd5Epy2MKnOdWujzVe8m7SfcQcn?=
 =?us-ascii?Q?V8mDQtWy7383AFkmoAkM+ziafGOirVpGM0P2/3DEZbQBrZmm8GjAwZPdfF/F?=
 =?us-ascii?Q?DPPnkWN87S3oCR5R5g1EUz1bJdGOo7FlCMo2wtAL+TQMavenfxrsaOs7uvTk?=
 =?us-ascii?Q?K5ZgTVTgX/NFDjAMwpRaN4kWiR5k9qa0wyvv4gsfXLUznVSwCBeQatZajQTK?=
 =?us-ascii?Q?Hv2OMle4ggkTeu8Ht+fGaGVcnFopM4HJm5MVVlqRPdstfqrej86HKIG/3X8s?=
 =?us-ascii?Q?pVAEgxe1QremEmsIxcdJPJq4cR6vzOSgDZ+hwvhvThHicEd6kYsT1+2Kl3tr?=
 =?us-ascii?Q?MLuLZ+BB04+VRwZhA8Ia67kjDCFuMb07sYFl8Ex0w2CbA2PNnzXB24r92VRB?=
 =?us-ascii?Q?1VFWwjRIWQGnoAfAGf0iIht2iVKYy9NVxCDKUtO4lbPo9SDoHNx+zr4JQBjY?=
 =?us-ascii?Q?mAIU8AJjUyHUyHOZSV/DIoR6tMZY/6PmOSqrXOFKa9BWhOPW5Kp8gY8jHpvb?=
 =?us-ascii?Q?IYsnX7QRkNt6sc4Dr8A5qlKVvzIwktNcAjEZhxqmHBAOmnIsHxlO0iwJFfcJ?=
 =?us-ascii?Q?P/Mspys3zMYzq+YV6rnVy3zUaDFvUZlPmfg8FdBEHrVMX/5kLIZhv027+IuV?=
 =?us-ascii?Q?cxE/HH3BT9zzlH031Mf0AXuc9jwLCx2TGC0K+aGO8zaHGmzpXn4npUCl68LG?=
 =?us-ascii?Q?IMUyMOrO4COejCCQfzbqILsMrSE+ifgs+RlWzW/LnUNBGy/LvVD8WtLcxSav?=
 =?us-ascii?Q?FE/qwuOyoUz12LWLL304/4ffU2UHoP5WDl2IKh2L7IpEVuF8Zt4E7eU+thfF?=
 =?us-ascii?Q?M/sgcYxAEg86NMHUsYN1xacXwdmt62dcZC+Y7NKNjloGb8JBqq+uldz/cgr3?=
 =?us-ascii?Q?dYOdQDyLrfWqbRk5x4yK9mTeX/IVdbbTp7/k6gM93CoS1U5rhKkziRp7HCA0?=
 =?us-ascii?Q?XzvxegXy00Smc1Ay7qAv1kK7QlE0/MlvWQGgz1FyMa9k9pSw65mw3D6JyJT9?=
 =?us-ascii?Q?HzcLysf74V6jVpIFD/Cbhk5gt6uxJBfglNqRco/C0kijQaIoY/01l/7dMjDk?=
 =?us-ascii?Q?cxZsNhz1WmX8sCGDFov6Ztx8oZyqsiiBs4thlnP72MGUXVoym05blofb5+Lp?=
 =?us-ascii?Q?tM7OErZ4OCkb5XGr8fup10Pz11Ct5YKj9V1A/xuezLmhWmWsS8R9788K5G5r?=
 =?us-ascii?Q?kYPD7tEHx8PGG1nOXcX2RVpW7IqlqCs4Ozc+jMhUOsr2jQpg+WU93kLhOEbd?=
 =?us-ascii?Q?91/KD4iyRo8T8rx0Z5OrPw5R67NHfZd//zhHy4NCYm+S4JoeXqyjLXYNOa2z?=
 =?us-ascii?Q?nDBGK8jMY2DiEOna78C7kHJJZvObeIwhrao64m/MI9G0XZ6IYsGCCL5B9x/3?=
 =?us-ascii?Q?Tk8w2jjoZ9BS4Efkhy0QGvZbXIGpIRTn6MKDuz7KESUJ+5UEVb7pnyZvtMcD?=
 =?us-ascii?Q?n8GJRQyGKdkC+BEH3+68QUlxIlDxHJg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3554a2b8-f17c-40f1-756b-08da295b9e9a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:11:10.8858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6czl5SH3QTjuJNpHU81TDHHVfSya4SGJ2Y9XBheE5W9mr9xFi7hzSTiPVNkuSChD0BLL+uxNcsgvG9XIyOA1dNB2vRB9bYrzhqnQMmCrqdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: gmEDQzyccE2mhqC5eHfc8M8QGixSHMaN
X-Proofpoint-ORIG-GUID: gmEDQzyccE2mhqC5eHfc8M8QGixSHMaN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print the feature, much like other kernel-supported features.

One can still probe its actual hw support via sysfs, regardless
of what the kernel does.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/amd/init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 27f2cf61d0c6..c410d127eb58 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1936,6 +1936,10 @@ static void print_iommu_info(void)
 
 			if (iommu->features & FEATURE_GAM_VAPIC)
 				pr_cont(" GA_vAPIC");
+			if (iommu->features & FEATURE_HASUP)
+				pr_cont(" HASup");
+			if (iommu->features & FEATURE_HDSUP)
+				pr_cont(" HDSup");
 
 			pr_cont("\n");
 		}
-- 
2.17.2


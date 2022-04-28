Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1A1513D21
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352054AbiD1VOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbiD1VO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312DD728F4
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJYOFW015530;
        Thu, 28 Apr 2022 21:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+acMWJruhCeRAK7/pwECqhYMKVXDyB26ZOIR3Ns3tH8=;
 b=OsoVeV/YYf7UjoTvbBLOQFJIF21O7eDHwFsBym/yeLeCS5VcXSnJQ62N3HtTE8JXYmJW
 SKvTzZ511Gxy/PSE7mrb6T7d8VL7tH3THDmsZtVM+hZxPITuK6GlxASoRffkKeCmNSMh
 3z0aqTUJw1IoQLVslpxJNM3YMNuhDIrtmf4Sa9UcQfBxl+ByYwBbVGjNd1Mm8j+IHpnO
 OevLOzbdohtQK8OrYixEXa9kU6JSfmYG1W6YuyKsOO8+ekEcjOr13oH6HXdH/WFa0bLM
 /emZLRxZQx/6AlxjstSw+fN/a5yoHvj9jyRHM0d1CuHHDxw+UoV/rbK2Kimtw7IkYsHY dA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9aw5vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6BX8025002;
        Thu, 28 Apr 2022 21:10:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w78a10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avjee+tjumqLHSh8Hqe+W+kVhy0rAqkHGNqFRCzQcTAN36bgr6QYTGTOE7WxIU7Vb7a7J/FnU09d4OiLw6PK479oY1PZvKtiuofCJ3u3+4zYB9n0pl/G2uxIXI+U7Ml7WbVWKYJDsX9BcjYNSMGaowqmSjpiLiZHVT86YNG4uxtsrmlkiKJ8JnNtnfq30TcOUOHUZRcKPF22bhKIjJM67PXxzOoKSHKBQZ9Uza9IWkzIDu6MnIff/qjHbn8znFslNQQSt6B9yK0XBdE3e4lhP89gCHQst32QwgX42PvWGI61SDw2mL1/hImdzYlF2YbW4mT4PmMeOW3aR+skLsUjvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+acMWJruhCeRAK7/pwECqhYMKVXDyB26ZOIR3Ns3tH8=;
 b=OqNUsCaeLr6gNHcjCt98Kp5uwd5aGji/HAZXFhM+habTlchqSsvQa2EFp5ZVEFgOBMpRYOtSCzMI0WWO/KOw/FT/Fvxm0rRtm0o/YKx0AmQizm9bYDaA0Eamk/i3G1y2ibmPC0mC4dGDb/eTLx6qDbEk8wFDdI/2vwLAJ0b2A2KTj5V6xpNHeuIZ01qRPLbPqd2ldZp+BVCt4y8wp+X3zPj53FaYXfOHbpoHP/F+SeaZAZTV1wIzlk4SFcqn9xVnhMDJ8J87pbWov/C5QNDpvf/kz/UV+VEwjpYkPurA1A90tVQNJxevv/lryFTqFi2IOFws5rSu9kuQOap21l1QHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+acMWJruhCeRAK7/pwECqhYMKVXDyB26ZOIR3Ns3tH8=;
 b=DHhuihUi8s58zhMhBE6Mr+kszakHSSwRzGYSMKM0Uk2hiitmhr0wnzF5F9yLt25Lqm6rq0jzySPYRxRgT8sjlZKkWCU/iLtoREA6uKUBrz00rvh1xd9z4cP9OlZAdOVHuDYVsT+iZtrxi7jJobpqeAPha9wwb2te6fZAulAZ5kE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR10MB1630.namprd10.prod.outlook.com (2603:10b6:301:a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 21:10:36 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:10:36 +0000
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
Subject: [PATCH RFC 02/19] iommufd: Dirty tracking for io_pagetable
Date:   Thu, 28 Apr 2022 22:09:16 +0100
Message-Id: <20220428210933.3583-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220428210933.3583-1-joao.m.martins@oracle.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fac85983-09da-4c6b-1c44-08da295b89f0
X-MS-TrafficTypeDiagnostic: MWHPR10MB1630:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1630B80436C3F71EBDDE9F45BBFD9@MWHPR10MB1630.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IMn8Es1+EJew2bbNKCw4SCX+o8CmjX6sZeLXouBDDGgyTGuNXU50oT2oEOYI6T+GfK9l7qfnftVVBBOfY4WnCG9VzRVhSbC3ODon/2E3jLHVhpzEfoGlqm3BkPIXkluns6cd8+xUqpSjHJCIwbRZ4hsjTY7n8latr76wwpjXWI4quWSnzrPCNuk9HaTtKdzQZK4NstKvOB09/4V0l4vcWuhuHNY8gDLegm7J5TmQcaU7a92w+a9ykBFh7lidEMOcrd+VcFCuOZI4G3ONPVASMdV7n//+cZPYsb9+1E3KoHYrmDR50N0LK/d3wltzS6JOBp5Ovtx3nDKBlIjspohEoFkaZ1W3UJXLmIFDA3olMMXy/VK51ehnN8NyCVQmxfmahVrkNNToy+HxM2CAQuAmZM4/v+xHV+MpJ308ZIrZZr13W5daiSzg2A1qaWQWdv48EAkBhiPe52J5wRxRzltz2Bu9U0obIi1t8ORCYlmC79XYMvBxL2VptthgMZyT2OzHs/MQ7J7lvAbC5S4dAa11l5RuEa7sA7vjiwj1kHLBSjFrtz1RyBJk1k6I3VyAwInm+to/aQIj0yxSYLuCPwITGFeHXIx6QR8FKVI6/10GRvTn2pztv/MUXE1elaP7bHpfz1Rxg9g/HxG5wYrnQzBvjtPm1v7p7QxbECI8uVTwkzckj1jkVWa/IvtSMe6PMlahIO6I/BXlsOl1DC3GkGdO8d23RUyqwcHqXCc8OJWD2KM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(6486002)(6512007)(2906002)(66946007)(66476007)(66556008)(38100700002)(4326008)(38350700002)(7416002)(103116003)(8936002)(6666004)(6506007)(5660300002)(26005)(52116002)(508600001)(2616005)(6916009)(54906003)(1076003)(36756003)(83380400001)(316002)(186003)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v7mW/MarVYptc8ZKTM+RaVQssDYzoascbbxuB4J5OHzxA2K0FXPyq2OeDsUH?=
 =?us-ascii?Q?3vGxRMOyyCs3U8Tu8CJHWDiMjHAR2OseW2DSFsMnazts7UsME1Vc7aNGv6oq?=
 =?us-ascii?Q?nfKfRYUPML//gxBt64Cj4w4Od0O76hwcEScf/4HLa1nZ6vMa4meZLus3QQzH?=
 =?us-ascii?Q?hy/pskUtXrAulOuFGlJnUXiqPKb8U1lsdc3M3zPqfSIttv+DHsbOhOAWJ/xL?=
 =?us-ascii?Q?jWt7YfW5ODQ/0jUsvzxefk3ua9KOAuyZP03fDp86sIZyUE5Op7qbUI6RHTSM?=
 =?us-ascii?Q?TsRFSaF+sIR0Rvn44M2J/Q1I8TbV4xr3ZUHP0KuPJohLf8RijnsA7P8FgTYN?=
 =?us-ascii?Q?Vtd+vZYXnzmrwZoBsvZD3ML/d6lS7ePmgzotvQgbwkr9wlXlhoSJrBHyHlX3?=
 =?us-ascii?Q?yI13UjQ5c/5ZjJ/QFILFang/Rb16ySMSto1oCqbf2cMoWmHmJht5WiJx2EUb?=
 =?us-ascii?Q?GSefLyyDCX+KZ/ZXUMu54Am58KS1YHmBsPjbRzLj28Z0SlPf8mM8iPoGr87T?=
 =?us-ascii?Q?xbxS8KSEIY2ZfSL2ZfkJK15iTxTvqNZN1NhP9Em3a0oSY9I/DB70Tf3mFKML?=
 =?us-ascii?Q?JPAI87sOrz97tLRoKsIUsGTB7bUxABrsYJ5dWXhczM5OTFO6KfIixF5nz3dY?=
 =?us-ascii?Q?U5ipNPWXjAA9tcFk8T5DTGwAMcT4eQ90BuCvTuvZRWfU2M7P83EUPPrmJWeF?=
 =?us-ascii?Q?X+cTNQuRPMY3VlE3NiRi+Qao5cfU5PnG3VvVfddpfy7gvxJ7MvIuUpa4PTsD?=
 =?us-ascii?Q?ntyMLUfBLJQc2YAPH4cnFqw9g3YyXMYOl/cR3uieQ0d/RuIBYsyqZsF/dOQc?=
 =?us-ascii?Q?+70Ji9DMuoEJyO1t3WtgC3k/1Ac9/vqu/yDB+RFC+j7Z9d5TQFfNI1TbfXaZ?=
 =?us-ascii?Q?KQeNrc9f8QpuCnJr7OEKkRkOkIevaRYo07Z4a3JzJddEV0Dmm8T4cK9mnrKd?=
 =?us-ascii?Q?3Ltq7mYFkrh7imzi0kRh3ThLnfa8Uu5/j440F5zqaUtUFH3seRkOPIWaAx6x?=
 =?us-ascii?Q?GRQRmE9WNp82TZ/5P2F+ShAFjHkmTUFA87NRx81FUeQ4Xpo3p8tKVJ1P9tO/?=
 =?us-ascii?Q?Jx3AnlV1LVvPTMzVMtF5+Np7nfosGifuAX0JOTiOefnKM7Ty+xcQkGywWUTg?=
 =?us-ascii?Q?yIQZIohFphh92CHb6MS/Tafq9aF2ka5XHxF0cltyEicAGaG00usTy9imsLCv?=
 =?us-ascii?Q?F/VKAfGrRFKmgJriT6cEUE1J/aSxS+NspA5VEzCQlzUHAB4jB5DiGoCPVgTf?=
 =?us-ascii?Q?3mvPQbn1roSj7PEoR1VGNxKHIaKqCvxh1/hX4a1fN1yncy16tm3Bd33y6WOP?=
 =?us-ascii?Q?V5NHnf2e85mqnFdPuSGqJAyuhjm+IMGLHMaWOSNdAnDEjCl+cNcoFAkZPqfv?=
 =?us-ascii?Q?Gp3wpyxbTyndU41qmntQQtfUo1kpV8Pw6jjcPMjWgah1x6Ap8ZdDcdu5KsU/?=
 =?us-ascii?Q?YnLrEb0QUK2oBUTxft8Zz/5++E5XeOcQ05F/kM6dJUYuGVgEDW1VcIqzrX7u?=
 =?us-ascii?Q?fsgIFe9N9KyCX6FgWf+zOFlU4S5rusjQoko1Pju85ZtptYKOMCc3C/T3GZze?=
 =?us-ascii?Q?WjjLbdLOtpwqsbGpiNhGndwaPlheEjVAqhOdC6urcFQtJL4FEc0K5m0LxaDW?=
 =?us-ascii?Q?zodyPZgdkU+L6ZNDm498dmLfFWQLpIrJpaHCS/umrgW+Py/TQGx1djApgb+Q?=
 =?us-ascii?Q?TFunriAkXvHKM8dCwirehkrCXId3ZwEb2iYrwL82HSy6JmmzkPsHyDNrjYnM?=
 =?us-ascii?Q?tkm99t0DWR6GwCof6d6+q+7DBCuUx1Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac85983-09da-4c6b-1c44-08da295b89f0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:10:36.1354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DW3p04Ui61SCSciZpQMNPoAtMHskgOe8WVy82eojHGSwSA1gafqBmXGdU/RgOHoYb8DozmjMf2XOb2qdCp0897OyHX/Q9Xcir6b5FkfQL44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1630
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280125
X-Proofpoint-ORIG-GUID: VZHfCtqcZBq9V17Sy94oakcLXkB0aZqH
X-Proofpoint-GUID: VZHfCtqcZBq9V17Sy94oakcLXkB0aZqH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an io_pagetable kernel API to toggle dirty tracking:

* iopt_set_dirty_tracking(iopt, [domain], state)

It receives either NULL (which means all domains) or an
iommu_domain. The intended caller of this is via the hw_pagetable
object that is created on device attach, which passes an
iommu_domain. For now, the all-domains is left for vfio-compat.

The hw protection domain dirty control is favored over the IOVA-range
alternative. For the latter, it iterates over all IOVA areas and calls
iommu domain op to enable/disable for the range.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/io_pagetable.c    | 71 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  3 ++
 2 files changed, 74 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index f9f3b06946bf..f4609ef369e0 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -276,6 +276,77 @@ int iopt_map_user_pages(struct io_pagetable *iopt, unsigned long *iova,
 	return 0;
 }
 
+static int __set_dirty_tracking_range_locked(struct iommu_domain *domain,
+					     struct io_pagetable *iopt,
+					     bool enable)
+{
+	const struct iommu_domain_ops *ops = domain->ops;
+	struct iommu_iotlb_gather gather;
+	struct iopt_area *area;
+	int ret = -EOPNOTSUPP;
+	unsigned long iova;
+	size_t size;
+
+	iommu_iotlb_gather_init(&gather);
+
+	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
+	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+		iova = iopt_area_iova(area);
+		size = iopt_area_last_iova(area) - iova;
+
+		if (ops->set_dirty_tracking_range) {
+			ret = ops->set_dirty_tracking_range(domain, iova,
+							    size, &gather,
+							    enable);
+			if (ret < 0)
+				break;
+		}
+	}
+
+	iommu_iotlb_sync(domain, &gather);
+
+	return ret;
+}
+
+static int iommu_set_dirty_tracking(struct iommu_domain *domain,
+				    struct io_pagetable *iopt, bool enable)
+{
+	const struct iommu_domain_ops *ops = domain->ops;
+	int ret = -EOPNOTSUPP;
+
+	if (ops->set_dirty_tracking)
+		ret = ops->set_dirty_tracking(domain, enable);
+	else if (ops->set_dirty_tracking_range)
+		ret = __set_dirty_tracking_range_locked(domain, iopt,
+							enable);
+
+	return ret;
+}
+
+int iopt_set_dirty_tracking(struct io_pagetable *iopt,
+			    struct iommu_domain *domain, bool enable)
+{
+	struct iommu_domain *dom;
+	unsigned long index;
+	int ret = -EOPNOTSUPP;
+
+	down_write(&iopt->iova_rwsem);
+	if (!domain) {
+		down_write(&iopt->domains_rwsem);
+		xa_for_each(&iopt->domains, index, dom) {
+			ret = iommu_set_dirty_tracking(dom, iopt, enable);
+			if (ret < 0)
+				break;
+		}
+		up_write(&iopt->domains_rwsem);
+	} else {
+		ret = iommu_set_dirty_tracking(domain, iopt, enable);
+	}
+
+	up_write(&iopt->iova_rwsem);
+	return ret;
+}
+
 struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
 				  unsigned long *start_byte,
 				  unsigned long length)
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index f55654278ac4..d00ef3b785c5 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -49,6 +49,9 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 		    unsigned long length);
 int iopt_unmap_all(struct io_pagetable *iopt);
 
+int iopt_set_dirty_tracking(struct io_pagetable *iopt,
+			    struct iommu_domain *domain, bool enable);
+
 int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
 		      unsigned long npages, struct page **out_pages, bool write);
 void iopt_unaccess_pages(struct io_pagetable *iopt, unsigned long iova,
-- 
2.17.2


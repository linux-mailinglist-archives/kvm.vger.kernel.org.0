Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5F05A731A
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbiHaBCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiHaBCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:08 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444AC6EF18
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlY8QGxgA5VvX/lPk2j3RKwdbEvbbIJKC0DuoXZNdA4ZMyIFcvUsoHvL7n1aPnmPSSwz5vHKq0JV4Hs2x/G3uDycFTTJ6zBv5I3mJWupg5Mdql72+AT0gCMqDJtuV7qefj0haRh/uRxz/AUAXS7X/mWb9JpnJn5foEF4reG4wYklzMb4RJzJ2sm2LtjoKnxAclde+KvrunhdZBI2zutUIxiOLl/56Vujquq+HZNuoymlEuh9MhoeBy1lxvH0EAHsXUZMFShPTgb/pKqSCvuvapAu2H0LYavLvCpCBwnbVWRZHOQ9CRbLr8NvrrPsBKxbL2l6xLHXlW3Qq92/By1f2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+8RWLWlL8/vjd2/vOYscQLOB5Qb1CZdaLflCEW69wg=;
 b=ZMDHH0jRD4uvc+Nci/pHuevfIetRZGHQEkyHB0CPKBPYGI2lCfOKpPlbmvfCmswAOQ+WtN+mc4CYw+kKUz0+3FSLXAdAB60Hd4aEYZH3U4H1sAC3hIRomf6ycGMhf8JiuIaLcIwDlnLyaAzSJbmbZh09nhyF523+u8djQatPylTA/x6JsJFKFwRlYALKwFDAwYpgGogbgj7m1QEh+VXpRCGyfansnh+imMCgEaRMgFaklq3whmI/0MZ1ZZ0Wp2VQ5rwnSYSBz+RPDgcp/dRk1yW16zcB8mXej5vUgKoFQGEPPpBX9t3wHqRMB1hhwOiRV/XDUWPNdpFg4vP8JP7s6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+8RWLWlL8/vjd2/vOYscQLOB5Qb1CZdaLflCEW69wg=;
 b=X0+GQcbDsyD4Th3IMKMEVxIjfaobRCgpW6hCXitZLzv87BMbxokaxLcrVdHTJYi5lZ9EqU+lZnkPW++BUzP/BOQxKDeViZ0IAU8DxbAqV+mR21lrXk6eKmZbt1PQc/Pg5O4Orw15dVMKlEE4pFOmJIlUMhfq/WAsVrqUXgtyeY3+vgw6kw3UASVp3Px/3rrUeTe7Z04x/gWbxHlAbbA4tVorWXEIgm0A1WD7MaP0OubaI4AtjkVJe/Yzblme1vU82Q5UO0PLvuc7xkA3QpJ99s7jmv8Gs6eLbbZG0tOKTSJdA8TCpcTJ8lDI1o8DOXZaeb/oLSlT3iBsIsYcUxRKyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:05 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 6/8] vfio: Rename vfio_ioctl_check_extension()
Date:   Tue, 30 Aug 2022 22:02:00 -0300
Message-Id: <6-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:208:23d::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba509ecb-a568-48c5-06be-08da8aec6ac0
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +f/9vB7V957RAhgvxxD0LJVLkjoydOUXzr9VsSuWeW1j0vOBbuNKapoUsT0t52628E4GsK+ebhSK9WYy6rqocn+I8UhmiI8LYotX2OHCYqrMeldqdPbLnWPGGeZktTCpO+efHScxcqDJlpl/RIVDqIUsOKhydljn4Kf1MoiBytznY4DRH2FsqKGCpEIoKpPgpdJ2cdvFvSgaqR4NNB6ku+6c9dg+ExiEsaqZ3x1o+sonoFUFZ/US5nW/G6/dsVbM1j40kZDLRItTNo+akmHV2BjxJ4njRvDR7Dpqo8MZB4EkJRa1QI7pvJqdb8eoIsjF7e+AaSXfmWQ0tZyEs50qDT2mhiH1lhhTRjpqL90H2HC/a8Dwv/wI80PetHR9IAMCXi8tU+5Xezl9YewC1quQGJn6HGb+WbChmi5lJzakaLsZCZHw/a1LC69yWUtEyIWxzAZVSgb0XC74bTvEvlNhC5frhz+7bzlQiDm7+GqotX3EIo3O8XVkcJgWEIaLizAsw8rU8H1M3Lph+VnEuBZ6OYpnX7TQCTAs5i2FJl3ccB2iILu1OF2oGLr3oXS4ag8YLnxJvXOPqs47pAlI65bANj+FYWkmCIYWgiZtHovU668XAiU5zr3fvaUa80M4n11rscwDLEigDzrb/cxE3CqfDwvw/IYp1tpuJ0RUuRhwblKetRXhEPdenCkWnnvdVT0vwh6xkNq+D1K/D6q1ML5aKtyKuOQf/5Ds0F3WZprBdw/VpBZCgBIKxzOggp73dYpa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(6512007)(6666004)(38100700002)(83380400001)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/2SeGflkhnSrC8FABC5ucDY7nxKoJvfPZ1dHRs6sBQ5cqe1aLLqCNq01w4wT?=
 =?us-ascii?Q?vMQKKr+scdez8Rah4GM0xhvqDxWi6enahkrNOZwfpj7BB+B9DF1oihP6zMhi?=
 =?us-ascii?Q?TWMCbnjEvWfUGdrWaLqtAGrDVlJMvTPclnwqS1Mzy/NMqfPdLGvCuQSleGMO?=
 =?us-ascii?Q?jDlUMMOy9hIb5Amv2j1qg3tsr04OYHhV+yrihuwDvmHZAdPPmg1Uy6ko6BS1?=
 =?us-ascii?Q?g++7X3ZE5ZcNPl6ZOyIVI4VRg39Q4AKlTZqWTeMfGOLKaHZ7gW3tlQLg6hbQ?=
 =?us-ascii?Q?UYMqI+eedXyFq5t5J52dqJrlDGe0lUcfTeMekPLFC26MDnuYjY0SSQ5DX7/x?=
 =?us-ascii?Q?d0X4KlWN04lSglJjXaKVO7F2BSSvScPC40jtlixCYL9058UCik0PhcBsJPVA?=
 =?us-ascii?Q?Qe9stXubQRMYGYxgONDPLxlOQwNiWXhaF3mO3PmzSpVH51Uqya7qbtY8Wrxj?=
 =?us-ascii?Q?hOWg297R/4J5CQ4gq4dN+9Z41w83BY+uIU2jjstZ4LW5zXc4k/lKneXhqHyS?=
 =?us-ascii?Q?tGxNwMMMg18qtL5YEsztWZO+Ro2/+62uM2BHvXemRBzeFJMXsyqM3rzABser?=
 =?us-ascii?Q?2UhPppIehZwni+YZUmhv4WN8kNwgnWPmwFqIlbJxKKQzVMmgsqu/ZS+DWA6f?=
 =?us-ascii?Q?h5ZYy+WcapI8IUXenmiR1dEmwrA4IHFFABsEb2UezO+/g9xBX2+WtNsnEV+7?=
 =?us-ascii?Q?TxcBaetTGPvz+TucthGwkA8ZdjfjXjP65HQUIH6qXdXrKWAtpMmJsxbPSI48?=
 =?us-ascii?Q?KXKwcwy5ZVwyWK0NhOJ/l7F2HeYhvrX3/q1jMk3Lp2IonOkkGj4xtSrFtS++?=
 =?us-ascii?Q?DZxBxI667OMjI/04kZkHWJ4rPOm34Ol8dvatXkdXC9sxVscOF/Aj+W0gRfqy?=
 =?us-ascii?Q?wGZxYEFyI3uD6OgNVxXG76D6pYAWzqN0c/EEDoym4lmDYqAKsAR+rYO5UZes?=
 =?us-ascii?Q?1a0gv1NDlttqGYoexkWvVCNrwnBAeUruhouf7EgJ/RO6j+vaAHZJVbG5wGGR?=
 =?us-ascii?Q?esC/ywmwe+C2WI/OmD8egmFi35965khbnCRv9+WnkGy7AyQ8ge4kCCeabvVU?=
 =?us-ascii?Q?SZsIK1RfiOoFm/a2e10xCTb1NbpjHp2v7wcX2fUT/7r4Raq9ufWeGcV1HYnU?=
 =?us-ascii?Q?eI9OkAez5mqDyLhreJHnBQw+DYOKnUGnZpF4XQHqY8Nm731bAYHgfszw/z9V?=
 =?us-ascii?Q?jByQN7Boeuj8cXRGVu4PLMMqH27cWnGqgcaKNa3+wtzMUkASi5XFOPJSLL0p?=
 =?us-ascii?Q?HiBv4q2YGdA37KWVICkL+u7+txwhMAF8zkT5rHzF3DqrRNG2vi/yGYJbfDxk?=
 =?us-ascii?Q?nBXupphT7+ROz9hQRP0zNFZ8IitsGh79o1bnECqRp6MvxDwtFLYUhXUnjpBt?=
 =?us-ascii?Q?XJgmVVZQqVH02GbE5Acr3j7TCZSQxTaTsbWQzA50UHNorc6DoYDOzI2YhUmr?=
 =?us-ascii?Q?FNpSQhU8YBQ0Nf7XduoJjrYx7NxIEwFP+XVHTAM6F03WImUpagV7jXdQkuiY?=
 =?us-ascii?Q?8Emf++u/pOxDZeOk9/qlqWbibz2Aeqmj4+SlYGCNhuU9l/w2cQYB8XE6dUOR?=
 =?us-ascii?Q?jN7lVujPgZ4yZURbiD6KpaJYpfE5s/PqDaQ3cX8g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba509ecb-a568-48c5-06be-08da8aec6ac0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:03.5636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLICL1LcNwNrju4HyXGUo9T9jEZanIfmBvC+VVs5qnbdZQaBLY5RnUviDEFtCqKg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To vfio_container_ioctl_check_extension().

A following patch will turn this into a non-static function, make it clear
it is related to the container.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index bfe13b5c12fed7..e1a424d243351a 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -705,8 +705,9 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 /*
  * VFIO base fd, /dev/vfio/vfio
  */
-static long vfio_ioctl_check_extension(struct vfio_container *container,
-				       unsigned long arg)
+static long
+vfio_container_ioctl_check_extension(struct vfio_container *container,
+				     unsigned long arg)
 {
 	struct vfio_iommu_driver *driver;
 	long ret = 0;
@@ -863,7 +864,7 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 		ret = VFIO_API_VERSION;
 		break;
 	case VFIO_CHECK_EXTENSION:
-		ret = vfio_ioctl_check_extension(container, arg);
+		ret = vfio_container_ioctl_check_extension(container, arg);
 		break;
 	case VFIO_SET_IOMMU:
 		ret = vfio_ioctl_set_iommu(container, arg);
@@ -1770,8 +1771,8 @@ bool vfio_file_enforced_coherent(struct file *file)
 
 	down_read(&group->group_rwsem);
 	if (group->container) {
-		ret = vfio_ioctl_check_extension(group->container,
-						 VFIO_DMA_CC_IOMMU);
+		ret = vfio_container_ioctl_check_extension(group->container,
+							   VFIO_DMA_CC_IOMMU);
 	} else {
 		/*
 		 * Since the coherency state is determined only once a container
-- 
2.37.2


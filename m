Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C96A593386
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 18:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiHOQur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 12:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiHOQuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 12:50:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6827EF4C
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 09:50:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+5C+AEuaJPu6H7f5K8z0qtl8/lEyMDX92fIWEAVfaArqKoQRDpds6HgaAbtCGwNhwQYhoNw+x3BjydGI2X0WRP95AhOI9Z0dpMfwx8SkZz8Ny6n31kaMx1SYtd/R6fYzVUfHkI3SauDhGtaNb3NOy8DZC3URrRmcmP7RIimdhgyAs8W398r6C48J3x4Y7Ob+qcVfZ3+U2aagYKf7gDffHAoFIzA/GH2lATC8c5+mxvXvGJphFolOCh2/pbu+ykVZ0WhCTMmRuZQQ4elYMmJoxuY/4VB3pVjoHC1OYF6GIyd7GIVI5lqkbnNJ/FN3bwMDBNL+jnDISp6aN5Hr2ykKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RG0EA8fCXg6akfZjU2HUxdkKZedYLesOp6YbV4B/LzI=;
 b=jZtfAc6BWJ8qxpphzdoEjw3feeTktu5l96Vx+8IzCqB5RiDUnKgfbea4R6nXnQ2CAiJesOPITQ+R761DjEIZsMh+yUS/4YI0BUTUZ9cfumwzJaoo1xwzHlhjzv7bIux6k+YG+p8mVbvYkL7TZ3N++ruVIvQfppQ11NREAEekhZ0Ck+YM9OW/5Rx6NBuAXlu42RIdgXD+MSJuullnZ0Z1AooXMWkl79ZzBITmq8kX7a3qPfRJjonBoSoUnkhEINS6k4QI5u5RCop30RgB1sSxFz04yx36ZESkxiOd/yVA+DsU1cru4un6/iwuU6tp+YlkL6TeuDji7J0HiOgitWmcUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RG0EA8fCXg6akfZjU2HUxdkKZedYLesOp6YbV4B/LzI=;
 b=npy0F0UV6kwhfpdFl7IaItYzSDSGhz01XxYzoyba9jq/5yJOJfzzjsXpGR/RvX+iyiAFNcNrPe6/+1huoafeSpZ0eu+c1c7WztIsYV2v35QHokgDq0I3kr8hKGwO3Fu7VWEB+mUplRDUeTIXCq1uCGdGGiMb+WZbZgO3aGGpP+4Bu27rCU9B2sUt5VABYFvgZcBIe3CChQqbLDnw7llTOXEPK0oou4bNTdbnkgPbhlHUBPoRwBtNac+X4eWQ5yLG4sS1aQT9rmXDA8UenXSIp6OujW4t62qKqn4TL+2Jd+cU6TB4nfU3hlfbc4Nt/nz2KwZ2gC+5Kmo5v+GauP53Qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB2385.namprd12.prod.outlook.com (2603:10b6:207:4d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Mon, 15 Aug
 2022 16:50:18 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.011; Mon, 15 Aug 2022
 16:50:18 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] vfio: Remove vfio_group dev_counter
Date:   Mon, 15 Aug 2022 13:50:17 -0300
Message-Id: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0211.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f632b04-774a-4ede-fca8-08da7ede3c23
X-MS-TrafficTypeDiagnostic: BL0PR12MB2385:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qYDeNdECYziTQoCkVYm9PGcfX1o97B4mq5hil0OjcSFgBLqvT//1/BzR4WqIJVAFl6B0rYW7Cv48pNGSjHqHOI8nzuFjjU3cQXUGL3mLV6eOg5l2yH1jWuD8oguiHONpYZPUIOq79GCz3njpeN9QiAODyjNLrE8hBXdBYhCkZ1FO6p4jD4jmbysMDmVf817a/T0Z2vH+o4vJB7zjZzt2myotq5nBD0b1rOfKxNJvtkCErLtoScJOhz1wo93PN4PVfDGRpweCGFDFNQBKxbBr75IJ9a2X8l4sXGTBasBl+vP2iDO2I4RK1IrcggIoezJing1WQxuwofXeJpBzGayWVgt53t0nfR/33RNAUQPRZd6kkPQcXUdSwZcUlNwKByhnUh5gJ66swxVq6zBtjkuw+mSWHHa1Axc4T+vwVeIZiB/FmDy3gRUqxvbX3M6aYQgdcZzNbsSBoI7JbH5LBRbE8Okjj/12ZDmHorSreDPW53eawcZdknUPVdrNo+ZeAqHFKlLsR/SEID3kaHV3Yykul8/gkwCa4rwX6cz4t94OoTe27j6xuEed/xK3Kv5PSBeWjUfQO7Xo8Dp99/Cb4PvsutGDNecMcCOr7aV+uwgCTyV3eYiXwhIS0BHW2Py0PgCq5n7ane7vtW8tpsdb48TrP2AyWqNbAnWiDjp1/0VSsH7uxq+ebC5zc4OWESOztP2vWzyEnPFNZtTzvDrTbxT2GBXgBQ29K/s/jE1zvBMoO1Y7kNZCW9d1tAh1JHIxipzLj2DiPQtwZtm499UmcX/rPzB+GP7f1O3bWY8gpM1/tN4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(83380400001)(5660300002)(38100700002)(66946007)(8676002)(186003)(316002)(66476007)(66556008)(41300700001)(6512007)(2616005)(26005)(2906002)(478600001)(36756003)(6486002)(110136005)(86362001)(8936002)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d89GrY106fBLbUtRdRnj6cFA7GvHLzMPxitJCYbL7C2vybpvaY6HEkIfoVC9?=
 =?us-ascii?Q?quNgZrUBt1WNhGkoW6TI04B3Gw9Y4XxH2YWnGqjM5j1mDYzy1JIv3x6ARmfO?=
 =?us-ascii?Q?N6o51AAwFMoxIXtGe0rBn0qUQfoAwva7dhvmWoNuChPucOyyKsdNHzqaXpB/?=
 =?us-ascii?Q?iedmjGIPbkUYzgBM7YzdwwHs5t8NxkdAvGeBtli/KqgWlaZJ8yKcC8AiCq4f?=
 =?us-ascii?Q?XaURg2RW/Octttm8uk0FWPNCJF05i2Jr7pkXR8ycUN6g+HgS4WSDfSRPsu/7?=
 =?us-ascii?Q?E56t9y26t/aVyigHIKmV+1PeflqUa5v7uI7jR6IAe7i5UhJLSPyZvdD+aHJJ?=
 =?us-ascii?Q?ufd30pFbfcrHl5ZCL3NS6yHI2koVhpMcAxs69ehLARsWQHpCt1bA31FLAoRS?=
 =?us-ascii?Q?Xj4AzpezoeWzNJa9NAxH5m8V8KhlL+RGYsZO+qXP466DBinUniVKxitxQ8wI?=
 =?us-ascii?Q?5I5R7roToErpKsxgYfv4JBgBe2SQlAr4E7xN37MoaqjsTYmUQzp5AM0fhTEO?=
 =?us-ascii?Q?L3luFDCqQjjG2XjoVsmc5VsB+Ma35ReUA4THy8Qzkw4rKCHypH69GSH49tUr?=
 =?us-ascii?Q?fHAOHxItkORxpQny8dxbq4cvPp6HQJURNPL1jMUfiZ0J0O1vgx5t30pxMBl2?=
 =?us-ascii?Q?JHuKDDnEYDLW84R1wJOdWmLeinHK8v51LFFiHfiBGRIQBNmb0wzEN8xZkNy8?=
 =?us-ascii?Q?2ofPc7vsGO6Pk+HZR5Chmw31O9UpmE/UbGKdSsbGjWU9FwVogqkn5HgtPlwL?=
 =?us-ascii?Q?Kx8gIGBJPcFOzpv/3hh6M1ruH7K51sM42ln6Ms2AvjoWEYLWge24G5mFw/p5?=
 =?us-ascii?Q?Fn51yleOuU3cq9Kr46D+NB3Bot0Gke48MG9d8RJGT4TwsnKOygVAzWPI8p6h?=
 =?us-ascii?Q?0twYp7jHVYT2z1LAzvLJLACNs25a6sK6wuWNE1Ir+2KBC+CMqV52ddXKwkNU?=
 =?us-ascii?Q?dXwXJrnBw+Lpls8g9atlGqZBulMxxK8cNNmgYsqocCu3+B4o8VA2iBwKvWkd?=
 =?us-ascii?Q?9YZRtYymyRWpwB+Y28ZRZd63IIE9og7EmZ6Iiozl1wqFVz8Bm049pDIdqSXQ?=
 =?us-ascii?Q?r5VBE+TNMHrLjuXSlSLttwIeQbRLk/e11jLui4VQFY09zc6hfzxparmni6tI?=
 =?us-ascii?Q?5FiBKVVxizJyp6JTadFh8Xywl1jiHFHNvZpjdCUTiuZokU+ggQFlzcp68FWB?=
 =?us-ascii?Q?zD73VufzW9KKsv6jTFQJxpOmQhEzAtb1oiPRvx6ZWDl50Hqcde//yOE7hire?=
 =?us-ascii?Q?TnZ+E0QH1parexKXNYVt8dl/G+OJZU8Ckoe1ZRKz2UT1wkvgqAb7GSraT1ys?=
 =?us-ascii?Q?Gk26bnNUDEycrjq/7l0ML3VxsXMFndPaeUb451p5FyR958GQwl5cf6m1mL4t?=
 =?us-ascii?Q?gxLltFFBV+T/ULef0hyHhc977CtQb3z+yqwdO7OZgoCIkyhmxIafXd0B5D2D?=
 =?us-ascii?Q?VwAvjLre1EVpgrbtmtXk2JBmv5DnV1mBIl3dRhFKEuJQshRCZD9KPCWyeaXK?=
 =?us-ascii?Q?Mu9TVxjjVHV4DkfSo+8pJJ2dQVD8iAO+N+PS68b+JPXhRg//JV1Zd/5kuw5X?=
 =?us-ascii?Q?N6/ed+7PcWi3bD+RKR562RZCaZPIzH/5vdpIW/F3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f632b04-774a-4ede-fca8-08da7ede3c23
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 16:50:18.4427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZS6j/V6hkNWDb17HVcUc3RnoDG3J1DB32TG2YOHx/RCZ66InCpkxbtX8VFgqVln
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2385
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This counts the number of devices attached to a vfio_group, ie the number
of items in the group->device_list.

It is only read in vfio_pin_pages(), however that function already does
vfio_assert_device_open(). Given an opened device has to already be
properly setup with a group, this test and variable are redundant. Remove
it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c382c97a2..76a73890d853e6 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -74,7 +74,6 @@ struct vfio_group {
 	struct list_head		vfio_next;
 	struct list_head		container_next;
 	enum vfio_group_type		type;
-	unsigned int			dev_counter;
 	struct rw_semaphore		group_rwsem;
 	struct kvm			*kvm;
 	struct file			*opened_file;
@@ -608,7 +607,6 @@ static int __vfio_register_dev(struct vfio_device *device,
 
 	mutex_lock(&group->device_lock);
 	list_add(&device->group_next, &group->device_list);
-	group->dev_counter++;
 	mutex_unlock(&group->device_lock);
 
 	return 0;
@@ -696,7 +694,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 
 	mutex_lock(&group->device_lock);
 	list_del(&device->group_next);
-	group->dev_counter--;
 	mutex_unlock(&group->device_lock);
 
 	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
@@ -1961,9 +1958,6 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-	if (group->dev_counter > 1)
-		return -EINVAL;
-
 	/* group->container cannot change while a vfio device is open */
 	container = group->container;
 	driver = container->iommu_driver;

base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
2.37.2


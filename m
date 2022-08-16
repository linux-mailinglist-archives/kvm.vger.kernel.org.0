Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33905962EA
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 21:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbiHPTNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 15:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbiHPTNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 15:13:10 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62ACE0D0
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 12:13:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNev6/mgaXfU6jLYc27twJJVuNZBalwGYs8GCnzOy2Xr4tK4euB9K5PLrhIT0WTv9oPvTuo1tVtLvT3MqBFsDFYLMPOqQfqwrmRgGKQ55imwyNXgK0w+fccFuV3rODFIOfcfVggu99YyXOBdDfx5GrQPq5d8hpW9bHl3sIY4JykmKjPRcG6LESEFcwntkgpsW8uNxEjpln5JzxQoDfk+n1tuS1/KIzrdG80pppHj66UDpbz05pJYHVRbKLiz+pfA88CVdl5VG4Qp9Aq+5XA2RDWVQoGwOBh29bMmHycaSQngAlW7dDWFZ8J5N20ByXgQ6BCzbweEoebbO+y9Oqq5hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQBRNMCIsqsT/6OUODJdTlHn0/RecdhJ0mnKRWdMFWY=;
 b=SUmT9CFNiB8GKxW7lK6ts/+BRSo/PJt+MLVj3Imrp/+NwSPez6qIATtvFrCXjZfHyV9VVKhfg89gemu0Ghk/fDRlO9ZRJW4GlMpptbUbi4q/bJeTdY1WFbLKGRUxiw4zPG5LV7+eSSFfj+l0dslvwUURZOQr0Bj55V5BH3D3mggPwTlXGZBtOGnfD9s80wKmOCE9gIZVLumhuPQ6c3H0urlGJaXqgT90WSW42V3DrSujTtdq04sHom6GVFfmAxuZrXt+41tIpoQ+tMPIKj7HtNUfovx2pa4MTKNrJwSblimYeM3/r6RacNB8cOsKnSqs+1FNuHd0Y1lVacuF/3g85w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQBRNMCIsqsT/6OUODJdTlHn0/RecdhJ0mnKRWdMFWY=;
 b=b/8O6ZAxBJ44bsoMhwazUUIEu/RVIEh4gmhOFqLRg42p8ofp96LqM7OVd0Uvsnszdil82BFPw0rSHPIe45huAu5mE5Xx3kYRnS/Sb9CCgWAYnHnpBagVQmUK4AThI8ivYcWXyaco2pj3sxYXuNCI0RpS5uZrTsOosQ91z2/oy2QGb/ZLoO4j1ULOdZUbbhXLblyk9LyxrN2PtfAgoMe2uTscdwMdvK0W0zwrAKaa5d00Zr8IojQQi9JjHk0Zebm8BOSOa5pm6+kIcISkEHYqfstem0NoFfwr2xl3wLUiaqLBpQH/ly2BYyiqA/UhVfPXeKTBKUraJbq3upMtL+nfnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ1PR12MB6361.namprd12.prod.outlook.com (2603:10b6:a03:455::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.25; Tue, 16 Aug
 2022 19:13:06 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 19:13:06 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2] vfio: Remove vfio_group dev_counter
Date:   Tue, 16 Aug 2022 16:13:04 -0300
Message-Id: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0023.prod.exchangelabs.com
 (2603:10b6:207:18::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88332fce-1d7e-4e3a-96a7-08da7fbb5957
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6361:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ajo6w6n7l8SzEnW6NTUKsmUeCthp5xkqDqfkiThdajf9mdqseNpJqfHSwkqRLRdsyDPHO0VSYxuzpXo89sfIa9hfvoElS0TZNjKuZd6DeNgcGAdESsdhGBMp6gIITsbLA6SVZWZsa7obIK0bHAzvkpQjx2TAHUqX0bIup3ri6imbVR0XHGmlgZ0vg6NnZqMubNR4a6cpIPaTdN2kjgiAKTNCWt8QNT3Mj1llfH8Kxw43zZa/en/WZGY10EWXXXIL+nKPFMP2f7pH36kRghGruB9dKvRo6795QQckcEnfjdbRh///fXOOo6RFVJ3bqQpVC0Ai8ZY3laOERD+BDAVu+pHolbPl3V7MCfVeW09YdFI8CSGj1Ckc6Wy2mkSW24GJozEWVKCIxs+OJcLc2BJKVJGQMpwhEOCEfAplylPK7TuN/zXW9KN85V05vpJ9wcX838ey+KZNw1tKPTTqKtBYVjSLjsdQSIJdYqQy7HEbZPgIbjNtZ7KricnZg/FLkoGCGprcj9dQgU8W/rDX9pZ3kxId2IKceXHCXxXk/TKeS1RH9stHY2LKvXrqM9DLSu67FxQ1+NTFLK1gcak4Kl8pj/XZahvZP4ALPzrcJKZ7ud1/rGJfZkKGkgJUDzrJBOTYIdaSI/jgHsMDckyF5kk2mi0UaTY9XiglLwTGRG295qkORk/7JQkU651pCh7gP2izfiujPBSCLiCLqK/HDUoJ/m3Sa5d+TuVzEGB5sBKUF0rv0TEZTYyBInHcQyuV6uMFgo1vY+nSWYZvcU4lOJJISZGjyTnU8K/zT37TBc1LZsMLLVWiZk9m7G//+uIXIBv+xUSAlLWMN5lzBbs+3XTwQAXtIjZgfogpPuJ8AUX/ErkrjJYVMOLJDh8NnCJSFtEG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(8936002)(316002)(5660300002)(86362001)(110136005)(6512007)(66946007)(83380400001)(66476007)(26005)(66556008)(2616005)(8676002)(478600001)(186003)(6486002)(966005)(38100700002)(41300700001)(6506007)(4326008)(36756003)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bSTPh+Vr92q+COCF4HwFW5X/kPw45ecTZvcw0zO+WHBV2RDzj+SSbA02RE8/?=
 =?us-ascii?Q?YyX9JOmXDbjNyp8owntLo74W7liSMlcnz2nUKPyBJdBrJqwV3bqF+lg54Yyp?=
 =?us-ascii?Q?2AM2diKak8MQ5CcM38P4cf/gcS6LsGOGIyS0zfy0oKJ6bfEfM0W782TqodOH?=
 =?us-ascii?Q?Vc4hTBzf/cn1k5gPfTed+eMSm/AT7jkswqq/3kaNHvFnLmIofgxr0Veil3Kp?=
 =?us-ascii?Q?m5aX0g8RijTbWAE9IxGTP4F1xjxypqJSnW/RGiokU8wOA6SwFI/QpLzN/vio?=
 =?us-ascii?Q?c7vjc8IGLp74JNBq+cvUPtKtEgoLL/WHINkZXrKjVt69550nng9wapc7mpTM?=
 =?us-ascii?Q?xUK8+3EY5u+0s6VUu7VjSjQMGaZy3mhXIzPxAUE+0HU9ttOW5FKJPYmZUhxz?=
 =?us-ascii?Q?AkbE6ciZ6Xjbouid6aDeV2xODLuYuWRwfx/Ypamryjw1KVIMJ3zyp0LkS8ej?=
 =?us-ascii?Q?B2VM3gbS7N7jBk9GRmaTKjK2UiTY//6mxTZP922pHF5l0nKVgpiM/vRYaPkn?=
 =?us-ascii?Q?GShSrH/bPpn1Aquzmmc57Btfj8yTck7jvopHHA+SINb4/mMN7Tm6XowgFDWM?=
 =?us-ascii?Q?GtjSfoRuFamCUn6lc9yDvWhx9VCb27zjvMMAbADaki4rhR9UdRSRJ8vpOxhb?=
 =?us-ascii?Q?4J0AzeVAeQqnJQjVhAgINWb44mrYxp0IAS50f/nc0xRyYO5SHSWb1CQ0+FCy?=
 =?us-ascii?Q?n5kjGQzpPgO426fhbH0UeZyQsJo7vryCwcpokxP86O4cQ8L2dQxxB78/uTXz?=
 =?us-ascii?Q?dHq/Nug/xDOo0+ml7P+Fo2mdYxzqV76vYY0+TNXLtAbU3KcrMY/+uz61xMSk?=
 =?us-ascii?Q?nhfI5LY+7/48f3nZrGdoL8PwAidRid5uB3n3D2NSBxv3YNMUZdZF0PKQdLZJ?=
 =?us-ascii?Q?ggR05VJkAeCkKSsv2kwMhpTJrFZVjU//1g/c5l0pKTEsvzMDpIemPUmcSXQx?=
 =?us-ascii?Q?mwWC7oxMhPSMHUdkFcLoeROlHboJKYghNqV8yZZDOICrDhuBguOGU/yFj/sw?=
 =?us-ascii?Q?hgxpnJW62cCiaLFUBFw2cICLBZ8j0k2IKI2w1CEgVMGoRAyBXim6/XrvlczN?=
 =?us-ascii?Q?O7h6oD6/uBcT0/eilVf1lFPY6NUnr7kEnCTbVqcMtzYjwUgukrVkgb0Wowoc?=
 =?us-ascii?Q?OEzK7LiduNVx5j7X67Tq+yTxsXsedsGMMsNmHPVripgu+NKPP86T8WiixctN?=
 =?us-ascii?Q?hQ+ZyAvADi52t4om1taXBidzz87UYU3OOx6uChVLoh02EMD1sgteBdWYqgZJ?=
 =?us-ascii?Q?eHzWKko5mjH9Z3C6eD4BSkgoM7oZLN1BPP00eaMClehNoCHRCyp8bzIa1g5a?=
 =?us-ascii?Q?zfpRGss1AicdhRDrZwiBFGkXmiTWok6iAZQMXtBvumUkO47phn+WDaSxC031?=
 =?us-ascii?Q?q6LpTBXRqLRVwKrNTO9UmyKDaryrNh/VFeinyA6l2h6hu+BcWr17ymnAA0BV?=
 =?us-ascii?Q?iMJfk7vVSWTXg7weYvW77vifulbBpGV1hMpYl4UrLOQJyj0OjZjUB25mL4Aj?=
 =?us-ascii?Q?79toZCjG3MymbBV/D66Qs3WOv3OXM3p0fmIUkOm6no1eRMQFNHMuaIfFLL/F?=
 =?us-ascii?Q?HsUaGQkRNWgU4F2DPI/u0U/BwOFOcs7ilSNxvOTj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88332fce-1d7e-4e3a-96a7-08da7fbb5957
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 19:13:06.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x338EonOj3Bd4ot4QKxXX87BrmGd1ghCT4rj+8kP/Nr//CS1BGdKsNeGTlDFuzRN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6361
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

It is only read in vfio_pin_pages(), as some kind of protection against
limitations in type1.

However, with all the code cleanups in this area, now that
vfio_pin_pages() accepts a vfio_device directly it is redundant.  All
drivers are already calling vfio_register_emulated_iommu_dev() which
directly creates a group specifically for the device and thus it is
guaranteed that there is a singleton group.

Leave a note in the comment about this requirement and remove the logic.

Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

v2:
 - Reword commit message
 - Add a note in the comment that vfio_register_emulated_iommu_dev() must
    be used
v1: https://lore.kernel.org/r/0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7cb56c382c97a2..94a76cb86a0388 100644
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
@@ -1946,6 +1943,9 @@ EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
  * @prot [in]    : protection flags
  * @pages[out]   : array of host pages
  * Return error or number of pages pinned.
+ *
+ * A driver may only call this function if the vfio_device was created
+ * by vfio_register_emulated_iommu_dev().
  */
 int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 		   int npage, int prot, struct page **pages)
@@ -1961,9 +1961,6 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
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


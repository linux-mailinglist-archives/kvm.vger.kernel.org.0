Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A234E5B91
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344131AbiCWW4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345358AbiCWW4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:56:21 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2922490264
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:54:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyfQz2cWzBtCjZCe1bT/bm9Oms/idot3Bv9QLcxVKbNSmreI3cK8OwGrJJHbSM6+cTJb0jDea/2di34+CEkeuMCsGupAY5bMP12VLd6wublK1DNe4Udnnv5c2468FUEB+AaZrI0aBIW1DKYEBPi/u+Nt7dbJnNWkWwVWorqKkMA/Zrg8ejTSzZHRuWs6JgxcA1q/ftwq6G3hWJG1bMcHVB4LhPxuPWqsA8OkvmcoGWZZg4i56PFc8cYwdgKHUZSZU6UWjPHtwMvx1H3GTun6CKFNxr/u4Mzg2lLZYHXo81vvjiKhdHyjTo80vMfDY83lq1saHTi1/X3Jbmfx7bJDwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOlDUA7/f8dT9RVHpQwhyN9s3aluErLjTUu5WnrZImQ=;
 b=cQk7nJpdXJrAlksu4XdRXth+T3WqjInyJ1OGMeqCNwee9E8ATqULU6xvtMhLt2E1qq+B8aAP14/0ifo/yEQezd5Rvs/KVGWcyStsPgeSYFbcwo5Dkf/JBMTNy/Q0d8C46EieniBoH8wejjyWBOmUWjS4iYTeMzm1DtYF8J6BgZOQXzjvhQmlMbCuM4Zvo7Izb7TkF/6x9541eUZ8nuYef0w6uxhbO+8sLsARyrycC2n9MJoGX4qCPkRu98OpCeq0oT29mUiMuzfhYgZyfzl5FraIz4Uj0n/SYV/Z3qHIR9xICz+D/6a2ujaildV62IGyzLtUa+EsziOwa7H3c8s/BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOlDUA7/f8dT9RVHpQwhyN9s3aluErLjTUu5WnrZImQ=;
 b=n7AKvmQcOfHy7DpGBlFh3wxyCkz3tjQew169n/MgZr59K0kCt+D8K1B4vlu+vwNgrW/GsHKXha7yLOC5j7cwc0K++P96Uw8inlJ8sm0pHjH6qO8MYyRXvsWO/sIRNfLZwb8d/1jsYbFZHvi11e6iR+AlXs/c210w8Y8ycadIP2NDwyrd2VDjLq1jnxx9It+RuexydOZssdoWR5HGI87/38UvpG6Shr0ja1psh/ndAsaLncazfPsozXLmcR4n7aRia970j+Fj9hqkxum97l8Z7nZUX1nHwfX3NInmHAGi9n7AR+HrtqORn497veyisDCMQrNoSFSEr48uEJ9Av789Dw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5469.namprd12.prod.outlook.com (2603:10b6:a03:37f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 23 Mar
 2022 22:54:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 22:54:39 +0000
Date:   Wed, 23 Mar 2022 19:54:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220323225438.GA1228113@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323131038.3b5cb95b.alex.williamson@redhat.com>
 <20220323193439.GS11336@nvidia.com>
 <20220323140446.097fd8cc.alex.williamson@redhat.com>
 <20220323203418.GT11336@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323203418.GT11336@nvidia.com>
X-ClientProxiedBy: MN2PR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:208:23d::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4543f435-9341-4f0d-2087-08da0d201c73
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5469:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB54691373751A548AA89326A7C2189@SJ0PR12MB5469.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2BtoUZZgyWZ9MluitQ2+tPfujp4zCgiB9YMXBBcxSi2IxzjVsQ4bmB7BMOIM72n3lfBVj4oJqVNpaoN8kLgrFR6Zn6kQ9DCrmHkE+31F8wgJO6hAHJ0aytW9Y2pP8NMobqpCHIsu43aYtPN18LSyRJhx+n4NaSlBUamo0ErwJ+e/utiyynVZGoDJ7GrirkNvkhP2oVjvfyw0Ua95iRvzKR4nkDdmdu1qbNSX3eF9wHUAtoZ0+NDa9+EjX9nl1HpNKsOoq6pnQs1B7kKZ6LM83+LEQxqKdW9Wn814dOS0bComDRyTkNhyBQdvBWMkdLn0lYvQHNEY/ZKW/r+2VscqmmRU0ChCh4IGVIWdXb4edVxsrFQ4Ra0O/cyP/KN4WsI/OnuXNch/UMnWgaiaIJIqDAjytAf+QK1d4IfEVExWXu5o+hRE2WGpoQBpq4u284X4YJgqp0QrY+mpneJ0lwl4YIfyejgEaJTWeTkAaGvlGrO/Huu4khOUNBI/56ByWxzwGJN7q/KwSD9BF8FVskyPf0sR+RT5hKifLHHeicfGod6GDSYAohrKVvrzmEntBfctt6/E/BZq7b+Jf9oQSmsvZKcDfdhfA3najb/t/VgNDAFKrVFIP6SGWUmReq0y/j6p5XpTgds3U7IUmUgNQRjeRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6486002)(508600001)(6506007)(2616005)(6512007)(33656002)(1076003)(186003)(26005)(66476007)(66556008)(2906002)(316002)(86362001)(38100700002)(7416002)(66946007)(8936002)(4326008)(5660300002)(8676002)(6916009)(36756003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?//GFOZ0OVztjgCak61OG+dmskFfv+Yo6ofJkQ5jMwRREeNeN2E4sz4f5V1pC?=
 =?us-ascii?Q?y32oBr7kDejM6XJrAmkR2BzdlAq8IQICz+sFWwXMuyYqANQICZsTxuzHugeE?=
 =?us-ascii?Q?dJ68G1k6wERxi9W7w9FZSIp8KS7T5R6hR7QHze4+LE3VNcbBROTdnq/OOIBS?=
 =?us-ascii?Q?5lURPjXw1HrBI0IlStW7XtKPCFDAsAH4OqRdP1F6uYwpqXNvJM4ArVvjsJyK?=
 =?us-ascii?Q?fJ6zzCkru2UzQ0CVGQ29L3hAmYYptw+HobTPGf0Pp/PhWspTBaTqjQMn/t6Y?=
 =?us-ascii?Q?nw84wji/Eoe5r9y091hGEDis7IvAuEw1fGhW40QAnkEJh5BmT+NnIlH19Nn5?=
 =?us-ascii?Q?dSiZMjCMviaA7VLCbLYVdo9lZ3/WGRO8rcJI6NUCGISZXgX8dfIcKQkr7xZP?=
 =?us-ascii?Q?pUCotcUyvVMY3d0MjVbQi0UaRwQy7J6Z7GRX3ch4ILL5H415mdYu1vvAl3rh?=
 =?us-ascii?Q?a2AK8NapI2lG8LHok9fDVIelpQQ28o29DcVz/nJPhweG2EGsEHxezl4cvysU?=
 =?us-ascii?Q?Y99292x8AGUJvaxKtXUHDnICq+ijuazNhZ0Wq798lHaikB7tm7An38LLXCTn?=
 =?us-ascii?Q?CIIotIZDIGuVmY3LZ1riezH0tKW9CKauDiUiMS6gXyrlLwl5G2VhL6zVsmIq?=
 =?us-ascii?Q?a17zIaWgtqX9wdfOaESVyzdIj2UpIAlKlNZdCEFq4ireFsb/1WJlokLkJsW7?=
 =?us-ascii?Q?aiEXLstBlPQh8MMwxnosiz+ybwSBwksIAV2fIcsoYZOso2llsvRi0ouci2xp?=
 =?us-ascii?Q?XeLiTCdiowzTyQb87vExFobEfI4fSHsorOpLKt9a11vIoKY9EDnbI9Sc/1j0?=
 =?us-ascii?Q?aSaids4fDdaLdCbQ/lm6IVkDpDlRU1mAt5E3sARql4bz1+nWaL73ha077jej?=
 =?us-ascii?Q?VztzjurWgNKSinpFPH3KlkBgdS972J3JjsPpMC/FwG2wJ1YolQLfKyV5IBnv?=
 =?us-ascii?Q?Hmm2h9CecoB5wi8kINpfQy4ZzbkZ118A4uRmNbWbbIz2fNuG5G8Fo6p0plSz?=
 =?us-ascii?Q?w+9nFIQVYiC5vwb2MT7/KhESGayjFq+XHfMr4YhFJbm7Pjr+O/yI5ah0IR9i?=
 =?us-ascii?Q?m071koH45BaULrYIBXCumF+t9Zf0IVsUIr+2xti+DLAX9gYpe5hyU29LNAub?=
 =?us-ascii?Q?zQAlTgmJbzkh7Ab0waFDTNoaLm+EWtlHtXOaEnQZPt3t7GtJc51TQ+5Trk+8?=
 =?us-ascii?Q?BtxAtLp/0faMbpen0oxhCBwgtN2wB+zVRN5gJ08tNoRjA9PBFsNKQrqKkY5A?=
 =?us-ascii?Q?bNmoPkZI2uMbHndveMQZQIsiQ62cMxe5kWx/l4KBtrg0PJl2x56clZeftoLi?=
 =?us-ascii?Q?Qf6UY3gW3l8Y/ZJKLbtbzzk8Q/xjXStd1AADW4Lj4MceGn9qM1yJVGSATN4F?=
 =?us-ascii?Q?x0IvhKkGBymk8DO4y4VfMWCctHVUU1QJv0FYh/OGLHMFTrduDM4A6ZhwkkdK?=
 =?us-ascii?Q?tLVMztovD1qZWqy+lbrT4bcsp+iRUbhb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4543f435-9341-4f0d-2087-08da0d201c73
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 22:54:39.4705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6ER4LnD4U01Aulx2Dk9UPa9/3B6pNOZ410tUh+xhf6Xw7SMx2cJiBGgZZDCklCz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5469
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 05:34:18PM -0300, Jason Gunthorpe wrote:

> Stated another way, any platform that wires dev_is_dma_coherent() to
> true, like all x86 does, must support IOMMU_CACHE and report
> IOMMU_CAP_CACHE_COHERENCY for every iommu_domain the platform
> supports. The platform obviously declares it support this in order to
> support the in-kernel DMA API.

That gives me a nice simple idea:

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 3c6b95ad026829..8366884df4a030 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/irqdomain.h>
 #include <linux/dma-iommu.h>
+#include <linux/dma-map-ops.h>
 
 #include "iommufd_private.h"
 
@@ -61,6 +62,10 @@ struct iommufd_device *iommufd_bind_pci_device(int fd, struct pci_dev *pdev,
 	struct iommu_group *group;
 	int rc;
 
+	/* iommufd always uses IOMMU_CACHE */
+	if (!dev_is_dma_coherent(&pdev->dev))
+		return ERR_PTR(-EINVAL);
+
 	ictx = iommufd_fget(fd);
 	if (!ictx)
 		return ERR_PTR(-EINVAL);
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 48149988c84bbc..3d6df1ffbf93e6 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -129,7 +129,8 @@ static int conv_iommu_prot(u32 map_flags)
 	 * We provide no manual cache coherency ioctls to userspace and most
 	 * architectures make the CPU ops for cache flushing privileged.
 	 * Therefore we require the underlying IOMMU to support CPU coherent
-	 * operation.
+	 * operation. Support for IOMMU_CACHE is enforced by the
+	 * dev_is_dma_coherent() test during bind.
 	 */
 	iommu_prot = IOMMU_CACHE;
 	if (map_flags & IOMMU_IOAS_MAP_WRITEABLE)

Looking at it I would say all the places that test
IOMMU_CAP_CACHE_COHERENCY can be replaced with dev_is_dma_coherent()
except for the one call in VFIO that is supporting the Intel no-snoop
behavior.

Then we can rename IOMMU_CAP_CACHE_COHERENCY to something like
IOMMU_CAP_ENFORCE_CACHE_COHERENCY and just create a
IOMMU_ENFORCE_CACHE prot flag for Intel IOMMU to use instead of
abusing IOMMU_CACHE.

Jason

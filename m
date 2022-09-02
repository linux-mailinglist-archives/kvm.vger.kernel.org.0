Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F67E5AB91F
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiIBUAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 16:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiIBT7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC29429CA0
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiEIf3vNOGg2SOQDHKhxz4bkYp39unRDD+A+a8Cf6RKFar/Olh9crwgA2ElL4BQSAEb2u4QTnIgW1UQBfNrccJEhJowuLkMOkp7BnYpImE84fojaSJqsObpOjavL+LI4iNd2nEUfXbM6g1DoCtEzlV5th5hnOdsQFGlwou2AXIBp/U9KDAcBIytoSnZFnMmWyTLXZdU4oyMnOPMW8AmycatufPtc6CNcPeFf2G0m7buEy5zdtoq2RXjEvTAM0IhK47oAbyQO6rHmBq8l5Zh4uekofZ5aCsDW6mFPHHjpDVm0+ikxDntndeOn9lWxHqFCgAzl1QocazHZq5voMPWJvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3ggYgxsYzMdXmSA6DKZoblYoso6sjueIOAEkVxiw4E=;
 b=FWLlbIr1+PkQlTxay8xZhDkp5TBt4gtoo4pFvCm6e4LLZEjzdRKuFjqMrl7eook68L520K6CsU7xlfYVIO65Dx9e9Ey8O8OM9kQzwwDmZhuyxOwPhx2oLg+uq6LbpSDu0LIX8gXYWWuoFWfX0DiPxzim8uhBo+erpFwfBiOII5i8Gd+RwYWgNDHUQ/eplW1mWq40q57kM614Gehgv3wUtkcwMSap4J6rVf0FlU9jBRso5aNEX0CuW/gcu0KiCTe6obKK7Pbtod+VIXKFdc+XL3FvH+VDIRHEbcCPmvL08eabgiHdxEhHT4+mJ/ImiqycITv53/lJ6Xwiqul8dw9PbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3ggYgxsYzMdXmSA6DKZoblYoso6sjueIOAEkVxiw4E=;
 b=RtPzJW6rVfIjwL72cKxY3/IvAe7YS82JpHu/CJ6v45Nw2Dg1H/XpK1r8plACAOgNlDkDs4OLG6yzJWAFOBctgLKR+g/jdudmTxZ2lGcJGL1ISmavEHln6pUD7sRN1H3LDkUCrR30ATy0HXu0+8OQDDLfGBPNVd0DyqGkzS6gdEdn7qScRVYYtvnBoJ39iauHYY12jb7t50Nmb2SK0UA5gm3csDlMBXBPz/ukODACnThgaaxYiO/bEkgZJeUbmlpM6yVCe68PdCrwW9TYTVmXunETdUcdHJImC4edJuRW6iotrr1KyYNwBSNMMFrUbE7pK/WGeN2TZAbxLgZqPr8YyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:33 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
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
Subject: [PATCH RFC v2 12/13] iommufd: vfio container FD ioctl compatibility
Date:   Fri,  2 Sep 2022 16:59:28 -0300
Message-Id: <12-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0029.namprd19.prod.outlook.com
 (2603:10b6:208:178::42) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96674107-ad41-4c7d-c57d-08da8d1da646
X-MS-TrafficTypeDiagnostic: DM4PR12MB6566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VYLU7IZvTz9Qf8qrUIcG1mK+7Jas16Lvg+ZkZCtjzSMW8rtehcIWobPuNtLUhQsGcAYFersR52aKtRow69smbsritblKQdrNGU4tUUqvkTQYT2qhP/3dZ/1lRsbSFvU8JbTxCGKRK/yJ5Zv19YXIs28XBLd7Ul4bnNogbGMADYDp2NoWhR2RYwTDyjxipC6rWf7BTTPo/LBZnNRJ2yHDrMeNxmMGYgZQ3OboDgMjzna2fCGlLpi68PJUv024cjsvFgD8oNi5BQkJ5RkS2l5zShLuZdwZGFgK2XsNtVu30YVvenwpLL0tpNk/9LIbDfoYucpg8OXwtWvyRjUOUpllHhp1KRtbaUm3saeLcfOZSU/3HTS30PRe0lwO7yKb+kyMn7lC8ZZ1Vz6PU1+i9oEgxVD3/hUwZEZRGpTz3AP2OXc+EbhpsEOtr5u+1joIrrnyh2uhS/+T+unaKKmVn86J/lyETkoZ5QUXGa8qReM9/wMREoqqkgRD+k1e2RcDjRGWoBY44v3dJCr5fqS3DXA65n61k4/35Vt+3hW0qcjJ1CfY89WMdFs4o7WKFP/P4AHwWgZAUZ4iYIzGk7jGPvaiec/Ca0nHMhNjTJk6zsU5CgOGHwI2gau+3Pv2dKbdaDqYHucMWN6B+HDfk/m6PMs6iqCwOUr+eo8RhuqKhXAs3hr3Q88aPA7lxpDtUDBW6YpNbdq7V6iu2j0051xZSyUgJ9kKMAH680AKRpo7L2RGeI/6mfOHCx4KWXCNkuWF9iJA8/JUGFxExwff8LUW3yC9xJy9D1MsDCrzW58s/Vn6bxEBQFtu4fqTWsyWuj5TZCZknKJ1u+nhOHc9x3HwjsLOhQxy6qjIj27beuHD2U/JLgYI8RraWWnmoIlBqOD+mkFK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(30864003)(5660300002)(109986005)(6506007)(36756003)(966005)(83380400001)(41300700001)(8936002)(6666004)(6486002)(478600001)(2906002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4326008)(86362001)(54906003)(7416002)(26005)(6512007)(186003)(2616005)(316002)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBf1MeBjnCY2ipF3oVYPDc01swPgTtJhAyyWYqUpGKZYYKg49jMGPoDBN7xc?=
 =?us-ascii?Q?aV/U7GQL7CqtZQ7cXe7D/227hV44G5txTBCn7IFN5uLsy6ceu5LoUIhxykiv?=
 =?us-ascii?Q?hGjEp0akDo72kmntm7Lq9ICCuoIEya4+LXTTOS1TFy912jOGqZuP+CQr94RD?=
 =?us-ascii?Q?RCGlbikXJWdk+ROrWbpLWJoEAaXO0YAWVv7mcMPsuRJVosy/LpgIVpNcha2E?=
 =?us-ascii?Q?dXqFrXu/cW32dmRaItXuElyCvLCOlZzYiGUN8Zme4zKhDyZGvpFQ3rgIzFHs?=
 =?us-ascii?Q?n51Pjo1g9KdAisRMwDmQbfhzOjpAMx+sHugenbUMU75/WMvyJMV7TE4Yuyex?=
 =?us-ascii?Q?sNnSWfqGQLlKpO6xwQ7ncZNDfXYc1m/H5cofxhbLwaXHk5w+hZrKJHtYy5vS?=
 =?us-ascii?Q?E13J3xpGQvfuerEH21GuT3NGzHbkjKYv0cxxWYe6Q+ZqPnk9S6bXzsjTIweP?=
 =?us-ascii?Q?bVhsQec/gefbIN3V+eX/oSkGxi//FWzIDt7NDjQsal+yv1rtreHrA41PM8GA?=
 =?us-ascii?Q?CiF/n7t2Q3pa8CO/zt4r9SdG7Q5s4qo2/uubq9OsfK+D+kp3PdBrwF5IOgiq?=
 =?us-ascii?Q?ZtB0Q+6waDUqolyG89X1MdraayrsE5rg0/iBRo3a7Uh3F5hyHpaf9DmO2XV+?=
 =?us-ascii?Q?mchCEXRrP2K9XRJaKtkoV9dQpLY7yCnjOjNSKgxICUWGWEHgsPhDtFNKTTbH?=
 =?us-ascii?Q?GpqOr60giPyxoGB/F7nBnf+6Y6feQB7HpOZhRYTPtRQpl/WBo1oAR3Mftk1M?=
 =?us-ascii?Q?QlGMc7p21r3+kFbmz+8PQltOWQSenh4EjxjYw/Lk7AnBT9XM/TkZI9oj6eYq?=
 =?us-ascii?Q?haJQwINY1q4tin490zLYVcRT6lBRvCTnoUdgd4GL9KZmgvFMtwoROfCRR3fR?=
 =?us-ascii?Q?cYUqwVBWeIvnoCPqs385deNioVE3EgBqb6XMLIzDQPqkkt6tQ9bMCmz2ImCv?=
 =?us-ascii?Q?b9gdZUAJ2AWAzhEQxT/TOBz/b7NH62jdyy6IYi8kNxdYBCyS+KlWUlD+0RGp?=
 =?us-ascii?Q?MY7pF7/OtT3H/Lt0+cekOMTLvC8dFW7E2iwoaUM44KBDdgsFxE4cC/i8Ki55?=
 =?us-ascii?Q?2FIVylI6QVoAav7QpGSL1V1eSaI6nmMokvFZ5HQbUt9C26c1hsbkF5QDohax?=
 =?us-ascii?Q?Hc+C3anLALZyt8D2kzETr+PLdka4m5KR/ld3h4ZK61XHivukYXzjCGg4xhco?=
 =?us-ascii?Q?cfxDAkwiMyZ49sG7ocq3C+A9mOmInz4u6DLPZHe0egWbe3HzAy6H+G/Yv+DL?=
 =?us-ascii?Q?OT7JMZl2wwK543ebkz8mb+3OT5Ocx5qRG0drZMVq3HBohQsiDYzaMHQ9y1df?=
 =?us-ascii?Q?Y7g6f5MobJ7cy8ayq5xc5F5HAwyJzE/uYQ6k6DA/DYznD3oYJLUx7BNTLoBE?=
 =?us-ascii?Q?8vuBt/qlJVn1orksC3/Vn2I+d1Y3VVwBge+V2aNZO0dtAEeuXnq1vSjs5lV6?=
 =?us-ascii?Q?Dr0P2L+rP9R7gXzRjO3uMzGNgMYoFJ3DlMd4EGjdbkNNZxfDYXtys2WCSdLr?=
 =?us-ascii?Q?gNC28iX6PxM3sYvrHg4V3lkioNJdUG/G1WwCdou66UMIm91Wyxy6XLr6qUZz?=
 =?us-ascii?Q?cDGZUilhwsRSikAS3ilCm/jtMomQ/UcC1g8NgVo4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96674107-ad41-4c7d-c57d-08da8d1da646
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:31.1601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Xb8ZuFSYKHOfj1j4w5Ocv/4fK6xmZYZsK3q6KK/bSAiRMBoicIOnvBxGwQx8C4G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

iommufd can directly implement the /dev/vfio/vfio container IOCTLs by
mapping them into io_pagetable operations.

A userspace application can test against iommufd and confirm compatability
then simply make a small change to open /dev/iommu instead of
/dev/vfio/vfio.

For testing purposes /dev/vfio/vfio can be symlinked to /dev/iommu and
then all applications will use the compatability path with no code
changes. It is unclear if this could ever be a production configuration.

This series just provides the iommufd side of compatability. Actually
linking this to VFIO_SET_CONTAINER is a followup series, with a link in
the cover letter.

Internally the compatibility API uses a normal IOAS object that, like
vfio, is automatically allocated when the first device is
attached.

Userspace can also query or set this IOAS object directly using the
IOMMU_VFIO_IOAS ioctl. This allows mixing and matching new iommufd only
features while still using the VFIO style map/unmap ioctls.

While this is enough to operate qemu, it is still a bit of a WIP with a
few gaps:

 - Only the TYPE1v2 mode is supported where unmap cannot punch holes or
   split areas. The old mode can be implemented with a new operation to
   split an iopt_area into two without disturbing the iopt_pages or the
   domains, then unmapping a whole area as normal.

 - Resource limits rely on memory cgroups to bound what userspace can do
   instead of the module parameter dma_entry_limit.

 - Pinned page accounting uses the same system as io_uring, not the
   mm_struct based system vfio uses.

 - VFIO P2P is not implemented. The DMABUF patches for vfio are a start at
   a solution where iommufd would import a special DMABUF. This is to avoid
   further propogating the follow_pfn() security problem.

 - Indefinite suspend of SW access (VFIO_DMA_MAP_FLAG_VADDR) is not
   implemented.

 - A full audit for pedantic compatibility details (eg errnos, etc) has
   not yet been done

 - powerpc SPAPR is left out, as it is not connected to the iommu_domain
   framework. My hope is that SPAPR will be moved into the iommu_domain
   framework as a special HW specific type and would expect power to
   support the generic interface through a normal iommu_domain.

The following are not going to be implemented and we expect to remove them
from VFIO type1:

 - SW access 'dirty tracking'. As discussed in the cover letter this will
   be done in VFIO.

 - VFIO_TYPE1_NESTING_IOMMU
    https://lore.kernel.org/all/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   3 +-
 drivers/iommu/iommufd/iommufd_private.h |   6 +
 drivers/iommu/iommufd/main.c            |  16 +-
 drivers/iommu/iommufd/vfio_compat.c     | 423 ++++++++++++++++++++++++
 include/linux/iommufd.h                 |   8 +
 include/uapi/linux/iommufd.h            |  36 ++
 6 files changed, 486 insertions(+), 6 deletions(-)
 create mode 100644 drivers/iommu/iommufd/vfio_compat.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index ca28a135b9675f..2fdff04000b326 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -5,6 +5,7 @@ iommufd-y := \
 	io_pagetable.o \
 	ioas.o \
 	main.o \
-	pages.o
+	pages.o \
+	vfio_compat.o
 
 obj-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 540b36c0befa5e..d87227cc08a47d 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -70,6 +70,8 @@ void iopt_remove_reserved_iova(struct io_pagetable *iopt, void *owner);
 struct iommufd_ctx {
 	struct file *file;
 	struct xarray objects;
+
+	struct iommufd_ioas *vfio_ioas;
 };
 
 struct iommufd_ctx *iommufd_fget(int fd);
@@ -81,6 +83,9 @@ struct iommufd_ucmd {
 	void *cmd;
 };
 
+int iommufd_vfio_ioctl(struct iommufd_ctx *ictx, unsigned int cmd,
+		       unsigned long arg);
+
 /* Copy the response in ucmd->cmd back to userspace. */
 static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 				       size_t cmd_len)
@@ -208,6 +213,7 @@ int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
 int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
+int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
 
 /*
  * A HW pagetable is called an iommu_domain inside the kernel. This user object
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index ed64b84b3b9337..549d6a4c8f5575 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -134,6 +134,8 @@ bool iommufd_object_destroy_user(struct iommufd_ctx *ictx,
 		return false;
 	}
 	__xa_erase(&ictx->objects, obj->id);
+	if (ictx->vfio_ioas && &ictx->vfio_ioas->obj == obj)
+		ictx->vfio_ioas = NULL;
 	xa_unlock(&ictx->objects);
 	up_write(&obj->destroy_rwsem);
 
@@ -241,27 +243,31 @@ static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_IOAS_UNMAP, iommufd_ioas_unmap, struct iommu_ioas_unmap,
 		 length),
+	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
+		 __reserved),
 };
 
 static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
+	struct iommufd_ctx *ictx = filp->private_data;
 	struct iommufd_ucmd ucmd = {};
 	struct iommufd_ioctl_op *op;
 	union ucmd_buffer buf;
 	unsigned int nr;
 	int ret;
 
-	ucmd.ictx = filp->private_data;
+	nr = _IOC_NR(cmd);
+	if (nr < IOMMUFD_CMD_BASE ||
+	    (nr - IOMMUFD_CMD_BASE) >= ARRAY_SIZE(iommufd_ioctl_ops))
+		return iommufd_vfio_ioctl(ictx, cmd, arg);
+
+	ucmd.ictx = ictx;
 	ucmd.ubuffer = (void __user *)arg;
 	ret = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
 	if (ret)
 		return ret;
 
-	nr = _IOC_NR(cmd);
-	if (nr < IOMMUFD_CMD_BASE ||
-	    (nr - IOMMUFD_CMD_BASE) >= ARRAY_SIZE(iommufd_ioctl_ops))
-		return -ENOIOCTLCMD;
 	op = &iommufd_ioctl_ops[nr - IOMMUFD_CMD_BASE];
 	if (op->ioctl_num != cmd)
 		return -ENOIOCTLCMD;
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
new file mode 100644
index 00000000000000..57ef97aa309985
--- /dev/null
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -0,0 +1,423 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/file.h>
+#include <linux/interval_tree.h>
+#include <linux/iommu.h>
+#include <linux/iommufd.h>
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include <uapi/linux/vfio.h>
+#include <uapi/linux/iommufd.h>
+
+#include "iommufd_private.h"
+
+static struct iommufd_ioas *get_compat_ioas(struct iommufd_ctx *ictx)
+{
+	struct iommufd_ioas *ioas = ERR_PTR(-ENODEV);
+
+	xa_lock(&ictx->objects);
+	if (!ictx->vfio_ioas || !iommufd_lock_obj(&ictx->vfio_ioas->obj))
+		goto out_unlock;
+	ioas = ictx->vfio_ioas;
+out_unlock:
+	xa_unlock(&ictx->objects);
+	return ioas;
+}
+
+/**
+ * iommufd_vfio_compat_ioas_id - Return the IOAS ID that vfio should use
+ * @ictx - Context to operate on
+ *
+ * The compatability IOAS is the IOAS that the vfio compatability ioctls operate
+ * on since they do not have an IOAS ID input in their ABI. Only attaching a
+ * group should cause a default creation of the internal ioas, this returns the
+ * existing ioas if it has already been assigned somehow.
+ */
+int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
+{
+	struct iommufd_ioas *ioas = NULL;
+	struct iommufd_ioas *out_ioas;
+
+	ioas = iommufd_ioas_alloc(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	xa_lock(&ictx->objects);
+	if (ictx->vfio_ioas && iommufd_lock_obj(&ictx->vfio_ioas->obj))
+		out_ioas = ictx->vfio_ioas;
+	else {
+		out_ioas = ioas;
+		ictx->vfio_ioas = ioas;
+	}
+	xa_unlock(&ictx->objects);
+
+	*out_ioas_id = out_ioas->obj.id;
+	if (out_ioas != ioas) {
+		iommufd_put_object(&out_ioas->obj);
+		iommufd_object_abort(ictx, &ioas->obj);
+		return 0;
+	}
+	iommufd_object_finalize(ictx, &ioas->obj);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommufd_vfio_compat_ioas_id);
+
+int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_vfio_ioas *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+
+	if (cmd->__reserved)
+		return -EOPNOTSUPP;
+	switch (cmd->op) {
+	case IOMMU_VFIO_IOAS_GET:
+		ioas = get_compat_ioas(ucmd->ictx);
+		if (IS_ERR(ioas))
+			return PTR_ERR(ioas);
+		cmd->ioas_id = ioas->obj.id;
+		iommufd_put_object(&ioas->obj);
+		return iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+
+	case IOMMU_VFIO_IOAS_SET:
+		ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+		if (IS_ERR(ioas))
+			return PTR_ERR(ioas);
+		xa_lock(&ucmd->ictx->objects);
+		ucmd->ictx->vfio_ioas = ioas;
+		xa_unlock(&ucmd->ictx->objects);
+		iommufd_put_object(&ioas->obj);
+		return 0;
+
+	case IOMMU_VFIO_IOAS_CLEAR:
+		xa_lock(&ucmd->ictx->objects);
+		ucmd->ictx->vfio_ioas = NULL;
+		xa_unlock(&ucmd->ictx->objects);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int iommufd_vfio_map_dma(struct iommufd_ctx *ictx, unsigned int cmd,
+				void __user *arg)
+{
+	u32 supported_flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
+	size_t minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
+	struct vfio_iommu_type1_dma_map map;
+	int iommu_prot = IOMMU_CACHE;
+	struct iommufd_ioas *ioas;
+	unsigned long iova;
+	int rc;
+
+	if (copy_from_user(&map, arg, minsz))
+		return -EFAULT;
+
+	if (map.argsz < minsz || map.flags & ~supported_flags)
+		return -EINVAL;
+
+	if (map.flags & VFIO_DMA_MAP_FLAG_READ)
+		iommu_prot |= IOMMU_READ;
+	if (map.flags & VFIO_DMA_MAP_FLAG_WRITE)
+		iommu_prot |= IOMMU_WRITE;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	iova = map.iova;
+	rc = iopt_map_user_pages(&ioas->iopt, &iova,
+				 u64_to_user_ptr(map.vaddr), map.size,
+				 iommu_prot, 0);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_vfio_unmap_dma(struct iommufd_ctx *ictx, unsigned int cmd,
+				  void __user *arg)
+{
+	size_t minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
+
+	/* VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is obsoleted by the new
+	 * dirty tracking direction:
+	 *  https://lore.kernel.org/kvm/20220731125503.142683-1-yishaih@nvidia.com/
+	 *  https://lore.kernel.org/kvm/20220428210933.3583-1-joao.m.martins@oracle.com/
+	 */
+	u32 supported_flags = VFIO_DMA_UNMAP_FLAG_ALL;
+	struct vfio_iommu_type1_dma_unmap unmap;
+	struct iommufd_ioas *ioas;
+	unsigned long unmapped;
+	int rc;
+
+	if (copy_from_user(&unmap, arg, minsz))
+		return -EFAULT;
+
+	if (unmap.argsz < minsz || unmap.flags & ~supported_flags)
+		return -EINVAL;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL)
+		rc = iopt_unmap_all(&ioas->iopt, &unmapped);
+	else
+		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova,
+				     unmap.size, &unmapped);
+	iommufd_put_object(&ioas->obj);
+	unmap.size = unmapped;
+
+	return rc;
+}
+
+static int iommufd_vfio_cc_iommu(struct iommufd_ctx *ictx)
+{
+	struct iommufd_ioas *ioas;
+	bool rc;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+	rc = iommufd_ioas_enforced_coherent(ioas);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
+					unsigned long type)
+{
+	switch (type) {
+	case VFIO_TYPE1v2_IOMMU:
+	case VFIO_UNMAP_ALL:
+		return 1;
+
+	/*
+	 * This is obsolete, and to be removed from VFIO. It was an incomplete
+	 * idea that got merged.
+	 * https://lore.kernel.org/kvm/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/
+	 */
+	case VFIO_TYPE1_NESTING_IOMMU:
+		return 0;
+
+	case VFIO_DMA_CC_IOMMU:
+		return iommufd_vfio_cc_iommu(ictx);
+
+	/*
+	 * FIXME: The type1 iommu allows splitting of maps, which can fail. This is doable but
+	 * is a bunch of extra code that is only for supporting this case.
+	 */
+	case VFIO_TYPE1_IOMMU:
+	/*
+	 * FIXME: VFIO_DMA_MAP_FLAG_VADDR
+	 * https://lore.kernel.org/kvm/1611939252-7240-1-git-send-email-steven.sistare@oracle.com/
+	 * Wow, what a wild feature. This should have been implemented by
+	 * allowing a iopt_pages to be associated with a memfd. It can then
+	 * source mapping requests directly from a memfd without going through a
+	 * mm_struct and thus doesn't care that the original qemu exec'd itself.
+	 * The idea that userspace can flip a flag and cause kernel users to
+	 * block indefinately is unacceptable.
+	 *
+	 * For VFIO compat we should implement this in a slightly different way,
+	 * Creating a access_user that spans the whole area will immediately
+	 * stop new faults as they will be handled from the xarray. We can then
+	 * reparent the iopt_pages to the new mm_struct and undo the
+	 * access_user. No blockage of kernel users required, does require
+	 * filling the xarray with pages though.
+	 */
+	case VFIO_UPDATE_VADDR:
+	default:
+		return 0;
+	}
+}
+
+static int iommufd_vfio_set_iommu(struct iommufd_ctx *ictx, unsigned long type)
+{
+	struct iommufd_ioas *ioas = NULL;
+
+	if (type != VFIO_TYPE1v2_IOMMU)
+		return -EINVAL;
+
+	/* VFIO fails the set_iommu if there is no group */
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+	iommufd_put_object(&ioas->obj);
+	return 0;
+}
+
+static u64 iommufd_get_pagesizes(struct iommufd_ioas *ioas)
+{
+	/* FIXME: See vfio_update_pgsize_bitmap(), for compat this should return
+	 * the high bits too, and we need to decide if we should report that
+	 * iommufd supports less than PAGE_SIZE alignment or stick to strict
+	 * compatibility. qemu only cares about the first set bit.
+	 */
+	return ioas->iopt.iova_alignment;
+}
+
+static int iommufd_fill_cap_iova(struct iommufd_ioas *ioas,
+				 struct vfio_info_cap_header __user *cur,
+				 size_t avail)
+{
+	struct vfio_iommu_type1_info_cap_iova_range __user *ucap_iovas =
+		container_of(cur,
+			     struct vfio_iommu_type1_info_cap_iova_range __user,
+			     header);
+	struct vfio_iommu_type1_info_cap_iova_range cap_iovas = {
+		.header = {
+			.id = VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE,
+			.version = 1,
+		},
+	};
+	struct interval_tree_span_iter span;
+
+	interval_tree_for_each_span (&span, &ioas->iopt.reserved_itree,
+				     0, ULONG_MAX) {
+		struct vfio_iova_range range;
+
+		if (!span.is_hole)
+			continue;
+		range.start = span.start_hole;
+		range.end = span.last_hole;
+		if (avail >= struct_size(&cap_iovas, iova_ranges,
+					 cap_iovas.nr_iovas + 1) &&
+		    copy_to_user(&ucap_iovas->iova_ranges[cap_iovas.nr_iovas],
+				 &range, sizeof(range)))
+			return -EFAULT;
+		cap_iovas.nr_iovas++;
+	}
+	if (avail >= struct_size(&cap_iovas, iova_ranges, cap_iovas.nr_iovas) &&
+	    copy_to_user(ucap_iovas, &cap_iovas, sizeof(cap_iovas)))
+		return -EFAULT;
+	return struct_size(&cap_iovas, iova_ranges, cap_iovas.nr_iovas);
+}
+
+static int iommufd_fill_cap_dma_avail(struct iommufd_ioas *ioas,
+				      struct vfio_info_cap_header __user *cur,
+				      size_t avail)
+{
+	struct vfio_iommu_type1_info_dma_avail cap_dma = {
+		.header = {
+			.id = VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL,
+			.version = 1,
+		},
+		/* iommufd has no limit, return the same value as VFIO. */
+		.avail = U16_MAX,
+	};
+
+	if (avail >= sizeof(cap_dma) &&
+	    copy_to_user(cur, &cap_dma, sizeof(cap_dma)))
+		return -EFAULT;
+	return sizeof(cap_dma);
+}
+
+static int iommufd_vfio_iommu_get_info(struct iommufd_ctx *ictx,
+				       void __user *arg)
+{
+	typedef int (*fill_cap_fn)(struct iommufd_ioas *ioas,
+				   struct vfio_info_cap_header __user *cur,
+				   size_t avail);
+	static const fill_cap_fn fill_fns[] = {
+		iommufd_fill_cap_iova,
+		iommufd_fill_cap_dma_avail,
+	};
+	size_t minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
+	struct vfio_info_cap_header __user *last_cap = NULL;
+	struct vfio_iommu_type1_info info;
+	struct iommufd_ioas *ioas;
+	size_t total_cap_size;
+	int rc;
+	int i;
+
+	if (copy_from_user(&info, arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+	minsz = min_t(size_t, info.argsz, sizeof(info));
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	down_read(&ioas->iopt.iova_rwsem);
+	info.flags = VFIO_IOMMU_INFO_PGSIZES;
+	info.iova_pgsizes = iommufd_get_pagesizes(ioas);
+	info.cap_offset = 0;
+
+	total_cap_size = sizeof(info);
+	for (i = 0; i != ARRAY_SIZE(fill_fns); i++) {
+		int cap_size;
+
+		if (info.argsz > total_cap_size)
+			cap_size = fill_fns[i](ioas, arg + total_cap_size,
+					       info.argsz - total_cap_size);
+		else
+			cap_size = fill_fns[i](ioas, NULL, 0);
+		if (cap_size < 0) {
+			rc = cap_size;
+			goto out_put;
+		}
+		if (last_cap && info.argsz >= total_cap_size &&
+		    put_user(total_cap_size, &last_cap->next)) {
+			rc = -EFAULT;
+			goto out_put;
+		}
+		last_cap = arg + total_cap_size;
+		total_cap_size += cap_size;
+	}
+
+	/*
+	 * If the user did not provide enough space then only some caps are
+	 * returned and the argsz will be updated to the correct amount to get
+	 * all caps.
+	 */
+	if (info.argsz >= total_cap_size)
+		info.cap_offset = sizeof(info);
+	info.argsz = total_cap_size;
+	info.flags |= VFIO_IOMMU_INFO_CAPS;
+	if (copy_to_user(arg, &info, minsz))
+		rc = -EFAULT;
+	rc = 0;
+
+out_put:
+	up_read(&ioas->iopt.iova_rwsem);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+/* FIXME TODO:
+PowerPC SPAPR only:
+#define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
+#define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
+#define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
+#define VFIO_IOMMU_SPAPR_REGISTER_MEMORY	_IO(VFIO_TYPE, VFIO_BASE + 17)
+#define VFIO_IOMMU_SPAPR_UNREGISTER_MEMORY	_IO(VFIO_TYPE, VFIO_BASE + 18)
+#define VFIO_IOMMU_SPAPR_TCE_CREATE	_IO(VFIO_TYPE, VFIO_BASE + 19)
+#define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 20)
+*/
+
+int iommufd_vfio_ioctl(struct iommufd_ctx *ictx, unsigned int cmd,
+		       unsigned long arg)
+{
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case VFIO_GET_API_VERSION:
+		return VFIO_API_VERSION;
+	case VFIO_SET_IOMMU:
+		return iommufd_vfio_set_iommu(ictx, arg);
+	case VFIO_CHECK_EXTENSION:
+		return iommufd_vfio_check_extension(ictx, arg);
+	case VFIO_IOMMU_GET_INFO:
+		return iommufd_vfio_iommu_get_info(ictx, uarg);
+	case VFIO_IOMMU_MAP_DMA:
+		return iommufd_vfio_map_dma(ictx, cmd, uarg);
+	case VFIO_IOMMU_UNMAP_DMA:
+		return iommufd_vfio_unmap_dma(ictx, cmd, uarg);
+	case VFIO_IOMMU_DIRTY_PAGES:
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return -ENOIOCTLCMD;
+}
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index c072e400f3e645..050024ff68142d 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -72,6 +72,8 @@ void iommufd_ctx_get(struct iommufd_ctx *ictx);
 struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
 void iommufd_ctx_put(struct iommufd_ctx *ictx);
 
+int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
+
 int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
 		      void *data, size_t len, bool write);
 #else /* !CONFIG_IOMMUFD */
@@ -84,6 +86,12 @@ static inline void iommufd_ctx_put(struct iommufd_ctx *ictx)
 {
 }
 
+static inline int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx,
+					      u32 *out_ioas_id)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
 		      void *data, size_t len, bool write)
 {
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b7b0ac4016bb70..48c290505844d8 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -43,6 +43,7 @@ enum {
 	IOMMUFD_CMD_IOAS_IOVA_RANGES,
 	IOMMUFD_CMD_IOAS_MAP,
 	IOMMUFD_CMD_IOAS_UNMAP,
+	IOMMUFD_CMD_VFIO_IOAS,
 };
 
 /**
@@ -240,4 +241,39 @@ struct iommu_ioas_unmap {
 	__aligned_u64 length;
 };
 #define IOMMU_IOAS_UNMAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP)
+
+/**
+ * enum iommufd_vfio_ioas_op
+ * @IOMMU_VFIO_IOAS_GET: Get the current compatibility IOAS
+ * @IOMMU_VFIO_IOAS_SET: Change the current compatibility IOAS
+ * @IOMMU_VFIO_IOAS_CLEAR: Disable VFIO compatibility
+ */
+enum iommufd_vfio_ioas_op {
+	IOMMU_VFIO_IOAS_GET = 0,
+	IOMMU_VFIO_IOAS_SET = 1,
+	IOMMU_VFIO_IOAS_CLEAR = 2,
+};
+
+/**
+ * struct iommu_vfio_ioas - ioctl(IOMMU_VFIO_IOAS)
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @ioas_id: For IOMMU_VFIO_IOAS_SET the input IOAS ID to set
+ *           For IOMMU_VFIO_IOAS_GET will output the IOAS ID
+ * @op: One of enum iommufd_vfio_ioas_op
+ * @__reserved: Must be 0
+ *
+ * The VFIO compatibility support uses a single ioas because VFIO APIs do not
+ * support the ID field. Set or Get the IOAS that VFIO compatibility will use.
+ * When VFIO_GROUP_SET_CONTAINER is used on an iommufd it will get the
+ * compatibility ioas, either by taking what is already set, or auto creating
+ * one. From then on VFIO will continue to use that ioas and is not effected by
+ * this ioctl. SET or CLEAR does not destroy any auto-created IOAS.
+ */
+struct iommu_vfio_ioas {
+	__u32 size;
+	__u32 ioas_id;
+	__u16 op;
+	__u16 __reserved;
+};
+#define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
 #endif
-- 
2.37.3


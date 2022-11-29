Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABBC63C94B
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbiK2Uae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbiK2UaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:30:12 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E04063CEE
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:30:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O83KxW6HqNaEAzSTF2yvDJ3DpkbbfMykYvOd+xgT+E2h/sHop0Sqyz9VfOqaXoqqGwfHOvZXtZS0wvSe7wQZH8BcyGb+pgYIFcer2H2RB+0ej3FN+3xKqXnJyIS+KLPYk4NbjE9hIM/ftO3aurKXIiX6b39RNadVsJ6YOhpcXpKVHSADhyvaPpNe6hK1Od4TLUe0aIMfpP0rUX5QBg/zQoEErZGuACiiSWMptOLC98yW40z4Nxeh6CrTAikCdgUjSgSzZy4rAKBXSdrbrYcUHFJADnOGSl1mmbAuY0RlfQ1yhzW02svqsCXuHaZpvHzGqrI9RzXGueOX62pYsf6z9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8maZ74X8oKpnHjpMMEwQcS1U3LiB67whkFPu5Sdch4=;
 b=j7FCh+Wf5rhmXrSy7WqH5JYYD8R2A1kyTUAHD2iSs9qLFdlCKoeHR1DghMdC52PEgsN470ZUKhpecnZG7Iy02FKSAvSM7hfZbnvM9nzIiViEJu2zNLI5Ukg1bxd2PKmZ4IqaW5niKc1JjaPofnlStgrMARBL5G9a0rJNWLW6OW5qd6RsTzQ6Bf8do68PhfDqmqllvp7csYJwDyVQeDQSgyw/cO0aHXvaFVfYOIMl4wwYLaJRadtUi+CtFukjE+++cgMuK+U+3JZVfe34QCkMED9ImbS9TJeZXEPFeHeWPkLjs0Q2Zo+c9pfXVHxnLmBBdcIRzBR/nBH3tDi5zBCfbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8maZ74X8oKpnHjpMMEwQcS1U3LiB67whkFPu5Sdch4=;
 b=IhBncUIW1Et/q4Y9vs21ZtmUxRskvGV9nuLPtpHjMyp2bI9+XpHfCx5I1aEqcZ6I8QknJjGb+7OsOANMOhfCYFNForLIdibwz2VD4SGNGiVtZTQOsIwwkRvs+xPlpWJy0Hx46sfDDRYvYZ4dUIdbA9z98W5d9Qr8z7C+1gGEms97pVcZlhkrsbQqwmcH21EeJ5x8t4iPLnGj55JcPJmdXWvIyOUQZi/42MqwblX+Q82VOOdmtaagbBm7RUZ/PfrDhPJ/OjDBhHr5lWeK9lAjwTZMQmkt4qkqmcKhZmUF2TqzhCIqaDY/ajYqGwJdUnsjjpq4VbMzDv+J0QfJoQx+WQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 15/19] iommufd: vfio container FD ioctl compatibility
Date:   Tue, 29 Nov 2022 16:29:38 -0400
Message-Id: <15-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:a03:74::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: 86f87748-548c-437d-fde7-08dad2487438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kWLLPyK5FcsDnmUaZmFSQidxt3tQ9yB0FAhc+eSErhzfA81UXDi7RiCKzIWd0A+pntx9rSNPblNtT2qWrFTZ8P3r4KY7oqhgHPbR9JARp62GrxllttzTWjFW1Fk8GaZgaMzBQ7+HOPQyd3jfHgSbsXjx7X3YLlj/MBloN1Y96XozMEoDJTGfz7ZOJMSQIL0+Je81iwwVPnP+fG0PEz16DEN4P9TynG9WKDBP/cBXr5xSXVnxfAlEK16eClZdEv8R0BmyAkzRAXXHjNHVGPtg2zTfwDJrXj8BZqioFA+reTmn/64wuHlbgT0z+cnCwUzcpTu4sIsf8lD1f64ysD2zqWZXhMoTxWt2v20Kco7QP8P6PFXijKzTlst9W722P5R0AgWwTZTECo8som+F2+CP89wrgO7Vce2Lz9rw31Vu7pwrlqNNHoLmD+47DueKEcW44wWHbKyqxZJ1+KlaSChpsQ8QBAo0CZA6ZYIR90wYI95TOU3++vvzccZNJY8uRJXBizx4lUVJgAz19/4OgswKYWWUhDxINpIBdqK/f9iD5aoxs50qc+1NBJmxg/u1AOqxsEKv+hhq/W7KWa0iD8uIjfmfYJzqj2NjZiAuuu2N9HNbwrnWIk8EQO3a7J2DmQvrnE7THBQmaNLPS7Swupd8Du9kRuDxGzp1gFhPyc/tJsV7eTewOBQavCEkScc8H1oS8EczrKDhcI16U8ZWs1nSP4tgIZOm2Oe68gUUtr0an2Bb5a/O4hFORtTsJwD0mcITX6SQ5Z1u1FODiMaKqt/8kgBibQINSLerEaS1BB0m1dHoaBUQ4XRB2d6CuO/6Xt/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(109986013)(2616005)(186003)(54906003)(316002)(966005)(6486002)(36756003)(86362001)(38100700002)(26005)(83380400001)(6666004)(6506007)(6512007)(30864003)(478600001)(7416002)(8676002)(41300700001)(2906002)(8936002)(66946007)(66476007)(66556008)(5660300002)(4326008)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T2lzUr7h6CahKTpTnLKSpsiXEPeExbuOODB0JG7m7kodqk0FfJmZ/bbLyaDm?=
 =?us-ascii?Q?gB+quRG4AQ7Hay215aRCbfj0byJ+AokjKxUqS7oT/iwqBcpTCL09b3HAV0LR?=
 =?us-ascii?Q?X8tFtpXxN2ksZyCujg8jw48SuxA3tsTbJ1SzS0qOWBxG4YcKz4M2U+2Vzznd?=
 =?us-ascii?Q?TaHIP5xdtmFEBSQB07CGWIcGbN4lX1VavQG+4au+UWvlvst4vhAKsU5UtmLG?=
 =?us-ascii?Q?3x1MZTNinnbfvxAQGPpviQuMTFbjBwZQn+svAGwHFFuWAcLzJ3+OGXYjnE0G?=
 =?us-ascii?Q?txt2/xGm0gHACN4zi7+srroCKgBjREXdr5dSnpJ1afHwNMVjitTq4MFqotWE?=
 =?us-ascii?Q?thpiOI1r/5r3DxDanH2zYeLGlH6OFAXE/DOTL1TZnaVnxK54YaYBFwQ/ZXKg?=
 =?us-ascii?Q?7USSRzwyMIVL6j+fjhnCPujbwDD9vCOws6Vuet3cgCxeVL+yh2kWowyS3f07?=
 =?us-ascii?Q?XO0ysCZHCOcr+IVqwxdXTd3XIghSUeAmZ9qiCoAsPPMiwTbugYhYr9yfxAqr?=
 =?us-ascii?Q?3cqSZHsMaqMIBZrzneD+8HGUkXZRDo0NFLSmWQjwSDmbb7DhBnHcvh96BgxT?=
 =?us-ascii?Q?bxftaGRppjaKiERr6JUMMgiUnHSTCaNgfiHC7lIA1Fj9k2pvk68Tbr8sotpA?=
 =?us-ascii?Q?CNckjpadqUocTudMmw7mYhqiabALgq1gdxzytQn1wdf6iLn56T4WsRiN1xZE?=
 =?us-ascii?Q?pQW8cymeOdz19aKXVTN9cGkvb5X+2P7MPaVHL5KSZB53V9lyl9T5LAp2gj0Q?=
 =?us-ascii?Q?Y2l62C1duL0wmTjE9esCUhUUQkfx1B/FMArJHLvIwwYOh5IdJKRrx98I10uc?=
 =?us-ascii?Q?9Dl7mbgWgsLXqqdT81KldPm4O8lwaVQPm22YjqDxS3V2FKRdLNaf8Hpf5LfQ?=
 =?us-ascii?Q?Y1iQZCQJ85I7s51QrifuEpuIcwd7q4JSCAFjubeuCEb/nwqBtaO0R3k+kUC+?=
 =?us-ascii?Q?v+oFjFnvisvcOiYVmN4cpkmBAHjQ0ZoTwV0QQv0YDNPhsG7Et4tkJTmrLWVD?=
 =?us-ascii?Q?HJkp3UOrkHInCbiCne6eg1WRrmfSzkD9brQXpSs4xsFbAGsDBziXk4DukbLw?=
 =?us-ascii?Q?I6ARIpCpCL1xjz3qEFrz/VCddRGd8CEcBllXYLGXVkPj4Q+M29ftxW35Ykj6?=
 =?us-ascii?Q?xvuXp4SHpo5h6q/Ak+4UN1Q+ecRxLHLCisklZu/wsYB/zctAWo1juBnXWQE8?=
 =?us-ascii?Q?g9gUmhcRT6BMg6i5gkHk6RKsh0PJLYKBJvBfV4o6xIQ+sPKYph2ZjoDZNMzW?=
 =?us-ascii?Q?+qupuHwB1TMd0YcC51DaDf+nJ/dO7qEKLELBi9GAH8VHrYZNqGeRxDLH7ICo?=
 =?us-ascii?Q?PcYEWKMa8evc1es4JBihZdbmldOknmmB6UxMfGkBOC7xXUc4oon8P8T5Lm3D?=
 =?us-ascii?Q?IeQac8v0UxWmngFE4pt4k4YJ4PE+uvedl7JLKK9Sj24E6J2MU/GWytFzXGOC?=
 =?us-ascii?Q?cF6pAyqBGczsIpCZ/PQawhXxlqu9G9EJmhi4mC8uGiOPQt84toSRRy4h0pFi?=
 =?us-ascii?Q?1ccOM6+87peRvjPS+Ss0/15Hwlr0d0zitLsReJdqav0VSt6OwmFkTynbgMbf?=
 =?us-ascii?Q?IVPDv3+GISxI1P8vL3oc0+O0yVtXdqXE4fPyqxdI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f87748-548c-437d-fde7-08dad2487438
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:46.0259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4J6NQUQSkufJfwPwuAiC87WPKUFHBfLXt/lyqs6yF8m3Ybo5e3LwkOlG/OtFCTL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

iommufd can directly implement the /dev/vfio/vfio container IOCTLs by
mapping them into io_pagetable operations.

A userspace application can test against iommufd and confirm compatibility
then simply make a small change to open /dev/iommu instead of
/dev/vfio/vfio.

For testing purposes /dev/vfio/vfio can be symlinked to /dev/iommu and
then all applications will use the compatibility path with no code
changes. A later series allows /dev/vfio/vfio to be directly provided by
iommufd, which allows the rlimit mode to work the same as well.

This series just provides the iommufd side of compatibility. Actually
linking this to VFIO_SET_CONTAINER is a followup series, with a link in
the cover letter.

Internally the compatibility API uses a normal IOAS object that, like
vfio, is automatically allocated when the first device is
attached.

Userspace can also query or set this IOAS object directly using the
IOMMU_VFIO_IOAS ioctl. This allows mixing and matching new iommufd only
features while still using the VFIO style map/unmap ioctls.

While this is enough to operate qemu, it has a few differences:

 - Resource limits rely on memory cgroups to bound what userspace can do
   instead of the module parameter dma_entry_limit.

 - VFIO P2P is not implemented. The DMABUF patches for vfio are a start at
   a solution where iommufd would import a special DMABUF. This is to avoid
   further propogating the follow_pfn() security problem.

 - A full audit for pedantic compatibility details (eg errnos, etc) has
   not yet been done

 - powerpc SPAPR is left out, as it is not connected to the iommu_domain
   framework. It seems interest in SPAPR is minimal as it is currently
   non-working in v6.1-rc1. They will have to convert to the iommu
   subsystem framework to enjoy iommfd.

The following are not going to be implemented and we expect to remove them
from VFIO type1:

 - SW access 'dirty tracking'. As discussed in the cover letter this will
   be done in VFIO.

 - VFIO_TYPE1_NESTING_IOMMU
    https://lore.kernel.org/all/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/

 - VFIO_DMA_MAP_FLAG_VADDR
    https://lore.kernel.org/all/Yz777bJZjTyLrHEQ@nvidia.com/

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   3 +-
 drivers/iommu/iommufd/iommufd_private.h |   6 +
 drivers/iommu/iommufd/main.c            |  16 +-
 drivers/iommu/iommufd/vfio_compat.c     | 472 ++++++++++++++++++++++++
 include/linux/iommufd.h                 |   7 +
 include/uapi/linux/iommufd.h            |  36 ++
 6 files changed, 534 insertions(+), 6 deletions(-)
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
index 40302cc0da3603..8fe5f162ccbcfb 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -18,6 +18,7 @@ struct iommufd_ctx {
 	struct xarray objects;
 
 	u8 account_mode;
+	struct iommufd_ioas *vfio_ioas;
 };
 
 /*
@@ -92,6 +93,9 @@ struct iommufd_ucmd {
 	void *cmd;
 };
 
+int iommufd_vfio_ioctl(struct iommufd_ctx *ictx, unsigned int cmd,
+		       unsigned long arg);
+
 /* Copy the response in ucmd->cmd back to userspace. */
 static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 				       size_t cmd_len)
@@ -222,6 +226,8 @@ int iommufd_ioas_option(struct iommufd_ucmd *ucmd);
 int iommufd_option_rlimit_mode(struct iommu_option *cmd,
 			       struct iommufd_ctx *ictx);
 
+int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
+
 /*
  * A HW pagetable is called an iommu_domain inside the kernel. This user object
  * allows directly creating and inspecting the domains. Domains that have kernel
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 4153f6a2025559..5cf69c4d591def 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -133,6 +133,8 @@ bool iommufd_object_destroy_user(struct iommufd_ctx *ictx,
 		return false;
 	}
 	__xa_erase(&ictx->objects, obj->id);
+	if (ictx->vfio_ioas && &ictx->vfio_ioas->obj == obj)
+		ictx->vfio_ioas = NULL;
 	xa_unlock(&ictx->objects);
 	up_write(&obj->destroy_rwsem);
 
@@ -271,27 +273,31 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 length),
 	IOCTL_OP(IOMMU_OPTION, iommufd_option, struct iommu_option,
 		 val64),
+	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
+		 __reserved),
 };
 
 static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
+	struct iommufd_ctx *ictx = filp->private_data;
 	const struct iommufd_ioctl_op *op;
 	struct iommufd_ucmd ucmd = {};
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
index 00000000000000..3ceca0e8311c39
--- /dev/null
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -0,0 +1,472 @@
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
+ * @ictx: Context to operate on
+ * @out_ioas_id: The ioas_id the caller should use
+ *
+ * The compatibility IOAS is the IOAS that the vfio compatibility ioctls operate
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
+	/*
+	 * An automatically created compat IOAS is treated as a userspace
+	 * created object. Userspace can learn the ID via IOMMU_VFIO_IOAS_GET,
+	 * and if not manually destroyed it will be destroyed automatically
+	 * at iommufd release.
+	 */
+	iommufd_object_finalize(ictx, &ioas->obj);
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_id, IOMMUFD_VFIO);
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
+	/*
+	 * Maps created through the legacy interface always use VFIO compatible
+	 * rlimit accounting. If the user wishes to use the faster user based
+	 * rlimit accounting then they must use the new interface.
+	 */
+	iova = map.iova;
+	rc = iopt_map_user_pages(ictx, &ioas->iopt, &iova, u64_to_user_ptr(map.vaddr),
+				 map.size, iommu_prot, 0);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_vfio_unmap_dma(struct iommufd_ctx *ictx, unsigned int cmd,
+				  void __user *arg)
+{
+	size_t minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
+	/*
+	 * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is obsoleted by the new
+	 * dirty tracking direction:
+	 *  https://lore.kernel.org/kvm/20220731125503.142683-1-yishaih@nvidia.com/
+	 *  https://lore.kernel.org/kvm/20220428210933.3583-1-joao.m.martins@oracle.com/
+	 */
+	u32 supported_flags = VFIO_DMA_UNMAP_FLAG_ALL;
+	struct vfio_iommu_type1_dma_unmap unmap;
+	unsigned long unmapped = 0;
+	struct iommufd_ioas *ioas;
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
+	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL) {
+		if (unmap.iova != 0 || unmap.size != 0) {
+			rc = -EINVAL;
+			goto err_put;
+		}
+		rc = iopt_unmap_all(&ioas->iopt, &unmapped);
+	} else {
+		if (READ_ONCE(ioas->iopt.disable_large_pages)) {
+			/*
+			 * Create cuts at the start and last of the requested
+			 * range. If the start IOVA is 0 then it doesn't need to
+			 * be cut.
+			 */
+			unsigned long iovas[] = { unmap.iova + unmap.size - 1,
+						  unmap.iova - 1 };
+
+			rc = iopt_cut_iova(&ioas->iopt, iovas,
+					   unmap.iova ? 2 : 1);
+			if (rc)
+				goto err_put;
+		}
+		rc = iopt_unmap_iova(&ioas->iopt, unmap.iova, unmap.size,
+				     &unmapped);
+	}
+	unmap.size = unmapped;
+	if (copy_to_user(arg, &unmap, minsz))
+		rc = -EFAULT;
+
+err_put:
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_vfio_cc_iommu(struct iommufd_ctx *ictx)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_ioas *ioas;
+	int rc = 1;
+
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	mutex_lock(&ioas->mutex);
+	list_for_each_entry(hwpt, &ioas->hwpt_list, hwpt_item) {
+		if (!hwpt->enforce_cache_coherency) {
+			rc = 0;
+			break;
+		}
+	}
+	mutex_unlock(&ioas->mutex);
+
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
+					unsigned long type)
+{
+	switch (type) {
+	case VFIO_TYPE1_IOMMU:
+	case VFIO_TYPE1v2_IOMMU:
+	case VFIO_UNMAP_ALL:
+		return 1;
+
+	case VFIO_DMA_CC_IOMMU:
+		return iommufd_vfio_cc_iommu(ictx);
+
+	/*
+	 * This is obsolete, and to be removed from VFIO. It was an incomplete
+	 * idea that got merged.
+	 * https://lore.kernel.org/kvm/0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com/
+	 */
+	case VFIO_TYPE1_NESTING_IOMMU:
+		return 0;
+
+	/*
+	 * VFIO_DMA_MAP_FLAG_VADDR
+	 * https://lore.kernel.org/kvm/1611939252-7240-1-git-send-email-steven.sistare@oracle.com/
+	 * https://lore.kernel.org/all/Yz777bJZjTyLrHEQ@nvidia.com/
+	 *
+	 * It is hard to see how this could be implemented safely.
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
+	int rc = 0;
+
+	if (type != VFIO_TYPE1_IOMMU && type != VFIO_TYPE1v2_IOMMU)
+		return -EINVAL;
+
+	/* VFIO fails the set_iommu if there is no group */
+	ioas = get_compat_ioas(ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	/*
+	 * The difference between TYPE1 and TYPE1v2 is the ability to unmap in
+	 * the middle of mapped ranges. This is complicated by huge page support
+	 * which creates single large IOPTEs that cannot be split by the iommu
+	 * driver. TYPE1 is very old at this point and likely nothing uses it,
+	 * however it is simple enough to emulate by simply disabling the
+	 * problematic large IOPTEs. Then we can safely unmap within any range.
+	 */
+	if (type == VFIO_TYPE1_IOMMU)
+		rc = iopt_disable_large_pages(&ioas->iopt);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static unsigned long iommufd_get_pagesizes(struct iommufd_ioas *ioas)
+{
+	struct io_pagetable *iopt = &ioas->iopt;
+	unsigned long pgsize_bitmap = ULONG_MAX;
+	struct iommu_domain *domain;
+	unsigned long index;
+
+	down_read(&iopt->domains_rwsem);
+	xa_for_each(&iopt->domains, index, domain)
+		pgsize_bitmap &= domain->pgsize_bitmap;
+
+	/* See vfio_update_pgsize_bitmap() */
+	if (pgsize_bitmap & ~PAGE_MASK) {
+		pgsize_bitmap &= PAGE_MASK;
+		pgsize_bitmap |= PAGE_SIZE;
+	}
+	pgsize_bitmap = max(pgsize_bitmap, ioas->iopt.iova_alignment);
+	up_read(&iopt->domains_rwsem);
+	return pgsize_bitmap;
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
+	interval_tree_for_each_span(&span, &ioas->iopt.reserved_itree, 0,
+				    ULONG_MAX) {
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
+		/*
+		 * iommufd's limit is based on the cgroup's memory limit.
+		 * Normally vfio would return U16_MAX here, and provide a module
+		 * parameter to adjust it. Since S390 qemu userspace actually
+		 * pays attention and needs a value bigger than U16_MAX return
+		 * U32_MAX.
+		 */
+		.avail = U32_MAX,
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
+		iommufd_fill_cap_dma_avail,
+		iommufd_fill_cap_iova,
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
+	info.flags = VFIO_IOMMU_INFO_PGSIZES;
+	info.iova_pgsizes = iommufd_get_pagesizes(ioas);
+	info.cap_offset = 0;
+
+	down_read(&ioas->iopt.iova_rwsem);
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
+	if (copy_to_user(arg, &info, minsz)) {
+		rc = -EFAULT;
+		goto out_put;
+	}
+	rc = 0;
+
+out_put:
+	up_read(&ioas->iopt.iova_rwsem);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
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
index 46c481a26d791d..84af9a239769af 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -54,6 +54,7 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
 				unsigned long iova, unsigned long length);
 int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
 		      void *data, size_t len, unsigned int flags);
+int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
 #else /* !CONFIG_IOMMUFD */
 static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 {
@@ -84,5 +85,11 @@ static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx,
+					      u32 *out_ioas_id)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_IOMMUFD */
 #endif
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 855aa984b632d3..de8d2d4f8bb604 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -44,6 +44,7 @@ enum {
 	IOMMUFD_CMD_IOAS_MAP,
 	IOMMUFD_CMD_IOAS_UNMAP,
 	IOMMUFD_CMD_OPTION,
+	IOMMUFD_CMD_VFIO_IOAS,
 };
 
 /**
@@ -306,4 +307,39 @@ struct iommu_option {
 	__aligned_u64 val64;
 };
 #define IOMMU_OPTION _IO(IOMMUFD_TYPE, IOMMUFD_CMD_OPTION)
+
+/**
+ * enum iommufd_vfio_ioas_op - IOMMU_VFIO_IOAS_* ioctls
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
+ * @size: sizeof(struct iommu_vfio_ioas)
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
2.38.1


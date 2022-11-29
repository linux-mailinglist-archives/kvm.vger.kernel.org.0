Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F131F63C95C
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbiK2UcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbiK2UcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:32:04 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD3063BAF
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:32:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kahaUFVEFaOMiosF1y75XRh8qvnfEbC7c0iqug6bg4ainzS6jGdKt+iSw7K8ALPpSXWY3R6qEQ5SdiJZaToDmxV5l1JGZ9tUrnYDQ1d2BOrnu7nDdyr/aQzfkKYNkJ6XNs3DPnQm65RXxqnerjPPBd/XA+6L0BLYMzy2Y/DrokD/bkHrQe7NeMEJsyzIgRbgSB/6kvFiAQobX1gwieQP/RlfUcqynsd6u+XItlWpXuS1nd2LZqimbG6o/FCBR4Sd7faQYA2e+2Ybte5OLkVR3ELqtrnKAE4JhCOZqPH1s7L/Fj1z0hnUqa/1Sdc+oyXNd+epGvLDlV9FZZ3V+gABkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUesWnyhsS/lYHYyRn9vm3/EgOkAloRPGtXQzrnv9hY=;
 b=JBn62zuoiAEpPQZcvC9MOQjF+8iyz9wUSzFkjtLbl+YnUUTuDyyq+0lLZEbevANO7jzQItE53uIba6Nt5nbvE4UW/q7cd5Yj3/EGXQ73X+IlmnNutGoylmiRc4GKUDO3ACIgNjYKONaF5Osq4cmMCLUcPOFcFcQqYiTzy1mA3uz/ajiaZ45UjtKAMsQ3DGalWvmrvOv8trFuCHDhsDvRsr7ub+21bvvlwFhZNQKHaigSHQmg4qtooKvjFog5Kiin3eOfEe2BU09wLb+YcQDdF9s56Bee5cBD4H3i5YNZK//cmXO3Id/0VIBWrf/7JQfMFcsB34TbTcYHfT2rpHxxVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUesWnyhsS/lYHYyRn9vm3/EgOkAloRPGtXQzrnv9hY=;
 b=MkCb60oEs8Byf6I4tAZfLOx5cOHUOxmDNMVWBRRKAZZePt1xY1fo8W9IYywSO0qqzL+JWVSYIY6GO3/oznE44tJXoa3ICrHTdJIpJlljtdnlL0WbywQ6W1CiRUIKF/vglGMuFrwiaOSEdeE8RiJgXu91U8wRwxj9oDZmWPS5LPZGCiTKltNs4QiWPXavA+K9NTaZaCeLumvYlKSq+QVFjtfO5OWu591bvyXVFqI0zSdOdEnSPWpK4hVJy2kbhJ57snWQnyjBB5qmjb23wF1QC3YPON5ac3XbJfqoAzziWUxDWKEIIIOZkz8l6VWH7QH37Tq62VRB3fKKR+19qUsPSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 20:31:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:31:59 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v4 09/10] vfio: Make vfio_container optionally compiled
Date:   Tue, 29 Nov 2022 16:31:54 -0400
Message-Id: <9-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0122.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e360a9-b98a-4089-434c-08dad248c33f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lwpffs8rgu2Dv38O9w5ZR3U85vq1SvX0BKUwrBkyIJ7NkvHozjt2OeiYN9/r5Uy2KPNzePo4+DXD1bkVFpye+FD+6i7tRSqmgRxoFOBqEA4UMqL72r0qVdRDGT8XS6rRdKE6ronPSobnp4A1lwwD0272TtUJinwH8XlJ+jV9mxozFgg4Ba7JfSRN1AUwnznIfZky9v3Bf8eFLhhKJrXNS0J9Uqhq4mFnMXGsfjFQ4Xqt0ouZIkCUXD4BSVkmJs5P7+V9JxyxdmlqVs/5Egh5380bvPjqMQ0JnP+oiEe9m+jh050S0ikjh9vaFeYFrpmRSl+4NGdfBLdG5TGvpcnSl2S6grntHTs7oGXduqJ2vUGETGypkJNglho7q3ni0NEl6+Ri683kWPDgzY+6j9DaszptfNCK+OvNe8YpWTcgPp9VYP54lCe+cUsGnnn0SY/vU4koOX+aGoHdpZXXo79fNpDIr7gEtNDe+9528I2+5xzGlYZSiL/ODWW/JaFvTkCT5L+XVYyOW7aj0pqDK5mIXj3XG5aFTK77MBra31lPbmZpWxfojdMOjOZq//y/OJWY5w2AwNf+Iowu4bGpn6bQfuGn+YmvbxLr1VXQBkQVqlDfn+Gugjd+M3MPlcAo93sCzqzULu3IQWyl33sUi9qyVojhU5ldha+PXlJv5zhoTIP19kUTdLI6VhaWSa/e4OPEePRflmaRhdaNFULwrBeMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(109986013)(451199015)(26005)(86362001)(2616005)(6512007)(186003)(54906003)(6506007)(6486002)(6666004)(478600001)(38100700002)(83380400001)(36756003)(2906002)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(8936002)(7416002)(5660300002)(41300700001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jo4nOkHv4FEaKzVRwbwtjeQWfOAcWhD0215dns9tWnADhiIeU1evAN4qcpYJ?=
 =?us-ascii?Q?5SKnMqssLA8d8840xPcl3xM9S3ctlKNbhxngOktJwnax98o8n62DsVP5S8jT?=
 =?us-ascii?Q?MFD3clGpdoapqeDVA/JHQJHTocAxFvmtJQ7614jYg/7uPsQA0FIiiqa077Ic?=
 =?us-ascii?Q?bAvBuv3Fg/J3kZ5El+GyioQLjKjcmc4sC6rI38bmczMkMCaa/ojlKYxpmx/9?=
 =?us-ascii?Q?V4fcQnV40iyWqxweWRdxSoJrRGTbzv7q+zQk6SlxZSJgwxc55QqImDl8hwui?=
 =?us-ascii?Q?+xjtmzRgdE6mgqMk/xP+MytxcmkFiI2iVHMyn1qb7XxUwmfD0gABJcFuyRQH?=
 =?us-ascii?Q?En585GXEB8GQy4BZTbKIzBTDhBNhssYEHUMZhDPjEA52UC98saSpyLqdXxNp?=
 =?us-ascii?Q?DuMprilHhaktAHCP23ie1WvgbzeaiN+beCEvcYYWAhmsF/HH35r3yM6eiOHh?=
 =?us-ascii?Q?t5ddGq72t/gv2O4ejKWSVa+qaULcauVZ4Qxmuc6SSavhTOxzCS1yH7vB4om5?=
 =?us-ascii?Q?lKH9qHReMth/K25AIQr1AoPp2xDP99TblN4ELjA5Oyhq6KteA3JILK6cYQxG?=
 =?us-ascii?Q?qbkfvqYYzAeoz4K3QPjCdlDnYlhBQcwwFyEEg7fcopVOMz46O5hUmKeYnJV4?=
 =?us-ascii?Q?x2RhBYGkDpm0z55Gv+ZTKcZq0YmMC8WfCtxZsyYXhLAILPCxUtYUXn/e7RlZ?=
 =?us-ascii?Q?69zcKOWS9/+IZENMve7sF0r9T6nedMPVgywyXrw7K19OUAYGB/B3A2sYcPao?=
 =?us-ascii?Q?Uzh7MFB9eT7sm4jR0v1IT04tSB8+Th6pErkuEruQTOzK0dr666DCS1+bOgcR?=
 =?us-ascii?Q?PYDitw8oJGdjoAOtKE0H15ohETixJQrZWLxdO4NVPn7ilHTfgdjJZprAz4Zy?=
 =?us-ascii?Q?qrulytPaY8RTHaXOIemMunIF6k48c14RjO+0guKSPXR7bg7JbQYBBP0VgfAx?=
 =?us-ascii?Q?4yfUv7QMSBsTAx6LmTXWDqZP1FZAMZJj6s8ktSAPsLtIihbGxlwrqZYjn4P0?=
 =?us-ascii?Q?jT088VcWeWSc1iyP+GzASuMooEDFkmPe92iOLJTUf6w4XO7NisCVDdAUsxGS?=
 =?us-ascii?Q?wOgWrbViXALaLTGag0An8HCaCijLL1+0CBOxn798Nh7iTRu8A5KsSvN0Z06R?=
 =?us-ascii?Q?AYnZcm/WiBYkxZ6c/aFU9n2wriHd+/uEhye0IwX59z4QEpGk1qcCL35C/jp7?=
 =?us-ascii?Q?0C7M6/NtcsSTzgAF0sr4dWOSL9fmS+70/GjdWXU7VqCIGUKqEta3yX3bVJEH?=
 =?us-ascii?Q?5SLtx9SWvBCr7cAVba7vFDs1mEkbNqrz199K16aMyxrCO9bt9FUTToEOzuH/?=
 =?us-ascii?Q?3St9ziKwFv6Pvxc9hK7tD5J0KvQeiS7GlJWZyyl2KWzLFhgcgs+uxHB4NawZ?=
 =?us-ascii?Q?BitbEpFHABay3gVJHDQCv4NyL0xbamnvWAwQoEXzHnLI/sMW+sdMuBvrz8KV?=
 =?us-ascii?Q?Rkaz3R4PZiqV84AkxDd/NhR1X0iQF7sDG+MHN2kkY6pKFacz6B7dwTpN/out?=
 =?us-ascii?Q?pw7/rqwO3IF2jk4fncqTD6riEkXFIky+J3eC/nWzAh3A8TH9RUECQUU2ic9E?=
 =?us-ascii?Q?MxB4VvGPgweUva1IpwA/N5AjDPTJ8PY9WxXQkLvG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e360a9-b98a-4089-434c-08dad248c33f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:31:58.3714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWrshT1D3qvKOEluwa66A6THmKPsLCYXGBRRIp2YTfTxrperGAzINqXQx7oaBumc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6439
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

Add a kconfig CONFIG_VFIO_CONTAINER that controls compiling the container
code. If 'n' then only iommufd will provide the container service. All the
support for vfio iommu drivers, including type1, will not be built.

This allows a compilation check that no inappropriate dependencies between
the device/group and container have been created.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig  | 35 +++++++++++++++--------
 drivers/vfio/Makefile |  4 +--
 drivers/vfio/vfio.h   | 65 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 1118d322eec97d..286c1663bd7564 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -3,8 +3,8 @@ menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	select IOMMU_API
 	depends on IOMMUFD || !IOMMUFD
-	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
 	select INTERVAL_TREE
+	select VFIO_CONTAINER if IOMMUFD=n
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/driver-api/vfio.rst for more details.
@@ -12,6 +12,18 @@ menuconfig VFIO
 	  If you don't know what to do here, say N.
 
 if VFIO
+config VFIO_CONTAINER
+	bool "Support for the VFIO container /dev/vfio/vfio"
+	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
+	default y
+	help
+	  The VFIO container is the classic interface to VFIO for establishing
+	  IOMMU mappings. If N is selected here then IOMMUFD must be used to
+	  manage the mappings.
+
+	  Unless testing IOMMUFD say Y here.
+
+if VFIO_CONTAINER
 config VFIO_IOMMU_TYPE1
 	tristate
 	default n
@@ -21,16 +33,6 @@ config VFIO_IOMMU_SPAPR_TCE
 	depends on SPAPR_TCE_IOMMU
 	default VFIO
 
-config VFIO_SPAPR_EEH
-	tristate
-	depends on EEH && VFIO_IOMMU_SPAPR_TCE
-	default VFIO
-
-config VFIO_VIRQFD
-	tristate
-	select EVENTFD
-	default n
-
 config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
 	help
@@ -44,6 +46,17 @@ config VFIO_NOIOMMU
 	  this mode since there is no IOMMU to provide DMA translation.
 
 	  If you don't know what to do here, say N.
+endif
+
+config VFIO_SPAPR_EEH
+	tristate
+	depends on EEH && VFIO_IOMMU_SPAPR_TCE
+	default VFIO
+
+config VFIO_VIRQFD
+	tristate
+	select EVENTFD
+	default n
 
 source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 3863922529ef20..b953517dc70f99 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -4,9 +4,9 @@ vfio_virqfd-y := virqfd.o
 obj-$(CONFIG_VFIO) += vfio.o
 
 vfio-y += vfio_main.o \
-	  iova_bitmap.o \
-	  container.o
+	  iova_bitmap.o
 vfio-$(CONFIG_IOMMUFD) += iommufd.o
+vfio-$(CONFIG_VFIO_CONTAINER) += container.o
 
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index b1ef842496372a..ce5fe3fc493b4e 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -55,7 +55,9 @@ struct vfio_group {
 	struct list_head		device_list;
 	struct mutex			device_lock;
 	struct list_head		vfio_next;
+#if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 	struct list_head		container_next;
+#endif
 	enum vfio_group_type		type;
 	struct mutex			group_lock;
 	struct kvm			*kvm;
@@ -64,6 +66,7 @@ struct vfio_group {
 	struct iommufd_ctx		*iommufd;
 };
 
+#if IS_ENABLED(CONFIG_VFIO_CONTAINER)
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
 	VFIO_IOMMU_CONTAINER_CLOSE = 0,
@@ -129,6 +132,68 @@ int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
 
 int __init vfio_container_init(void);
 void vfio_container_cleanup(void);
+#else
+static inline struct vfio_container *
+vfio_container_from_file(struct file *filep)
+{
+	return NULL;
+}
+
+static inline int vfio_group_use_container(struct vfio_group *group)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_group_unuse_container(struct vfio_group *group)
+{
+}
+
+static inline int vfio_container_attach_group(struct vfio_container *container,
+					      struct vfio_group *group)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_group_detach_container(struct vfio_group *group)
+{
+}
+
+static inline void vfio_device_container_register(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_container_unregister(struct vfio_device *device)
+{
+}
+
+static inline int vfio_container_pin_pages(struct vfio_container *container,
+					   struct iommu_group *iommu_group,
+					   dma_addr_t iova, int npage, int prot,
+					   struct page **pages)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void vfio_container_unpin_pages(struct vfio_container *container,
+					      dma_addr_t iova, int npage)
+{
+}
+
+static inline int vfio_container_dma_rw(struct vfio_container *container,
+					dma_addr_t iova, void *data, size_t len,
+					bool write)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int vfio_container_init(void)
+{
+	return 0;
+}
+static inline void vfio_container_cleanup(void)
+{
+}
+#endif
 
 #if IS_ENABLED(CONFIG_IOMMUFD)
 int vfio_iommufd_bind(struct vfio_device *device, struct iommufd_ctx *ictx);
-- 
2.38.1


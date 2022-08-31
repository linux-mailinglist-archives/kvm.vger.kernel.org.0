Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4010C5A731E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 03:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiHaBCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 21:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiHaBCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 21:02:12 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E7779EE2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 18:02:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTv21mbh90MifNoJON63V3ALG3sI5EtYPscmY34rDnc5k4nv5/xYYR+DMVuhFY1k7nu4q42dH3c+IbSZKYjaSmTRae0zP4oQ2m7CD0R0HJdclsaFoKnoAs+lmgeHkSjghhDVw0CVYE/IHfFrVK+/k+L0LBAm184qj7kJzBxkKXGxmhavfLabZTlSx8Xb9jd3DQd76jUClyGJYwUXKpfVnGR3HSftHXk7AwOpxBECu14duCOXnQIkY+/oGiacnHZ7b8U0Hl5E1fS+LjfR/Rzcn0KMmnQ9zGz8cxX5F09vqDBXfeKKCVeAt8cv3XYmAzEOybtor7q7Ijs0gDKRAR1jnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EykSJP8Pr5JkxvD00HjPhrC7lzQi+Tnh5LH+ilgH1Z4=;
 b=D7rPEXMKVII6AifnEZZx1fk35WtKYKzqCm4nDTfd2hqz/62OMVTIXRFmBFFfi2EfP7/SOYCZkmiwIQ/VPv5kQl6HYveMwa0hvYG8AGlMr/MXDfOExftjn0OxYqs+ldJ1s7LrDpkslX5Q5ljZH7Io7jjrWuG4+2oEXqhXdLyOKFBvS9AjkyXAq8lzLj75YaXBQeqswP0xRzxqhfdT8sN2aUeGLjVWaD4XnkcZUqnXm7EuEG3nWewq8I3flUOif7Vg+BtDVVLSRxQi1UlZsQhOFc8e1Lq4/55oRkIPZhczTYxk8Kbekm2Yw75zPPSxz8qxKsOT13gUXn7R0AFCo+6kDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EykSJP8Pr5JkxvD00HjPhrC7lzQi+Tnh5LH+ilgH1Z4=;
 b=l82z9lpN9qxyYY/MZdGIAhm+dVtI9c04ZHejUDr6J3afpNi11S0P+aF5qekYgkMC3oMuxyhBms4SKHFhPS7sHj9/FRHJp37iJqK3DrNYsbV0QLfYTG/VRSUIAlMHrFgjPtcpnxqf8siDV/NebWTQXMUJ2oHlMa9foNATu0Xca4RWnU8ng/Dys/d6f1ObuxkMBz3468JK4hk0pfpSTHsqYb3p1GbY2lmyZYdEj5B/owoPe5FhVSmIot8qIUNNrNAIXNH5nyDBZPauIsxAWngH2/ELhb5EHE4uvrA+OEEZkspdAs2FTNacl2PH/aRje88d5VFN+xBl3TFpAiJ+7uS6kA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 31 Aug
 2022 01:02:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 01:02:08 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 4/8] vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
Date:   Tue, 30 Aug 2022 22:01:58 -0300
Message-Id: <4-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0064.namprd02.prod.outlook.com
 (2603:10b6:207:3d::41) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0fd1979-2b88-4b94-bfb1-08da8aec6b40
X-MS-TrafficTypeDiagnostic: CO6PR12MB5410:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: esMskxUvrtFlBslW6RdG0ZB5ZmsdCe4HEPy1UGjjgwNA+KossnRYdAAi2EwnqNeNki/vLyHYk0dbUYweSUuJPyzBJc7tbS8yyI64rwF12eLjzYPmjM1HaSrSSE/BViXRk9OoqrycicDKste8H/R56YPLrxEv6xRQuRecr2y2SWbnsCNNONP/gyU0YdK+r0nWt0yUqG4f7EiJDLAfh/ufr1e12qyxuDYNkVYG9uxFM+xB8XyJQVFsnEiR7kBrBUUAPZ85FcGa5yiHxkghjfl/s2PgDdG2/5gsvc6ohxXhcVP1/w1qYEcTO6eNWXRuDfO2VEUebvTeu4YsxBMFTVwhSilrMMMKal82bvyasui/goCkui7Kerx5kNxm//nb6OKwtVhKzQg8129YmhgS3Qqib/XbmiWwRKbsZT7plOVpLdYSxnozlbPAa/ELN99y9S9tuuFoJ93EY1ls+ffmL4M6fDSLh4XwYgLrOnYL9WpbEAfux7g6LPHHzP7Yu7nQJBWykUa9044Xhb9Z2BUOhCy2Vi+Z/RqXGHUoCqg2KopZnFk9ye5ZH4yqWmQQ2J+6Dspiz/KECXiz8K+iQz12/i6Os2p/HLPgdrVT9ZXQxKT6GpxDqzps7qH3hrjYyHAoW21oTBOvx+Rpfb0VTPQw8P0I2IEzYsW6g9BLprY68jP7o6ziNfO9eiEaxHcDnqkvnL6aRkjOzDZ2qoFPjU5U39r11calzX9eb3z3PYkowdnOeNb6AqjOd+gYmJKJ004SRTwT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(6486002)(316002)(110136005)(66556008)(66476007)(66946007)(8676002)(86362001)(36756003)(5660300002)(8936002)(478600001)(41300700001)(26005)(2616005)(6506007)(2906002)(6512007)(6666004)(38100700002)(83380400001)(186003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LvWJCBfzOgSbzGEeWgDh2bMLzelnFhFjm9N0QDI2bI8IMwWNQd4u/7bmMaLt?=
 =?us-ascii?Q?gm7sX0izoNqsegGLkl6ClxJn8ZPEQKrfL6KGM9q44mD/EqEDBJKcHV+RO+GW?=
 =?us-ascii?Q?71UWEnehZAaD9JrsfPP53bEMnRleOJuoF9y/f8VRWmWRM70DyIwcmT/1yJ2Y?=
 =?us-ascii?Q?z2fyvUsrE8ZDawoVl/695Bs4V9JiLoVZnk+ET4OYzecQDujyLgN4Y0C7Bewd?=
 =?us-ascii?Q?AnQoZk+I/UqLAexx8NpIB1GFM5Ub2V+x6GQv9BHdkkWbR/0Ri1DXP2Z6/CI2?=
 =?us-ascii?Q?9u3ZLeINb2E28LmOe1KrWQ2rhYWO1F33MUZXcqHkBe5NsWtDB+4qZvVEJwVk?=
 =?us-ascii?Q?MaW6YSpO21qF8LbHE8UUGuVFLIEkG0WrIAvq0XSCYJccPLJtyb4cvvjCs0yb?=
 =?us-ascii?Q?E7lbcWNDxkx1KLCwxmrcrTv1YcYgH0IxFSioBQ1641Zxa+9yE4zj7cr4uSy3?=
 =?us-ascii?Q?RyI3BuexVH06XqKGsF1zoQAzTLVc9q4tlcGKqfi3zCc+FLexFTL3RbCbriKK?=
 =?us-ascii?Q?GQIVZzmQzA8ExDKLa9JWjBTOVuiWxcEY2HmzNOlwCYOvcVJUWo+p1nPJIiJY?=
 =?us-ascii?Q?uBw4Znau7Yw6KuyDGyytakcKfOH0vC6dcIiZxgVtDqGI2gf36hsY8au2y7mG?=
 =?us-ascii?Q?7lWp29bpcCN9uD5d/CeAtOQ1teQTrvRG4zOtBqh00qPnVhtYVatDZJVQiuSC?=
 =?us-ascii?Q?4RQ2IhPvivwajTXvOYWs6x2vGI6UYiW/ScUIqT97nBIzpmEsn1s3xr+vRJE5?=
 =?us-ascii?Q?od4DlN+IlunONYt14oZwFD7aFojbd8S8xilw8iDL7nkqrKEwyTpZgjvEgsZt?=
 =?us-ascii?Q?kMbpeo/IFD4IGC14EXVYR+7Wn/jHUQgHorJRdCSeSc+eXTZL7xFxmsTDTKz7?=
 =?us-ascii?Q?vRU9WKD/2P5RMf4vIP8apX9o9XAH6cW48wxvRnReazVPLGqhQGYbB1kNSrAj?=
 =?us-ascii?Q?k3ar8/f6oYTMSxxUZ/DQ3w43CZYQOtilvT18/pn5iKAYytqXm0h8ZXv0yDWr?=
 =?us-ascii?Q?ZhkUnX3AW0yxUFEMUqeLnzy0tc72x3ViK6TWtpWV5PruBnXUpiBnch7ERYdA?=
 =?us-ascii?Q?2f8d/kx5cpS0r99TLY7o61RYnp0iV/r0+2KI/euw62AJCdYNzJVU8StX6IyS?=
 =?us-ascii?Q?SAtNujuULN4sDYv8wXJAJNgTnjuo6HjV7tdvtroyJfYq3V/Tqg+ZEyPkmUCv?=
 =?us-ascii?Q?Jowe1dSUYGqi+6NRIR4bnAx2jNIfC9bz77fbWd6rLfpCA272UHgtsx2+l4/z?=
 =?us-ascii?Q?q+Fuglz6Jnl9kgWGaS3tEzv6oD2xm4tAi+y0MmaGfUzpg7jMVM0QQw0X7/fU?=
 =?us-ascii?Q?4io1NoChIMP6hz/aoDod6QdB09oR1iRH0UnQlm/1DeU1SHSR1E28PYru9v9v?=
 =?us-ascii?Q?OUzM6OF6DEFikh672G/VuVZczJA8oY/sYZBYXc/uy6cQoZgyW+cn/R1M5UH/?=
 =?us-ascii?Q?JUbBYcYFKhJ0VqS3rsF61uj9EeQYF9F1uptwT/mSmKqA4iwKxna/fsLqtplh?=
 =?us-ascii?Q?fGf0ghNgCeZg5yuH4lOCHiq/TfASWKVCxfNKLKKPRhLYYkC5NNPOfJILvOcA?=
 =?us-ascii?Q?rAvFqGKstmLKogN4mEe3Uy/Yjn2BEpTklfImV4k1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0fd1979-2b88-4b94-bfb1-08da8aec6b40
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 01:02:04.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PaXHYqrIXrg9YYnhVKJvCbAZcEZIlYQG+AguOEelPVzAgj7ESkhzgvFrBYbJzDQO
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

This can all be accomplished using typical IS_ENABLED techniques, drop it
all.

Also rename the variable to vfio_noiommu so this can be made global in
following patches.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 43 ++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1108ba53fe5c28..f76cea312028a6 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -82,10 +82,12 @@ struct vfio_group {
 };
 
 #ifdef CONFIG_VFIO_NOIOMMU
-static bool noiommu __read_mostly;
+static bool vfio_noiommu __read_mostly;
 module_param_named(enable_unsafe_noiommu_mode,
-		   noiommu, bool, S_IRUGO | S_IWUSR);
+		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
+#else
+enum { vfio_noiommu = false };
 #endif
 
 static DEFINE_XARRAY(vfio_device_set_xa);
@@ -162,7 +164,6 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
-#ifdef CONFIG_VFIO_NOIOMMU
 static void *vfio_noiommu_open(unsigned long arg)
 {
 	if (arg != VFIO_NOIOMMU_IOMMU)
@@ -181,7 +182,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
 			       unsigned int cmd, unsigned long arg)
 {
 	if (cmd == VFIO_CHECK_EXTENSION)
-		return noiommu && (arg == VFIO_NOIOMMU_IOMMU) ? 1 : 0;
+		return vfio_noiommu && (arg == VFIO_NOIOMMU_IOMMU) ? 1 : 0;
 
 	return -ENOTTY;
 }
@@ -211,18 +212,13 @@ static const struct vfio_iommu_driver_ops vfio_noiommu_ops = {
  * Only noiommu containers can use vfio-noiommu and noiommu containers can only
  * use vfio-noiommu.
  */
-static inline bool vfio_iommu_driver_allowed(struct vfio_container *container,
-		const struct vfio_iommu_driver *driver)
+static bool vfio_iommu_driver_allowed(struct vfio_container *container,
+				      const struct vfio_iommu_driver *driver)
 {
+	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		return true;
 	return container->noiommu == (driver->ops == &vfio_noiommu_ops);
 }
-#else
-static inline bool vfio_iommu_driver_allowed(struct vfio_container *container,
-		const struct vfio_iommu_driver *driver)
-{
-	return true;
-}
-#endif /* CONFIG_VFIO_NOIOMMU */
 
 /*
  * IOMMU driver registration
@@ -535,8 +531,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	struct vfio_group *group;
 
 	iommu_group = iommu_group_get(dev);
-#ifdef CONFIG_VFIO_NOIOMMU
-	if (!iommu_group && noiommu) {
+	if (!iommu_group && vfio_noiommu) {
 		/*
 		 * With noiommu enabled, create an IOMMU group for devices that
 		 * don't already have one, implying no IOMMU hardware/driver
@@ -550,7 +545,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 		}
 		return group;
 	}
-#endif
+
 	if (!iommu_group)
 		return ERR_PTR(-EINVAL);
 
@@ -2101,11 +2096,11 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_alloc_chrdev;
 
-#ifdef CONFIG_VFIO_NOIOMMU
-	ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
-#endif
-	if (ret)
-		goto err_driver_register;
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU)) {
+		ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
+		if (ret)
+			goto err_driver_register;
+	}
 
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return 0;
@@ -2124,9 +2119,9 @@ static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
 
-#ifdef CONFIG_VFIO_NOIOMMU
-	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
-#endif
+	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU))
+		vfio_unregister_iommu_driver(&vfio_noiommu_ops);
+
 	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 	class_destroy(vfio.class);
-- 
2.37.2


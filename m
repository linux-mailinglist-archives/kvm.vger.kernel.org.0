Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A6B5F32BE
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 17:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJCPjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 11:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJCPjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 11:39:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC62C25
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 08:39:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meg7T+nidf/dLWOxv6O5QJCvmkcI9SfpGScdN8ZojTbaIxZonr4flyVJNHNbmQyLe7nZCy1GkhjddEOmQokK7NXMw2bWKLNA9aMn619qjMIkm/148sPGx4jWQU/jAToHcQqYjSTIyhD0Tzvq1shCfxpD9G4D2qmkwtSnTpBFRqtGojU8pWFJ/Xr5C8e4FAkCajvq8/e+SwHg4pMwGzKcHqgoI9bZOQRgIyRlUSH6JKyT3WiFOcaxSB64zm5VIoD0qOEu2lnIKn8VY/UTE+GHF/xKeSM470DaozLxtcv3SWvWfLf25gFWzvq2l7Fg/GJIMVrzvjLMliuXu6HyuKM88g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aO9XhXJ8gvwOHJILQIXTLfZHlxeRa88Ch43D8LgAtlU=;
 b=G0UuMUNwJajwzbtY6PEki4AbXEsyMHpLgx0dP3Zz4QKHryH8EQXW7CtmSJyFOt/YHhMxUn1YLkQ/5929+b9enjdZduh9V+A+MLyFQO8K8ThLsBTgNIGKedFUCf+n3mn9XtA1LZWZsroTZD5iWEG4A7TNeQQdm9bvwEWlhfxXLhHJ05DtnadgV2fr8UmzxXK6mldIAojDwynN0AKTpag/EocMyQuxyLXGe9XU6sAiUqwmzsAVVdwiCCXmQb4JhAKFjW/gRGSBDOFhEYoKzaT30KX4ct1WQ5URNXTkWVwelnYC4/u8UIu/WZ2WSR9gzwMALdgLICnY05VjtEP6XMOJvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aO9XhXJ8gvwOHJILQIXTLfZHlxeRa88Ch43D8LgAtlU=;
 b=UGSqrchKvlPMOTO+VGQuL6mBwbcpiTuN2KducvnW+QnF+ALpNtFksJTa+FTkrW/cNVGlmJrRfVIBuvewjfYqJUt5nxd2CFc/7B38JqeInO5EZEp4hUYPHrHiWZeYWnw3K1tUZy3ar6YSLOr5BNOoqoplMhepHLzglGlzSuXX0CCU4o5FHSin+bCQnHtybv/89RiXUYxGiq1oed/hbQgcVIaZeA68G1rhHuC5uQZzigCsI3o6P4qIW6JWgIgLsNhMciIgajAhkphqG35rAoi6F4Jv1xobbZinrnhZ+LSSJngXZOHZClx8yZXP8yihYB95XU1mDF5nrSxuzGkg0AKXlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5471.namprd12.prod.outlook.com (2603:10b6:a03:300::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 15:39:36 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 15:39:36 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 1/4] vfio/pci: Move all the SPAPR PCI specific logic to vfio_pci_core.ko
Date:   Mon,  3 Oct 2022 12:39:30 -0300
Message-Id: <1-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:208:23a::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|SJ0PR12MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: d5dc5189-263f-45dd-cbcf-08daa555791e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 975SVvkoMLHm6a/smeh+rI576dUdJHpWCVllq8fdl5MGdjrr5rYf2YDzCox7A0zn73fS2OKlhidvsHzUjnwPxP0QixkeqwLOdWNdgVxmUxx3mWupN9F6/nZhrZIrddo8GbpPCkY09jIJqupntxngSCAtCQ1b1kWY0BmZ4JH6/lDSzEq0LeNbZjjb7xE6ZECuUuzAvkzfGiArDYxyGhire466dYCQOnHZk9DI+WElGY2miKGISaIZnF5lana+4QwPoRi7Tg6cEXsQmYaZVFz7BX6n60aIqsE2MR2D+vffVJoSDp5kaSbi3N1i/1i1k9obTYByo6JADcFs4716v8YDlS36OVAABnJVDosT6rTXwonjOAYfWBm0o3pUcoHauBi5VtATz9sr9LYN9u2FdW+jzglCQj5IHujBm1IZ8G6wk6mBdhWj6+1hbbfulFzBpDNxhgwh1lvNROFSg6Br6sl4mW2ky8Q05S5RtdO6pmF9SELDgJCtXfJUG0d3nW3gDJd5jwzxb+9VkQhC71iMw2WGhs6rk9N0jCMff9Rvby5S6ESBBJ+8uMYHBx3r5XgIAYm0mPxIK/bDWF+Xoqcmgx4xFIk3m8bE2AmSj+59laAPEnajgJaApLFGyUJ2MLYhmUUyMXsN9RmVSI0VWjfQQIVmQInaYZN8s991GjKa7DqiGGlvNb66Tj/PanSV4BTvPS+CDeMHcwWIulU6hrrVLbxmWcePfH8HV3ZCNB33dTduqvSkd+3peF1Kk6rxGkdj83sZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(6506007)(6666004)(38100700002)(8676002)(66556008)(66946007)(66476007)(36756003)(86362001)(478600001)(2616005)(186003)(26005)(6512007)(6486002)(110136005)(316002)(2906002)(5660300002)(8936002)(83380400001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cKgHkhIBy6elaH0eIsTbcRWeNCtuePfBFrQrrs4fIxy75nMbZe2F8YJBhrwq?=
 =?us-ascii?Q?S2hMqv8rXI0iJ/2BudPy5WJHTIcTQTCqafKkRDeOG96MmECU1Wf0pWHdCl6Q?=
 =?us-ascii?Q?HyCba6YCyVygvHA55yTp1vF4N6I2Ha2bCX/0nVUQ4Z0DNoVqTqQr5lAQBPEI?=
 =?us-ascii?Q?bgc0JAMZYCvjkKCqHExdVPbbPswUgTEWegs2H5CgYjsZkUZzD+mJSMxbMafT?=
 =?us-ascii?Q?cU9dRo7p5pJJnhYEaIK+ncMZ2xeAOFFx2V9VujVQ+lVPykHOb8IDnKyQ857y?=
 =?us-ascii?Q?96CQMDX9Aux1sgMKR2gz0VxgIcfLTsrlrMGgwo3iqVOZfr6gf1o2oT2WnAIS?=
 =?us-ascii?Q?vHR5rWbKanv/KCuLvlpy9Dt3XGzZO7lmCEQeDBFdM/c5ua7f1GrkQ4OP9DHP?=
 =?us-ascii?Q?McjPXzYc4OxRAgMI1RtjST7Ji7+ANWae8A0aXoM2WDDWr3CaUQAfkOClTbmK?=
 =?us-ascii?Q?g+q7CmAo4jIpC23RqRVRYxSg5MagenWSWAAhCATaTUJ7BCHFyyLDDGmyHKKG?=
 =?us-ascii?Q?qHLjts6R+JF/Y3ffaTvjhqK/XgEJ1PVKItHpYr7AYtMrg8k72/yD7+A594pR?=
 =?us-ascii?Q?3pFCs8qZ2MB/1SBqaAJJsfSzxndYc0nh+K5Cp49xJE/iA876tZGOZui/Uqfb?=
 =?us-ascii?Q?b3CI1GvEp9RPa+E8F6zIlUkGJPWppoSV3gdbIKpvEEvAXClZF/uACX42Tf5v?=
 =?us-ascii?Q?BBRz74+ff9gAoT/oVqAPijqnlZr8lwZpIJg0GevJJspjgK9UWM3FNIGwewb6?=
 =?us-ascii?Q?HFWbza0tQIhhF/cGrBDIOwiaZE+xEVkYNy0bf1qZFcyX6maM/6ePWvaxoQRf?=
 =?us-ascii?Q?t8whRFUbIIdRgBwK5ull31prV21qZTJJwDc9g1VIipKe+eIAAVBOh7E4tcXe?=
 =?us-ascii?Q?B+bhjGPo1vk9/Iz19EjkH8zoJ1AFFAAyOS/iyv+VSNyglHd474FkMJIQcYJ8?=
 =?us-ascii?Q?/+1DqwZL0B4qTT/EYYOIUE3a3bOuEEAoO70e4ueFOPWm6FRWv+AZA5zG0YhV?=
 =?us-ascii?Q?iI2rizVe7wML9LeDYigD7lQjrWg+hri4E7t8NF17KjlBOUNjKFGdOgwejeGu?=
 =?us-ascii?Q?5g7S8I63E1XPJwkD5btjGF9sulv7pdzyWTGdjegUw9i2sq9piJusQfJi68k5?=
 =?us-ascii?Q?nOaHsWoYjRkNd/mjoyVdN4CUjWIh6FUka7o+AvO/LvnCeHWabrR3sH6Qmsn7?=
 =?us-ascii?Q?PuuaDBkn7IpogpaJMW379vAlUOw2a2lOfWKjipi4iNiOlNAab8mkZ9HTe+y7?=
 =?us-ascii?Q?e3P/+HihL7f/ntqqFeXcl4zEVynICXF1I3//Y8JAyJiMZ13omDUyL7/e/qvT?=
 =?us-ascii?Q?dJzf+pNPqSnION9ZhdLWnA43LB2ztv0wC/HJBH+Z4Odhh8qDRHU5irqGnC/d?=
 =?us-ascii?Q?YcpEJ28m1A/4UkU82HxptkS/+4mzk4Wz9Yf3FDEqz9VUM7l0/kDWQkNjPnVx?=
 =?us-ascii?Q?bT/YEXv8V4DJ/ewBB7ldvS9BtjWkJzJsHlpul+KeRpFn/UhcT3EcB6R221Tm?=
 =?us-ascii?Q?owypCbD0fvm8l1shk117zvshs9AJp+ujFJU0UF9w8iM0tvWYhlxQ+HP0XdNx?=
 =?us-ascii?Q?j2dnq2C7lNXFzVgRaFlCon0vhYC8LPJRD2Hl1p2l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5dc5189-263f-45dd-cbcf-08daa555791e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:39:35.2023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yc/S0N8AITbxdr52p0KJLNMptuUfTMBfixoiLXaCO1tLMLpY3qp6IpxFLTmY5peZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5471
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
around an arch function. Just make them static inline and move them into
vfio_pci_priv.h. This eliminates some weird exported symbols that don't
need to exist.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_priv.h | 21 +++++++++++++++++++++
 drivers/vfio/vfio_spapr_eeh.c    | 13 -------------
 include/linux/vfio.h             | 11 -----------
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5e4fa69aee16c1..24d93b2ac9f52b 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -101,4 +101,25 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
+#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#include <asm/eeh.h>
+static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
+{
+	eeh_dev_open(pdev);
+}
+
+static inline void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
+{
+	eeh_dev_release(pdev);
+}
+#else
+static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
+{
+}
+
+static inline void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/vfio/vfio_spapr_eeh.c b/drivers/vfio/vfio_spapr_eeh.c
index 67f55ac1d459cc..c9d102aafbcd11 100644
--- a/drivers/vfio/vfio_spapr_eeh.c
+++ b/drivers/vfio/vfio_spapr_eeh.c
@@ -15,19 +15,6 @@
 #define DRIVER_AUTHOR	"Gavin Shan, IBM Corporation"
 #define DRIVER_DESC	"VFIO IOMMU SPAPR EEH"
 
-/* We might build address mapping here for "fast" path later */
-void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
-{
-	eeh_dev_open(pdev);
-}
-EXPORT_SYMBOL_GPL(vfio_spapr_pci_eeh_open);
-
-void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
-{
-	eeh_dev_release(pdev);
-}
-EXPORT_SYMBOL_GPL(vfio_spapr_pci_eeh_release);
-
 long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 				unsigned int cmd, unsigned long arg)
 {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ee399a768070d0..b0557e46b777a2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -230,21 +230,10 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr,
 				       int num_irqs, int max_irq_type,
 				       size_t *data_size);
 
-struct pci_dev;
 #if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
-void vfio_spapr_pci_eeh_open(struct pci_dev *pdev);
-void vfio_spapr_pci_eeh_release(struct pci_dev *pdev);
 long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group, unsigned int cmd,
 				unsigned long arg);
 #else
-static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
-{
-}
-
-static inline void vfio_spapr_pci_eeh_release(struct pci_dev *pdev)
-{
-}
-
 static inline long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 					      unsigned int cmd,
 					      unsigned long arg)
-- 
2.37.3


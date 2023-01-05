Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C320265F49C
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbjAETgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbjAETfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:35:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73AF18380;
        Thu,  5 Jan 2023 11:34:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIjgmZTZnbyhzv5RE7nMd+Px8wo59ZI0yGEAgfeYexiF7B4wPBVTW2xokh9qrSL6k0ZpEIlk9MD2NqVYyuL+mYv8Y7hUg3H7GMwuNHISFULbaww/rrLbnaKFPBoQI/u3G/yduRioWk+F7SJgOUN96+/5/N2zCmku2QKdGdbe28uFKXEiWlzrr1BY55t3A+sVhydwm+WgVk3t5gzZtgkBM4rH4rfiU1Bm7+ZhdlWSftI/Uj3QjEC0wEXItAUgYeqFRFQLFWQOJQ1qrDnZnmvWNKpIXmCDRMcAteiK1qGWJTDzw1ne8e1JhuensIGq4AE58sBmK48dsQ1sdUoYu2DAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zy+THkEzs3vZnFUTuqqQXlIcXMufDEl0Vr09ikq85SU=;
 b=htGlWdx/CzVcNxGmUV3lVb3nmv79VI+Ed9z3VhRRhsSAlFkB6XX6zEN+I/XMcDEK3mYdZSEe95USFkYJbXnPXiJ0+dwD8lURIQHwiqrMznTr553gb0lzCkT4F+z3t2FrTYzdt8zgCadTgmV5l7QHmJ43wLN4F3fZ9+t72PAWvURScXLxcAmLaLx4h4Ew7iY72WJTTfxGhCeVKV5sYHEtNIPn0rwZxIoyhdCd36lfiuRobdMt/n2Zh4DtTwMUOV3edrToJizvuR47gh+WtK2fNo2i/bpDyVWi/utYtV4DuiO3fvwMe2aO0UHbZjebYNtabOvzZHENBnhtmoY0KkZfRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zy+THkEzs3vZnFUTuqqQXlIcXMufDEl0Vr09ikq85SU=;
 b=HIxXvSlcKKGkN6uCehPrBagqcmyrQQORxpttyE3Ij8vnQjTbbdTNzuaJtIBlY46F8uGr+yNjyYbu4TeOcsXOFBBfkRdVhtDJgRzd2EGlD56QCe8on65KDZ0siRR6om1cE4oPhRC7FFN0O6NkfsPUR51eudLatipnRm9a0+G68YzoC9zuklyoblHvojf26Z0KvO8hnatt3vfZ8nCsTWCwU3hi8xQ6PaZuZr4bocLXWCctrS03HSNjXFAGg1dN5/EczRNAM9vlyXknzcKWI4lghrF1CsnrTWstZK3W9YUKqscYnBbkTuWDRB6BJMbm9PWAApDwZrwyMVj4gCNxyO7vuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:34:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:34:00 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v3 8/9] irq/s390: Add arch_is_isolated_msi() for s390
Date:   Thu,  5 Jan 2023 15:33:56 -0400
Message-Id: <8-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:208:160::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c259066-4865-46cb-1d1a-08daef53cac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a7EAof3v4OInOdAR+C0Qn8v3a5fOAJSlro2/wpUHi8503D3jFLIq3HFyTINVmAtTSrYxG93if74aVXq7HbaGLsz+kGbwVqY4svmff+zRRvqtPVEyrRsLlbzF3GWAAwg4wPsDfAu+hbcP+lxW5YO0dJOZfcUu1bhcfSRcw3JlsxXatCQRPNosRWiN9MvY9Lz3qfvgIPtADsGEJrz0LW7zPlzT0xoXV8tA9bGTAsDPd0xCBt+Tt3O+FXnniTBq6K1o5CSrthULq5dJAEn5oj8UoZcMltwFJeMDxtjT33UwDAVkzxzTQH4OZ3rN3a4kKCP5r2aOUIxHjW7jVYPr7rEvIKCQ4FsLSD642MUlFzAB/g7XESvkjKqRUPP/ZoHfyp5l9phQtIwnNk/aoDRFKTLwuiX/JPfCFTRyaf0yJri1AnzUn+pCbp3RMJEyZePP8AkijgE5K2w6T704mVl0avogHgHoXqEQskvNTYgcGS8B86VgGJmAmtxmRTtM2RoiZLffFXYtCrV5gZvbyStmj2Tm3+9xvAiPWEyxp+Z+CYOpBKW/Ys0pKo6dxvU4UFARAOzI1dbiSCaaMfmLPhc1kGy5C7y1vNYs0+st0ko8GO9LFn4rxFAboiXOJHFr/G8mxLLG9MYiDMqDggH5O3qdkbW8d1Xe4DW2+I862gOg80hQVkhoAUDvct0YPHpg3SV6xwlXgAq6A6+G8M4WLIxwPmO0/FLj+9B30kN/HMvQ3P0/kZmXI+Vjj7pEyJnRhe2spcfOq5NBbZYU5A5hYD7vRAoncMPSAe0mZ4+0vZmt2VDI3dQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(6486002)(6512007)(26005)(186003)(6506007)(7416002)(966005)(8936002)(83380400001)(478600001)(54906003)(4326008)(316002)(2616005)(66476007)(8676002)(36756003)(66556008)(6666004)(66946007)(41300700001)(38100700002)(5660300002)(2906002)(110136005)(921005)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E9/2aSRMG71erA8S4QPDhSuJ7SBKkT7A2xyblRFfIk9xlaYuQipomg0gdztJ?=
 =?us-ascii?Q?XbPIom3hcqQHugnwhLaCV3oANxDQCIb0GWYwGZRjLNP4RP1qA8r4phBekENl?=
 =?us-ascii?Q?nDbh6LBAmb+mAc+apmzPd6AyvKMorsllznQO/v3ud2sU4ham8yOJ13TgqA1Y?=
 =?us-ascii?Q?Ovimtfun9ogj1qDr1tuzodVaYGypOxzMA9KHJkMtezKez8Gdv9s8ri2xA4Xg?=
 =?us-ascii?Q?C6d6fmP8c2hN4YJbUCbj8rNOktfVCx7NtnWhLKTndHmXeZp6jj5AXW2UnH0i?=
 =?us-ascii?Q?OWBWzbocaltS5RwuBELVbMwAQlSVswgEe07yyLaX3YoGuMlWtSazi4mumcu7?=
 =?us-ascii?Q?nVAl+tKyQywoow7amR5I56OkaGyD4R/pdLMxcjFtKlzSx3iceVrIebzenEkO?=
 =?us-ascii?Q?XtmdPco44/c8s6xpKOo3Ed0Q04+ZpnGwdSWQX8KbDCEt9GBmHH+/7m0t1xpg?=
 =?us-ascii?Q?UBzqxVIX3CfTDvXuG2EVSiId640SG9I1qeC0ophlokJC1+Gde1/bJ8mWpZ73?=
 =?us-ascii?Q?7bFFz7oXNW84fiIXDf82mo5kTwdUEneMZpk8fDUCLAiU5bpAbeaHDN9/iRkm?=
 =?us-ascii?Q?zUJen461K5M19glX85CopBDLi1k/wtUpTycMYrdMw9LoonHBGBGQkY+HtnTF?=
 =?us-ascii?Q?SdTki7eny+Gj6Wm67WdxkT9yQLNfo+kJY0k05jP5mKkiAtu9MSgsyvDEAd1j?=
 =?us-ascii?Q?CfgupR1srnnhi+86DzLxbXbh36fG5/ZJcGpNljhZF0hCJMfWkCPBULWvAYeR?=
 =?us-ascii?Q?3N2Ymf6lZ8WOaIAT6iAZZVWXOo8T7cy3dyXj1EaQ2wjuxcRTHNxE7fXlX6QO?=
 =?us-ascii?Q?GyA+lD6MOmfw2osV4y7tdzgwK+P0SqEFkzZXbRCKzEz+Y1pa3zviAwj0Y91t?=
 =?us-ascii?Q?1l/59O3rYvod9xyKtthBEvk4iYGCiyShcdLNLyrkUYxCB8CrfYpe4JqNCz56?=
 =?us-ascii?Q?/2RZFsVOvlyyd1HWQ2ez3rqMgep4uK+C0els9gBfmF0dc5Yh+3uSvh0awfoS?=
 =?us-ascii?Q?wY/RT4dX9K4wbwvH52+qs/XhHQSySLQR56oVeYaNXDHYgCzuivUHF82qumHH?=
 =?us-ascii?Q?V7hgxJ4ewFDUSGEnlUhyYVM8Ysa82lGwOrtm3/+BT+atiJAkbs5uSsqz9PD2?=
 =?us-ascii?Q?k5bTzDlYs90uqLe7eEjl5hcKzUWqDrJ1gY3b/ZWqKN5pZ0EUCHEsk9mZ3Nvs?=
 =?us-ascii?Q?5iTUZalS8Ge/+3rKmJFyZccM75z+/8nFO3WGJv/V4/c9lBYEfQOfVnNQ0c59?=
 =?us-ascii?Q?zDw0x1N/8Pc+UVRmx/tk4BIjfMroYNYxuVLfaoNGxBD0f1R/E0MjUMmIcUWy?=
 =?us-ascii?Q?zKXp0xbSBW5DGoWbzJHVwnk6B4+Kt5MgElUyjMfl4gvu8j+kSQcPSciJQuNn?=
 =?us-ascii?Q?Q387zRaxN5Cv9IqX0Umt8PFppR1bj3+0Ke4SgPQibkNUrEeMp6g+mMUPyGUF?=
 =?us-ascii?Q?3JyzYbaCjR56nTUA+GTmocyEgBSe1iqWB0Mw34H5zcq54Eu7/BNs2SXFj8y4?=
 =?us-ascii?Q?gQgT5uu62sZcRLnZXUzAxfDQpbmpCdiymfTlDCr4SwvjCffSUwipscmLxZhP?=
 =?us-ascii?Q?/BIkiQRnMd0iVisAUjS/10+uH8LnBGjc7mxNH0kH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c259066-4865-46cb-1d1a-08daef53cac3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:33:59.0704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpPNutKEC7UcQrbbL6yKzkhymJoxyT8Sv+0nSYQSobXTi1NZlBmDD3L6gefym9ij
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390 doesn't use irq_domains, so it has no place to set
IRQ_DOMAIN_FLAG_ISOLATED_MSI. Instead of continuing to abuse the iommu
subsystem to convey this information add a simple define which s390 can
make statically true. The define will cause msi_device_has_isolated() to
return true.

Remove IOMMU_CAP_INTR_REMAP from the s390 iommu driver.

Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/s390/include/asm/msi.h | 17 +++++++++++++++++
 drivers/iommu/s390-iommu.c  |  2 --
 include/linux/msi.h         | 10 +++++++---
 kernel/irq/msi.c            |  2 +-
 4 files changed, 25 insertions(+), 6 deletions(-)
 create mode 100644 arch/s390/include/asm/msi.h

diff --git a/arch/s390/include/asm/msi.h b/arch/s390/include/asm/msi.h
new file mode 100644
index 00000000000000..399343ed9ffbc6
--- /dev/null
+++ b/arch/s390/include/asm/msi.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_S390_MSI_H
+#define _ASM_S390_MSI_H
+#include <asm-generic/msi.h>
+
+/*
+ * Work around S390 not using irq_domain at all so we can't set
+ * IRQ_DOMAIN_FLAG_ISOLATED_MSI. See for an explanation how it works:
+ *
+ * https://lore.kernel.org/r/31af8174-35e9-ebeb-b9ef-74c90d4bfd93@linux.ibm.com/
+ *
+ * Note this is less isolated than the ARM/x86 versions as userspace can trigger
+ * MSI belonging to kernel devices within the same gisa.
+ */
+#define arch_is_isolated_msi() true
+
+#endif
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index ed33c6cce08362..bb00580a30d84d 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -34,8 +34,6 @@ static bool s390_iommu_capable(struct device *dev, enum iommu_cap cap)
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_INTR_REMAP:
-		return true;
 	default:
 		return false;
 	}
diff --git a/include/linux/msi.h b/include/linux/msi.h
index e8a3f3a8a7f427..13c9b74a4575aa 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -48,6 +48,10 @@ typedef struct arch_msi_msg_data {
 } __attribute__ ((packed)) arch_msi_msg_data_t;
 #endif
 
+#ifndef arch_is_isolated_msi
+#define arch_is_isolated_msi() false
+#endif
+
 /**
  * msi_msg - Representation of a MSI message
  * @address_lo:		Low 32 bits of msi message address
@@ -657,10 +661,10 @@ static inline bool msi_device_has_isolated_msi(struct device *dev)
 	/*
 	 * Arguably if the platform does not enable MSI support then it has
 	 * "isolated MSI", as an interrupt controller that cannot receive MSIs
-	 * is inherently isolated by our definition. As nobody seems to needs
-	 * this be conservative and return false anyhow.
+	 * is inherently isolated by our definition. The default definition for
+	 * arch_is_isolated_msi() is conservative and returns false anyhow.
 	 */
-	return false;
+	return arch_is_isolated_msi();
 }
 #endif /* CONFIG_GENERIC_MSI_IRQ */
 
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index ac5e224a11b9aa..4dec57fc4ea639 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1647,6 +1647,6 @@ bool msi_device_has_isolated_msi(struct device *dev)
 	for (; domain; domain = domain->parent)
 		if (domain->flags & IRQ_DOMAIN_FLAG_ISOLATED_MSI)
 			return true;
-	return false;
+	return arch_is_isolated_msi();
 }
 EXPORT_SYMBOL_GPL(msi_device_has_isolated_msi);
-- 
2.39.0


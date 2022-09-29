Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CA75EF84B
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiI2PFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiI2PFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:05:04 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA8A4C604
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:05:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0t061wwztNxpPuWvu+zdg7mkryQiv2OiCYJuvgj9wxOikoSHCfPp44MO5q6uZPajguTRYfzPNLVquJfNUnqMa6/Xqal+lynLa8MrYbLEhtquxt9ILbQaqDzw5/ewCIDao9Zm42QMlgIhMePsAq+BMhHOVzaUpt2E2sDAfwAzWWoSYuJussX0n23w3e4UGYKgHKBO1ZVhVCojQSNnzjvgF4K8mD/6XZ4yQRIx3k7cIMY952yFB0MWQ2udqaecCHPpf9WZYJ1e1lQ0t/wTQO1koxK3qaMtEWkA+WJZddRBgK8/dFwCt7gq5p+2CZaGAhrLpuxdEUtqwv/Scm2V3p7eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRDXqDHX3kVxO8OcurD/1uM6q0kYj3kVf0ZEqclkIL8=;
 b=XRMvU+8S+wzrIlNa/6uF7CQ8lajh0OXiKd0ou1wlVXVomjiz4F+I9dWsOwBys5oCorq2TyZDT+BjECNNBgqZ7ynSyYZ4p6TSbDBTY0PujWzJzLdaN8xc7pTFqGnDNdRw80PJYk4vmSOau4VaOHtaw1ICRF1YQfLRhKHv6YUvyxppseSxu2yvGq8K8cXHc+anoJnr2AMZN1KVjR3VWa6f0yunYtJHM1arYiI267xz+3feH5haZo1vdX8UDiJcebQJQLnXBOMtPjOiGVtum1ghUKVbSXJPIj5EGE4w9c0Ju7+4GPzoEisSuZiv7HYkMG63L8d8FGnioOQN9v2mSoz+Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRDXqDHX3kVxO8OcurD/1uM6q0kYj3kVf0ZEqclkIL8=;
 b=d1J+rzQb+sim9xLxu1lOjdZlF/evQUxmKu1ezFcEbcnyRmDKCBT/hn9T729CFUvhWIBxcUIY+Fh3iKz2CZOhmEllBjaw0JBr29BxRjx8LX1saRwExrh2hg+DJpo7GcbreO8+gk8Zq6+qZPWRdEb+m1B8JhgOTUc/ErNB8PlV1HeoYoFwP4vO4PrFspsMP+Uc057AMDzOyWf8k68nMcTJ3j+osKBXDfxKXJG6++zaWtYNC8SJ3ap7qnuh1B9BSO74c7+qMvpgJcTFcnfGTvs569+pgLy+jz1NWjXMrHrGWyV5dspmAYkscFhim4hTnZnqB/ihZ4qFiHalEc31NcIpdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 15:05:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 15:05:00 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 3/4] vfio: Remove CONFIG_VFIO_SPAPR_EEH
Date:   Thu, 29 Sep 2022 12:04:57 -0300
Message-Id: <3-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
In-Reply-To: <0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0120.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|PH0PR12MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: f662eef6-19a3-454a-2c3d-08daa22bfaaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sezkt+o2kgLGUbKdqs6Py4s7CC0ZKSxJCeqkfGoi7fdoYK1ey2AbazJBlZcufdXCxnJZUBtVVrejRFa1Qp03zqiB2Ut2EqOydG8g1C/bpWs1eeXSIFgOGUkMNd/o6SSSaMmFJAEqGHC5qNP4kSKhqyLQUpjB8i9RJw3772UNJL6FcHgDDBVthUY8NNCB/HflOhODexuxTPyKvGWXu06tuw/3mql3HyQIDKuiw9bkOjUwz5fyLAXCpAsYMb3jaW4cWUJ6qgISvCDYZYRn8Apb0HUFUMTrBCnZw7wux2DD/9cw/JWmkbYAXIzi1v9TNGPIZUP9vlgOQvtT6KqE5VrsuhRY6o7yj6Exsy0jUfh68rn9HIZJjOIMmehpTCojsi3o8tl3bub4oQ4okA7gAsiF0hyBvAWHoB8iKtm2ScISn7AbXFAz6TIUkXSIzV45g+8AHwdmNcku7/gKw3I0NsuF+TbHAQM22g41bQKszFpJIBN0xT7nCjY6K0fRbPEsK9hwvIojpLSKxEQKawWHD6tEA6wQwGW/1fjC/NpabrmZREO4FNOvwvdMDEePuqWHqE4QtzJfDG2aXNA/aftujuUJORRpSipdK+c9ywSh1PWwNjsZd0B2gcDuMBGlyJJkrb+ECYQYZMlDTbka+O0e9O6eaQrjgb77hRZqa+Y3YoNGxP6KRz/zGqMsH/l+uZzl9TgdzpjTof2DwQlGDvfHxGlrgmNWAxonY0I+uCHm/V5G7YBQ7vVQ2iRzitKSK/BjGkIZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(8676002)(83380400001)(186003)(38100700002)(2616005)(6512007)(2906002)(41300700001)(8936002)(5660300002)(6486002)(478600001)(26005)(6506007)(6666004)(66476007)(66556008)(316002)(66946007)(110136005)(36756003)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8PeHqQgZwwXz9TohmdMvSLSAI/8P+GCWJ3AJciPl/j+COGYLvBHnAkiCmYJ1?=
 =?us-ascii?Q?DU1CO44w/c9d0OKCuOhDyyx7N8FoGlF7H508mjz1Y1QffDuBuno79hTj2TcU?=
 =?us-ascii?Q?rKCpiD/w1MrY32gofrz5fssj1cL8vxqrYsG/aYwuAqm9l7sL318Rrxy4QtVy?=
 =?us-ascii?Q?e9Dx/pJqKS/EXuCNAGsdobxVNVfIQAnEKMamVlBZXAbsAMYPY2NJ0kU/l0RY?=
 =?us-ascii?Q?d+Ihyf2aH9azAsqPOUrQDuEPmc7k9rMvu9L7EoOB0HRNm16aHOv7dL0oZGUa?=
 =?us-ascii?Q?1pq+CveMbJMfFnoUKVADCMILpZvIZV6JmxyXgnofP/4WqjJzCJE8GwTq14UO?=
 =?us-ascii?Q?N9YHu9FSgLUvSpoBFz6i0vUCqflTg9IkvTtYUqf7/TJT6wLOflfeRf2YLCGE?=
 =?us-ascii?Q?ojj103FlociZyTXLjGAGQwY5RE88Y5lQ2tUnsVl3MY5I8a0UQfDqOshsmxlt?=
 =?us-ascii?Q?p61eggH/Vhgbs1OqGHfiHgbGH8o3/dUcAmodS/N+hVMu1B8nJ84rujoxRzq7?=
 =?us-ascii?Q?6Q80ZvdkO6wzD4AmWJB5eMCGZj5IOF9lMGKw8lMFXHhoeIrWH0EXCIIKPSyt?=
 =?us-ascii?Q?9KQvZMafJA77PK/WuP1wHFTnhp/s+F9ECifnMaCsCRS6EpYFtBeNbDnZpbj9?=
 =?us-ascii?Q?+3dfmhpm3NKu7LggvpNZx2/KjTfheJJMgvAR25rBDlICi9MqURS8tsl0R39G?=
 =?us-ascii?Q?raN5AYrLXAvAHbc0PBmNDJzrtls+gTNdwjEL1JMpMjWoX/jz/TCTM/yo+uMs?=
 =?us-ascii?Q?hVrYNazREi2V3oYENsIZ/Ueax9tZjlmA5goyyFHKkbloVk2/RY4yC4xW5All?=
 =?us-ascii?Q?8btm2NzQ7JwYMWjddWTja+2rx/7ZEp4LBxCsyqlE0yZYqe2Fn5Yj2FlQLJR+?=
 =?us-ascii?Q?EycmJAofJfYYY34PcEW6EEs8eRzgdLwp+Qk3en0u2lLuxvc2MAX9ty2aBlBj?=
 =?us-ascii?Q?LldRos6796Dv/VRuC6BP20Hv5KC6DPWTSXvWi6sCD2c8PoUQuJH6ND21Yd6N?=
 =?us-ascii?Q?Pa/2l8GwcOXB1dQuXzATigh29Hg34mLM+gSsg579O/ADp411Y/kJ0NH7Waej?=
 =?us-ascii?Q?vUnWFjr43FYYWdEd+GAqvkheCCh6lvFqP4j8YC0b0H5qkPDe5TR6VPF/4vtA?=
 =?us-ascii?Q?yZChF+lIsY6RTCQ95MB58p8EMoxLt5c/NsPXjAwBP1GAcwVIjdaS0vGIV6X8?=
 =?us-ascii?Q?UFRGdziDREQ0GCqf0CR3UzmvQNto3D+inFOfbnST5Kw37LR0sGGYlNoI+i99?=
 =?us-ascii?Q?z+mZHbIjaqPYgbrK09pO1ZBomuyueAxwHuwC2RukVexTvWAQcvW8AY3JeznD?=
 =?us-ascii?Q?M/sRbuwr068fOyq4tlAXZzahcbkXVejCbAAW4ryrX7EY3sQX4vTGN3rEmgqS?=
 =?us-ascii?Q?wvZY16s1+3EDQ/2sXbSFfw3vmQ7q719Lp7GB9qrEElGOTJjbG++scbEcRpTA?=
 =?us-ascii?Q?gC6YDZq4j+q9mZilPxzR/Bsp1ZWrRaOG0zBAxTj+jS1eM5V9yCNAOtdupiHr?=
 =?us-ascii?Q?NCel950dC9NE/+qr0Mdb+2JPSzUaD3WE8x2nYgqGBxRevnoMy5ziTkilkB8V?=
 =?us-ascii?Q?guVrpxToylOX6TE8xQ0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f662eef6-19a3-454a-2c3d-08daa22bfaaa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 15:05:00.0189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSjEC7tFybqNh71ztXN4qksiOnptH4qxgH6TFcCAbWc/aVVfJ5fonH9bd0mFkuAG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need a kconfig symbol for this, just directly test CONFIG_EEH in
the one remaining place that needs it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig             | 5 -----
 drivers/vfio/pci/vfio_pci_priv.h | 2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 86c381ceb9a1e9..d25b91adfd64cd 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -20,11 +20,6 @@ config VFIO_IOMMU_SPAPR_TCE
 	depends on SPAPR_TCE_IOMMU
 	default VFIO
 
-config VFIO_SPAPR_EEH
-	tristate
-	depends on EEH && VFIO_IOMMU_SPAPR_TCE
-	default VFIO
-
 config VFIO_VIRQFD
 	tristate
 	select EVENTFD
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 24d93b2ac9f52b..d0fdc0b824c743 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -101,7 +101,7 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
-#if IS_ENABLED(CONFIG_VFIO_SPAPR_EEH)
+#if IS_ENABLED(CONFIG_EEH) && IS_ENABLED(CONFIG_VFIO_IOMMU_SPAPR_TCE)
 #include <asm/eeh.h>
 static inline void vfio_spapr_pci_eeh_open(struct pci_dev *pdev)
 {
-- 
2.37.3


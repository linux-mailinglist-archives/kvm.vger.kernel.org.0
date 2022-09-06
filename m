Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477D45AEC07
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbiIFOUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241277AbiIFOSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:18:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E181A3A9;
        Tue,  6 Sep 2022 06:49:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfMevd7NqJZQr54fAiJsrhAbnVEFr+9BNYbhrXledM7+IB4Z6UcNDiiJRbGoBrID7qsT5eXIUdD3dyetOjHO9wPqE0XU60NReVn1ceV7kljHVGcyC00r8TDgkRw1q+wPBscPo/pkEJgNVZKJOMvNzVTjEUjt1VZFMo0YyXrFJKgiO1tTyjXs/tjQfXtcdmc2BIYCdgqzmvFdXKHCq8IKXDtHD2/CoNLzXza5g/66i6T20a5jpn195YNkC1GJcbIjpPN1w4OgrWMdD0x+Z/QtlG8ZhOoUwwH2Jny+eQYD9D3C7aZvDn1UpJNppGO4dJXbup1RaluOr4ec3Mc1ykVKsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFLqRFQwdCB/AVMKNaSF9HMOVyLB+Gzq9vpFzIaP/vg=;
 b=c3EQR/c+4X5JUspMN3VqQaRTQ6bqb22uJMoVgA43dGvjoG0vSAjyK/uFE9hLxUt8uIsw60dLOa0pweJ2/g/swUqG66qtrXGtoHg2tdgBicAKFgjKBqdZB2SdZdqyJVX3XAkx2reObwpIWcbKqxgWTnljKmamXR4F29shed+oJ7z8LUrXq5nlP3Fps7/BN2N6WwqE9GvevT/KxWFgAi6ztkVUD7l7sbQAfpiVLu3lIeTz1hS9dgw7pxO89O1oDb7inrRYZOLM6M+xfa2wBWYKFhOpuVE2dXqDdxXRLKHlxguTWS3oFNONaDGwYPbv2Rg/elpoa2BJu8lstMw8LzbAIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFLqRFQwdCB/AVMKNaSF9HMOVyLB+Gzq9vpFzIaP/vg=;
 b=JghcdcGjFdNP2ZTwRrEgGmP/xlfEWHmUNOZGQlwZRUEWelrMHh1WIDuP2p+kVXA7dfAhjNMs3oVWbSUhy47p1Dh8TXN5zTKbYQ5hUEe8AV1KAOOCG1MU1yWI1Ded2vUaSQuxjHOby2tr0qah+fRiBWJH4SFJU/nH+tIa8Padmk4=
Received: from BN9P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::23)
 by DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Tue, 6 Sep
 2022 13:48:45 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::30) by BN9P223CA0018.outlook.office365.com
 (2603:10b6:408:10b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12 via Frontend
 Transport; Tue, 6 Sep 2022 13:48:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.10 via Frontend Transport; Tue, 6 Sep 2022 13:48:44 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:48:43 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:48:42 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 08:48:33 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <jgg@nvidia.com>, <robin.murphy@arm.com>,
        <will@kernel.org>, <joro@8bytes.org>, <masahiroy@kernel.org>,
        <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>,
        <aleksandar.radovanovic@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration for CDX bus
Date:   Tue, 6 Sep 2022 19:17:57 +0530
Message-ID: <20220906134801.4079497-4-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906134801.4079497-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6010912-b4b0-452e-5e44-08da900e843d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5279:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKhFPQ2rEF7/crTGWm+MaKqkCDVo8LCQKiW4QfOG/HCHMOrT5dU+l+bPHL2/fNa6Mp+yhr6kiWeffwo4qNXl3K+TuNDsT38/EERDq3fqeE/DxBcWXCnlIkmlrHX8+Y2QGozG3hmAbWY8Uxz9vjTaWuhRKx2CJNY8UcXounR3DlWj320sGh0Qn3GJAeq2nTWm98uB7EK8pTeC3lHUEKMN2aY6yvoh8Qn+rMQt5nELGG/mbaTSnCk6rYTt2aYbFHGhuftrOTt4ZgHRqHKOqj6hl3Vtyn8Ppj05knrb1s6ZtBbDqkRcf1UpMRggJJgBuhfDUAxWLhoGYmRxUUK9Of+0ul0XeDpcu1x04jMlttdNDidtrvNP1q8+N/Z/3H0lldGpQfrHOrLEiXw+TADsfqb/RAMhyc1R33gikxxipDi79FxkbNKxpSBp+5bGTcgEPw8lQKu7xbPSkcfhxmiNdu0M+gJjIrk9+bdYkOxjiWhvr39a7w1jJ9Z+9oJZEWI/5Ik67/Of5szInixUjiPD0wUSoe2V1qW+RvmIbAFyfiIzWaxuOJmsKQKvVSlo7VvrmkMo6JWmZPJvO0KcsTcfaNk3oOH1WDxXBENZYazENgTXDqznr1PL1pirYDDQt1kAhuJrNfK02GO1v1zwyRnfR/ATsGAP4mcojn77TauNHDqGBR7CgSkjorrcXHu+e9duEZ0BOHB+Qqm48tccaQWQsY06PzvWmvSYur5B1eFQIMA8KPpjgNEyLO6/2a4B8CmgjW7zyodLvK6nlvcwSaUwOhw4N/R9u8xY8VkruSJEchGCXCBRwYkOjyyXna0xI8jxBdj1jKSGzAvzyb5j/eVj3RcD3DyU3BT4ut6fjQ1Ws6bXPd5zbQhoSC8Yu16pY6pBZxej
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966006)(36840700001)(40470700004)(36860700001)(5660300002)(316002)(83380400001)(110136005)(4326008)(8676002)(7416002)(54906003)(36756003)(44832011)(70206006)(8936002)(70586007)(2906002)(40480700001)(26005)(41300700001)(478600001)(86362001)(426003)(2616005)(336012)(82310400005)(186003)(1076003)(6666004)(40460700003)(356005)(921005)(81166007)(82740400003)(47076005)(36900700001)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:48:44.7965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6010912-b4b0-452e-5e44-08da900e843d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5279
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With new CDX bus supported for AMD FPGA devices on ARM
platform, the bus requires registration for the SMMU v3
driver.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d32b02336411..8ec9f2baf12d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 
 #include <linux/amba/bus.h>
+#include <linux/cdx/cdx_bus.h>
 
 #include "arm-smmu-v3.h"
 #include "../../iommu-sva-lib.h"
@@ -3690,16 +3691,27 @@ static int arm_smmu_set_bus_ops(struct iommu_ops *ops)
 		if (err)
 			goto err_reset_pci_ops;
 	}
+#endif
+#ifdef CONFIG_CDX_BUS
+	if (cdx_bus_type.iommu_ops != ops) {
+		err = bus_set_iommu(&cdx_bus_type, ops);
+		if (err)
+			goto err_reset_amba_ops;
+	}
 #endif
 	if (platform_bus_type.iommu_ops != ops) {
 		err = bus_set_iommu(&platform_bus_type, ops);
 		if (err)
-			goto err_reset_amba_ops;
+			goto err_reset_cdx_ops;
 	}
 
 	return 0;
 
-err_reset_amba_ops:
+err_reset_cdx_ops:
+#ifdef CONFIG_CDX_BUS
+	bus_set_iommu(&cdx_bus_type, NULL);
+#endif
+err_reset_amba_ops: __maybe_unused;
 #ifdef CONFIG_ARM_AMBA
 	bus_set_iommu(&amba_bustype, NULL);
 #endif
-- 
2.25.1


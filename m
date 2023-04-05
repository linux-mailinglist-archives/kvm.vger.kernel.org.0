Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A86D8582
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjDESCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbjDESCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:02:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340EE72B7;
        Wed,  5 Apr 2023 11:01:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZEZu3kRRvLKZAvppHl9rlc4mYRgdx1YoThcLRVLlztdB9H1HS6NoJol8igy16PYhBGeFGlCiPZHrPDtprxUoXuAjuPqaSOwutPNyq/s0SFxVXI0MZRf+VA5zNJ1ZYhoyishQ9XOkkViEE8pVR+iI1EOVeuQveMa18zzRgG1t2bKdd7LAfi7BmNk8YGYXbXG1DfaMO4iCzuEpr9G0by0wQZrrPkQkDN+Dzp9fF7L+Jlib3FGCelFOK4iPdKvzyVNIGyipmEoEzbjY2+K/8zHHhL2gTbqRV4zG6rCtgkYXB7rWN7UVfRjm07qGzWWTHRXBJJ4jr9Q1eaNF38gdO4tuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtaL/n8C6+3A7ETFFxQQ906gOFVAx/zW99+G1mQbAcE=;
 b=bJtA0zIYz/GDw+dRvQs3YcqPlJwiaH6ZMjTyuPrEVWeqiDxkW3ymxI0cClv11lLzxg4LEGzxU3DSqFNGRA86oQ+4R6Lr32QIubKZF99VSY/vH5Fhl39jPT3Xkbbl/4IW8Z4Kgl2E2kMJQ/xQvtUbX3l0DWhnCAT6yP+aJ/SpD5P39v+hIWxd9s0o2HXxzHZXsRc32YQFJ3zuZsLNAviQC2c/XGK5NMcMMmH4C5tcGQp5SH9QzpsXTolUUeDavew4ZpJnRIiF+4G5eLZ3mra+UhfR+SD+Hhdl8jnY8Fhn6VWnCqGWDpYdJsbcBOOnd2ZntLHFYmPh1yAx+0X4jc7C8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtaL/n8C6+3A7ETFFxQQ906gOFVAx/zW99+G1mQbAcE=;
 b=QyaJu+mRzARAiiVLlhivxtdm0wWLTASPlKuNoHtnbEobDBdfM2LtDfrBEyES/U+F0sPurXqtWcFlHyvO00xYsF0YjlYBJLxtMVxi3+2eKr8G9TcHjluJxbFybtFuT1P2G/D7GEHG+VsyGX3q3KphFQhSmp658gbKqpEg6uHnyMJp8sxQ6492+05cm4i/vp/Sj2uep05awNVTjX4XZ5kKK7QiBiDuP20Mg/AxDxGGqxjGESpbQ9oAnQLea+yTUXb3qf4Uq6v718oa/gRxP1Dz1qonnEcuv15ZpO98IzP39UqUmVMKiihMcgfPpv60/hixTetIJwlbKt3KzD1XX5/fJA==
Received: from MW4PR04CA0265.namprd04.prod.outlook.com (2603:10b6:303:88::30)
 by MN0PR12MB6077.namprd12.prod.outlook.com (2603:10b6:208:3cb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 18:01:51 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::bd) by MW4PR04CA0265.outlook.office365.com
 (2603:10b6:303:88::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Wed, 5 Apr 2023 18:01:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30 via Frontend Transport; Wed, 5 Apr 2023 18:01:50 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 11:01:36 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 5 Apr 2023 11:01:36 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 5 Apr 2023 11:01:36 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <naoya.horiguchi@nec.com>,
        <maz@kernel.org>, <oliver.upton@linux.dev>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: [PATCH v3 5/6] mm: Change ghes code to allow poison of non-struct PFN
Date:   Wed, 5 Apr 2023 11:01:33 -0700
Message-ID: <20230405180134.16932-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230405180134.16932-1-ankita@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT045:EE_|MN0PR12MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d9c77d8-476c-4dc5-216d-08db35ffd506
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aowpSczYvGkbf0GmtDx0TVteJl6Z3VkolupEIVVvbH9BsXlNO84HYLdRWY4TIUbPhoeFtu70v75Z44NH7DVzfD5K/lAoF4qBAKlioEM6+HTskN4pdYZv+lMBRiY3jEmTwV42OsFMIYD0zKMLpXJdLQs0S2u91rgbp0lvieCBxVMAOmK6A0gm/YYZ0Qqz9eDZQ2tASV+IqqH3CaGBYoRjn66tmI48cLBF5DluzKhTK7RhwRwxvVz3Yf9s0e656EYw9hy7AZLO40e1ibb90lyRvOsbiCAYXFJgv8Cxj2tsiGtmS4GJDo1oTXtXRZIIH+qpjtZV151mvnWNFDz4yZiv5JQXwDC0O6FVggfKGbhKzVUehb09XbOP7t1CueTKRPG7d0EsjZiBLzROaUk9JnJaIYWKgBOPSBqPSEM4cfVsXZ4ZJJLLHwaB0sjuGf6ri66JDwtUbSxs7vwgiJKRHdfFt5buG9pppE70cJunJ/qKKIPmopEMWRbuESi/Yswpivpl9Bx1NuCfZz1RHILnOSRQCppm3YHDJ0Ub3Gmff916Jz2QMph9ys76h+FvoFvWbnPnXctEucrIOfD75yBSG8mEZawLTbeh1SmgdcuI37ySYdLZVqztNpXqCAArWlTfmni3ZBFOiDgJuO4Vnujl1WaCuGDR9sQcjkmSUNnhlo5xE3yQGLSjNDoW5RLSuF6ao6AhkIIZ87auOtcTAqebEtmEaBIqmWK0USoJiSYWk+WeOpqOIryiPaa7r20BGriQGHLc
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199021)(46966006)(36840700001)(40470700004)(82740400003)(2876002)(2906002)(7636003)(356005)(5660300002)(36860700001)(70206006)(70586007)(40460700003)(8936002)(41300700001)(8676002)(1076003)(54906003)(316002)(83380400001)(4326008)(47076005)(2616005)(26005)(82310400005)(336012)(110136005)(426003)(186003)(478600001)(6666004)(40480700001)(36756003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 18:01:50.9001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9c77d8-476c-4dc5-216d-08db35ffd506
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6077
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

The GHES code allows calling of memory_failure() on the PFNs that pass the
pfn_valid() check. This contract is broken for the remapped PFNs which
fails the check and ghes_do_memory_failure() returns without triggering
memory_failure().

Update code to allow memory_failure() call on PFNs failing pfn_valid().

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/acpi/apei/ghes.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 34ad071a64e9..2ab7fec8127d 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -459,20 +459,10 @@ static void ghes_kick_task_work(struct callback_head *head)
 
 static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 {
-	unsigned long pfn;
-
 	if (!IS_ENABLED(CONFIG_ACPI_APEI_MEMORY_FAILURE))
 		return false;
 
-	pfn = PHYS_PFN(physical_addr);
-	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
-		pr_warn_ratelimited(FW_WARN GHES_PFX
-		"Invalid address in generic error data: %#llx\n",
-		physical_addr);
-		return false;
-	}
-
-	memory_failure_queue(pfn, flags);
+	memory_failure_queue(PHYS_PFN(physical_addr), flags);
 	return true;
 }
 
-- 
2.17.1


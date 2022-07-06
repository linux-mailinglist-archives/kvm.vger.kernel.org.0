Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D3A567C25
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 04:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiGFCye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 22:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGFCya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 22:54:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50576404;
        Tue,  5 Jul 2022 19:54:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dd4lJnS00olzQ9Z6n/ONdPEzyUjCSTk1UXuy/W/oElfJmApQpIx3ocWwGvhUdDJSG7xp3ED9spUv2bxEEvdjIHWXuCOos6q8PSOowHCMLsNFMd8TZ0SxF6BhJJTgZxIR8dMQNgLnxYWnQWXLmmNF4P8V1O3tZ036dW6IitQiwcdWqwS3lliyDK1uG8jKmvwnBaACCPOfMimx7LDuZ5QkNWmU2ALJJ8n5rUp43wKUI7mHarAtDz6pIuLAqej16GJQ04RtfJvUZ4KPbp1L10wlfi8JDCVhdfUOQfNyzQDffAOU4VgVr/XTJ+2Y0vPUj/e28tg5JO7okyRCJgwj2WniFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LiCxyqcoKggNvq6s7KbFSHN7ZpGIh0DXtSvh1beMmXw=;
 b=V4PZJVdjG3QCLab4CG2Z0QieOoKrUVEeqeWYl1iBEZuUeoDAl80rqAfGW2a1I9kjYbPGOMvtrskp5FMaSL0B9UHi+fkPsoO75IJ7KqSXOTyQBLimwxt/JCpS+3OORQTRmg3eAQTAa7A2F6uGI35zYVDoRgqP2jXh4TAFjZycQ5OatlteokGGZIvyi/AB0KY7ps9cM7L+kWPrTbAPKffd0ZdUZ5pM66MYaePgWaAE6RfnBjbJMOcdBCUCkEeQ5luYbE0/AExa/ZAduXaEpeY2o7e6LagCR9z3wrxSxUnT42fKOzPHrJ3r0eBgMAKSqfXJQZPBIT+0PvFXql1I3qn0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiCxyqcoKggNvq6s7KbFSHN7ZpGIh0DXtSvh1beMmXw=;
 b=c/pzCk7H7ftVFDEYNTTRbMRp8dGV8VFzO3X/eq0RwO3Hj+rnCySglADy1O5wta75d/gC4taN9yYgLGQ80t3DLyhDFiRln2Ypeg+L8C0Kld6WaD/4iAB4Jqdo0tXSjqCu5Fxc4KCub/6BRoKlcWdVfuvgRJeriIJdfpPwLfuwvxw=
Received: from MW4PR04CA0335.namprd04.prod.outlook.com (2603:10b6:303:8a::10)
 by CY4PR12MB1670.namprd12.prod.outlook.com (2603:10b6:910:4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Wed, 6 Jul
 2022 02:54:26 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::e6) by MW4PR04CA0335.outlook.office365.com
 (2603:10b6:303:8a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Wed, 6 Jul 2022 02:54:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5395.14 via Frontend Transport; Wed, 6 Jul 2022 02:54:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 5 Jul
 2022 21:54:24 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <x86@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        NOMURA JUNICHI <junichi.nomura@nec.com>, <kvm@vger.kernel.org>
Subject: [PATCH] x86/compressed/64: Add identity mappings for setup_data entries
Date:   Tue, 5 Jul 2022 21:53:15 -0500
Message-ID: <20220706025315.657144-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22b0a745-1a1e-4037-f677-08da5efad6bd
X-MS-TrafficTypeDiagnostic: CY4PR12MB1670:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2Ggq6JfxiN7qI55tb1yimLVo9ZXSC1LbxgUfLphOEN8vZpTukO7G7cHgqxjn3x3Xp14zjYLu0AZKOyM7gQqw9KpZTAloRpohQTBJHkGY+lW8jMyrJ18Tdi//2lCu8iK8Y+g9xomJ+QAVWQtYytdsHk6SLFNIMykfHgwAPAeLNWYUM13UGyfJB4ZtAFsnszwI1CYXFsccZ108lRZzwaxnw/tNgPkKLNA+2Cc9zjOWg+d6oJj1VpEFO/uptAM2FfeYIDcfYb6EbhECuZIrWv/mj87p+xBxs7lxPkiNy5eCCwsv5efanYSTuehMTvBIWn6lFANXkusTJafyQNQgc+G6HPAMd0rtPnH7yxHyvEnwlzH82u8LtoKl+IwfHJ7cxAh0UHwuahNQZSERKxsmuQaLaA5hiUIdGi5kc5MA0QgITgwOYn3o9RHlsGBPcVQ9dzHCQ8tSNNwUrWUcLo3mn6SLcJpqp7OUKbSG4n2pguRecPzfudiohdvwxytc7eFRRE9VBqaK/8sFdTQeKy3Dxb70dqKzp54FacdDrWNf5WbTeTy5UGMNL4fey7CbYtC2zkd7Kq5OZqSkRaO4whz3FhZ//+3pdeE8iOUBt1rbuLCZOpveOiOAjgslCqcNwUwKRtYI/CpH0v+0JtQjH2man9u8w1Hp2O29q1HVpow/FZVFyEDuRYWqJpIwvdZ/ErqzbAY24dmPnwYUVFUxAq3EZznyuEOTpkFHVrrD/TEotMCD2DALmAniSYcPIGTvCIV/lk6FEdcPuJRGNX382mjvG370OgEppSLMCSRpPSu3vTKBr9Fh/0TXoXc/VLv5dnlNqf3ocvD0taag6w71G0DdJRQ0hfRhMzvxmEFjhSVtQyTQ62qqSe2aX7bsFvrLdVFjT1R
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(396003)(376002)(40470700004)(36840700001)(46966006)(34020700004)(36860700001)(5660300002)(70206006)(4326008)(8676002)(54906003)(40460700003)(70586007)(82310400005)(316002)(86362001)(6916009)(82740400003)(81166007)(26005)(1076003)(2906002)(2616005)(36756003)(41300700001)(6666004)(356005)(478600001)(8936002)(186003)(44832011)(426003)(47076005)(83380400001)(336012)(16526019)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 02:54:26.0361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b0a745-1a1e-4037-f677-08da5efad6bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1670
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The decompressed kernel initially relies on the identity map set up by
the boot/compressed kernel for accessing things like boot_params. With
the recent introduction of SEV-SNP support, the decompressed kernel
also needs to access the setup_data entries pointed to by
boot_params->hdr.setup_data. This can lead to a crash during early boot
due to these entries not currently being included in the initial
identity map.

Fix this by including mappings for the setup_data entries in the
initial identity map.

Fixes:  b190a043c49a ("x86/sev: Add SEV-SNP feature detection/setup")
Reported-by: Jun'ichi Nomura <junichi.nomura@nec.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/boot/compressed/ident_map_64.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index 44c350d627c7..e2249ec93229 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -110,6 +110,7 @@ void kernel_add_identity_map(unsigned long start, unsigned long end)
 void initialize_identity_maps(void *rmode)
 {
 	unsigned long cmdline;
+	struct setup_data *sd;
 
 	/* Exclude the encryption mask from __PHYSICAL_MASK */
 	physical_mask &= ~sme_me_mask;
@@ -163,6 +164,17 @@ void initialize_identity_maps(void *rmode)
 	cmdline = get_cmd_line_ptr();
 	kernel_add_identity_map(cmdline, cmdline + COMMAND_LINE_SIZE);
 
+	/*
+	 * Also map the setup_data entries passed via boot_params in case they
+	 * need to be accessed by uncompressed kernel via the identity mapping.
+	 */
+	sd = (struct setup_data *)boot_params->hdr.setup_data;
+	while (sd) {
+		kernel_add_identity_map((unsigned long)sd,
+					(unsigned long)sd + sizeof(*sd) + sd->len);
+		sd = (struct setup_data *)sd->next;
+	}
+
 	sev_prep_identity_maps(top_level_pgt);
 
 	/* Load the new page-table. */
-- 
2.25.1


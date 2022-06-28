Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B6C55D2EE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344157AbiF1Lkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344211AbiF1Lkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:40:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0D12EA03
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:40:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sj2Y2tvjTnxXBBMBEUwOqdsyP7Oym8auDX1hY7w+2mzkPGeclhAWqFPTcfWp6f/tRVFgyDvviRcNkcQkBI4CGzsERwbN1DYYHDrudOgo3xZSDH+khwWbSFS/Zhk3envq2dSybskaolRnMc1GkdERYP9DIm5XA0j4zqgXba7HD4mpmK7bh0Y5cmpO+VO/tfANWwHJLQpYXWUzfkIXuhGhQUco1PxRMVoCw0/HtyGSSWGvpT9hkcw+Hm2MUhaWD0ahMhzI727bDkqyp0fY5eiGO3U1v9qxcubr3Ikuwii4ktT44EJ8rj2UFWa9BRWTm13Ir5i2EsOFwG6K09o6x4/m4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpR5qEqNt974fyvG+mtHVbviGjtblSu4c/S2iw5QnY0=;
 b=KFDpPiwbmTfFqN2d5SnmToMb2EuLoTaceacW0DWMPfe4jZYaQS82WrHLuoajMubTi5lulD6z3OEqPqmn4jX0xSZB71pU6Z3vj8SvtMWaLEFwIKzkCjQ71fs444BEQwOx5fPtC3+7hH/uDnYOgzUZH3js+1MLzlitJyNYWJJD5qUfrBapBQqytm2J3ka9meWz+NmoGplgPcmT1MxRHuhxOQ2ImxEGGPOydI8GnT/J7ZVCAbgjuorHvBD+iv06uzvaQZwAOth2dr7rynWQt16p+LFr/0ap69MIv0hQngWYvlqXkB/LPvcbp8LqRbQpC6wZG1VwiSYEU0QLiXyAs4Dq9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpR5qEqNt974fyvG+mtHVbviGjtblSu4c/S2iw5QnY0=;
 b=qCwr7vjNbHICgC2wFhYnBDqhgLmuBsnCekMShscz8fBYQfaktCpgTS3cujlmCAqE+L6KLjYobgmbCf2hGTgjM1CCAFnN7smDzAiA/Hd72vDNKaxsYGa5Vbe7alEFXIciDINxcExQzdUfhOHYp668oW2fHF3pgt2k450aoaQcpKU=
Received: from BN0PR04CA0024.namprd04.prod.outlook.com (2603:10b6:408:ee::29)
 by BN8PR12MB3299.namprd12.prod.outlook.com (2603:10b6:408:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Tue, 28 Jun
 2022 11:40:46 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::4a) by BN0PR04CA0024.outlook.office365.com
 (2603:10b6:408:ee::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Tue, 28 Jun 2022 11:40:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 11:40:46 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 06:40:44 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v5 4/8] x86: Improve set_mmu_range() to implement npt
Date:   Tue, 28 Jun 2022 11:38:49 +0000
Message-ID: <20220628113853.392569-5-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628113853.392569-1-manali.shukla@amd.com>
References: <20220628113853.392569-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b402b92-bbfc-4b25-0fc0-08da58fb0ac2
X-MS-TrafficTypeDiagnostic: BN8PR12MB3299:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oHuSIyAJS4tJIwc0Y13X8wI30mmG+tCYE8dTxKB+P/kzrLiaE0tZmE5NJmrC7bWmx7vhdXRcMEaj2hbiAOJpUCJKSoyR8vh9FtpiXDGs2AF4jLI3lxxkRP2XOyFG0wIyyew2SJU2PKUY1EM+66sQR4+lLzppCVjelw3mwZhOihvmUV4+VEGNfBKVHGEKYMk5UIagg3sOcfA9VfHOlJijHrylsta2lCE5nyc5vlxH40EcAUfE2JxPT042oNzfdfpq6uYX5rhqROX6nD6PT3TbIvgo5Xp0iiTNMMw2G8e5ab2pYw++bLQx6fQ3A/xOwXBjdGRTdWUbh/MJn7NCxcOcel7p+hfjx2lArgjarwUJrAxE7J7j+m+XcSjtDneSbM/nVvTCYdlz8Jm5IyA/zyblCImn3+2BdtPntOhrPzkHqcWN+ULEmrZJX9VhzZhkgGogAreEBK8PVzaEFsVDlVxHIsIEgrQhFDmcXf9tkJp2AV/oPt/wmJlWCYVojgOPPAUnH2C2dJ62DxgY8TxamTPyB1ycyhHIpN36/4QQQqB7Nt0dXoQmPFhRo3KExsx8GGCffFo9mnTyWCKI/JUd4SamnQjzQjC+SmnAFJN7kHSOOcheShGvWBcWy3KOpwXPu2ycAill5j2YnzPY+SpDN0RzYoHJFPgZIWcADErZZepz9/xXZMt8XdZyWNSRJql4lvcZ/Rv1/l5062/VmLYB8GmFffOIybv7T/oK894lhz9gb78LGNaPmd4CrWAeOCA+rP8kv2Kw190zDF013Ty0CfplbxbiDJBQhVYh1+rd0TfoKV9zN1DDHeSf5Qjac85wYpjNiDjJPsUEZzD6OYxyrYFJPw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(136003)(39860400002)(46966006)(40470700004)(36840700001)(426003)(47076005)(336012)(83380400001)(36860700001)(1076003)(82740400003)(186003)(2616005)(26005)(7696005)(2906002)(41300700001)(86362001)(316002)(40460700003)(81166007)(82310400005)(44832011)(70206006)(70586007)(5660300002)(110136005)(40480700001)(8936002)(356005)(36756003)(16526019)(8676002)(4326008)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:40:46.6247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b402b92-bbfc-4b25-0fc0-08da58fb0ac2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3299
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify setup_mmu_range() to implement nested page table dynamically by setting
PT_USER_MASK bit for all NPT pages because any nested page table accesses
performed by the MMU are treated as user accesses.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 lib/x86/vm.c | 25 +++++++++++++++++++++----
 lib/x86/vm.h |  8 ++++++++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 25a4f5f..46c36e5 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -140,16 +140,33 @@ bool any_present_pages(pgd_t *cr3, void *virt, size_t len)
 	return false;
 }
 
-static void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len)
+void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len,
+		       unsigned long long mmu_flags)
 {
+	u64 orig_opt_mask = pte_opt_mask;
 	u64 max = (u64)len + (u64)start;
 	u64 phys = start;
 
-	while (phys + LARGE_PAGE_SIZE <= max) {
-		install_large_page(cr3, phys, (void *)(ulong)phys);
-		phys += LARGE_PAGE_SIZE;
+	/*
+	 * Allocate 4k pages only for nested page table, PT_USER_MASK needs to
+	 * be enabled only for nested pages.
+	 */
+	if (mmu_flags & IS_NESTED_MMU)
+		pte_opt_mask |= PT_USER_MASK;
+
+	if (mmu_flags & USE_HUGEPAGES) {
+		while (phys + LARGE_PAGE_SIZE <= max) {
+			install_large_page(cr3, phys, (void *)(ulong)phys);
+			phys += LARGE_PAGE_SIZE;
+		}
 	}
 	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
+
+	pte_opt_mask = orig_opt_mask;
+}
+
+static inline void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len) {
+	__setup_mmu_range(cr3, start, len, USE_HUGEPAGES);
 }
 
 static void set_additional_vcpu_vmregs(struct vm_vcpu_info *info)
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index 4c6dff9..2df19e3 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -4,6 +4,10 @@
 #include "processor.h"
 #include "asm/page.h"
 #include "asm/io.h"
+#include "asm/bitops.h"
+
+#define IS_NESTED_MMU BIT(0)
+#define USE_HUGEPAGES BIT(1)
 
 void setup_5level_page_table(void);
 
@@ -37,6 +41,10 @@ pteval_t *install_pte(pgd_t *cr3,
 pteval_t *install_large_page(pgd_t *cr3, phys_addr_t phys, void *virt);
 void install_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt);
 bool any_present_pages(pgd_t *cr3, void *virt, size_t len);
+void set_pte_opt_mask(void);
+void reset_pte_opt_mask(void);
+void __setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len,
+		       unsigned long long mmu_flags);
 
 static inline void *current_page_table(void)
 {
-- 
2.30.2


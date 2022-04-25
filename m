Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7172150DF46
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 13:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiDYLtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 07:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241728AbiDYLtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 07:49:11 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6568517062
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 04:46:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WX3cNf09pO3tuHc1RyPRhNGIbE3fh1r46WNncmRc72q61rznoOlq8j03pbpWualkwQxdIwjLiyYsPL/6Er2LZDyyYMGYm4NUE1ZN5ROf9NvGlvD7oAvKatNcPnYL4/U68zy3jXSYCKv2GW4ljKh6AYAtsG+IriEG2nLvv5VPZaiaGpox16WgB/eh3pMzLEAMhbouUCQEiTVhWktFTTlY1I2ZmswJFtnT/jkHQI4RgTc26Qu+xhu+NBqUUodCSXp971TeIlrjaBJmTt6wMestE8EkuaYoDdezNORXz29UmPp/5aDwLQQ6m5OV7TCa+X+BAP/bZvn2DvroTu3SFUbtAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHm2+E/PyY0Oitkb4o0PC3K0HvTeqO0g2uKc0ioKecA=;
 b=GEEt8HmAjzVxTMIyXfcTrJt+CnRNxiKexpsKH6NaofvBtm8o6slqkiCUno9DGZcotAyNvAPAcvawxLoAMI6euRsp2Y13Tosmi+078dsith3P7ZStmkGSKrKNVpYtV8beUNDE+RUIsRWCq6n3zb1Oi9PSiAF1nbZ2Jpd2Si4mQ2nFuwv8exfsECzOk6nZ4p0apRU1TfYV5Q44LpCYEZHF4R+y8lPmKHVPwNSLGGR+nI9yRQOkseLz6geMnobQXma2ScRuSXuYF0pBEhWSe9UcR5cly6o+wK4VSwFdF79RmV09guyzstuWGTRFIGiVUHMmUlg1hT1i5LVtuOpVpQWHnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHm2+E/PyY0Oitkb4o0PC3K0HvTeqO0g2uKc0ioKecA=;
 b=E9mBRsk0M4fv9dz7af6G0pL4Dp8XW2ks/ODR+cxLiVKeTc83GY3LbBt7CgKcdz0LA1mXIQDJbCfxMNammQB5v9+c3/UB9cHs5UPKD4eaxZue8bb+j184j+VXvR3mS+DaNXPkTZZu+oB6HRbcc6G1Xr367HfML9UGUdn7AKjmXMo=
Received: from BN9PR03CA0747.namprd03.prod.outlook.com (2603:10b6:408:110::32)
 by CY5PR12MB6057.namprd12.prod.outlook.com (2603:10b6:930:2e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 11:46:02 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::81) by BN9PR03CA0747.outlook.office365.com
 (2603:10b6:408:110::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Mon, 25 Apr 2022 11:46:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 11:46:02 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 06:46:00 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests RESEND PATCH v3 4/8] x86: Improve set_mmu_range() to implement npt
Date:   Mon, 25 Apr 2022 11:44:13 +0000
Message-ID: <20220425114417.151540-5-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425114417.151540-1-manali.shukla@amd.com>
References: <20220425114417.151540-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f89ea96-a555-4018-1439-08da26b12c72
X-MS-TrafficTypeDiagnostic: CY5PR12MB6057:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB605759FA3B8B88479C84EAA5FDF89@CY5PR12MB6057.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DNIVZP/lBB98zs1jl62CB12v4IJHewg+zZZWuRupciCR/TrPp30xpcMIWwyPp5iMbQili9cCeHI0IbAFqJq92nn3BCE70/EvlQi+xxsEIc+2hhh920fuZ6ST6ERLn9sRSUZ7juGslzdZHD7LTGtY7bO6XJKgH2Jw4tuPIcD9mPS3BofGOLL+VQD5dimTEb31oQTKX9r6nVp6NMht9AHH9jsB2XJZUdQCSzX1l4fds50Nk+PlgA+cRUsJ5Zdaj/gA/q+3QQ9ktSE06Bob+sa99bKe1kmnGcAh9RiE3V/JbKnrdHoh9v13Kh3VXJWwLkMrjLKWmiWYIjFITJpTfhFJOWG9L7R+35/IoyQBJOfsrZi97my+EhgTElmdbO1aXXjzfuthGtszQY8cofUk1EYphsmGuXY6nVr6tX7ocGlzADgdhryGt3jj8tHm6UXSVn25/ITD6xl1VHA8npbh7udxmXh+yPZP9DtHRMN+PmKszq3Togyl9sSTIz46rRUTuBO+CmGTkjoi9+VgSS9SzlakOS0WjEUiP5ATi84Ca3yusLds9u9iEuaSjqgG3v6Yf+8u7TQ5q0CHtJtPJQ1lSHlQc76ItKZVKwTah3vcY6m5aiII6v9z1z6d19LsRa973FjmKLg0mzdUH2k3/QOeibXL7JHZQ1k+eHPgR4zHCTZGSmh5nMApr4hH2jTnR3uxspyaA6RwQL3dCQyzeUpwo1M6QA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(1076003)(70586007)(186003)(16526019)(336012)(426003)(47076005)(36756003)(2616005)(4326008)(8676002)(36860700001)(70206006)(44832011)(5660300002)(8936002)(82310400005)(26005)(40460700003)(81166007)(86362001)(316002)(83380400001)(110136005)(508600001)(7696005)(6666004)(2906002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 11:46:02.2305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f89ea96-a555-4018-1439-08da26b12c72
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6057
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If U/S bit is "0" for all page table entries, all these pages are
considered as supervisor pages. By default, pte_opt_mask is set to "0"
for all npt test cases, which sets U/S bit in all PTEs to "0".

Any nested page table accesses performed by the MMU are treated as user
acesses. So while implementing a nested page table dynamically, PT_USER_MASK
needs to be enabled for all npt entries.

set_mmu_range() function is improved based on above analysis.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 lib/x86/vm.c | 37 +++++++++++++++++++++++++++----------
 lib/x86/vm.h |  3 +++
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 25a4f5f..b555d5b 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -4,7 +4,7 @@
 #include "alloc_page.h"
 #include "smp.h"
 
-static pteval_t pte_opt_mask;
+static pteval_t pte_opt_mask, prev_pte_opt_mask;
 
 pteval_t *install_pte(pgd_t *cr3,
 		      int pte_level,
@@ -140,16 +140,33 @@ bool any_present_pages(pgd_t *cr3, void *virt, size_t len)
 	return false;
 }
 
-static void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len)
+void set_pte_opt_mask()
+{
+        prev_pte_opt_mask = pte_opt_mask;
+        pte_opt_mask = PT_USER_MASK;
+}
+
+void reset_pte_opt_mask()
+{
+        pte_opt_mask = prev_pte_opt_mask;
+}
+
+void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool nested_mmu)
 {
 	u64 max = (u64)len + (u64)start;
 	u64 phys = start;
 
-	while (phys + LARGE_PAGE_SIZE <= max) {
-		install_large_page(cr3, phys, (void *)(ulong)phys);
-		phys += LARGE_PAGE_SIZE;
-	}
-	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
+        if (nested_mmu == false) {
+                while (phys + LARGE_PAGE_SIZE <= max) {
+                        install_large_page(cr3, phys, (void *)(ulong)phys);
+		        phys += LARGE_PAGE_SIZE;
+	        }
+	        install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
+        } else {
+                set_pte_opt_mask();
+                install_pages(cr3, phys, len, (void *)(ulong)phys);
+                reset_pte_opt_mask();
+        }
 }
 
 static void set_additional_vcpu_vmregs(struct vm_vcpu_info *info)
@@ -176,10 +193,10 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
     if (end_of_memory < (1ul << 32))
         end_of_memory = (1ul << 32);  /* map mmio 1:1 */
 
-    setup_mmu_range(cr3, 0, end_of_memory);
+    setup_mmu_range(cr3, 0, end_of_memory, false);
 #else
-    setup_mmu_range(cr3, 0, (2ul << 30));
-    setup_mmu_range(cr3, 3ul << 30, (1ul << 30));
+    setup_mmu_range(cr3, 0, (2ul << 30), false);
+    setup_mmu_range(cr3, 3ul << 30, (1ul << 30), false);
     init_alloc_vpage((void*)(3ul << 30));
 #endif
 
diff --git a/lib/x86/vm.h b/lib/x86/vm.h
index 4c6dff9..fbb657f 100644
--- a/lib/x86/vm.h
+++ b/lib/x86/vm.h
@@ -37,6 +37,9 @@ pteval_t *install_pte(pgd_t *cr3,
 pteval_t *install_large_page(pgd_t *cr3, phys_addr_t phys, void *virt);
 void install_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt);
 bool any_present_pages(pgd_t *cr3, void *virt, size_t len);
+void set_pte_opt_mask(void);
+void reset_pte_opt_mask(void);
+void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool nested_mmu);
 
 static inline void *current_page_table(void)
 {
-- 
2.30.2


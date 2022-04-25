Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA77150D6C4
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 04:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240305AbiDYCDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 22:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiDYCCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 22:02:47 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8AD5EDEC
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 18:59:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwSz4bMJtRsIZ0pSq39ArrX6Df2wNvvTLtx/sZHXY636eCBhYMFNbhrwCJHG0qDwANWycWDwOroASrIBDnzlyIE8JFe1+PsOrmoRqgDcrLubDvhxrj95V7fOUc3DuDqd3k0z+YeaE2oSbd6BHHCq2VwuxvS2RyNUG3hwWTzfOIF91TKcCIR3ju72IWDWhdyg+8WgMQm+8Ad45W9UItrDFANwRnOiNga7lt6Ai36DqK7Sogi6WBSfAvQ6BAO3UJlOn/uM0R49SD9wMzYnUqSBy0OQa3BQQm3bYEj941Y248fxMc5v5E1P+0PRXgistXxi8fa3SdXjwEJdOqgTJ0L8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHm2+E/PyY0Oitkb4o0PC3K0HvTeqO0g2uKc0ioKecA=;
 b=IIXSNS1jS7fy4viDOBv6zIDRi1K7iHI9qED0oiurI86CESVnsCHhQuAZXop4KHqz29RCYa6k8vVm3+zul6Rx5kL7VGkF1vShGbJFDBLxabikxHOyIfoOgPUEnKsY+PNvSoaL/gtmdvsgxox5LRRkm1win3dm0fndKaxOnXQXnivSFWHEthjYiIkpul9vKK+OFE/yyXFoQfZvGxeOp7AyBGcpoyM1b+f/crDOavtP1mQiw0E/IYN0FCp3dO1WGPAHPX0d2FpVmp8w4xA/eIuTjAKfVJMigvcvbWl/jeFTyMlvUczDXtRj8Try92N67Bvpg3bry46XvZHJFPNiTHpxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHm2+E/PyY0Oitkb4o0PC3K0HvTeqO0g2uKc0ioKecA=;
 b=HSGS0ciZ3/xOXgz1zLXE1Iz/y4UOsUTyidq5QkEwaucZ7Von4AClC246vBx5tT7s2YG1bmkdVxBWJUSjc8lvZLB90bW8mgp3dP1ZUiRVIVwiA/1fFoz+VEZRFzsnk47fpyvdAp7p+AATNdXRu1WCsMkA3pSjdmS020rGKLX5ykc=
Received: from BN7PR02CA0030.namprd02.prod.outlook.com (2603:10b6:408:20::43)
 by MN2PR12MB3119.namprd12.prod.outlook.com (2603:10b6:208:ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 01:59:43 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::9e) by BN7PR02CA0030.outlook.office365.com
 (2603:10b6:408:20::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Mon, 25 Apr 2022 01:59:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 01:59:43 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 20:59:41 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v3 4/6] x86: Improve set_mmu_range() to implement npt
Date:   Mon, 25 Apr 2022 01:58:04 +0000
Message-ID: <20220425015806.105063-5-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425015806.105063-1-manali.shukla@amd.com>
References: <20220425015806.105063-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19cbb974-8b41-4ac1-0104-08da265f440b
X-MS-TrafficTypeDiagnostic: MN2PR12MB3119:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB311900935170C75477D012EAFDF89@MN2PR12MB3119.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdvjzs03TrBIXuGOB+p/cHBRVwNv8/Y24LmpdnPg8RujEEYjTtmEQpslccWxV5M2QH/vrsJ45gdP4BCX/i0AaMCjBxm+e2FOHeWh7Uhib/IU7lyoA284IPUKfgzKlzAZeTh3JKPLQ6h227aq8htdDofUb4QyGRr9ZVqxt4fM+qRP9YWGH8C163Qj93gYNJc+lKvg7DDHdbIXsptUPuVftPPcQsPvO1ELStu3mEqK+Oq1qIa+xAkRk/4qmBK5KouLJOPabLITGpaebVGCz9a21onZBO7J8PYC5HS1GiQNI1yx+NHVQVpW1PVW5UCUpMn5W+qXbtY3DzkHkcHLbs1LNHyGtsdo/f1cK+r1XOzbq7ydAUmWhsMSC7MoCGz7oopQsTpsE5ZwgtyewzwXfzb38NYnSXHHEc/vp45lMvLJply2GSEgh2kOBDC7VQL2oN+wbUzr6fDGa1xDOJTrkuWnf2bCFQI4U3AvpvY7dbCMQQN6oPM4ik5dW+nWYYOOG3OZgIu6w2e0LPkIbzPjBD49hGPRgTDoabzjZ93IDGR7AxKkbR0Me1vmmaUNth8H/vxmot5ctXbSihth8zUAKO+TGVq96gM59gZLoeosROtP2yUQvGLaVAQjo1vJqditVvEcGRE9zXTrZ1y0JPH1yGDKv3Mrq4CLm2/TIR4BrjHiMnwdRpY60A7TGrmwaPHaD9VV8BSUEGg6q5n4SvvMXi5ivg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(356005)(40460700003)(6666004)(7696005)(316002)(1076003)(8936002)(186003)(86362001)(426003)(336012)(47076005)(16526019)(81166007)(5660300002)(83380400001)(44832011)(2906002)(508600001)(110136005)(8676002)(82310400005)(36860700001)(4326008)(36756003)(26005)(70586007)(2616005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 01:59:43.1041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19cbb974-8b41-4ac1-0104-08da265f440b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3119
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


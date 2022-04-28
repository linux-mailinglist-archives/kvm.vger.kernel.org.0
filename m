Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439ED512C6A
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244898AbiD1HOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244886AbiD1HOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:14:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A643B84A1D
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:11:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt2T18Gp/LyLyLB0UleE9eDJlvs4WsflgXYdBIM0QYgnGAgWyRvVNItpHvsBAiyzUjRachsSjCZqOeMkloPT2YiyzLV58l17tVwr7g3lQMF3N5iqWpAwFDXTTx1X6BSIgIgDjlBpPuK5kdDb6xbjpjp3m/o+l/fEFwjOeBcGUTpcJ4ZSEU7MeC/wv+LfAxWvJ6amJfwSOZU4vxenym65A6DY4RM51ybvUMm2Kv/Rekn6HS7UeRWk5/FGy5mt+FR/4a0c+GJf5ODxYwgWI0FWhtIhemUBOzc7wSphUtMRs8VmZo0WjTIF6Sul/IDWvvpLps6CZeN9N2S3XmI9Lc/jow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHm2+E/PyY0Oitkb4o0PC3K0HvTeqO0g2uKc0ioKecA=;
 b=juA775lZTr7hnfrEocS2BqRFxSgLYWga11ciHP5+rzjqzH0fvCslmCoOBmX9aCA42wA1d998ctqJuI1bQhog/fdQwk8b0R/uuHXv/aPWX7FuUqZBgT/AxRO4CNfzlZJ+PWTog0Np74TO0bOW3vregg+O+f/raV3ojc2OYSjGtgN3ofrhgrhXK6PHYm7HIJCf0Qw1XqGZ2KtVcx+1fjlhAVtJ0gSajharnJzJqnU7y++nV7FRLGMsN+h5bLLUpuZBJ7K4Cgruuppk840TbwOMkK+Nm0ssovV/Y9inD8WpMXqenWEu2Kg9juCvmL6BqztlNP0EgbI0ifQ/6scqa/47gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHm2+E/PyY0Oitkb4o0PC3K0HvTeqO0g2uKc0ioKecA=;
 b=X9f6nwJsTnNMZ+ETzvE78xYcRQOqKqTrTCcp/tzsoItsHeYhBBOV6xqXo8nLJ0tbLIxPWDa0qlA47zPvZi//ooP0y7whx9AQL5NclDBBpnMy9MoDbRJWuhvbFocEmWN/ngaXtz3cU78EZNtr6Jd46iSXAh0zIzCLCTUXNTikv+U=
Received: from DM6PR03CA0040.namprd03.prod.outlook.com (2603:10b6:5:100::17)
 by DM6PR12MB2873.namprd12.prod.outlook.com (2603:10b6:5:18a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Thu, 28 Apr
 2022 07:11:16 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::7e) by DM6PR03CA0040.outlook.office365.com
 (2603:10b6:5:100::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Thu, 28 Apr 2022 07:11:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 07:11:15 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Apr
 2022 02:11:12 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v4 4/8] x86: Improve set_mmu_range() to implement npt
Date:   Thu, 28 Apr 2022 07:08:47 +0000
Message-ID: <20220428070851.21985-5-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428070851.21985-1-manali.shukla@amd.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b53f636-bad8-4a49-248c-08da28e64923
X-MS-TrafficTypeDiagnostic: DM6PR12MB2873:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB287376118F5FB4562F05F017FDFD9@DM6PR12MB2873.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CmjK9KgyW7o53rY1LVi8A6KFKvUN4tnr87/DiA6JpEHUUaxQGsl287xh/uzeyle0Y/6FlVHc99a2Fdpw4M6nrirzl8ji6EHv8Hdlj/DUhh4OJaxYFU+4oNlCIAwAoL7WDnL+4YlMcLU7oPVgRYVwVwJ//11DO7HEt5dLGwZvA1UTKnlbO4UL2Blbfa1W+vVhrkuN7Iq1VvXHa316jY+tIkyNgPaktK7IAuqYeyMeCweqxim3B3CybofhNUX/HSfkrBtipkBRM+gKb8zr7KW8wZG43LMyp9LpbbH2q14wSDXr+r8QqQa8eRrO+RJCZROEflGlcVw9t3LrPuUZ1YR6xi8k3ySRLwbjLSnp8FMHhsndjPJh0EKLLnW2W+0dKUlBV0fBQjNyy42ht3mMQv6/wwB2G+kLwvm6PBy0XeQxqie0+r1jvmcKzk0yxS67IQqTIDJgn+9jnOOWtzPfQwGLCq3yg+PhPFMTKbfrpP9Q77E7388qLzZXC2aM2eSFoIlnHJr3zrJmZylGpdh+SKpXqrrughbIqyuM1C91NiwghOlIbP45a1pS/5q7UjyaTFvvBMObWPjxHeyw16ovzmJzVxsbr11i57ZNxDFOTQFdT9NNKLfQcFvAeq6M8gG39HpsYJKR/+aVzLnGyQYVBoD6e5mJmvU1L83M3R+nu/VNc3IfDwO5oKyts84CrosCDjkLgukAoyxuhk868t0As23hTQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(81166007)(356005)(110136005)(316002)(2616005)(5660300002)(8936002)(186003)(44832011)(16526019)(36756003)(6666004)(40460700003)(1076003)(426003)(2906002)(47076005)(336012)(26005)(86362001)(7696005)(36860700001)(83380400001)(70586007)(70206006)(4326008)(82310400005)(8676002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:11:15.9881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b53f636-bad8-4a49-248c-08da28e64923
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2873
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


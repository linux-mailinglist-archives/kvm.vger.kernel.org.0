Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5CB50DF4F
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 13:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbiDYLu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 07:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241806AbiDYLth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 07:49:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B58A403CC
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 04:46:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZxCPSYZ/YqpFewdM4VlsXNB4eEHdceO/OBhwIBwNtMBOqQFAz2I0RhSj8l8oqy0rl9xuQcg4SGqU9I2yd/LqNvFqTEM8YNQxcTojryAUfw0qsJ6v32AVQCw96uw4E9GPaupIS/IuD+TlYZaPpNASBx9crtWukN3vKRZK7sve56EUmUM+OEJnmUGG+dP07nKMpIBDTfVOVZ1AIO3fyJT6XTl1kiH/oKCSHtVghbAw0LYdHnmS4yjGTSZqhq/xnjTwR+5ADqrwM7Toek6un4xv8f5TrrU9Dkr4G2q9Be6RhfGN9Ec5Y9CkNFpyj4XQ/7xeBiyHZdtxRIMKRwkGyZSEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKPRMBVh8zRQNedbMqrr6A5GVdeIF1KGsdCCMLQagfU=;
 b=UvcHU+k6SA20jpBA9Nok/rEM0fF82e+33KO9m4DXoeMs8e+lw7DFjuEJ200hD5CpJumpHydKSn70FucrlVkHyL9m1K/ZS2i5q1QRpeDTn4rO0zI3hdSisFSP2B3u89yx9P9KVLxm1l9apuxmRCTBfggS+LxX/FrtfgLKvYSRL2wb1JRgEyZ+YrCOuBAZW9c9HcPbKq+x0++azw4UZKsEjUkb/BmCyOiha/KxPdnN2cq0UF+Zztzj+MvGk8WCLJRws7GLJJ7VfNth0HTVMFcK5CGmNkQO+UmqBZbzm1zGltvNn1A2OhiZaidlfuD94hmR7XAmcmcNw+svKofEuXV64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKPRMBVh8zRQNedbMqrr6A5GVdeIF1KGsdCCMLQagfU=;
 b=qkgGNBXOd/Arys9JK1RrVpyYG8vQ8Mn1zEvtipIcLFkFL+FA4M9g7YulC4bKSNP6amQXGqgkqCk31EYyRzuy1XP41NLdQ+r/6FsRWuB8RwKrIcc5uaE1Tce6tTy6sJiTwTlCnAyXLv7+KFnoZ7BDNpaYooWpFR8+1sN9FiGNDXE=
Received: from BN9PR03CA0605.namprd03.prod.outlook.com (2603:10b6:408:106::10)
 by SJ1PR12MB6172.namprd12.prod.outlook.com (2603:10b6:a03:459::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 25 Apr
 2022 11:46:25 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::8) by BN9PR03CA0605.outlook.office365.com
 (2603:10b6:408:106::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Mon, 25 Apr 2022 11:46:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 11:46:25 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 06:46:23 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests RESEND PATCH v3 5/8] x86: nSVM: Build up the nested page table dynamically
Date:   Mon, 25 Apr 2022 11:44:14 +0000
Message-ID: <20220425114417.151540-6-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2036c155-f024-4ac1-78fa-08da26b13a3e
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6172:EE_
X-Microsoft-Antispam-PRVS: <SJ1PR12MB617250F638B98C060C75BF76FDF89@SJ1PR12MB6172.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5OKO+iH5WkayLYg6M5DoY2CLt2+v3OddfkYn3r/5wZBW5q5vAwqT6usquHGNVwCfhcdyVUapkBh76nUsrHoyyrt8BLu8/mj8xYuIEoQBjXH9iz1KPIyc2IbyrJlNA3PlcR0/j0u8Fm1w0KeneB2QKYdLLldBxPcM7sf8mnbyyadBOG73t/zA0xBQbItbz13GnI224JCJpY2rensaocw3J9US4YTxnyX+LmAs/orsRIJp2q2V+1S3I5GE1UtWZvmU2A8GAUfLYjWu2qpSHrD0MpihTSbsHGyCjm+uaeC3UjdhwngElSrr+cxtJrzhKnzZrXUgA0av1kWI9WERa0SyVWfATUPTiczlRixvA1Hl/Y5MAEHIHIyKm3yiTVndKZpURILX2Kx1Knc3lsXnrO+NKjU6Jzjw02qUgXNpZMMKCoEky5KEYMG0/wY86Z30Vpycs9QTrVPt7QB56T3ZCZ2wrGl1h282TFwZwg55G1S/foumnNm1QR9AlRTnqhm+O4X8WmuSkxKz5MdkicVNkXN3DZlAKsx0p/by+dsDcfBvyr4aO8KOuTANtIZUk8vSpDFqwG31n6udNq0giTwWKfQcsBHwFJYXbt9TQn9ZGuwbZEKyvp3lziQa6rwnDYkol64doASu/Yzs61UhTFii79A98afDamWrvCEXIc7eqclIacWGdz7HWmsCZsvBcti+6h9+tCosmSJtNMjXEFQ/o9LuQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(70206006)(86362001)(2616005)(2906002)(508600001)(6666004)(5660300002)(44832011)(36860700001)(356005)(81166007)(83380400001)(8936002)(7696005)(40460700003)(1076003)(16526019)(47076005)(426003)(186003)(336012)(316002)(70586007)(4326008)(82310400005)(110136005)(8676002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 11:46:25.3961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2036c155-f024-4ac1-78fa-08da26b13a3e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6172
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current implementation of nested page table does the page table build
up statistically with 2048 PTEs and one pml4 entry.
That is why current implementation is not extensible.

New implementation does page table build up dynamically based on the
RAM size of the VM which enables us to have separate memory range to
test various npt test cases.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c     | 75 ++++++++++++++++-----------------------------------
 x86/svm.h     |  4 ++-
 x86/svm_npt.c |  5 ++--
 3 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index ec825c7..e66c801 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -8,6 +8,7 @@
 #include "desc.h"
 #include "msr.h"
 #include "vm.h"
+#include "fwcfg.h"
 #include "smp.h"
 #include "types.h"
 #include "alloc_page.h"
@@ -16,43 +17,32 @@
 #include "vmalloc.h"
 
 /* for the nested page table*/
-u64 *pte[2048];
-u64 *pde[4];
-u64 *pdpe;
 u64 *pml4e;
 
 struct vmcb *vmcb;
 
 u64 *npt_get_pte(u64 address)
 {
-	int i1, i2;
-
-	address >>= 12;
-	i1 = (address >> 9) & 0x7ff;
-	i2 = address & 0x1ff;
-
-	return &pte[i1][i2];
+        return get_pte(npt_get_pml4e(), (void*)address);
 }
 
 u64 *npt_get_pde(u64 address)
 {
-	int i1, i2;
-
-	address >>= 21;
-	i1 = (address >> 9) & 0x3;
-	i2 = address & 0x1ff;
-
-	return &pde[i1][i2];
+    struct pte_search search;
+    search = find_pte_level(npt_get_pml4e(), (void*)address, 2);
+    return search.pte;
 }
 
-u64 *npt_get_pdpe(void)
+u64 *npt_get_pdpe(u64 address)
 {
-	return pdpe;
+    struct pte_search search;
+    search = find_pte_level(npt_get_pml4e(), (void*)address, 3);
+    return search.pte;
 }
 
 u64 *npt_get_pml4e(void)
 {
-	return pml4e;
+    return pml4e;
 }
 
 bool smp_supported(void)
@@ -300,11 +290,21 @@ static void set_additional_vcpu_msr(void *msr_efer)
 	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
 }
 
+void setup_npt(void) {
+    u64 end_of_memory;
+    pml4e = alloc_page();
+
+    end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
+    if (end_of_memory < (1ul << 32))
+        end_of_memory = (1ul << 32);
+
+    setup_mmu_range(pml4e, 0, end_of_memory, true);
+}
+
 static void setup_svm(void)
 {
 	void *hsave = alloc_page();
-	u64 *page, address;
-	int i,j;
+	int i;
 
 	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
 	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
@@ -327,36 +327,7 @@ static void setup_svm(void)
 	* pages to get enough granularity for the NPT unit-tests.
 	*/
 
-	address = 0;
-
-	/* PTE level */
-	for (i = 0; i < 2048; ++i) {
-		page = alloc_page();
-
-		for (j = 0; j < 512; ++j, address += 4096)
-	    		page[j] = address | 0x067ULL;
-
-		pte[i] = page;
-	}
-
-	/* PDE level */
-	for (i = 0; i < 4; ++i) {
-		page = alloc_page();
-
-	for (j = 0; j < 512; ++j)
-	    page[j] = (u64)pte[(i * 512) + j] | 0x027ULL;
-
-		pde[i] = page;
-	}
-
-	/* PDPe level */
-	pdpe   = alloc_page();
-	for (i = 0; i < 4; ++i)
-		pdpe[i] = ((u64)(pde[i])) | 0x27;
-
-	/* PML4e level */
-	pml4e    = alloc_page();
-	pml4e[0] = ((u64)pdpe) | 0x27;
+  setup_npt();
 }
 
 int matched;
diff --git a/x86/svm.h b/x86/svm.h
index 123e64f..85eff3f 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -406,7 +406,7 @@ typedef void (*test_guest_func)(struct svm_test *);
 int run_svm_tests(int ac, char **av);
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
-u64 *npt_get_pdpe(void);
+u64 *npt_get_pdpe(u64 address);
 u64 *npt_get_pml4e(void);
 bool smp_supported(void);
 bool default_supported(void);
@@ -429,6 +429,8 @@ int __svm_vmrun(u64 rip);
 void __svm_bare_vmrun(void);
 int svm_vmrun(void);
 void test_set_guest(test_guest_func func);
+void setup_npt(void);
+u64* get_npt_pte(u64 *pml4, u64 guest_addr, int level);
 
 extern struct vmcb *vmcb;
 extern struct svm_test svm_tests[];
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 53e8a90..ab4dcf4 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -209,7 +209,8 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
 	       "Wanted #NPF on rsvd bits = 0x%lx, got exit = 0x%x", rsvd_bits,
 	       exit_reason);
 
-	if (pxe == npt_get_pdpe() || pxe == npt_get_pml4e()) {
+	if (pxe == npt_get_pdpe((u64) basic_guest_main)
+	    || pxe == npt_get_pml4e()) {
 		/*
 		 * The guest's page tables will blow up on a bad PDPE/PML4E,
 		 * before starting the final walk of the guest page.
@@ -338,7 +339,7 @@ skip_pte_test:
 				get_random_bits(20, 13) | PT_PAGE_SIZE_MASK,
 				host_efer, host_cr4, guest_efer, guest_cr4);
 
-	_svm_npt_rsvd_bits_test(npt_get_pdpe(),
+	_svm_npt_rsvd_bits_test(npt_get_pdpe((u64) basic_guest_main),
 				PT_PAGE_SIZE_MASK |
 				(this_cpu_has(X86_FEATURE_GBPAGES) ?
 				 get_random_bits(29, 13) : 0), host_efer,
-- 
2.30.2


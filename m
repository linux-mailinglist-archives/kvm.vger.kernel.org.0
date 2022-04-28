Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F51F512C6D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244902AbiD1HO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241941AbiD1HO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:14:57 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9428A7C3
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:11:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqOavYTiFAZiW6Pl3NppWJk8l5jonshYmvIU++Qm+a2SWKgjUatq+fyzNsXTsWpuX5mUHXsFNuc6c3bySFdeSzxqVUnutFe3oiNvFOgL2U/ydFWRm4/AgjFbj1PwB7QOrapUjEe/mmY/Ky0YVLpFJB1aNnYoZCd0iHK3liDfrlKhMWEqtN0sKOOVUaUTnZwKaCH5QONFkqWHNySdEvXbxZfdeo02729N09KXOO2xBus36c/9A/wd9rnEBrLsIrSiTrqRuprrzXRquRhQbEXp1p87gwM1iyAX4azQm4lneMdLrFUj4p6PHeCQrm4OOrko8fnF7qDwuXfkjN5VEjGf+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKPRMBVh8zRQNedbMqrr6A5GVdeIF1KGsdCCMLQagfU=;
 b=Q/0dRuYKtAybDtiRdL1P4qazYnz0kFCSpknMS6JhrUjCnZREIsf1cUfoJGZ3oZVkQxAyLIovfX1yfc7ezBpjrdgrm9Qqc+R0XbwBoVKkTDjynV/Zr+OcK4oUlsr8AKhOlLGQoAYpLTQFokEi9JOLaRPNv6yf0wf9S5N8b6b7z+1secbj3CKu+BtjQGpoNEuTwhYYCQCgEWslv9BODkuwpmus33DfbJHKXZu/F/bQHF66uYTpl9ewCVV405GQn8dLVsG6y9akLnRej+PX6kvQRxp/asHPFqi7wCB1DX1BIZO8DyGfj4QgNcB9y/82WbM5xjEhomCpEbRzwydG4DIQlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKPRMBVh8zRQNedbMqrr6A5GVdeIF1KGsdCCMLQagfU=;
 b=wu3enahQr4ciukDpH9zJuYDYhO70GTEPB544EtsrOZMFO2U9aUkgiOGgCXEavjOTQEF7iWoftLNqbeWkfWLUPvDbEPnwBRynIkDnBE3ZzaqjcbuzHVC46xR1KG7v0v0qhima4vYHgDbcuEpRTVCtotxXOl4O2KeYIJ0fUYXZVxY=
Received: from DS7PR03CA0228.namprd03.prod.outlook.com (2603:10b6:5:3ba::23)
 by CY4PR12MB1479.namprd12.prod.outlook.com (2603:10b6:910:d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Thu, 28 Apr
 2022 07:11:38 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::14) by DS7PR03CA0228.outlook.office365.com
 (2603:10b6:5:3ba::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Thu, 28 Apr 2022 07:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 07:11:37 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Apr
 2022 02:11:35 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v4 5/8] x86: nSVM: Build up the nested page table dynamically
Date:   Thu, 28 Apr 2022 07:08:48 +0000
Message-ID: <20220428070851.21985-6-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9491d2ad-4487-4201-f397-08da28e6562c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1479:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB147929F4F182A52269BAA3DDFDFD9@CY4PR12MB1479.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8WZ5gB1AOZYgKsnt2mmWUDUcXjGtSuYbXuWnfKjGXtyptfdm7ZkXlwqusgoC7zvGIwNHJSpWi6JFJWbcYuLeWx535AEV5vswyghInKQQwtREHPRLZRBwCcWv+/y8yVdspuFlya8GzEF/uqBmBBj4WwDAgXTS0faTXueo8wHHz5EEsFdTRb6vonOpMAvby2sEw7rH/sZwfhvQWrPlB8FqXq3A5mNvoU8+ZthJvnm/0ItBwveNtmgwcCJUQotr1rET8iyzydTj1Et8l/IBu/v1FOdc8fo4/qPP8NFRbpI5Ekq8HSWL5FsXIic4+Ty1xG4eQOUblDlc6itOVzxzmDkHtOvoCr7fibEz72ht8oK6IG6SLRSdPa/gxfFNdDnoHRM99WyvNnxN7XOWsnm9RgDwUHeT/K4+C3EYwZaiiHp0d013EU4oJVQe6/ImOkk9QXjQZENWvRyDUhpRg99Tmh9vUERAokctCUBwsjtVxgd5LrbJ0el9NQSsXtwl+Y9guH2wy64psuxcC2hrtsuRA+o2b63+k4CdOeNTd6gAExO91eypprH1c1HTh0XrZ1PWbBGp2GKyEBwhYpEqXR5wH2xCtIVzGk3HrlfcOfXW5kTpb/5DV4WJ0jXyhjnyCDgjNzTrHCOjyNbNLE/703OIb4GoGsV21ZKsVgZB+Dw+7WGeB7pFgRUWwvkDzZFtY6O1FRuHTHe24SzqqQseMCHi431AOg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(86362001)(186003)(2906002)(6666004)(7696005)(1076003)(16526019)(82310400005)(316002)(4326008)(36756003)(8676002)(70206006)(110136005)(70586007)(81166007)(36860700001)(44832011)(5660300002)(508600001)(40460700003)(47076005)(426003)(336012)(8936002)(356005)(83380400001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:11:37.8472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9491d2ad-4487-4201-f397-08da28e6562c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1479
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


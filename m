Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B2E50D6C7
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 04:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbiDYCDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 22:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240258AbiDYCDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 22:03:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43B415701
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 19:00:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRa1EUQrpgK5WVsTZ6Rz7D/tqvsEGqlS3IMPjHpr8PFnKXZ9np83oFXf8xYfdrwysdVfh7bacidaOesMzBej4Afhvfnbk+c5B7FPj4gdx0ulX5+zhnqIfXKb1gcgi7S5jJAEZRKDvOqJJ36cnfV8DVmmHVu13ttdg/aBCtr7/UYXFlNRr/cTyfzHdbeul/okwZ7fcJRjItc7kC3NhW675/zykiQaD3/i7OTvq/cPOrMvtGI2U1kfq+8Z2LCpv2/WlWouYva/RJQfhA2O9TbqNixx4A4wUhI2V/AqgdxN1oSwsHUWBsHOEbPtGsPaINtsVzfJyPqqecLt8vKruwN4FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRSbsy9gE8G0QORUo9I7lHtUg+Z/T3tiYSA7DH3e5ZE=;
 b=LGBrK0KKFr3jrNMM/RD7P1wheUBbHbD1dDXgucUhGOdKh2bpaRhx/QeRheQ9Aa++ZGq7FMRTPfwavBpDtpaq2EEyBLPFwnx2Bi2mYYTiJHoH2L33PmnkVDWiKP/mH5YtFqmI340fleeh3ebG11J2dcDE1by3Q+9CyLVLzJcYalUkDXoSdERrfIkqoilnOi1Mh/oUrQ21CQykD0qNgjmUQY7pmjo7QIC/UDlJPFaTGKD6l1OotA8Jm6TtKjYl+R2XkwPvcs7pwOxryQMVfzoB7JgieUsxgbmuHmMUc9fkVWFTKVCJGy+OyTeYJ68WpZhr0yxCPYcDClZv/oGjzt/qpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRSbsy9gE8G0QORUo9I7lHtUg+Z/T3tiYSA7DH3e5ZE=;
 b=uAsSMyP5+XPr483szyxhZ7Kpb6/RiBLxHeL1v1R4G/0ZZXqB6GJ7gs0eKKgADa2chPrVbZ0F0a9tWwepFUZr7dPkl0woz1zJG6wKBKckQit1T25zsi2SM2fESAZuAHfQf1OnFVB4tQ5cCtEAEL6vPrARiFhdaVPG74mHTMxZSRQ=
Received: from BN9PR03CA0385.namprd03.prod.outlook.com (2603:10b6:408:f7::30)
 by BL1PR12MB5803.namprd12.prod.outlook.com (2603:10b6:208:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Mon, 25 Apr
 2022 02:00:07 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::8e) by BN9PR03CA0385.outlook.office365.com
 (2603:10b6:408:f7::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Mon, 25 Apr 2022 02:00:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 02:00:07 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 21:00:03 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v3 5/6] x86: nSVM: Build up the nested page table dynamically
Date:   Mon, 25 Apr 2022 01:58:05 +0000
Message-ID: <20220425015806.105063-6-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 92dfadae-a4eb-4c5d-2fff-08da265f5292
X-MS-TrafficTypeDiagnostic: BL1PR12MB5803:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB580386BC50AAB71E85AEB186FDF89@BL1PR12MB5803.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7kxNRYxjMYLlgDdgtT3eTXGNauBcygxL+rGD0A7nmEh4aznLDBzA+zjYx8fuTfrEuZqnKZtJG+V0TiD23hKtAwjdqeAOxBniE3aerVRyifhwBMcGrBUjk2ozBAUyPgTDEWHPFs+rdeJFvp8Pq4KlGIQVb9F/BCkLb4EWqgJOGmsKidQZZPCF1I2OAg/1BYnXdaL9G/lby2/Nhe3NZcdy03CykFnuUsgZt2UgPeqjPzh6qQZtA/zRIdnYlCagvfVdyuSh9MWY1j1X+07mbPnRL6arSznx0ApYKfyP3aCThwwoJ3Egc4wn9m2X5UpwxkU2HunIeqeN11Cnd4+5WC1aCOGmZ/BlZ1rQE2AGvYg9W+nRKrELO9Rn63+Zrw8mrBa/UcB+7FV6hURv5WZIJn1joOjVJRYUUMQP+t0w8ommNFwWVa7aqF4ttjA4pbKUuzvBLtYrYT7uBed+4IVJshJ33YKeS2sZQ26ymVc9FZTAno2Rsxl9NfxqZ+FlPYmMA0IsBbEXcJdGBTb/0QZr0ZGc+UE4qR+K4UWh1/6RsVkUggvVGOKsaXADgVmcUUdHhB08G98ck5Qr4bN2BrQDvHjQyLNBb1Jvv4nVjQYzdObQJ5I++IXqPu9JFIX9jhkx4oj4HGz86pCdUkopvnTCRKQlY2mZRJ70W95xU/Uu37z3mQm+RyBI7+5tj+01EgBRu/iZpbKmEDycQkYjAAkr0yjlw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(1076003)(26005)(186003)(16526019)(7696005)(110136005)(2616005)(426003)(40460700003)(336012)(36756003)(82310400005)(508600001)(36860700001)(86362001)(81166007)(5660300002)(2906002)(316002)(356005)(83380400001)(47076005)(70586007)(44832011)(4326008)(8676002)(8936002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 02:00:07.4626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92dfadae-a4eb-4c5d-2fff-08da265f5292
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5803
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
 x86/svm_npt.c |  7 ++---
 3 files changed, 30 insertions(+), 56 deletions(-)

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
index 4f80d9a..34fdcdc 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -208,7 +208,7 @@ static void __svm_npt_rsvd_bits_test(u64 *pxe, u64 rsvd_bits, u64 efer,
     report(exit_reason == SVM_EXIT_NPF,
            "Wanted #NPF on rsvd bits = 0x%lx, got exit = 0x%x", rsvd_bits, exit_reason);
 
-    if (pxe == npt_get_pdpe() || pxe == npt_get_pml4e()) {
+    if (pxe == npt_get_pdpe((u64)basic_guest_main) || pxe == npt_get_pml4e()) {
         /*
          * The guest's page tables will blow up on a bad PDPE/PML4E,
          * before starting the final walk of the guest page.
@@ -336,7 +336,7 @@ skip_pte_test:
                 get_random_bits(20, 13) | PT_PAGE_SIZE_MASK,
                 host_efer, host_cr4, guest_efer, guest_cr4);
 
-    _svm_npt_rsvd_bits_test(npt_get_pdpe(),
+    _svm_npt_rsvd_bits_test(npt_get_pdpe((u64)basic_guest_main),
                 PT_PAGE_SIZE_MASK |
                     (this_cpu_has(X86_FEATURE_GBPAGES) ? get_random_bits(29, 13) : 0),
                 host_efer, host_cr4, guest_efer, guest_cr4);
@@ -382,5 +382,6 @@ struct svm_test svm_tests[] = {
     { "npt_rw_l1mmio", npt_supported, npt_rw_l1mmio_prepare,
       default_prepare_gif_clear, npt_rw_l1mmio_test,
       default_finished, npt_rw_l1mmio_check },
-    TEST(svm_npt_rsvd_bits_test)
+    TEST(svm_npt_rsvd_bits_test),
+    { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.30.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FA355CEEE
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344260AbiF1LlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344703AbiF1LlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:41:15 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6772F666
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:41:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0zJlZfhZaweoYfxr9yxQhhgaGNMvhswD72yG10XyAbNWvhHtsGi1WM5hPBcdNcrAbG//DKdZPUd4tASKYBVEBO9IvYLYGLgLGZYnHXXy1DwYvRifMkI4Ne15urFwhRM1TKtt1ZmM63PXr6Gq0RkjIoK2nl8pkwwHXRbn5rJBWRYXAEerNKn30XHxrRWfXUtVN8T6foOByHnJxTCzJC8y2mxeUZiEXGpGExpFCT3OnHQpMk2t0rFe/eRJxOaK5mOBP7H9/GVNFMNSBLtxfgFWbeNWyIno56S8UVniTh3cOlngOO/YFxVUbfI4/YB5zTwycN4H1vpPaXrTpwVl+uapg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBFmLH8ic6qA7hZHS5iw9Sp98jkPiIaIZ5b4SZzSh7U=;
 b=Oizjx7maGOS1MMGWcMJHwIG8cLFkcKJ2Ieb1QwfB/0Nq/HQ+GV7k798wiQpnqJ5aYdlZBeLaM3mpO5W1+9+ZJp30evoJ2kmx8dxHZ0VCaFEG1fCB8xibJFvmdiCdfJYnRn0SiyEUMpNXmZOARSDOd45Bn3GmqhqSTMpObg6PZG5dG3/SUN/xSi3aQGuUNH/2UvxLclo7TK/4CheRolxKewvWJDIW2+J1Y68LyHS3IXuH3CBAUmcbkGBN36EQHJHjSeTNLI7a/j0Ouoh2RxG5Pa3d1qdlEjdS4/msV896OQOv/IqZVcnF7ql6KCOlvHZebYf4s6eU9aZJpw9UMuuIqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBFmLH8ic6qA7hZHS5iw9Sp98jkPiIaIZ5b4SZzSh7U=;
 b=pkdZ6TcQb2ESxe8eOqCfH4iWZqVe1O7ZKhAyh2wG63g/Uzvux+RDE1vLoR5DGxYs32SaarxNZ7VVjDaXw3lDR/DTHcMQds2M5iJw/A9WQXwLZE8vaVcSkbrcHTXYsE0opkg2gV0/+vi7Dp1yIuJ7nEvZ41V7IX5WZObJesLfSIQ=
Received: from BN0PR10CA0029.namprd10.prod.outlook.com (2603:10b6:408:143::7)
 by MN2PR12MB4502.namprd12.prod.outlook.com (2603:10b6:208:263::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 11:41:11 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::a3) by BN0PR10CA0029.outlook.office365.com
 (2603:10b6:408:143::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Tue, 28 Jun 2022 11:41:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 11:41:10 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 06:41:09 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v5 5/8] x86: nSVM: Build up the nested page table dynamically
Date:   Tue, 28 Jun 2022 11:38:50 +0000
Message-ID: <20220628113853.392569-6-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 132a43dd-adef-4ce5-d9f2-08da58fb1925
X-MS-TrafficTypeDiagnostic: MN2PR12MB4502:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IMh8EYmnU5dh+MIWIRokgoWMdhgawYm26LYeUbkrWX8irEmOt8Xyh2XIIhOrnsSX4mDnLp3hnO3IVdjrEnbeDlW6l8sTpPdcPGwche/alUVWfaJOLKLjEPefFfdGisLD0uLoAhMPGhQz7Hx9KIqSR/vmd0ocdgYZ6ddynCpAblT8Zrrsq6mgAM4zHel0DkWZQrwQcWnIKtJ3xhOcqeJmqN6rjzfCO51ElpgM1zm0va6ZX3jY+4bapGz13rrcAVEWstasmYgr1XgpSk/Hw8lILarEsPQ7yoqUHvXlY0Uns/1gEv3RC2NKUy/+7WKEwPFaMuQ58DCjYSFEYFXvkpagVURXhD9P82gR0aCRFf+zE+BDxSlQrFPDXxhBsIizK5fMuvo1PJZyTXF2G2C7L5OtkZyw0ie/JPrHBfJmMmNYO95cFBmh5SdrM6qr+60pjyazj81yWhfEeqRFkjBxdv6TOSWglbGA6Kue11KWiHOUnEZPEZV+FRRCT5D3lv3D3Fuj6TWs38vyjCrvj7i+h68t+PpApGjFoxlG4g+uuTYRABBlZgRIg/gBjWXGJSG0f6MGASseTQvB1YSukEe5vcP1eeILQYTX76vp1Cxz+e9jHYBNAqKqu2ij5jrVZaEKFsGXYwrVX7NHDP8h/VOuHEMwo2BMKyzsPnfKwu6vKWQ2lh8HUuHdHyCdvYZt0VuQOFhvlGWT+SDs9gmuS2KRKOy5ncvYBikmL6XUtGo3PFLMBA2Eg68Kgq9TeyU6xk6jcgAMv27y+FuqC/bcoRG1lksHOW73RdmsKgkd/U+NNwXHoInC3V0SI1HIoPmViR1YsVpZgqGPt4go6GthvcWin7jLxw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(376002)(346002)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(1076003)(110136005)(6666004)(356005)(81166007)(82740400003)(36860700001)(316002)(36756003)(44832011)(83380400001)(70586007)(26005)(82310400005)(70206006)(2906002)(47076005)(186003)(336012)(8676002)(86362001)(2616005)(5660300002)(426003)(16526019)(7696005)(4326008)(478600001)(41300700001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:41:10.7668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 132a43dd-adef-4ce5-d9f2-08da58fb1925
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4502
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Build up nested page table dynamically based on the RAM size of VM
instead of building it statically with 2048 PTEs and one PML4 entry,
so that nested page table can be easily extensible to provide
seperate range of addressses to test various test cases, if needed.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c     | 73 ++++++++++++++++-----------------------------------
 x86/svm.h     |  4 ++-
 x86/svm_npt.c |  5 ++--
 3 files changed, 28 insertions(+), 54 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index b586807..08b0b15 100644
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
@@ -16,38 +17,27 @@
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
+	return get_pte(npt_get_pml4e(), (void*)address);
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
+	struct pte_search search;
+	search = find_pte_level(npt_get_pml4e(), (void*)address, 2);
+	return search.pte;
 }
 
-u64 *npt_get_pdpe(void)
+u64 *npt_get_pdpe(u64 address)
 {
-	return pdpe;
+	struct pte_search search;
+	search = find_pte_level(npt_get_pml4e(), (void*)address, 3);
+	return search.pte;
 }
 
 u64 *npt_get_pml4e(void)
@@ -300,11 +290,21 @@ static void set_additional_vcpu_msr(void *msr_efer)
 	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
 }
 
+void setup_npt(void) {
+	u64 end_of_memory;
+	pml4e = alloc_page();
+
+	end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
+	if (end_of_memory < (1ul << 32))
+		end_of_memory = (1ul << 32);
+
+	__setup_mmu_range(pml4e, 0, end_of_memory, IS_NESTED_MMU);
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
+	setup_npt();
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


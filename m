Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB34D0EC9
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245438AbiCHEmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245570AbiCHEmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:42:07 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7CA3BA61;
        Mon,  7 Mar 2022 20:40:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khCdZ6iLEOEKIAwcZwwNmR45o1Pvr0cZJxdWhg3Jv78K0fCi4jsK28FoZzbZNfH2dj0do2q3DnKbeS8XtTdAsAcJ9G5JdMm3M4iCL8c5ZkNkw3YTWhVrKySQleCHySE0IQTJ5fYxwuqVBfBtVbiIAmGCp2J/FOziNbgtrGhsU9WWWq1o8XyJx68/HbeHfD6kEW88oo1NifSXlbLsdDMKSAxxwVn1j84EcMdNFlyuJXexE/+U5aqSY7LD5gHnniQMh5a07rkIWerjq4Bce28f1Ua811ewPtMlDwHwQtSSEQI6RGl0pKnxTw0H9rU56hrB07oadvBQswfcL6628aWvdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fS5KJk+FNalIXRvnvjm3wg4niRt0/uJiUGFXnkpgy8=;
 b=Dra1tjyRZwsnfMgovy4/OzWiL5JagYUBqTp1lhSLncSgwtlg7YQ0Qih9NeVlpOUU0N5x9YbvLy0e52txT+2wSskg44sJkPTTamvcwVjk03FGZPBknb5j1Nc6+ynP0Yc/BZsRzj10QshQDLvjHtXuegFnZOQCCj7ZNjGCzBnvO+EZ6TvG+QgcwwezuAsfs7MJvaurfiVmRNkYt0A/rS516paRAtBShIj3toRuYqgowe19sISotfmR0yODw7fSDmZ3srqOAkJLd5zghwBoQEfKnYZRWjFN2v60gzF6Brx/c44DQoIGcSUFjpsZAc82tB0xaAAwTErL0EC1djPsVFsMXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fS5KJk+FNalIXRvnvjm3wg4niRt0/uJiUGFXnkpgy8=;
 b=f8I/mMMenmkmCG6F+5XVJtnrYwv2JQ78/WYSIIXszjdW9p5cgaT4vHivjRBUNJMYW0YBqTgIQRSuFxnbC0E6DDyTDYRvsHgNGKOzgnYOOze27Of3pB5MLg/LMhQDDpr3fGUOAZAnq4MwfM6lF99XUchnADKTxc3XzAVuNF6KWMc=
Received: from BN8PR04CA0033.namprd04.prod.outlook.com (2603:10b6:408:70::46)
 by MW3PR12MB4348.namprd12.prod.outlook.com (2603:10b6:303:5f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 04:40:50 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::f) by BN8PR04CA0033.outlook.office365.com
 (2603:10b6:408:70::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:49 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:43 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v1 9/9] KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
Date:   Tue, 8 Mar 2022 10:08:57 +0530
Message-ID: <20220308043857.13652-10-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220308043857.13652-1-nikunj@amd.com>
References: <20220308043857.13652-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fce8d315-bc92-4a8e-a3e3-08da00bdd1e5
X-MS-TrafficTypeDiagnostic: MW3PR12MB4348:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB43480375B7765912A8FE3064E2099@MW3PR12MB4348.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kb2H5I24lENDweXkJ1K0+gLPsvArhbgHQpnaI1n9jzr/R5XHVaRXKjgUMrIwnD4cmRG4gfL/7vSzR0g4MGFx6CLb5xCnamL71vgU3vyzOtEB3zYDYId4IktnD1sr+KaCTsHu9gDv/MKFYN1/P3MTXB/0Nnn7VDnECMeiS5mukhk1/EFHKE0XbQOdzeThH3smdjA9IPTEUn9oXGFWHuwEdc94GR5L41xPKdWdlWZLLE6F8tvDrdFwlEGUdgLmAfuzMcBGxKGqxJ6VIu+2fBI0OwqFa1tYGAieXSdHn3fEnSOctkEwGdel/emfaQE473sYcl6xpNIscwS2QeeEclF0M4lEJrGGUSzNs09kBWy1TVTDrK4wdIIe+IjFIwqwNlhAAQ8NSiQsIrUUADwsfcrQymZRcHE0/r3hfpCjNB2O/l0FelITC4zqbZT6Xyb68GN5QjmVMU+FSIJ7AyFyQnAQ0RGNnu3tZUuoSOt8DB0SftRKY9rx3BqYxtUeetN7q/9yfmYX3Bz4F1K8RG0p3SiQQdBadXpz9LU2ewDzFGVsgAGYsbyIau1LN0NRqOSsd271t4gILEc6WvGPZqgcLA5l6SCaXuIF1X3hcI4ziFj3md//bNUOqfQUiADBQJdz4uPIxk7sLzdq+9W58mwHktLX/b4Npsy2KITy1Hqk8PnUQLBINNA/qbUzaHiX6QzbTxLir2Jan+Gk9cC+IbcZAmoQ9Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(7416002)(8676002)(4326008)(70586007)(70206006)(7696005)(47076005)(2616005)(5660300002)(8936002)(6916009)(316002)(40460700003)(54906003)(36756003)(2906002)(186003)(1076003)(426003)(36860700001)(16526019)(26005)(6666004)(82310400004)(508600001)(81166007)(83380400001)(336012)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:49.6028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fce8d315-bc92-4a8e-a3e3-08da00bdd1e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Pin the memory for the data being passed to launch_update_data()
because it gets encrypted before the guest is first run and must
not be moved which would corrupt it.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
[ * Use kvm_for_each_memslot_in_hva_range() to find slot and iterate
  * Updated sev_pin_memory_in_mmu() error handling.
  * As pinning/unpining pages is handled within MMU, removed
    {get,put}_user(). ]
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 146 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 134 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7e39320fc65d..1c371268934b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
 
+#include "mmu.h"
 #include "x86.h"
 #include "svm.h"
 #include "svm_ops.h"
@@ -428,9 +429,93 @@ static void *sev_alloc_pages(struct kvm_sev_info *sev, unsigned long uaddr,
 	return pages;
 }
 
+#define SEV_PFERR_RO (PFERR_USER_MASK)
+#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
+
+static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
+					   unsigned long size,
+					   unsigned long *npages)
+{
+	unsigned long hva_start, hva_end, uaddr, end, slot_start, slot_end;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct interval_tree_node *node;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	int idx, ret = 0, i = 0;
+	struct kvm_vcpu *vcpu;
+	struct page **pages;
+	kvm_pfn_t pfn;
+	u32 err_code;
+	gfn_t gfn;
+
+	pages = sev_alloc_pages(sev, addr, size, npages);
+	if (IS_ERR(pages))
+		return pages;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	if (mutex_lock_killable(&vcpu->mutex)) {
+		kvfree(pages);
+		return ERR_PTR(-EINTR);
+	}
+
+	vcpu_load(vcpu);
+	idx = srcu_read_lock(&kvm->srcu);
+
+	kvm_mmu_load(vcpu);
+
+	end = addr + (*npages << PAGE_SHIFT);
+	slots = kvm_memslots(kvm);
+
+	kvm_for_each_memslot_in_hva_range(node, slots, addr, end) {
+		slot = container_of(node, struct kvm_memory_slot,
+				    hva_node[slots->node_idx]);
+		slot_start = slot->userspace_addr;
+		slot_end = slot_start + (slot->npages << PAGE_SHIFT);
+		hva_start = max(addr, slot_start);
+		hva_end = min(end, slot_end);
+
+		err_code = (slot->flags & KVM_MEM_READONLY) ?
+			SEV_PFERR_RO : SEV_PFERR_RW;
+
+		for (uaddr = hva_start; uaddr < hva_end; uaddr += PAGE_SIZE) {
+			if (signal_pending(current)) {
+				ret = -ERESTARTSYS;
+				break;
+			}
+
+			if (need_resched())
+				cond_resched();
+
+			/*
+			 * Fault in the page and sev_pin_page() will handle the
+			 * pinning
+			 */
+			gfn = hva_to_gfn_memslot(uaddr, slot);
+			pfn = kvm_mmu_map_tdp_page(vcpu, gfn_to_gpa(gfn),
+						   err_code, PG_LEVEL_4K);
+			if (is_error_noslot_pfn(pfn)) {
+				ret = -EFAULT;
+				break;
+			}
+			pages[i++] = pfn_to_page(pfn);
+		}
+	}
+
+	kvm_mmu_unload(vcpu);
+	srcu_read_unlock(&kvm->srcu, idx);
+	vcpu_put(vcpu);
+	mutex_unlock(&vcpu->mutex);
+
+	if (!ret)
+		return pages;
+
+	kvfree(pages);
+	return ERR_PTR(ret);
+}
+
 static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 				    unsigned long ulen, unsigned long *n,
-				    int write)
+				    int write, bool mmu_usable)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct pinned_region *region;
@@ -441,6 +526,10 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 
 	lockdep_assert_held(&kvm->lock);
 
+	/* Use MMU based pinning if possible. */
+	if (mmu_usable)
+		return sev_pin_memory_in_mmu(kvm, uaddr, ulen, n);
+
 	pages = sev_alloc_pages(sev, uaddr, ulen, &npages);
 	if (IS_ERR(pages))
 		return pages;
@@ -558,6 +647,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	bool mmu_usable = atomic_read(&kvm->online_vcpus) > 0;
 	struct kvm_sev_launch_update_data params;
 	struct sev_data_launch_update_data data;
 	struct page **inpages;
@@ -574,15 +664,18 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
-	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1, mmu_usable);
 	if (IS_ERR(inpages))
 		return PTR_ERR(inpages);
 
 	/*
 	 * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
 	 * place; the cache may contain the data that was written unencrypted.
+	 * Flushing is automatically handled if the pages can be pinned in the
+	 * MMU.
 	 */
-	sev_clflush_pages(inpages, npages);
+	if (!mmu_usable)
+		sev_clflush_pages(inpages, npages);
 
 	data.reserved = 0;
 	data.handle = sev->handle;
@@ -617,9 +710,14 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		set_page_dirty_lock(inpages[i]);
 		mark_page_accessed(inpages[i]);
 	}
-	/* unlock the user pages on error */
+	/*
+	 * unlock the user pages on error, else pages will be unpinned either
+	 * during memslot free path or vm destroy path
+	 */
 	if (ret)
 		sev_unpin_memory(kvm, inpages, npages);
+	else if (mmu_usable)
+		kvfree(inpages);
 	return ret;
 }
 
@@ -1001,11 +1099,11 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		int len, s_off, d_off;
 
 		/* lock userspace source and destination page */
-		src_p = sev_pin_memory(kvm, vaddr & PAGE_MASK, PAGE_SIZE, &n, 0);
+		src_p = sev_pin_memory(kvm, vaddr & PAGE_MASK, PAGE_SIZE, &n, 0, false);
 		if (IS_ERR(src_p))
 			return PTR_ERR(src_p);
 
-		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
+		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1, false);
 		if (IS_ERR(dst_p)) {
 			sev_unpin_memory(kvm, src_p, n);
 			return PTR_ERR(dst_p);
@@ -1057,6 +1155,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 
 static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	bool mmu_usable = atomic_read(&kvm->online_vcpus) > 0;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_secret data;
 	struct kvm_sev_launch_secret params;
@@ -1071,15 +1170,18 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
 		return -EFAULT;
 
-	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
+	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1, mmu_usable);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
 	/*
 	 * Flush (on non-coherent CPUs) before LAUNCH_SECRET encrypts pages in
 	 * place; the cache may contain the data that was written unencrypted.
+	 * Flushing is automatically handled if the pages can be pinned in the
+	 * MMU.
 	 */
-	sev_clflush_pages(pages, n);
+	if (!mmu_usable)
+		sev_clflush_pages(pages, n);
 
 	/*
 	 * The secret must be copied into contiguous memory region, lets verify
@@ -1126,8 +1228,15 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		set_page_dirty_lock(pages[i]);
 		mark_page_accessed(pages[i]);
 	}
+	/*
+	 * unlock the user pages on error, else pages will be unpinned either
+	 * during memslot free path or vm destroy path
+	 */
 	if (ret)
 		sev_unpin_memory(kvm, pages, n);
+	else if (mmu_usable)
+		kvfree(pages);
+
 	return ret;
 }
 
@@ -1358,7 +1467,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 0);
+				    PAGE_SIZE, &n, 0, false);
 	if (IS_ERR(guest_page))
 		return PTR_ERR(guest_page);
 
@@ -1406,6 +1515,10 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 e_free_hdr:
 	kfree(hdr);
 e_unpin:
+	/*
+	 * unlock the user pages on error, else pages will be unpinned either
+	 * during memslot free path or vm destroy path
+	 */
 	if (ret)
 		sev_unpin_memory(kvm, guest_page, n);
 
@@ -1512,6 +1625,7 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	bool mmu_usable = atomic_read(&kvm->online_vcpus) > 0;
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct kvm_sev_receive_update_data params;
 	struct sev_data_receive_update_data data;
@@ -1555,7 +1669,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 1);
+				    PAGE_SIZE, &n, 1, mmu_usable);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
@@ -1564,9 +1678,11 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	/*
 	 * Flush (on non-coherent CPUs) before RECEIVE_UPDATE_DATA, the PSP
 	 * encrypts the written data with the guest's key, and the cache may
-	 * contain dirty, unencrypted data.
+	 * contain dirty, unencrypted data. Flushing is automatically handled if
+	 * the pages can be pinned in the MMU.
 	 */
-	sev_clflush_pages(guest_page, n);
+	if (!mmu_usable)
+		sev_clflush_pages(guest_page, n);
 
 	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
 	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
@@ -1577,8 +1693,14 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, &data,
 				&argp->error);
 
+	/*
+	 * unlock the user pages on error, else pages will be unpinned either
+	 * during memslot free path or vm destroy path
+	 */
 	if (ret)
 		sev_unpin_memory(kvm, guest_page, n);
+	else if (mmu_usable)
+		kvfree(guest_page);
 
 e_free_trans:
 	kfree(trans);
-- 
2.32.0


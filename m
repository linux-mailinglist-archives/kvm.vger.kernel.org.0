Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C2149244A
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbiARLHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:07:16 -0500
Received: from mail-mw2nam08on2060.outbound.protection.outlook.com ([40.107.101.60]:15840
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238886AbiARLHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:07:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJwBubjBSPFyxTwH6vppkGK8Q4zHVzyvd0+j7IF6MKQ4fhRQro93+8/pJuvZ3P5hqPIIRFGAfPIFn6xj3jdKcHWLW/0PfD/Um45m5ub7ByIU3mRoM/zL8ghb9syqSW/rV3/dnsW/YklZyDLnVX3YpGubP19JqHFT9YGM5ww5Vb1PaFherU9AgEctd5bjGaqnn5Q9ybWFllv5/phqEid5VTz3MzlDMEIegveKCAKSlhg7J33p/AwiebB/kx2L18mnjXI1Mg+Jb8t7n0TXLWag7mGB61/A2v4blwZtsqJ0+7eH1tJMcB8vBHJD+ATjZf/NWJBj8PPwe1pJvEbQTzdnRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGs/NxoPmwMYt2qms90KlE15xs/G5gfvCH3JjBjSFzY=;
 b=K01YcWMTXvEOmp+Qmd/BEiof/oo1z7+6tmTR4BMbcTDza0Fyz/3OnO7KsbXy2Me0Y7KuNQJxezrioEuyrPhK/fybCMDaLLKux2vWkxeN+2gfJ7wQ3jNNmbQm1DROQcHxtYN9GeAmmp0+qF4l2CKcrvGMM3BRt6DeDi9gQzLNJUaSk9YvSWzZSGQAPUEIfLrPCqi0VX6VREEUOCd0ws8FXQBqEo5o/0MRWQgTJzoHiTnXKBhVsTq7ZLMXLOivpU35Hdh1UlgKpY6tShx1wS0ScOzPkJ9kdLj6NQmP2dNkYcvxJGFf9w266bYn2G/cx/5bb90yl8mfanZKXYC2C/zoKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGs/NxoPmwMYt2qms90KlE15xs/G5gfvCH3JjBjSFzY=;
 b=BfvcvGl/bBFD58Y+SV9MI70LsbWakVxIB8CDqawX3E0bt2W/VYDPe3I6rb7gWoj7ycUjpBKxhIhEarObhqzDhhKkGUZhBHUqeW/rJVAmZwTizd3vWd4h9elh2vOx2co7ZvH5C1NwjSCMEUtNJudTMDfizxQlTunMgf6nrRBfLCs=
Received: from MWHPR14CA0048.namprd14.prod.outlook.com (2603:10b6:300:12b::34)
 by SJ0PR12MB5472.namprd12.prod.outlook.com (2603:10b6:a03:3bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 11:07:10 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::d5) by MWHPR14CA0048.outlook.office365.com
 (2603:10b6:300:12b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Tue, 18 Jan 2022 11:07:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:07:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 05:07:05 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nikunj A Dadhania <nikunj@amd.com>
Subject: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during sev_launch_update_data()
Date:   Tue, 18 Jan 2022 16:36:21 +0530
Message-ID: <20220118110621.62462-7-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118110621.62462-1-nikunj@amd.com>
References: <20220118110621.62462-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d680bbe2-6fc5-4471-51fc-08d9da72ac65
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5472:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB547236AA652B936074E89E50E2589@SJ0PR12MB5472.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WGaQOJmurj8xUqnxz/YcrdMhnYLvCvKPh1xA9tkiPGWhOE6M/j5lGMMQGs6e8rQDwf/xmEFflE8cPChSDFZalrBUUSXG6lE02eEJfpxYtAxjapYGTKpptUXicBtRK9RvEOr/jaF/ciHcZnhUiWqtiQOwxCBa1ulAFqdmMTKAxDEukohc+3o9ydBDOH75XBIEBBE6KKxn4xpd1VnwOeYMxh+xneaSHP0/h1MeRo/de4JIbzEITlVp1sz7ossPvb//kxVEhMzx6aOo6fNHRdA4w9KtLUkPZtE5/HDvdcFe1omeL4BYWGO9z3Ohz42XzXJVkSQGjnZHZqXbIKuZxMZu6ilT179MPBI0el/rt5GEj317U8W313dBqlP9vKb+Kw9DQVSkm1eJcFLh7++u37SrkW4PlLa2zPwybdnLJ28baY0OFtMdgIK3nhnquByVXtbgenonYeMJuzP0kiHsNZlzCMNmt3Jb30S3Davt0sfHMYj6NTRM09aynjflVdU3Cl/bjZKqV1pLh9sRJ3hEtfnrKIsIiq/Xbr6n9vSnn+3+hBR6ax++NwxGPyOYfGwNDAWFgnw0aRNWjYuJmDj5Cws4QwkNMECZ33Lwo2FMdcPxkyB/Vy/h7woM0+dueEKTN5gcZOKcc4xY/vUQ8mAjSy7vWMIJYNmb9yyc31CDyN3WnOm8ylddkhvRMT7TQzAh5LFlHwxzt8DegNUArTL6E3M3T99WsGNjp4WgZ2deuG8RK6vj7kRBJbGw1DO3/qApL0JEkqwbPyQdFgJaMhY01C1+7uSXNgzreokEPxO9S0N1YQ8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(336012)(426003)(5660300002)(26005)(36756003)(81166007)(2616005)(1076003)(16526019)(47076005)(40460700001)(82310400004)(6916009)(186003)(83380400001)(54906003)(8676002)(316002)(2906002)(6666004)(7696005)(36860700001)(8936002)(70206006)(4326008)(70586007)(356005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:07:10.1209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d680bbe2-6fc5-4471-51fc-08d9da72ac65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5472
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Pin the memory for the data being passed to launch_update_data()
because it gets encrypted before the guest is first run and must
not be moved which would corrupt it.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
[ * Changed hva_to_gva() to take an extra argument and return gpa_t.
  * Updated sev_pin_memory_in_mmu() error handling.
  * As pinning/unpining pages is handled within MMU, removed
    {get,put}_user(). ]
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 119 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 14aeccfc500b..1ae714e83a3c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
 
+#include "mmu.h"
 #include "x86.h"
 #include "svm.h"
 #include "svm_ops.h"
@@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
 	return pages;
 }
 
+#define SEV_PFERR_RO (PFERR_USER_MASK)
+#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
+
+static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
+					      unsigned long hva)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot;
+	int bkt;
+
+	kvm_for_each_memslot(memslot, bkt, slots) {
+		if (hva >= memslot->userspace_addr &&
+		    hva < memslot->userspace_addr +
+		    (memslot->npages << PAGE_SHIFT))
+			return memslot;
+	}
+
+	return NULL;
+}
+
+static gpa_t hva_to_gpa(struct kvm *kvm, unsigned long hva, bool *ro)
+{
+	struct kvm_memory_slot *memslot;
+	gpa_t gpa_offset;
+
+	memslot = hva_to_memslot(kvm, hva);
+	if (!memslot)
+		return UNMAPPED_GVA;
+
+	*ro = !!(memslot->flags & KVM_MEM_READONLY);
+	gpa_offset = hva - memslot->userspace_addr;
+	return ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
+}
+
+static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
+					   unsigned long size,
+					   unsigned long *npages)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_vcpu *vcpu;
+	struct page **pages;
+	unsigned long i;
+	u32 error_code;
+	kvm_pfn_t pfn;
+	int idx, ret = 0;
+	gpa_t gpa;
+	bool ro;
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
+	for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+		gpa = hva_to_gpa(kvm, addr, &ro);
+		if (gpa == UNMAPPED_GVA) {
+			ret = -EFAULT;
+			break;
+		}
+
+		error_code = ro ? SEV_PFERR_RO : SEV_PFERR_RW;
+
+		/*
+		 * Fault in the page and sev_pin_page() will handle the
+		 * pinning
+		 */
+		pfn = kvm_mmu_map_tdp_page(vcpu, gpa, error_code, PG_LEVEL_4K);
+		if (is_error_noslot_pfn(pfn)) {
+			ret = -EFAULT;
+			break;
+		}
+		pages[i] = pfn_to_page(pfn);
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
 static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
@@ -510,15 +615,21 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
-	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+	if (atomic_read(&kvm->online_vcpus))
+		inpages = sev_pin_memory_in_mmu(kvm, vaddr, size, &npages);
+	else
+		inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
 	if (IS_ERR(inpages))
 		return PTR_ERR(inpages);
 
 	/*
 	 * Flush (on non-coherent CPUs) before LAUNCH_UPDATE encrypts pages in
 	 * place; the cache may contain the data that was written unencrypted.
+	 * Flushing is automatically handled if the pages can be pinned in the
+	 * MMU.
 	 */
-	sev_clflush_pages(inpages, npages);
+	if (!atomic_read(&kvm->online_vcpus))
+		sev_clflush_pages(inpages, npages);
 
 	data.reserved = 0;
 	data.handle = sev->handle;
@@ -553,8 +664,13 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		set_page_dirty_lock(inpages[i]);
 		mark_page_accessed(inpages[i]);
 	}
+
 	/* unlock the user pages */
-	sev_unpin_memory(kvm, inpages, npages);
+	if (atomic_read(&kvm->online_vcpus))
+		kvfree(inpages);
+	else
+		sev_unpin_memory(kvm, inpages, npages);
+
 	return ret;
 }
 
-- 
2.32.0


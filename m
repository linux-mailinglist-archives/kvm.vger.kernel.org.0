Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B5492442
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbiARLG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:06:59 -0500
Received: from mail-mw2nam10on2055.outbound.protection.outlook.com ([40.107.94.55]:15965
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238550AbiARLG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:06:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtS1npYODLFOyJLMNNUk1hq4sMMZx+fl08JOXy4H+vjKHmRGI1YwbZ5ER7PfPG6iMbuPqJzSh8Uwx0y4SmAwyVliIO3E3Ua0FA8ouMAovPYe8h184XujAl3yDGhYJIaGrVtp8nQyGpdPIS7PQuq51lfGPqC/VKZql9XWGBKnnxOITlw7pvX5tu8RNPXbS3e2aGBP481pM/y6a7a7ZvHLrlNXUcCc1AS9jbXIiaZ7BKSX5bi4N+5YdrYwQCGIy4O8uBuoN2BBWj1XPmfDBwcFfz4KWT5ideOOF7lDjbrpbMCvEYm5cfRebL6Vxo/ne6m1QwjylE3+VRnKFqSrqz8FEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UKpjyRB8zKmbZhd9QXnlWZp/aC7b7ZPgU/15zOu8ow=;
 b=I4g9osP+CvLjlsMGMcSi0sYnPxrXc94fV1Oyg1NDwrBzj4XO02A2CPCU0mO8F5J7UaxHwFaQP9iDrF1F3hAdtfFrVU8UJde9vsPV8nfwg0AP6Yia/UZgHprXMqCMga0HHB4L8x7+Mrig4ZeWaFKBXbwPnsGv2PWVKRlLxllAEMuzbEd7e9aJZiPKlTZcz7Pv6Y5eiLHNIhmfU70TElVXuMx0SmwztzMySn5Ldy/z+M2bZFms/wuOGRUDl3YcFeDSMYbbSnztYliiRRchnIGCUWS4pWAmOwh0ECck/+AHgnn27HaWRTRuWdDvjUjoGoiLAC5s3HwUyxtoay30H5EwFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UKpjyRB8zKmbZhd9QXnlWZp/aC7b7ZPgU/15zOu8ow=;
 b=vYAdpf5CTuiMNfjgIw1uBeeX47IsALzQ0t46lmVSqTW4GYgY0iazn9CBX42D73JDDMf5toBMCJaVkE/PpHuELpeSNtwnZGJLcneuGH5vWWhd22melp6c8hhEuukVbQVYXKmizPODNsFOw8CZarMJ+jlTO71JCaDi6bD4miKXDTE=
Received: from CO1PR15CA0068.namprd15.prod.outlook.com (2603:10b6:101:20::12)
 by DM4PR12MB5341.namprd12.prod.outlook.com (2603:10b6:5:39e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 11:06:55 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::4c) by CO1PR15CA0068.outlook.office365.com
 (2603:10b6:101:20::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9 via Frontend
 Transport; Tue, 18 Jan 2022 11:06:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:06:54 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 05:06:49 -0600
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
Subject: [RFC PATCH 2/6] KVM: SVM: Add pinning metadata in the arch memslot
Date:   Tue, 18 Jan 2022 16:36:17 +0530
Message-ID: <20220118110621.62462-3-nikunj@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3fc57edb-5c50-46f4-3ff8-08d9da72a35d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5341:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB534160C94F189DF4E424CB89E2589@DM4PR12MB5341.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sWx8k7HcSjAvXgLyTqoItFEGxRaGK3WBvVFjtNSUS6lGM/OlK4K1PBL3kk7VfOkSO8tPMm6rYOy4BfbI3NidDqYnKi4yKkyTxkm3gT2TswdtNQYOpZbUr0gua8PuJYc6HIKefIYHKhtszpyM+oNO0hhOwJFW9cfJTyTBj690fRl9CxEEYWDnFBcpgvAA3BvpPdCuAPvRhjRY1QwzAUp/NSwy5TUD1Ly2AOaidpzSiBhzdIP7+m5vSluKFJ76igLYJ4K1jSCbq6j1scIbeY+/B/wireUfu0S4SngrcWpPvuHRIbOV8ZJoB5D3d4U9Y7HtjogufBCyZRRts0yWQUVmCCm6ZdEo4zb17enCLWudqgU2LCLzaVa4BktynNP8Mx9Fx+zh+TVAhClL+kTkPSXY7HRKpiENbBVzGVKd+u8Gr6F+rC+nChE6AO4fHFpXSRdV66/GnUUS2YOrsX9Q+4vPRsf1QUia2pkUHlDw98UijuOB6qU+Yb7sjEu1/Os4e5WEhB8G37CrjTEqVhDFhg4MGYNCsLTu2J500KWn6UAE2/IfuV/sXccfqDiBtPDeDLx+16bkdK/AcDDu9Cp7lB2fGHcsn71kl0FQB4tLmFo6dlwbfwVF/k14zRb8FmFC75BZeKthGBSOpyQ5EIHnwDcz7KiOvtjBKi3LBVswlq/zWirquaovjagf+CFxK96rlHjB++2sk0PIIeMfaKy5+DrxYv3svy9WYrccylQ/EcKPfhiiiwgghJIQ5ECJFGxiHQJ7YwgRvRtDY+Le2NCxy/F0bSHjPyC2CQwHJQv+ZshJwmo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(40460700001)(426003)(508600001)(6666004)(5660300002)(356005)(1076003)(336012)(26005)(81166007)(4326008)(16526019)(186003)(36756003)(2616005)(36860700001)(82310400004)(6916009)(8936002)(70206006)(7696005)(83380400001)(70586007)(8676002)(54906003)(47076005)(2906002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:06:54.9841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc57edb-5c50-46f4-3ff8-08d9da72a35d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5341
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV guest requires the guest's pages to be pinned in host physical
memory. The memory encryption scheme uses the physical address of the
memory being encrypted. If guest pages are moved, content decrypted would
be incorrect, corrupting guest's memory.

For SEV/SEV-ES guests, the hypervisor doesn't know which pages are
encrypted and when the guest is done using those pages. Hypervisor should
treat all the guest pages as encrypted until the guest is destroyed.

The KVM MMU needs to track the pages that are pinned and the corresponding
pfns for unpinning them during the guest destroy path.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  7 +++++
 arch/x86/kvm/svm/sev.c             | 49 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |  3 ++
 arch/x86/kvm/svm/svm.h             |  6 ++++
 arch/x86/kvm/x86.c                 | 11 ++++++-
 6 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a96c52a99a04..da03250f503c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -87,6 +87,8 @@ KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP(alloc_memslot_metadata)
+KVM_X86_OP(free_memslot)
 KVM_X86_OP(pin_spte)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1263a16dd588..c235597f8442 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -927,6 +927,8 @@ struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
+	unsigned long *pinned_bitmap;
+	kvm_pfn_t *pfns;
 };
 
 /*
@@ -1417,6 +1419,11 @@ struct kvm_x86_ops {
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
+	int (*alloc_memslot_metadata)(struct kvm *kvm,
+				      const struct kvm_memory_slot *old,
+				      struct kvm_memory_slot *new);
+	void (*free_memslot)(struct kvm *kvm,
+			     struct kvm_memory_slot *slot);
 	void (*pin_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 			 kvm_pfn_t pfn);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6a22798eaaee..d972ab4956d4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2945,3 +2945,52 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 
 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
 }
+
+void sev_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_arch_memory_slot *aslot = &slot->arch;
+
+	if (!sev_guest(kvm))
+		return;
+
+	if (aslot->pinned_bitmap) {
+		kvfree(aslot->pinned_bitmap);
+		aslot->pinned_bitmap = NULL;
+	}
+
+	if (aslot->pfns) {
+		kvfree(aslot->pfns);
+		aslot->pfns = NULL;
+	}
+}
+
+int sev_alloc_memslot_metadata(struct kvm *kvm,
+			       const struct kvm_memory_slot *old,
+			       struct kvm_memory_slot *new)
+{
+	struct kvm_arch_memory_slot *aslot = &new->arch;
+	unsigned long pinned_bytes = new->npages * sizeof(kvm_pfn_t);
+
+	if (!sev_guest(kvm))
+		return 0;
+
+	if (old && old->arch.pinned_bitmap && old->arch.pfns) {
+		WARN_ON(old->npages != new->npages);
+		aslot->pinned_bitmap = old->arch.pinned_bitmap;
+		aslot->pfns = old->arch.pfns;
+		return 0;
+	}
+
+	aslot->pfns = kvcalloc(new->npages, sizeof(*aslot->pfns),
+			      GFP_KERNEL_ACCOUNT);
+	if (!aslot->pfns)
+		return -ENOMEM;
+
+	aslot->pinned_bitmap = kvzalloc(pinned_bytes, GFP_KERNEL_ACCOUNT);
+	if (!aslot->pinned_bitmap) {
+		kvfree(aslot->pfns);
+		aslot->pfns = NULL;
+		return -ENOMEM;
+	}
+	return 0;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 46bcc706f257..3fb19974f719 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4740,6 +4740,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.alloc_memslot_metadata = sev_alloc_memslot_metadata,
+	.free_memslot = sev_free_memslot,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9f153c59f2c8..b2f8b3b52680 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -643,4 +643,10 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
 void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
+int sev_alloc_memslot_metadata(struct kvm *kvm,
+			       const struct kvm_memory_slot *old,
+			       struct kvm_memory_slot *new);
+void sev_free_memslot(struct kvm *kvm,
+		      struct kvm_memory_slot *slot);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76b4803dd3bd..9e07e2ef8885 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11694,6 +11694,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	}
 
 	kvm_page_track_free_memslot(slot);
+	static_call_cond(kvm_x86_free_memslot)(kvm, slot);
 }
 
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
@@ -11719,6 +11720,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
 }
 
 static int kvm_alloc_memslot_metadata(struct kvm *kvm,
+				      const struct kvm_memory_slot *old,
 				      struct kvm_memory_slot *slot)
 {
 	unsigned long npages = slot->npages;
@@ -11771,8 +11773,15 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
+	if (kvm_x86_ops.alloc_memslot_metadata &&
+	    static_call(kvm_x86_alloc_memslot_metadata)(kvm, old, slot))
+		goto out_free_page_track;
+
 	return 0;
 
+out_free_page_track:
+	kvm_page_track_free_memslot(slot);
+
 out_free:
 	memslot_rmap_free(slot);
 
@@ -11805,7 +11814,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(kvm, new);
+		return kvm_alloc_memslot_metadata(kvm, old, new);
 
 	if (change == KVM_MR_FLAGS_ONLY)
 		memcpy(&new->arch, &old->arch, sizeof(old->arch));
-- 
2.32.0


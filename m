Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E355527F8
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346958AbiFTXOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348211AbiFTXOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:14:17 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2073.outbound.protection.outlook.com [40.107.101.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4ED02654A;
        Mon, 20 Jun 2022 16:12:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzQ9dy6vkA9hYGcoE9lhaXn90oR82PYuE7DmFrWsfFdW/bSB9foep4AQOnEjgOLSFAqRaVSGtF09kBpjYU92yxA1XIkEfrk1V/FvEA/EONNypjmu1K6QjPLUpsum3jZlEiru7vGV/3uGsiODP4MxNXdrAVM7xkFPa+qk7uJL8jEHahYAnB21u3U4PaNz3BIkKAbntBGGg2MRTN57Ucsz1ZgHO1Vo9iGoGmgoy1GIoDJsq2DZ056eEKXOAQTODTLj/ck8IBgOx1cACswvBsJuSY1GP6+vF6Kh+Oo8L+uBe1oA57I4N2+G/BytpzfyFjkVSvlJ+pqXnr+pqS8Z26oVpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4II7Sw+OTmVpH+XlNpuL4yzBMW7v2TG4Mfy2slvmeEs=;
 b=YNr+WH2VUMMYF3a4WFOkXxPQrIP1ZPPba5dLQNwhjs6zxIRLiaI+RA9zyC2TnEs2J1dFaFE8CYkCnz8rPyS0Wn7CcecbIV6abwOGjbJZ/hRSyPklrE792WDMTbf3bPPRA3vpRFaOnTjDQ/FVNP+kz5xd+Dq8twQb8w/G2R92BpHWUUN8k9+3XOxuF7xILp1AJePlRPZauiH5YTXZi+yMR5qEFaUnW1+EScTHOIqJzV0qreIjyOVEL1fo3/a2CKJViO2CFA6mCvKr1K1/XnAozD++JRSq7tPQ4B0H5vZrkWVNH0xWLAb3XFER7cc1Fj8tlprarxoJ3pBB3Emcee/PtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4II7Sw+OTmVpH+XlNpuL4yzBMW7v2TG4Mfy2slvmeEs=;
 b=B4nxlEgl9gNooUY05wSXDT0g3h6C9JbH4En5g/3SzXEvNCLIOJI+EYSaWaN2KnQptYRPLkDkukUNkWXUNT5ektzr4uKxTH0w4z9EhVVztfec/s8LTjxHnnbhLn25RDAGEF25ZhANBK3FihFjQVYek/Sh9ycI5bax2ybbDLN2BbU=
Received: from BN9PR03CA0601.namprd03.prod.outlook.com (2603:10b6:408:106::6)
 by DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:12:28 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::19) by BN9PR03CA0601.outlook.office365.com
 (2603:10b6:408:106::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:12:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:12:27 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:12:24 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 39/49] KVM: SVM: Introduce ops for the post gfn map and unmap
Date:   Mon, 20 Jun 2022 23:12:16 +0000
Message-ID: <34246866043db7bab34a92fe22f359667ab155a0.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26e7cd5b-f3a2-4a86-9911-08da53125820
X-MS-TrafficTypeDiagnostic: DM6PR12MB4516:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4516BCF7B0A2563CB7E4875D8EB09@DM6PR12MB4516.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: se44/YaMlqecFPiDUEsVVNRJw/HeVTYvKwPNxtKsYggYUq7O2+qml0l/Y+MJ9i0SnVoXkbNpYn/JomJOBzI6RALJ3HL4rKTnFegnoZcdZjSrGG+OlXRc+30tpNqRUPxNxcrGi93HcxxqoyWX97E8sx7ozWctDdxbPYrXGhyRmgYbNTMZkFy4kRExVBH9ht5TPb40qaR71+wU3wX7tDpm6EdkHWVZiTwAyiZmvkhtKWLaQXRgPC2WpgcobMElNPatCUEEE6Ls6zP3wmJFbRdYUQdE9zD1LOILB1IoRI0rPy/0MJ27YtobyftLJH48S7tnAwGrmjrMMaBbtQKEy8A9hHKlJ10POgzlXd9abLD7M+IBlNgCt+lmwzXa9X8lYxiTwsKq0lxe4t0LBleLSwAsMdDeIxFJ1j8GVF/qOr/EKYEuo0+EZAUWs861pFXYb3XM/rRQgMIQjKM1Bi7yfEQCXy9mcpj6s1zg+nUGtLNomzyP6OrB9kte4QtjTipNttWasVvg1YgpA6bIzS5E3ZA8EuVu4wZjE+KrOS0Xk4sLXKpWz2cU0Keqo3FmuAfN9LqaX9WZuWkYgxwGgQge/QyUNo8scOHBBCD3Txwa2j+gnelBrf6cSOZHNf1UPvo4rY9j/nKiZ2XqP+RsSb38AOJmlYgCXmtYcsQjbK7hLUNIm2nMAptL5Jid4mDrtup9aLmAW6kCEFLwIJjvJ/YuOHm9Ewc72+tHNjpj6E8cOzkI8h20T9fJxEpQ4qZU6vgqtjorFgvP4JUxBsivc3o99VfuUg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(46966006)(40470700004)(82740400003)(356005)(82310400005)(36756003)(36860700001)(81166007)(110136005)(316002)(40480700001)(54906003)(186003)(47076005)(26005)(8676002)(16526019)(4326008)(426003)(2906002)(70206006)(336012)(70586007)(83380400001)(7416002)(7406005)(8936002)(478600001)(86362001)(5660300002)(2616005)(40460700003)(6666004)(41300700001)(7696005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:12:27.8457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26e7cd5b-f3a2-4a86-9911-08da53125820
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4516
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled in the guest VM, the guest memory pages can
either be a private or shared. A write from the hypervisor goes through
the RMP checks. If hardware sees that hypervisor is attempting to write
to a guest private page, then it triggers an RMP violation #PF.

To avoid the RMP violation with GHCB pages, added new post_{map,unmap}_gfn
functions to verify if its safe to map GHCB pages.  Uses a spinlock to
protect against the page state change for existing mapped pages.

Need to add generic post_{map,unmap}_gfn() ops that can be used to verify
that its safe to map a given guest page in the hypervisor.

This patch will need to be revisited later after consensus is reached on
how to manage guest private memory as probably UPM private memslots will
be able to handle this page state change more gracefully.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 ++
 arch/x86/kvm/svm/sev.c             | 48 ++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c             |  3 ++
 arch/x86/kvm/svm/svm.h             | 11 +++++++
 5 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e0068e702692..2dd2bc0cf4c3 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -130,6 +130,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL(rmp_page_level_adjust)
+KVM_X86_OP(update_protected_guest_state)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 49b217dc8d7e..8abc0e724f5c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1522,7 +1522,10 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+
 	void (*rmp_page_level_adjust)(struct kvm *kvm, kvm_pfn_t pfn, int *level);
+
+	int (*update_protected_guest_state)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index cb2d1bbb862b..4ed90331bca0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -341,6 +341,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (ret)
 			goto e_free;
 
+		spin_lock_init(&sev->psc_lock);
 		ret = sev_snp_init(&argp->error);
 	} else {
 		ret = sev_platform_init(&argp->error);
@@ -2828,19 +2829,28 @@ static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 gfn = gpa_to_gfn(control->ghcb_gpa);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
+	if (kvm_vcpu_map(vcpu, gfn, map)) {
 		/* Unable to map GHCB from guest */
 		pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
 		return -EFAULT;
 	}
 
+	if (sev_post_map_gfn(vcpu->kvm, map->gfn, map->pfn)) {
+		kvm_vcpu_unmap(vcpu, map, false);
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
 static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
 {
-	kvm_vcpu_unmap(&svm->vcpu, map, true);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	kvm_vcpu_unmap(vcpu, map, true);
+	sev_post_unmap_gfn(vcpu->kvm, map->gfn, map->pfn);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -3383,6 +3393,8 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 				return PSC_UNDEF_ERR;
 		}
 
+		spin_lock(&sev->psc_lock);
+
 		write_lock(&kvm->mmu_lock);
 
 		rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
@@ -3417,6 +3429,8 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 
 		write_unlock(&kvm->mmu_lock);
 
+		spin_unlock(&sev->psc_lock);
+
 		if (rc) {
 			pr_err_ratelimited("Error op %d gpa %llx pfn %llx level %d rc %d\n",
 					   op, gpa, pfn, level, rc);
@@ -3965,3 +3979,33 @@ void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level)
 	/* Adjust the level to keep the NPT and RMP in sync */
 	*level = min_t(size_t, *level, rmp_level);
 }
+
+int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	int level;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	spin_lock(&sev->psc_lock);
+
+	/* If pfn is not added as private then fail */
+	if (snp_lookup_rmpentry(pfn, &level) == 1) {
+		spin_unlock(&sev->psc_lock);
+		pr_err_ratelimited("failed to map private gfn 0x%llx pfn 0x%llx\n", gfn, pfn);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!sev_snp_guest(kvm))
+		return;
+
+	spin_unlock(&sev->psc_lock);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b24e0171cbf2..1c8e035ba011 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4734,7 +4734,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
 	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
+
+	.update_protected_guest_state = sev_snp_update_protected_guest_state,
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 54ff56cb6125..3fd95193ed8d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,19 +79,25 @@ struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
 	bool snp_active;	/* SEV-SNP enabled guest */
+
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
+
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct list_head mirror_vms; /* List of VMs mirroring */
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
+	spinlock_t psc_lock;
 };
 
 struct kvm_svm {
@@ -702,6 +708,11 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level);
+int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
+void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn);
+void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.25.1


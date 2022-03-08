Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C1D4D0ECC
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 05:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245261AbiCHEls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 23:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245429AbiCHElW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 23:41:22 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0023B3BA53;
        Mon,  7 Mar 2022 20:40:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deUshmlwhjHo4s5UluqRc3e/7pRMU4NnvhYM2MkM8g8gEbtJaKJMqhE787ffZprrHdHTB8P7inHFAihmPlnwGHW7O/Qk95rtB3OEqDNbbKQTvSXQT8ObYBzW6n5rB66GhRrZBvy8DguArFymckzMUqpQQRWQrUkvJbgvwACDuUFGRONO/SD1NwChG6O2/LnZQl86oVJW9VEIQ9BIsGm9bnmCI9LXQ9prFGW6yNCVWJE90pDbozivgcihLL2UfkyxQCS/iPNLCehut/H9uqTEsN/7mAfgln0m3Wz2/c5h3Tgs+/hSe8ARu//3/jtSzuV01vXKbT+cKOGDoTMzeAkbcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qM2tLOnF3ZYpC6ARUyWqAGZBf1ntzZKkRbKsSdrjXY=;
 b=PZbm43/wwhdISPUgMjLYXSM19LlvZCemWMSDtbiAesOlFuNqMXG+zL2qDPx+o9s9biU6IVBFN4h/wvUB8jCbcIxSwrHHqk2/BoWLMvtHDji4zEeDT7XRd/P6fe3AGKP+sQt5rN118zw9K36hc4EuUXUJernYpYTuNgmLjBTMPO6IYv7NT7+MEsGfWGtWft4BFp+doRBAXlnjMg7+J4odv9j5U9byNmcw6YfyBb2RMvIWrI5QscGX0zBX+AE+kHSeXEma/CkU5iszB7H26S6WTpWm5uYJsTEVcK+HA+5qQSslEStCH/iqve53Wc09eYCdifezS9/qss2cQhh3SGk15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qM2tLOnF3ZYpC6ARUyWqAGZBf1ntzZKkRbKsSdrjXY=;
 b=c+yaMZjg9iuGT7DEQMHgi/e95qhGpdxoGnHY37WUnrM1qfXnSWY8k46eAGamt/pnPrvwjBljV4/Iac9bwB0eU1Oy2+baTOfWwWCRzKuUtXXcgDLq3aOpcPZ3h5ZaXCgnJmunIMMOWaSn2F2ZA1tMQHFZ/wJzWhlhcJ4ipo2MrJM=
Received: from DM6PR11CA0038.namprd11.prod.outlook.com (2603:10b6:5:14c::15)
 by MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 04:40:18 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::1b) by DM6PR11CA0038.outlook.office365.com
 (2603:10b6:5:14c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 04:40:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 04:40:17 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 22:40:11 -0600
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
Subject: [PATCH RFC v1 3/9] KVM: x86/mmu: Add hook to pin PFNs on demand in MMU
Date:   Tue, 8 Mar 2022 10:08:51 +0530
Message-ID: <20220308043857.13652-4-nikunj@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 36666c20-36ea-44dd-2e91-08da00bdbeb8
X-MS-TrafficTypeDiagnostic: MN2PR12MB4454:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB44544188E2E6CFC52EEF0430E2099@MN2PR12MB4454.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZlkOeum9HXdoP8nmeLiupAmhnaiwhvNCFsO+on/c/CsBHqx2ujJKhiLxIuYaj6MDT8X506bSUlwa7K70mRM96+wrIvei3RQERyKlNuCOJvFpXVW1nPjIOGHx5WYTVRQF3C1Pn0p+TkjwH22//DN+5N2Ojw5vMgaumu6N6egCyI4YyF/tilAJC/tsMdftr/KRG+dm9HjpQwL4R87jm4ckyR4DhSmLGC82BZQsrBXTM7WUyRUJCt27jM4Sd1S4qKb956hwzK2kqw8B09Ky/Z3PT9WQTDPUHrkvo9u5T8p9euxLCa0zq7qzsUZJQsKgZ4VMCGROH+J3XmH29d4cXqP1xgR1ti2l4jv6l4v6bm1oEZKFqiZfchAb4liNQjhpSQH1iSDT2o4o9AKNnvMvXYJ+on2VpHSQRwuX68GvzyU44wnbs9y5+n645hXWy6woVR/LoX1e3CejHB8kN1eWmoKqXQkb/hlhiT6LZ9+PTUF0W/QGA0g1wgEB7w0jPS053hq59Pr9shGlzmmkB/0mGb6rW1wolSLirNEeFM61rrHliM7rT+Am7tCmYE7FKRthn3CHUaO7xy0VQNXKGsNab6pcCB2d6J/wPaNKdl6spDnDyWHhHYlHU/oIl5mHYw4bFTe7m/nja+zRlEx2B4VvsGFIJ6H/D7/UNHZBJCZPt92ut9RXsJg36Icg30D3gZH3wa5WA0wtrTQD5Pg0tueCCiPYQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(5660300002)(7416002)(7696005)(8936002)(508600001)(6666004)(8676002)(2906002)(1076003)(186003)(26005)(16526019)(40460700003)(4326008)(82310400004)(70206006)(70586007)(81166007)(47076005)(2616005)(356005)(36860700001)(316002)(426003)(336012)(54906003)(36756003)(6916009)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 04:40:17.3813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36666c20-36ea-44dd-2e91-08da00bdbeb8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vendor code via kvm_x86_ops hooks for pinning.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/mmu/mmu.c             | 15 +++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index d39e0de06be2..8efb43d92eef 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -88,6 +88,7 @@ KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP(pin_pfn)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec9830d2aabf..df11f1fb76de 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1418,6 +1418,9 @@ struct kvm_x86_ops {
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
+	bool (*pin_pfn)(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			kvm_pfn_t pfn, hva_t hva, bool write,
+			enum pg_level level);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index db1feecd6fed..b94e5e71653e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4001,6 +4001,16 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
 }
 
+static bool kvm_pin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn) ||
+	    !kvm_x86_ops.pin_pfn)
+		return true;
+
+	return kvm_x86_ops.pin_pfn(vcpu, fault->slot, fault->pfn, fault->hva,
+				   fault->write, fault->goal_level);
+}
+
 static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
@@ -4035,6 +4045,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
+	if (memslot_is_encrypted(fault->slot) && !kvm_pin_pfn(vcpu, fault))
+		goto out_release;
+
 	if (is_tdp_mmu_fault)
 		read_lock(&vcpu->kvm->mmu_lock);
 	else
@@ -4057,6 +4070,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
+
+out_release:
 	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
-- 
2.32.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE5E492440
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbiARLG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:06:57 -0500
Received: from mail-dm6nam08on2058.outbound.protection.outlook.com ([40.107.102.58]:50080
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238467AbiARLGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 06:06:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgA2jsS5hXB0eea7a9hQGhkQsUOxtTcmPBvv9tp7ihO+VDl7CIJb2PE2MpB3tE1m/oOyErJdyA8Qrx5b89CGW8s+gPWzmr678RSlQvpWRHIXk0RqnqPlm6cKsrjjF1wVOjTHc++w1SY8CR5qX0in4sqD2tuFGna7syUCqrygXk1TKOX1wjEMR6N37eGGwuk6VOYTunZo/6N8aEjW7lW9c3GZLmqPAx1gPIpfc2BAWL1aRvCk1CS+jlpRo2t3PGQ/eVS7mjgNxn32TchDmOFWYywgNWqlTXS/LgEH3nRkCbCtVswmOEU/oHR4r7TcVobMdoCYcn9T4mlHVQnjGZEMBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUmfn8KV5dcGImEu8xWKxUf1N8/3Nk126wgHmM0KoLA=;
 b=BRbOyhCKDjJha3oIJTjSlenP0iBSSCZjFlQUsPFymzf7Ha54KGXbGz70Pg8DSLlTSXQW/JPHHeHWzG1u0jKPyyzcm9yx5NykNG8KqF3pOSrn/+rsnDvhYzEOocuujGxseCaEJFqVYyQPa32zTgHtNE9f9l7HRUop5BVFCKGraDkV2QFCcqEiuKVqKhKXViHQFxzKTw5i8lXA8sE/nddMV2g4KLRkXc6g7M4R4yk1FQnR/wQt/6SAcZ4sU7PfymoqRVH9WEOmOVnWBavfSsf+JiPenpeeiokfyf941JnT0Y8TJKA8qyBh8chd60Jmr717F2rhhuHJH6TySc9GlFp4oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUmfn8KV5dcGImEu8xWKxUf1N8/3Nk126wgHmM0KoLA=;
 b=S71cJu6iagZwP2AlSuVpP5VGtYm5lx812qNX6C/GBJUzLh+kbVIgDvQxE+ETItnazvuK4ErB1i80g52qSak2L9ubuJbh8D844VPXl3fSUn2ZEV8qAwny/B4/PO3DQKQUpIqmqAuAFjkuwOyKzDBdhQ9V338HlNXWn8965bLZcIE=
Received: from CO1PR15CA0084.namprd15.prod.outlook.com (2603:10b6:101:20::28)
 by BL1PR12MB5079.namprd12.prod.outlook.com (2603:10b6:208:31a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 11:06:53 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::7a) by CO1PR15CA0084.outlook.office365.com
 (2603:10b6:101:20::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Tue, 18 Jan 2022 11:06:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:06:52 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 05:06:45 -0600
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
Subject: [RFC PATCH 1/6] KVM: x86/mmu: Add hook to pin PFNs on demand in MMU
Date:   Tue, 18 Jan 2022 16:36:16 +0530
Message-ID: <20220118110621.62462-2-nikunj@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 51968e1e-7526-46c2-a451-08d9da72a1f7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5079:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB50793CB58B447A6C4AFA8F36E2589@BL1PR12MB5079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXzDPNsa+nTk7GEwl2NtpTsb7hmxATbByoHPKNx65x25d99KELYyI4kyXKRODt7lcea9QLFjcUbxKdraSL1TQ9ko4JeQDpANTWdBRC46p74fz8ITC01ffh98PEbf4jYKi9IjEnHCYAhcZLkT82gn50addN7UIii/ImnJ+fMgiuSby7loDfRiNg6e+RIn1mQlloiVu+LB7a7X6tNgCAgGGkmq2yqkUtt/xT3XSQMZcljAQN94OQM5TNfjxSg7df0AsplWDy7Z31gGRngPUO7oWO9Xoyg7b9tjXF/LKCmXtxebtrvFe2/Ft40IspfkaMKfzTWkXLHsT2lpnsz3OiNU2z3lPwkq+C0FLtOsXN/7Mjgd42OnMVZMbnznpcMT96JgwB/7fNSRXVNWCxi+7shTBxPS909hJga0epAnaSdiuvf81engc0aJn6SDH7S5624N1uIpwEXMNpc/LXe1oWxyKpnq9ZIysZgepDSGsEZ0/fZfKSXyz3SZIifui5VkqT5QTuYD0YBp36eMEeis3GfViKW9l6eHwKIXAzh2n0eGq2VKS1Nk/5Yj6+22Nkv/TPrqzMEpJZvU34ATLk6ap/TJcvUwKi1aWoT3VzporScJygajIb2VX7h5XDAStsE3T0znFROnBGL+8DMHUQNzuOjhZd/4WzbnguHn+QlS9Oz7+jvJQcZoBKJzt/asLTdMfFFsRCE3ELe7J21Qc9ronug/p75hjjOd9bojILicnWgJ7MPy/j3j8cMh06IHeqncdnRiLvGKp6AOy60XYm505cNBb2UPWeS7BgdeqHNzCyCgj6k=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(26005)(2906002)(36756003)(4326008)(5660300002)(316002)(81166007)(70206006)(70586007)(426003)(16526019)(6666004)(82310400004)(2616005)(186003)(6916009)(47076005)(40460700001)(36860700001)(8936002)(356005)(336012)(7696005)(8676002)(1076003)(508600001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:06:52.6405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51968e1e-7526-46c2-a451-08d9da72a1f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vendor code via kvm_x86_ops hooks for pinning.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 2 ++
 arch/x86/kvm/mmu/mmu.c             | 3 +++
 arch/x86/kvm/mmu/tdp_mmu.c         | 7 +++++++
 4 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index f658bb4dbb74..a96c52a99a04 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -87,6 +87,7 @@ KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP(pin_spte)
 KVM_X86_OP_NULL(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0677b9ea01c9..1263a16dd588 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1417,6 +1417,8 @@ struct kvm_x86_ops {
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
+	void (*pin_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+			 kvm_pfn_t pfn);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1d275e9d76b5..62dda588eb99 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2977,6 +2977,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return ret;
 
 	direct_pte_prefetch(vcpu, it.sptep);
+	if (!is_error_noslot_pfn(fault->pfn) && !kvm_is_reserved_pfn(fault->pfn))
+		static_call_cond(kvm_x86_pin_spte)(vcpu->kvm, base_gfn,
+						   it.level, fault->pfn);
 	++vcpu->stat.pf_fixed;
 	return ret;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7b1bc816b7c3..b7578fa02e9f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -467,6 +467,13 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
 		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
 
+	/*
+	 * Call the vendor code to handle the pinning
+	 */
+	if (is_present && is_leaf)
+		static_call_cond(kvm_x86_pin_spte)(kvm, gfn, level,
+						   spte_to_pfn(new_spte));
+
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
 	 * the paging structure.
-- 
2.32.0


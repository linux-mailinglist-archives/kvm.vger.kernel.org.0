Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD3D52D073
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbiESK2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbiESK1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BEFA7E22;
        Thu, 19 May 2022 03:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cqaditm+snspOOXiug5va+2ndtOnGXaCD63nx/NGMstrJL4R7dEus1Bo6glFzYBXxUqpzck7FB3+HMOGdfYJCjXfhYvahg1GHYdEq1VBiapLdOnZcP3QRjxkK9P+wyw/XQQw5T6w3rGI+8FXPg0jtHPFFdoaRK/pa8TFZSm2+NpePw7Yip+byD/ZqmVBDrHdT5O/zNVZUs3/pEFdWKMXxN8DfFLv9TcH9++7uFSVugcSCPfj9GSFKH3o6yhUyQGL6ydsmctWxI0Z31EO6vVvCmaVWRTdqwbXI/cXRK29rfRI5rC3Fvqfn93oYVLRUdGPtGx0npMI6Isr/lk4x/oIHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cNgGsdFWKRWIjCLSQ4nHmgOHOsK+GyL6ZVYxn6pkHA=;
 b=nOyPhExaR4qai4CQu0nwMe66kJ6UX5j72DvQl5V7omDPhHpsO/V56U9d+ZHuok3/lFyp1+I4OBylt30IvuAJcsdAyXl95X4T+kzBpMn6mcLgwcPZ9zKcSy8Ht5sFGFHk1CTTRv/GTmKb68JPNXI+jPoW3jUiVWl3ZdILsKoNaBzP67RmuPoxCqAPm01vqOo5V+MqX6mU7WKCuxtNFFscb+6FyaGx/FI/3B85+EExpRNc+1Du+2nDXbh348T66xeERguw9sG21v2EvabExF8BWMgomrYDPNTaqms17BTQo0jVQRzcC9AuRzW+jDQNse32KOSn+BfmPTUQp8YUXY/61A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cNgGsdFWKRWIjCLSQ4nHmgOHOsK+GyL6ZVYxn6pkHA=;
 b=NNtbvF6NnEcse2H3K4VwLl8YBZ9G+Wu8QVClcohw5+QN2Yi+fckku1GENmXIHJOBImDX0Q/mGrROsxGgNpqAU60AKU+gOTdgIufLoFPZtl57HomIOF6Yzz0C//EuPWSc/6Pbnup4jPcPDRWHX79FqbGXgPzmwEDrpXgxOQV7mzg=
Received: from DM5PR12CA0051.namprd12.prod.outlook.com (2603:10b6:3:103::13)
 by CH2PR12MB3703.namprd12.prod.outlook.com (2603:10b6:610:2d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 10:27:36 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::1) by DM5PR12CA0051.outlook.office365.com
 (2603:10b6:3:103::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Thu, 19 May 2022 10:27:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:36 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:35 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 13/17] KVM: SVM: Introduce hybrid-AVIC mode
Date:   Thu, 19 May 2022 05:27:05 -0500
Message-ID: <20220519102709.24125-14-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 231678d3-52f8-4fdb-2926-08da39823185
X-MS-TrafficTypeDiagnostic: CH2PR12MB3703:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3703EF3BA988727BF6226429F3D09@CH2PR12MB3703.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6f4nMkZkR6fmy2iibHppdYRgPkzKK3FY4C/Uyq7av7r+E5E35f0qEEecITjslV7HyftzDKjTQWOwUWBvygXEnjb9RYK5Ya54fYQN+6iWf/ouDruJgvAOpOIkcxkyFhA3ICuRJYWjH8erY7hd89Kk5GGBEOdIh3GviMD160E8qempqSdp5VwfqYhe6efm2cocPUU9eeyJe4DbTLp+fRc1Xw+RcntozGvHUVnL7JUYNDh3JYw7pYIll9IPmvVT7dhq02RCL5eiYMBcJLJDniaj5AuvFo78SRLY5lbVDDunxyav4KZS1ecBJnfT9sSafKQUr3gZqwjnqCfXw547ETDMI1iHUZKgxl2IQIX1IXo/+G1K6EgB3RUc4+8pRZ99yzyz4xAPBi7d81IGUw6tUxCGnuTmxRNCDbYi2itwisxkJ0OoPJhxmR8uGNly3dxzxNicWpv2S4/xwFhPcrvN6cf5H/vvOUs7iaU7jfGt/zZuIWIcUCwBGVL+Dm08fwmGjbgO1YnJNeUcCV93/YpTujTXjVoD1L85RcUU/KjUQBxAG8r8gRArfqKHdJmISrVxuNbM3ze0bJQWGfeMbpiR/v0vz0CHne5gGvY4cqAPEcI+KVdKQ41GyUvlsHXpeeNBYjZO2HwVusH/4Rz66hZ5F/bhRY/lnwT3NYa5btaqG/rK+i/Gyheh5sOvJjFRIQL6HE69n+Zgi2zHbAbNq0BN03VqJw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(508600001)(186003)(16526019)(8936002)(44832011)(47076005)(70586007)(5660300002)(336012)(36860700001)(81166007)(70206006)(36756003)(54906003)(110136005)(86362001)(26005)(40460700003)(83380400001)(356005)(1076003)(4326008)(2906002)(426003)(6666004)(8676002)(7696005)(2616005)(316002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:36.4751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 231678d3-52f8-4fdb-2926-08da39823185
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3703
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, AVIC is inhibited when booting a VM w/ x2APIC support.
because AVIC cannot virtualize x2APIC MSR register accesses.
However, the AVIC doorbell can be used to accelerate interrupt
injection into a running vCPU, while all guest accesses to x2APIC MSRs
will be intercepted and emulated by KVM.

With hybrid-AVIC support, the APICV_INHIBIT_REASON_X2APIC is
no longer enforced.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/avic.c         | 13 +++++++++++--
 arch/x86/kvm/svm/svm.c          |  9 ---------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c59fea4bdb6e..da03111b05f6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1051,7 +1051,6 @@ enum kvm_apicv_inhibit {
 	APICV_INHIBIT_REASON_NESTED,
 	APICV_INHIBIT_REASON_IRQWIN,
 	APICV_INHIBIT_REASON_PIT_REINJ,
-	APICV_INHIBIT_REASON_X2APIC,
 	APICV_INHIBIT_REASON_BLOCKIRQ,
 	APICV_INHIBIT_REASON_ABSENT,
 	APICV_INHIBIT_REASON_SEV,
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2d9455338b1f..bac876bb1cf1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -71,12 +71,22 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
-	if (apic_x2apic_mode(svm->vcpu.arch.apic)) {
+
+	/* Note:
+	 * KVM can support hybrid-AVIC mode, where KVM emulates x2APIC
+	 * MSR accesses, while interrupt injection to a running vCPU
+	 * can be achieved using AVIC doorbell. The AVIC hardware still
+	 * accelerate MMIO accesses, but this does not cause any harm
+	 * as the guest is not supposed to access xAPIC mmio when uses x2APIC.
+	 */
+	if (apic_x2apic_mode(svm->vcpu.arch.apic) &&
+	    (avic_mode == AVIC_MODE_X2)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
 		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
+		/* For xAVIC and hybrid-xAVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, true);
@@ -978,7 +988,6 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0ec2444c342d..e04a133b98d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4061,7 +4061,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_cpuid_entry2 *best;
-	struct kvm *kvm = vcpu->kvm;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -4093,14 +4092,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
-	if (kvm_vcpu_apicv_active(vcpu)) {
-		/*
-		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
-		 * is exposed to the guest, disable AVIC.
-		 */
-		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
-			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_X2APIC);
-	}
 	init_vmcb_after_set_cpuid(vcpu);
 }
 
-- 
2.25.1


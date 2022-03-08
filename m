Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A9B4D1D7A
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348573AbiCHQlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348483AbiCHQkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:53 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710FC517F5;
        Tue,  8 Mar 2022 08:39:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ko0QfLQ85RtvKlIezHwKXlUPcKXHbFk4S4C1oB1R4eUgkVJgAF5vYDNsm9jgHBvnfvUXhSSP1Sn7mhlG2ShW5NEVeSu2VcX1wmu5IiuLGDtyZExNSQ+4UVUXsXIqAKZLk6cefQoRGuB2xfHGYkmYU96MLN+Sco05XV4xVfaNwqabTID2F02iMOqO1SHSKy6AQBGKImVFwmekLEkYNk9keNHkfybU5qps8AkCqYJ9wYUttxOvQjyAw0/1jtrTJNrJmcT6bzdHVjbHofoFrJo9RpvflJG/6veOnMocFk/lywdT2BpzEu+jrCalLCjoqarwNGsFx4HEe9ybOT7nNp6usw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9jKIQYmPBjF+pD4N/ZWzrzjZvFPiPBlvIA7idNRi70=;
 b=JT81+r6li/JiBtsYXJAhLLVBtMqiPpAlohrHTABf6U53thK7qRdub66PQZvxhK44if/QJdb4geqvwUyY6ROuzgC0G+cgfzB0MUVZ6zJccAfJwg1sjUR/fa9cAMHnVqvzANgDlTPtifynhj+mZU+yYR1zivc/F5G6FuUxzcbM+jwgAr3fz4DjdzpG4vITUHauyJwDRnQxkhC8pfRB/YT4rLZLoXniKwBWtnQkA5EGnQ+SmGSR//YleD3BceeBbL1AfLkY9tbDOAJMgEGoYILIEcRQdBTj/6O2ot9gS3F5EfaofizAnnDBFICiUpLFkcqlydx6msQukJ2XU9M5QmFoeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9jKIQYmPBjF+pD4N/ZWzrzjZvFPiPBlvIA7idNRi70=;
 b=UC2cF78uCm0X/J5uzBY1sPXkwsMre/MS8QEsPRi68fHQqXCGGlJb1BHESwJodfEvZmSQN8a+PoOuoA63lPArIqK8PUp2jCdC3Z0lU5ubxHA/qYqu0jMlG5DwnEGniBQJvTWdM6K+H+Y9pyhoxCdey4Tc0Q8p6zOrEtn6nM9MObE=
Received: from BN9PR03CA0310.namprd03.prod.outlook.com (2603:10b6:408:112::15)
 by MN2PR12MB4815.namprd12.prod.outlook.com (2603:10b6:208:1bf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 16:39:52 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::92) by BN9PR03CA0310.outlook.office365.com
 (2603:10b6:408:112::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:52 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:49 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 12/12] KVM: SVM: Do not inhibit APICv when x2APIC is present
Date:   Tue, 8 Mar 2022 10:39:26 -0600
Message-ID: <20220308163926.563994-13-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c6bc746-ac8c-47c7-b89e-08da012244f4
X-MS-TrafficTypeDiagnostic: MN2PR12MB4815:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4815EDE3E3E77E3EBF164D66F3099@MN2PR12MB4815.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R84l9IoCLIeDyut792/mF1wZ1Va/JU4Mf/WQczHqAAoNYx0hacnaDmLXSGxwI14Ao80YRUv61gMq1bqTNQIWc8zYr4YHcZir6QELAMogm3B5hYHOQgh0FUIyZrM9l+dDSri+NIFaz2ahVgALT+pYGtSTBFNZcRNhWuBy2wCzEBDdLlyRDmOvdjNooZ7G3RbUlOYxPsy6DoVxhx2b3gxfX+/u5nrlPH6iwzAKF7oxLpIzBa7aBE2Ibicnqumgucrho9+Rs11rMuiIyEeJe1NfPoM2MnKaIc/p08/atONPRFZGmXSvtfRZmrKd3XTHptIykPENUo3mUmy45ALEWa9DeIRxfEZPPUNo1wAIUe3wRYeuKth1ElTgH8vGHNS6WhAxioF+OBf9915FqWVn/xBdzfyKN2xiYw50zQPT/bzrXfw65NlR7Knvul3l5B+w/6WjrdD0kSMZoSxFaIokBKXPENyTl2FlADHYwADRFz+D5uF1Zv451rmSRzVJSL0jXtpZkXwQIrg0a3LLRwHqOS7dd3XD9oHgvY2VBMBNZVCRIKsjesYs+Au43y7pwEfRluD8nSFMH+32XM671OT2uMxL8NAY/f0GdcsjM+EknVdJJr40lLs5iB1apJTDRU1vFaFma8dlLCGn7F7aVGeFOST5HpoTW4unuM02Am/KYtIIpge0IWuzDVGYqiJUHpwQbC7lJQb7ZKHxMJn908ML0p7Fqw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(40460700003)(336012)(47076005)(508600001)(2906002)(426003)(36756003)(6666004)(36860700001)(44832011)(7696005)(82310400004)(5660300002)(26005)(8936002)(186003)(16526019)(81166007)(86362001)(356005)(70206006)(8676002)(4326008)(70586007)(1076003)(2616005)(110136005)(316002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:52.3126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6bc746-ac8c-47c7-b89e-08da012244f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4815
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
This is because AVIC cannot virtualize x2APIC mode in the VM.
With x2AVIC support, the APICV_INHIBIT_REASON_X2APIC is
no longer enforced.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 21 +++++++++++++++++++++
 arch/x86/kvm/svm/svm.c  | 18 ++----------------
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 015888aad8fc..e4bf4f68f332 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -21,6 +21,7 @@
 
 #include <asm/irq_remapping.h>
 
+#include "cpuid.h"
 #include "trace.h"
 #include "lapic.h"
 #include "x86.h"
@@ -159,6 +160,26 @@ void avic_vm_destroy(struct kvm *kvm)
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 }
 
+void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested)
+{
+	/*
+	 * If the X2APIC feature is exposed to the guest,
+	 * disable AVIC unless X2AVIC mode is enabled.
+	 */
+	if (avic_mode == AVIC_MODE_X1 &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
+		kvm_request_apicv_update(vcpu->kvm, false,
+					 APICV_INHIBIT_REASON_X2APIC);
+
+	/*
+	 * Currently, AVIC does not work with nested virtualization.
+	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
+	 */
+	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+		kvm_request_apicv_update(vcpu->kvm, false,
+					 APICV_INHIBIT_REASON_NESTED);
+}
+
 int avic_vm_init(struct kvm *kvm)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce3c68a785cf..01384ccdb56c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3988,23 +3988,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
-	if (kvm_vcpu_apicv_active(vcpu)) {
-		/*
-		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
-		 * is exposed to the guest, disable AVIC.
-		 */
-		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
-			kvm_request_apicv_update(vcpu->kvm, false,
-						 APICV_INHIBIT_REASON_X2APIC);
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_after_set_cpuid(vcpu, nested);
 
-		/*
-		 * Currently, AVIC does not work with nested virtualization.
-		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
-		 */
-		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-			kvm_request_apicv_update(vcpu->kvm, false,
-						 APICV_INHIBIT_REASON_NESTED);
-	}
 	init_vmcb_after_set_cpuid(vcpu);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 19ad40b8383b..30fd9c8da9f2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -576,6 +576,7 @@ int avic_init_vcpu(struct vcpu_svm *svm);
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_post_state_restore(struct kvm_vcpu *vcpu);
+void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested);
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool svm_check_apicv_inhibit_reasons(ulong bit);
-- 
2.25.1


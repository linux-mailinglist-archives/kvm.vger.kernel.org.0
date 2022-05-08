Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BEC51EAFE
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiEHCoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387688AbiEHCns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A55BC01;
        Sat,  7 May 2022 19:40:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRPLgBW+R9RfL7jCQuZkyUgDUoEuxHvoPqmeJ+Y0dMSVrcGpbQo4oja3tbPypVLyMLNHnNqxoAvS+ZDAOlPaD+H+yS18q8n3zQC8DfkF4SRnmhLNwzuH8ypYEaWDsngw9FK1diSrXWNOnT1DxGI2ZH/26h+U2FQe97D6E+snIagvCxDvU0+CYFr0sUEXZXuAlpwzPHcNOWJVxeQEJkvXkK4/nkdo+DDgp/KDpUG7BRE7B8tBvCUDlKoXPkVNai3y+DP5MB5i2hizORNSiXs5uAB81hNpey3c60Dni90n6oaHpSNqkFhGyhbK8wt3K+zZ+Z8TjwArP9hZv7+h9E9x2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjqLwa14iWv8y2xU42QG6SvQ9MSFeM4tAai8Pc2+o/U=;
 b=QDdXddGrZgHND7lx7c+IN1RAUNxXXJV3ZzvGi+By19VNR58N/0O0GJuDCVt9D3jznoa8qJ0HYd1HpyTLiTQaaJVAHLUAAEC/FMgYla976zzJQTuBfY9azBBrtV6499cBWYtA2COZwbCKT5xSH7saz6VCFomi3IJcIEJ6lL/CZw5pp62IU4hbtjzmZ1R9Xz3jMN2tI4c/LRvvUXGbpzoI2QF4wo6EbEAvgq1TjWrZ+GS/o1HOtQ0Qbue73FmzaXm9nZttQFvYDALWPypV844wxdt2C6zIZyzpwuw6cKP0wH88k/dvPZ7j736kdJ8IhtWx9hqE1YYV4ilZ1q79rj74Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjqLwa14iWv8y2xU42QG6SvQ9MSFeM4tAai8Pc2+o/U=;
 b=askQ62TifpOkdPx9Mtwkh9VL0fawVu8GDa2eQmsOwU3jcUj3B/UwkmXIihUTm+FwRA4Uw73e5Rx+CzzJZHwKHNZY2NkX+k5KbymG8QUvXfbF92GgQcVT1YeV1eRdrAJXDwzz7SmgPYvwB+dhya7960hQYys88qFZO/6XDJ5xFfs=
Received: from MW2PR2101CA0001.namprd21.prod.outlook.com (2603:10b6:302:1::14)
 by DM4PR12MB5087.namprd12.prod.outlook.com (2603:10b6:5:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Sun, 8 May
 2022 02:39:58 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::7e) by MW2PR2101CA0001.outlook.office365.com
 (2603:10b6:302:1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.3 via Frontend
 Transport; Sun, 8 May 2022 02:39:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:57 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:54 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevisk@redhat.com>
Subject: [PATCH v4 12/15] KVM: SVM: Introduce hybrid-AVIC mode
Date:   Sat, 7 May 2022 21:39:27 -0500
Message-ID: <20220508023930.12881-13-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be7dc8a0-02bf-4b9b-b7f0-08da309c0ad4
X-MS-TrafficTypeDiagnostic: DM4PR12MB5087:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5087AE68B696949A51E3E4C8F3C79@DM4PR12MB5087.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cxWtcuQXON8OwmuAz8IPm3NuuvCL9EPudZdmLvCxLMjPCj7ZazpEJRiX45i8d3CJkK43jBi6y4k1UAjjWW81yWOHTwzN9wfV6Y8mN54GeZuiQTUi9vV7EoYS2jlYPWjK7Wog98k2Yma7A45KZ2GZTbqcY1V4B6ScoCKF3ZXbyArhU/DZlqelClvpWU8AXOMFZkLb0B4aFTfvxcBqAy8+XffDlhPkCYonDX90uku2r0R8gYlOQN1ui/fD6R6yhSF09m1tPX+pu43E3NZz4c0Ud2nRJDdWpZ7Fsw1ulTAov31Mw8v4mkLB098TLCS0xqNoC5L7ADzlK8TUVps1SbOT/a6EiH5mc6zvBUvlkxD7To9Ar7HHsHjoReleqi+nU8SRt/39Xaegq3m4aAK1sFrq6K5JE18ZENYT0qQTdZOCI1Kvr9DPSLEwzVyxclNp3qzTKK1vU66Ts8SSNzRAIoV91DURaMyfAd67Ai92TQy6hHlFUSeimkeSO5VpKvq/EDkQc9J+ibwHIVZ7F3cU3CLUIW79ZPTusWgMVF/IANvfRK1M3sO3OZk0d6thKJtUcYzuez+qSIks4oSfYsX7f7rSh3VNYEAFG/zGfDIZAWRgl7PYAvE44uTdcfbA8NE4ZTPWFehLT4Czvekky5myaLeIJhSwhitvjDhYkSjwB0xMHECIkmssSOnHey8YP+iXmYTo1yo4HMZPckvzoNVSguIfrA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(81166007)(70206006)(70586007)(36860700001)(2906002)(47076005)(426003)(336012)(40460700003)(8676002)(356005)(83380400001)(4326008)(36756003)(316002)(508600001)(6666004)(54906003)(110136005)(7696005)(2616005)(1076003)(86362001)(82310400005)(26005)(186003)(16526019)(5660300002)(8936002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:57.9215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be7dc8a0-02bf-4b9b-b7f0-08da309c0ad4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5087
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
Reviewed-by: Maxim Levitsky <mlevisk@redhat.com>
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
index 8e90c659de2d..ceed4b39b884 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -92,12 +92,22 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
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
 		avic_set_x2apic_msr_interception(svm, false);
 	} else {
+		/* For xAVIC and hybrid-x2AVIC modes */
 		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
 		/* Enabling MSR intercept for x2APIC registers */
 		avic_set_x2apic_msr_interception(svm, true);
@@ -999,7 +1009,6 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
 			  BIT(APICV_INHIBIT_REASON_SEV);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 96a1fc1a1d1b..c0a3d4a1f3dc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4041,7 +4041,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_cpuid_entry2 *best;
-	struct kvm *kvm = vcpu->kvm;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -4073,14 +4072,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5314FE04B
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353351AbiDLMku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355043AbiDLMit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA8555A3;
        Tue, 12 Apr 2022 04:59:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgIk/7EvegiHA+sC3POhNhoNCrnGc4EtEBQTjCKJpnpTtbZgehKLXE2Vi+VbX98gblrRUXjMFHySGb2iHn4wbDRTjUJwNieZHyj0qclei9SVFxOO5Yo65Bof+Myl+gmaMYYObGhJZc3lv9G083Gyp7ZtKzjNGFkhFK5t/v7YgSf23LDESeYq/j6X4+sKX1nhNq45sl5lj66Y/CM7RsOHALAF65FuAOHfuqfu7paCP59LzXkbGelW1ZUF2gyNf3Ij2fcyXaS+0OkEK+kYuqxKikGcRxgLdeHk4GdzAXB/JdoQhZVkYKqXfvSmyKd6jB2bKgrX93A1nsJ2A4751j23Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIlgdLoosU8m/iuMDsCxEW/8h8Pt7kcI3elCSTPiBS8=;
 b=VnItmyKOg6+OAMJREUuRC5GMzvHkss5KwPnA+6cOQyvCpJE7rlbvjB/ttmuHxkOelXGgH8iu8AMNiE+aINJFU0YRgO0J0xFZESXY0D6Tc5DgnWi0oksX0ycHGBtmTmT7R82MD5j5N2cjHicS17n2Kf1lwaALgfkapLiv9cPZGqmbOcG/bSNeP3Fvy5JNK0NwQthPFs/4p521XDCW5Y5iuE/hjF8Bk9gxsEXCMSpxhz48kMxxLL0mtF02fHNdSCHwu0D090NO3oLOF6sif4UWeqbuXZqSXxbQ02Ee6gwHAl4oiLkIGgMj+OHcOzHqFa26hzjEnkTHnOD53zsm5WY09Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIlgdLoosU8m/iuMDsCxEW/8h8Pt7kcI3elCSTPiBS8=;
 b=lnXz5kxmgxDae9wKgKWewtLfPGtJpYgo3xU1XYnHdhLVsiSTX5niHu/3NV+UrKxKO9dIfAS7FTc5CPCz4WFWPje4Rh534q7DUN6EW2V8sLutUufCUyu0o30CkCMfwRzrRwApUton6iAlCeA/NN+o3b0sVNDjAEQtnuXQ6Z4tnkM=
Received: from BN6PR12CA0047.namprd12.prod.outlook.com (2603:10b6:405:70::33)
 by MN2PR12MB2989.namprd12.prod.outlook.com (2603:10b6:208:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:16 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::35) by BN6PR12CA0047.outlook.office365.com
 (2603:10b6:405:70::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:16 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:15 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 11/12] KVM: SVM: Do not inhibit APICv when x2APIC is present
Date:   Tue, 12 Apr 2022 06:58:21 -0500
Message-ID: <20220412115822.14351-12-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b190d82-c098-467f-ddb1-08da1c7bde49
X-MS-TrafficTypeDiagnostic: MN2PR12MB2989:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB29893E740BB4FE925B60FE1CF3ED9@MN2PR12MB2989.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I8dvHfd6LMnko6sXL0cal1q2P/FRubAqHRV4+FajvcC1a4mAR3MFZ998wxPjHlQAoh/j3zCF1reRTpO+2+EjSsMmjvHtHVyFBuHLEerOje3OD48U92uJI/CdPodJQctcwmSoM58K1sDIPm2L6FqoJw4sC4uv03v+e29IAnCs5HihpMiFOsWxJT8f2veTfInCoEojIx6TI/3Wu3Hm+NzIstBgoMs/SxI+LOSua/pnK+77mffveaqhsnkFnCpvZJlsgWywSe3U8DeJJuVNUGS5QKJefujpo9keDpP6Nt+xJF/+UvTSGjZaVWExyzbLoSHJFJFP9ozLacMuSjWsYbdqG+RW0nNE+o5vrcqrv6+qoPECDKnVziCgUHPcPRuAM75cmXRVPQMz2bQhzut6xmJCJ0gqGrbswdab9qPgNV+Yz9jcW6O/x4PjyhZB3moltDeO59zMxcEeupN2+WJX4np5YJazf4X6LB9HDeFn3P+mU64Hw0b6gOPjkgy0vddq/vD2rlTAbOYcgtiyp5vlKP+me0cDdqHEMiw71X/guIaxKmJzCGDwl7KpsHKetT9IinXRMmAzgcxW63b1DdqtpG4FdxzcJfA5LByThIJuDY+EYtRT3aqPEiCucZ7gi8oGlJLTq01zcU2eOWC0jafVioMYChC0LnTeccufgfDYzly/3RvfUkDLCXgCXdYCXRgql63L/fCQEB50Q082d02FZm1n6Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2906002)(356005)(508600001)(186003)(81166007)(5660300002)(8936002)(40460700003)(47076005)(44832011)(1076003)(16526019)(26005)(336012)(426003)(2616005)(83380400001)(7696005)(86362001)(6666004)(36860700001)(54906003)(110136005)(4326008)(8676002)(36756003)(70586007)(82310400005)(70206006)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:16.1659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b190d82-c098-467f-ddb1-08da1c7bde49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2989
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
 arch/x86/kvm/svm/avic.c | 19 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c  | 17 ++---------------
 arch/x86/kvm/svm/svm.h  |  1 +
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 085a82e95cb0..abcf761c0c53 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -21,6 +21,7 @@
 
 #include <asm/irq_remapping.h>
 
+#include "cpuid.h"
 #include "trace.h"
 #include "lapic.h"
 #include "x86.h"
@@ -159,6 +160,24 @@ void avic_vm_destroy(struct kvm *kvm)
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
+		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_X2APIC);
+
+	/*
+	 * Currently, AVIC does not work with nested virtualization.
+	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
+	 */
+	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_NESTED);
+}
+
 int avic_vm_init(struct kvm *kvm)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b7dbd8bb2c0a..931998d1d8c4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3961,7 +3961,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_cpuid_entry2 *best;
-	struct kvm *kvm = vcpu->kvm;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -3982,21 +3981,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
 	}
 
-	if (kvm_vcpu_apicv_active(vcpu)) {
-		/*
-		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
-		 * is exposed to the guest, disable AVIC.
-		 */
-		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
-			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_X2APIC);
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_after_set_cpuid(vcpu, nested);
 
-		/*
-		 * Currently, AVIC does not work with nested virtualization.
-		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
-		 */
-		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_NESTED);
-	}
 	init_vmcb_after_set_cpuid(vcpu);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e340c86941be..0312eec7c7f5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -583,6 +583,7 @@ int avic_init_vcpu(struct vcpu_svm *svm);
 void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void __avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
+void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested);
 void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
-- 
2.25.1


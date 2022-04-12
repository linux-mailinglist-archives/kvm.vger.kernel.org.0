Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE714FE084
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353548AbiDLMlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355015AbiDLMis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE4F1088;
        Tue, 12 Apr 2022 04:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQuoDZVmHxTdUShgDHhgGAtBILuXMJmlmFplzWJLD4uw6MwAzQHE7yV4YaLlVtPIpJwWhwvG4zebd8BNwC7JRvkPF+CPZJa/OoVkb+K6dFKAOV+fKFABCe8K3dw6IobenP5I8bY9uo80AzYzrTQUsbW37SI3HzT1cM9n2b+qzTNxc41PPBDH2aLXGV3Qnb/fVuxRWpbjTuYelJNe6pfZAKHAC75i0PCseX8OFV0dw9w2juboehUVuOU8YiRM7CrEAJwPjDqfKDS8g2N9SVBLO5D+uPGtDi0GdbxVw+xKaCahlAUixm2fS//L8UyIfNbfOEVL0wx2uSKrjFWqhoNwWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UORJKTj+0Ac7xRmmokcm1s6rEllH5PfNQD51lTUlZ8A=;
 b=YuynJMMrU1LrE5SoBj8o9RXUwvldRXCY5hx2/ZTz5CTP2Usp9t0QycAWlcJ8y3/wmZ0Ton0Uye/mDHGsLsKp2eZb/6wYBDXbQGoho/s1tZs0Erx814GnqN/vfRwolYsVB9BOZ1CUyHaKfV1vL6FaCAHuLYW+TP4D5UcI/97T4eHp7QhkJiV8m0y0C1GPZ6X5S/CTCIDDDHqZNt+WGenDCvEugkk2xAwkz/WQB689IVEulyFbNa1jeAmOH72B0z/W7WjtaTKThDiv9wDgOsLuUo691MwEY8in2Wirdaquc/tv6a5UAhAO6+cjiNu6NOj8biQq0GLvdmKyE5yC3uBq5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UORJKTj+0Ac7xRmmokcm1s6rEllH5PfNQD51lTUlZ8A=;
 b=SdE/8SfmtnEKG2XPNVahfNw9I+6J5GLCQnOif7E8c/XwJmUdv3/86SNTEDjk5dsvk+pomw6xLdrjZKjFjQ+4K2WT1+mZAU2hDX1ouDCdmimN5eLaoveXcMe3GIbyGl64deM9Tuxnf0sYNXvUnVpSXHGJPIHfaHkF/MFjdKB2PMs=
Received: from BN6PR12CA0046.namprd12.prod.outlook.com (2603:10b6:405:70::32)
 by SN1PR12MB2576.namprd12.prod.outlook.com (2603:10b6:802:22::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:14 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::fc) by BN6PR12CA0046.outlook.office365.com
 (2603:10b6:405:70::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:13 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:12 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 08/12] KVM: SVM: Update AVIC settings when changing APIC mode
Date:   Tue, 12 Apr 2022 06:58:18 -0500
Message-ID: <20220412115822.14351-9-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: c03dec3d-6ad4-4276-1b4c-08da1c7bdcdd
X-MS-TrafficTypeDiagnostic: SN1PR12MB2576:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB257638D1464C68FA7D2671F9F3ED9@SN1PR12MB2576.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bIDgGtJJCkG4ARSDIPGDxxOKxqe3at/24IUg0URUJ1qir8FK7AtyGPPMEss2HYsVHV6lzASpl41v/pwbhNTsuBhJHLP1VINVkkxNXpQc1CGpGbdfkS86Ko/EixuBrxFYfWpB7A4AH/gdvfs4UDx7UbOLOac5uwP9gYKt02YquCgj8QFzCz5y8WIYaIeJdD+vISWpYpI78/n2JNupfzJX4NSbkGKg7lgncbIXHqirIpQAPvzvF97fugUAakPw95vc2yWqXggewLOCWQ8Z/7XZ8EpY9XIWL73q+drL4b2xH8ts03xwu8LQ5UORKtcKp1XAfuR6ijNd1YVV2mGTp9LBwT9ZHqH19TSsm3y9LnGBuXQDl5IsCADvtQiqu6wrm8WNDVOXDuz5egA6LfWdlyPjPQhfdPgGpzZfBLA/oQRoJ2oTchsDe9upZ4s77Ur3E09RFfmxQdtfyj4/KfanUC7HSpgABy2WTocff/kmM+FKUk2tuIEoPZrzb8FIcst+6vefsqXjK5EMzp0jOcMBcd3aA/EsDzMeaNmaMxkhNXhgjHe0hG9ilNE0Pv8ooHViAxsP5XcfqFLdqLcR7zSxsC6ds84s8Rt/3ezZDbOrbJddACvdza9x/oKt3miS6QTDAL+m+tFCvfezyKIFyPkL/8QnlNLv7WIvs1uWTsZQCadeGn63yYKlcEftunS47d0t3pfbzENC6iTiiIvWYqiTZ5KV5w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(8676002)(40460700003)(8936002)(186003)(5660300002)(81166007)(356005)(44832011)(2906002)(15650500001)(83380400001)(7696005)(4326008)(70206006)(70586007)(426003)(2616005)(1076003)(16526019)(336012)(26005)(316002)(110136005)(54906003)(47076005)(36860700001)(508600001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:13.7754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c03dec3d-6ad4-4276-1b4c-08da1c7bdcdd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2576
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When APIC mode is updated (e.g. disabled, xAPIC, or x2APIC),
KVM needs to call kvm_vcpu_update_apicv() to update AVIC settings
accordingly.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 15 +++++++++++++++
 arch/x86/kvm/svm/svm.c  |  1 +
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 22ee1098e2a5..01392b8364f4 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -616,6 +616,21 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
+void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
+		return;
+
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
+		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
+		return;
+	}
+
+	kvm_vcpu_update_apicv(&svm->vcpu);
+}
+
 static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c85663b62d4e..b7dbd8bb2c0a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4606,6 +4606,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
+	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
-- 
2.25.1


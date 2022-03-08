Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0504D1D8B
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348509AbiCHQk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348478AbiCHQkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:53 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2071.outbound.protection.outlook.com [40.107.100.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644FD517DF;
        Tue,  8 Mar 2022 08:39:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsuyz3FzqS8VKWGhJGIxyj2Zxr8rpsvrPePmxeJ+HUlyjVkS3sim2NvdmuQ/FoRyaYEx3OiKiMOGkA9GE4NO1/mpRTSCQUnNLL9WkiUFDDLTt+9UcQINsAtlBzVzvEeHWuJEU67qk+WZUfI35Skst7PDKcdGtQmnbV1slbsHjTlR21i17fFkeFpNa6u8jQf+rhJnsYehR6jcnqgtJsQCqfDlpVac6UMOOgyT9GdIiauXXK2riZjgVqyl/ZQN5leJ/IKtCGMiy58k/bEFTODSSXZj819uxgBxH5LXCd3k1Nu9KKoXbDdP7HGIvhCmysvWKAdnknenxzT12jMQHO54zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehRyC3GVKVAZRTKpx5jlzsRnBHEmgBQJSfDVkl0CmH4=;
 b=WoNs7byysm4UHpvL0YX+J42K9cZEzLwMarEkUyFOJT+TfPgqpVrABuW/X9RuofwJutqiVc61jg1ygl2NcVUmHznuEVzfr11DJF5ygvonogp4SPJWtUN3uP1H9TDD37k62YXNZfmUy81AGvt+qR/3IszwscuVdE+0kzwadggfsQzaablmHGXR1Q4eEebStP6L6lwFkVNRFBZlNHfG8nk7j8sYfeYkVFhVhtoj3JHRqCx8zpFA5wZZhqDin0JXbpNPTpWaoX9lL84x7EfodoK56bLGLbCCgIAc8pT56Q/vNVRowYfscMNlxxCsOIQDqC/7CqBSzsT14wslwlZW4QsoqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehRyC3GVKVAZRTKpx5jlzsRnBHEmgBQJSfDVkl0CmH4=;
 b=Opb45G7dybR8QLnDWleJmo6qGtQW3674Zzd0UL0w/CJeCasTkcNZVB7L/rzUNfScTE0BeI5GPlT/GcrtmJb2SD3NGWJYd+wr/BbA/zRYq00UlNVDQUOD/Zwmn6VgnxJNS7seOp0mI/LpFCVSwaqLVrch0uxLaYMfK7+Wy58yXTk=
Received: from BN9PR03CA0321.namprd03.prod.outlook.com (2603:10b6:408:112::26)
 by MW5PR12MB5681.namprd12.prod.outlook.com (2603:10b6:303:19e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 8 Mar
 2022 16:39:50 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::e3) by BN9PR03CA0321.outlook.office365.com
 (2603:10b6:408:112::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:50 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:45 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 07/12] KVM: SVM: Introduce helper function kvm_get_apic_id
Date:   Tue, 8 Mar 2022 10:39:21 -0600
Message-ID: <20220308163926.563994-8-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: b510b5d4-69a6-4bb2-437c-08da012243b5
X-MS-TrafficTypeDiagnostic: MW5PR12MB5681:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB56819F747FBC0BC3973EA8D8F3099@MW5PR12MB5681.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xr5bX8wYDfF4pxbSByTj1IzFGnpW9Gm8nHLpkeB1mnpshaEEcOW9yNPSH5JgiZ1W84aKM5PxIvEXFJe3/mfpSPxDMNC2sE+0uKHu1EymBu3J6ijg6UFvAFi+k69EViwrTTRZ6xqZrKgdiTJLmWlvF9hTa6jeg8rjfpg+0+Nx08PJWQLkGy1+YCidDuQqdV3P0meVM1WH+vLJPKaS5AOSYyIVXrKqkHbtK19g1hNkWacK1AIjaeLIs1ZNkM1DdA2p66SaRa4w445rYnD29oiII0BH47TSF6UkBxXVAOhwuMxzc9OGWzMe+KIPChyfFrUsIbX25zQZw8twocF1xbJgpMvtiShjIvYm0f02Sbx6NjC81NyF8FGEUv7ozRfP4AGz088Iec1P7PNBfPNkbAOupge4FyFWIKQ8gUHp8ws2S4822LSs8XXHtQFMYHqzBaxss/1ZvMlMXtNNcWOLmJyyFM0kQu5t/Q+fJbBG94Ce9eO2MSXB77wHGlzVIViS3Yp0lgWM4Reo6QszHuQJydcEqbOpE/uQw54krfDl9gN0mBjYVrPWlL/pjvE+75X6fFofFY+pCajvz5TwLnpWTnnhX6ZeYsNUWOoNP1WL4ZSMAMKEPQs36GAWDso39DZo8tKyu2xy8rKinUprkjzAewq4eSMTqAkz6d6EjVsIdrZhFRpPnglXCdxkOGf2YNMsdIGGjpW9cMetrfTxXJGFlVhVaA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7696005)(70586007)(36860700001)(4326008)(82310400004)(8676002)(70206006)(2906002)(16526019)(26005)(86362001)(83380400001)(81166007)(336012)(356005)(8936002)(426003)(186003)(5660300002)(1076003)(44832011)(40460700003)(47076005)(316002)(2616005)(54906003)(110136005)(6666004)(36756003)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:50.1565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b510b5d4-69a6-4bb2-437c-08da012243b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5681
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function returns the currently programmed guest physical
APIC ID of a vCPU in both xAPIC and x2APIC modes.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c    | 23 +++++++++++++++++++++++
 arch/x86/kvm/lapic.h    |  5 +----
 arch/x86/kvm/svm/avic.c | 21 +++++++++++++++++----
 3 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 03d1b6325eb8..73a1e650a294 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -106,11 +106,34 @@ static inline int apic_enabled(struct kvm_lapic *apic)
 	(LVT_MASK | APIC_MODE_MASK | APIC_INPUT_POLARITY | \
 	 APIC_LVT_REMOTE_IRR | APIC_LVT_LEVEL_TRIGGER)
 
+static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
+{
+	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
+}
+
 static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 {
 	return apic->vcpu->vcpu_id;
 }
 
+int kvm_get_apic_id(struct kvm_vcpu *vcpu, u32 *id)
+{
+	if (!id)
+		return -EINVAL;
+
+	if (!apic_x2apic_mode(vcpu->arch.apic)) {
+		/* For xAPIC, APIC ID cannot be larger than 254. */
+		if (vcpu->vcpu_id >= APIC_BROADCAST)
+			return -EINVAL;
+
+		*id = kvm_xapic_id(vcpu->arch.apic);
+	} else {
+		*id = kvm_x2apic_id(vcpu->arch.apic);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_get_apic_id);
+
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
 	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..2b9463da1528 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -254,9 +254,6 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }
 
-static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
-{
-	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
-}
+int kvm_get_apic_id(struct kvm_vcpu *vcpu, u32 *id);
 
 #endif
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4d7a8743196e..7e5a39a8e698 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -441,14 +441,21 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 
 static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 {
-	int ret = 0;
+	int ret;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
-	u32 id = kvm_xapic_id(vcpu->arch.apic);
+	u32 id;
+
+	ret = kvm_get_apic_id(vcpu, &id);
+	if (ret)
+		return ret;
 
 	if (ldr == svm->ldr_reg)
 		return 0;
 
+	if (id == X2APIC_BROADCAST)
+		return -EINVAL;
+
 	avic_invalidate_logical_id_entry(vcpu);
 
 	if (ldr)
@@ -464,7 +471,12 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 {
 	u64 *old, *new;
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 id = kvm_xapic_id(vcpu->arch.apic);
+	u32 id;
+	int ret;
+
+	ret = kvm_get_apic_id(vcpu, &id);
+	if (ret)
+		return 1;
 
 	if (vcpu->vcpu_id == id)
 		return 0;
@@ -484,7 +496,8 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 	 * APIC ID table entry if already setup the LDR.
 	 */
 	if (svm->ldr_reg)
-		avic_handle_ldr_update(vcpu);
+		if (avic_handle_ldr_update(vcpu))
+			return 1;
 
 	return 0;
 }
-- 
2.25.1


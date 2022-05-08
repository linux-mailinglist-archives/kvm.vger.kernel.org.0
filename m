Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6398A51EB04
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447154AbiEHCoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387819AbiEHCnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC46101DA;
        Sat,  7 May 2022 19:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/UQ6lqeQHcln7VcvXXS98UJ0Uzay9dNNpWXOaIF3pKUkxdnGhg6ggHcZiG4shvgXzHrlvyyQbhA90DDD0i1kkdjb5DxCVxetvRwVqbOnhx8AJnshBF/7FabOhbJy8mIE090zHDnhvkcgtTANkk19qehDYxpd5O9u7ZqSts1Me1AwOpDPAjhUjuBj7zBoyxwIXvZGqnSVT8GcmdNj+CnIYxPWkrUWADuNqWLw7FMabMTgcHDdEy5wLRgHytyTlH2lREo9kXo5H0ixp3pqZwFUx6XOM76oLHA0/+CMaofQ0k+h9s79cdU4tLXcMgpaBitBRQU/N9ux2j12KCWO4JDog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtj28FiXPxbrdc5np/3iL0uaPrU8U/jQ4a4ntnM+95g=;
 b=fGQ5IZIAUFOg+tHpV016+1/TNZoA7RnxvnVhuU7qqpNFWGY9bNhLcsF2NRaEl11SKyIzG2y1XED11KEtLwgV+E0tsXR0gzu91bgd8WiEMRpVAy4YrQ6J8isn0apNUE07oLi4yZev2uU5SXgPZAlk4o3Htk4ACEBYskgbOf7I2xQagKTSu3mQ0mjhDUBCbxFlKVBzgVctn5SAR81W8ITEFLZaxsykQfEbci182AV9fHln0SD6gDlc4sT0Zohx+sFP3O/7YM+jORjZRkC5G2GfEdZpYt9Twk2XPoVZCW+PuTx1tnaVJBhqaFXfg7RFZGdl1E9aL5x/TBHcCs7fIipH4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtj28FiXPxbrdc5np/3iL0uaPrU8U/jQ4a4ntnM+95g=;
 b=X537hFb33hNdks3IWWl9aw2JAhK01TfoxySbGo02nUzYFK9XJ6Fp+YDDUfEmKfj1lNzBUTHZvHPNrVKMLQ86XHzLV8V6fPcPXFAhUqBgDs8dRLCUauWFJe4+2oJL1SXEyH6HcFopu8KXADaZY7bMLim3hKZrXumg+rXEjJRqesw=
Received: from MW4PR04CA0050.namprd04.prod.outlook.com (2603:10b6:303:6a::25)
 by MN2PR12MB4517.namprd12.prod.outlook.com (2603:10b6:208:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 02:39:57 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::26) by MW4PR04CA0050.outlook.office365.com
 (2603:10b6:303:6a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 02:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:56 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:52 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 09/15] KVM: SVM: Refresh AVIC configuration when changing APIC mode
Date:   Sat, 7 May 2022 21:39:24 -0500
Message-ID: <20220508023930.12881-10-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 759f26dc-4003-4aec-f472-08da309c09f9
X-MS-TrafficTypeDiagnostic: MN2PR12MB4517:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4517616CE2B8B32195F5C614F3C79@MN2PR12MB4517.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RgOULHr4UYI57Vw87E6itqMguo5OhfnG7SJRX92kSzd6yICoY31xCnvx3PAAq7HkxQ6K/YDB4NjawbLxR9cnfQTNdfH+F8maeRO34mUYkfjAL4ZdfAv6ULiLaGhTRRiUiFJrJGqq6E2KEsA+BzCkMhqqLzCFumSKjmWfUh1VAXPhojEO2d//0bTTG4hn4fSDeIXijghHSgPukfwuGPM1gszvZqxy1lJKqD7UGgH6zOkBheycjjKnW4xHb8umHpHOMBdalOXJ389sesF+HPmXE6suRqpfI6MMx6cyifZYTx0tsf42cP6gHpjXBM5B3YoPUltSTsjQfVlNc0be9CZwpsmtSXohMMWZCKarYaCoPXLvT6QoEy5Vim6T5NwYOifWfdAlcwwfxMMISl59JfFcj9yd6xxIlLPebukkgLEJeK1T+MYZ/xMu+WFwPL6l46EUQVu56J1Vz4NnnyAUUhcBGw5xdGkV0TwQbUC9iddN8OsWO8Gtmke899WLm+oXBtuu4YABmvETHbGI5uZ7RrfVmFx5bC5KYbyxBnWtW26uFbmCQroVb0fTOjfOnlq5Tr8lDVqTaIOFZdY8BeDagNi9tRUkzZtScmMu+/RfYV9dlaniuztAIvMRrFpzSSwPploxJyxzSRYGGFOjXp45YbQw/NPoBitWUVAzp5lGAFIOkzaLc1q+OF9b4BFjqo0z6SjeMUsC2NG4wVR36oci5niOdQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7696005)(508600001)(86362001)(70586007)(54906003)(110136005)(82310400005)(356005)(316002)(6666004)(81166007)(2906002)(70206006)(16526019)(186003)(336012)(47076005)(426003)(36756003)(2616005)(5660300002)(83380400001)(40460700003)(26005)(1076003)(8676002)(4326008)(44832011)(8936002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:56.4879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 759f26dc-4003-4aec-f472-08da309c09f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4517
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD AVIC can support xAPIC and x2APIC virtualization,
which requires changing x2APIC bit VMCB and MSR intercepton
for x2APIC MSRs. Therefore, call avic_refresh_apicv_exec_ctrl()
to refresh configuration accordingly.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 12 ++++++++++++
 arch/x86/kvm/svm/svm.c  |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 16ce2d50efac..a82981722018 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -691,6 +691,18 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
+void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
+		return;
+
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
+		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
+		return;
+	}
+	avic_refresh_apicv_exec_ctrl(vcpu);
+}
+
 static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 314628b6bff4..9066568fd19d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4692,6 +4692,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
+	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
-- 
2.25.1


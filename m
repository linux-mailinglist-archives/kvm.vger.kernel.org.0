Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A00B519868
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345678AbiEDHiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345635AbiEDHf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:59 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9C4240A9;
        Wed,  4 May 2022 00:32:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFAOt/oa71lbfkU4WDi/LZya9VeRquRcxfWCLFOWlHTe8pzyQLX4HwArAkoy8m4CbTjr8nI9XL3+vCeqceI5stznCA9UkzKCTgoxoZrtNVEiCUDACLh0AZxZupiYT1TEKVPQiOfCPPdn0rpBkjuJjNF2OjqiVwhK/VuF0eV/Y9WXA4uxo9bmd5Fws+8WcEhrgORHrD6oZ+dMFmRmIOVskvw2Mwm4pUWVimDeKvwYwb4b8sXtKQwS3Flomv0Gr++QeA5ZhJmApmX6Y7WD7cD5+1tZHkGjZAegv7LCYnqtcWjBAhH6V+hGb46zLJ9Nb6c4zfFonmShFZRdIXbxTS2eBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Am+hebpbUVWjqbjozJ/EwbcyomrWHLe7poj2ia4Fbaw=;
 b=mkK0doC4Kv25b9tO+rhmatmEKXQ+pzG2DUYTn5MQIyKwnv8CUbHT27bRSieEPycryh6YALLV7CeiqqNSQkWR20LOgmDlgyuMlAyQM+3XZ3GVpUeG2D114QSuQYiLMp4c/81F1RpJ/p+XIZyFCszwy2nMuVVB2iLQqvntfiK1POVOrFwrkRdJ31qzgfeRzaA3JU1YoswjUIBC77SY6G+kahOxVIadxb+wGiYEo1PnRTVw1WTSBvPiSR3H0gBx36HTgCeTsQ9u+V5/RMgM7oN1Ir4W8D/t54ctbhwiM3kdKkuBL/W5Szo2jSo/9H011h5ZZtSRiLz7w1t8CHvRsBvuTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Am+hebpbUVWjqbjozJ/EwbcyomrWHLe7poj2ia4Fbaw=;
 b=qe664NhY9UyxI08OsKTVVHHmY66dFOir3Y4YDSf3ZsWnW1FqTTvsNsRHqxOs2cwRhPRX17dOTVhzQ3Z+uD0W69hD2m+7wfvaOWMH2pl8CJuvCnVj3MpFLTlqcRqYnRLZLbJDVWgQ0BLjuEIBO64Ud2pjpKQaF1LeonjvFd67+dg=
Received: from BN9PR03CA0447.namprd03.prod.outlook.com (2603:10b6:408:113::32)
 by CY4PR1201MB0039.namprd12.prod.outlook.com (2603:10b6:910:1e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 07:32:07 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::37) by BN9PR03CA0447.outlook.office365.com
 (2603:10b6:408:113::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Wed, 4 May 2022 07:32:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:32:07 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:32:01 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 12/14] kvm/x86: Warning APICv inconsistency only when vcpu APIC mode is valid
Date:   Wed, 4 May 2022 02:31:26 -0500
Message-ID: <20220504073128.12031-13-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ecbe219-5c3f-4573-cbd4-08da2da03147
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0039:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB003998A08E94270AED9CFED3F3C39@CY4PR1201MB0039.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+/TozoPPKS6o6GeMRVOwCAz129TuvDqBj1Pi0UDTPeJy3lTCzRMiZKu5u/TwahdLrKqaT/McxoOrtnvEcVsiig3fLP+vXJzgVI7Ha8+iMK9BQ7cBme0BIxdan8Psxnuuv1TRNs12vxfYeW9eB8JacUBWWG7tZCilxjWrNxpq9t0YZqCtcfd1jsP9Pe8BxMBc/ToOQz1EM7UkhDnbq2LxX6arPf7NQVypOdQMiXobL55uZmS/vmVFpLYyn3sVYGlEHYVfvR3DKwHZTNksuFsZLEodLQ0Y7ggnQBFElS978KRdxgLtFvi2E120dO6xXsCZsdS37RU2FTwy3Lw8fjZ45BNwJc9JyK33Z2FXbdWv8kLGn5E65D6ksURpxWbe/DNK4C7mx2afPaBVyvzfiYoHlwXDaa/CMPF1hoshdiAqRjCmANwsY5mgErl3vJAzZRQ5te7AsSFNmJXKIED+gVYFup/Rg1HfXSzhGmLoJsQRz9oB7HXEqtiYSpwhDkSFGaDrYj8MfbTpJ1j7vQ6fuqfGKJzT4wbmiBPdcUW0Tg4bM0AeNuXp6q++iyQil6W/Og9XT1PvFEo6hNlIZ0H6O+SFwe01NAViq7UcfypwaKHKOBEPLV5xbwYuxE+QnLmqv/nP8KYOLvPeXRsvFmrzwVnsZDsFQIaNuWY81sVwuFK58zCa5d+P6116z9noYFpnsXnfcsbS9fg9ddweW6BUgyNwg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(54906003)(36860700001)(8936002)(110136005)(316002)(2906002)(44832011)(83380400001)(86362001)(356005)(81166007)(70206006)(70586007)(26005)(8676002)(6666004)(7696005)(508600001)(4326008)(82310400005)(186003)(426003)(40460700003)(2616005)(16526019)(47076005)(1076003)(336012)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:07.0527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ecbe219-5c3f-4573-cbd4-08da2da03147
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0039
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When launching a VM with x2APIC and specify more than 255 vCPUs,
the guest kernel can disable x2APIC (e.g. specify nox2apic kernel option).
The VM fallbacks to xAPIC mode, and disable the vCPU ID 255 and greater.

In this case, APICV should be deactivated for the disabled vCPUs.
However, the current APICv consistency warning does not account for
this case, which results in a warning.

Therefore, modify warning logic to report only when vCPU APIC mode
is valid.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ee8c91fa762..b14e02ea0ff6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9838,6 +9838,10 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 
 	activate = kvm_vcpu_apicv_activated(vcpu);
 
+	/* Do not activate AVIC when APIC is disabled */
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_DISABLED)
+		activate = false;
+
 	if (vcpu->arch.apicv_active == activate)
 		goto out;
 
@@ -10240,7 +10244,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 * per-VM state, and responsing vCPUs must wait for the update
 		 * to complete before servicing KVM_REQ_APICV_UPDATE.
 		 */
-		WARN_ON_ONCE(kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu));
+		if (kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu))
+			WARN_ON_ONCE(kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED);
 
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C621E70FAE2
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 17:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbjEXPys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 11:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbjEXPyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 11:54:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A71B13E;
        Wed, 24 May 2023 08:54:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9eqooEpZqtYyT16D8s2x1Cu73ouNwitRimCbBTnpGpwggGmLuAIFImnKUZXAA64qujkbFAwhqCYanO7dnKsWqdiTZmkYVKrVGIzixXU7qIUOJT0bF4O15IepqKyRtv4vvb2JbgAisqjkCZ/x85VhFgEoghWUGKy8qZ8mKMXH2IoJhmFO/aGSffzPPKl8ShzT2mNi1g/baQRsttoUOYFdVsXuk1Us53PwGXftUM33tvZ0/9XRgyPgDuylhRggnpvDPfprdJqE6EwHC4mEj1/BllnJXYzm/Nk6CM6cAvSQP1tOMxlBXNipQ2zjPpIJ1y5tWTTdlz+XgTxf8MFsGC2YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A2pih2ZZpVPOGOTfrgDGOtFHCoQoQdzuRfKktlUQQ4c=;
 b=cYr1pum2UYQGpSlf/iiLpj4q3p+WfKNyqfZbve8UJlxQQOiW/J1di3/zUp682Q3vHRl0hOV6SDGn1pOwAAGs7gpbp5HKidKEFg9hsyjfgeucGr5Qajub5RR0Kd0u48HlJlPZvsqP4ggt7epswnG9UmEtiP1YaEOrHZnEcyCciBqwHBYqlghhnVWPShvY1iT6b0BVC8eBFRcLpWp4VWAb/b5wBX+WTa6+V1CLrAN0qjV4VocsMJR7zje62vlUK2oc3Elp9g1+gCcoAzsyLqofPT0BV53GqIVGIWaycWF8fbxZkdWhK1sKXHjPjRUnE2rxFsO20dTBwAlIOkaAtPAEAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2pih2ZZpVPOGOTfrgDGOtFHCoQoQdzuRfKktlUQQ4c=;
 b=T4QJZs7MugYIvANoAYopveEVc6ITPbJzOYxM8oXn4Axj6h3/Jr7fozFmIVYGEzH6QMFUmHNvK4VouV/XldwvDSXhVVeu8dDgH0T3jxJ07KwSn5dnXqr6uny1PKr8xCWny52Rhg21fGrye76/c4Aa6xpZDL3clAeID9rFI4C+CBc=
Received: from BN0PR04CA0094.namprd04.prod.outlook.com (2603:10b6:408:ec::9)
 by SN7PR12MB6766.namprd12.prod.outlook.com (2603:10b6:806:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 15:54:39 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::39) by BN0PR04CA0094.outlook.office365.com
 (2603:10b6:408:ec::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Wed, 24 May 2023 15:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.16 via Frontend Transport; Wed, 24 May 2023 15:54:38 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 10:54:38 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v2 5/6] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
Date:   Wed, 24 May 2023 15:53:38 +0000
Message-ID: <20230524155339.415820-6-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524155339.415820-1-john.allen@amd.com>
References: <20230524155339.415820-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|SN7PR12MB6766:EE_
X-MS-Office365-Filtering-Correlation-Id: 04b80d26-77aa-4256-ab88-08db5c6f2e3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sVBoCyFpbMJSuGT59scEHRBNTpHpvqAg3Mvvy/2y/6cSrXLHi+Z8XmUEFFi0NG92p2Cw8K2kZAus7YqwDhyv9EvCg1jpxfIEeKVY/IiQn/gnaba7uVS9plNe05pwQ79lmt7dhWVObyyK7bCdimFKGJ3x+FNFanU/5PTf53eNHxVnM6zqqaU2aQx1lsRDbAmLG11y2050Da5wmyJhW4eWMQp73H0tE+MnG0+CrESxE9iWhfHsjonfNrpviAnDlBraC3InZyUQF1TR+Veh3aUlBqOg0rMxdSjCLGIy/bOFBKqNokHRmkPX3nA/rs6KtfiugOiQ5VR6jNaDA2rGoO9/pswt/pSQaZSuyr/X1DOTFCIeqH9SLwvdPYoAsyI6AuIpCYQHZWHnNKrvZ1WBDdxyVwKeTQ1B9NL15Y1KVvz7Vj3azHfSB69ACWunUEJFpDk33HDPt/5GQRt/M2urbqXyc1D8LTKkwpqy1K1X56Bqwq3s/bV7nzsSJkT/yegFK9071iN6dqs8TyLr8W9M1nSPe+mkwdKXZyxBs19p+/SNe+2UgHy+heIn0KENTgbinA2PwlN4Ph671WQUg888z7tTAXJnX9PK4Ir+J0xFfsc5Mb2CIbgjqu+cVPYIGb5grYMX3WBPvqtGmcZzDGn9s3lUEJgLz5/O9+FoY+Rut5/8uUJnBGcyCcRT711HEWGeLFLRTpDrpB72sIMq3zu7qR77vFwvX/OJsrbOHn0TeVGt0WbQ6wVocaFKeJI2/vqnAIfFvneIOjulHU/FYScsZbKs+A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199021)(40470700004)(36840700001)(46966006)(82310400005)(70586007)(70206006)(478600001)(41300700001)(6916009)(7696005)(54906003)(316002)(4326008)(86362001)(8676002)(5660300002)(8936002)(44832011)(356005)(16526019)(26005)(81166007)(186003)(1076003)(82740400003)(40460700003)(336012)(426003)(2906002)(40480700001)(83380400001)(2616005)(36756003)(36860700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 15:54:38.9310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04b80d26-77aa-4256-ab88-08db5c6f2e3a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6766
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest issues a cpuid instruction for Fn0000000D_x0B
(CetUserOffset), KVM will intercept and need to access the guest
MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
included in the GHCB to be visible to the hypervisor.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 12 ++++++++++--
 arch/x86/kvm/svm/svm.c     |  1 +
 arch/x86/kvm/svm/svm.h     |  2 +-
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e7c7379d6ac7..8f91376273e0 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -677,5 +677,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 03dd68bddd51..92a7c77bc66b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2419,8 +2419,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 
 	svm->vmcb->save.cpl = ghcb_get_cpl_if_valid(ghcb);
 
-	if (ghcb_xcr0_is_valid(ghcb)) {
-		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+	if (ghcb_xcr0_is_valid(ghcb) || ghcb_xss_is_valid(ghcb)) {
+		if (ghcb_xcr0_is_valid(ghcb))
+			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+
+		if (ghcb_xss_is_valid(ghcb))
+			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
+
 		kvm_update_cpuid_runtime(vcpu);
 	}
 
@@ -2989,6 +2994,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
 	}
+
+	if (kvm_caps.supported_xss)
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cdbce20989b8..6afd2c44fdb6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -143,6 +143,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
 	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
 	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
+	{ .index = MSR_IA32_XSS,                        .always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index dad977747a15..92ac1aefe640 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,7 +29,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	53
+#define MAX_DIRECT_ACCESS_MSRS	54
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.39.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF9663E756
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiLABwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiLABwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:52:03 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2048.outbound.protection.outlook.com [40.107.212.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1356C9B78B;
        Wed, 30 Nov 2022 17:52:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKX1ClBrWdT+0ntj1u8WmLMjKi1PHlDmUUPWko6EaCo7hfKMGDDxfzIKvGUBPUlpstEub/+dM+zhTt84dMrb0oAfH2c356mwv+8E/uAVu0oZ9D1H6rHzQa6cOUXSJlPHrXBBAsyzPSULSMztW51zHRZPwLRzDiiZKOkDjRmt8693hn+CpUcyDZKr5GBHwO3a0iaqYYo0hyAVNEO6jof8PY7faJX5Mv5M06d8EIN3BvIhWTX5VjabsKfbDqEL3eZ5I5SvGWb0k7M/WNGuJTdSNHeNQ06ugF48bN4ANzNhP2jQg8GcUPbTwd41zIaS3U99eryjlbwbE04SU6u0ha5kGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5yn4H32ZvqdpqIu7ciQSfsvPTxyx1+k4NA+Q6Ls32E=;
 b=RGJVEMO/jMDTvXDcKpn86svYRjV4TicYmAzZxvQnjbrJ2tC3O2lDuhxzdI+viZ/0LB0jy2z+Pf8u0tQ02IyyKvVL54RBtG9QwNI9rrYK/GGo1fqHYWo1TnFxI3vp9fvuCnN1TyLWs2nunGOQIgeIlh3qnszuK8QslluhNnvjgiQifcp2K/Pvb6hIxu76OZDFWijlSnvszQkAEAD+KHc6UgXjq0mM+DdAs8xDEliDYultDAYF+OiRJgGqByrAFWmMJaZfTYlS2F1DP111mhhlHwMen0XOX7lmUZ6wE9c+15J/s4Q6REjEiGL/vzf/FQ31qeIsx5Dmh8pWrAvOtSS01A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5yn4H32ZvqdpqIu7ciQSfsvPTxyx1+k4NA+Q6Ls32E=;
 b=3W2DfRvJ71dXrni1No0GaePL0DUFtcHVdG3Mp8aansSJx8Q9Pwh6cSdwqN+EZHSWp/83rlVr/ta+QJG8MlnmvoXEn8PLcGsyUVtRX+y6FO+XbRc283CupHfGq/kqBl4Mlej3p2+mktEz7TgiogEln+ThC9z/ioJZUwi0MLiC5f4=
Received: from BN9PR03CA0225.namprd03.prod.outlook.com (2603:10b6:408:f8::20)
 by DM6PR12MB4188.namprd12.prod.outlook.com (2603:10b6:5:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 01:51:57 +0000
Received: from BN8NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::cf) by BN9PR03CA0225.outlook.office365.com
 (2603:10b6:408:f8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 01:51:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT094.mail.protection.outlook.com (10.13.176.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 01:51:57 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 19:51:56 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 7/7] x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest
Date:   Wed, 30 Nov 2022 19:50:03 -0600
Message-ID: <20221201015003.295769-8-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201015003.295769-1-kim.phillips@amd.com>
References: <20221201015003.295769-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT094:EE_|DM6PR12MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d9001e8-fd08-4790-6bfc-08dad33ea176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILfn7DiucaIT4zbpN12X2zbbMeYqdM1z0nHVhHfGpaPN+lWLDgoYqWdAIxU11RRdppFOvFFwbFf3yfr8hKENlqxNmuRJUUIxbw21H2fTwFPMu3aoxxULSGF3ToCOVHR3vWTNbyDpzemIGRfVWVVY4tViMFOF6sMFPFcGCY/UsTjsdCZM4AoNHnGMWeNYWqQXUba/gLLAJvXMmCjenLxDr8dYEr3Dzmw2mRBnlBm0nhb08FlLLe5cEpHBLPI8hQ6wcrQv53uZxwngegqjxY2yciBsNX/ttqYAkvUyuVhFpQFm0aIzBkzHsjY1i1pkfGuSqzImGQ+Z761IgSwv3/BMMxgstcplp1v/r6axM8raVMAGfW1i7JkUPYBrOBr48L9p1xaZOTf9h8ZvlK0p0z024z2aZXfATaQ7LPBqZkyjsCEiWOZCQoBOHNL0a4PCErqBnbV6aFnvIveKb1l9N1Du3ZQtXH3MsSNMAqKYgdUhSknE1fyNdT/9m1RMCXh9jBVXU/RuGk0Biy05neIU1Hm0t8AagY+Q6ANep62vcBupGe4P8ekF2SNVTHV1r3k8GA/sxQco2h8P0rcDyfIpc3YkCForhPs0/xggj8JWU+a1qn58Rt+/+cXGUMvLmyLbaz7c+xSJNk07XyVcDsqy5+3hB0K33QdkBPhOupdMt+jg9dm86qQG0+zq+KY0bJX1vTWUHN9UlH/6wB47gkI8FzdQ3d9SEUUGqCLlsM1UgSW56b8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(40470700004)(46966006)(36840700001)(316002)(70586007)(478600001)(1076003)(70206006)(2906002)(40460700003)(81166007)(356005)(54906003)(36756003)(82740400003)(83380400001)(426003)(47076005)(26005)(6666004)(82310400005)(40480700001)(16526019)(2616005)(86362001)(336012)(36860700001)(7696005)(186003)(6916009)(7416002)(44832011)(5660300002)(41300700001)(8936002)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 01:51:57.6203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9001e8-fd08-4790-6bfc-08dad33ea176
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4188
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the AMD Automatic IBRS feature bit to those being
propagated to the guest, and enable the guest EFER bit.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c         | 2 +-
 arch/x86/kvm/reverse_cpuid.h | 2 ++
 arch/x86/kvm/svm/svm.c       | 3 +++
 arch/x86/kvm/x86.c           | 3 +++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dd0fe79521eb..0ed3ad3e9341 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -732,7 +732,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
 		SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		SF(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
+		SF(NULL_SEL_CLR_BASE) | SF(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 184614e27d5b..0bf02c02bb0a 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -30,6 +30,7 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_NO_NESTED_DATA_BP	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 0)
 #define KVM_X86_FEATURE_LFENCE_RDTSC		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 2)
 #define KVM_X86_FEATURE_NULL_SEL_CLR_BASE	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 6)
+#define KVM_X86_FEATURE_AUTOIBRS		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 8)
 
 struct cpuid_reg {
 	u32 function;
@@ -89,6 +90,7 @@ static __always_inline u32 __feature_translate(int x86_feature)
 	case X86_FEATURE_NO_NESTED_DATA_BP:	return KVM_X86_FEATURE_NO_NESTED_DATA_BP;
 	case X86_FEATURE_LFENCE_RDTSC:		return KVM_X86_FEATURE_LFENCE_RDTSC;
 	case X86_FEATURE_NULL_SEL_CLR_BASE:	return KVM_X86_FEATURE_NULL_SEL_CLR_BASE;
+	case X86_FEATURE_AUTOIBRS:		return KVM_X86_FEATURE_AUTOIBRS;
 	default: break;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4b6d2b050e57..3ac3d4cfce24 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4960,6 +4960,9 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 490ec23c8450..db0f522fd597 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1682,6 +1682,9 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+		return false;
+
 	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-- 
2.34.1


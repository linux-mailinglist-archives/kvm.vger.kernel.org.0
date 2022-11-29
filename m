Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C8463CC16
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 00:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiK2X7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 18:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiK2X72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 18:59:28 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C260716EC;
        Tue, 29 Nov 2022 15:59:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tho6qxLhGEvUfujh/JFWunWjoT8WPPdugQEcZosdLeWIHsSLCs7CvYDZlpsqoxLjE0ltpxF+JdrvcjB43jJI0vEKiXgFg0+o45RBAYRKo9Ts1NMNABeUdXHU8dFg8EpqtgcFRFhRK4qtKbZCUnAasnHrWBkfqpQ6SRKi5VuxE0UWa+I7ii+dBP1HLAq4VjmnWx9sgHdEtRrifu0QkMNzN43NqrPiHWOQZ3ByfSvu8K0w+MZysOZs4DcOGUkLEuWEK4xvII9e/YeWesHrIGXy5+w5ENnPjsAXZd/e6iUBGN54xPzxXZ/pZ4vW0soLfEFgiV/XW6mMqkFB8QggwyJtjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqdISPSbp7KQRgmhiHQrk4ift4qakd4q5TfFK7+GO+k=;
 b=fCyI+R91IHrlcs884kIw33KFzXKF/Up1Z58q6PjaYDGOfWj6WHTIDEpYX6EsVUmFRlJP9jZsdFfzqj01mFRdcD/DCUjtTBtFUnlbqA1vM0Yvq3gR4bETvD0qa+OR+KFeJQUgHJcCajwqQ1M1rQT8+Vz7t54V0Mb+GEc0l+g4yXZgFYesv0SOpFztyoi8TokhNWJGmWzpxEumG1lFfK/+Xp5azSDV29MV1dlIYOUqBhO/zeGd+M08/KMHGgqaXevcr0IM1Pc1Dm4ahpLy2KVyxo81iBQxezgsn5IS5PmoSbuuNYlVhMqe7TkDJB6UVD2lE6YxZW2GMI3cF+A7W/FsSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqdISPSbp7KQRgmhiHQrk4ift4qakd4q5TfFK7+GO+k=;
 b=c0DwQ+8S/1OoXbv+NBNDRiXH2TOaPHmNW5IB/UDx9cZqOxrlgmMVAT/+yovPcwp4ol3yK/kICppZ8TW1qfbW6M/VRYm+1ssBlUWeDQ3eWviXbb3LGVza+WrhBY8ybXZccsCUdLA3MbhiAalrj8WV4Zcb3BFW6avU8woz1vi4+PE=
Received: from DM6PR07CA0101.namprd07.prod.outlook.com (2603:10b6:5:337::34)
 by DM6PR12MB4863.namprd12.prod.outlook.com (2603:10b6:5:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 23:59:20 +0000
Received: from DM6NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::1b) by DM6PR07CA0101.outlook.office365.com
 (2603:10b6:5:337::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 23:59:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT081.mail.protection.outlook.com (10.13.172.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Tue, 29 Nov 2022 23:59:19 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 17:59:18 -0600
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
Subject: [PATCH v3 4/7] x86/cpu, kvm: Move CPUID 0x80000021 EAX feature bits propagation to kvm_set_cpu_caps
Date:   Tue, 29 Nov 2022 17:58:13 -0600
Message-ID: <20221129235816.188737-5-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129235816.188737-1-kim.phillips@amd.com>
References: <20221129235816.188737-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT081:EE_|DM6PR12MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ff28f6f-31ef-4a1e-5376-08dad265bb20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3GMPWiphxH/KGTboGptpyayl3I4Q6JK5Ff2UCwNAtG0wosflALfBPzHeSGmGuzzJgmAeQAshiooGaDrHF6c9t60MtAD5KdNHutagZczZf+VDHO9LdAj//rtF6dEvv9JF8gpYfTflxvlAZzOwP+AMcgo2qspOit/X1Wg5G3QabehUOLpCqJVQQJEeOoQHp/DV43tF5f8dzNIpeimaKyQ4obiEw4toVletavVzKBjDvaJQyIbJ2D7vUl2TM/BkOmd0sgFhLxtiSDJOH8ObMBu6mGROBTygb9QcgyY3yFapszURiIXhEhu7GXwbuKW9RRQxGdi7daYBe6uBffOiBxveFmq26j6m/laLKJHQY7AT+8hjrexoF3NtKalY7S5kNzjIZs6sCaCiOgnLJj91OqdJaY2hYi/aGsMN4ZUEANVNz3va3sfe+J5xNoSY/7ouS57xtoOfnlyS8RcqyM7zUE2XSC4X1W0sngqSm33Z94TztHlHLcPujY7GMWdQ5NYPbdjskNHjJ4tuf8koxL8qoGP4bRvQzPJ4Pw9WKd926dT4EeiOfhcCOaQcmmDJaIyBHcr2bZIIyLx0bGvZWCV47Dx7TATHLLB29bdhkCSx8nj06RBLP7hE8TsciDwnaew4haCzMk3a2Y3BhH/jDSbvXkFjgS9H6myE5OcH/OxJyIBwRcxVJ3euT1pG+2jm5JPgSDgIOSIbEg+tfLAc3nehqbjnXlnfK2Fgm5KQwh9oNIYXKNk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(2906002)(44832011)(81166007)(41300700001)(16526019)(4326008)(6916009)(36860700001)(70206006)(54906003)(8676002)(36756003)(186003)(316002)(8936002)(70586007)(5660300002)(26005)(478600001)(86362001)(6666004)(2616005)(82310400005)(7416002)(1076003)(336012)(7696005)(47076005)(40480700001)(356005)(426003)(40460700003)(83380400001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:59:19.8553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff28f6f-31ef-4a1e-5376-08dad265bb20
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4863
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since they're now all scattered, group CPUID 0x80000021 EAX feature bits
propagation to kvm_set_cpu_caps instead of open-coding them in
__do_cpuid_func().

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c         | 35 ++++++++++++++++++++---------------
 arch/x86/kvm/reverse_cpuid.h | 22 ++++++++++++++++------
 2 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c92c49a0b35b..8e37760cea1b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -730,6 +730,25 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	/*
+	 * Pass down these bits:
+	 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
+	 *    EAX      2      LAS, LFENCE always serializing
+	 *    EAX      6      NSCB, Null selector clear base
+	 *    EAX      8      Automatic IBRS
+	 *
+	 * Other defined bits are for MSRs that KVM does not expose:
+	 *   EAX      3      SPCL, SMM page configuration lock
+	 *   EAX      13     PCMSR, Prefetch control MSR
+	 */
+	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
+				   SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) |
+				   SF(NULL_SEL_CLR_BASE));
+	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -1211,21 +1230,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0x80000021:
 		entry->ebx = entry->ecx = entry->edx = 0;
-		/*
-		 * Pass down these bits:
-		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
-		 *    EAX      2      LAS, LFENCE always serializing
-		 *    EAX      6      NSCB, Null selector clear base
-		 *
-		 * Other defined bits are for MSRs that KVM does not expose:
-		 *   EAX      3      SPCL, SMM page configuration lock
-		 *   EAX      13     PCMSR, Prefetch control MSR
-		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
-		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			entry->eax |= BIT(2);
-		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-			entry->eax |= BIT(6);
+		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 4e5b8444f161..184614e27d5b 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_8000_0021_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -25,6 +26,11 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 #define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX) */
+#define KVM_X86_FEATURE_NO_NESTED_DATA_BP	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 0)
+#define KVM_X86_FEATURE_LFENCE_RDTSC		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 2)
+#define KVM_X86_FEATURE_NULL_SEL_CLR_BASE	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 6)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -49,6 +55,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 };
 
 /*
@@ -75,12 +82,15 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
-	if (x86_feature == X86_FEATURE_SGX1)
-		return KVM_X86_FEATURE_SGX1;
-	else if (x86_feature == X86_FEATURE_SGX2)
-		return KVM_X86_FEATURE_SGX2;
-	else if (x86_feature == X86_FEATURE_SGX_EDECCSSA)
-		return KVM_X86_FEATURE_SGX_EDECCSSA;
+	switch (x86_feature) {
+	case X86_FEATURE_SGX1:			return KVM_X86_FEATURE_SGX1;
+	case X86_FEATURE_SGX2:			return KVM_X86_FEATURE_SGX2;
+	case X86_FEATURE_SGX_EDECCSSA:		return KVM_X86_FEATURE_SGX_EDECCSSA;
+	case X86_FEATURE_NO_NESTED_DATA_BP:	return KVM_X86_FEATURE_NO_NESTED_DATA_BP;
+	case X86_FEATURE_LFENCE_RDTSC:		return KVM_X86_FEATURE_LFENCE_RDTSC;
+	case X86_FEATURE_NULL_SEL_CLR_BASE:	return KVM_X86_FEATURE_NULL_SEL_CLR_BASE;
+	default: break;
+	}
 
 	return x86_feature;
 }
-- 
2.34.1


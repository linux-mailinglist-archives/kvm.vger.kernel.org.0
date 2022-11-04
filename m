Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7AF61A375
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 22:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiKDViB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 17:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiKDVhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 17:37:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134924E42B;
        Fri,  4 Nov 2022 14:37:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jE1BVwW5Lo8Iv++i3QS3gFPTU//WfmY5uDDMqTcGmvEBC/w8J/QRPoW/B6nD79vOyQwNvFWkvhuZIBcXC2/vLomNfRvBQPs1dSmWKoH9T9cX5L2Kg2F2KxeCt1BxNFFn76EzHYLFFuT+2j4x94AbsknRcrEEM98jTOtF4on7En5KsAJDcJkMXSOoLtDuZx2TQDjonO5cBQVDxgwlWgI7jYq/yiX6C10qSni4kQoMGQS/pfAhjfoxNbpA4m3SOZUtVUyRRWp7hSr2FMP7TRHFolqG6FKEDGhVtvUQxinIcS2cezBa4I9h3jrXRLv/c5MosXZTvSCl+4Sm2u/58M/OHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZ0kXE0od6jlWKn9Xxo7jKgWznf16l2AgDC2oB9wId8=;
 b=DLFZpBLVtir7zdF6GEd+dXFvzVaUiGXbQ5S/S6mfhrjwqgDWaLQJ//c6ZI1fL+b7Jsm0oWXJ++3iZmeV00XknqyGgfQfWBr+sfNZYJuv/D3n8165e9t55XwA2Pm5O+yxASrXq7T62bjODWd9uAdjQeydgA+9FTxfrEeZbniSnUvF3LDub1tUPrYZuqouaVhHUXlt6OxKCDyCdqFjyHLq0X8069TRiboPs6UxpMg8t0f3D+R2WbHh4h4+b5nVvlGTjn/zMEDUFe0Yn+u3CcTdQaxl2UeLqiq55G7ry9AOtjjVDS0MDXltOu2IrgliBrVkEotYwlCIzsJSP6kHp4pE6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZ0kXE0od6jlWKn9Xxo7jKgWznf16l2AgDC2oB9wId8=;
 b=gq9znmdWMzTMv9g6b5HXNYgJiZ5S3Zl7KSI2nwkjaRlh02xZLwYnLL0Z11vRWKuz8SD4R6C3DdfmLgL4upee8J8tmCpPkisxJLqWc1niNpeRymI6QUQJJ7QVpqT95hbI4ONfkH7BHIM/2WR6lUtoMhnk7qNwQ3NwAHKwGY67Gfw=
Received: from DS7PR03CA0099.namprd03.prod.outlook.com (2603:10b6:5:3b7::14)
 by PH8PR12MB7134.namprd12.prod.outlook.com (2603:10b6:510:22d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 4 Nov
 2022 21:37:39 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::c8) by DS7PR03CA0099.outlook.office365.com
 (2603:10b6:5:3b7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Fri, 4 Nov 2022 21:37:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Fri, 4 Nov 2022 21:37:39 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 16:37:37 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86/speculation: Support Automatic IBRS under virtualization
Date:   Fri, 4 Nov 2022 16:36:51 -0500
Message-ID: <20221104213651.141057-4-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221104213651.141057-1-kim.phillips@amd.com>
References: <20221104213651.141057-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|PH8PR12MB7134:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a6aace-8e6e-4c45-2711-08dabeaccc04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LyDUfMw4lUcUA+frW+eFQ4tzW58ZoWijC1hAnUIeG1ZyvRV3nvX+pcTv0XzpEIEaEhItKB5yHuoRJFB+DKhR2ehdEFB0nchMWJ2xNUbXo3csDbv2yVCC8rzjUGFD2VpssMWosQHL8O7rVQ37J7viAJJcss3MnzigMk69ikrAkeXsz3kkiRSp/h12uZ3mk1HzENp3n8QyyxQmmyq+OWqRXX9OUcAvJo/K5wdNg1/+FSRsiZnMVWdxkH0ZEFlK9Ibn01OBcR5no27YkDSvvF74Rzz9FV6wLYJiQBYkAFn1wip6nqvsoaKeHpsJfZHR4xK+jqLnRX98UXaBDRi3PPtd/4eaK44zE95Ouy7HUJZ/Bd4o1ekFHXyRJWGHw+tWxwwiiyE4Gu0fuH2lsD/tjYwyfN/+CWmezrrt+b8BsA2hADXW/RiGklw3zUo5j0LMPFKK+uPg4EY5KQRUIBEEsyd8RWzaxNTZsIo+HohGcRIo3r/vkMckleByyAR9M5Ua47W13K2aXySSc1Ef+WUYhTJTNWrFaYU+TpJ1dXuEx0pFFR1kH4hL6JCzfQQ4jEpWjtkjye3rqRqRSdCgaVd5FNYRTggPDFPELNaaLPZbLE/4JvIytnoCCq9JXMm95UV8/okw+pJi7gHJTX2HPzdWxVHcYodeTlR/egvLcv247tu6DuLjiG81WtqjUDU1yPNSGQRQ+/FftQZQQod2l3f3JmmN9hjMQWgXFoHwRaAvj8yxsUbWvVhxXmhGeXjMjJIh0Pp6cs5z1/xBxjhx+PQtAN+7LQZkUn4rqWegb417fmJWs9xejc9DtjtbdaIoz9b4CK0U
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199015)(36840700001)(46966006)(40470700004)(47076005)(44832011)(356005)(5660300002)(40460700003)(426003)(7416002)(86362001)(2906002)(6666004)(336012)(41300700001)(70206006)(54906003)(4326008)(26005)(70586007)(36860700001)(82310400005)(8676002)(8936002)(7696005)(186003)(6916009)(316002)(2616005)(16526019)(1076003)(478600001)(82740400003)(81166007)(83380400001)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 21:37:39.2041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a6aace-8e6e-4c45-2711-08dabeaccc04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VM Guests may want to use Auto IBRS, so propagate the CPUID to them.

Co-developed-by: Babu Moger <Babu.Moger@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c         | 5 ++++-
 arch/x86/kvm/reverse_cpuid.h | 1 +
 arch/x86/kvm/svm/svm.c       | 3 +++
 arch/x86/kvm/x86.c           | 3 +++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7065462378e2..2524cd82627b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -730,6 +730,8 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	kvm_cpu_cap_mask(CPUID_8000_0021_EAX, F(AUTOIBRS));
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -1211,12 +1213,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
 		 *    EAX      2      LAS, LFENCE always serializing
 		 *    EAX      6      NSCB, Null selector clear base
+		 *    EAX      8      Automatic IBRS
 		 *
 		 * Other defined bits are for MSRs that KVM does not expose:
 		 *   EAX      3      SPCL, SMM page configuration lock
 		 *   EAX      13     PCMSR, Prefetch control MSR
 		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
+		entry->eax &= BIT(0) | BIT(2) | BIT(6) | BIT(8);
 		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
 			entry->eax |= BIT(2);
 		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..7eeade35a425 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -48,6 +48,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 };
 
 /*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..2add5eb3303f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4993,6 +4993,9 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cf1ba865562..3dbeda353853 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1687,6 +1687,9 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+		return false;
+
 	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-- 
2.34.1


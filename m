Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278F1679ECA
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbjAXQfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbjAXQf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:35:27 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7524C6E6;
        Tue, 24 Jan 2023 08:34:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etBK3Ad5h+66VIJoEjZ5ctx1Kfhan/oo+KJN1Wropge++S9lf6KK05bV2zfRPv7651JAgig3AB6D963x764VRwRmtVR9lN6GjleDTOlOD3RIVhHoWMsWzUOOeHnNYn4y3SMqzwCBAKaQTVQIsj7MjRLb7ZLX8UzY+4Ev+tnQfTFDEj08c5u4GdVpt5tg3qnwtjS4HLqP2Q0qBpPjgzORuih+EYsAZt0U5Cm7tY6LxA87t9+wWu7THhjyKX+nq4EuZ+mwFxQXbqREDEAOrabaIC19Lg71xEG1MayhdQPY+hOjiKHewsd3pKkmVYjNKlu2vZtHyfBI13TtwnJfHNqLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QtECui6TSsADqcieXhOUyp4e4/9Pjdylrm4eQBeUgKk=;
 b=HWzLCFLN7K7BcKLwctHFLoq8vHv5G22UGFFXbqcn3OCLpIyz9LpErfWS06ppJVj3xa+gDJyWIHGWs6roQoDJxqdv7zS5/FJTE8IJcSrXTJhPcBAgTH6v4n0g0YHPHyIZspUC1APCja32pTE5RqAMJhsleuL1kIE01T+amZzwhzyg+THkDLbV50OQVp+l99nCdslP+t72Y9HO/iI3+T3nIvkMq2XXD7Yv5ENQm0naDN5PWbHNUU1Ix/lgDWYpgv49bpFFk9wE5IhBDHXLpw8y+ahcQHzp0IErxVouDD4Z2q6IDcJ2Yf3ej8L7rMlIvlvyBrgIdsrc9+8SG93t/nim8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtECui6TSsADqcieXhOUyp4e4/9Pjdylrm4eQBeUgKk=;
 b=uqp/Wt+eXF6peESyiqPurYMC2b/zdu+FBGfMV6mrwqQRVouJpq6Io6tPJvdQmNp/FDiFt0HtJ+QyFsIVDxIwQWaUu6j4MGvU8HmgZ5TdeMwrujV9WecnWv+zY7FkZG9AVBlXtu6yAtQ9PW6xuH2/WmeXq8s9rsSZgkxu6LqF5/g=
Received: from BN9PR03CA0458.namprd03.prod.outlook.com (2603:10b6:408:139::13)
 by SJ0PR12MB5661.namprd12.prod.outlook.com (2603:10b6:a03:422::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 16:34:55 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::ee) by BN9PR03CA0458.outlook.office365.com
 (2603:10b6:408:139::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 16:34:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 16:34:55 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 10:34:53 -0600
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
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Alexey Kardashevskiy" <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 6/8] x86/cpu, kvm: Add the SMM_CTL MSR not present feature
Date:   Tue, 24 Jan 2023 10:33:17 -0600
Message-ID: <20230124163319.2277355-7-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124163319.2277355-1-kim.phillips@amd.com>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT040:EE_|SJ0PR12MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: 04688a8e-a34b-4d9a-e5e0-08dafe28ecce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6enQsfyhcNPGp6Pvsst6UEaym+a67n/oBi9TV0jB0dt/qe/H5YY+6sUESfEtOJr9KOxD0iE3h/KewNSvivNdBsMnryV4h/gOg/SSXCXVS/qgXoy8C/Mm6uMM2zaVnjWzmgzDOEdDOZrey8T94jAVF7RkuksN0d2HNsJ0wiQvOkKtF6r5Wv+LBwIkJ8NOiKAUBrqS6/Eeei+m6HeHSaHNXD2lGyU6dENpnRDhklmwHhM3bt4DWwV4o/vhypz3EfjOxo+Jd6a5z5toY82Ab8klCXbXc30W/7yvxCkb+Nc0mdGRYBYnZqoRgqHsXeCFlMuywK3ES1psvsz8hQFM4MCb+o/ZTQ+NyWCXCuoZXeH5f9KHXNVQ8Ky5csXN5AY6pvY1+0filtCgbkqf8suHDZzpX2Da6RgKjtoj+UqT119f4+Mq08zocArIe12I8fhjHqP2ZP3A1bG0FGpBI3AiEgrsQ/hfi3M1Q7FAnYAkbvi/H5aKfdiVuuN+3qdpIK/o8RC79Lvsrk9KvzSJcI61TW2s+nlhqgGfqLE0LaL7SHm5Sw07HctionVJIPUMgBCzDx23f8ddkOjtyzwaBV7369HvFQfOh2avJa2/9mGmjRjIc3+1ZmTRN6TMUVurw/GeiFkIiZqWGbpQpNlRr+dZH4w+WAT5Ib3wVPPFFRmbc2C+C8bIV3O9ttnVpmIABgdLOVvXrhV3UojmI3FOyu5UX7B6WflZc7shb0iemJbwdIlULME=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(41300700001)(86362001)(81166007)(356005)(82740400003)(7416002)(8936002)(5660300002)(4326008)(44832011)(2906002)(82310400005)(83380400001)(36860700001)(478600001)(7696005)(6916009)(26005)(8676002)(186003)(40460700003)(16526019)(40480700001)(316002)(6666004)(70206006)(70586007)(54906003)(2616005)(1076003)(336012)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 16:34:55.1006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04688a8e-a34b-4d9a-e5e0-08dafe28ecce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5661
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SMM_CTL MSR not present feature was being open-coded for KVM.
Add it to its newly added CPUID leaf 0x80000021 EAX proper.

Also drop the bit description comments now the code is more
self-describing.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index bb0b483dcfd1..8ef89d595771 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -434,6 +434,7 @@
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" Null Selector Clears Base */
+#define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* "" SMM_CTL MSR is not present */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2c403cd33f1..8519f4a993f7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -747,7 +747,7 @@ void kvm_set_cpu_caps(void)
 	);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
-	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
+	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
-- 
2.34.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF9163CC1F
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiK3AAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiK3AAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 19:00:19 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8966DFCE;
        Tue, 29 Nov 2022 15:59:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nljLp/VwNAOpHCmkzKvz+iCkvpl2kM82CiiCj60TYYeubh1wtwTWwdCHREdpESIAfZ9tT0weYXnkuNHp1OWyLiWj61VyOSuHKDmuBaY38qDDCDPGjy9d57AYwrvNtr+2JouSGFVvGby2ukwUIzN95z6n1e5IDXpGiP8SRfG7LjCoq3Z13Zec9kiXGTS1zMGtqbaJVC2rxglPD6RebB/sq2FWGC/Y04UZ8oPeBql1tZtlNrUNBS2ARj//hf5E8Bvw9d1MAjmm2L9b+OW9PPi57VYf8xALBNjRSClG/f/5c347TJ82arAYs15UVQzKoYIRlMAs2wlvmo1WKW7py0KcBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Y3K0hU9pYTi+63DTkfvm/QK3ks7jn2pT5fO03+8bYE=;
 b=Hk88bnsz+iPOctS57THaZ9t6I/mPfsNO/N6bFEl/L+hG2oRR8PlNFCASmU59mEYATZpZPg79pihYBwd1xO9nS4qcolj//cRnSNv+6Cac+1xTg6eUszvpqKdvAJBKXDlyMJuHVdxiDy77CDzvS49Dq/sf1uiVH3VRFUheFWDB58qwLtR8sUmvhcwtU889lGL79fztsY1K6gZlyyNHd4udT20Bvqw4P22ERZUXxeCJmNePaT4ZOV2cwOXg7vs4hoPUpJtFPn1MUotVCd0WVaZmtkeMUd8iYuiKpV/5PCCKQYt/raoa9C07MXAm8G1iT8r4E/BtX/0r7Q9GJZkPzvTZ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Y3K0hU9pYTi+63DTkfvm/QK3ks7jn2pT5fO03+8bYE=;
 b=Dkjok1fIJIOnJ0C+bxoARczBIhZ5PIhpOBb4EaEdXMuMzs+Tcve4IOlEjEIgNI3/dpSQmV3FG5hjFt+fFRwYybSo9q4o/XpjnAJpwV422VbV6FzpyWSIuiggIHG06qGa4HFc0eHdY9Zbz83TsAy5zQoE7n/vdoKJbcjoFGu+YTY=
Received: from DM6PR12CA0023.namprd12.prod.outlook.com (2603:10b6:5:1c0::36)
 by DM6PR12MB4339.namprd12.prod.outlook.com (2603:10b6:5:2af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 23:59:55 +0000
Received: from DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::b7) by DM6PR12CA0023.outlook.office365.com
 (2603:10b6:5:1c0::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 23:59:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT101.mail.protection.outlook.com (10.13.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Tue, 29 Nov 2022 23:59:55 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 17:59:53 -0600
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
Subject: [PATCH v3 7/7] x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest
Date:   Tue, 29 Nov 2022 17:58:16 -0600
Message-ID: <20221129235816.188737-8-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT101:EE_|DM6PR12MB4339:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f95a8e-8d80-4961-fba1-08dad265d046
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +tYXD9jLNun7oszmC59jA2Vsl+iHYWZc6nAWozNbVH74wGVv7F96fcNXPZEeAEhh+JI1alA3InADFryte3jF3wJq5sfV18yx0fznP5w6sQM7vniaC4ozXAPNrZHgVVncWSJgbZgfoz41TkkJLqY+C3sDOrkbNFD2fywE2rjZRyf4cwbhyXeSHUJzLELLngiLu02dCXEa2ugg0d8dD+DtaZ9dsN1LZIzX4PJAgDr1hEQm07eK8u2Artu/HqGoIsSVJzHJulJ8XbkKodUc7wrJ7nPvKvxdEo6l/ke69pigkZMaIv5a2pvFj3yc7f6Item0BQrWmMZn88wkM455i3qlJqCsutuOfQdI6ZrH5WqhbvXo80ojz8EgwwI66UVp/1zo1G0VTTJoWCKfiUxFUHUnnGgKIufXTX+t2ygRKlAhZ/MnTRYnZp1VF1poAv2VcrqH1TdKRcjMjED9yTIlBqpLC4HDfZJ6NPwbmsl2A7OSOSiz2lW0mH8zFFu5q7X7xcprpb5tofdCGjA0qpr8lZlIqOKgOfDr2NdVXlUXAW2ApkYv+YZEzfaLrmV9dGI93ao0stLBhJmFL88Pzz16WCNkr85/Xji22/0I07nw0OCe6KRMdeXkH3P54NhN3fhCKPL3OwIJq54aSfevqtTrjW0vGfjTQ2f7tfldZoZzW3hdS1Huq8nThjCHxn5C1EB+STA1wRsoAaaGARkOmvTwvmcifPsPzyK1PM/ZEEWjXJ+vaiE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(54906003)(26005)(6916009)(7696005)(316002)(6666004)(81166007)(70586007)(70206006)(8676002)(4326008)(356005)(426003)(478600001)(40460700003)(47076005)(5660300002)(41300700001)(44832011)(8936002)(336012)(16526019)(186003)(1076003)(2906002)(83380400001)(36860700001)(36756003)(2616005)(82740400003)(82310400005)(7416002)(40480700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:59:55.3251
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f95a8e-8d80-4961-fba1-08dad265d046
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4339
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
propagated to the guest.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c         | 2 +-
 arch/x86/kvm/reverse_cpuid.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8e37760cea1b..acda3883a905 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -743,7 +743,7 @@ void kvm_set_cpu_caps(void)
 	 */
 	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
 				   SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) |
-				   SF(NULL_SEL_CLR_BASE));
+				   SF(NULL_SEL_CLR_BASE) | SF(AUTOIBRS));
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
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
 
-- 
2.34.1


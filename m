Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53153376901
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbhEGQre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 12:47:34 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:35754 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236774AbhEGQrd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 12:47:33 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 147GMEHn031757;
        Fri, 7 May 2021 09:45:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=0LW5GjAXtRRVZwkKDoHSlJ3Ibe4GdwJsb5u0mA3mWV0=;
 b=mwN18iMEzqASzDA0xnLAlsldc42oKS7Ld+LYtS1A/nfKGWEjcNKZlEcNDT+8kr8S7xm+
 Ix6mY+RGNHcpyQWmAYsrhaEdDzq7Gd8toFmpc5EiFyegAiFf3v/zED/Uk8PCmflfbVzH
 uSnDNPlAyj/JNy5vGEeJCBtKfzsUtTFYHMv2HOqPg6QJLpvf8xsYlOPVqbRjSCn7vB5+
 k/696kiKqoeS0kzuChQbjazDlbZN4jATS/eySQ/oCvUjkC+ROUW5XARUpkhSSAoBv+UX
 thu5C1x+Wazvrz1aGDg6tMHfdZImWAtPhEcJAtEMrsh+D+9xFGuhY3TdHuGn0A7rpaAL rw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38csqr9pap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 May 2021 09:45:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7nADrjX04nafDMhhSkWfVxL4HmS8hz4wCnKYTgVd2uohSk3/MCNWJanQHy9oVrQaVOVjizy4HQ3yXLt4x+Hie3u+VdrvmL33g+xMmUC3VMvSqdACupFVzGUdbbu3IkFfscvoPE7w2FmmuEv/K2Xfx3whLc2sM5+HOSZq1YAAf1qPbu6dJDRGfj20cx1aTXK7J6tpduDtzTTwWrvqlz55s1mOH7L8UrAh3kdt4rgDvCBmS4GjFC++PlvbSdMaFzIAXyDfvkWg65lR3kezJCaL2KVqLyC9oM1dNuoORhFL0UJEcSEpg8BvHkQlSRotNeP0KzPm07jbnyxB7QbpUAkWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LW5GjAXtRRVZwkKDoHSlJ3Ibe4GdwJsb5u0mA3mWV0=;
 b=Ld4PFPrDN6FpwDI8RZRe/wlZl6sblg6p3JadkY+ZOrxZ0HucMEXR2o3BS/Q/zB6qdah3SV03fe73mLGoHuBLoaTYJtYaApY/dHCewE5XYo6BDdV0TqjQtesrVPm7MJc0KF5sjkCO8xVX2chh5iKTyn1/zsV9s+GGbJ8NQGLfMyaicc6KPGie07ahe+9AkbqBTX+94Lje7P+XPAcXhnDH/g1q8KBDpF/spMdaR4E/g+EENklLNTumgStZdE+k92uU4EAUAeuci4GW5ZpFZ8DZZVMNHLrRdVb5AffUBDTMC8F9+ESdBSUZn8dsn2vBMCJrfxTa20+CEQTmy0nODJYjng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: nutanix.com; dkim=none (message not signed)
 header.d=none;nutanix.com; dmarc=none action=none header.from=nutanix.com;
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL3PR02MB7938.namprd02.prod.outlook.com (2603:10b6:208:355::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 7 May
 2021 16:45:17 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.029; Fri, 7 May 2021
 16:45:17 +0000
From:   Jon Kohler <jon@nutanix.com>
Cc:     Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: add hint to skip hidden rdpkru under kvm_load_host_xsave_state
Date:   Fri,  7 May 2021 12:44:50 -0400
Message-Id: <20210507164456.1033-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2601:19b:c501:64d0:a9a2:6149:85cc:8a4]
X-ClientProxiedBy: BYAPR01CA0054.prod.exchangelabs.com (2603:10b6:a03:94::31)
 To BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02F13YVQ05N.corp.nutanix.com (2601:19b:c501:64d0:a9a2:6149:85cc:8a4) by BYAPR01CA0054.prod.exchangelabs.com (2603:10b6:a03:94::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 7 May 2021 16:45:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa6f606d-cb5f-44f3-3997-08d911777e75
X-MS-TrafficTypeDiagnostic: BL3PR02MB7938:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL3PR02MB79386FA5DBCCA5DD4A1D7855AF579@BL3PR02MB7938.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uQED+3U6AIU6irycietPGrJX4f/kdVSaWKJDJMDW88JdcHtuxxNTpZ3v9SfJI0UzCoexqvpLrW9IHH5U8weVEa6vmrujAX43bWJzGeYesSIwAG5nLIBT+sMRHKNvEhgcQJSS82Qgwhcf/n8EFce3xda5gJnz27Bm5jCCFTxxAMMy5PzBSLZFN1NFYqU9kUrzXNwA5EbWTkLIkC1yzHqi5/J+R66bIq6/x13WRlb61d/qwP09QGTeq/3ev784AFN3jXQ7D5KVvAfc+L6JjR9tBdjxyBMpl41YxbcuSyAWrHYyqzEoTCGComN2iWpX7cOSMiQ0tyd7F+p+qZb1eh9xIF9zDxAgDdWwbHruemQhXqOWjlxZITK5wcJ/PfzljkKNyPcbCXqq/JZTJ26fTMNxc0WIRwPuw4cqN2F8hDX1EILXN4EdOz8+1CQaN/0u6/pphBCR6ud/Yn24Cox6gKHOvbietM1CSMiKIvi/B2AT2fdpcjmI1LsMLwOmSSJavEJgq8kwsg1pahZ0NBruSQ5PpKdE20oO4If2CXncmXhG1+TVsKvGoFyBcgEJbIyyO3jIKxOYmy5aNH/C85PwmeZorVTKeS0yvaYQZjTz9kfH7K5ULwOEFp8d4o5Crve1sQf8A2As9bXHDqnBNDjCn5XkDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(316002)(54906003)(6486002)(8936002)(8676002)(16526019)(2906002)(6666004)(186003)(83380400001)(36756003)(4326008)(52116002)(86362001)(38100700002)(66476007)(109986005)(66556008)(66946007)(7406005)(1076003)(7696005)(7416002)(2616005)(5660300002)(478600001)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kOwgKbSM4l0UQQvJ6NCAt3aMwfNBc3CSKkzsNUCeOtRdim8ClSfFjEy1tvp/?=
 =?us-ascii?Q?5R8oBcd85eiRCs6IHMr75S8sRwvh0EudLmh642lZ1iDJ9iDjk9vZe7gUk+h/?=
 =?us-ascii?Q?0ETqfMucy6Hh5pRqo8t/AC7EZfXjxQuiTApCjrE3Wov9R0wBxtrL70NBY9gy?=
 =?us-ascii?Q?uBNua130gVUBlzEU6Jfyo6onztr3VNzAed5hDng5VggVN0P00zhfD2TdvgPf?=
 =?us-ascii?Q?doEZ7i0kIliZ3W105fp4SaiRHdBg/aIQ2pEJuyY0JDMrSmNK2ptG/DX3sZOt?=
 =?us-ascii?Q?KReUWdHhmdRO1IZF+f9Kc7sAgvtV+dbYJi6mvT9hMwW72HtDuD6d4Mc0LNGf?=
 =?us-ascii?Q?yZUG7ZWhghouw3mJMXxekdF9bwH1vTwkAGLXzVADIyv15rnXpv4AKhm/ycVk?=
 =?us-ascii?Q?dVNP8BgTfMLRAaKLEp3yQ07BP78kUrcGNcRYrJK0UDO0MHdw/8jgu75eZy/J?=
 =?us-ascii?Q?Vr4mTgouXRdUOn1HbIrnRlEqrqOTptJdZcKsu/sO0YaKwLPyNUsA63nUdCKu?=
 =?us-ascii?Q?2aRE/s6eZwLyI7iTE3QeSfuMgRlF72koqNoIuA4nDubxEpsd9H7FFujpzhwq?=
 =?us-ascii?Q?8pMl0DSAjH4uWuRSYuITwmo5DOzXuiTazQF5bTbv48QY3FNdzPqXjOtGDqk8?=
 =?us-ascii?Q?chEECSM/v7QcSOnUNgasdb5Iux5dHbdkKnMZe+vSp32Z1LjINPQlpbKIQqqz?=
 =?us-ascii?Q?s12Wgb1JA8lrXuUwbPQJ4RGukHrvt92gftbzYPLNvBhliLSbYo/EbM0zXG3d?=
 =?us-ascii?Q?5OnvNCt6pL7cwSLwCP+SdI3ppVbEJ4ReGkfa6VayM5aspaqTWyGPfVX+2sDt?=
 =?us-ascii?Q?ZoCX1mYHKTJu6ah969RD3EmjPYaTys6rA4h5heEI1g01SGQ0+jYaZdvJoxsu?=
 =?us-ascii?Q?9orw1Uwewt6CKBLMC1/a/O+Zr6QboeCgb/WirPVUJ91ilbbiNgc6gefiUNM+?=
 =?us-ascii?Q?9peXQ0VFIYE9UjjpjUVjJe5QRZtlsWNruglLmSaw5QD10ow/rgia4m2m8/fN?=
 =?us-ascii?Q?agAgY4EYmKB+lL0AlOsVaOrJiSPVUuy6Crn5hh6AqioQXLu1EeEjRhDF7htl?=
 =?us-ascii?Q?S5rau6+Kvb4fUoCaw45a3wLVcGL6HPmO8RAPpp2A9gn5NfaHRYVswxzZstd+?=
 =?us-ascii?Q?ltvX1MkeE3eXSacIveM1d/qRmaFhIK7Pyk0BdI+rkjWzykBXahzcVCnwRSMq?=
 =?us-ascii?Q?SzVsIzRPyTlwwmJADVvYJ7e3HRxw2AJU1A2Kb0U+RVpyIpX5k9Zxd8rq/r7A?=
 =?us-ascii?Q?G/29O0+Bf5nlRRg+wTbjAk6j/iic/i8pQ/RylpmCEwcuuk13Ugiatv07LgAn?=
 =?us-ascii?Q?nEwoK424XjQbtqMqXegRpdGh7DTv8SwfSNkKikOLPlDKHlKdwD0K4MPWWxa3?=
 =?us-ascii?Q?6JNNI+ZZB+t0nxtmQOIVIk0tuOEU?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6f606d-cb5f-44f3-3997-08d911777e75
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 16:45:17.3755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2zxhHs6NHbmc/A+GcJa+V7nbN7yg76UxeHogJQIOQsWPkDbBPF6OEmkMTCz/dT/6aKbbr576ppq7h7y1VFR84bWqa1pzz7JdElo9ngCeBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB7938
X-Proofpoint-ORIG-GUID: 2LyWATrpTl0zdgWaiN3mCI9C_-WSRbkO
X-Proofpoint-GUID: 2LyWATrpTl0zdgWaiN3mCI9C_-WSRbkO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_06:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Reason: safe
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_load_host_xsave_state handles xsave on vm exit, part of which is
managing memory protection key state. The latest arch.pkru is updated
with a rdpkru, and if that doesn't match the base host_pkru (which
about 70% of the time), we issue a __write_pkru.

__write_pkru issues another rdpkru internally to try to avoid the
wrpkru, so we're reading the same value back to back when we 100% of
the time know that we need to go directly to wrpkru. This is a 100%
branch miss and extra work that can be skipped.

To improve performance, add a hint to __write_pkru so that callers
can specify if they've already done the check themselves. The
compiler seems to filter this branch this out completely when the hint
is true, so incrementally tighter code is generated as well.

While we're in this section of code, optimize if condition ordering
prior to __write_pkru in both kvm_load_{guest|host}_xsave_state.

For both functions, flip the ordering of the || condition so that
arch.xcr0 & XFEATURE_MASK_PKRU is checked first, which when
instrumented in our evironment appeared to be always true and less
overall work than kvm_read_cr4_bits.

For kvm_load_guest_xsave_state, hoist arch.pkru != host_pkru ahead
one position. When instrumented, I saw this be true roughly ~70% of
the time vs the other conditions which were almost always true.
With this change, we will avoid 3rd condition check ~30% of the time.

Cc: Babu Moger <babu.moger@amd.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 arch/x86/include/asm/fpu/internal.h  |  2 +-
 arch/x86/include/asm/pgtable.h       |  2 +-
 arch/x86/include/asm/special_insns.h | 10 ++++++----
 arch/x86/kvm/x86.c                   | 14 +++++++-------
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 8d33ad80704f..0860bbadb422 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -583,7 +583,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 		if (pk)
 			pkru_val = pk->pkru;
 	}
-	__write_pkru(pkru_val);
+	__write_pkru(pkru_val, false);

 	/*
 	 * Expensive PASID MSR write will be avoided in update_pasid() because
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index b1099f2d9800..8c8d4796b864 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -151,7 +151,7 @@ static inline void write_pkru(u32 pkru)
 	fpregs_lock();
 	if (pk)
 		pk->pkru = pkru;
-	__write_pkru(pkru);
+	__write_pkru(pkru, false);
 	fpregs_unlock();
 }

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 2acd6cb62328..f4ac8ec3f096 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -104,13 +104,15 @@ static inline void wrpkru(u32 pkru)
 		     : : "a" (pkru), "c"(ecx), "d"(edx));
 }

-static inline void __write_pkru(u32 pkru)
+static inline void __write_pkru(u32 pkru, bool skip_comparison)
 {
 	/*
 	 * WRPKRU is relatively expensive compared to RDPKRU.
-	 * Avoid WRPKRU when it would not change the value.
+	 * Avoid WRPKRU when it would not change the value,
+	 * except when the caller has already done the
+	 * comparison, in which case skip redundant RDPKRU.
 	 */
-	if (pkru == rdpkru())
+	if (!skip_comparison && pkru == rdpkru())
 		return;

 	wrpkru(pkru);
@@ -122,7 +124,7 @@ static inline u32 rdpkru(void)
 	return 0;
 }

-static inline void __write_pkru(u32 pkru)
+static inline void __write_pkru(u32 pkru, bool skip_comparison)
 {
 }
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cebdaa1e3cf5..cd95adbd140c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -912,10 +912,10 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 	}

 	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
-	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
-	    vcpu->arch.pkru != vcpu->arch.host_pkru)
-		__write_pkru(vcpu->arch.pkru);
+	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
+	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
+	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
+		__write_pkru(vcpu->arch.pkru, false);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);

@@ -925,11 +925,11 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 		return;

 	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
-	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
+	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
+	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
 		vcpu->arch.pkru = rdpkru();
 		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
-			__write_pkru(vcpu->arch.host_pkru);
+			__write_pkru(vcpu->arch.host_pkru, true);
 	}

 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
--
2.30.1 (Apple Git-130)


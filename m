Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1C337AB4A
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhEKQFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:05:03 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:1240 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230382AbhEKQFC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:05:02 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BFwOpC011519;
        Tue, 11 May 2021 09:00:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=gsE1XIklwGdRMGIZBrMbuldutWsMKTAO47dYHXtmBSs=;
 b=VJzPQfJZI7yDO3B/QftqdhRHP/MHdJ0ZB4rGFJcwbkwfLjeUeysGD9UjbZmWJX8OU7RJ
 nim9S55lGxk1d1t/Qe5aGdaOU0k3YRNxoezdE/md6N5itTZZt6qcvkyowPB/BK8vileZ
 1/tI5u/m/8PsZ8cOZTC9BUXU624vjAi+v9V6VIRwu0QDr/Z0cO7H9lQsI8yWXhUgg0Ux
 WDrLjzotCmghRWB+MucCqahvWyc9EqEtvhfJJGqieuwsQQNmPx76vQ/H3IclsMoqLNPY
 Yem7q+YAll2GKsGUKxNsKIsC7+zTstycWPne2xc+4d6XCXDnioZRZwbCvxzy+0Zibxf9 sw== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by mx0b-002c1b01.pphosted.com with ESMTP id 38ey42unnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 09:00:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceWcNpNa4Jktc6MjJ3IFLUd3ghPRClvNY5g5OFKdsJGSFNYjPJJRJDrxAFAcUxSIZSjJ/2BpxLCPhwxL6m0Uzb5NVleu0FGNL0OTYfGPPhjrfBUYMf8t3fgWGUZIeIiPBZebQA3wSnp0Jxa17UNPWbcmocvGbxCJRWZxlqzS1pSI7CCf3OidbmtfpgZrHZoRBKQHOFrY0cIYMFEBPLzTOZStTnunSGkrZiuP+1hsGI4nq7lui+RTEOc/ENneGL7XkIoxdLDGqu5yd6J8uBZdomcNjdhbc3GR+dxP7KDmmp0u+KKoRCvvrc/0ZUdfQzniWvmvv/Kgvj8H+Wu6sdZvuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsE1XIklwGdRMGIZBrMbuldutWsMKTAO47dYHXtmBSs=;
 b=ExKO3vB/T3NjY48qMvR//ID6otvZJZSfO6BkhHkfrYmd0a3UWaz2J08Vs1Srd6Rr/7jImFcY1vMOwyMylonAwOczTIvNtitnsH39ynu2taLeebwkK8xt0lTOZ6O2pkZbFnGxR6GAn1vdEpxm1UTKRWBUXIxHqTCYHYDakXhQ7hpGpOZ/57ciV9dMvMibQRdDSP5WBrXSyJb4WukRrirqbrs1P5J50JN5D3jTO6qPoRTIaZ7OWbyxcqVkCP6HdywnkrX2ZoMLE0G/6cDXftAzsG9LQ5VFzQysdK/Au2yOS6Z9OBentljTIIAcMkT4s+j1+kGT2CR06rxPrBb61pLW9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: nutanix.com; dkim=none (message not signed)
 header.d=none;nutanix.com; dmarc=none action=none header.from=nutanix.com;
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL3PR02MB7922.namprd02.prod.outlook.com (2603:10b6:208:351::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 16:00:03 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 16:00:03 +0000
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
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Juergen Gross <jgross@suse.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2] KVM: x86: use wrpkru directly in kvm_load_{guest|host}_xsave_state
Date:   Tue, 11 May 2021 11:59:18 -0400
Message-Id: <20210511155922.36693-1-jon@nutanix.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2601:19b:c501:64d0:68d9:a99b:e44a:d275]
X-ClientProxiedBy: BN6PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:405:70::15) To BL0PR02MB4579.namprd02.prod.outlook.com
 (2603:10b6:208:4b::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02F13YVQ05N.corp.nutanix.com (2601:19b:c501:64d0:68d9:a99b:e44a:d275) by BN6PR12CA0029.namprd12.prod.outlook.com (2603:10b6:405:70::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 16:00:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e58effa2-ebcc-460a-3ad0-08d91495d680
X-MS-TrafficTypeDiagnostic: BL3PR02MB7922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL3PR02MB79228457E2F4A9B9CCDA4F5CAF539@BL3PR02MB7922.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oihqoByFArySNFXMly6JjV+hIQUf0JQ60C2hHHT5wx5Tg0zQe+WQctYT8h6RJGTCh8JjnVLoC1IbRnHOll9AR7YCOEEfCcHfq4P98isFEppY65AKrdvXS4uUWOlJqBcCBCvTiaeQsHUaW4sBpslvAAiAx0co4wJuHktehHw6WKw2QKJCNyG5D8AqkeuIDUerzpzvApK2e2mEvrrNE/eLzzq/lCZVXvoiUDalvd9L0DL1NvV2txd/gP39WLyTaYi3Ht3ji+Bt+YUC2gTsJbh0hl4SIlxFEl76fQq50SzXY9hYsaSZUPlPNPaVGNQWOFJ39cXpUydFf1Ulv6xf0g08eal530D3J5LQP47oB+NoO2RdWklpwjf0UTStpL9q8IP0/g5xeFBBCWfqZgD1ap91/nXDI+1/pP//VWxfcTaY92MLFLK1UyuBSjru3Ysb60MxffABdHnnu9n6j8L9EJKelXzU4S1hszDWItQE3PNNGH9n3zumGcWcxYZggix40dsAYpsFniituF7nn8kzt+6sG8jB4gSuNFPTYAbQ1bXnMGjvePrCnioHuTSgPN2MLxBEqcvYQeyfJq+hdzjch/m8VyDs0oiX4/8eORLp8qe5/Zl7aDohR/glc7i3wX7ZmpLr4n4SqcXw1BwnI0ae4Je0dQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(396003)(346002)(66556008)(4326008)(6486002)(7406005)(109986005)(1076003)(2616005)(8936002)(7416002)(66946007)(5660300002)(36756003)(316002)(52116002)(7696005)(83380400001)(478600001)(8676002)(2906002)(86362001)(54906003)(186003)(38100700002)(6666004)(16526019)(66476007)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKaBBA0luGHZSFgioqQEqokf6jOJh+w/05W2dbRc0NL17Mw79cTvcWk/R083?=
 =?us-ascii?Q?B8G3g3IurvK0xXDPLuQmESjaE/50xaud2/lZ3ver7tC+7SvVUQPdwUk5UTpG?=
 =?us-ascii?Q?ZzQLiSVkshJueRTIA9vdKlvWu4UFhBrwP5CGJRN43UbUg/JrXddhrEPPyiIn?=
 =?us-ascii?Q?ZiEJtk63vAt/I4JHY6aIYEWY8veUXw3zoe/EK8Xt5GVDbOB/NiQxhis2bFas?=
 =?us-ascii?Q?wNcTEFHqpHBBK2VQ9rn7yXHV2FJ1rHCeUU12G+0bjDnazr4FRXvPRJhO0SZw?=
 =?us-ascii?Q?YYOrnqwQlSgnk1h432psMRaUapbAq7EqLJmQKaJyVJw/lkg6vR6tdcziKOL7?=
 =?us-ascii?Q?a9fwaEy71mmtLdNBwo/q+qJHOCJ8KonikQL5i9LWiD9xf8ROy0W6JZs09gmd?=
 =?us-ascii?Q?K0hqPM/gI5IvYFrXFZKamX6m8jmGcFhnwCU6wOZOie4CxF7WvCAJ9X9Xh4ll?=
 =?us-ascii?Q?N/M8IlDbSdcpusMUu4JkSOgvSF1iBogtKA1odk4kFZZPv/HIOm/WZcGTHRoK?=
 =?us-ascii?Q?cni7rQ5LJD5w3Z1Une+I/0LlIvboC1onRX1b0Isq7SQyf94ZErieJXDkfzNa?=
 =?us-ascii?Q?6X3NUg7GfIRrFfR/I//IN7zhqVR1R9QFi4t6IJ/ZaHNwymdH/wrLRSajr5qy?=
 =?us-ascii?Q?cbEgoE+ZP3/q3MjTArVRga+7j9LBYgGqDBJDhJj+DIq0sPuxQ3PWK0jfhtEe?=
 =?us-ascii?Q?iwQWzhtZqK777CMaeAZXlMqBJkz6xEtSpSyO8hO+YHwKSlPSpcvaE9mwyEya?=
 =?us-ascii?Q?QXgxUlqhjOtMjdRo3HEYUDUgtdyeedfJDdD1LSRm1M5CEbTIiyJmcNzBa03+?=
 =?us-ascii?Q?TKmNfeWePwtc32gDZuX+7jDpZxH9pqwsPDmwpwuwkV7UuBBpympXge2y+s1B?=
 =?us-ascii?Q?RHeEVLT+SyE1ej4Ilgfgmut/q0MdzjNf1lg+RuL7aeRt8nXooLq5bfgBuoTD?=
 =?us-ascii?Q?dst6yTUSe4Y0Vdeywqrrux9+tvg66Sn07pwZLSykXGsrUXeS6HPSWkJeav7H?=
 =?us-ascii?Q?mlC4AD+wV5qg+Ru5po8O96eRgC3USr0EYGOIP2nfm+HMtMo3+Gz5yRbdZh5Y?=
 =?us-ascii?Q?oTuEukph9hYltY8kHapFxeOeTHfW+KazTh+CS86tW4oNHqzmOLT7D31y9bE6?=
 =?us-ascii?Q?FGk5FO/kaMBT2b6tLmdliT49E83axwLNzmqKjrN4y1CTgc4tIYgGzVYgl7aF?=
 =?us-ascii?Q?FgYrQs7F6EdTwlAOyPT8rfXAafu//53ENgnxgGMH0aytuhC4mzawyXdwIqsY?=
 =?us-ascii?Q?9FOZ6nadL1ypzmCGViminpSi6FYs28uybq11B/C0q/5f+F2sTI5BwxFDnDA3?=
 =?us-ascii?Q?QRP4Ec5A+8BBUNI7FnfATtEJcCjVkcBWbhoeS2pfYJJQkKWEON6VNQCR76ra?=
 =?us-ascii?Q?52Tt4JrfO7WWkIXzzIyyQLP2PjBk?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e58effa2-ebcc-460a-3ad0-08d91495d680
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 16:00:03.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3OQ6vbNaEsByObLfr4EZmWbhXKa0U/yJ42X6tbqzdz0KDlD7dyuC09AgVmkowZaXtt6+6EGTqM7zbqGCcQ8d0y3hsuMGYXMhCd48bv1i0bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB7922
X-Proofpoint-ORIG-GUID: swhGi_z4gKmUCxTv_oW_rbX1YoL6rK7v
X-Proofpoint-GUID: swhGi_z4gKmUCxTv_oW_rbX1YoL6rK7v
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
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

To improve performance, use wrpkru directly in KVM code and simplify
the uses of __write_pkru such that it can be removed completely.

While we're in this section of code, optimize if condition ordering
prior to wrpkru in both kvm_load_{guest|host}_xsave_state.

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
 arch/x86/include/asm/fpu/internal.h  | 10 +++++++++-
 arch/x86/include/asm/pgtable.h       |  2 +-
 arch/x86/include/asm/special_insns.h | 20 +++++---------------
 arch/x86/kvm/x86.c                   | 14 +++++++-------
 4 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 8d33ad80704f..6b50fa98370e 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -583,7 +583,15 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 		if (pk)
 			pkru_val = pk->pkru;
 	}
-	__write_pkru(pkru_val);
+
+	/*
+	 * WRPKRU is relatively expensive compared to RDPKRU.
+	 * Avoid WRPKRU when it would not change the value.
+	 */
+	if (pkru_val == rdpkru())
+		return;
+
+	wrpkru(pkru_val);
 
 	/*
 	 * Expensive PASID MSR write will be avoided in update_pasid() because
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index b1099f2d9800..20f1fb8be7ef 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -151,7 +151,7 @@ static inline void write_pkru(u32 pkru)
 	fpregs_lock();
 	if (pk)
 		pk->pkru = pkru;
-	__write_pkru(pkru);
+	wrpkru(pkru);
 	fpregs_unlock();
 }
 
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 2acd6cb62328..3c361b5cbed5 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -99,32 +99,22 @@ static inline void wrpkru(u32 pkru)
 	/*
 	 * "wrpkru" instruction.  Loads contents in EAX to PKRU,
 	 * requires that ecx = edx = 0.
+	 * WRPKRU is relatively expensive compared to RDPKRU, callers
+	 * should try to compare pkru == rdpkru() and avoid the call
+	 * when it will not change the value; however, there are no
+	 * correctness issues if a caller WRPKRU's for the same value.
 	 */
 	asm volatile(".byte 0x0f,0x01,0xef\n\t"
 		     : : "a" (pkru), "c"(ecx), "d"(edx));
 }
 
-static inline void __write_pkru(u32 pkru)
-{
-	/*
-	 * WRPKRU is relatively expensive compared to RDPKRU.
-	 * Avoid WRPKRU when it would not change the value.
-	 */
-	if (pkru == rdpkru())
-		return;
-
-	wrpkru(pkru);
-}
-
 #else
 static inline u32 rdpkru(void)
 {
 	return 0;
 }
 
-static inline void __write_pkru(u32 pkru)
-{
-}
+static inline void wrpkru(u32 pkru) {}
 #endif
 
 static inline void native_wbinvd(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cebdaa1e3cf5..3222c7f60f31 100644
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
+		wrpkru(vcpu->arch.pkru);
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
+			wrpkru(vcpu->arch.host_pkru);
 	}
 
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
-- 
2.30.1 (Apple Git-130)


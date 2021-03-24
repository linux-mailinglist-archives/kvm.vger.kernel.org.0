Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA303347DFE
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhCXQo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:44:57 -0400
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:61165
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236526AbhCXQoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l199L+V4Ge089NWVG3wErxFWsgGricRNfA32GAN99V4ExFD7+T4mnGZkqpzWpvoouy6ASAJJKqxbZGK14NGV0pWgaiUU+PJq4fSrd0S3198o39Ddy0kOsnwXZSQDs5sQHzLg4XabxdUArBAAhjhm1HKbXyne5/j7xJrBiZYgIfj1ghlcsEhKULuIZJsI0nIalUlqzo4+yv+ddVcZxTxJY66HjgZe3XyWStnTGPCUcWmSQSPPp0qah5qiCHhVjWSbcSi4td+rtfJvdF2dlDF37kapVuGdspqpxt5xmApZQWRXsaObm+QzglxBWrbxeYnxP3+NNjiKDpExYFuVZdcE5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2NZ/x5l9g3J9T9OeEShBfA14lpT0Z5ht9s1VtNtVes=;
 b=ETBvkNSVh6HU5pnv62b/psTkta9CF+z9Yx5+kuZu92c9PA2lU3jnwpueV5fSzVbcUuDQ1ROWMjm7xFVZaEEii+sIQofhWHyV7fzvlfza/Yl6O3rFk6crc8dB5P0jlxr/mDXcoGli6+T16xEKtrLgzEQAa1X98QTPd0ItvNbSTowhtlTgM1npnZQ/RA/hbfpVs+HqnnslqUk28T+6lBTJkONXMM5cmcdL8gtDp6zVuDDnkpEdR9coXhBAdQQx4RXjt26GpgS7AsBJ4rWC6DArg84YBtr0DP1qANkLY7qaIpGiKvsnOSVlBH1E+Mimhei1rZYSNfiDkPYLBaWUTNN4Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2NZ/x5l9g3J9T9OeEShBfA14lpT0Z5ht9s1VtNtVes=;
 b=a4NAEKpq0q9JqBodYpaLTrEy1q3xXDEn2zc4pj0d2I2h69k1n0ptpUrxe6DWdLVP/hAngWbVL7q+oNwisWyb7+hS7BAvhTdAGT/JaoZg9crXEpUthSFgoSa1/JeXZIKwhrhVi1ipBnuSbmWM7ElTtUgg/R6bwP2UoJPu0qHYVZQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:44:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:39 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 02/13] x86/mm: add sev_snp_active() helper
Date:   Wed, 24 Mar 2021 11:44:13 -0500
Message-Id: <20210324164424.28124-3-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3b8ae719-fcde-4577-58ff-08d8eee41dc3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2447EEA587502202A498183AE5639@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Qf+YoSr5ur7bPrY5YoUgrWmqDeLQPTntdstwKnjGjyL25uAF7UYK0IYOlCT8Te9Qh/LxF5FZ/eA4EvwwvDZm2xQ1CAuWDKt8jU4eSvQ8h8nMVv4VcV1LJHtcDsiq7xHvGou4hJD2pQ2YCY19C3YXfLgHn1z6bURbHnhkp5g/lIOufHH2BakhyQJwFolWTq6/tql1XHXtYsIA3dU0Zq8+jlaiA9F5rQ8mziCw+tFFGnRjAYy5k2WbuyYYEdVjNr/e90p5lCfVVhrWy9bc+nApvEXiH6x1RvI36NDebY6LUbxTjI9uUghdiAAZKDNsi0LuRH8BR8TgvpAtFRNhKYM4EN197L5jbX1W7LROJDOGMzBquklelZ5C/VprlkWyO6sA6R5N7LN2CgKg1AQfn9nOUa/B8a+Nelz8kNDYaEmGFcXAvEDC1Ge3txnFKgUJZ5yf8YgMiG73bc+nvBtvih8I3TZIHt37HIuSAvxKJv14DyoFfP5NAgcoqzIvrzBZ3NgTkrE8aIkNq42fLGHItoeZNLr/3i+RFT9Zfseph417tN/LEuFVPHkhjXMjddXE4cKH/VghlciMQ1zfbztIdW6Y4pvGErkDMnMBeUlTfxhHTBzG4uiA43Cz2JoAichtBEf6xYhHSJb1FYPPCsP3xrOfdAoZw58XEQc3Iz11i1q+po=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(38100700001)(5660300002)(26005)(44832011)(36756003)(1076003)(54906003)(8676002)(316002)(8936002)(4326008)(956004)(2906002)(186003)(6486002)(86362001)(7416002)(2616005)(66946007)(7696005)(478600001)(66556008)(66476007)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Kj0AFu9969HfJLrKBn1vT6GhX6xdeub9uV/+wJeWsAHM6tQ3yh7/f1hE9AGX?=
 =?us-ascii?Q?QBBXz+wzxzZ/U5ZWqxzqHqjHfl6ro9d31pOn1ilurulPG5mvgJxBciqwxmm2?=
 =?us-ascii?Q?dCJ4imGeKQLLIRYjEpeQ6dI6brcarMHGM62lzOP8DDHRGCZM09+RpUyaKLKM?=
 =?us-ascii?Q?QJvwHDt6XrVTjL0jyeVXKMI79m6u4LFUgeQZDGPRZcZZLz0dyC9y1jaKy8ob?=
 =?us-ascii?Q?BVMJJAmPv3u5Nn/r05p6kze3b0qG8T32ko5WbdRKblLk0TZQbz6GFzDffpRJ?=
 =?us-ascii?Q?Hy2XqkCADUc9VNtvhw1lmYsuqhfWm6LD8rjNkWVMQ+cM8Iq6rsw+lLJyZ7LZ?=
 =?us-ascii?Q?dGK+jPbyusa614DJuEwkc7D5jYw1qrRdLWL8/Gfr5wiEBBm5mhJqjXqs44ZQ?=
 =?us-ascii?Q?UicT0v/Xnwxm+XHoBxO9T/jD012qIS1GJD+7LkZLDuhL3zsIeFecfVHkoHqv?=
 =?us-ascii?Q?ok2iktsVWUGpM40lvbppagmNv+sSsIEbgkHdG2SkyD/gpWRF66VzYzuoPR+c?=
 =?us-ascii?Q?YzGQkGW+k3m4e0ei5WLNjqanyb/XNSbfUDSXBryaEoMR02SY9DAPCXxqfc3y?=
 =?us-ascii?Q?BFCzi9CzDQBrBUzLRYmYkH805aPW9ba5Udd6wmqoXwgYOOFGraBTG9dg3qsy?=
 =?us-ascii?Q?ywy3yc8UxiFfoSwnUFmr+P+24sdf1uXUNol6UX9gDbA5n9Ywd1ZV1RRNTnfb?=
 =?us-ascii?Q?qVG51eSItcjiTfUxTIi2IgpYvIIwaHr7pxunaQBNK8lFoBR2pZkviKL4b74D?=
 =?us-ascii?Q?PSi8lwSfAB0wD5GpdudRlKJjZ0LnZuG/ciqBs3tZjS7ODWuqrnENlO4nThiO?=
 =?us-ascii?Q?tZiFy1SVTsQPiLyvRgrYT96coAqWJxxcHrMTn0FEyWz/p1o+HnhS+2aYzNBl?=
 =?us-ascii?Q?pW0naUMYCwjfS56H0Efe2GIBKDqfUxEN48obqzK45McsaLXg8QB39YGYUwbb?=
 =?us-ascii?Q?fEOEBU8lestcJiInYSJlSwt00Pyn5s5aO/yoUg0rnwBcWnTD6H2zP0su4qBB?=
 =?us-ascii?Q?MVi4VCr1/C1waE8m/EpvUY+VDpiep3UWo/F6vj6aRC0kaLH7xllH/syp9dtB?=
 =?us-ascii?Q?ueuqFzvZdmZH7CfhtC0q0zgr7siIHb4cirLVQztmLvBcMenn8M3OOoag7PZV?=
 =?us-ascii?Q?hMpIUthQgl5Qn7LTOemK0J/zHLMl6rHH6i0ALWmAlwdIwXThZKYvTEmlEmiL?=
 =?us-ascii?Q?voqn0RLGTjthYpWaVvwX3bVEe88wI519thjTTwnRF6cPe62dLDHwu0K3QjXb?=
 =?us-ascii?Q?l5ym13a4v1ownEEMe9iK4ynL5eMQn4mFR9dff+7mS8mXgrOVG3wdKcv2Gcuo?=
 =?us-ascii?Q?AWFe1IBi6BlUgFpS3v3Iy4cx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8ae719-fcde-4577-58ff-08d8eee41dc3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:39.4119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xbMaWGVs1GKQ/8ilnzFRxeWWfHx3x6t0e9vnJYW4ZqPOXV2ch/hrcfnJZwOOFfp6wRD1HKsc78N7IoEhlmiSjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sev_snp_active() helper can be used by the guest to query whether the
SNP - Secure Nested Paging feature is active.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h | 2 ++
 arch/x86/include/asm/msr-index.h   | 2 ++
 arch/x86/mm/mem_encrypt.c          | 9 +++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 31c4df123aa0..d99aa260d328 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -54,6 +54,7 @@ void __init sev_es_init_vc_handling(void);
 bool sme_active(void);
 bool sev_active(void);
 bool sev_es_active(void);
+bool sev_snp_active(void);
 
 #define __bss_decrypted __section(".bss..decrypted")
 
@@ -79,6 +80,7 @@ static inline void sev_es_init_vc_handling(void) { }
 static inline bool sme_active(void) { return false; }
 static inline bool sev_active(void) { return false; }
 static inline bool sev_es_active(void) { return false; }
+static inline bool sev_snp_active(void) { return false; }
 
 static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 546d6ecf0a35..b03694e116fe 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -477,8 +477,10 @@
 #define MSR_AMD64_SEV			0xc0010131
 #define MSR_AMD64_SEV_ENABLED_BIT	0
 #define MSR_AMD64_SEV_ES_ENABLED_BIT	1
+#define MSR_AMD64_SEV_SNP_ENABLED_BIT	2
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
+#define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index c3d5f0236f35..5bd50008fc9a 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -390,6 +390,11 @@ bool noinstr sev_es_active(void)
 	return sev_status & MSR_AMD64_SEV_ES_ENABLED;
 }
 
+bool sev_snp_active(void)
+{
+	return sev_status & MSR_AMD64_SEV_SNP_ENABLED;
+}
+
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
 bool force_dma_unencrypted(struct device *dev)
 {
@@ -462,6 +467,10 @@ static void print_mem_encrypt_feature_info(void)
 	if (sev_es_active())
 		pr_cont(" SEV-ES");
 
+	/* Secure Nested Paging */
+	if (sev_snp_active())
+		pr_cont(" SEV-SNP");
+
 	pr_cont("\n");
 }
 
-- 
2.17.1


Return-Path: <kvm+bounces-72419-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JEvHhEUpmnlJgAAu9opvQ
	(envelope-from <kvm+bounces-72419-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:49:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D395F1E5ECF
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7440135E8A3C
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87CD386579;
	Mon,  2 Mar 2026 21:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nsvID/HS"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FCC37E684;
	Mon,  2 Mar 2026 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487387; cv=fail; b=I1DzknJD7b1KCtqyW+HJAEs4yoAuENym5SPxwJs4Kj0X5Dq95RXvwBimknQl0cXdx0DW67SXt0zy/w7zx5b+Q0AMsdrgRYLsYKFBX/reGxjEDw+LOd5FCnxnb2spozAg31ZsNEZQq7F5ZZL7+WLwOsmvgXSZiInudShT/xd06OU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487387; c=relaxed/simple;
	bh=A5nTh1Q/yeTIiuuOA9ZRPWr3xQg3fDcq++7/5lSOoFY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5PUym2qJt0ClbNQ7v1S2Ua6RM4eiBnbLVyGpOP55q9McL061plMTnB3SN0E54UDurJfHk08Vs+TIYwvh/wLLaEqLacn6RKAB01ipBSdfXbxLP27WDEAn5FUPLgsJUfcNt6HCGhjJpvvaAv/Nno3x9dhgrs8h8pLQgKwgGO7jkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nsvID/HS; arc=fail smtp.client-ip=52.101.52.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aKZpokdbEj5sE6yPX+tbxExS0sh6cLmCQdJafD1RtUC2utnMWBnPlY8mbLmIkkqDNGzH1x3gQXcbY4uvnYEDDM1SGLVaU0RIN0o6q3iWKd0ub9ADrxulGZyS3q69H/JlXkgEG1OmEO7gYsHgj8E77daFPJ2Xs5xCJsuoE1BqLVk/AVHotF1Bo3km7tMzIAXmMBX/+HJTZ+JJUkfSaK2iyj9cSkC2tW4Bsf/wjyzm13GjK+cE41rlwVd34E1lvTpMVH2mkPKctoMcDPBd2Px58E6BQoEhrQ2h1cwUeq+dswkjEKWeDzlnf2Hpb0upsKTWBRLfFNO4Ls+iZsInP8OQbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdmp5XSUVMo03xR1wll8PiZ3Uq755AHE5wtx2cyGIpc=;
 b=CTh4C8Vi9FnIi1oxbVvuED3Kkdvj9BUsfO3tw5UbDsUydXA6gPYOThay7zTQHwaOCJ4hiL1aSn2Ggur+Ig3kz0nZY9ywlWoiN3QqPGhDNYwFtM19rjDKj+qjcLDFrMzlkvhCG2muE2Wy7fmaOriAyCEqEIFZWJRSVvMRxTNSrHqDo/QjMI9dy2M7TTpO1kb2FIahfrt94u+r5oGbCZ/qpy3ZIb5uc8TA/JmcwanxsY0tV8XlEkXF+vViaKYQCj6mvYTtmi4aH7Wiwwwhvv49XoL4oPHeD/1LxIxfYYMbWO4f4yhW9xrOz2gLullhOm9oNOWNDuKSKscE946aJhVStg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdmp5XSUVMo03xR1wll8PiZ3Uq755AHE5wtx2cyGIpc=;
 b=nsvID/HSrnAINQRLUef749nySlrQcfC0ZrcQWdwdn2RTUXRBgv8vgFUVXMEWNHEp6GnUEyjXm7ZKaSqG1J/KVBZ0mVqZFHzo4E38LH5w+Bpwg47Iu681IjQLWMPaKj6EITLhZXJwZ0vRkvoj3COvchKmX4XMZsXXQfEt10lEwMs=
Received: from DM6PR08CA0060.namprd08.prod.outlook.com (2603:10b6:5:1e0::34)
 by LV8PR12MB9182.namprd12.prod.outlook.com (2603:10b6:408:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 21:36:22 +0000
Received: from DS2PEPF000061C7.namprd02.prod.outlook.com
 (2603:10b6:5:1e0:cafe::b0) by DM6PR08CA0060.outlook.office365.com
 (2603:10b6:5:1e0::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 21:36:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C7.mail.protection.outlook.com (10.167.23.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 21:36:22 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 15:36:20 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
Date: Mon, 2 Mar 2026 21:36:11 +0000
Message-ID: <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772486459.git.ashish.kalra@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C7:EE_|LV8PR12MB9182:EE_
X-MS-Office365-Filtering-Correlation-Id: 02616f90-413f-47b6-4de0-08de78a3bfaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	rMY50e3wsUZ9FD9TgXPduSvOetTA2oRpJ9IKsKHVnNZbUZgAEdj9fRuKzkRLrryTem4owpOqRr3cv/X/AXp9P/mG1/S0097aUbnSKZFrBZYIGJAQy1C40Xg4mN7QzF3EzVF7ItXmkYCA23WvKkkuFWemsL5fd236owLXf+vaVlqiCumTeELCojDn78hdXxkeUIRb7+gCvDU7JH9Xx1KRydrKjDzF7K6dRNDnHxRq++pKidKMgQBpVbICdkPjJuOI7jlpwp0YZlPrbIhCtYvlwT3IHAbjXGWiDzTgstUcH1rOBDFbFVNCEZcTXYFZwXW1olnWIF3mRarze6RR272ObauPLafgWHcoirGBoL4QD1E4Xhz5tBhEG3uoSfRwNU8+vNb1J9k8UtrAKWqBtdJSDmJ6UBdu3od3+zyCumFAw2/DIfW1/Nm0IouT1CaYwNnb5muuGQ+P//0EYE9XDelBvjoObzy82r/kMpGHUwVRTIpcP9hGR+dIbfl9xOsHuqNrkfa7n8BsrXdCBSntUpOufb1gcaOCrW5m843zbsQT6u5sUJrLxXaeOCuJGdisO6eOEEWJSYbs8CmUBGnolX+AwZz8uAyJhLvZST/2bVgjf0qFAppT6oTXDOKHo70zkMJPZhQaHsEiU4+WVfSs3Ae5OtlJtMB39L6ZtTvrDamCXytZ/uEB5Ud8CA+p2rhpWVAthpeGuyI0383NSTyFlQZpAovGwYJaZZzq/ZOKauB2XiD5ppvzv2gqjB6cr7pMW3C2skvISr7V2BSQDXuCBdCqsiy08LGUuwMjAWkdi9U4BuzBkhtqi14f5CvWDsSzvrea/rJUlY0sSW/sTRHqyhjoZAq+urAHzhtIduzTImuY6+o=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2X555NIb0NbjhzZc72vq03z92yMVXKqHZ0eqXGMix81D0yZlZ/rC1ZgoAck6jSZpbsRbp+tYai7KlCqiFwCfXkNlrqSud6/r/F5xwn15jBpLtZd77vKxXOHubNlvPIbF3H0huUfVVto8IcowR7mfCoqhi6RpzHiYZryf99qbWMln70eCZnY6ynGR7n4pg+c/vYhDArdeKWkavi+d8+qzn35zzLCUt/0PqdLOyI2x3j/xLMzWZ1PTTQ2v3yujKajgLPxz/I2VDHdoPACrQdVzTRcC/oDTwnAVQalgWKhaOQDId0uLD6hgBBakbfHE9bhgQAwwzHBplSrnKZlayVrfP7JHRUjtPZVt13niXdVjyy5cGtRUaephkUWYYiXMztE2gDUE2B54Qeo7Emfaa9JKq5ACED/tB7uSrFqpB2FYSR9rQv+/LxP71D1dCqWaYVA8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:36:22.3290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02616f90-413f-47b6-4de0-08de78a3bfaf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9182
X-Rspamd-Queue-Id: D395F1E5ECF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72419-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:email,amd.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

As SEV-SNP is enabled by default on boot when an RMP table is
allocated by BIOS, the hypervisor and non-SNP guests are subject to
RMP write checks to provide integrity of SNP guest memory.

RMPOPT is a new instruction that minimizes the performance overhead of
RMP checks on the hypervisor and on non-SNP guests by allowing RMP
checks to be skipped for 1GB regions of memory that are known not to
contain any SEV-SNP guest memory.

Enable RMPOPT optimizations globally for all system RAM at RMP
initialization time. RMP checks can initially be skipped for 1GB memory
ranges that do not contain SEV-SNP guest memory (excluding preassigned
pages such as the RMP table and firmware pages). As SNP guests are
launched, RMPUPDATE will disable the corresponding RMPOPT optimizations.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 78 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 405199c2f563..c99270dfe3b3 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/iommu.h>
 #include <linux/amd-iommu.h>
 #include <linux/nospec.h>
+#include <linux/kthread.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -122,6 +123,13 @@ static u64 rmp_cfg;
 
 static u64 probed_rmp_base, probed_rmp_size;
 
+enum rmpopt_function {
+	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
+	RMPOPT_FUNC_REPORT_STATUS
+};
+
+static struct task_struct *rmpopt_task;
+
 static LIST_HEAD(snp_leaked_pages_list);
 static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
@@ -500,6 +508,61 @@ static bool __init setup_rmptable(void)
 	}
 }
 
+/*
+ * 'val' is a system physical address aligned to 1GB OR'ed with
+ * a function selection. Currently supported functions are 0
+ * (verify and report status) and 1 (report status).
+ */
+static void rmpopt(void *val)
+{
+	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
+		     : : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1)
+		     : "memory", "cc");
+}
+
+static int rmpopt_kthread(void *__unused)
+{
+	phys_addr_t pa_start, pa_end;
+
+	pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
+	pa_end = ALIGN(PFN_PHYS(max_pfn), PUD_SIZE);
+
+	/* Limit memory scanning to the first 2 TB of RAM */
+	pa_end = (pa_end - pa_start) <= SZ_2T ? pa_end : pa_start + SZ_2T;
+
+	while (!kthread_should_stop()) {
+		phys_addr_t pa;
+
+		pr_info("RMP optimizations enabled on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
+			pa_start, pa_end);
+
+		/*
+		 * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
+		 * memory does not contain any SNP guest memory.
+		 */
+		for (pa = pa_start; pa < pa_end; pa += PUD_SIZE) {
+			/* Bit zero passes the function to the RMPOPT instruction. */
+			on_each_cpu_mask(cpu_online_mask, rmpopt,
+					 (void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS),
+					 true);
+
+			 /* Give a chance for other threads to run */
+			cond_resched();
+		}
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
+
+	return 0;
+}
+
+static void rmpopt_all_physmem(void)
+{
+	if (rmpopt_task)
+		wake_up_process(rmpopt_task);
+}
+
 static void __configure_rmpopt(void *val)
 {
 	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
@@ -533,6 +596,21 @@ static __init void configure_and_enable_rmpopt(void)
 	 * up to 2TB of system RAM on all CPUs.
 	 */
 	on_each_cpu_mask(cpu_online_mask, __configure_rmpopt, (void *)pa_start, true);
+
+	rmpopt_task = kthread_create(rmpopt_kthread, NULL, "rmpopt_kthread");
+	if (IS_ERR(rmpopt_task)) {
+		pr_warn("Unable to start RMPOPT kernel thread\n");
+		rmpopt_task = NULL;
+		return;
+	}
+
+	pr_info("RMPOPT worker thread created with PID %d\n", task_pid_nr(rmpopt_task));
+
+	/*
+	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
+	 * optimizations on all physical memory.
+	 */
+	rmpopt_all_physmem();
 }
 
 /*
-- 
2.43.0



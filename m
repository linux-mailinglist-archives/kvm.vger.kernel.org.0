Return-Path: <kvm+bounces-68794-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8AVwNc5DcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68794-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:23:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6278A5DFB8
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:23:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3B28582430C
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E582428859;
	Wed, 21 Jan 2026 21:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1Qvp3QM4"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F096143DA23;
	Wed, 21 Jan 2026 21:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030115; cv=fail; b=qeD++JiU6UTaiL+zUmeE8fJuVvNDP+q5jhDjxoJ8CpXelIsDIeTcDKRTbtOukwnNXAtTfr+9sltxDUPf5HVHjfmar5f6PQyjjm0m+/Cp7pIERd0zM10y4TcggPSP46Xu+lNLPi5Or1aGg2DU2BIxPwem1W/YYttCvhmpHol3Ne4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030115; c=relaxed/simple;
	bh=3XMYqlluCr+ocS+pMijk48E8n2FUoz4q12MDwtGFhC8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4Rr9ogALapPKJX2T3zvh6TPgOnllM+KYLeSu65Pf6A3kErVT5G0u6F7ZzcAHl7uFQTvFAdJNmcBlklubK4/2/KAWEttgWS8oWxxea5lw0DJqEbPXey7RUZVlJN1dv8+JHn1FRwvtEEXX/fkKgwbM6n8zqciGFZs3lT7QuZJFzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1Qvp3QM4; arc=fail smtp.client-ip=40.93.201.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ek5n88h2S6w+UlwABwpkYThCM+cpiD27E45TA7eZsiwrVE+p7Y/EWY9R9AMc/UGEgUNvAXlSgznWPLlUTuE0Sohe4s3xqEaAefqO4Gy1+8hY4lvWYaHZAcF9goIgjkB5aAXQIZsYdxD5pD9cR7j60eVrEinxShrTc806LajHQsHpgKNbJyqP3fmizjyf2+3J0UZc2MTFz4Ohs5eKrAgssUiPu8iXfyKcqVEXFCwPcljyo2Zs+TsyI5jAZapOwjAFz8BZZ3zNgJhDU/ocCt24s9z/LPuxG4JAv0K9+HtWzBm+EUY3C2ib5a5iC3oSpVrgfPunyvclFA/HrtVN9KT1FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xa6iMP1GyjrKHIDm3MbLB1uSe9wc5N0e7SmptiOSha8=;
 b=W6aiq2352CMfJrsViRqy7Y2XAOxs38AB/Ia3+TYGht3oMdM690+sD3cDoTgjXKbUNHBEuciLsiTsgH4hBHm0UdJP6+lDZSVqIYrh7e6s11qnvMbY0Mbtu0swYl1loljicNN8ycidrpNxgJ4ehqA1RrWg/IhvUnngAiIvBPOBz1Y7QmSfHworWVEBcIENLEIGD9ofZCg7mkeYIAIzsRDcpTShYmsacF6MQC/mff+f88JlQdhN3KXW3GPKzvBtZeNn14dBMoe2c5UXzYD8rfKSGhvU3yjd7BDBX9xz7sjWY2azjlsHBbtPkQgti9WNrWnN6UWBXbOkFZazWSgijr5Wrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xa6iMP1GyjrKHIDm3MbLB1uSe9wc5N0e7SmptiOSha8=;
 b=1Qvp3QM4eXGUgUoBwzoUkVW5VrQioNuoEBu9MCt4bbPwe+des8eSogXoHn36aNFhgSGFkLXriMJ+y8KVXBSlLZxsXreNe2vCceCC2LcMrOA8gkKRSzVTkpKNGDCPXXI/ysR2ZzyVqHgWsx+qZ+bDRyLhAiSdG618cVC7gLmot68=
Received: from SJ0PR05CA0099.namprd05.prod.outlook.com (2603:10b6:a03:334::14)
 by SJ5PPFF62310189.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:15:02 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::b4) by SJ0PR05CA0099.outlook.office365.com
 (2603:10b6:a03:334::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.5 via Frontend Transport; Wed,
 21 Jan 2026 21:14:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:14:59 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:14:55 -0600
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <babu.moger@amd.com>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: [RFC PATCH 14/19] x86,fs/resctrl: Add the functionality to configure PLZA
Date: Wed, 21 Jan 2026 15:12:52 -0600
Message-ID: <84b6ec2a2b41647f44d6138bc5e13ceab3aa3589.1769029977.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1769029977.git.babu.moger@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|SJ5PPFF62310189:EE_
X-MS-Office365-Filtering-Correlation-Id: 566b7534-79f9-4415-ceb0-08de593222b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q1kprrINSyYkH44K3lik3DQOkcEAmj+4haG3zoePIV/Hgp0dxNTegG44Yp2I?=
 =?us-ascii?Q?YeTTKBCfAM8W8e3e3neQy6eoeUu7T2AWdFmh1cjlqzvSFg+rtGMSSERp9ufM?=
 =?us-ascii?Q?1jMo+EvLZYsJOVMuSEkTtbRK8pgckUP1DfM+nOpDITKEZbWS6Zm7RiWqgA3i?=
 =?us-ascii?Q?v5nWUE7ldXxQu1t6PyOe0cOS9brvjNOrCk6wvAnXi/VXGeyjs5vrh7ysk+wY?=
 =?us-ascii?Q?N/iPB78Yt/2t60TjYHEoF6vg9Nh03V+LcdLWEeEppUT2Jiqz1J2t5uRHJ5Fj?=
 =?us-ascii?Q?xHSvjkt4BnPWg5Y9/lMMVTyOeB9qNt6NuZcGzAqNxgi9S7kswA2Hz1gVN8Lq?=
 =?us-ascii?Q?3Y0d4IQ/o/0KAR2o48UVmq/TtaIxgk0N1uOUKDtHuruO3t8aEEh0FxBYxmy4?=
 =?us-ascii?Q?yRCv1XS3qrVKtyEnVSb4z1NITBWBrULpAHPATPsJnMX89ruxGDYPLETFkVEL?=
 =?us-ascii?Q?gRW3FNxk6PYTp1gGlsiQ2osrZleQL93sWKR+2E2fZVxweSQaY8azZDJwIHoh?=
 =?us-ascii?Q?FSOfJEAJ2/r4GYkzNMSV1FDJQnDxHCKt9W/clhfVHgTxWObqPPmfGWiJ2HZA?=
 =?us-ascii?Q?y5V42mDvBKyBW2MwaIB16KJw8RfsX5hi0dO5AUcl9yCEsNCrIaWMZmCp517/?=
 =?us-ascii?Q?uv5Mc7oDS9jig2uS54NRWz6shf5SCjezxXc+HkOkNRC6HbBEWm0n4kyDSS2O?=
 =?us-ascii?Q?emokW3IaSdfmn3LNPOhgyqHeSG23lE6LmglNadEmg55lC9oYtT8cNOjNat/y?=
 =?us-ascii?Q?BTg2K/m/CFVK0v9y+uI2fgeWJmBg/DNf52bY8F3Sz2ABoTOp7pCetBTIkVUy?=
 =?us-ascii?Q?rkJ6zgfbldAIeUAz+rHYPMk/k3MAx0CMEV6TSyerJHjQR0i2Ma2h7uYOkLY0?=
 =?us-ascii?Q?JBjATwh66JEPa0M6vYThTmVySHhMMhizPFIbVL5A5njL614fwVzj9K+jE7tb?=
 =?us-ascii?Q?xMFeEdGvmOwXNhyE5aIIgKHPl1AYZGCSgeDdRi0qucw5TOe12tBD7+3jqbJ5?=
 =?us-ascii?Q?KLLOEf2026lhdTe9sOEFlA/cGbqcwG/Vx7KBJlNFJ4gFEILIIwVA7FMfiafI?=
 =?us-ascii?Q?yiuGU2MhvPLS5rEpWAw3B3/gckVEB4cxBD5l4bU6QMjzxSpMWawKB1l7mlN3?=
 =?us-ascii?Q?da6V3+Xx/AhmrFhVmcPYPGqf8AaK7pQ2VYimHW+znwDXtzsYszj9TlwpdvKQ?=
 =?us-ascii?Q?fZooqdlFL4nbCr/jN/qjM6HVlxflCB70cDSYwgwpD3z+Ns09rqTRrxEKc0Ql?=
 =?us-ascii?Q?Cy+sDTe/H4OjGPYbwzuvxdur6WPJrJKLwzp+YihK58v42NGUJXR0TTQOQd7c?=
 =?us-ascii?Q?pBm+8LaWxXMf9kJWZunyJMvsCezeNJgdFXK2hl14XXsLcVtnxAl3hlFTSyJX?=
 =?us-ascii?Q?3S7MQZYZ/0CEbldrlXrXDhJDLFmeIN+03bc6qtemyJNm/IJBUgsZLUPNYP/A?=
 =?us-ascii?Q?0sAFLm9AfAtr//bA5SoOmeuox8QKQlewxbE4qYFFrr2066QOWDw8hId9HgAP?=
 =?us-ascii?Q?birZOPe0FauX6Nc0oyKvEJ+iqsBgTSUjEd+7rc5GQ/XmggvqvyzAbaM4+gkA?=
 =?us-ascii?Q?IAzXu8oM2Cn787sROTBfhEsbU6/SLHZnTsE7oGObZxSCO2BK9k2T4yW0ThWF?=
 =?us-ascii?Q?Ulwi9laxktk6mY43nVr9EW7GVQwuE97Qw4gsSkZ6by/5rGNyBis95EAd8p1E?=
 =?us-ascii?Q?VcR1RedPV2lODbA/uqB9xtVTj7w=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:14:59.8209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 566b7534-79f9-4415-ceb0-08de593222b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF62310189
X-Spamd-Result: default: False [1.54 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68794-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,amd.com:email,amd.com:dkim,amd.com:mid];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6278A5DFB8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Privilege Level Zero Association (PLZA) is configured by writing to
MSR_IA32_PQR_PLZA_ASSOC. PLZA is disabled by default on all logical
processors in the QOS Domain. System software must follow the following
sequence.

1. Set the closid, closid_en, rmid and rmid_en fields of
MSR_IA32_PQR_PLZA_ASSOC to the desired configuration on all logical
processors in the QOS Domain.

2. Set MSR_IA32_PQR_PLZA_ASSOC[PLZA_EN]=1 for
all logical processors in the QOS domain where PLZA should be enabled.

MSR_IA32_PQR_PLZA_ASSOC[PLZA_EN] may have a different value on every
logical processor in the QOS domain. The system software should perform
this as a read-modify-write to avoid changing the value of closid_en,
closid, rmid_en, and rmid fields of MSR_IA32_PQR_PLZA_ASSOC.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/resctrl.h            |  7 +++++++
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 25 +++++++++++++++++++++++
 include/linux/resctrl.h                   | 11 ++++++++++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 76de7d6051b7..89b38948be1a 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -193,6 +193,13 @@ static inline bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 ignored,
 	return READ_ONCE(tsk->rmid) == rmid;
 }
 
+static inline void resctrl_arch_set_cpu_plza(int cpu, u32 closid, u32 rmid, u32 enable)
+{
+	WRITE_ONCE(per_cpu(pqr_state.default_plza, cpu), enable);
+	WRITE_ONCE(per_cpu(pqr_state.plza_closid, cpu), closid);
+	WRITE_ONCE(per_cpu(pqr_state.plza_rmid, cpu), rmid);
+}
+
 static inline void resctrl_arch_sched_in(struct task_struct *tsk)
 {
 	if (static_branch_likely(&rdt_enable_key))
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index b20e705606b8..79ed41bde810 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -131,3 +131,28 @@ int resctrl_arch_io_alloc_enable(struct rdt_resource *r, bool enable)
 
 	return 0;
 }
+
+static void resctrl_plza_set_one_amd(void *arg)
+{
+	union qos_pqr_plza_assoc *plza = arg;
+
+	wrmsrl(MSR_IA32_PQR_PLZA_ASSOC, plza->full);
+}
+
+void resctrl_arch_plza_setup(struct rdt_resource *r, u32 closid, u32 rmid)
+{
+	union qos_pqr_plza_assoc plza = { 0 };
+	struct rdt_ctrl_domain *d;
+	int cpu;
+
+	plza.split.rmid = rmid;
+	plza.split.rmid_en = 1;
+	plza.split.closid = closid;
+	plza.split.closid_en = 1;
+
+	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+		for_each_cpu(cpu, &d->hdr.cpu_mask)
+			resctrl_arch_set_cpu_plza(cpu, closid, rmid, 0);
+		on_each_cpu_mask(&d->hdr.cpu_mask, resctrl_plza_set_one_amd, &plza, 1);
+	}
+}
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index ae252a0e6d92..ef26253ad24a 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -704,6 +704,17 @@ int resctrl_arch_io_alloc_enable(struct rdt_resource *r, bool enable);
  */
 bool resctrl_arch_get_io_alloc_enabled(struct rdt_resource *r);
 
+/*
+ * resctrl_arch_plza_setup() - Reset all private state associated with
+ *				   all rmids and eventids.
+ * @r:		The resctrl resource.
+ * @closid:	The CLOSID to be configered for PLZA.
+ * @rmid:	The RMID to be configered for PLZA.
+ *
+ * This can be called from any CPU.
+ */
+void resctrl_arch_plza_setup(struct rdt_resource *r, u32 closid, u32 rmid);
+
 extern unsigned int resctrl_rmid_realloc_threshold;
 extern unsigned int resctrl_rmid_realloc_limit;
 
-- 
2.34.1



Return-Path: <kvm+bounces-68799-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMKKJmlKcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68799-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:51:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D235E4E9
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:51:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 018AB84BE81
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79C944CF47;
	Wed, 21 Jan 2026 21:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ac6GU/2X"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9441F44BC9F;
	Wed, 21 Jan 2026 21:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030145; cv=fail; b=rcrwKuKppFVlxWzfUlydqCYQE7RgKua0DuiSunOM+t1lLX4wX8ItveGGApSo7gELJCg1ps6jqu1iQbYX0J2wDAoMXPhlaVIlUWls8VLmoEP2/D0tOL3DA5UrxNp+kRat+PSFoSgVwl9Q0tXZ0VyPTkUmVtEHJxDpuLoDw/F4Wz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030145; c=relaxed/simple;
	bh=hm0C/630O+fyxsO+nlugQZPEsOL+cdQUClZ97H40yWs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QzndH9rh/1Jpj6MwbKn/5AMB0P58eXzV4UdFyLxgeZJ1DIXqRZDnLnWIRcYvLXvSYn+UqLdgwScyiFFzdc/hqfDXGKxK3Rn5K71BPiaUUyj9Xl4h4W6M4HKYyWe0k5i6f40/g1nMijWgfpBfX0IlW2CyhKMNsv1RjOxsEOwHEZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ac6GU/2X; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dMxb2hYbzKPQ9FWf3vFOMl7ZJi4R+DEBMMrLkuUP5WMb5z7Fa6aOUKqrZfMTqVlxN5RTWa/ljFXKzZdzmzegGhUV5bFvNC2tYEFiZFkurUynX4x5QhwvMbwp4500z4urpj0aRFhlugXkrS8KMgx4FpM8WLFAkiT++amRA9DElrdfMhsRbYH8FyX//d6sJP7KIJBQxrwIxFJ0pJqcyAHg+C4eJKEEnMNP3dykdWHCB/sqVIuZh3RbbQqB/iaE9cebNKjhrCip5dZSr/CNWizi0q5zLjR2RRe1fB3nqPgIz4iiFUM46CZ3P+PQoC5vP+n46WUWQdl196A+p8iuoNUcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2ZPLEI8voNpm4e664+GJxAyrvr0dO+czn9mhemO5hQ=;
 b=Oe/dcRV3KF1dcnxoC4N+prJ5gN5TGlfsXIKQ044w5h+caJNdxiV0BR1nAv2ihqZphY9oEu8hxDmKQtVv+DXAUlsqunrl+Lq56iWnRZSdEA31aWhZ9p2uDeRI7R2H9yGC+SBFbvl93lu/a7d/SBeR4mjYht4diZYj+AdNxO/0HfYzu5EoyMrTVvTkQZeURQyHtGnChxqnN9fiYGh+818NCYqC6HZhVYLRLDQ8ANF9QVMlkx4tVLu+FCOURQAVx/fkIXvNKC3gvfsVOyUJO04ei6NMQqTyaNn5QZYlUJkA579pS2fHfyGh3uyuRTanLehkvPp8XHLRiQPfe88WbGXxmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2ZPLEI8voNpm4e664+GJxAyrvr0dO+czn9mhemO5hQ=;
 b=Ac6GU/2XQ1Ee4/dvwLDn9a0scvs2H8KBDNP7BBQzpS804xkXvXCCziCec+set+7G0HG4QMcuXAjcAaZV9kHGDVzZLrVV+o9Sr4p//t7f8ucjpBbfhLuDk09jiL2qmDb6TgSjsPOKP0+hpL6BitZTnG4h2jKVJViOhOxQMxiLRoA=
Received: from SJ0PR03CA0300.namprd03.prod.outlook.com (2603:10b6:a03:39e::35)
 by IA1PR12MB9740.namprd12.prod.outlook.com (2603:10b6:208:465::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:15:38 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:39e:cafe::87) by SJ0PR03CA0300.outlook.office365.com
 (2603:10b6:a03:39e::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Wed,
 21 Jan 2026 21:15:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:15:37 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:15:35 -0600
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
Subject: [RFC PATCH 19/19] fs/resctrl: Add per-task PLZA enable support via rdtgroup
Date: Wed, 21 Jan 2026 15:12:57 -0600
Message-ID: <096d70c47ca16630a51284a61541e068d4b48698.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|IA1PR12MB9740:EE_
X-MS-Office365-Filtering-Correlation-Id: fc926851-bb92-46e0-80a9-08de59323921
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9VLLnl5p8D/HM/vjquiseIDbr+cC74T9PI0mSH627D+sYImJ86aVhbv2P+w/?=
 =?us-ascii?Q?1GybitDdBCAUO066WyB1iKr9UI2f2WmcMhZzqJXJ7lTuK6cFUvF3hfpgX64Z?=
 =?us-ascii?Q?wvYdpnm8+1M++J/ZFAEIq54hoO7waXQtAfzJGgadxhJOqsMjBz3T3hEa7kif?=
 =?us-ascii?Q?yRTWUw7R2Ynv86JLedjNTATInmumg/FMZFahO7jHfxYA5JWhbI+1tUWuD7BW?=
 =?us-ascii?Q?4HYvrKItorj8t8kYBlLHdu0ojczc5HnNKMB2FUmQLp4FgHFHqy5/1bYj2eiP?=
 =?us-ascii?Q?Jhu5D7AssnTLykirIryrvOJFpQ07hyUR9epRXm3x19y2YF61SgiVkAr9kC+6?=
 =?us-ascii?Q?ZBWQmSNLoK1+zzsSE2lTbWB2StVM4iY499cnwpowor48LgIXxKv2E0PQsTDF?=
 =?us-ascii?Q?PLPXkL9oxSUuuz4LT5qZPsIzDa4CBeumm1B9kfLSHQVQnQYerk9ny3zNup9D?=
 =?us-ascii?Q?xlS/KoI5l1brG0wc7KZkxPXbHpph4TloqGuzvqjSxLdWq4zxNWi2ZxOada9W?=
 =?us-ascii?Q?gN9/iNS0K06TlsOEu8h67UhqqS3iepdd+CTsx37wxdq03IAeXYWR6xRkDuFE?=
 =?us-ascii?Q?seKv4mxRDpnH5GOZIFKB7p1eRlXRTjkjPG+ozQ0ekN+4DSdVacvXJ7VQuM7x?=
 =?us-ascii?Q?J1y7VTkXaH5zi4KYTE9vHfdii8PwNAol25SyfOvRm9yPlGrHiehUcLioYrkF?=
 =?us-ascii?Q?Jr08JBXkkgmBHyPa+kRxo8jCX0QEfqDB9V4309yKzBNvDtgktb2TPA5PmX8j?=
 =?us-ascii?Q?sqxls5ZIGy4ZWn/LF8syzd3ybxXCTq/uNXJEu1xZnI4hwTocmxYomjhy2q26?=
 =?us-ascii?Q?MpeUtO+BPyfN2Mh8KpV+QDyJGeB7uJyf7DpPnFvC9QV8glZIxvI/wQTkYvar?=
 =?us-ascii?Q?nFgneEnjyx4By7SBH7xeHltKHu7+cFoyNCN7ww7N1riAz0nV0TG/kDuCCdXA?=
 =?us-ascii?Q?EVaCHfxEe2i47BT4/8ui+0wC84FTXlC6TEKQj59cQN2l8jlCA3ScyLs3c59v?=
 =?us-ascii?Q?bkcItOm5erCgrXXSi6PzBEZjYzVifbyPuqBKaTuO4XG2nw7YBTpRkTpRgqhW?=
 =?us-ascii?Q?SVVns3xTQXGG2dxA2stEpFnQ/LnDPhbcjOVW425txfTGAOXzaivxTif2MgBj?=
 =?us-ascii?Q?cVQNaFmJ3AqRLSoo176PAeLtKnbm5CwcCKrkMBLrXizT2pzFqlE9LUnDqI8J?=
 =?us-ascii?Q?zZeM547fLo7/L8m3KPmeBv+VuREDbW36i597EqQou7DMxOS05tHl4C48f/DI?=
 =?us-ascii?Q?H6CHTKi65IqwPai35V3McIJ+rQ968S70spOJzHRq5qm6som8K5fYTEFGSVlz?=
 =?us-ascii?Q?Myoo0yGJBy3f+DTlg+T1n6fXtMfoX5NYABH+6K3V5SjkVVUKKkNg5Iy7sPBL?=
 =?us-ascii?Q?EDe+/+azXtJiVpASKWIVcwGULTtZX9l0menpkiawMXbZnYdoqmNpD97I07nr?=
 =?us-ascii?Q?SJrBPneS9zNs3Ybf1CQ8CGt57/VAamntPsLMFOGuCyBWlM+nZff53KkB4fH5?=
 =?us-ascii?Q?nGiGkl/TUibInoVOoRvrHs8TxilLYcbKnu1lfguikQ4adBQrG9Lw5xK1OnD2?=
 =?us-ascii?Q?wuJpVabvNTzYAbgGdSzy6eJX9R0pAtysuYx3dGh5hH5s35L2DsiNyns1zK/h?=
 =?us-ascii?Q?ZNQBv+ymw7kbe57p6YdoAThO6h5XbxfC5XKHKUadpG3X5XU7EXVJNTJZMDgz?=
 =?us-ascii?Q?IVKtwpG4PnCAR4YzRAGKQ/oz7iA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:15:37.3827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc926851-bb92-46e0-80a9-08de59323921
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9740
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
	TAGGED_FROM(0.00)[bounces-68799-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 62D235E4E9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Introduce support for enabling PLZA on a per-task basis through the resctrl
control-group interface.

Add an architecture helper to set the PLZA state in the task structure and
extend the rdtgroup task handling path to apply PLZA when associating a
task with a control group. PLZA can only be enabled for control groups;
attempts to enable it for monitoring groups are rejected.

Proper memory ordering is enforced to ensure that task closid and rmid
updates are visible before determining whether the task is currently
running. If the task is active on a CPU, the relevant MSRs are updated
immediately; otherwise, PLZA state is programmed on the next context
switch.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/resctrl.h |  5 +++
 fs/resctrl/rdtgroup.c          | 69 +++++++++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 89b38948be1a..2c11787c5253 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -200,6 +200,11 @@ static inline void resctrl_arch_set_cpu_plza(int cpu, u32 closid, u32 rmid, u32
 	WRITE_ONCE(per_cpu(pqr_state.plza_rmid, cpu), rmid);
 }
 
+static inline void resctrl_arch_set_task_plza(struct task_struct *tsk, u32 enable)
+{
+	WRITE_ONCE(tsk->plza, enable);
+}
+
 static inline void resctrl_arch_sched_in(struct task_struct *tsk)
 {
 	if (static_branch_likely(&rdt_enable_key))
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a116daa53f17..5ec10f07cbf2 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -706,6 +706,26 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 	return 0;
 }
 
+static int __rdtgroup_plza_task(struct task_struct *tsk,
+				struct rdtgroup *rdtgrp)
+{
+	if (rdtgrp->type != RDTCTRL_GROUP) {
+		rdt_last_cmd_puts("Can't set PLZA on MON group\n");
+		return -EINVAL;
+	}
+
+	resctrl_arch_set_task_plza(tsk, 1);
+
+	/*
+	 * Order the task's plza state stores above before the loads in
+	 * task_curr(). This pairs with the full barrier between the
+	 * rq->curr update and resctrl_arch_sched_in() during context switch.
+	 */
+	smp_mb();
+
+	return 0;
+}
+
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 {
 	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
@@ -795,6 +815,35 @@ static int rdtgroup_move_task(pid_t pid, struct rdtgroup *rdtgrp,
 	return ret;
 }
 
+static int rdtgroup_plza_task(pid_t pid, struct rdtgroup *rdtgrp,
+			      struct kernfs_open_file *of)
+{
+	struct task_struct *tsk;
+	int ret;
+
+	rcu_read_lock();
+	if (pid) {
+		tsk = find_task_by_vpid(pid);
+		if (!tsk) {
+			rcu_read_unlock();
+			rdt_last_cmd_printf("No task %d\n", pid);
+			return -ESRCH;
+		}
+	} else {
+		tsk = current;
+	}
+
+	get_task_struct(tsk);
+	rcu_read_unlock();
+
+	ret = rdtgroup_task_write_permission(tsk, of);
+	if (!ret)
+		ret = __rdtgroup_plza_task(tsk, rdtgrp);
+
+	put_task_struct(tsk);
+	return ret;
+}
+
 static ssize_t rdtgroup_tasks_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
@@ -832,7 +881,10 @@ static ssize_t rdtgroup_tasks_write(struct kernfs_open_file *of,
 			break;
 		}
 
-		ret = rdtgroup_move_task(pid, rdtgrp, of);
+		if (rdtgrp->plza)
+			ret = rdtgroup_plza_task(pid, rdtgrp, of);
+		else
+			ret = rdtgroup_move_task(pid, rdtgrp, of);
 		if (ret) {
 			rdt_last_cmd_printf("Error while processing task %d\n", pid);
 			break;
@@ -935,6 +987,19 @@ static int rdtgroup_plza_show(struct kernfs_open_file *of,
 	return ret;
 }
 
+static void rdt_task_set_plza(struct rdtgroup *r, bool plza)
+{
+	struct task_struct *p, *t;
+
+	rcu_read_lock();
+	for_each_process_thread(p, t) {
+		if (!rdt_task_match(t, r, r->plza))
+			continue;
+		resctrl_arch_set_task_plza(t, plza);
+	}
+	rcu_read_unlock();
+}
+
 static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
 				   size_t nbytes, loff_t off)
 {
@@ -991,6 +1056,7 @@ static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
 
 	/* Enable or disable PLZA state and update per CPU state if there is a change */
 	if (enable != rdtgrp->plza) {
+		rdt_task_set_plza(rdtgrp, enable);
 		resctrl_arch_plza_setup(r, rdtgrp->closid, rdtgrp->mon.rmid);
 
 		for_each_cpu(cpu, &rdtgrp->cpu_mask)
@@ -4209,6 +4275,7 @@ static int rdtgroup_rmdir_ctrl(struct rdtgroup *rdtgrp, cpumask_var_t tmpmask)
 	int cpu;
 
 	if (rdtgrp->plza) {
+		rdt_task_set_plza(rdtgrp, false);
 		for_each_cpu(cpu, &rdtgrp->cpu_mask)
 			resctrl_arch_set_cpu_plza(cpu, rdtgrp->closid,
 						  rdtgrp->mon.rmid, false);
-- 
2.34.1



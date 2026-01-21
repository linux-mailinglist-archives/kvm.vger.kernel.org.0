Return-Path: <kvm+bounces-68798-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDAKKzpEcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68798-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:25:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6242F5E010
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 01AD94E9AD2
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F190E44BCAE;
	Wed, 21 Jan 2026 21:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wrGNzm2Z"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF803E8C6B;
	Wed, 21 Jan 2026 21:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030142; cv=fail; b=RBjePw2xSkuV+dw4SMnmFcATL6SZ0U4IFHsv/cEhr6RgatrZKQrf0fR1Qrx8p4TTvMY0JqhPfrooZ7b6dTWImRpH2vWcrSyjDSfUVCCL9Zw3D2UTSFXl7EmmXS06JimNbBQSFKHosACuHwXCOTz/vVl+E3eRyayDKgZXrv3+zR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030142; c=relaxed/simple;
	bh=8SDcoR80eo54AsZESIywTHTuNcrRvKYW/lwxzQf+YBo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRvoXHHoCxl98QBedE+RlR7RQCGgON8NoaBa6sDFXtyKeCHKFCR3eMRU1g1U6MQ8oakmM4sOagKlz23nx6U9fZZv9KPOqRSGEf7YBxOdsZrYqnGkaabMfEZRH3RD9QQaB+t8Uuo37/wbk7Yz/oggQUXR55djJZqKy/e0JyGqVwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wrGNzm2Z; arc=fail smtp.client-ip=52.101.56.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EyVHAZHwUHp8hOVRTrhkECIJGN0qYrs1ab3R0hj4xPUQjDxwnWGuZRx4ujuRpZwZ0ZaNwKMFjX/VCZoxRakF/0YjXSik/cxIISO1+OefLeOullmKmmvTNO9KZ24K2fyztcltWTyCzGUUbaHmVlRK0Sxgi/2PkBPsHPQS4pbYTQEjLBvN27VjnMZ5nkKKiBPM+PYsBnEbcafgqHy/dlY6w46bTAeMPnd4joSmFDzq93SYlm3RfkwpwPdv9Np6jnGKJi8yDTk8ImyaVAIEW+1vRNq4EaN66WSbRihjLNXPrZU4ERwmlnAY42or49Re+VwtmwHJUfiYHyXDXPvoNC7M+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzzTBuxTRJfXmN2gAB5Bz1i/QpJQlfNBq4oLALv4zzk=;
 b=iEv5LfhV2xKRWEohA3MdPMsj377BCknqFdlQ0AG0k0UKvRXnzkff7t2XiCtvN4aNGBDeegO7sfZzKU7KPSBss440PZGP85d3sHiLoE6m1YAfhHxHNtyJQ9nL56565C3kDd3f5tmxsE8Pu797kMlyXi7RY1f/7xhRC6UQ5/NYS944sbeGzJcfPXGlhQC4ApPgp/cCzGn9WSfj5J8WtmKTtmQxwDoaqe/Bwdk841gsUOhZbUQIrv1LcCn7n1vcRU09PaTTgu61nMqMXlGi1L+aej9jgc1BF28b5rmpKzvXjlxRjvzkSlwaJP+UQXiF19zlIo9y4DjL/8TX65V1m4BwgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzzTBuxTRJfXmN2gAB5Bz1i/QpJQlfNBq4oLALv4zzk=;
 b=wrGNzm2Z2mVL+ku/gCnv1wD1Ex3l06ojwBkBMxGrOLNobIMPiEkSTnYixtFp9YQGQQamr5jX3rqA03OPhXOAGDUkGSG2i+yfkjLmgMsJdyVmcFm1RtSEOdlZDczCToVuxF13qG8tPXVT4DtKC1VabEJOsdztWLl0MvdHT4KsYHo=
Received: from SJ0PR13CA0138.namprd13.prod.outlook.com (2603:10b6:a03:2c6::23)
 by CH3PR12MB7761.namprd12.prod.outlook.com (2603:10b6:610:153::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:15:32 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::4f) by SJ0PR13CA0138.outlook.office365.com
 (2603:10b6:a03:2c6::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Wed,
 21 Jan 2026 21:15:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:15:31 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:15:27 -0600
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
Subject: [RFC PATCH 18/19] x86/resctrl: Refactor show_rdt_tasks() to support PLZA task matching
Date: Wed, 21 Jan 2026 15:12:56 -0600
Message-ID: <e0b7daba00e70a0f4c136e111452d47d00d1f9fc.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|CH3PR12MB7761:EE_
X-MS-Office365-Filtering-Correlation-Id: c2ee05f2-b239-4e16-eb62-08de593235c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ahLV52UhBTWousxyGFM+8kAHLklbHlJGQUQmCppkwfRoXpuKcJzUV0lNg3bd?=
 =?us-ascii?Q?hODYLneZg7N0pmmT2F7KcMo/oEWHQU6HurTXV6hzcxnkaDZbCyY78AWe2X7x?=
 =?us-ascii?Q?2sl3Lzp2Q0DYw5dj9Om5y/0NDS0vhuBU3bBJ+qPOXg1L7kxhI3TFrjBLfxsw?=
 =?us-ascii?Q?hnX/66Q/XwHezMIgEz5kDr1b9lTxdAQD8AP80CLm3o8m55Ooz48CDMqYwSjv?=
 =?us-ascii?Q?Egx63SHuzes36TvdJHL+wo/HAsAi4mCWjPk2fXjtlq/oz1VvIqL1XIu9x7Dl?=
 =?us-ascii?Q?FDqe/SZbsRdnC6bFXVsxB7FDCu8AO6kh8lZmCBnr7hpY8rc1prQuuOWaN86h?=
 =?us-ascii?Q?Cy2I93Y80ATXtasr0fCoaPv8yNtHy0FUYu7Ul4lYL9pXUYaWI2myNVu3kDig?=
 =?us-ascii?Q?q7vXjZ2ybxjy/+oVp8lWPpXX7zozLf2MnTU5VsZyGf5JpwdQl52LDarUDgGG?=
 =?us-ascii?Q?E8lek7SyWOAopJTuC0Oq/qxDC9gMppAn6mFEV6DTOYkaxyykrfcojo0e2r6o?=
 =?us-ascii?Q?lKJL3DwZ2Swrt5ohQ4I8xWV1zs2Nw7cbgEanYqxga0ia7rOeIjHY+YBJfTHb?=
 =?us-ascii?Q?irgyx2mM9Y++uQoO0CipKReB2TGT/CtgDv+N5OPUlj0TFsiK2IB/2j5VKVmP?=
 =?us-ascii?Q?0QOOqk7iJ2onfXF5xscN6s2xwxM1LymtXT/h0DyoogLVtCifWieupPrkkMcd?=
 =?us-ascii?Q?VlHC5Qnl0BQ5BSYHqPCpTjhtILKv3L6aPpsE0VyNCZJuEGpOr6aI+rfXra6o?=
 =?us-ascii?Q?DGgranFO+xoSZ8feI2ovviQSHOu+ErcSW0L0TC3UlWDKA+ea8m+4cpmtmaV1?=
 =?us-ascii?Q?U7167ZXo0FlTMkBEodEB5CJUotEMckO7Y36D1x6lC62R4GXYrdWqTsomJYdK?=
 =?us-ascii?Q?RLoTB5nF0ugiM8FbEw/ute3v5j6KXAh9u0foIDXwOMmNJ3GuPkcKY31G2oeT?=
 =?us-ascii?Q?yD3H2oLkagvGrNNKha8KHhhg9ktS+2uekclnsoeYM3JdwARC/KC0QzsuuXVa?=
 =?us-ascii?Q?HKYJ71xI41ZkaDiWMC9fA7H4RadZ7vUwr899FwaKDfGxmejPDu5ObT63/1pG?=
 =?us-ascii?Q?csgFEc1Dmd+9bbo0+Nptn8nLUUeMCZze50nYY1RMci63Z05JdEjFXD6ge9Cy?=
 =?us-ascii?Q?rlhrBQZx5vth1WDFzVRO6QQlbVkj5FjfD4tuFrjrHsKM9hC4I3/h1s1OecQM?=
 =?us-ascii?Q?mlrerZVqX3W8GNdqFwrnczAGBq6Tv3k2q9mGsNaa69IgoFCAXRAGGQRBksNH?=
 =?us-ascii?Q?W4JxeBmgVDP2XOz4p1uIiGTWAdefc5f9mUlVVaL7xFRJtjAIaTKiocpDJ3gp?=
 =?us-ascii?Q?EvwPWvjDo7aK6By0ETZqyC6xQUUlJzjjSDH/Kc3+VR+L00ohYVLwc7Ky8vFN?=
 =?us-ascii?Q?vxNvpSxR1ehuRJhJUZHhDgWkCqQdMTnMiOCCEX46KalyMKwUJ8ewZLn9o8Xq?=
 =?us-ascii?Q?8/WAaZwYCm/El+C9jL+fjnd7AZzlAGplKF5qdKC+OEF0uO/0txyAclVK++S4?=
 =?us-ascii?Q?lvaNNLqsS4gVQEMlOvqIceloVi9JfQnPqZnWxqkWRbmyCjZ6B5U2uKGbzbyt?=
 =?us-ascii?Q?NTsO3L9c8/cHxgoComeMTgivm4wIPo1IN3KUneOMdCkove91Cgy7KA304jZj?=
 =?us-ascii?Q?3s7PQYBIP9eGUBt4OiHfNeDl2c8VY9iLo4AaLbFW60ZPzigDN/ejPct/FQ0A?=
 =?us-ascii?Q?vAVnNQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:15:31.7573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ee05f2-b239-4e16-eb62-08de593235c6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7761
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
	TAGGED_FROM(0.00)[bounces-68798-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6242F5E010
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Refactor show_rdt_tasks() to use a new rdt_task_match() helper that checks
t->plza when PLZA is enabled for a group, falling back to CLOSID/RMID
matching otherwise. This ensures correct task display for PLZA-enabled
groups.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 fs/resctrl/rdtgroup.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index bea017f9bd40..a116daa53f17 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -845,6 +845,15 @@ static ssize_t rdtgroup_tasks_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+static inline bool rdt_task_match(struct task_struct *t,
+				  struct rdtgroup *r, bool plza)
+{
+	if (plza)
+		return t->plza;
+
+	return is_closid_match(t, r) || is_rmid_match(t, r);
+}
+
 static void show_rdt_tasks(struct rdtgroup *r, struct seq_file *s)
 {
 	struct task_struct *p, *t;
@@ -852,11 +861,12 @@ static void show_rdt_tasks(struct rdtgroup *r, struct seq_file *s)
 
 	rcu_read_lock();
 	for_each_process_thread(p, t) {
-		if (is_closid_match(t, r) || is_rmid_match(t, r)) {
-			pid = task_pid_vnr(t);
-			if (pid)
-				seq_printf(s, "%d\n", pid);
-		}
+		if (!rdt_task_match(t, r, r->plza))
+			continue;
+
+		pid = task_pid_vnr(t);
+		if (pid)
+			seq_printf(s, "%d\n", pid);
 	}
 	rcu_read_unlock();
 }
-- 
2.34.1



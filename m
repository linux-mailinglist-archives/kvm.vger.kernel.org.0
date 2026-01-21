Return-Path: <kvm+bounces-68795-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIsnMLdHcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68795-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:40:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 73F885E283
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 78C3F848F1B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8154418CD;
	Wed, 21 Jan 2026 21:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V+dBH7g1"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010009.outbound.protection.outlook.com [52.101.193.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268D44103D;
	Wed, 21 Jan 2026 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030122; cv=fail; b=Xw6+A37FTUQUWIU5alZZMCK3oU5i0Wbau02RbvCmfvaGNM6hOl+QCWKPJcnegfZZ5viP0/oHh6WSGMMzrlW3HxaZTjP1ey/v4vgt8nCzPmNZwsDjfXwhBY8OdSib+msHO44j/h3VIDw4YqxAsUYMlbgrKLZEmzx3uPjsvGBAThY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030122; c=relaxed/simple;
	bh=eGIKTzYnjiO37skilu3SIkxRrYLkPxmtPcmYL8SIszM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDHt5o5ODw6Cl3SN5DSankpBAj83+QNdt2wgsv89BoQXaAT9V5o/QX3rWp/+0GRrtfJ2zgXUtROypS/AHi71nGhsMkxlSr2A1l1jEVlt8Ug+aaq1E+3eoYUKKegVGT3x9fCaqI4bi+MuCK0ee9cDyKG/R0WV2HExwHiRY/xbeP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V+dBH7g1; arc=fail smtp.client-ip=52.101.193.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRSE9+lxiNft4ZrYYz7ECiSOad8oNIm6VIPKxgmOOwBpv+s4y+eS5i2J45XNzAsFqSie7WHJyiSMgczl7RgaUZNo56AjJxEs+dJW7UagO7U/FzqAfxr4Gv60yoeO/AG4EjByV9f+SzP1C1DUhubkM7DaPzeo7ztcrUFGTmz8Gma/DO4RoAOlqVOm4gtkyd0OKg5R7gwZqFdhBo2JfEobdFIDxcn1DcGPn+ZRkdYKiwUaRcwGxCBYqJnSrlKo6jguSI9MjaHsbPmC8UElTJrOId3CKcNLm1rYXAlphvqBpdNdVoovGq87syFeSDi4PkeTR/Bs7g2F9XZvK0cpNESaQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrubP77xkMqumAI1ZVS+28jsLZdgm0R1CglheM0BNxE=;
 b=O5hs3E+7FvvLwIYUdhE5DLGthmTwxxtacgdk5Vc13MU9LBO0b1Nleprqv5LOca7Bf0Kx/oeJePJ4NuS/i9+PXtdki3X0oo4LgCAK/3V/r++qY9wE3wza+Y4confUlrv9BnZ2p/9qZTsfcAPCGvADVR+n7QBG3OuYDVJ/4YX0jwzm1EcFLUXJJeVBnrDtzDwqmYv8TztCvuAV3HD0TWlaH7yGP8t8wy31+H9rF5qZO+dQ2pN6htWKounvZ3Vy+dG93vhWwdqV03K6reOIj3cdlzfk807x8zfAwWKRi/fQW+opxrxvw3oY5DGclLvd5s1CAPCKiDZ9posqadLyZwyTGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrubP77xkMqumAI1ZVS+28jsLZdgm0R1CglheM0BNxE=;
 b=V+dBH7g16Ld9L2Rp8KWWvYOHQ/4ZKn/mkqzxF3FM1e9oUqE4MbLUb0UQjSP2+httGtT4kE/VSzsMmbb9vVQILOQafGmhgH38U/uZvC9IyJPjT1ZkmIXqkXRqGMCQKVx8LeIlC0FwMQRO4u6D7K7o9i0OAfUuqbj1rrt5o9bBH+c=
Received: from SJ0PR03CA0291.namprd03.prod.outlook.com (2603:10b6:a03:39e::26)
 by MW4PR12MB7310.namprd12.prod.outlook.com (2603:10b6:303:22c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:15:12 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:39e:cafe::61) by SJ0PR03CA0291.outlook.office365.com
 (2603:10b6:a03:39e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 21:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:15:12 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:15:03 -0600
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
Subject: [RFC PATCH 15/19] fs/resctrl: Introduce PLZA attribute in rdtgroup interface
Date: Wed, 21 Jan 2026 15:12:53 -0600
Message-ID: <e6fbb7786b0b8cc0d2ef82f7c9a37facc42d245a.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|MW4PR12MB7310:EE_
X-MS-Office365-Filtering-Correlation-Id: 10c5e9c0-14e5-4920-587a-08de59322a5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7nuDGagfVIekqSUpHrvhh74Sg3uRsIDp5qKcFv7UYUyMKQ4vQ4k7gtUEcrYw?=
 =?us-ascii?Q?Z6VVhUOIOfyUs3wCxS3bA8KvTIkkMadevW9GXb88DBFaeyiQyuUCMNsnLcDq?=
 =?us-ascii?Q?HzGelqGHnppx4jPAOA6CzeufulR/GEVTPHuIbd/IFBkl5678DPUUcfOAX7Pi?=
 =?us-ascii?Q?dTfwvsgSdmXRUOIFjGTVQeOStESbea613ekLAja3lTYMvH/TGu97HwDBfqZB?=
 =?us-ascii?Q?DgeL/FnjSS+x/UeVy82C3fHgSUMJgwuFXK8AMXvqwYcsrb9RYaLDr7qXn7DQ?=
 =?us-ascii?Q?RhBCWFuIeciMB26yPn5rtL1hnmd00+iy2WhzJryEpqHxDZniTLpK8+cfwBEk?=
 =?us-ascii?Q?cKbPHJv5xI70xaLH8jjfbf1Nb1CN0bKa4KujitRmNwDCaNbaPnmOjkZEd6Dp?=
 =?us-ascii?Q?AnDmOD5ARKXnLVmXdaFRgfKl84fsFendK7qQso4t/9KDubqbeqRsw0W5dJmX?=
 =?us-ascii?Q?3tGq+Ce4Virxz3TJguy+YPhjnnIFhvOubYfSVF4ls3pZAH/NvQWC4u55Kze7?=
 =?us-ascii?Q?mIaaYN7Fow4vrL1bOIX1D7UX1zmI39Csqi7d32t3ZAwaaluVNZ9S3OYFFpDl?=
 =?us-ascii?Q?h9aIeEjltJm80rtbB+mLI2o/h+3NZc6XLvEQG4ya7CFoqPrhVEWfrw1AUKPZ?=
 =?us-ascii?Q?3mtBJLgVr+Feo63B0aavW7YWshhw/0d/hw8PYm0+Ww9ZhznwGsrJvP37IBMG?=
 =?us-ascii?Q?ubLox0o1+t0/kIwGoh5l0Ccwq03dmvyfvUlxGumk3ff8spGk7WDJikLa9qGu?=
 =?us-ascii?Q?g3qMTkgg0fTo2d4psFs/ZbvIhFhClgBzZQf3XSP7syAks9NVEwSgIGmasjaL?=
 =?us-ascii?Q?s32hXVTCiZ5CJwBc67uEBuvMvj5l2QOlGTlz/3OQZ23F0kjVw3SB9Ss0IEg9?=
 =?us-ascii?Q?9FgqtlkeqT9IAdbpJ1oPFxDm9u9suFFCtwCy5daAppn+hmCJmI3+ovBhV87x?=
 =?us-ascii?Q?CE8mhsw6iOD8gZ+YVbu7R9OcpzKCmoUslKj/ClA2bJFoPczATr63sZ+ezxm9?=
 =?us-ascii?Q?2fR/rJTFdED6eN9xF9i/7mgmotwwbyw4UuaGbkIG+pmjwhYdJJZ6iT0bPZO2?=
 =?us-ascii?Q?40JjR3RtXNAhuZx4ESltP7oAwGBfhSvbWY7CIhE717nZkq2rUDUleRImZYUp?=
 =?us-ascii?Q?NKfAbImuAZ0vbXPOFCvI3TLrVHUZdVgSuGjGI8pN98Jt00df228IRiFBRTwH?=
 =?us-ascii?Q?GW3RGI1SoRi28mRIxziTe9RUDM43k110hfxRM7JvVYYYd7cYCihbSkPbelAQ?=
 =?us-ascii?Q?d9S3ynbURKEM0meiM8FNzdejcs8ppK8xRcMXohbDaWmkOqtK152nfxHRBGll?=
 =?us-ascii?Q?VK83Qoa+5HL9cXhdrmnqhJlb38OXJ3eQj1ExJGY07RLj4xH4RQcwljDoraWN?=
 =?us-ascii?Q?q5KvBI2J3t5f0TxgSntJuHLLwI7pZNDlEREM19C+OSZa30DLdv0wYbdUB3Jk?=
 =?us-ascii?Q?k936N2wAEX9C9uEWEPL1zpcK550631R+daZ2b6oRt7aRc0wZGN2IGvjtamwl?=
 =?us-ascii?Q?i9oDSUTLolKhCvDGAVL3+en8cottikJPzaTLR7UvpNe3V1Qu6mGUQVeYahYZ?=
 =?us-ascii?Q?vILJn/2HtAIOBHFpYMlHwWkd8Yc4C/LjOyPqesHbqqRRKrFV+2xB0wjXu7fX?=
 =?us-ascii?Q?nFLaC2txk62/bTa8H5xr5D9EfVuxZBhjVSj9b3KFq3af6zV1FGMV9mTZBpY2?=
 =?us-ascii?Q?dtjSFg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:15:12.5857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c5e9c0-14e5-4920-587a-08de59322a5d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7310
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
	TAGGED_FROM(0.00)[bounces-68795-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,amd.com:email,amd.com:dkim,amd.com:mid];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 73F885E283
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add plza attribute to display Privilege Level Zero Association for the
resctrl group.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 fs/resctrl/internal.h |  2 ++
 fs/resctrl/rdtgroup.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 1a9b29119f88..c107c1328be6 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -215,6 +215,7 @@ struct mongroup {
  *				monitor only or ctrl_mon group
  * @mon:			mongroup related data
  * @mode:			mode of resource group
+ * @plza:			Is Privilege Level Zero Association enabled?
  * @mba_mbps_event:		input monitoring event id when mba_sc is enabled
  * @plr:			pseudo-locked region
  */
@@ -228,6 +229,7 @@ struct rdtgroup {
 	enum rdt_group_type		type;
 	struct mongroup			mon;
 	enum rdtgrp_mode		mode;
+	bool				plza;
 	enum resctrl_event_id		mba_mbps_event;
 	struct pseudo_lock_region	*plr;
 };
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 616be6633a6d..d467b52a0c74 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -880,6 +880,22 @@ static int rdtgroup_rmid_show(struct kernfs_open_file *of,
 	return ret;
 }
 
+static int rdtgroup_plza_show(struct kernfs_open_file *of,
+			      struct seq_file *s, void *v)
+{
+	struct rdtgroup *rdtgrp;
+	int ret = 0;
+
+	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+	if (rdtgrp)
+		seq_printf(s, "%u\n", rdtgrp->plza);
+	else
+		ret = -ENOENT;
+	rdtgroup_kn_unlock(of->kn);
+
+	return ret;
+}
+
 #ifdef CONFIG_PROC_CPU_RESCTRL
 /*
  * A task can only be part of one resctrl control group and of one monitor
@@ -2153,6 +2169,12 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdtgroup_closid_show,
 		.fflags		= RFTYPE_CTRL_BASE | RFTYPE_DEBUG,
 	},
+	{
+		.name		= "plza",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdtgroup_plza_show,
+	},
 };
 
 static int rdtgroup_add_files(struct kernfs_node *kn, unsigned long fflags)
@@ -2251,6 +2273,14 @@ static void io_alloc_init(void)
 	}
 }
 
+static void resctrl_plza_init(void)
+{
+	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+
+	if (r->plza_capable)
+		resctrl_file_fflags_init("plza", RFTYPE_CTRL_BASE);
+}
+
 void resctrl_file_fflags_init(const char *config, unsigned long fflags)
 {
 	struct rftype *rft;
@@ -4609,6 +4639,8 @@ int resctrl_init(void)
 
 	io_alloc_init();
 
+	resctrl_plza_init();
+
 	ret = resctrl_l3_mon_resource_init();
 	if (ret)
 		return ret;
-- 
2.34.1



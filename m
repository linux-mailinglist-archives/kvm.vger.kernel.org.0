Return-Path: <kvm+bounces-68797-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNHILyZEcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68797-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:24:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 535C35E002
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:24:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2CEF5883819
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF82144B695;
	Wed, 21 Jan 2026 21:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="n7DP0tSO"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010050.outbound.protection.outlook.com [52.101.201.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF43449EA0;
	Wed, 21 Jan 2026 21:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030131; cv=fail; b=cRchVRqoH2Tsu9FFKGZik6H8ER8WluXpdtjKqRhCWYgc6UntMCqxZCNfGQNp0GZzEF7O6aVCKs0HY5MuDXZLK7ZDCexsvstBRz4UMAqQLOWl7oo48g/GT5wd4ebCDbZWs0pEQjzzK6kmMEnvVpZ0vA44yeTN7f/woFlWOG/tExU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030131; c=relaxed/simple;
	bh=h/bQjCarL7StpR5IgKz9pHqE2EH+SdkSyHVhb//1ZU4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdQ5hGmAsbTmB2dUBtPc3dQOPBrucQ11f7qrnCdI6S5u0/JUYlU0JGcRP+8skLUvbben/QD6LWXpwzsCxH/clA4tW21cTro2l0/Wv6tX6wrXmcyQM3rqf9FDgm9yXEOQ12FmNnsBdX0E7UVqz4SC1YyXrEXdBnUYaJQay3+2/CA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=n7DP0tSO; arc=fail smtp.client-ip=52.101.201.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mkix79O70GjlcHIqTMflrlgfTc4XvcVuptK8aG4DB9o0Ap6dLCcTYbA2FvoWJ6+WpWI2slLygxjcTIUiBn++ByQX+kVP5xUgABlBOZBKHXS1rR6GqwiRjAgkLzscyW2W0syyH3OHnILirqGD/u6IBCUbACszoVxcONy15juGBbAm7bfn517sVCsCiWeUYuTPjFcY1uLsSaRclnlTkmC4JZfDD622EScnsnt7T+hYJN5nLeOe53maK8AArC1HDXWGNNxtStERdEO7zFMcg32Mwp6eWLroob5c9I8ZJxq1N1OljxwsRSlMa6HYKkG3MyMzCvdQ5x9unrZiAr+aI7nICw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skz7OdnAoWnCtXKIWjkf2IYibfdIXj4yeG7h2r4qG8s=;
 b=DI3hwdGZdHWtAt2yTxZGGMQ6p2SmkPomvFcv0TyN+T4sJdwi0R01DtpmeYvM4osGIflpPLwTqoZnBF7bs99FeNsSHmup7aLockfgOuVDTzixHHjjbdk8zDWZB0T3lDr63uf0WWqrCxcxyFdRj5/svF3z5yQsjoGHD+wDw7voqd85G5V5RtXZNCuZKhZPetuEfZWbdOEBdKmP2TERVIqU58GUpo7kU1nCfvACt+gghvvFUTPYiKRjApp0x6PcxaCJAYpbA1SZnmi7mJ8JQXGmUwmRHkiKF8GN5AOpUNjGezlGzO2i60DUwIz3JlfpdtgWkYVY8CLYGgOGd2VGLe5PBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skz7OdnAoWnCtXKIWjkf2IYibfdIXj4yeG7h2r4qG8s=;
 b=n7DP0tSOEmiFPZbsxty6JMNCRB7y+gBrfjok/Ey+brCjrQgRcD1m+pYfKs6iQlRjiQEZ6lVp7OrWjS5gqdSsbqYqlerKJlOhCYeoVdA4YGwaDdp1Tk38NgeznJid4uXe8yipi/J9yVCGZ3V/aHNiIqIz1lM8wW017wb9KeC0JsQ=
Received: from BY3PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:39a::19)
 by DM6PR12MB4203.namprd12.prod.outlook.com (2603:10b6:5:21f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 21:15:24 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:39a:cafe::58) by BY3PR03CA0014.outlook.office365.com
 (2603:10b6:a03:39a::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 21:15:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:15:24 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:15:19 -0600
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
Subject: [RFC PATCH 17/19] fs/resctrl: Update PLZA configuration when cpu_mask changes
Date: Wed, 21 Jan 2026 15:12:55 -0600
Message-ID: <f2afd52c55edaedbe410274065049d90a763a136.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|DM6PR12MB4203:EE_
X-MS-Office365-Filtering-Correlation-Id: a5902eb2-ad84-46fc-3d24-08de5932315a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gj+Uufe3v815hmAAeOP0dzMvqZBk63qErUpHMY0VUiw18TSgx3Ep32NhW2vW?=
 =?us-ascii?Q?yLH/pgEi3XOA6GgP7Y+V8Dy/THTHHQxbvNSJkuqDNK2GLh8F8gTxLGnUG3FB?=
 =?us-ascii?Q?gvUcKZJ4BBPOskqQ7EDXYXroMKzPVodhNTX9tOC8Zx33Gjs/K/fjdok1Gjfc?=
 =?us-ascii?Q?z0doCfJvX9MG6dmeF2bXGKTnV2US5J92XIifqSHjuhi9FkrkgiLDZjYyPkbz?=
 =?us-ascii?Q?rmmmyMv5wpD3v5PjmnNe6+gLke8X7J7ErnBaGaBzZStbBeAxMjb5u6w2r6us?=
 =?us-ascii?Q?nZd7pFCMhhHec+YmYSe6rrPIgU+cApl0Qc4IzBggxXYlBZRqI8KLb9eIx9sB?=
 =?us-ascii?Q?gDoMi/+WLnQTP9SI4JKVQf4fSmrbszMVJTCYwmnT8FO5KxA5GYhYEPPBLvsX?=
 =?us-ascii?Q?g+hQPyvuzdQmh8aaVinQwmQa2oYcEs5iY5IkkdWXqA/WHQnvRiXlzjPJSmZD?=
 =?us-ascii?Q?2E9MOZWNWeUoPJw8+7DblZPNd6fQiOtdoDtVfX/TunyJgTWEDGuofu73wwlz?=
 =?us-ascii?Q?H/7SbwgpFo/uL/c/yif615x/zbWqqQ1cbXKBxj5xbMGQLJ1x3daNSN0jKmZj?=
 =?us-ascii?Q?UBImDgC2fAdWtt0L0dF/kVFBIJ42a8rJhRbatcMczsEo5mShPXsBTWxpLIa7?=
 =?us-ascii?Q?xqbZ9GP5ldm6JWQP0cFZMJLewLF9Q44dvtgZDHf0WvtznbqIl5mdDbPASfaW?=
 =?us-ascii?Q?6H4IoJMFr8Z7iXvbSZF8ZgazEW2vA1CwvSnaqkmd4CtdUwmnI3zy1JAOGf74?=
 =?us-ascii?Q?jmBbrMs1/BBkbPKNt3Q2MT9mykWJmqUngEP0y7u3vlOVJV0Jb64Dcpy4iCXu?=
 =?us-ascii?Q?yYfBGDxiwoVJv45tCkA9yeqA1Egr9q0tvqn7Jt3nJs0B39do1tgfae4cMwUU?=
 =?us-ascii?Q?ma5qP5Ictxlh5N+F+chNoOJl30CoAA91SOqaH1hCJIiwIVVgjbr8RmsDQftZ?=
 =?us-ascii?Q?KDcDN4nBHrDaKhVHcKM9utnCbgYMJ7+ea3+e9kRb7zdw1Ym4oyHrjefwfwEr?=
 =?us-ascii?Q?YKkyOAkEgwAYipJCsjJoBHCD8SiF8GyIG0Z8ePnToMVJcz4aAe8jDa0XxMNH?=
 =?us-ascii?Q?hCz32sSvdEd3qoSuxQw7v4Nl8y2q+/ZRF2yolh0y7+QSPCUKsIIsbyo3Y0Xp?=
 =?us-ascii?Q?UBhkJk/Y9zHapPsOYritHUq82iVqm5Ew0Qgk+38FTT0s9kzv9+8GvWJ1IYNx?=
 =?us-ascii?Q?0P14Yj6MxJnFPNoxEOj1hqjg1OX3PzvKzQ1VeSPUUZssiSe48uAgb+fZkHkL?=
 =?us-ascii?Q?pF49oFFTH5YgneimVM9JH0ZjiZi/26h410XApe9IRJnv2IbKTC6ERnrge7pm?=
 =?us-ascii?Q?9ykHIDRT3NJh2xy3yrxXVcY056/hk6/JMpf+M2ItJOIYtWkCnpdDCPl2iyq8?=
 =?us-ascii?Q?u5yQO1M6ON+oDxOQGTT/YUVdLU/OFPxD4vZCY8dXLsMNwNFdOUAdP2u6I4VP?=
 =?us-ascii?Q?KN+oAWWxihdm2fce1FJSJC1uCpBa1bJNOtjBK5FGh8aFZHyaIQqMU/07wodF?=
 =?us-ascii?Q?ADNSxa2rRgKXN26LbGJAvfk6Zya7ok7PbnVm3XgMTr7RPyFEJwTH2LTfl+YX?=
 =?us-ascii?Q?K7YW5HEqINqv6lfH4iN/aMgC0zFAifdZExJ4564GbwR4Zsi6i5VxqB7+2RqM?=
 =?us-ascii?Q?lYiu53fzhvuXc/lRLXxqK2plz0ugOTBNyz6XybndEOGxquGeKbm+pVyrLws1?=
 =?us-ascii?Q?2gKd0BGiRwC1GZvXBLynATzhkCI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:15:24.3603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5902eb2-ad84-46fc-3d24-08de5932315a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4203
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
	TAGGED_FROM(0.00)[bounces-68797-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 535C35E002
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When PLZA is active for a resctrl group, per-CPU PLZA state must track CPU
mask changes.

Introduce cpus_ctrl_plza_write() to update PLZA on CPUs entering or leaving
the group.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 fs/resctrl/rdtgroup.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 042ae7d63aea..bea017f9bd40 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -508,6 +508,33 @@ static int cpus_ctrl_write(struct rdtgroup *rdtgrp, cpumask_var_t newmask,
 	return 0;
 }
 
+static int cpus_ctrl_plza_write(struct rdtgroup *rdtgrp, cpumask_var_t newmask,
+				cpumask_var_t tmpmask)
+{
+	int cpu;
+
+	/* Check if the cpus are dropped from the group */
+	cpumask_andnot(tmpmask, &rdtgrp->cpu_mask, newmask);
+	if (!cpumask_empty(tmpmask)) {
+		for_each_cpu(cpu, tmpmask)
+			resctrl_arch_set_cpu_plza(cpu, rdtgrp->closid,
+						  rdtgrp->mon.rmid, false);
+	}
+
+	/* If the CPUs are added then enable PLZA on the added CPUs. */
+	cpumask_andnot(tmpmask, newmask, &rdtgrp->cpu_mask);
+	if (!cpumask_empty(tmpmask)) {
+		for_each_cpu(cpu, tmpmask)
+			resctrl_arch_set_cpu_plza(cpu, rdtgrp->closid,
+						  rdtgrp->mon.rmid, true);
+	}
+
+	/* Update the group with new mask */
+	cpumask_copy(&rdtgrp->cpu_mask, newmask);
+
+	return 0;
+}
+
 static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 				   char *buf, size_t nbytes, loff_t off)
 {
@@ -563,7 +590,9 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 		goto unlock;
 	}
 
-	if (rdtgrp->type == RDTCTRL_GROUP)
+	if (rdtgrp->plza)
+		ret = cpus_ctrl_plza_write(rdtgrp, newmask, tmpmask);
+	else if (rdtgrp->type == RDTCTRL_GROUP)
 		ret = cpus_ctrl_write(rdtgrp, newmask, tmpmask, tmpmask1);
 	else if (rdtgrp->type == RDTMON_GROUP)
 		ret = cpus_mon_write(rdtgrp, newmask, tmpmask);
-- 
2.34.1



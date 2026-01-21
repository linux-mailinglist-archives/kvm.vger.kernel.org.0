Return-Path: <kvm+bounces-68791-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJctAX9DcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68791-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:22:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 695285DF84
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7D9B0664EE7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5F643DA26;
	Wed, 21 Jan 2026 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OQo8KIfF"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012047.outbound.protection.outlook.com [40.107.209.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB8F42981F;
	Wed, 21 Jan 2026 21:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030085; cv=fail; b=gJABeeKyDxXWe8EnjVKCJaWjUAWRr/TmX4hG7+jr+VNuzNJD99vqPm9sE8X6no0sczCE1MhaFGavxVcp+kRSShqBYyw3SqbotZZOIZrz5CV5yc8kDlgogFyYxuL2nbjcf4B91C7KwiaofsVCcv0KmWmnNjQFv1Ebh2nL3OJ2Wfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030085; c=relaxed/simple;
	bh=keyDIbB+DsOToFMczIvTaElavnVua322jVgPdVzNT18=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YswOuQeFVNdhJ2lk01y4RhFB5lIifC6Jsu8ZVlG7kuLi1TwXAT0tRoRtvlNvpZHtfiphbeyKvBL5vXUH/rzgkwM5zAvfOnlzda/m0v65tyD4AouZdZQSt8fyNtvvFN+OEqaqQsgGQWuseHkAMNZwUITRXtAnt56hVqNlH7DylR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OQo8KIfF; arc=fail smtp.client-ip=40.107.209.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q2sSsER0Pizz/XHOJ4/vDNd9r9JVYodDyRsKm03icPfh86NINKUqXTuAK7b6+eWKJnZIGxDf/JwRG1iy1I4HXuRtUWFH5YqexA7k72dBC7fQZPb5WKATkcJOnbrUfidKnyy1RGAx+9iK1MpbFbF7aSVKDFc+bBxaqaLnKROFAcPfE+21av2LZ25hJbsQT8rediM8B6GT8TrEHY6kNncj9kjOvsqnnLzs8LD2cn8mvXvTlDWz1BbA8ivydQPYKx/i5idQpm2AIK2sZIehE7oBnOF/snH1moLbOM57ybgveqR4zfCWsAgfpdLQtqUmWSDq7WVGtPIxTap5hweDn84uig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+f5Aju4xTRtSE1hOox5BhFE0A3pz2SwFoszUzV9hMw=;
 b=fh6TKEOom61ymDIPrVVaUs9qaRqhaZl8Lg4sw3ycHT4kmJmYohhLxOHB9DpfAonyHSGkdk3U8LLXDEA34R9va//5eMIMQDvZ+gGPNY+nS8XuE4soWvttcvPjnrDsXfisrK1BAyd5JS6TyILZ4/KFw2r0RklRnMlSnDzoDWHrfF1zhlzMPSHy69z/A0UNJTK9wABc+eS4t4Ur4rLoboGFuY9VPfrMDmRCyzQF6uyXnBm9+mkdh/2MVAZyYyoB2Dymta3is9JhbTLx9Ex9kB3MjSy/bAWJDxosYfBvnWH9oN8qIUPbreNPrapL2KFxPeo1Sn43bZIjQoglWG+j14YKsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+f5Aju4xTRtSE1hOox5BhFE0A3pz2SwFoszUzV9hMw=;
 b=OQo8KIfFLvjYFxbpyhBqLygWSbC3EJqG5z1CAG9ow7cq9iIzftfQsO4HO6pDSJF2hK4OnpaZqbO5RdBbsrAA7pkTUgmVxxjuIMhV69xr2M20nHB6zDBnk4CtqfWdNOC4ihyuKXol5G6DuClzzuMRg6GnntDxJ4QOJPFHIWzIYBk=
Received: from SJ0PR05CA0047.namprd05.prod.outlook.com (2603:10b6:a03:33f::22)
 by PH0PR12MB7905.namprd12.prod.outlook.com (2603:10b6:510:28b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Wed, 21 Jan
 2026 21:14:37 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::83) by SJ0PR05CA0047.outlook.office365.com
 (2603:10b6:a03:33f::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.8 via Frontend Transport; Wed,
 21 Jan 2026 21:14:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:14:36 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:14:31 -0600
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
Subject: [RFC PATCH 11/19] resctrl: Introduce PLZA static key enable/disable helpers
Date: Wed, 21 Jan 2026 15:12:49 -0600
Message-ID: <4269529e1623128265ad2ee9915ab5e653b156b5.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|PH0PR12MB7905:EE_
X-MS-Office365-Filtering-Correlation-Id: b35324e3-c5fc-4a4b-ec4b-08de593214ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D4gde3QbqcD6hepsTzpkYgfnFX9JbqJN7uvE+7VdIfIB+so3R9YiqZz/CNA1?=
 =?us-ascii?Q?GAxtYo9ppBRocsvCFTGaUFep4Mda14ZW9SXICTxaFqcdioDmuzHcMapzXFrJ?=
 =?us-ascii?Q?e5pJPCBu+nBv8kRtbkzAOGtKGiSU9+e6F7XmtDaR85EsBZlvGGOU5W7F4DDx?=
 =?us-ascii?Q?uT0z0JfDEmpuHzHRnPRD2RY66CkfgCyHgKfRxA6wkRSGEYzi64dK7NO2W3+x?=
 =?us-ascii?Q?neLoUaoAvCT4qxAJXpN58jrXfNfKwvetnw1UQJ/n7Lh16cy/5Wdc4M2SExN3?=
 =?us-ascii?Q?bTYkyLvlEqMI1Esg/kWs6dIKsk9UhECWB/Rrms9Mj5mTmyecPFW5KJ5hMjA5?=
 =?us-ascii?Q?tmaJzJiSRrQ8q1N4Yj2OPiA7y3HjEmFn+kSd3GArdTNPMJHY0Jie7cRr2vIv?=
 =?us-ascii?Q?fjz+LqxuyhmlhN/44cK2TnDScGwWpuARlNuKMP87bdl/f6rKDE01EAkuz7ts?=
 =?us-ascii?Q?XDGSRH0MY15zB3wetDfr75JC9Pr1t05DXh5SVJwiFaPe36bti1PO6fbxt3OV?=
 =?us-ascii?Q?w4zGcurvjlq9jFl+sWApedM8eDKZAOjNb0VqQ/2pFaLcsI/SQGVHIReFb4X4?=
 =?us-ascii?Q?pFrsIlueRqbyQzc55OiFO6Sb0/YS/pIRsZNS9DnMkgEQ26KpdQDLgo/aJmsh?=
 =?us-ascii?Q?ls8YoALpSooeYENuqOxkrqA44zt8Bb9buXNZ5r12AtESOBGjyuaW5Is/VT1e?=
 =?us-ascii?Q?Dt/UvHzks6upzIGilX9m1gJN7Y3IAy4atYtuR9+rC7xozhfKJezZRvg0FyfD?=
 =?us-ascii?Q?ohw6tdYQ1JHaZDRZ5ECU0wyfhQkCCkoEOQo1G7NFd8W10rFwWuUZMLFrIBo/?=
 =?us-ascii?Q?hDvqx6rjb6HU/8D8Jmbq2chhgQscX8SB96AtG5Wq8b0pD8Slma0LEYpdsYlo?=
 =?us-ascii?Q?hgRT7UKXaoJBiyFj99noBx+vdDYeczE8wrMGttcpQb3f08iuqrYfZL6OtKku?=
 =?us-ascii?Q?QCUL7vHSGmVmm281mePVzLudTe+6XY2liKcv+zoribWC3qGgw8rm5iQCZqld?=
 =?us-ascii?Q?8NpovR3d72C/L+PpnoFxkuW3mnD5xQW/FdJwHL2+4zVn3BRfiW6NNklEh+ru?=
 =?us-ascii?Q?yqmPgDBZ5vpLS+o86PWfFPSJP4xMlIrBzDjdW8pTwEgS5j3XpBtWCu+iOBYe?=
 =?us-ascii?Q?5j8/7Y9HGD302lDwhFIR0nF93TO0oVl6DjGtI2cuUg9v+Xd3Lskr+xNDKNmN?=
 =?us-ascii?Q?l1a3uL1wWt7HRlIlpf9rYufv9jdGRtLysC9zK2fi6Cn4MVQbysSEHDoCNArD?=
 =?us-ascii?Q?CyVRvj+AU7ob31W0/pIHWZjTxnduIu6WlJoZXQl4joxLFSLYXEv5IpmBXPvw?=
 =?us-ascii?Q?F+oqlmHnQHFYQAFC00iBDYy36jXJdGeNLfIMowxTanijFw4JTBJ2SXUqdT0E?=
 =?us-ascii?Q?M22VWLj1YlB6uoWd1WlRIOKDDMc19yyB5/10mhWs14lO5TQNUbE+YVMQdeo2?=
 =?us-ascii?Q?946onGXMRlRn3hGp3dw10uWM5Gm3WSRqatwTTZHmJNViIpA9o+DqPkG/lpWc?=
 =?us-ascii?Q?zx9vuVnuV1hGziHHxqOXjArMf7QXjFJhsH81LDusxr+HaXkCWcmELlVI2cul?=
 =?us-ascii?Q?1T5R2g2bfCyEbGyqbp5j7zbcskTuJE2CzvD2+PbPzaoesTYqycHBKCYLqKP3?=
 =?us-ascii?Q?2e4n1XgygEHt9/WdRpqgBvajhXyPwT98YFO2Ox4ipmpur2MdEQEFqzFtVe7b?=
 =?us-ascii?Q?nCJFTJzMi2Nzbqec1dZJVSuxG/I=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:14:36.6284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b35324e3-c5fc-4a4b-ec4b-08de593214ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7905
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
	TAGGED_FROM(0.00)[bounces-68791-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 695285DF84
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The resctrl subsystem uses static keys to efficiently toggle allocation and
monitoring features at runtime (e.g., rdt_alloc_enable_key,
rdt_mon_enable_key). Privilege-Level Zero Association (PLZA) is a new,
optional capability that should only impact fast paths when enabled.

Introduce a new static key, rdt_plza_enable_key, and wire it up with arch
helpers that mirror the existing alloc/mon pattern. This provides a
lightweight, unified mechanism to guard PLZA-specific paths and to keep the
global resctrl usage count accurate.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/resctrl.h         | 13 +++++++++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  2 ++
 fs/resctrl/rdtgroup.c                  |  4 ++++
 3 files changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 575f8408a9e7..fc0a7f64649e 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -48,6 +48,7 @@ extern bool rdt_mon_capable;
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_mon_enable_key);
+DECLARE_STATIC_KEY_FALSE(rdt_plza_enable_key);
 
 static inline bool resctrl_arch_alloc_capable(void)
 {
@@ -83,6 +84,18 @@ static inline void resctrl_arch_disable_mon(void)
 	static_branch_dec_cpuslocked(&rdt_enable_key);
 }
 
+static inline void resctrl_arch_enable_plza(void)
+{
+	static_branch_enable_cpuslocked(&rdt_plza_enable_key);
+	static_branch_inc_cpuslocked(&rdt_enable_key);
+}
+
+static inline void resctrl_arch_disable_plza(void)
+{
+	static_branch_disable_cpuslocked(&rdt_plza_enable_key);
+	static_branch_dec_cpuslocked(&rdt_enable_key);
+}
+
 /*
  * __resctrl_sched_in() - Writes the task's CLOSid/RMID to IA32_PQR_MSR
  *
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 540e1e719d7f..fe530216a6cc 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -38,6 +38,8 @@ DEFINE_STATIC_KEY_FALSE(rdt_mon_enable_key);
 
 DEFINE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
 
+DEFINE_STATIC_KEY_FALSE(rdt_plza_enable_key);
+
 /*
  * This is safe against resctrl_arch_sched_in() called from __switch_to()
  * because __switch_to() is executed with interrupts disabled. A local call
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index d773bf77bcc6..616be6633a6d 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2910,6 +2910,8 @@ static int rdt_get_tree(struct fs_context *fc)
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
 		resctrl_arch_enable_mon();
+	if (resctrl_arch_get_plza_capable(RDT_RESOURCE_L3))
+		resctrl_arch_enable_plza();
 
 	if (resctrl_arch_alloc_capable() || resctrl_arch_mon_capable())
 		resctrl_mounted = true;
@@ -3232,6 +3234,8 @@ static void rdt_kill_sb(struct super_block *sb)
 		resctrl_arch_disable_alloc();
 	if (resctrl_arch_mon_capable())
 		resctrl_arch_disable_mon();
+	if (resctrl_arch_get_plza_capable(RDT_RESOURCE_L3))
+		resctrl_arch_disable_plza();
 	resctrl_mounted = false;
 	kernfs_kill_sb(sb);
 	mutex_unlock(&rdtgroup_mutex);
-- 
2.34.1



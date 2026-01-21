Return-Path: <kvm+bounces-68786-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALTVFsZJcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68786-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:48:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BA38B5E447
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B48AD3ABFC5
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66296428484;
	Wed, 21 Jan 2026 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R8kVpwoL"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012057.outbound.protection.outlook.com [40.107.209.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC2D4266A8;
	Wed, 21 Jan 2026 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030045; cv=fail; b=OBJn9IDyNVPcXM+nEP87KQlbzTKMzADCDUMOXQGVO/BQY5Vquxb2E53EW5HSVQIucT8NPsT6LfDVimNsT1r78/xC5tajC/2PBJCHk/Y9cFJBeK7xo5P0WQ1AmHNoIueI7VUWuFEri9bfl6bqJ1S6TM14jx0fuNk55Mh3EOi5pkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030045; c=relaxed/simple;
	bh=0yw+QGOG5FsjUpsFM0lRz+XbBCi5MllTwgsXV4dnWtk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SUFqVMZkTQdhRrTJIIqw67DuJsU65XZkK7OSX0YAOJ00DNmeJJ4Jw272SOm2ivZKUDESiz9zbxl7qgxoet2+OpxD55ri0onLdBAiNYkbIwxwXwI2tmTlcs8o7hH26B6CQ+Af7/+oMUWy6YXud/Dlyi43ozOYue4ln7zGlw0gEvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R8kVpwoL; arc=fail smtp.client-ip=40.107.209.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJPe1u644YkWy0kCk09/hGpDSepc08AM2f6huyLA0GPdR6Ikq1s1C1+YFrEFlUlokE5SSZ7gNBn6rr10Hri81qt/1N3c0L76GrX7HqceSQqxGm+I03APdt0VIecOrhdBh+zwFlJxnT7j8eocXGH2Bw+TeLW1OUaifoaULmukuHoHxt0pOOB7q0U2VPk7Nstu+Mfd8+XUAry/9qjMabmKyEpkY4HVBqNsQH0v6JvzozE5ONVROZ0lOhKXhsgIaf9Lup14pCMFcreYh1yW67OFNHgdSjsKdWVZqEVVes4WyGGAUGIG0aMBQo9+VQPwHtTwV2/MFUY5UsIZEqUMFYE2wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21bvvTCZp7ro2MXXcK1LQRhUC85Y/qfoDMFT7WCz3dg=;
 b=FaKr6BG6hsp97cID0Efi/xcAlJGa1fQigRf75pqmc5kzHPrYwwBA6QrrOxyzmLm5UZvye7ucJr1LUefPLOGJVAIxMQJGef6NB2/09jFAtzBkpjtYzdDBPlsngQElVDw+ZscsIyI4ulrHcOsLmIs8dJQSS6cEM/3/l1Sp+2qVybE1xfxlJAecIQUWQrCq6CMPHN0oQdhD7RgBMWHCiH/Gi38xxpCk/6mMWuiVJP6ecJc+jvfT5HnSp7XVyu7s+pcyeaFVCT7X3R4jrx3QVcD6TAcUZEjzRf1PV/KbQ0NGiOAPP2K/xR5M8eBLDwfPQSvFw+7BjDFXDHVmWhy750pi6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21bvvTCZp7ro2MXXcK1LQRhUC85Y/qfoDMFT7WCz3dg=;
 b=R8kVpwoLeykQPatNsPrUZCllj2Hu4ktk0537iZ8xdIefhdz9C/GluBtnoCPIznje0/5it7CXbnfPRZGPECoIwHFRxWRgjbSUKHtse+n6ea13bETFo2dIsDkts0nLmXLbB0JpV5Y2IUOlgPiQLCTWAomGBoeVcq0UCtED2N3u08U=
Received: from BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::14)
 by SJ2PR12MB8740.namprd12.prod.outlook.com (2603:10b6:a03:53f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:13:57 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::2c) by BY1P220CA0001.outlook.office365.com
 (2603:10b6:a03:59d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Wed,
 21 Jan 2026 21:14:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:13:57 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:13:51 -0600
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
Subject: [RFC PATCH 06/19] x86,fs/resctrl: Add the resource for Global Slow Memory Bandwidth Enforcement(GLSBE)
Date: Wed, 21 Jan 2026 15:12:44 -0600
Message-ID: <d712f52434d78d0ed14ffa22a1ffa4765f67cc3b.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|SJ2PR12MB8740:EE_
X-MS-Office365-Filtering-Correlation-Id: 8214b571-b788-4d92-a30c-08de5931fda7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9PSaHjgAyZF5SM/5NNduhUvl+6RwIJ3AzguViM0rIx+PXAzJ/CP3E6+YGKZD?=
 =?us-ascii?Q?SLRiP0ooMUcHsNERoe/6TRMp5S+pgvISAG1EQAharJV/FBex7ec4xq4IDmlW?=
 =?us-ascii?Q?VhVn8/O1tCH4H6OUSrf+CyrzLNb2Kq4r6v2tP1yiwZ5YAQCfcymSVOcSoWeB?=
 =?us-ascii?Q?U4zSE9eAeXwTMCt5vnU0NHmtxe8oSoPhJVK8cIz5ugfRp+NamD7zazdujGOZ?=
 =?us-ascii?Q?w7jlJW4y+aGC3381V6AP0doN4u0xPrYIklFISAlEznKXUui5hZNve/zZtTqX?=
 =?us-ascii?Q?qNoLgYG7CTmLBJSs6VEzz4r4OdjiLv95XSwKfwU5n64vMABEMhTzbRiqRWK9?=
 =?us-ascii?Q?dKEEpuSOck0Sql2quFzD6R68ZAfXl02wtwTNBgvNpH7gOcAM4tGS40FOwqaB?=
 =?us-ascii?Q?hWqVopGs/f4UMvjQEdXaEx7e8PserZ88nJaPiDTyDQXt69vF57EGjyi3MA/p?=
 =?us-ascii?Q?mDUKVhBLptX3Zx5s2P5XANi+sqSm1MXjY3+JZcRarL1aqeKh83mrmnrCAL2K?=
 =?us-ascii?Q?PQXEmpP7H4FWJjmIxQLfY4xSKFsRhBHF6k4pTPVM/6UX3H6lfXzOs83WTTwL?=
 =?us-ascii?Q?XdDrMvjaFQCwOvjnr8UuKMUjpachNqNyepDT4/sSUMEfkG3/lSQf90wVC+yo?=
 =?us-ascii?Q?u4+avDiGQYo/1lEkD0pr+0FxICuBD7fJbcrHQDfIGLvgTedle43iG7ss8+S2?=
 =?us-ascii?Q?QnKw543hcbWeUSdzylfFhIiFgMCCN+Uf35sQbbXs3ItT+WRBg0wGFniEFsZy?=
 =?us-ascii?Q?/EcsHR123LvuTgMzPaOqc7uKwpV30DrbfbsAbPu++hxMjwzR6/Hr6hx0cRJz?=
 =?us-ascii?Q?BQDa3090+iS+5F7g9UucKHIgaFdE5MMQwVHVQsXf6LqTmDp5DhgtvuuJSvUb?=
 =?us-ascii?Q?Os+LFXcEeI/PcKOeCXa7RNCR3P/bmc8k2nTdo1fkTwmaxk1Efgvte9VxT8Ey?=
 =?us-ascii?Q?ipYzL1T3Tx1N//ZaZUE4SFqcnc/8ivVgp7XxC/jvDwn6nUY4vg2eM7Sz7eS3?=
 =?us-ascii?Q?IWfSrWKv+Uj809dx8WMyZ16VF198j/pYv1IRQi6rtao8lyaCzo8MwIHuZv3w?=
 =?us-ascii?Q?2MUjrWa29ddEfA4D1UReFn+Z5hEjmxGbldoQ4+nGuYIiQNU3UfqaUJ8b+GIb?=
 =?us-ascii?Q?khxV2sjw5TVCf0DoSvDACaSZdUno5E9ivyEJdpnROwrmzFOJD+DSAqXp8vVi?=
 =?us-ascii?Q?8aYPlvARxlole+BwmfCz2qBk/W1jwqFrDOyOF4oI1ES10oqV7mDFzUwVATIx?=
 =?us-ascii?Q?PZREgW0MqgCuRHIctYdaM7TwiesCIEg4IAyg/TUgoxkokKJJXsMgdo9TpCPS?=
 =?us-ascii?Q?QYeM2vmCk5rxZt1OkQ7pPqyYYGSDW5sALDOvyWLddDkKr9hEZmyK4k8AKVVX?=
 =?us-ascii?Q?Ot69iWorTXs6ErEF72x0Jp+PM0+PipRKR9Z30E+V00rixrZPJs5h4mKWTk8k?=
 =?us-ascii?Q?g9e6qDstfcgrniTdS9TKEASOJuNw8L7dD2ttoBx9aha2pPQo0GRqNEbKbZmB?=
 =?us-ascii?Q?ihrlg40koxNneG+0wTO9XtVqUFgkt3mFIcxroMxpAj1SFqpGPfbzDN1TtQiT?=
 =?us-ascii?Q?Ev0q8oS9KCEqoz68MNy8T4bd4lzo2qXZRkP9AOKjOj29TfvoeDCr4tUjBdr5?=
 =?us-ascii?Q?kzOq6w+JrYd8dx2hkHQ+BH/OD0gIVNE/7qrtGHyYM8FKflMONgvtf0ohU1Jk?=
 =?us-ascii?Q?YHIm3pBlscA3QFVkRtD8UJRcjtY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:13:57.5997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8214b571-b788-4d92-a30c-08de5931fda7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8740
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
	TAGGED_FROM(0.00)[bounces-68786-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
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
X-Rspamd-Queue-Id: BA38B5E447
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

AMD PQoS Global Slow Bandwidth Enforcement (GLSBE) provides a mechanism
for software to specify bandwidth limits for groups of threads that span
multiple QoS Domains.

Add the resource definition Global Slow Memory Bandwidth Enforcement
to resctrl filesystem. Resource allows users to configure and manage
the global slow memory bandwidth allocation settings for GLBE control
domain.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/kernel/cpu/resctrl/core.c | 31 ++++++++++++++++++++++++++++++
 fs/resctrl/ctrlmondata.c           |  4 ++--
 fs/resctrl/rdtgroup.c              | 16 +++++++++++----
 include/linux/resctrl.h            |  1 +
 5 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e9b21676102c..0ef1f6a8f4bc 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1275,6 +1275,7 @@
 #define MSR_IA32_L3_QOS_EXT_CFG		0xc00003ff
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
 #define MSR_IA32_GMBA_BW_BASE		0xc0000600
+#define MSR_IA32_GSMBA_BW_BASE		0xc0000680
 
 /* AMD-V MSRs */
 #define MSR_VM_CR                       0xc0010114
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b4468481d3bf..cd208cd71232 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -109,6 +109,15 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
 		},
 	},
+	[RDT_RESOURCE_GSMBA] =
+	{
+		.r_resctrl = {
+			.name			= "GSMBA",
+			.ctrl_scope		= RESCTRL_L3_CACHE,
+			.ctrl_domains		= ctrl_domain_init(RDT_RESOURCE_GSMBA),
+			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
+		},
+	},
 	[RDT_RESOURCE_PERF_PKG] =
 	{
 		.r_resctrl = {
@@ -261,6 +270,9 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 	case RDT_RESOURCE_GMBA:
 		subleaf = 7;
 		break;
+	case RDT_RESOURCE_GSMBA:
+		subleaf = 8;
+		break;
 	default:
 		return false;
 	}
@@ -958,6 +970,19 @@ static __init bool get_slow_mem_config(void)
 	return false;
 }
 
+static __init bool get_gslow_mem_config(void)
+{
+	struct rdt_hw_resource *hw_res = &rdt_resources_all[RDT_RESOURCE_GSMBA];
+
+	if (!rdt_cpu_has(X86_FEATURE_GSMBA))
+		return false;
+
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return __rdt_get_mem_config_amd(&hw_res->r_resctrl);
+
+	return false;
+}
+
 static __init bool get_rdt_alloc_resources(void)
 {
 	struct rdt_resource *r;
@@ -996,6 +1021,9 @@ static __init bool get_rdt_alloc_resources(void)
 	if (get_slow_mem_config())
 		ret = true;
 
+	if (get_gslow_mem_config())
+		ret = true;
+
 	return ret;
 }
 
@@ -1099,6 +1127,9 @@ static __init void rdt_init_res_defs_amd(void)
 		} else if (r->rid == RDT_RESOURCE_SMBA) {
 			hw_res->msr_base = MSR_IA32_SMBA_BW_BASE;
 			hw_res->msr_update = mba_wrmsr_amd;
+		} else if (r->rid == RDT_RESOURCE_GSMBA) {
+			hw_res->msr_base = MSR_IA32_GSMBA_BW_BASE;
+			hw_res->msr_update = mba_wrmsr_amd;
 		}
 	}
 }
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index ad7327b90d3f..5c529de24612 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -247,8 +247,8 @@ static int parse_line(char *line, struct resctrl_schema *s,
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP &&
 	    (r->rid == RDT_RESOURCE_MBA || r->rid == RDT_RESOURCE_GMBA ||
-	     r->rid == RDT_RESOURCE_SMBA)) {
-		rdt_last_cmd_puts("Cannot pseudo-lock MBA resource\n");
+	     r->rid == RDT_RESOURCE_SMBA || r->rid == RDT_RESOURCE_GSMBA)) {
+		rdt_last_cmd_puts("Cannot pseudo-lock MBA/SMBA resource\n");
 		return -EINVAL;
 	}
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index d2eab9007cc1..fc034f4481e3 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1423,7 +1423,7 @@ static bool rdtgroup_mode_test_exclusive(struct rdtgroup *rdtgrp)
 	list_for_each_entry(s, &resctrl_schema_all, list) {
 		r = s->res;
 		if (r->rid == RDT_RESOURCE_MBA || r->rid == RDT_RESOURCE_GMBA ||
-		    r->rid == RDT_RESOURCE_SMBA)
+		    r->rid == RDT_RESOURCE_SMBA || r->rid == RDT_RESOURCE_GSMBA)
 			continue;
 		has_cache = true;
 		list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
@@ -1627,7 +1627,8 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 								       type);
 				if (r->rid == RDT_RESOURCE_MBA ||
 				    r->rid == RDT_RESOURCE_GMBA ||
-				    r->rid == RDT_RESOURCE_SMBA)
+				    r->rid == RDT_RESOURCE_SMBA ||
+				    r->rid == RDT_RESOURCE_GSMBA)
 					size = ctrl;
 				else
 					size = rdtgroup_cbm_to_size(r, d, ctrl);
@@ -2187,7 +2188,7 @@ static struct rftype *rdtgroup_get_rftype_by_name(const char *name)
 static void thread_throttle_mode_init(void)
 {
 	enum membw_throttle_mode throttle_mode = THREAD_THROTTLE_UNDEFINED;
-	struct rdt_resource *r_mba, *r_gmba, *r_smba;
+	struct rdt_resource *r_mba, *r_gmba, *r_smba, *r_gsmba;
 
 	r_mba = resctrl_arch_get_resource(RDT_RESOURCE_MBA);
 	if (r_mba->alloc_capable &&
@@ -2204,6 +2205,11 @@ static void thread_throttle_mode_init(void)
 	    r_smba->membw.throttle_mode != THREAD_THROTTLE_UNDEFINED)
 		throttle_mode = r_smba->membw.throttle_mode;
 
+	r_gsmba = resctrl_arch_get_resource(RDT_RESOURCE_GSMBA);
+	if (r_gsmba->alloc_capable &&
+	    r_gsmba->membw.throttle_mode != THREAD_THROTTLE_UNDEFINED)
+		throttle_mode = r_gsmba->membw.throttle_mode;
+
 	if (throttle_mode == THREAD_THROTTLE_UNDEFINED)
 		return;
 
@@ -2420,6 +2426,7 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
 	case RDT_RESOURCE_MBA:
 	case RDT_RESOURCE_GMBA:
 	case RDT_RESOURCE_SMBA:
+	case RDT_RESOURCE_GSMBA:
 		return RFTYPE_RES_MB;
 	case RDT_RESOURCE_PERF_PKG:
 		return RFTYPE_RES_PERF_PKG;
@@ -3669,7 +3676,8 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 		r = s->res;
 		if (r->rid == RDT_RESOURCE_MBA ||
 		    r->rid == RDT_RESOURCE_GMBA ||
-		    r->rid == RDT_RESOURCE_SMBA) {
+		    r->rid == RDT_RESOURCE_SMBA ||
+		    r->rid == RDT_RESOURCE_GSMBA) {
 			rdtgroup_init_mba(r, rdtgrp->closid);
 			if (is_mba_sc(r))
 				continue;
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 17e12cd3befc..63d74c0dbb8f 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -54,6 +54,7 @@ enum resctrl_res_level {
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_GMBA,
 	RDT_RESOURCE_SMBA,
+	RDT_RESOURCE_GSMBA,
 	RDT_RESOURCE_PERF_PKG,
 
 	/* Must be the last */
-- 
2.34.1



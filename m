Return-Path: <kvm+bounces-68782-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kA0CEIZCcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68782-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:17:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB455DECE
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 829ABAAE5EA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6440E429837;
	Wed, 21 Jan 2026 21:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZdU7voLW"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013063.outbound.protection.outlook.com [40.93.196.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F223F23D9;
	Wed, 21 Jan 2026 21:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030010; cv=fail; b=jW6c0ZjvubRihiU1BertADlFJiFS/zEIT3OprFMtrFHdtjW27+LMV6ByRahnnudOSS0Ks/7guKDBX+Jjn/aHZqA/1VEG6XQEoKDAiZx9jp8w2zIrCgvXDunanUBpnMnwz4F90WSR7is5Lio/8QhC330bY0yUja4O3eI66WPDkcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030010; c=relaxed/simple;
	bh=C6VNZ4StDNOCgDXKRm8QvQQ8spyv27tT0GJEkQuL8IU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DpmRk7qtUMtQ2oT9BwGZRuNpkmhI03343QjzgJGkrkKw35yUK4MCJBqexoI9u4jNY9XkeTmi329gIOG9NuEyIguNIREFKu45ZceI+uwkDg+JZ4tM63qcxa3ROvOhaGBot1ygGpZsHe6P7yLfVuYsAECJKkgrPs84OCazsdTiqXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZdU7voLW; arc=fail smtp.client-ip=40.93.196.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i7fii/KFVW/+nkp6lPR9Y61qZg9LZhpVSfDVjBKGl94MNks1tEgHn1A5NTuC084erot3wL91npKVMaQT+7Nsb334Q/kQhj/kpISnEclyLRzf1BGaFuwfEXokAap/Vo+WJfEhgf2sbf+X+2Dm0XppPt/m8iVM+1ElRhWIoMnAsTgsbYtR8KWkOEyxWFM74AekyQpxvDKHgoLYYWD/RRTAyuuQy1WdTYDnp6gk8Nfmem8MFS+yJ3LbtBqk8mnM+MsLXPXyYD+ot+9Gn0hhhkFHMQuuVUQ12rxGot/hfmimhDeERxhjVySzd9n+YH3bYwGuefVLedtAOSYFXXRUJqRAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRM03+T1cgpAIYEAdTDYkMlwzAa53/I5tjNH681T7CY=;
 b=RUJg2nj1zC4EdFJc5IJEcHxgzyYQainrP+Jdk3KhLkEav7/YcxjC4t9JeYEEY2lvUKecSXSqsH7pdgSlxy8kmwzCB9/IUu2I71o4Ye1wuutArv7pKO9UXGHb3oQQy+5ZmTt+QuZvSgxSUbXTiJJVGj1UexsgyruTROSfcQIqSlz8kMmTQPGPyAEBQ52xShR6ULz1ylpnfwLFYWisa6wx9DM/2akzVEgFNpKmh6HezXxxQ9/zPEd+V8DUX12ez9XfCQwDB14rVzhStMrhWHN9dqh2egjRqeX1X4omYrMJ/WpqhrfkItXe7sBhoR8Yfhkyok9h//V3awxPRbjHC9l3zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRM03+T1cgpAIYEAdTDYkMlwzAa53/I5tjNH681T7CY=;
 b=ZdU7voLWmBQfcxeA7L/+OGnGBE7ukpDLdO/uHdawjhNL/bexqM2QnKiwoL4eGj0EYW6xvam7ZKZFSevw8VAsF6ao+v9DPED5iKYWJeUXmFFfRwSv6kKuTg+iOVQcyJYcovTWF4F9iJq/nlS2CDhdzMtsrj/kFX+0hnttBGeTPgE=
Received: from BY5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:a03:1f4::30)
 by DM6PR12MB4329.namprd12.prod.outlook.com (2603:10b6:5:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:13:21 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::37) by BY5PR20CA0017.outlook.office365.com
 (2603:10b6:a03:1f4::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 21:13:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:13:20 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:13:19 -0600
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
Subject: [RFC PATCH 02/19] x86,fs/resctrl: Add the resource for Global Memory Bandwidth Allocation
Date: Wed, 21 Jan 2026 15:12:40 -0600
Message-ID: <6c37e6003e82561070d8737ca8a3b542e70ff832.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|DM6PR12MB4329:EE_
X-MS-Office365-Filtering-Correlation-Id: 9630b168-53fa-4efa-ac8a-08de5931e7bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RfqpTwQtupE6+N8FCefwHs++5xAEvaYbYNxAa2dN6P85Ke6yb0JOtgOn4XXO?=
 =?us-ascii?Q?frzwqkbbU2uvJajKHK4DaX+XrNEIH1pmBzWe5ObbK91jzN06N2V2OJSY5rqG?=
 =?us-ascii?Q?SThPhawItu83r4fMSYmPacPeIzODxfTCmbLbeFmCT5XqdIhs3+zwef6gueLQ?=
 =?us-ascii?Q?XVkSRxTNs2KGcB+ciNYepkJrSTxBmQlIIGsqWgHh9nCUxr5FYoqV9bf8QyCk?=
 =?us-ascii?Q?Tgajt9KnLeFmo9NisJQVWI8tWajYbrPMltvu3HBUnPKih5SnSa1PKrhexvju?=
 =?us-ascii?Q?8lGs4AxhaQDznUIHBhsXCO0s6xGlhMIixw278H9nSeraq9PxEq8G/Vw/4Rpo?=
 =?us-ascii?Q?c3OSQXFWxkFWcXeAlQx3d6s6zDiukYXnw7uDBug+qOA2YSoZ7dRcKjabT9YW?=
 =?us-ascii?Q?w8iIIDaPAKg+lF71KfKEFE6HWD2LK4K8Zv7AUDOYf6KWfwkjlVyjwJrMg4lm?=
 =?us-ascii?Q?KrNsZnxzhIenvmiKtdLLWaoOZ6D4Nza3ZkJqN/+Z6NOTwm3BsQKWczhOtaAl?=
 =?us-ascii?Q?7AaO8CdwiF4DK/0bika4YGI+XaRuIXjULd3ncIfh+nriOOFRVXqcf/QZpYYK?=
 =?us-ascii?Q?rmHIw3gcbUxMx/WVajauz1jp6EDij99/hrm0dQtnL4zofVKI9zTWhP7HvOzi?=
 =?us-ascii?Q?f8GcYomSLV1pNBlPyjQDr62mTHCF4A9Qpuha5J2jUfGloDAM1hXOYGciRSiR?=
 =?us-ascii?Q?f35VW1P7xtAb/G8ImDVYTJj/5F9RELpBRJIf+5j4QyLEK8as8mVT9lujXvP0?=
 =?us-ascii?Q?XO15tZQmg37kh4j8zqD5CPDsSRr3PwAFiHNe/C9ewRHP2gE6PTKaU97rnVcl?=
 =?us-ascii?Q?ZGk4AYQCAZFcsZMGz/fIYpxgnajx9qZ4/+HzhATUAYX5M6XyvbsuaLNq60iT?=
 =?us-ascii?Q?3w5XvCJZwwszcqX8r/qe8XTE5+9OhJqdrODIyB9GCEcL8EF0OtuIc/GuoqMV?=
 =?us-ascii?Q?IKz7mNdfpF4oaSPY41lywjf2sJKtRKONE/ev8aV7Swp4uXsDOiKNYax1QL3o?=
 =?us-ascii?Q?uxdBVG/yO9WUdQoQGRLq/rMuw9Wuj6avvVg05FpeaJ9060zA3HJpqyKLmjyL?=
 =?us-ascii?Q?G9EFUU2PFIvJ3YJ9Fe2j+1bcktuYPfK5FhlbB8ZBCSRPxqLY9wmTImarC0Sc?=
 =?us-ascii?Q?Fllw+dswm4CFzdImtlxUqHv6kIlVilZyIAUCatwdgCbAGJ2bBDpNcMsxC/yd?=
 =?us-ascii?Q?/62Vy1pGI37uzsoWkLExXSJcDwjoLQjPifP7nfXuYsluY5CFbCUMoHTGt1TD?=
 =?us-ascii?Q?pg7NBmoSjfKfT2L45rSh7tdkd4zwndRdKEGKgfjjE+UpL6GKw6yY+M7vJMIv?=
 =?us-ascii?Q?dOGEf31jfQn7so159v2Ny7STRF2ElIa1WvpczOcQyvl5iNyOL5cxqVkrBu0Z?=
 =?us-ascii?Q?2tTxGSPm3+2X1fN1hIz+Pf8p/1bfsUzaDZUtzxPZ5q1pRwhTvezVQAqTxVjo?=
 =?us-ascii?Q?w4lZPzG9DbqUVdH61qp819oz2QTCQxjNO6ytM4earEWVIPTul7qg2EfsEqfk?=
 =?us-ascii?Q?oTU5GTzNjsqthhF08TGxiI5UekICFTnm/WrgmtnUdx8BS5x0JEpKVCganF2m?=
 =?us-ascii?Q?bjYDDhS0N/RlDybH//wCBnoOVoKy347tSzBF8haGuSUN/uxTgzx18smH0Gb7?=
 =?us-ascii?Q?LvMXqDJ6BTGJlGTvsUAZ5Q9F8g0fnK547pBY/2eu6QMq+MRrGnue7epeBsJO?=
 =?us-ascii?Q?le0rglJdm0KND55B1LfZ8yKE3qs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:13:20.8258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9630b168-53fa-4efa-ac8a-08de5931e7bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4329
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
	TAGGED_FROM(0.00)[bounces-68782-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: DCB455DECE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

AMD PQoS Global Bandwidth Enforcementn(GLBE) provides a mechanism for
software to specify bandwidth limits for groups of threads that span
multiple QoS Domains.

Add the resource definition for GLBE in resctrl filesystem. Resource
allows users to configure and manage the global memory bandwidth allocation
settings for GLBE domain. GLBE domain is set of participating QoS domains
that are grouped together for global bandwidth allocation.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/kernel/cpu/resctrl/core.c | 46 ++++++++++++++++++++++++++++--
 fs/resctrl/ctrlmondata.c           |  3 +-
 fs/resctrl/rdtgroup.c              | 13 +++++++--
 include/linux/resctrl.h            |  1 +
 5 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 43adc38d31d5..e9b21676102c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1274,6 +1274,7 @@
 #define MSR_IA32_L3_QOS_ABMC_CFG	0xc00003fd
 #define MSR_IA32_L3_QOS_EXT_CFG		0xc00003ff
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
+#define MSR_IA32_GMBA_BW_BASE		0xc0000600
 
 /* AMD-V MSRs */
 #define MSR_VM_CR                       0xc0010114
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8b3457518ff4..8801dcfb40fb 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -91,6 +91,15 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
 		},
 	},
+	[RDT_RESOURCE_GMBA] =
+	{
+		.r_resctrl = {
+			.name			= "GMB",
+			.ctrl_scope		= RESCTRL_L3_CACHE,
+			.ctrl_domains		= ctrl_domain_init(RDT_RESOURCE_GMBA),
+			.schema_fmt		= RESCTRL_SCHEMA_RANGE,
+		},
+	},
 	[RDT_RESOURCE_SMBA] =
 	{
 		.r_resctrl = {
@@ -239,10 +248,22 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 	u32 eax, ebx, ecx, edx, subleaf;
 
 	/*
-	 * Query CPUID_Fn80000020_EDX_x01 for MBA and
-	 * CPUID_Fn80000020_EDX_x02 for SMBA
+	 * Query CPUID function 0x80000020 to obtain num_closid and max_bw values.
+	 * Use subleaf 1 for MBA, subleaf 2 for SMBA, and subleaf 7 for GMBA.
 	 */
-	subleaf = (r->rid == RDT_RESOURCE_SMBA) ? 2 :  1;
+	switch (r->rid) {
+	case RDT_RESOURCE_MBA:
+		subleaf = 1;
+		break;
+	case RDT_RESOURCE_SMBA:
+		subleaf = 2;
+		break;
+	case RDT_RESOURCE_GMBA:
+		subleaf = 7;
+		break;
+	default:
+		return false;
+	}
 
 	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
 	hw_res->num_closid = edx + 1;
@@ -909,6 +930,19 @@ static __init bool get_mem_config(void)
 	return false;
 }
 
+static __init bool get_gmem_config(void)
+{
+	struct rdt_hw_resource *hw_res = &rdt_resources_all[RDT_RESOURCE_GMBA];
+
+	if (!rdt_cpu_has(X86_FEATURE_GMBA))
+		return false;
+
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return __rdt_get_mem_config_amd(&hw_res->r_resctrl);
+
+	return false;
+}
+
 static __init bool get_slow_mem_config(void)
 {
 	struct rdt_hw_resource *hw_res = &rdt_resources_all[RDT_RESOURCE_SMBA];
@@ -954,6 +988,9 @@ static __init bool get_rdt_alloc_resources(void)
 	if (get_mem_config())
 		ret = true;
 
+	if (get_gmem_config())
+		ret = true;
+
 	if (get_slow_mem_config())
 		ret = true;
 
@@ -1054,6 +1091,9 @@ static __init void rdt_init_res_defs_amd(void)
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_BW_BASE;
 			hw_res->msr_update = mba_wrmsr_amd;
+		} else if (r->rid == RDT_RESOURCE_GMBA) {
+			hw_res->msr_base = MSR_IA32_GMBA_BW_BASE;
+			hw_res->msr_update = mba_wrmsr_amd;
 		} else if (r->rid == RDT_RESOURCE_SMBA) {
 			hw_res->msr_base = MSR_IA32_SMBA_BW_BASE;
 			hw_res->msr_update = mba_wrmsr_amd;
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index cc4237c57cbe..ad7327b90d3f 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -246,7 +246,8 @@ static int parse_line(char *line, struct resctrl_schema *s,
 		return -EINVAL;
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP &&
-	    (r->rid == RDT_RESOURCE_MBA || r->rid == RDT_RESOURCE_SMBA)) {
+	    (r->rid == RDT_RESOURCE_MBA || r->rid == RDT_RESOURCE_GMBA ||
+	     r->rid == RDT_RESOURCE_SMBA)) {
 		rdt_last_cmd_puts("Cannot pseudo-lock MBA resource\n");
 		return -EINVAL;
 	}
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ba8d503551cd..ae6c515f4c19 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1412,7 +1412,8 @@ static bool rdtgroup_mode_test_exclusive(struct rdtgroup *rdtgrp)
 
 	list_for_each_entry(s, &resctrl_schema_all, list) {
 		r = s->res;
-		if (r->rid == RDT_RESOURCE_MBA || r->rid == RDT_RESOURCE_SMBA)
+		if (r->rid == RDT_RESOURCE_MBA || r->rid == RDT_RESOURCE_GMBA ||
+		    r->rid == RDT_RESOURCE_SMBA)
 			continue;
 		has_cache = true;
 		list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
@@ -1615,6 +1616,7 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 								       closid,
 								       type);
 				if (r->rid == RDT_RESOURCE_MBA ||
+				    r->rid == RDT_RESOURCE_GMBA ||
 				    r->rid == RDT_RESOURCE_SMBA)
 					size = ctrl;
 				else
@@ -2168,13 +2170,18 @@ static struct rftype *rdtgroup_get_rftype_by_name(const char *name)
 static void thread_throttle_mode_init(void)
 {
 	enum membw_throttle_mode throttle_mode = THREAD_THROTTLE_UNDEFINED;
-	struct rdt_resource *r_mba, *r_smba;
+	struct rdt_resource *r_mba, *r_gmba, *r_smba;
 
 	r_mba = resctrl_arch_get_resource(RDT_RESOURCE_MBA);
 	if (r_mba->alloc_capable &&
 	    r_mba->membw.throttle_mode != THREAD_THROTTLE_UNDEFINED)
 		throttle_mode = r_mba->membw.throttle_mode;
 
+	r_gmba = resctrl_arch_get_resource(RDT_RESOURCE_GMBA);
+	if (r_gmba->alloc_capable &&
+	    r_gmba->membw.throttle_mode != THREAD_THROTTLE_UNDEFINED)
+		throttle_mode = r_gmba->membw.throttle_mode;
+
 	r_smba = resctrl_arch_get_resource(RDT_RESOURCE_SMBA);
 	if (r_smba->alloc_capable &&
 	    r_smba->membw.throttle_mode != THREAD_THROTTLE_UNDEFINED)
@@ -2394,6 +2401,7 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
 	case RDT_RESOURCE_L2:
 		return RFTYPE_RES_CACHE;
 	case RDT_RESOURCE_MBA:
+	case RDT_RESOURCE_GMBA:
 	case RDT_RESOURCE_SMBA:
 		return RFTYPE_RES_MB;
 	case RDT_RESOURCE_PERF_PKG:
@@ -3643,6 +3651,7 @@ static int rdtgroup_init_alloc(struct rdtgroup *rdtgrp)
 	list_for_each_entry(s, &resctrl_schema_all, list) {
 		r = s->res;
 		if (r->rid == RDT_RESOURCE_MBA ||
+		    r->rid == RDT_RESOURCE_GMBA ||
 		    r->rid == RDT_RESOURCE_SMBA) {
 			rdtgroup_init_mba(r, rdtgrp->closid);
 			if (is_mba_sc(r))
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..17e12cd3befc 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -52,6 +52,7 @@ enum resctrl_res_level {
 	RDT_RESOURCE_L3,
 	RDT_RESOURCE_L2,
 	RDT_RESOURCE_MBA,
+	RDT_RESOURCE_GMBA,
 	RDT_RESOURCE_SMBA,
 	RDT_RESOURCE_PERF_PKG,
 
-- 
2.34.1



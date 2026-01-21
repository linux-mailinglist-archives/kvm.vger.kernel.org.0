Return-Path: <kvm+bounces-68788-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OMMNH1IcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68788-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:43:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B83D55E34A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5453654D98B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A64429830;
	Wed, 21 Jan 2026 21:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ema5eeUe"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010042.outbound.protection.outlook.com [52.101.56.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805E534C9AB;
	Wed, 21 Jan 2026 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030071; cv=fail; b=V9kGC7xCPbkQ6QTp2yk2pkcjSMUlgD35ThgnZ8kQAKMXFVg3v8ifY5E0YkmSG9tyDcmft/Ucb17lC/ZLTdMkJONCsviEmC0BDDPyjtvebQ5xKcpYUu4EEd4QZBhfs2NLJ1tF+jBKyw3kPYvJ8NiW5Fx+gz4wnocz70kZuMxqJ0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030071; c=relaxed/simple;
	bh=7gzS6AEOBm8GgMlIpXngQVS6IN1/87xveGFUswoKRfc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSt3ATyYL0yRaYadllMFxdxHIqRUXn33qysWHfU0XJfo9WxvCQyjLiNvhJyFLHmAP8ha3UeBDHbQtkwEIZ1I58/kv7GVGheH5AOOXIXguDWpP293TLTwqYT/8+R5zcoQK6+ZFlw9eu3Mcw5CYp/0/xvz9nm507GkqJNbeRPYOhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ema5eeUe; arc=fail smtp.client-ip=52.101.56.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3DNeNGXYDSQQAXY0TDw0ZqJbmbpALYsFmwAGpwYqDlVirRrhpFVJb9m3TVZulBMq2JG+b9tsm7Jyd/ADQNYDdziKBdHY+6QzytYqFw08ANfjFWMy42x5XIxctAZ1wVBN2Zs4vnKqMa7alQrwXtbokyxZMC1Vb/eMjVePi+HLIbx46lkmwa3AcJCyG8UaAvUAFm+KI6f9xeWp1+x7Nx2YT7zF6HlAKx833aSO5guoLGwxueMgm1h+wmCgXJsubDFifZCbAwJB7vPzH4T3QlvWOzs5FR21lgSdbhdYLw7SVECWh3qZS5KHu3NHGpiTJkq76wBhRAHyQMCsmQcaU38iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Xt1F2DPBD8WMBT71HBDImNQPgzhV60b2WT5WOAzbmo=;
 b=SPTD/PwGx85L/1z75rlRx9JQj/Ekc69EdUEe9Kh8Q78AQVZTb/Hjrt0QNOo7Pz+raNeVXBWBMOxFk9zRya6wTyVxlssswbq9KA/E4J/FOGBrvTaZxDD0dUnrcfTia1dbVdCEDcPU1DkROo7eTqN3B9iQC9NufIiYC4a5KaPtFE/Sbw9NUNCbdu1sFEXeMGo5oBA77HjBbFIUqHgVcvTfz9YuN99DYN31769SIeSlJFTT+ZO2yfcQ7Whi2oaZN1xwAHrdXbUMWJVvlWzoLHET5KBEM7WU3tWEdUbgYbe2OEBeFCY5Akyq9yPYFBwnN1cWy26eTiclXh95ryymv7ChdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Xt1F2DPBD8WMBT71HBDImNQPgzhV60b2WT5WOAzbmo=;
 b=ema5eeUeAAxaHxPHkazfnMx/twQ5biVCpYMk7HYMpfmSNcIq44iQYQ614LI5aG6C2g6MADK95HAUwGdGtoymsOnBkU5zl8D9ZOaOHUhWNEpfIC9M5NCBatGwGDou4+3DqbzHcr3uXRQ1/Op+9/dsU1mFhVCCYFOyS160/oEFJ10=
Received: from SJ0PR05CA0093.namprd05.prod.outlook.com (2603:10b6:a03:334::8)
 by MW6PR12MB7087.namprd12.prod.outlook.com (2603:10b6:303:238::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:14:14 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::bd) by SJ0PR05CA0093.outlook.office365.com
 (2603:10b6:a03:334::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.2 via Frontend Transport; Wed,
 21 Jan 2026 21:14:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:14:14 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:14:07 -0600
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
Subject: [RFC PATCH 08/19] x86/resctrl: Support Privilege-Level Zero Association (PLZA)
Date: Wed, 21 Jan 2026 15:12:46 -0600
Message-ID: <3c3029e61d4602476b7836d82614ba4ec71b3a99.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|MW6PR12MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: c2a726e3-d276-465b-7e59-08de593207ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ynY3BEmQX3fP7nDfDgMAMCopbkRsWBmzmzf6UHfARX74UhV7mhdoeH2Zzg3/?=
 =?us-ascii?Q?fx/h+bbU8AXdP4qDiI3/b9HWKJViKEucWbMxysbTyjqnc2ww98Zys5ailXj0?=
 =?us-ascii?Q?jmGdSrJ4C/gnThFg/bQDKNDNUMrjggsTiVBq0IO4+i+RMRecStuxDGndEOFH?=
 =?us-ascii?Q?JNDraowyonJfm/yxslVMrpOwIrXXhGayLmPadMEYXqEqtr/KWaGRkoncf423?=
 =?us-ascii?Q?0cn3rw+rVMfBTtoKJZ2QVkAa5Vh7fJqEwsVANxb1E5xaTMWzdFkwPMSSmWg9?=
 =?us-ascii?Q?E7fq989qwl3+KVRaRHq99FwaIvlcjwX/xcu5UkMfSaQC9p7RcGzPKlJQY6WT?=
 =?us-ascii?Q?ojr42RNgsmOu4Gd5ocoPyww0eQtCxTG0k0caicLJtRZjEL16nSyQ+1H+4rmY?=
 =?us-ascii?Q?XbTsV1vV2++kQNav5QSr/a95+zRJIaBiIsDLxucA0p01xB8G5hjlDnhA84qS?=
 =?us-ascii?Q?xmpxAT98ruKRY1YIWaTHzyC65gtagPOxHxqeJLCjJUvO71ansyU8ewzlFzoy?=
 =?us-ascii?Q?vTBXKZXdS7pCCFoFamIZsQERc1kFtPUZiUSZ/ErGqR62e5yqCZlYXqWAVzyy?=
 =?us-ascii?Q?lvwJ8vqgFQKxSD6UiMUNKMofJdolbj0b6A1rTTLSZxGik8K8s95xNQqCNyWi?=
 =?us-ascii?Q?PNexBvEfDDWMhvS86FQmDHEDdPGAIcLea1fxRupBeB/HBTr5qovDRByzwjoS?=
 =?us-ascii?Q?+3x56LSaLbVzsWz4SKnOL1KRn2pkDwteCjLUnjHD6CZCv3DzjiNbhYH8t1Mw?=
 =?us-ascii?Q?s+ND/esXvkKhaEtg9MLrGApXPeDPKQmu9Cfqq+c7ZVCSrAyIjHeUnzw23zEy?=
 =?us-ascii?Q?Ihm4GgxmapMlzU4Ma+DFEZMu3QtS31CrD5R9nncVQiXtfDM8grjku2MxhffV?=
 =?us-ascii?Q?4PhD30vY0MkkPIZSZYXpl+FR2TzQleb3+MdAfuGhsKPm410zK58Hw+ucx63G?=
 =?us-ascii?Q?8dxcHD+5b08H1V2WOKnp4uB2BQS665yNi3Fuy/bwiZml6j68Z7RIg4Umkxfd?=
 =?us-ascii?Q?kTR8rABPBQ/gMTRPL7+T4lWNZfyQWX0S+9U6ro12EoXOA2yuUx/P9h/qQCu5?=
 =?us-ascii?Q?HosX5cD6H/tqkSwugMLpXgr4ROY/kF004YyLvvXt4Kzv5rNkBEoCkxDNIZrj?=
 =?us-ascii?Q?x+fbL2RX17ihuya1E1XoZZVcDSBz0JkhZ7ReA9NbUQ0xuV9ElTSgIhLu6WCa?=
 =?us-ascii?Q?UpcAGueNwiqYSQqNFWMU7sGIyOettVyeoI5eSyESaG8WgKzo6P0G2pI2qalI?=
 =?us-ascii?Q?ZWDTm3Go/3H1XLOlcisl6jtKvALeJO7KgBMTkmyD10odbME9ReTUq01IBUyM?=
 =?us-ascii?Q?ksttY0sGgM8ayFJjR6oQGRxRkIu7JMZB7ndMS4jHMgRZA8Z8HKGsAinpKSlq?=
 =?us-ascii?Q?nBUQ1tftZLTSi4cBBwfOFvlNOJ2m++YFe2MYeOso8E5i7nlVVPkN9bXpGTf7?=
 =?us-ascii?Q?NqmJK31zs3nbbn+wC5LUuefZpNnFX2C8L2lbpSmDBpxbl8Azk1eFHZKmII6Q?=
 =?us-ascii?Q?2f70cgmBmcXFZdFUTHEg1THDwb8uxhun9jfvPbet40KafjAhz0G63Gl3zYcT?=
 =?us-ascii?Q?drIbWOKvaZWME+xOs3LlPpXpdBlc6YXRfxdWFx/RDAFFGH9ZRNhaemUXnnnP?=
 =?us-ascii?Q?dZF2RDh5je7rZpud0ak1mzP5PXocDYT9bAOts7dA9V7dq4K5OJqUAB83L01Q?=
 =?us-ascii?Q?rtJL4L03SEXGKOVMJhMjLOYbiss=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:14:14.6311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a726e3-d276-465b-7e59-08de593207ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7087
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
	TAGGED_FROM(0.00)[bounces-68788-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: B83D55E34A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Customers have identified an issue while using the QoS resource Control
feature. If a memory bandwidth associated with a CLOSID is aggressively
throttled, and it moves into Kernel mode, the Kernel operations are also
aggressively throttled. This can stall forward progress and eventually
degrade overall system performance. AMD hardware supports a feature
Privilege-Level Zero Association (PLZA) to change the association of the
thread as soon as it begins executing.

Privilege-Level Zero Association (PLZA) allows the user to specify a CLOSID
and/or RMID associated with execution in Privilege-Level Zero. When enabled
on a HW thread, when the thread enters Privilege-Level Zero, transactions
associated with that thread will be associated with the PLZA CLOSID and/or
RMID. Otherwise, the HW thread will be associated with the CLOSID and RMID
identified by PQR_ASSOC.

Add PLZA support to resctrl and introduce a kernel parameter that allows
enabling or disabling the feature at boot time.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 arch/x86/include/asm/cpufeatures.h              | 1 +
 arch/x86/kernel/cpu/resctrl/core.c              | 2 ++
 arch/x86/kernel/cpu/scattered.c                 | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d3eb21e76aef..4ce3a291cd68 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6325,7 +6325,7 @@ Kernel parameters
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, gmba, smba, gsmba, bmec, abmc, sdciae, energy[:guid],
+			mba, gmba, smba, gsmba, bmec, abmc, sdciae, plza, energy[:guid],
 			perf[:guid].
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 57d59399c508..0c3b44836cfe 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -514,6 +514,7 @@
 #define X86_FEATURE_X2AVIC_EXT		(21*32+20) /* AMD SVM x2AVIC support for 4k vCPUs */
 #define X86_FEATURE_GMBA		(21*32+21) /* Global Memory Bandwidth Allocation */
 #define X86_FEATURE_GSMBA		(21*32+22) /* Global Slow Memory Bandwidth Enforcement */
+#define X86_FEATURE_PLZA		(21*32+23) /* Privilege-Level Zero Association */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index cd208cd71232..2de3140dd6d1 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -834,6 +834,7 @@ enum {
 	RDT_FLAG_BMEC,
 	RDT_FLAG_ABMC,
 	RDT_FLAG_SDCIAE,
+	RDT_FLAG_PLZA,
 };
 
 #define RDT_OPT(idx, n, f)	\
@@ -863,6 +864,7 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
 	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
 	RDT_OPT(RDT_FLAG_ABMC,	    "abmc",	X86_FEATURE_ABMC),
 	RDT_OPT(RDT_FLAG_SDCIAE,    "sdciae",	X86_FEATURE_SDCIAE),
+	RDT_OPT(RDT_FLAG_PLZA,	    "plza",	X86_FEATURE_PLZA),
 };
 #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 62894789e345..4c98c8c5359f 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -61,6 +61,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_SDCIAE,			CPUID_EBX,  6, 0x80000020, 0 },
 	{ X86_FEATURE_GMBA,			CPUID_EBX,  7, 0x80000020, 0 },
 	{ X86_FEATURE_GSMBA,			CPUID_EBX,  8, 0x80000020, 0 },
+	{ X86_FEATURE_PLZA,			CPUID_EBX,  9, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_L1_NO,		CPUID_ECX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_AMD_WORKLOAD_CLASS,	CPUID_EAX, 22, 0x80000021, 0 },
-- 
2.34.1



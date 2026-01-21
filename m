Return-Path: <kvm+bounces-68787-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QFumNoFHcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68787-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:39:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0B25E264
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A138346B53F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73E743637E;
	Wed, 21 Jan 2026 21:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k3cZfTu+"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF9D42EED8;
	Wed, 21 Jan 2026 21:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030059; cv=fail; b=W7eC4+QnGddN95l8ja05CadYv2mg3I2d10OH4st3UIYmtI0CPCyplztlJ9bJIQtB3kmm4DY/GXSGJ3Io2FTrCRq97oxViLo1dfyc7gK9omn6GOS7KVOL/s31FCz/aE8oEg5E6lzMQkU8wvQ4tuVz8E6Y8TeM8t70her2wKsjFKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030059; c=relaxed/simple;
	bh=Pb9YvZpY4Xi/9YFd9OlNhVTalxQ5FZtQuC/2zWrOp3c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ua+aUyy224p2GfBmYQBh/GpjZxNbailnj3A6FgL28TZt2Y33Ba5KutjVIBXhMGcxPKr9aW+MyvKpOF2LBMW89hZq/EbgE/gPG/IqYSqKa9iOtRRqjBW9h/Ib6zhtYo5oz00wOJm4zra0KLM3vHwP1wrnPDyXpWeYHZzLAGBbHr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k3cZfTu+; arc=fail smtp.client-ip=52.101.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p3RN++dBz+1CalTOMN2P34DwknTfFV/0E7A9OnDfmKrzQkN8yMHFF3t0irM/xMbDjj+dHtMI/j7vUieKhS8g7/RKIrf1DwYLIJRyGUrnYYUsbgDwcpMQ0J4u0nX9Sge8plpi8Zqq1HOGJLoqTBuS+JLZvCVaL8IagsTAzEZUl0lX9K8a362xGcMdZbwIJpO3t6Lc7p1QuPDg+nqDOrPv4d4yZHIaKDZ4SwU7YZC33FaO20vYofQnAZMvY4cHb8PI1SEWjljAaa1o7ImhY39wvoP5y3eGS7wO3ok/jBYrINoevzDKWaSOhUnpaJAQq6vtJ2YfCSvFbu3Vc2DUJz1Atg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WitgPiOjTreNz/VMCh2V4/ToIZ4QEsuJ9aMU9pUKumw=;
 b=JOl+L1bpAItHUMF+qzoWbeYOvKG390Df0v5WOY+VwMv3A+VvAx3wA+/ZfajKYlOwKOlTElSFYbBKC+8WBC6lOmv70j2igmT8wxTKeEqSqsA05OCek0eyIZM7CmgAzz+zt8X94kmeALNtfmRDBvsKhu4wxxYrBBebZtp9gvVVLTMXtBOnFWnivYxD5wLZ4S4NQAtsRicBriToczRnRJEG4vzKGaUbU1vN8lkifBgGA8j/joA0egNVZ3+aVudEIGliXbcV653L5UDUWzCWMfXr8veNZ3JWgQxh7hDf9kv/sJB8qx42sDR6corVgnGG4T879lFKuxG/G8eFdMGWE5Pz2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WitgPiOjTreNz/VMCh2V4/ToIZ4QEsuJ9aMU9pUKumw=;
 b=k3cZfTu+m4tcSfzpJ6wiR3TO49FlEQRTdF6qp7p3YcvaF4FGHAhRRUkwa0fLX7oYp/7AblA1XWgtOPL3GMDYCSZ3fMOafqw60k91HwMgQSuH5DA3sz45OCTOFpb4QycRYWIrEP6ccQT11NjeBjQxAdjTQNANN8nVqGd9LoCk/eM=
Received: from BYAPR05CA0039.namprd05.prod.outlook.com (2603:10b6:a03:74::16)
 by CH3PR12MB8330.namprd12.prod.outlook.com (2603:10b6:610:12c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:14:11 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:74:cafe::2) by BYAPR05CA0039.outlook.office365.com
 (2603:10b6:a03:74::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Wed,
 21 Jan 2026 21:14:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:14:11 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:13:59 -0600
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
Subject: [RFC PATCH 07/19] fs/resctrl: Add the documentation for Global Slow Memory Bandwidth Allocation
Date: Wed, 21 Jan 2026 15:12:45 -0600
Message-ID: <c619c1eb2c1ce476bcc295891b42d7c83b4c4ec9.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|CH3PR12MB8330:EE_
X-MS-Office365-Filtering-Correlation-Id: ca520328-b9af-4706-ffe1-08de593205bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RYj8YASRB6hkgTkJbdMgIZ7HcvKW1wOjxthk525ExMuk5aZaPTvlm4TkRmuf?=
 =?us-ascii?Q?Fs2hL+X7JOFEJBbmuFpf7PhQ/u3vE7dUQHPkH35WG6HftBXt9eQe84wj1EG6?=
 =?us-ascii?Q?GcM9jS7bTA2GwkRwls3drS1xqndReat+UF3ygN3s9P++KzqHERNJgXuxAsPL?=
 =?us-ascii?Q?HChAtys1LG4VubnwcVEna7r1Wuzj/PRw6vI/s7Yev29m96Tvxd24xOZW94x4?=
 =?us-ascii?Q?hHkWbhmZYpX8XN2txAjI04MpWuL0cPbULC9A9zZWT5yzkIBLu5JwoKr5+vpt?=
 =?us-ascii?Q?9yotXFM8IR8t4qEC3u9otAmxDxPvY4xwcSoaRgCenN/KZU/30HcBGiBZNHr7?=
 =?us-ascii?Q?OPKXNUkgVBh2+QjmCi7soE1sUktPDBboSxgwHPpjQeNa033F4jSG/YyzJwRk?=
 =?us-ascii?Q?tm3HlZywost6cX4RVvZ3TAVBfgazJGnhHjhIZIL/obZ9/mYqRrHWygAaQkHI?=
 =?us-ascii?Q?bTcFAq2RjLf0QQmBvkHu4T/faU4JMmGjYnZwXo2wQiNXjBR7Fyscoq5TFfx8?=
 =?us-ascii?Q?FCDDM/9x6Q1WO5eDUbL/GhMMEHm66wAOPTPBbFo6Ff5UlM7vZkIDZxj94H+v?=
 =?us-ascii?Q?g4ER56by8qhRoCGcJFSIZGHXCWJk7F27M2c0pZRjPdJmwYLjW2b0qHRATEvb?=
 =?us-ascii?Q?v7I7v/I3664jBAZ9lQ+YViYOtGenff3zqghOgn3v3y5TA4wh9a43L4sKdvXI?=
 =?us-ascii?Q?MIHL+ull4tc4J5XVQfFbYpRjdpOwjcpGqT9IyK8WVufN8Rfx6LANy5zxcC2n?=
 =?us-ascii?Q?DzZiij1IlKSwG4HeciTk8bVcMDhU91mx8AP68NiB1wNdvHMQc55DbAOlj6Hz?=
 =?us-ascii?Q?F2a1vvPE4aKfiurwl1nphBqAULp8wPVlVjfbMhrX0tzKY0ogsRuGbXKP7fOR?=
 =?us-ascii?Q?11haRn8VKJHc6Y7sL65gkn2MXzevnQwwPnuZ8kUnJfxxEjluElnJEyEw7p62?=
 =?us-ascii?Q?Md9M2yHc56bqk6dpsmX06aUw5ITMyjsfT09l0YSyohwWONpLFh6z6tJgfvbM?=
 =?us-ascii?Q?fkSGUWqu1baEIsCrL6JUAO5YyyHTyozSIKRlG9q2eUVpZH5ycz6NLPXhF9//?=
 =?us-ascii?Q?S3yC1OjimQ6CSbIGy/Em6zWQzL8gO/t7WxIwcj8+rlX3mRhw0JBo0SGO9oJV?=
 =?us-ascii?Q?buaoS6q+3dmaoTOAaw74wyIXrmmK9ONfcdzROlpYkAnW+f5CP79YNVYniVmB?=
 =?us-ascii?Q?kSOUV+FvKt+73VjsnJirIX92iNO1PB8tvW7GDq2YgbCxIdnWp/gdKn90RYYC?=
 =?us-ascii?Q?8K9FpjaDUIWpVypIDtF8f/70AMhSa06jwIYyjZA77iWjvGHnmOIJloWv6hys?=
 =?us-ascii?Q?4GEjwQ8n+mlixb9EzDuVoMG5hSgnqnXLYl3Ip1wup6Z2Ld0UwDNVWQddUpe9?=
 =?us-ascii?Q?Pjgzgmk9YMy/foIlMZWyKmdyXTNYDDZ+xzVSKmPBBWOFDcSTtSmBuXONzSpH?=
 =?us-ascii?Q?HUfb90aiGw8nwV5BvPUUNuRRuFERs7AanbhtoxSjdIWEeENsn35l0ts9g49E?=
 =?us-ascii?Q?lykyZSDGZ7+pRrKGFq1yr51+LqMuo8Wr4AW4bHbvOzIGntU63d3r/5Ah8tYW?=
 =?us-ascii?Q?KK1/65WwpzUMs4MtQPR3dYUJtfFLuS17zPt2OhAhLpA0TM3+VDV23vSC4ths?=
 =?us-ascii?Q?AorG/1L4NFaFXghVrohRtgv3b2TWsEnOBL3Ro/9T1LLXH7OFcnuZ/jR27/hK?=
 =?us-ascii?Q?uV3+ILuoyTUJE69rMmgLpF3ZzX8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:14:11.1547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca520328-b9af-4706-ffe1-08de593205bb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8330
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
	TAGGED_FROM(0.00)[bounces-68787-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 7F0B25E264
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add the documentation and example to setup Global Slow Memory Bandwidth
Allocation (GSMBA) in resctrl filesystem.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/filesystems/resctrl.rst | 39 +++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 6ff6162719e8..3d66814a1d7f 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -29,6 +29,7 @@ BMEC (Bandwidth Monitoring Event Configuration)			""
 ABMC (Assignable Bandwidth Monitoring Counters)			""
 SDCIAE (Smart Data Cache Injection Allocation Enforcement)	""
 GMBA (Global Memory Bandwidth Allocation)                       ""
+GSMBA (Global Slow Memory Bandwidth Allocation)                 ""
 =============================================================== ================================
 
 Historically, new features were made visible by default in /proc/cpuinfo. This
@@ -995,6 +996,19 @@ is formatted as:
 
 	SMBA:<cache_id0>=bandwidth0;<cache_id1>=bandwidth1;...
 
+Global Slow Memory bandwidth Allocation (GSMBA)
+-----------------------------------------------
+
+AMD hardware supports Global Slow Memory Bandwidth Allocation (GSMBA)
+provides a mechanism for software to specify bandwidth limits for groups
+of threads that span across multiple QoS Domains. It operates Similarly
+to GMBA, however, the target resource is slow memory.
+
+Global Slow Memory b/w domain is L3 cache.
+::
+
+	GSMBA:<cache_id0>=bandwidth;<cache_id1>=bandwidth;...
+
 Reading/writing the schemata file
 ---------------------------------
 Reading the schemata file will show the state of all resources
@@ -1073,6 +1087,31 @@ For example, to allocate 8GB/s limit on the first cache id:
       MB:0=2048;1=2048;2=2048;3=2048
       L3:0=ffff;1=ffff;2=ffff;3=ffff
 
+Reading/writing the schemata file (on AMD systems) with GSMBA feature
+---------------------------------------------------------------------
+Reading the schemata file will show the current bandwidth limit on all
+domains. The allocated resources are in multiples of 1 GB/s. The GSMBA
+control domain is created by setting the same GSMBA limits in one or
+more QoS domains.
+
+For example, to configure a GSMBA domain consisting of domains 0 and 2
+with an 8 GB/s limit:
+
+::
+
+  # cat schemata
+    GSMBA:0=2048;1=2048;2=2048;3=2048
+     SMBA:0=2048;1=2048;2=2048;3=2048
+       MB:0=4096;1=4096;2=4096;3=4096
+       L3:0=ffff;1=ffff;2=ffff;3=ffff
+
+  # echo "GSMBA:0=8;2=8" > schemata
+  # cat schemata
+    GSMBA:0=   8;1=2048;2=   8;3=2048
+     SMBA:0=2048;1=2048;2=2048;3=2048
+       MB:0=4096;1=4096;2=4096;3=4096
+       L3:0=ffff;1=ffff;2=ffff;3=ffff
+
 Cache Pseudo-Locking
 ====================
 CAT enables a user to specify the amount of cache space that an
-- 
2.34.1



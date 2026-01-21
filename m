Return-Path: <kvm+bounces-68790-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJxQIRxIcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68790-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:41:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB615E2BE
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:41:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 108C9768D95
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF6543D513;
	Wed, 21 Jan 2026 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xzHyh860"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013070.outbound.protection.outlook.com [40.93.201.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E27A43C062;
	Wed, 21 Jan 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030076; cv=fail; b=jVgrWaI87b8AlWk11WUR/yCm3zwoxddCv/qYIDW7vdG3sJxHhSw1RBqe2C6UzmFJBKUweG4p6NTsS51x9OCZYgY5BHQvRSdMfjApISXU3qp/JfjplBilINd4K2C0CuVBjQO/ftYfG6oxiv20TCeKZxyL3JGttR/6Pkiz0IXWts8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030076; c=relaxed/simple;
	bh=orNwuItCWADF6E0D0iaknm1rgFmTybCQtft+Vl8k/yY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OyYNzT3drzvYkxLr6pYu7UNOw7WASuSTKkbWvwfhIaRcVL5V/AcmFZUnE9gVPbv5FobvaCqKGLNUsoxG+XWTKhEhPKlEKmXjagsFH7HoAnXVMCkO4GD8Yntnsm3u0wREHKQ9V87jGsxPQyVxdjUhC0f4IWr0UcOr2MwDc7a2Ung=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xzHyh860; arc=fail smtp.client-ip=40.93.201.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vIJ83KMuWDVeMmx78I1Qe0dzvG/Znlxe1crx95uuEuNFWAwXYZGSz4nbip8wbYAdlJi5lgizwM3SJ+lk1ofUktvKnKQ9X/ONKLNTYFg1uQu5q9dQ2FNjmgaImIn2AybGzAujXcJTOv1U2RyLFaEeoGLlELgpQ5T4Jpaxh0tmLtHTEC+q+n+reIGhpyJF9KgiIKM9KMVsyU1KHabJwut2MaZ3La/Q2UQS3Cmj1dEEaPjxa6KigmPW1f7/NXMfvyJbEwL6qY0JlVEhQzYbxeSH+Lk1bRvO19N/87H5EJ8AmYQaD0CouDiYZiAE2Urc/bUlzcPxYOYSMoQfYEu+fk6rqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=adzOeOoQgK9iMFAQldtCXZy2aHut5huQ4S238nNfzao=;
 b=fLJNejtuWySpGq9A6yaHFYGcXpToq5JeY2VQoVpqtMYaF10pK1spiks/8gsVJ3dSQU0GvMvT5dpzwg8YvS5Ovl095n52Ap20K680/8ZQnWUPvtjJ7tWcoz8XUXLlf9aRXL+iMgsulxB7YmWrwKo8lhKZLmZQoEU0Baj8QcbjDneW76vQdRW4wjDOa+yYcKfs6qV01hFIJvH+akDeC4Wz+dnVdClEnSXrnOqZn2q0MsD6RIY+xAQgwymUPvh+gYIaXSOLIKeDzXtvPRbimoGfiQRhwuye/ra/D8b+apKZAfPFDBbglkB30gj9LTFnWIJUG4YFC+merMr+yM8H9hs4qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=adzOeOoQgK9iMFAQldtCXZy2aHut5huQ4S238nNfzao=;
 b=xzHyh8608G8Fhk+MaOcjVGdLUyRZw7IPpOX/Fs5OZH9rQ8hOCiJ9eaO5AShBy1F/sbpZgWkKETqan3AeBaGVxG90niqaaeC7AGpPclW8lKAkanYT1dkQvqeknqGGQPsjikG2/9KEZbx+bu/0Slutvr4L+ASYqP1dyX8s2ysv9cM=
Received: from SJ2PR07CA0001.namprd07.prod.outlook.com (2603:10b6:a03:505::11)
 by SA3PR12MB7879.namprd12.prod.outlook.com (2603:10b6:806:306::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:14:28 +0000
Received: from SJ1PEPF00001CE4.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::69) by SJ2PR07CA0001.outlook.office365.com
 (2603:10b6:a03:505::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Wed,
 21 Jan 2026 21:14:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE4.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:14:28 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:14:23 -0600
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
Subject: [RFC PATCH 10/19] fs/resctrl: Expose plza_capable via control info file
Date: Wed, 21 Jan 2026 15:12:48 -0600
Message-ID: <bcf600adf9e632ae486f08fe857475167218f26c.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE4:EE_|SA3PR12MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: e26cb46b-441c-4e79-ea59-08de5932101d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jDAHvxjfX1vIAe2EiAZAe19BXiEq1V+jUuWerRoPEWk2c21f3bm7u3kIc/ke?=
 =?us-ascii?Q?onKCJn3CwLxK9Xx9b7JBQNe2t+fXrmWEP4YTuyDN0GtWKq+VYDh4U+hLhd0k?=
 =?us-ascii?Q?TBpnIT4r+gUSm5CsYp2bQfiwRzazXsY0TE3ZgXQwmFZwuK1lpuyvEUfAubS6?=
 =?us-ascii?Q?VJH4oCmSIBM9+hDwiaabOgWm6+tRWrWTmFR8Bmbd9YsEMzHavO827VRNjz88?=
 =?us-ascii?Q?5tGbtI446ljkn0A5bKLQ5JjFgdDYk3dl4VsbBuCtd6rgJLkCxj5xSeIgDG7K?=
 =?us-ascii?Q?VZxuj0iszQ+g5nz/mBUYjZ/AkXkAPCn7DIZhJWddMWDF6reblcvEkI+SSSI/?=
 =?us-ascii?Q?F0VqI93x4Qv89dZmmlV9v+zoo4NmqwySa1RCCHa0oW217K7aQujqQkQHWnkQ?=
 =?us-ascii?Q?Lnl9DIkfNu1ZhdXLTlYPHbI4fzj6dGno3Heb5Hz2MRhIIg/Dzqu823XkkfIK?=
 =?us-ascii?Q?89dHGB+D0NhxKhlyTDDBsG1fZDdic4hvYsJdXn05sn0KxqlGNPKpxptBIBQQ?=
 =?us-ascii?Q?c7j97vC0JeZrqVn4qKF0F/d5OjB6k7qRVH2hdbmooVkofo7z6S/zn+CRO2xL?=
 =?us-ascii?Q?TQUXfUogkhpmEyvNNyf1yRyK/BKfgUCLvgeKV7zAkcUoE/tfz0S8riRPvm9g?=
 =?us-ascii?Q?HrZl184fH5Yrtl8zU2aWkm+kNpaUxZBKG5UVp+E2f/dVWEjeHb+npWvMyuyR?=
 =?us-ascii?Q?aFp69yRhgP9TmYoILh2Dx6JRBvcH3D735rBMgjsd0x2MIXgx7HrNsfwez0Tw?=
 =?us-ascii?Q?GxprLuZYrr0d3w7/SQaWeRkayxirTnSuzJadfQbYC7hq/VRuL6Gt3wenoNBq?=
 =?us-ascii?Q?AGU4sC4UhdsxxPjn5hED8gi9yK1JRzObVghzG9mJiglqHxYS5oPZhlA1G++Z?=
 =?us-ascii?Q?oKAeksN+y29N20mZ1/HHYbVnqj+3LNSCANlm8YRI3cDsDchf4cqFUtL5LqCm?=
 =?us-ascii?Q?G5EF3msepi+/KjFTm+GVvvXTWugP9LeiU4okmy86gfNCj0fDhARAOJ5EPiRA?=
 =?us-ascii?Q?IGcVHvPHLr5h19Xb3i+hNXP/CNR9Q2XlxKcHjJizrfkL5lcXLnmOpadjWEy8?=
 =?us-ascii?Q?R037ei6OHwEubh51bqJzlixdtebhNWcWLn8XBwI38pnUPhfHFYDD/5jwetOY?=
 =?us-ascii?Q?y86z8LMACujuH5y6pl1iNGQWpu7cD/vsdF34mgtYmKAFSgMFKljPz//h1E9/?=
 =?us-ascii?Q?vXYOs76T4CXXBs6B0sOhU2zLYswTYH/UUzkbdstvLWpvGxRtZoWC36BL/5KY?=
 =?us-ascii?Q?9GA9m5eF3NymaQCnKBXsNda8rsEEe0IgvDQWY1L+pojkGO6VCsDvNfrUhncV?=
 =?us-ascii?Q?swWkocb2+3cbidqAdqGcNklEl7Sa+YY3ZYDxdAcov8QeAN97rtiStOvJ7MB2?=
 =?us-ascii?Q?itx2WfZDBGT7udiKfjOmEpIGz6PBFv/cB6kChIpHt61/YEP8+AT5pgL63NoC?=
 =?us-ascii?Q?AYEqLkN30PUXeTvSvUXoJ4gTkTuCGpRoXa3NOfYWkJDZpTUaafss8o3m0bP3?=
 =?us-ascii?Q?ANAyjQa+FClLKvSKNjz5kyMDA7ZjWpEjIuHMLl+dlatWQYqxpN6VM+N8Iyka?=
 =?us-ascii?Q?bnh9x13Qz6mikdgTZFEZ1wecyHV7Uuo5Rd9TgVMdNajV+KlqI4mREcFvh9S3?=
 =?us-ascii?Q?IQwJhc7UKNltN4yUEN73XvZR8RZznXiBvHJwV2AI3G3u8s1xwOZOkkv70631?=
 =?us-ascii?Q?7rBoRPTJ62JmM2TrlHpHaLPkiko=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:14:28.6021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e26cb46b-441c-4e79-ea59-08de5932101d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7879
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
	TAGGED_FROM(0.00)[bounces-68790-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 6CB615E2BE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a new resctrl info file, plza_capable, to report whether a resource
supports the PLZA capability. Allows user to query PLZA support directly
through resctrl without having to infer it from other resource attributes.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/filesystems/resctrl.rst | 17 +++++++++++++++++
 fs/resctrl/rdtgroup.c                 | 17 +++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 3d66814a1d7f..1de55b5cb0e3 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -30,6 +30,7 @@ ABMC (Assignable Bandwidth Monitoring Counters)			""
 SDCIAE (Smart Data Cache Injection Allocation Enforcement)	""
 GMBA (Global Memory Bandwidth Allocation)                       ""
 GSMBA (Global Slow Memory Bandwidth Allocation)                 ""
+PLZA (Privilege Level Zero association)                         ""
 =============================================================== ================================
 
 Historically, new features were made visible by default in /proc/cpuinfo. This
@@ -151,6 +152,22 @@ related to allocation:
 			"1":
 			      Non-contiguous 1s value in CBM is supported.
 
+"plza_capable":
+                Indicates the availability of Privilege Level Zero Association (PLZA).
+                PLZA is a hardware feature that enables automatic association of execution
+                at Privilege Level Zero (CPL=0) with a designated Class of Service
+                Identifier (CLOSID) and/or Resource Monitoring Identifier (RMID).
+                This mechanism allows the system to override the default per-thread
+                association for threads operating at CPL=0 when necessary. Additionally,
+                PLZA provides configuration capabilities for defining a dedicated resource
+                control group and assigning CPUs and tasks to operate under CLOSID
+                constraints reserved exclusively for PLZA.
+
+			"1":
+                                Resource supports the feature.
+			"0":
+                                Support not available for this resource.
+
 "io_alloc":
 		"io_alloc" enables system software to configure the portion of
 		the cache allocated for I/O traffic. File may only exist if the
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index fc034f4481e3..d773bf77bcc6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1260,6 +1260,16 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static int rdt_plza_show(struct kernfs_open_file *of, struct seq_file *seq, void *v)
+{
+	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
+	struct rdt_resource *r = s->res;
+
+	seq_printf(seq, "%d\n", r->plza_capable);
+
+	return 0;
+}
+
 /*
  * rdtgroup_mode_show - Display mode of this resource group
  */
@@ -1991,6 +2001,13 @@ static struct rftype res_common_files[] = {
 		.seq_show	= rdt_delay_linear_show,
 		.fflags		= RFTYPE_CTRL_INFO | RFTYPE_RES_MB,
 	},
+	{
+		.name		= "plza_capable",
+		.mode		= 0444,
+		.kf_ops		= &rdtgroup_kf_single_ops,
+		.seq_show	= rdt_plza_show,
+		.fflags		= RFTYPE_CTRL_INFO,
+	},
 	/*
 	 * Platform specific which (if any) capabilities are provided by
 	 * thread_throttle_mode. Defer "fflags" initialization to platform
-- 
2.34.1



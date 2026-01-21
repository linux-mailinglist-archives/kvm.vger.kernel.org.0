Return-Path: <kvm+bounces-68785-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +E9JGSZKcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68785-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:50:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 480695E4A7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D9DB1382514
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F066635C1B6;
	Wed, 21 Jan 2026 21:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mPV90ir9"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102383803F0;
	Wed, 21 Jan 2026 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030034; cv=fail; b=Uq0g4j14PACYrfaJpbMCf8d+Wp2QRQc0wRRCJU1xWPtH3OO286Pe/bazJqoGBrht5EAsNqZnqa0z452LzVABQhC8opJJgHKP5av27bAUFNZWvWlvEl0MU/Gc7OlcXGLhbBAaQXr+golL6rFE1Gk2tJHpsSSUmifWK+t4sw2fqJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030034; c=relaxed/simple;
	bh=RccvlA2mI4YwvN/U2TkpaT2uapoy4X3yhT1980Iicp4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swwY0QNw8zHS0otAOBj4G4k/I3jvdSJ+ZDU98ID3aU/ZDTtmuAz3yG/45q4uWroUyDWt9RdAG+tpLEtJWkzA/30vSukULffpFpclXkFIoalZSWA2xQqJzRopdB9knRp2kXjO2Aym0X0p8+P21h7cg6sThqEMKBkR2ggotRfqxXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mPV90ir9; arc=fail smtp.client-ip=52.101.43.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qk/ybuD+xEoqCcBjmivgvwLsgS5e532qPQ867TUcjpvirX7EONE4ZWzEdMlxxRy4giXtQvkelD1Gth7x28J2i0gUbFIpcB6ec4ibY8LsQBcpCo/D87oin9A3YSonvSx0FEQmsvd/JvFt52jH/JeeTqJB0rlm7rfy/KaxKuTsYGsTtzhCY1knWCErMIf0YbDfa7gBzKBTeQr7WLAE/iylfp//NMRkVeQM7QXpw9iv0mJ5a2kuXeDWUF0ezT6CLDKrL5CJUOXy6f7zB9s435P7j8Mw5uLGMh+gL9NmtD3wcqNWmvzX5aj31Sfs8+Myyty+WBffjxHuHHzzHomPvtSOKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dET9DkLiWFUYXQHLoGLpWw8qFSsU7xlV1jMTjS3LYtk=;
 b=GPRnaYGfJX1LZCGoVrcdzwQhC7+u7xQUb8VUjx9hPkzru6Vigimv4REHxgpZHwIhzA8o/nk5lZhD7zs4FY4C05OvtG9YOxF/Nh4ObKnIxvT0LSN+Ed7kQpR5py3fcSRIy/nBwTOoBS6TrMXmYvgqsm6k3XkXSW8cljT42b+58rmiltP/Mbn3NQuGBnbkV4Ag+Z0Bj9lnwOZlPkDs170HNRNPEC8MzMnG/tXmAE3OLFCyWx/+RlC8aXtzENpZsiB+On7JiEUVfzY1SRCMwwTGYyKUw9cRQurxE/zd0hEICGTJfDkGUr1PhZXrQPIhpf/PzTbGjdFPOztu53ynuESC/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dET9DkLiWFUYXQHLoGLpWw8qFSsU7xlV1jMTjS3LYtk=;
 b=mPV90ir9pFklb6ZbufQ73JGjW9AXtbFtVW0xtysvc2cwEQdD886S3hYK7aIiC4pXBPiMKSlr8GXGTHFAJIFhWBoChblom5ApuUq+cgZ/6PgRrWm6l1OuE44Z8S1XGu+dQ4+t6SFDNIOvIJOdZwRm3fIEUfKYJyJTl3HLMFQ6O4k=
Received: from BY5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:a03:1f4::21)
 by MW4PR12MB7015.namprd12.prod.outlook.com (2603:10b6:303:218::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 21:13:46 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::2b) by BY5PR20CA0008.outlook.office365.com
 (2603:10b6:a03:1f4::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 21:13:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:13:46 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:13:43 -0600
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
Subject: [RFC PATCH 05/19] x86,fs/resctrl: Add support for Global Slow Memory Bandwidth Allocation (GSMBA)
Date: Wed, 21 Jan 2026 15:12:43 -0600
Message-ID: <0f1046790e7721b4eccbaf246c23aa96b551008c.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|MW4PR12MB7015:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e102eea-ff71-4ce9-80c7-08de5931f71c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n3v+b9a54znFp9HeFE8FjkS+rfUCPkd42jN0481Al6i0imXwnEXMsa9MuV0B?=
 =?us-ascii?Q?Jh8C/C4BlFDC3WZ2aOGsijkRBDC9TRPK+GtSBZm16MZ/yi5u3FreZJnlKCKl?=
 =?us-ascii?Q?6O/evJt8lCR+bsDBh6fB+ZhwoxFDQf8UVdpUv4riYg5Flg7Riqzib51GRQbb?=
 =?us-ascii?Q?9rScGU2rnW7FMegi3oDlQbD4Ljci6asY2QlG5qpuWzkWhs9wWq9cjczTlKRq?=
 =?us-ascii?Q?/NMnVNcLHs+RjXuSGjcmh0Lxieqe9L7PcTjnQdb8cp4kkYhTlTcc1+AtYaaZ?=
 =?us-ascii?Q?tANt31n7E33ws7JAf7BtO9zFrQVdAMgcWCcwNCCxGgcmG/aWwPX3oiTO/Ixs?=
 =?us-ascii?Q?Xp/B7igH1KRG+9Nj5f83ilpwTm4UNPA3xKdQtbQ3lThBbQUQxeKf7UWWsUNy?=
 =?us-ascii?Q?U10mRAwr6Mw2TCuTbIbQ5u4ilY59lqY1a6naZwBJ8O1RRCIf82ePUfmH6yRu?=
 =?us-ascii?Q?AvzxujuNUOA8oPjQjr/Qxrp8kN8RfybLUYfSwaE2fOaQ9d4uCDus1aUgDMCm?=
 =?us-ascii?Q?AYrxIPCZLBHpg0E6ou9KkTTB1KfNWSnKdxOs0GVlNROfDBgFwHvUv9UfZBOW?=
 =?us-ascii?Q?SFPVWwWPnhXQ95Y5Y9RAy6gtGjKCllYiadNnfW3EeCm/gZYlKC1knnd5dkcg?=
 =?us-ascii?Q?OxoTMurtXtlLNr+Uon+/S7C0qJkfS+du6pT5p1V5mBJv55grHGZ7JsPG7KU2?=
 =?us-ascii?Q?rIxTD3NdFpSKTdZZxZCtuwiwCCdhRpI082QPLGPfhtbF2iWUPbzmydnVABp9?=
 =?us-ascii?Q?dPDhbed83CYD2E8hglKDAi1Buk8bQq0eKguT2CtL/+WrV3dt3xl0MBM6suA/?=
 =?us-ascii?Q?OXQkdSG3QDlmBPzbEB1EWA7AgLqYKyJ+mtq6KC1+2rE5EizVI1NIYzMjwGTR?=
 =?us-ascii?Q?5eiS9lXOdmU8Yu5d5W3yd5hh/V10mY7npfD/lPl72b4trMtaBtDc7x2a1UEA?=
 =?us-ascii?Q?SQHXindq3ZtheZD7scAsRzS+odBG0bK3FqIINEcVKWsaHqxBsVSS0AfLMSGj?=
 =?us-ascii?Q?bGmp3gOHAtbR54ldUZ9r8z/ACz+2iWOXPp2BvdA9YBhj6ShALnBrkN3K31Na?=
 =?us-ascii?Q?MmF0A2hMGMmBIgdiqJhfDvo+F96XuKkQDQnYE/mV7NecwTVugDzmq8BbK6IP?=
 =?us-ascii?Q?kG33hncFWK30ii1/3qfX3s9qd6wOrYxfIjOgfgbzJTsfrX9DJ+WN2XhQU3Yw?=
 =?us-ascii?Q?Qkg3ahLtHDezBTCRzTBvoV0IutrCNxL6+XvEUj0bLOO9pUrjcA2olMtzoWmA?=
 =?us-ascii?Q?KmcEdzxgjbeMkFngbA5V4wrIhn7y5gRtmvqqGRg6whhSMrjRvsKWgK0dTp1d?=
 =?us-ascii?Q?ii1234VgKfEglBHOuRI8Zi3Go7og7g1sCvdgDxExuhwWbnYZshtAExOobN20?=
 =?us-ascii?Q?eiReth2AvZ+CwZMTLO+ZBVLXcRbBsmvMp6qf18S6k1V1bxawTMD/MKTzhde2?=
 =?us-ascii?Q?C16+fCEyNl/Byr6M4z0+GLkkV2V54M5JxQ2VYs4LRnS/chEiW+AH1VWSF8IQ?=
 =?us-ascii?Q?3sAmXewJWmhi2aL/nGJiLXvmSz5k3C9n+X+QwFrVqVGuD8DjnatDQbdfImLu?=
 =?us-ascii?Q?0U2ISkKfTt5eOsIZvH7dnGSZ7zVa5201wLvB2mgp16iuUSw1EKSZYIm3GpN8?=
 =?us-ascii?Q?Q0Cker/rybVI60iZ35NoVhdz7QUxCuw6MADFFsDoe7thyA5mPOUSljv3Ikkv?=
 =?us-ascii?Q?z7VdSfZmR3LdLoXn7p4XzIQ2t3E=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:13:46.6222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e102eea-ff71-4ce9-80c7-08de5931f71c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7015
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
	TAGGED_FROM(0.00)[bounces-68785-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 480695E4A7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

AMD PQoS Global Slow Memory Bandwidth Enforcement(GLSBE) is an extension
to GLBE that provides a mechanism for software to specify slow Memory
bandwidth limits for groups of threads that span multiple QOS Domains.
GLSBE operates within the same GLBE Control Domains defined by GLBE.

Support for GLSBE is indicated by CPUID.8000_0020_EBX_x0[GLSBE](bit 8).
When this bit is set to 1, the platform supports GLSBE.

Since the AMD Slow Memory Bandwidth Enforcement feature is represented
as SMBA, the Global Slow Memory Bandwidth Enforcement feature will be
shown as GSMBA to maintain consistent naming.

Add GSMBA support to resctrl and introduce a kernel parameter that allows
enabling or disabling the feature at boot time.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 arch/x86/include/asm/cpufeatures.h              | 1 +
 arch/x86/kernel/cpu/resctrl/core.c              | 2 ++
 arch/x86/kernel/cpu/scattered.c                 | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e3058b3d47e9..d3eb21e76aef 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6325,7 +6325,7 @@ Kernel parameters
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, gmba, smba, bmec, abmc, sdciae, energy[:guid],
+			mba, gmba, smba, gsmba, bmec, abmc, sdciae, energy[:guid],
 			perf[:guid].
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 86d1339cd1bd..57d59399c508 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -513,6 +513,7 @@
 						      */
 #define X86_FEATURE_X2AVIC_EXT		(21*32+20) /* AMD SVM x2AVIC support for 4k vCPUs */
 #define X86_FEATURE_GMBA		(21*32+21) /* Global Memory Bandwidth Allocation */
+#define X86_FEATURE_GSMBA		(21*32+22) /* Global Slow Memory Bandwidth Enforcement */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 8801dcfb40fb..b4468481d3bf 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -818,6 +818,7 @@ enum {
 	RDT_FLAG_MBA,
 	RDT_FLAG_GMBA,
 	RDT_FLAG_SMBA,
+	RDT_FLAG_GSMBA,
 	RDT_FLAG_BMEC,
 	RDT_FLAG_ABMC,
 	RDT_FLAG_SDCIAE,
@@ -846,6 +847,7 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
 	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
 	RDT_OPT(RDT_FLAG_GMBA,	    "gmba",	X86_FEATURE_GMBA),
 	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
+	RDT_OPT(RDT_FLAG_GSMBA,	    "gsmba",	X86_FEATURE_GSMBA),
 	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
 	RDT_OPT(RDT_FLAG_ABMC,	    "abmc",	X86_FEATURE_ABMC),
 	RDT_OPT(RDT_FLAG_SDCIAE,    "sdciae",	X86_FEATURE_SDCIAE),
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index d081d167bac9..62894789e345 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -60,6 +60,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_ABMC,			CPUID_EBX,  5, 0x80000020, 0 },
 	{ X86_FEATURE_SDCIAE,			CPUID_EBX,  6, 0x80000020, 0 },
 	{ X86_FEATURE_GMBA,			CPUID_EBX,  7, 0x80000020, 0 },
+	{ X86_FEATURE_GSMBA,			CPUID_EBX,  8, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_L1_NO,		CPUID_ECX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_AMD_WORKLOAD_CLASS,	CPUID_EAX, 22, 0x80000021, 0 },
-- 
2.34.1



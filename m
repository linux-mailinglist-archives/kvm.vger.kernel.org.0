Return-Path: <kvm+bounces-68779-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMUNDK1BcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68779-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:14:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B937F5DE21
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:14:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A0783B075AC
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6852730F53E;
	Wed, 21 Jan 2026 21:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2PkFBr4M"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010000.outbound.protection.outlook.com [52.101.46.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C41B426ECB;
	Wed, 21 Jan 2026 21:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029752; cv=fail; b=KHexKslnxs1Z504xIYCTzMOCPCf9kbCOh1VhH2id8LXN8OEApxZMZdb6tUHZ7A/8kXfpulkFzLD96YtJ1VblusxBYBgpBfve0EfiBr9KTiL1tdBZv6Fxe/QKXft7U3cUtwolAuS5Vvxsl2M2EA2allHoaOS87D6LOqS9ZosIFrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029752; c=relaxed/simple;
	bh=5JcyNK6iLnSYcGbYly1WtPePbCQOkm3+O3rs00pl2vc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eNyNy6YG1yupSv/K81cU2/LWAMA3FvIVG7ErP8F3XcQoP0KZgsbUWPxYm7TI7/hFPAtOvjwmbKaOOCQYM57qkRL4uhe/HaLRbh88nSk2mOZsLT4kORD40u/r7ssdzz7fqLpgdGpZGTvVzl836+QEUyVG8pI/M84yOCxM5m+6kUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2PkFBr4M; arc=fail smtp.client-ip=52.101.46.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XPVEInHd7N5a/odWuMKGbZsB6m/nlxiDMEwAeuI/NchzayYysojaZIoLIFi0/aYIXyQTi8odVGry3UXJ1rCz0QaryTgy6l1X03/OoI01c2367yySa/EpF5c+Bxe6CRvNwrqDktgDs4GbltIxEO1Bvy+Qn3Aj8sHWjn297G3RlmCSE0uz/P4PPLBrTVXF/WBv0aWfcPrsI/jiB43tFNlA3HXEBnxVvBusgLVqBfrXoUbxWTVzhVXjBhAtpt6YK/3/u5m1yoUeSul90VeO+NAXSsvbA7+6edQ5+/DeifVK6fip+U92+7QcuNwTdVvRo2O/ij6flX6v6a7G6jS5j7qSNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ot4YPkCiLiBaR6M1lp5qi3D4FX+rdEyylRX1o+LnZE=;
 b=GgnCK0gNww5DGwcFOx9XvjrmS+PNNqRzVRvxl+bPWkie2Ds8le62ax01SZg9rNjyfoili/42VhgUZGbwizUCYzckr9Gp/jgxJnG0kUFoMFY4YR9N7R5RXHBSf2vdjRCNDHOBDEaL2Nf63DcUkDP+FF1LviX0+RpnSBmRSi1LGfLGX0eIO2Vk0aKoHQncitdzf7XmQkJvKRhTOanG1TN6Np7hQxNWJMk689ZXg9hYy75B4ueV985l1bZ9OQ2DyqtJb6K2Sm+9ELakFxTqqf/RrrQMn9zv0s97FDAzvrjStZ8ZNu5Cb2iRNmH68gwv+uwfGyI2Ev027D7qj9eceSgKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ot4YPkCiLiBaR6M1lp5qi3D4FX+rdEyylRX1o+LnZE=;
 b=2PkFBr4MIg39/HVFlVGJmT6xyrjpZuM6FClpHL7RwWtF6Bxpd3ACAwv6LEFtBgtds4fqu4JM1ySCaGdaBBRa27Nnq9TwdAwN6W5O1+pqDw0jK2WlsQi6Oy3rLGYx20iC8jpyJL04qM/ucShkcVRGYYZ0L5dpL/MthivOB476qVY=
Received: from DM6PR10CA0034.namprd10.prod.outlook.com (2603:10b6:5:60::47) by
 MN2PR12MB4439.namprd12.prod.outlook.com (2603:10b6:208:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 21:09:00 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:5:60:cafe::cd) by DM6PR10CA0034.outlook.office365.com
 (2603:10b6:5:60::47) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 21:09:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:08:59 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:08:58 -0600
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
Subject: [RFC PATCH] x86,fs/resctrl: Add support for Global Bandwidth Enforcement (GLBE)
Date: Wed, 21 Jan 2026 15:08:21 -0600
Message-ID: <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029700.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1769029700.git.babu.moger@amd.com>
References: <cover.1769029700.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|MN2PR12MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: b5880cfa-d5c3-4c3b-c1ff-08de59314c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bo6G59E6eUK8fyW5iRb+9l9+iuGB6eNapVNHv5lts9g0+PshlHRyQmn1hxux?=
 =?us-ascii?Q?LlnwcJks6ewQ/ByMA3lhEF1LIEJ6HuVQRYyT1/ZMwEivH/CetyKSx1fiKNqc?=
 =?us-ascii?Q?oQ3G0cyOw6GLkUc+nsv8K55Tod91FdSjQ9h+SoGSf3OIq4axHKEIjXxgQugS?=
 =?us-ascii?Q?zkuJ1uoPLKMBFMDxttU48/Uaa9GR+DIbNrQRwHJmXj5NXz0HoX5kPNGlaCHH?=
 =?us-ascii?Q?ewXn2u8y84xUbWEZ65TvhaEodTiO5gdIb1vhWlUsTjyeGDDPuB+794me7n0F?=
 =?us-ascii?Q?aC3AexOBPWKoj0iSqHimeTpw3D9kFVm8Bg3VFWIvf/98TPoFhO8w6Yqwrkcb?=
 =?us-ascii?Q?ueI6KKHI01X1C+lngW7iiTbcknpxDVASIjGBHqNztl0cLDU9cu2siQHGWr/u?=
 =?us-ascii?Q?xwdleCry24XrXphP/3vweQcOGguTTE6VBstxeXOkin2J+3ciPGiCqMOSEBVD?=
 =?us-ascii?Q?e84VzIRxUqj18wnoAw9HVkEwaoH46NniUK6/9ICx2IVwMOUZjuNWV4o/IeCI?=
 =?us-ascii?Q?3JIpMaVqRh+bSFNdkFSe2+l0c2l7m7o4RCmjWrcKpnQC3ebDwY9Ks2AvEgsF?=
 =?us-ascii?Q?UbBeF7ccbFgO6QzY1RP2/cIOCmG9kilQDrdqkPvz4A/3WKZ1lTrcAkWtQ1Gy?=
 =?us-ascii?Q?bzIb9zKVmJllanycWPgYBen5IedWGBZDotjber5keOtWcAi4L9MvdlsWsJGO?=
 =?us-ascii?Q?KQaRx6du5Kjn2oB4b5syQxNeNKmjO9AXbRzYW3P0t5abBAFAcb7fXAVx8Jnh?=
 =?us-ascii?Q?enKH6pbNjUZmjqaZT5/ma6FiRiNekwCUNWonF1q41CDVPOaV0Ft/J9Nl80/9?=
 =?us-ascii?Q?lVNAWvlc60OGQG9QaePKawNYtz3fhm4IrWPXbYtH/lHFFomMmuXkrsEZuj1g?=
 =?us-ascii?Q?7UINtWckxleZdb/b2Q5S2z1r5hEEqLZ4ZB+QLMVoJte9EHkh2d7Zon5J750F?=
 =?us-ascii?Q?Smisqvn3ZRbgY0tkJ5A6KN8jYinOVCMN3BBobcgmQpida/6MEdODJCJJM/TZ?=
 =?us-ascii?Q?2pw/2sQwlls2SgkHJrAVzWtlh3h6faLzGiqZQufs2Ga3uMMY6HhzhysdMitP?=
 =?us-ascii?Q?8C1z17KzJ+2F7BcHrkNkTMvdCqHTR5AD5xls8MEL1TLHpoSvHtYWXna1dyXe?=
 =?us-ascii?Q?kEdBh3/tWViGblnbhyXqU12RADpnyfYVu9xWJCTWB+Jtt0Joxut7A1sq+YZr?=
 =?us-ascii?Q?T/YXWs5k5bf/wLm+c2KQaSWoxTJbGvm/JCbO6JoqihMMfQ8hjF9Nle602Qf/?=
 =?us-ascii?Q?1jhZ3i8W5gvRkRCwfM+w2fyFyZAl+GPpt9TDHHOu1u5jg29wClYSwZQyfQ/I?=
 =?us-ascii?Q?6XJw0ZyDIp3JwyRhUpxbTY1M/rocFjubkTX5vh+6P8reH/6kP1LDgDJ8GPoH?=
 =?us-ascii?Q?vqT9Tx59hIBcyeA8G8HM/d/AZsZc9MKunRRMVeE+Z2mkBs13ISkvKyvaTWsv?=
 =?us-ascii?Q?bb99kKRP/wAmm0qSESHxvd1GAvQRvpnSskDUPNnytMjvV+5NwZ/z6dX0bJjy?=
 =?us-ascii?Q?Vm3yJkofzLa6W/1cIrFaABqGDHIoBrQxtE46w6/OP1xcwNUK9fE1nuNHxqjv?=
 =?us-ascii?Q?ZkN+aEWLAmidyHz4F5z1KJ8TXPBWMwqRfx0qiXg4ZwE59fPpey208eHUjsUR?=
 =?us-ascii?Q?SpJq6fBbo052OhYJ8z6o2F0locT7oEucT4HR0XTB5+p/3t1IczJ7g4F+putK?=
 =?us-ascii?Q?bWFv6C2NGwN2Tkp1TM0aMIf7THE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:08:59.7135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5880cfa-d5c3-4c3b-c1ff-08de59314c15
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4439
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
	TAGGED_FROM(0.00)[bounces-68779-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: B937F5DE21
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On AMD systems, the existing MBA feature allows the user to set a bandwidth
limit for each QOS domain. However, multiple QOS domains share system
memory bandwidth as a resource. In order to ensure that system memory
bandwidth is not over-utilized, user must statically partition the
available system bandwidth between the active QOS domains. This typically
results in system memory being under-utilized since not all QOS domains are
using their full bandwidth Allocation.

AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
for software to specify bandwidth limits for groups of threads that span
multiple QoS Domains. This collection of QOS domains is referred to as GLBE
control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
in GLBE control domain. Bandwidth is shared by all threads in a Class of
Service(COS) across every QoS domain managed by the GLBE control domain.

GLBE support is reported through CPUID.8000_0020_EBX_x0[GLBE] (bit 7).
When this bit is set to 1, the platform supports GLBE.

Since the AMD Memory Bandwidth Enforcement feature is represented as MBA,
the Global Bandwidth Enforcement feature will be shown as GMBA to maintain
consistent naming.

Add GMBA support to resctrl and introduce a kernel parameter that allows
enabling or disabling the feature at boot time.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 arch/x86/include/asm/cpufeatures.h              | 2 +-
 arch/x86/kernel/cpu/resctrl/core.c              | 2 ++
 arch/x86/kernel/cpu/scattered.c                 | 1 +
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index abd77f39c783..e3058b3d47e9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6325,7 +6325,7 @@ Kernel parameters
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
-			mba, smba, bmec, abmc, sdciae, energy[:guid],
+			mba, gmba, smba, bmec, abmc, sdciae, energy[:guid],
 			perf[:guid].
 			E.g. to turn on cmt and turn off mba use:
 				rdt=cmt,!mba
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c3b53beb1300..86d1339cd1bd 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -505,7 +505,6 @@
 #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
 #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
 #define X86_FEATURE_SGX_EUPDATESVN	(21*32+17) /* Support for ENCLS[EUPDATESVN] instruction */
-
 #define X86_FEATURE_SDCIAE		(21*32+18) /* L3 Smart Data Cache Injection Allocation Enforcement */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO (21*32+19) /*
 						      * Clear CPU buffers before VM-Enter if the vCPU
@@ -513,6 +512,7 @@
 						      * and purposes if CLEAR_CPU_BUF_VM is set).
 						      */
 #define X86_FEATURE_X2AVIC_EXT		(21*32+20) /* AMD SVM x2AVIC support for 4k vCPUs */
+#define X86_FEATURE_GMBA		(21*32+21) /* Global Memory Bandwidth Allocation */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 9fcc06e9e72e..8b3457518ff4 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -795,6 +795,7 @@ enum {
 	RDT_FLAG_L2_CAT,
 	RDT_FLAG_L2_CDP,
 	RDT_FLAG_MBA,
+	RDT_FLAG_GMBA,
 	RDT_FLAG_SMBA,
 	RDT_FLAG_BMEC,
 	RDT_FLAG_ABMC,
@@ -822,6 +823,7 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
 	RDT_OPT(RDT_FLAG_L2_CAT,    "l2cat",	X86_FEATURE_CAT_L2),
 	RDT_OPT(RDT_FLAG_L2_CDP,    "l2cdp",	X86_FEATURE_CDP_L2),
 	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
+	RDT_OPT(RDT_FLAG_GMBA,	    "gmba",	X86_FEATURE_GMBA),
 	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
 	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
 	RDT_OPT(RDT_FLAG_ABMC,	    "abmc",	X86_FEATURE_ABMC),
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 42c7eac0c387..d081d167bac9 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -59,6 +59,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
 	{ X86_FEATURE_ABMC,			CPUID_EBX,  5, 0x80000020, 0 },
 	{ X86_FEATURE_SDCIAE,			CPUID_EBX,  6, 0x80000020, 0 },
+	{ X86_FEATURE_GMBA,			CPUID_EBX,  7, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_L1_NO,		CPUID_ECX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_AMD_WORKLOAD_CLASS,	CPUID_EAX, 22, 0x80000021, 0 },
-- 
2.34.1



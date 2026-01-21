Return-Path: <kvm+bounces-68780-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELbvK1VCcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68780-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:17:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3511B5DE91
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D89825077A7
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7A8428476;
	Wed, 21 Jan 2026 21:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VybWJfP2"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012015.outbound.protection.outlook.com [40.107.209.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35992357708;
	Wed, 21 Jan 2026 21:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030000; cv=fail; b=tDQf+fLjYDk/PhdQgOMUtmnjeMVt5VkU5HubAVmQpAP1AoJS66gV9GAUfs/+WS/iLNu0R0l2CmiNQg7pvGsfqYxTm9nYRFBLa2E5Ens82xVyYSN56MfATYF84RtwWl4tJgEIwpG7km0sOwkmG5YY1DU2M5RNvU49t8EVq6bpEbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030000; c=relaxed/simple;
	bh=5JcyNK6iLnSYcGbYly1WtPePbCQOkm3+O3rs00pl2vc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgPunH5sSPHIxzW/Ug/+Ldot5xZHOUQG6839fG3XeU/hrMTnL3og+1SqWxgGKbRKLLA3ra33EJXOlrJ/2t1SjVpGXr2pKRNQAszXPgZxHhnp3Tm6lLQgNZT/58noZGW2RWnDUMdRW0sqepmfctsKXJ2OAC/WN6g2OTDK/7K+Pso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VybWJfP2; arc=fail smtp.client-ip=40.107.209.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/23pkLhyibK3NyYLCLRKJ8Q3SYxJY6CcjzH3EXPCT9fFRKHKsjVcQWo3boncMOw1SdxrxQttqtuF/gHTHkv+vzIAKY0gO3kLoNGXtCurQPKL0sNHzm+nQ929nnJGD3uPyKGBpIucCxopYeJbv3TF5hGC1MbtbIi2vrx58/qkwEHLj+tl4c3j4Si64nap3lUYCGBF5OIpONS8JFEvthpkEir/xyeuIwwr9UgMycj7QL/4MpvXxZBCuMijIHyx9AJybhxS8VxEO9rkHJpQSOR5hKQWh53Wl28TbEn3lhqd0yEiPiTCjlbaIVfVdwGhRt8iwDk3CeGgxyimeBlgPViBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ot4YPkCiLiBaR6M1lp5qi3D4FX+rdEyylRX1o+LnZE=;
 b=F7nKio6Z6lNzgoQvyXagovKT8WRHU6byqt2TIQNU0/wMRKbQx+/4GqGTuVWXlKPw0Ya6xjoScK091qVAWgrVWz1NEzh8U/7G9xvY1myKf7CagyPRoaiQzaU6C9dTLJfIDpxo7brh2+AwHnJEkeMrkZKdjFa6Nx49SrxeH+nt9rSxi1+3Fh0AOxfwA/1qUaHjth6cV990ZxjnmdpHUa3s7vKgXT+oxqbJtNzXNg5MOhlgHw82Z1CLLe84ZW9A9Ytvv0pMLjvtvWVCcyWwrM0EUPTMtGJYOetYgyTwZWl4rKDF7Q22f6gGBxuQAOntrQ2Ob/xpEeJo/O9cY/X9B6QcwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ot4YPkCiLiBaR6M1lp5qi3D4FX+rdEyylRX1o+LnZE=;
 b=VybWJfP2cYjYtjYZWWOSMSdIadfbJXzSUYLa1LTPDm5voeBCYzaNu936Q909/FPzxfsWGi8/LQ7h5cvHgUCgzBBFwgE/qDMZKzrlMKvkIOaYV+7IW6sU7IvdCtnFwAIzKzGC5MgjNzRLNRbGywuhTZOtFRxpNYuGv6dY+EtD15g=
Received: from SJ0PR05CA0045.namprd05.prod.outlook.com (2603:10b6:a03:33f::20)
 by DS4PR12MB9707.namprd12.prod.outlook.com (2603:10b6:8:278::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 21:13:13 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::ac) by SJ0PR05CA0045.outlook.office365.com
 (2603:10b6:a03:33f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.8 via Frontend Transport; Wed,
 21 Jan 2026 21:13:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:13:13 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:13:11 -0600
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
Subject: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global Bandwidth Enforcement (GLBE)
Date: Wed, 21 Jan 2026 15:12:39 -0600
Message-ID: <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|DS4PR12MB9707:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e1cdde2-1359-4b28-c979-08de5931e324
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Un0XMty5w2EAPMt3YEpW72XwYc56gqE5hbXasnehQMZH1F19faJeD9DFwaIB?=
 =?us-ascii?Q?OHicYlpYhB2CZwniS51p90nBVlzY5k8cXoKmreHltun52VHrStweS+rK4Yce?=
 =?us-ascii?Q?vpEhMUDZZ9lUmVbDPjoz9fYjSSAmLp2cM6/h9RentrVM4fDaIv2OpPLfoyLm?=
 =?us-ascii?Q?gY/0SOcArV4q3Xm49dyMKnOYQcehP6dJBvzpqfZt+p8kleR4qQJxdiL0fuLp?=
 =?us-ascii?Q?aMIbQiE23ec0UVfLaHcu0xiE6uuiBg2JItB28gZ9PXWcfxC9Gw5MM7PGRUId?=
 =?us-ascii?Q?eJ6wqhh4MgfdnHSvJeA5/Z87eWsvY6jHNyCS800xTjdm/OIwsmUy3XpVRMY7?=
 =?us-ascii?Q?klkW2HHKRTe9Ms022fq4ru+wnl/HRmVERBx78qrKQShkIMby9UzadP+tGwkn?=
 =?us-ascii?Q?UpJAZwmY/BnytR5fWaTa7HmeJiqIAtPILaUG23O+6N/V9jE5tvMH4TKTZw+f?=
 =?us-ascii?Q?DIpi2OhPW03r9TsB8m046dsug345dhuWdKJyr1CPwa9EgheRtfq2jInq0Idy?=
 =?us-ascii?Q?DKBES0Q8LfkezFauH64jbLX3oFccod0l0fFNgA4fUvK2xuzw7Y4Nwr3uJ9HI?=
 =?us-ascii?Q?e5HKZegCFFccTIte4pjzRZMm2C14/nghgA4YyH3bRmuS3QM1agIJATNP53FC?=
 =?us-ascii?Q?lioc2vEgTYiq+dzXUraGogP9TvDsToVadztShyGSowVYQFTxToggbwSvJbzP?=
 =?us-ascii?Q?aaMLOGYOlOKbK5oDGYTLzI/g39UJdhBYxez/ZQ0tgiBo7qNs6Ldl4hfHXf5W?=
 =?us-ascii?Q?7orFX7+P93kjm0gun8Sfr+pTMf5LK+eXOJ5l4KkupMQ4T4Xup9tEnlcWUK+a?=
 =?us-ascii?Q?qdkJmJ38z4eejaVa6yxqNrTGGd89xgwKn27K2mGQH0VQGTD50iy2+CX9bMJ8?=
 =?us-ascii?Q?AP/O5/1Xz6Ao42udMsW7bt55INhT6fAm0jU7IYls5uoJ2Ax/zqetJtAZ+mU4?=
 =?us-ascii?Q?icd445sB520dZAxrRgi9a5IV5+d3lnl33WT2LIcmfAkjb8x2mX3H6ClN4TOd?=
 =?us-ascii?Q?9ZPe4/nXv3h5CE+g30NtPLYv5EnQYkCOFY8hFYcGV+0jO75RRxmCazIMeHz3?=
 =?us-ascii?Q?ZLhtAk7Oth6GrqIl8UtR66QRviTq8OTpVUcPMsjCNhMSmCiaYATqvEc/91fc?=
 =?us-ascii?Q?KRBpny6QsuoddldBiTmX3dYUKpZPo24Fd1W8YQVmkz1l7uuUAHwucb0gE4mE?=
 =?us-ascii?Q?fN6gov8YDUXSUr0Wyxuy5CLf0akN6gWy2KVpm20Pd6xMLVrjlLQB1eCh3NBE?=
 =?us-ascii?Q?q8oSo7SAGSo9Nd1uAbaOahXXaPdUaB0qjDZWZpagjxHN193sKHRP2vk+CfhP?=
 =?us-ascii?Q?mumS05Wqwwley7GoiE83Rhop2cgfceiEoXUuCO3jsHtoQTJ095qToE1O+N2R?=
 =?us-ascii?Q?b4vjGe4UdJTxGG9MbMaFYwUPIDTpbHMUukZlHODMFp9EnD1x8zX40VpWz7n7?=
 =?us-ascii?Q?3+ewy2P9I4IHHxZe6hZGgtQfsHrg7txtBZMR40qrMHRjAaDI21rjtJo9PX2n?=
 =?us-ascii?Q?cJg04WMan4yUkTMCJrqaKVO1Q4uiul0Gx9nHQtESw8Xt1rSWuEOL+JVzpgDi?=
 =?us-ascii?Q?zi+V7JrUBk4jiBTs4YYT/nS50IyU2ZSBAwlaxEVp2pnpm9G7ykdANQoFPM+c?=
 =?us-ascii?Q?DN658Ii0LfrlkiVrb4LjWsaOQt4bR7PaoK2N5SaJQAR+rXlK1pKTRFMa3jPN?=
 =?us-ascii?Q?w5d1BCmuBa/3GdIf/PO+a8un//U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:13:13.0958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1cdde2-1359-4b28-c979-08de5931e324
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9707
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
	TAGGED_FROM(0.00)[bounces-68780-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 3511B5DE91
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



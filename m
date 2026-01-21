Return-Path: <kvm+bounces-68784-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wONCFL5CcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68784-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:18:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B103F5DEFA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:18:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 75ACAB28B57
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F5D426EB9;
	Wed, 21 Jan 2026 21:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bsWFt3tv"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013050.outbound.protection.outlook.com [40.93.196.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D3D42B759;
	Wed, 21 Jan 2026 21:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030026; cv=fail; b=gYvIRGLFi120W5k2Pj/JFMKCA3KWeLODUSK+kdPq9LhTwAUmo78Ef7OoJdo+f89NL2L2Yd5HkAEX79/iZFOqOvcPi1VTi6YW7v+XZWM/LfrflmBN9AbdXT+B5o4VhWF4X3047SYyZiCM36kRNGZxxq3BcJkJeKdQqe9OWW+tb0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030026; c=relaxed/simple;
	bh=Si4oT+ZjhnigXaXf24Py/aaaUjWOphr2moG/TlJ5uf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j2a9LFppjVV3lgL88FtCVweXnoj9Jt7uEDlW/XPUjtY6IPe2vWF+4Ok+e0a4aY6pyt3a1B5ZTu6X9T/RE0/cP+6X+O3ltfQ8yvzgDlardkO98xVdxUPzdqk4pdSkvD/VjBl18KXLnsnoyrFShYg2zytdHCCQCzWfPiDReTTHxS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bsWFt3tv; arc=fail smtp.client-ip=40.93.196.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EjcTb921HdX0FrS18UE1aRFqBzhA8UwJyBsGF83RFVpRm/WRs3X04SMrUOIeDPhe9RT4AH7MQh3ZuCoyJcHzhpWPnx3xYZFbGLkAqCEsnNEWrjdx4KNYBew66EKdC5mMvo6pu0LVCj9SF6p//bCQRBcC+IK2fnXImwvM/b403WvBnpVkaOqlIvMf07RzZP7Inw/VYP1QW5V3G9SY6NxoyvFS+488fkR/HmYVzFt+ZbzEDYnUXiVz9Qnm0F27npvCRtQPt7EtV2LllN68MIdrl80Htr3fqBVjVZQMOszmz3rvm7+xHamQc73vCNfN9CkS9aQBp8gJd7ipNtClYNxTKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYIAkSRwOZyJ1DXPlSMjTzvfWW+fvbahMrWeAvqdUzE=;
 b=i5J129VzS5+F2Xz0VwZGZmHtygnny/VKGOdNkWiUtxaBdswPbxxlQRIUNzjdf2RD3W2SKo1kmoLXu7Yg810dMJry51SLxfkrY7LzSeVfKhu5d8ysE/Sknzc5YcnET9x69T3ybJsRaKnP5IWI8HgkDLOkjE2A63TykMgpRWgqrOxvikcY3iL/hZoPkFjG3MHQtroTAWLPlI6Pc40YS15HRUPxfU1qhGsHwD7NQ7WTCMwQgk/LPk7y7xptsei/ulsKj4aEbyEq/mfbdLwBjd24As9KPc+NEZUo3tb1H/7r4lspR3pbO+AxPkgvkTLi8m6zVGSAOeCco3I4R9thaNS9Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYIAkSRwOZyJ1DXPlSMjTzvfWW+fvbahMrWeAvqdUzE=;
 b=bsWFt3tvuGrhE7rWSI93xV/KW9F3UN9h+CuoGwjJ2ed6izdNIv+ejSlfuMnJV/37IRNvx75HG6D0SRGv5q/VaCBTlttoOVxpqihu2slpQfUVWWmXbqpdx10q0nS9VbT+7iXlIsVt+BBB4f7eEHd9HVvUfsrypyYACNqgBBObd+I=
Received: from SJ0PR03CA0362.namprd03.prod.outlook.com (2603:10b6:a03:3a1::7)
 by IA0PR12MB8086.namprd12.prod.outlook.com (2603:10b6:208:403::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:13:37 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::e) by SJ0PR03CA0362.outlook.office365.com
 (2603:10b6:a03:3a1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Wed,
 21 Jan 2026 21:13:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:13:36 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:13:35 -0600
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
Subject: [RFC PATCH 04/19] fs/resctrl: Add the documentation for Global Memory Bandwidth Allocation
Date: Wed, 21 Jan 2026 15:12:42 -0600
Message-ID: <d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|IA0PR12MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: e39b8a1d-afcc-4e69-3cec-08de5931f155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oLVFa7h2ZXlxtVyHXxtQZw5GO739+7X05EdH2z5Qb2kODdpW1+5WkAQYfDjP?=
 =?us-ascii?Q?E9r6YJp0FsLQzENyi7UTt19b7Sr4JAVxc0xfqfx/hURGd7wSiQoRigrLriQ8?=
 =?us-ascii?Q?GzynU499EhsNMx4sGCjcfwKybgtCGDgMxWppSBQNgCpvz5+NgontWWx7btHr?=
 =?us-ascii?Q?IXsG6h5xWAdEmIHktL6rZiPd3ch1EzmyaPcYb+Vr5i4ukW/mI39A0+ibZvKB?=
 =?us-ascii?Q?Uo9ottpwb3V2AVUOfaPvOdQgGDJkJZXlcMitbzkxDF6I8fCjDf+7Enyboq87?=
 =?us-ascii?Q?xc+2aSV3bYtT3a/0F0UiWHNPy6BiDufZ55XNOCAh1byDCINBS/1bDOZrED0q?=
 =?us-ascii?Q?XddIeiQjwhjArbo7b51XQgW6A04O+VmoyklaxaAIiSj0OPnml8WAGw7GkEHs?=
 =?us-ascii?Q?KAK1Ljbzbwa/nD3vEFSyKiPqrp4HFPywR8Z5LLIJQuLqnDgSZlJ7SmlzEbPB?=
 =?us-ascii?Q?2BalRRf9uLhFMV8MgTCR3vlb5JAPg7sSH4k11+LHZP5hHlT5F1t37fdI87bq?=
 =?us-ascii?Q?/IVLXT4//bwVzfs4WHJGVzCn8LgVXantSyL/ifrx8qSGJA/f6tDw5KyIxNK/?=
 =?us-ascii?Q?hPykre85ZCRMwJPyLlCy5BoIyUJB9AbsN7k8ywHAV7yBZEfpAhWwyOV7gRK9?=
 =?us-ascii?Q?9QM12pCoLll8mVjI8m7kfj0PKBwf4/OJd/PTfpbK6+GSgHIG0iHgIpYeK4Fq?=
 =?us-ascii?Q?RUIOAk9mL0Obgy2GK7LNCC3z/KvWliexz1NfhpDF8D3rLX06qPtsJSD4z0y9?=
 =?us-ascii?Q?ekOUTgm5svwiOsK7vCGZ7wnPHKf3yvYlraDiwVZNUyDxFnC3p1wPt0LQGT4W?=
 =?us-ascii?Q?rxpCJW+PGxx8sw8fWJTeUMOyvAH8HRkhrV0VHEMQb6qQrHK/QlVUnV11rOlC?=
 =?us-ascii?Q?iOO9M/D5LjR17HK8dbyYoXTpSuGVQOj/hCD19jSnv3wpttcNaaG8XNlnQ710?=
 =?us-ascii?Q?mgbF6aDxdoYIHkgdZ9x+dFpCcdpQsh5vVVndZzxtx6Dl0LkrakJbOMLAJkcD?=
 =?us-ascii?Q?n2b4JpMsEJb0AtEhhBbKL6QhbYMsgM4MhVPrUPtlnSCXYZwBkrClX/mSK+lZ?=
 =?us-ascii?Q?UKUIoLFt19iA4PzUJfa09nx2odspIymmAQPHKPUvbK69THolU04DJtxgzLEK?=
 =?us-ascii?Q?DyvqxAOwRlRWP7Rc1Q5S0cxCA33fU01tyW+nTMAGWD+XneJas5UkYsXITBnW?=
 =?us-ascii?Q?H0ymmkXjfuI2jZkUSVbqkOMzcImuIP3CGiUG57yAqPDWFWTAm01paXssOfUv?=
 =?us-ascii?Q?UuVHDG4h+1D1sAE1/eZlZ2TUS6FetyXIo1x/6UOmWW6iZjiiR4AI4SzJQEsj?=
 =?us-ascii?Q?+WTC6cj/k1J6chYVYyAvgBCvCYNet8AKJA7tFVEk0V6NzawzefKawtbsMAkT?=
 =?us-ascii?Q?uTZdruKcqTGsT0Hi1+/g4k8vF6wtQ4Du3bQqYrZBYLbO6HWhiy3S9KZmYSKh?=
 =?us-ascii?Q?c3bYyQzNEqsLFvTqwAemaz5mClDVnFoyQO4RFC5rrLkSz38fwCNhkKyiLxHW?=
 =?us-ascii?Q?le8VazyOJ/+TogTRYCwJDYPondfwRQYpVdazlBk7xzvqk/0Qe/dsVHsLm0DZ?=
 =?us-ascii?Q?d/hzfwhDZ12u/3CIJ1bW3w40/mS6hPe7wfR8X4bqgQIvH5Bfamdd+da7fzIM?=
 =?us-ascii?Q?QmcLWmYdSTfMSjQbH3wW3ztUkFGXPJFA4bEr/XCKGb5AeYg3BKhZvIqegMVN?=
 =?us-ascii?Q?R9r2gFBEjMsMS3yT/ERZ/Ln/6Hs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:13:36.9004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e39b8a1d-afcc-4e69-3cec-08de5931f155
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8086
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
	TAGGED_FROM(0.00)[bounces-68784-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: B103F5DEFA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add the documentation and example to setup Global Memory Bandwidth
Allocation (GMBA) in resctrl filesystem.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 Documentation/filesystems/resctrl.rst | 43 +++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 94187dd3c244..6ff6162719e8 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -28,6 +28,7 @@ SMBA (Slow Memory Bandwidth Allocation)				""
 BMEC (Bandwidth Monitoring Event Configuration)			""
 ABMC (Assignable Bandwidth Monitoring Counters)			""
 SDCIAE (Smart Data Cache Injection Allocation Enforcement)	""
+GMBA (Global Memory Bandwidth Allocation)                       ""
 =============================================================== ================================
 
 Historically, new features were made visible by default in /proc/cpuinfo. This
@@ -960,6 +961,21 @@ Memory bandwidth domain is L3 cache.
 
 	MB:<cache_id0>=bw_MiBps0;<cache_id1>=bw_MiBps1;...
 
+Global Memory bandwidth Allocation
+-----------------------------------
+
+AMD hardware supports Global Memory Bandwidth Allocation (GMBA) provides
+a mechanism for software to specify bandwidth limits for groups of threads
+that span across multiple QoS domains. This collection of QOS domains is
+referred to as GMBA control domain. The GMBA control domain is created by
+setting the same GMBA limits in one or more QoS domains. Setting the default
+max_bandwidth excludes the QoS domain from being part of GMBA control domain.
+
+Global Memory b/w domain is L3 cache.
+::
+
+	GMB:<cache_id0>=bandwidth;<cache_id1>=bandwidth;...
+
 Slow Memory Bandwidth Allocation (SMBA)
 ---------------------------------------
 AMD hardware supports Slow Memory Bandwidth Allocation (SMBA).
@@ -997,8 +1013,8 @@ which you wish to change.  E.g.
 Reading/writing the schemata file (on AMD systems)
 --------------------------------------------------
 Reading the schemata file will show the current bandwidth limit on all
-domains. The allocated resources are in multiples of one eighth GB/s.
-When writing to the file, you need to specify what cache id you wish to
+domains. The allocated resources are in multiples of 1/8 GB/s. When
+writing to the file, you need to specify what cache id you wish to
 configure the bandwidth limit.
 
 For example, to allocate 2GB/s limit on the first cache id:
@@ -1014,6 +1030,29 @@ For example, to allocate 2GB/s limit on the first cache id:
     MB:0=2048;1=  16;2=2048;3=2048
     L3:0=ffff;1=ffff;2=ffff;3=ffff
 
+Reading/writing the schemata file (on AMD systems) with GMBA feature
+--------------------------------------------------------------------
+Reading the schemata file will show the current bandwidth limit on all
+domains. The allocated resources are in multiples of 1 GB/s. The GMBA
+control domain is created by setting the same GMBA limits in one or more
+QoS domains.
+
+For example, to configure a GMBA domain consisting of domains 0 and 2
+with an 8 GB/s limit:
+
+::
+
+  # cat schemata
+    GMB:0=2048;1=2048;2=2048;3=2048
+     MB:0=4096;1=4096;2=4096;3=4096
+     L3:0=ffff;1=ffff;2=ffff;3=ffff
+
+  # echo "GMB:0=8;2=8" > schemata
+  # cat schemata
+    GMB:0=   8;1=2048;2=   8;3=2048
+     MB:0=4096;1=4096;2=4096;3=4096
+     L3:0=ffff;1=ffff;2=ffff;3=ffff
+
 Reading/writing the schemata file (on AMD systems) with SMBA feature
 --------------------------------------------------------------------
 Reading and writing the schemata file is the same as without SMBA in
-- 
2.34.1



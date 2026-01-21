Return-Path: <kvm+bounces-68789-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gL/yHRRGcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68789-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:33:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 172D65E1A5
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:33:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1C00E54E03D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07CD043C05C;
	Wed, 21 Jan 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uLwtJDHw"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F4D42981F;
	Wed, 21 Jan 2026 21:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030072; cv=fail; b=ufdpk0DCbGNAl649+0/BfbDVo+b0cWLL4FdZ/+kuDlBlg2M381/C25Cg2I1DYn3ScxoeMtSTz/uGpJNyosPaBA1oJO2xgLOdHfruCPxQ1HNEksvQfML+pk8vqMmjWpNml3E8cleUVXXTlikRcmp6aWUPHIbPRgnHY8R0YgB9DGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030072; c=relaxed/simple;
	bh=PgHKmuMwt+Y+Mlj8hjAqMjZpHkoYPZpHwXeCvJqrTQo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UuT2asRp6Hb7ymqZb5Ep+ykaIs662BtzgVjCvIP1zgYc8KM/IxfJUoDaUTLdrvSxPDbDdiv6M6CMhQW0lIvgUQAsEJrBIDhfG6FTZriv9jzqnTxstIvHzEpGoR/dxhuC6kvbRpfsCf/1CwAMTDvFuUklU8+/Y34RtaNNDUh0LTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uLwtJDHw; arc=fail smtp.client-ip=52.101.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YY9PJoTC4A69Qnuv3nCt9dYD+0ZIl3Mp+B1um5csZ7aKQBrP+n0Fuwoq8JUkPc6S2ASWU60tIm4zRCD0y9prYspNAdauklLeJl46P/PweUU5Z3duE0E4KyL4y82rRjsaO+cRJFCGTqnjs2TdUu04Fp4xHlKdQd+mnhShAeV8cm45V6gn5lYQNFu4+p3ly74GjuVbHBsgAczIkGj0v7nv1Kd4LnhoQNp/NbcudIXYxcYmk7gsxjqSE99EW5Fa4rVEA0VvXqCbLkF1tehRdX+KuHT5nWMkltKNA+E+hyep/JcpIV96rkH9w+EW6s+aF+vE/AylkdP8ljrez4Fb1DRzwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drOkolsyZ4dJEEQe+0KW7qcNf6Mf95gudj4fYUzDYLU=;
 b=NhE2dYQq+Qnsus1UiBf8t2W9hh1shqtIzGe7xmpwIUQyLys2AE7yqSIxtHGcF0+enX/ORMMkpQBwqQLdEJFTWNx9fyU+7iNP0h8PTRnKV065MLpfOTUQU8E5CnpHT4X3oSlY3WmiHOwrYcy9RZE+NTruigOhaDAd0PtmeIAgUyB0HlESE0Ni/CCWqdYxz7xR7yfqrfrzmS6b3gn1rUTHkZ4e7ccAgoGUR3kq2TSuIgen3csvKlKDLQGFIEYnVCpqiYvTKW9MOsbpRVV8pV3RcaUXlc/uUc8suWFrlnVARkdx2U+MRwJNhQPCsEM/UWdQOJiGtGmeif/eqZNqaW+cSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drOkolsyZ4dJEEQe+0KW7qcNf6Mf95gudj4fYUzDYLU=;
 b=uLwtJDHwKPyXIfzB0riu198NfT0s9tuQBx9uOeOecYZdTDBtlKZNSnwIVKhm7buawcf7GRqrfyQJVUquLH4JwfJyr6TkPjoJofvNTv2ljfYT4TnPrJkbjodrRFhUX6gDoRWuseo4jCf+EA3K8xCQWpT/96bqzMZzYKq+y/LXbeU=
Received: from BYAPR05CA0072.namprd05.prod.outlook.com (2603:10b6:a03:74::49)
 by CH0PR12MB8506.namprd12.prod.outlook.com (2603:10b6:610:18a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 21:14:24 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:74:cafe::24) by BYAPR05CA0072.outlook.office365.com
 (2603:10b6:a03:74::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Wed,
 21 Jan 2026 21:14:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:14:20 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:14:15 -0600
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
Subject: [RFC PATCH 09/19] x86/resctrl: Add plza_capable in rdt_resource data structure
Date: Wed, 21 Jan 2026 15:12:47 -0600
Message-ID: <7b7507eac245988473e7b769a559bd193321e046.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|CH0PR12MB8506:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c80da5f-9d8f-4210-9a12-08de59320b5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8bHj3o1YgNWnQgdEPFebdqpmKzvk8TjQ8EQQ1XnJDGVA/n4/kqZtBYZyBw06?=
 =?us-ascii?Q?ESXmQJtHQrY3oiCPLNfbU8K9DRIoXjNww9rFRn4yG7I5Xb85sGE2jFcjeLaw?=
 =?us-ascii?Q?RVQnH8+eRORYFlJjaw3VLGwG9zb3x99fle5BZoZHKGQPRRMq1KKFo0LfouQz?=
 =?us-ascii?Q?jqYgdQGDohUKUuMgONRXcJptvqk3b/DMi2wSGLxCWapa5XN6ThzDMe2vo77p?=
 =?us-ascii?Q?Am/9jFEaYsugZyRKzmR/r3emm2sgtWqUwUhs0acVV9VRkf7+3hf0Ylr3jWhm?=
 =?us-ascii?Q?j9dZsb1n/4qyMxL1QSD8LAvJrouRS/FDBK19KS3M5/NsPwCnR7x26HaVJs5+?=
 =?us-ascii?Q?hhWQjrwx76Ko3WKZx9WXXnqoscuLDikVZ9uYgLaMknquJJVkGPTVPnNzaI37?=
 =?us-ascii?Q?emJka8Sf9588og/X09XQOXJc5rpeUtdcewlK53ZScMoDWg9dFi4xWl3qQYxi?=
 =?us-ascii?Q?yKbHrpg0QE4iy55hRWoChGgC09YrXg6+cqqaE4D751TqR7yXYoih/SV43jzd?=
 =?us-ascii?Q?ubeVWr4TFfWSGeFp5uyrF2mUAzyEe1E9eudLqED6zzMQZXQMfvPPOQY0wPeG?=
 =?us-ascii?Q?2Q9s1atHIb9WdE8kbAxNgbzs5bXOKDgfGvKZFHBvO7lTkO5nJ3RboPR5Qw/U?=
 =?us-ascii?Q?BBL4PHInNCZ6tQpeqvW/V82x942LCE0gUzcD2KziY90wlwDBhTGlbiBIV7qa?=
 =?us-ascii?Q?Hk8J2kEaJ/VFiVPXamnQ2ZUBkseyht1cXl64MYLpBBNDZvRzvx+6gpy6hfdc?=
 =?us-ascii?Q?GW9KNlkoVWRgz9AlJyPLb19tQjrTKtGpudmxybz+al0HzVKfHwXkYBb0isgd?=
 =?us-ascii?Q?//PBCkr+F2ev2crVHIHrDf3QxvtYYfQyKwK+R4JPxcDmT6mv+wHuMQtQLJhf?=
 =?us-ascii?Q?fxCvSFhQ9gWpHQfjqKRo1B7lux0Q9Vp3VEbJyPbCP6FxEKTCDCG8BteAFFSY?=
 =?us-ascii?Q?q179TyWME2n3ZUuPq2tzz2aIkU9Ahx18vaBP/q98pmxC+TqX6bU85r5uf2LP?=
 =?us-ascii?Q?ZlMf82IoPb1N3uo6WP5aZ9dllKfOW2kyJ8zyDfeI/QBByunrhFtR89bOHXrO?=
 =?us-ascii?Q?+wP/mpMc4Ez6HKPF/IRvrYjKGUvx70NHRXQzXQxHFtQELgF+z6RJ9t8NAmT3?=
 =?us-ascii?Q?d140Vr/j2uxaR59cRq6Vtdv+gkBjamQCkjCNxzfQTP/J053h7FqkjNqInpaw?=
 =?us-ascii?Q?9bc/dL1rXYsYRtZzKA5N1g48Wu071bw9140qtJLwfGdNsPEwe1VLMcPgrehn?=
 =?us-ascii?Q?xW9fElhALe5F9Ugvl04sVccpV3cCG5ZBrpOo8eBpyx69CPz/9kKUDmZXl9rq?=
 =?us-ascii?Q?CavVhtfxcUgrySHc3+jnKH0OUCAkprBGjtBZHMvukDCI5SzGXXpzKfknnxWt?=
 =?us-ascii?Q?a8yctVtWQWh1fZ/7gB/EFjr5zBEAqts3eZ/yw1L5yCWA64uAFU8ZDgMcxg1J?=
 =?us-ascii?Q?wa6MWUprCE07aBYRbjDmLKFjPK5XPR70gbkCtXmBtmjOsnmikKPyt3NjpDXC?=
 =?us-ascii?Q?tXUkV6qpL8E6IK3Psx+SuyTdUZx1jBBZCoq169Shk19QFaZzQYe/pOgPtLhr?=
 =?us-ascii?Q?OmKmUUUeHTYo2zGrRZvk7UXVEgrTvtSRAueFS5rQvxKjuSH7/rqZEih9WjOl?=
 =?us-ascii?Q?W2vYiAecCQCNpBEhIrN8XgbMSSnfUl0vmNlwMh1nPpaNhoErKpO/izVqYXWR?=
 =?us-ascii?Q?g60Rsx/xhd6zWio6/+qGONLOnF4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:14:20.5961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c80da5f-9d8f-4210-9a12-08de59320b5c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8506
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
	TAGGED_FROM(0.00)[bounces-68789-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 172D65E1A5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add plza_capable field to the rdt_resource structure to indicate whether
Privilege Level Zero Association (PLZA) is supported for that resource
type.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kernel/cpu/resctrl/core.c     | 6 ++++++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 5 +++++
 include/linux/resctrl.h                | 3 +++
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 2de3140dd6d1..e41fe5fa3f30 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -295,6 +295,9 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 
 	r->alloc_capable = true;
 
+	if (rdt_cpu_has(X86_FEATURE_PLZA))
+		r->plza_capable = true;
+
 	return true;
 }
 
@@ -314,6 +317,9 @@ static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
 		r->cache.arch_has_sparse_bitmasks = ecx.split.noncont;
 	r->alloc_capable = true;
+
+	if (rdt_cpu_has(X86_FEATURE_PLZA))
+		r->plza_capable = true;
 }
 
 static void rdt_get_cdp_config(int level)
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 885026468440..540e1e719d7f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -229,6 +229,11 @@ bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
 	return rdt_resources_all[l].cdp_enabled;
 }
 
+bool resctrl_arch_get_plza_capable(enum resctrl_res_level l)
+{
+	return rdt_resources_all[l].r_resctrl.plza_capable;
+}
+
 void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 63d74c0dbb8f..ae252a0e6d92 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -319,6 +319,7 @@ struct resctrl_mon {
  * @name:		Name to use in "schemata" file.
  * @schema_fmt:		Which format string and parser is used for this schema.
  * @cdp_capable:	Is the CDP feature available on this resource
+ * @plza_capable:	Is Privilege Level Zero Association capable?
  */
 struct rdt_resource {
 	int			rid;
@@ -334,6 +335,7 @@ struct rdt_resource {
 	char			*name;
 	enum resctrl_schema_fmt	schema_fmt;
 	bool			cdp_capable;
+	bool			plza_capable;
 };
 
 /*
@@ -481,6 +483,7 @@ static inline u32 resctrl_get_config_index(u32 closid,
 
 bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l);
 int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
+bool resctrl_arch_get_plza_capable(enum resctrl_res_level l);
 
 /**
  * resctrl_arch_mbm_cntr_assign_enabled() - Check if MBM counter assignment
-- 
2.34.1



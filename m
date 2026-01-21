Return-Path: <kvm+bounces-68793-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOZXFNJJcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68793-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:49:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FCC85E44E
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DD2B580C54D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080E342B741;
	Wed, 21 Jan 2026 21:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OzJk1LfN"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26808329C6B;
	Wed, 21 Jan 2026 21:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030107; cv=fail; b=uWNIpi+BIN582lj1mguYTO21BMfb10QBfg40heC9u2D9jtY1rvvd/pDAP86imyLoWjt5VazdDhvRxDN3fVMYs6nmodwOVQjOV6F1xryTxLeDReEUgQUgKhl4kVn+6w0x9Nr086zBBKvxiENyG+3kdbAkEdlFOTKiZ4XjKAXIW7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030107; c=relaxed/simple;
	bh=oZ7xA6sc2cisryQ7y+JtO+Z5wZ9Xn8KqG892Zq7Pm1E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYn0iJn5BOx+1peHnzNkrfc+nfvJ3THjUi9rot6kVcULBqFuglDvxaAaeNuBI+7+5GUSrhAzwWRffVRikUOuFfK71Ai8VCXupQ4/KhV9MBSzhvFr0Bnw5O2cSJMA5RPqeF+qM1lEK706/BYRlfxzkmEbT38OJHan2+sFezG4UiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OzJk1LfN; arc=fail smtp.client-ip=52.101.193.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ebBJLFHbG85ZrugWL+TEiKFWHan1WCGSEHap2wVqXtMyHzgAsF+qcsxgmd6sSZ23QTTO5EPcYO0dsLqoPC3+bNnZtI3vK/UmtOzaTuvlSGksW/ZIG27WbmBoBVlBYep35v7dSo5zqljp0+Kldm1fKFWus+s66I30Cb2o0inDWOQqf6TAe+CwHaWJ28a2kBrHRX+vgKa/MtQI86WWaRDJAKvE/lageOCKnyxuZvYopfBqN/mkpihX/1kXZIaTiyFYK6PvhSdpBexUif3kMZvL92ltVj2H8OlPwhRl2zx6Ltg7E+txh3BwOZWFChLdAVrazI1z9HI6CEWtNRDEaAMFQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PC7edQFe39USyvVGw3hUVGB69g3g2zI7YfRZB+iWxc=;
 b=Y5O0BTwRHZn20w4KsZt3KAJ7Z44Q/SdDGhJS7hgZoOuRvUgCa7iNu9c3Zb2yR1qSDQtJHsFol/NX132wBTq/92kzmdpMXbC9+MPQm3IrlY5e/TICkM2qJz7LMDuWA2k5dyKMylA68v9iYfisF1l9wLoVVCoTcUGqFL9TMOifXs+NfnjIS/IovG9Y0iWXWjMVlHEmI11adEQZmAn3ReMdU2MQzV2HpIMWLSHfF+R8TftL6PlzTOZwA4vncQb3IRVe9WDhr2jKlq0OF238Ci9OY9HPbxHstJai6FkgHZrzz+7N8uB0lrj7Q7m0Fud7GovCQU0QiHkTW/cZerbYlgPoFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PC7edQFe39USyvVGw3hUVGB69g3g2zI7YfRZB+iWxc=;
 b=OzJk1LfN/MkYnSwFkXWvg1gc2zDKPEkjlYK9nH3OH4BmTwjBon/8NeOtQlP64ii7lZSUzSg9N1J/0SzzZxfrvj4QkkC1dxKJ82qbA1boijmS4xVKY8c3eM465GGA1+EA3CX5MaPoAoSHtTFN62WkIWvxDYtvCvucpM8IIYpeqtg=
Received: from BY1P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::13)
 by BY5PR12MB4099.namprd12.prod.outlook.com (2603:10b6:a03:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:14:55 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::83) by BY1P220CA0007.outlook.office365.com
 (2603:10b6:a03:59d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Wed,
 21 Jan 2026 21:15:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:14:55 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:14:47 -0600
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
Subject: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and context switch handling
Date: Wed, 21 Jan 2026 15:12:51 -0600
Message-ID: <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|BY5PR12MB4099:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d68424-17d0-4831-6bf0-08de59322030
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BHkjhDef0RJSBHghdJHiVyi9gM/IvfP8xggq9zt6QfFD/2TESeyCjLJJawLw?=
 =?us-ascii?Q?YEQYtAURtNvW+JHDqsfOWPC64CFXH4dVQf3j3pCaU7IxY2GVC01y5vWgyTVE?=
 =?us-ascii?Q?MFgsNn0Md+659bUjD1/QZuA2LhJpfrxHL2FDJWVsWUS2BtP5nGbzZhwB3Iko?=
 =?us-ascii?Q?HlZKR1xX8TEKnOhnAe+y/9ldz8JjSL/oedTSohoOPzT7he7c0hgWgDuSD0J2?=
 =?us-ascii?Q?MAfhsJ3SNFT4j01lh5lY429GWdMFeAIs1MHjFKdlRUJ2KTrAaxS42wxA6vQH?=
 =?us-ascii?Q?tBdBAZHPaLymfznP27SCtrdFPdPNg83XCx1qyrZRIRt/8taYZDPkdHG5lm3d?=
 =?us-ascii?Q?tVJmKLpnkmp2D3w3oQfGZDk6ph/rbSJoy/cWp+mtOCmNkwq5BloMrhMUiHor?=
 =?us-ascii?Q?Ugz2NZoSuTxsURtErjtT6mVJQjk80n4DTGQavwADmNaq5Nytg4u26lYWxv1g?=
 =?us-ascii?Q?QSs2LJm+Ps67/ukLHX/coUnitpTkSDHg1Mdkoh5FxmHP4wRCL4XViTh+cKM8?=
 =?us-ascii?Q?9tC0Kr4ZvPrV8m4UAF4u03SaKAQ4wYeeMLhIgY8ujIt3Y+yaDikhAIxvtANv?=
 =?us-ascii?Q?yhe/kcyjLFrly1hD+ehd3RQPIx3zuC7ltRBRAa6qGiqL5aJq5DCZfaGqidKr?=
 =?us-ascii?Q?I5Wxb2AiUxSSD0fujZV++mqi6/RSgN10F3LTmKR3V53ojFwJx+TJFZLGVOBS?=
 =?us-ascii?Q?k9qii2tjFUc+CoZ0DHgeywf1XMzlZb0ZjTQk8YLXfyKdVqVL7IiFRrjF2YCy?=
 =?us-ascii?Q?FpSlLnZ9SoR7E49+Zdj+0p+/ln3OY64QrnFU2OnwDDaibpBPdIihTESA8/Ci?=
 =?us-ascii?Q?gVchuJkwk64v2UYWHo6kk2T/0q5Z7ztcKfTKjlvoTZj/ierdnKPThPmyE47Z?=
 =?us-ascii?Q?+msjO1VoIZKgXiyVwM/WHFT9n+NM/UT3Esfy950r3m+oRmv4YzK3t+26fiMy?=
 =?us-ascii?Q?GN5hjoKt5hDmzCGjWn15o52RggK4ZB1XCWi8mUKc2SCAoL5hhNVqiah07EXA?=
 =?us-ascii?Q?/kBgnpBlW75aj1AmIyRzYWvJfqEBfZpZrGkCk46cXLNXsBmKA+anj7XBivIh?=
 =?us-ascii?Q?LM/wdMIx8N/uGN2cGDdU25JoXBy/cTvO17crfJNnOkZt/sEyXodbNsrsb9Pr?=
 =?us-ascii?Q?x20/9HLCTzHEaqo3eOJJjmDDsgsM8jG44L55uTYf0955u072jtr6qrT9aa+I?=
 =?us-ascii?Q?TSCi99QOFN5u7kJdLLJsP8SsJuAe4RgTIOOl1rJkLXujG+448l08ggoh1aDa?=
 =?us-ascii?Q?k3QoZ1Vd5mFX4DC8WxTDUAg3xORhazc5Z4Lu1Aylocf3cdi1tBPlu94j7rhw?=
 =?us-ascii?Q?hbG5dYTMWUE9knwaRV3r/lNuhduujF5kZhnXv1IzUINI3FyrzlS6NUiuGuhQ?=
 =?us-ascii?Q?OF0w08L85cKOrfMUtrb55xR+T5d9AGVpfian80Ewt1tWIL0neARF7aSzW/My?=
 =?us-ascii?Q?aBkKOuBd8nM7zyEwLgE5gCiX6o0kcUwfwh29cBrJEGouu0f5A9HSVYTdls1s?=
 =?us-ascii?Q?19l4IbPLaGoCLbq4ghyV3/aAqL9eYeeWB2egGTzJkRAgDoUsC/6KistYAslW?=
 =?us-ascii?Q?DsyahVWzTqF0RSTYshI8zIKjP0VyBHaZ7mYhEoQhjhzOZxMkwyKnhi61sDjq?=
 =?us-ascii?Q?3LLMqvwx0f2qSLBffl9f5Y1KxFOwmPlkbE6OjqSfmHFghDE4YblKi9pDi0MF?=
 =?us-ascii?Q?3/o+1yxQPxTXoj+LXZ5/u2FHA1g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:14:55.5382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d68424-17d0-4831-6bf0-08de59322030
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4099
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
	TAGGED_FROM(0.00)[bounces-68793-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 0FCC85E44E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The resctrl subsystem writes the task's RMID/CLOSID to IA32_PQR_ASSOC in
__resctrl_sched_in(). With PLZA support being introduced and guarded by
rdt_plza_enable_key, the kernel needs a way to track and program the PLZA
association independently of the regular RMID/CLOSID path.

Extend the per-CPU resctrl_pqr_state to track PLZA-related state, including
the current and default PLZA values along with the associated RMID and
CLOSID.

Update the resctrl scheduling-in path to program the PLZA MSR when PLZA
support is enabled. During the context switch, the task-specific PLZA
setting is applied if present; otherwise, the per-CPU default PLZA value is
used. The MSR is only written when the PLZA state changes, avoiding
unnecessary writes.

PLZA programming is guarded by a static key to ensure there is no overhead
when the feature is disabled.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/resctrl.h | 19 +++++++++++++++++++
 include/linux/sched.h          |  1 +
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index fc0a7f64649e..76de7d6051b7 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -38,6 +38,10 @@ struct resctrl_pqr_state {
 	u32			cur_closid;
 	u32			default_rmid;
 	u32			default_closid;
+	u32			cur_plza;
+	u32			default_plza;
+	u32			plza_rmid;
+	u32			plza_closid;
 };
 
 DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
@@ -115,6 +119,7 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
 	struct resctrl_pqr_state *state = this_cpu_ptr(&pqr_state);
 	u32 closid = READ_ONCE(state->default_closid);
 	u32 rmid = READ_ONCE(state->default_rmid);
+	u32 plza = READ_ONCE(state->default_plza);
 	u32 tmp;
 
 	/*
@@ -138,6 +143,20 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
 		state->cur_rmid = rmid;
 		wrmsr(MSR_IA32_PQR_ASSOC, rmid, closid);
 	}
+
+	if (static_branch_likely(&rdt_plza_enable_key)) {
+		tmp = READ_ONCE(tsk->plza);
+		if (tmp)
+			plza = tmp;
+
+		if (plza != state->cur_plza) {
+			state->cur_plza = plza;
+			wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
+			      RMID_EN | state->plza_rmid,
+			      (plza ? PLZA_EN : 0) | CLOSID_EN | state->plza_closid);
+		}
+	}
+
 }
 
 static inline unsigned int resctrl_arch_round_mon_val(unsigned int val)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8f3a60f13393..d573163865ae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1326,6 +1326,7 @@ struct task_struct {
 #ifdef CONFIG_X86_CPU_RESCTRL
 	u32				closid;
 	u32				rmid;
+	u32				plza;
 #endif
 #ifdef CONFIG_FUTEX
 	struct robust_list_head __user	*robust_list;
-- 
2.34.1



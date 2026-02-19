Return-Path: <kvm+bounces-71329-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEd1JQ6jlmk7iQIAu9opvQ
	(envelope-from <kvm+bounces-71329-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:43:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0373A15C28A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3F332301706F
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8EB2C3261;
	Thu, 19 Feb 2026 05:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Wqc+xf5t"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010036.outbound.protection.outlook.com [52.101.201.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A762848AF
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771479818; cv=fail; b=Z6GGV6ywCRzDBHNq52K/OInZzvr1abaaC710dRKClH9wjgADIYLiFjaU7Vz/7NjIEtBl3dgZP07arTRdZQMXDNjGmrHJdp+wwj7oL3NMFLuGyD2GBtv1wKRZXKWFvBWXedKOnUeX4IiMc9Xc8DN0CzSy9QR0XhwGDad/UIexZSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771479818; c=relaxed/simple;
	bh=HcLqGSOeh74Tp6YMTyEqSVUPzrIrCvnbx1dtSbjRVjE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZxG6ipX7/hJp09bLYGtqekw0SxInYpksdXNOXFK1D4dW8bCv0ZnBJd4RqLt6o0S6VGRN50xsURBRs+D2JNLeGugNUhaWm5xuP0sw/abJ1JVzTqhvIP1sDOaZQGo0IuHMJP3GJDLP5qNvaixjH5HgwCN8Qki6ccXbWF6+lwVlFIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Wqc+xf5t; arc=fail smtp.client-ip=52.101.201.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CuuNhIJLWHJsy3f0tJW7x3m5tou1BbEv6lFh2xbGc/fs2UZydcxk04RdADRAUUN0CBMEYKGpe5hE2yvIr89IN8+uFw7YQhbp5/D47lt1IbY14V78Qe8E5kzIyuWQmv+ue3tZM9Cq6Apirlr+6PAFCQHKQ7+U9NRF57/v3vscCPE4CSq0pAQE4hAarnn1Zdo6Li9SFNeC852qjg+nZ0G9/qIsB23uHn1VbcUYd61ROVruFfS2kTPNaddGixdOSeOZXss1GYX0R0LrLeeXCTLVaNnkop6POI6bMeXrm0XJjA34iJRc0oKBPTa9kLvJHInLk043Gft/+WkchQ0nsseWew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H26O9oOQbFO4kCaf/400R1csmdkmHx2ST0gLcTC+ilE=;
 b=i4XSoUeX7J02HojQ/I0JNprmGI0xAwtzqK+mza7r6xJWOV6wwaeq5LP4YrYZJ/V0Pa3TVUuQoIiNQwb4LmgoDK/dFIf4dUw0U0+pkbWRTudxgacWyMCSMwz760LL9tfzqxIMaGJ6J9HNKfLpbyDkVz4q0r6xa1sgnU0wrAIvo+OzoNfL7EaAKINuv1ir5ULe/m1iiW/9Htc4mg8YQ9QKi0nqglRjDGGDICemreUvLI51cdwf/sYKYZVeCP132jGNx4FIxs7TnPpRk+AitYXR2qwvmFUbDVTpe2osBB68spOI9nUJuFxJPbSJiRahiuuieW2yhxay2O/3GWsTg9GEYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H26O9oOQbFO4kCaf/400R1csmdkmHx2ST0gLcTC+ilE=;
 b=Wqc+xf5tLDrpkt8fdxeHymKSYMWWI9970a6/v/3qWF/MLRmJQvjNuXkpCQFrNdQtAwC+ShzHirO3cFj/OpDu1bKVAK12SDeif3+EFgPByHuCyuKG8b/LNu2GPCw1Zce3sVc0do6CBI8/ruVZI2pD6pMJEIjBKy/i9VeAL+oNbqo=
Received: from SJ0PR13CA0112.namprd13.prod.outlook.com (2603:10b6:a03:2c5::27)
 by SN7PR12MB7980.namprd12.prod.outlook.com (2603:10b6:806:341::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 05:43:33 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::29) by SJ0PR13CA0112.outlook.office365.com
 (2603:10b6:a03:2c5::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.15 via Frontend Transport; Thu,
 19 Feb 2026 05:43:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:43:33 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:43:29 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <qemu-devel@nongnu.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	<kvm@vger.kernel.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Marcelo Tosatti" <mtosatti@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Richard Henderson <richard.henderson@linaro.org>, Naveen
 N Rao <naveen@kernel.org>, Nikunj Dadhaniya <nikunj@amd.com>,
	<manali.shukla@amd.com>
Subject: [PATCH v1 4/8] i386/kvm: Add extended APIC state to APICCommonState
Date: Thu, 19 Feb 2026 05:42:03 +0000
Message-ID: <20260219054207.471303-5-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260219054207.471303-1-manali.shukla@amd.com>
References: <20260219054207.471303-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|SN7PR12MB7980:EE_
X-MS-Office365-Filtering-Correlation-Id: 99b1f9a2-f1db-4120-99cf-08de6f79d209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kLe+pUJi/o8VvMdbR/5+A9KDtfLV8foAEEpv3PLhsJhMh8s6f2uRoETJCu0e?=
 =?us-ascii?Q?FuseKKo0tfGD3HFxEl1XNEwh9o46YGR+4tMsqy358PXDXf/lOk41j1JuNbmD?=
 =?us-ascii?Q?ZM1KFdeRArvdIIiVvMZJEidEhalmZApfsTAVYVt6ajBJ15fbqSZo/g5HiYht?=
 =?us-ascii?Q?D5YUtDmvipMeIhw3AI4nKOc/WtMkdOCwn1DEtuL/191Xs6l5H8ge3epkDWF+?=
 =?us-ascii?Q?7sZJ5Nr3PTPuvPBTuqleMl/aI473PEZkgFCW54dICQcmyBPxBV/VFxmMakv9?=
 =?us-ascii?Q?BK3KJvATX+cZGGDaHRQAU6mmoSrGAH3i9Ri1WQHaPWQm8moMiucQ2Ak1XdQb?=
 =?us-ascii?Q?UOLRNeIvbzkdER7m9EmFiqTAJreh0vSbJCiH72GVeUc+V0MNlFnNGvJIceGs?=
 =?us-ascii?Q?H6tPClEoBO/i06txuJpD+jMqgLsHoNOi+uJNQnS0j43/St8mGQ+nOjqMEoVS?=
 =?us-ascii?Q?79yE9n8ykLN0Vfi+f90UDe4A1QjvaZUyZqYmWi8R873wYU+ghyD0CxnGkwr0?=
 =?us-ascii?Q?1DiOgrYPJQcx59PzrQCcl9GRJ67TjvS4xu3yWOqbduJyhuaP2W++TrdbfomH?=
 =?us-ascii?Q?De57ARApdjolkTB23v1jE+rFjhdc/BWyLGJd4lPiEydGm+Ew8ng0aA4O4Fsl?=
 =?us-ascii?Q?mcYM+Jg+ShYYT+PRzyTcNF0C95M1CI+/MzHMenCD5nQ1pb3VXsQOX5Ln2yMw?=
 =?us-ascii?Q?e42bebvAizXFCCLDBUd1+wxJEL0bZaYcsi3SQz0BYrWjvEWfrrJdu1sSZLH0?=
 =?us-ascii?Q?iJN6viaqF8KQN7l3Gw2363wCh2fdcXlKdgz2jE/HweMAHCS97O00SIyqD2ku?=
 =?us-ascii?Q?lReN1lhWh3rH0nuCZTTx7Rz9CRn2LQGsNCDxOKg7Eft+56vCiSNdmN0rNutl?=
 =?us-ascii?Q?dDxFXcK4rVmrdYDEn72DeCj88zc+oxt/sNn7Te+8gq0MZIbWKWJ5ixCIuo0Y?=
 =?us-ascii?Q?4b+yXvNPC8wbHEVhmBFDgSqTZpllfKdiABLZfS+85msTEagGHQ63DQlDywt4?=
 =?us-ascii?Q?EIqv+OnEPQGD1PKsCRYFFBU+6ar2KY5s0GixnCZdaqf7OCtbPxu+FgbvfdQW?=
 =?us-ascii?Q?0UrfO123d/ZImESc2UBXdgr6xUgX+K/w8KbhHoNrcbpS3tqCVGkk/nNmVvpR?=
 =?us-ascii?Q?ebas+ETCJiILq2S8jqu9dWPXGp9Wly59lSFqrziqy6syE/57CIonavCvJbFV?=
 =?us-ascii?Q?mypawYNVyfwwVJUrilryHDfCbsyHiT/HQBf8LEzaXOFty7rYwD4/IQWw4r+3?=
 =?us-ascii?Q?qOQm5o5kmzqNOoaepqyM95LjWHnXVZ3rdKdoLnPAHkP8+C8m6uWNSg2GqtCQ?=
 =?us-ascii?Q?ALviFWBh9/Kyk98i2bPc/RP2NYwYH/z2Rh6uIDoPtgpQknazCEy3KLNIA7pt?=
 =?us-ascii?Q?EKXYz8qyzPfAYgTev1FKej7M0HqU/VhuJ/42EkIJupS2SnWxyKfKH+2UBbJT?=
 =?us-ascii?Q?66tYWbrryjBPHpZEc8e+MLlmUKhNoa4Csu8pHjVZ0JyFDbKcYv3jeNSALiA9?=
 =?us-ascii?Q?Y9E+gqQqBECYrGFyNcdOQr72S38oqGBBoCdnwcN4jY5zEVubR9OZI4Hf25vG?=
 =?us-ascii?Q?SAXrTdAiJzUFsqtsCbxnIr9fqdwCNe3Fvyl2S6U+4TL2+SVJSvSRK29OlT8l?=
 =?us-ascii?Q?a8T101qJhWTzmFUaKQpdTTA2FtgiHak/v5X6ahcOJMA54LvzA7BbZJ7IrKQU?=
 =?us-ascii?Q?mEo+YQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/HmS3XY3lLolHijiYjkwME/SA+rV5utmIdOOl/0oUNuQ0FVVp+DxR2WEQBEgbQqW7SD1H042ZuOhzWdB8cN0+AsufffiVuAJMF40m0LuCAFuLj+kooiFVhArDatbqgvZHxWO0LDAVChyy1Q5ahHGb2kBALJocvgLh7V+hVJDFQXknzxRWd3mPnSLkr8G8tJ2aLo3L13m7MbcbGIwR0GHTkIhKrpluvzg5C7KgVmY7RNbb4VTzTpuN4dHOcq3zxNTbW5JHQxwz9HD6S91bYT6DrFVgfeisaBjHKHvNHkm76FQ1uK9Bb2+PlgGrmH0CdFowhotLf1gf4z2sRcezpVIyRtcCdAZAfVABiTl2jw5O8BHcHucGkTc8AzYQHyLUCFIOOhdPrIGgai3ao4PVTDZe/76GO4CG00Ali7GcPefWvbwAyISo2tyezPCgasAqSeE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:43:33.7494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b1f9a2-f1db-4120-99cf-08de6f79d209
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7980
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,vger.kernel.org,gmail.com,google.com,linaro.org,kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71329-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0373A15C28A
X-Rspamd-Action: no action

Add extended LAPIC state fields to APICCommonState to support AMD's
extended APIC registers:

- efeat: Extended Features register
- ectrl: Extended Control register
- extlvt: Array of extended interrupt LVT registers
- nr_extlvt: Number of extended LVT entries

These fields store the state of AMD's extended APIC registers which
provide additional extended local interrupt vectors beyond the standard
APIC LVT entries.

Add kvm_initialize_extlvt() and kvm_uninitialize_extlvt() to manage
the lifecycle of extended LVT registers. Dynamically allocate and free
the array in APICCommonState based on nr_extlvt supported.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 hw/i386/kvm/apic.c              | 21 +++++++++++++++++++++
 include/hw/i386/apic_internal.h |  4 ++++
 target/i386/kvm/kvm_i386.h      |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 9489614bca..7bec7909e9 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -135,6 +135,27 @@ static void kvm_apic_vapic_base_update(APICCommonState *s)
     }
 }
 
+void kvm_initialize_extlvt(X86CPU *cpu, uint32_t nr_extlvt)
+{
+    APICCommonState *s;
+    s = APIC_COMMON(cpu->apic_state);
+
+    s->nr_extlvt = nr_extlvt;
+    s->extlvt = g_malloc0(nr_extlvt * sizeof(uint32_t));
+}
+
+void kvm_uninitialize_extlvt(X86CPU *cpu)
+{
+    APICCommonState *s;
+    s = APIC_COMMON(cpu->apic_state);
+
+    if (s->extlvt) {
+        g_free(s->extlvt);
+        s->extlvt = NULL;
+        s->nr_extlvt = 0;
+    }
+}
+
 static void kvm_apic_put(CPUState *cs, run_on_cpu_data data)
 {
     APICCommonState *s = data.host_ptr;
diff --git a/include/hw/i386/apic_internal.h b/include/hw/i386/apic_internal.h
index 865b7ed567..e84cbed7f6 100644
--- a/include/hw/i386/apic_internal.h
+++ b/include/hw/i386/apic_internal.h
@@ -174,7 +174,11 @@ struct APICCommonState {
     uint32_t lvt[APIC_LVT_NB];
     uint32_t esr; /* error register */
     uint32_t icr[2];
+    uint32_t efeat;
+    uint32_t ectrl;
+    uint32_t *extlvt;
 
+    uint32_t nr_extlvt;
     uint32_t divide_conf;
     int count_shift;
     uint32_t initial_count;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 00f8ae0ee4..338433eb52 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -73,6 +73,8 @@ struct kvm_cpuid_entry2 *cpuid_find_entry(struct kvm_cpuid2 *cpuid,
 uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg);
 uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
                              uint32_t cpuid_i);
+void kvm_initialize_extlvt(X86CPU *cpu, uint32_t nr_extlvt);
+void kvm_uninitialize_extlvt(X86CPU *cpu);
 #endif /* CONFIG_KVM */
 
 void kvm_pc_setup_irq_routing(bool pci_enabled);
-- 
2.43.0



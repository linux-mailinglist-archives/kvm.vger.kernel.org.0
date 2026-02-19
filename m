Return-Path: <kvm+bounces-71330-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOnzADajlmk7iQIAu9opvQ
	(envelope-from <kvm+bounces-71330-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:44:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C4B15C29F
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3994A304B4DC
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71522848AF;
	Thu, 19 Feb 2026 05:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HutOtLXZ"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A4429CB24
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771479822; cv=fail; b=B+1o6/kdOobmrxO6zYuBkfZ3QstTnEGAoWSYIWBBniPEBXbLmsvf2zLlxLVFdzxYKqd0zT7WKsGMgnfNOv1k399awjnQdbIMNEOtRqtMYyyfU7tuhMF3RSxtvCudzeg8qmxd7DJVzAtI7YSCafhy01TEW7R6Hr4kvWNreRQznns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771479822; c=relaxed/simple;
	bh=Y2SkAg8FsoO0X6A6Q/CUHUVuZwOHb1ILyyrnuf4g8Vc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iqIftGbW5MKnETKGJUvCa8ASjXixWruXr0ZZ4NRynTlm/b1QpJbGiIa3kOHxm3cdpTlllrRWAYMURWK6/Lr0oMeqBBG2Zd6Unx9cMJgkZ6tDbYpN+tNX9NO1MMKrzAis+cblSxkaq5OYefmh+Gb4nak0rH1WguIYM/wLTNhbUp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HutOtLXZ; arc=fail smtp.client-ip=40.93.195.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wgJC3bO7chg5SDF4JQxVzd27Jn3FF73Z6z/JWnR9DuMFPKkxsJpo8FMhb8VbDiZ75Gt1LylmsUuYRmq8BbaTxmIBx9Cps+h8mrILBcmy851aTvPWSaUojf+uQvQ0NJC+1b02eF9XujxJeCnt1plKhu6FTwFkplXiKfLAOVyRgjtnbYeMSqI8W6sx+rsx4bzMOvg5/yYQW6YNVmLwcGfKYrOoO5w/0enRkv4ozBPAS3lUQA602CzOyDPaIqhb/yPfBU1doUgfiBoSAhFr24DAHXuHSMrQwb6GhollLpPn9AA9tdjJTVSjd2AgZXLqYg0/z0nAOZ/HwmgImsFP4X7XkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVaeOsMTf2qFffutIlkHnH6jX3KJxkPdN0qcWyPMKIQ=;
 b=HCxXc5N414PvnrWJTIMSyIcRFKcKIdG/VTcUIvsiz3aGd3bFXnFJ7n1mtxF82MK1W62d3GQPt03GyU5u8gTdj/QyyAZDKHq2Mewz6txK89fs3bKy3YkXi39fYYeMKCfG+eUm4bQvrSNs+yOCl2QQrU352zzZX/Zs9I3CjqZoTOPOCFxrsltRRtEUcKhyXRlaMAFhzwelFTQ81GEMHKGX718KurLuJE2eQmNYVHNqXj+Sn5Aq8t1Z/ObD0dxEyBnyeX1iaQB3XoK82D5XzS6vvyktTnfgzY/G8p3jzUhuHkx4xgyBWuHqrjllwWCH4smLTsF/zQoONamYonx1OaiOMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVaeOsMTf2qFffutIlkHnH6jX3KJxkPdN0qcWyPMKIQ=;
 b=HutOtLXZJJhNQ/dkVt7o8OiXz/ykz+nx5GKL9uf0BXZYGGtJyQxZ0DAD63w/mZWcLOvmoPOJQ/94GjmNh6KMxE6xDy9jwPthnLZ2ChryAApKylryG2rlrqMIotLBzHixmd9I6Mn+CfJ8dTDY/JH5IjVRFGktpZBQIPtTYg2oX5g=
Received: from SJ0PR13CA0002.namprd13.prod.outlook.com (2603:10b6:a03:2c0::7)
 by BN3PR12MB9593.namprd12.prod.outlook.com (2603:10b6:408:2cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 05:43:38 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::bc) by SJ0PR13CA0002.outlook.office365.com
 (2603:10b6:a03:2c0::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.15 via Frontend Transport; Thu,
 19 Feb 2026 05:43:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:43:37 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:43:33 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <qemu-devel@nongnu.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	<kvm@vger.kernel.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Marcelo Tosatti" <mtosatti@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Richard Henderson <richard.henderson@linaro.org>, Naveen
 N Rao <naveen@kernel.org>, Nikunj Dadhaniya <nikunj@amd.com>,
	<manali.shukla@amd.com>
Subject: [PATCH v1 5/8] i386/kvm: Add extended LAPIC capability negotiation
Date: Thu, 19 Feb 2026 05:42:04 +0000
Message-ID: <20260219054207.471303-6-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|BN3PR12MB9593:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c23b9ed-5e0b-48f9-7394-08de6f79d44a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wAVn2Q75vuEB3PfmhLT1E0Gw07ps85Dy0cor4/br+gM9GWEl0WZVzbM54QY/?=
 =?us-ascii?Q?UbjL9AR1nC/tK6l4IdtfexUBXweBoe2YVJ+9S/55fLcfC8zEGe8o8LTg/UuK?=
 =?us-ascii?Q?BWxbTMxYTBtDkRrasl+IK3eRyZ/J5LDfwZv70jqgT3zFE22PdaS1OgTDfMKY?=
 =?us-ascii?Q?us8mpbIW4qbmflLTAAhNNCQMS6yzOXMljh9PTcu8+kex07bf+X2ajPCA8aMl?=
 =?us-ascii?Q?ESMgvr+APjzBWLqHzHbsnqA68vtDOxeSYTl28F4lYG9jzvS2kchorp+9YQCi?=
 =?us-ascii?Q?Zo9Fy5CV1/0wWGQAhwlxVm+u8xZF4xq2sOlEglwO5HBq1cBMXDR7gCo3bA8c?=
 =?us-ascii?Q?3pZ1q4H/e+BquuFikhZlmr/R+U20pdLYY0N3c9JfutvWuaL6LfZjeo++Oyex?=
 =?us-ascii?Q?xYxqmHMNTs6uReRBhAK/qliQ35RXozEkJrC6zkuZbYHDiHBq0+G+G1HM9B9M?=
 =?us-ascii?Q?CuZE+Mk1xw9s1q/gS6eIYLtdHkone2nv/JTcsqpSIJdcQ07UbdXdYzUtRoyu?=
 =?us-ascii?Q?4NnJNGijFDenbhoFX1Ck+qDGb0DEmJvumAE1wpk7O3bZfU14dQLxfTpzxoWU?=
 =?us-ascii?Q?f6aA8aveXXgxXhSWlr1NGk3X/nJcwNyr9fD4Ddd1LoM1k6qc0t5XHI3Toi41?=
 =?us-ascii?Q?99wYL7sfXE96KanO+IpfBxX9M7Gzutq9CagB/GS3wJj8HLmKXL1DfMVcrOHE?=
 =?us-ascii?Q?kSw3YryuAzjPe4Manj15Ch6uEGE3xf0vMa7Csxo0sGkPVw8YevjyWFEJliiI?=
 =?us-ascii?Q?8jL0PzhjphP+diCjmEOoVcDE4oFAuP2THg5dsaQmMSTbbFM4aL+sSnQizn3P?=
 =?us-ascii?Q?f+mdr+hTsAXcUen843F6br2PnAtkapxt+zZ5fzs+aCMTY8m51rdZPHdmDAHd?=
 =?us-ascii?Q?VX1VgpN0nWmn3RPxSwFenjq6LaWUeOh0MRCp+tVM/kmBK9EJk0S+WByzl5pX?=
 =?us-ascii?Q?9vcKNE6P31FJG6sF+lJNRfENg4s1ATIBAonxuz08CwAVoJ6glbbuk7Ig/yUD?=
 =?us-ascii?Q?a0NCJQS24+5+z54XBu9INA8KKJeWrUtzEetkGMqfujzbKU0JERHzqqixjV46?=
 =?us-ascii?Q?gXImgCGK9SSXqT/5K+e32gdAIUaDWbfIbTEgaKD7Mgtssbql9U0aOMNKjLYl?=
 =?us-ascii?Q?EcZ2bQVMwPmuyEcOb4wvOKH11/7Hm0jNCwxGEvZs+E8/n0qB2nQe7eLvVsOX?=
 =?us-ascii?Q?OTwSLd0xWTLqCv9mW2QpT00MMb6o1/nNAMQudegrpMTV2NSaTluS+aISbVCx?=
 =?us-ascii?Q?1r0+bARpQ3GIG5WdNVt/Bzf49W+jWlSWju/52cZxMSmO/uPYycgL2hDhtgHd?=
 =?us-ascii?Q?T8PMQd5RlxBJl8/dPmU1pPKrLZMmEYpUbhdHaz/FypRm8mHCnQLib/+jT/zF?=
 =?us-ascii?Q?Q2+mlT1M8OCnxzRvQXXiAdtq7v9riFaMd2rPFBHBURg3QVrNWYIHtlVAhWwn?=
 =?us-ascii?Q?wuCBCel63hPj02z+sA+b/8UUDGOLB1XJJXoteEdEtnyamlmNyfFoDDPW2QZi?=
 =?us-ascii?Q?y8iJyeoDV+P79rT6mB48Qgxrc7cH7CjuexjSWffb0/sIwc8WJEeEtBGCUfEB?=
 =?us-ascii?Q?+qnnPbCwbdHGgAx1T7lJNKK1G0y1fcKJMF+01KaziJz2hon8+zY2MUuvKADE?=
 =?us-ascii?Q?iGMBRAUqmUScca3d9UyqVTH/G7pfRAfFVmdC2F6AtzajufUEOOCf2+0gc7/a?=
 =?us-ascii?Q?nF9DWw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6S5b77mU/h+jSSWI6uA0NPKWzhAzG8qArDkzQ4+0w16QKxq3YAAw9xn8y2WTDH0ASRoq1hMz8fQAjTxfEU43CTJTag4UAuFN8ETB9xa/MuRLgNKo0MP3LGdCRYKcX37EM3vLcbxnBiG+N13hyKaxEt80WlAIFYb+0YTClPGFCGJ5I3Idob+tlhGPo2d8Pjvcu8RF3uqyh0m9UginNGPGsMpkMSLL2S1uALHsfXWa/9l3nJCUeH3IR50404yKnDI15GUZOGQl0WEx7EwFsfsRw7zBgtGdhymGgsPLOt+aQ0MMH+QFpFL5PQHbijKKtSDUHr4xw7WsTjxTfzMiim2OaLtHhoJEJ3/W5+XcepMUy7LEz7/JNRnvMuQNrf91CcRMbxtJerF1NN+v0l19aOtcWBq/lWXblWN7+bsigxbjEwlzRnWRA9Som+SmulK65jmY
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:43:37.5204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c23b9ed-5e0b-48f9-7394-08de6f79d44a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9593
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,vger.kernel.org,gmail.com,google.com,linaro.org,kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71330-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 83C4B15C29F
X-Rspamd-Action: no action

Negotiate KVM_CAP_LAPIC2 during vCPU pre-creation.  Enable
KVM_LAPIC2_DEFAULT for the 4KB APIC page.  If the CPU has
ExtApicSpace (arch_has_extapic()), also enable KVM_LAPIC2_AMD_DEFAULT
and use the intersection of what host and guest support.

Use a VM-wide has_lapic2 flag so the capability is enabled once on the
first vCPU and reused for the rest.  When extended APIC is supported on
both host and guest, set has_extapic for use when syncing extended APIC
registers with KVM.  Allocate extended LVT state in
kvm_initialize_extlvt() during pre-creation and free it in
kvm_uninitialize_extlvt() on vCPU destroy.

Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 target/i386/kvm/kvm.c      | 61 +++++++++++++++++++++++++++++++++++++-
 target/i386/kvm/kvm_i386.h |  2 ++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ea22aa7180..c9f4cb6430 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -177,6 +177,8 @@ static int has_exception_payload;
 static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
+static bool has_lapic2;
+static bool has_extapic;
 
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
@@ -2064,13 +2066,69 @@ full:
     abort();
 }
 
+bool kvm_has_lapic2(void)
+{
+    return has_lapic2;
+}
+
+bool kvm_has_extapic(void)
+{
+    return has_extapic;
+}
+
+static int kvm_enable_extapic(X86CPU *cpu)
+{
+    KVMState *s = KVM_STATE(current_accel());
+    uint64_t kvm_cap, vm_cap, final_cap;
+    uint8_t nr_extlvt = 0;
+    int ret;
+
+    if (!s) {
+        error_report("KVM accelerator is not available");
+        return -ENODEV;
+    }
+
+    if (!has_lapic2) {
+        kvm_cap = kvm_check_extension(s, KVM_CAP_LAPIC2);
+        if (!kvm_cap) {
+            return 0;
+        }
+
+        vm_cap = KVM_LAPIC2_DEFAULT;
+        if (arch_has_extapic(cpu)) {
+            vm_cap |= KVM_LAPIC2_AMD_DEFAULT;
+        }
+
+        final_cap = kvm_cap & vm_cap;
+        ret = kvm_vm_enable_cap(s, KVM_CAP_LAPIC2, 0, final_cap);
+
+        if (ret < 0) {
+            error_report("kvm: Failed to enable EXTAPIC");
+            return -ENOTSUP;
+        }
+
+        has_lapic2 = true;
+        if (final_cap & KVM_LAPIC2_AMD_DEFAULT) {
+            nr_extlvt = KVM_X86_NR_EXTLVT_DEFAULT;
+            has_extapic = true;
+        }
+    }
+
+    if (nr_extlvt > 0) {
+        kvm_initialize_extlvt(cpu, nr_extlvt);
+    }
+    return 0;
+}
+
 int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
 {
     if (is_tdx_vm()) {
         return tdx_pre_create_vcpu(cpu, errp);
     }
 
-    return 0;
+    X86CPU *cs = X86_CPU(cpu);
+
+    return kvm_enable_extapic(cs);
 }
 
 int kvm_arch_init_vcpu(CPUState *cs)
@@ -2399,6 +2457,7 @@ int kvm_arch_destroy_vcpu(CPUState *cs)
     g_free(env->nested_state);
     env->nested_state = NULL;
 
+    kvm_uninitialize_extlvt(cpu);
     qemu_del_vm_change_state_handler(cpu->vmsentry);
 
     return 0;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 338433eb52..b28fed69d8 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -25,6 +25,8 @@
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
 
 bool kvm_has_smm(void);
+bool kvm_has_extapic(void);
+bool kvm_has_lapic2(void);
 bool kvm_enable_x2apic(void);
 bool kvm_hv_vpindex_settable(void);
 bool kvm_enable_hypercall(uint64_t enable_mask);
-- 
2.43.0



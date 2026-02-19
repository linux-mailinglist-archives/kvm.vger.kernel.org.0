Return-Path: <kvm+bounces-71333-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EIYuDlGjlmk7iQIAu9opvQ
	(envelope-from <kvm+bounces-71333-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:44:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD95815C2B6
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 706F43053660
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257C92C326F;
	Thu, 19 Feb 2026 05:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f9SIQ+Qy"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013060.outbound.protection.outlook.com [40.93.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E712848AF
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771479835; cv=fail; b=Gn4zI8ocwnfbXfnASdE9+UhAJGQe2pico1i/qbdF1eBMzHkxqpbvmsIMLvsRav/Po5f+lRkmK0u2h9DBQFgNobGKgfMabro/fYF44dNCGce2edJzU/cGXUzfA4mEQF/QtxGkNjO066udcmf8djsllgDDqbz4M7M3C+1GWCnmVMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771479835; c=relaxed/simple;
	bh=EDLQFEMYfbKIWyNYMTwbXgxdQ3d/jcRZ0LGOe/Xpn7A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7lWdQOkcfbmbv8M8QHiFYNIZ/tboIh25uFDRsFfuH4+vhNYcJxCzGLKz+JW18kOXxECkU9nXZtptsNvKoz/Bz0+sD3KFnZhR7wjlTD1kpkk3hMyPzqOMmbBmzgX1OhhWYHJ6Ua1UpF1My4gfZU4BPqtE2ZSK62+i5OPGp/VUMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f9SIQ+Qy; arc=fail smtp.client-ip=40.93.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CmrMzobq2pgR5dBC5c34z6sQg/aMDp5HmJB1UdRku6Fj5dE2lKTWj2ddgb7Ei3Fb3DgjJJhVn/8cB/1EVLkF/BzaAaj81DMRavYTnYXWBKAqy/DVSP7ahu3vq8ENO0ZRZSzRrrIHLxPYC8cL1/ShI376RE9N2feI8mQ4vQBi5eLLWCMoBJMsgYM0y4kIK4WHz/UfNOhbDNP8cb/Uxx5GkhLQJn51tgPFiUSye7FKSt+Cm4SSyLSrtaqsbCnsyj7khu6W5qXRBZI/zsiDQfhLUMGMh3ogznNRVFeg2IDJDfvzmZoGjpldKx4Qmy+lmP9GZ4uecQd4McB16o+JtTZ4kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cq6sDYQ2bIU8naegtNI56GdYdfjY25ij4bdD+f4fNMU=;
 b=aSGroVKuZGajddkJ5yYv5stAFtmsJW0vLSo75FA0vvTb0tK45VqPjMS9tx9jgD2eXX1U76FkVuZ2p4Sd4yEnt2aIo9iMpaCFvio2Lx7ZzbqCR/UtkUiZjXmue9eF2P+TKvCZ579WQVFIysiUQQpfnOSwROFKb+m1qgGq9Ilazy/WzVJn2E5Ztdht129efrTkbb8ehDM50reLX0jXz1NBcj2HNNjWfWUCZulf+XHejIpoBOJyIlVWIAa2lVhgw5UWUpw7CxCdOKaseMGx0XWRRW+ewqBGBqF74LvQ72E050RATo9ESkWcllPzPeUU4F3WuRW14WPmXLwRBi9RYMdSZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cq6sDYQ2bIU8naegtNI56GdYdfjY25ij4bdD+f4fNMU=;
 b=f9SIQ+QywXq2qKRuhcm5Uh+8RqNqJdPWa1IG0t3sQcvHHGioJmHUnKmC809ScNd0U40Uygq1g9e5FeAUWvwQJ4G+pYQaYgQlBk//Zjc6HCtUY9n4OfzCFUQMjgdemmSTzaWMpz46ieNGPDXnlxwdmm9i5Gnrg1hbzkdNxBLplP4=
Received: from SJ0PR13CA0024.namprd13.prod.outlook.com (2603:10b6:a03:2c0::29)
 by BL3PR12MB6475.namprd12.prod.outlook.com (2603:10b6:208:3bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Thu, 19 Feb
 2026 05:43:49 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::7f) by SJ0PR13CA0024.outlook.office365.com
 (2603:10b6:a03:2c0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.14 via Frontend Transport; Thu,
 19 Feb 2026 05:43:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:43:48 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:43:44 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <qemu-devel@nongnu.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	<kvm@vger.kernel.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Marcelo Tosatti" <mtosatti@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Richard Henderson <richard.henderson@linaro.org>, Naveen
 N Rao <naveen@kernel.org>, Nikunj Dadhaniya <nikunj@amd.com>,
	<manali.shukla@amd.com>
Subject: [PATCH v1 8/8] DO NOT MERGE: Temporary EXTAPIC UAPI definitions
Date: Thu, 19 Feb 2026 05:42:07 +0000
Message-ID: <20260219054207.471303-9-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|BL3PR12MB6475:EE_
X-MS-Office365-Filtering-Correlation-Id: 0977c157-300b-4775-dcb7-08de6f79daf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WZPFXw9n0xa7JipBTKojz5WOPfN1aa7kMt0teHx1nYpHV9I8xdBSyljVvTC9?=
 =?us-ascii?Q?vwsAV+iueoM5su15hF1LPRlE40J0BG2YvPJ5JTxpQ5xFt1+re6BdmJ62K6t8?=
 =?us-ascii?Q?Ba3xRbEBg3LWvlWWjlV3xFluHL2LyQ47MlEbQNZLZUbt/xl3+QY+5GyVrtp5?=
 =?us-ascii?Q?2UETn3s2sgWBxcPEL2uLJYndlvQeWE6tXlQof32F3skd/dMtcngDSXvvXOW4?=
 =?us-ascii?Q?MyNHXwNWIIzbr4FFkKCJIzaKTi8nYXMBHDfRzLIt2h0KvUY3suq/wg6HbxWg?=
 =?us-ascii?Q?W/9icqRZcdpyRFgiQlzhgXzwcugb287P+prk35qM7hMiDIUyE3k7SORDuZS1?=
 =?us-ascii?Q?sypeiBpa7uqgRHETy1xRnsWq8wLcFNzauBPKDjUakTHgZE0l726g7LIan1Ia?=
 =?us-ascii?Q?PzfnP0cyXIpVTFiGWulJtk0EC65kK3Mvm4F85M6+yOLC4dqj0x6kDlgRbmzF?=
 =?us-ascii?Q?oJgHkAaKAXDKYLfn8I0AwPL1TWho3Vt9ljoyHCqV7gdrDq3XgnKBqQI3nHaD?=
 =?us-ascii?Q?7ZErH79i2/8NwvpJee+75V2G4RTZxy0CUn2aCl4dSQtvfglJoWcqnOS5DUyZ?=
 =?us-ascii?Q?WfWNQYbkCcNIu+yVSf5D5A3qrejkZSGucuyY9sdKSJ9tJ/MeMjYYdN79qL87?=
 =?us-ascii?Q?TeYvLcer9r+P6RMCXa3fr34x5Ck5/ItyymzyHuRqmkChpwih0JhLAynHM7Yg?=
 =?us-ascii?Q?Mxx/xvHvfs8BFKczqZqYIW5SWwuMYKzvdtF56Rw2R18tXEd4PqKBE6+08VRQ?=
 =?us-ascii?Q?rmhHoPksxMkXIP6SMwZn6hvPvQunVCCeb5h3TGBW1ScqGwpmlqeimEMu+G8x?=
 =?us-ascii?Q?4C+s2gO5jLRqBzrKuYK3vtQ4zcztKc0TIvTAYoLb4Ia1PKBQu8neQaZV8vmL?=
 =?us-ascii?Q?MjC0DtmGWVeMJJmufbJt0zmMfeaaP8X8Jo4mvllUXVgNDWy4q+ay+QSxvNkc?=
 =?us-ascii?Q?pmaylLTkPArrj8QskL6QO2LLnAh5o/B5uyC1i9ENkMt5bdiPCvOJviWKp7N1?=
 =?us-ascii?Q?dYnBIO2/Nyo2GCTKKHMVHs1tvwNFnBpt6y4R0O7MPl2R9obCq41zu5l2uvDq?=
 =?us-ascii?Q?ba+ihI20xbyqkIu5l9vzos5JRdaNKrYU/aFFsDtZq+4v/ebe164aEjiJOl97?=
 =?us-ascii?Q?IUexr7zpVWY/PDisNQJLxSd4XZL8G7ZYMNOZOqC43o5nQmw/UW3h4u5uvH+0?=
 =?us-ascii?Q?lQEUk+UH9C6swEloJCHioxFLJVB2NyV8ZH9PLdGNWClJr58fTrbdWhnd5NUY?=
 =?us-ascii?Q?WVd1Gr2O9HQgcaoWDFHD0w1O316R8qwyp6dWUuNlU28hJWF5q6YJU0/H+110?=
 =?us-ascii?Q?gUNIfj9gADyWCMTwH6jNsyEBtGHbSs7Ij/nBmhmj+Egnfa/hqZEtlbiMi0JP?=
 =?us-ascii?Q?6Qn62QtHlakHT+rAK1/ABuu/1vnsDOtFdkaTFwIbg5WMqV217FmzgNJVBsdP?=
 =?us-ascii?Q?8MCWBZPCMqJwQQfiUXnyDlNpiBQPTrzKINKLsb7DuS8TCHuKKtCOBylA3vGK?=
 =?us-ascii?Q?MJFGbUEr0UQN/PJP+E46X9cdAoOyfkQk6JBB5Z+wZqp9ocI0jzPcuHmxXSZY?=
 =?us-ascii?Q?+RDWd2EIWq91otWoxdt8pyCi2oUuA5aQJJBhRbgYuIQWCzxrkMR097WYn3US?=
 =?us-ascii?Q?7+kxBdJGwZ/GSv0LGudDVkVR2dTQxUsGgB3eZCV80E2LG8hfYMl1F2PkTGtd?=
 =?us-ascii?Q?lRlWEQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	By/YQNO+/ZKS1qVeVR0LRWvIE0CGWqs/dLrfGio85Hc3iEL4bfBlzeZzNSgytQU5QB5PB8zeUBYcNmI321Zu2GUQ35kURZgeDjOqBEGMCEaTFCNzxu9B6USpJbXiAnWEHYG+iW3+GmDs1bpfrXMcStkfyt6OJ9YAvM74ICE9wVpdQCnpKBmNPWPi/m1WoXGTSYUK1Lfw82fJpF3L9KnCVuzP98/5zuZsC2bIiasWcXEemh57vQShBjqwXQsNSKau6j/VmuOgWLAJtKvI0yM+SGPCq+veOpgXp4mEo81ndanGjTlHyS/MbUyEyrPYgaUXhImKafbwNlwf98kY8jUb21wWVlrmwob1Ja1svc0FpFh5cj/cOqcb5XP1dlOlAbfmUwPI8z3humR2MGfQqFWUrMY3TSAthUhsEF2Qq4SZ+lK40Mqi7Q/7FOIEHlNu05vt
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:43:48.7069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0977c157-300b-4775-dcb7-08de6f79daf3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6475
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
	TAGGED_FROM(0.00)[bounces-71333-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: AD95815C2B6
X-Rspamd-Action: no action

This patch adds the minimal UAPI definitions required for extended
LAPIC support. These definitions will be imported via the standard
scripts/update-linux-headers.sh process once the kernel patches are
merged.

This patch is provided only for testing and review purposes and
should NOT be merged.

Kernel patches: https://lore.kernel.org/kvm/...

Signed-off-by: Manali Shukla <manali.shukla@amd.com>

---
NOT-FOR-MERGE
---
---
 linux-headers/asm-x86/kvm.h | 7 +++++++
 linux-headers/linux/kvm.h   | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index f0c1a730d9..04d1a1a527 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -124,6 +124,13 @@ struct kvm_lapic_state {
 	char regs[KVM_APIC_REG_SIZE];
 };
 
+
+/* for KVM_GET_LAPIC2 and KVM_SET_LAPIC2 */
+#define KVM_APIC_EXT_REG_SIZE 0x1000
+struct kvm_lapic_state2 {
+	char regs[KVM_APIC_EXT_REG_SIZE];
+};
+
 struct kvm_segment {
 	__u64 base;
 	__u32 limit;
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 32c5885a3c..4e67281e99 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -637,6 +637,10 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
 
+#define KVM_X86_NR_EXTLVT_DEFAULT		4
+#define KVM_LAPIC2_DEFAULT			(1 << 0)
+#define KVM_LAPIC2_AMD_DEFAULT			(1 << 1)
+
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
 	/* in */
@@ -952,6 +956,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_LAPIC2 247
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1308,6 +1313,8 @@ struct kvm_vfio_spapr_tce {
 #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
+#define KVM_GET_LAPIC2            _IOR(KVMIO,  0x8e, struct kvm_lapic_state2)
+#define KVM_SET_LAPIC2            _IOW(KVMIO,  0x8f, struct kvm_lapic_state2)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
-- 
2.43.0



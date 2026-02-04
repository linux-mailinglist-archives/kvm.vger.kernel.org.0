Return-Path: <kvm+bounces-70151-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LDIFVH5gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70151-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABAD1E2CB4
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D3D73062233
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AD334D4CB;
	Wed,  4 Feb 2026 07:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lAiMm+do"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011004.outbound.protection.outlook.com [40.93.194.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E7138E11F
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191138; cv=fail; b=b3PCOOqSeZKiehhZCweI5Kqob/kg6gYLrSCMiBftfhGaBh8dnQPBIO9GC13RJcBtf0UscG4vcvKZnxyU5UtGD3nCSNZpqlUje9BVzDCyX0WoRu3qbdJK39Xq/0UYl7QGKRUa5DbkoYx1H4k3jZYInDHDeEvNZm8M+MlGuE1vcP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191138; c=relaxed/simple;
	bh=UZY9jLtRsKZ+VGO5nkfRm4ZcOxSbgLT/8HWBQCwm6nI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J8gL3PGZ7kZzDnUoqJs7DuCNA7qvvX5+u9fbchY0Zyax1O1A39FkAsd3WWopBmApk2l5w4K9x4VS7EjlKOPubg/UAtpKl2kNqnzz/2yaRdIryekY5VV1b7q1sMUZZQdG5FVuBGQerndiaypRjMkHw/VXYwQ/Cg6TSTWQSB0lt9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lAiMm+do; arc=fail smtp.client-ip=40.93.194.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XQfetNWL6B7QakWiL9rcsJbyos41FXapikyLzgoXE/6FcqsLNIHJPjfUdii1ZJPsdnJVhFNXvmyu5c3wYQhK+5VmkmGnnhqOY1ac/JTVndHCnpL+Kg8acM99QQMwTW/xHEe+QIDhh7vEwX5Cfyy0ipG7qNDz/nFEeG9401W9cqy3y+I3ZWB4xrqanpkWK5XE1jCa+ZE5Zoh1PXTQk7iEUOQqbgEp8h8KysyMyJ8ul8ANiDS5aHBRsx551hy1Crir/3fl45BZeRU2gWVwDNmnokYq7pWwzCfifrau7Ta8s0kJrDTyejzVa1nxILc0cQlHyP2qMUG/poYL6E+G91+rqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTC2wxP6slebJ99QL7OB/eXid3nDlZr0N7Gzaw6djdY=;
 b=qzUwd9Q9f2iMkNCkD2G8xpNaSbiX/fGRmhxbPJaLqMX8uU55EcWpgFxC1w+VfLKvJ2w9PnnYribSeJJQ/86CwXVVLBXU+XkrYHQH8/719JKf5EvSKgij7r87kgzcMFgrR/1f4M/1n2O9oP07R8E7rD02Sl1HFhn0hTbFokNAT60iSuBbl8/tLF9xsR5HDnlPs5oLCJ8tA4baKKEeZgkO0eMfVZOt5dCh5kKHwE2cDfX0hSR/NZmvRPUbhr2rGNq4zc2ZfDFn1GEz9YjvKgtv9nzdakAtLgau4U8xllAFD1ijCQTIltx3Vw/IPcmo13K4YOLjELg8JilKStJq21s0tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTC2wxP6slebJ99QL7OB/eXid3nDlZr0N7Gzaw6djdY=;
 b=lAiMm+doBqNXqxvDuiOp21/bcujcIDLRMdjqTAQGsWFqcgZFOMaA4D1H8dnOLwR7whgixRFrn/BG91nsLK3VA+rfxUPRtQWvQS6kRqJqcZkN4NBn0H8UHS5Z2q9OnhU7EbsbIAOQqbbG0SBhDfv5FBREaHFwVe133KItR57pKqo=
Received: from SA0PR11CA0099.namprd11.prod.outlook.com (2603:10b6:806:d1::14)
 by SA1PR12MB6678.namprd12.prod.outlook.com (2603:10b6:806:251::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 07:45:30 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:806:d1:cafe::45) by SA0PR11CA0099.outlook.office365.com
 (2603:10b6:806:d1::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend Transport; Wed,
 4 Feb 2026 07:45:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:30 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:26 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 5/9] KVM: x86: Refactor APIC state get/set to accept variable-sized buffers
Date: Wed, 4 Feb 2026 07:44:48 +0000
Message-ID: <20260204074452.55453-6-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204074452.55453-1-manali.shukla@amd.com>
References: <20260204074452.55453-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|SA1PR12MB6678:EE_
X-MS-Office365-Filtering-Correlation-Id: 97e03bbc-5c85-410a-be6d-08de63c15eb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ID6wb4DH0DxHNI2zhUUTHHqT3VnB4+DoI/qpd3L/j5rI4pQO5NBA7R9TER7Z?=
 =?us-ascii?Q?ULuGuiC7BZvhgalSv7QEGSGjSnTwGrrTbM6qhHEvCuphTo+QXZ3NuUICodDT?=
 =?us-ascii?Q?OJZjPCoPuStcOZgKPeCzi35iCIxJ9mlVT5VPFle3VzHSEWMnodYjYzdsMf+p?=
 =?us-ascii?Q?K0VIZj5Uvc8y+J7Q+47xgxwzP/SxhN7JmN0Ia6RmupfQGm2YZYYGdmayew7d?=
 =?us-ascii?Q?ozWRZsss4VFyDP4O2cEuyOaQePCsqzrfkVcIuTrbsnFuBfIcRrzCqAvXVWIq?=
 =?us-ascii?Q?GBKZkmLk9r6kDgTupJL3IQiLhddqIvLjSlE+Oa6KpQVUENt8fteFjOCQF/vY?=
 =?us-ascii?Q?2E4+0gPYn7AQzuIqVh2Z8eEmDiYqX4TEEW2KMTD9WqAXvjHbniDEHHyiS3zY?=
 =?us-ascii?Q?DWwmYeX2K7YM5Jzy8rrYDVDMRrUUG+N/gkwNEIG3MlAR0dQU/kxCbs0OL/tB?=
 =?us-ascii?Q?5YmB96qf4ZDsQR52PABujvJffTMsRMw7vFsfeGxT959OmJuesKQoOPUFpRj4?=
 =?us-ascii?Q?sPaPYVI3TcrKwUfx3Qd21h5GcEG9MOs3b3qw5OZfFm09Pehpxwqszu6R5kMv?=
 =?us-ascii?Q?CQSpx0OxIt9491hEcz9xLmxP9lZJLJIZs7xHQ0TOiEthKOdkYjq52kL1oiWn?=
 =?us-ascii?Q?TD6RBxFyCYcFFke7hsm+VGdnOLsa3uNh0zNEAJ5Cq+Qr1ZlUHEqD4yvrwUP1?=
 =?us-ascii?Q?dLVSlmz1hnjgNcFe1m4Wc2Bff6f4ss9iLEVoDC6Zzi6yqgmmwQsMVCd7c02K?=
 =?us-ascii?Q?LLJtjEwUAfrYShee/Fs+KPhEH6iAfivqpZXubk6Jso2yyjtXhGvw8c+HGKoR?=
 =?us-ascii?Q?cS+Wdp3hee29w8dCyHG0Fik7Ihj+nTTEuYcNTZvQooauzHX2LQDPfCM7zqle?=
 =?us-ascii?Q?pwVSNEXz9o2Bu+6ohpXrMZJs3guZSx/LFTuqQE12hyDVQpBgRXWgY73srWtP?=
 =?us-ascii?Q?R7CY+MkeUpmP92CaTjPjBLc72V2kDiFMlFEwIx/MNxwoHJIoB37RzAS6+mKo?=
 =?us-ascii?Q?LKksT/OFi4J5GcmJDI37orqMS3T6IbZpzN+axNwX8xYc4RwLYT4e8G10YtJ9?=
 =?us-ascii?Q?9TZwoRaLFMIrDWVRSKLt75vtbBJWkZuzXeBVTs3EmRYmAque6YUe2VrrgDan?=
 =?us-ascii?Q?Q7YkbSrp6q4zsInSa7sq5FtWROrtFPehcvOL1P++n73TX4sExyR3uGYQIgP8?=
 =?us-ascii?Q?PClL/pdvrhkBinZu5kwNlIiexjch+SiZWs4W/UQyIEep0ttMcLWJU3RXGFhs?=
 =?us-ascii?Q?It7xFeawneSqn2ypJS2CTctBwHft+YW9S+HSyIe9e5WPsm3qAK1ocAbzzNfQ?=
 =?us-ascii?Q?cOkeFqnvbk4IGujRWreUJoTNQZO1Ep2N6BDzhvg86nelsCFCTTRkdexQnyRs?=
 =?us-ascii?Q?P8RaMqaJ5zpuUAjjE9DZsJm7rSdyoI2iL2ZVb885p2TYBfP+8+FlKhw9QBuJ?=
 =?us-ascii?Q?WMJhZSEZhbRgvhaiMkH/m4YSaC/wQsqjWnLlP8+OcXYuB85SW7DyAmHq9VZB?=
 =?us-ascii?Q?HNlvbZmL9OXyNjUN5tFLRdAo5IWzg74XSvtmtyZV8AuvQuGpNcBFDwez6WmA?=
 =?us-ascii?Q?E2voOnL9FmY9o4KOs+UpzYdK31VF+vu+K0Wt7EeAYtZHtGA6lpIq1d4+ENZd?=
 =?us-ascii?Q?XIWS09E5TD+REnA0BV8bHjU0Uan6o5j+SJHNQLHOm8sHZmxbvTdMpQHv9uZJ?=
 =?us-ascii?Q?1BZpLA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VYgepBb8IvIp8PBViDJJfu4TQS/cVt0PqzS+AseIvMrjPjLyv5F8MK6Zq3v4T8GcViCs3YVVpcfYdHqqrKHVSb2OMK7iZdBhA2Nz/EKIppW4KAh1wVayYhkTn7k1UZUW+ffEMMZUG5g2+76vmaOBT8uRW/JOSYYniGEr66oKXWFESDPQ8atnwYOvY/zsS167KE0ogUvhSM3bmH4WPwzp/KJrp6ajHQ4Bf1ReO7Dz30jlyiaSRqnbB+mlGV608Hq6Dq00Bjh1+xbCoF1mJMujhP2DXiuL0pJCcv6b50mcVkDJJ81inbjlT/v3xxqx9GMPNHoe6mjq4dqJSsSUl+XEEAS7YVMZwds4KW0/h+W7aWR9rrYpUWyfJqN+mIIOBsotqZPuUo/y3qKfoPjAq89s37UwZ0e42gC9JYXOqSOBAXU0erhOV8SpVGZT8wxId/4b
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:30.1457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e03bbc-5c85-410a-be6d-08de63c15eb7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6678
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70151-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: ABAD1E2CB4
X-Rspamd-Action: no action

Refactor kvm_apic_get_state() and kvm_apic_set_state() to accept a void
pointer and explicit size parameter instead of struct kvm_lapic_state.
This removes the hard-coded assumption about 1KB APIC register space and
allows functions to work with both 1KB and 4KB APIC register space.

Existing callers of kvm_apic_get_state() and kvm_apic_set_state() pass
`s->regs` and `sizeof(*s)` to maintain the current behavior with the 1KB
kvm_lapic_state structure.  Subsequent patches will add KVM_GET_LAPIC2
and KVM_SET_LAPIC2 IOCTLs that will also use these functions in order to
save/restore 4KB APIC register space.

No functional change intended; existing KVM_GET_LAPIC and KVM_SET_LAPIC
IOCTLs work exactly as before.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/lapic.c | 32 ++++++++++++++++----------------
 arch/x86/kvm/lapic.h |  4 ++--
 arch/x86/kvm/x86.c   |  4 ++--
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 66819397e073..4ed6abb414e4 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3151,12 +3151,12 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector)
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_apic_ack_interrupt);
 
 static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
-		struct kvm_lapic_state *s, bool set)
+		void *regs, bool set)
 {
 	if (apic_x2apic_mode(vcpu->arch.apic)) {
 		u32 x2apic_id = kvm_x2apic_id(vcpu->arch.apic);
-		u32 *id = (u32 *)(s->regs + APIC_ID);
-		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
+		u32 *id = (u32 *)(regs + APIC_ID);
+		u32 *ldr = (u32 *)(regs + APIC_LDR);
 		u64 icr;
 
 		if (vcpu->kvm->arch.x2apic_format) {
@@ -3189,12 +3189,12 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 
 		if (!kvm_x86_ops.x2apic_icr_is_split) {
 			if (set) {
-				icr = apic_get_reg(s->regs, APIC_ICR) |
-				      (u64)apic_get_reg(s->regs, APIC_ICR2) << 32;
-				apic_set_reg64(s->regs, APIC_ICR, icr);
+				icr = apic_get_reg(regs, APIC_ICR) |
+				      (u64)apic_get_reg(regs, APIC_ICR2) << 32;
+				apic_set_reg64(regs, APIC_ICR, icr);
 			} else {
-				icr = apic_get_reg64(s->regs, APIC_ICR);
-				apic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+				icr = apic_get_reg64(regs, APIC_ICR);
+				apic_set_reg(regs, APIC_ICR2, icr >> 32);
 			}
 		}
 	}
@@ -3202,20 +3202,20 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
+int kvm_apic_get_state(struct kvm_vcpu *vcpu, void *regs, unsigned int size)
 {
-	memcpy(s->regs, vcpu->arch.apic->regs, sizeof(*s));
+	memcpy(regs, vcpu->arch.apic->regs, size);
 
 	/*
 	 * Get calculated timer current count for remaining timer period (if
 	 * any) and store it in the returned register set.
 	 */
-	apic_set_reg(s->regs, APIC_TMCCT, __apic_read(vcpu->arch.apic, APIC_TMCCT));
+	apic_set_reg(regs, APIC_TMCCT, __apic_read(vcpu->arch.apic, APIC_TMCCT));
 
-	return kvm_apic_state_fixup(vcpu, s, false);
+	return kvm_apic_state_fixup(vcpu, regs, false);
 }
 
-int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
+int kvm_apic_set_state(struct kvm_vcpu *vcpu, void *regs, unsigned int size)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	int r;
@@ -3223,14 +3223,14 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_x86_call(apicv_pre_state_restore)(vcpu);
 
 	/* set SPIV separately to get count of SW disabled APICs right */
-	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
+	apic_set_spiv(apic, *((u32 *)(regs + APIC_SPIV)));
 
-	r = kvm_apic_state_fixup(vcpu, s, true);
+	r = kvm_apic_state_fixup(vcpu, regs, true);
 	if (r) {
 		kvm_recalculate_apic_map(vcpu->kvm);
 		return r;
 	}
-	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
+	memcpy(vcpu->arch.apic->regs, regs, size);
 
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 152f17903ff0..c6ac40c76f62 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -132,8 +132,8 @@ static inline int kvm_irq_delivery_to_apic(struct kvm *kvm,
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
 int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
-int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
-int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
+int kvm_apic_get_state(struct kvm_vcpu *vcpu, void *regs, unsigned int size);
+int kvm_apic_set_state(struct kvm_vcpu *vcpu, void *regs, unsigned int size);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 368ee9276366..669c894f1061 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5328,7 +5328,7 @@ static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 
 	kvm_x86_call(sync_pir_to_irr)(vcpu);
 
-	return kvm_apic_get_state(vcpu, s);
+	return kvm_apic_get_state(vcpu, s->regs, sizeof(*s));
 }
 
 static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
@@ -5339,7 +5339,7 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 	if (vcpu->arch.apic->guest_apic_protected)
 		return -EINVAL;
 
-	r = kvm_apic_set_state(vcpu, s);
+	r = kvm_apic_set_state(vcpu, s->regs, sizeof(*s));
 	if (r)
 		return r;
 	update_cr8_intercept(vcpu);
-- 
2.43.0



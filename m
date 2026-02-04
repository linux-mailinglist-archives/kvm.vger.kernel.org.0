Return-Path: <kvm+bounces-70154-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFcJFm35gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70154-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C24E2CC9
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DB7B3052891
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D521A389E14;
	Wed,  4 Feb 2026 07:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VUEf/j9l"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012017.outbound.protection.outlook.com [40.107.200.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DF42F547F
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191150; cv=fail; b=ifkqhYyqTIGvzOSTSt5ASxiarQReQaySNkj0fejpiVSb/rNlrxWaLd0EgXaBZVVdqhWjT6w1+gOdZSDFQ53XNh8yPGY1V17viLuP45KgyxranLyf6JOxIFxOo457dUsrhzWjsq3bOhMz89cG7q7MK5raB9m5W4mtAZsCJ95+2Sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191150; c=relaxed/simple;
	bh=ji2PiXCO5RNxuswJZRZqpCY1w7lqp3C2GGHT+9dl5UY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJue5ABCQFwzSay1odKKnsQwNj3OvsQZkkU6MCyJYRcKQ42QBSLmOlZrh0jHLkYEJ9hQirdhEkkZTVAJwHqDcvgY3CHHycIiTOsvr76ZZ7NsgJYMrTyT/shVGQyj36s36KoM9/29Rv13vqYj17jOI2m6IRqjCNPBamh4bw81OYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VUEf/j9l; arc=fail smtp.client-ip=40.107.200.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YruxB9E+plWyBSaucvylA2RPkDnzvk7btTI/M2UVGXjWNHz6G1HLvCSW5Cc9sM+WhJI3WWMGxaMMN0WA8+OrrxZv5wfGWNfJ38zPnurmvR0i1UfGRwrFufU/dEFunWxDmZR8kmfIJ0iclbaBIKaZBWQsVLChSIB6644WSwH6kq1MfqmU/tWupru3oCkN6YxKkTeQyY4Hk6Dd/F+sdrDVqR40Oc3xOj2/E6x08aWAb21MvuUY7527eTeehNXLHIJEPVT7qK/25d9biD8wTRMS7hC38lVj1lyfabg6c0sOYyUPl4fuJjm6PQ0og1FcYweUOhghkcXbabQ1g5wvNeX64A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdjybW0bk1/tSBYttggPsDIPnkh2eoTA0X8qfJSTW4w=;
 b=ef+yjLwH0gYtkg1+yniml95e2l7jw3gF/pIJmju9jG2lZD/irobyiPZAMFfrP3cAL25X+I24jvmHKDdz/OuPO01j+ieZkOw0bqnvj0uLtkn+I8vrWHML1Wgrsp2Jl2Ezsm2PFmxEKJ2AC2oenOhERqg5yFjDnY3aAEMO1KrMbVzkXZD40W6upzA6coPY9ZBvFIemxGNTARAWJrQtjZLQa+PUDhBnM2hGn0+opf0xMI/SzrBsLfWiwoxild+ek6UiNK9NQVTjtfHmXKXLu7P79B8YflKtIaQPtHRtU92ryC7clUCAdRjNKktDCRc3nK92hoVecwCM8Gn0XJ6VDlmsRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdjybW0bk1/tSBYttggPsDIPnkh2eoTA0X8qfJSTW4w=;
 b=VUEf/j9lWfrXmg5CtQNAP6jkH6eGLi8xfr9sbnSkYtVsNzRa1E22EtNSUK/VNGDTFSSA66XhVPCYtmtD5pwzlOih/7o1wZyCI7LNNX1FlHfbWAorjLkNpL2gGSiKz3HTRmr5gupVoO25zqVHiJ6VPAoE9B7tauky+kmuimLQZuA=
Received: from SA1P222CA0132.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c2::15)
 by DM3PR12MB9352.namprd12.prod.outlook.com (2603:10b6:0:4a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 07:45:43 +0000
Received: from SN1PEPF0002636E.namprd02.prod.outlook.com
 (2603:10b6:806:3c2:cafe::fb) by SA1P222CA0132.outlook.office365.com
 (2603:10b6:806:3c2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Wed,
 4 Feb 2026 07:45:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636E.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:43 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:40 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 9/9] KVM: SVM: Add AVIC support for extended LVT MSRs
Date: Wed, 4 Feb 2026 07:44:52 +0000
Message-ID: <20260204074452.55453-10-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636E:EE_|DM3PR12MB9352:EE_
X-MS-Office365-Filtering-Correlation-Id: 7414256d-f72b-400f-88e7-08de63c166bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8Voh8gpsfFAyOnOGc1oAGEOdWvcRcDWPHgDWw+CLkIzRZVRYJzZxkkXkCCGE?=
 =?us-ascii?Q?X6CNweZmWenp+Y04oryYbBcnXIe04EsEHlrEkHoguvBJOytkyN9ieYQmJd7c?=
 =?us-ascii?Q?veaMB/Qwd7pHQTQrfSrBodfq2MWXm3jSuce0rSLFUcufMlxadVSjsl3p1Sk+?=
 =?us-ascii?Q?qwdk7TZQD/503Pr9B57Q8/wGYkz3MpmQMpeP2jb3oa4++nyPfnqTb2DdtP2m?=
 =?us-ascii?Q?+SLILo9SGVFPKzrmeXMfk+yOFxl2jCsN3mRaRl+lF7lmqcOnGAHXHgmWKqH2?=
 =?us-ascii?Q?9H3sdBZp2PEuz8HlKRIwhFJfv6qVmUw/0BmmNmZt9jC1U8PfEY98CK+iaj+n?=
 =?us-ascii?Q?Qi3Fw5uXvXmlbKW/HZd+83igVLC3ne0oyvvnwFwTDF1oQ0bhiiKlo7Os4OQn?=
 =?us-ascii?Q?56BauWNepYxH9WAEh2d+EXzcTKMb4mm8sYkDdsZiVzNLgZZNJz92XdnRLoGM?=
 =?us-ascii?Q?7Zt9FefJFF+qFA4OimZWPYm0o4x4Rn5E2QfMOSVEV+4WFgo+iM/dRjUOfoyQ?=
 =?us-ascii?Q?OivOK31XUR2qOhGqzhxMS0ypVC0zeD7GsdgoPQSWiHcjIHIXBT+fxDmeIfCi?=
 =?us-ascii?Q?6yrmQyKPUzyKN4xjIodSAB4KDOM0ifFJ50hVwLGOExZlTFOtpz/5hUQCvO16?=
 =?us-ascii?Q?p9ztphcos/0+PxOWbp6BqlYgLD03X7rwyErMG7mL35u96QJ6OFixCuWw5YA0?=
 =?us-ascii?Q?dCSJ47J8L7FjazV3Mx0qeHJa7d9wJbxE9gdy+l7VqlyV/AvLre+EB+ZkBJLI?=
 =?us-ascii?Q?wym5468IQFBpAhxaiZJOKTUKovwVkwYsDYkOBgY1phBjUx6NLKCo4BL8/S8Q?=
 =?us-ascii?Q?TwSZHwaGOnflwJgt/TPALpqDrKYlRQBSJ1XySfkoux347B7Z5qHLRsZ6/RSm?=
 =?us-ascii?Q?7cElEmflYXQgCA0IqZJ7nXhT2iyTv2yEE+ZV0ZVx6uYOFXsj5AWv7BqrHWEg?=
 =?us-ascii?Q?57pAzeQ25BKkL35EbMFmo7G6AK4oXwudsDm661VSzhLed0vcbD2gTn88KerT?=
 =?us-ascii?Q?IZmmUjoRPn5XQt6HH5pduMG/B0n6MDXVrhgtNGc/nvahY+mFPJNJDL4fTfr6?=
 =?us-ascii?Q?QHnd5+5li8IgCifqy7F4/IR4Mcr/EDAdGy9E14LoZ7/RtsEhfdVCm2H4nBqk?=
 =?us-ascii?Q?qqrzRX4pjff3jCZXUmvdNd/IDheey1e6nKN/XiC7CGeL6RZiYgALvs57/2gw?=
 =?us-ascii?Q?8vKlcmMEBP1fu9Uw1iAvcYKTn7/UVtLagTud5gR5XXxrFG1jAKlvjRI33VT2?=
 =?us-ascii?Q?w2+NjTQazg/18FXeaNtJSBV7aEpwuewXCe3ACq6c9WByuRSYCm+Vi1K5bipE?=
 =?us-ascii?Q?JsZkCoagUNAncikk08ZtIhiDHYXwHjjgPXQb6nvFtoQ+AKDJDVfw8xejwOO1?=
 =?us-ascii?Q?rLRSjvHGt+lRmehmOic53Req7SDL8VBd1ZV9z7DiJmKgJMrDPpPUdjp9k7AP?=
 =?us-ascii?Q?lwsjCbu/4Vnet/3IEz/i9NQ6wN2AVv3cyamzbW279kcVEJn6W8W84qPtVujb?=
 =?us-ascii?Q?ZWiEjbYe6+08uRSCY1cgGTV5DJiaQBjlsC2PbIOlKzQTSVaBQ4tQxh8JhCxr?=
 =?us-ascii?Q?MB2l/24z6g/z6/t7aLN8fUILIwyxpP0njwwkDgXKa+l7T2LqcSWzOcIJ+Sl9?=
 =?us-ascii?Q?l0wkr3y0LdZuVIhYRSgDAAS5JtmcxtWIpklyUwrKat51KeRCXryO5aI/VRbt?=
 =?us-ascii?Q?QZaMPw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3NXuHwxkL3u5BaZRGwA2UMSy9gT7Ep0lBDYcDhYJs+wTdNu9nta3IiCQqBxIqqodDaK7YCE97js2KSrLViWQVqDwQtSb9lDq0ivAJT7fOrdnIxgDRGK0QZUXo8LyI2zGsRnoW/+AWVR5GZLluFUKqoXGVZ/uwsVKVDdbor78yZfhpmnoAre/vD4MTfMIi9HOo4HpaFNTUelXQ6jYOsSHySB94MfbbP+ZOsCbS4DqL06eeFrHvuq61WIEdEqITVeKbD9NSe6wWgl5yvqdurxffSkGrHhWKYMDoMOAfwreIPyuI0KTT/i+Y9jXSxc9s7T0vAh/WspTcQSSwqfx8cV3qrrMTHApHCq7Q2N8j7NITjrjOZ/X6vsxm/FNJ/EY9SLwRt8gTR2ijqQcXaTbxaF13WDLhZisESlbEfkJHj0csniDdEbLzePR09beMHmQ4LEw
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:43.6000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7414256d-f72b-400f-88e7-08de63c166bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9352
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70154-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: E9C24E2CC9
X-Rspamd-Action: no action

Configure MSR intercepts for extended LVT registers when both AVIC and
AVIC_EXTLVT are supported by hardware.  Extended LVT registers are
x2APIC MSRs at offsets 0x500-0x530 in the APIC register space.

When AVIC is enabled and MSR intercepts are disabled, allow passthrough
access to extended LVT MSRs.  Hardware accelerates reads without VM-exits,
while writes trigger trap-style VM-exits that are handled by the existing
avic_unaccelerated_access_interception() path.

Enable AVIC_EXTLVT support only when both X86_FEATURE_AVIC and
X86_FEATURE_AVIC_EXTLVT are present.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/svm/avic.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f92214b1a938..039cb02dc00f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -107,6 +107,7 @@ static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 static bool x2avic_enabled;
 static u32 x2avic_max_physical_id;
+static bool avic_extlvt_enabled;
 
 static void avic_set_x2apic_msr_interception(struct vcpu_svm *svm,
 					     bool intercept)
@@ -155,6 +156,12 @@ static void avic_set_x2apic_msr_interception(struct vcpu_svm *svm,
 		svm_set_intercept_for_msr(&svm->vcpu, x2avic_passthrough_msrs[i],
 					  MSR_TYPE_RW, intercept);
 
+	if (avic_extlvt_enabled) {
+		for (i = 0; i < svm->vcpu.kvm->arch.nr_extlvt; i++)
+			svm_set_intercept_for_msr(&svm->vcpu, X2APIC_MSR(APIC_EILVTn(i)),
+						  MSR_TYPE_RW, intercept);
+	}
+
 	svm->x2avic_msrs_intercepted = intercept;
 }
 
@@ -815,6 +822,10 @@ int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu)
 		     AVIC_UNACCEL_ACCESS_WRITE_MASK;
 	bool trap = is_avic_unaccelerated_access_trap(offset);
 
+	if (avic_extlvt_enabled &&
+	    kvm_is_extlvt_offset(offset, vcpu->kvm->arch.nr_extlvt))
+		trap = true;
+
 	trace_kvm_avic_unaccelerated_access(vcpu->vcpu_id, offset,
 					    trap, write, vector);
 	if (trap) {
@@ -1293,6 +1304,9 @@ bool __init avic_hardware_setup(void)
 	 */
 	enable_ipiv = enable_ipiv && boot_cpu_data.x86 != 0x17;
 
+	avic_extlvt_enabled = (boot_cpu_has(X86_FEATURE_AVIC) &&
+		boot_cpu_has(X86_FEATURE_AVIC_EXTLVT));
+
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
 	return true;
-- 
2.43.0



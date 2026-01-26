Return-Path: <kvm+bounces-69179-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCcBJzrud2kVmgEAu9opvQ
	(envelope-from <kvm+bounces-69179-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:44:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F11308E03C
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 23:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DBCCB3054D18
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5391430ACEB;
	Mon, 26 Jan 2026 22:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xr7yQeIL"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010062.outbound.protection.outlook.com [40.93.198.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031DA30AACD;
	Mon, 26 Jan 2026 22:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769467376; cv=fail; b=YNML6msVb+/K7SGEupUimgT6X6NRd3F+SAg5lh+XwcP86PLKXWrGxXhQjhj5GVAszWrY+ktTILHlZAcN8lQw0V9ihYwnv86L/ps+tJ1t0MNHC2NPmZm93owA0F123QA0BSso1Gnh/EJHVZDLmMDCCLlkBWwgHuIuFSYyQFz6xCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769467376; c=relaxed/simple;
	bh=lEEHEy5NXYmlrENjx/M/aNd89k2WrZuELFhoI6w8kTo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wwa47CacYgT8wvQ+PedhP68H83hbMLM5rDxVC62bWX46dzTMt0AbkUFSu9xVUHI2yWT1q6AM+qM8Htk/F5aMDv6Iu9n9Z/OvsZZvKgupK9/lrKrtZWdmp2bINPRNVMo5R+kzSApf3wliRQKF/0AMGDw7edItxyLydM1ypItUs5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xr7yQeIL; arc=fail smtp.client-ip=40.93.198.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cI2qIpUwf5T5LIgcZE7C+RHcDW2Nqw0fjSQPBdko0ZAuuiiyAdjyB0m1x2R8aSsXolh38wYSanL79dFgm2PtvdwjMpdDIQzjOds6NR8y5SqF5nOUNuDwsZclnXLu76EfJdK2RWqLJzHbXmCqoKxYnk9eg+WTRep+AY5rJTqmAYXDWUGNAVDJXt82rHUjszamLzOaW+GS/09BTY8R6+K9MiYt/aH+ZGOE5CFQ0vvUW1CxXZK6zSeSKzD1FQ61FvICYJhgq7mT9M0PS6nXxJDITHKpkgvsVB6M+jHjRyO53Gto18uIw2nhOLugpOAmFQLFwfRMeKrO5inkr/Ir0jOypg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOzN7rP5+RmHojoItY3+Vqsy1ZZvtjHzpiv9ydQ71DE=;
 b=GRslPX9Vy8Uo7PzE1yVIqxyjE6NHJtMEYXd1HEN4EEKDSINILjIhUWy2FHMin8f0mp5OgP5RitcctVuqGMxojRNH45WgkfPM/onXhnIWI9MSH9Ug/t9api4UjevlYo2S/VY1TAy6CUa0oO3xSXFOaRvgaGIgrzi7jf7sFNQUdESS9JVx0XrKRRAowykpCVnFDXJ+W744m5nGqCKyRovAFMWjprnx/VNFEHGQly0cvhUE6zcq7Z20YLpcKQZSILHJmyEJvoldj6rs4NeMEx/X3hOt2SKe8HXI3G0lnCIQdfe9U9ae0d+svLnWB3k87dfQ9aHdaqC9HFk4EipnROdn1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOzN7rP5+RmHojoItY3+Vqsy1ZZvtjHzpiv9ydQ71DE=;
 b=Xr7yQeILVhYi42TLPDrICX3DhgxYgx1iqNbEXvcb8Pw0nDsDHjgIk+6NlNHGy2ysOvCCaMpzcLGdcnfW3vt1UlwEEYnw6qoiU55tgLC4X+GEQ70QBppoAaNlfjAhg+Cs/nFMnUvmEQSvMkOVgs+6IRvVWVrKCOgktbVUd3bUSAY=
Received: from BL6PEPF00013E02.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:18) by DM4PR12MB6206.namprd12.prod.outlook.com
 (2603:10b6:8:a7::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 22:42:48 +0000
Received: from BN2PEPF00004FBF.namprd04.prod.outlook.com
 (2a01:111:f403:c803::7) by BL6PEPF00013E02.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Mon,
 26 Jan 2026 22:42:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBF.mail.protection.outlook.com (10.167.243.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Mon, 26 Jan 2026 22:42:47 +0000
Received: from gaul.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 26 Jan
 2026 16:42:45 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 2/2] KVM: SEV: Add support for IBPB-on-Entry
Date: Mon, 26 Jan 2026 16:42:05 -0600
Message-ID: <20260126224205.1442196-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260126224205.1442196-1-kim.phillips@amd.com>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBF:EE_|DM4PR12MB6206:EE_
X-MS-Office365-Filtering-Correlation-Id: 56da80d3-1738-4f8a-69c1-08de5d2c3ad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FnebeY9EbsqhVw3FZq0/uGHrW6t7UKfZx+58eGKRaoPjPIQ3q7mAecthO2IY?=
 =?us-ascii?Q?XJEh0+zWHgJB9BrLVdesXRFzPBUVlleyvnYQP/Nhpr9cbyIU7dyaWMK92scd?=
 =?us-ascii?Q?ahBzBr/44QVRfQ5B+kV5l6Ui6W67Q5Qt02k08e8Ej9APR+mFt74/iC9o3KXb?=
 =?us-ascii?Q?8Uo/EL7cBuWL1Ie0XY3qppDB7k/Wx3pCB25ibkorjjgJ0eG7WGNnF9UvJIlQ?=
 =?us-ascii?Q?5nu8cII/SSLrOZp8km+ZsZYOGVquE9aX+DyvlpHEggceQ0sP+RBVTFsv1v7q?=
 =?us-ascii?Q?Rho2E7KVHmXNTEsU39Jaonfq8UluZGmDC3ssylSWKXtoKEA28ItL8SHyOk8f?=
 =?us-ascii?Q?HjNq8fFF+HZjz2Z9CCjVVyA2GgvUNakeLsiNOnzWJRT6yMJbM+avJQt/Xs4g?=
 =?us-ascii?Q?vp93c8jVJPn2si7QG7Vfrx5ssi3tvLrkcbSFDv8h5W7VcoLSl2ZsSFNofsZi?=
 =?us-ascii?Q?N4AR87JAQEJ7HCXWECpOIvYgXXrkxeZde3C62s4lbNCxqOpbjexOfCq9qrkZ?=
 =?us-ascii?Q?hadeTu4sSizBJFB3pyecP2St1NTHWT6jhHgTW3dq8E6M+B9+ENwXi52xrhon?=
 =?us-ascii?Q?imsSkLZcNcsAd8kc4cw9nmyXsGX53oh2vphtxA6d/39nN/+REI8Qry50v0Cp?=
 =?us-ascii?Q?FdwF6hM6a1pNOu0jpLtOgVgPbqPNi2jCYKFXl1SiIqW0tawIB6wDOPQlyFxt?=
 =?us-ascii?Q?ojndV/5eoHpZ/FZLRFh2BGGaJLfeAviCPg0xxM/rndXKNifm6m9PdLhjlgXr?=
 =?us-ascii?Q?HXuFzVidBclE06HcXVaYAPsxU7k93+ePP/5EPHwsorYKDH+8Pqx7RSxSR/rs?=
 =?us-ascii?Q?HbaIgeCnA5DHgco8uQY27B3nidDpnZq/wE0uBa7QyKRF3gnUEZl56+cPvrlj?=
 =?us-ascii?Q?JpT9Y48FFsCdfQ6j+LMEDPS1Z4Rj0EHo++lsfjbFuZO4GuO7Wh7X0u1XNS1i?=
 =?us-ascii?Q?ICSARkoRd/qTZTvi0830aSTF3IpqGbqCmudClByvrRI/QtEuXA83r863vxdr?=
 =?us-ascii?Q?vNSXiYvB7t/O0uGtiBux+MIsJUW+hu8jZrxq3RBj6nRbmqCBzM8CUomAAGoV?=
 =?us-ascii?Q?1ImCgUdRb8poi7aiV57mO3UuEvjql6uS9h8rl5j/Q/2gjNHaq9Xws/1Nr5yh?=
 =?us-ascii?Q?bILQpP5g5U7O9HXE1q8oFXSqzwOOL7edDaZNHXcLGfSKhnFrPoXnVAgjuYNo?=
 =?us-ascii?Q?+qlUjpT5cqOdqpGd4QvJCk6sVJGoJey0xSkLSdiujloh8A3NX5vy+014RdfF?=
 =?us-ascii?Q?Q8nzKPit9Yl+P3rXoNt7EENdO14GJM10l+h+IbLA0nvavVwspNfzPLmnvpcL?=
 =?us-ascii?Q?7RcHDlLGegOQ7ZrPBGO9aMkJp6/uP+U12WNzds/TPAfCvrD+jDbMpBVhpWpO?=
 =?us-ascii?Q?fTOr+o57LIi0GivWud+B4W/pFc5+gcO7nP+7pZc/IbdxpttDkC/Fy0lpHRkc?=
 =?us-ascii?Q?fbnhIzPO0dkw6dUeWPyVvrG+qAWgwUOFnA4F0BtbQdcmbb01F25o8RlDrDzt?=
 =?us-ascii?Q?hz3cXa+6lP3EJcvpp4kUkSCbQSFGeX3D3wiljBaG6tHCW0X9o07VZyV47UTR?=
 =?us-ascii?Q?7EaPs9ysWmvGfLK+y2ErQiFrVlaFlJAbKxoNiJ4DxJQMctTaHOQSkzRec1yW?=
 =?us-ascii?Q?3jJLzWXKwAhIQ2UvOkKsOOiETtqfSzQHwkeD3bR2wzWETUL3HYXM2C3OBPmI?=
 =?us-ascii?Q?/YR9Rw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 22:42:47.9511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56da80d3-1738-4f8a-69c1-08de5d2c3ad1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6206
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69179-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: F11308E03C
X-Rspamd-Action: no action

AMD EPYC 5th generation and above processors support IBPB-on-Entry
for SNP guests.  By invoking an Indirect Branch Prediction Barrier
(IBPB) on VMRUN, old indirect branch predictions are prevented
from influencing indirect branches within the guest.

SNP guests may choose to enable IBPB-on-Entry by setting
SEV_FEATURES bit 21 (IbpbOnEntry).

Host support for IBPB on Entry is indicated by CPUID
Fn8000_001F[IbpbOnEntry], bit 31.

If supported, indicate support for IBPB on Entry in
sev_supported_vmsa_features bit 23 (IbpbOnEntry).

For more info, refer to page 615, Section 15.36.17 "Side-Channel
Protection", AMD64 Architecture Programmer's Manual Volume 2: System
Programming Part 2, Pub. 24593 Rev. 3.42 - March 2024 (see Link).

Link: https://bugzilla.kernel.org/attachment.cgi?id=306250
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/svm.h         | 1 +
 arch/x86/kvm/svm/sev.c             | 9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c01fdde465de..3ce5dff36f78 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -459,6 +459,7 @@
 #define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
+#define X86_FEATURE_IBPB_ON_ENTRY	(19*32+31) /* SEV-SNP IBPB on VM Entry */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index edde36097ddc..eebc65ec948f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -306,6 +306,7 @@ static_assert((X2AVIC_4K_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AV
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
 #define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
+#define SVM_SEV_FEAT_IBPB_ON_ENTRY			BIT(21)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea515cf41168..8a6d25db0c00 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3165,8 +3165,15 @@ void __init sev_hardware_setup(void)
 	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 
-	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+	if (!sev_snp_enabled)
+		return;
+	/* the following feature bit checks are SNP specific */
+
+	if (tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
+
+	if (cpu_feature_enabled(X86_FEATURE_IBPB_ON_ENTRY))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_IBPB_ON_ENTRY;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.43.0



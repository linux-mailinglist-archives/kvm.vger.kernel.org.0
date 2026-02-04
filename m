Return-Path: <kvm+bounces-70153-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AOLqLWT5gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70153-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F31E2CC2
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9E6A306ACD1
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E172F547F;
	Wed,  4 Feb 2026 07:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="THtBslup"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A093838E11F
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191144; cv=fail; b=BVgBm82H7WNgQnuBVLmVwNi9hgd3IGV68HbZNcH0KiR7AgItUV6fFem1P2Mx7O2UP6LCTssUcD3arxGCjtU8jyBQJDhxPVTMq1QGEjf3c8QRcK8Fbv8ykoG0gnkWaXvdFvCDjxkfL1NVuSpnrCsLsAhy5cmUQ3JTgpRG0Nwx+AE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191144; c=relaxed/simple;
	bh=RBsgjHfbaf5FdiQyKFZAoM1QiQ+djocxO6jIVaJVT9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XNElOb1xcTCDt1uQd/y/ZC+aivvJksfLca0s4Q4kJqZx2HWixwMZkhe0N49Sc4ns0WAZCkJ5JHCDp19p2OKVgk396tUyG211Kf+tl4pX5mTJZi/rGrkZs+k56/wdbFuLKTYmZR8NAbGnCrXs0hv33W4SVrQ0Ua4zu+cW66YiQfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=THtBslup; arc=fail smtp.client-ip=52.101.61.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ArwOGuvpmKAjV8We8T3oID9RnfCiItl4jRS8n+leJkQKeWP4Tc6reBiVQMHvsbvy8sN0CVBNMpdQ0QdaAf/7bfZ+i/V1ppasK+3BytGaiYPKhvQJHaSp88PaSCVwcBsiZGnrIqZj7+xCX38U3II8RES2WFwUGBKOweW+8XiD/d+ItxzimVva50DEl22Ny6e3/K/OAIABqXZshrkdenMICOelI2flO8UdDVeMVdEmlgE+UZY4218TWZ1SM8RdfghPpA7RKxri09Ybcpu3iS3BQVNz2/qrE+FYIrdLaQrVo7iBxTsFRKI+4myorvq9P6+qIKDaGdVcsa6kBIUP3e1F0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnvN9a8cZ3thTbc1A9kyQNMOVFgl7EMELO6bAUWUfiM=;
 b=CYHvwPS/4TRtQXk+tHMlOr+5PfRzPQaB2Vf2DWf1OwC+zX//x5IJwjwwZCySv9CP7BExxGyhV0fJP5L+RGtI1l1y1yNtSrjgMfh+bzy9EOlLWeofXjWkRDB+TLCv5aC5vAd9UUpo98zS+ao4vBe3TP5rwZl2mJkbDQYuZq1Q/o3SWH5D/5cpbGxLJQrJLcCKvRx70U9buTyCELcLQj4nTaBRetapsqf8XRDVy9BgUpccue0JMN5aq1RPisMqh0hD5MkiHlAWF+ZJ4aWAAOobroUwFSjKDZcrO3Yyd6afCWc5zzAt5OswpJbMhXxzRXb1OU+EMjgapEA3eDkkAOB8wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnvN9a8cZ3thTbc1A9kyQNMOVFgl7EMELO6bAUWUfiM=;
 b=THtBslup9N+/2S/WV2QflsxXiOyIWJQLy+4w5LIeThuRCduKIY/A1ZgWPQaP8NIe/rv7VK57yC1jhuW7V6FJt0Heh9Hl4+XqacGsQb+s5xs3Imi74LxMOhVQucE642+rCqxDq84tkQNXjdFl+vLceY9Fl1guj1CsB2hEOlEzG9U=
Received: from SA1PR02CA0022.namprd02.prod.outlook.com (2603:10b6:806:2cf::29)
 by DS7PR12MB5863.namprd12.prod.outlook.com (2603:10b6:8:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 07:45:40 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:2cf:cafe::bf) by SA1PR02CA0022.outlook.office365.com
 (2603:10b6:806:2cf::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.16 via Frontend Transport; Wed,
 4 Feb 2026 07:45:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:40 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:36 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 8/9] x86/cpufeatures: Add CPUID feature bit for Extended LVT AVIC acceleration
Date: Wed, 4 Feb 2026 07:44:51 +0000
Message-ID: <20260204074452.55453-9-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|DS7PR12MB5863:EE_
X-MS-Office365-Filtering-Correlation-Id: 30343c89-1ba4-45f9-59dc-08de63c164f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Ui68l5r/pX0rKe6b7j12E6IEhWXi3/3eld6QPHs3wPfHtLjgsqaH5CltfOk?=
 =?us-ascii?Q?ALTYjLATwn94EpGcqiSFKcPl+lMCDK27HIeflQfj3U5w162irfmYgSbhEAJf?=
 =?us-ascii?Q?mETHoFi46h8wRFvnaNvod2MNyqayQSf+qXP77oEEFbxm6YsfwWnDS7wExImc?=
 =?us-ascii?Q?1PfKybP3EDUuZQS5KxneY1rmQJKusNTCNdxnFXDdnXQ9CsgssbGdzMsM3/mB?=
 =?us-ascii?Q?3hfpG9gZKuVgxkjRvVO8yE/FQBuBUmNQWX3/MW2wKAoW/2ajbeq3upVYio+j?=
 =?us-ascii?Q?dApbhow45a2F1g7TNqjJe93ZibBePfeVkjpZlhm2N9wr6owPzTclO+L+gbJp?=
 =?us-ascii?Q?KEwlJyGmYIObQThZYdwMSSCJ/mu3MmJILy/7gMREfqONWmRQJBEFQCA0oABZ?=
 =?us-ascii?Q?RBLgLL2UqgFr/bG8hkpiQwh57MpgAm0on6/G2S6UX6UOUuVeS87ruD9Z0GV/?=
 =?us-ascii?Q?XzxtrcbZsMxIYKuyHwzHJlt4LyZ6NkiHKalY8CZwg1MChlcFQYsn/wiD+aWD?=
 =?us-ascii?Q?hoZ+tEph29m5WlzKJXOVFyLXfrW+zVGx+pfoEy3iqoR2bOzPhSrW9JVXligo?=
 =?us-ascii?Q?1MxS8R6WZU07saQgm+E36KSQYIx7RBvikKoDbdthbG2zUzBncrjZkMGyl8W2?=
 =?us-ascii?Q?G4hZ0sR3LcMxvDnoMWWoTPyZbe0NRdyAirCbCPFo6b7UD8WvOvtrVJbRlB88?=
 =?us-ascii?Q?fyCLIXzEmWVhFJbksCAWQrZKeV2H0hjb3+SvIAXOBTv8RXqsaSY88snGdAys?=
 =?us-ascii?Q?faO458Uq7FB1f1mtmHUgHOVYduJzduZqyeLsWs8jtvOQfYYngYbyuyLPHhaM?=
 =?us-ascii?Q?TfrMMp0OliHKzMQ+ZlKHz2Kg5FjwGS4A0Jq+mQwHjJKBsD6Xh22rqRIfE7Rm?=
 =?us-ascii?Q?emqcXTI8OpekcAFeJnqDGkDD1fYuvPRPSmYiinvYZFmVWUhTfxIWLrnDJb0G?=
 =?us-ascii?Q?XK8DURx7Jmu5msHJYiVL9z0mc+un2Ei/ysJnrH5+kr3a3NExo3NEch8G48D1?=
 =?us-ascii?Q?PDLjVHaQstNggld+stS4FzEMtGfCgJIElP/nldAeh2GPBHbUuoazdmA2w5Go?=
 =?us-ascii?Q?DLxZZ0wVt9iMTdEHiq4c8pijo3WgID/hB05+c0/6uZG6xYml0SjAo/5BAr7g?=
 =?us-ascii?Q?XzCm6VxcWlxVUnfad7F8mXkUY8Yzrjl0zK/SlAog64WrO8P17LzLtrWJw3Rp?=
 =?us-ascii?Q?62/pZSdX4pDtbk0K2DH+fuqgdt8tjN721ueXcIBeDr4AQJg3SwKorl5xKzuN?=
 =?us-ascii?Q?yz8M/vlA2XmhLKGNGlxun6gL+v5EGng+Bh8d8SkNvfuww6Bh1kLEhKruNj54?=
 =?us-ascii?Q?CD6bs3sz8waDN2B7YbC3AUcDxCBkiZI4imrrR6Omrizc8I+lbzHnxuUsSxBf?=
 =?us-ascii?Q?2JQpJL0eCWa87+N/mEaFof7JYuFpAGh3uk0opwoqBx8Oi6WmnLD3zFmNap/D?=
 =?us-ascii?Q?GRITjtdDVNYs/7jDSObgr4QEv0rHbg5sjQx/KRmEu5mmtBEDVMkKpToR+umD?=
 =?us-ascii?Q?W2ogPhgQ2FdmKseYDqJIpBH/8T9s528wAzEevph9S4d9pqO1F7iUhj1Jf30+?=
 =?us-ascii?Q?bkIthWzogfGvHBWtbIyE+WeqEKXsWGx2AtoGj+Zr62i7rpR8ZPzkfuoOzuAz?=
 =?us-ascii?Q?/IR4xySkBjIFqTYu0PNjz/u0xXATi+BRZ3JeTbld20SVuwyVlgXkWxNuP221?=
 =?us-ascii?Q?cYWRyA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fXP29gAP3F48fMJQpOQWP2rdu9MZ2qGpeP2NhOo4qHDBlwrQHz4hSi+WlcwS08MfyP1WvjubL/1yygeOi+9GhXp58YuhS1lElSIj2BvWufTw0Iwpzn2K/2Mgg2Fi7LJY2Gv3iHsaTlKzhA1rDDJP32f32GJb/y8Cm9Zeel3LfrB3cH+JMGuh1FqrfpECQpxRZerxpVoOiiT25Ns0js2Eg8MoEDul6s3IhEMpZ9ufs+O37EXpGr+m95L1kwaf56eErM4XCPwBxnqD6KgGd9Wgdgu6Et/XIX7EbhciRYg2P6f2XfzDIsro5ia0vecalTVpa0LZaoaZ2CjuWncV3XdBYDsebg+UmTMs4lxVT0rB4d5dZL8PcyKLclcqpb9+T8NN2Ce82gbcIFTavHR9/qvPPWySjRRHYkNrXyuwFgaQRR7AzREfGs6b9vq+2q8+mk9U
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:40.6370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30343c89-1ba4-45f9-59dc-08de63c164f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5863
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
	TAGGED_FROM(0.00)[bounces-70153-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 15F31E2CC2
X-Rspamd-Action: no action

From: Santosh Shukla <santosh.shukla@amd.com>

Local interrupts can be extended to include more LVT registers in order
to allow additional interrupt sources, like Instruction Based Sampling
(IBS).

The Extended APIC feature register indicates the number of extended
Local Vector Table (LVT) registers in the local APIC.  Currently, there
are 4 extended LVT registers available which are located at APIC offsets
(500h-530h). Future AMD processors may expose up to 255 extended LVT
registers.

The AVIC_EXTLVT (Extended LVT AVIC acceleration support) feature bit
changes the behavior associated with reading and writing an extended LVT
register when AVIC is enabled.  When the AVIC_EXTLVT and AVIC are
enabled, a write to an extended LVT register changes from a fault
style #VMEXIT to a trap style #VMEXIT and a read of an extended LVT
register no longer triggers a #VMEXIT [1].

Presence of the AVIC_EXTLVT feature is indicated via CPUID function
0x8000000A_EDX[27].

[1]: AMD Programmer's Manual Volume 2,
Table 15-22. Guest vAPIC Register Access Behavior.
https://bugzilla.kernel.org/attachment.cgi?id=306250

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 81f7b3b91986..52882d794b3c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -381,6 +381,7 @@
 #define X86_FEATURE_X2AVIC		(15*32+18) /* "x2avic" Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
 #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
+#define X86_FEATURE_AVIC_EXTLVT		(15*32+27) /* Extended LVT AVIC acceleration support */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* SVME addr check */
 #define X86_FEATURE_BUS_LOCK_THRESHOLD	(15*32+29) /* Bus lock threshold */
 #define X86_FEATURE_IDLE_HLT		(15*32+30) /* IDLE HLT intercept */
-- 
2.43.0



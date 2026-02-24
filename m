Return-Path: <kvm+bounces-71640-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id c7PtNFbqnWm3SgQAu9opvQ
	(envelope-from <kvm+bounces-71640-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:13:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F89618B180
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4C985312A25E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A13E2C0F69;
	Tue, 24 Feb 2026 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tbnjjaRE"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D322BDC1B;
	Tue, 24 Feb 2026 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956178; cv=fail; b=FkNrIdx/SwpcTn/0pIrxGlyQ2ZcibQyuEEWRO0stPfPEB1OZDq8r6B462KpEAjkTR/zyoODUuJPKr5ktA0QhTHlMmJBdMvS2ChtWMP1PTjKyyxiDAvGj6l/F7phdUEy4i0NWyr/f01yj8iX2wHWENdKImtPXpk1QhjrYVv50CNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956178; c=relaxed/simple;
	bh=zaXbjq4mtARusu1csw0kvpq5okBZhUbkcCNtZz6TDHk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FO3FtQjBaRyI55THqiH15xvFDkpIvsfwbBGzv8FoqFMk7plBF+OQ6L5U+ajijCaj9Z9SO/GhweUY9EcGNneFoL56jP49l+eW8dTbqhDU2a3tygjAn4OmPTWXskSs0XXjfMTS9ef7DBLAonOW9iTvI3GoIeXJ678N8zG+tuEiHNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tbnjjaRE; arc=fail smtp.client-ip=52.101.193.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ogYsSH+3PkzHS8X8pxt0aSVqFCqW8gfY/OwMOKyJ014MZQfWoy7Q3lxMeMP1NAqZY3ztpeT8ghIo8nc9OmnpGjZ3rg2rpx4sOaIl4Xe8I/fcAGqA9BoqXA9/53Oe/VfuXNbKnE/OwkzkTo5WJnES9mYaz7Gaw4Ntrr+j/6m2g/Bg6pljsVPNp2lxESCapxfqlAGWB9B74I1nYg/vN+RhbFp7gMqvZfwdVp+IsZRkwD4B3x8om0nt7Kc5EKPXrGSjApLQpfaib0dGN/5vrJZ+PTW4/iQwefWhJD2oT997gNV/EUJqYthcGDqBy1UOyLAZKtiWu8lgvqOvALPXjXavqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaO+M+H17Rg9ZGjPSsN3VVzsUoyC0KEne62dErKCQFI=;
 b=U+lfBqQYrg9iXTnBftps9qNkBuWgdf29fHPYN3X7BnTThM8+mIjdKPun2lC84kRyHzUF9ywCzjkwhVsFkJg3KbHySjKX/vHhN6qdZaZPacJlH7eOZaCPQlEGw7MTazq9GblqsZJIxBxq2Q2vhfRLyujla442rrYASDv4XwXfn05wAibszJOnTHu3xpIXKipfKvBLdMt2dBSC5iml9k4+lHKrjTkIXEQoA7UYlqeEj4P6J70x+VxQPD73HgR8acjdw1DlxXWX1aPobE155iaeo7YPhpDTu+v2VHrWirj7qHtENaIe9oceT/5pkF1ftWZJaOFMAVEeTP2sC15wa+D24Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaO+M+H17Rg9ZGjPSsN3VVzsUoyC0KEne62dErKCQFI=;
 b=tbnjjaRExpphERNwbQowELLhurJCY0O905/bO0c7glMy5TJmL/KwNe2Ns5Pyn7BRLRbp/0vxw7SmTo9N7z8mdZQevEe6J5Y69y67AWHXbc1oosQi/ojiBUuNyBJ83C+0xM/zCmZbBAnhNORzvgLtcL/zJXLJAjkQI2YR3ZPEcYQ=
Received: from BN0PR04CA0070.namprd04.prod.outlook.com (2603:10b6:408:ea::15)
 by IA0PR12MB8693.namprd12.prod.outlook.com (2603:10b6:208:48e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 18:02:52 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::12) by BN0PR04CA0070.outlook.office365.com
 (2603:10b6:408:ea::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Tue,
 24 Feb 2026 18:02:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 24 Feb 2026 18:02:50 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 12:02:49 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "Kim
 Phillips" <kim.phillips@amd.com>
Subject: [PATCH 3/3] KVM: SEV: Add support for SNP BTB Isolation
Date: Tue, 24 Feb 2026 12:01:57 -0600
Message-ID: <20260224180157.725159-4-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224180157.725159-1-kim.phillips@amd.com>
References: <20260224180157.725159-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|IA0PR12MB8693:EE_
X-MS-Office365-Filtering-Correlation-Id: ef3edea9-4d4c-47dc-9bd0-08de73ceecc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KpBnSk4paXZJID6rphy4KUP0jVJTLwDp0x+mwz2dPlVeOErNUs74xkXr3VuW?=
 =?us-ascii?Q?4DWPHYonHrGT3DXslbAyU0KUvfizFLnkpsx3qwTtH1hXjkeULTpbWz6YPn4a?=
 =?us-ascii?Q?mN9rJJdRLI9O1/xMbsbMrw5Z30Pq3mDCxGVNwicfI9VWV6eLCJiYjLklFArD?=
 =?us-ascii?Q?KEVIhzfTqOL3VQUDF+MDFE1cPJtYp3qPBx0Y0v8SHOn9Flji9J3Nv4c/NklT?=
 =?us-ascii?Q?nQsFybfhpTLcrSIq+YXFLLlBlrdw3Wy9zTgWhYiqmef3oeVjGK8c6X0GXEnp?=
 =?us-ascii?Q?+NS77V3gGfCh6tiXocL+u08BLDBxu6hyVHWodADw5HBbLZ7Zq0b9GNOLdglM?=
 =?us-ascii?Q?ISDT60KHEMtXQNZ18vQiWlWNVUVc8bMgSF2Mk/Us3oJz+uX9Yyn2Zp6PmCQt?=
 =?us-ascii?Q?+4Qb0bMO8pvJsSHEYJ8As1NmePoBkGkxDG0V3c5haL3AV49ihogz0zNQmYa8?=
 =?us-ascii?Q?UqKIl4LT62iQF7P/IwAfDex4ltHGAqL7BHlJVvAPYE5d7NB1v0KSnDNWnT1H?=
 =?us-ascii?Q?cj7H9elToSsj+sjq6QYjhp5cTDumZLERdThWMF1ka1azP1a8j66JRzvEkk5C?=
 =?us-ascii?Q?iHyE9++xI2Qn/oiVHYD5zs3zxeKHcfBv/44tNbkAlBL4UA6syji0V/YqqeFh?=
 =?us-ascii?Q?JBf1z1eiNkyzFEkLJkcqZ7/1AoUp4DYrnUN0I9YEy9y94YlU49/Pq39MGzpk?=
 =?us-ascii?Q?ZgbexcStkO3mKKnr34fjHxgJ1zGTmRfeFM7b17dEZwgtKuvkxKyxq/tEtyAA?=
 =?us-ascii?Q?afIc7qyZRQWBY7NpOEDMh5Tuuv4TG4gbkaate9zkFZz4TMoveJfqaJAgdU8c?=
 =?us-ascii?Q?wCxQlDfh5Fq5W7Q3RS1nV8iRc5NtRctWmMn6E8hvUNgjmHKL261e00V58G+/?=
 =?us-ascii?Q?l3e3B8/Wjg4sno3YiSqez+Oed1hUfa6nEzSmU5bd9ndgADxZXF5RALHNF1nl?=
 =?us-ascii?Q?boDjM9W5mNh/767FsTtfZ52nJa8PEV31xEEtLJ93a45HIWYTV77RVHaDqp22?=
 =?us-ascii?Q?Vbvpy90+jlWbNGcVcnNrTAxJpLD4XcSbsBpU0e7A7W8RmX4BPrkXBNQObajP?=
 =?us-ascii?Q?XxT+++Ob7Dcrw4Cz0n1CTW2aBBR/oER2YwtkQIhAo/Udiu8OIWXI28IOu2Kl?=
 =?us-ascii?Q?wa1qjqOz7jLfXAih7b4qRRoF4cERJgH678uhnfUgiw8oFFc+475Pu3LuACjQ?=
 =?us-ascii?Q?6caoKUBN7vtRSiK+5m0aQeloIyDDi2iSHRWD7G5tscQ46pOoiR73qb3JawXI?=
 =?us-ascii?Q?AmqSru5X9IVCzLnkTLlY3H7Obw9WVSnI0pnDoxWwJLvsNejKutCy4Y8Rv9uu?=
 =?us-ascii?Q?8aqTXeI5kJwwrq/nQRK9wOpip0QJPQt3FwjpAf0d0YFI2yUojC3LeOi5ynZG?=
 =?us-ascii?Q?ejQ12G3SogR8HJvwztCYRqKY2xOtkyKidNX3JwqsM8qi0Fiqhjeu0yC31rYu?=
 =?us-ascii?Q?1fMv3+nPUR/f+MDLyNrIubYtnWDStAbiMNJFNMypIWmlDJ5866vu+uAmFMpF?=
 =?us-ascii?Q?CfnN/LTnj0P4KGyy26x0t/DHA18lMn7sg9wLhe6Gi9hDHAf73r8cyjt1ukgv?=
 =?us-ascii?Q?g36Vd380FnucJ+2fdxT4AnoE/tr+5hWozS27GSxYJbEFKufjB7sLbAvm7olm?=
 =?us-ascii?Q?hFAD0fYaw4RmcafEuDw/qc+bDORQVg1Sk+WX7THLol22iL5JAmldiZJo0OMx?=
 =?us-ascii?Q?A0+fCw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gtvcl/qdeZDB2qeFMD4CXWerLlvCIrXBGatoIWWwYdLUxlYfJmJqk7S2EpHdgqmHBqehRoErELW6NnEswJEn39v+UrqTSxUnyUU/fJibrfrRXX4QG8QhS/Bxj5YY2tAoxd8ohZj00NZZk2mjTe3m6yzvZVe09QqGiY/j1jhqolNJCHS3ydJhlNKRRfD6WtmLj04IndA8x/OFk+g9wd0sStUTaIW2lc5IVmvUz/votLrbEZxJ0L8yHg4TGqGrAZwqOuyOuTSjQSNoSdRmCJeBad5NglJnYNt2fH+jNLUMs/+zr5vzSglj0hYLueR3vrjle8S1WPe5/a1Fw/v/SRwKfBcn49OqNmrw5vxq4+iKhz1aVSy9cvDw8PR0lyvEJZIWC1ryH5U4a4+pW5XViBDkZJIeyVWuBqvztYIY+iSVsLxUHsLBSP33Qh/uKIiNOWRx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:02:50.5786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef3edea9-4d4c-47dc-9bd0-08de73ceecc8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8693
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71640-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6F89618B180
X-Rspamd-Action: no action

This feature ensures SNP guest Branch Target Buffers (BTBs) are not
affected by context outside that guest.  CPU hardware tracks each
guest's BTB entries and can flush the BTB if it has been determined
to be contaminated with any prediction information originating outside
the particular guest's context.

To mitigate possible performance penalties incurred by these flushes,
it is recommended that the hypervisor runs with SPEC_CTRL[IBRS] set.
Note that using Automatic IBRS is not an equivalent option here, since
it behaves differently when SEV-SNP is active.  See commit acaa4b5c4c85
("x86/speculation: Do not enable Automatic IBRS if SEV-SNP is enabled")
for more details.

Indicate support for BTB Isolation in sev_supported_vmsa_features,
bit 7.

SNP-active guests can enable (BTB) Isolation through SEV_Status
bit 9 (SNPBTBIsolation).

For more info, refer to page 615, Section 15.36.17 "Side-Channel
Protection", AMD64 Architecture Programmer's Manual Volume 2: System
Programming Part 2, Pub. 24593 Rev. 3.42 - March 2024 (see Link).

Link: https://bugzilla.kernel.org/attachment.cgi?id=306250
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/svm.h | 1 +
 arch/x86/kvm/svm/sev.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index edde36097ddc..2038461c1316 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -305,6 +305,7 @@ static_assert((X2AVIC_4K_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AV
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_BTB_ISOLATION			BIT(7)
 #define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea515cf41168..3c0278871114 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3167,6 +3167,9 @@ void __init sev_hardware_setup(void)
 
 	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
+
+	if (sev_snp_enabled)
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_BTB_ISOLATION;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.43.0



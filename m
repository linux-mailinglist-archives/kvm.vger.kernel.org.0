Return-Path: <kvm+bounces-70111-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLiKBBd3gmm+UwMAu9opvQ
	(envelope-from <kvm+bounces-70111-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:30:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6889CDF467
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:30:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 212DA30DE6C6
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D9036F411;
	Tue,  3 Feb 2026 22:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sfmF5Uv9"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010014.outbound.protection.outlook.com [40.93.198.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13AD34C155;
	Tue,  3 Feb 2026 22:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770157499; cv=fail; b=BIvzSDIiQts6l73MpNq4Rxgh+cRFJBzOKhH9lL2bW6RSnBY5tChmO899HF0DevHGy4Rl7hOnbSac3UFunQuEmZCNfW0Q5+3pMqGsMELpjZGoTfFa/WB2GXUPrecidMQ8wbW/4U0XpE8D+j9AImKPonf6Los++gnSZdcI1TrYGm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770157499; c=relaxed/simple;
	bh=EWQnw9AB+GS8J/7D6qpflPOCOQm0u4QtrZd1HKLJoZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nx8aGIhJI8iKchWMfUX+RDFuvdAK32gPfIdrQW0Z5VPvNHBy11b7fCEW6dd96NEKeAIv0ATEPvLFk6+zi5mrqeXeC83k8qqWUIucvmo1CG3SMRhHESTBhhCKNeAXcvjLVI2R05Q9k602+v9KcJsFlKnHf6kK90mjVfD0G5CmEnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sfmF5Uv9; arc=fail smtp.client-ip=40.93.198.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BnKztzruFP9sJhkt2B44rm4q89RTDQecAGSuZO/1UtzAm8LYVYnVs3xRRmPfcQOKZH6Lszn8OpYaWcpdmWypaBr36WuQ837XQu14jB+P6tdn8kGR71/0vR28hqTHvGGOexRhWHZHaS0TcjYbGGe94UeqaeSnhYf3epnMzr0Lja5IHHKoclb2grJByAe4Elr0VVYRXu7tZMZPl4gmVNDxJwZm8gXMGPQu/t3j9kBXwuJq8DD0r8EiDoQHR/b2Zzizd1p/7R5nJLkpJWM48GEcLOShk7X2N1dGm6/A7fPysxF8q5bBbUkJFfMGtsl84FhhFsuPgwGr93pHtMButpQ7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuQhjSd0sArmdk7egOGyAeGGHHdvXdL63v6JOdw5YA0=;
 b=rpnYSmxmUz6fLJefrSNEbnLxppfhqThZVRq7tNLgXUJCDXsct5TvR5zrjWP+BKdxNWEMtkmiJFdVHEGDzLqh0Sq91T5snIIiPUWpbYNoWZtJjlXTvxxUG4wa90IezUvwkL/fd75KIlKZNPSgEoXWqv51UCexf1SmRyml02uEXN18gmU3R+i8i8VrnXgpb7dHVMio70lFM9S/DYFe/7/CmKg8GGT6jXxnEh3qHUmSqFkXwmED/4ou7I40Vmq6Poa4DLt99SGlp3BKa2x72soxhr1y0m1vrsRupCmF6uIzMZSEShDAyPQK+5nSFRbgiBQfw9NJ35D5jSRmdChYw7IzFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuQhjSd0sArmdk7egOGyAeGGHHdvXdL63v6JOdw5YA0=;
 b=sfmF5Uv9ztzYMNwqNXozyad1WnLlCKG7CPrbWlnHvPNxAPItEDMI49D9K+PgF/znCpFR9DSiv7KJ4mATZ7j0nIERSglPoUxjQ9X6IKHbclLu2uYm5i5KtHHZ0E21HZ5dsMRvgzyFsXpKsAu5JwClrErpUlnM3tVQydpkWd20QaM=
Received: from CH2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:610:5b::40)
 by DS2PR12MB9637.namprd12.prod.outlook.com (2603:10b6:8:27b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 22:24:51 +0000
Received: from DS2PEPF00003447.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::40) by CH2PR07CA0066.outlook.office365.com
 (2603:10b6:610:5b::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.16 via Frontend Transport; Tue,
 3 Feb 2026 22:24:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00003447.mail.protection.outlook.com (10.167.17.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Tue, 3 Feb 2026 22:24:51 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Feb
 2026 16:24:50 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Borislav Petkov <borislav.petkov@amd.com>,
	Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, David Kaplan
	<david.kaplan@amd.com>, Kim Phillips <kim.phillips@amd.com>,
	<stable@kernel.org>
Subject: [PATCH v2 3/3] x86/sev: Rename SNP_FEATURES_PRESENT->SNP_FEATURES_IMPL
Date: Tue, 3 Feb 2026 16:24:05 -0600
Message-ID: <20260203222405.4065706-4-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203222405.4065706-1-kim.phillips@amd.com>
References: <20260203222405.4065706-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003447:EE_|DS2PR12MB9637:EE_
X-MS-Office365-Filtering-Correlation-Id: 61bc72b8-3093-4d82-6c35-08de63730cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ig2hvlrKdAjwoCjN9p1LpYigOHNckVzXTQw7NAHGDGnlh4iIe+zJANU5zoe3?=
 =?us-ascii?Q?RF+NawUP8vMPXxfrbHOKfqlMNUZcwwxAYfniwUJFMaMTC0D+/BVgODUMHC3L?=
 =?us-ascii?Q?Uvn53tJRghiiddE7gLJ/Twy+WR8ZubURh2qryrimTZemIryQ0pYcUqVplXvy?=
 =?us-ascii?Q?ABTKpFdRM/PpueJPvHeKh6fWonxRodYJnKnA+FlY8LHoLimUiSiQgLdiCBZZ?=
 =?us-ascii?Q?rtb+sQNIvTD2Pl1TVzG/j+rOaMpMmR3O5f/uDal4WGCZrDq9wOi1fBF8feGc?=
 =?us-ascii?Q?O3Q9geOsMSFKm6LTrvgfQ10SeByw/9V2poAjB6mXZfxuBkjDlxVEPXSg03MD?=
 =?us-ascii?Q?aiesWhxK8sUPPV01IVbtJ1Tu2FfnSMG5GpZSmds8m7Wg9FZJD3K+PXTnNrxN?=
 =?us-ascii?Q?QxNkyHv90cTTRpsu4QADgLzgvdKmdDrKiPnI3K2UWrDAeY206RSp70o/h0F6?=
 =?us-ascii?Q?oyR7X7LF6PdajpdDrLeca3y7TjTh78zBJeYSTW90e6TADbrh2eDzaWYftFKn?=
 =?us-ascii?Q?Lwcx4SMP4P9Ql6phwXuWSUmeYsJ4YwlxnAuEDQNGoWHyCzniUM7owVYJrm68?=
 =?us-ascii?Q?6XfXQXA6QXvxtNEcHnXcTmQv6VziyrqcE8neMKKiUuqAkUrHGYz8cAsGfAoB?=
 =?us-ascii?Q?UFWKxUqFHz4Zz4iQUaw4fzir86JdzMw21P0QyTUXcUCe53vcu30NADAXuvNY?=
 =?us-ascii?Q?aTA0GJIGyPQPQelyXc/g4+RFgRchqxAs18T1004dWf4hno5aPUvgk0AKxVtb?=
 =?us-ascii?Q?/odddzol9LExMMIgElTFZkm/beZ+SVFRsv1h1DJOCUhGsyPbBW4KtjFHLv4C?=
 =?us-ascii?Q?25UqhWBDdgXUXG5CQurAJ2ngL2328iHCPoW7JCynWKqWTXtFTRW09g4iKcJH?=
 =?us-ascii?Q?eFhRWhpB3IZCHTTGqYMvL+E0fwlAov1LAEyO3ZRrl4Xy0adJKwnnFPUumMTn?=
 =?us-ascii?Q?m/st4V8EnRAChG5oPehj9ZsmDYRp6BUwzjSg+pE/tVYh9RyNS/1nFFifSgBN?=
 =?us-ascii?Q?BDhMajRVia+sOx1PLlOjPvokqzYVhy+iErl58RJG412dzBkY1+wZ1Df7AOWG?=
 =?us-ascii?Q?LbmFQbkLqS7RqjmjwvjgcTWH6pClaxmzUQ7rD1cjzLp8D6cSdHsLjZXyzKp2?=
 =?us-ascii?Q?Nokyuf5i96agECJDiaeDX29hX4dIAoU7FCf8AKGU84KW5flACTJRoBSqdA9u?=
 =?us-ascii?Q?LB3JwWggSW8/CPQem0e0Ann8hCCBdTPX8HIzqco+ebq/Igj0z06OrpJWpg8t?=
 =?us-ascii?Q?Vm5LYb/HJnBjS86j1JanlzH5DfHD5HqSO6TpPJ29dQydOQFjQrpsZuvxJF2o?=
 =?us-ascii?Q?YDxhwQ7vsiFTKVXFXAASp/FqLNdWCBPR2hiARuiCoxGFR36gTe4qbes32G3L?=
 =?us-ascii?Q?yv0nKxIQY7GsPob6TAoEF0gh++FZyrREqUTQ9/9pt3VPfLgi+R4DHNaoVf0E?=
 =?us-ascii?Q?l+dqoCBXRk2CxnfqC9AD4U6gpQ0ChSLuMAuZpSfoOf4LYtlwrHvvzzDbUxE0?=
 =?us-ascii?Q?/IxoDoLo4FZMXu7tEOXmvG6SE7poTKvTdiBl590ouNmjuTd/8Vs1xS1qmt2j?=
 =?us-ascii?Q?UFrr0BqdQDIpIkUH4kV5QxKdDEzw4UYDKYJOhDXXMVbAnCA3B+T3uNuroDHj?=
 =?us-ascii?Q?4TTGdN28EwCHBQ26x3oMnrF+ewwzGiSvsq/N1elS5s5Ubf1NKEbs5gIBBcLN?=
 =?us-ascii?Q?gDWJ4Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4Di20PnnHiy79R5s1z+XNNiFzD5FaJsaPhlT22b7xIS+uxE1dgDQ+OnADnqR0T5jPGp6s8cvxlJAkkDa0zOZ/QU1skzNawe8OEPsA0eIrjSaVdtwoRnJ33vH1CoR2kzwv+bG0Pcnl7BhBGc7gd+f+acdbAsAiVM/R6MEprMSZektvSTyn8/ZFqzQnKQmc6VF+7F/ei5vf2YZmXTeXixYhTuuC1BckcjcqcGzgXmnSR9mOTBCHF+XUCjxyMkCvOc3mMasRPz5ynJYQT7qvolvdsuPNX9OgoFY2rBfIWH/mtMuhClRDeNMkPx/yRP1updv98ok3q9lR4LpQ2mdqfG2z/C1qDWqaF8G6IyxIlbh5eqZczRusV2k3HdJwfwMaUCwh/jXhRD6f9zcJLaM+OkA7wKGG0GwrDubjSM0bVAlNG9VXwdyZqSv5tskt5eAgSqx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 22:24:51.7704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61bc72b8-3093-4d82-6c35-08de63730cad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9637
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70111-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kim.phillips@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alien8.de:email];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6889CDF467
X-Rspamd-Action: no action

Rename SNP_FEATURES_PRESENT->SNP_FEATURES_IMPL to denote its
counterpart relationship with SNP_FEATURES_IMPL_REQ.

Fixes: 8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")
Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: stable@kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
v2: new this series

 arch/x86/boot/compressed/sev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 2b639703b8dd..aca5313d193c 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -198,11 +198,11 @@ bool sev_es_check_ghcb_fault(unsigned long address)
 #endif
 
 /*
- * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
+ * SNP_FEATURES_IMPL is the mask of SNP features that are implemented
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+#define SNP_FEATURES_IMPL	(MSR_AMD64_SNP_DEBUG_SWAP |	\
 				 MSR_AMD64_SNP_SECURE_TSC |	\
 				 SNP_FEATURE_SECURE_AVIC)
 
@@ -211,7 +211,7 @@ u64 snp_get_unsupported_features(u64 status)
 	if (!(status & MSR_AMD64_SEV_SNP_ENABLED))
 		return 0;
 
-	return status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
+	return status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_IMPL;
 }
 
 void snp_check_features(void)
-- 
2.43.0



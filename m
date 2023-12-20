Return-Path: <kvm+bounces-4951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A72F81A228
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6316288527
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162DE4BA96;
	Wed, 20 Dec 2023 15:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vZYsfH1X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A604B5DC;
	Wed, 20 Dec 2023 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISuLTX24Xy0XefvFKzgpgnQoKuWRC6ipo6lyUVgaRfZNbdp0Th9bbTU/zAn7pV7avCj1bndcprkUJ+ee1SvMNSy6ZHM9vTcYtV3Z4YBb2S2P/ItN4X14VsdCFW81WAsMbAXFHOq3X/86FWZiASBkv3/74xGEc/gq5ubTrdIx6Vs825K9SA6HQovslASROAy2iXzFgJRHTsKuaFiNGi8jakIIQAvQMQQs1kxY3OyJZrXOK+nXqgB9VYIomYCv9fJwkPPn6QJJJynU1YxfJ2dEFqJLplw9HcTwsx5PDtLCJ8K+xplbCcN4hMbpMtaan2/fo45GmSvCBYpeJaBniFt9AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xfYZQB78+sTYy1UJYLBgGq/OL9DmWtGkxRo5j9Rl4lo=;
 b=gBIPUaewKgZtlAgJBA5NANecT14P6sqc7pevOOSURkSfqA6RreluT1TRyPkGdh9D1Dn92raeSVGtQyyaeDjiD+r74pnIbOAZjS0twoECsD1Zq/BpMAcPTLUYLdHYcba/80xvaR/sv70Pl9N7MBoS0IVsodi31OZPmqQU1OkU3I3I0Lm1HHjgYpO7qHCb4SXkpNQIsg0ngUsDLNinE8fmltqlteApwKRtDurk2/W4QxOiCU8Y6treY5Hc/hR/yn2qNcBcqOrQiKGoAXctV7r+71rhUXfM+n6P8TvfVNmhxpyOfgEhWJD1yIogUuhTgiuPEG2iW9IGqe75t/5k51UT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfYZQB78+sTYy1UJYLBgGq/OL9DmWtGkxRo5j9Rl4lo=;
 b=vZYsfH1XhFK2Bp3kbcEP9/q1lExlun+60H9qvVlROPD53CstBHdJ23Ep511rcORN1MrBPSuPgstWVC1SrUtxbueT8IYiQF0uKUi0RnJAtkkQ+DyqdyUwNrxgW4HUZNXxVk3MSFd7lPkthugS7qvtYc+lfpn9XPWr/hOUwfNwOyM=
Received: from CH0PR03CA0238.namprd03.prod.outlook.com (2603:10b6:610:e7::33)
 by SJ1PR12MB6123.namprd12.prod.outlook.com (2603:10b6:a03:45a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:16:22 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::9) by CH0PR03CA0238.outlook.office365.com
 (2603:10b6:610:e7::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.39 via Frontend
 Transport; Wed, 20 Dec 2023 15:16:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:16:21 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:16:17 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 16/16] x86/sev: Enable Secure TSC for SNP guests
Date: Wed, 20 Dec 2023 20:43:58 +0530
Message-ID: <20231220151358.2147066-17-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|SJ1PR12MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: e0cb5b82-5134-49b5-b398-08dc016e9fd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	j77AwyFDbYQGVvMPx7MdS0QUBWg7dNSfTQpSoaNL5bymvX+eRIjuOnJ3SOrzxaFg6My+CtsthhbxQH03mAP2/T5FTDi2W6qzLk0QSiMYySJUpJTGoj4i+t0xeokWofmXFb3aa6tfL+0iXtDCHaXCoSG2GDGrWgxxwTyG3F0Z86lsTT6DemChzf3+ihof7CVAn3JXMsbxCg1+YruFYjhMqjNNs+cEQF7iBa+WJISAJxSkRZUDYKkUzKkBZRULkwwFvv1YHgsZXiZ5dC59/aa+5aX7YxDvwmimnTxbaIQ7CrD6i0GQ9tSekYvfPf08zBc8/J4eBse8PFPTBXBqRXpY75VptDEpYfskhqxkK/RCilxfYNElWCR4ZW9rgIDTnssPIfhQ9fVAggGr5jPQM/zp2wTnwz7OYtb3JLA3JjPH8u4MFPdEcFmMyGc1rYe5IqaCSXogg2GFnlAMmw/DHAK7NEFEU0eMjrqtdTp3jARfzjmRSHvgvF6Cr4bFbuIeM05SxPtVIlUzR/UZ3Dx/Sfl7+LwpIoXrPaTvfhy0SeTaKYyN+PtDj8nEkpyiFlHez6On8ahgwDQ6X5m0ksRwSNI8oAfU6alBV4RrOYQZGla9xumOv86rkRxRprdpKvUGcvhYicXvGjn6jvzj/hVQMCtbPHqeSveN7ziGpQ2CJNbQCJMiHi0HyFHoAYOFtKKHd2eND74IIyR38vt0G9Me1wb8VJiHYMva2c/Gt1C6p4nC2/QAJ0ZSq5oP5EaGhdPEX5kEbpg8O9KWFejXayzKxtvouA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(39860400002)(136003)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799012)(46966006)(40470700004)(36840700001)(4326008)(8676002)(8936002)(26005)(478600001)(40480700001)(2906002)(316002)(40460700003)(70586007)(54906003)(110136005)(6666004)(70206006)(7696005)(356005)(5660300002)(36860700001)(47076005)(1076003)(83380400001)(81166007)(82740400003)(2616005)(7416002)(36756003)(426003)(336012)(41300700001)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:16:21.8468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0cb5b82-5134-49b5-b398-08dc016e9fd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6123

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to snp features present list.

Set the CPUID feature bit (X86_FEATURE_SNP_SECURE_TSC) when SNP guest is
started with Secure TSC.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/boot/compressed/sev.c |  3 ++-
 arch/x86/mm/mem_encrypt.c      | 10 ++++++++--
 arch/x86/mm/mem_encrypt_amd.c  |  4 +++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 454acd7a2daf..2829908602e5 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -375,7 +375,8 @@ static void enforce_vmpl0(void)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index d5bcd63211de..b0db76dc4a9d 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -70,8 +70,14 @@ static void print_mem_encrypt_feature_info(void)
 		pr_cont(" SEV-ES");
 
 	/* Secure Nested Paging */
-	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		pr_cont(" SEV-SNP");
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
+		pr_cont(" SEV-SNP\n");
+		pr_cont("SNP Features active: ");
+
+		/* SNP Secure TSC */
+		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+			pr_cont(" SECURE-TSC");
+	}
 
 	pr_cont("\n");
 }
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index cc936999efc8..7ee0a537a22e 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -500,8 +500,10 @@ void __init sme_early_init(void)
 		ia32_disable();
 
 	/* Mark the TSC as reliable when Secure TSC is enabled */
-	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC) {
+		setup_force_cpu_cap(X86_FEATURE_SNP_SECURE_TSC);
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+	}
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1



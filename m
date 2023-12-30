Return-Path: <kvm+bounces-5396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5898207F2
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 775D6B21CDF
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA3B15485;
	Sat, 30 Dec 2023 17:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XsMawTG0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3515483;
	Sat, 30 Dec 2023 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgilluhkTl+SNUjd2PdZGmqWIv5YMuTzpyB+ElKPiXtPITYMFTQEm2zzBDbCQhBVHDEEmf+E9NPnHflLKkQJ7+wXWJMv0oyfOnSNAPIomNeq/loyZFOt8mssuGNLaBuGC5lSrXYTehYGi1/2Lgq0T8MqRvQSFEmcVqXorAdJoAiduNlhQCKH+t12m5FOD0bxHaZbnlxYXPuez1vXo38k81XJKHPH6YizVzuWNW2YaILVVsPq5lCb7ViyKaRORHsZVgBjgC/K7pwirKWrIwfMjsasnzS0q7KyVmdeZnnips20UXM0FNjoSFuqh2E+izoSLlWnu4HRZqkigXmOFEIn3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIwk6SdQbKgnArTaU2+dt5LmQsuI63XFRKexbmVvLvg=;
 b=cw6/MTaolaHUR5LJ8gLiB269bW9Y+/hXwph1bBeSr01mAoowbQaEOeCyf4AIE5rSDB36d6+4Vl6ZR6YgWY0YdKDLGs8fKf50jm2AH4+5gjvLesDzz3/aLGsC0P5qQhxWZM6uZH1+zL9q9Jsh5968TpZbIf79GFxrGAZAkKTe2XWq/gL23zqEO2+yA4z9RXo8heq5pZhCtZgqdZi6c3fNOgDoxxQWas01LJbkgVMzn3pYsdQ0CQUsvggLgTFD+kYycRD0YSvmgELwCVC2iZGkkPyWv5g+M2UqOT0EbN9cFJOyc0dOkCCEqsPhLcNmg+cGCGaOtlky+6jScr15K8ZY/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIwk6SdQbKgnArTaU2+dt5LmQsuI63XFRKexbmVvLvg=;
 b=XsMawTG0zOSqaYG+2PbG7pJwiTNuyRRCkLUbCm0iD3QThDBMwyqO0mdnzI25yQclNHtoFeB4jEOj27Y7BfD+edvTan8Oj5hqX9e5Ik+b6PYot2P7tgq1Te+R0c9zI0ACGYwfMEb+jhuOqXULzK5o2TRTPp9JgPGZnSDXTVURii0=
Received: from MW4PR04CA0082.namprd04.prod.outlook.com (2603:10b6:303:6b::27)
 by BY5PR12MB4115.namprd12.prod.outlook.com (2603:10b6:a03:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:33:23 +0000
Received: from CO1PEPF000044F0.namprd05.prod.outlook.com
 (2603:10b6:303:6b:cafe::6d) by MW4PR04CA0082.outlook.office365.com
 (2603:10b6:303:6b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:33:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F0.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:33:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:33:22 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 32/35] KVM: SVM: Add module parameter to enable the SEV-SNP
Date: Sat, 30 Dec 2023 11:23:48 -0600
Message-ID: <20231230172351.574091-33-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F0:EE_|BY5PR12MB4115:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bad581c-e564-4175-fb96-08dc095d6c54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KIeBUdZ0KOvrak0cKD9a4XtMhj+BtADQ1IwcUqSHVnomKptonprDZzut+aox9kbNgAoe+pAq/BqGvakCynD6xTFyPAVY3wBGGdJgYEWXcZOiCFGB1Unk3ZZNiWkGVoRom4ikazUem8lg3nbaRXJRfT8HBvD93hg7+7BYkcNb8kcik3ZXFXyy1ryDp7xDND+QOJn7OfUOOw0/ld8NlPXGQSED83Sqdu3OhwqutNp7ZX31j+ri0mPI1Vl/tnt0FXl/8X5UiNP+UUd2IIPHxr6d/ugLHMc8nmdUo150sfJbXequ8RTIUMRbcdoB4YJF8PSOrHwdj9/LUdhHyUVns7/1FufivA89H7sQAoYi4LmE1XFBDbqjECBSXJ4qL3hN7NGKMPDcibunI0cIuKVgyhHfMXkE8lEQ1X624uqaF0fDRE65jltcn0v5gS7C4XdffVYnoBjnAlVdaJrlxCUBaBJ3RMGfwhA/juYjGS4dCxysprOG2O/BgU5+YdC0JygSS+T5iqNWgPnKScaorEa3pZxaPfNIU8tKXHmO51HjKQ9FWoZ+qiqKt8nLQZWJmHgG0eVs3h4/lzKc86nDlg/s3rgq3dLl8oU0ON9pMkRU2p9cabse37YBLp+HhNtUWKwIaG/X1UNZlzEuAT+AF7dwBDH0f+cO93yjAXqfbF/HOlhAkFWD4OyNAoHsZSnnxUd7VoQcNfPblCaYiOhCvPA4TXk5yTFPJisP/wQdK04fgsqH1zqtpX6r+oEsVgSZyo5iqidosWkmU2rh+3h5FH9qlEkWew==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(376002)(39850400004)(230922051799003)(451199024)(1800799012)(64100799003)(82310400011)(186009)(40470700004)(46966006)(36840700001)(40480700001)(426003)(83380400001)(16526019)(1076003)(26005)(2616005)(40460700003)(336012)(478600001)(6666004)(47076005)(41300700001)(316002)(54906003)(70206006)(70586007)(6916009)(36756003)(44832011)(4326008)(8936002)(8676002)(36860700001)(356005)(81166007)(86362001)(82740400003)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:33:23.2166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bad581c-e564-4175-fb96-08dc095d6c54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4115

From: Brijesh Singh <brijesh.singh@amd.com>

Add a module parameter than can be used to enable or disable the SEV-SNP
feature. Now that KVM contains the support for the SNP set the GHCB
hypervisor feature flag to indicate that SNP is supported.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2cc909cc18c1..30a2e75fd94f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -61,7 +61,8 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 
-static bool sev_snp_enabled;
+static bool sev_snp_enabled = true;
+module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
-- 
2.25.1



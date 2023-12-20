Return-Path: <kvm+bounces-4947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0585081A220
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6FD8282966
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CF949F9C;
	Wed, 20 Dec 2023 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3G2EmqYK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C24C495EB;
	Wed, 20 Dec 2023 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOlOKAU1g3U8SybY8MNYtALF0RNhLLttPK2bjeMEP3SuejhJgLiEBC6bZwISQ88SVGf/x//7i5tW5zkx/8a6oQRetQJY95kiSVQ7aPb1s1VHWGMU8UoS5IT/OMcs+EGQDJcoM7tDhTLkkPtByw8aZtys7FRxXdW1d70ICMGasSqZDEoMXBoSfsXCmdmbAuO6ruwdUnVK8KIENyeW2pVosUWx3QFPz21WrWzAYkmsLjUsBLAWSybAn3nn67CUZW5UutTuLP0kPZZPnWCRCF9B8cFSf0DuSgg4h1S1MUu5RuFEmCwrQy7kIAZgwcsDZSJrSjKf3sPuhaoJU5ijFj/03Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQ/pi94Ahx0XKANbz4YCEijYP/GWAPG5vpISWCds3jA=;
 b=NXSTgKHkcirNvAool/Vx7BKY0hUXGHaj+4axjBzWUrhD2Cw2Zqrhcll3souuUUDG9q5B4XVYw9q16uVDvpI1pd+uXS7DNLTsEkx8VqkVbR3yqM8zFcxdQZTDOTOW1PNumpwywB64HfPGoIwm83JeGD51BBFO5ha8s12PTVdSUPNhceEyZ1IL4vy5p15pdX2IxyObfhwoAVr4mcqaEH2tQ6+eqs972wabfYcbdzLcw4vVfS3bnfO3BCDHQhVLjM/EgmrZlnL0Jx6uDFWPRGwQfIW7M2TouYO9ArI29edtA52cjYRQg6nJDP7LkTKQnoeSbQfwCtrPTgXCU5BlNZi2gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQ/pi94Ahx0XKANbz4YCEijYP/GWAPG5vpISWCds3jA=;
 b=3G2EmqYKKCoApKHzhiLIHQ84foLwVRTWMYTRby6Tit0EpKHp228xdoJScyFGITiUmJ5qxP5eYxV12h/UkvdC0tj6+B6tyIHRQO5uAH0IZL77uqyFhR1HTp1B/1yU4E/1x4ZtdkoI6O7xC0zrtvyJjMOnXEa6KaKwMXbDqwv1v90=
Received: from CH5P222CA0003.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::24)
 by CY5PR12MB6034.namprd12.prod.outlook.com (2603:10b6:930:2e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:15:58 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:610:1ee:cafe::8f) by CH5P222CA0003.outlook.office365.com
 (2603:10b6:610:1ee::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:15:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:15:58 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:15:54 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 12/16] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Wed, 20 Dec 2023 20:43:54 +0530
Message-ID: <20231220151358.2147066-13-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|CY5PR12MB6034:EE_
X-MS-Office365-Filtering-Correlation-Id: 51c71d1e-7096-4aea-b45c-08dc016e91d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/XiQ5QTcCENt+isWlQvDJB8TjSmZdiH4QeKv2/3jWbjovHm1jd660WYzYa9n7WCoJtyQUGkNkPyCitM6wuUkzqP1snkC6ia7WYstUQYXflOtzA2KHfeVWuJ45U7PmeP+sP+d4ROsaymtYIyHNuM2AeZKFithM8QTIfPnhHtagtm9djOFgnJHGmj5y7dn9QBqqzUdXxfZ2DltCpePed5EIWU9txW6l4iCPINA2njCJeHvs+eCTfjOUfXnePPO1BlrkCyhlZVw3C5MsmwwYXcrCyjgkydqWVQ2B1YADUX+8JcbkfzeX4VkP1LvhMYv/diZ/lpmdyTVodvPjd7mJmUvDV0jZX9UEzEpPMSVpyHaqEhlEfK021LtJ3f62sGBwIjLuaDau8XuPQQhGA+h72eetCnCMMrcvsB++NNrVVNAC2NcjwjxtlrE8GdtuHjAZ59wbH8R3TChPL8Plo5MpXx89w+exg0jt/xI/5wwwYMMnppvC+T4du87801kIdvHFpcGDBSa1n6Gg7j5YYmd+2l2QGIilnE4iclFlkLI5GZqI3hVFeB4IMInVaJCn8LtaAe017SvsPzQ798eN7sjKja+ohkZ5UoCZmEyKdV2fpNRhnPAGL27zPv1MU4+38nM7ZaRMbjsSJ9Gmw5bswktqHxZnfxUGdJJFaZObjEUaRSJ1Eri+zh46qU3Rm0BNlxn4Pf1VdaWjjsKHpLlWhGJydZXVX433ieEfl6yfg6js6swtFMtYT/8XeDlF3HHwIlSt5lhUHZ1mYmc0LQO/k8PKCY7vw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(346002)(376002)(396003)(230922051799003)(451199024)(82310400011)(186009)(64100799003)(1800799012)(40470700004)(36840700001)(46966006)(356005)(81166007)(82740400003)(7696005)(26005)(41300700001)(36860700001)(16526019)(36756003)(336012)(47076005)(426003)(2616005)(7416002)(1076003)(5660300002)(2906002)(8936002)(8676002)(4326008)(316002)(70586007)(70206006)(54906003)(40480700001)(110136005)(478600001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:15:58.3365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c71d1e-7096-4aea-b45c-08dc016e91d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6034

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
instructions are being intercepted. If this should occur and Secure
TSC is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/sev-shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index ccb0915e84e1..716aea6fc90c 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -991,6 +991,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cpu_feature_enabled() is not available when
+	 * compiling boot/compressed/sev.c.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1



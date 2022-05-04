Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3585B519854
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345607AbiEDHgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345593AbiEDHf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:57 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF5423BFC;
        Wed,  4 May 2022 00:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvmStNU0/w/472tFA6yS2Ab1dUYFCHmSNdvcClINCPvTPHJHmfo0RJ6E2WK3kLlTC7vuKjyVLg9Q+9V+jfTMRDCPz3h8h/nZTdPsPzkZw6ZUD+rKgfPGvLV9NDro+w5IwjVrS7lWV3iQZ/YdXKJrsiNM2Dfior+2+ihnCIJ6D92OkZBt9LulovpWcvXE+wPRRJ+QaHAuQwveGu9nYAFdoWRvSESRFkP3sK2nvEtNpki8rZ3DgEQxN0Vs4DXkOfdLWR8GT7bouW+LjFO1E1nhv2CXEZnqmX39Ho0NuVaKXBFBfaQZ8Xt+fT5pbM581Fu/oNz82s6hLMNe0kgIxA5+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zc/of3Lm60E7G+tiFe8ILRpuSFGVZhuCnkP2zfuapQI=;
 b=hRdMCEDsEYFNyLQZlUc4wniNitUQh7S915q2yKyTaE0xzJd/aFmxleHUuQsk6uTzJckjVq80beGDVig/WhIYfoxq7AfNU1M1fHR5SU6kIUevfFL37+72t1C8ttvFVY2sGfWdPuT+V4N384qHhIEQDz3XebRviEzQXAwgl+JwsYhZpRb8/3jZp/K8cFCEhzLUEuNFxUAcpys/q+cMk5O4KGqmgAwakFcv5CpIQ/cCy6NctlV2bmL0FVG4zbo1cSsbhiRzwR33bvarrgsouamPpvVp29GvqqVROCfkPyCALcCGdfaUH8asxCOzc7bs2zu+soF/21f0r1P7crlnQ5djAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zc/of3Lm60E7G+tiFe8ILRpuSFGVZhuCnkP2zfuapQI=;
 b=DXAPJNG77SEypsXQjLttGG4Ykhd9/IVxb9PDjEzZ7EXC2LMO8wXdVJBex9Ijgy6F9RqLLkxehRGgVS43w1YgoYNuJpBSrULBOujxGc3xKCpmcCOHAhRs9ChpNJL2BldA55Aczeyq3AFA/YbS9//Dy1IS9lV2OkhQM87KC8J7/+8=
Received: from BN9P220CA0016.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::21)
 by CH2PR12MB4971.namprd12.prod.outlook.com (2603:10b6:610:6b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:32:03 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::7c) by BN9P220CA0016.outlook.office365.com
 (2603:10b6:408:13e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Wed, 4 May 2022 07:32:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:32:02 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:55 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 07/14] KVM: SVM: Adding support for configuring x2APIC MSRs interception
Date:   Wed, 4 May 2022 02:31:21 -0500
Message-ID: <20220504073128.12031-8-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8142eacb-bb2a-487e-b3c4-08da2da02ea9
X-MS-TrafficTypeDiagnostic: CH2PR12MB4971:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4971E4F06CEC4F1AB30CE90DF3C39@CH2PR12MB4971.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1GDg649dbpbceexquCdI0FNOXmiiTRn8Bpqy5nkLZ8VTRzSvx00+A7kyQFsgywx1xwkXZGLlF/QXl7EAZg791cHrIfi8UAUSHvHuAfTeaeAMrhe6Op36V7m/CseuU/th69jRX0dfpSQECdJIetOw/fmuD3pXngnc4dQMPb2c7CjecJyq5eyv0c3DR7HMwpZDJqo2K72jiSAos0bSJIGzIdVqmNPU3d0/FP1t+Xh962tCdoRranWOrQ1/MPnFIQoqKsNb2t9qZdW8Jzcs0upTRFl8Cvv7w/avyb1qk3sZ3kTZIR4xi+I4dZq4ZGMqTNSoycwAMoHYEJf5EWEBqq0VOeUSDmLtJ2fkjwvtwO41HuJv+TbE9KJo6wdtiOq4Zzl9xMGANBsQTsrQYqo/7SaTYAPKYO0xFPQj5+H7YQRvMHxatUlYr0396ywWMbJLb2eZy3zvxRtR4a1LW1fdAWDUyp2ccbyVI5Tzlmna1NWDdPUzDFfJwb8f3idaCFz8e1/s/Rt6BAVfbzdznyhwsHlC7DdVC9i7l4FAIjPPQzjGwMlV0nJC+9zd9p0YH+Thxs5olK65e+K10hg9rUiD3Tk5GgZaHwXETNsff+AMFWswLBni2Q4NJyLayjox/WMoQQeNM+uUvmCGU2242LmcFHFI0pUwoxYMSAjHwvOyCM+hgtUZqlMQh9AEXnaezZ5wlgHfr3dx9DEXyKR7wuIEQpAQ5Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(7696005)(6666004)(26005)(86362001)(81166007)(356005)(426003)(16526019)(186003)(336012)(40460700003)(47076005)(1076003)(2616005)(5660300002)(316002)(83380400001)(70206006)(4326008)(8676002)(70586007)(36756003)(82310400005)(44832011)(2906002)(8936002)(54906003)(110136005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:02.6456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8142eacb-bb2a-487e-b3c4-08da2da02ea9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4971
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When enabling x2APIC virtualization (x2AVIC), the interception of
x2APIC MSRs must be disabled to let the hardware virtualize guest
MSR accesses.

Current implementation keeps track of list of MSR interception state
in the svm_direct_access_msrs array. Therefore, extends the array to
include x2APIC MSRs.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/svm.c | 25 +++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  4 ++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 74e6f86f5dc3..314628b6bff4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -100,6 +100,31 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
 	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
 	{ .index = MSR_TSC_AUX,				.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ID),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TASKPRI),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ARBPRI),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_PROCPRI),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_EOI),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_RRR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LDR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_DFR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_SPIV),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ISR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TMR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_IRR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ESR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ICR),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_ICR2),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVTT),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVTTHMR),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVTPC),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVT0),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVT1),		.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_LVTERR),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TMICT),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TMCCT),	.always = false },
+	{ .index = (APIC_BASE_MSR + APIC_TDCR),		.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 678fc7757fe4..5ed958863b81 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,8 +29,8 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	21
-#define MSRPM_OFFSETS	16
+#define MAX_DIRECT_ACCESS_MSRS	46
+#define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern int vgif;
-- 
2.25.1


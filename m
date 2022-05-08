Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FEB51EB06
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447125AbiEHCoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387771AbiEHCnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:50 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EA6BC01;
        Sat,  7 May 2022 19:40:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuDBED6nr7fm610OEpYXYwbgzKwIgeiNgRa5YHt8ZMJuBqeisrjfw3BOxHkNWRhYWo260LD0IMC071JsCGil32iP1z5sM/FIZe6KfFUibIdhyJpkhdnNb53G149IprHX4dAjZaqbY+1KU9rvvUhvp5d57wnh0NnbYwaKwVH9COqYHMl4FEU/Bun9bBDubrI6qfkUV38At9aotlYU36SAWpJnI34fyUE1ZUF/7oNyz6NkVNN5X4sUnD7R/DO7VFsfOVOE84PB36Ja7QmgMqzWV9bTQkhHLWbYeQp2XPCEBfRW7JyATnF2zi3ESHw8LAiEs0h8KlgExR55aIVOGz+NEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1EWd7qOvSujODRJB0SJIKRkGJZFqi1Z3Dk6MgKXteI=;
 b=bWN2EpIP8AcaQVg0AOPKwAVkDY5Zwc5DAxcsqpLZu1E84/li+s71F5aVkhwGCaDze0rsqMXDypRSaQxSDub/ctyzBLe3OMCfKs6WM+15YEtP2LQ1037FmwsXMOZGMWAwrPSOhTyYkHnw0S6V3SD9VN1GGdXa8GOHOSckD1qyIlLTlZVc7S2V30JR4j6zBcUTbZ4xcqLLSe+9mssvyyO3rOf4hkTXRKM4bxLwWT3fSO8OqDFvF5VaPdGKtO532Exl+WMBv1Duq54I8J5YEoycmk2Rzrs3kfB+ayIyd6ZWNjQWfHjG1+6BNSeE5APBKdHf916Fgk/lXOtUo6VECYCJdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1EWd7qOvSujODRJB0SJIKRkGJZFqi1Z3Dk6MgKXteI=;
 b=WYAqLjUZ203dcs4NuCkh7TOs+7xL48j3N/vOf/Hpq7CzwJ8QZRdiRA4G6PNraHsjmS5g1dESkqL5F0gBqVomRnauUOg/eJ5C3hGBqwVgC1W4rlpIWEqQ4qjsc2AtfYX0j+cBwTr43OhaCP5yb3zikB684u0OH/xtYEJ2M3c0IbE=
Received: from MW2PR2101CA0008.namprd21.prod.outlook.com (2603:10b6:302:1::21)
 by MWHPR12MB1616.namprd12.prod.outlook.com (2603:10b6:301:b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Sun, 8 May
 2022 02:39:56 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::bd) by MW2PR2101CA0008.outlook.office365.com
 (2603:10b6:302:1::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.3 via Frontend
 Transport; Sun, 8 May 2022 02:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:56 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:51 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 07/15] KVM: SVM: Adding support for configuring x2APIC MSRs interception
Date:   Sat, 7 May 2022 21:39:22 -0500
Message-ID: <20220508023930.12881-8-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8812e2d-d551-47a1-179f-08da309c09cc
X-MS-TrafficTypeDiagnostic: MWHPR12MB1616:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1616F62621800344E89F6B81F3C79@MWHPR12MB1616.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QwiwPfkTlN2uZHC+uTEwnpdMQ7CYelW4YxtO2chrJRwVH5MJbTV68TmusQmlWh8pPWCXWb8/DSiS6xYKUQOZrxh1WTRIQvL6no5sPNyQb0N3rLfv0fEi3UTps9xLfJ/Xq5NnX7AmbN7cX+jbiJkZUsx/zL49f9+Mk3oAkZeOiXItgOBgXxhDOxlpa6sKVsoVuiGKymly+/wUTrlIcKDcMAyHfPkbflu4JIoWePgq+l1nfEqx+IwyE+EVz2OSdkI/5JFWSo72qwRRL1iQS9MJdKrMeyWnIdu2lgMTEtfQVyB4IZLfT2Q7wAyn4BC9fONlVisavl39qfD4qBpMIq7Ij/CNEsgr6GavkhaYsKXbMyHR8UAN78rCU5MqlRl+CAcVx9MB/pOqlCx0omQEco1zYca02+9jntOQg+i8mLPBuEPOPt/spjQmbVBJEpW4Rm0K7BeKYgOkmKdCZAeorgONy0LLQ8z6+XX/C4zq8uFLbrllXPtM+mAnYy/1aDVw6WA4yySn0asS+wyhhalCW/qqKm2JPv11u+wX7l/R+2zNeMtmdlEjaJ1HxEVTnBSJ8XtMHBI4rI4ki4BqpIpDeaKkpxol5MwOjo4FI+526KPsdRK1tWeG6O36B+ADEJXHLe+iq2eNpyf1OCM8uGwKrgbpocovCc92Qvsg5i7v939gCThgiWDFl/67UFjd3urXC1BcFYwPXVZi+KdhFq8v3J2v5w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(336012)(426003)(47076005)(16526019)(70206006)(186003)(8936002)(44832011)(36860700001)(40460700003)(26005)(83380400001)(5660300002)(2616005)(4326008)(8676002)(1076003)(70586007)(54906003)(110136005)(86362001)(508600001)(7696005)(2906002)(81166007)(6666004)(356005)(316002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:56.1873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8812e2d-d551-47a1-179f-08da309c09cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1616
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
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


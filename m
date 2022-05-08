Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BE851EB0F
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447179AbiEHCoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388364AbiEHCnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:51 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC1411145;
        Sat,  7 May 2022 19:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldZbLWnRo1tIok3JWqsVv0vO0L73lSg28pXYee+nz1nGa7wYpSt/NvIC6orQIjwcBHbKL0Hs7vYgpDgyrEJAVAkvsFDAUeFLHztQsxbWkBU97ATjY7wsw1GdaonrPXDqMEf69Pu+Q8nchKbpRZleG84W6voz22/tbynQEVSC+uiYknwwdLzrWGx+4aYONUbNobq1ns6BlC+2BUc0NjYjESdg0XGfqNWeDgWD3vYTAl15bUrpxRCNr0mVwWpPixWmjAChY7gFy81HYP717WxG3HnqkIanROX6w+O1bqmA5jbChDDeBU+PG4DdZLhEa5kx2Tj0ttsaYG+E9tke6vyfNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kWfiMj3CgwjsfTcDfxBxeC2fqR7gvCkxTRMOLyLo660=;
 b=SVjwF8bhokkyipoccbYCFY7HBhrEBGAkUDzYiM+TX62FaJM9XTI5NMET3KtoS035vrGHLkYmamAWPVwXWMZDn7MtsViut5oX8uMZf3DcJ2ZTL8m6m2ph1u5LXJDoEuHhDv0QKBtGhR/aInuEbhbh/v9h1V1ypiQkeSO2jMCA7DUB9UUa8+ggy2qIaSfO2r0mkjMCrcEBoy7LjMirIqXBCfky3YNdPmc8TyPPYYPoGKc2IsuaOl9Npxe/usjHcpEOvLkb3gNKAylzgaLe2QfW2O7Z1UkBS47HAYTGxdeRt9tF8R/MwERERTLwuEZA9pOJwnaQLFxfliBvjak6tfNMuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWfiMj3CgwjsfTcDfxBxeC2fqR7gvCkxTRMOLyLo660=;
 b=LPjIzxmVSknOI3Ng/aR9qKxXMLFwk7ghtyc4eHrODVA62H+cbdDLIwbLHPL4hSLfrT0ex+pN6DMCoVN5T9vn97eo0bk19bUKl167bl+LKwYmdoOq47P9u9euyquAqb2ubsDasz9wmXJ7P9BNQ7ZJPo0NIMUrG+fPfW2xiLhIQxY=
Received: from MW4PR04CA0040.namprd04.prod.outlook.com (2603:10b6:303:6a::15)
 by CH2PR12MB4086.namprd12.prod.outlook.com (2603:10b6:610:7c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 02:39:59 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::6b) by MW4PR04CA0040.outlook.office365.com
 (2603:10b6:303:6a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 02:39:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:59 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:57 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 15/15] KVM: SVM: Add AVIC doorbell tracepoint
Date:   Sat, 7 May 2022 21:39:30 -0500
Message-ID: <20220508023930.12881-16-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: d9a47484-1524-4355-ee0d-08da309c0b9f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4086:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4086D85BAA2F5AC9381D86D2F3C79@CH2PR12MB4086.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4RAj5/2fDpEyIMTOAIeromFTYpdN80snpftpVHyGHdhAAKc9WihtV4Mg69x6lbr41s5RmgiX4Zv51Ej9IoQ0GceHvthlDfK74p2TyCGDMF2WFBQUUU0N1EmeUfHJC82HSUMD1v5eeLciagp6MhnXnPY+jOsS/BJ4felzLVP9Rbef5hieEAsxFQlJOAqcLbmq3fwP6gkmo5go6B4X60VTsXjgPA3mE/fZAAcKivAghtwBJIsdxskPDvxiz1NvpzsQ/ndWhRmqNphW7QjWKp9lKHV4yofuc3espw5MPVrUqJhEFVuz7PRB5XhpGXLCILeqyQ1zxBgrhzxRUrTq99CECYB3USpMNpxg7+S28sg1JBBCmRH+CvHoaPPx4k40JlelxPQCL7Ta04TNbb2TIvYKbQQkEfJ4AzcJZGobiCT9xoliiHgxevBw9ciYmYp/m+BTHBnN1s0HgHdzqzvSpHeD4mTS/nOToQFSgUw3mQBvdD0Lhr6kXeyVldYvFzSKpNhKQpwmi4goH5SYunjJr4wzKK39IQyhuG2moguUrdJFyuNSo82lcohV7X54FdGoVoPUJON/Il+//M8b4fDEadfUlt4wp86Qid0ua/8f0HTvske1IsUGAlc7mSoiv1muRLQQDOzTnYKm7+TF+ldZzFr3KDMnXx/KDXYfsNg7p+oG1CemORNXA4hHCB3X6SQRTAWMYeu6VZuea1AkjwzloIdbQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(7696005)(26005)(508600001)(356005)(6666004)(40460700003)(110136005)(82310400005)(54906003)(36860700001)(81166007)(16526019)(1076003)(186003)(47076005)(426003)(336012)(83380400001)(5660300002)(2616005)(8936002)(36756003)(70206006)(70586007)(316002)(44832011)(2906002)(8676002)(4326008)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:59.2533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a47484-1524-4355-ee0d-08da309c0b9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a tracepoint to track number of doorbells being sent
to signal a running vCPU to process IRQ after being injected.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c |  4 +++-
 arch/x86/kvm/trace.h    | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c      |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 617dd4732a9a..2e59dbe29f79 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -345,8 +345,10 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 	 */
 	int cpu = READ_ONCE(vcpu->cpu);
 
-	if (cpu != get_cpu())
+	if (cpu != get_cpu()) {
 		wrmsrl(MSR_AMD64_SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
+		trace_kvm_avic_doorbell(vcpu->vcpu_id, kvm_cpu_get_apicid(cpu));
+	}
 	put_cpu();
 }
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index de4762517569..a47bb0fdea70 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1479,6 +1479,24 @@ TRACE_EVENT(kvm_avic_kick_vcpu_slowpath,
 		  __entry->icrh, __entry->icrl, __entry->index)
 );
 
+TRACE_EVENT(kvm_avic_doorbell,
+	    TP_PROTO(u32 vcpuid, u32 apicid),
+	    TP_ARGS(vcpuid, apicid),
+
+	TP_STRUCT__entry(
+		__field(u32, vcpuid)
+		__field(u32, apicid)
+	),
+
+	TP_fast_assign(
+		__entry->vcpuid = vcpuid;
+		__entry->apicid = apicid;
+	),
+
+	TP_printk("vcpuid=%u, apicid=%u",
+		  __entry->vcpuid, __entry->apicid)
+);
+
 TRACE_EVENT(kvm_hv_timer_state,
 		TP_PROTO(unsigned int vcpu_id, unsigned int hv_timer_in_use),
 		TP_ARGS(vcpu_id, hv_timer_in_use),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0febaca80feb..d013f6fc2e33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13095,6 +13095,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_kick_vcpu_slowpath);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_doorbell);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.25.1


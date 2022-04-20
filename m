Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0479508C74
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380340AbiDTPxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380211AbiDTPxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:53:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F2E33359;
        Wed, 20 Apr 2022 08:50:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQyZnCUuqvH6O2bTyQUbPeV1TWJpAMDVR/WaCAShK7CmJZAL0WEzej+JpVNg2mwYxgF8xE0tTzqySUP/kLEwYdQSad7CeHd+Bxjuu/HBIdSdOJ8tJysALZpQzUd+rUzUFmnncu3JWkS0flEmkzWies0XdnnUGEGSo7sMHrZVusvHfMyHGGm5S81zkJkXrMCrHdB7iNetT+fx7ttBowNyviX84riwrVlXrkq+qCkwCGNOlkUtaTkNQU6OAzs+5qAj9w7h336E2v6VRCA/h/iHkRM6UqM307ViNe8JxQabwxQ/WB3VXUaqJbMUMXzBuyrRbK5fHBwvgUR9HiIjRW8Hsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFBJKynoFw5waANKbjnG8CQPQ2CJoQn6GvO9g2Hza8I=;
 b=Ojuv/EX8hcU3BWC1fJzwarzJW/wjq2qQY1EDWglzFoz/6lZinNk/k6U2NTEcavwp1blbXMauzixftQsoTWeGedqaItjudWuqs2UIL+H2phUgGOOmu5JJYRph1VjN7NjfF/sqfIAOUJ7xad0lFbp6tCJ2PlSTLZrj4txdnzD2cd6VwZb0rztpw3UMpLfiNE/Js3L8Rkhwga1A+DyGTp8r8dQD2AoKH5ApeNh6XVHodxmxRlBTbWIWOkeP6QLcVr86ylPYZkiQMglXG1r9//2oQ+sC5qYAbrUSomHLzzjI3VOdBQmLtMtmmWFhWQedSSDFa09YvSKzLURwJaYdmtTEfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFBJKynoFw5waANKbjnG8CQPQ2CJoQn6GvO9g2Hza8I=;
 b=kWfWq4HOHC/MfAAbbEYea4LGzhpexyuyiru5e1U54lOqUzxlcQm50Igs1KY4sc3lCIQM7CkJFUCnrCK+d7NwhuhesHJdGzxPxFXilClxo6ay9Rl1lWwP9h9xa/SgEhKw68OieXBqkNn+0z0Z0/C1eGpbskvOf5OIpgYAkk9uE90=
Received: from MW4PR03CA0088.namprd03.prod.outlook.com (2603:10b6:303:b6::33)
 by MWHPR12MB1168.namprd12.prod.outlook.com (2603:10b6:300:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 15:50:18 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::9e) by MW4PR03CA0088.outlook.office365.com
 (2603:10b6:303:b6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Wed, 20 Apr 2022 15:50:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Wed, 20 Apr 2022 15:50:18 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Apr
 2022 10:50:15 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Introduce trace point for the slow-path of avic_kic_target_vcpus
Date:   Wed, 20 Apr 2022 10:49:54 -0500
Message-ID: <20220420154954.19305-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420154954.19305-1-suravee.suthikulpanit@amd.com>
References: <20220420154954.19305-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6df3fb5-b319-487b-ed16-08da22e57809
X-MS-TrafficTypeDiagnostic: MWHPR12MB1168:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1168A7B1CCC49AA0DDF1806DF3F59@MWHPR12MB1168.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LIqnrpd8vg1q7YGHngohc9G8dHIbGasXtM9gkzVk8s+EaE/D7FoGuMAH4bJwnxLeqmPX+Tyfp65CaU55OraSF7SsxsscIXpbmmmsy/FpFISCFwr053aUdTRaNmUhkg5nOTs0ipNSTKCMOshatAOPhsxSzXmWN9D5Q6X1ksa8UOq92S/0piirXsMr57xxrPz553wHL5NaFHpGGtwl30L3z+NItwbVJTrviMsiwtYCRJrnxYkbVRvAO1Et9UeWtj1Rz/h1nqvlr8XoOZd+YnrvF0UyTF2giaXGfXMs2u/VE0j7CReqj5WlaD7U3uzOrZ5Bsj12MwO+SRGUs+jHJkR90A7RNjcSNvyOqV8Zty80qc+75GRAWn76NjStqvdj1pMzs+Ms7L6PMvr2mlAPcZS4Lr9S25V3Lc5vnKY95OnjF6giyysrJbztidT43yMNG7YjqamfslUV2SaVMm3TyeR8CQ4X4cY67fkiKRVh8kRtaBcla7iycbitZOK7CqbmFdB9JHIiS7zwsRCcxm2M2/9lDtaoZMpwpADEeuKMKm37XmctfqGwJFcaudIVUkRMnqVnliDhOSRkedATcjBVh9grlU71BvSvEiUjCS1Fhcqf4KrRa6bh7by5UuXoRsnMCqXu2txGjk7tMIk7kwzzQyeyylWH9PxaB3dbVvYmhWnuR3sBvFQP4Gx4SmeG8N2KTPxN0CvW58US2IKfdWbow0Zx5Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(508600001)(40460700003)(7696005)(44832011)(6666004)(8936002)(83380400001)(70586007)(70206006)(47076005)(426003)(316002)(1076003)(110136005)(36756003)(54906003)(2616005)(36860700001)(8676002)(81166007)(336012)(4326008)(82310400005)(356005)(86362001)(2906002)(26005)(186003)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 15:50:18.1399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6df3fb5-b319-487b-ed16-08da22e57809
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can help identify potential performance issues when handles
AVIC incomplete IPI due vCPU not running.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c |  2 ++
 arch/x86/kvm/trace.h    | 20 ++++++++++++++++++++
 arch/x86/kvm/x86.c      |  1 +
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c8b8a0cb02b0..c5b38b160180 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -355,6 +355,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	if (!avic_kick_target_vcpus_fast(kvm, source, icrl, icrh, index))
 		return;
 
+	trace_kvm_avic_kick_vcpu_slowpath(icrh, icrl, index);
+
 	/*
 	 * Wake any target vCPUs that are blocking, i.e. waiting for a wake
 	 * event.  There's no need to signal doorbells, as hardware has handled
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e3a24b8f04be..de4762517569 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1459,6 +1459,26 @@ TRACE_EVENT(kvm_avic_ga_log,
 		  __entry->vmid, __entry->vcpuid)
 );
 
+TRACE_EVENT(kvm_avic_kick_vcpu_slowpath,
+	    TP_PROTO(u32 icrh, u32 icrl, u32 index),
+	    TP_ARGS(icrh, icrl, index),
+
+	TP_STRUCT__entry(
+		__field(u32, icrh)
+		__field(u32, icrl)
+		__field(u32, index)
+	),
+
+	TP_fast_assign(
+		__entry->icrh = icrh;
+		__entry->icrl = icrl;
+		__entry->index = index;
+	),
+
+	TP_printk("icrh:icrl=%#08x:%08x, index=%u",
+		  __entry->icrh, __entry->icrl, __entry->index)
+);
+
 TRACE_EVENT(kvm_hv_timer_state,
 		TP_PROTO(unsigned int vcpu_id, unsigned int hv_timer_in_use),
 		TP_ARGS(vcpu_id, hv_timer_in_use),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 547ba00ef64f..d90e4020e9b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12980,6 +12980,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_kick_vcpu_slowpath);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7188519856
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbiEDHgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345610AbiEDHf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E924098;
        Wed,  4 May 2022 00:32:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQUzBn9Pi3TexV7JfpTxJ1E2JamNEb5PMV1o7DXq8e0IJpS9XxxPEyJDFQnCjTtS61akRkqeUty1pDJO8Hv2c/MzGS652rvhRG4QgCAfLSurcmXxknyJCS1HCoUn9nzuc8ALt7UmdMebQYYQxPQ5m8itD+SeR01YI3+eUJ149G1cwXZLV8LzmTHxkBPvIClM1Yk38HZTHcFOoscJYW1NfNi4qt4p4o0okWxDI4b09PvFv5lzuNJB/K7T0w8vVN4Jwr4BIG2BOHXXcYJUnDv9Ks22hmsPVpnUC5zoIsZC4CtO09cW400AVE0/L5itmsFFoCvRwjwXvtbWiqf5+UpwbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4I+63+Zt42XQgKSkYTJdDXHuGGSUiSP5mh9jvyc2YI=;
 b=M1MSYhk7f0rgxxXW9Na8SLKQic0gVL3JXko5WQWy5kG3GlhS1Wau6R7dX+tOgXSd1jVxUvJqAmrGUFK5yKfV8l67YghhtUm+16Ecx8wzrUzaccvF6Y8x4BwL7qYvLT/dp86IjBU87jR8ihhXZnxES1IHrhid0fcw3TIUlTNGP9i2tjg/uR33kthseVkyV+wWldNb+htShkew+6bz5Ci8isZzxvs68Io7nPau1qtsvV0qovaLlPi5XDuVwtH8sAq8uE4Afq0kkNP5z6HtBZqyJwsl2PKBOyMMRnjvrDlq3EYauv/Cnnn1vf/E0fPQEKeGfZ/SyEfEdxPk3bvaYJUMUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4I+63+Zt42XQgKSkYTJdDXHuGGSUiSP5mh9jvyc2YI=;
 b=mAOusCr9Dzb6qEsYSdiVyRTK/9/a+B8DD0gftfWcVGuFsCSZIUAyOLqpfAzrf6/C5L3UM6qLh34PiZYKAYniS9TfZaInob5hGfjbhqpJyA2of/AtEByvuNXPTVTMlOVzm3t00VFGBW6Z2A/gyeXHaHooElesP9aYA3zIn9JC44A=
Received: from BN9PR03CA0420.namprd03.prod.outlook.com (2603:10b6:408:111::35)
 by MN2PR12MB3824.namprd12.prod.outlook.com (2603:10b6:208:16a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:32:08 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::ee) by BN9PR03CA0420.outlook.office365.com
 (2603:10b6:408:111::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25 via Frontend
 Transport; Wed, 4 May 2022 07:32:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:32:07 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:32:02 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 14/14] KVM: SVM: Add AVIC doorbell tracepoint
Date:   Wed, 4 May 2022 02:31:28 -0500
Message-ID: <20220504073128.12031-15-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: f66c16f0-6930-4fb0-ed90-08da2da031d7
X-MS-TrafficTypeDiagnostic: MN2PR12MB3824:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3824563C7100DFDE825C93F7F3C39@MN2PR12MB3824.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rrC7xhDLw08ldvjfXdaQziTjf4L6UJt+chZglY7SOvAbCQppcQL+O4yIZy0vLyMDglns8vcdIxLQE25lC8DyNzMykdifDLekc/AE5l8vXp1a+9vGLWO8xH7/X6/t77o8OwxQie6s2MqJdVurMeFm31qPuST8i0FGCdUir/pzlITOf4IRaMiDJ26ETx3G5B/J6o9O3L9aG9tmNoMyopsX8fW8gMb8x5ibHURIU4XnUzd1vF4OqXNORA3DhVlgqkmFXuK5W56zo3lb5EMzO4KdDbcdl11mAQyQgVexa7UJYqC2LuenG7JbJA1t0plr7sLb0aAKz++5j8FFslaAl8bGvcpaIeXHJ1bTo6sHlrl4SydoUqPrn0XFMBqiV7S7j+8k1fatKVGX3qzKCOjKN821k+0NhEIG6H8hhdL9q8qYaNF6NZX9dIDafytn0NiM3K3CKAhrJ5lCt9K0xXtUILk4Fq2F+Z65KcmW9aIRDddkIubdMnxRuQXZRIpiCD2MBogvqDTSahniS6FIII6wMEFNjXxbS7UPvWhXDNXtnVAFGEc4HMyyJvUwcNm/DBwWYFJdFtvgxmV4FD5xIYJHQN3PFUTXjMKBjymtKW8IwhJJOZdsm1WU55XryBMQhpUAMBFQjsTyLg5UMi/JZ6RAaXAMleTjYJkFv7PvhTi3JX0Rc1Ra6qHnRydSf3wFDuQ5wpR/GtNW2e2veIYcvC7sXA08gw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(4326008)(1076003)(36860700001)(2616005)(47076005)(8936002)(36756003)(8676002)(70586007)(6666004)(70206006)(508600001)(54906003)(2906002)(110136005)(356005)(5660300002)(26005)(82310400005)(40460700003)(7696005)(426003)(83380400001)(336012)(81166007)(186003)(16526019)(44832011)(316002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:32:07.9973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f66c16f0-6930-4fb0-ed90-08da2da031d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3824
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

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c |  4 +++-
 arch/x86/kvm/trace.h    | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c      |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a526fbc60bbd..e3343cfc55cd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -343,8 +343,10 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
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
index b14e02ea0ff6..69a91f47a509 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13097,6 +13097,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_kick_vcpu_slowpath);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_doorbell);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.25.1


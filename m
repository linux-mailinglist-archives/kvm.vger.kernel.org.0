Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C907852C07B
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbiERQ16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240203AbiERQ1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C331B36E7;
        Wed, 18 May 2022 09:27:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2nhJDVjZqVMRQ0Oschn+6xEo7gUWEzwQEdz9d34AeK5RyxsMWYuU55MPqHdaXgnzXPM4vm0GBzFv/LxdREWwnwWtL+KlbSObGYBjUk0P/lb2WlV8IgWuWzjostGZXSUXvoPr/d7IxujVX1TbQbk5wZlycHkU5T1mvMz+SK9Net0wR5DJv4vKviLLslUoMVJMjFF/LYCFRS73UjbvQ6RKWRLn/wglSzNfXI2Vkn4ftkl1bc8gOHjtS6rjZjw+4/1HP44GD9f66aT9j2G1jRmJjOq1ab164iGDPzrwhqb+88/6zV/5RKjenD1V69tRP1CYXs8Z90qc3kDYgWSYpx7zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/bvutB7S+dp6/W0J0zqVf2Gzw00JZ9rk2oPU8jUQCs=;
 b=jwelLzVlr1n1UPICqCyYtDHA5abGNq56M6Y5e8IQXx+8hxyNbTA6s5pBdxItGLnHocCj03VD7bPkGFDrSx1lADR58vhTuIhf6qUeVrtRAAJuImCd5z2tr9vobyYB3KhruzAIXHJc3WXcS63GicU8wUMXau0QFYI4o2s0J5ymxEespKP+OGgXeyxc4ncg7GaOrrrs+vQ+f2qiDNP5kCKlKVImAnO5ktp+7RgkXrCAwvoXfGDLmHTlKOphCd4eOWrghxkzdypJ1uCYagzFC9ZCiUMHLtJvq1IX3aCzbGOKMq7kv2zdpO8JT12RbGwOwnrZ9bZVSaVEpDWRlaMqWEnFKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/bvutB7S+dp6/W0J0zqVf2Gzw00JZ9rk2oPU8jUQCs=;
 b=YPlwkZeRWcbzeOCvyw8em72OVSgeMHf9OfHFMo8SOkoTlSVtsJOb5o1H8X98X6O1wy/p1goA1kJ9gz3DKZUzAwY0eDoPmfwkPn2oXo7UKCEdxEG+/KIeGPU13n+sdP1tHQUCcsUUwIZyjf47LK4hjlTxSKvWYvGITGIyk+mrqTM=
Received: from BN0PR04CA0168.namprd04.prod.outlook.com (2603:10b6:408:eb::23)
 by MWHPR12MB1599.namprd12.prod.outlook.com (2603:10b6:301:10::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 16:27:18 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::f4) by BN0PR04CA0168.outlook.office365.com
 (2603:10b6:408:eb::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Wed, 18 May 2022 16:27:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:18 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:16 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 15/17] KVM: SVM: Add AVIC doorbell tracepoint
Date:   Wed, 18 May 2022 11:26:50 -0500
Message-ID: <20220518162652.100493-16-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86d044b8-ebb0-455d-c305-08da38eb46ba
X-MS-TrafficTypeDiagnostic: MWHPR12MB1599:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1599E66FDD68F67B11AF9EA3F3D19@MWHPR12MB1599.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tpoOKDfQumVsDtLyr+RK3PjH2IuwCDr9DuwdC190JvOPL04g0p6oL648gEF6Ya2Qw2jyQ2YfGQT1UO9eh6ePt0EZgLWDMKPidqvPCCQOIY3CZfNEN/gO1kue7vj4aqXE11bhRejZKDrW6u8hlDCORLghirWr2MOJt3hfxA/Nd6gE3UrCGRu0AKvaQadVLbZbCAPhayGGas0mHf8MuH1HniivbQzgLJ1tYcpUiHHhMiiNCyH482V+T2ABnlKBFhT3Iy8TcuYHS7ca235aTS1hr1W75YbSPKGVwDs5UxuoVMKx0tKl096iabTjvWXLuTDEN8KKMvE9sG4WFf3/mxBFwVHQrhgQMQi0BAJuCjBsBIlk8PQ5zXOpnIBQT6AR3I6NNByRH9JwGbbGEBuJxqk5Q4kM7XwXvvgG8zN2rkgflf4NgjNXp0L6rqOolvb9lQwWbxYbpewUkkRRUgI6bLP2ABzMBaqxrWJp2LHFOQ7+VSzbwlirqbXq54YIhOswjX4vyvy0d55YfrtHl7r2OxbNf0oMHx3dB5i9XEFpgbESBmkGHbK7jEccQRq+DTY067RMOSHQURuTyHbiYR2acprYWLvvkZW0DxczvMRK1uFtPAwu+m8I+K0raNL8sqg4iQNVffcOXOdjYA6ZOAavJMOX/Qg/x4Lt4BQWr/tK+g7FAlQHEli2KXOJoC/xKic2XA6zdS8pBEBQbO13dU04uSmfTg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(1076003)(110136005)(336012)(36756003)(6666004)(16526019)(186003)(44832011)(86362001)(2616005)(8676002)(4326008)(508600001)(2906002)(8936002)(70206006)(70586007)(40460700003)(7696005)(26005)(356005)(81166007)(5660300002)(316002)(426003)(47076005)(83380400001)(36860700001)(54906003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:18.0836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d044b8-ebb0-455d-c305-08da38eb46ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1599
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
index 9c439a32c343..2a9eb419bdb9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -324,8 +324,10 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
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


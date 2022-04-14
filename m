Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A95500559
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 07:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiDNFOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 01:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiDNFOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 01:14:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9F0C0B;
        Wed, 13 Apr 2022 22:12:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJqQfa9+Hc7PqgoK9RfhautsA+ait2TUWq8GgXsCgc/rsl/d7/rnvlArGxj3eZ6/8lUj3jhvaBcpPi+gp5+m1iyCyrwriUj5hOmkkduHx/j8e/TdzXMcUPP2wNsfClFdXIJlZGtVijEn0W38DfS3L021f4AqwqfHXAVNz1tfP6EJlYwd6+nhDacXZT7Fh8+eLKKsbO9cs7E3neey+FiLoK11K7ajQQLuEcsA5uk3GPL4bWtVYxsnanNodXNeNXUfPBvIvqdA5z5zl/aSENlPuUVcvAEsFnVphYV3xUh6Tvf0MwrQejQflZrJYQu3Qv+/8Vp8II2PybpVwTQUvgaG2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWHEc1MqybQg+6/vo1n3OGs7U81LPhawi6vD8mT1icc=;
 b=DmEpzTsOL279KiDiImvYipKWxJkj42OIM5HN32yvva5p86lkbQJTuDEh1MPm08rnGuSdl1eDPyrwy+cnK3UZ2KSwcfm6opsuA+289EFWn+DiMXKrlbkk+uVNGyZk8BjTf09W8cGzR3lEMAf1aU4QvjdUOaHeMJlrV8sZGIxW+eNM/RJZgzjj0kh3E/PABpgi+cznoyNE67JTdcK1/rBAB7jrucKPRd21JbHEBgxXqszDWYPUGvA/FDTBqdtzDqoK4U61agUnexp0c4EFrcQX4VrsExiRdqJBoWps/1aK1vrKHGuLZ51jXwOJ9V3etvH2dvGhGsdlaD2eXv2IYdpXww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWHEc1MqybQg+6/vo1n3OGs7U81LPhawi6vD8mT1icc=;
 b=IsANWC5oGxDfiUKjdGEGX1BOqjO15jAZyhzcvCqXw4CYvNY2luGE2uqbjqdNbze/7ozZHjs125dAIYGT+Bls9OWwLjTD2UeEnjJu4BsJvcWUsXuvkwXps0gF6ykBXj96lbUdtFStbDCyzdiDYOoBKWY8h2mvBfgxkuQhmhTRQ58=
Received: from MW3PR06CA0016.namprd06.prod.outlook.com (2603:10b6:303:2a::21)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 05:12:11 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::c5) by MW3PR06CA0016.outlook.office365.com
 (2603:10b6:303:2a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Thu, 14 Apr 2022 05:12:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 05:12:10 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 14 Apr
 2022 00:12:07 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Introduce trace point for the slow-path of avic_kic_target_vcpus
Date:   Thu, 14 Apr 2022 00:11:51 -0500
Message-ID: <20220414051151.77710-3-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
References: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d54e262a-cee5-454a-0d82-08da1dd55456
X-MS-TrafficTypeDiagnostic: DM6PR12MB4106:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4106C955452219ADA04BD4CEF3EF9@DM6PR12MB4106.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8WfdtbcT3a1xRxYwTn5XdC3E1c6K2m1TWup8UCjj+UMl5EZ1yA3lvqwS5+m9xJ0Se6sozx3FxjvzIRxb2hxv9rblAmCIQfHy+MO45k0sj0NlKeFU4OZ18u2EPZhT1CkyQ9FQiY0DkQNDjGvZB2m67QSQJDV9XJExGbK7EloxW7jeyJpsoVf7oKjhzOwvFkt35LimuVXhiD84o6dxMIHeEbXrjosXOncjW4Y8oE4tkZI+TsLaqjin/2geAQ7a1vLDrUyxF5U0yIJriYWELtkCzeYXM+Vju0naWOc8yl+rKjMSBInZYfOn8czDbne5S53IpzqZ3smH2714gm1s1QVATNxS40Tv8mQPBRjy+DQx51NWv0pEQf6f/J1gcnxaGWaDCL5/212j/g11P55cDWP35PqC13QExq5Gi/EtqJ+25Z/GPYczwNphYOq3soQvk/g4n5kDjUiVQlF9eNW+F9FUowtoO2zyN1B1IUCxhgJHhgbWCXBsT522/FOnHJAmTowCz482qcbz9sKx76AkL/pTYfJSREtJOCR6//Tpdu0fAFKO+RiJ3/VVbP3jlql/BPS6yhETlu3s2gZQxkcpL3P77pVfJCotp69BaIcb4pxB+54T9NX/6JvzbEJZZjPzSEJCviVdfkrJ65lqlf7Dn+nFnWsUYmQeIFWzsV+ERrwgeVWW92EGaWxjA6CQLavl1/CcpW8ECNmdA/zssG4ErH8u4A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(47076005)(82310400005)(8676002)(2616005)(6666004)(1076003)(5660300002)(8936002)(16526019)(186003)(83380400001)(70586007)(70206006)(36860700001)(36756003)(26005)(44832011)(4326008)(336012)(426003)(356005)(81166007)(54906003)(2906002)(7696005)(110136005)(40460700003)(86362001)(316002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 05:12:10.4480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d54e262a-cee5-454a-0d82-08da1dd55456
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can help identify potential performance issues when handles
AVIC incomplete IPI due vCPU not running.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c |  2 ++
 arch/x86/kvm/trace.h    | 20 ++++++++++++++++++++
 arch/x86/kvm/x86.c      |  1 +
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 92d8e0de1fb4..e5fb4931a2f1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -440,6 +440,8 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
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
index d0fac57e9996..c2da6c7516b0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12978,6 +12978,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_kick_vcpu_slowpath);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.25.1


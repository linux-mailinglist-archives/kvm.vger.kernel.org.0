Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314D94F5527
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386855AbiDFF1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452723AbiDFBQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 21:16:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4612D51589;
        Tue,  5 Apr 2022 16:09:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ob5UncKinVN976TuBnDGxckYRVAPum0EewsUXNcvrDXA9x6jy41g9FYpcQZBgwJFLU5pNhNDB3AmIvOOlK4H8/qxj3MLueDWxlXgaAhVg2R+jtNNPxzE3XND8Wm8vs7oda6icnAaRM0mF34pUhDt5I7KM5oHMfsxB30TYzA8piaNy5GjS4qtUXolnVYJ0ZwY+zq2z4aqdwwu2GRQDw9u6YnoDqAp7SN/ieJ5wwW/lnIQNTt09nNQWa/2wtikw+IbPwFKoDNKy9NKwX7rjEw4k2kMclmGF60UaI6EqUa4dEJgt+SCCguIfNzpLRBNWNJIExadMqMcSC3Y8De3lJI5rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2Gk+j53OtsXRzn9hOypudYw6u5fnXAtEpoxwedIcWE=;
 b=hf5vlDUfCEaRW0xakRTz/YqHki2P1won/K+fPPf8qOxKR7FJHBbwe2drbtKTfD9+7w52UtRj9gze9n0rlAsn6g5h2CzNQe3LvREK/XOIxjon8LnTgjTvBybvGzg9XrcGABSNAZdbs477GELcejfy8ueX3l+sMq3/ySkxhyDuE/A7LoaTNu2Pfsxp5sJOamMvIKVqpbgOXgmSgGY4bY4Nvywkt1+tGrVfzeiktjJ3x4UR1jLdzwzsyx1maH4issWR3FcZ5z6J+CW5Q0To5xzzXxc3lfNTiig2WwiB7GTrLWyg4t8RL7cnIT0VJhqg2tLCQxk6B697jReglsEUqv+YkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2Gk+j53OtsXRzn9hOypudYw6u5fnXAtEpoxwedIcWE=;
 b=JuE2oqfWEuoOfSvUWLfOU/dfBqNV5ccob7BzGEdc/l9iz0MZuwlWIYBdClVo1F5YiHgCnDTLYBpumXFr+N/+dHUIAAqhx1nbfl4ns6f9cab9NHnxkUEbwguIWzOKPUkzN+8spMAZaRbBvWkhYlycXnDY8057jyWL+HvLHKJcrqU=
Received: from MW4PR04CA0082.namprd04.prod.outlook.com (2603:10b6:303:6b::27)
 by DM6PR12MB4369.namprd12.prod.outlook.com (2603:10b6:5:2a1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.30; Tue, 5 Apr
 2022 23:09:35 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::b2) by MW4PR04CA0082.outlook.office365.com
 (2603:10b6:303:6b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 5 Apr 2022 23:09:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 5 Apr 2022 23:09:35 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 5 Apr
 2022 18:09:28 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <mlevitsk@redhat.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <joro@8bytes.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 12/12] kvm/x86: Remove APICV activate mode inconsistency check
Date:   Tue, 5 Apr 2022 18:08:55 -0500
Message-ID: <20220405230855.15376-13-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
References: <20220405230855.15376-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cd80cc8-40ef-40a8-f1dd-08da17595a03
X-MS-TrafficTypeDiagnostic: DM6PR12MB4369:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB436965034F97495E806294E5F3E49@DM6PR12MB4369.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0+GqA2xy0kppnEuOpnV1EgHKgG90zwZXxemVuK8/IphGCe3zehqfxvkasON1mNIcyEufOWzNPQME8XwMOavW3ziruA0WieBz7KgCmbJlt2KA28n2LzeQrJYdQ5Ji3b2Mkj1ljtsHASnTjU1k1XoduQ9KN22isw2Nhp0bT2TJRHM501iUeeW86Bazl1TOhrGSjtMowx5TE8UxFaLRsUyjpl5P8E6VjeaM2QoD7a5fZ70R55e+v91jLeCwDlYPhrC+GeSfLSXJJ9KQSad0D11br9krA7GysHyTQVOLzcIDlavBEomIfuoKfYj220vFj3OW+HdfAoRYmrFwDT/sa5KBcC41bOO1hKMW4nEX5UKRtCPS3dW6UKu99x3oNhXcqu3Fi5BUCfnBBffOoeLtpUQJZM1AGQYNqxjnyUKbvfJ46XkSJKEZl8CkluGr/IJESB52TL7T7MyIaFr7mLmCiQCDVc2nuuG491WypOH59ppXLjHhI7n9lxguPVHaZ5XEBhzIfVlCoKEjjLeVMXKRns86tXDQDralAe+OobV1AKihaoB0J0c7ygKEz3dpx08K36vqvgs7ZrhbqBbi+Xl/61GMe6MyDGoU04lU45XWWWqnIpKVSEWIcV0S5xcKMxdtolpkwbn/FSVux87XJ6YZaYtv3ZApGsBcKR+yJwpN5jSwxHIoDcLjt52OWwOq1G4/AvTBB8mTAgmvj2WMAL8mLPOHA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(7696005)(83380400001)(40460700003)(6666004)(316002)(508600001)(86362001)(82310400005)(36860700001)(2906002)(8676002)(36756003)(54906003)(47076005)(110136005)(44832011)(5660300002)(81166007)(8936002)(356005)(4326008)(7416002)(16526019)(1076003)(336012)(26005)(186003)(426003)(70586007)(2616005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 23:09:35.3739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd80cc8-40ef-40a8-f1dd-08da17595a03
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4369
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When launching a VM with x2APIC and specify more than 255 vCPUs,
the guest kernel can disable x2APIC (e.g. specify nox2apic kernel option).
The VM fallbacks to xAPIC mode, and disable the vCPU ID 255.

In this case, APICV should be disabled for the vCPU ID 255.
Therefore, the APICV mode consisency check is no longer valid.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/x86.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb4029660bd9..56cecf5ccb63 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9666,6 +9666,11 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
 
 	activate = kvm_apicv_activated(vcpu->kvm);
+
+	/* Do not activate AVIC when APIC is disabled */
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_DISABLED)
+		activate = false;
+
 	if (vcpu->arch.apicv_active == activate)
 		goto out;
 
@@ -10063,14 +10068,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	guest_timing_enter_irqoff();
 
 	for (;;) {
-		/*
-		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
-		 * update must kick and wait for all vCPUs before toggling the
-		 * per-VM state, and responsing vCPUs must wait for the update
-		 * to complete before servicing KVM_REQ_APICV_UPDATE.
-		 */
-		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
-
 		exit_fastpath = static_call(kvm_x86_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
-- 
2.25.1


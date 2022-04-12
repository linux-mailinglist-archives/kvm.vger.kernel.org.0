Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063824FE067
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352646AbiDLMka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355071AbiDLMiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CD8237E8;
        Tue, 12 Apr 2022 04:59:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRWkG8N74NCtDpGhEyPLS0Lf8j+ZtdaMoHzkk/CLXRdw8NkUBlK4XkDrAxJOAv81t1EZdge8Gpa/zOY9MfMYpT1k6VynBelqKuf34OSFcSzG5W0zKeRB5wmB3b51oSq/E1TACh/PyNoCHwtdj2b0brNRT1M4lR8eoX+xG1yKa6PG9jVOmMY3b4HJu+nYf8dZYE8zJdTZdYYakSrBQJymDrWgUmEAGCGkO3+ycv3mrKlusVgH8NgWssQc6g9wNziIzpcyLgK8+i13rx4iww6fk+dQYjSxTr0DWpV4FzYdd+Vb8ASTgO0H7rMdXU0LTUwi2OIsUGXWEtdk9yvjPah0FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tROjBZ4OwaR6qvlQLq0OBQb8kaW/tfpzmLWrYNrG18=;
 b=Sf5f1KWQlPcXUgwW6pp7ya9xlVeIYfcOtDkBVQJNd7EpAw/HB/H2YQmkyI39Y1YqO2oE+Fl2OkUUg8LSJKkOnX4z6mkKR0eVsUZLLDhhdY2v+U4oVPOfOIZ8KdprttcnY6fN61rx3MOpTRF9bqMmX3QvoBG8yWVcYTQOxXNbrL+cJO5sxFqze6gBKE0Scxf3H1SoOiL4z3mRk4StAWYKeDtzFcoaoNkDEEl5lKPwwzvlU+xNi6R24EGfeM7IrXghIOR+/wMB+eT1bA46BB16Td+AqC1Yck1aAGu0KJRsgE4ZGW6YP2hc3Sf1+zq2PjiySvtTdqKDO6AKW+BZ4Lf5HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tROjBZ4OwaR6qvlQLq0OBQb8kaW/tfpzmLWrYNrG18=;
 b=meAK9JGMJQSUSyK/QNhAsLYDAy2TOz/+RZcdrSYMeCMmiHgdBD0f+s7dDZvr/4JCwltaD4rET9V0nef0EaWv1YWZHP7CpfZB/n1Hodbh61sVrmjc2gVgdSkqa9puqX0aoIhu93UhPpnG7+rMwJLIYmBl8F1Wynfea+ucAqAl9A8=
Received: from BN6PR12CA0047.namprd12.prod.outlook.com (2603:10b6:405:70::33)
 by MN2PR12MB4437.namprd12.prod.outlook.com (2603:10b6:208:26f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 11:59:17 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::35) by BN6PR12CA0047.outlook.office365.com
 (2603:10b6:405:70::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:16 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:15 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 12/12] kvm/x86: Remove APICV activate mode inconsistency check
Date:   Tue, 12 Apr 2022 06:58:22 -0500
Message-ID: <20220412115822.14351-13-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f05941a1-65ab-4aeb-c39a-08da1c7bdeb2
X-MS-TrafficTypeDiagnostic: MN2PR12MB4437:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4437C07CB6637865D259D6C5F3ED9@MN2PR12MB4437.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LN5SFd3X8gO4jjZJEkgz/+juc+VtOiVAgq+P6K0LgT9+9nFnJ2wub5lLyqR7GSAgIeNk6YxwZQtKhVMwb9RPqsq4sLUd7XpYOUtE2N+xrlkGednDPkNqqqln9baTq18Dhcx7ES0uidGeuewHggGKZIa2Usokd+JGUOqqRVjrFbAiZW1Jm3ZGo3V4WYfGGy+G44zHpYiUNzGrADYyblZqhzEODiuX131ymiYGYl1YDluRml3pT9dzQDc61xWj/MbfoEIcjzK0AxadvTfUsGns+fLQytfuY1RGx21t58qF6A5UEaL7xjn1ml5uPvlzyOBt5WcEtr8nCBGe9YH2FEnH9zOAz+GeNdN8ZaObDpXKK/+8HaawJIPjFxSe2InMLBRWKM375FIhG3dFTGUlueOQZSkcdJ8+K7c1XemaLLIQ/4fiG5uqI/IMzUqNbKAcRGY0ML6l8KgwP5avvVLVTG2pLL/83VKhHWTr+qsyFCwAmGv88SfKip6LriXnWxqN2WGJAFq5+Afux0OsuLW6BI00Vx/LiMssASWOqIxloFi7yT/nLFuDfQaFe6tCTk+8r3g5AP0ltMdEV2XiZa214GvuX1atMbxNrqL9/nrpjgFNZ9RpKfDwso2o/M7oO8rTL6kphD7NF2JbDOHGTlL5M/ZykFnXeCsirDo8w69NjsfkKtuQTgWxuBYVPcLvrsG8wJmGA5qcKFMCQINwG3xwKH8y8A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(356005)(81166007)(110136005)(82310400005)(40460700003)(83380400001)(426003)(4326008)(8676002)(6666004)(7696005)(16526019)(26005)(70206006)(508600001)(36756003)(316002)(86362001)(5660300002)(186003)(2906002)(54906003)(2616005)(1076003)(8936002)(70586007)(47076005)(36860700001)(336012)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:16.8377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f05941a1-65ab-4aeb-c39a-08da1c7bdeb2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4437
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 0c0ca599a353..d0fac57e9996 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9765,6 +9765,11 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
 
 	activate = kvm_apicv_activated(vcpu->kvm);
+
+	/* Do not activate AVIC when APIC is disabled */
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_DISABLED)
+		activate = false;
+
 	if (vcpu->arch.apicv_active == activate)
 		goto out;
 
@@ -10159,14 +10164,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
-- 
2.25.1


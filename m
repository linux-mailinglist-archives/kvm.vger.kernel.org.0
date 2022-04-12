Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFB44FE089
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353682AbiDLMlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355004AbiDLMir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E04C4EDEE;
        Tue, 12 Apr 2022 04:59:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlNDFsjZhy/qP95mUlhk10lrAGwl70aN/awF8b7kd1lBrSBmfJ7paDDbDkZk9sExjzea2GfJjSZ0RuLcSmErzKRAy1Z/hToibH7mpUPiK0vadJNYTUoM2evFcWGbI3Qpw/FwcDslTaP4qRwQZ6ndj0IEsx3mCtdPGeORvEqjTS2L1xcRKs4DtyHXVpza7w9d733GnivHPKBQtgKTm1hvbP8ydAyFLXW/Y7J2ha2/N/3ozJ5swsyaJXXTYu0f4ayaVrg9HkIKn2KpmOS6po7R/CpyfHc64SUUU9kRNgohAvrrbwCPVZpsaG5uDQu1fYubjZwfAAzUEBRyBwDYu6u2Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFW+dB5Wol+0LL8f3dgVcy7JTZvy8eLRETWZ494AGAc=;
 b=KV8sNylx7wvgD9KIffnlFF1v3ZNmzkW6irLiN4gqsMNLa6Zn72lRPhdish0cmRD7/2CrHuMtgEfEhZGYN0FsKgsYKX0ERgAuowMzSqiDVBV6p6aL29qu1zAxutmNZjURkJWFrPuD2wb5NMIRLHwpAprYgvGtzrOMPy34olKK/Kwb6ovgoXwuBhCMrTRgTNLq4vMpWcH4yYAXgYqJSXrFXoCx8clueNMXkrFoAghyAZoCHgT3wKiWWQbiX8O8MoyXngdPC6UpFJOdaA9zcMHyaYObqoVwcuYMfhOxvu0ilJqcfHnAw67Tb3SgkskilBjgWQwAkN481aQ25C1xFnx7Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFW+dB5Wol+0LL8f3dgVcy7JTZvy8eLRETWZ494AGAc=;
 b=FazzhUp1G7HzJDN44/397lnHekdPp/5O9L6g7WuCq22i5WUACgHcT4kfCP3vtf6B6NBOaTmAniMWGASSqdI6Z8TiUWYAl3rSFlPMESkKijPg67DFxSvTZtNeu2zb6CZi6Q0O1nI9bKlLC73yIOEe8xlfg05ufP9j7A5Iacv83H8=
Received: from BN9PR03CA0746.namprd03.prod.outlook.com (2603:10b6:408:110::31)
 by BY5PR12MB4854.namprd12.prod.outlook.com (2603:10b6:a03:1d1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 11:59:12 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::b7) by BN9PR03CA0746.outlook.office365.com
 (2603:10b6:408:110::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:12 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:11 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 06/12] KVM: SVM: Do not support updating APIC ID when in x2APIC mode
Date:   Tue, 12 Apr 2022 06:58:16 -0500
Message-ID: <20220412115822.14351-7-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ab6e330-1336-4ebf-1412-08da1c7bdbd6
X-MS-TrafficTypeDiagnostic: BY5PR12MB4854:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB48548869ED630BF107C8F4C5F3ED9@BY5PR12MB4854.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yilzhqgt5XFNFPE+/jUd8wkbpdsV6+uNNNfIPn+Pun2Uc8uD4CBymyUsCPx9rbbKVPTRimYJA+t9tVLuY88j6lAUjhvPHNWCBdPO7B4TcGD9NF+s14omcUhHowkDR8HRDzU5i7BqaHAIpMQOOKP6ZND7jt7pT3vK+cRh4DMf8Vm2wxMpuKUV4R5X94MkbS2RG/xtggklMYduTc8rrrRaor1UQFZLnvm145FYH+5iWk+wTHVAt9kVy2rPeVJIltjmHH9fMDcofjsdxt8/BtTUrNabTvfQWx74G9NoJKMfZOq4iGvOC+OJCrTF8KKrF2SW5hlMBgfrttiJ3qkTnffNDB7495mUG98nl31RqdlQOAYnnp34a7FqB/iA/c5zmROa2e6Ur3xxd8l5eT3dTrYh4QOKHhTxnXH9BB8oN7d5Qjrh3BEo4z87B1N/Hwi5CQvBvuhdOBD0pEdS2eL5Cqs4wkHNXZNz435hYjV5/UjGt9ovVV+0QAeSa8m0zfhwY5GuBz+inYxIAh4XKZ6NcoFWzs02GeSNUkwxSqHAqaq02OJEgHqol/R3S/guVtFNsdU6YmR6UoSPJ+pwK8B0FYTkzXOUdZVNF8O8lcnpPfxvMzOEvEZKHG6IrdwhbBRSFo7AcLbO7UZkQnugK5jLqpVVcjozxAYVBa0r1sOXEMKDtpmP+LTCXGNo1E/BLD5dKeES+RJxc8gEjsIs7hBElkkUdw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(83380400001)(316002)(110136005)(70586007)(70206006)(54906003)(36860700001)(8676002)(4326008)(40460700003)(47076005)(7696005)(1076003)(16526019)(26005)(186003)(86362001)(2616005)(508600001)(356005)(336012)(426003)(5660300002)(36756003)(82310400005)(8936002)(44832011)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:12.0516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab6e330-1336-4ebf-1412-08da1c7bdbd6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4854
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In X2APIC mode, the Logical Destination Register is read-only,
which provides a fixed mapping between the logical and physical
APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
and the processor uses the X2APIC ID in the backing page to create
a vCPU’s logical ID.

In addition, KVM does not support updating APIC ID in x2APIC mode,
which means AVIC does not need to handle this case.

Therefore, check x2APIC mode when handling physical and logical
APIC ID update, and when invalidating logical APIC ID table.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 609dcbe52a86..22ee1098e2a5 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -424,8 +424,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
-	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
+	u32 *entry;
 
+	/* Note: x2AVIC does not use logical APIC ID table */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return;
+
+	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
 	if (entry)
 		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
 }
@@ -437,6 +442,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/* AVIC does not support LDR update for x2APIC */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return 0;
+
 	if (ldr == svm->ldr_reg)
 		return 0;
 
@@ -457,6 +466,14 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/*
+	 * KVM does not support apic ID update for x2APIC.
+	 * Also, need to check if the APIC ID exceed 254.
+	 */
+	if (apic_x2apic_mode(vcpu->arch.apic) ||
+	    (vcpu->vcpu_id >= APIC_BROADCAST))
+		return 0;
+
 	if (vcpu->vcpu_id == id)
 		return 0;
 
-- 
2.25.1


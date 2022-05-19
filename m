Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7AE52D07C
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbiESK2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbiESK1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E11A7E3D;
        Thu, 19 May 2022 03:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmAnlQ8O4Jg6Hl3N5ZJsXJeyGnT8j9lm9j79Lke6mCEF+ejv+dwkThFv1/zHNW4acGpp/1yyiHIKyomCw67mNlxIjziLaTXCoh06kPsj6Nuuijo/NNpdSfaHST+1wWs+grBA8a0ld0FbHT3e7q3mo+laH9E9CTJMqX26NeiauSUhn45xvoBisruLmZPbx7xXq6Y188XFA4ajqa3DaTOCMwrBFCAPxTdDi/aZAsb3WBJc/GG9NPmvOhGYyN16Prd1CA2fYDpq2+ZvBzE3bB/7RwYT3TELdUksyCMd4EqSyu+Pkq0pSO8MzsAj5cUf6r4dox/Go4Bg+tj1mksmS28eXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=An59Audd9Wb4f9DlFPkPLOYObyXGIgmHhDYd1Z0I8EI=;
 b=eAGaR1cxMbx/XqQiI458bSQqrgWObU8hCTRCKjKfbNwN5BIINA0Ml5DMQN0R2hhzJ1nCoQ8ywPM0wTzmcfGhUi/O4JdWoNwQ9Qqwm3jjGBB7jaZEySGaPWOErCR7LxwoQ9JBN7bMQEzQWuFSfqHtxlNvAnnLc/O5A/S5y/xh0IDBgjji0EnMLq2uZhZN6P940kFjlzlH3TFGePMZqyIIH0aWFEgiRC19lLi7a25VPOkaEo1CAsIt5YPnwDM3M7L4ohjEyDmxGJ+TERCHdK6jAufTOdhyjwifUNMbE7ouvK2D3CRyL4dyjM4Ii2wU90JRWowWf+g5SiBIWeDljYCpNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=An59Audd9Wb4f9DlFPkPLOYObyXGIgmHhDYd1Z0I8EI=;
 b=O6mxHJdPPltRg7KSoZ6EQdbVdyRrDPqq3pfuQeW9AUGzIc/LOq3hpbuPoivB7QHbJYMfTo5AG87HblsgjmYiGl3Uma5vjDf4rBhxm1uNUvKCyjVPh+4wdkwzfm7GpSuJ/jTwjR8zZtVirmyQ2vm4Gs0sfhXAUpAgxyVjwuOZNdw=
Received: from DM5PR12CA0056.namprd12.prod.outlook.com (2603:10b6:3:103::18)
 by CY4PR1201MB0103.namprd12.prod.outlook.com (2603:10b6:910:17::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 10:27:37 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::d4) by DM5PR12CA0056.outlook.office365.com
 (2603:10b6:3:103::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Thu, 19 May 2022 10:27:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:36 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:35 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 14/17] KVM: x86: Warning APICv inconsistency only when vcpu APIC mode is valid
Date:   Thu, 19 May 2022 05:27:06 -0500
Message-ID: <20220519102709.24125-15-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37f08fae-d6a7-4d1b-4c58-08da398231ca
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0103:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0103D03EC8D44AA2516554D4F3D09@CY4PR1201MB0103.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UgA2dnukSZyLkkzgF0QQkZlQgNr602UmFh4uR6+5LAqxeP6ZPbgu8dc0rZeMGyXXqecfNTJpTteAXFJ+QvARJ8PpEuQj/0hG8/R3VzAduRJS/jYn3UQvnsnxUYEUNCxUqEuXwF0GBmmK6wgDE925Dp2TRlw2m/q50tIiPOWx0QhqVO3HQADEuIfIOkd2U/e8gHI2AZg7l2pQokOD8YueWKPvVsHOtoF1Qteh3zXiY8v0dMPcfeGLSz31eWYiuP//DdyirsT4eHL8GedVnL22P0Yrru4wvbvGbpUkJqlORui0SoTU6r78kluvqwpyCZ00OwDL/knL0XwguH9PHAo05EiWmxhBcxqW6b2riaXM6hMFUoRDVSihgwCbuCcUQE/Q0+BzbhL1TKoAKi4n9yXqBwVpLsb4zu1U3DqkxlsZ/Zpb9bByaYfSCMe4ci9enPgdvY8PdBciGEbQ0Olxgav+f4ZphU1crLgFtp6ofdN3xXurrTikWLrYyU45mdOVcnH2WerDEmKKHNmJ2arMzk9IY1dtFaFItv2Kw6SCvnqxPTuugy8xUFm5EAyJ4RfIA9mIynmo4YZZBqPOFKXPYw4yMKPKIzIaQU2XmhtgRzlVZCI23JxNxlA5b0gKKf+RmbQbgCPjTqT+N0x5JajQ4b1j4Rx6Y2Zpqy0jSue1hIUYV8jy7yxsgur+mipkogc/S5PwjwodK9lY9DH/g8oNYIxREg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8936002)(83380400001)(316002)(7696005)(1076003)(82310400005)(6666004)(2616005)(508600001)(356005)(44832011)(110136005)(2906002)(40460700003)(36860700001)(4326008)(8676002)(70586007)(70206006)(54906003)(186003)(16526019)(336012)(81166007)(426003)(26005)(5660300002)(86362001)(36756003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:36.9282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f08fae-d6a7-4d1b-4c58-08da398231ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0103
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When launching a VM with x2APIC and specify more than 255 vCPUs,
the guest kernel can disable x2APIC (e.g. specify nox2apic kernel option).
The VM fallbacks to xAPIC mode, and disable the vCPU ID 255 and greater.

In this case, APICV is deactivated for the disabled vCPUs.
However, the current APICv consistency warning does not account for
this case, which results in a warning.

Therefore, modify warning logic to report only when vCPU APIC mode
is valid.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77e49892dea1..0febaca80feb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10242,7 +10242,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 * per-VM state, and responsing vCPUs must wait for the update
 		 * to complete before servicing KVM_REQ_APICV_UPDATE.
 		 */
-		WARN_ON_ONCE(kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu));
+		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
+			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
-- 
2.25.1


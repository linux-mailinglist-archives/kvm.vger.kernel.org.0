Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E3A58E73C
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 08:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiHJGSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 02:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHJGSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 02:18:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BD065577;
        Tue,  9 Aug 2022 23:18:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXidEQYdLN9qCJcJngK8bIeKpkNMDK0BquibT0DkJi58kHw75FREBhmywgrs1lCaQWYi+kQPbsMjz1ms+PJP0NPcT5/90d7qmhD8bXnlPFuBuAHLQpUZr7qDX84DKL07WNIPq6NGGEy+cWRq8TRaEma/JCuw/zBfQ7md3qhEP8DIoz8sI+JkEjhjGo0s3JdATUow8bgngtKVTNCR3TnddI5Pz4/mmd66YVhlw94GGx+34W339S75g7jLEZuBLPdJxt8VakLNACnxZNsvJ9uxiMzmsrbWAH25VMOEeRwcjhBEfehY3G9Fc4N52CIDkJCadmbypuBCm5x1hP8s2wbEUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dc4x+2O5Nq8AE+1JxRdXG6tPPbs3D0HGYoKEgd/YFlo=;
 b=ON75FYxJ8kk+0LH/SBe2/oIBk/D8vndJNp9wFXV7yU8Vb6xcwtmbaZxxWyUv1t+g1n6GqzkNaR7pScym8M3CrRstWLB8FuLXkHLDC+41KoyFZB4ie+6nPS3UEcx+YrzJUap50KIsIRNbR4MDDjIwKyHxEDUwC+y50KounCMbgOOIGaHdzzZDqRBTDKwGcHUhJuOwdSNViAvCKQOf1um423PIgigtworKkMIv7z3wJ8kVsjBFH7F9zS1L9jjUTOuCq4ZvuZ9e+iu+siGRi1ZR5l7ZpGxJOU4VgwxZtCLkR69DWNGOZMrwEb1fCZZPUuktTLwM6bnK7d+CRQfx4e06ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dc4x+2O5Nq8AE+1JxRdXG6tPPbs3D0HGYoKEgd/YFlo=;
 b=tceevALirQ5cDJttR4gAHDbpRfUHLegyX74dkt+LCYpkm+dMVAFYqSsre7A5DtCe3rS319ihJ/zCp0GEa84eSLI8DfjXGqvqdGWFv43jZdejoFi7TgNN84PSl5hDcPokiG6KQodEW7ae5JUzpl5HmcxipQ7NPY/ADB99EHkiQnc=
Received: from BN0PR02CA0042.namprd02.prod.outlook.com (2603:10b6:408:e5::17)
 by DM6PR12MB2908.namprd12.prod.outlook.com (2603:10b6:5:185::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 06:18:02 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::6d) by BN0PR02CA0042.outlook.office365.com
 (2603:10b6:408:e5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20 via Frontend
 Transport; Wed, 10 Aug 2022 06:18:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 06:18:02 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 01:17:22 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>
Subject: [PATCHv3 8/8] KVM: SVM: Enable VNMI feature
Date:   Wed, 10 Aug 2022 11:42:26 +0530
Message-ID: <20220810061226.1286-9-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810061226.1286-1-santosh.shukla@amd.com>
References: <20220810061226.1286-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13141c24-945f-4ce1-46b7-08da7a98145c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2908:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBAsx7xJkVR6Js6gt1M8eF4VNM1rVmz9NCZfDI3Cz7CG0eXABt1Y7eKIcObdrWbrUAeN3Dkjm+6smIEMXS/0oKNOF6QU4TJ5Q2otnkOF/nHwvs9/+hZwJwrzE6Qf9G9GqKvHZH4QQR3UkV0EU6Xskwe2+rw/uP8lSRI58zyBpIe8Eq7HjhXs2HM1dRzZrGC9jxcBm2M+Uqg87IZFq0Fh81XOZZTMMSCyTWOSpiP/w7TCYkHS/+XHK/i2RjCDYtXI0hG7Es3lm0Al2+NiFkAU3jaUPXyH341Jk8k3QZnczMvo6JY5RNykVXEYVAtvQvlRTH61EeOPmeyQNgC+UJju6YdUfkkrDQBbZpJwQtAnaAbWsOnV29rpEwBGrxV2gtJFHzzlErey7z9rhK8nFMI8414L+gaU8OVBQNLR66y8Jb/1kixgGu9Ln7p61WyTquCZUjr2mny8NBP/5WyPVRYbfmwucE6rBUDrAg5UaEWJoSMsB6Up/jeVp8G3bAiWyD6Kw0h2f59VCVLw+UcejE1DD66NkngG9A4g+knb6lW2JVIIod/Pu11Q5B1xAIA3NNGf5daHZspvOOJO+w9UJj3VAgoUXYLKuacur8XmMAeatMsKqLe9/w2LY5vgISeOYuvLZWGNlsjgcSARqzFo+bwZFpjZrPDX9vPol9SgZpotHLeDgR5GQJFOciPVVX3iEt9y8xDs2qgsO/QgltTEI9tbJ7BtJJqSYmglpLxIqdXCMlrFpQJKH8Kse3pDr8yu++Us2dCkwhcwish6hVvWfrT1Ka8cG3fy25oILFSCIbkal0FwL5RStz7sqKIIjsnIPOTC9ZgWaPY/pidnlAEKCCY0tw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(36840700001)(40470700004)(2906002)(36860700001)(82310400005)(2616005)(40480700001)(81166007)(356005)(40460700003)(82740400003)(26005)(8676002)(41300700001)(54906003)(336012)(5660300002)(6916009)(8936002)(44832011)(4744005)(4326008)(70586007)(70206006)(316002)(186003)(47076005)(478600001)(426003)(1076003)(16526019)(7696005)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 06:18:02.0930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13141c24-945f-4ce1-46b7-08da7a98145c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2908
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable the NMI virtualization (V_NMI_ENABLE) in the VMCB interrupt
control when the vnmi module parameter is set.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c9636e033782..eefb4d5428c4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1309,6 +1309,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
+	if (vnmi)
+		svm->vmcb->control.int_ctl |= V_NMI_ENABLE;
+
 	if (vgif) {
 		svm_clr_intercept(svm, INTERCEPT_STGI);
 		svm_clr_intercept(svm, INTERCEPT_CLGI);
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A90C60F2C4
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiJ0Inr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiJ0Inp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:43:45 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8681B1213D2;
        Thu, 27 Oct 2022 01:43:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRh0V0PVhG/mVCokgxMsNAqMkXRWPrtF3tSltqs6fI8/b1rhKDXf8fnia9/H5J8ydSBYqENyNwFa7kW9TJxa7gfq8bqR2GIkgxWDAXb1TEEffWofHoMoJVARN1mfo9LC2OlgqdsQ5UR79fTxpZ2RmnRHJln3AA/FUGwy3HKYZEPrUGZs6Rpg3ik837d4cBNCKnX9ipmjS1C+hQcJfCfUlgf5Lm8LJAD7vo41VeNSHEPDDQrIFVDjkyQsLtIiIRMTJ5RcDvvk85SnbEYHIF8Symdxz1Bb5MSM7oO0hYvmYi4B7o++OEarjAZEtHt7wMZKTh7H/eP9qDBLegOOAYgtzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqegCxIaOnhSvJQ2jvqCAvktB5q3YZG4hAIM4XcHCbE=;
 b=KUEqedW0vDvsuHl3AyF9JdqLjttcm7MpQllThWWTLJ0vEr68495+piviQSBWr229scccHf0htPgWTZWklLRCXJ/ohK2RHd10ynYjg+mS6DfEZ8cYQmC/G0eMekV8D8FboMgczl1dQlD1tcbqvvBEaxdvLThXfL6IOIkd9ciZkIRIqf4MmrSfswETjwKIsEoXrEWiSs1YNJ9XPMzR+1nnzXEue8FoFTXCKTRCl/SKyNd50QcTUoTDjoye6lHUpsAnbAkdP1IA8MeLeCDZYgAjQ+bH9oEDNg0ZcJBYVDBHvxbJolegRyqQdCZO+BnAQj8Z0utOlto52/iTv7ulbLhBZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqegCxIaOnhSvJQ2jvqCAvktB5q3YZG4hAIM4XcHCbE=;
 b=KWJVs8VEISd/UGzvJLqeWrYrf7GgF2WlLvoJqaZbqoGX6a7+suirqmqOhG5cZDIkGjjXg0JgcWpNaDXWLn/34tFUEIZ+0P022O+mieZhvEKBpgZSLPFBVKA5oXohXWpL+p9ToVyKlSikQz0/7c2Z1kO4J3mF/E52C18PM666iPU=
Received: from DS7PR05CA0090.namprd05.prod.outlook.com (2603:10b6:8:56::13) by
 DM6PR12MB4329.namprd12.prod.outlook.com (2603:10b6:5:211::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Thu, 27 Oct 2022 08:43:42 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::17) by DS7PR05CA0090.outlook.office365.com
 (2603:10b6:8:56::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.8 via Frontend
 Transport; Thu, 27 Oct 2022 08:43:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5769.14 via Frontend Transport; Thu, 27 Oct 2022 08:43:42 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:43:37 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 8/8] KVM: SVM: Enable VNMI feature
Date:   Thu, 27 Oct 2022 14:08:31 +0530
Message-ID: <20221027083831.2985-9-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027083831.2985-1-santosh.shukla@amd.com>
References: <20221027083831.2985-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT052:EE_|DM6PR12MB4329:EE_
X-MS-Office365-Filtering-Correlation-Id: 99ad5507-cd52-4db1-2f83-08dab7f75a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DWYchpGhHUMuiDeLAj7Rl43Zy9hCI8q6MrLTspySar44qeYk6qsy/hmNMOebVDPRge0HoKxqIOcAqkNShGGF0Kqz42zoI9mPAkl4RtWlLo7eJP4DJBa3dyqu8fcOqxY7ejiK0LZOslzohTRUe19XSFIxW5c71/yH+gHEpRNYui+9LLzBQ5MY7kgsTb/3liI1AiKwAKH3eGrqea4qffBEkqTnb+iRvO1lyf2SS35+tFohSq2dn8oCtBz/0Mvz8wIyxrEeNwcDxpwQkQOkATU5e1XgTtuNdMEHXChmf0cY74b8aB9cEeluS6y9dytYeiL0Xp7itpxd8XDDXwt21pzaLLjuBfbPBYzGLoA9b2oeSfuYAxwDR5Gc6fXfaO5Rk+eO4en/0V4Vi8UlZNtZhrtaqT9R2IW56XQJ52YKGGWYd4ZmrPLmFwdkiK+gxpxn+EyXDoL+SybtuQbuA2tJfX9FDqiztokfxNN65l5Y3sdlUkf5hEK29pZcmls6dGq+kU97iFwc4pV26biAreMhgB6mV1d7ZiZzv6uRhpOsOeSYVwmMtqwZRgV4TcPzmba321W1/bb4MRFNLPV3pfK689YWjChgmeY+QnZhm4EoEnEBfvCGChLdNYX/TnfewRnrysG+HcoKgczCKRL0O7R6EFSMWACww3cp4LNqo7wL9HDH8+LtD9AfFIM1xZLfm0WE2uM6Dtx+uklupaP6UbpvO/sFsnPO10czXAGbxdPzL0BLFjX2zMw95WaskQSL0xvE2FnhIP+6EB5VX4Aw6D2z46mJx+LEik2BOr04yfglJvr+FjPKk5jRnm0nKjOTpy5PtSOV
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199015)(40470700004)(46966006)(36840700001)(70206006)(36756003)(82310400005)(40480700001)(356005)(81166007)(478600001)(44832011)(4744005)(5660300002)(36860700001)(86362001)(82740400003)(4326008)(26005)(6666004)(7696005)(54906003)(70586007)(426003)(47076005)(16526019)(336012)(2616005)(1076003)(186003)(40460700003)(8676002)(110136005)(8936002)(41300700001)(2906002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:43:42.6361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ad5507-cd52-4db1-2f83-08dab7f75a5c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4329
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index d8edd40e48e1..9bfee8c4e95d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1307,6 +1307,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
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


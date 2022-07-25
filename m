Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0994A57F8F7
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 07:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiGYFeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 01:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiGYFeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 01:34:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2043.outbound.protection.outlook.com [40.107.102.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C15B4BD;
        Sun, 24 Jul 2022 22:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFn43JfnpOCqn9iyAIJ/iPp/Fy13tOaX/oTRdWgJXu9gRh9CTAhzcBFtRnjS8ZOGvMVdCF8FmkNSxbQ8cz0vG7LsDD1Hcr1Zh9X4S0H/rcD6FEvC3YJL0oJnJc+ShcVY+f+jP0+IUrhgUk63QuXzIKn7WZQChUBfurR9t7ix3tLQJH9MXcC+yNci2BHuELbsvqZ2dW7WiaphmX/73lbcE6ckROC/q3oGQnR/ux6UCkKEGIpOAuO/VKadeMtnMwBWzuv37EAX+Pa+q/X0qZ6iUaICHLLxY9HXMO5mxgNI4hfgjQZt6SUoiloojYcCkIiGrDE76nyOqplTIGEzi5XNcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2nZPyeTgHnOFkB9Y7aR3Vju2rLDKur8b5sUqChZ5GI=;
 b=CtiaSzM8AQP2n1tns5jBkehzhd5801h5aBChf7ZjtgMJl6lerAbD0yxDnPwtFDi0dDRY5N2fJG0ebbMSjqOT5HvdukY8hZ7MlKE6udc3rbi4Yw3daGOn0tZ7YhX2dVkccYgvDrclFf4Tz1/RWk6R52vjai49E2EsR3VAuy1ETSwxr77S7dKtS2x0mgPqA1YlujH2XOYNC+XPqKWE3lTRZLksloP845gVvFzujOh7hP/R873C4mhhqxjjfWZvvkd7TA3dZdKzHvzeauTqDulsW79lmXrXU6BYS39vw5O7Syvo3GGYM/aMnDU2Is0arkACbwgdgzPr3NQtpPOetp1DgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2nZPyeTgHnOFkB9Y7aR3Vju2rLDKur8b5sUqChZ5GI=;
 b=R+rDwccfAELGUQDjVzgrhgnAN1gT4pRrX3E69zm4J6lf4+1mchZyny2mtG1/NKPkzjXZWlsb5zmrLLR8y5hE+i4dXqR5NVi2m0kYbDLxavcyixzGWeuPu2uN2luXXalAnUFlVAXG/0HMcSYj2m/TDHvs7FfGMUW11NlR7b4ZzFE=
Received: from MW4P222CA0025.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::30)
 by SN6PR12MB2734.namprd12.prod.outlook.com (2603:10b6:805:76::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 05:34:11 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::f8) by MW4P222CA0025.outlook.office365.com
 (2603:10b6:303:114::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Mon, 25 Jul 2022 05:34:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Mon, 25 Jul 2022 05:34:10 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 25 Jul
 2022 00:34:09 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v2] KVM: x86: Do not block APIC write for non ICR registers
Date:   Mon, 25 Jul 2022 00:33:56 -0500
Message-ID: <20220725053356.4275-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e53529b-f12e-4eb1-bf8a-08da6dff4d4a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2734:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WUYODChh1L8+nXL1WAUrRiFG8ZhvtZ7KLu7mJqTGkCrjoOVqXAeXZjuHIVV2rFWKNEKpsEYaXBcM2EtLCqrS/rDSpac1Q6cuoQevohaLJIb5Ub5H1rUJaQ3U37NPTjxTs4lfK1qebwcg5BgjlIfUmhU/al7PW4sBmqemtff/osZ5USTHbwp5DNd3bbo7Q3kLnedXcSaB/Tov2EWy11B/yiDNmnWqzOS7Nsh1Vq7Bn5GbIT1jtBu8zHgcyB53mUSxy1ahAdKfVKk9rjYl5fTD4XZe8RKOSBM6zV3GGE5B5zISPslcSD7YINdMA1SMbDMP95VECyQVM5lxjRln2Ypfhybu1ub1aQ2amioqch2EjChMFfd3hMobkE+JW6r45KJcX0Tf8Q12IQjnLvJ3ozbycRwDThMJKHO8sYXtVMtXxgFmNZ1eVD3k4rlhHBqsH5ePvwNFWA7+cARULeqUBfze9QUEeZyQXcp+GhBzVy2vAG9xiWJcmqlI1bcbNacSvthWyrRCMnvbNV9DZj0ozQ+0nkiN0jWJnI4wUT92cFDgR7KD2aPXJj+RwquxgFgGfAsl816vKcS+QnCo8vRFLUfh8c6WSB/2cAMByXvTEkzt9EpcMsu28JbHJVZKacCoLX7+exsklLRy3JmZz1jFsohqBqAVMvKPGtiuNw5ZBDWW0/M+erUoZMHTrGMyysugGSWpUb6ciPfn5rrDwmBTcsEwH7lBci/3CNzNX/uNwRxT94xeSvC2b19F6H2sfJDjxGNWwrwMxNxQEj19AC2My7ZrduX0izF3/b+dkLMcGIZQ8KcEIfoGXO90g4yQn6LSgKqGUzqIL87rhhfGX/Z/AMJ3iA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(36840700001)(40470700004)(356005)(40460700003)(4326008)(44832011)(81166007)(82740400003)(36756003)(36860700001)(47076005)(8676002)(70586007)(70206006)(26005)(110136005)(54906003)(40480700001)(7696005)(83380400001)(316002)(16526019)(186003)(86362001)(5660300002)(2906002)(8936002)(2616005)(41300700001)(426003)(6666004)(82310400005)(478600001)(1076003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 05:34:10.5304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e53529b-f12e-4eb1-bf8a-08da6dff4d4a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2734
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The commit 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write
VM-Exits in x2APIC mode") introduces logic to prevent APIC write
for offset other than ICR in kvm_apic_write_nodecode() function.
This breaks x2AVIC support, which requires KVM to trap and emulate
x2APIC MSR writes.

Therefore, removes the warning and modify to logic to allow MSR write.

Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
Cc: Zeng Guang <guang.zeng@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9d4f73c4dc02..e2ce3556915e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -69,6 +69,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
+static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
 static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
 {
@@ -2283,21 +2284,20 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 val;
 
-	if (apic_x2apic_mode(apic)) {
-		/*
-		 * When guest APIC is in x2APIC mode and IPI virtualization
-		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
-		 * on Intel hardware. Other offsets are not possible.
-		 */
-		if (WARN_ON_ONCE(offset != APIC_ICR))
-			return;
-
+	if (apic_x2apic_mode(apic))
 		kvm_lapic_msr_read(apic, offset, &val);
+	else
+		val = kvm_lapic_get_reg(apic, offset);
+
+	/*
+	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
+	 * xAPIC, ICR writes need to go down the common (slightly slower) path
+	 * to get the upper half from ICR2.
+	 */
+	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
 		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
 		trace_kvm_apic_write(APIC_ICR, val);
 	} else {
-		val = kvm_lapic_get_reg(apic, offset);
-
 		/* TODO: optimize to just emulate side effect w/o one more write */
 		kvm_lapic_reg_write(apic, offset, (u32)val);
 	}
-- 
2.34.1


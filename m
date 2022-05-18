Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B662052C02D
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240152AbiERQ2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240204AbiERQ1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2835F90CE6;
        Wed, 18 May 2022 09:27:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJtPFVJJyFiRyhKMILwnlkmQDd7LwwyrKqh5Vedw7T5z/OZSj1jnWxDTQ8LeoW1xCLnhN9RTtKq2uyHSi4GxevhhWJUqQ47iUKg8yqbUiJLvG0K8aJLmJilRHa0po+7GDpoy9OFi//xP8gfuQVrsiy4KrKgnyrgeN7XYEikQdwE0D3N60WQVLFbSk6Xjk0kHu7cSkBhiEDv+TxG+edll3b3lcJGFGJom3su0uiLwgBXkA1rk9UPetPtD3Uqs+Hz/PjJF5j6arsszdB0SrX6J0I/E25vrGpuzjH0cpDmIUSRnJDAyfXtx2kGMoJ3Me2VQDkU6mQfVllgqomI13hHYPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83695Y+9o+s62B8x0blwU4bqtpuC0t1iZ5LaeEhEG7k=;
 b=LUmNleJp2lnL120RU3yaUVX2RaRBfp31/sW1pxEo0qm/dHXxjZk3lAFj7RmkLF4hPo9+QhjqJSt8nc58wO40VzVf+jPAbJB8IzsJJkdcfFpPP2V9RwcKeRI7qJOVl3wxJh65/0AjZnB1ALKCGKpG8C+c6xc1E7MPkSwJsB/2lA829XFsbTSoJ3mOyujCXLeRADgjXLEFIfapkVdgTcykdaHWuASM+pWybNfLt8eHIn0LIkCtibGPAG4+t+L9bjNM2/yoDpQ2N/TC6vcY3HyzN6IISDGDkb3ONSAebwgP1kDu4wk+Y5E4TreCdigi72pBmKrexAfo2czq9SJa9c5H4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83695Y+9o+s62B8x0blwU4bqtpuC0t1iZ5LaeEhEG7k=;
 b=h4kP81k7UiauoqGgC2OZz6Xrdz27RR1g6J74m2F4FUJ6lbnuU1YSXs3vpMhxMqIR5PfI400sjUlldxZcESVLSl3/9UtNzS8eC0xLON7MOA3gMRjJHHTVQqfevNyukQO/pA3a9WJ5oQ40dFilgvlqxoIhbC8/Ozt7OhbGT4T+nqI=
Received: from BN0PR04CA0179.namprd04.prod.outlook.com (2603:10b6:408:eb::34)
 by DM5PR12MB1851.namprd12.prod.outlook.com (2603:10b6:3:109::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 16:27:16 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::8b) by BN0PR04CA0179.outlook.office365.com
 (2603:10b6:408:eb::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Wed, 18 May 2022 16:27:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:16 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:12 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 09/17] KVM: SVM: Refresh AVIC configuration when changing APIC mode
Date:   Wed, 18 May 2022 11:26:44 -0500
Message-ID: <20220518162652.100493-10-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9b8aae6d-6fa7-4b6c-3553-08da38eb45c5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1851:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1851B32AF8D6FF9B2B84282AF3D19@DM5PR12MB1851.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sBkJ2ZnFNeLV7cBB6lgludcrvNDP2hlzKVGNK2VnsgatiOCiNJxVq9gKFOH7pmXP9L0pQtAGODvoachXL3K9fBMS8Xk+5hlr910DCXwzTMGK+qSC39OG4j84plTt+0TSoQoiWXcRoLQOskqYzqSDdIULpUMX405fy/3jfTvhuXZrRuO092TR7RaT5BTadoNWDzgJgiYie8G6r5HdBwPFr8VJ/s+hNcU002RG8bGqDu1GCVQStMWeG6JOTvHg+NowM2OuMVbqp/Wwl3S/OlaMFbLutZz3kHyhsyEItjEMcKKBlg/qVmXqGGmphQDjZMKK3oWsQ5uIiYIKgRQQedA6tHT5Kh4eTdhlbcEYMz06Yz/if3gLYr0oTuNIwfrUXd+MkN9zcDniuaoQukuqpHREU7VDgz/9LncRbBYeRN0WQ4pabItmkvKSXWQ2PQ4m52/xMjqlljxBf9YmPdusjjHQsCEmNjm6+VQaJLpkvFvu0/q8bqUz1LF9aGjQbhh+79ApuiYHR7jsIoSFlW6Kw8evEv8GYK+IooZe5XgH1pY2tstCzNO0AbVt28xwY3YKJ/3FzAb+AqnSp+nbUQol3FWpmU/NPbzrSLL0j9Zgybfmlpdu621fJoF1LyuC/Sy0P2zAWOgrkrNs/Vum33RhtHLKPLA1948MqUvIcx7Q5SjBqB8e7mFfPb/3DZZbULxoYNsGT292ExsVETsgSowAUxCIA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8936002)(4326008)(6666004)(110136005)(8676002)(40460700003)(316002)(336012)(426003)(81166007)(70206006)(36756003)(36860700001)(508600001)(7696005)(54906003)(70586007)(186003)(16526019)(44832011)(26005)(82310400005)(86362001)(2906002)(1076003)(2616005)(356005)(83380400001)(5660300002)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:16.4743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b8aae6d-6fa7-4b6c-3553-08da38eb45c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1851
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD AVIC can support xAPIC and x2APIC virtualization,
which requires changing x2APIC bit VMCB and MSR intercepton
for x2APIC MSRs. Therefore, call avic_refresh_apicv_exec_ctrl()
to refresh configuration accordingly.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 12 ++++++++++++
 arch/x86/kvm/svm/svm.c  |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 7aa75931bec1..aa88cef3d41f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -685,6 +685,18 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
+void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
+		return;
+
+	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
+		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
+		return;
+	}
+	avic_refresh_apicv_exec_ctrl(vcpu);
+}
+
 static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2cf6710333f8..31b669f3f3de 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4692,6 +4692,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
+	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
-- 
2.25.1


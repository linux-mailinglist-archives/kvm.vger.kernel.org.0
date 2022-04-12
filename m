Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598304FE078
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353283AbiDLMkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355012AbiDLMis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF064EDC2;
        Tue, 12 Apr 2022 04:59:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Whct3Kc53qbsgmsLyzBreQ50eXHK2pFZgcF0hGSL1ZMT1qo5SD66+4rfHN4eRIWnF9jrz4eROHN2wJj+niJu3QeDt5Iqm01UvL7G+sDpkLxXZDUtlWv7n3OKMahsBYUJ5r0aqN51qJvX1XZsORgC+5fyfp0CJBvPRvZgzJVR2aMGGDsVpx2XNL/EFNp3zFxev8hlC3zvUY318RlvtrTC9cO98CcZoZqlIygiNtamZN/9dFkjU3ZJy8wRyg+rPutSXn9Ja7ttZKQknj1LUkd53TR0kXFkjuzqZuxnIT3ZM1aXsx5OsbQqfEmVSupXuUuda2q3joSdwgUeoGQKR7QnvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnoWV9wc7zlYms5ds6rbvb11cTDLum9TslUT82sGkBU=;
 b=M5jqKlWmD21N04eH4mqJg1+1IVRd5ldMbF4ms6pmTBwmKiIz6eNn2Cz3EYR4qH8eNHH3oHRLD+I4g4SORUMNaRmg9th3IkkHYWQ+MQQ5yPahn5d/EhClFiUxkz2Ue8H1Wd6V3OKLRj8z7GwLkYb9o4BKVIwMqM0e2QoS5pQ76Y3CU3o/HAqlGx6TPy/Gjj6CsJhWKZazeFnTXOVuNOEJ+eIL/5ZIJWm8W0zFrF1LzA25M6p1+c9ONzt/olJX5cJ+d1HeukUZHW36tdw0SWkckuauOt2p2a1DeQEK65Z2kJBCsTIcseYx0vl2ahhbhPmNSwHZG6j8Old/RuxUXspvPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnoWV9wc7zlYms5ds6rbvb11cTDLum9TslUT82sGkBU=;
 b=K/knDvgE9sGbEblUaAbNKCGAg8+On7qroy8DEGiIuqWJ/9VVnBMsZB1BZxvqz5k/JYhAs2rZaA8c8Z5jwWF1I7KJ2KzP6byIZnWumixjVby5yaDti6u/zJgUiBZ8DvBtb+muxeZW7TEbwyATRXloUK43Qmc5FAZeo1aEIR34zxc=
Received: from BN9PR03CA0739.namprd03.prod.outlook.com (2603:10b6:408:110::24)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:11 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::d2) by BN9PR03CA0739.outlook.office365.com
 (2603:10b6:408:110::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:11 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:10 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 05/12] KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
Date:   Tue, 12 Apr 2022 06:58:15 -0500
Message-ID: <20220412115822.14351-6-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6849b8b6-cace-4e6e-ca63-08da1c7bdb89
X-MS-TrafficTypeDiagnostic: BL1PR12MB5061:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB50611D8DA73058BCAC8FF4DBF3ED9@BL1PR12MB5061.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DCwoAdlYnlBbnvxdYpnemER6mS1BplSWPlI9V1xSdJWNwrCudPCwybQ8I4SK2qIlsl/N4Qoyxa/6WNn6a9fiej1qXjexTjpalc+Oiq3YVgpvMTklp1+5yX4UZakfaiKND9/3lycalwvUzAhwDnbHaW7HwD/e3Rw52tMdokVAVc0MRNmhhj6Sgrmc742sVGRIiJJUm5znYfuFKwF0sd//sa9peaC3kgroSICJ6f0mDrmFLJ1NMKfmKOuyFYzDTtJismg6rL45ei7iSRUVth1rxyJZF94w0IKC+PKgkrHkXeedKNr63PSEVd+LTj7hQlmbiCyyYZUGPwpOvHRZoCMG6OARnV7Nql+v/3LGcuAFghzgDMWjKcyN3x12BQqLRGXVil6W9uXAOgsyECuG831ULbvVUDxqFwU3uQkyNy7GJp++k1VZ/pAz/LtioUhQEuEPo6ZgZIynyGc0o7sIHJA2fxaU9hBMWXJhCXeVIATV9pCTklbp5r/gjnXS+DGSNiztn53MDSCM09fdT4p6FmL1YhZwY1Oc3qr+qeQWYkmaoFOtp94n6k8N8Uo4ciXNs38kZp1Hw8MrSuoDDanKWs5zVX+U1RrkhWSIfyGd0g9wjF3dPrx9/EOw0bTJC/lTiTfiOqPLprCgSeLjPHGxxpNXhHB8Zs4hGTBCNJ2X6xKDY/Kjl0HkPv2wFzZKH80OkjsQ2Wqg2NIWfJOpCA5QudHW9Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(8676002)(40460700003)(8936002)(186003)(5660300002)(81166007)(356005)(44832011)(2906002)(15650500001)(83380400001)(7696005)(4326008)(70206006)(70586007)(426003)(2616005)(1076003)(16526019)(336012)(26005)(316002)(110136005)(54906003)(47076005)(36860700001)(508600001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:11.5517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6849b8b6-cace-4e6e-ca63-08da1c7bdb89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In x2APIC mode, ICRH contains 32-bit destination APIC ID.
So, update the avic_kick_target_vcpus() accordingly.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6c4519db3fc3..609dcbe52a86 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -307,9 +307,15 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	 * since entered the guest will have processed pending IRQs at VMRUN.
 	 */
 	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u32 dest;
+
+		if (apic_x2apic_mode(vcpu->arch.apic))
+			dest = icrh;
+		else
+			dest = GET_XAPIC_DEST_FIELD(icrh);
+
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
-					GET_XAPIC_DEST_FIELD(icrh),
-					icrl & APIC_DEST_MASK)) {
+					dest, icrl & APIC_DEST_MASK)) {
 			vcpu->arch.apic->irr_pending = true;
 			svm_complete_interrupt_delivery(vcpu,
 							icrl & APIC_MODE_MASK,
-- 
2.25.1


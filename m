Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D66152C0CB
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbiERQ1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240201AbiERQ1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF52A6AA60;
        Wed, 18 May 2022 09:27:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOsJs+5UJ9Wu07zzJYOGy2VpgGp3+BzLtnSLn81MaLMHhnRdw7aM1jZg6tV84PnavvlQQjde7yuXCYBYaWzpKlzxAhwQtFl5v1lBTBNbs1SqDdHm+N+pJkKnrpg5z5amtBZJAOToa4/XIYTspMHRprW5a3+mGT3LdlXXhtOREVVKODGMmZ10Dr4QtkqtB+EgaElbM4OqWVnDxUB/jPA8sFxGgHMCbVhduUUB2qMM/zzQHUCtFS6OjhzCwLsV9boSeueMUwctdBE9gOUjckCJGhzRTtOzBK4yJ4HyrKzDuqK+/68TGXL2dFC91LB1Oyeu3etYdd+i2RKCNC8o6/uIJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWn/vash+REJVBPvFVe6fL5edyLf62h5NzBGmBUCpiU=;
 b=OT+bjsuwGynEUY+ldNVodXtTqyUnSq9FAmnHCCLM4DqA79DFi1JcvKm+iPWJVHTB9wzhcTKWix28FK51IT5mRvHKwxvKENBOiBjKHq2klQKUcw5SLrTRGZVgiBJ0pbevT+XtGPuBLUyB9TuKSKK0m0DrNybS7DVT3THvla61YUS5rMZ44l12+XmRd4Vff/nLGHvcAdr8fODzfXfRgCcdQBC8IWn80JDLOsHvU4SxiLbuY6q2pThtI2PhU+i+MGMjjen9tjB5XHMasHw5lFseoLl6Tcu+PedTWvnQFc1rBhqtbGRdL6ROwoDsDtNBST2Tb2U8jKKj3qYHDCwRrwVX6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWn/vash+REJVBPvFVe6fL5edyLf62h5NzBGmBUCpiU=;
 b=jxFzq6I/nuIZh0EHs9EoL64ZcR/6kmWfNy8NCrvoyFjWTPa1OKPrOLEdrj4J9mMHVGSCWx1M6Ep5D/JY40WSEplvlCwuGcOEgaTgX8tBIijrBp0RfQNIDNuZfZ7jB1fJqjEEK3ZsqP8ZmvM6XiVKhSS/FEzrus8MiUBg8cVtY8Y=
Received: from BN0PR04CA0178.namprd04.prod.outlook.com (2603:10b6:408:eb::33)
 by CY5PR12MB6372.namprd12.prod.outlook.com (2603:10b6:930:e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 16:27:15 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::e) by BN0PR04CA0178.outlook.office365.com
 (2603:10b6:408:eb::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:14 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:10 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 06/17] KVM: SVM: Do not support updating APIC ID when in x2APIC mode
Date:   Wed, 18 May 2022 11:26:41 -0500
Message-ID: <20220518162652.100493-7-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d85d4698-ef53-4088-d08e-08da38eb44b7
X-MS-TrafficTypeDiagnostic: CY5PR12MB6372:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB637212859F3975E9A5A55620F3D19@CY5PR12MB6372.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7mqGp14jPm0d0GzzqrHtmHvf5sEnmpQsgCQbM4cKrbNpKA9DQzqALKY6QRSUNpp8isycaOauiAkWIThseb+0hQad0OSt5gFtUC7eAzoDZimL3wORhDJKaIEJfE8f8efGSzs3uJQ/827bA8De5HJTl/7BgaESsPQATFp26dJhw9amamz2FqaTHytvvSn9o2DzDfPNgIiSin5Sv6PFGaSzL3NW5yn9DzWA6xtDUpjKW5hdCfgT5VLjP0OQDQSYElzu906qoEhrpfTTdFYTBdQ56RJswK85/XwFCRUXvzUCCPgpwAmiKy7RyzPk0+QAwtOjli8LcNp/5qp4+XNPQPagRZmgKQy4QBQZKoyAJruL/ck9sFDiSH0V3x/tYf98QMmujnj5jjB3yd4NsGKdzNWkodcJpZfNf7HB77BOipoadUbMN3Dan3raUhYjCnvC5VcTgYiIW51PKIkhvsweKMYqMcaOqvx3lqW5LJyZ9zuangIHvHzMh3Sc94BonTu46pR71bUgCTDdiPtgw7idJfLzGnspAaMiSBI1O80Mvcgxg0vnMv9umi/BUWFpSDNbE/v9n03Rl2rXOtU66rEQhxoKrP2gC/FbUCujFkqRBVARowKH3WfXHY2TQtzzgNP3uTV/zm8WikAAjKBKYFaDP0OFuEngpsO7L9QLI3AY91WF63wV7ahkvj9ydTy4c2z+zpmfXjWeWxOpeYKE9rBg22qlgw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(47076005)(426003)(2616005)(186003)(336012)(40460700003)(316002)(70586007)(16526019)(4326008)(8676002)(7696005)(54906003)(508600001)(1076003)(36756003)(5660300002)(81166007)(44832011)(6666004)(8936002)(2906002)(86362001)(110136005)(356005)(83380400001)(70206006)(82310400005)(26005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:14.6932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d85d4698-ef53-4088-d08e-08da38eb44b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6372
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 560c8a886199..7aa75931bec1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -493,8 +493,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
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
@@ -506,6 +511,10 @@ static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
 	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
 	u32 id = kvm_xapic_id(vcpu->arch.apic);
 
+	/* AVIC does not support LDR update for x2APIC */
+	if (apic_x2apic_mode(vcpu->arch.apic))
+		return 0;
+
 	if (ldr == svm->ldr_reg)
 		return 0;
 
@@ -526,6 +535,14 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
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


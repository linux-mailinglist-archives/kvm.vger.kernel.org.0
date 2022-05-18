Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0322452C096
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbiERQ1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbiERQ1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:18 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2061.outbound.protection.outlook.com [40.107.96.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593FF72E2C;
        Wed, 18 May 2022 09:27:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiBmRard/KOkOWpDKGYjbNaNDuHs4QrwahItM4rLJK5bOWTtoKH0hn39rdSW5vUvO4OTyR0FXlbsFzHdlQyVnlSd4BWWIm7WwFoMmpVP3x/SByGXRn9sMZ2l/btmCBDXMO5KYBc8E3BCDa6Nm9DERwVGqBK8qHK9BGs7cxKaiJNscDhvdoL/FLlHafTnWcZWVSM37BOL8k4bM3hW/CiQQ29ppd7IXvCYhkvMyrb3py+be1GvAoVvupFy7DoxAa8KTLXV5pCD35lYT43nfak3lvps4ytaTQaEBScMLCdypQa0vyEMnCjnB8UVoBvRzf/Xs20yOpPLWkcZXrKDJIAgzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7nGMak3tiYN2w9nHKtz8Tq5+cMkjgVNWyFDRaDtLDw=;
 b=AvR2PyNZEM5b7kjwfJVwbx/eEY+KltNKg4bksHAwWpJmoPn3iW2dsBZtvlCCWkX7jHatz3NzH4hRvb26Y/4t+DWv8AaPs7USh5liKYt0cgVGnIb1fe1Oj7lccQfJxU2gyzi64NeHEiVqOHdHj1v7clfeJHDoykuF6/f42yrmB3rLVT5e/e4JBnbU7XahP367wK6S2p7+WSEEGhxb8L2hrdOq1Pvtls77EkRfYlBMyGyH0w0y2CmG+vP0wYg8vIvIvy6EfKYMmHBG3ru4aJjfbzjaVdUaWxfgFiTETA3EeH+KgguGoqmN9M4dpYphJcWIYO46HAx9cLf4/b/6Zqehng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7nGMak3tiYN2w9nHKtz8Tq5+cMkjgVNWyFDRaDtLDw=;
 b=gmb1Hdi+An5fFRYW1wEABF6XuJ/3UZ8zXc+eLu1Z3aur1ubTeYmYd1qXf25c5REAgNpExySsKUVKb/v4iujDs607xyxGn5SM2P7PdXw6vqCkRg8Baea8GX22Ttoj/LpyLqMfW6gcv64F/mIfyOt0sT2akiuwNpmPUNScwuarmhw=
Received: from BN0PR04CA0155.namprd04.prod.outlook.com (2603:10b6:408:eb::10)
 by DM6PR12MB4028.namprd12.prod.outlook.com (2603:10b6:5:1ce::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Wed, 18 May
 2022 16:27:14 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::fe) by BN0PR04CA0155.outlook.office365.com
 (2603:10b6:408:eb::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
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
 2022 11:27:09 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 05/17] KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
Date:   Wed, 18 May 2022 11:26:40 -0500
Message-ID: <20220518162652.100493-6-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: d80aadeb-6593-41a3-11ee-08da38eb4456
X-MS-TrafficTypeDiagnostic: DM6PR12MB4028:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB402845B3A35904173F1B2895F3D19@DM6PR12MB4028.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xD+LN86cdXykuiTOE+UY5hekJ7wnPliH7EJW+tVfK9xrjcOCEYog9UpjA87mzXD+0bXsaV1f1YgqUCyByRHsKEx3LFSBbrPRWOzWxMW95vksYtg0xpOQ4MrYeR4eWHSkCwKDH/YaVX6Mvfn9rDYn5oqPtyMQlkwMub152KdXS/ZstUuLaZmbZVaPXAmLbk1HxWbU7X2TiGOA0zs/9U4qnllqkBxC6MpzeQaFsAW0smbPYUa24qs4D8WATAQFKgpKo4W5eoAeFvaPPakeq2uEsKB837CRtID/bzN7D44J4SsNYTrh6WYyy2RnsO/1PmD1ejB49RkMD9ZH7DExNDgONNIjCN1k6EZ2lVTrRqa+v03K3W/75oTcEx/xloiuaP5MW+Fwm1hUjL12TyrdMtI7Y4kEc4ocNoXaaAwLPbpeuSVKAITy4N7Xs0q8RaUvXnz1TkY1eMAgKFUNKZhGsmq7E26bARDDqWQxnGQAaPSN4PO7hVU14CNdZGcPkrJOR6jYsLfxjlOICqi+WB5pMCBd9n2676ijiEqmkTn/pOH6wLgO8xKlIoRKH563rVxWuPg4eupP9GEv2zUnAOKk1nwQGJsWy0KZAa/vxjNOC67401nUn9EU9GA8DpPoK8y5NHbOHy9yktIOnMd4WfKxiEqdEyeH9LxFt/jfPfeXF3pcQy9Ekgh/1NLO9lm5+WwHbWahtw1Ndq2IYP7fLrnnM1iuew==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(316002)(81166007)(36756003)(36860700001)(47076005)(2906002)(44832011)(6666004)(7696005)(4326008)(8676002)(336012)(356005)(70206006)(2616005)(5660300002)(86362001)(186003)(16526019)(54906003)(110136005)(40460700003)(15650500001)(8936002)(508600001)(1076003)(82310400005)(70586007)(83380400001)(26005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:14.0526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d80aadeb-6593-41a3-11ee-08da38eb4456
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4028
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 6b89303034e3..560c8a886199 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -369,9 +369,15 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DB0577DAB
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 10:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiGRIjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 04:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiGRIjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 04:39:43 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECFDBF42;
        Mon, 18 Jul 2022 01:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2vDxD7NPXko/dTfjEV4LH4ZDn3sWUCNz1s+pROeVYcqZbkFoVkcMQMVpqvpm4bh1ZYfy7QEeF3Hjk/FnxzAzaWiMX6q49Ukv3leF4gGmzu/KKJwp/K9XJE19kJq5v4MBlqbHNWoHcS3vtaekKh3qYGd+mL9wStZDW6GHa12buvCo135Ml3agIAq3sbK9fgQLow+eXGtSkur7BI1zCVSD/JD7bMRhccJsujng63tiwjS7RGOzoaIgVtBv0pVXODsIkjn0XPoOA2RJ/0hw9UYyq7qBI4GwsPXk4LercThc6CktSyfHPriqU2Ro6FbblXIYg+g4jLqhA92+5y6d9vMsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8SvED4Agxp3k3Q8emgb1WW3J/G5C3qEB+JEgjtXSPg=;
 b=AHYGHWr9cqsIkBLB9fPGZk/E8hcPpr7x2iRNMM57msk1qxw6Eemb8J6QOHfVZ7yclEKp1H6b9DUe09ggYMuvvOyjbbJ3lfsYRoLZqrWxM298vJ56In9Xu6KLAEBjSGiWsHssXq3sWf/+cydZFHz4zS8n+oZIQQLJxoEYdwLCjn9xEWK6TeNiAZfu429ns0lOgul4SB1MjiXaQlNmIkTzUf+9YPuspbwd5xzwQHmIShDRtG0pfqtHSfERBoVj+7aoAMxoTkYFfNeP94Kz1PMLHAYTI3D+KjMla6FR7Lc/mjhgAPfJzlXghSyurnSrfINkX1dKJTzkoBFXG2XOFC252w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8SvED4Agxp3k3Q8emgb1WW3J/G5C3qEB+JEgjtXSPg=;
 b=IFQuvYyVia05TiTnfRBsjHReNTlcX/h4r0Mf1FR1mcDvQmP7onj7nYKzgPRQxaxKSGJBsdMyeVJ1G0OBwquxiw/jwcU0c78aaj5eMJv9yw6xqODhGeOB/9IfyCSVPDTZ+WE0JQtDCHta/LVEoCYsTyCKvykG6YiseJm4s7SD1H4=
Received: from MW3PR06CA0010.namprd06.prod.outlook.com (2603:10b6:303:2a::15)
 by MN0PR12MB5883.namprd12.prod.outlook.com (2603:10b6:208:37b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 08:39:38 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::e4) by MW3PR06CA0010.outlook.office365.com
 (2603:10b6:303:2a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13 via Frontend
 Transport; Mon, 18 Jul 2022 08:39:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 08:39:38 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 03:39:35 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH] KVM: x86: Do not block APIC write for non ICR registers
Date:   Mon, 18 Jul 2022 03:39:13 -0500
Message-ID: <20220718083913.222140-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4119b87e-e530-4598-37d9-08da68990cf0
X-MS-TrafficTypeDiagnostic: MN0PR12MB5883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgAWNn9F6GCtqWbIKddvp1hh5feY7ugxDSKA75OdeAkoBJsCKaAmjMCRq/nZa1hLINCcPyZ19wCWkrDXZgGUvCiri/TVFGNWT0ot9bLTU5HsY5XctJX2zi15Ozl4Ad4lYXklDfoiW5HHBPAbOf9otlBU9iVSMS7EF5cSfFTfO1SSBQrmZ6QbVUYFOHyw0DGfjsKFhmh49mScim9LvudKRT0hphgdgx9s7j0e7PgPtov3972uMX0ZrAByuWrdp+4OkqNWvX6XHYJ9gZluEH+7Hm3KenqRTxgAMHi8OC+FHPIPIZdk6osxi33znH6tNFrFC7ILaeWtEKRlf2eV7Ot2XkS1eShciVqad/BsVlTA+Oc6tirVpUoMZtXPRYGJn61jeZjG23DUEhMFfzLLvSvXUCnzYUtHAgT0e8Kz9625N/MEqXkzaF2vmHOtNDCe5+nFP7prukjSn6ogT1vpjFki0DJOh1XIBXvzZSdvgLa+QKAsZNSDSDol8f7VX1gSkTZyp+hIEkT+/PW7j3Xq0fGuXOE4wmP7dVYqKdQhkgY4HPrMoBwqp2QKJ9C3Vci0jaadN/uHLZLi6aHzNKzYU3cYJLf1gTFob29Ysrp1CyVigyYrINyrTQB3mTyEUbDsDGHsQlB3Hw7hYGmc9Vqgx7y0TBRtPKEOe7k5BsZBKmino5P3uKfA3i70lVLxozjMhPJYOBvy2yuGzflXKd/nseDlW015xLTnG1RMnF3Onv65eQ7sg7goBMhfFdqjoQjMLIjvnmLxQRSwEw7hocZhkhO1h1NUv+74ot45cqCvPHmX2suUGSdWbdmrtcJswVF/77nT5CYzu4717c7I9SiMvyBm8eYIIzdpUDCO9btvJVEH3SI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(46966006)(40470700004)(36840700001)(356005)(36756003)(36860700001)(82740400003)(16526019)(1076003)(186003)(81166007)(70206006)(2616005)(70586007)(86362001)(83380400001)(40460700003)(47076005)(336012)(426003)(44832011)(478600001)(2906002)(110136005)(54906003)(41300700001)(26005)(6666004)(7696005)(8936002)(316002)(4326008)(8676002)(5660300002)(82310400005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 08:39:38.0826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4119b87e-e530-4598-37d9-08da68990cf0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5883
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
for offset other than ICR. This breaks x2AVIC support, which requires
KVM to trap and emulate x2APIC MSR writes.

Therefore, removes the warning and modify to logic to allow MSR write.

Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
Cc: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9d4f73c4dc02..f688090d98b0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -69,6 +69,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
+static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
 static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
 {
@@ -2284,17 +2285,23 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	u64 val;
 
 	if (apic_x2apic_mode(apic)) {
+		kvm_lapic_msr_read(apic, offset, &val);
+
 		/*
 		 * When guest APIC is in x2APIC mode and IPI virtualization
 		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
 		 * on Intel hardware. Other offsets are not possible.
+		 *
+		 * For AMD AVIC, write to some APIC registers can cause
+		 * trap-like VM-exit (see arch/x86/kvm/svm/avic.c:
+		 * avic_unaccel_trap_write()).
 		 */
-		if (WARN_ON_ONCE(offset != APIC_ICR))
+		if (offset == APIC_ICR) {
+			kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
+			trace_kvm_apic_write(APIC_ICR, val);
 			return;
-
-		kvm_lapic_msr_read(apic, offset, &val);
-		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
-		trace_kvm_apic_write(APIC_ICR, val);
+		}
+		kvm_lapic_msr_write(apic, offset, val);
 	} else {
 		val = kvm_lapic_get_reg(apic, offset);
 
-- 
2.34.1


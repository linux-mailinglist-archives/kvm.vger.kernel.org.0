Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE52252D089
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbiESK1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiESK1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:34 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2069.outbound.protection.outlook.com [40.107.100.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACC2A7E22;
        Thu, 19 May 2022 03:27:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrbv8tQG+qbsLjEhFW7Ha+he1LBbAdCHhJQzrFkJJB08g1fUmy/kTaPN+EOOsbxZexiTIveWahd27o3ycNjblGW6pbg4S3zklZLayYT7nZomqKpYZN74hRfXhA8cwCaD7z9xJWB5QJXEI0gYoqjhZYHgOdHre7ONCH/JoL+xckAFWBUpZN2q3+giGYydeGzbqd6iV0zmKG4bBW3dg9GJf1nMRWD2KdJtxFghmiqUzhIBrtmWk6cjPm/h+YTxAtOmN4xoezTL12IPjv9nHxJ7pALCkiiijB0WcEG3l1/3r8UWQk6PfcdcInrFyQ5mbKLvuvFtLHl9fthW+kDup89Jrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7nGMak3tiYN2w9nHKtz8Tq5+cMkjgVNWyFDRaDtLDw=;
 b=E/eTCDgdfmxEP4lVoPE+fcXhQQzqUc9Xt0yp1rtgeU+wUimaEG1+rBPWiF5h8A/uQdFlAj1+H1TDPq6NF/KSn29oZycLbkGkbU+M29HKvRfKIG0AElC/EaZOksXdxC6r5u7ZkN46vkmWjYUfmymCrvsOqUPhh5XUYtfbIpvRbXZXSjC8OYGirc9bzDK28vYg1I2eP2RFgDlsITI8W+vtCTJAZ2mvQfCWgHl6h2XT7w5W5NSWmhpE2P3ykBbVkEplG6UueZIsSIWm6ktr52GDhGmflOW1NF/V/i1FHu9l0qBfWm/md9RfT9LUgWOjUWScA5fSBLzakDIczLNUKxfl3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7nGMak3tiYN2w9nHKtz8Tq5+cMkjgVNWyFDRaDtLDw=;
 b=N/sbkpe85Wx3z9TH1gY6Nw5eQjw8IWe1V/ZCEF4u6ZQVzrRg0t9oaW0A3e/hj83LGrKpEnhc0cedxYLXZ8A+GiLR7f4RemKHE/cgAs+6dNHt/LrOnxF6lYJBmWBQTKu9ofxx2Jt2phP2ktQ9cCtSnKMo/jZlvFH9NFoDqUiqA9E=
Received: from DM6PR02CA0136.namprd02.prod.outlook.com (2603:10b6:5:1b4::38)
 by DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Thu, 19 May
 2022 10:27:30 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::6c) by DM6PR02CA0136.outlook.office365.com
 (2603:10b6:5:1b4::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Thu, 19 May 2022 10:27:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:30 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:29 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 05/17] KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
Date:   Thu, 19 May 2022 05:26:57 -0500
Message-ID: <20220519102709.24125-6-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1d7f3945-85c8-4e30-e219-08da39822e14
X-MS-TrafficTypeDiagnostic: DM6PR12MB5520:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB552013F19784EAF7F60BC531F3D09@DM6PR12MB5520.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oEahODQfOMgKy0T4He9EmySLO0TcW/eqnwMcolL+DOjsUvVihCfeGpHy9YX4OF0sJVXpE8VVwUGTRYL5v/5M2Dyz2Kx9dPEYvN1/9rU/4vzRUaWnrbUbxfjmGFZyF033tpgp7d5C0GM3z1tPXHwCb5yaeJLd8KRDE5yaPBnVLoz6ac7fiEI/A/FPZLTZXZD6Bsy81EFOIRUUDfx2df6LjR/CzKI5aJTWIBr4eo7jvhni+YcTX/bzdxFfvhwvu1IECW+0ocBUgxoLFmbgOL543glU3p7lS8RUS+JDai3OabUgQ0T3U0xvoZgNnEJHCqGdoICNIRiqzBQQAB2GK5Sx0A+DDCGTe3N/i5LhZojtuRxvehE716SaoamINQHDpilpX/386oio46QgmMbofBcWDMZ/JsDJiDLW7NSsWnoNNhir6XK3KOUWMzlfARfz8hYwbAYKnmq4VcrRAfiwqoI4PdQ7fsGD4bi0v7dSstP5IoOhWfUK9TbK8TsqRQQBIjAxKZMJBofd5BLOxQkNb92JP6rCBaTN5XzX38eeBlzsjUnvuEoFhyPrKACsgFbklAhyMJDEqo3M04u/lOEa/uYa92V35BGsseJMLvCQLtGly496uZ3oUOPSM8+YXWtiBEYm4Pua7NvBp4INQnwfuUeQV92fup/EKoUpWZUarxVyMehthkQXkWc/hEeFa5kDaIVrbddwpQGaejlNh08pewbOzQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2906002)(15650500001)(6666004)(47076005)(316002)(82310400005)(508600001)(70586007)(70206006)(4326008)(8676002)(7696005)(336012)(426003)(54906003)(110136005)(40460700003)(86362001)(356005)(16526019)(2616005)(81166007)(44832011)(36860700001)(83380400001)(5660300002)(8936002)(36756003)(186003)(26005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:30.7061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7f3945-85c8-4e30-e219-08da39822e14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5520
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


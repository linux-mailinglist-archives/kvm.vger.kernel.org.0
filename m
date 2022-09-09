Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D135B403C
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 21:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiIITzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 15:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiIITzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 15:55:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E6745981;
        Fri,  9 Sep 2022 12:54:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EyTLQyDOAjSVT+MxlOFXtRfW8EF8dcbSizejAEXF4htiRTr3KuOwXoyLN5t3VCt+fBUgmpScn/1PuZmdSbBN6GtKD66VXaMFcBEPIwTGYukpGB/hf0MSfIYl7tMGUM38HU0WTyTMSQVkEQ9TGQ0KpykrODGYxhgjSglPlypWtndmPcOv6DP5bPG60a9Wopzp9IsdBF7pjY5t0zgpI2GW40Ol5jQmkHqiK/154KDOLUYaYbbSPd1OHVf9KpujC6SqZHE2Sr8UbZwMfHSrGQI4wngWnWzl3OwkMtBoZP18hpIdeLio00CcKLvE38SdEBMKSV2PomS4VL5yqQsRZPk2rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnSsIv8C6DvIxJfzUP//+hnjnMdWa6NfPQ1tD9Xw0I0=;
 b=isjpjbAKJxsdNQcEIfJEMtf6TF+YC3OqW3EI7/7KTYeXWiUzic2XVfLqAoy0H4WfYnytOxTgOQBysrvdwPw/KKU0w5xZrByUKUovodhiiNXH99dvjqlXTRh9TcYYabh1c0wNZCS+d66kybWA22wQfs5hvkWD4qDvurZszE8Xu+S5gq72rjHs5W4+hlEHUzvikyY44v09QcRR+MKbUop0jjwgd8kWmCeDAxotWyz1mKPMhmE0cB8unCjVF9AzMBL2KpBUGM18lcAUhmtrdF654benHA729qjwiTtXktUeVvQ953Z+C2TUb2y/3+/NBhwtig9QzY/z8Q7TkyJdutlRvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnSsIv8C6DvIxJfzUP//+hnjnMdWa6NfPQ1tD9Xw0I0=;
 b=0Yo6Y7nPDtsvzx5NoJbjF/qv/4qZwTOPqKfZwG3x4N7rIeCA1EyaWg8OMFIPm+pCHssk075SFZsIVZxxUPRGHqqKNyjeaQ4lr3JiXFtRsagQwrIQd/rWVwE2mIY4UiTXItyWVCL8RbqMMuHu7AEOPEQB5YYqgtOOPnsb5SkOhgQ=
Received: from MW4PR03CA0199.namprd03.prod.outlook.com (2603:10b6:303:b8::24)
 by BL3PR12MB6377.namprd12.prod.outlook.com (2603:10b6:208:3b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Fri, 9 Sep
 2022 19:54:54 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::a1) by MW4PR03CA0199.outlook.office365.com
 (2603:10b6:303:b8::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18 via Frontend
 Transport; Fri, 9 Sep 2022 19:54:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.13 via Frontend Transport; Fri, 9 Sep 2022 19:54:54 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 9 Sep
 2022 14:54:52 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: Un-inhibit APICv/AVIC when switching to x2APIC mode
Date:   Fri, 9 Sep 2022 14:54:42 -0500
Message-ID: <20220909195442.7660-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT045:EE_|BL3PR12MB6377:EE_
X-MS-Office365-Filtering-Correlation-Id: dc8c217d-83ec-4c7b-cd1a-08da929d2a60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /AOz/IYAfs/qs8qp6Fr9d4w8Aa/w1IMt0H+M3HCmz2QpCB4r+ILrTjnEz0R8OnJ0rmSpRoJOuB1MHwDyT/onQLeDI3C9evmXhAcZrfw03AzzKSOXXOrIXZ+ffB1f5OBGD1fwzoFlPU6rbKdPbxDO8Bs9zk5x7gqTZ3Si5ipS+UPXIGUJmBwnNZh9lncE6Uospb1j/QUoLJPbFqklkDV7hRNEQqYe17LGrL9nC9y2zSGVgRSyl7TMXmJVEiMAYxdL7Vjm5E+CoyKlYC5hF2ki/y2WmHRbqAEOBxCl1Y+76HTZpkELmQSqztsXUsR7r6HoKePaleX/fSR/Bv0EUBb+pI8ARka1WX5L73pi2woox85heJD58eofHGa10u5doR2zfrgSJVGs2EjKW+dL5cmkYJYyQSUu7av5/r5ErXczMFZixd4BH+PDF5wtf1Qmc1Zv7q9cJHcKa0aOa/XAM25oKetveYzOTEpDa0LFfXXLIl6fzkJQbt+1PbFDkFwzPq1MkL19r3CRllRK29xhRPs8uyticTJB9y2Rasyunnrap4u1jVe0a8A945a112fNVtXug1Qgq/+Ihsxi+PjpBqIPfcpi4XiA31o6dKJcIMrK4++CjPVwq4lS1OdKqnT0vUo0zJULKZ36BelHN2lRO1mQ9iEImfLxcWfgrGgVGyFq9NnlLwbnSjVrtKpt5TsKzYona7AQY3cvh8T/kKj4VA+3Fk37HegBEE3vNSje+w7qc0tV9y9feqkarA1ftWyEGmrIc9Talyiq9BzTchmUuJzfiWj3BuyBNI9sNvETxB50jbMzcqydmEireMYqGCz57w/N
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(346002)(36840700001)(46966006)(40470700004)(70586007)(8936002)(36860700001)(5660300002)(44832011)(2906002)(83380400001)(70206006)(40460700003)(36756003)(478600001)(40480700001)(8676002)(82740400003)(4326008)(47076005)(316002)(110136005)(54906003)(6666004)(82310400005)(426003)(16526019)(26005)(41300700001)(2616005)(1076003)(86362001)(356005)(336012)(186003)(7696005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 19:54:54.2823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc8c217d-83ec-4c7b-cd1a-08da929d2a60
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6377
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, kvm_lapic_xapic_id_updated() checks if the xAPIC ID in
the APIC_ID register differs from the vcpu ID. If so it inhibits
APICv/AVIC.

However, for vcpu 256 and above, the 8-bit xAPIC ID field in the APIC_ID
register cannot support 32-bit x2APIC ID causing the kvm_xapic_id()
to return invalid ID and fail the comparison with the vcpu ID.
This causes APICv/AVIC inhibition for VM with more than 256 vcpus
due to APIVC_INHIBIT_REASON_APIC_ID_MODIFIED.

In this case, when guest switch to x2APIC mode, KVM needs to clear
APIVC_INHIBIT_REASON_APIC_ID_MODIFIED.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dda989a1cf0..750d385b770e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -374,6 +374,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
 	kvm_lapic_set_reg(apic, APIC_ID, id);
 	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
+	kvm_clear_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
 }
 
 static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
-- 
2.34.1


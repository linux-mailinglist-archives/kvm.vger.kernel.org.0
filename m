Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBE355C124
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345178AbiF1Mdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 08:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiF1Mde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 08:33:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E148D1DA67;
        Tue, 28 Jun 2022 05:33:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jr2Q6ws2xsZrvUKtmpFxEnOkzI+TkcFXgMUkAVTOgwpZnkqdbYvkY3fjSzxD0BFOLh8reggTgK9qA6n/W0OukvTuS/X9p041JqhMZQglfQGkiHrTQy0w4XNaA010pQb/NU2Lh/Ub8wfZm7mqHdjUAiddM9s6CgPAMZO94lbdqO5drI3uAuI2DKSbAOUsFTClt04EXSVsa5thM3E1zE+ulJ0R4b8Zk018yiDT4vzhRmPuJScj32z2CDY5Bq7ptWxF66RAKwJLYAQB9b+8uCPgJDwWCAAgVrqvYKGQ68IPaskoFIlJW3x2yPrGDcByoscSRGujHdg0Gt1WiTMtYCec4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YcKdIQUwmXvswNzp/eojixJuHcyDTnEVCSx9LmKdH8s=;
 b=LJzY1wm90eGVwcEfX4C3EbMduDxwBcVK/YOnsy+U2SatpZ8NWR7S6vwhLzEHHVyNK7+JnJS5dJIHhSYCJLaPODhvOnpz41woC7qTRAd4i9Tld9Dz8m5eztrhYjWkgD9fyR7XDfzkrZ9h0O/s3u0K+JKOseGFU6pjeebcMYD82P2GkV0QUHsx249uGNS9A6aKK0oNBdEWn82nhHYa63lvEtMqOLumIu5qCOBJ9TggpwEi760GsxmWDgdkWrTNoGlBxZuUp6GmZO6f/D62sROAhbQ5CyYM2P4udiBfb4MMoxoZ6ZS2/v/M5kdSv+8bHsVLrRMbcxn56dbl+GSRIC7yUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcKdIQUwmXvswNzp/eojixJuHcyDTnEVCSx9LmKdH8s=;
 b=l3rU/4Oj/lOd/RwEihJhpC4kWX0ddVz245LvQixpLOIzIC2JU5z/k/D4W4taq2c/5T1X6AN+LqHaoZ7VgPUCssl8K8SlI6lWId8LHMfmmSwKIJaQNaYbeksCa2x8PsK2CHxMLBRdwQZx5WFw8QMEueShnlZids7SBL4pIsjKaKY=
Received: from BN0PR04CA0156.namprd04.prod.outlook.com (2603:10b6:408:eb::11)
 by BL1PR12MB5803.namprd12.prod.outlook.com (2603:10b6:208:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 12:33:31 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::b5) by BN0PR04CA0156.outlook.office365.com
 (2603:10b6:408:eb::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Tue, 28 Jun 2022 12:33:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 12:33:31 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 07:33:30 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH] KVM: SVM: Fix x2APIC Logical ID calculation for avic_kick_target_vcpus_fast
Date:   Tue, 28 Jun 2022 07:33:14 -0500
Message-ID: <20220628123314.486001-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 697179d2-56f3-4ed4-f043-08da590268fa
X-MS-TrafficTypeDiagnostic: BL1PR12MB5803:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fokju9d08OKQZDp5g7O/RYMrWbu03Tv6F2aOT1NwP945Ktn2yLNk4BEIC0a1/GZtrEKB+LQ217kbTwwKXosCPvrozk/5r9a9uXmNGFbTyTiOrUw19JbOoBOnKdr5JZvjn3rq4HGaD5hvcLFQD7JipeGmkltLnHsGuYaFn5u0RDhiWp79N5EzZN4FJ5DRp4TqcBeA4hnIslUUcG8nFkRHV+SEY1x+fGtNLl9RIWAWDm5dOzSbqSAD+BwrjEZrxHw2ray2wOVQEoMUjqT6VGQucakYP85/vRpxRYWHo3XJyJ8IqTUnv9/91M2qFiot42SZXeiemWrArY2JLtD/4ZSQmHAM4YLLi++DSHSQreMjnxqqEAmhuGEFXSHwetIw7B0kIDSsyIphFiC7xMkj+5lp67646/bUQUb7MqnJ+U35nLu+Oja6ZqlBMr8NYTDUBiKDUUW/iidPFuS3ps7T5BtDsr2UuPyB6voYWDrkPaJerXkUvsfN5kyrNUPnsTA4FH5KuqHOMecQy7frU3bdMh8eQarxkxb5btt+UG77iRJQV42707O67v1KPace1RE9F9zC7RgIxPLJsXofjfDT6jaUpp2CwvBlmab4gNl02VPjaDP+QCA+i4yC9mxfP9a4Mdat9M2gSTS1/5be6C2/sLXE6sZbUWt8gF+FvJ4hNtMO4GtHTXLxcTPbdLX8illJYU+pzP79EjPLsBNIgNC/BNPm3q1FY/t9ZUNoEGzeFmi5CsfLXqfN18ZcRi1Qf4okBDHiNbqXHd0twW8FZwB0AbkkPI0AWhSN73NnLK1JVsrVEqf4MLi59e3JqwOiQDJ9doah5PRchpsJQ2HbrfYAu0Spaw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(40470700004)(36840700001)(46966006)(478600001)(7696005)(5660300002)(70586007)(41300700001)(16526019)(70206006)(110136005)(4326008)(1076003)(186003)(26005)(8676002)(356005)(40480700001)(54906003)(82740400003)(82310400005)(81166007)(8936002)(316002)(6666004)(2616005)(83380400001)(2906002)(86362001)(40460700003)(426003)(4744005)(47076005)(36860700001)(336012)(36756003)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 12:33:31.1647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 697179d2-56f3-4ed4-f043-08da590268fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5803
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For X2APIC ID in cluster mode, the logical ID is bit [15:0].

Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a830468d9cee..29f393251c4c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -378,7 +378,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 
 		if (apic_x2apic_mode(source)) {
 			/* 16 bit dest mask, 16 bit cluster id */
-			bitmap = dest & 0xFFFF0000;
+			bitmap = dest & 0xFFFF;
 			cluster = (dest >> 16) << 4;
 		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
 			/* 8 bit dest mask*/
-- 
2.32.0


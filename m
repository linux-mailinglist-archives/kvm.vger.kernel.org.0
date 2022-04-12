Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A94FE045
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 14:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353084AbiDLMkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 08:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354967AbiDLMiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 08:38:46 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2043.outbound.protection.outlook.com [40.107.95.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7D91AF34;
        Tue, 12 Apr 2022 04:59:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpT3XcJkI81l0EKuEs/dd0eDY6RXtWtyXKjXFQP3B5NhTgfxjjA8fohpYHZlhzSoOiCdTR2wbSKhD0icePcUA1KEpAsg4mLw0N+aBDLUlcFj3NvrPZ5pYbjARTURXmSWREtzlXqMEAfR2RdU5eN0S6i3bVC77q+5RGycScKF8Q48JrRbZxMZH7Ym2DPMhEWECABDjlj3Y3ljGwAu/Y91HGQsUDYbFUS5nxHNSGAyXF1wz04FFT7H4/eczeRRdQmjxuEbsc0+UCgV36Bow7teDSHdo4OGMraJcjlTeA8go1UjMY5amTsopHLt3t/fN6jiauVXGhdHnaf8jqu9k1prSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRw+cd7Jn0ZJIgZ+XTMKW4Xa6/MroyXyjrhRM14T+0k=;
 b=U0k84iR8XPFeFgFHTAufkZYBmqasvKW9mwVWG9Hk3kbUxvvxupFdx0ORBYRHD9l6LFMau2fNSPCz1f2LCxZDR7Nbp6Z1ITbW+Z7RMSJ5eEHlUlvaFHMRcKWUOCgOmRwknwgUf1E/IdM8bjd9BFbOcsUoLjRfFoZ7jnfUcqKLNK5EZ78x5J0wXbEmrHrIc5ln6zp8NIwji4SCCFyYoSF11MNAcZKWPiZxD7rV7gRfHH76TwKalCbYnS/al7uw6ocHbmyMO48BrMWBpUrrFa3viXICGIWuMM0/mnt/785d7MgDjGIvCbtF+2IBJ8pd/8Sc4xnwZJAVYiC7+uU8qW6yew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRw+cd7Jn0ZJIgZ+XTMKW4Xa6/MroyXyjrhRM14T+0k=;
 b=1SlPhtV6FBgPrmNpAYH9d7Dyo1v0aNfEKBYBHD2aAiuenvJdp83+i1V3vdfdXwKay/F4HMUhmoZk16s+cYy/Qqzjy7hO0Xh+jJVgYxHLlc0UtrojO+1aWMleBasX9UequGcg9vGZaKjJmyakoQJm6EAEJLW+pF9lTOkF7ujw7ow=
Received: from BN9PR03CA0681.namprd03.prod.outlook.com (2603:10b6:408:10e::26)
 by CH2PR12MB4296.namprd12.prod.outlook.com (2603:10b6:610:af::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 11:59:08 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::84) by BN9PR03CA0681.outlook.office365.com
 (2603:10b6:408:10e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29 via Frontend
 Transport; Tue, 12 Apr 2022 11:59:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Tue, 12 Apr 2022 11:59:08 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 12 Apr
 2022 06:59:07 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v2 01/12] x86/cpufeatures: Introduce x2AVIC CPUID bit
Date:   Tue, 12 Apr 2022 06:58:11 -0500
Message-ID: <20220412115822.14351-2-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: c0c3f521-7c92-4eb1-658a-08da1c7bd99f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4296:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB429693546DBF2B63447ADDDBF3ED9@CH2PR12MB4296.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79d7xUc+Sk/7BBmXYHdTgK9NEHOHjxRngWCh2MlMzDrp0sDGEyhHvQ+Aqn1oI9rI7sKaQweaBqAVcX4zXTwmmj03I9DfvCJ3rAGBeRa9k9p0GshbZY0N9Ks8bBDFOZipiZhPJW7gMg0WP677icQAskDJ9rAtVupsOY/dTL5wnMNVthi17tjMoilKfLOd1K9R+5EzW10HnVl6lkVdaFzTBhYepIhOanREKNG1eMPpaip8c+CopDmkKRpjBCqAorRKxYWh+gw1ZJNS0jJgcV6cxuMqR++L1wc4SSBUK9ue7x7NTBln5BVelcYKald36e9JhG4Ef4pWtKBIdz9PqZONWW8prdPxEwqaDZYQJADISJ0OLDDT72jEwCiDh1oDiKJopiwtg8o6DuQv5r5LCSgwWUyx4SuXNlAnBHakMsW9Hw39wXoAYSYLw+A2bJDAXPbLucY/+Y5W4ARLMmyYMu0F3maT/YXr/+qOnHylNkF3HEjY13gnqERLXpcrWIu1h3sSbFL6X/dC8seRMBwloOs7QZG9U0RVo51YyngYv+01WC4OXCF3hrDMcUd/Qqx3JHJ9liSqvL8w/IcuN8iX1gOGbZSITF93WceXXLC+Pvuii8a0b2B1Qw2CVHyCsZVHohxqV6ZPBeVfdLVT27rTCmbk1q1G6GRckRet/m8wACCwHIovitkgFhzMGioeSyDaIyCTbka/yOqlFL0i4J8wCKZ+ZQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(5660300002)(8936002)(54906003)(86362001)(110136005)(81166007)(508600001)(4744005)(356005)(36756003)(6666004)(4326008)(8676002)(70206006)(70586007)(44832011)(7696005)(16526019)(47076005)(2906002)(2616005)(1076003)(316002)(336012)(426003)(26005)(82310400005)(186003)(40460700003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 11:59:08.3378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c3f521-7c92-4eb1-658a-08da1c7bd99f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4296
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new feature bit for virtualized x2APIC (x2AVIC) in
CPUID_Fn8000000A_EDX [SVM Revision and Feature Identification].

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 73e643ae94b6..ece314d43e08 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -343,6 +343,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_X2AVIC		(15*32+18) /* Virtual x2apic */
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
-- 
2.25.1


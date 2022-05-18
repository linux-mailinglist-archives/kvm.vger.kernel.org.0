Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B6D52C05D
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbiERQ1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbiERQ1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:27:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F9E68F8F;
        Wed, 18 May 2022 09:27:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2RP/cnlO1PAzVFSzVCWFKo9+WKA/BLI2LqDi4obfj2ni5o71HdQsCi3PfZRJrsotLu/X5R0bn8+f97u3TJJhAoJaTSbkk7lrjp4poGmSR9XC7tVvd8co6XKTq9wGIYDwZU2Osk9Gmyf5tzePoq3kgAuoolKycPHxwQvPST/zQnrPyuyylH6EpMjnKm08oFbB5aNwLBiAST27w2HO3evFTfKkeSWy8zbGbhRVEUuYSt7wTWiPCfvb758tKNfg+fSTWp11bMB5BVW2l9ZUo1rbcc3lpe9JpRwJfiTOH1mk3x8FxEl56ku2erqSqrbnbvaRp2uOSKxIo65Rl+mV7MEFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIxqo7TXYYl0T+tYZvoLGn2rk3JMESoQytRIcfR+RbQ=;
 b=VrkVkiXJ/36ogQ/HCFUMWmNaPKzJEWU/pZi1WB6jPn09KhNzAb+6YZ7IaNmanFI972CaJIumCABBBIs3cBVdzN3BuJygHKwcMbAaARCpcZ6KJ6eN96VUWgmVGSQlsqkxCleRw/Vh9ziQYbJPI2dP3lqgQ27z9ZYqLBEDPVYSetXFLOcGd67n1Tys9MpKCfQbWzBa/nizQcqD51Ryngu9LCuGmGXf9ixfHtDDsqW/WDEu9zY5kw+WWq0sh8n3PAWNzzIwEE1C5MzRD/m7rw9TOrspGMYaYvquxO62kFnh6Gp7aEB/2GVR84cSpT4r4hvf/IiHOkXhtLiGUetsZW9hzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIxqo7TXYYl0T+tYZvoLGn2rk3JMESoQytRIcfR+RbQ=;
 b=MzFXOKQPfw/PS8SoS203uwypxQHRDuekC7AUTC6SVqD7NW20ASDHEGUFfCENCiJYjB+yfd5OvmsWXcea4S6IK8uQOIGxERs4eTivlYfgnkfu0EhfT+jn7a+oiEt7FreRDEvAtfyhLYd027xyW4UGkpOao5S6w1RWMmNUep8MGB4=
Received: from BN0PR04CA0178.namprd04.prod.outlook.com (2603:10b6:408:eb::33)
 by BN7PR12MB2724.namprd12.prod.outlook.com (2603:10b6:408:31::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 16:27:08 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::e) by BN0PR04CA0178.outlook.office365.com
 (2603:10b6:408:eb::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15 via Frontend
 Transport; Wed, 18 May 2022 16:27:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 16:27:08 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 11:27:06 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 01/17] x86/cpufeatures: Introduce x2AVIC CPUID bit
Date:   Wed, 18 May 2022 11:26:36 -0500
Message-ID: <20220518162652.100493-2-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 48581b35-0396-4fcc-fc05-08da38eb40e3
X-MS-TrafficTypeDiagnostic: BN7PR12MB2724:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB27247A8D9580878AD430E474F3D19@BN7PR12MB2724.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHgx+jVm/4jsqHBh5wazmvxYD6td4ev7lht9lTBaJBQKR6/i/bU9wnN0hAf2ZBvMVgoKmdPDchpbhHfYhOzhAxbiNh+wWyp+vvn89sRiX8wyw1UV8qfd9gB6lWPpL9Hwldy4xn887r3MOYH/29W/Quk/TpR8vkzOHg6jQWEkYKIoER65bsYv6AVitsndxJIKg7+GegT18Mn+jNZGaWAYP1+6jw5FBZJh5/6Zc7PZhycqSZP4WMEDB1M5CLny0DeIsaLmqgThbSsrukrw4EYkE0cqpGyuxLclz+3YlJm6ie58Vf6jMk6cvVCM0Wo+wumvF7Wkc8IOJTNlmI00upyyuHdzuJYcX9bvR+/zNZHiafiWCSPLp45HdDE2E2otofrpOBCwD1tqtosYwBT1K1XjYEXobt3MY87lw4saiw1sPkdbhbYq4VsckV/n1JrM6CRy3dwmE1JIjjkbFny2dp44yvikcv18T2b7SpIQse0ujUAbQur1waeTAHtoPmeVohGdvtMXIPQW06vO3frtLR25qcC40pwqdcptk30w6Aeo1LbMjY/J+UBy1YHC9aV6XO+omeBQKWK3iVjtbacXEkUs9XrVpq+iZfiqz+oMpwtU49OUgAcyFfi8MJH18W5Q/5DaIlJHQxnQum85BpLgfvMHZYxncwy9aobA38AX4xW17JwqDNDCQNXwLWlk0YPijm0sroBdP5sHCjx2RMRX9vSdyw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(316002)(70586007)(426003)(70206006)(336012)(2616005)(1076003)(16526019)(356005)(47076005)(186003)(36756003)(2906002)(110136005)(6666004)(508600001)(81166007)(82310400005)(54906003)(5660300002)(8676002)(8936002)(4744005)(7696005)(40460700003)(44832011)(86362001)(4326008)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:27:08.2718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48581b35-0396-4fcc-fc05-08da38eb40e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2724
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
index 1d6826eac3e6..2721bd1e8e1e 100644
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


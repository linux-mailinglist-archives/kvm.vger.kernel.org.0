Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1ADC519849
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 09:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbiEDHfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 03:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiEDHf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 03:35:27 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17848140A6;
        Wed,  4 May 2022 00:31:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njm7F09Sqq0fDFF0WVJUqZwc44Md7lW7npBNyKG7bWgOvObalgt4xZ2A+C9HKzxb4jTAiMVIb2BYFxI32iDovKW3dHpSib69r7poJjWskbvSekULjMcZo1+m9FnWWJdlYYIOut1M5P+OlaG72k9twEPHtRjultGDcGRU90FIRSvxQhgXfaGgiiGkuJKzzxJKIFK9nTMr6QpmOzK19kwBktdJVM9g53bBiScp/p9zOfzffpUkuBTUlMahhO6ZI+aGsrpXyw5uhdvupCg10Sx0iSgGev3M5ADfGbHWz6+fEWtfgKfqYXgFsNS4CT2S0vY9ZkMD6C7JO60mqJKbytaJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIxqo7TXYYl0T+tYZvoLGn2rk3JMESoQytRIcfR+RbQ=;
 b=foYQM17885vsn1ARjtaYSZ891uRbkrojbRJxDEBDeLQiV4C7aH2iZNUTefjgbCrDEmbBioK06k3Y+hNxk6B/+E1ifG4YzdilRxBrS5G6u2jATLJK+AgtGSuAn6yBdIvHq0vcWj6yXfAo+HPot+NMYJVQetrxNqU+AZ2sq8QSdhKrpRdTWOsPuRy0Nyw8XS0/bAHZh7TgWSAMnppvhP37MrrxcnnFL5u8aFXDqg9bvqVlEfSYv6VQ7SfZ5R0+xEbBzby+MZ5GzODg2mc6S8nxWv9M/8E8QauVH5bnMwhoFpw8on4WcC9WjxGZz2xSZc2kMrFDlSJDlOGLKie005ABkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIxqo7TXYYl0T+tYZvoLGn2rk3JMESoQytRIcfR+RbQ=;
 b=036EV9WXw1XC3KdVyJ5D60U78mdHdDvg3AIFpVE/1FcjGR3Infi9sRW0E6gF+7FbNxoTJondYbV/GyV5jPQffZWrE+yJIoxfFKUPlyZL4B4RlrUHUUSc1WqEvhm+qJZE9m7WPKeIWwyL2/aNAbAT97V2IAAGiz/y5KhS1Ofz9zQ=
Received: from BN9PR03CA0728.namprd03.prod.outlook.com (2603:10b6:408:110::13)
 by SJ1PR12MB6170.namprd12.prod.outlook.com (2603:10b6:a03:45b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.25; Wed, 4 May
 2022 07:31:50 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::3d) by BN9PR03CA0728.outlook.office365.com
 (2603:10b6:408:110::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Wed, 4 May 2022 07:31:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 07:31:49 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 4 May
 2022 02:31:48 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 01/14] x86/cpufeatures: Introduce x2AVIC CPUID bit
Date:   Wed, 4 May 2022 02:31:15 -0500
Message-ID: <20220504073128.12031-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47768752-6fa7-49fe-e412-08da2da02718
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6170:EE_
X-Microsoft-Antispam-PRVS: <SJ1PR12MB617026B1C9D189D7A62EFA7BF3C39@SJ1PR12MB6170.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZyTJugCztD9v/vYMap/6J1S2y+nEJkYG+a+PhRLFgu7CthYE23vxG1Kz8P3PepczsWINHuGcslDCC9fg0DEJmrF77AgPONlcj5HuCEjDKHxNJBsexbR0O+ytFBPJh34bsx1w41WKKPiNqOmYYqkknelEgAPLNpKZxGkMvVhqlOBma4J5gXGCFM2R7w4V0Zyk+BExC/gjekhX7ZXP7Ei8+v27md1aE3O+DgCgANK6aqtqmqh1F3HlIEumb/YJNe3YaMt+5fYwU4oOK/uMl6S6oY8GA41dQXquC9UhHeenM8PZmQHPJM+LVKhsOoZjeF+ddKF3l2I3B33DSM4JzViOd66aYHxOL4/gpx5TR8v38MY7O50UaEXbbhCR3WyyK50cjDk6+LFCKI0AiKM+EAYerq1OICJTS2uDqluidXkooaPpPaO+qB54NYNsSeKdGy7PIgF6QGz5aduX+jKXkBB+0npGoVWlUZn3IZkmgXWaEeNcTujOcs6l98wfy4dQEM4pPsHvwDtlWFh/8iBU+VRK67Uwzx+0yCIfVnaTAEOR06psFQ1H8k8uCm3UK/VCUFP3nCEZYqJyUL6QcqvvazLhqxXa5tNpgzCKHGmt0ucA1u4cakjkwRC3F9vE3ey1fNSZZNnA2reJNmzqJk/O+VtIu3PrQJECIKp1EZkFOL81E5DVUFHu4FykI9UgwDoFH+nBCG7aMqWGyi7mJGEkNXZF5Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(316002)(110136005)(54906003)(336012)(426003)(47076005)(81166007)(44832011)(82310400005)(5660300002)(36756003)(4744005)(8936002)(2906002)(86362001)(70206006)(1076003)(36860700001)(70586007)(2616005)(508600001)(40460700003)(186003)(26005)(8676002)(4326008)(6666004)(356005)(7696005)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:31:49.9525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47768752-6fa7-49fe-e412-08da2da02718
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6170
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


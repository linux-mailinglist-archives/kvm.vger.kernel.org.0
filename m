Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C48D5F0E96
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 17:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiI3PPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 11:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiI3PPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 11:15:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0138C76474
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 08:15:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc7WjGcOMfyaNByg2obUBAjNHrVClZeNoqh8rjq7BUPUkpP2+mtq9d4+9cvm/os/sPbwGUc1it38zCJHoENNKjWDdwak/VVyTaN/RxcZaLm3J35Kw62gYu1rmxXUxW9KgbgsE6MresXVsGh8voyEGVIZzBZ5GoeeKtGJOzuJf8cGNo9DIEL6aKZkbvW4n3UKZJFZJn9vQ7eC2Yvk/N9jT8XJL7T6uCZzJaIMVvK+C5fWWFy+9+ovX59xabZyPtp1/5nqdGlO5cVDHA8YlbR8HX1z08rCM1jXXjALvwa/Rt/gvO3bNbzxry0BNs843pQx0a1O2Nxp0C6AXvV36YVjQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8p4b1w4rnquY8PiNlpi7Ul8PChbGJzBJX7pWBqONVE=;
 b=WlCBnU/w5lPNraDXh1YxyYQWaIePvGov1TYyCn2LUwDy7UgiPHKUuL4gzc45VTEMHd2ifBMqfQZIL7mWE78Lcx8dl46OAx0ZM0NTGLMkWU0/13p4WEniiCsCVsjGYvg712hbsIv7M0aKgm5Jij78BRPOVkZmQt+VNE0KsRKsRNA6Yd2av9xqe7fV0XlgcxOkbWEpb1fVC+ZvUUk1iaXH3ONBp6puxd0aG+2BWJoBdpyyNTnqGtgSOEHbGV0r12awX8F+eutqqaiiMAErNzy/ud128tlul++ZRbqjXdd8N1wl6RryhKhpy26lvXjIXDdY9uEqeQVQAoUkLhBW2Ag0gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8p4b1w4rnquY8PiNlpi7Ul8PChbGJzBJX7pWBqONVE=;
 b=Q1iD/FmP5PayyJ0l2tsU8nR+fAilaxQCAGfa9msjbPgrvbOlf6jnSUpKQs8V8Poc9SgkNIZGaYWA9stckk3W0XCVOtZP3XkYLvQ/PORdpPM3bQcfQ5ZhIpGPzVbYWnUqsenFiuIwNbbqqmEB39tLPIcjo2NFB8XmP9KQZFdlwWk=
Received: from DM5PR08CA0043.namprd08.prod.outlook.com (2603:10b6:4:60::32) by
 SA0PR12MB4558.namprd12.prod.outlook.com (2603:10b6:806:72::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Fri, 30 Sep 2022 15:15:14 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::45) by DM5PR08CA0043.outlook.office365.com
 (2603:10b6:4:60::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26 via Frontend
 Transport; Fri, 30 Sep 2022 15:15:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 15:15:14 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 30 Sep
 2022 10:15:13 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC:     Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [PATCH 4/4] i386/cpu: Update how the EBX register of CPUID 0x8000001F is set
Date:   Fri, 30 Sep 2022 10:14:30 -0500
Message-ID: <5822fd7d02b575121380e1f493a8f6d9eba2b11a.1664550870.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1664550870.git.thomas.lendacky@amd.com>
References: <cover.1664550870.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT057:EE_|SA0PR12MB4558:EE_
X-MS-Office365-Filtering-Correlation-Id: a28f63b2-5b04-4a93-b9c9-08daa2f6933a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ijz+ph1hsWbs5zaLzVzC5mEfHaEb2J/MQu6fw43EhjK93pOIW3OOT3BVgi0Gi9vAt6HDOHfXbAlyN4jcHKYzxV8vl0UsToxt8Pz6Fq4RRYZ9WE8EGiegB1S+gxwaC7sngDY8N4XdfAKA9XFqwORha1z8sTd4e7DiGYzx2IskFWe7kHIklCzgvq5sOnJpfbLNfnIMO/DaWY5373VjEdTx34ib0AdUH9QVdIVjsyP2LyFrKevuEascVv5RbN+Kb+hpkMx0qMCiiqZNIfOkgTEhWdE6qhCkQpvTYAWBHtAArELnqNAq8pdNekzC12zKqzvcMOjrQ8mAbc1iNrFvHPk+l7LWAkSCFnBtyhP8LMoWrIzSp1oB25cKDizTeLT//1rivbvrpNiYArInF7R0sbQSciZksQq309mLTR5GVOOAuKt8LwT3eQDwowuYS2fVkhLDcWMy2vS8YDnFEyXNRca2IFpR5+Ct1aGEICeDToGZV6+yyT9B4avzostB3HPEvKai+4mgs5CstOfrJhocxRjqoeqPHA3KzIL4HNtCGnjM6GhIBs8sDQVvVNvRoVbY44tCAJ2pcMfCKaU2iSQA3FYosT5QJ17aiwipT27majVQQ2ly3NxfFL5FDPe9ejFSWcPWMuvYBVN0QjlHF1ckoBg8GfWyXNkFbhn6C7jX/Pw3bYtOKpS2s9lEstZ86Qgz+txumcuwr2O9DG/SN+xXMiGEaxSBNOMhVHuEDC0iC9NE9oYQC9nt7Oo5ZYuuPjw8iiSub++rAVP+ZGv+egZoBcZyv2/7sx13sEx0Jn2XvFFg09uWPsJPzNgbSiI6rTVqgFoj
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(426003)(86362001)(47076005)(83380400001)(336012)(82740400003)(82310400005)(41300700001)(81166007)(110136005)(36756003)(54906003)(478600001)(316002)(6666004)(40460700003)(70586007)(4326008)(70206006)(186003)(16526019)(2616005)(7696005)(26005)(8676002)(40480700001)(4744005)(15650500001)(356005)(36860700001)(5660300002)(2906002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 15:15:14.0850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a28f63b2-5b04-4a93-b9c9-08daa2f6933a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4558
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the setting of CPUID 0x8000001F EBX to clearly document the ranges
associated with fields being set.

Fixes: 6cb8f2a663 ("cpu/i386: populate CPUID 0x8000_001F when SEV is active")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1db1278a59..d4b806cfec 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5853,8 +5853,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (sev_enabled()) {
             *eax = 0x2;
             *eax |= sev_es_enabled() ? 0x8 : 0;
-            *ebx = sev_get_cbit_position();
-            *ebx |= sev_get_reduced_phys_bits() << 6;
+            *ebx = sev_get_cbit_position() & 0x3f; /* EBX[5:0] */
+            *ebx |= (sev_get_reduced_phys_bits() & 0x3f) << 6; /* EBX[11:6] */
         }
         break;
     default:
-- 
2.37.3


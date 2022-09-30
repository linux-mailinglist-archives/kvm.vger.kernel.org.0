Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA255F0E94
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 17:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiI3PPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 11:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiI3PPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 11:15:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7665A3C0
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 08:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nO+myY2/uWiikVN+ARTXnKPDCsVErp1Exo9Ne0PdVXJFJvK6ULjeROdIXmHJ4YeA4daI8N+8esBvsz586Vqpm+NeuEeIz7/au/CEW9j/fL7B+29Rqi8JkGmtWatQCs12/DslYgNbEa+dQraVgOjTrlwyN3QhdozWKgOp+uhi4U+BuVlIXTXbEpi0GxdQvmAo+qrL+c1c21hi7+awMNXbqa4BmSlh80JJ6sY1kl+VNCPJusoQEfB2fhf0CeZkwFckMUeEnlTcgXc1cfZDWyDItGqJHDW7ii3q8PTYccID87NpvgSk0UvmuMcUASdDTXtmU5eYn1azYIZmQrvaMDvKsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCsVCwffb2vojkLdLT9BTCms2huNYqdI8+2y//lbwbY=;
 b=moZX2V69RL2qD2t1deYryBr9etkEOJcOywi8ydWb15WaVYFeTzq5uErnlyhBCiosR59j6f1Uk9H8P9c2F0uVHOQnsZBrALQ4RWcyvDraZpiqgIzm1JdmNDGa4EPb0Z8MfL/OTVsDA8gi2eIgWk050BFiyh4tJouSFM2V8U64oC3eh6q79rFBysT5Hafi7cuOy2IK3ZljyW7F1saDlLTj3Jgouq0quEpC4Jukxn8rs1jTJu9So70vR5TDw3bQNezheRs3/qOrmpFSePVhA0EDie182XSNUyoWXpx4hpu/S9gIYP/+9ELIoqQYocoHbm99WKtok0LkHVyUdiMvfARj7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCsVCwffb2vojkLdLT9BTCms2huNYqdI8+2y//lbwbY=;
 b=t98K73bFqzIZUNC2cQpuAYdJwv52uR07Colt21IVStujgjm1cGm8yiEbqAiv6nkfGEIB0ymY/im/nXnt860pekR+YSsUw/Yx/hzKJsKt5DTUxzPvjwQM9t77+Zw4CfQKmHWkUGOh2ndUrhm/pDLtF+ZVQcBXILUZ+GHBXuMP2xU=
Received: from DS7PR07CA0021.namprd07.prod.outlook.com (2603:10b6:5:3af::23)
 by SN7PR12MB7203.namprd12.prod.outlook.com (2603:10b6:806:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 30 Sep
 2022 15:15:07 +0000
Received: from DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::97) by DS7PR07CA0021.outlook.office365.com
 (2603:10b6:5:3af::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23 via Frontend
 Transport; Fri, 30 Sep 2022 15:15:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT070.mail.protection.outlook.com (10.13.173.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 15:15:06 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 30 Sep
 2022 10:15:05 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC:     Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [PATCH 3/4] i386/sev: Update checks and information related to reduced-phys-bits
Date:   Fri, 30 Sep 2022 10:14:29 -0500
Message-ID: <cca5341a95ac73f904e6300f10b04f9c62e4e8ff.1664550870.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT070:EE_|SN7PR12MB7203:EE_
X-MS-Office365-Filtering-Correlation-Id: a7000f2a-de05-4b0e-7302-08daa2f68ed9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kGRQe1oqaVmbcKrAbMDeh/iPvhuOp3wqCNFISjk9GRvLn1TkaKKHlTu89mg3sjPocLtImP5wGSAVf7vS4oGB/sT0pmdjSXiatFozFB49cCdjpjm530vkaKSLOV4JlnZHBj6YLAQsT/cyZ6yraMtws1/vNhTVRswa4dneJPmnIFLP0/640AC+Fe5lV7Uvij35JSunHUd1z2nYxl63Kqn0INEeyNuhLGUteGzVD6pB6a4ULGdvw6GfmUc2j8g971G1aC2uiz4v2LZLp7HV+rP/A8r+Yd14mqdhj3o9WZner3VKLta7Hho9zjc+lvl3n1tCSRhx4aeQIoH+CJf118DGwqZqFmhqwM6muMjqbT9WLGXVXdbSMrLbjo9z26b+72d//nNNiPXdibXSsJmD33GBKLnXRawIvLKSqV690C31i0fLnhF81EO6bETbBshfm5RzuNusvn17Sq00vAfM/ubSrRLjdL1K8lys3ZOTDM5LJKtgGVdakbmrp6YwcHeo3Z3zaSkE5jGLlWKwFraREY8CfxczDzxsrThhDqUXRbO7tExDx7hYUxSN2R8msuUzCFov4vj1VQRUqIKcgwf3zTUSdbELNwB1dRL1sxrutDo/jbPFWySBffBJkoq4CSq1cpozkmbA/Y7MSKvRCBbZyoR93LUQWjMM53cqRL2RF/4Yu/ow+u2E6Ju6sUVU+526D+1hNTOj/G45N2UK3+rxOIQUtyxzK1TwwnA52YIynzzsuUuJwz/AsXft//Z4vtV0l/s2ai4IzOl+/Rk8KIKoumI3QTpuWE8RilHjtktngFGJY1XNJ8CoontIcHe9R/9xnHMe
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(86362001)(81166007)(82740400003)(356005)(36756003)(426003)(8676002)(2616005)(26005)(36860700001)(40460700003)(47076005)(2906002)(8936002)(15650500001)(16526019)(83380400001)(41300700001)(186003)(4326008)(5660300002)(6666004)(70206006)(478600001)(70586007)(7696005)(82310400005)(336012)(316002)(110136005)(40480700001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 15:15:06.7522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7000f2a-de05-4b0e-7302-08daa2f68ed9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The value of the reduced-phys-bits parameter is propogated to the CPUID
information exposed to the guest. Update the current validation check to
account for the size of the CPUID field (6-bits), ensuring the value is
in the range of 1 to 63.

Maintain backward compatibility, to an extent, by allowing a value greater
than 1 (so that the previously documented value of 5 still works), but not
allowing anything over 63.

Fixes: d8575c6c02 ("sev/i386: add command to initialize the memory encryption context")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/sev.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 32f7dbac4e..78c2d37eba 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -932,15 +932,26 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
 
+    /*
+     * The cbitpos value will be placed in bit positions 5:0 of the EBX
+     * register of CPUID 0x8000001F. No need to verify the range as the
+     * comparison against the host value accomplishes that.
+     */
     if (host_cbitpos != sev->cbitpos) {
         error_setg(errp, "%s: cbitpos check failed, host '%d' requested '%d'",
                    __func__, host_cbitpos, sev->cbitpos);
         goto err;
     }
 
-    if (sev->reduced_phys_bits < 1) {
-        error_setg(errp, "%s: reduced_phys_bits check failed, it should be >=1,"
-                   " requested '%d'", __func__, sev->reduced_phys_bits);
+    /*
+     * The reduced-phys-bits value will be placed in bit positions 11:6 of
+     * the EBX register of CPUID 0x8000001F, so verify the supplied value
+     * is in the range of 1 to 63.
+     */
+    if (sev->reduced_phys_bits < 1 || sev->reduced_phys_bits > 63) {
+        error_setg(errp, "%s: reduced_phys_bits check failed,"
+                   " it should be in the range of 1 to 63, requested '%d'",
+                   __func__, sev->reduced_phys_bits);
         goto err;
     }
 
-- 
2.37.3


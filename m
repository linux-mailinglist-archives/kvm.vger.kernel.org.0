Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ACF512C68
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244896AbiD1HOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244886AbiD1HOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:14:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C76A81491
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0N8aBokg/wzVBfakaGiM6YoSJaZbqcLqMV9hqSriTuc3tjxXuj2XbSTNlGxmL59wTEetLbR5uLTcCDyI6CxAz/LjqMrZDclT8hkSeRziz3bZatSsRT0qAJYB+jQOvy3zlqSiAhd4RZY6HFXjVCJX63LvqFLkKg96/SsDKlKUbiCS+FaCNl/MUMkRI7vDcbjCCrQWW1SqjboSKCHUqPyZ0IV6F6slwXRbJ9g2lfK0hAVa1i62ZnGo5OOC8h5dTBjFSRNOv6TNPTgRzBEOARS5Br3uVkjcCCcLlhb7rs1JYnk6X2S+lSzBzzQ65nNE0LSt3kUrgYP4XGceSR0Kd2rqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afLz6ymCTxhBM+cMUfD7Ernu4k6QpU4c4t5M0qzpWyc=;
 b=VnKuxxd75xjtKuorwUZTNpT4E9lsxfN0pUAB8G2obKLfZTBQPMl6tt/3+k6HbAYzPmUlLSK0s4t6XwfjZn4S1O8b+Fees6F+H0tf3KMGuxEOoVFmH0Ny9dRiuqYC8Qw+VGsFUw5b6yaCqNk391AflXKYlSfNpPbFjaTYCtM3KFHk3evOv7Kp8ANhPhkOsGR/LQswAF9muj02YIcmv/FGv1h3tfv64P+SjvXq0ebfMUDnBlUxdF0R1YhQMyX2GRig3XROsFntETSzjOC8NL+bLoApoeTdi3EdvQneqzz2yeLubtW+CSHEIpKqxt3ndtHOKlm8tL3X89W4XCVlCpM6Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afLz6ymCTxhBM+cMUfD7Ernu4k6QpU4c4t5M0qzpWyc=;
 b=a0q9VXTthrD4hGhWd4oLq2OfLMt3ZTv6btN8jEov7vrb8cElhslAB/33KxLe9xZoPb5PlT3BFhnbPt/84npIfJ4mwj5qQxA4f0sTlbntTP0vXHrWxpfsfKVl6tsvSuGpgbsXjgpbzt0eq6k5uQVYXgNyf0n2KLJESYBUVMgUl80=
Received: from DS7PR03CA0291.namprd03.prod.outlook.com (2603:10b6:5:3ad::26)
 by PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 07:10:54 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::75) by DS7PR03CA0291.outlook.office365.com
 (2603:10b6:5:3ad::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Thu, 28 Apr 2022 07:10:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 07:10:53 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Apr
 2022 02:10:52 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v4 3/8] x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
Date:   Thu, 28 Apr 2022 07:08:46 +0000
Message-ID: <20220428070851.21985-4-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428070851.21985-1-manali.shukla@amd.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6059f7d-ba95-4058-1bc2-08da28e63c02
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB568524D2EE96282A2B89C09BFDFD9@PH7PR12MB5685.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Sz1y6jpYvPBNuadrw8UnJLIuKuCDJWZHv82+u4NpodtI8UjsOTaU/IidrDrr1WiOfyOT58e17ZTHmzaNBF6+OFY+nP+Ar8RVJ42yG4pWcDJto/baQNnOsDW8TJNWfQEjQAj9S/BsdJHMtctqFC4XkOBTSXr3PoYAz8WAg1mMbNvVSfkYC+zAss81I2ihOeTZpNXEyIsJqE/CwwR1SB0nDDZh6vuHFHedfY5wc/H5TIFDSh187Hjo8Bwr9SZZYmX5jHjYyG4nVQLuaeLnYmV/rsHtTDcb9JxF/3y+t529P6FzAPV3qgwKz17CBbLRfbicX4I70ffb4/4NljRzbjli3dZ37W2fKKpS6CrxOqp/bzwA/C9P73q+G7uFE9cooX+L2wnA6LEMPrjXrc4mUrZG08CQbBkmGMp8mD3xXx97quhbi9lEBW2LciGp6+JQDqazp3Y7BGfWWflaw8NUPFGNmyhHx3EED2MGdgKDCquB5mOjF7duA6FUCIqiTHdIz3nNvuPwfce2tdPUPlNJffXqDuHYm0BT5aEyGA6XEZR5qglmhC8TP6KkEXYbXV3GmVv3JrPcKF3O5Arh2mZ51eknAdLJqJXIUyesEVjgHnH85F13YOKS6p+OR1VbJb27WuFc3LcS2kiVxjVA1wSmAw4e7yiYycOLj7A5UeGf9HKtWUsEV6Je5fdaI8rJNUaGKNztw57xdJZZ1j8mMuDKWDIhA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(336012)(7696005)(8936002)(83380400001)(36756003)(36860700001)(426003)(5660300002)(47076005)(16526019)(186003)(2906002)(26005)(44832011)(1076003)(8676002)(2616005)(86362001)(508600001)(4326008)(316002)(81166007)(70586007)(70206006)(82310400005)(356005)(6666004)(40460700003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:10:53.9613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6059f7d-ba95-4058-1bc2-08da28e63c02
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5685
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 916635a813e975600335c6c47250881b7a328971
(nSVM: Add test for NPT reserved bit and #NPF error code behavior)
clears PT_USER_MASK for all svm testcases. Any tests that requires
usermode access will fail after this commit.

Above mentioned commit did changes in main() due to which other
nSVM tests became "incompatible" with usermode

Solution to this problem would be to set PT_USER_MASK on all PTEs.
So that KUT will build other tests with PT_USER_MASK set on
all PTEs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index f0eeb1d..3b3b990 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -10,7 +10,6 @@
 #include "isr.h"
 #include "apic.h"
 #include "delay.h"
-#include "vmalloc.h"
 
 #define SVM_EXIT_MAX_DR_INTERCEPT 0x3f
 
@@ -3297,9 +3296,7 @@ static void svm_intr_intercept_mix_smi(void)
 
 int main(int ac, char **av)
 {
-    pteval_t opt_mask = 0;
-
-    __setup_vm(&opt_mask);
+    setup_vm();
     return run_svm_tests(ac, av);
 }
 
-- 
2.30.2


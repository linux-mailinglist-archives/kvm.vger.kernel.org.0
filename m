Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CF350D6C1
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 03:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240264AbiDYCBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 22:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiDYCBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 22:01:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1746D53E15
        for <kvm@vger.kernel.org>; Sun, 24 Apr 2022 18:58:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWrBeZvn3+9gioPMiEGzVBezkwhfqI4LWrCpZO39b96WyVJy8J00QuBEw9kG9qfzp4GdTHstbxso0TW5NHhjtmMjga8mlT2D830eFQC2WCN0zrJOljdD0MMIq/rXSApS3cSjdhIj90jYEmp2PkDnTcq5uMKCJZrljxxL7lnozMBeEucNNH2cmV/qm28uXSoDLKmkHroZI64+xVLtfpAuCdSml0Wh/7stbyCTULx+tc6Wit6qATqlbNVf1f7JnbiHlPIkEYMs15K28EkAbiWGvUB5Zx8meBeRCTJRIeI7DfliZo1h3vFMW1VlSKd1vTGU1RZnx3CvfOnKX8yYa/bEYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQoMxsKRWvk2zoRApzSmN+kwdM16YC7UU2Rv6UIx/Sk=;
 b=YnU8ChHsMgm2LATPrmargDv/8Y6k8xY+ieWx1mmrh9NS5WOuN1WFELXP/TFC8N7CQV4q4v6Vy2dNolmv5pbfcKRnw9LNGBJDOfWQx2/TSiQNM/tsxHdzy4Zqh1S+ETypNA99AoaAMBIzKz4pvjILsZPjYaNhAcdwz6b7aUOVbjfVvln5GR0fCAXDX9REhh14aGcV/Zbs4QxaUH97Uibgg7Qzebtx9kfZrG00jSDUFiLT2UGRhDDE8jOrU5KSZOoimv7+3NqPcPpRt6P2tpH3eu1Rxc1s+sxY2ClNJ2NQclvysAsH1DYGQAQ/NC+0QL9jqn4KAGSvv0mjVXqSmKMT4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQoMxsKRWvk2zoRApzSmN+kwdM16YC7UU2Rv6UIx/Sk=;
 b=B5Q9eNRjL95uIdG6SVL5jEXskjQk4AriL8hbfgLsSdExVtz3neqGfKHjiURaTHtHSznPwzSHAmJm6WVv8bj/IQLvxvWrgaFSxi3Yd2l6O6zk3xIpCDtTYiVYftw5OG6w7xmwvYgAKTFPCmKLbl5apG3MemCGP9Haz+1KwVl5AD4=
Received: from BN9PR03CA0989.namprd03.prod.outlook.com (2603:10b6:408:109::34)
 by PH0PR12MB5483.namprd12.prod.outlook.com (2603:10b6:510:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 01:58:42 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::54) by BN9PR03CA0989.outlook.office365.com
 (2603:10b6:408:109::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20 via Frontend
 Transport; Mon, 25 Apr 2022 01:58:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 01:58:41 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 20:58:40 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v3 1/6] x86: nSVM: Move common functionality of the main() to helper run_svm_tests
Date:   Mon, 25 Apr 2022 01:58:01 +0000
Message-ID: <20220425015806.105063-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425015806.105063-1-manali.shukla@amd.com>
References: <20220425015806.105063-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5dbf625-244d-4ef5-2dad-08da265f1f96
X-MS-TrafficTypeDiagnostic: PH0PR12MB5483:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB548362CEF7130C707462B6F7FDF89@PH0PR12MB5483.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: svrF6kf+2+W7Ll+Rk2Ss6ZMCIA/X3Yikb85i00pL30kT0Jtxry9th4oOOLvmTtM115RduM+/W+s/2tx2BBBJbLYTwN4r7macAFh7h4tgxSEjqPfc3Hris09sqDCfz9jXKh0ukFNzi5leg8ynrR52zTPOyuSQWf5qD8Wfh6InyCF8mNtQHxF+XfJKALGvLv47Ilqy7ccIumsb2rE7a1h7rkdErJC3AaFBVqAWphZoGB2/3uu6FFD1vInvLIYy2uVnk57yF90gBHUioBQ1bMT0jRtSAgokMOR1fkX9d5+bZ/7ryhwxoNjZ2gypknt9CmAEf9KZe5oscbpm3+aMszROOM2aYa4WqIQJSsjp1XrBgcvq28Q+0ctIB7WatNv66tpiDGbNLIAXiH+Vw0zEHwkLm20iu4WyqsyeQYOJm52ikuVamWtui5Deg5viSC+iZ1A05iNSfJTaLsAT/G8UycIOv83lIHVWpaJjQwcxjYsSwHAKk2xgCN3ghBd3DUsNprYPpeqYo0G15AsWuVIg90OfjAVjm/8dLkrX17kSwOGhpggzc0i4vkhqub0Sm7IUE62MMSG2qvB4sCZ0L4FkBbi4IUigaUlA+CZ/y3IIJFQcahRarrBDH87Ir7b8PW7sD+FeOAsn+mbnzbD5NW9HaydEC9pFHBIqsEhALfrvMLYbDoVy66QrjtxkVdVaBv5FijgnTKv7psmcZ58HNRAIYvo/kw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(110136005)(44832011)(26005)(83380400001)(316002)(5660300002)(36860700001)(426003)(47076005)(336012)(6666004)(186003)(16526019)(36756003)(2616005)(1076003)(7696005)(2906002)(82310400005)(86362001)(508600001)(356005)(40460700003)(8676002)(4326008)(70206006)(70586007)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 01:58:41.9405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5dbf625-244d-4ef5-2dad-08da265f1f96
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5483
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nSVM tests are "incompatible" with usermode due to __setup_vm()
call in main function.

If __setup_vm() is replaced with setup_vm() in main function, KUT
will build the test with PT_USER_MASK set on all PTEs.

nNPT tests will be moved to their own file so that the tests
don't need to fiddle with page tables midway through.

The quick and dirty approach would be to turn the current main()
into a small helper, minus its call to __setup_vm() and call the
helper function run_svm_tests() from main() function.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c | 14 +++++++++-----
 x86/svm.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index f6896f0..299383c 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -397,17 +397,13 @@ test_wanted(const char *name, char *filters[], int filter_count)
         }
 }
 
-int main(int ac, char **av)
+int run_svm_tests(int ac, char **av)
 {
-	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
-	pteval_t opt_mask = 0;
 	int i = 0;
 
 	ac--;
 	av++;
 
-	__setup_vm(&opt_mask);
-
 	if (!this_cpu_has(X86_FEATURE_SVM)) {
 		printf("SVM not availble\n");
 		return report_summary();
@@ -444,3 +440,11 @@ int main(int ac, char **av)
 
 	return report_summary();
 }
+
+int main(int ac, char **av)
+{
+    pteval_t opt_mask = 0;
+
+    __setup_vm(&opt_mask);
+    return run_svm_tests(ac, av);
+}
diff --git a/x86/svm.h b/x86/svm.h
index e93822b..123e64f 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -403,6 +403,7 @@ struct regs {
 
 typedef void (*test_guest_func)(struct svm_test *);
 
+int run_svm_tests(int ac, char **av);
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
 u64 *npt_get_pdpe(void);
-- 
2.30.2


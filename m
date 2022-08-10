Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067B858E6B3
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 07:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiHJFWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 01:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiHJFV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 01:21:56 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2052.outbound.protection.outlook.com [40.107.96.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE80550B4
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 22:21:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BS36iPKdeVBWbvRZjulAv2YqgVa74MatNXa2VuOtJEfVi5MEdX1tzWZyybtqR78/le8W7PILNMkytvxaDK8MZ+FcXIRWx8VIkG3ptVesWDukREdMmZl/x3EjlQu7vKHYUukMvjYk/GWWT/qrcw8Qf20qdAQ3K/yyHG5yDwgTLMpz/Elk/U3OC/vULVVW8fsKs4SVT1rLpku06B8w6iT67l0pdk+28/06GffkXbTcPWAPCzk2QP3AOTwMZ2rrL3FtFG01OJyo3U1CPwuZTeFW4GA8RaCRreMC3w7QLruYI3hdF9L93uwuR6QD/OgznLVCYi8xcsL1xNJEBZiiOprvNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlL0Kg+SeeIuuKMEL9N7yrCh1HQM62eRCeRgrYakop4=;
 b=XhzWQj2VoMRmx0s5xx75RROcXMqZbaCdK8LDst/is7IB33yiJqykZmcSZyEDfQsqOBsBltHDqXIDXv/+f/Ju4ezcwZjT1FGqkD2UdXNOPqLeNP53nM7eiwpiZByJEvET/X8OIBFXsmm8XpPHZqV1IvjWmb2dkzKh4DIr/7S5QUnPdPCreZWgYLv8b9vpzALWjsd20BejbREwH4K5aXiW90Nw8VDullIUrauia7eyYwdhyp4ClDNd5x3r05hyho7cVqq23swQqVy9DacQwFDWq8LTgplx16XDWXNw8tGH3fxuVwwcXqAkSF9cEc6jTlqRL7qsOLE0hLuZMCiVnGfiNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlL0Kg+SeeIuuKMEL9N7yrCh1HQM62eRCeRgrYakop4=;
 b=PM9OES1zLhuUhW2mizsV6r+gDRZUyGznEFqkAsAcu/GYpQWaUQJyqjeEXkYvCvDj9dY6rDbYoN3+q84iCbUf4Ytu3ZYGuq6y9G0YLmCJZ8fG1keSdgmJGmMF5yKyKjQP4j6OFZ90kX4q0hTvvwmRW+VJbUswj0PcyNS/n4VstW8=
Received: from MW3PR05CA0017.namprd05.prod.outlook.com (2603:10b6:303:2b::22)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 05:21:53 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::e6) by MW3PR05CA0017.outlook.office365.com
 (2603:10b6:303:2b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.9 via Frontend
 Transport; Wed, 10 Aug 2022 05:21:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 05:21:52 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 00:21:46 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH v2 2/4] x86: nSVM: Move #BP test to exception test framework
Date:   Wed, 10 Aug 2022 05:21:02 +0000
Message-ID: <20220810052102.7591-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220810050738.7442-1-manali.shukla@amd.com>
References: <20220810050738.7442-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa966391-b371-4c7e-3b84-08da7a903c39
X-MS-TrafficTypeDiagnostic: DM6PR12MB4499:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aIEuTmFyOmhGt0GqalnqsBOBq/tRjfgpB42a5ndQXprQgopLNnPZWzvs6IUzvIpdNU7YKKY5Wd4DS8YFXZPHpqRuwHhcUVXMpjUFWJ4BmuW/d1HB/OwhSaoOjBHxSUCld/25byuuirQ3GnDbm7DsEtSQXgJnKzaQxBtvrZc1gdnTx6k9q5i+Di6lnCgRfJxL+agdnUGrVsm5ayDoL7P9d68keILfob9A3W2BLVg9dGpcyT18Bm3YEFDgyQDs3idRKmtt77Ih+ZdYVqWWOVeSoK7nJiEDy+cdzpEwWthPxO6FSB8Ys8evzClMg7aoYQ22AA31qLTahRCglVsTEr7JQHnTbDbhbry8IH6yc5eC0ChhAdpg4FhX4O5ggck3q029HPojXt/x0f0ev/uxkzRkJk3t/tOSe7lXTmM8S0VnO4o1OtLqvFlPzsFP/ezhzbWw/YmEdPPvC/ySyJYqeOKn4+zBdM9/puj9rNF94SFkVojGFmC1CRi/RD2YKH+1P3xLt0zKdEdWpaffKOBUzWt8o+5BlkZfs7gylrKh5FcSck23aK3RZ7vGWm0tj2zhtmaTRFaTZmn3Xxwne+E+F58oHnu8Wedfdiph7V2qCpEIh+oV0lsNOTHMwVxKKvG+wkyRRQAl4eELxPliDGMGQ3Y3iIJGwd1rQrZWiLq8/pCJgbK5x/q6YId6tJN2tixR+Lqcz0ZJWQCr3W/ii4yC/0xxt32iNBDhgNKpTeQhOeH3jVC2ey5t3sCpznaPcaxTItKGmZkMqJyu225U1Y3wAJf9/BFijDjLMjSx4vYSgHx7b21xRu36l3YCmOLj88CGFon5oDp4YK+/095D0qMFbpz4og==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(396003)(46966006)(40470700004)(36840700001)(81166007)(8676002)(70206006)(4326008)(356005)(70586007)(316002)(54906003)(110136005)(40460700003)(86362001)(186003)(5660300002)(1076003)(336012)(16526019)(2616005)(8936002)(83380400001)(47076005)(426003)(7696005)(6666004)(2906002)(44832011)(26005)(82310400005)(82740400003)(478600001)(40480700001)(36860700001)(41300700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 05:21:52.8422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa966391-b371-4c7e-3b84-08da7a903c39
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4499
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove boiler plate code for #BP test and move #BP exception test in
exception test framework.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 7544034..b36aec1 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2804,26 +2804,11 @@ static void svm_into_test(void)
 	       "#OF is generated in L2 exception handler");
 }
 
-static int bp_test_counter;
-
-static void guest_test_bp_handler(struct ex_regs *r)
-{
-	bp_test_counter++;
-}
-
-static void svm_bp_test_guest(struct svm_test *test)
+static void svm_l2_bp_test(struct svm_test *test)
 {
 	asm volatile("int3");
 }
 
-static void svm_int3_test(void)
-{
-	handle_exception(BP_VECTOR, guest_test_bp_handler);
-	test_set_guest(svm_bp_test_guest);
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && bp_test_counter == 1,
-	       "#BP is handled in L2 exception handler");
-}
-
 static int nm_test_counter;
 
 static void guest_test_nm_handler(struct ex_regs *r)
@@ -3350,6 +3335,7 @@ struct svm_exception_test svm_exception_tests[] = {
 	{ DE_VECTOR, svm_l2_de_test },
 	{ DB_VECTOR, svm_l2_db_test },
 	{ AC_VECTOR, svm_l2_ac_test },
+	{ BP_VECTOR, svm_l2_bp_test },
 };
 
 static u8 svm_exception_test_vector;
@@ -3500,7 +3486,6 @@ struct svm_test svm_tests[] = {
 	TEST(svm_vmload_vmsave),
 	TEST(svm_test_singlestep),
 	TEST(svm_nm_test),
-	TEST(svm_int3_test),
 	TEST(svm_into_test),
 	TEST(svm_exception_test),
 	TEST(svm_lbrv_test0),
-- 
2.34.1


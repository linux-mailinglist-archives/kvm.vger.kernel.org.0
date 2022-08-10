Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B09F58E6B8
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 07:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiHJFWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 01:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiHJFWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 01:22:51 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1390B71BED
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 22:22:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ST+UoQ63VcaY7DF1RgVsHayEOoHv7wTzjx60gT/deddI/mJbChucEFJYkJLeeoRSJUGuQKXCt80N7nMzNRilStMbGepzJjZmbIn5oIpkfCNlQZfaEy6YkTo/OjY9LF+rMu+qBcJl8YbZHcGIddsw7kPxZD22bW35qus+w4n36Em2oNW4QcanJLBUwiDkZD0//sterwGu6pi2KWBeLvPCBxKnXI12AwXT1oCWD98YNC0sxTDx5nK44dVwTEUdJIQc1t24xpYuyKNlFXakINeuIRovlZUG/nlb3jxNILS+wGD/I0yBiW/ilmBJQmKOMVgXjSwfhfBy5l4wUtZ5aZ77xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0/AonMWVbqukB8T50DLbQ9fyYGzmAZvKmIFree2MNs=;
 b=oLtGwkEr9CvhBliTGEIKAnR7RPaxlVhjqMlEyvWyj0coPM1XGrLWfzSoQ0oAekWaJR8qdebFEjtAT1PrEUERKeGySLq1HOmQOzR1S6QXCMILKIUdno59RMi0JyT2nVquPkTZNceSJUP50EShL5q4dXy01OFIVw8Lv3HQByRNcgdImIWmmj65NpNnnXUhmHgqisl+oSn4RfRHQ6gsBxuM+P5mOjQakp8SRi/Urlh5rpToMDTBi2T5yBOMOpDB/PfI2i6pH0jOc47TXJaQrwl9OX98ux8NlPPsshM8s0O2lxvdalDqAXIBCJ3AGlmrwz0lgfZIYoj2BVkeh5c39BdISw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0/AonMWVbqukB8T50DLbQ9fyYGzmAZvKmIFree2MNs=;
 b=YVi8dWpEVviTvg4aMoGNw6eArQpamhlDszrel/SpSyztTqlkah6A3UcE1s3movh6r0llEuE2vORc6UkKYZkCuNxG2juLFPX0o5/mUan6dvwh5XvO7YC8u2znQiLxPRqnYf4CcIkEDt79hnAkbTLXICHt9qdIc/RDXwqujuo/zRE=
Received: from MW4PR03CA0039.namprd03.prod.outlook.com (2603:10b6:303:8e::14)
 by DM4PR12MB5199.namprd12.prod.outlook.com (2603:10b6:5:396::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 05:22:48 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::fa) by MW4PR03CA0039.outlook.office365.com
 (2603:10b6:303:8e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20 via Frontend
 Transport; Wed, 10 Aug 2022 05:22:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 05:22:47 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 10 Aug
 2022 00:22:45 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH v2 3/4] x86: nSVM: Move #OF test to exception test framework
Date:   Wed, 10 Aug 2022 05:22:28 +0000
Message-ID: <20220810052228.7615-1-manali.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: cb9bea64-9f25-4554-121e-08da7a905cd7
X-MS-TrafficTypeDiagnostic: DM4PR12MB5199:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wk4hWaKIErjQT/5+QE1E3NS5Ig3rTdVYIfTlaCy7BXUvzXygcPQCFSLFVYghBRaNHY096pxpm9dv8GJHI/VsteXu/dRmx6qWpwDA2/9kqmPAKKfKoCB3ZGu29q2Nt+x2KcXEuwWHl0Ma2RbrbWsV9GKRikmjXZDWZULdR7Ell3vpw7ezl7Pobe5MSsD6LrFdRISZ2D4ljuIe0JWN3UiOnKbaH+oVEeMZPghehX3vfxA+m1eiWTMZgdpPsO3/gCJxtppKvp5B+IFwXaBJpGGBk89IO6modqiqcuZH+uU+Trpf9zCzH5gcCi6cw6CMOv4IWDFWPhG7X1MkpGYu8Uk8l0vRZhbyEASJvnV25yrkBjDEFHxeiOKllSnpy2KqrJjoAPNGVF/tl+DJ7fh5yupPCKS2Z8joxQyOr1nu8nZHgbM2SN20FDvG5Wye2RdaMLGDpL54MPFKQ9+O+CmQ17M/NgUpYCZRn5x/J+z1SAKq148W74cKRGM3uSKdrfT9LGLvOxaQ0U2SmTevQQ6vXhnUbuFW1FDeHK55zRj/OazPGx/u9gJTqsJpX1WJO1LLshiMaQo/xVYfC3YT3QVqnOFjFhUGLbeQGpCiECyV9dOV3inxsJ8J4i2OCfmFLG209+uVJ3uI35dtdMAryMSy8JjklDj4cvjh0iZHdt+i8TE6fv59cIfD6OKnGayIWE/K0Bcj98n1pFfEBgOelLE6z4VYRN0j0/MVPEzDnHA/I8y2zOIkVaAqt9YfvxfoT58fHewD6A5J8CdpXMAle3c2R8EMBga3yW31L/PpIKIubq9oxMVyPVV4VsG89sFThy9NVWCwcHneqj50dTm+UHr0SbW1lg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(39860400002)(376002)(346002)(40470700004)(36840700001)(46966006)(336012)(7696005)(426003)(41300700001)(6666004)(2616005)(47076005)(2906002)(26005)(40480700001)(86362001)(40460700003)(1076003)(81166007)(83380400001)(16526019)(356005)(82740400003)(82310400005)(8936002)(8676002)(70206006)(4326008)(54906003)(36860700001)(186003)(70586007)(478600001)(36756003)(110136005)(5660300002)(44832011)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 05:22:47.5012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb9bea64-9f25-4554-121e-08da7a905cd7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5199
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the boiler plate code for #OF test and move #OF exception test in
exception test framework.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index b36aec1..b0f0980 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2756,15 +2756,7 @@ static void pause_filter_test(void)
 	}
 }
 
-
-static int of_test_counter;
-
-static void guest_test_of_handler(struct ex_regs *r)
-{
-	of_test_counter++;
-}
-
-static void svm_of_test_guest(struct svm_test *test)
+static void svm_l2_of_test(struct svm_test *test)
 {
 	struct far_pointer32 fp = {
 		.offset = (uintptr_t)&&into,
@@ -2796,14 +2788,6 @@ into:
 	__builtin_unreachable();
 }
 
-static void svm_into_test(void)
-{
-	handle_exception(OF_VECTOR, guest_test_of_handler);
-	test_set_guest(svm_of_test_guest);
-	report(svm_vmrun() == SVM_EXIT_VMMCALL && of_test_counter == 1,
-	       "#OF is generated in L2 exception handler");
-}
-
 static void svm_l2_bp_test(struct svm_test *test)
 {
 	asm volatile("int3");
@@ -3336,6 +3320,7 @@ struct svm_exception_test svm_exception_tests[] = {
 	{ DB_VECTOR, svm_l2_db_test },
 	{ AC_VECTOR, svm_l2_ac_test },
 	{ BP_VECTOR, svm_l2_bp_test },
+	{ OF_VECTOR, svm_l2_of_test },
 };
 
 static u8 svm_exception_test_vector;
@@ -3486,7 +3471,6 @@ struct svm_test svm_tests[] = {
 	TEST(svm_vmload_vmsave),
 	TEST(svm_test_singlestep),
 	TEST(svm_nm_test),
-	TEST(svm_into_test),
 	TEST(svm_exception_test),
 	TEST(svm_lbrv_test0),
 	TEST(svm_lbrv_test1),
-- 
2.34.1


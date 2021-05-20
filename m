Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592EC38B95F
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 00:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhETWIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 18:08:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:53418 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhETWIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 18:08:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14KM4iWa020055;
        Thu, 20 May 2021 22:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=jgWRvZ/TKVeTPk2+QbVjLR96P8riqdD40k9JUFsLb2w=;
 b=hUnsJuYAPzS4Z+XRUhHNaQo58iuB8MbYotCkWw3nLTjy4LM/zxoJmtaPPuwjPxsdrxf0
 vyoWnwoq519YYZoU6AYKbTzrqmmTd1EWQoeUQKd3Id+2HPAarC71OOtfnF05HShmq86a
 Qbkq6FYOmLzB5RRt0iEIBUKyZEDYE7OS+iOL3h7nNmb/h/RtD8FuzGbgHYvyWJTPoTNc
 b0qaJhaYQwcUWxVpsM/bYN/BKCugJmkBlEprRBZFCPwiRD+Ly1h+bYfGt7oOL7l4obnK
 bx81msVhWVPfmrAgWuA9lOsL5waeHXuoby4SFtWceX52Dr2cJ6gD7fkWeguZM9wUVFLM TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38j3tbp4m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 22:06:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14KM0Vnt141047;
        Thu, 20 May 2021 22:06:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 38megmxxpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 22:06:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7NEDNat+lnkrHJ5D6amLSYvKJ41BNzCKtPqyqWfIp2K56Xilruqg0pTrTo+Z4DmCTCxx8/TTv9GGOeVZcBCOVES5iMl7hTSLBX2tGJuu2YruGa+AhM2X2P+ivu2YjjlLpTjoxuAIsfOUpi6dKjHJxc9wr6hZ3uuZtahCD/PWlpx1GT6pOE4KcOm83yWW5tWKbym0SLD/u4KkvgrGVPLs+vCMJGSnkQhiITy+RrsKnokoxSdBiIIfuIo9hFm/LIojkuslsiZl/8uKZkraP1SOIPqFiZdnVQqjPaSTlog0FmSaYefszL5uHDHtii44DlpSRUYGC6JICHII4kv1vdm1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgWRvZ/TKVeTPk2+QbVjLR96P8riqdD40k9JUFsLb2w=;
 b=TrxUXHi20hWCXe6y1WUj2MytYCeHjiccN1k5oGQptuZHnaEb7AJp93jOJ6REUjtuFTDA+c/S1mXE/LQFP2rR6mgeIu3bMrz/iEuYe5mRNzNIllTBhTa/bTDgUWhlM1bNNajC5vSFuwfpbEP8qHRL27CyoQsVYIk0+juANljK7Uywl+zRvrrpKKyOZaLwROWEBoN2iodaosrYe4p7XejBncCY10KoxUC0ATPGqfJo3z4+Z9nKFGurUPtFqZ/osybVCCvA2oFtW7gnKzZRGde1TjWnkoNZOn22Y5Eeeu/HEmJicclg1mjhvH6VIagOlOcGrxci3oYxm7xQo2dhJZEM3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgWRvZ/TKVeTPk2+QbVjLR96P8riqdD40k9JUFsLb2w=;
 b=B+2nj9NKIG9ziFXW5fuRV45dh1rZz6rYjiHZw/xEtknZdkZoZOKGBG7zV+jw9k2dwwes0QLvZCQEVjwh9TEgUds4KOFlqOGfvetI+x7yT3tChSDqvF5Qd+YNGtj1SlYG/CW45asZGGQ5rfDOzgbAxk7M7iX1KG34v5d/SqMABXc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2462.namprd10.prod.outlook.com (2603:10b6:805:47::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 22:06:19 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 22:06:19 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH] nSVM: Test: Test VMRUN's canonicalization of segement base addresses
Date:   Thu, 20 May 2021 17:17:08 -0400
Message-Id: <20210520211708.70069-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SN7PR04CA0233.namprd04.prod.outlook.com
 (2603:10b6:806:127::28) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN7PR04CA0233.namprd04.prod.outlook.com (2603:10b6:806:127::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 22:06:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6ea20a1-5a16-466c-ed9b-08d91bdb7f11
X-MS-TrafficTypeDiagnostic: SN6PR10MB2462:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2462C13D35E33BE54CCC43BB812A9@SN6PR10MB2462.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zS5CUMdpeUGEts+WrbFELj2A3Ln50xBauxsLFw44VS5M2SNXeEO4VQ2fucSMgJIYDPZQDsSO8vx0PD4Qwvb2IUtNr0uOxdbJ+l73cto11RaBwUrEv6kxS8rljJPx87ElxwsMYpu+1gBa97N95AD15lCBFNuDR1JdQYqIzaImzhEiaa2UWFCJaM8IV8sfeTJAvqKdtrq/ln6cn4DHFuegZIJQdxwMzBs6RcHoG7skuorr/x4y63n9VsP0c2S39Sy/uHB12IcCd2dN6o8/6U6Kp8jSnsfI+bm5eJf2j6qP5A5p6uf5JqbQdk71G+2vzAkrBPLfp6pOOYdizmrkf8aCWlAOJPG8JQVuu6IWgZGL1HiJcWiSrnc4Gb7mMJVJhKWxcFD82t5CftBzkcMAr2Yq+zrAo2tBxmBLPXxk7LPp6DfLi4SOuI1fhituT4U+rsPls/eJDIFXshjbX1ACSfGWlW49slIiVnz+E4g0nv0Wxt3rOMZ+dPmxjN3tXj38Xr4jdlaBO43k2FfIYvho2KLaVeYM1V4SXXGJn/Bp9e9AvYjOKx46r6Vlna1Ys2IQE/e7gNXiV5Nxoq4828Tt8qt6L/VC3UdPX/OItzdypED4jGC4wS+xSMmSk+lJ98fvLCqBkQCd8ZLc7zsOm7Ee3Bjd1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(39860400002)(396003)(956004)(6666004)(38350700002)(2616005)(44832011)(7696005)(38100700002)(52116002)(66946007)(186003)(316002)(26005)(1076003)(86362001)(16526019)(6916009)(478600001)(4326008)(36756003)(6486002)(5660300002)(2906002)(8936002)(66476007)(66556008)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PDLw/GnYDG59ezcFL7Pw/6ZJaFFwAKuPPi6fh6pbfCHL9nEel4UKb+tGgiSn?=
 =?us-ascii?Q?NhRyqaabxHr4Sxhh6B5v596ovT13JrL9iIZLqNTyGAsvNxig9KXxpJ+vdlEy?=
 =?us-ascii?Q?K8Zenh1uy1p+PKSYyY9hWoHnPk6D2qEnP+yq5gwiMwUt71TSMK5t729weOqR?=
 =?us-ascii?Q?AgLuMgKXiJLejg+zORxpkS90t6paRlizbwBWchq6rEsEy2g8pPVIAuw57WNW?=
 =?us-ascii?Q?6CLA7BUf+ZDKOj1V2SQaF+oPhJIrpfE628rl2vzi9CyLLaYyXTJ4w5++Ju+x?=
 =?us-ascii?Q?K9d2ieZQ+UiAL9Q3q0Bc3K9EZp4b88SS64Dyh7bCFzr+rbmzc91bcCRnzmph?=
 =?us-ascii?Q?hv5U1bFLSV6QIUy7mWWTPudiqVUkPpI0ltqrcoJb87ToCaWzN9/DabEzjW5K?=
 =?us-ascii?Q?jzvYJ6rUKwxK2jQBzuowDWzqCOipftGH/+LK9uxCJlcSTzoDTOEd1ZedI6cO?=
 =?us-ascii?Q?NHhD4XSVr1hWIqQsOXnE/jlgNCraGJS2/YIgGJzI3Q393ZQvolEqrDi6uLLg?=
 =?us-ascii?Q?BszBjHa/N2GzAAM70m46JINpWm6nM0nwpuVQTCxlGfigkoCAAYGlpVdQakUb?=
 =?us-ascii?Q?l+/jgMd4dhyRjXxyuZ/bsNcao4kLfLLQHyuUpdw/5CsWWiGu5NuTAKmbd6Ch?=
 =?us-ascii?Q?xCglFG0dcZ37iAxS4AaX7FBTYGsDbAXdD8/ViLbZjNIbRCQ1pq+xolB9QOOr?=
 =?us-ascii?Q?wUMOsobBilBycizv2KtDqLaNCNnlz5Fb2li5MZ+1bcH2lPr8nv6rWaY3/vAa?=
 =?us-ascii?Q?zQxbLI8SnJwjW51ppMMi23TShKbASWBTdubIsMt+ACCiVq894w2wJPYkopIu?=
 =?us-ascii?Q?ra3KgUQ6AGEV6RMgOgQ5tynZNiy1ilvX4nZ5AU4jaVbthtUteWhi6PPgsejr?=
 =?us-ascii?Q?oYS0W07UWf3h0kShhRwe1CUYpKl1sup+No5QyUdOjex0/IRDiOuXOM8KThi+?=
 =?us-ascii?Q?EBHx0aI7HRLYGPfLl7stib0LZGGTrLos+tonAhCe2rdH9vsfYeRGviGeeI5d?=
 =?us-ascii?Q?D52ZUzQwj0vZIA1Z82M+pZ4Ijh0/2FzMxuNstGE3WnkrsEURTsTap4LF+mAR?=
 =?us-ascii?Q?SG3LyzsHJo2u+PleughiH32/rwWjIZhwXhans7HerKcTvDP8wOSyPUBR2m/7?=
 =?us-ascii?Q?jBew9EbD5QZLTI78vw4nYQaAHACSzApqvArYWKwXaZhEXZCHrorjQVbu5tbc?=
 =?us-ascii?Q?xflVmz6SsyacK+Npo8D9Bp53HSOrNnndFJiBY8D/xpGYSjJVT29vSXNTLGoY?=
 =?us-ascii?Q?VTFsGPW4HsVapRDCJsgwvMHKStDyCgACcXDCTp4OUDfKUgWvRtRSPNNPl5zo?=
 =?us-ascii?Q?Sb4yhECgcAMpUYg2dHRAox5s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ea20a1-5a16-466c-ed9b-08d91bdb7f11
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 22:06:19.5353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cYWTURDXzC8tvZSmEJHE5skrGp04BIrcBaFKR1l8LF5jbViP20ippZjbuxxvQmXVOo5MyGxh8gQZVv8einHvGufZk1Uxy8uj6C9PwhEs5vg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2462
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9990 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200138
X-Proofpoint-ORIG-GUID: vG-s70WgPIHNpPX2XQRPExdUQ2B1LiGC
X-Proofpoint-GUID: vG-s70WgPIHNpPX2XQRPExdUQ2B1LiGC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9990 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200138
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,

    VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
    in the segment registers that have been loaded.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index d689e73..8387bea 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2499,6 +2499,34 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 	vmcb->control.intercept = saved_intercept;
 }
 
+#define TEST_CANONICAL(seg_base, msg)					\
+	saved_addr = seg_base;						\
+	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
+	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test %s.base for canonical form: %lx", msg, seg_base);							\
+	seg_base = saved_addr;
+
+/*
+ * VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
+ • in the segment registers that have been loaded.
+ */
+static void test_vmrun_canonicalization(void)
+{
+	u64 saved_addr;
+	u8 addr_limit = cpuid_maxphyaddr();
+	u64 noncanonical_mask = NONCANONICAL & ~((1ul << addr_limit) - 1);
+
+	TEST_CANONICAL(vmcb->save.es.base, "ES");
+	TEST_CANONICAL(vmcb->save.cs.base, "CS");
+	TEST_CANONICAL(vmcb->save.ss.base, "SS");
+	TEST_CANONICAL(vmcb->save.ds.base, "DS");
+	TEST_CANONICAL(vmcb->save.fs.base, "FS");
+	TEST_CANONICAL(vmcb->save.gs.base, "GS");
+	TEST_CANONICAL(vmcb->save.gdtr.base, "GDTR");
+	TEST_CANONICAL(vmcb->save.ldtr.base, "LDTR");
+	TEST_CANONICAL(vmcb->save.idtr.base, "IDTR");
+	TEST_CANONICAL(vmcb->save.tr.base, "TR");
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2508,6 +2536,7 @@ static void svm_guest_state_test(void)
 	test_cr4();
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
+	test_vmrun_canonicalization();
 }
 
 
-- 
2.27.0


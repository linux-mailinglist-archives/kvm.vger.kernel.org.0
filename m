Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB33FA28A
	for <lists+kvm@lfdr.de>; Sat, 28 Aug 2021 02:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhH1AnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 20:43:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14420 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232503AbhH1AnA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 20:43:00 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RLCcBU028952;
        Sat, 28 Aug 2021 00:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mL/yTHv1CK5kJW3JsTh0uNITLCgyMlB55F+moUDgyYc=;
 b=ILxzAcoIGbcNQuV69HN8iMreJp7zQjjrBtHLgT1Htver6WvP8vIdt0oeiG0UysjOJTcH
 TagG6xOucQOBBp2TEK1mdMD+qYdrsO7d4ZJdb4OZEUWAJc61mqEErzFX0xFa9Sv8q4mR
 USDivzlyCupB+vhfGRfqAH7xArAqCaqA0IICvDOGPopOEFhAHzfpWeLXFPn0EGO87fEH
 yYKB/e86MitimPd4Hy8XmxTTKNO3NZVTVhi+W1LtwkXxt58QwinRIjfYQihvig90u5Sa
 ecDdx1N94Obu3IkLjJwAMSJLjr9nDp1W8kTfoQ55waDf9VQVTMVfNBO4OhS56mMzJ6n+ /A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=mL/yTHv1CK5kJW3JsTh0uNITLCgyMlB55F+moUDgyYc=;
 b=ULs8f9DlzOkgW6/eVCxu1UsAOq3PaCIYI9WHan9Uydbd3WU5YlCqF7ffdRc6fPI2eSd/
 4y5TgxPhkFsNAuDI7ZQ+qD20j4ISX8gGfbkBLFhhoFRYEHW+/V/JasbYREjbGZQtmU+P
 fHirIdl2C70MlFT/zkKCfoxy9rzYOnmw6rPhnKUPxlGNAeYYGOdIUDnJPPTTN+geKzYR
 bpadT9+Njq0lPSKpxurc+1jMFFo2BTQMSJGUcHwWOHg2c9cVps1koneZAla43mONeEQV
 7uXWGai5PdPXk7UlOkXVA/cK/hdoiUy7G02/I5lf/jP0JQbqlf1yCf241Co7TnGqOqPx MQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq7s0r6f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 00:42:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S0dmmc160276;
        Sat, 28 Aug 2021 00:42:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3030.oracle.com with ESMTP id 3aqa8thjdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 00:42:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrDXijA1nWBxvpnE94/ljKmi5quWAnitsuCWLaaHng/afU7/L1T2xoPTe8U1kLNOBzCmZiycfKpc0ZBNCkq0mlSuQw5gScNk0GeLnCm/TcVOK+uatT/IiMm/GmEvsj2ToYtyBEKZeO4DXN8EkET6jU8FyxkU9kfDY63M6Q6NqvsBhkniRFZwCXAmuJ58JSyLfiq+kALLu1XsLAZ31ejC+RpeXqHONwKVMgmHYstzIAmn00k3le9E0prn+WhpL2UrhjtGH5vO5Jy3DCVDlACjKvzhyfY1mlqtY9H+DBvkpyg0HBkuYqEjpMc7rC5OMZ8wd2oSlv9OqPSQ2k/4uvmERw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL/yTHv1CK5kJW3JsTh0uNITLCgyMlB55F+moUDgyYc=;
 b=bq1BHOm53WyZK/dGkJ6tu7WqwY021+RNWs5ageskwmnD4wVbyu55YpfHqfemQ2p9UE3LbMNVZ5VNbOop7e1CWX8PCsnyA8128WOgs29Vqkcp46M4wYpjQo1ZME3KspUwHlAngh8THvCPV1PhGdubhICCciaxYZhztV/Fer5pqMa53myNLDk9gmHbLrTDQlK/9w6BOpIOmmrGDCyzcDRsZj+v29gHOCmRYHltygnkLUy4TphaUnqyVVYhLz1P3X7MKo/aFDMiNriUT0MDJJ1rLdi/k/9xPlGb5J2qN0vfJCKdDUc5LfzZe0PXqX9F+qJa4EizwCy7jQOiuM3NVRYaCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL/yTHv1CK5kJW3JsTh0uNITLCgyMlB55F+moUDgyYc=;
 b=mhaZnvJymEE1Usakt2+FmArr4i49TcOxuI+eZ0RAFzZDOoRPVaK9c5PGQdCs54ggRQqPQdxqfLMUpMB3mciHgAVHnYSbARShSVTYJvkf6owl8J4kujhcGGHYT5TIv45+5h2oFwth8Eo+imwo2NeHn+6LSVzrUsDLCmHb9573q98=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2718.namprd10.prod.outlook.com (2603:10b6:805:41::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Sat, 28 Aug
 2021 00:42:05 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226%5]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 00:42:05 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [TEST PATCH] KVM: selftests: Add a test case for debugfs directory
Date:   Fri, 27 Aug 2021 19:48:17 -0400
Message-Id: <20210827234817.60364-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0026.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::39) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR17CA0026.namprd17.prod.outlook.com (2603:10b6:a03:1b8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 00:42:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d57d388-ca0d-4ec2-e08b-08d969bca88c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2718:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2718E5DD1366DE74504889D481C99@SN6PR10MB2718.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:216;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFnSnSTP6PP/eOaN2MpwGr1Jn1hMdTIGj6MG7HN9yXrLGV+s30tBmzOTCdKuiiup5cj5AIOWvFrPXmIzctmI0oigrHeA1IliNNSAMXm0ojpaN4HwvMCWSom5sUZT1AmB+XtIr+bezZx9W9OLH2rfIv86yJVuEy5xvVXVjarQl6v3ZMKd5Y1mxa+XnwyfeT3ewy/zbsw9qW5aVqbmhhL1Fj1IsH9KBTHIAhgfKpILMNhZdgW+cJDg+hJ7pBwN5IGWLlquOrj9ztiJrQWS30+LYK2b5j0tkZurzlFOmxGiWQOVzsP6EupSXv1YINGcjoC6+Y8pS+XGD3SfWhM3yAQzf9bbP4ICJGZr0vWYpG5hvk+BDhQYZ4lsmUIgY/LyhHC5VToJzULl7y8NcR+LCYaFoaDyZ/duyQdt2rpa5EvO9Lytk+W2/Z0wgX6EYq9QZFWb5EE0KFXllF9DKe8d7YnUT7zbbgqx/4FmdjVKvLP5WcKi/eHvo5vAsejUUSdjvvrWuFodhX+XB9hreSih503Q+cdSD3C538e72LIuJ9CLcF0P8mvh0/h1sJlyDpyPgoRFiLoATWF80zMpWcUmpCl3ASS1sTNTEuBdBilHgw3QQrll4gwDf3P6soL913SJqAG7agGvxYE/WQ99e4JHfOOOAdd0ys7TRmA3Tfx/of2nirUYRCZgCc50wJwF2sddPX8bKDdmynxYYHih8JEwmvnwYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(376002)(346002)(66556008)(36756003)(38100700002)(83380400001)(6486002)(478600001)(186003)(66476007)(5660300002)(6666004)(66946007)(26005)(4326008)(86362001)(1076003)(316002)(2906002)(956004)(8676002)(44832011)(8936002)(52116002)(38350700002)(7696005)(6916009)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N/SsljES3Ne2gmtMMj+i7+XteViln86iynVwlO0TRnIzLV9FJgIaxmPB5NN0?=
 =?us-ascii?Q?2rUXWSivfwxZ7bYfPqOju03gpw9wBugf7/Voue0hQ05WKHtZiiQocQeiTszR?=
 =?us-ascii?Q?K9J+6zLIYLwgdKpmui19wDOMJtMuPXxNV1FPU/Pk4KTSwcix3vdSiOnht8WB?=
 =?us-ascii?Q?Z8Tq2uIrtZwtfnondgJSucDjxbQXpS0WXYq+r9YA2K2XROLUVw/bUD2pSQ4D?=
 =?us-ascii?Q?1Ddycjjytu7yEl/XT+h5APAOwOLd0hRIMvu6wuHlgegx7/LC/TBYz5KUaXyP?=
 =?us-ascii?Q?hvO9ckTEXx7JEeXIPCsDbafZpA66KAbB788I//1J75hBnTI4W/X1LTTqEjIi?=
 =?us-ascii?Q?JhVqukvX0Xcv6CXDZxjUbrvN/+XzOnsSnknh+VRVriETNgFgJDSODyMjLX45?=
 =?us-ascii?Q?/VosTnr+ZeOLWREekHwEFx7AqUSTC/H6qpivTpeZkWyI32a/wB50zChlqEhU?=
 =?us-ascii?Q?p3LBwGk2lNveIdBZ50pDZxb3+LmbDB12xg/y9qeN1vTmbGhXmIwLniV9Q070?=
 =?us-ascii?Q?YK8jJC5KRe0h7Ib9nVyiBXNmoXzrg3iHJHKHxUTcK0FCJRY0HpQPw/prbjNb?=
 =?us-ascii?Q?tUf1R7P3Q7mUS5I5SMyr2ACGoyM1TW7QVhE72a3LHYQ9e2skdbatVYGHz7b4?=
 =?us-ascii?Q?DxxCNQDkGonEDvXZP5YtplH4LNos3qJSboTVCAxu/vs8zVlaeUXqpLAdLofq?=
 =?us-ascii?Q?819uiu6dZObItsivSYeORba3NIpNa0gJ80uRcOB/dvj3C/Iu74p2bPq7BWat?=
 =?us-ascii?Q?gBTCP581nJ0HjlIjnWsTvCM3EjFg9tU8MYi8UcwMWrJRuS/4dHEFgmjong9k?=
 =?us-ascii?Q?6AZgGxkYlW3ovazcvj6L4us/DDNjrcNifnlHEA9LFVYZCKgVPKCWCplJ7+u9?=
 =?us-ascii?Q?1E/kvrrDYLRIFWAreyLAGaoWkDfLGxroqMYbOIC3OKp/J0pMlnC+oljleZl5?=
 =?us-ascii?Q?x6J2UEoqCYNUcYuysvTpjowtTb+zE4XyzuNDRIaszZQb+P6Z4OaBYnr6KNFP?=
 =?us-ascii?Q?OmXzwqr63Kyn6SddzmhnvMtGYDibvNylFGHe4tyiMtT1V5UE3NtgCbJg0IDY?=
 =?us-ascii?Q?ZoOgOp4Dt2wbYUmiZehvb03PCCT02787LFkoZdNK7XdLMZW7zdcHXFfaG/RJ?=
 =?us-ascii?Q?aCmJeDbqHPQM1j7p5i1YmGgHebuS4ovd7WulUEiumgQzmtbXolioTOiTxLLn?=
 =?us-ascii?Q?SgV6u4q15yzVoS04VcN26yVbOvVoam4r0TMtBz81amRyPWi6hNKpGMsBs+sJ?=
 =?us-ascii?Q?WLaHylksmPkFyVf1MFk7V7ngwGmwsf+dhGdnib2VWTJJN33sWuy8ca5kdNVQ?=
 =?us-ascii?Q?XP1kEDn3OrH51tUxmguWAPx8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d57d388-ca0d-4ec2-e08b-08d969bca88c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 00:42:05.4847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVcyeF1pg+lXA1hVopdkYYP+9EA4Ir8yxkj9Zbt0rPPW35c9wQNud2G1oi0mfTRrbmwsHL6OwBNAsCaitzQycOB4ZP1BnpvpDZAJfNdsJas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2718
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280001
X-Proofpoint-GUID: d1t6xxj3Cr1aQeJ-WJDQnzn5KdrLQxG2
X-Proofpoint-ORIG-GUID: d1t6xxj3Cr1aQeJ-WJDQnzn5KdrLQxG2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Along with testing the binary interface for KVM statistics, it's good to
do a small sanity check of the KVM debugfs interface. So, add a test case
to the existing kvm_binary_stats_test.c to check that KVM debugfs contains
the correct directory entries for the test VMs and test VCPUs. Also,
rename the file to kvm_stats_test.c.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 tools/testing/selftests/kvm/Makefile          |  6 ++--
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 ...m_binary_stats_test.c => kvm_stats_test.c} | 31 +++++++++++++++++++
 3 files changed, 36 insertions(+), 3 deletions(-)
 rename tools/testing/selftests/kvm/{kvm_binary_stats_test.c => kvm_stats_test.c} (88%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5832f510a16c..673e1f6d20f4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -82,7 +82,7 @@ TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
-TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
+TEST_GEN_PROGS_x86_64 += kvm_stats_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
@@ -94,7 +94,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
+TEST_GEN_PROGS_aarch64 += kvm_stats_test
 
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
@@ -104,7 +104,7 @@ TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
 TEST_GEN_PROGS_s390x += kvm_page_table_test
 TEST_GEN_PROGS_s390x += set_memory_region_test
-TEST_GEN_PROGS_s390x += kvm_binary_stats_test
+TEST_GEN_PROGS_s390x += kvm_stats_test
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d79be15dd3d2..812be7b67c2d 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -59,6 +59,8 @@ void test_assert(bool exp, const char *exp_str,
 #define TEST_FAIL(fmt, ...) \
 	TEST_ASSERT(false, fmt, ##__VA_ARGS__)
 
+#define	KVM_DEBUGFS_PATH	"/sys/kernel/debug/kvm"
+
 size_t parse_size(const char *size);
 
 int64_t timespec_to_ns(struct timespec ts);
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_stats_test.c
similarity index 88%
rename from tools/testing/selftests/kvm/kvm_binary_stats_test.c
rename to tools/testing/selftests/kvm/kvm_stats_test.c
index 5906bbc08483..4b73e7d5ac0f 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_stats_test.c
@@ -13,6 +13,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
+#include <sys/stat.h>
 
 #include "test_util.h"
 
@@ -179,6 +180,7 @@ static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
 
 #define DEFAULT_NUM_VM		4
 #define DEFAULT_NUM_VCPU	4
+#define	INT_MAX_LEN		10
 
 /*
  * Usage: kvm_bin_form_stats [#vm] [#vcpu]
@@ -230,8 +232,37 @@ int main(int argc, char *argv[])
 			vcpu_stats_test(vms[i], j);
 	}
 
+	/*
+	 * Check debugfs directory for every VM and VCPU
+	 */
+	struct stat buf;
+	int len;
+	char *vm_dir_path = NULL;
+	char *vcpu_dir_path = NULL;
+
+	len = strlen(KVM_DEBUGFS_PATH) + 2 * INT_MAX_LEN + 3;
+	vm_dir_path = malloc(len);
+	TEST_ASSERT(vm_dir_path, "Allocate memory for VM directory path");
+	vcpu_dir_path = malloc(len + INT_MAX_LEN + 6);
+	TEST_ASSERT(vm_dir_path, "Allocate memory for VCPU directory path");
+	for (i = 0; i < max_vm; ++i) {
+		sprintf(vm_dir_path, "%s/%d-%d", KVM_DEBUGFS_PATH, getpid(),
+			vm_get_fd(vms[i]));
+		stat(vm_dir_path, &buf);
+		TEST_ASSERT(S_ISDIR(buf.st_mode), "VM directory %s does not exist",
+			    vm_dir_path);
+		for (j = 0; j < max_vcpu; ++j) {
+			sprintf(vcpu_dir_path, "%s/vcpu%d", vm_dir_path, j);
+			stat(vcpu_dir_path, &buf);
+			TEST_ASSERT(S_ISDIR(buf.st_mode), "VCPU directory %s does not exist",
+				    vcpu_dir_path);
+		}
+	}
+
 	for (i = 0; i < max_vm; ++i)
 		kvm_vm_free(vms[i]);
 	free(vms);
+	free(vm_dir_path);
+	free(vcpu_dir_path);
 	return 0;
 }
-- 
2.27.0


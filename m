Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3969930D0D1
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 02:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhBCBb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 20:31:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47730 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhBCBb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 20:31:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131NxN4153271;
        Wed, 3 Feb 2021 01:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=PsWu26ET1Aroe/GiEox5JHJTetUd/Z+jgu1B15egZvs=;
 b=JofT+gQ2T8IDBMHlQNXOhttCwPCS6W7AvowuJgFSrNR5vvVQz5AA8pBvJLheDFwxAns3
 lwWJNvJqb/fEzn/oCgKL5gc7N/Vs+dYC//IfA8utvWb52eRCmRNOOWScr9ampgzv6BcN
 lUsLKeKiMtu1P+vhrXrdI8LbmwY4AN37QR3N6aPwhwl/jI5ydIxT9JtbTPeK6BRk/fAW
 kRiwXDbYlXk9sxrdZdtLz4sz6XUn3slPjQ9DvCBemyYuURvo2au6zjza44itZpV3yn8C
 3f/exU/DATT2S2Srz1lSjXj+cWiDzZFz7C5XEHVw1YagFi4GB4Z6l+4ygmlH7ABfklBE Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36cvyawts1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:30:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131QYRc101012;
        Wed, 3 Feb 2021 01:28:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 36dhcxnvwk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaZTEQFC4TjFP1lLClHnpdA/Euu3LtdkTJeuWonxiKuC66W/S64+UvvlSRfdMBiprrgYAv6aUb1Ujp2Jpv2bgk8gfiF0/cgNh+zaaXeOeUAjYz78uNeFHUTDPUv4Ehe9hD/Vgkw9IyuNJKxFIsbGivnp9kEJ8HXLhKjljWSRNXpuwgkX5BaTWzfkXly+QalNnSgLKNKVunUXgLgu1s0L/U7tNNnsBP+Fm8yb+5ITD0VUEVcridugWOVjvvN9zZir6jmcSv2zALMA+FLbXc61jwmrQIgoIXwoqMq712HPvuOa6s24PgzzRaOwzgH0DjwVjcg1gfT+nNNl30N7t4X+OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsWu26ET1Aroe/GiEox5JHJTetUd/Z+jgu1B15egZvs=;
 b=mH3hPZJTgOZRboEsx3OkWb1G+si7DM/WaPD9B2YW/LpiCjbUOxBlbD84G84bJcHS0PAh4w6kczq0ovykhS83ZHZmuFRrYDSHsgd0HzUQhABJpWVjuG7TxJsgof/GL0EaI+5XxauXr8A83G8SemUgepJ9uL+8FLt53WK3T7g+0fq5sZUmmA/u1hWfeYdD1RuND6MvpbZ7wd8JeOjH/9dLnoBblt5APhUn4ppqd5ZlpAJF75BSxHsehcgd1XRtncWQXnLzBJZSIAYKOYvxJ8WYD4tFyfvguxM+oM3lqlmWw6CiPKa/zpd1PO0mKirc05PwQwHbmNuNEsgqIM+L2Mq4WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsWu26ET1Aroe/GiEox5JHJTetUd/Z+jgu1B15egZvs=;
 b=ITHxSH1iBbFOigi3//aAczgnN8T8jBG6e8KS0Hfbsyh6NP8K0e0KDRf2iPlGJUvkqY1A2QcLFkKNk21GBfX7fxuIw47yAdX0IwbItLvKlJljezvDgZq97bkwhVvImpBjmMecL/mSUJJTwsM0LjQ9cDEKcUA6j863iiHsnazhohQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DS7PR10MB4941.namprd10.prod.outlook.com (2603:10b6:5:38f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Wed, 3 Feb 2021 01:28:41 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba%4]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 01:28:41 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/5 v3] Test: nSVM: Test MSR and IO bitmap address
Date:   Tue,  2 Feb 2021 19:40:34 -0500
Message-Id: <20210203004035.101292-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
References: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR05CA0073.namprd05.prod.outlook.com (2603:10b6:a03:332::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 01:28:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f9e1d61-de50-4d9a-d604-08d8c7e30a15
X-MS-TrafficTypeDiagnostic: DS7PR10MB4941:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4941A932E98997F7736E0D7781B49@DS7PR10MB4941.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pjPfw+xNMwWI2qHmMm2n43bi8eAgjXY7SZZ9gQ8JbgwHftk+V5veKJaObwrjc2QwjXSVDVyAr/ew0HFFc8N8Am358GRbjKVEZbdvEt21BHaIWE30YxLTwxnzCUO1sc/P9VUkwACGKJJeFs2ikmekmieb3Iq5k34Gw6hJBXxPIVgQagpYMteG+rN8otGCiQRfpHmIkLP7oiev0Lzdeja7xLVTEDSVBKGUDc8tHcZCpmhifv0CjG3NLhV7SjN+Iyz9TCdMz3OM5N6HRqCvmt4hen3mre4dcirbplVAjCQaVU9WJ4RcxktGmDds1ib5K0BFR9F6wBXPYZ7aEx6LIBkzrbXjpHF5o7S8PeU8Vr87azIzzB71XHEYNe6XVIpubf1r4as/DlL3RAeI+cMfKh1jWuRx6sTYP7I+QXcQmUJT8r043iwJWZOgGP6kxt9VjIFRilp6E+Kgvov08wqenl/tBPfqs6Kf7qi5MARfDZu+EinUXB/NjSmX9D5OvR8d4uIBPzQH2gnHfJ2Y4gYtsrrQCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39860400002)(396003)(316002)(36756003)(7696005)(6486002)(6666004)(2616005)(8936002)(1076003)(66946007)(2906002)(186003)(4326008)(5660300002)(86362001)(6916009)(66556008)(16526019)(44832011)(956004)(26005)(52116002)(66476007)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9g4oH41eEeb9JmI2xhF7X1+T+wLSs8Vm4EN4hA++7zB1H+LOTPha/JwA0DUa?=
 =?us-ascii?Q?U4zKunJtBo8Hm+J07SOqXyMV0Nyh+qOvsB3ptu95oTf9NFowYQDArzIemdVf?=
 =?us-ascii?Q?5pQusB8mptsyeawCGHiBcUJj1tBlwFcxHFT7dB1gr3wcHXFZ61W4JFGHKb/O?=
 =?us-ascii?Q?82EuKd1d63BtjsIvpTf0Z38VgaLjJ6s/7+6H2WaHhb80T4WULxMEC5Mihbz1?=
 =?us-ascii?Q?PHyNbmAIVANM6qJTgbJO6HV9sBZuzBAYEVaXTpfZo3tyTrp8GAXz4FtMe23x?=
 =?us-ascii?Q?ZRC4QTjvSz3+mpKYW9hPPKyY/kj3+QcJc4phxKI0OGo7UaNYPf8DMIpgFmpL?=
 =?us-ascii?Q?bV5+3hcgU2qQK4zRYZ9usg9lBkotBwGbhp21uAWXc2Pj46qjQZnLmRHegSKG?=
 =?us-ascii?Q?g/9LKXsqcNFDvb4rrO7OPeW6BAwDjag/Awh9GqhAmEq3IO8yZ3xjuagpFEbb?=
 =?us-ascii?Q?c9JRFYqai8AiDQGKHD6n9h+Dzspc6Gqo3ue4NBsrcH94FZRsUuL60kyF8iS8?=
 =?us-ascii?Q?IyF/nSdOgndmojLvm8MZqWlYx4dBtB7tL7P92SP4T9F1aEoWv+Vqf9bE2+nQ?=
 =?us-ascii?Q?sB7gNusx6ORacyLXjB3Ft1xkQ/jA1LxnDwdmZIpOzf/h8XS9If1OM2gXhB7M?=
 =?us-ascii?Q?nJrY8uxJlVRpAQZDCbXI0jz2qfTwH8fnqZ69xzIBTwtJYkt/1+sGAW0cb5eu?=
 =?us-ascii?Q?XJS/kEFNMZzmN+QQSuduBlBJEI76sc5IAmW8xVh5IjwCchIlXgsoimX+VyGN?=
 =?us-ascii?Q?ugsjbMnrGGFLtw4KD8wup815DqTYjPafxkRmptFxQ2bHNf/CIBxx1vkG3sPZ?=
 =?us-ascii?Q?NZIYwedyeqRiTYBOxyM2Y4BLEmK1MqUoj1aNnChyB+8NwwTj/l7uEcoiNCWb?=
 =?us-ascii?Q?/fOmGPCYwydhOrLYfDHNCxWAeKWglxXolajScb+Enx0e7A9tA+WzHbN1SLH5?=
 =?us-ascii?Q?k4IpWUczKAL4/K8qoVU4E88Mf4PJg0Xd35bNV140VS7fPDCapOaCW7MiEhUB?=
 =?us-ascii?Q?znBzwAz3FnH5S4SAmi6BFke9KsUPFAcYHfkGmSUq39qMdTQQ6lk7LfwhWUrW?=
 =?us-ascii?Q?G6tSM7dW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9e1d61-de50-4d9a-d604-08d8c7e30a15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:28:41.5820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTH+WndcDDjmaW3WQQyuCqExjg7sf3KJ/1tZWiVtFxHGr+PiXGyxQBeqwEqgHyw6jlcxSF7Z1ywlDGygcUbrxOnQWyN5rjtyOaQT6+GrD1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Also test that these addresses are aligned on page boundary.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index dc86efd..929a3e1 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2304,6 +2304,43 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+extern u8 msr_bitmap_area[];
+extern u8 io_bitmap_area[];
+
+#define TEST_BITMAP_ADDR(prot_type, bitmap_addr, msg)  {                \
+	vmcb->control.intercept = 1ULL << prot_type;                    \
+	addr_unalign = virt_to_phys(bitmap_addr);                       \
+	if (prot_type == INTERCEPT_MSR_PROT)                            \
+		vmcb->control.msrpm_base_pa = addr_unalign;             \
+	else                                                            \
+		vmcb->control.iopm_base_pa = addr_unalign;              \
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test %s address: %lx", msg,\
+	    addr_unalign);                                              \
+	vmcb->control.msrpm_base_pa = addr_spill_beyond_ram;            \
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test %s address: %lx", msg,\
+	    addr_spill_beyond_ram);                                     \
+}                                                                       \
+
+/*
+ * If the MSR or IOIO intercept table extends to a physical address that
+ * is greater than or equal to the maximum supported physical address, the
+ * guest state is illegal.
+ *
+ * [ APM vol 2]
+ */
+static void test_msrpm_iopm_bitmap_addrs(void)
+{
+	u64 addr_unalign;
+	u64 addr_spill_beyond_ram =
+	    (u64)(((u64)1 << cpuid_maxphyaddr()) - 4096);
+
+	/* MSR bitmap address */
+	TEST_BITMAP_ADDR(INTERCEPT_MSR_PROT, msr_bitmap_area, "MSRPM");
+
+	/* MSR bitmap address */
+	TEST_BITMAP_ADDR(INTERCEPT_IOIO_PROT, io_bitmap_area, "IOPM");
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2313,6 +2350,7 @@ static void svm_guest_state_test(void)
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_msrpm_iopm_bitmap_addrs();
 }
 
 struct svm_test svm_tests[] = {
-- 
2.27.0


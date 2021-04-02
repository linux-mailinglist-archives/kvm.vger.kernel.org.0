Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F2B352524
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 03:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhDBBdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 21:33:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhDBBdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 21:33:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321ULi0055454;
        Fri, 2 Apr 2021 01:32:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=sJqjwwn/SYPzwAFhYkRmS6LIMupB5Bf29Dd7pLmjO3Q=;
 b=bo5AKKKYNgNYurXtcIu3rU04yRa5WorHKEgu20TyKlpHtKi1trAvkVXecXtofaOLfCDU
 L0I1KI5vIfJ7289Ulw91lan0lru3AU+b8d0NfSqnBs1ytq2Jxfxy3TdKmY3mhBAQS7Bo
 QEAPKkPtMwII+NpzAR52M7j8Pkus4J/+2QXaBoMnjwmZA/UvpzH3lNznPb/F2uzLoQEm
 Q8RC7htmAArG45RLw7rDWr0rbI1NOhCqRVADVMJouhz28hhhKr3gX3qB0+Am6wOluFob
 USLkIu0QSJBhGoZ04YY+VZXhCtGDv7GWoRvbMpR9Sdzj7FCf5i8C63dCl9TBMvp8ucuj xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37n30sbg2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321V01v019168;
        Fri, 2 Apr 2021 01:32:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 37n2abyyvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBcv30e8V8LnwX9iFwwAdQ7JkfdgSSGhudwvxsOe0Zj8rAWT5HFQrgH03NcCbI7Nwi5dd3h0SI3rrGyiUweBrg25z6rYghf/61n+EREGVziyRtHaEY/Bjzvkp5ExYG+N8k8DIjh8UaH/uwK8WZFnZVEJsi7BH+d4e3+Wl1HDmBUz5YBJJos2zjKrk8KcdbbBglCfEmrqFV7rHuE7eTzQHOZZo5axyjgUU1P90exa1PG0SgwCAG/Lr/CU6Uj69045YMnUkyqGRAY+46ghgscCEbbN3e2kSR9irLU2eM2G9g7A8RpJha35xJTIQiTgRg0XNc+pO7OKWOmkRgg0ji6TKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJqjwwn/SYPzwAFhYkRmS6LIMupB5Bf29Dd7pLmjO3Q=;
 b=FD43ikTo6Ww3MFtRxFl9uPrSLru/0iifd9DQlH7c+h+fTnt0+rE7W61dCEUOk0hTCa8eGr4Rxw9TXgvRt3oP+oy0xXFuDhm8E9E0mT+axQaEYOS5aU6QM20F6kbzQg2Fgkv6eYQQZETLLYq5Fu/7pZ+UPdzHcPJwL55304ON5gS/9vRQPIg66fRIbvK4xfySdtnqCLGByD2zsGtFSmq1Clt//5/li83HQMQbMavsEFLNYDUVO9Kv8YjywT499v6BH6JaNQAmhNFu5IU4x1x1Fko5NWFXvRliPuGPWv42wTDzdJnyrzwtR8at31pyLgMfowpPpKkvvE6jJnztuZgWnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJqjwwn/SYPzwAFhYkRmS6LIMupB5Bf29Dd7pLmjO3Q=;
 b=HcKPcuOGASz87SLAQLoU6w8NpXabaQjCDaCHGG9uGKkdnUdc8/aPHkkTXRPawoWhg1rnoaNE/siYephtIg/4GjOvvv9ZdEUjXf0ZXg65+j1PL233EB+sTgveh7gKx0GPclaJES9xLiL0piy+wIxlF92Scumy5cpAC0Ga0bUW4xc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 01:32:56 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 01:32:56 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/5 v6] nSVM: Test addresses of MSR and IO permissions maps
Date:   Thu,  1 Apr 2021 20:43:30 -0400
Message-Id: <20210402004331.91658-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
References: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SJ0PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SJ0PR13CA0024.namprd13.prod.outlook.com (2603:10b6:a03:2c0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 01:32:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf0b5b72-5cba-49a5-318d-08d8f5773db6
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB47955EF65F550FE6E7CB361B817A9@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:486;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7yC+9xeWT1ZF9JxKjmdX/V0EdCj5m0ken34qOo6TSnROBix/72dDmhogVzdNdfmX4EFbUaQHVHzmrFXkektwk+qVlb/XrMpPiMVnQ3h4C0XwIRWJe0ZnN3rMQaUGfgtVae48Y7ZERQcQF6qWhRMUieIKVAoGXUZjXTGrrF+ZFEDFFto+JHH/ZXzu6fhzjqVkYmlVUrBJcoid+pvnsgvKK6Mqiw/EXyq1CCA9qlToT9q/IoD99Z5F6brcQelg07sJaG2hChaQxMcRac3R3dRX42CP9o7vgcbLkSbU0Oox2p7bpD0Xtje2767hLHbyNF731Yx39DTkB/RnZc36QzMx023W8ksQJfp6ApO7fWzH1tr+QsmPI8VJF1Jn874qO6N0sgywIxbiArKfGtDIpLm0vYuSY/NP9ZOiSbwzJ3GHD9T1o1UEI2UHSLms1bPcQ/kYSh/oyo7EBSxVGl3c7R0ZPY1gtFN14zZqImr9/ctmuji7fg9QgjgGvXc/K9y7gqB/P4owIkSZG1F/St96l6nIaZA2dVb7R0PywKnI2W98ijEGTa2K7OiALVB2vSOiaDHVOxAC+APxLAfv17bjjK25y+NpFDvbVWYEnKE+cpDoZReRugivgZJaBEUqoyg2jBzQm1G1jdyY8izEuPsUgAKdfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39860400002)(136003)(6666004)(26005)(36756003)(316002)(83380400001)(1076003)(66556008)(5660300002)(16526019)(66476007)(186003)(7696005)(6486002)(2616005)(44832011)(52116002)(956004)(8936002)(38100700001)(8676002)(6916009)(2906002)(66946007)(86362001)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?go8flqLgj3BzZrMkXrMHY28AlMQulzU52J+ZL69FVeQl39ya3V/6pTBxd2dh?=
 =?us-ascii?Q?jha9Jlt3Dr2lMCxChoC6Vb6JByOZXR0AdfzdGSTcCFgR3v0uJWwJHiTrsbWo?=
 =?us-ascii?Q?6XISy0CBAS3x1VlbqR7Hk2cKpa43FO22TdzpsNpVZWZfY2fC/veAI0PiLcza?=
 =?us-ascii?Q?fu19P5A7c3x0QXHyAQxsU8jwlztb6E2tImcWXVafqjkBULFQ4vwcAMuISqOa?=
 =?us-ascii?Q?SV1euTTozFy4oLduoS0DyhqtmEg76RU8uGk/JFuhOT6AOfzxpiphh1DnmPpG?=
 =?us-ascii?Q?EC6d00gv7iM0sh9ho011IFFYf8AH14y3OgPegR9rBokbvUYpjEs1uhZ5ZktF?=
 =?us-ascii?Q?P2k6y/6ShJdPk+PYutAQIFUtqW24mqee68X23Ep+LsxMPgRQ830UG1L/rkdN?=
 =?us-ascii?Q?tqXVlwJKGzry8md0RlJm4DV3P4CSQ4w5gn8eI9bVj4lPoMhbiD7kwgYLw9rr?=
 =?us-ascii?Q?dBUE+1trK8DTqe6gBv9sr25h/qmQLj+gTFu9V1bwP1MmpXoM7YKUYZcytVy6?=
 =?us-ascii?Q?VQMtQSh29Sgf2SbsVPegqpIm8DRUrK7EL5026N0ghD0ZwB9gQdpocMNVX07D?=
 =?us-ascii?Q?YW1CqzKEmVT5uhaZnQTTKx9Y2fYFwGsfWuECWwifY73ffZacGd1rBAOseBXb?=
 =?us-ascii?Q?MpdGyiQnJu01yZKaIKAEMAFAVtARfO+t4Y66A4V8iF3czKNRNk1IvISedL26?=
 =?us-ascii?Q?zW/jUgMZkwtCJSPY/f8Z+QfFCXg95g4U00H2Vwxkx5k1oy9C3TdtcWOju50z?=
 =?us-ascii?Q?1nbUcL0w+CxuuuxV7qSKRIR9eY84g2+WFuRMKA+fen759WqEs4Iv3idZhFA/?=
 =?us-ascii?Q?OYIok37dg/z002A12GGDqNCD9qyaMWKOb8icnIgkY1RRzy08YAMqm0/5qLQu?=
 =?us-ascii?Q?O8gHZk/jDcNGTRlk5xoTUYuXF6fxFrSh+l0UTrknCPkmeJVldme+Is/NScyP?=
 =?us-ascii?Q?qbhqAv1F7iEQJWb7PDPBLdsV+L+PGbXBQE3Y+WFhEBKg0zrmqM/gm0x/TpyU?=
 =?us-ascii?Q?Nc6qcTuZdVuCyaOpTJdRIfXgH9/akSjeXx0RzfLogjI2+zP8k8BIcsoPw7ha?=
 =?us-ascii?Q?Y3jB+LkrSmN1qoXobTKgLJT23nZ6e62haN9J6aSv7HlL4DOMhtzga02Hcrpr?=
 =?us-ascii?Q?wVd3NIac9GmBc4/k8yp+0z9zUnGtU4LUBb4WJjaexU2EjojCmpclpRfU2rv6?=
 =?us-ascii?Q?qeC+b/D5RLCapx3vOsZFyo2daiwpr0yQjCNxJvHneKObiqfIIXW1R+8zFUDC?=
 =?us-ascii?Q?uaM/SmWn8xng8G74tSK0+aXKNgIt9HgSfmXguGuOxxE5ZofmAqqpUrGXxEzG?=
 =?us-ascii?Q?xTjw1+MzHHKpmxwQeG3GcRs5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0b5b72-5cba-49a5-318d-08d8f5773db6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 01:32:56.0057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35x4o4mV118Mzjs+0rDDbVZqw/4Whbx8VgCejUUJvTHgjGgQQmx3wBsUlcTLpundmffD2eK93sbHvDBWrf8HRWkfBIjzJgojgI0ql4eKOxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
X-Proofpoint-GUID: MCZIioGIFpc0LLV5AMWGqEwAmZqFf304
X-Proofpoint-ORIG-GUID: MCZIioGIFpc0LLV5AMWGqEwAmZqFf304
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
(cherry picked from commit 0513cf071255c7d5a1b7a813d017bbdd2d1da263)
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..7014c40 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2304,15 +2304,55 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+/*
+ * If the MSR or IOIO intercept table extends to a physical address that
+ * is greater than or equal to the maximum supported physical address, the
+ * guest state is illegal.
+ *
+ * [APM vol 2]
+ */
+static void test_msrpm_iopm_bitmap_addrs(void)
+{
+	u64 saved_intercepts = vmcb->control.intercept;
+	u64 bitmap_addr_1 =
+	    (u64)(((u64)1 << cpuid_maxphyaddr()) - PAGE_SIZE);
+	u64 bitmap_addr_2 =
+	    (u64)(((u64)1 << cpuid_maxphyaddr()) - PAGE_SIZE * 2);
+
+	/*
+	 * MSR bitmap address
+	 */
+	vmcb->control.intercept = saved_intercepts | 1ULL << INTERCEPT_MSR_PROT;
+	vmcb->control.msrpm_base_pa = bitmap_addr_1;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test MSRPM address: %lx",
+	    bitmap_addr_1);
+	vmcb->control.msrpm_base_pa = bitmap_addr_2;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test MSRPM address: %lx",
+	    bitmap_addr_2);
+
+	/*
+	 * IOIO bitmap address
+	 */
+	vmcb->control.intercept = saved_intercepts | 1ULL << INTERCEPT_IOIO_PROT;
+	vmcb->control.iopm_base_pa = bitmap_addr_1;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test IOPM address: %lx",
+	    bitmap_addr_1);
+	vmcb->control.iopm_base_pa = bitmap_addr_2 += 1;
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test IOPM address: %lx",
+	    bitmap_addr_2);
+
+	vmcb->control.intercept = saved_intercepts;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
-
 	test_efer();
 	test_cr0();
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_msrpm_iopm_bitmap_addrs();
 }
 
 
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A5638F7D6
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 04:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhEYCEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 22:04:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45100 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhEYCEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 22:04:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P1xFg0139349;
        Tue, 25 May 2021 02:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tIbjrCJUHT1TgcvRwvdA1D5DyY+KUzIm1fcWUGAiLNU=;
 b=mRxGN5KUMh7CxhCd6HigiLihEkNdoMQkUKsj1IHemRdkX3gxk7R37xBS2D6n+Gse0qu8
 NagWT/V3JrbcJw7qWWnD5ngjY9aFcBL/Ge3JWEYMk2DZPEOoOtzk58tadOzaF64cMRKD
 459Y9lIMG8KvHiKYV+xvEjHP8bhCSZB23QemQfVBl71UVAyhYUHr5U2K4YbSMAKRY3Oh
 pypF5XilMWKmfCqOzUwE94Cqbt3pJkxQdUi9pylPizZdG0nb+i67h0neNRQ/cuoClPt6
 cBNUi8QcGQ2D3gzgnU5WUjr9eFmomDzxtWXISxyJ/3f2cyZluy9vI+9eaxrJYLTkSGVN CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfccmke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 02:02:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14P1u9MW023231;
        Tue, 25 May 2021 02:02:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3020.oracle.com with ESMTP id 38qbqrryu5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 02:02:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHqqbxNZt2ZuYlmV4l0MDKEofxcVHO0L1Xgh+zX/LKR2Wh7SlWSi+JarguPI6ONE9Hqp0MmEpn7hgJju4PCkDr8/3JW40FRMHS6635JKx+0ZzSwJWYUJcrWLadttuFTJRXYaG/BtQwKbkHdB14x/M3YoDMdjbIT3ZK6QPtVDFQUqrMKAK9wHpkdyybzgP5mcHezM4gWr0BcC/IqhYAh9j3Ot3sN3BP4muccCKQSnXgDcfNhDtzpkM0FvKpE1crj9XutHWpoVyngLvt0PqvcvyY0meL4IlybjH/MbW/qVV1uRw/eAUuhB9ZvCeRsxTfTY1H3OyNm9ay6kKv8fRD0arA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIbjrCJUHT1TgcvRwvdA1D5DyY+KUzIm1fcWUGAiLNU=;
 b=OcofFMXF2mOmFp31Gp9wBmHeBY0LYcssXq81h1RJ2bP/RZ5iSbSWg8VQlArr0jCcBFBTfAkBGJmOoUeNdCOvX8LHMWN/MU9t3MnN0fasoJXJxl8zJblCtdy2LnwXD56h2OTvWKjNDlvX2OjsBKCMBv9w0Bjc8wUazn6cvEyjAQfkr+ji7L0rvNhYK7AjZ+CRr15vZE5veuHhsqyzfdlstj/sAs2ZLBCDufOEKu91MnzPbOaXamtfZLE9EnjV7WIDHtF1WcoTJ6Xb+rvnPC3ts79oyBAElAekE90KAL1Nf4RmZy3qHXcBa7a0oLH3rKYb+Kouaoo8JZ5agTgLCYpj/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIbjrCJUHT1TgcvRwvdA1D5DyY+KUzIm1fcWUGAiLNU=;
 b=iawl0GfOTxPJ+EsgfnbidrN6vQfe71k92vVU5EG+HN/Hlmm7tOR4FJleqtk9Q7Az47qaMaUTILFwVORp0eZBYiUdVgzfRaVkkLC3WrRHfOtGI2BsR+JYmGtM/mGMF8PU0751DxYdc8wskg3shJuR0gItuXDV34xLYmP2UmwDzvY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4506.namprd10.prod.outlook.com (2603:10b6:806:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 02:02:01 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Tue, 25 May 2021
 02:02:00 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH v2] nSVM: Test: Test VMRUN/VMEXIT's canonicalization of segement base addresses
Date:   Mon, 24 May 2021 21:12:41 -0400
Message-Id: <20210525011241.77168-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210525011241.77168-1-krish.sadhukhan@oracle.com>
References: <20210525011241.77168-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA9PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:806:6e::8) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA9PR11CA0003.namprd11.prod.outlook.com (2603:10b6:806:6e::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 02:02:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3aab9e68-8873-4ee4-9b66-08d91f2115ac
X-MS-TrafficTypeDiagnostic: SA2PR10MB4506:
X-Microsoft-Antispam-PRVS: <SA2PR10MB45064A5642837871EA6AA1C781259@SA2PR10MB4506.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ui1tbgjQ72gAg3ZsaYqIx+adWwNkp0aLBG9M3r8F7AKk4syaGBfncX1Jt4Ad7kbNSHZqn/rbs0nbusHWgTm6t18acV74QuwyssdjboOqLsZZ2O2k8xXi0HtCKpw1O6IvimTFrWpIDIhBDtqX7ROdyzafBsuCt8pF3c+ul4m7YtlZbM2N1Ka6XqCjm7jrEeHREBOELmotvti+0njOmxuQk4YqXSLnFKIyrIwWHrs8PstUwnWwQlLUda0XOPJQBPTV0KT5Hf7Y4HlR9pcM1oPouARKocRoQgwGkX1gJirmB3ejfvMV1HoZO/HH3oheXxVvQsQIEKSNqB86YZHyUYp5jfIkHqByO6GoR+9YNuPEkjdt2G3qyzbcmf0CNQFLBUG103OAa4YwOB9nbyjkA4K+HYYQ0zryi76b1VH/ruSIeTkXcRMOL4cmowkEjufOAIQokKCzDumSTUNz4000VJBnIPRajME330S9buDmed0q+3pdVG1Vlw2fHdpAPP7H0GwhSkYIWvaIA4kaYZ33F1N8p0EHD9qYi8q0jYAV5aAIuIdG8Eno3DGHALU47Y2QeJ2Gi8yk4FNHAYBZubK0bUgy6cfnh7eW+unWAFMA8M4u0hqgVTcHr8iTa8a3NjTWtYTV4fjv6A5EslJ1vyxWoWbpOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(346002)(366004)(66476007)(66556008)(2906002)(6916009)(38350700002)(38100700002)(6666004)(5660300002)(16526019)(4326008)(86362001)(7696005)(66946007)(52116002)(44832011)(8676002)(1076003)(316002)(186003)(956004)(6486002)(478600001)(8936002)(26005)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IFnPTkqePMO0YWaD7/N+HlHt4JERQNhQKtpEVEGiy/u/07iRCPb21xXj+Uh9?=
 =?us-ascii?Q?GJSyKBnLsV8mRBbv978Zw7IdjjF9bUqpWQMIfti9BD/QBm6OrcQnm8JN6MZ5?=
 =?us-ascii?Q?PVFXpYsZ+vH3VZ91eRLci8g1UpW0+I/VU4y+ufKRH4s7/9xHpBHwm1rgr/33?=
 =?us-ascii?Q?/RI+GHc5hEyayRBQ0zYIiT+LyqlwmnoKqiLIUJvUIKA90hHO4jU/au422c31?=
 =?us-ascii?Q?aOQXP0ifPXH3y4aizJTqtdfG6HjTC4MMju5Xf/VdMKC212e1Qb9MHxb3uGDK?=
 =?us-ascii?Q?EC48MT+YfX1B4Sr0/6AWWk3YMpjxfdhdA42Z9LxEBToS9aAEMzIvrxFUyGUI?=
 =?us-ascii?Q?7EHnaHKgZTIe2wbVOqoAvpaRn0JxquDxmNDs0jK+APjEkQoLltXEpgP6w4cJ?=
 =?us-ascii?Q?Zl88GMGigOdxpGtOlmAygPorsTbY52mlkw88wFxdXI/9AXx8mdRALHTP/Dg2?=
 =?us-ascii?Q?x0ASKKpK+SzAi1006jMpxIuU9YirtPyB9ss/0c1uB+Rf27sEjF06RunsfESw?=
 =?us-ascii?Q?/OmWU7TZ+4RZ2OL8R9ns/EGEReH6/wJkWx/IsjhiEi47rRq01/DfMkS2vJO4?=
 =?us-ascii?Q?mfzDWWz8wAyBiTOKAJHQ7XIAIBgfl2Hq5kbpJKN86x0XHP5ckrt+dvVHuRqG?=
 =?us-ascii?Q?8mW8I7vSKcJqCNhYDDOflLHA7DgM97RZHRr+i2U7zHkzPviAutH+nLYR6MEE?=
 =?us-ascii?Q?J6aVQZ9JJSzphgLTRdBzraLxO7ivRG00He4SXK7v0NBfy0CPxZ3Rgh+qNIv8?=
 =?us-ascii?Q?1bGpMGBWlGD0HyabmqrseJxsFJrRd0FJ/zeTfd+c0s4hGHPOh9qOuJlBCkei?=
 =?us-ascii?Q?7zVGySRVSj4cCbO7+ldtcOt/HK1yeKcvhlICpievRNgbGxJZ6M9bAT+Nsca4?=
 =?us-ascii?Q?NkYo6WIyqg/1kNo/jjQXLJ2/rolqH5ZR+Cj8fQcjxIl1KCmuvaJc5PszBx9j?=
 =?us-ascii?Q?cRCq9IjIznXaD3cIFzwYK7OKTxR3vEiTIhX83LuIlFvtfkFcRagrREF4SOO7?=
 =?us-ascii?Q?DLuqFg3wwqWqJbFisEMeUz+7axVdSDx28B/Xv6dSd7EG4TmoxshO3ZiN5qpN?=
 =?us-ascii?Q?+t5eLjTIzfghH051MVBHlCQ3vJMZ0IMhBrC0qK8ERZMjTxy1SCt5654ztNK0?=
 =?us-ascii?Q?Bx2zVlcqQMKLHJfl/p4wn+Z+E4eKmSIXEe+S66CsHm2R674YWznNGqBVQzYt?=
 =?us-ascii?Q?w0xHI8KeTPaEIhnEr3SQL3z09rgG44HRtN/oKA6qJaSfaCMNvBQVa9vchY/r?=
 =?us-ascii?Q?gpI9Df4BogtUxsuzrTEWwAXzBcUGn2wyQc7WgWuxP+VLV1e+516uZNWbNCj3?=
 =?us-ascii?Q?IliJb9f1exq7MwpbLpJ17noR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aab9e68-8873-4ee4-9b66-08d91f2115ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 02:02:00.9510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEEwuu1WH84Adlpp1acNT/3/szy54qsR3+Ev5naMw9veUTep9TLw2GDI+326UB4NPIlq4iN8EvFMxSPtZfDQQ5YWPrZiAGbMP6zt8PgKPss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4506
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250011
X-Proofpoint-ORIG-GUID: dkKRXh9ameMTgR7ucXKXaaQEes6KQ6cr
X-Proofpoint-GUID: dkKRXh9ameMTgR7ucXKXaaQEes6KQ6cr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9994 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250011
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,

    VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
    in the segment registers that have been loaded.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index d689e73..eb6e73e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2499,6 +2499,37 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 	vmcb->control.intercept = saved_intercept;
 }
 
+#define TEST_CANONICAL(seg_base, msg, is_canonicalized)	{		\
+	u64 saved_addr = seg_base;					\
+	int ret;							\
+									\
+	seg_base = NONCANONICAL;					\
+	ret = svm_vmrun();						\
+	report(ret == SVM_EXIT_VMMCALL &&				\
+	    is_canonical(seg_base) == is_canonicalized, "%s.base: on "	\
+	    "VMRUN %llx, on VMEXIT: %lx", msg, NONCANONICAL, seg_base);	\
+	seg_base = saved_addr;						\
+}
+
+/*
+ * VMRUN canonicalizes (i.e., sign-extend to bit 63) all base addresses
+ • in the segment registers that have been loaded.
+ */
+static void test_vmrun_canonicalization(void)
+{
+
+	TEST_CANONICAL(vmcb->save.es.base, "ES", false);
+	TEST_CANONICAL(vmcb->save.cs.base, "CS", false);
+	TEST_CANONICAL(vmcb->save.ss.base, "SS", false);
+	TEST_CANONICAL(vmcb->save.ds.base, "DS", false);
+	TEST_CANONICAL(vmcb->save.fs.base, "FS", true);
+	TEST_CANONICAL(vmcb->save.gs.base, "GS", true);
+	TEST_CANONICAL(vmcb->save.gdtr.base, "GDTR", false);
+	TEST_CANONICAL(vmcb->save.ldtr.base, "LDTR", true);
+	TEST_CANONICAL(vmcb->save.idtr.base, "IDTR", false);
+	TEST_CANONICAL(vmcb->save.tr.base, "TR", true);
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2508,6 +2539,7 @@ static void svm_guest_state_test(void)
 	test_cr4();
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
+	test_vmrun_canonicalization();
 }
 
 
-- 
2.27.0


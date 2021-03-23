Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4155B3467DE
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 19:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhCWSjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 14:39:10 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55802 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhCWSjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 14:39:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIOTe5050737;
        Tue, 23 Mar 2021 18:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=FveCPFlVVNpCz5DRVWj+aSDizFMfGbWwnX4r/8ljZJw=;
 b=epHQYCOpMWWSbPqvNyRHPaQuSqdHX7taJQ2S95/2/8RLn/HWC3eNGBu+N3Z9KIrzjNSn
 P1HJrg8wnw5xcLZYScN4TxoHvVwKQlnrg9zKOOKkyveOlaCeGLgvTy3R4A7rsipJRbR/
 16MAKnPCMrRx2FvMRCb9b+xCP9QeLaC1WiqTtZGSuC0NqyCPSm/+l5YZQ3V/zDhlxk/c
 eZzsa48cdypIwpBvjFqVayar/MEH9SmRgPZfHdcjOWH1++dRtTCWqoNmY1PNyUY6zqr0
 tI0lXWpYtXXHSZRryffDZXLjWDMt4DpAZnoUHrm99eevYd9dsTj9EqWOijnrdfltcEbH Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37d6jbgb14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIP8Bj022922;
        Tue, 23 Mar 2021 18:38:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3030.oracle.com with ESMTP id 37dtmpv606-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2Jy25Ep2INxEjeurUYL9dgySh8N+bR8xNh7jS2kaoc/oUo6vYdyB3qovnhHCSZLSfN+wChbzlMYZlWzs8T9GTvuxfjRrxL4lJlycNtVh8Yhk7fbbnecNuUex+mYA5RhB4C+mJXWM5F0tEdXyA4Yo2DHd+Dx2sde0VhmZrZPS08TOf9DN+y7K5IfBza5tlFgap+cHrspf0iJ1Y5yKzVmsrUoqTpgpD4ukuFmVVNRzdLb5HGAflIRhT26bltAAENHfCijndeWAPhjT3WJ1ZDXqyDXTLR1jl4oK+OsrfOKcV+GAoKi9AG+G1pYK5zHW9YxAVIUG/ZtcZR5J42YekcJrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FveCPFlVVNpCz5DRVWj+aSDizFMfGbWwnX4r/8ljZJw=;
 b=eI1oaDvZDsi8ykUWSX+XiUrKMWKj9JxdpySnn3C/f0ZwnYzGkXHttxTqLoHXuWnXmWIT6KOtkMdKXK9xc953VocbFZ0mpR+91zlKlAT92Ofz+WeEN4mMVuWmWJudLoOkJGe4JavMk4lMivx5JDFViOZa/tmzv9uHmkv1VlHlzTWob8f941SEdbDz9woE8pECk3tfOSRc/ekZkpu9enfbXHiVUpMuR17JFMpkvVmnCjuuKxJ5zLFnF2Y9wmqfmB/by3m1yoU3VaKzLNZgCQZdqHFEXUFjAWN/dICKtIU45MZVJI4KPz0rZDRYfgVpHDopQ8IAcqO8kEqdBO9MaXJNoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FveCPFlVVNpCz5DRVWj+aSDizFMfGbWwnX4r/8ljZJw=;
 b=YhyInHdK8QqecGdb3KL8YFG8hhSFZ8PFcJnBA+xizSp5HkZ22Q0ke0wU889uU0YYT3Pbx3w4ERatOuVMgYRlaCsT9EMNxxuyw9kGdiO9dEnxyum17E+hcUMj91Xv5DA1KtL17ASpfO83M5CkFA6CgU4t6oUy8gfWBnzA5K1HFpo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2829.namprd10.prod.outlook.com (2603:10b6:805:ce::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Tue, 23 Mar
 2021 18:38:54 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Tue, 23 Mar 2021
 18:38:54 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/4 v5] nSVM: Test effect of host RFLAGS.TF on VMRUN
Date:   Tue, 23 Mar 2021 13:50:06 -0400
Message-Id: <20210323175006.73249-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
References: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BY5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::21) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:a03:1f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 18:38:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba2b82c1-946a-40ed-1c6f-08d8ee2ae897
X-MS-TrafficTypeDiagnostic: SN6PR10MB2829:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2829FEF0D15540DDF5D42EF481649@SN6PR10MB2829.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmtusVb2YiB45mZsZDvhcvTISeABfmYvF82tr4fReECYcthejb2UC4OWkZzxbUceIgt9xTrmq+gYzMcNwV89eBobB3gJImLbq2XnNnrtJy/A7dsvO/p+QVUhS4EUHEm56PrbP0Q+xb3OSBAFtK2vJMCBJWGV/HsLdz5eSPfpn2umQeqZlXtQuBgyt17A4c4kOdzqJpFkLu/1ndi6sPRiuXTtmXHr/dZ31cZaZavsB9gu545CnpCjxzp6snnNqG0OiNwUAQPvZ8yRAI6Hs7t+X1Bp9sBfhxG7wn5//p1XL5H0gs9HJpZO0vYCxSzSbin3oHyN7iqKm0WcS3Jh9Wf1HysDnn1kz0rO9vnbHAJzhX5XKb6UMcBnz6Q5duRtu42ZNgCyUdJsKVv3ms3aNJYnB9oXGpZpTm7qb7avT/IKwAYd+sN4pNJbsaAq/i6eTcUZDTIfqbORvJEvOaGldaQqj7RE9temLMlHxXu0D2/bT0jisImmgUsz6s3GO3XDX0tzdUDNckp9H2VqhF31cSp4ozurKyRLJkjA7TJ55ivsUwEcvKPvAPjzgK3FxN6UihmhYPhDuXFQrVBV9BsqdlvqNcc9CTfYwTfWNC41gtsBx6FQrhxOlrA6jHh68+OLHosy/OnXaMl9HlA/NnAJF34GhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(136003)(376002)(396003)(6666004)(44832011)(52116002)(1076003)(7696005)(86362001)(66556008)(956004)(66476007)(6486002)(2616005)(66946007)(36756003)(26005)(5660300002)(4326008)(38100700001)(2906002)(8676002)(16526019)(316002)(8936002)(6916009)(186003)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YU+8ozzjF0spT7vRKfpm3N+IvYWwX0YHYg1T3w0k9eX8vo0geuZcSUQUaKDW?=
 =?us-ascii?Q?fSy1gooV7GEjoZXY7oBpOxPfi9tynzFloy6+Mab2jNOCb/yKwQ4xqliSCjqW?=
 =?us-ascii?Q?p7e92TsOKs48ccVZg54PCEzemrSJ3YE1ZJHAl7wnLah7gGLzYzc/DFdrA43e?=
 =?us-ascii?Q?lNTe8UtRd5ZpNzK3jZagwVLsT25bx7HvZBTDsEG2HPEJ4hfsSaie4D6Fa9N7?=
 =?us-ascii?Q?sgOGEHeS2JiLvvxjjuTDte1f0jGlmTq1ipixOCZxeT1Bbw71olZhl88A6OtU?=
 =?us-ascii?Q?n6GFzo2vdCcCsgw0jd2CnItYdLRmTkiMzbEFiYkXtMu1VHAxOJtHImlX7KWK?=
 =?us-ascii?Q?b9LrXIgDjIo96dAZHcBvptGiuzp8tJZusZu3Bp5OM0/HBIRdFQXI7bkE5bly?=
 =?us-ascii?Q?Md2CcuUwurvp2GsSeOHKxkhl7XwGjPWx1ykC7r4VvwOUCfITyeGAUJ3qSCdF?=
 =?us-ascii?Q?IEUc6+AihYoAbbXAHuahVtK3I67tl2w5+zEE8BcmQ44VebLVQHmheV7haRgz?=
 =?us-ascii?Q?w8m/B7OUdrvCA+8fFrcYPZwh+IO3yWvemNJmhkwkmA0hTH6qxVBg7y2gNep6?=
 =?us-ascii?Q?PU9TGxyO9CVudybyJ+vZIMoJbpaSoXzc56hJ7gJpJfBYzDveFuaIxP8Xth82?=
 =?us-ascii?Q?Cp792nNUg3NltCrq7UydNMHwW76Y/SU9xz+1hN8udRUVdWiTsrC4NjIKZNvf?=
 =?us-ascii?Q?mICqNdKgTwxorcbeJLNeQsyzaD/MXFsSZs1dUpX9Fm031ceGZOUO0Tdb5V9N?=
 =?us-ascii?Q?w8DQBNZVa1qG3nVwIjyYgZeBpr3Gq+FegSw92KtOCH3vubLWKr963Bcw24Lz?=
 =?us-ascii?Q?/U5Xs9Jr/4m2T6zt+iJgoT74ZrV7GA4PgM9ZVrIwvwNmidgsVrdxrFK5colP?=
 =?us-ascii?Q?sFv14kNCFYo6eveud5yr/gnl5kOMsYs/VBxO0Ktyyd90HnoWkShpWhDUrdPP?=
 =?us-ascii?Q?FFIRXk6KDjr+UelDuDZwKc10QNBKhVQL9yfhvapH7PbWq+2oFFVo2hWC4d6h?=
 =?us-ascii?Q?VKwAQA8caJBqZjOhpCNe15DhRPKgIJQwdU5hHETt5vhJfNcPx2dzUPtZr1Hd?=
 =?us-ascii?Q?KYS7Fc/D0zakjRA1BHe5wZZbuW8f3qS81uEn4rNLb4syLSSbmq6b5I4+E14X?=
 =?us-ascii?Q?VwN5jEpC3NUdGqiEm1xebsgCRHNlphEOXI9mmRmgNtmKKY3G4ZRMTFv/H/ue?=
 =?us-ascii?Q?hQ2CTbu1YAxspa3CUIJl2Tu5LG53qi4jErl4heoLfOCVVuba4z+9buh6ygdC?=
 =?us-ascii?Q?zXxhMMtgeG3DkUJjzmRJkZzjD1E+QRmwvUJcosfofCTEDEHZ+B/+rsQIQL6X?=
 =?us-ascii?Q?4l2fHqlYegyxO1uN7Q914E5P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2b82c1-946a-40ed-1c6f-08d8ee2ae897
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 18:38:54.7050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VruLbgB/+a4tAiZMf/p62zuctfj41A/vsjqnwxtzH7G5JIAShfOhK046mYq7MGRPyNhLF4t8tIIwOhEr+FHCVnMI/EcKM1UT0/ROoGsDg78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2829
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230135
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "VMRUN and TF/RF Bits in EFLAGS" in AMD APM vol 2,

    "From the host point of view, VMRUN acts like a single instruction,
     even though an arbitrary number of guest instructions may execute
     before a #VMEXIT effectively completes the VMRUN. As a single
     host instruction, VMRUN interacts with EFLAGS.TF like ordinary
     instructions. EFLAGS.TF causes a #DB trap after the VMRUN completes
     on the host side (i.e., after the #VMEXIT from the guest).

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..46db49a 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2002,6 +2002,118 @@ static bool init_intercept_check(struct svm_test *test)
     return init_intercept;
 }
 
+/*
+ * Setting host EFLAGS.TF causes a #DB trap after the VMRUN completes on the
+ * host side (i.e., after the #VMEXIT from the guest).
+ *
+ * [AMD APM]
+ */
+static volatile u8 host_rflags_guest_main_flag = 0;
+static volatile u8 host_rflags_db_handler_flag = 0;
+static volatile bool host_rflags_ss_on_vmrun = false;
+static volatile bool host_rflags_vmrun_reached = false;
+static volatile bool host_rflags_set_tf = false;
+static u64 post_vmrun_rip;
+
+extern u64 *vmrun_rip;
+
+static void host_rflags_db_handler(struct ex_regs *r)
+{
+	if (host_rflags_ss_on_vmrun) {
+		if (host_rflags_vmrun_reached) {
+			r->rflags &= ~X86_EFLAGS_TF;
+			post_vmrun_rip = r->rip;
+		} else {
+			if (r->rip == (u64)&vmrun_rip)
+				host_rflags_vmrun_reached = true;
+		}
+	} else {
+		r->rflags &= ~X86_EFLAGS_TF;
+	}
+}
+
+static void host_rflags_prepare(struct svm_test *test)
+{
+	default_prepare(test);
+	handle_exception(DB_VECTOR, host_rflags_db_handler);
+	set_test_stage(test, 0);
+}
+
+static void host_rflags_prepare_gif_clear(struct svm_test *test)
+{
+	if (host_rflags_set_tf)
+		write_rflags(read_rflags() | X86_EFLAGS_TF);
+}
+
+static void host_rflags_test(struct svm_test *test)
+{
+	while (1) {
+		if (get_test_stage(test) > 0 && host_rflags_set_tf &&
+		    (!host_rflags_ss_on_vmrun) &&
+		    (!host_rflags_db_handler_flag))
+			host_rflags_guest_main_flag = 1;
+		if (get_test_stage(test) == 3)
+			break;
+		vmmcall();
+	}
+}
+
+static bool host_rflags_finished(struct svm_test *test)
+{
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
+		/*
+		 * Setting host EFLAGS.TF not immediately before VMRUN, causes
+		 * #DB trap before first guest instruction is executed
+		 */
+		host_rflags_set_tf = true;
+		break;
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
+		    (!host_rflags_guest_main_flag)) {
+			report(false, "Unexpected VMEXIT or #DB handler"
+			    " invoked before guest main. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
+		/*
+		 * Setting host EFLAGS.TF immediately before VMRUN, causes #DB
+		 * trap after VMRUN completes on the host side (i.e., after
+		 * VMEXIT from guest).
+		 */
+		host_rflags_ss_on_vmrun = true;
+		break;
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
+		    (post_vmrun_rip - (u64)&vmrun_rip) != 3) {
+			report(false, "Unexpected VMEXIT or RIP mismatch."
+			    " Exit reason 0x%x, VMRUN RIP: %lx, post-VMRUN"
+			    " RIP: %lx", vmcb->control.exit_code,
+			    (u64)&vmrun_rip, post_vmrun_rip);
+			return true;
+		}
+		host_rflags_set_tf = false;
+		vmcb->save.rip += 3;
+		break;
+	default:
+		return true;
+	}
+	inc_test_stage(test);
+	return get_test_stage(test) == 4;
+}
+
+static bool host_rflags_check(struct svm_test *test)
+{
+	return get_test_stage(test) == 3;
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /*
@@ -2492,6 +2604,9 @@ struct svm_test svm_tests[] = {
     { "svm_init_intercept_test", smp_supported, init_intercept_prepare,
       default_prepare_gif_clear, init_intercept_test,
       init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
+    { "host_rflags", default_supported, host_rflags_prepare,
+      host_rflags_prepare_gif_clear, host_rflags_test,
+      host_rflags_finished, host_rflags_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     TEST(svm_vmrun_errata_test),
-- 
2.27.0


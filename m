Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FE7344F66
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhCVS7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:59:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36066 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbhCVS6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 14:58:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIp9wI072270;
        Mon, 22 Mar 2021 18:58:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=3oqOQzXMmKRKihKmkIfDKh3nJtV0LRHpIc3Ti6MZhJ8=;
 b=lhMM4oBx+L4HSRhSHkJKE950HESQ/83wSHNtwqt0ISpyPy7eoV25+Koj/ysM23YPP3v3
 XaDnmpUjWIxHrvPOGx3um5GdP5OtjDw0xm1r2+sG1crbVjXmI5wP8gQqjwFNC7asT/kD
 vv6caUrmm6+Ke4C1jkpCtZkTLXXQ6HPaKs/s1EKvZRduka7RbAqkrxk83o7KGAoi2OwF
 znODd6Er2FZZXSuvv4nJ9ZMdDaAP6UNVm+UyAqKotLBfMn3JT+hCeGzsRnxpwEfIWbYt
 9hCiCDqoD+wdch97IOIEY0LNXpSUaRo2bE9E+auBTtERdiMWGupC4dRAKTjJAvp6XLDo Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37d6jbcndk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIp58a155689;
        Mon, 22 Mar 2021 18:58:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 37dtmnjpuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYQRuAWgXuzuOewwfNXM0FhJHxMfFPShgmfTYDPeQyiXO0+IDRSLjb0b/0gWlvyRflki35QPRAaqsBX2xL2Qf+SGxnVYqlWe6zysjl+01sq+PQC/8Pq5e9UoaK31z1fidseshUvqGkqpLB5PLb1OiMEe3dS9jayZBPK4fV5988VV9NGJzFe7gloKdYxdJHn5gCpjJwuu/kENbizKbNfo/9Y2ftg3VIC4ICI2qMO/+s5G+asbtm4sDz0M7Fj8sEjkH65VDlpa52Ai3HULjtPHlrsJ04qMW5XLVJAoIRSVaVfHVYFU13flVLp+CxqYwvhySR5WGMbXOtQtslSLGzzETA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oqOQzXMmKRKihKmkIfDKh3nJtV0LRHpIc3Ti6MZhJ8=;
 b=A3NfRaTNgJAroOzBG3bASd5Dw9+qtGAm0/8jEkDa4BrUyF/I6G/718uBT9hUvM+Lj4ixW+/a7Pn2VpcJKyaFNGhG1MAfDJQD5U4HVgu7km6VR+yN9XJPAgJ3ZB6zNk9/mvdX64nuD6z19npSjWUaNoDfGC9aoQAnnwADWn3A6yktHSRm7XXNDYdDV2OYjGNw/D706oNaFvGsEhPQ49GQ+cEhhSNvRKHiWu9kD2sdsV5huhAPjl+UVQdrBVk4hNmGO5p84p1DI8z3DvmmgxK5ZT6PY+YUiVyldnKzDInASrZbjPgh0I7+vo1dxCOIawWp8t4F5tzGCj+OQpNCxu4GVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oqOQzXMmKRKihKmkIfDKh3nJtV0LRHpIc3Ti6MZhJ8=;
 b=B5pAVQzcdaIqg7WT68xhqQbVXZHv77GtFy7HMc+Yc9oE+eMjkbpq3cbIBRwJfALJTPu+JKoQEK7hzC7QX6G0qSLcT0/b4nJY1c4dyMlnVk5FnBsu4am1jQdwrTosyofeOtThPU9eA9p3H5GawWPMkNfzby9RCqItsPPBPEu9cJ8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 18:58:45 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 18:58:45 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/4 v4] nSVM: Test effect of host RFLAGS.TF on VMRUN
Date:   Mon, 22 Mar 2021 14:10:07 -0400
Message-Id: <20210322181007.71519-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
References: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: CH2PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:610:60::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by CH2PR14CA0021.namprd14.prod.outlook.com (2603:10b6:610:60::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 18:58:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 488ec309-582b-4d05-1cdb-08d8ed64841e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB47952CE2562986077473D70D81659@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3dTtyHx2mCdD5uLGTeo5dH4xKr4J6tdtM/yh/2jQZpZ9znt6V4xeD3Vs3FmKR2cNXn8bvYArxDP91d2cDgA6v6GCEfsKRYrJaQxB2TGGd3CLWemweZdob5ypfMF8q8fES3A7eDfSox52mG09U66uY2/d5nFXPDE4StXkyMqUPJqJUPgxr5++rT4jWnPGzQZcf214eVL5ys18ABX6ph/o62FjjMn577QnbJE5SUstjuaCA7i2Ht03QbkjW8a0iPDyb6ImMz7wAOq0UNl7zgWsJ6nB9su9bw8aO7serFYpaEM6Tvfeo87QgGw3a8AJ/XHu/GvILqvwokMGCHXX0ANGkS4CCZgnxiOvNyIRJSwvgJTEOgiq7W+wWc0yGdwrISpRcLlc4wGs2VwnQYLIqrfOptmdtrEY6wJWWD2gjbIk0fqeIksK8sJwiHT2+rG0KJn/WE1GFWpHhu8WxP4SwZanH/OQ0L3vDxiPUod7vgPre0nqXS7zYQWopnnCtbA+iQx4Cw/7Qrm5DQEhwqycE7nJa1jTiGCXfGw2jtECj+1JikY6JDltFDlG2vC1QMWWRQ/q4rrijblnyUqA2Hcc6nhKkXtn37HN8OQ1VqMputXLIKET7QH9/ddm6eLs2W23Y067B0squeOB2y9Jh/haflQ8cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(6486002)(2906002)(16526019)(186003)(6666004)(26005)(44832011)(5660300002)(66556008)(86362001)(52116002)(4326008)(2616005)(316002)(8936002)(1076003)(7696005)(38100700001)(36756003)(478600001)(66946007)(8676002)(956004)(66476007)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dQgx2/OEiReArSyJEg7FS+hOjMmtXshTIwOQM6GMefWb/1pBhNwNW6LD9+cC?=
 =?us-ascii?Q?7PQ1peRiSKQF2O2+/NnaI1z/r36fuoKfL5yKfhNe6O/ilHNGfpvkVe+K+Tmu?=
 =?us-ascii?Q?avy3usxKiHX1ryUyPi2gdGKVDFEYlcJfgg9vUDCqM8rP9SGZW1kv/XcsiQ5A?=
 =?us-ascii?Q?b8jtxpIQ9SIWYwGQkLVgB8bUHZZ9a7cs7Tf+S0oBg92vLCQEK5yGbZiy41NO?=
 =?us-ascii?Q?FQEjVaSEiJrFHwsiO+PYfUkFCiZyqO6t7C9VLrA2oEuKVlhLGUhqNpFBpRon?=
 =?us-ascii?Q?JftXnt5kLJJvEESzFKLKm9zckYEyuA8lUCJEi82pwZKZ5JzbUkeLRhNwaaqu?=
 =?us-ascii?Q?CBD9e+Ol4wwvPwWlm/cDA1zC02DoEQA9GVDSGnfftl8dqM+jLUkD5fylpq2h?=
 =?us-ascii?Q?hxmsOVfW2zE6bnw8b5KVrfW8sSpqE72epHn8/ccN9MX1Mmz50Q3DEQoXHCSw?=
 =?us-ascii?Q?TgXgwKtG563nsgUYMw7MmNk+9rkgGkeJe34en/zxKISP5HoTxsmsKLhmdtvC?=
 =?us-ascii?Q?kQNtWRkwn4sZaOG8XnSUgualG4Y31G+Hyim2UqroPj1pVVq+qe7LE3YVuzMB?=
 =?us-ascii?Q?liPyXR8mlUofikLCSQUnefaHwHDsPMjl0kbDECwkig3d8S1nC4L2A9ZrwjmI?=
 =?us-ascii?Q?H3J8tJmmSTPJ+RN4MwrT/OM8NT31ERRAZgc6bqbx8raGlM2itrTEREGIBrvx?=
 =?us-ascii?Q?X6wdqNfkWpcIIZJg3KAd2BeqPcSo464bJoo5qx49PL+HO4BlyYV9Hys5oi80?=
 =?us-ascii?Q?VJOwUepepa6Pant50YZ9PS/V8p51Mv0nTRRewKePmXGoPXRcejvVJ1E13a5p?=
 =?us-ascii?Q?rSGt9OI4SiHFKtkTY9i/OoSlqFpai/HebzrT9AAaZEHlYwoDf5ak2KxYWwjc?=
 =?us-ascii?Q?wrcvu9HFz9sqdEOjz3I9CowzKR1qVo55q2L5sxOuqlXrtX55KNlF1ZClPnqT?=
 =?us-ascii?Q?2ca69ALf0I6+Bpk62oAXooDQV7Z09WJClfclVaZPYpzTO1A/VvOx5K48uVnN?=
 =?us-ascii?Q?XC9Z6IEFHoX49i2ebULl6I+lbA3fOm8knv7OybiJHQaMbuDZFyOVgY212Fwe?=
 =?us-ascii?Q?WaK5PS881+la7fTCWCl/Qu4UvIYK13xKbNC90QEazA3McUnafWKvd7Eu/wK9?=
 =?us-ascii?Q?tH7hNAIkpXiwsbMcNYxMPgVEQzay0KIfVNIbdv9EBCGnJoItyCvPDkoUAHmX?=
 =?us-ascii?Q?bKUipHv/i2G4OHLFUFYegTdt7kPTJeNnCPkjhPHgDa6+9wCqgvBZJrg81ERO?=
 =?us-ascii?Q?ejjBzThEuLSqq0v3+7ANT05l5DqRL0qdAJ8VHa6GyVLIOGizIE2o9NSXyBKw?=
 =?us-ascii?Q?MOdT/+iOLmXyovu5Xn4UhjKe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 488ec309-582b-4d05-1cdb-08d8ed64841e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 18:58:45.1987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G062W8uob/9fQlmr9iITpB6RYwauV288SQ0AQjL2dEUzNwx8nUmDgUTn966tmQGmGjiz+B3Mh9L4O4ZbbkvDM0316SCnde9h0x+iGHWTjVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220136
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
index 29a0b59..fd990f2 100644
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
+extern void *vmrun_rip;
+
+static void host_rflags_db_handler(struct ex_regs *r)
+{
+	if (host_rflags_ss_on_vmrun) {
+		if (host_rflags_vmrun_reached) {
+			r->rflags &= ~X86_EFLAGS_TF;
+			post_vmrun_rip = r->rip;
+		} else {
+			if (r->rip == (u64)(&vmrun_rip))
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
+		    post_vmrun_rip - (u64)(&vmrun_rip) != 3) {
+			report(false, "Unexpected VMEXIT or RIP mismatch."
+			    " Exit reason 0x%x, VMRUN RIP: %lx, post-VMRUN"
+			    " RIP: %lx", vmcb->control.exit_code,
+			    (u64)(&vmrun_rip), post_vmrun_rip);
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


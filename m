Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271FE35D35F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343830AbhDLWpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:45:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbhDLWpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMcnBQ170320;
        Mon, 12 Apr 2021 22:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=XM+f3CSviDJaAEMD1+a0+/9ZO+z3OpmRI489A5hn52Q=;
 b=kcGzH6iSJieDO1r5MWZ/eeqvIfM+o23+Uld3FcGH/0WM878Q3B+Rjxq4dnPMSgT+4/5h
 Rxo14QeAdWOPulRiuHlZLwEDQQEE42OIrwzVjPNppdY6ffP3i59JQBVo6U7XfnKgqRsR
 gZZEdhtY08myg2x3wfwyPTh6JEc8RnJZZJolMUFMK4np6n6wMzIB6FroaKMk7jOJz09f
 hMxNFeLjcVt/1MKsPj6My91bBEJWfSBLukzOHg0vjSRuSBeJscwnWPLqdRA3qX4eu7wN
 IclwX7evd3rDkVZp56TLRQhZyYL6g11CBAT67hmaBTeKAzo2xT5FixNOJa4THumvpJaW 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ymd9gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMdc4G167396;
        Mon, 12 Apr 2021 22:45:02 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by aserp3020.oracle.com with ESMTP id 37unwxy5sq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsRzVNnKkEVdAWc/lyYk8xaqvWzrmNkbuI8PpSLGoMjf2ks7qv/gShhThyXfx+hUfbolSn7d3BJgO7yi6XljkXDzMypB2fnmrKwfYyXe4xuigWYeGYnIpIEPHXlrYNG4g79cuWfeiQneZoljN64e6GLbR8GDLZEFRQeMXe7v3h4fKUeJmQv22o7w05zDRB/stpQI6zE32555GGUuqFAm/wV+U0b+EZUXJdIflKIqM9WgF24W3rxKGXPQZDo3Qamh3u3oIe5WRcWSUQp+anGGI1nLCiS1Z0T6UhfshVIsIxsJqlDl4zcGIP1L6oURocv9gBQPbDl3rHwHHJRn7XzOtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XM+f3CSviDJaAEMD1+a0+/9ZO+z3OpmRI489A5hn52Q=;
 b=iqTzGSAMZXtg0fy6KnRKjCU8OjVKYMbKVg3esRmtiaDqGCAIrDrjG6xKpJLH9sno5g7tUHJfQumZpJKWwtooLUQD3lmaTSrvYjDs6yribrnVSZKy7PT6IS8uNOqasr960520uKRwJLtqCxAFreYM0XdlbHUkTR4cujxIQ0P9ymK+Qbti6nEyk3EVgce9Uoqgh3H3yYa06VftuDd4aiZpreiUfLnZrG6yMKRKlgWAhWdOlTNoyOPwZU1CFrpGH/qbD8i/TXevCJ7y3r8d386jBdqrWd/QFpMNWTin4IVEj6RIgGhWYsWrrA4LRtzOie+HCYNZe0uADcVtti9rAr0L1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XM+f3CSviDJaAEMD1+a0+/9ZO+z3OpmRI489A5hn52Q=;
 b=Lga76LiGEsEDKZFrDVmIpECsCyiNgqFbelKJAbMGiPxRfCKDQB0YXAWvoD1QVMczhCRC0nBe+o0T6z/QKbDnRxBAknCvMpjC0UM74hzjIPyG1eRzYyYAM1K1nKhASGML68AxXOaFIA0kTakIZ8TYcrijn0tyK4s6xXYgkAT6MCA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3088.namprd10.prod.outlook.com (2603:10b6:805:d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:45:01 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:45:00 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/7 v7] KVM: nSVM: Define an exit code to reflect consistency check failure
Date:   Mon, 12 Apr 2021 17:56:06 -0400
Message-Id: <20210412215611.110095-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:45:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a588135-1265-4eb6-9075-08d8fe049b02
X-MS-TrafficTypeDiagnostic: SN6PR10MB3088:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3088DE51E14B7DDCD459D16481709@SN6PR10MB3088.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzcBDks2Dp1PECbEiM4b2LKXnL9JoGf/6YvXFQE4yMQYZakyVt6qPbAYmDI49gSmpAPH/NlQyGHLVI1bgZyLyg4FzcIcTy0OlPzt+LAfxWxGrv4/54VLHPjdN7NAdZjm4kHxnwpacGqJJSfqQyBgCEjoXv24rftYiVr418xFcdfsX2uQtrvVIVQEwnUMuKD66L8z6cR15WE5br5ff3u1KCG3QLDSTVXSHN0QpSusUOj/0BZWTTiupJoqKoe0iPYA5nBKJ2nDCOBaO315hO1ApmIY7+TCPEcCeg6UPP0+XZ97NIOSOiu0HJxUpct/AugpLZ2eEJe+o+tICZncP0spB3WNpbvCV6y49JNDED1F2PCTW0xbVEfCJBIAjFnnlz81Gy/mYrRmL4XDNRAJ9bj6evlJBGVE3gFD4ffP0W1Bvt82o9JCCQXN+4c12s/YAxaE2zrCx0tfaMqUSJn/JWSGaE2l1jTZ+9t/xi/teesJG5hJci3qB970GdzUJNUQ+dHjKeGK7pS9c/GsopsDLmdvnEyHumlU50i8hlSzthFb0S7PsausQ5Xz9pk0DfEXrqAs3ccQNxS0r3rIr5S/hlv5/gVTTk8UqDPovcZ29uvv14iF3x25mz+nqgwO/Mk/l8yEusK6EVzCMLFG6jGQJVOVcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(83380400001)(86362001)(2906002)(956004)(316002)(1076003)(2616005)(478600001)(4326008)(8676002)(7696005)(36756003)(6486002)(52116002)(26005)(5660300002)(186003)(16526019)(44832011)(66946007)(66556008)(38100700002)(6916009)(38350700002)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MJxTVavP5yXy7SZpN/6OkFul3u3/Uv1dy6h2QA5lOTezsRrkoYFJ8E1DnXK7?=
 =?us-ascii?Q?mz+VWkLlUHPhIyLlihemWuRiFyQTCaBZpVq8n31m6phIEGtbPAOyFke7bexK?=
 =?us-ascii?Q?14d2Dp43a8TmaLgRmzqmuxMVW17pMPyWMH4QI1LyGjo7K+4kauOSEy2jWixt?=
 =?us-ascii?Q?2sUqPYqS7XWRU8lEezEI8TuEVFrVXPFmWJB9H7nzOISraMwsRwlcEG+O1aPI?=
 =?us-ascii?Q?99k317ACz1KqrzqTa8kL8r+YG4nFxlD4WZaxvMrANrQl2kOnrHWPMfDranWz?=
 =?us-ascii?Q?WehUDdJ5fpefg40S8Rkqw3YTPc5vmgLwB5IEwZ95//G+E/bmc6dKVOa8TCZV?=
 =?us-ascii?Q?Ejg6IzWyPEGLdtOTXpz/Jq4KyKbOLx+SWgH6cCaC1iJZjNLVitrPNGSeAd9l?=
 =?us-ascii?Q?x16pQf+zv4P++QX//vZtLHVhIxCMttIcMdsdSmYuNJjZd5zOmm6uJdsn+L0l?=
 =?us-ascii?Q?sTpTJjRAX90B7gu6s/yGKY+/Yjz5xAwJcx6B49CtOE01D2eANdwDa6CpVmoN?=
 =?us-ascii?Q?Q4ARgGm9Qus7fa2NNkO7pwKSfiOSmLSGCjXasWxHpDU2vAgP9546xwilE43n?=
 =?us-ascii?Q?8fUhMFfvRMEuIfbx4UqoKUeY8FVSKQ/jOzShIPeaqP5u8b1eaSu9ylfyV5YZ?=
 =?us-ascii?Q?BxNmLZX4FOsEKGlCcp0d3PLd160hZPQ2CIerQl0VsiZ/25qWM4oY8rF45r9q?=
 =?us-ascii?Q?o5HxFdWAQTd8kEMguXttTuhjVnl2PStV18GS/uKM1KEEvc4uHWW70/0oAHIX?=
 =?us-ascii?Q?wB+F4aLefAvQnxnqzCgTxUAbzQ9SuGa5aPiw1PtDTUd+XS0NefXrVZKPmsLk?=
 =?us-ascii?Q?6qayisTzrkcAF7YWRPxNS8jzN+oZqHk0LQYm6/0IUvhqqDgnKpr2+lrsXgBe?=
 =?us-ascii?Q?djQikoI9uqFqBOHoMATU29ninHhGLtweYEhFZUp3W349s90tB01/sTSUG2un?=
 =?us-ascii?Q?JCOxRYK33XZ6phzQ6zsMBIBlEhAUHcSZaaAeL2wQmDP9ndSLYZX4PYnqHiqE?=
 =?us-ascii?Q?DmCe8T/nyA4I4Uab+cKrLFrVonHX7txCJ1tkBMgKICwlX4zXY/r/r2Mx88FC?=
 =?us-ascii?Q?Q2vkWOGARJ9/52KbU2LoQWhbgL/6llFbfcVSashjd7WSg1YQCP3DRjfDa0lP?=
 =?us-ascii?Q?kuLlAWmGolFdAqUj/STxn37+8uzTHYc6uasJUV2gukUwytDnrWEKYUfOGXfv?=
 =?us-ascii?Q?aPAwuHI+Aew+ohXsDhW/2HLzaCs8hMvcF+spSErf59MUcfwgCoT04bwZOQ7J?=
 =?us-ascii?Q?y9HuIJJd6x8sRm9nQcAY7/uMsKwyEBK6osk6d1EVdfCXgRaxKBusmE+QBnoO?=
 =?us-ascii?Q?h6y3RhOqEkvR2kwsV2A+4K2t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a588135-1265-4eb6-9075-08d8fe049b02
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:45:00.8944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBCBBAhukleSsD60/1P0Ng3IMvmnk4dQFjasXABEFNhkCU4qelIIwpWgC12Q6DTUwbkyKmTB93vyoVwKNtf4GvOeerTFrk1amKgqf55ESfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3088
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
X-Proofpoint-GUID: ZvmuCfMZCuXK28KG1G-iFD5ZNUClWio4
X-Proofpoint-ORIG-GUID: ZvmuCfMZCuXK28KG1G-iFD5ZNUClWio4
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120146
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_svm_vmrun() returns SVM_EXIT_ERR both when consistency checks for
MSRPM fail and when merging the MSRPM of vmcb12 with that of KVM fails. These
two failures are different in that the first one happens during consistency
checking while the second happens after consistency checking passes and after
guest mode switch is done. In order to differentiate between the two types of
error conditions, define an exit code that can be used to denote consistency
check failures. This new exit code is similar to what nVMX uses to denote
consistency check failures. For nSVM, we will use the highest bit in the high
part of the EXIT_CODE field.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/include/uapi/asm/svm.h | 1 +
 arch/x86/kvm/svm/nested.c       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 554f75fe013c..b0a6550a23f5 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -111,6 +111,7 @@
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 #define SVM_EXIT_ERR           -1
+#define	SVM_CONSISTENCY_ERR    1 << 31
 
 #define SVM_EXIT_REASONS \
 	{ SVM_EXIT_READ_CR0,    "read_cr0" }, \
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8453c898b68b..ae53ae46ebca 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -606,7 +606,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
 	    !nested_vmcb_check_controls(&svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_code_hi = 0;
+		vmcb12->control.exit_code_hi = SVM_CONSISTENCY_ERR;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
 		goto out;
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC983467DA
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 19:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhCWSjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 14:39:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44822 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhCWSiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 14:38:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIOjDH166831;
        Tue, 23 Mar 2021 18:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=oI+jRfUT8/LTeal7sxTiD5VotikYIf0caD3DMotVJEI=;
 b=Q/+nDaZK9aQdRBSq0Bk66zX9NLtTLCwUnoOD7Ea1aAYpxoY5FIkaBzaWTV+lm57bHsse
 TEI7AlinKEGKyGsjSr6Qr8yEE7HlDSFhSRGxlBhPfb/B2bcCFZ37j6UT6mgY6fqY+ZwQ
 L8tmd8vHxs89oUtU11W4e9nm0RXbjFaOq/SqII7EVhunqRfG/K9TxnfGgsvlp33xFl/1
 yNGbfS6/NJ8dCQScSuFButNYZ4uhwhSn+KLXbE5oNmNrpDjOnKzssjffcByOGkntt8cs
 lpLpWYYO6gCrCIiHRWM09wjPHThmZqUsfQA7l3+rmtxyNwjaLIAxhShvGYLM5VTxzeCo rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pn0634-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIQNs4075389;
        Tue, 23 Mar 2021 18:38:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3020.oracle.com with ESMTP id 37dtxym92t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7t4nYJAxCjAKi7ZxmCiGCkDpYoo7/eaFQVsYqfu+mObX8fBS8Oh0iud1/wS8ImJJ+us5K3iedLOFJw7dFplZkGi0ZVek0FCTVmK97MSC8bpWgHclAOcmMp4TZx3+ku+1Q9o2gNMc4/VctdjW7eB33iUJcUszxEgXeiLx5z1bxXeOv75br1cFVw5+EbhqTy3Sk314V2vqbGdxZBVj2sCxG0OYGsSqFR+qBjkb+yXWZZu1F9YaX2rSFxJoV2+GLeoiDjcNynw5BQkxrOSp2cOe5Y6UscCv5NZ6u9Je+7kA7oa10Jw9hLEpVOMmbmSJTgjuoSjufS4x84yO7YJAMiynw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oI+jRfUT8/LTeal7sxTiD5VotikYIf0caD3DMotVJEI=;
 b=GfcDLA4zxOMBZ1bQPj3UxfeR0FQoV3HpZ7WfrDkQQKmckhIV9DyHjyir5ZJH0FmY3olN6ZRsZXdLqDphtoNSFViD0TcivLcU4+V2PY5CFsDyd1GmVpq9aJmh5+Z4GOFFx6l/KCPtI8oXrfLs/2VBiPeO0ru8CCu0MP+JD2yZ3We9mokIg46MbezHSTfwvxIxWMTnknAmgGLKnsQrkn+QGaEsRG6irRVVBIOJJnw8O8Ye7MDkcmlP2CC9oJ9Vz3j8Zk1KeFlb/zThWUz5UPWFyO8PTlCRnCKcfa7thZqH3fWfijMw5f++mq4U/pNnZssbeNsuSalfdXBl3/bsaHTWFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oI+jRfUT8/LTeal7sxTiD5VotikYIf0caD3DMotVJEI=;
 b=SrDJGs4QoPcG5H6vPQ3U+Yi7Z+XcvLkSx4jKjH0xLUAOSCm/ixV88zBb6RUzUmQF3k85x7M8U6RlurfLUTyHorInrP55/fK+2+N31OVt21JPzxVsiArB4VzVT91f+CYJ1KR9gCMcQKHFf/H/HeZHDN88xx8yhnoxua3IiHcHSTQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4508.namprd10.prod.outlook.com (2603:10b6:806:11d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 18:38:44 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Tue, 23 Mar 2021
 18:38:43 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/4 v5] KVM: nSVM: If VMRUN is single-stepped, queue the #DB intercept in nested_svm_vmexit()
Date:   Tue, 23 Mar 2021 13:50:03 -0400
Message-Id: <20210323175006.73249-2-krish.sadhukhan@oracle.com>
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
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:a03:1f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 18:38:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdfe4f03-ebda-40cc-b982-08d8ee2ae1e2
X-MS-TrafficTypeDiagnostic: SA2PR10MB4508:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4508C55A53BFB3ABC09030B781649@SA2PR10MB4508.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uAnlQnUXEDDWc2ezj73RGZrZlvg/ZbXjyu0KL1PAhpGpQlhzRCI/fqSGjwaNU3NvYgf2S6ATWaP1qXpEopHPphL3Zgw0NdtdoYCcasG5fzyfwkoRDizhHJnOhS+yr2bjkjtIxgVEpfSaAjObhwUooICDvTqWmVs8L+bDT7ewM8F0CkFQaODL7MgYzqTfOPKmPtHzw4IXiXHyjuNp9cmV4O+7zSWnkgZEUl3dEpLzxwzsDosOP4t0W5UyZElDiKuqnfS32X4DnvI+Y6bl0yam1ZRTxbbto7LgYFhnzJUchJAUgocv05w54rUko85H6x4ejzt6k4j8CYYFmZ3xS7BqxkJsdfFFn4U+SSmOwHgoW6ZOyukfumsDQ0GZ776qc4F2qiez6OFd2/pKIIFvl8FJF8DSQLjbn374VGbGXxkHBMY3aaDmXDQkAMrlDaF+mWWr7TAFKYc8AODrfmmI5vU+WwF7oDEkxev68FJT6+00Huw+T77QnyHKDIbeUmKvlGuykajxhKJrgJIpFyilLQUuV6KiMBgfqXCtopmbKl/AvijiZK0GVhYGJjXo8Xt18gSISfJ/otlsfZICAYeEGRyaY+5q4mgNcPGV6p3+gvjMcChLxuRiph0V0V5yCy8zE+iNnp6RmQ15UeD/lTyEOOYTWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(136003)(366004)(44832011)(1076003)(16526019)(2906002)(316002)(2616005)(6486002)(5660300002)(83380400001)(38100700001)(66556008)(478600001)(66476007)(8936002)(66946007)(36756003)(6916009)(7696005)(86362001)(6666004)(8676002)(4326008)(52116002)(26005)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3o88P0C0pyrZW6SqhSfeCcvbWD3xwMGYuSacvKsX/HPVQZZMLDfWeZZ0N5cZ?=
 =?us-ascii?Q?SI3GRw3eaWIi8fS+Bapj+3e86/1EnCSwZUEqOrmUrmjWKYviitv4QzTgBc7c?=
 =?us-ascii?Q?dheiWpaEAzIKvNSir5/pG23x9Dud1D7gvIEQloiST3fHAx183zvPTv3X8ozG?=
 =?us-ascii?Q?UWe+JfznPULCNDRv9lsu+pUBKzkCRe2NqT7zU8TmEaZmv0vRGrS8tmFdKgRt?=
 =?us-ascii?Q?wh+GK1/Xkgkq6IH0arxM5GTdlMemO8mktJC8L8c3XzjChl3521KaFj+MS4N7?=
 =?us-ascii?Q?T0zkPpH2InY1bToQG1EVUXMMzgMguArHXCa8XhBU2iBP7jlndmvHy2S8o92U?=
 =?us-ascii?Q?PECzA+OFBOBSfzSQSU6jPAiGN+zqva9O00iuCM8zk++M9ACNwyLLaOm9M0NA?=
 =?us-ascii?Q?XCS1K6pVFMNyZonKI4Q8WltcbLSLHo+y22+jaPivM8UiG7pdO+LZN0s1t6oL?=
 =?us-ascii?Q?M7eiF6YWK3ZzPNoGXF7ZGxLTNzWeQ8V6/qHYr1X4R8soNRGpWTXtnjBEZy5D?=
 =?us-ascii?Q?J43wvQCN7d/r7F1j2c9cp+iV76O6nN/+FdYTEYcgtCTPeT+5zx6WQzZofQ0S?=
 =?us-ascii?Q?iwYBMFS5NKeMA4RyV5NL0EXV/rfhsnVivTqfGiPyQoVPVyfSKRwkVBN86bHS?=
 =?us-ascii?Q?3ivgOgnbZSHLyHHDvqCKHxZS0BLPILGMHIgRZWR7Xhv5xmY2nB+akZnreHnu?=
 =?us-ascii?Q?YzlxOKkL5PS9w+YhLu4p5UY7+Ju1pzUuRnr7Skb86Vmu1O6ohJakFsARPG+r?=
 =?us-ascii?Q?+iAGR03GRcbnpinz/+hbZAHTrKWgzQOMSKS4GWDXBO7vco06AouLvi6bvcWJ?=
 =?us-ascii?Q?Zi8AhMAShzUl1cXSx4W+VhJz1WuIQq4ZaRPt9IEfz06I6X8P4He1+UFwtiQl?=
 =?us-ascii?Q?XTaVqJ5iHDBwEC0kO0Mkd885JLLVOI6u/t+runnt4aiH7szgWmzwo9/FIRn/?=
 =?us-ascii?Q?PM7u2b5CFNVDZVmbQSD8reU5ZszSA24V8law4OvXM1tJ6ou+YRWpHWdDf3ak?=
 =?us-ascii?Q?GnPW2PupLln31K8B77iA2+xrurU9b9H4AwWRks7a2OCJ/MBrEVN85CK7wYiO?=
 =?us-ascii?Q?NwygqXscNK4HNTgQLaFuqG33LdEc8i4cTWUXPfTDK5cXV1oOp4iVp/AbLJUM?=
 =?us-ascii?Q?TH4+nB81CjOVxTlDu1Ud9YudD6RPpCnRHb+7pCdQmUFcvux/D/SPIcK+X6TE?=
 =?us-ascii?Q?Rbhl//QqxA9ZYocdUz9xWNbeQfb8jpVZk5USxyuzIcTErjlkpdKvqxmHeInO?=
 =?us-ascii?Q?4N/4LaqKYToWfHSg3Er9SX2sb9rXd2fHMjOUQDRzQzcZToMjKGEOCI7coVKi?=
 =?us-ascii?Q?3f3ENzm1QLRsLLYrBRiZXFsl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfe4f03-ebda-40cc-b982-08d8ee2ae1e2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 18:38:43.9602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pIIoYDqTdx39spZRtsOOtRSUVhOTlS38c1aVpbKDB81bH/u59LeVA9ontDlO44AreJaVkIiWvMoayhc9q0VjgBnGXwBhApoC3E88Y303ZDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4508
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230135
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to APM, the #DB intercept for a single-stepped VMRUN must happen
after the completion of that instruction, when the guest does #VMEXIT to
the host. However, in the current implementation of KVM, the #DB intercept
for a single-stepped VMRUN happens after the completion of the instruction
that follows the VMRUN instruction. When the #DB intercept handler is
invoked, it shows the RIP of the instruction that follows VMRUN, instead of
of VMRUN itself. This is an incorrect RIP as far as single-stepping VMRUN
is concerned.

This patch fixes the problem by checking, in nested_svm_vmexit(), for the
condition that the VMRUN instruction is being single-stepped and if so,
queues the pending #DB intercept so that the #DB is accounted for before
we execute L1's next instruction.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
---
 arch/x86/kvm/svm/nested.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 35891d9a1099..713ce5cfb0db 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -720,6 +720,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
+	/*
+	 * If we are here following the completion of a VMRUN that
+	 * is being single-stepped, queue the pending #DB intercept
+	 * right now so that it an be accounted for before we execute
+	 * L1's next instruction.
+	 */
+	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_VMRUN &&
+	    svm->vmcb->save.rflags & X86_EFLAGS_TF))
+		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
+
 	return 0;
 }
 
-- 
2.27.0


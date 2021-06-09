Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6155D3A1D3D
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhFIS4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:56:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46346 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFIS4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:56:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159InSrR195152;
        Wed, 9 Jun 2021 18:53:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=w2vUXhDaOWktz4RbDt+pqrqVW+N04Hvh8ATKg5xyujS0Ssym83MsXXJPrg/1KN8hG1G+
 GETZ5iW3W1KrfCxrBExZvZvfqxQ/j0FnUwtkUrUXcQq4k09iMOvY6zzB9vNUk6EGhYyK
 8K5H00rl3m0qYiTl+Ett5ib8l7jeGmtNttcNbZLUDd3LWoTUwxAaCUtjUUOOJhXTF4jr
 5RGrLGkA9xnBw3EXoyIaOr1W4OLzO6KubkoZdlqOG2imEd9eeqa32vVXhk8C1YXg7wcZ
 zu6+dNkg/1aVnunbSplHF4WSq6uT4tnFQXvwZ5xDxg9Oq5vmQ1J1wIF0p19YkSINFgCv 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38yxscj2r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 18:53:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159Ip6AT146254;
        Wed, 9 Jun 2021 18:53:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by userp3020.oracle.com with ESMTP id 390k1s714d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 18:53:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQrkXTmOpxu8WaKmRwW5OfZUxtl0bd0+JJ0wKXDAEhh7BMRYKFrI9z+CIOSFc6LQWUA9TLYtqLPCVjcQ/O9ypm0EMDM/okq5r9F7HkPryph4d0lqhHl4wpCaHNTIqiNp/meHU7cJRkD4cEn4K1fWYqLh1xg/egyH3EQ3CJ3XPdgyKGoJ4QlUHh11TllU9oeFc6JXBjCAJAxqEDvdSbNLOCJ7ml1aVEWtFY0GHcviHhGygW+jsjiXXm0St0Z7ssmNyzoEo7VGFGgSSeKzTTIsZzON7kfu3Ob3hXKomRRaCqQJbgvKv1IVn1aLu+w19srxazJKnJfEto/ypJlV5rkurA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=BfzXvuRxeVVY7+9PU13e5cuy/wFW5NvPVGqrdK3uwYuLbebLh585HP1mGbxs32zJ8fS2Q6imP5XWHJd8HymKMilhtwb/rx9ClklPbCYWP6hIFeMZXsluxc9tNfZ7cyQK17mBwG/pFvki1bl3lfk78zDZgvk80I5teUDxPI9ulS0y6y8ROBcJrCSGL8V4nIUlr4p//+WN1GIztT8sHXnd/L7kBPZP6JN/tr1HtNma/fe1RBemANvyRBXk1eaYWaW9lTFKMcyXBOLSelY/OtAADYBE1BYhSLBzAKoVzkLOOd0w9/lk3ushczK85ulFY1u+lRGwLew8eMv+mY/Oj1PSIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=pLd+sIy/iF5ngr2nAaSV8YvplFPri5m+4Sp4u7H6eTER1gsbIJRLGoeSvQEwSMx+YHQeHjcs9+GoS0qeMsZ7ToXgHfPKDyeCGmB+miOkTAXSkbzkyddeFt+kjlAhmwTxrXoNowt/C3iJ8rP0N6z4OmdV/xvefSXDr6TbtRqwstQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 9 Jun
 2021 18:53:11 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 18:53:11 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 1/3 v4] KVM: nVMX: nSVM: 'nested_run' should count guest-entry attempts that make it to guest code
Date:   Wed,  9 Jun 2021 14:03:38 -0400
Message-Id: <20210609180340.104248-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210609180340.104248-1-krish.sadhukhan@oracle.com>
References: <20210609180340.104248-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR08CA0055.namprd08.prod.outlook.com
 (2603:10b6:a03:117::32) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR08CA0055.namprd08.prod.outlook.com (2603:10b6:a03:117::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 18:53:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2871aaa-d26e-44e1-3fa9-08d92b77d40c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2510:
X-Microsoft-Antispam-PRVS: <SN6PR10MB25109AD0EDC562D976F9384381369@SN6PR10MB2510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yghklAAnq4h2smFEbKYQWxUtxhIJXzHBoc0j2a1vpLPLYk1mnCoSGw9YrQDonQkxz0idbim9+O99msR3Nq7qFnuzFEiYWU+EZqPXTvkmg+j4/onGtJ3U2mFogUVAMY6xM6CoivC6PajHFkcDpNbGqBla7os997ECoUBli4hiqg23oSFiM9ozEXt6tYEJw8xMtkGJByn+rv1RZtNnTqakNePt58FZc5SG7Zlu6X8igie25bnB5mH7ihoQGzsXs2TdUZul4Xx9/Kjc5acdUNMtXyBqMb9AycvdDOM2rys++FNmnETMBF+Kk3dlcX89821rjTUVw/j0z0icTs7x5Yb7fzUwOzdOTFFsJJ2u44Mt65F8tMyxM1DkT4zMWmpXaZ3w+RO3Qkq6Wdi8BCsuRumfGrTymGFRdcmqNZ0k/yrT35M5NEgfa8VW7lLjPUxWsI9IyiloumZS6/TpXd07CpxDGfU0w96FkGwkdJZioTdzUUMcBw86eEM8P1WpJNEPlCScX+Vl3jCRkguEU/jq1t3tXMGyRYjpgygsNhRRKDc4rGjuhUCB89FJNqpwm91EKQi2yEn16MEKogRAHX13q9QsKGFwdD2AiFEWty+c0JgOJno8sUrGc3Ryac8Bi9RfQtWONqPykuxPfesFSTMQncgmOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(52116002)(2906002)(6486002)(8936002)(36756003)(7696005)(38100700002)(38350700002)(8676002)(4326008)(956004)(1076003)(16526019)(26005)(186003)(2616005)(478600001)(316002)(66476007)(66556008)(6666004)(86362001)(66946007)(44832011)(83380400001)(5660300002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YJTSfz/2GLqF6+xiki8vLu37DsuerzHz3iA0Ynu2fhB32oECcsHL6mh+AAlT?=
 =?us-ascii?Q?wMqHWbjEA/oBLWc/gOltlmk10ZlGPQvkwttmT+MGg9E85fB6eAlY+PC1LhbC?=
 =?us-ascii?Q?CC8QO4dU4beZY4M+DzdPU/5mZgkl8GWAk5X3KV9S/CdTSz/gk2GXA2J4LO3p?=
 =?us-ascii?Q?cFYpi/BMgktEEDBo7fhSx+FgmFOxdPkiRgdbHTQJtsuTL/s2dq+YuGnSrL6w?=
 =?us-ascii?Q?+tlqSRT/WhAH157ZDHZUW60+/7Z+h4s+mWi74skstIi0v3iLFkKLDWTOrOOn?=
 =?us-ascii?Q?PLdrcjZLDrUK/UXniE0A1xCD1hAQ0XPN4RJGrMQybQJInZifR2z7V61jXw9I?=
 =?us-ascii?Q?z5yyHeKNk3uz/E+/oWa9qR68nmhz0h5NvKrG7Xsn0NgEtjkpjwulcGiLAIiu?=
 =?us-ascii?Q?7szXw6hdGUuqUILvJrHRjxtnC3cj0v+Vx00zwsjrXAjLgO72KRJeIXV17pBN?=
 =?us-ascii?Q?9XD4EEN1i+cY8HgMbS6xWGW85S3G8KmQMDxxOXqVtzj7PK78sEtE3pJVLnoY?=
 =?us-ascii?Q?7zSYgCoNCm9ylioXbGwpMV6Vd978lEx7lN1YJ1HVwOuPyf1ZJL4W+ZipVs9T?=
 =?us-ascii?Q?M+HcLEYVAHcsG0DP4NxLq4AJ9/C2+NjNutEi3kJAYhUZDNdDYzOEnaXHzIzm?=
 =?us-ascii?Q?lU5k+d2DviOH+GOuXNQ0jYtqhbmqEwXMT3sm5ruhutuQLxQI1QZjc980zUWL?=
 =?us-ascii?Q?1WqbtlWFUb8093NxaB6iUMpX6kPe7zlydJKT+8rp11h4Ep9kQ5I18E7VqToN?=
 =?us-ascii?Q?xGGrZ2PfYRLXWePC4qI1JnPEIkD8YQ61dN5P3dv+dRK+d5uNo2MiLXeceath?=
 =?us-ascii?Q?foWcQwGYYV1nLzKMD9Sv40Ci1OJ+q2SEQnP2IMmx+MrmYkFiQkHpVYhzDI25?=
 =?us-ascii?Q?woE44Dqxsb+OvCezXVHMBHC0vryTrAKhOPjFdc5I53Lg63CaI6UAHW9+R/E1?=
 =?us-ascii?Q?y4f6hENVzUmc20BCli76Tm9LKaE5WcN+weQHnYy2jqk3anBxthgjytN5sVJu?=
 =?us-ascii?Q?W2gy9AL190h8x1Rn8O7iLS0Mcj8r9M9elzyi0OE9FWuBRpaJHiIqaeNHrXXF?=
 =?us-ascii?Q?Jz2tRazbuzzAUTsyFIMclGsHkDvtBvoK6iVfsQDkZvov41GBzSvSpbag5Zya?=
 =?us-ascii?Q?Rrq5xKxCCDJwiu6JThq+MA4RL4miY8F0QoiywkvuVyD+7ChPhpJeb8WxXsU7?=
 =?us-ascii?Q?V447vl7bi1+xFItDGlEqFPOUQhFXugo6ddMSAzooC8Pq2aUIvy/G5cXGRmoV?=
 =?us-ascii?Q?IoP8LcRp++QsvhjsZoVf0Cxg+eiuzBsLNJoFgQUL6hQhXH9yr0s2wZ1+pq6/?=
 =?us-ascii?Q?7KVZkYEPhPV7XuoidV0kE6O1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2871aaa-d26e-44e1-3fa9-08d92b77d40c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 18:53:11.0499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: siv/rkmnMUQCt88zOwnR8c7vB6FHc7QlmfvgUizC3K/ttFuHNopnxaddd9Urf9jWsFyNu/tXqpnbqbJqZKSP9c/TnCOfyN4xMUHLD/x3P34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090096
X-Proofpoint-ORIG-GUID: JP4EN3oFXRl8ST_icd1XdL6t4b3URIFX
X-Proofpoint-GUID: JP4EN3oFXRl8ST_icd1XdL6t4b3URIFX
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the 'nested_run' statistic counts all guest-entry attempts,
including those that fail during vmentry checks on Intel and during
consistency checks on AMD. Convert this statistic to count only those
guest-entries that make it past these state checks and make it to guest
code. This will tell us the number of guest-entries that actually executed
or tried to execute guest code.

Also, rename this statistic to 'nested_runs' since it is a count.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/nested.c       |  2 --
 arch/x86/kvm/svm/svm.c          |  6 ++++++
 arch/x86/kvm/vmx/nested.c       |  2 --
 arch/x86/kvm/vmx/vmx.c          | 13 ++++++++++++-
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..cf8557b2b90f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1170,7 +1170,7 @@ struct kvm_vcpu_stat {
 	u64 req_event;
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
-	u64 nested_run;
+	u64 nested_runs;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
 };
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e8d8443154e..34fc74b0d58a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -596,8 +596,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
-	++vcpu->stat.nested_run;
-
 	if (is_smm(vcpu)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4dd9b7856e5b..31646b5c4877 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3872,6 +3872,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->next_rip = 0;
 	if (is_guest_mode(vcpu)) {
 		nested_sync_control_from_vmcb02(svm);
+
+		/* Track VMRUNs that have made past consistency checking */
+		if (svm->nested.nested_run_pending &&
+		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
+                        ++vcpu->stat.nested_runs;
+
 		svm->nested.nested_run_pending = 0;
 	}
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..94f70c0af4a4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3454,8 +3454,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
 	enum nested_evmptrld_status evmptrld_status;
 
-	++vcpu->stat.nested_run;
-
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f2fd447eed45..fa8df7ab2756 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6839,7 +6839,18 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_host_xsave_state(vcpu);
 
-	vmx->nested.nested_run_pending = 0;
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * Track VMLAUNCH/VMRESUME that have made past guest state
+		 * checking.
+		 */
+		if (vmx->nested.nested_run_pending &&
+		    !vmx->exit_reason.failed_vmentry)
+			++vcpu->stat.nested_runs;
+
+		vmx->nested.nested_run_pending = 0;
+	}
+
 	vmx->idt_vectoring_info = 0;
 
 	if (unlikely(vmx->fail)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bd550eaf683..6d1f51f6c344 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -243,7 +243,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("l1d_flush", l1d_flush),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
-	VCPU_STAT("nested_run", nested_run),
+	VCPU_STAT("nested_runs", nested_runs),
 	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
 	VCPU_STAT("directed_yield_successful", directed_yield_successful),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
-- 
2.27.0


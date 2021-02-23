Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9473231E8
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 21:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhBWULu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:11:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhBWUKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 15:10:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK4xJk023448;
        Tue, 23 Feb 2021 20:08:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Zu8rfJyHRcTfVFgb/PRcCVioUNaAej5CPTn06OpwxaI=;
 b=ANYPDjznlJLRPt86883JwK154JQHPr4pQmUSP2/+mDP2AZbHRR9uswpMFlX3FUW4070U
 PJgFM44CkIVWK3RalIoPaeicnxAYgDRyI0UT3zRfCOkdSEKbX+cewLaxMOg/MBjEs3ZI
 FKrCR0PYGUMj/kWndtk9BdLot1Nx+n0hBTcBhk8re21bH1IjlUXbEFZPsZS2hk7tfU4H
 CuolpUtZom8UgBcHtD4nQSkgauyBueLsyE/uyyhurQO0T4C2NNIwUrw6AzpelYlXyldC
 6eBXJ4WQfpg31F1b5ObLGPrttcfnVQK1v1GiyVg4seihJNf2kT94eBwMB5c2TB758u5h 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36ugq3fjet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK6Vd8106920;
        Tue, 23 Feb 2021 20:08:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 36ucbxyc3h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgjtjiZo7w+ij7pFJ//t9ZHTsWDjaHtc/2TPrRz5evSIGfRO8bmfS1Hnt4pGxW4EWLJ65BF9DbhMFs80thDQWwR0KMwBl+a9LF1CT6q1TDUak1MY2RBpYbLKwJnDuVbg74BgBCDr/sKX614RUMOtHWYCaNQRjiLX6XGPGp562/c0mXS50XuvPoSto6dw+O/NicUHOYR2tTIaP3CPsdpao2faHQtNsAdmyOVfVPDJIyfjMcMGNKNRTWByiMehq4RuNQK10Hwx6hGg4npG0iA75MNIkw1XC+A9K52BJlp7QAubXRXRQ8NV3Km7vDid8KiqL5EW7bT7M5lXok0LGQVJ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zu8rfJyHRcTfVFgb/PRcCVioUNaAej5CPTn06OpwxaI=;
 b=ZFeZscCqPFdTWB8cfFJhIaDm2TlAyToJoPEr5B97nEhurY13mB8GwpWjdYgHoV1VefwYSBcs/eOOSLpUx0bfmGd3K3FJOvOazB0qpIRWe4uv78rZJScsSFFqWZoAHrWw4PnzB3Xv4FLhA2vuX+9Ef2fLYBnxVzqouo4uxYlNh4OA/7w/mYT3y5iO0/tGFJH4HdBRoFb3WOx4f3UdFiT6HoeEiLqWTJZDNz5vDuoYaa90Pk6TwNOe9SqzmLEVZtN85WiYKny3m4qJSINL79Gw2fTbJfQAstsMGN2JsoVoV/c2VnHCAPk4BwaUOIwnY9VmFD81PGSvv77vsybt6bNyQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zu8rfJyHRcTfVFgb/PRcCVioUNaAej5CPTn06OpwxaI=;
 b=ziyYwZpEU+OkqrWTt+fNkCxy3S3k9JFWeKhci1bZPIxLidjh5d91jfCtRI92fAjBmpqJDt5mJBd8JvZ8q80nqbgq7hqoB6nrOyXvJzbhI3P1BLNnMuwf0hvqD0hamq0c/E98pAVL9RZB1NhRBJ8NehEz4psOqpLA5YcwG1Oy59c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 20:08:15 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:08:15 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/4 v3] KVM: nSVM: Do not advance RIP following VMRUN completion if the latter is single-stepped
Date:   Tue, 23 Feb 2021 14:19:55 -0500
Message-Id: <20210223191958.24218-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
References: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by BY3PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:254::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Tue, 23 Feb 2021 20:08:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db3ffe92-c370-4361-616c-08d8d836c106
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:
X-Microsoft-Antispam-PRVS: <SN6PR10MB30222E30669C7853B388C24F81809@SN6PR10MB3022.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A64eL3FuqI/pllC4pzUmuPnmuv5wW39/DtDeeWv04byg6UxALVmPqCf6noSuslpzgC7G10x38vjq7dGuAOHDnkkwUmBd2DpaeqjhqdBOB40rEgQ+TqzqMa53zIvGnn/sLCJ9Acf+Pc0GfGEwK6liFznxjAWF5UDA03T+Sw1AcEecxMUWlbJXkTbojcjE/S4BDa0lyha971JlPQ/fCPUCP8QBDRSzr3gUuVrx0EZc6N4KsrHyRtotZRtG2OzaE/H1yJvJL6wPzOj0WNWBhwAn10doNx0fQFBjZsCevNHFhujAqDCH4wSuMesgewy9hhFViX3y4SNHHkAnfU7o1mFMgtUYyH7NiPcyQ6HYeZ+/lYByhiFQ2Q5uu87T5snre5BGH0AvyGjnGl6IMTvSeEcCGra8cie/r6VqKeDQGoTVgtWgi/eSmthDMYtybXgfxlKL1uX9MdQadi2Bbx4LpIO9futYU0rL4dlULQ6OJqF8j9jztV1PdMw/zU1dCcI0REv+In9Gd9uFFj6ZQJDeiRwvEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(376002)(136003)(66946007)(26005)(86362001)(7696005)(66476007)(66556008)(52116002)(1076003)(186003)(44832011)(16526019)(36756003)(6666004)(316002)(956004)(2616005)(6916009)(5660300002)(6486002)(4326008)(83380400001)(2906002)(478600001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gV8XunApVChU+Vezzb5bPLR/zsu+Ekb19/BVSqLAU3goX1mtPAhi0JMK9rdg?=
 =?us-ascii?Q?cg2WjXdXa3K5rnriqGNib+HkeJTUL+XW8FOlXrEhls1y65370Y9US0JjxVkc?=
 =?us-ascii?Q?w7VcbZhGW4H+r/gdZOLXz+nkEQOpQy5CXsk24sQgGJCcU2yeOzlvOlx22HQO?=
 =?us-ascii?Q?sLkpmER1EVjJx1ehCzWX8gILrsBH8c/O2wy+jYRvY+GXgx0AQwPkP+0lGEL5?=
 =?us-ascii?Q?fdkYgxxGm9PDC46xMUke+7nDQ441wdGzjykMpN9k1jCDppMd04WTFC1Ojniu?=
 =?us-ascii?Q?j15zmQWleJQLj/OPdxa31AjK8hNIVfBdJOXAGPn27520zxQud0detEt6pN1o?=
 =?us-ascii?Q?Y/4r3kCOhj/RHf+TUItMBdFk0PWO1sTsayBspD6bUAOtoQfW4X8VtAmZbbv3?=
 =?us-ascii?Q?ID0RBToqolW6fawIQhmE6HNxql4TpyjuDN9amZw5ODOiq70A91iSFAIdKKiC?=
 =?us-ascii?Q?zdWWV+j+441ozbFk6hbedEMK1NiNKkN6Oih/8+6NECfMAzsq9xEUN97wgQF8?=
 =?us-ascii?Q?R71+TlaljmFYAPgR5OTQ2fTurauePdWKTmKd543N1iYe4gWfxoeL1CW/wVTC?=
 =?us-ascii?Q?eBA/R2sY/J3SsAzq9EkW0RiJj8CVdg7sJToO1A+yHrIY6zJZGihIXM0/mWcH?=
 =?us-ascii?Q?+vOdpHxMEt/0sJZSo47EV6AdJ3S+f+FEB6nZjC+O2tcud4nYRBDP/kgv/CX9?=
 =?us-ascii?Q?9ETosXg3IiX+G1bNwYERNiYJvrLJga2wT7zaoUP1Ac4DEpuAmkGzRSFRCxxO?=
 =?us-ascii?Q?2MpkyF1mrPGO/XVIQNSp0xZVg2CTo+voBgvwxp+8e0xZhEfaOqHs+8DZgTh9?=
 =?us-ascii?Q?KCkNzSxaPFhv2UDLAqyNw/Jq7gwOhXU17a+vkGCCtzcEsjvzK24LmiGFbUtd?=
 =?us-ascii?Q?M6e05boxWOmJaxpXW7VBiUOewhnkC/BZwWz59ZpmTuzyJVND0IonmjTCCLsu?=
 =?us-ascii?Q?/p017PVBhW+3Ew4DFAHjbsAiCYU89pfdiaiLmT/uFJ+wWAej8RZJoyAddz8j?=
 =?us-ascii?Q?BocnQO9PeR4y88YEoAkk46Woq+2QDgySKyXlyItZWEk1kp5cXyAplccxS7m5?=
 =?us-ascii?Q?duC4iObjco/YGtIhFRz4G/UnEM1cRCHa+4XD7cW8VsiPRYVuqHKJtHNllUTo?=
 =?us-ascii?Q?UH65dmi9WJQtctFTI/m0kLjj9GwOdmZBALAUmTb6cn29iPl2l5pZndrLM0sU?=
 =?us-ascii?Q?EwyNf74jZ/IS4GjM+reuLCO83S3+uPH4wbMdHn2JVqj7m9q0w6sgPI6wn0pX?=
 =?us-ascii?Q?suBcOrNS/yF/UqNry/7ozu5l3D5t89d46e28GATE2VghgeUbNZn5/wj7B2gP?=
 =?us-ascii?Q?EEW8Vz/d+dkg+Vc7GZZKuwKC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3ffe92-c370-4361-616c-08d8d836c106
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:08:15.3528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ysVrlQm7yeTPbQmTQGWdGLVL2+mPp2q7hT2YmD800NG+BbRYy8eOy/YPc3J1wXvNa3Qwo2t+rlGQfBQjpHadC/3YvT/xhKNs0KglEZU66s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=846 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, svm_vcpu_run() advances the RIP following VMRUN completion when
control returns to host. This works fine if there is no trap flag set
on the VMRUN instruction i.e., if VMRUN is not single-stepped. But if
VMRUN is single-stepped, this advancement of the RIP leads to an incorrect
RIP in the #DB handler invoked for the single-step trap. Therefore, check
if the VMRUN instruction is single-stepped and if so, do not advance the RIP
when the #DB intercept #VMEXIT happens.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
---
 arch/x86/kvm/svm/svm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3442d44ca53b..427d32213f51 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3740,6 +3740,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	instrumentation_end();
 }
 
+static bool single_step_vmrun = false;
+
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3800,6 +3802,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm_vcpu_enter_exit(vcpu, svm);
 
+	if (svm->vmcb->control.exit_code == SVM_EXIT_VMRUN &&
+	    (svm->vmcb->save.rflags & X86_EFLAGS_TF))
+                single_step_vmrun = true;
+
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
@@ -3827,7 +3833,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;
 		vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
 		vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
-		vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
+		if (single_step_vmrun && svm->vmcb->control.exit_code ==
+		    SVM_EXIT_EXCP_BASE + DB_VECTOR)
+			single_step_vmrun = false;
+		else
+			vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 	}
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35ADE362D55
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 05:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbhDQDjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 23:39:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbhDQDjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 23:39:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13H3VWc8001207;
        Sat, 17 Apr 2021 03:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=zWwO9PuoFih3JCbvBiYRVa7Al5PeZNWYhw0+o0jbAzI=;
 b=YQLCt0QvAUPFlIvGSpNoPbPTJyOUnol7L3p52I+P2Jke0bMMQrjBG2sgIchBDC4Qz8oc
 rMw3w3qo5l0PtucHKC3trb33qTTX5MllNwty4M7glPFLG7XK2Rv7N4dgJh1Olj2qH5WP
 r/NrqkNjagald/4xQYMy1YUii2uOiykdTBHc7zXd8ZVXNnyds4cbtiEt65z9DMITFY/o
 0JooIKzZ+iDtipx4jIhobq4AvRfwamIjKegfGJDgK42kOvYjw7wtrydGpGV7bKV+IRSH
 66yxHdW1pT2ISQyqWxKlAmHEuXWNFqgAp8aSOZqGwyzxjLRv0W0L5ND+zp8unQCF/nFE PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nntn11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 03:38:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13H3PgKW190340;
        Sat, 17 Apr 2021 03:38:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3020.oracle.com with ESMTP id 37yq0jsak2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 03:38:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po7lIUS6W1Y3s+oTPF6ZcyPCxDLjQkxf6nNkBXlyngTS1EeiySIWfoEzo+SpME7r6Az8cYO1IcxG6zzek32CK2aJLaLgWBqpJ0pfVLf6TKqMFxfJTHO7MVxYoo4ihgctIcMkanHXYJJeO1kiYuxF85grDj/DDrNyi6P9zuqUx0sEJIC6+q8ssz02Tf6feSWfwN6MeFoWSx7RZ83coTd0XwaV0o2A1U/Miq1XOya/sbGkPgD4Cm+Kh4zlsm0/B5uqr/IV64QeJFfqBLIbJJsxe8OZEfJrWuzFFbmje7YveHtDb4owvjx3WBoH0WBCWCqhmR47JGHlJYA5A9y1L5nxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWwO9PuoFih3JCbvBiYRVa7Al5PeZNWYhw0+o0jbAzI=;
 b=HDjmc4k8/J2/91ESf1vqB88NG3fW7TTD7Vneox27v+TjlgwV3xSilzk3uOBLibp+apdHFwtqJ9MKCnmJPoZRl+azZ5jrW1d9WQ05jmfplhloHTbWOcWuBK1corz1uOeGV6gTiZrU2lH4lYOgtD0j9WBOml62UZuWt7oRQDInb2/6kbUWRwDSAPQWbi/Es20R/GO1aeOlmqAbY9CgHjLbTwwi+3G9l0QLKQrjNUA1vjVqM4ax7yx/ko+AYQsPx+BXE/ghaSKfkCwxUMk9BsGFMZXCXgU2TYcTWohV5olS8OBE2XEfSJaRl6/gSD3lYa0ZwZrGlxMTuVoTkbzmiOB/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWwO9PuoFih3JCbvBiYRVa7Al5PeZNWYhw0+o0jbAzI=;
 b=nq4+YdTQ5Kz5JuITuRdeI8hn41bJvy1uxxQZaJcQyAk/Fc5yOKQ1lMjy2+BvdNXy1naQyHvfMLllvhOE+Aw0Gq/wCTAEWGbN819JekG33yQqSs0DzDNRj9PSzUA0B1Nz3BFQfb6s9c/NYbQkE8wvw+2eGW8ebhkc7jwbbqdsnhY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Sat, 17 Apr
 2021 03:38:47 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4042.018; Sat, 17 Apr 2021
 03:38:47 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH] KVM: nSVM: Cleanup in arch/x86/kvm/svm/nested.c
Date:   Fri, 16 Apr 2021 22:49:55 -0400
Message-Id: <20210417024955.16465-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210417024955.16465-1-krish.sadhukhan@oracle.com>
References: <20210417024955.16465-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:74::21) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:74::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Sat, 17 Apr 2021 03:38:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c1f9409-13ab-4692-cfb4-08d901524f02
X-MS-TrafficTypeDiagnostic: SA2PR10MB4665:
X-Microsoft-Antispam-PRVS: <SA2PR10MB466531EB31DCE804B1467FFC814B9@SA2PR10MB4665.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jUzJwV4CRE64+UxeD1Nu/yoZZkQgIAfAZKWe7pWu+pi2mzXPjQU8XH91SkZVXABCyCKEhOhwtxRpVgJqx8vUpc/k1cTpP8CAWz0rmasRoZotIzmkKTn8vifHirxurTh1L6PVzMExwkCyRDW9cn5shUHv6h96ZJonTiVG5Cw0GWjKgcFX2JAqwrAkp8ArDV4Yfjy+df6Puo6IGFaJfFxpyTkaPb7yfY1jWG2LgI6RzuPUERx5j6gwht9c/Uv14zECHj/gs6QfiYftulpk61riwIvRpkJUzA59QC9ONeUqchHs3ZrefvWG6qmSyWQ26D7MbjiGdx+tWU2lBs8gYRwHIejpJsP5BDA/K8xNwYEw0Kb02hAohqzfO/Kq/Vqw7Hm2ZJ4c01DOlLfFpmAHUxtYjczraXyXp8ScAa1y8aEL4Tv9IOCnsnjkIIgtj3AoeNH6Q5RB6drgocEG8sJMkPVGBmwAUdbMt0+piwHpNKrqOkwLtnQTkVlT/355VS0IMly76tOAjelQ6J6+3LjWPDja2ZTpt+khHr34JL9PgFUSLWUgYLZXLdN9gmFjyRLvOyAQODj/LqNOZvqimHPq0XcbCz9fnsHqQKC/R58pBeS7SjDkE47rDKd7hntQUXKZR+PFRHc9yFcPWlwo+u32F9O0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(346002)(136003)(30864003)(66556008)(6486002)(956004)(83380400001)(6916009)(8676002)(2906002)(2616005)(316002)(5660300002)(478600001)(66946007)(66476007)(86362001)(44832011)(8936002)(6666004)(38100700002)(4326008)(7696005)(1076003)(52116002)(26005)(38350700002)(36756003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HE4agCRANK8NcIMfc+6y5xGD4Kijyr5KzqvgCDOQRBBd0sMzJxdUIbrtT/8d?=
 =?us-ascii?Q?P5N1gPb251iGiL47O007i6anYt0E/rpbHxN4mSvzM5vYh9YI7YLjza0Mqpcg?=
 =?us-ascii?Q?/N7AHy7X9rXRNP/JRwL4XTT8gIOKE3UMLNDOQVSgKPWfQGkvBO8QxxiGS/3r?=
 =?us-ascii?Q?ArDV2APdSd/lPG3JT/8NqouKktnN6pORo/9Skgs0pijwdq3h4coF1hD81/Sl?=
 =?us-ascii?Q?BTeaEDL1YBXuwl3FPWdlePwGWrqKeqDOUhTYHo1jAr0EDd+gJbO/ALC2cBhO?=
 =?us-ascii?Q?lQ+MESvvzA68SWV/vL3skxChBAaPL+3EFbuQTqCOERwgJ97QzYSBOafHwGk6?=
 =?us-ascii?Q?y4vaFzFytEH9aYfLvuQHQWEhWBx+Nps3jUVNjPdM/t7pXJE/ZUa0BKj9i+xW?=
 =?us-ascii?Q?JB+aFxuIduQAvJWsak/bNWkqGb4l+CdAkh3MMwCglI9LZm0oFsP8UaYcb5m+?=
 =?us-ascii?Q?u9dN3obzlWZLdCNUf5JUBMzQNo7KXJoBJCmkKVyPcTQhxTfacY2RK54j43+F?=
 =?us-ascii?Q?r5g25NVbp5dRYfQw3rHSYLxyNS1VcXO0LaiyZNWmQaG+Ac2eoXeQu9O2DuE5?=
 =?us-ascii?Q?0HNabRoHMoR9e309G3zzGl22bWskUBckqdWUttoHD0a5wikNYhytQX4ZWguX?=
 =?us-ascii?Q?4bVDVE8BKosiPYj6cHLFB5yDDh3hzxvB79fCZYgNzhJBOKlJfaDcmd/5rGn/?=
 =?us-ascii?Q?R2bDhczMGxzAfx17XxFWaEFe6DL/RiBisMLhUvXkT/L4wHK5v8fZUCTz6uqA?=
 =?us-ascii?Q?KNYRItEuZSpJ+50xXRMzdtWLC/3goqgFA92z+nYwOCHnxJmL2H3MrWM3a1E4?=
 =?us-ascii?Q?XbYY1gNKwtVB/SNU+oeIQhDfGrcEYDLK3dKDTlYJMNQUjVeju+bYyH8DpZJz?=
 =?us-ascii?Q?34hay96hxYziAra7xOb90XMNe+FFsrUtXjkFpifsQ8wFhzZFeXhCV4YKF3VN?=
 =?us-ascii?Q?wO6c3cGxOt3rW57th8BCVbP5oPuGte7JryszyQDUB6mfs7hcK9lHrsqugE7L?=
 =?us-ascii?Q?qy+TvhuZSZRMSXzk1g8AXtwJjRmUhvikW3HvALhwuMt8+12RexxDW+5Eudeh?=
 =?us-ascii?Q?tFa1uTIJFi4Ptdxb4ssidduK8bWIYsXGgw3c8pd1iEZlA/ubh1TvffUqYZCY?=
 =?us-ascii?Q?dRK/pldRomR5iCLnCgfQys6D//J5r9aHi8JoByTIXWWwwLt9XNttbeoVot0E?=
 =?us-ascii?Q?3z2D1cbm+hq6eHp7H+GUtnRiRCjM+9vBfSZS3TSm7treFpTuL1Spg+6DweT+?=
 =?us-ascii?Q?kOjr4ZhsLqtPPtUVbri114Sgex24QviyemJZo109DFw1hc/+azvLkw/XB4ss?=
 =?us-ascii?Q?ahqiulodtZMIOJ+jQ6/2ynYc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c1f9409-13ab-4692-cfb4-08d901524f02
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2021 03:38:47.8143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JFvtQZK4R0Ez3oETWw6hcP2mvfAvIM3HZJj9RIFDsfIFHE3ehW9okTV7eE6ywFL9PSA4gyj0/XqqxaYM5XiX30ry6WfmwnpcSGwgJ2qUXSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170022
X-Proofpoint-ORIG-GUID: Y9TAInCkwGAzNs3DsJ3SkEPpHjBE-Tah
X-Proofpoint-GUID: Y9TAInCkwGAzNs3DsJ3SkEPpHjBE-Tah
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170022
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use local variables to derefence svm->vcpu, svm->vmcb and svm->vmcb01.ptr
to make the code tidier.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 267 ++++++++++++++++++++------------------
 1 file changed, 141 insertions(+), 126 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8453c898b68b..ddbae0807332 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -35,20 +35,21 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 				       struct x86_exception *fault)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
 
 	if (svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
 		/*
 		 * TODO: track the cause of the nested page fault, and
 		 * correctly fill in the high bits of exit_info_1.
 		 */
-		svm->vmcb->control.exit_code = SVM_EXIT_NPF;
-		svm->vmcb->control.exit_code_hi = 0;
-		svm->vmcb->control.exit_info_1 = (1ULL << 32);
-		svm->vmcb->control.exit_info_2 = fault->address;
+		vmcb->control.exit_code = SVM_EXIT_NPF;
+		vmcb->control.exit_code_hi = 0;
+		vmcb->control.exit_info_1 = (1ULL << 32);
+		vmcb->control.exit_info_2 = fault->address;
 	}
 
-	svm->vmcb->control.exit_info_1 &= ~0xffffffffULL;
-	svm->vmcb->control.exit_info_1 |= fault->error_code;
+	vmcb->control.exit_info_1 &= ~0xffffffffULL;
+	vmcb->control.exit_info_1 |= fault->error_code;
 
 	nested_svm_vmexit(svm);
 }
@@ -56,14 +57,15 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
+       struct vmcb *vmcb = svm->vmcb;
        WARN_ON(!is_guest_mode(vcpu));
 
        if (vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
 	   !svm->nested.nested_run_pending) {
-               svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
-               svm->vmcb->control.exit_code_hi = 0;
-               svm->vmcb->control.exit_info_1 = fault->error_code;
-               svm->vmcb->control.exit_info_2 = fault->address;
+               vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
+               vmcb->control.exit_code_hi = 0;
+               vmcb->control.exit_info_1 = fault->error_code;
+               vmcb->control.exit_info_2 = fault->address;
                nested_svm_vmexit(svm);
        } else {
                kvm_inject_page_fault(vcpu, fault);
@@ -298,8 +300,9 @@ static void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 {
 	u32 mask;
-	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
-	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
+	struct vmcb *vmcb = svm->vmcb;
+	svm->nested.ctl.event_inj      = vmcb->control.event_inj;
+	svm->nested.ctl.event_inj_err  = vmcb->control.event_inj_err;
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
@@ -316,7 +319,7 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 		mask &= ~V_IRQ_MASK;
 	}
 	svm->nested.ctl.int_ctl        &= ~mask;
-	svm->nested.ctl.int_ctl        |= svm->vmcb->control.int_ctl & mask;
+	svm->nested.ctl.int_ctl        |= vmcb->control.int_ctl & mask;
 }
 
 /*
@@ -404,6 +407,8 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vmcb *vmcb = svm->vmcb;
 
 	nested_vmcb02_compute_g_pat(svm);
 
@@ -415,53 +420,55 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
-		svm->vmcb->save.es = vmcb12->save.es;
-		svm->vmcb->save.cs = vmcb12->save.cs;
-		svm->vmcb->save.ss = vmcb12->save.ss;
-		svm->vmcb->save.ds = vmcb12->save.ds;
-		svm->vmcb->save.cpl = vmcb12->save.cpl;
-		vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
+		vmcb->save.es = vmcb12->save.es;
+		vmcb->save.cs = vmcb12->save.cs;
+		vmcb->save.ss = vmcb12->save.ss;
+		vmcb->save.ds = vmcb12->save.ds;
+		vmcb->save.cpl = vmcb12->save.cpl;
+		vmcb_mark_dirty(vmcb, VMCB_SEG);
 	}
 
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DT))) {
-		svm->vmcb->save.gdtr = vmcb12->save.gdtr;
-		svm->vmcb->save.idtr = vmcb12->save.idtr;
-		vmcb_mark_dirty(svm->vmcb, VMCB_DT);
+		vmcb->save.gdtr = vmcb12->save.gdtr;
+		vmcb->save.idtr = vmcb12->save.idtr;
+		vmcb_mark_dirty(vmcb, VMCB_DT);
 	}
 
-	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
+	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
 	/*
 	 * Force-set EFER_SVME even though it is checked earlier on the
 	 * VMCB12, because the guest can flip the bit between the check
 	 * and now.  Clearing EFER_SVME would call svm_free_nested.
 	 */
-	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
+	svm_set_efer(vcpu, vmcb12->save.efer | EFER_SVME);
 
-	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
-	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
+	svm_set_cr0(vcpu, vmcb12->save.cr0);
+	svm_set_cr4(vcpu, vmcb12->save.cr4);
 
-	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
+	vcpu->arch.cr2 = vmcb12->save.cr2;
 
-	kvm_rax_write(&svm->vcpu, vmcb12->save.rax);
-	kvm_rsp_write(&svm->vcpu, vmcb12->save.rsp);
-	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
+	kvm_rax_write(vcpu, vmcb12->save.rax);
+	kvm_rsp_write(vcpu, vmcb12->save.rsp);
+	kvm_rip_write(vcpu, vmcb12->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
-	svm->vmcb->save.rax = vmcb12->save.rax;
-	svm->vmcb->save.rsp = vmcb12->save.rsp;
-	svm->vmcb->save.rip = vmcb12->save.rip;
+	vmcb->save.rax = vmcb12->save.rax;
+	vmcb->save.rsp = vmcb12->save.rsp;
+	vmcb->save.rip = vmcb12->save.rip;
 
 	/* These bits will be set properly on the first execution when new_vmc12 is true */
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
-		svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
-		svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
-		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
+		vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
+		vcpu->arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
+		vmcb_mark_dirty(vmcb, VMCB_DR);
 	}
 }
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
+	struct vmcb *vmcb = svm->vmcb;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
 
 	/*
@@ -476,37 +483,37 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	WARN_ON(svm->vmcb01.ptr->control.int_ctl & AVIC_ENABLE_MASK);
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	svm->vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
-	svm->vmcb->control.iopm_base_pa = svm->vmcb01.ptr->control.iopm_base_pa;
-	svm->vmcb->control.msrpm_base_pa = svm->vmcb01.ptr->control.msrpm_base_pa;
+	vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
+	vmcb->control.iopm_base_pa = svm->vmcb01.ptr->control.iopm_base_pa;
+	vmcb->control.msrpm_base_pa = svm->vmcb01.ptr->control.msrpm_base_pa;
 
 	/* Done at vmrun: asid.  */
 
 	/* Also overwritten later if necessary.  */
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 
 	/* nested_cr3.  */
 	if (nested_npt_enabled(svm))
-		nested_svm_init_mmu_context(&svm->vcpu);
+		nested_svm_init_mmu_context(vcpu);
 
-	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
-		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
+	vmcb->control.tsc_offset = vcpu->arch.tsc_offset =
+		vcpu->arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
 
-	svm->vmcb->control.int_ctl             =
+	vmcb->control.int_ctl             =
 		(svm->nested.ctl.int_ctl & ~mask) |
 		(svm->vmcb01.ptr->control.int_ctl & mask);
 
-	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
-	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
-	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
-	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
-	svm->vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
+	vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
+	vmcb->control.int_vector          = svm->nested.ctl.int_vector;
+	vmcb->control.int_state           = svm->nested.ctl.int_state;
+	vmcb->control.event_inj           = svm->nested.ctl.event_inj;
+	vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
-	svm->vmcb->control.pause_filter_count  = svm->nested.ctl.pause_filter_count;
-	svm->vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
+	vmcb->control.pause_filter_count  = svm->nested.ctl.pause_filter_count;
+	vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;
 
 	/* Enter Guest-Mode */
-	enter_guest_mode(&svm->vcpu);
+	enter_guest_mode(vcpu);
 
 	/*
 	 * Merge guest and host intercepts - must be called with vcpu in
@@ -531,9 +538,10 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 			 struct vmcb *vmcb12)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
 	int ret;
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
+	trace_kvm_nested_vmrun(vmcb->save.rip, vmcb12_gpa,
 			       vmcb12->save.rip,
 			       vmcb12->control.int_ctl,
 			       vmcb12->control.event_inj,
@@ -549,7 +557,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	svm->nested.vmcb12_gpa = vmcb12_gpa;
 
-	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
+	WARN_ON(vmcb == svm->nested.vmcb02.ptr);
 
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
@@ -573,8 +581,10 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
 	int ret;
 	struct vmcb *vmcb12;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
@@ -621,11 +631,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
 	 */
-	svm->vmcb01.ptr->save.efer   = vcpu->arch.efer;
-	svm->vmcb01.ptr->save.cr0    = kvm_read_cr0(vcpu);
-	svm->vmcb01.ptr->save.cr4    = vcpu->arch.cr4;
-	svm->vmcb01.ptr->save.rflags = kvm_get_rflags(vcpu);
-	svm->vmcb01.ptr->save.rip    = kvm_rip_read(vcpu);
+	vmcb01->save.efer   = vcpu->arch.efer;
+	vmcb01->save.cr0    = kvm_read_cr0(vcpu);
+	vmcb01->save.cr4    = vcpu->arch.cr4;
+	vmcb01->save.rflags = kvm_get_rflags(vcpu);
+	vmcb01->save.rip    = kvm_rip_read(vcpu);
 
 	if (!npt_enabled)
 		svm->vmcb01.ptr->save.cr3 = kvm_read_cr3(vcpu);
@@ -641,10 +651,10 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 out_exit_err:
 	svm->nested.nested_run_pending = 0;
 
-	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-	svm->vmcb->control.exit_code_hi = 0;
-	svm->vmcb->control.exit_info_1  = 0;
-	svm->vmcb->control.exit_info_2  = 0;
+	vmcb->control.exit_code    = SVM_EXIT_ERR;
+	vmcb->control.exit_code_hi = 0;
+	vmcb->control.exit_info_1  = 0;
+	vmcb->control.exit_info_2  = 0;
 
 	nested_svm_vmexit(svm);
 
@@ -698,7 +708,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
 	/* in case we halted in L2 */
-	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	/* Give the current vmcb to the guest */
 
@@ -708,17 +718,17 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->save.ds     = vmcb->save.ds;
 	vmcb12->save.gdtr   = vmcb->save.gdtr;
 	vmcb12->save.idtr   = vmcb->save.idtr;
-	vmcb12->save.efer   = svm->vcpu.arch.efer;
+	vmcb12->save.efer   = vcpu->arch.efer;
 	vmcb12->save.cr0    = kvm_read_cr0(vcpu);
 	vmcb12->save.cr3    = kvm_read_cr3(vcpu);
 	vmcb12->save.cr2    = vmcb->save.cr2;
-	vmcb12->save.cr4    = svm->vcpu.arch.cr4;
+	vmcb12->save.cr4    = vcpu->arch.cr4;
 	vmcb12->save.rflags = kvm_get_rflags(vcpu);
 	vmcb12->save.rip    = kvm_rip_read(vcpu);
 	vmcb12->save.rsp    = kvm_rsp_read(vcpu);
 	vmcb12->save.rax    = kvm_rax_read(vcpu);
 	vmcb12->save.dr7    = vmcb->save.dr7;
-	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
+	vmcb12->save.dr6    = vcpu->arch.dr6;
 	vmcb12->save.cpl    = vmcb->save.cpl;
 
 	vmcb12->control.int_state         = vmcb->control.int_state;
@@ -739,26 +749,27 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	vmcb12->control.pause_filter_count =
-		svm->vmcb->control.pause_filter_count;
+		vmcb->control.pause_filter_count;
 	vmcb12->control.pause_filter_thresh =
-		svm->vmcb->control.pause_filter_thresh;
+		vmcb->control.pause_filter_thresh;
 
 	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
-	WARN_ON_ONCE(svm->vmcb->control.exit_code != SVM_EXIT_VMRUN);
+	vmcb = svm->vmcb;
+	WARN_ON_ONCE(vmcb->control.exit_code != SVM_EXIT_VMRUN);
 
 	/*
 	 * On vmexit the  GIF is set to false and
 	 * no event can be injected in L1.
 	 */
 	svm_set_gif(svm, false);
-	svm->vmcb->control.exit_int_info = 0;
+	vmcb->control.exit_int_info = 0;
 
-	svm->vcpu.arch.tsc_offset = svm->vcpu.arch.l1_tsc_offset;
-	if (svm->vmcb->control.tsc_offset != svm->vcpu.arch.tsc_offset) {
-		svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
-		vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+	vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
+	if (vmcb->control.tsc_offset != vcpu->arch.tsc_offset) {
+		vmcb->control.tsc_offset = vcpu->arch.tsc_offset;
+		vmcb_mark_dirty(vmcb, VMCB_INTERCEPTS);
 	}
 
 	svm->nested.ctl.nested_cr3 = 0;
@@ -766,16 +777,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/*
 	 * Restore processor state that had been saved in vmcb01
 	 */
-	kvm_set_rflags(vcpu, svm->vmcb->save.rflags);
-	svm_set_efer(vcpu, svm->vmcb->save.efer);
-	svm_set_cr0(vcpu, svm->vmcb->save.cr0 | X86_CR0_PE);
-	svm_set_cr4(vcpu, svm->vmcb->save.cr4);
-	kvm_rax_write(vcpu, svm->vmcb->save.rax);
-	kvm_rsp_write(vcpu, svm->vmcb->save.rsp);
-	kvm_rip_write(vcpu, svm->vmcb->save.rip);
+	kvm_set_rflags(vcpu, vmcb->save.rflags);
+	svm_set_efer(vcpu, vmcb->save.efer);
+	svm_set_cr0(vcpu, vmcb->save.cr0 | X86_CR0_PE);
+	svm_set_cr4(vcpu, vmcb->save.cr4);
+	kvm_rax_write(vcpu, vmcb->save.rax);
+	kvm_rsp_write(vcpu, vmcb->save.rsp);
+	kvm_rip_write(vcpu, vmcb->save.rip);
 
-	svm->vcpu.arch.dr7 = DR7_FIXED_1;
-	kvm_update_dr7(&svm->vcpu);
+	vcpu->arch.dr7 = DR7_FIXED_1;
+	kvm_update_dr7(vcpu);
 
 	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
 				       vmcb12->control.exit_info_1,
@@ -788,7 +799,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false);
+	rc = nested_svm_load_cr3(vcpu, vmcb->save.cr3, false);
 	if (rc)
 		return 1;
 
@@ -796,7 +807,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
 	 * doesn't end up in L1.
 	 */
-	svm->vcpu.arch.nmi_injected = false;
+	vcpu->arch.nmi_injected = false;
 	kvm_clear_exception_queue(vcpu);
 	kvm_clear_interrupt_queue(vcpu);
 
@@ -806,8 +817,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 * right now so that it an be accounted for before we execute
 	 * L1's next instruction.
 	 */
-	if (unlikely(svm->vmcb->save.rflags & X86_EFLAGS_TF))
-		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
+	if (unlikely(vmcb->save.rflags & X86_EFLAGS_TF))
+		kvm_queue_exception(vcpu, DB_VECTOR);
 
 	return 0;
 }
@@ -881,11 +892,12 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 {
 	u32 offset, msr, value;
 	int write, mask;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
 		return NESTED_EXIT_HOST;
 
-	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	msr    = vcpu->arch.regs[VCPU_REGS_RCX];
 	offset = svm_msrpm_offset(msr);
 	write  = svm->vmcb->control.exit_info_1 & 1;
 	mask   = 1 << ((2 * (msr & 0xf)) + write);
@@ -896,7 +908,8 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
 	/* Offset is in 32 bit units but need in 8 bit units */
 	offset *= 4;
 
-	if (kvm_vcpu_read_guest(&svm->vcpu, svm->nested.ctl.msrpm_base_pa + offset, &value, 4))
+	if (kvm_vcpu_read_guest(vcpu, svm->nested.ctl.msrpm_base_pa + offset,
+				&value, 4))
 		return NESTED_EXIT_DONE;
 
 	return (value & mask) ? NESTED_EXIT_DONE : NESTED_EXIT_HOST;
@@ -908,12 +921,13 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
 	u16 val, mask;
 	u8 start_bit;
 	u64 gpa;
+	struct vmcb *vmcb = svm->vmcb;
 
 	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_IOIO_PROT)))
 		return NESTED_EXIT_HOST;
 
-	port = svm->vmcb->control.exit_info_1 >> 16;
-	size = (svm->vmcb->control.exit_info_1 & SVM_IOIO_SIZE_MASK) >>
+	port = vmcb->control.exit_info_1 >> 16;
+	size = (vmcb->control.exit_info_1 & SVM_IOIO_SIZE_MASK) >>
 		SVM_IOIO_SIZE_SHIFT;
 	gpa  = svm->nested.ctl.iopm_base_pa + (port / 8);
 	start_bit = port % 8;
@@ -1007,34 +1021,36 @@ static bool nested_exit_on_exception(struct vcpu_svm *svm)
 
 static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
 {
-	unsigned int nr = svm->vcpu.arch.exception.nr;
+	struct vmcb *vmcb = svm->vmcb;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	unsigned int nr = vcpu->arch.exception.nr;
 
-	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
-	svm->vmcb->control.exit_code_hi = 0;
+	vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
+	vmcb->control.exit_code_hi = 0;
 
-	if (svm->vcpu.arch.exception.has_error_code)
-		svm->vmcb->control.exit_info_1 = svm->vcpu.arch.exception.error_code;
+	if (vcpu->arch.exception.has_error_code)
+		vmcb->control.exit_info_1 = svm->vcpu.arch.exception.error_code;
 
 	/*
 	 * EXITINFO2 is undefined for all exception intercepts other
 	 * than #PF.
 	 */
 	if (nr == PF_VECTOR) {
-		if (svm->vcpu.arch.exception.nested_apf)
-			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.apf.nested_apf_token;
-		else if (svm->vcpu.arch.exception.has_payload)
-			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.exception.payload;
+		if (vcpu->arch.exception.nested_apf)
+			vmcb->control.exit_info_2 = vcpu->arch.apf.nested_apf_token;
+		else if (vcpu->arch.exception.has_payload)
+			vmcb->control.exit_info_2 = vcpu->arch.exception.payload;
 		else
-			svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
+			vmcb->control.exit_info_2 = vcpu->arch.cr2;
 	} else if (nr == DB_VECTOR) {
 		/* See inject_pending_event.  */
-		kvm_deliver_exception_payload(&svm->vcpu);
-		if (svm->vcpu.arch.dr7 & DR7_GD) {
-			svm->vcpu.arch.dr7 &= ~DR7_GD;
-			kvm_update_dr7(&svm->vcpu);
+		kvm_deliver_exception_payload(vcpu);
+		if (vcpu->arch.dr7 & DR7_GD) {
+			vcpu->arch.dr7 &= ~DR7_GD;
+			kvm_update_dr7(vcpu);
 		}
 	} else
-		WARN_ON(svm->vcpu.arch.exception.has_payload);
+		WARN_ON(vcpu->arch.exception.has_payload);
 
 	nested_svm_vmexit(svm);
 }
@@ -1139,7 +1155,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
 {
-	struct vcpu_svm *svm;
+	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_nested_state kvm_state = {
 		.flags = 0,
 		.format = KVM_STATE_NESTED_FORMAT_SVM,
@@ -1151,8 +1167,6 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	if (!vcpu)
 		return kvm_state.size + KVM_STATE_NESTED_SVM_VMCB_SIZE;
 
-	svm = to_svm(vcpu);
-
 	if (user_data_size < kvm_state.size)
 		goto out;
 
@@ -1196,6 +1210,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state *kvm_state)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb __user *user_vmcb = (struct vmcb __user *)
 		&user_kvm_nested_state->data.svm[0];
 	struct vmcb_control_area *ctl;
@@ -1287,21 +1302,21 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (svm->current_vmcb == &svm->vmcb01)
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
 
-	svm->vmcb01.ptr->save.es = save->es;
-	svm->vmcb01.ptr->save.cs = save->cs;
-	svm->vmcb01.ptr->save.ss = save->ss;
-	svm->vmcb01.ptr->save.ds = save->ds;
-	svm->vmcb01.ptr->save.gdtr = save->gdtr;
-	svm->vmcb01.ptr->save.idtr = save->idtr;
-	svm->vmcb01.ptr->save.rflags = save->rflags | X86_EFLAGS_FIXED;
-	svm->vmcb01.ptr->save.efer = save->efer;
-	svm->vmcb01.ptr->save.cr0 = save->cr0;
-	svm->vmcb01.ptr->save.cr3 = save->cr3;
-	svm->vmcb01.ptr->save.cr4 = save->cr4;
-	svm->vmcb01.ptr->save.rax = save->rax;
-	svm->vmcb01.ptr->save.rsp = save->rsp;
-	svm->vmcb01.ptr->save.rip = save->rip;
-	svm->vmcb01.ptr->save.cpl = 0;
+	vmcb01->save.es = save->es;
+	vmcb01->save.cs = save->cs;
+	vmcb01->save.ss = save->ss;
+	vmcb01->save.ds = save->ds;
+	vmcb01->save.gdtr = save->gdtr;
+	vmcb01->save.idtr = save->idtr;
+	vmcb01->save.rflags = save->rflags | X86_EFLAGS_FIXED;
+	vmcb01->save.efer = save->efer;
+	vmcb01->save.cr0 = save->cr0;
+	vmcb01->save.cr3 = save->cr3;
+	vmcb01->save.cr4 = save->cr4;
+	vmcb01->save.rax = save->rax;
+	vmcb01->save.rsp = save->rsp;
+	vmcb01->save.rip = save->rip;
+	vmcb01->save.cpl = 0;
 
 	nested_load_control_from_vmcb12(svm, ctl);
 
@@ -1325,7 +1340,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	if (WARN_ON(!is_guest_mode(vcpu)))
 		return true;
 
-	if (nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
+	if (nested_svm_load_cr3(vcpu, vcpu->arch.cr3,
 				nested_npt_enabled(svm)))
 		return false;
 
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82495352068
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 22:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbhDAUJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 16:09:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33372 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbhDAUJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 16:09:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K9BVF079551;
        Thu, 1 Apr 2021 20:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AneYmxT+wnBjB5ar/m4nkw9mGYrRbG5xb2isd7ju/Ms=;
 b=CtBjcSjqC8sglNb40nhIPB5TIvPzLT0vkZkaERB81tXA92LBl6ybUY+D1gciJGxos9KX
 HSotwTuPgGj4Vrpw8uOZd/FXPcJKgYA5zzFnh3vqks4ciuiTD/tlYZoUI9vdFMFnUGaB
 Zu4ABaL43zmgPeVCsLTUHcEPrdqx2iNWLGE6RYb/brovWeBDegJGy4CvGdMkcu+5wE8q
 G+L2m8r3QqSjGSB8RL52AZRcZ2nTChW3SQKBtaS3t+XCttN5phUrQA1qyFPb1gHLtYNf
 UqhLJNiovx+qp4/mFLnIxnxzZhYckLCd63/rZm9LSFD24cIWXuOl02jN+BHeNxhLIYvk qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37n33du0uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K10Wg178428;
        Thu, 1 Apr 2021 20:09:25 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2056.outbound.protection.outlook.com [104.47.45.56])
        by aserp3020.oracle.com with ESMTP id 37n2abq9ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRQLCudd3dup6MGdT92MTNKFU29crbDQRyouHH+xFeBfflIgm9Zp+h9g2txVZDlyNASjSJtc50OKnn8ieZXTtQJZce6O/31qXBQxvfvA2zcy9Z6sqqsID6nql6QhwOYCsJeW3qjRtoQ0hU+1U0bXiFwVVFNYJV9Ev5PS6oyHdh5/8clRFGM3/f8+9yw0RqAZGAmihX3V1zi6kM/Mggg7oqst/LbK3dEjJ4lU1gntdYs14dthBzbvjxwkbBs/fxThoZ2iYiCS7hMLc/9GSiUzakiCt6wKIRFTUJmg6I8ZfuHgJNsfuI3it6MYHC4QCjMP0KpfeNWCNSy3zIBmdJ1WOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AneYmxT+wnBjB5ar/m4nkw9mGYrRbG5xb2isd7ju/Ms=;
 b=h49jmuhRm+LaY2ZiWOGYAXViascgLm3I8XES/chYLOYrqZ+AxZtPF0aWaV5a6noqkQcrEK8iLGW5quKGoIIHMvt9m8FhJjSV9MmIoY1f9AmFlJdx6GAB02AxaE53cd3zUxLu5I9FOCMs1+LnQYYvBqUVMybi+S89lxNKxAxuwtNZd9Wt8XnEPpkIs+tkPnagww9uDv6wIC2FSd/U52M0rk27KeHNHdgNsxV5BvNdhNLTjhaLgUrE2sRzHoWRnjgSW95CHa7wPIlMPsVoB+U+LZC/ptfOU2zX38M10xARX2KUmDcAbzct/7IudcXZK/lYt0No4DmNhdi6xn/pQGjQyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AneYmxT+wnBjB5ar/m4nkw9mGYrRbG5xb2isd7ju/Ms=;
 b=z3cO+FfmoOMg6AtvJRwXssRHoTTjwLjXqMnh713V4YSHPQxxsiJk9oYu4aOvQhHwoQVldWwscQojizxRNfWtTp11fY+Ce21Oz6VYsdSPosbM7AjAsUyxxLds8v9ODIrwyZRXew+ifXAP2cA2V3FrZXWVS7ZRsyAkGLpNfFTJgYI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM5PR1001MB2091.namprd10.prod.outlook.com (2603:10b6:4:2c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.33; Thu, 1 Apr 2021 20:09:23 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b%3]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 20:09:23 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/5 v5] nSVM: Check addresses of MSR and IO permission maps
Date:   Thu,  1 Apr 2021 15:20:30 -0400
Message-Id: <20210401192033.91150-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
References: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:a03:114::25) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR21CA0015.namprd21.prod.outlook.com (2603:10b6:a03:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.0 via Frontend Transport; Thu, 1 Apr 2021 20:09:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c086f08-a849-4e03-360a-08d8f54a0a88
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2091:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2091C0C294C166D3D09DE349817B9@DM5PR1001MB2091.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZH8RKoCYq4F8NMRU/545hS2DwYyQ7ptV/RkgQkKmMC2y3hIS9QDhMIAEPDzzkfWuOSQ3nxHwPlnXxhy/DhTDFfmSS5UGbL4COp0vk35vkLQf9DW+ORHVBWY0e8QMbjxyRgDSNGtlowBnboRnayuA5rsPY54PCi6lphmDkB2JW+bmji4C3n+elYKvoIK0ucDAl8vY4f8bDnDehDt/VxCpVbcobl4THu3nqgWr4uuCkR9vCTZixT++e4DS5XXvwA1BI/SD4A/FAEY9lSVvC/7CIpva6hdZSsflfMidjBTnNwiwS02/lb7/agaZvmeTR+npmIa0MQ7WbId1jyBWloEANLKHgbE1zJDO2mZUoJJk1jmX4GXGuhNjI6zqOu2GZLYzupeUdJQSNVgKKQHkTcfUTixPWYyJT5ox3C/5a6fTNjVhcIuHYcDgixMflXBnZqr0AbwOWBjUt+NqTnEBmBLmxw3f6FyJH9wN5ZG2RKHXTSqm8XN0FTY/9QUbGUanIucFkQ5/T/z21rxiekIKB0voD6hFsqQZU7WQmm4qKYu21BYTOG8A/IQDpxe01AAvrHzPPmK7k3OXMH46g6NGgCtJnlOetjyonzUkXCppYv6MPNRvG2d41hCqPBzGMXvETZBy1VVcrLrqragCYsUwQLT3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(66476007)(86362001)(2616005)(66946007)(4326008)(2906002)(186003)(6486002)(6666004)(36756003)(316002)(38100700001)(8936002)(7696005)(478600001)(5660300002)(8676002)(16526019)(66556008)(83380400001)(6916009)(44832011)(956004)(26005)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Inr6VfQr3d+XPC99F1/uLFiZxxaav8TGhWly3EbvbDJwZBLaeIb4gi12y2xt?=
 =?us-ascii?Q?HmV/nqlEv9oO1ha7FXWaDBqLuoDMfXd4ytLBdcf/8fXAAUjLi9sjluUol4QA?=
 =?us-ascii?Q?lCT5rKGkbcXF2mx4c/IejGYM6i//kxuT6AB3cB9+Yyhi9Dt4H795anZuiE3x?=
 =?us-ascii?Q?SNJ1ct2LFul436VleXyQd7IBsyfn5CO/0jsKTGN09sjgzBLp+UX1kiyCmLuc?=
 =?us-ascii?Q?basOWjHzQwXEacfSE1yV/b4r5dMu8JzAWK52SEwaUCu6Ajnid1FE7ciDcsIA?=
 =?us-ascii?Q?P9ike3mtdiTkJv90PzO76e+G4JM96fUB7nNE85SK+jsukvR9P2+rAtDF3+fs?=
 =?us-ascii?Q?Bl28K03oNxPlofrZ0talbelF2vfiboLa1eZrqA/hiPwZot8NwESfgDsnVTHK?=
 =?us-ascii?Q?T97vY822LxpDrqG/ifX3es1CCH3ysHENiUNs2oWTroEbcBrDv4jZvdOAZWgO?=
 =?us-ascii?Q?E0tH4i/wKt6GvQFMfiDezw8vxUQ1JlmbRzhjDBbuTSeVX9C+zkAgwOpof1Qm?=
 =?us-ascii?Q?0QrNNRUJQQU06St79z/1N+G5AlgucT4Fzy1yYDcV7likKuwyAVHR3ORLIwhJ?=
 =?us-ascii?Q?SQ+2Jnz4MboUguMXTyY6zcqvbS+GIpd0E3MCkhV5cWvIRAuaZSVXQDIpnSoV?=
 =?us-ascii?Q?TxfMFJpA3dscZiOFJAP5wW3UmZQ2vJTEzAqaL9EprYCMxvLRqoOWh9ZyzNbu?=
 =?us-ascii?Q?JsSR0r0/HijlxPBwb+WGncCImkQU006MFmi9+rtqPTcU9ECCJynX8mMsLnPu?=
 =?us-ascii?Q?lK2cIqmLCO/Z0CD4arVltWUOVg/TKtpHuXQa/hywQ42NZ3P2HBN5OuaTVakw?=
 =?us-ascii?Q?wCN/1faUUuAYv91N4HS95/+if69Pb1wtNM5OSRismuWm/d8s6a99Q9DPCrPk?=
 =?us-ascii?Q?TE3reEPZ8wL0PafmkYiqdY7gMFXyQi6dB3IvfQaXF3DkNrJblsFr1WHy0VEe?=
 =?us-ascii?Q?MOjBJmwpJ4za0URUukhLsnkkRmsjYyzp3M48cJQSxkg8Wl7JPdfcWoltJv48?=
 =?us-ascii?Q?Uu5sAAAW1BX5P/tW1moP3UJKjcuIU6UYPiob/tPgSpJChhMcl2ntj6ZVemQJ?=
 =?us-ascii?Q?eK7KeqVPU6+SUR/kHc05OJhg6kH4CVWxgnLardoDD9ESSHCup3fSuiFB4CLM?=
 =?us-ascii?Q?BEvC0m9JPi3h4IKvGvqHBM3XETo01KN7WusOJ2oNdR1L2Zp3iyNIRynvKSn0?=
 =?us-ascii?Q?AcLVHPYXwTQSNH75oB4Cmw8cK2hX99bGKNZO1/DZYY2YAZlz03gPJadEmFrr?=
 =?us-ascii?Q?cUxcel/0j7wzoxUNPevHKItwoKEyF8F80BjXE+pundjerRVp0VWYXmdTnduA?=
 =?us-ascii?Q?aXHCUbUIm531UJYQv9hBAapU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c086f08-a849-4e03-360a-08d8f54a0a88
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 20:09:22.9736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rDHn0DMvGbzeumXz3vC5Pf1PvCnhVQvqJSC3+aH2N+cgPklyAISnbFVWc2tpjRO8PuY+xtpAbSmKrZcNJNa+T6Uh9oeZRbAO/K+VIG3XEGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010128
X-Proofpoint-GUID: fH6kiTYRrq8xMDUb6FdjwRhZOC3MQxI8
X-Proofpoint-ORIG-GUID: fH6kiTYRrq8xMDUb6FdjwRhZOC3MQxI8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 35891d9a1099..8d04e69db038 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -231,7 +231,15 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
+static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa,
+				       u32 size)
+{
+	u64 last_pa = PAGE_ALIGN(pa) + size - 1;
+	return (kvm_vcpu_is_legal_gpa(vcpu, last_pa));
+}
+
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_control_area *control)
 {
 	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
@@ -243,12 +251,18 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	if (!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
+	    MSRPM_ALLOC_SIZE))
+		return false;
+	if (!nested_svm_check_bitmap_pa(vcpu, control->iopm_base_pa,
+	    IOPM_ALLOC_SIZE - PAGE_SIZE + 1))
+		return false;
+
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool vmcb12_lma;
 
 	if ((vmcb12->save.efer & EFER_SVME) == 0)
@@ -268,10 +282,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 		    kvm_vcpu_is_illegal_gpa(vcpu, vmcb12->save.cr3))
 			return false;
 	}
-	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
+	if (!kvm_is_valid_cr4(vcpu, vmcb12->save.cr4))
 		return false;
 
-	return nested_vmcb_check_controls(&vmcb12->control);
+	return nested_vmcb_check_controls(vcpu, &vmcb12->control);
 }
 
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
@@ -515,7 +529,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	if (WARN_ON_ONCE(!svm->nested.initialized))
 		return -EINVAL;
 
-	if (!nested_vmcb_checks(svm, vmcb12)) {
+	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;
@@ -1191,7 +1205,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	ret = -EINVAL;
-	if (!nested_vmcb_check_controls(ctl))
+	if (!nested_vmcb_check_controls(vcpu, ctl))
 		goto out_free;
 
 	/*
-- 
2.27.0


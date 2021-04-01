Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB5352069
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 22:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhDAUJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 16:09:34 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33388 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbhDAUJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 16:09:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K9QTe079639;
        Thu, 1 Apr 2021 20:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=2rfIUzTVNk64pyO28Ajj2K1M59/WU00WPZ/I3efYdbM=;
 b=JvRTcR12DRiBvKvRAhtJMhr3Ns/xe3232/Ltknzih8vIeGuS9Hi+rA75d6AaxFNe/WFI
 IZ2zIRTpgRDbmBDWJ+JurT+LsP5S7LEAB9jlL2mTNaf+tWZLUim3MV3cCEOsLWhkruFB
 9yw6vxLvyw1BqTuN7E2hBXn0Vl7nK3TzWNrgV0MXJtO2XcgseTD7XD/B8BHF+P31aCrE
 eFGO+WSCkrgCdFcAZkEgwBbJKjDalzYtCjv/C3FmxAj1oTB1EbO38fWLnIXQ83LCsCF3
 ZHgL/Sq9vbKcDysPIgRuMJaK1Gk+/ruMA7FcBGq2OTOBlIrEEfm6dPz9vWLC6wR+LTcj jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37n33du0un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K10Wi178428;
        Thu, 1 Apr 2021 20:09:26 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2056.outbound.protection.outlook.com [104.47.45.56])
        by aserp3020.oracle.com with ESMTP id 37n2abq9ue-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX8vnZVPqXqw8U89RhkK6z7LNitJQVlD3jz67c1uDRyLhZrc8pS0j55JxwMjqZ6j17PJXMdzHXd3sZ9WqW1ntnL+8os3W4oYXeiWYGBBwZBAyWstclxIy9vaLCwkp+ccyUkO9SNfPkUpJxxv0WHTzGUb79M0CE1HW51/8HtOdvPMaiYNyCdIlCVGRVryriKqtorTBQMZxAshNw/3BrN9X8Kq3q/sgWD0b2fKMMc3IEhvag2N8BKAURv6uBuvIiNLNOr8GCKjpBEZ4AzM9GSLSZfwaPwvFA1IyjvVm0jKRYmeAfwnJVk+5WaA5KBWIucX6k6OD8eE7piwhfMLebRIhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rfIUzTVNk64pyO28Ajj2K1M59/WU00WPZ/I3efYdbM=;
 b=nGu/aRKxi88oZGd1cBhxJ9wSQujQ1PNVht3WOIAlwj8Ua/Yx3p+DK3kETxiUNP2xB2Gv+HeRJmvGPpVGH2pAu+DsEuH+fItD92k6Clqdh2LMzj0vKg8zzxsZWuDTODCw2y5CayK4E+vzX7Abudya24NrRgokyBgoqgL1kbtVNC0Dkkt82nIdEoxsECnchASnOVcPB8SG8iPcTC7bS4ZlpcqW+73UkLl30nO9X10TtPnIOLrymzS/aBCKzevsllTP8SRPQIh/U7jrwT2F0OTuMtUO/xerBTbBvYmXs6sCYDl71+VbesY6QWB3eh0sshI38XPU0dELlz3HAKrM8homRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rfIUzTVNk64pyO28Ajj2K1M59/WU00WPZ/I3efYdbM=;
 b=QKDSsrroN2VSvGI3zTYbg79gvEHBXkpuXBcMYH37o+6k+X16LgiEIg0VmKkY8UeDDMQwMnkt+l81AeUOH1bkyEX7Jid1qFpuqwzvfnYfBhjeQxQBYju0X/VjtFS7jFSM50qBgP2QrSX2Ry1a/9rMYHRjixUjk3TSMpS5tAvCGZ4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM5PR1001MB2091.namprd10.prod.outlook.com (2603:10b6:4:2c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.33; Thu, 1 Apr 2021 20:09:24 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b%3]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 20:09:24 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/5 v5] KVM: nSVM: Cleanup in nested_svm_vmrun()
Date:   Thu,  1 Apr 2021 15:20:31 -0400
Message-Id: <20210401192033.91150-4-krish.sadhukhan@oracle.com>
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
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR21CA0015.namprd21.prod.outlook.com (2603:10b6:a03:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.0 via Frontend Transport; Thu, 1 Apr 2021 20:09:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 206608b1-8327-40bb-8df4-08d8f54a0b6f
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2091:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2091064DDBDFD38BB7F658B9817B9@DM5PR1001MB2091.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWrAOblcWwsxb7n7SAuTDobCkWCIbmt3An8ELUBk9cAkAD2F9KUESZWDbAhhJSKt6ZeveBiQRTj3sxlKeBPSYA8eonDoMf3FUmPQvbVt0Sot70vNAVEm63ONAEYzbJWTfiV8LeOkae6o8KY241AXdoRbZaWDh4hj2FbXaQl284Ppzgdm//IOdJWU07yXxjZe8XtpszH44hhMnRusHfHn65BumdwuosQQHgQ1+jrAdkPDKsaFcXN00zQqAhSxEH46I7R2tD8vTmYJpOjYaVf94RurfeTrF+p0lQdTL6Os/4QG3M1tL4iJhGGMgjoW4oEtRMQ5QCZVYDZSUSz7QpwnVsqGdGAqK2q3DlYv6fRpH66wq6MtnowRYpxyCEmlI98hkEUsaNZuNGgebuY6PMpcY1TA95NNKBYGqm3Qu+Bzy27eM+rCH6ZQd0uvTL7QygBqf+BcZpNtbpT7zRbvtGjRJM2ZRo6VbnF5/jHn+sK/np13zADA8gq/ygUtIRGzMPSBZSc39Onb4mH2zap2oi8+VLNXtPg6UlKr7gzC4oVk+mqlQZAquPvb3s7zqxCtYtWZbeq1a5yFcce6GE20Qy//YdU5WwDeur/orr7QrCBnun/ieBIrOiOS5fHaeu3TKiBmSWx6MDaiz99+q0coWQzw/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(66476007)(86362001)(2616005)(66946007)(4326008)(2906002)(186003)(6486002)(6666004)(36756003)(316002)(38100700001)(8936002)(7696005)(478600001)(5660300002)(8676002)(16526019)(66556008)(83380400001)(6916009)(44832011)(956004)(26005)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hITz4iJ94yGVAxY/X4QYGrshbadsjcDWULiD5DGAK8JyZeF2dYZ0qXtm9PyH?=
 =?us-ascii?Q?ltFnG38dcUwPEnSzZ+0yjb58NtNrV/R7Y110Z6fNS8X3l0aqQ38gp5QdU1KO?=
 =?us-ascii?Q?oRohIsEhwZlu8yMMyWIiAqSk/Y/UJYnW8c5tr2oVRjUFZb3OXl2QICIQlowq?=
 =?us-ascii?Q?dJOG8Zc3beQBvynVIEVaX8LCIsEBLaRvaUeIv7Uxvk8oNKaUL4k7VG2Yhjwx?=
 =?us-ascii?Q?xvwku/Ht2zwlFSLHV7xWO8LaKGaUjOfWiG3z3yfAKNiuMQ3Bkd0ze8lLkUZz?=
 =?us-ascii?Q?jzMAyBy95c33kvNG6X91fYnMFlztKwGE95TkxRgSE3HtvTbP0Hy/w3kA2hBa?=
 =?us-ascii?Q?RjsfoEG9ib7J5wcmhf0h5x+YHcoFtYIpHucH1e/hrFta8J47Xo89DHc0/epS?=
 =?us-ascii?Q?z/k3GYvW8WFzpk3phDZ1dnqxAYrr3QRPN9YsxkGZl8BwWBcgQrMeQp0QQTs1?=
 =?us-ascii?Q?AJuTY7lQzIAcEd3C3qMQrFGMins9gwhzJRJPR9AEoGeSCtwmG6FezaSl6Mfj?=
 =?us-ascii?Q?OA78Qc5bHSNrwMqgiYFA7eAE1F17xHrJZdQzJsFk3uvBhULV61+jluxBQ7Sr?=
 =?us-ascii?Q?RSunSAsniqxafQhuidIR1WnD7KLDOnxoGfUuznp4IquNqPfbr27TJU2wgymg?=
 =?us-ascii?Q?RTVqDAtszyQw5VoGFIt6Iz2odw4WMwZFeOB1M8Rd2uwxImckDpo3wbEfyEdu?=
 =?us-ascii?Q?9yfC0fwh4/a/27GGR0kvzyjh02d4ZSc89xNWuK93fFAPvDJdVZTYGHIxEUKZ?=
 =?us-ascii?Q?jRQT+ySfDHywxFO7clSRMd3nOzx4xXK/B40a9yAD+H/yOc9EFkvEqtPcTWaq?=
 =?us-ascii?Q?3acLWL6J2cr+RYssff44LzCOm8fpe5WSm6JuhFieZLJbGCp2i1AY6eAzMsff?=
 =?us-ascii?Q?6VeN+/d85uWn4uV8OENNI30p+TlM1ca+IEMq5CUlF36Ti3uR0IqgURV9gjIc?=
 =?us-ascii?Q?cR65/LthrWMeK9k0KPJ8yAQ2l8S19kyPDOkmBrf6dZY6Bv7QQ+ecOYyHGexF?=
 =?us-ascii?Q?W7omkTAmEia0mSU890nAyQuTHrUvT7OjgsuneScIuLP3jGis3Rv1WuZ1BNvR?=
 =?us-ascii?Q?iSvNcebNXLl3h+ix0pJ/ZKGaDHuFNPFIcMN52dGUtLMSeKJVTeepaqMkiw0w?=
 =?us-ascii?Q?lv45ljX5UsX4XbOiGZn+HicQwe+oCKBUOKyJFC1DJEfrc/8oPsxoqyL1bBth?=
 =?us-ascii?Q?dGhZomoiKspiXYGbS2FI82ZYnXX6DrxophiQ6hHC3WZ9WwEJn2dQqmZCVxSi?=
 =?us-ascii?Q?vppbsNJr4zgGrb5p5St14GVpGuCTxLdf6RFELNCAivIpUCPkvef9fFXCVply?=
 =?us-ascii?Q?yGnR8uriC3zFDbhZvDAX4LYf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206608b1-8327-40bb-8df4-08d8f54a0b6f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 20:09:24.3569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DgFViDc17S/9ZvBXR98PrmVA5Yb6RBsn03JFjfA7gzGmhaGwMrEKvaNpwqLU7z0loN5yGGFdx4TI2daOY5Zcuhic2wevXSxM1IMpNOIQ3NE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010128
X-Proofpoint-GUID: u7hxqrpFq72miBlqpJ-Ms8RXP_Ojge-6
X-Proofpoint-ORIG-GUID: u7hxqrpFq72miBlqpJ-Ms8RXP_Ojge-6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use local variables to derefence svm->vcpu and svm->vmcb as they make the
code tidier.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9d8d80f04400..2ae542d1befc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -503,33 +503,34 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 {
 	int ret;
 	struct vmcb *vmcb12;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
-	if (is_smm(&svm->vcpu)) {
-		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+	if (is_smm(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
-	vmcb12_gpa = svm->vmcb->save.rax;
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	vmcb12_gpa = vmcb->save.rax;
+	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
 	if (ret == -EINVAL) {
-		kvm_inject_gp(&svm->vcpu, 0);
+		kvm_inject_gp(vcpu, 0);
 		return 1;
 	} else if (ret) {
-		return kvm_skip_emulated_instruction(&svm->vcpu);
+		return kvm_skip_emulated_instruction(vcpu);
 	}
 
-	ret = kvm_skip_emulated_instruction(&svm->vcpu);
+	ret = kvm_skip_emulated_instruction(vcpu);
 
 	vmcb12 = map.hva;
 
 	if (WARN_ON_ONCE(!svm->nested.initialized))
 		return -EINVAL;
 
-	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {
+	if (!nested_vmcb_checks(vcpu, vmcb12)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;
@@ -539,8 +540,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 
 	/* Clear internal status */
-	kvm_clear_exception_queue(&svm->vcpu);
-	kvm_clear_interrupt_queue(&svm->vcpu);
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
 
 	/*
 	 * Save the old vmcb, so we don't need to pick what we save, but can
@@ -552,17 +553,17 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	hsave->save.ds     = vmcb->save.ds;
 	hsave->save.gdtr   = vmcb->save.gdtr;
 	hsave->save.idtr   = vmcb->save.idtr;
-	hsave->save.efer   = svm->vcpu.arch.efer;
-	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
+	hsave->save.efer   = vcpu->arch.efer;
+	hsave->save.cr0    = kvm_read_cr0(vcpu);
 	hsave->save.cr4    = svm->vcpu.arch.cr4;
-	hsave->save.rflags = kvm_get_rflags(&svm->vcpu);
-	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
+	hsave->save.rflags = kvm_get_rflags(vcpu);
+	hsave->save.rip    = kvm_rip_read(vcpu);
 	hsave->save.rsp    = vmcb->save.rsp;
 	hsave->save.rax    = vmcb->save.rax;
 	if (npt_enabled)
 		hsave->save.cr3    = vmcb->save.cr3;
 	else
-		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
+		hsave->save.cr3    = kvm_read_cr3(vcpu);
 
 	copy_vmcb_control_area(&hsave->control, &vmcb->control);
 
@@ -585,7 +586,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	nested_svm_vmexit(svm);
 
 out:
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map, true);
 
 	return ret;
 }
-- 
2.27.0


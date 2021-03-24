Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485A93480C3
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 19:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbhCXSjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 14:39:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50964 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237689AbhCXSiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 14:38:50 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIOR4c117165;
        Wed, 24 Mar 2021 18:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=0BmbeEmUbLeyXPR4iuqm2o4WOrw+pqilh+OZEuhBVIo=;
 b=gPpOfuCAyiASTf92K03dDad0610K0SelM+scxsm+sR6DVwWsEYqbOJ/r3siXv6A5xPRP
 bnpOWQLAIfrtunZzfnYZCJuq31Gr4qfOz1xMrhWDlxSwKoXPaMWhSAiu8cvmBsbMT7rL
 wDsxvANeHiXqH+jYAQjQCEmWOIwcSvD9isHVuRyPKgdhkG/0yV1Eh9N874A2U+f+GdgB
 ikSqxa4erjHSqLMEncPh4YHc7SLJa7AOKNaIKbCzCcRLIymXfGTV60LWpONDoV1+sWex
 NF9d/fkJXAMN8uvSeRAxWyl9iKeRfjz9EmprDjYSE2Jh3DMCgDy7Y0sU9e/8KNKWKxt9 Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37d6jbkxx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIQFPY167563;
        Wed, 24 Mar 2021 18:38:46 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by userp3020.oracle.com with ESMTP id 37dtttpj74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLozW9Yn/QFenYo0kwVShVBqhVKWiSex323k9Zgz7/uClQtmMfkxuFnh5HSxbBUQOXLLIVsi8cWd6Kxu0t8bpcmuZVpFmANYU5kzmXEUU9Lsuy9Z0MFOptXFpxRxjTKbn6dtRzkkDPM1szTnZbVzqVEjG09o0TO6sqTHjsSOQk0uBZIEY5+/Juk73Twc22vADl2kPhovBx7yah/kOBlywTJGzeB/PutEgWJjLT1T77ZWgOFTNovLyo1+ClHqWS0N4eJtkToDsSpQHemDRX4iFFA1Lhk+BMHAX8Xd1dmACC9kilFzjqTATYd+QMXfhSYB5bXK69U1vjNKEAK/kp2aEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BmbeEmUbLeyXPR4iuqm2o4WOrw+pqilh+OZEuhBVIo=;
 b=mvuvDGYbY7WFoPwQ+ve28+Fuyc8GRQIJ0Gp/IoUcdlDY897R12ZAaLfemHPmSMpXO279NULl/jl1ymwxSs6GfaQkKmay7if3tpxPajQUEnJWFHVp4Od7U3xW/AkyDJdpsVoZlxfvpr02kK/NUzZHpZMskn789Eo8HrbEx4c9/id5hhsZfQ9xyZwrjyL86Y8Mx5MNt37TsDOzsrqT8oQn4JgBksU1RQlivEo6xebzIbGUHAqhN/kSlnLOqwKzaN47/gZb9KbSPcJd7E6xaVNZEaVbWrApMMxXRQG0VdJgZw+Tvh0GI2Zo2XE/xDx/mn+6Rj1Y7xeLbWHjfvxtxNNz1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BmbeEmUbLeyXPR4iuqm2o4WOrw+pqilh+OZEuhBVIo=;
 b=NSA0bmiJM8ifUATOr23tC7/qGHUZVIFllByvvbyYVDChj/Gu3/NGiggcF2/Xdv3dxndTH+AjNZbdcVN3lTzHspR0cykMdzlzUY0kNZ3sPQ5xVme852NlnfjvMbZLXjcJgrJBBitY33txrnYGDQ1DynMPBq0//pT9CO1RkgfbL3M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 18:38:44 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Wed, 24 Mar 2021
 18:38:44 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/5 v4] KVM: nSVM: Cleanup in nested_svm_vmrun()
Date:   Wed, 24 Mar 2021 13:50:04 -0400
Message-Id: <20210324175006.75054-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
References: <20210324175006.75054-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:c0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Wed, 24 Mar 2021 18:38:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c81cf52e-1e82-433b-e421-08d8eef40da1
X-MS-TrafficTypeDiagnostic: SA2PR10MB4425:
X-Microsoft-Antispam-PRVS: <SA2PR10MB442537F51ED1A7E7C4B8714181639@SA2PR10MB4425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6dbT6fr++3p/K+lv+0L7VaSWi29bgrtnmOtJU6p90D/TK6KVNIjq73UbwjJz/Dr8ex5ZERF4YNe7dt3VhH3ozA6wl6xxoOyVVNljh45DA6ijmFM8hlP/sONSeAcFz1rSdJ8hcNIo54nCaEa6KGgAFJ9lQoLJRMSO2AZ6ChuJlJmiTkTPjC3pdGGXnfmme9KvPMUQhgcHosvNLL2XVufNfVAeWMwNhP/o9LIJRmpN8hnPf+clhBLb1x3aYQM8ZSpGMQdpWapRG4KlH+WMzqqxQgrozIkMIuGVy2ujXBVZ+5ysc6UbiSnOX1Vb8cfl4Fh/LsPWZ5v/cZS/jefwgtTitfqz1b7+JQbKrvDjsSb61Oqd1RTEatOA0tU1Pa/bACB11vRQXl3eBj/S4bbCbZB8VcKii3F4zQfyV7N7bcfRA6dwpJBVDTSI0HBWx6+1aXMZbqigkcVSensrRscbVT4MI4iFLoNUDjNzM1dq4qcsX37A07la/BbCCxuH3UUYtAEqhuQc3x30trjUowIOH6EPiXu3gIr13C0XL9F5iutBRQgICW6qS5WCohmrFpqIU9xPskho39Xrwv6XGAFz8Gii5/mEdkYJEXn/JkNTzu8uN8Fl7/nOQ1iOhp2gNIt/O3yRWQSCU4PSnsBg12H9nRE8pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(38100700001)(52116002)(8936002)(7696005)(6666004)(36756003)(1076003)(5660300002)(6486002)(66946007)(66476007)(8676002)(66556008)(6916009)(2906002)(86362001)(26005)(83380400001)(956004)(186003)(478600001)(44832011)(16526019)(4326008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ww4VvLBSXLIt/4t+B05y08IHOYrX8IJdqCF8whlrdyxLZaV6eTNdPzj5MQ0R?=
 =?us-ascii?Q?QrS/4KpGjnhXAIWlNyek4ULWcpUN5N6XBhWe00HYgiIM/ruOQl5bZi8MG503?=
 =?us-ascii?Q?9maHfVeTFDsIx8uSzF5sr0+WpkFAzYp8ojA0LmR2lJp/zcPH+jByFG7GWARj?=
 =?us-ascii?Q?i6M+kAZLKP3Y+4TM4lF0/AYU9OLnYD5SS6aUcKIcZlrlOQpqnhmszgkJPXRZ?=
 =?us-ascii?Q?P1BWUgfxMsavLxtEceROeVDUVXHMJnRdiC4uvQVYOxUEnzfq6p8oMADPvxgq?=
 =?us-ascii?Q?NZAYm7XngVo2rBceX/ej+vWeGHriLXbWIh4dF6wDIkOSoJpcmnfSuWlw5Q+P?=
 =?us-ascii?Q?hIi+KRzAAcwt2CuT2yHsJk8/kNQ8JHToMjyT4wbmZqj3/zwc1xWXrsDAj8vs?=
 =?us-ascii?Q?s6kDqChyCKiQMZ5uVN6jeFl0VJ6n85Hl7pExD6kXpL7OOkVeME1TZrqEvTM6?=
 =?us-ascii?Q?W7u9nOI+0n+Wk9r0U7H1pVly9q7XXsO1DZUKoKgH5FxDRxg54Z9f2eW+yVYJ?=
 =?us-ascii?Q?VvBowisjIu0rV3Ra5+JgTusZv/eEaHy/8B9259LuoCkG5clx14iLmegePJ7q?=
 =?us-ascii?Q?seQKyxwahVey+shr77Pmrl2c3Gqzmmk7x9zzcubRhekEsKIM6eqXHia/ZBmG?=
 =?us-ascii?Q?yhJLcPKi0fdkNbEwf2v9cavqUqXDZJ8pSreb8+QJaWCSvr05980ylZOulU6B?=
 =?us-ascii?Q?Eg2felCCr3HFKxdAMv78b+rqsCuSg6kYDgiY2WnXFCbiKAgHPcgEl+ZL0+De?=
 =?us-ascii?Q?Bn+nXbbjX6/VGqamk8RK0xLAcb7PNpZ5JF1tu4IifXj66JHMcN6AZRks+uZH?=
 =?us-ascii?Q?aVMnJhMTWHfiaCFZGIql/rayVn+OrZvW+acMo02cXeZjwDWrdkH/tV7xsy2v?=
 =?us-ascii?Q?Zr7/2iNc9tT66v92iZZq0NFysuqpxQyHSrcEb59fcG9lcPagp8gtna/iaR7l?=
 =?us-ascii?Q?KEZJr5EI4+MsLKUy/S+7hFP88BDeiJcjTYHRJCfYPQ42huITOUGTDO39nRqV?=
 =?us-ascii?Q?VQP8c4VjypZ9iO81OQBMkoFInu3OSzAvSKUSq13bFFQZ2fKRUK+IhENuLpJP?=
 =?us-ascii?Q?cQqfUI2lOGxbbPdh4GESoQjFnf6a7JqJPzGvrLH81Njn1J44/F1Ai+Dp/jn0?=
 =?us-ascii?Q?55TaDELg6l5U4Kkd0WsvAL7fBVhcKp0INYhWMoJ8fVmu/5kcKaLs/LwQYoDx?=
 =?us-ascii?Q?LMSG75FLDXBazq//cXWF2dSv5DuDRb+3Dgd5NNPGd7woB9H9Kq4OMZ8ggx/g?=
 =?us-ascii?Q?MEhkmgAIMCdBFctC78btgyIZHoa4/m7D95cS/5Xu2F/aogWbaQmSt/Et6wqi?=
 =?us-ascii?Q?lES63IqvXlCiZNHWYuiQiOrN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c81cf52e-1e82-433b-e421-08d8eef40da1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 18:38:44.3887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTecIhU5ojDZ0ePQFQYTCxmstt4I08e6rXsqGJnBnBZqUpkWXhf295/VMionHfBztrFlSWR1SgpOuqjj8c0zeodSvFNgI4y598kiguL6qGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240133
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
index b08d1c595736..a02a4e01e308 100644
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


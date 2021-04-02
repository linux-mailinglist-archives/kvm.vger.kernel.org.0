Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE23352520
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 03:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhDBBdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 21:33:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49852 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhDBBdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 21:33:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321Wr5n063887;
        Fri, 2 Apr 2021 01:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=YwdOVBRL4lgF1P+4RwcjwaVT/DZRjxi78ki3Vg3kac0=;
 b=YLConeR0OivaBqrmhf5gj0uBklxpJ95kgF2tpHeaO1KcXHDcLsE+hA6WCaDeiKwL3JNN
 dUzVDDwI7ZCuQZGqoJvRNYgbD+8qS2l7ATXpTYIxeW9fdm000zJT0qinGrp5aZDaM3G6
 A4EfPRw4/aoJ6cTzkRE0ef5axogK+nm8LiPjZdVzmutjolDagaioAUh9luqDJEkqVZX1
 7cJJUJOQ0KDzi41hu7MEcUxwvw2RAb5ZRdk1ZH6AA03igHY19WB5zbwCCDe9Gio9UhID
 nYRDlP6YUJRXfwykKDo+KnmQS1zrGUQgfQ22o3RqrNuxFqL5THB850srxo1ijmqgtLvp TA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37n33dugm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1321TkIr150731;
        Fri, 2 Apr 2021 01:32:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3030.oracle.com with ESMTP id 37n2at0196-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 01:32:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuYOqnlPTmJ7ks71M+QnbqB7ScJjNyyPAuPWPMYbwbZEI4bvRlIh//xWd+FBhsRkmIEMKbTTC4ca8MvC088eqOjaobS0G2/Mb/zak7uiA4fWpLt25X3laQvvg5mpbZRiKJmPj+MQK77DPxCPO3Ep8n2xq8NibxH+f7+scLSvgPVkHxvsAHxZBaP84jRWk2A2mRKxzm3ulc1DXuueuDS78rKjHIVDGun8sFQpdrI5gJ/cD629cHa4meAG2uwYZobLLiWcWaRPpoT/Mv5W4MDDAoZ2GxsaSxaWj1CtRlsvXO6MK9AO+Zhn+GZPyphlRQMQusFlnsKhstaKRaUpL3wiJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwdOVBRL4lgF1P+4RwcjwaVT/DZRjxi78ki3Vg3kac0=;
 b=Qil/jGm4jOQmTtR4as3XFOtWUU6TTAumUWZT9b/2dnEnEclDfMbipazTB7Yq7ZRp4d1i+uOfnE0yVsvAs1wsOQl4Ts/WqRbKNTIl5CcDQ+aZtxHGxh/KHwoxQBBb8RBILclJik/IeQicU6jm1OjX95wVTHyRAQjY/t2KDUrkJq/fC9bwCphVrbx2RealsyPymMMDUW5v8bs7gT9yEzg/GX1ytQgI/DUMZKSXsnmvl0II+aG4HbPjVjdMDyHKa76YaMbu2xItympE/9UGYR669s+ZlZeYWqBqk/Xvh4eTPYtR13Pbv804DZrTzgd1iUipjD533nCL5jZUES32hkiGTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwdOVBRL4lgF1P+4RwcjwaVT/DZRjxi78ki3Vg3kac0=;
 b=mW1S92JMc5ltYQkMNuWzCNuhWP97Atxmu9tAUn81pj8v/3ieQ4dtxp05lMMr0rhjHKKPkPNXSizot2k5sO5i7vx4IME2f3jK1z+PUXS5rLDVjVHiKcM+8mnSzzYyq7AOMiTRRgQ89GuJI3IqYbaEu60OmeGxcVGT3wOhuPkmHgU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 01:32:54 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 01:32:54 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/5 v6] KVM: nSVM: Cleanup in nested_svm_vmrun()
Date:   Thu,  1 Apr 2021 20:43:29 -0400
Message-Id: <20210402004331.91658-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
References: <20210402004331.91658-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SJ0PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::29) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SJ0PR13CA0024.namprd13.prod.outlook.com (2603:10b6:a03:2c0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 01:32:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c757095-0814-4c5b-9b1d-08d8f5773cea
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB47959AFDE18043E1309435B2817A9@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6SkGRexuOf2S/Dx57S3uiz+t+AGubtfodCscQ/4iBAYjaXmBizK5OJ2HIqItilrYTx2UfB6hVF1e+UuoCZz9ryeBiqm5HlK2XHovMwmDDEKF+1EWHkPjqR0rDnd2URDlG7lyMoWQwsJCFu5aV0kSqRMu5i2XR5zNs1s774P6qih7uXwr9y8lmXHxj/cUhlaqRfjYJoZYR0RfUtIko1W+KUmqWfsV1i+jV10xaO+PthdGYNL3ZBSm7WrWg9p9fnE2jzTfdTwEOTfZaKWKz7yE0Uxuc8Bx2mQzlYyjYpkBtc9OrCJGJCx9x2mUry7/n75toSCGyU4ksPookRAOf8yk16UffmVdPEDgPQx8/Dq91IvNWoghOc4x/lI9ZNnm3wgNY3cu1nkeBPPQoNdagZy/QXYpadycgIlnj3SKZiCuNfZV/Y9wkHrRBSFRWdptn0dTBGHsRW/yOK8jyimQ0NHBsCfkFB/SGThzUpe2EUnva6OHj6xpf+TE315AWOuhALPoOl4HGk0Ts718hZyBICG8ykpOwFNub5yMPhfqcU5fYyif9kJIpp8QydgYFcRNyrl1xnE1AS9IAH7nWM5oy2xXbHRBnnXgG06FENYfJZ3MCKpRzDTtm1kyoTHN5WEBm04VvQ9rD6hBLvjzPXSNNkAVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39860400002)(136003)(6666004)(26005)(36756003)(316002)(83380400001)(1076003)(66556008)(5660300002)(16526019)(66476007)(186003)(7696005)(6486002)(2616005)(44832011)(52116002)(956004)(8936002)(38100700001)(8676002)(6916009)(2906002)(66946007)(86362001)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CI8zCYv7sK7vs5H69N0sBtHkpaWrtvyj4s0exk/7nrBdmCQgRK76/FQd+mxA?=
 =?us-ascii?Q?ZUDoVVmTSYqgK9nR1+jPBlqEVbJvwhgItTryKHqTRIRLh+DY2EBYMij6gqzL?=
 =?us-ascii?Q?MX0+FoPSqXhswEBmup/b0jCaS7m7ZYvsrGkqEYBrgZos0ML6r89MpSQFiJad?=
 =?us-ascii?Q?jHiKCptDQpngDm4LADHhDPX/CvLKzCsAZjmNkYQESipSUYR0E3vEd1mXWdxf?=
 =?us-ascii?Q?4BJotLPGSnK7szbqlTY8YyM/Jk3qb1aCyjyLtMbPkFPMQ8JnUl4d+xWTB4nk?=
 =?us-ascii?Q?dLNY1wK9Am0NwA6DG/pV59efncu1q9i0lpbbX2OacvO9npk7RHpT4m1Yy7jT?=
 =?us-ascii?Q?UXcZblHnsOoL/hIUjJmWl+q4a/euPQYadnvunO/U5/Q76sgVeFCZ3EfEGvBX?=
 =?us-ascii?Q?k6nmN22a9rcRcpl+wkhGboRqp5udY0sM6AneyFNa37UAy3ztkZxUlmjSgrLB?=
 =?us-ascii?Q?fxPA0cGfznudYRsptNKy7AZQt6TADkuj06oxft1AEhyQhIzhOHN2j90DiEcU?=
 =?us-ascii?Q?Gpn86yR8KW1J3jYcEHDc1nDs6IBOuQSlRgs0Qkkf+p3QnZfo0EtAVOR0pvuq?=
 =?us-ascii?Q?zOONLCqIFXDuN05hNRWp9ZCbezc6IxhdpTOwB6AAgcsb/mJdhbJIAjriWyJX?=
 =?us-ascii?Q?g/UYgrRPz8i3xpv2sR4cUOfN0fP4p4kvWqar9nZOEIy1pGSPmkQb4DpRmSdz?=
 =?us-ascii?Q?77avm0pb/+9R+SiB4UflKQp6myrZ4MaD7NLGbbnkyxs+Y7g+OUJGviUPBPve?=
 =?us-ascii?Q?Vm+8bsaYcpFb3hJKlluHQdvs9CcSEBPWANpW9Qha+k94em2hez/7ppKbzwUQ?=
 =?us-ascii?Q?/9TTVbjGR9WBX9ZNkaQO/vH84BYiADRQ+Jcb0bizvirY8B8i6y2ipWXwZwgJ?=
 =?us-ascii?Q?uXlDQBWGsljSxci95qwKFCTJwLJSl81ZGaK04O1cxL+vJpCKEe2m/vsHqRJg?=
 =?us-ascii?Q?+KN2nhpt5d/27iyyMCu2v+Cv1xDiE+Hnu9jV8yeNjV1jVsz+JPNlrWfsOqU8?=
 =?us-ascii?Q?2/OCisn1c0av7dGJwsox1BQ6jewoNXnBBsh2/iMy0J9h6ciIv580e74G3HyN?=
 =?us-ascii?Q?wow5wuqJKGLY9pE9Y2bgAQHf68IkhUc58gH/d8PaKKxqVq5M8yZeeOXAHldg?=
 =?us-ascii?Q?F1uq8dxmCNJiCBjwL/zbTy364I5osLGja3PzZaAW7zxaiw8POHZ+4PFE+2bN?=
 =?us-ascii?Q?YWqkmNwPDdC8VfvYY8291/jJiXPGBagEo75IEqgEXGMcO/HBiQqzkXEu2ggi?=
 =?us-ascii?Q?AmbcQzZuMg9zj1pF77tuYNhEat7zR0iBNMkXyeDjdbc3PvII3JxfWmpImcbt?=
 =?us-ascii?Q?TAc3LubcCjj8aSzaRgAq/rEE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c757095-0814-4c5b-9b1d-08d8f5773cea
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 01:32:54.8534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f73pWfkRD+UObPD3F9od/9qZ+HtQMyIaM0qTdtyj2A3ID3hHI55QLWwCaM1cBCSnR1IMHnhWt/j5uQ7xgaWOIu22Stxe0jRsOztH5CrhatM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020008
X-Proofpoint-GUID: q9RtLEYXVyTROYlN0m_HKyW0agIsGivg
X-Proofpoint-ORIG-GUID: q9RtLEYXVyTROYlN0m_HKyW0agIsGivg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use local variables to derefence svm->vcpu and svm->vmcb as they make the
code tidier.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b3988b3a3fd5..3fd51fe63170 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -517,26 +517,27 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
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
 
@@ -556,8 +557,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 
 	/* Clear internal status */
-	kvm_clear_exception_queue(&svm->vcpu);
-	kvm_clear_interrupt_queue(&svm->vcpu);
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
 
 	/*
 	 * Save the old vmcb, so we don't need to pick what we save, but can
@@ -569,17 +570,17 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
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
 
@@ -602,7 +603,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	nested_svm_vmexit(svm);
 
 out:
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map, true);
 
 	return ret;
 }
-- 
2.27.0


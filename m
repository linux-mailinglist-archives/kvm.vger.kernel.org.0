Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38E730D1AA
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 03:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhBCChz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 21:37:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50298 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBCChp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 21:37:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131Ov8p015765;
        Wed, 3 Feb 2021 01:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=xZq/Z3g8M/JasXXwjsHckyjYGD1FpG7RMfGu+OE/pfo=;
 b=i4Lfg3MZHE3Er/ovpohd+LyyiL+3PmLW506X+7Jifr/omEsCd0fro4Ld0vGJZ4pjVG4U
 7o6kyY3ImJmyePvvOBP9dpM9f9khymtWUfyuvH35trCUVzmbeKPyOLzNGuuqwe3ffgiZ
 yduHwHG8F2zL82xTpBi54bO93e8objhcMMdtNhu18YeSFDiCIqr6bBKMxUOgbmKaKpy2
 uFQMIgv7LTBl71bFwG4+VeYcxCwaZUmc1arRk6visQOPewFYT/xYB/wCzc6yFmnov90u
 ghhlE8uoUfe4/Bbc+dhS3sVCCZ8vgoMWHfncEWxTjsEeKjPgz8ipDOEnbYtAbIgZGn0h hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36dn4wkg5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131QYRb101012;
        Wed, 3 Feb 2021 01:28:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 36dhcxnvwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLRwAuHZ9k2BfyPIgS2/L+s1N7GOXdw5vEEqqAj/sJZln/gljN0aIZ/gq5OgyTyR1aMOEEYD5zoG6fBwwN1k0sVs12eZXdYo/tINU5P9sGBqbMNU8icGgll7j7BHIKp7XL8QL7DNWqy8R2dWESlEHy7CRk6V1a/zW6WBRTFWc19OWKFd+r7mcF4xcQa2sBMCAg1cmTJYEykZg0QAOqMltLcj8bJ2mVxQuMSw8I48A5U6vmQwzghY3lC5oxdSRTpp20ZrByE+vXV8jdn/QZ1BxZ13O3liIeRNg13dp50rqSmD4U/lag97q2IvIpf5Hd0W9hWOQm7xplCCv+5uBcArUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZq/Z3g8M/JasXXwjsHckyjYGD1FpG7RMfGu+OE/pfo=;
 b=EnjK3tQ6t9BvSEojBgKg9bAlTyelxoriJvAajdLPsxhb+7rTwUo0NjByYqAlG9+wPrbIa2b+Cz0t8gGLQ84CPsFAjsRYjEEw7zvIQvdjABuTrc++Frs1iYV/uMCC45+nmv+tu77Xrkg/aF6Pkc/1hWVDN6qO5dwO43EErANwjSnLT4X63hv7fefbyeOEeksyuw9erkb/YWde9cuBH5NliRSFbriVgc9w3d+VDdooOjSmp0EJzzzu/QYjviVDWeUnMH7xK7kOI2ES0bH/N/hkpUIByz7lfhjE8ye8bEinv7v9LQofjolTXyVKYn6XLraJnpJPm5CxjKabXCuLCAw8FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZq/Z3g8M/JasXXwjsHckyjYGD1FpG7RMfGu+OE/pfo=;
 b=mhO5H697qrf1ab8+NxgZFqSjY3BxeBKKSFzQH4AzurerlWVUt96IcQqp7XLdMk+CCfubYKKLPugLQJyf2Jxfj+Dant7VFu1v+8yZ3CHWnpGxgsEfjUy/jgEKzK0Nq2QDV1dUQJD2P8P2q3YpEUfzCciQ0QTJP1KU8H5wXOcfBdo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DS7PR10MB4941.namprd10.prod.outlook.com (2603:10b6:5:38f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Wed, 3 Feb 2021 01:28:40 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba%4]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 01:28:40 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 3/5 v3] KVM: nSVM: Cleanup in nested_svm_vmrun()
Date:   Tue,  2 Feb 2021 19:40:33 -0500
Message-Id: <20210203004035.101292-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
References: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR05CA0073.namprd05.prod.outlook.com (2603:10b6:a03:332::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 01:28:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0f8f72d-d4ec-4fc7-cc2a-08d8c7e3092e
X-MS-TrafficTypeDiagnostic: DS7PR10MB4941:
X-Microsoft-Antispam-PRVS: <DS7PR10MB49414898DF1F17206A145F9E81B49@DS7PR10MB4941.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sJDB9dGSOCNZMHNBqY0SknsKa37rXV2jx4hwuTWdv5LSW3BTehY8ElnF46bacaltiLsUe5AHOJPVNPZCgtRxaB72NgmAmrW0srzAuUN4dYbHlG1TwVSd8gYEWB1ThmPmYlyNZVWjmPvjKRwVquWtWMk2X2gV4GwgnJzi08YIg4XjTpY7lTsn85QG1sgzBOlvd1mk4H8BUr+nz6sl7VcOptiMQwvynwXX4jkTo32LI0inAcPtJ0tLrNow9lNR3ggEnvvYQBNDubNmNy+VD8EBDveqVLh2BcmnMN7+PNi3bHhqF6cahBo+clAIfKcGYg1BO3VjNDrM+JfPZV7FBO4sFP4KaUntVE/IP+C/EoKtzvga9og5KMDln0J7Hl2nxyMnbQdB3UmD2JDgvxeV37qUZFL6P/HuACN7DYbGilZItsjxpTAQ2O2Jyw6UUt6oOCmwyIjOsQBe1b2roxCb2I6/dhly195ztA2ZvMBEZfOwWYf238ltFg6+W5qUInDzi4KHQ+A725DGBw09Xk3HY3UxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39860400002)(396003)(316002)(36756003)(7696005)(6486002)(83380400001)(6666004)(2616005)(8936002)(1076003)(66946007)(2906002)(186003)(4326008)(5660300002)(86362001)(6916009)(66556008)(16526019)(44832011)(956004)(26005)(52116002)(66476007)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HfvMelyQBSebS6YJD1jjTxdmeYqU92n+OO44u8mI2xj7IOi952kZEo9WAVvT?=
 =?us-ascii?Q?eJEVeBA3SRBXZ1WDgQnNMJjLLWPcSZnJmIuvGYwybzDvONs/jIf0/Rvx+chc?=
 =?us-ascii?Q?s9lKB5lE3LqqkeWBceZjIUeSEwYOr0UqU3c6RfRa3H+cef4rOfYaBJtZAAS2?=
 =?us-ascii?Q?hoHul7OYn2/LEaXxUV/t1TaK2/N6FBLB/UkRoxyDgPMej0MWWScGUI9ZUgHD?=
 =?us-ascii?Q?C2ZYvIBqohAQKkGHzs8Od3zjTaXsWzj9urbn+Y3zRbSnv/PL1z6u08REz793?=
 =?us-ascii?Q?1Qe2zsrdx5YRa+JSmaB58L9Oh39Ip8mAxDJ0XrTx81U+BHLP/uk2SzpADxoD?=
 =?us-ascii?Q?45v7T/iQgY/jI0+/V1JCP1Pt47zwm1bkw9FrZNJTMapsaBZ8iRtvXJXIJZHe?=
 =?us-ascii?Q?kxW0isNjFGiJsvupVp9XnXozq0xKbhAkqsdVpb18r5BhpnSgdqVDIZINf5fc?=
 =?us-ascii?Q?kg9WPFYNngYZOCl1v/e93ofZ6PcD27+oLz1q0dJzia5SopSElr5eEHoRYP2G?=
 =?us-ascii?Q?xFm9Okp5gCnvHOtYvWJoW2RAgrRB9UiTDa7B/PnTHATsf8YDfbPdI4x/ZUA0?=
 =?us-ascii?Q?xQ/HPj6sQB8pp3hlHeWOIIlgfz1GRYv8rUkmL/KvO9souOrVBzLf1oJgkd4M?=
 =?us-ascii?Q?hZXseEmX1RDRNRAvXUki7+hbPazGCkOw2ZjkMsq44/Td7hNGwgBCuewVBSgA?=
 =?us-ascii?Q?bJzSYeRrloOerbBw3vyny190+22X3a8XxPlI5GQrRXvfI2rMqSygPUjJonDR?=
 =?us-ascii?Q?IgHZpQpfWRCzINNJkv9l7KfDoB/7fDhFRzHHFeu1hkQcADzWA4zmZz3mwv5e?=
 =?us-ascii?Q?aeFTHe1Gy3BX4/eYRxWQoui3qiy76FS9uan1XAZGF7OmHsccGCLF2Vjl20Sg?=
 =?us-ascii?Q?50nluBjFHFlJqFfQ6SZlVgFHvsEzd3ub7weEYorZYb5YNSDxHh5SvnwwpkAo?=
 =?us-ascii?Q?oK1Lsmo1g1nM53Zq38cgAOqUK4keNQw4GWLSq3vKagNoPU5XBsTIfN1WCuNZ?=
 =?us-ascii?Q?hGQDEOgiUJOaoqyeG7rjfjv46wWQAVZKUOVddQN4hkpcbisgpVDIA/sBjrFa?=
 =?us-ascii?Q?ZtwWmD9b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f8f72d-d4ec-4fc7-cc2a-08d8c7e3092e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:28:40.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRI4fHZECO0pO7jmemVPItfXQZzrZEfyJhNwFdkjCrIqhQ/f3woSZlU9T5y3lRl0kSq3lGdXr+U7j7S7fmxHRAixpNhQqskWr9rQVLdxum0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use local variables to derefence svm->vcpu and svm->vmcb as they make the
code tidier.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 45 ++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index caf285e643db..e9228fdac9b7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -470,33 +470,34 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
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
@@ -504,7 +505,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		goto out;
 	}
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
+	trace_kvm_nested_vmrun(vmcb->save.rip, vmcb12_gpa,
 			       vmcb12->save.rip,
 			       vmcb12->control.int_ctl,
 			       vmcb12->control.event_inj,
@@ -518,8 +519,8 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 				    vmcb12->control.intercepts[INTERCEPT_WORD5]);
 
 	/* Clear internal status */
-	kvm_clear_exception_queue(&svm->vcpu);
-	kvm_clear_interrupt_queue(&svm->vcpu);
+	kvm_clear_exception_queue(vcpu);
+	kvm_clear_interrupt_queue(vcpu);
 
 	/*
 	 * Save the old vmcb, so we don't need to pick what we save, but can
@@ -531,17 +532,17 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	hsave->save.ds     = vmcb->save.ds;
 	hsave->save.gdtr   = vmcb->save.gdtr;
 	hsave->save.idtr   = vmcb->save.idtr;
-	hsave->save.efer   = svm->vcpu.arch.efer;
-	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
-	hsave->save.cr4    = svm->vcpu.arch.cr4;
-	hsave->save.rflags = kvm_get_rflags(&svm->vcpu);
-	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
+	hsave->save.efer   = vcpu->arch.efer;
+	hsave->save.cr0    = kvm_read_cr0(vcpu);
+	hsave->save.cr4    = vcpu->arch.cr4;
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
 
@@ -556,15 +557,15 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
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
 
 out:
-	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+	kvm_vcpu_unmap(vcpu, &map, true);
 
 	return ret;
 }
-- 
2.27.0


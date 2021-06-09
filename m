Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437363A1D3A
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFIS4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:56:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34648 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhFIS4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:56:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159IoS7h057635;
        Wed, 9 Jun 2021 18:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=zDAGnCEJiliiviTeigvCAGMJbqADRv1w2qy4UsYpuX9Q6mPxAorzPEd+oKIiJxX2Kx65
 slTPwMbry413KaxJGVO8TG46A2EQHKUiF6pxcyV4T+zbxl44h2GUOl9rr0VWinsKRvZQ
 k5jiqpLOfy3SaRVQ9eADWSIspxiTiWW8SvJ32DFAUOSgUoIK9FsO05/2tPXnSkm4LhS6
 FSuOKdXTaLWH3mvLvYo+cy/A3/ZL3vui7si65BetK37WY6N3OwaGP74TWI8CoPR8ZnIf
 zlLdi7d+TJHih7P7ZbM3wYvvNgN/6L7nK+SgZu1GSR+6tTH2lmEsgr+saouSP5sg5Qhl Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3914qurga8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 18:53:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159IovQo156004;
        Wed, 9 Jun 2021 18:53:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3030.oracle.com with ESMTP id 38yyabxqwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 18:53:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llvKazIYk7pXIWdfiqXM9nW6xousR0TyvHVVmhKL/lnBcls8FjMEGvi+NEw8ClmXOOWYYv023rpO3xEEkCzjYP4Ka/f8EV/2hP3Lxfk/1J+AAwF+CJgIZUeSy6WJpsznZykDtXb/feJ1F+Zu7ZDErzxjElhbhX3o04U+RsTvCDF/bzgmFtRFBPhd1WKH3HNO34aIoMZIOJfB7VUiXn8uG8oWPGWSs31fUy8BVePj5KoynNX9kKU7/Qvdldum+lKWplazCRQHFTCgoGRC6fpuJp6UZpaQvPkXhcoBbvYnrMKkG+xKPQHgQBi5QINlRf6Ahllnf4exVN1KW1/OLtOA1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=b1jdXXGGmRVV3EkSvYB/R0MQEe4I9H/85oF+GhORi4b4EkzvP335V55PxoF7LJ7IroEWvCTOi9TLbuX5RZ0CcjQpCbi97nOgB65aO8RZv4Xvp9BzbKdc9VsMP0M/AiCSJLVYsYYVBjfsGfYTJVmwtCg7n+ekDHJNkVkN+HEOG6KMZbE0EV0V7yt0fN6F9z4le0kVnCgNZmaB3lEMKZgMJkc3mw4LDy+/CtWLNeB2JByjZNmMp0LpU8c0bSyGOse8A5GSGYmNVaDqI37llDNegoxMiGiuHZkY/7bkCK0TJoCu5BhP3eCeK1aad0CIBifOGb/1mrXT5rU7NeMg+DHrHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNwt9UOOm0/cE5NjYsCNNcoaSz4DNRBm+k1CVihfWZY=;
 b=bSfLZtORuqGyFq+fVIK8+5se6Bal+Q2CKwOZ8iyViNVbP3qjaxhug7cTDDVRyMz58aVbOVf5YLjqETgN7dDfAXQb0I+2BctuCE2mKRNAyuJ1fApxzkM3et5ElutIMdSDF9RicWEyQvXZG2B81nfjy6Z/PAcXPJd0qcTE+Kw2XTc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2510.namprd10.prod.outlook.com (2603:10b6:805:3f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 9 Jun
 2021 18:53:12 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 18:53:12 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 2/3 v4] KVM: nVMX: nSVM: Add a new VCPU statistic to show if VCPU is in guest mode
Date:   Wed,  9 Jun 2021 14:03:39 -0400
Message-Id: <20210609180340.104248-3-krish.sadhukhan@oracle.com>
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
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR08CA0055.namprd08.prod.outlook.com (2603:10b6:a03:117::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 18:53:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7eb5366a-1c90-4134-e942-08d92b77d4fa
X-MS-TrafficTypeDiagnostic: SN6PR10MB2510:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2510950C7B918792013C67C581369@SN6PR10MB2510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CpTOiPlV3EBbDMCrHZu1o6Zt+3eULUSz/ZO4Nmd423V071KC8YHhe5NocpOSsSyJxnW6wXN1liplOuT0nNVzGuRim3ryTjIobY5jWA5EUEELFygXBnqtqL5Tzd9n7+anDktNvjzPioT+LtkaIXjk5ZFXytUXb+Q3SLA4pVXW2b5ML/JCdvRc5UOV+WwZNEV5Q7MPouH5fSKZ1pKF8RxLrkD4WqeWOzeZF7aWLnGxmMnKO42QGRDMeL0nIGyNmXiDKpnR+UgsXq2SFMkTVP6/86pgS7R+WahoYJz6ulf4VGXiPJbsTlMt00isXGZWN1GuA7miTpAa3MtpwmU9KeNyQL3AmUzXlaXsQCeyc65879/O8qIeOBvarUEcSkAH32CG/GEHkb0mmatyY3tBMn7i5RnbNlKxFJ6xQkujEDbmj1LGCRv/LKyzLCQcXXwaFkFx4y+k3JDsrnRqHGgQU0J9i3CHaSuWFiqBwzucsV/McuCzOYRRgbW/KlrMGtXNHvoKUnPhHc9m6CcOV5BdlTrcCHPa7ildAJOoG8ssN3dNecup/1VdL+B7iRoM5b5RuAC/zfR7fgWo7CnGI5tjJ+0coIBxuArKolSoM5mb6hE9cQXUG8tNAvny3l3LPHOG8xI7DLKHoIgVIff1JUZulTVrHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(52116002)(2906002)(6486002)(8936002)(36756003)(7696005)(38100700002)(38350700002)(8676002)(4326008)(956004)(1076003)(16526019)(26005)(186003)(2616005)(478600001)(316002)(66476007)(66556008)(6666004)(86362001)(66946007)(44832011)(83380400001)(5660300002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zchi6K7dBi3wK8a6YcPRYSmfcnukG0WFTHnsE/hR7N2aFWDOwRzy2stmgMHV?=
 =?us-ascii?Q?7BhwHMbttG9nUi+gbezFP+lNEOgIFDCDMQ6psumlfEiRdxrU+0HYc0C2VCFl?=
 =?us-ascii?Q?T31V8soBuCMAQ1kpmcT0g+a9AcY7MHv/OAPLYVl5rjWMuBQWeeqlZ6gsPbX6?=
 =?us-ascii?Q?z0bne3gKu/spWbUtOEFT96llbq+e4VSAFzHnCVut/C+tQyfkw9jQeuRMGgyd?=
 =?us-ascii?Q?/w51FNk9pQ6u8xiym5teD2RQwqDacE+LwdbPR6pAJb9f9wJbxyKpzpxUcu3E?=
 =?us-ascii?Q?rqKE+9jDaAKgO/mjacsxdhj8KZrCBN4Ru06BCrk7l4hupeDwq05w1nq/nlK/?=
 =?us-ascii?Q?8bAP07Ssj/c9cbbYTiqH2vzZhxgWwWFFDLU0Uc44+Pcg+aJI3KBm2YdqX8LB?=
 =?us-ascii?Q?jA1xWD3udtvmG9Iyk9qqKYmazDRBSsm3DbIf43MGZkqB8sI4BFu7BihSFmuD?=
 =?us-ascii?Q?qA6CusR6KQKtT27VKLdoWBh2/MHpYnfuLaKvkMXheitlL+ENGGIa9Sajxb8Q?=
 =?us-ascii?Q?QZ+RMIehqh+OQMzdAbCHbXFguoOnyV8irbSY0GQoE8gYpZTym9/hfz+a/WEI?=
 =?us-ascii?Q?PNf88cUMAenKnt+lavSecpXuzAeVJsso6XB9wC9SXeegij0mbG6E3ZxTTBOc?=
 =?us-ascii?Q?NccFwxPQ7I6fGBWBgkh3z+JaI/myjIitePwHUP2ghKdQkJTob90gF6ShZ131?=
 =?us-ascii?Q?3fsGslYi9CZ73/4jUsruJlAnmKNoxD1Tt+qa9iMXgrd9MSkM19rRjrZ6S08h?=
 =?us-ascii?Q?4jhkhK52VvU5vhyxIUrty3vxKkoXQq0EoH3qzmoBZJkMWdUM7t6pHf8mmRbP?=
 =?us-ascii?Q?9vwT2zVxFpyvsJhU90DzaEX+lJ5ik+BJximMeolOd5742A8mKfWYbHL2Nsmo?=
 =?us-ascii?Q?d7w3QRXb6eamfAAX6+jCjO8tdPUmQcnIu/Ne5TIYWhicd05t+QLbZXtuEU+a?=
 =?us-ascii?Q?VN41SqRS+6M6mNIdv+WMwRFhaLJly97Cf49AS/Nwm+OphewtCaDb2lx/Sbaa?=
 =?us-ascii?Q?XHvDyNGBCBfMeX1Z8Dqx/v0p5/OxrfEMtQ4f4p4va39cmucRbyXQeQNsHfPH?=
 =?us-ascii?Q?iQIZJ98Bov6pkEyQCQBt5+eouhc3lQG0U8kUXdu6dYQQwScHfTKCLNqUnXBu?=
 =?us-ascii?Q?LcCr7AHOMsfbAFUbP0FYS08MvIsz95YOkP7iba5MkYwkY36IFMuO4OE2solJ?=
 =?us-ascii?Q?A7eQMg58kUbboW7HCH0xB1202/iNpLXusLnUzaFoyhd9ch6HXeE5zI3jeuMY?=
 =?us-ascii?Q?jf/sawKLjjSv+fo2esHhDt9eGrbQ2XMunpaXLjMjSYhEcoVK7tdMLi5hL9mT?=
 =?us-ascii?Q?esn57y584g0xaWv46CmA7mlo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb5366a-1c90-4134-e942-08d92b77d4fa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 18:53:12.6340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pi1y2uKuGBDVZqhSLofkaQqlZfp11m7zKttIOmukr8RhfDVX61Rj4hGxqlgrIIpeyo2ph85LDWAQJjcQgDSt/wyS6lunl/DXPLQzJ+uTFlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090096
X-Proofpoint-ORIG-GUID: vZ0KLkk07ICLGxGSE2VfjVjr75F8wpkW
X-Proofpoint-GUID: vZ0KLkk07ICLGxGSE2VfjVjr75F8wpkW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following per-VCPU statistic to KVM debugfs to show if a given
VCPU is in guest mode:

	guest_mode

Also add this as a per-VM statistic to KVM debugfs to show the total number
of VCPUs that are in guest mode in a given VM.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/debugfs.c          | 11 +++++++++++
 arch/x86/kvm/kvm_cache_regs.h   |  3 +++
 arch/x86/kvm/x86.c              |  1 +
 4 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cf8557b2b90f..f6d5387bb88f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1173,6 +1173,7 @@ struct kvm_vcpu_stat {
 	u64 nested_runs;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
+	u64 guest_mode;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 7e818d64bb4d..95a98413dc32 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -17,6 +17,15 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
 
+static int vcpu_get_guest_mode(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	*val = vcpu->stat.guest_mode;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_guest_mode_fops, vcpu_get_guest_mode, NULL, "%lld\n");
+
 static int vcpu_get_tsc_offset(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
@@ -45,6 +54,8 @@ DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bi
 
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
+	debugfs_create_file("guest_mode", 0444, debugfs_dentry, vcpu,
+			    &vcpu_guest_mode_fops);
 	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
 			    &vcpu_tsc_offset_fops);
 
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 3db5c42c9ecd..ebddbd37a0bf 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -162,6 +162,7 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hflags |= HF_GUEST_MASK;
+	vcpu->stat.guest_mode = 1;
 }
 
 static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
@@ -172,6 +173,8 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
 		vcpu->arch.load_eoi_exitmap_pending = false;
 		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
 	}
+
+	vcpu->stat.guest_mode = 0;
 }
 
 static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d1f51f6c344..baa953757911 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -246,6 +246,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("nested_runs", nested_runs),
 	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
 	VCPU_STAT("directed_yield_successful", directed_yield_successful),
+	VCPU_STAT("guest_mode", guest_mode),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
 	VM_STAT("mmu_pte_write", mmu_pte_write),
 	VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EF73480BB
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 19:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbhCXSjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 14:39:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237686AbhCXSir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 14:38:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIPqO7047526;
        Wed, 24 Mar 2021 18:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=dyX7Z/sm1wFUhxRuIDoHhXtN3HGD+gw+OWnMFUMsc5Y=;
 b=REjmLRh81rflq3eZGVOGpFrJK5z/wvt8Nq/LkNnxcy0wcZB/Te6wamnT59Ah7nWhpbNu
 xzAEQh04bQWUK35Zv6iIAS2oeH/Nzh6qOQRkLS5K1PCkMFZV7vEK2MlU5lSVslWjFJ4r
 hcFn9hu7Cc23NpvE5awOX52xLg5N+4SvqArBJ09ITwrEruVveEf4ElRPfmn8W5xkvkLF
 EjW+xrk7o/160sbdJ6FpptVByKp7EzSWS24v7MQ4YtbD0HUO+fcZaN/RnAXUgy8wALRq
 tMxt6CfdlB8A4oDChnwnJdL7KxJgovpkkwz9P+Ixi9wf6SnZsASNI+VDlwXQO0KQhkVp 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mktnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OIQFYK167607;
        Wed, 24 Mar 2021 18:38:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 37dtttpj5x-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 18:38:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZK4Z71fg+ymP0vNmEUTTujZ6s/Mb6p8NN3XfRC4OSO8B/ka5BFW7ggs+DIE4PM9GVpn9AbEXVp09JsinI5Hb9+PKgsbbMgsiCyiAJJDvIMSQf5pksvza1MwTV+nIeWupLrxIINHIFyrJm7Gm5sYwRkmsEeeDomELlAK1GNkxlCvxwGe/3HUfyQjpSfLlydncKY2rbuPdjxJh0ljuinzt9q3/0wiv9kAyXKCJn5lYHBWhgD7FzGT6qBiAHzmpfLcwNagW0FrAUmmjJt79T0LCdtQOqjAsTLPp0zCjbXiPGPsCTmmPKk7HMxcVWq1Qig8HCrDaVc4vmiTR7PxmGne5qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyX7Z/sm1wFUhxRuIDoHhXtN3HGD+gw+OWnMFUMsc5Y=;
 b=RL3pYnH9JqqVj1BgawxGL80aVCpndOOXEYt2hNLj4GMRBjUHrTpzoso5tKKunz15NZa01So3bezknp81OL3NKU06K/fl4yQhBVYmxP+VqwQT09oXy300f2bxuXQ9gXhp6iYwAbv2cXpMJ5hJVVnhSP46B50tJ1BIdvCXl9qWISuhMWKrxrZDM4pDzfzQxdq+evYArAyTjEHlB1JNUZEBfv5Kb63UQc1q/1xWfgSculbehOY9PIJ1NmXg1K7QUMVbvMXWtxZXvFpTHOgZJWGvfeTLH4gY1mFvDANNGeJv71gIEiwRLVKCOd6nTT2atqlH/nDNmRgi+X661lJpaAH36A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyX7Z/sm1wFUhxRuIDoHhXtN3HGD+gw+OWnMFUMsc5Y=;
 b=EaooH/0e04iKJTGsgnF/+pu9fKXbcCTKtKyeV38/iU/Sc9hxAkNRxGVVQYQ51w8iQnhN0V8DmsU6876IC3FYsFr6kjrn8rFEtZtKXqdSdzVQr7RL3e7wY1RdkBw6zTgwLT72p5LoHSmQ8l98TXij5TmnLz8IwAC+4gqfeuo3QbQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 18:38:43 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Wed, 24 Mar 2021
 18:38:43 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/5 v4] KVM: nSVM: Check addresses of MSR and IO permission maps
Date:   Wed, 24 Mar 2021 13:50:03 -0400
Message-Id: <20210324175006.75054-3-krish.sadhukhan@oracle.com>
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
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:c0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Wed, 24 Mar 2021 18:38:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82019940-9176-4428-da8d-08d8eef40cf7
X-MS-TrafficTypeDiagnostic: SA2PR10MB4665:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4665D70C7D3A04FC96B52BA681639@SA2PR10MB4665.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2giGfAJ8SyTIxfCNPizuUVz0082XszKn7PYTPF3iF9lhv5d82YK+inJi/cnZv92R4ZTYfY7SMkcBYlAZUbwFx1TmSdbkRM7TlmODgk3S+7Nx3v0Gb5TiF/r4JQKVvIkitOhuUHKe2kvGIBvMMZBaTkGRiMpODYwpwBlhmqQDLdu3taHwSiJLCKqGEZyJDXpe5Z3+SLNyqRqgSOGruitAo7Q5awDhUiFZqAdr8DbCRCrcsesJ71WCxci68VrMZtRRDnbCJ8qnIaUd3IYhwAu/q9sflpXcpmJATZYVeJYAoA3PRa9sFafA66l/k8M+nNlY95/ZCFCxjyTU8K+2XA+Tko+52+qbGh0tdhATQbRKJjOJ68DNaoG5HtnVF1EcepxxJ6QnbvQ4BvUaqb6evoW/8/xxsd7VB77EjYfzbU/YsOycuAZaTdTrxMUduJx2avDQcdIcN0AB7ikoLgVBPcUdzqfsq7oeJ2UBFpy3FaRek827qi2U1qN6SDb0XpguFYjRV221wQaEGDkB3+exWnsg4bcqP5ibREIaxjGHi1w4niN9AO73dueKG3Kp07Uk5XJ1g+IaZTNf1ijvFCHdIxp8qQy3wqkAeARIkGM7IZOsWDrV472qz23l9ij/p3xXXvaPsp8mrvaTLGWBNI0412nrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(66946007)(6486002)(36756003)(16526019)(186003)(478600001)(6666004)(956004)(1076003)(6916009)(2616005)(8676002)(38100700001)(4326008)(83380400001)(44832011)(316002)(66476007)(66556008)(5660300002)(2906002)(7696005)(52116002)(8936002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AE/VZaI36DEbvo3eGK8J1dJ4xn09n02Xpc893QIinEkEkr8ESZBzSsLEonuu?=
 =?us-ascii?Q?aQUIgsHx8EEvjOqycsh/QIbmCO8x3VBRWO+4Zk48m0nRD5CQfcdthjSvNijd?=
 =?us-ascii?Q?L2CMgcmHSWqunQlAb/wDsDPK7N87IMub/59C/F+GrYNGMVgQWvskRvGUKiWm?=
 =?us-ascii?Q?R9ly3u3vzSLnMu7uHrK1kHoAKSZCktU4ryNLPH18aMxWqGiZqYC469bKjQbi?=
 =?us-ascii?Q?e7eFb9xpFnAoTJoRYuYRaudE/UA8kUnZBzaC75h6u2H2+QDMcvINaFNZmdMB?=
 =?us-ascii?Q?st9vRI1D9yIk9E3ayW4WiftOAfpjZULUFUu+UcxQL/IYAyWbzHVD5fn14Ejh?=
 =?us-ascii?Q?eG3fMdeAMgpRI0UXjbS66nzYw5EUBkh5JH1vDFe9vit7sBdhdUxsUf/54BGp?=
 =?us-ascii?Q?vkau+USesSBFo7gO9HWJr5k9TJRMxvEHY19v9zC4KVb/x85XcCq+5s2rD1hT?=
 =?us-ascii?Q?YOwSVubE7JHAsjHVyLp5wZrfZ4qblR7UFks4ECjWJFx73o+SjFoYBjFFvpey?=
 =?us-ascii?Q?O2Z7upDuggEL0xRF/qBixr9E4e5WeepUwNua/pfDL4uipt2lCjZCgHTB1hUq?=
 =?us-ascii?Q?49mx0X83eCTOamT4RXdCntzbPYAYF0Yyo2r2dRp9RITBltwom1N7YSanwZCd?=
 =?us-ascii?Q?w7ONDq/oqsoPbfx+VaDk1zagXMQKnAd2LnYHRg7mEFPU5Wdzq8uuPCmfgkit?=
 =?us-ascii?Q?8//sHGMmmb4rqrDrua+1NfzVjRUtGPxFdKu9cBnzKiiY9gKqzWMs6s8P11rf?=
 =?us-ascii?Q?4YRhliZOmzVpEKlwWah9yMsXzzGGdwuV5iTrL4Ge3qLE3ALXoL5A5ICPYRLk?=
 =?us-ascii?Q?XoYGVYA6NFAXPBctYnqNWdkqpwudZI5bilZvBd8Dv/8cTJ2dN/fJDTSfzQIr?=
 =?us-ascii?Q?nfNfy/FiEp7eMYjdC5pYtAESc0DfxAcxvfjL7YbhliD9/XOLsKblWBYr2gYv?=
 =?us-ascii?Q?A3OOoRbXwPWIup+Supw2v78BPMXswx53rrB6ZNUPRS12o9gh4tkaKY7i7F9c?=
 =?us-ascii?Q?Dgf3CB0pASQnAQkRKPUWs4xhAqvidLZGenVtljI46kSWpIc3F9mYHuGp8+Gn?=
 =?us-ascii?Q?SgLRCsvVK/ulSBM+2qiin3klS6cIFO9idq8OjFN+CXCvKCpipp1mx7bzNlX3?=
 =?us-ascii?Q?fS29hjaKAwn4/GWnJ/LUGBslUAlI+YkTBUlkcbipnXiKCv5HmRZ5jx9UrbTA?=
 =?us-ascii?Q?RdXrbAn9RSh61eY+CJpfOc/B4yy6ebHplN91kx+lNHaUTBSG9hGWDWhBxFws?=
 =?us-ascii?Q?ZSduIjZgKH8sCyQhIPWnVorsVQNVPtfF3WAt0ip8z5d0teJV5feDpvBV+D8o?=
 =?us-ascii?Q?EADayfv+3mH0hhRZNRq0t37f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82019940-9176-4428-da8d-08d8eef40cf7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 18:38:43.1615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gye4mnQCOMxar6lGEBQy2tgoKdo/IBoqa6WPF2gOmrpq6scM7e9jWEeunHmVRWVl3dQ3JQRoUYIGvu90YqHXDpzsb3ku8ECRXgtezmG4/5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240133
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
index 35891d9a1099..b08d1c595736 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -231,7 +231,15 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
+static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa,
+				       u8 order)
+{
+	u64 last_pa = PAGE_ALIGN(pa) + (PAGE_SIZE << order) - 1;
+	return last_pa > pa && !(last_pa >> cpuid_maxphyaddr(vcpu));
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
+	    MSRPM_ALLOC_ORDER))
+		return false;
+	if (!nested_svm_check_bitmap_pa(vcpu, control->iopm_base_pa,
+	    IOPM_ALLOC_ORDER))
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


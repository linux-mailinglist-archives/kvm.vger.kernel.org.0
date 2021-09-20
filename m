Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814C5411302
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 12:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbhITKkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 06:40:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44554 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236113AbhITKkM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 06:40:12 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K9rDtD028205;
        Mon, 20 Sep 2021 10:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=AINhbha6E3GTdJOoRKH2ne8Q4O6aSfY/BRwpeJacKqo=;
 b=O9VQ6aMxGEwO6bqNjXltjSZRxs6JF1uceFnh6HjvJ46xcFRiDAK681ev9RcIIHZA+Nin
 6RRJLk95leHeHo6KrCjZg5w0x+LxfWixbpcEJXtEV3SSrKd0V0Li5gZ/jerikpHAjaZk
 XIcrgPBmBSxvbH/4BpF1+tYbSewlE2nWBGVSlYZwsaaBp3u/BiqTxkVkbYp/Ornb49yt
 7WPUFREMS9aXdFzOSCRll5dK+LCqeWNp05bFxxfSkEHG8WyPO8pjUkUSo7BDYAVkqTEz
 tgYdf2EQBg+BloDhl45aKSKOfjjlTTh5CZNhlRayIVvfHm9jos7XJaM2eyh8tvUXwlrz /Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AINhbha6E3GTdJOoRKH2ne8Q4O6aSfY/BRwpeJacKqo=;
 b=NsBxOy0mZspd5/EHmDVLbdwr/XsPtSOcNklqszT82tYg4010l1k62X8yBJ3lqv4z6IE1
 19sR4WRxGud4jJ/0E8C3aTFDS0YcJHcsXC1hmia0xtxhm34k8byaQK0Wx01ViHqUpmMZ
 ZXGK5BdYHweN5w3NbtbtBDgyPjhdJyhExu4YGERSx1Kd7zlIeBAdA//Y99ny/JmobgQI
 GV04WeewUzUQulF5Z7IauvoEx+rzL0KRpcStc7ThZm/Ads6obcokj493m9INBZ2LzKUj
 kw4HFE0B5r13i745TkeP5+Kd7VaJ3Kn59kCUJTkvyGl3dcmS0ZlBZaJdALbAJ6TbEhga +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66wn1vs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KAVTOp106020;
        Mon, 20 Sep 2021 10:37:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 3b557vbvc6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:37:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JoXOYRGudOh1mvSuEkQasBElgyMgW5eEYlZWFvOo31iXpAmiVC960B6kVcM+a2PLyHOGFN2kbvDHBS3IAcIEYOTJtvhCCwR6UpQOBbet6pLDsUrZBDPd4rgAAs3ITArDEoYSSBrQ+4xUWT5XS6zHcT/QVw41E3o9CZUuGPKJGkjtHrcyN4+pPI0rvB0BYUjnTa7D3pc+ds9PHY/5mLQVyVqyo5a2tkoAncycI3Hxl3OQBe7LsD/aenmFioqR1CyE/FwkpFywF8lO/4PMMxftryT7AZrtSU50TO7HvRdeeIgLxsqr+bMHUQtDNgrO2SVDGd27CtqicF0cMSi3e74acw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AINhbha6E3GTdJOoRKH2ne8Q4O6aSfY/BRwpeJacKqo=;
 b=fQsqyn9YgNuWs1KfcT/UBmBYu7N4RWtRL5HPXCklYg3UBUqN1H2FDuYj0sxhRsEGcS2ouwRPI61UUPSCMh0P7tTl4ESQX2aw51Iq0twsDydU4pntWE8x1MHt8/UgBjfwuFXvHUswigOjtvxRC/61U8xY4nfXHzcYbUjCDo75N8XwnfpkCnYqQsGJfcGvZ09tl3U9Hzyq9bibSMxp8of+y0i7p5a6L75lo/MH98vNZw1osd6FYYYuwaxR74b+ImzBYwG3g2e2KxJRZH9niVqeqffkFNTnH5tK78xIAf5HveVVBH5ogLEixg5zuVCUg9ODiOQ0J6IqPxT9uTjFtV7u2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AINhbha6E3GTdJOoRKH2ne8Q4O6aSfY/BRwpeJacKqo=;
 b=bIi+p1532lkqrvFV3OTPjd0nbp/TOeOFz7vOgq7uIUbi1sDvKu18RhRx7BPJqU3HT3REuRZhuVwfXHmKLNGrc+ZSyentL//8kSBKsn36ZAf6CPBS7QMznFmBC5hR409FucqkU0tjbJyShw9DHph4Cos4buFkggzUu6da9XtoRpg=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3308.namprd10.prod.outlook.com (2603:10b6:5:1ab::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:37:47 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::6124:acae:c33e:1708%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:37:47 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        David Matlack <dmatlack@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v6 2/4] KVM: x86: Get exit_reason as part of kvm_x86_ops.get_exit_info
Date:   Mon, 20 Sep 2021 11:37:35 +0100
Message-Id: <20210920103737.2696756-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920103737.2696756-1-david.edmondson@oracle.com>
References: <20210920103737.2696756-1-david.edmondson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0149.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::17) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0149.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:37:44 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 1e34cf3e;      Mon, 20 Sep 2021 10:37:38 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91a5a7e6-a665-4d79-e601-08d97c22afb2
X-MS-TrafficTypeDiagnostic: DM6PR10MB3308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3308ECA487BC1E484C830B7E88A09@DM6PR10MB3308.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gUDBsWLFJkKJ9GNDcnGbKo3oyXGWPeZ57tAxcNkPJ5bSVH8csyX8txvhaWsqe0OsmoKKVRNXPA82/VGn9zuX3rS308m8JlNe8J8tK5aNxSPDHoTJQ850k+3g7oeMUZx3R6jtg0EKdGZWwgYHLt+/tcochcPylfED/2VehIC/+82VfmFrMhD/3A9VuqgSz52xWIx7EaeGGlQLOdQhz1+3RpIM7BHvWRdVS8VJYasdbysp+B5xB3g2eF5oAXd6x1RJrzgC0leTElZt2KqJizIVSwZvTQDii+xJ/Xu0P6uLqgmzjEf2+8u31z+xERdwan+1lLltP7xo6873B1dp4VngBax6UO+vQ4/lMnhdNAqSFYz5chGYc6JEt9FoUiLBwXZn8tRfl1QYUb/hJymZ5qgUFz2yhD/SM0CxJjXevmWEhYYSNckb8kjiCJ8cArMPomWmiL9j4iPIsHYK2QTPgLXQy9pHzE6M8tEz9w/NASuqw80dc9TBDybH3n/0HWXK9H9GR4pEVOs5e1kFhaKgjAZomMqLpELuAGYNQEF0HXgmJlG36b5wUjA+7KKc5oIsZibWL2CC20KLKECY07EGKKEi75L0/UrbbFXco3kc+2b9IrNeoghirAW0VKNyFIF49EMRdTw9GfEODEwJzVs/oeQglw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(44832011)(36756003)(107886003)(1076003)(8936002)(7416002)(8676002)(83380400001)(186003)(4326008)(52116002)(5660300002)(6916009)(66476007)(6666004)(66556008)(2906002)(2616005)(316002)(38100700002)(54906003)(86362001)(478600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P9cf1i8HkJt2fPLl0yZFYS0SnSZZaUBbGLU2yRx4VgvxuAOSfCLNZVeKmG7X?=
 =?us-ascii?Q?6pg1ZEuZ/d6umrxwhavnTrZTmFfsTD6fbAStI9YjIfNgQMq/ipPUbw817v+W?=
 =?us-ascii?Q?JZgxYKzUCJalDehU3CeWaML9UxiOhmP/61u/wqQVzk4bBaxxNiCseWNf8JWB?=
 =?us-ascii?Q?lxTblIhykJniozuTlYDWLGr3KAyCRgdsr8PWCE1/zunaSTrXkqB5Grmc8MRL?=
 =?us-ascii?Q?1zLF/ZHomFs79tFsf3rN27yhu8Rc5D2HGGKZVCgw9S47SSh6TCuDgFYYWTBN?=
 =?us-ascii?Q?rWf8mTqgnsaS0gZ1t79B5oOuH4DF9etwidkmAEqZR0GHb10VTR3RuvIzf4Fr?=
 =?us-ascii?Q?/rgp7VQkNtee4rLtpDeI4DyPp1ABt5YwgCzhB473RqOx3b9ncuDpEu0GPfC2?=
 =?us-ascii?Q?m6wekf6ZjjW5lQiQm3WD+LqXnfVQfxFLcWWGXhRyU1Lr24hNQDrqWZqpvC+t?=
 =?us-ascii?Q?pqvqCRP6swHIfXsRyHZYpuuYavd4xXhTKNfbJr0MljB0Inq4+z7YswcI7dnc?=
 =?us-ascii?Q?iH2k2zoG/MBFe7EW0lVqk2V8VaDBVcqTqfgooQzrYnX5NZFlkf/tJu2fj6AI?=
 =?us-ascii?Q?TzQs8Elb19OSZfTNCZFjUlmyn79WvK863q8GiRQZMK0hkfVFMcFnPr2DCzg+?=
 =?us-ascii?Q?sqSsM07zBgMRS1/6XuhmK97Rpy+Sy0TLH6HNdKduHL74848Wnnb6FntO0KXs?=
 =?us-ascii?Q?fleE4Zffd1RmvyHGSviGyEKP9MbGHJDia0HZWfHfFdli/50VeE70q8Ca1wks?=
 =?us-ascii?Q?b7/FCqMp7kGBf0Jln4PM3R57UzzdlivHF2Zug5+0NUQ6lHrK8DQA77dcybnB?=
 =?us-ascii?Q?vw1c6lwv+mL4M/RtpjeUEFdLVSNObV737qRJwAk4sDa5ZnhzkJSFTyj8/kQD?=
 =?us-ascii?Q?ktmGiEqqTH4AfEEWvquQrhGCuLsDnS1sXIPiHF4O7vkFDwcGpgQH0gNczWrS?=
 =?us-ascii?Q?Qf8YV0kzQMiB4IIBwzIHCdiEH9UxThVaRlXdYh8qikwq4/lc55amSvMjlJnj?=
 =?us-ascii?Q?aPoC9K9oGqen04LxAPqncnd5WXgeoGN9+zG+tnBFCdiJdNFwXSzxIE13m0U+?=
 =?us-ascii?Q?r3AnHO1uQ5bRK7D/PTntW9WYyXzbwdMXrCk/Nv3UcA5rdQVCDb++YwUZQwQz?=
 =?us-ascii?Q?IVp6EQzQIqZDJu2NLS53++oPgRM/pfEvNfAf4vwNxdswzHWv/4CcBiAoPF+m?=
 =?us-ascii?Q?8oK35xyD11oVT6ddRZmQvtFg/WkdWSYjv86dozIw4y7EihTk6PnoUbNPMQf0?=
 =?us-ascii?Q?wH218ZFE8uMhEHJ+sPsmJOmOn+gfIQCj58S1SSF9bR36O87xmS28qcLIEOD9?=
 =?us-ascii?Q?6tgtsvDd9jcuYFo1o8QJmg4wGNBoa4AAP3Sa6+F++aAvEA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a5a7e6-a665-4d79-e601-08d97c22afb2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:37:46.9344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2QB62Gyz1HEf8Xn1IPzMxuIHsP9V/9kga6fhrbckg+EXQOr9Hx3eCNCE666UqJtWZWDbDC5/OD0+kg/cZs/NwnjbwacRO7rYRYwZrxeNEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3308
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200064
X-Proofpoint-GUID: 8mP0FWU29PPAm1HfgFKy2qLwjCoUgIlI
X-Proofpoint-ORIG-GUID: 8mP0FWU29PPAm1HfgFKy2qLwjCoUgIlI
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the get_exit_info static call to provide the reason for the VM
exit. Modify relevant trace points to use this rather than extracting
the reason in the caller.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++---
 arch/x86/kvm/svm/svm.c          | 8 +++++---
 arch/x86/kvm/trace.h            | 9 +++++----
 arch/x86/kvm/vmx/nested.c       | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 6 ++++--
 5 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..d22bbeb48f66 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1405,10 +1405,11 @@ struct kvm_x86_ops {
 	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu, u64 multiplier);
 
 	/*
-	 * Retrieve somewhat arbitrary exit information.  Intended to be used
-	 * only from within tracepoints to avoid VMREADs when tracing is off.
+	 * Retrieve somewhat arbitrary exit information.  Intended to
+	 * be used only from within tracepoints or error paths.
 	 */
-	void (*get_exit_info)(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+	void (*get_exit_info)(struct kvm_vcpu *vcpu, u32 *reason,
+			      u64 *info1, u64 *info2,
 			      u32 *exit_int_info, u32 *exit_int_info_err_code);
 
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05e8d4d27969..a902a767f722 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3272,11 +3272,13 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
 	return svm_exit_handlers[exit_code](vcpu);
 }
 
-static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			      u64 *info1, u64 *info2,
 			      u32 *intr_info, u32 *error_code)
 {
 	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
 
+	*reason = control->exit_code;
 	*info1 = control->exit_info_1;
 	*info2 = control->exit_info_2;
 	*intr_info = control->exit_int_info;
@@ -3293,7 +3295,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
-	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
+	trace_kvm_exit(vcpu, KVM_ISA_SVM);
 
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
@@ -3306,7 +3308,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
-		trace_kvm_nested_vmexit(exit_code, vcpu, KVM_ISA_SVM);
+		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
 
 		vmexit = nested_svm_exit_special(svm);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 03ebe368333e..953b0fcb21ee 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -288,8 +288,8 @@ TRACE_EVENT(kvm_apic,
 
 #define TRACE_EVENT_KVM_EXIT(name)					     \
 TRACE_EVENT(name,							     \
-	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu, u32 isa),  \
-	TP_ARGS(exit_reason, vcpu, isa),				     \
+	TP_PROTO(struct kvm_vcpu *vcpu, u32 isa),			     \
+	TP_ARGS(vcpu, isa),						     \
 									     \
 	TP_STRUCT__entry(						     \
 		__field(	unsigned int,	exit_reason	)	     \
@@ -303,11 +303,12 @@ TRACE_EVENT(name,							     \
 	),								     \
 									     \
 	TP_fast_assign(							     \
-		__entry->exit_reason	= exit_reason;			     \
 		__entry->guest_rip	= kvm_rip_read(vcpu);		     \
 		__entry->isa            = isa;				     \
 		__entry->vcpu_id        = vcpu->vcpu_id;		     \
-		static_call(kvm_x86_get_exit_info)(vcpu, &__entry->info1,    \
+		static_call(kvm_x86_get_exit_info)(vcpu,		     \
+					  &__entry->exit_reason,	     \
+					  &__entry->info1,		     \
 					  &__entry->info2,		     \
 					  &__entry->intr_info,		     \
 					  &__entry->error_code);	     \
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ccb03d69546c..43ea97b3f8e6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6059,7 +6059,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 		goto reflect_vmexit;
 	}
 
-	trace_kvm_nested_vmexit(exit_reason.full, vcpu, KVM_ISA_VMX);
+	trace_kvm_nested_vmexit(vcpu, KVM_ISA_VMX);
 
 	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
 	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5ae873..99f8f7c4a510 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5628,11 +5628,13 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 static const int kvm_vmx_max_exit_handlers =
 	ARRAY_SIZE(kvm_vmx_exit_handlers);
 
-static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			      u64 *info1, u64 *info2,
 			      u32 *intr_info, u32 *error_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	*reason = vmx->exit_reason.full;
 	*info1 = vmx_get_exit_qual(vcpu);
 	if (!(vmx->exit_reason.failed_vmentry)) {
 		*info2 = vmx->idt_vectoring_info;
@@ -6769,7 +6771,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (likely(!vmx->exit_reason.failed_vmentry))
 		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
-	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
+	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
 	if (unlikely(vmx->exit_reason.failed_vmentry))
 		return EXIT_FASTPATH_NONE;
-- 
2.33.0


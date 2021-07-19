Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F7E3CEE4E
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359129AbhGSUeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:34:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54144 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1383542AbhGSR4V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 13:56:21 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JIUUQ6006909;
        Mon, 19 Jul 2021 18:36:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ejz4N9VaA+2B3m9yDYZuFUikLoLLOfqfcBX/4xFP9fw=;
 b=hhFgIgFQS68nPNI1F8A6qEP/5waIT13/kgzokfCUgi7gnTvo+CtEs4MruHKBKY0hZ2MX
 M9A79jeZ/y8WzKkGkwle5Xuna6oUq8gd+2i8sAbGpkGTd/36MVHyDGMeW9S18Z17OKEA
 rydEAlXmhOQorE7kUAu0HuDe2Ypjj817b+CPfxodfi/1sLK1GRXVpbeFCEtngcH6tW54
 wLAG51YOTEmE+G/we0IQ8tBMmH/eEzMuqZZhYjvav3NTz+iRgMRKm31arVdXT9Bl3fD/
 3r+43vRuP/VNY4pL5IudnXgShaKyppoH8P7scDinNMY6GT2xOBi2X2xcuIpEBZoDqQT/ gA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ejz4N9VaA+2B3m9yDYZuFUikLoLLOfqfcBX/4xFP9fw=;
 b=n61QqpgX4TwoVw8v/9h+hu5EEqjduzPB7E1OIzaXYWBssdI27J1MGZALcIo9kH51DREB
 pP25Kvb7M/p0PlOgslHsfnRBMI/rSRbFEDs6mh+46FSt9eKV+E3fVkC9nlQzasoYTas1
 YmR+KHiTz9eNJbdrSLC10dB29hjh7FsvhGOtvAGV5FNR/lKRJ1WYpCNPE+qzTc/3T25E
 4DZWZZtQ+tIb30nXJ6hAi4E0HX5t+48uaO11VTONZCBXNt65ZBVIm1MNd0d36jXUhY5h
 SDMLb+O/pBeAveA7rhXYBnP28Bz3hS+7b0AzagX3+qQReROnhNDUHZukY6NGHr/qhJEr nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w8p0rvnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 18:36:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JIV3T5136392;
        Mon, 19 Jul 2021 18:36:16 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3020.oracle.com with ESMTP id 39uq156kk9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 18:36:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHcu/HccmKAJkt2+qBQgKBVWeXFydMxDI5VVqq0I4HZX34jGXORWf35cVAkUdNVd903cf4+l65qXfc1SZwP8j7mynmeBXPq13Bp1VV+eUkER4qLuEM0+397Iy4b/DgWasSV8GtwfeYvBnkBIYyLkIhy+Ly82skEVQ0Bw10qtg5jcrFryvqdlPqLYMgqIqUhmq3JwOnBxMY1FT89nDCZ3kjPvYjUzdZmNYs4Yama3vClqh0xm++qZa250536eFbe+9EqxZxZVaJmFk8r84qjBrGaIiVasRAA3fPxd3kmWel/Vh0mw0IGRBBj51WDzvuTtYk8Yu9dYjCKFXsEGegYZmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejz4N9VaA+2B3m9yDYZuFUikLoLLOfqfcBX/4xFP9fw=;
 b=f2/4LBO8c2mhfl/WxPtq9vGXQhWAYpeV7Ph/L2mnvtcWPPof7fVG93sWxNPsyAgmq9ug/KCFnk4kDIOq5Ug9An25sM7xB+Rnl1B2UHqHXiv47pQ+4zF+QRtPL2AV6t1f+xC69D6igxn2Lv5dySYt6XpIRoRb+V0z5JuLJZ0cePqBifLsUWjXn+MX0GpBMyyHA8aFRmNzWbO8P63Tkt1iGSHZflD2jU+D+GXh6w8q+l8gCC/DCwUWOeWrUH6pfPLK9CKkUlBixIa6mUQSvx8/PgN7TKo4X/ZncC+nzlL5krlssMGZlVyevpSGPIKoKAIis8xGKYzor4QxZeJEnGXD5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejz4N9VaA+2B3m9yDYZuFUikLoLLOfqfcBX/4xFP9fw=;
 b=I82lPdQCpZQYjZWO8MTy69nHPlGrKV5XeJGDMe18pnIpUxaEHyezcbCQ62sz4eUsYlO42T6Ageh1uZaKLnGbFYlTWXCXlMJujeJO8/dykmOJKRl4GrsLhEVoVbOe3nH2GEc69D8zfdbbFOUt3z5QAlu7byssAW/vCuhFKjHYMqM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4538.namprd10.prod.outlook.com (2603:10b6:806:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 18:36:15 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 18:36:15 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 1/2 v2] nSVM: Add a variant of svm_vmrun() for setting guest RIP to custom code
Date:   Mon, 19 Jul 2021 13:46:16 -0400
Message-Id: <20210719174617.241568-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210719174617.241568-1-krish.sadhukhan@oracle.com>
References: <20210719174617.241568-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0066.prod.exchangelabs.com (2603:10b6:800::34) To
 SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN2PR01CA0066.prod.exchangelabs.com (2603:10b6:800::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Mon, 19 Jul 2021 18:36:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f503184-208f-42a1-021a-08d94ae416f0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4538:
X-Microsoft-Antispam-PRVS: <SA2PR10MB45381B2FAEDF3C827F46CD0E81E19@SA2PR10MB4538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4UZUcIwbp9SM2BePyS82CgHTkdg3JLkvPr1q5SUtUNOCyNsgbdVklnEBOZlcDtLxLH7khF7ajSl2VSC2zFRngIt6YUNpxXuXhPgWEfT+tz9ejhMQVOtnOBo/tssqeyuKfh5bHZ5gYAfj27Cdoqx34+CVRDwzn//IHmGrVrmERlx+GjXQp2bJHy3OA41wRlZq+WeuscsRne1dsVKqPiMIK7ZV2eCebvymRa+8l0cY9mpXnXUk1BxeH6SjZG4R53DBTWWHScLaFz2M72lkmXjxDcLQP9OAPGSDnlktErdd5CTTtaf9dwQnutK9cCzvvtLkTjnKNFy8mB1AwA/f+tXmqM12zcNItrK6tBU5wqklCaITxwxsaC7taKRs7pTJ8He+vx+RagLIGsfQsoYsxr+E0glaT7YxWmZ0IntORFZk5yDVOrcDhHIsEmuR8RTjgIsWlW5fMUou7Addf70W/ZN4x5ZnKVA6I67SONh+coOrYHy8ebQuCWV+Uh8PgGSkDkJkf1vzi10Ty8cbhxfZ2tRiawZzGcTod8UOgKqsrNlgZ7qNjRYiYvtHj/pNv/YY9JS7aJywIdg8K07Ow93ElNn/9mfVz93ttlNL6XKRSuRnnK1sDJvUVVk95IojX6UctuCjuioz3fXFXCAGv10RngLHo1jD3hlQfhkpzJ0pNP7Ej/oMPJ9De3KD9+UYEG4DOlHMcV8pmQVhETx9WAxoLcvxPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(478600001)(52116002)(38100700002)(316002)(38350700002)(8676002)(7696005)(26005)(86362001)(5660300002)(1076003)(83380400001)(186003)(4326008)(6486002)(36756003)(66476007)(66946007)(66556008)(956004)(2906002)(8936002)(44832011)(6916009)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6sKVFMkcmZ5kLTWqAqYjh6rUP5OdGkUlk1m0yb78DFlipzPfe4rtb4JIetR?=
 =?us-ascii?Q?3npOexi/cy/1HmZFhgZIKBXNwrONiz++MGq39G/4is7KuNAIBo4V82pVgYR6?=
 =?us-ascii?Q?Bus4r0yCamwkGBU46aG0r/BkD2gHeEnl0xp6c+Y6lj62ZbkA25TJXqXEAeSG?=
 =?us-ascii?Q?SNu85MR7BWatw7tUi3bmnffPpfPqnBkQhQpmHSlNxe+nA7TW0gwtlgWPFPDl?=
 =?us-ascii?Q?GtJWXOESUwKK1uLRUas2eJ0CGYrAclLsljxVDyu8a9hEVSJ43bxOwRy3Aedm?=
 =?us-ascii?Q?oRC8Ak6hZvDbEmUiIb6bzbqRlUs5S6DJThq70bAeRuSp64I5SrsaCi1TKnvg?=
 =?us-ascii?Q?msePPm8PyL+2p/b7o8pwHiDi5q8TiaYvYS5QhdU0V9s74BfxXA/dhEa+lxtm?=
 =?us-ascii?Q?RNmz9kzARtHsANtvIE9cOuNbc0hLdtb1rzCdAuD8ZDkwx46nkNCjoo/KM54C?=
 =?us-ascii?Q?UFvcKSFbS6L3UyHNUn/JnTomXbVuN4JqhQLn7U+5NcyD8cXpOxZuOzgDW4Sa?=
 =?us-ascii?Q?h4JXiWcugPeVdzoBfCwM+RbNCrEo6frdSohkSzV5deif2Z4lUO4Ga+oNYHzH?=
 =?us-ascii?Q?Vu6hhUe5QeW4exJex3nA4BpZ8UaqtVYhpDUeyfcp0KlGzNpyCY7L96PlJBQo?=
 =?us-ascii?Q?THGvkhXaSKkeiHkw2DXIrhfrAp8EN3iRTWwJSOQnhRat04Vuawn0pf7urPCu?=
 =?us-ascii?Q?aDaGKRAC5+Uz8hBXUSyYcpXDKYVcYnybeFyS13bLsB+u2KQQ4AF0E6pBQriP?=
 =?us-ascii?Q?sQfglgqGAIEoS211/ZY5wxWIR+IHhG3mdu3WOQi6dRko/Apn/T5tkx2XrzXu?=
 =?us-ascii?Q?5M1J4Sov36j1VPm3Dto088cYUHtG5TsLU+ZCnzvO1+cKrTcezupRtzTzDele?=
 =?us-ascii?Q?rem9fkbGrKkfzh9eASBiFHVcu5lkfWDfLK60iB+pAGZmSCRncTlV4f49d49B?=
 =?us-ascii?Q?Du8ZpMt068ulz1TL22LA2AzrGiKbBHqPMQHjDGs2j9eaLKCAi/Uv4fdBpwfB?=
 =?us-ascii?Q?ZLbPCWoHWerqvxkBA19KED55GBOfX1YJyfpr4PXri8AhICldttFJpHRM4SuV?=
 =?us-ascii?Q?0+O164OmSqOeZ32xNKIccSlo2jfN7qv06lcZ215T4qrBSXKYeyFfSW/Co7MP?=
 =?us-ascii?Q?4eGhGszJnwdoZSpXyO9hFvkdMApobp4Lv/YcuC+ea78jNs9bef+gB7jrkpxa?=
 =?us-ascii?Q?SLyi9NgC9Vuvp5UUHuCRoR67iZqSlGZtff+28wl/5E1WcdSdCbBTnXjNi+Jx?=
 =?us-ascii?Q?MYLSt8UPDdz1z83BKrVJUQxm/F7q/IjpRbb9/eL7E/auAzqzpVmf3aE9Egfy?=
 =?us-ascii?Q?vW57NGQq6+zuTjFBc5TTRwah?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f503184-208f-42a1-021a-08d94ae416f0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 18:36:15.0950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GpJmyjqDqmqDI8g0BSrQrVcZq7iWZ+aB50cWF6lhg4YYxBw2FKqkHzAtODT4F0Hw4VNSkxY03l9uDnS/GF3I3B2KhdZkeplCsTsj79AMnkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190105
X-Proofpoint-GUID: 72RkmIpZ-mXM16h07r-ym_-wIYxO6JY-
X-Proofpoint-ORIG-GUID: 72RkmIpZ-mXM16h07r-ym_-wIYxO6JY-
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current implementations of svm_vmrun() and test_run() set the guest RIP to a
wrapper function which executes the guest code being used by tests. This is
not suitable for tests like testing the effect of guest EFLAGS.TF on VMRUN
because the trap handler will point to the second guest instruction to which
the test code does not have access.

Therefore, move the contents of svm_vmrun() to a new function called
__svm_vmrun() and add guest RIP as a function parameter so that it will
set the VMCB guest RIP field to the memory location passed in. Call this
new function in svm_vmrun() and pass the wrapper guest code in order to
maintain the existing interface.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c | 9 +++++++--
 x86/svm.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index f185ca0..4b46281 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -227,9 +227,9 @@ struct svm_test *v2_test;
 
 u64 guest_stack[10000];
 
-int svm_vmrun(void)
+int __svm_vmrun(u64 rip)
 {
-	vmcb->save.rip = (ulong)test_thunk;
+	vmcb->save.rip = (ulong)rip;
 	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
 	regs.rdi = (ulong)v2_test;
 
@@ -244,6 +244,11 @@ int svm_vmrun(void)
 	return (vmcb->control.exit_code);
 }
 
+int svm_vmrun(void)
+{
+	return __svm_vmrun((u64)test_thunk);
+}
+
 extern u64 *vmrun_rip;
 
 static void test_run(struct svm_test *test)
diff --git a/x86/svm.h b/x86/svm.h
index 995b0f8..92fa277 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -408,6 +408,7 @@ void inc_test_stage(struct svm_test *test);
 void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
 void vmmcall(void);
+int __svm_vmrun(u64 rip);
 int svm_vmrun(void);
 void test_set_guest(test_guest_func func);
 
-- 
2.27.0


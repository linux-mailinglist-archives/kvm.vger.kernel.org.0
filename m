Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4D13A49A3
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 21:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFKTyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 15:54:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhFKTyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 15:54:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BJkC7e131598;
        Fri, 11 Jun 2021 19:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=zgvj0Rgs6QN6ODmwwU/jT/TjTfpZoy9WiLAFflid+kNRXlMp+pH1uQzdxbDnSrHzyOm/
 B8VocKTj1XUaYzoLKP1dKX3gCMM8OEMBZ8EL86T7+usn80yZ1fpxRNQsvROCYgHvrHg9
 tmQLS/7yy4t+L8Co7Xg7CDn/rKt7qpDtVMoStQ7ShAjnOo8lNPRb7thRknaKzqofdwhX
 LEv/beV52a1KsTsm/S5HbkdFFfuTwnrGssNYxoHntzZSFQK8J/C1g24zj7lhUcrxvhDV
 zbrT7ZddW4+V8Z59SSt6I7XkrseNAZFDFd4bnxMQieH1wHUn2FPCFd+/w6ZbkGD1NKFx 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3900psfkb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 19:51:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BJomsQ048061;
        Fri, 11 Jun 2021 19:51:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 3922x3ecgr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 19:51:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXwSiJco+zsEoEiSEkiiUoGs0Sn61LfaInDoiaLeTLHH4m17leMGunj7HK+qeGzA3sopVVZuTqG0Di7Nqf56ksjrTKYNbGstHmiqmAuZYW8QZn9G4mg697QBmTsrn1BapcK8cXMQy77OkiympcANc6+mTwth/BzYKCH7V9nh+Rak4X7gIUC8voN6Lcoo/3W1d2/mMEY8XUN7J5H7v+tYaXwPYTQtHe1Kd4MuzOpj3BZwbrPVsFADtykFSS2FpLe/aPFA4iRtYjluVnXXMJdN3Y54K7e5qWAiafiLEREliSLz/fcEO0xAow4d2E0If37mMnmIFDaNSwxdFJ0+iCascQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=dCn/Ss0WgMigzYfnDunLogf138EgOEyTkd6p1w/aloRM+oVa7skDL2E5yLg4hCato25j4FvA4CWnt2LzKY4w7TKBZ3jp41dRgIbrDxEUn1fn4odfMpEFqsqaJEhFJBzUTN1lyCoYE9bqvQ0ns6wjdfY6PNUmJWV1YahOzN1dFDuZHvsdv75KT2vhrlGhQQg80PUqX+AkSOprS9tuZKEAxf6RSc4iZfhFhDd3gkyB6s8brH6PW6l0DKwo3hn0KPQYQsugC5RIGSR+yJUfl7sBP727H67HAqy1AQT6d54Fj8UQmtxmO98EU0WJ7lt1dIcuVKta9oYpQwRImkhEM5trSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=r7zblnKPBBwHSzTogplnL7OyrYnTg1d1t5HOe99ThLIPHlZTe1DVeQKJ+V+qgktTnWe7ZzBAV4xAy2UKJzDL3+LJtCtjMxtHx4c8YH7Z3++cMT70UT6HNWmFaA9qmw3OlkkGOSuiIW6P6sbPvYG7xe2NlLA+vqyi4uJ5RwUwgyQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2944.namprd10.prod.outlook.com (2603:10b6:805:ce::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Fri, 11 Jun
 2021 19:51:19 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 19:51:19 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 1/3 v5] KVM: nVMX: nSVM: 'nested_run' should count guest-entry attempts that make it to guest code
Date:   Fri, 11 Jun 2021 15:01:47 -0400
Message-Id: <20210611190149.107601-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210611190149.107601-1-krish.sadhukhan@oracle.com>
References: <20210611190149.107601-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SN4PR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:803:2e::26) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN4PR0201CA0040.namprd02.prod.outlook.com (2603:10b6:803:2e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 19:51:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ff4897a-b415-42e6-20cb-08d92d12481b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2944:
X-Microsoft-Antispam-PRVS: <SN6PR10MB294453B0F11B88E731875A0881349@SN6PR10MB2944.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5YIpTLQ+hy+sS6tdPkN6BfC9PRxaIzyn/4PPMDEmCA3vhtSDHwnkteWrPUQ6vdNen+iJSgnjy0/nac+z6dmz8acCjR/dr/q5NJGbl52EEBP27fz1cf/5phVi/ANQr2rubu5O4M4SxXk9KyJHQDVccdbB6IglNuyOND1A+W2HUdxq20YMdWVtT5lkOIuWWrmfTv/5uFcInGAuvKWmOTzzTRkBjUfVooBryxdgunuzGaP0S8rq9U4iwtmC+bq9yh/JIWzZcah7PCnsGQTJ0z8HefNb6lG6/TpnlFPu+CSeMYif6y6IKtOhZ7cI+pbQlyA2KNtLP32mstj9bP+qd6h5kMPZgQd2iISnFMh93mvFjbrpZtpf3jwL8ODdVfJyDADbdS75jK9gLVqyK4LxKRzsS1i2lL94ZDT0hmqlNNq8J0HmFyvt7IXc9S5eRpqXK9H3AVLsaMCebtey835dIgj6vPNR1deGUkeWqCdF+EMMYjI7ghIBwTTmZ2gLg4ng2j19/pJ7zJUtV6tyHlGME4vNPWbT3fkj7EkS14qwsjRMEPmhHyjaCMZB9MDJPuxT1sDjVizTerQOmMYdUx7PtwHDCAfFq1s86uw/bjYei6wchfUGNdcOoK0DAs7UFfpiSEJZt427yiZBErhtS0sjSr+qA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(366004)(396003)(316002)(2616005)(956004)(44832011)(66946007)(66476007)(478600001)(66556008)(86362001)(26005)(5660300002)(4326008)(186003)(38350700002)(38100700002)(16526019)(1076003)(6666004)(52116002)(36756003)(8936002)(7696005)(6486002)(8676002)(83380400001)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9aNDJzfiA3wj2T+PLeLvZBkrvmNFol4zeEsoAu4RpmtpvoS0T6H5pDxiyv4S?=
 =?us-ascii?Q?P2wrAJYFfl92c7z3lH/4Ep6Tiv0UtPMzXjSm6Z/nOSZMMklcSWmaQ8AAW8it?=
 =?us-ascii?Q?wbv4gVDmP36Q9KcgFDPK5Sn3Zpm3on1DbSwZaWrLn/tjGkEFC+pJkv5lvICp?=
 =?us-ascii?Q?PZGfwUiTWxmgYa1IN80iFfwYwB/nUhIZ9Xh32uMRPNQD8dc8wCXPLmd+Cb2d?=
 =?us-ascii?Q?f38rOic7bO+70ggni32UgS9sRmW2iXk7Hc02mP0JkPAJPHIQPWfb/4gO6eCq?=
 =?us-ascii?Q?yNDo4SDcikAQa/j9R8Jg8m532NSDqCje2MfChBi42OMJCg7VXixU4OyIYEMJ?=
 =?us-ascii?Q?M3kdWCEqbMrnpPy7U6s2+9X2shIvV/scGyLv/FfqsJrzx+NdNIcNJbZbA+xi?=
 =?us-ascii?Q?mLgYGBj678x+xZrqiD6zZJ5XcL9B6HsMZ528EgYLiVzHazW17RHY2dVXJg21?=
 =?us-ascii?Q?i5fC2PWCioJYyn4V2Sw7d0ESx23AbOkHaA3431Wr6VWg8SmLwaKGhirh88l0?=
 =?us-ascii?Q?J1eDGDddvbPBl/isrMZCGASaAkY7Vg/WHAdwTf+jShoHyBdPtXmq0FaSAeaO?=
 =?us-ascii?Q?glAyoE7FDjMjueFr7BzLF9lHvuF71EnR5izN8ytaZM/siro+R1gDam0N8iwg?=
 =?us-ascii?Q?YVZAhGF+PkxKG0UalLgwv5IJaJUHKPv7un4QXr5At4kwmBUCBuFoXBXzQ8Sb?=
 =?us-ascii?Q?avlx4/PYlnkPgorrZVPTCgkLbjJMYY0aPpRvdJuYuXjAgm/1Jqo212InXjn0?=
 =?us-ascii?Q?ZtZiYpKtMW5JlO6gL1wDqhJf8R5Dao9ixlXlLDeDaixvT8iP98k+PebRx22c?=
 =?us-ascii?Q?Jc/0hQBP5oDfZNp3vvDqGdlv2Wg7pfgghmGPs8KQCfwkNT1DLgNjda+Ki+X+?=
 =?us-ascii?Q?yueUiX6LbIf1CALL9fP/2aB2skDW/uzIrY+Pz8Z9saWG66mNhdrhoZrE8377?=
 =?us-ascii?Q?suJYvuE+b8HM1zWG8Z9T48Yeu3H1JJ1blZaIKo3s8j7HKVkf7fOU/ln/OcLw?=
 =?us-ascii?Q?ySqFFrry61frTuMuTwLqKoqcMSlK0iAMOb323eVPD9KnouFL7IIXQBW1e+tZ?=
 =?us-ascii?Q?hXmTvxHHjsuxA1x9+rW4RAP05bDMR7HcSsCQhcCOXd1omYUs116fw7Vi89b5?=
 =?us-ascii?Q?mByMnBHjhjVt9nXci+moZEt06NSUNv7cpaNmhGU2PqiOkWQqckNu8cwdRqtl?=
 =?us-ascii?Q?08kkJ8RlPPOOLHd6wodA8wekPUcUh+p1Lw2trW2MuPEmGKMwn7ABge2Fhpgo?=
 =?us-ascii?Q?W+z9GdldpQpNeoBIRHWf87OcsjxdjVdDo6IUSrqXgCPFkwPR2BKw/ZrD3ZJk?=
 =?us-ascii?Q?4AU7Y+31BqMstIoGjmTJ2Bfz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff4897a-b415-42e6-20cb-08d92d12481b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 19:51:19.4213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPVMKjNqQBiC7qsvzpSXdZodKynwnDDhgQtuSBANDV6KGoWjHVJgyGSXYNdklz8AuI9kxBSD1Zhk4MpDtpkSMjhxrAYU3mkT70vOc0zW5Dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2944
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110126
X-Proofpoint-GUID: 9ZmHubX33eTUhgMFezr9iFSfJTBC9z3p
X-Proofpoint-ORIG-GUID: 9ZmHubX33eTUhgMFezr9iFSfJTBC9z3p
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the 'nested_run' statistic counts all guest-entry attempts,
including those that fail during vmentry checks on Intel and during
consistency checks on AMD. Convert this statistic to count only those
guest-entries that make it past these state checks and make it to guest
code. This will tell us the number of guest-entries that actually executed
or tried to execute guest code.

Also, rename this statistic to 'nested_runs' since it is a count.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/nested.c       |  2 --
 arch/x86/kvm/svm/svm.c          |  6 ++++++
 arch/x86/kvm/vmx/nested.c       |  2 --
 arch/x86/kvm/vmx/vmx.c          | 13 ++++++++++++-
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..cf8557b2b90f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1170,7 +1170,7 @@ struct kvm_vcpu_stat {
 	u64 req_event;
 	u64 halt_poll_success_ns;
 	u64 halt_poll_fail_ns;
-	u64 nested_run;
+	u64 nested_runs;
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
 };
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e8d8443154e..34fc74b0d58a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -596,8 +596,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 
-	++vcpu->stat.nested_run;
-
 	if (is_smm(vcpu)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4dd9b7856e5b..31646b5c4877 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3872,6 +3872,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->next_rip = 0;
 	if (is_guest_mode(vcpu)) {
 		nested_sync_control_from_vmcb02(svm);
+
+		/* Track VMRUNs that have made past consistency checking */
+		if (svm->nested.nested_run_pending &&
+		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
+                        ++vcpu->stat.nested_runs;
+
 		svm->nested.nested_run_pending = 0;
 	}
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6058a65a6ede..94f70c0af4a4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3454,8 +3454,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
 	enum nested_evmptrld_status evmptrld_status;
 
-	++vcpu->stat.nested_run;
-
 	if (!nested_vmx_check_permission(vcpu))
 		return 1;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f2fd447eed45..fa8df7ab2756 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6839,7 +6839,18 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_host_xsave_state(vcpu);
 
-	vmx->nested.nested_run_pending = 0;
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * Track VMLAUNCH/VMRESUME that have made past guest state
+		 * checking.
+		 */
+		if (vmx->nested.nested_run_pending &&
+		    !vmx->exit_reason.failed_vmentry)
+			++vcpu->stat.nested_runs;
+
+		vmx->nested.nested_run_pending = 0;
+	}
+
 	vmx->idt_vectoring_info = 0;
 
 	if (unlikely(vmx->fail)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bd550eaf683..6d1f51f6c344 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -243,7 +243,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("l1d_flush", l1d_flush),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
-	VCPU_STAT("nested_run", nested_run),
+	VCPU_STAT("nested_runs", nested_runs),
 	VCPU_STAT("directed_yield_attempted", directed_yield_attempted),
 	VCPU_STAT("directed_yield_successful", directed_yield_successful),
 	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
-- 
2.27.0


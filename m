Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488A53A09D0
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 04:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhFICMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 22:12:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48664 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhFICMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 22:12:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590rqOu178054;
        Wed, 9 Jun 2021 02:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=oRABewmg7jiEpwCSg1OgMaGQGVjtb5G3ByG/w050JtprDcpEZQ3PBf1DEHj910I9qRTf
 ehEsxKMaPEZlIl8Hjt5XX30Uy/H7aJEswKBaTs9PlVPaXvwD8/9pG6PLzsXTvkUkR7CQ
 4viE5DcAVpYmgV44HCZfk7uPM0+/jJ29GtuuOvvbMBpm9sWsMUVdtlnE/Kz51csFDjcU
 1G5jkhKo34aBT+RheupKQmVrbDQoyDPE+uZ6CTm/iZTlUq6s5sQI9UV95ptlcTE9q/0H
 o60qwYM05IYErz6t1SeZ/6SpUTbA/bu0w/fkM1zN5IrmQvqaMsgFJSyMiYUHEP8T14xA CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3914qup5hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 02:09:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590aNcn129799;
        Wed, 9 Jun 2021 02:09:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by userp3030.oracle.com with ESMTP id 38yxcv89a1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 02:09:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k27JgoPc/XH+DfT3vBl7U5tdA17Mw50oh6njQZZQFIEPLmxgqdRYJEEYZf1z4P9UqnDFOYRBsQVY0GxQ7xM0Q3fSSXmkH2SABms0ka5ITKnISmw1GIh50MFmjwpW6VBFfh74EjogXLsRubv+PEs4jVVI+NdCA//gXhUpJTzC6pwEuMgnBmx2pRiTGuSWlR2HQnQF6lBDPUFXfsp5kWBvgxajNdHrNisLGWINid4JjODxSZOEK8zmtTUDp0Ch914Fok7ySipQdpbOjr7INwShuX+5HzHgBUq9uKiFnf6ibNc3RP/LLm/MtXb50LeD7zW2Q2OUegyOCq7CNYesml4sqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=EruLkl6THJ8gYVjbePCh9i5bmNP2Ncs6fvHwywstnyYUZ1hau/fvp477SBlJotHc/XVSNq/6NFjALT5MGYaDfW9VUDE+KAvqZWUHoWoKQjYN6WrXasWUENdIXoK8FBtUCdDgH9MJWF5tAnfxjEt2KzEZFQMojQeHKilBKN/xklBLKtADDUzUbx9Bjfwdc7oZCSuk/al48ieJYlOAPms0xGqcvSPTxCi/ya3XmPIj4dlesR9OWW3ro1J0XzstHMjRRdc2x+5o19Ung354p5b8H176CosNC67gQJOiVfKk1p5jFUwrkELPLyooRzXB1ypdX6bXGZgT4ItT4U7g3kVYVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6whqB0sEEgGEJG950YazK6tKw+N3ZRrDCp6elXlmAc=;
 b=s+TX5IYPpmxxPyJgBTsffLf+oIJfnE2HEaCFJODk/zo+Ev0oMc6gFnaUg0Lo/PmwAT2DUdb5Sg9XyDZb9BPoyqSAI9kMZ1FvCcoFcAIJ5+iZaZ6VcYKZfNyLPBquKUe6qb4F5dh3jELTLhjcM+YY5ljIpARiL5XunmL61zmxXbk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 02:09:06 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 02:09:06 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 1/3 v3] KVM: nVMX: nSVM: 'nested_run' should count guest-entry attempts that make it to guest code
Date:   Tue,  8 Jun 2021 21:19:33 -0400
Message-Id: <20210609011935.103017-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210609011935.103017-1-krish.sadhukhan@oracle.com>
References: <20210609011935.103017-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA0PR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:806:d2::19) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA0PR11CA0074.namprd11.prod.outlook.com (2603:10b6:806:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Wed, 9 Jun 2021 02:09:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcad634c-a505-4e43-f17f-08d92aeb8f38
X-MS-TrafficTypeDiagnostic: SA2PR10MB4524:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4524395D2097A1124D3DE48F81369@SA2PR10MB4524.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EiCTxMF2+mSP5bgpFe8RW36UXScTlIpq6xxS0yQ0xLPVqqrbS0lMJIK1w0bxkbDS56PSKLrCAQ8KoZ512wEtwcdgNL8lF+0EafxuURibCTtrpKCt5yIN40aM6AN2oKSpRof+zqHbrzLBh3fKoAmPm+gNHL/6LTEeS6wnLSlOdeWTnRAg/P810kaGsYd/Y0npBh/+XSaPJ+NiTsB0+eCkEgHTSYU/ab0IP2y0YTIeOFLR6BxkckEgS/HHdI3JaFl3Rllp7jaDhZ4MeTpvjNUaVrnoKH1b/6e5Y0kcytPnUPY95AuO1G5R/OifKbkCvyQsOtvO2bELc2ljD4CfLnTPaRAK8QJNzzwL4gdNGS7XTrZKie07DMTwpLbuhcWOXV6NdkjblIkRqVAtugUvrrjw66p6FCHY88N1SW6cIl+eG2x9hyffYuT6xNvbcaZhLVwPxj1MUFzPCn6de3gLY3QCxltIA+j1MnJw44qPUg5451R2WF3QLjLujQLQ0I82qL5HXirmQdYIrECH7vSkvD9tLP/6UqKZZTE15vl9VihwKmunVQe0lLnz/Ls+1t/9Kt5rqPsYTHhA2RKGOnPzJV9B626JFV6NElSsMJNQr1ERPcQ6LbZrW6ZE8sXmtHGWKMOqVW/+QTbokhh6jyUqyNYv6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(52116002)(38350700002)(16526019)(186003)(83380400001)(38100700002)(7696005)(478600001)(44832011)(1076003)(5660300002)(86362001)(66946007)(4326008)(36756003)(26005)(2616005)(66476007)(956004)(66556008)(8936002)(2906002)(6916009)(316002)(8676002)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PCy0koIgUfHmdFTRIeHKBPuRqwiW8gBPwpcEvGnEs7dlxRDfMAcc4kABKnfC?=
 =?us-ascii?Q?jO9kGF6202g9M2zJ9tNZtIWzpxGsoRWMO9BtxUlhv6NElGGPE+h5T3rJ1Kmf?=
 =?us-ascii?Q?KJzn5qQbXkbBqiMZOuroT6rxfVMyYJVLJziO/R68yiKaG925SjjIPiGzF7ML?=
 =?us-ascii?Q?qF2Bd3SnKJMt6HuhV+CQv0hgcgFSGEvTFI8p6clOkJoxcx1I6OQat4/Dj6DE?=
 =?us-ascii?Q?5/c7Ouuk9MrjeLWKX5sc1ktus9kjP6PnP1aLSiY6YbPBU0kyvQP6iuwLD1R2?=
 =?us-ascii?Q?QF1v9fc5yGtiHzJmZNDkYJqj7b+rtblV1558DOfzy9OIy2ql9DdfdPbxo7Tk?=
 =?us-ascii?Q?NqqSEwYWl+lAG2M162huUoVllgBkhvgYZJAjmmA3L+DbQfk90EnV73/lt5T8?=
 =?us-ascii?Q?fEcoXDcA5Z4wWL54pJWIVBeqW/FVvz7UjVh1ASGPEM8ORZyuGB+m1LdDlVAs?=
 =?us-ascii?Q?Rl2v0MbGYDTm/JjIm3LMj/sPQtgOYSunKrijt7VTu6lRUMd9GmVbze9c6AmY?=
 =?us-ascii?Q?WuK196YqnIXP+KKuoUC8KmWZcKG//b8+Pnyt6RhGQG95OmH/OZJKf+tHvxeE?=
 =?us-ascii?Q?h1QjAJVUfGSJhC2rPx7F0hPzWPt0jtqVJkLSt5B+NwBVdsK9Mt66S2GzqMfU?=
 =?us-ascii?Q?KZlJwzkyTIp4USSS8KdBp3OlO6/O792qJ+YnN1hDSKMr9sogRVh3wvTUxuJX?=
 =?us-ascii?Q?7PoaSY1JYn6ZufPnTSMGcSFPDQLvI7LB+9jhAiyYl2A5WhF1fLL4tydqtLUu?=
 =?us-ascii?Q?xI5CDSbgGfi7hyPF7Rq+seuZl+WnqzAM2ecPeJDFKcqkOuQOqGrh8qRm7e7e?=
 =?us-ascii?Q?xCZTH2VfXNs6+NaikdzxCq3mjVupT7XDkKh36bzhEwsKkp7b6UrQ+iVcXPHR?=
 =?us-ascii?Q?IDaj5hOBYmo+k3EvQSZhZCBSXx6YvxIiNQiLbJ18r/D/yogHDKi1ti8OT1pG?=
 =?us-ascii?Q?+UiJP6HewrO3bnEJX3oeUYfvZVk3ck4lIAsIZVRd2LR8qk9+TDUZM7Gu75tx?=
 =?us-ascii?Q?BvBm1Ni2YnEn9VC5FwMZB2qsPZiAKbJUlG78Ruz5DTDcL+o+OrhpkoyxmUKY?=
 =?us-ascii?Q?QkgthbxtsabGrfUvWTnUDwz8yQhPzHPJJI1nVKYcaoCSG6fXNX06X01HT01U?=
 =?us-ascii?Q?AMgAGln+ZOMwQIFtxRfAz1D6J3v4A1XvLHECKJMRo+8l6fJP0FoGc2xzCb87?=
 =?us-ascii?Q?NmXOGLJiLOgdPWcKas9/gGNQgB+ImzzqC1DFMJJZsti7vYIaE85WSxmuULqY?=
 =?us-ascii?Q?yZkOs9Z8pf0ah2tSJBshSRcXPLbfR8dxwp6qkfAAoOEVWoCo7kxGXbfG0DQA?=
 =?us-ascii?Q?dEZ3r/Qan0z+39VMd236Uubd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcad634c-a505-4e43-f17f-08d92aeb8f38
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 02:09:06.0479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjgPGtxz0G0Ny3/EOmxeqrtKqLY5IfC8LmM7WrulSvQj3C8Unk1gUiNkfhM3Q5SafkvUeFUIMfznzn/HU7plOF0Tm6PL/WqELNy0yiBJtGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: 09KWpMGRxNffFXXE9F3JpE5Ze5s3OJ3z
X-Proofpoint-GUID: 09KWpMGRxNffFXXE9F3JpE5Ze5s3OJ3z
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
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


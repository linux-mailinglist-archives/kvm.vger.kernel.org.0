Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C435389AF8
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 03:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhETBk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 21:40:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhETBkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 21:40:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1Z0pQ109307;
        Thu, 20 May 2021 01:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=zoa5ankHEh2OBCT0Q9bVTohB/rmrokHnOUJOHQqIuXk=;
 b=TCFn4yA7y7tL5xVO2D6DS2klSiCDVDofz/q9bI8faBXZEyuQ+nSbUmpUTvolkQqqkGzC
 Lgo/26YnE5o1nrsh+9U8lWxEcgD8JRZFNq9aU37ovmMyolquH45e35Se81VqnZ4DGZ8K
 /d8JI0W6+CIepP2uHLY3QafRv0+m2QeheU4Ffk+34T2z0Mf1YcVmbfc8/SijRcvf+r81
 oeUAvX12er+xnsRJuehUbjmk+tVlBAHob8f+rOIc7AMlZS65CP27QzCDGUMFGPbhBQgo
 Q4hius4s9V4XMofCbMDn6RELqz3wJQGV8pYRSu60666+Ucyfd16bz7HOP9J/B0ajPsj6 UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38j3tbkb45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1a6nL017253;
        Thu, 20 May 2021 01:39:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 38meckwdm7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RO6ZkG0AzNP0SILWtosO5Z1F3wsscMZvOkq8nwJ0syV4tJoJp5HA+Dnks8Zr5HgQnjoUyxTSy4IwYdzNHqoRqKxlm2u1t0NWhBZGQlGN/Mt9PEEjbAAP5TYJVzDyaQEO6hPzOnhuuRfEpLCuJL1rF1Ls1foEwuPMp7tebD769U3io0XQRJXcoqi90UYvm5PFqKhROIMEFCJlUGltzNqGzwPyEd+luZiz8JkoW3UloiO8+LOC6eSTXojaJDpt71nBAwpVviZYPbAWSPmWviWQxHnzMaAGL16JGTNrgS9s8JcgNC43p4n9Bj0ePa+B10pH/r/pV7AneMp5enLBgAGNXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoa5ankHEh2OBCT0Q9bVTohB/rmrokHnOUJOHQqIuXk=;
 b=gQSCbK4dzHnborM05hU6fzr8EWNxLg9ApgxuoR/1vrdU6oHN1UFLI2SsTvRjESHsrRieYSTdJcJ0PSF/HcGr7NZiY3eDh5vZ/haSmmRGuDGXJKyRuhPETPA2eNvFxhqZIuxoyxRMobXD5I0ycqsDNR9zA30M6D2vFgocJdN/D+qXdLwYLxK/o/0ASbAj6xBcZvL+3aYSd1arb9ZSRNL5yjs5HJmsKRVrCpAeAo4AoqK2uqOXf9idIHmfS+eiYowvdqFDtmliA8gDOrpXbjRIN+16uW9tbtd/3CY7xDNBHZcYUtCX1SQalcMSChAoy/JUJ20PcGJwPU6E4kyYAkXlzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoa5ankHEh2OBCT0Q9bVTohB/rmrokHnOUJOHQqIuXk=;
 b=JgRlDMx9l+fnslkkf9svR/BA7XXUWsyfvm2JsXM7sP9KDQpBeQnSOCUvTn1tngicHo3fdPfnUAB/4KdxrrFD8cy51ib0l/C0MrJXNjob22Ufe3+kRcQwxnz2yschEoppM3T5slLjBNjbg12uCa7cDarJxQsWI94q3vN/998W7J8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 20 May
 2021 01:39:29 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 01:39:29 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/4 v2] KVM: nVMX: nSVM: 'nested_run' should count guest-entry attempts that make it to guest code
Date:   Wed, 19 May 2021 20:50:10 -0400
Message-Id: <20210520005012.68377-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA9PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:806:a7::8) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA9PR10CA0003.namprd10.prod.outlook.com (2603:10b6:806:a7::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Thu, 20 May 2021 01:39:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d2c4198-2728-452c-a806-08d91b301bec
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:
X-Microsoft-Antispam-PRVS: <SN6PR10MB294371040BEE001B4BEE3775812A9@SN6PR10MB2943.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hkvxj5/U2+CqdcSMdoDFaCDwSOAYoG9pev1ll2dgLkWbqPJBEgx7ZWD0UP/jLKF5J5EyZx1n/Hwfw65A9Xv9p2C/BUyFe/7kWKNsNV8A3WD5SSLDv+7ihP+GqMzAIydEYlVFs0218UBMNbI9ryBD8bXPOD9Wc/JagwbnVhN4e5Re8ZTR4bnTbSy4e3c5bo390hhie7Jpez2Cnh59iCxS+9Io87kExmJiF41I3aNJUane2wyG0BUIWp8yhiKnuyZQArRXNE1ly7VfuzPMTugPJya30ux6hFU/Grjitm5lAP1FTD/XPbffWZqHitL57WfCzhmHqRzRLU+x3Ows99oOOFYIaKAnZEik3KuhzfX6xjZLWMVNbwvuIbcCDVRJ67zWrOUpSpmrHMKVynWWVw2SRpluXMUaqzUTFW1JTC35RQoTPLm+1AU/6HXiu/R0Nb9jN8K2tUtWYEac5aouv2q8v676aMrBMXeiOzCWgyfMS/btsxTpaHZLvieuz9ewBQ2SXInvsyp1pG8q7Ro061Y4UnN+vQOINbNaWSvhdE1gHdj2e+6JHqRmvuH8fzqyOMTC1S6S1zCf3/QtpcMH6sVwLs1qMOQE+Kx+7J70zBHOiFmwVP/+mzmN9u28GCaYbIZEO9oxPeBhDmYaqPlxcQTQgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(396003)(136003)(346002)(1076003)(6486002)(38350700002)(6666004)(86362001)(44832011)(38100700002)(478600001)(83380400001)(66946007)(316002)(186003)(8936002)(7696005)(6916009)(956004)(2616005)(52116002)(5660300002)(4326008)(26005)(16526019)(66556008)(2906002)(8676002)(36756003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?U6XPTAwxnzwGVvnpc8LJUtdrH0qx1jP766BQ1lfB9YLvWTVtQvFs2al5x6J/?=
 =?us-ascii?Q?Lk2QLBaoMqjq4Ore8/PfLrJXVzOKxx/qaGhdT9/pnTMfuWxWInIX1qonV025?=
 =?us-ascii?Q?bEIWvEL71RdP8qtaKajeHXJt9nitn8gI+vfuHxW4ktrXto3yvixbjsFbhwWL?=
 =?us-ascii?Q?+NjrmrSub4uKpsfw7PZzHwqqOsv44XVwoquDwaOE6EOxq4uTGh/eNAdLvkQL?=
 =?us-ascii?Q?t4bQqGq3M4fX5qpjinC/4MclocmKpK0evWfYIpSYIiMALcgHA8pc/iGbqPJY?=
 =?us-ascii?Q?SbZIE494y/s/JbRvkYu54ZtSlR4ZbCyG+K6t7kHDly5jkorVvLTj3iukS5Cs?=
 =?us-ascii?Q?w2aHnrhaQ1odkafuAlIW1ZFHB6szRoATSKHC+1bfZGjP6vIXwbjVZ43kSnk3?=
 =?us-ascii?Q?qh0a9Q9pgihjmsukwyqnRrEJdYmCFY2nh89iUzyyzY184jeETBSOSHpM8PlK?=
 =?us-ascii?Q?ZOFUyR34bN01NFQyheE/WgUdejxWhFXXMssNPkcHLhOdJUOeFv78OAigsJSK?=
 =?us-ascii?Q?2y5Om8d7mO2Gx0TXC9PEmZXCWsM6a2Q9kHU2Hwjsq28FX5AA5PAMDKaC3Ubs?=
 =?us-ascii?Q?nQdEQe3Ks2fLjDjiEDh2xZTUjS+FSxrmGXmLCGPl5TKm/Dfaf9jlg53K1BEn?=
 =?us-ascii?Q?7ADOBCtYgh/v2bqL3qMF6CEOqhMLOBfU86Cp7fxBBv4GzTFeCldFWFWvSWOv?=
 =?us-ascii?Q?oEJ1jzoXifNuK3IC4fIOQLyBZK5xXZx4A475vt6Gcmi7PBblAazHwBDqz6/X?=
 =?us-ascii?Q?HNJV/uKUhOwkkyPWYrw+0cd+oyUbpkQlqhAeClTGIdG2i0tTe7qk/1Gn8RVk?=
 =?us-ascii?Q?IG4dbmQC7idBiD3oysczEJcWKq11d06QyVG21LmiAhGZc073cd60Xe2veQFy?=
 =?us-ascii?Q?MD4RPY3PRV6gfeUJnrk2DvXmNwoAwBOLnuWjWR54QuS3APz1TB9ANLBgd6ab?=
 =?us-ascii?Q?+WM8KsZA9jE4+0STuDNobpVR9cOCNOOFklP56XaMFerBb9zsXuY3jMCAKhwU?=
 =?us-ascii?Q?VGiLnjZ0H0Os6suuduObqTlpiLI0XUL71NFZXLAVmhNM5lMsX4+DaM1STVYp?=
 =?us-ascii?Q?tdijjP7FK6aQ+IJnckF43INYiXeQ7pejf28/TQJXlCfrGZjh43l4UL9vVCAX?=
 =?us-ascii?Q?BKjB3DxcfQM2ZhiT5IzLJ/FmBvti1ev2KfMU+GIgFvT5TjM+uyRGa4TiztG0?=
 =?us-ascii?Q?YUlD5kKhTyDglx2EPD8vN/3/Lvv0tFMwn76Xw7W7v2fo492/kxC8MWUJrGbv?=
 =?us-ascii?Q?W6l2lCag8RjMe3eySY+M/TLcNiyGPPARktUiBRWBWhUUOaAbMCEzybKfhYDw?=
 =?us-ascii?Q?eXor2vN1zr7CU/RlQllKzkPg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2c4198-2728-452c-a806-08d91b301bec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 01:39:29.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 52qEdj4Gr++hVLcurc4Q8m8gmCVaFWZDtEN7wZXn3shZ9NsGG9Zw3bXeD8Ue2ksqEtvnvlz0kjbKZIC6BVyiSRGgKKsex8Etxj5GMhW1ch4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2943
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200007
X-Proofpoint-ORIG-GUID: i6h1JnfWyo9zd_4RsOxRQ2ElxMD5TTpa
X-Proofpoint-GUID: i6h1JnfWyo9zd_4RsOxRQ2ElxMD5TTpa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200007
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
Suggested-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/nested.c       |  2 --
 arch/x86/kvm/svm/svm.c          |  7 +++++++
 arch/x86/kvm/vmx/nested.c       |  2 --
 arch/x86/kvm/vmx/vmx.c          | 11 ++++++++++-
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 19 insertions(+), 7 deletions(-)

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
index 4dd9b7856e5b..57c351640355 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3872,6 +3872,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->next_rip = 0;
 	if (is_guest_mode(vcpu)) {
 		nested_sync_control_from_vmcb02(svm);
+
+		/* Track VMRUNs that have made past consistency checking */
+		if (svm->nested.nested_run_pending &&
+		    svm->vmcb->control.exit_code != SVM_EXIT_ERR &&
+		    svm->vmcb->control.exit_code != SVM_EXIT_NPF)
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
index af2be5930ba4..fa8df7ab2756 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6839,8 +6839,17 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_host_xsave_state(vcpu);
 
-	if (is_guest_mode(vcpu))
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * Track VMLAUNCH/VMRESUME that have made past guest state
+		 * checking.
+		 */
+		if (vmx->nested.nested_run_pending &&
+		    !vmx->exit_reason.failed_vmentry)
+			++vcpu->stat.nested_runs;
+
 		vmx->nested.nested_run_pending = 0;
+	}
 
 	vmx->idt_vectoring_info = 0;
 
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3971C3231E7
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 21:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhBWUK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:10:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41266 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbhBWUJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 15:09:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK4IaU091499;
        Tue, 23 Feb 2021 20:08:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Mo8PBUmkRrVcmhWa92u/HhCvZoMCRaBTR/gdegtOq70=;
 b=WX7EV91cnopkQqxLmA3afZdLfW9evJUD9Xn1F0P2fpfe7RkJSGieek5MusWbiS1HCQtc
 vgxESfPWtxUiKVfwrMu55NGbmMp/ENqLDaKBCXMOBzvGCxG12OaeACILlObzkk3X3Gtg
 6AEhGTzYcty5RJBEAMAIsU7FQ85f/WqBPic58D6AHaJWmyybpzg/KB4Q1JvjAk8CCZxj
 IdFrgvAdNmFmP6/KiIshesEopVPsNTAGBWGyLtilQscBIJ3H/Kq7R5wH7o3/9+haNVlB
 XFSv7vhGzYREWjiMO+lRkRA6Vg3beunc+jVJWy2K08dPyqGZFKPpEvzviMxdYMJ4y7yb Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36ttcm8pm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK6RGU172790;
        Tue, 23 Feb 2021 20:08:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 36v9m52nk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+Oshzw2ussjUyMQs6cYPvdT5yFZh5PZeLnpANEAYflZKv8CP3QsBaz48aAzu9dBFv28sKXFka0VvlUEz4IdTAMQcPm/0y8PLh6YbygsxZoEe3TG+Om1imyWXbP7fkfyvkw3krvaU4dtfgJRJScscK6eeJnK6ghmfI7U2mj/a9hA5KJO7YtaTq7LOg5QUpUWSjkxpSrGyQDVdWHEcPmY501J6N/2u80H97oFdLRvG5jyWyDFGbyzsN9CtgzjEfeMCkn34emF1MIeyd9UxOFOQMqR7foz0kDvEfzErLz5Sz/apr7fLJVfrw0bQvHZMjQqPaqo9SG5v4MNgkQsSXGtgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo8PBUmkRrVcmhWa92u/HhCvZoMCRaBTR/gdegtOq70=;
 b=NfTZIBFE7U9SPFhV05mRC62+y6/8EC++h3YmP7jcj/1d0KtDAIYPbHgSlLKBxcpfVWA5HVLUZKocRAX1m/Kz7szrSPW7g1WK8Z/qAJVwAKSTmuQ5r3hWCdp2g3SvMCn1rXtRZn792h6Cr+YHV+oDAorR7Tx2mb9lEFVMzorndyE5dRuHH0WPToLZdhep2vIg+LvB7EmHixed1wSpYKMRXKB63hDfO4Vh23LebgrodnR59eQ72cs8+wY/NgRT/ekCnZrNmARSYiiDijBSinTfFILowddLzkDsbzrEU8mtCDFx51YVshMPW8gEqBxe0eZpy+3mKVLVKdf6jJImnWqJSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo8PBUmkRrVcmhWa92u/HhCvZoMCRaBTR/gdegtOq70=;
 b=ENH4qhT7e756fg7lQWoVbnzUsN/n9tY7TSX4QFIuS9HRih2xd6Lj4Dud9WvU3+8w0HPfvQNHH5jLLzai+W6cmWPbhJUWNa5OM84xJbFMe5qutY45Dyo/AYu6aNW+Ao/x4Y9bxyGSqjIm5lYw3YqWNti8j3uae5wkJsr69IKOUwA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4556.namprd10.prod.outlook.com (2603:10b6:806:119::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.30; Tue, 23 Feb
 2021 20:08:18 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:08:18 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/4 v3] KVM: nSVM: Test effect of host RFLAGS.TF on VMRUN
Date:   Tue, 23 Feb 2021 14:19:58 -0500
Message-Id: <20210223191958.24218-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
References: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by BY3PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:254::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Tue, 23 Feb 2021 20:08:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6101446d-e066-40ff-6639-08d8d836c320
X-MS-TrafficTypeDiagnostic: SA2PR10MB4556:
X-Microsoft-Antispam-PRVS: <SA2PR10MB455660B627309B4277BD2A9781809@SA2PR10MB4556.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYyWUugdRBLQ+Ds+PMUTCrvFdbelgdcvQElyFM7HRD1EHWgOCKAQ16hSFk/uTg5VCRcQK/gCnG+RKOY6R2Qhe3m+TIucaLr6f41DA4OpqT6XzGYS28LezF31pMeZCDi81XNfOJnR5rTfDSU+3uAiC2NgLvMngO6kojRn9GF8CpGIZfmVSGqTkWp9H9e80Pr34HxorJCw6OhfWl1NORSCDSO1cXZ/bVWWnN1JTYGTVCS/yd4ml1c3WVnh4E4CbRWEEo0T6xBvIXhRihdRZAngBVdNJJJ1mU457/F8pkUYz4CKXNLIs+rDyj3cHYoHjZu2wAgVa2EAoHMGVn9PJtjd4zgGEGQjH1EPLujEhG4bhg0lvsONiCRhklVQeDrAfVOgrCb4a93x1QNxu5ierXIAzQOinbLvIKCZqq8QcCt5v3tgj7jmsnfbQhcdFLDpZQEVBcDvTRH8x+tuVZq+Q7+BvV/iZ2a/tmUaALcSs0RetpsOurFk+qER4g680Z9quhLJHSYyQ747YYUn0A3dkj5hMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(4326008)(6666004)(6916009)(6486002)(16526019)(2906002)(5660300002)(478600001)(66946007)(66476007)(66556008)(186003)(26005)(8936002)(2616005)(36756003)(956004)(83380400001)(1076003)(8676002)(86362001)(44832011)(316002)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A7fdJkC4q8DwCl5413mY6zNIbg9l7OeiUZUWDKXOEq/iEJTT6BvbWTy8edHY?=
 =?us-ascii?Q?mAXZzbm8cuual4iRsxwx9KcJsDioS9qmhghxgsLTwWP+3vVeMKyghP80mfuJ?=
 =?us-ascii?Q?wjJNasSWFi9iwYA9r4rgirumA9KsMRD56d4QKKp7OTpv2SJJPFKhWEzTAo5P?=
 =?us-ascii?Q?5eKP6tyMhrFofJkiyVzr2WXewsi5QL4OALSnmTj2VpNVaQesm9BAsSnBGOXJ?=
 =?us-ascii?Q?Y/sMJWSPvVHjlGN2TPixy88z94CTLdTjMuD41W89LISyRsgCLWdkADq025Ud?=
 =?us-ascii?Q?800HWCK762Ttu3plegHkOyb5xQWVW15SREbO3Rj3IGsKFL+0KRZRnlQYwDJl?=
 =?us-ascii?Q?TaqHm0e6sh7ng/tk96GnzUuS50PS+Fyfd+7fWZ0c/mQ27cWhdF+tFvJKhJM6?=
 =?us-ascii?Q?4FJAEbqQb5wwQPDp0MO64K+8ttP88qqyWAxX7/yHJoXh+9ms1ImfEccCYhSk?=
 =?us-ascii?Q?Rl7TO/xU26mLlzbgkPCcFtA4hf6GUjkrPXJ9lPc6Ua+TXWLZcGtVgUjS0QWp?=
 =?us-ascii?Q?quw0qik0IwXqMV7tk95NqebvZX2lQjtjtdlkswxNV5hhA/x8149uMvRY6CEZ?=
 =?us-ascii?Q?TFpUu8MBS3XkhDBW9mjZjbNlfbRXdAgA8khCCXlSX8hiHrDmKxAvdxrz2z24?=
 =?us-ascii?Q?dllQdz5JxKWt7VLj3VEkOaGH19uSj0NQQzyoaQB2/gzX0otUjjxjv5hw444H?=
 =?us-ascii?Q?Qzyuw41BCqhFUWqd1ShmPqqZYmdPh1KRCZiAN5sUbENpEDGHH5O3O1QAWvRU?=
 =?us-ascii?Q?2fEgJPqvFBqj0DogHmsReToKXMfkuX71mHEOXSEgokxWD38wyC3i07+fM2Hz?=
 =?us-ascii?Q?TyPu9V70ZGlluKMTFldpTNl0XjNOQb0xCb203RVVDnzYNrBcQ/6hbGLIVUMa?=
 =?us-ascii?Q?Ya1mmUD3ewwwM+GOw8WnA7dTfGn/lLUNjFi+/afZNGxLVhN10QD40eCrP1qS?=
 =?us-ascii?Q?MJUFUTxDPkToQHVJVTNWpWGVX/KquxqLfbSNEZ4l1BtmDfh4H/O2VNmumdk7?=
 =?us-ascii?Q?xgjt9XC5dcVH7gkDf549RnWeSxYkXQU8NBXfi81aZeR/v8/VyezUAwv7TN/o?=
 =?us-ascii?Q?pRMD/KmXhmcDHNXd8wCkD33cp+LIsovI64jTtW9eYcFHAE+N/td1YwX1IwXi?=
 =?us-ascii?Q?dH2NXnrZaJDV2Uogxye1FuSqy2XomVh5ORjMSgXtlKdQfybhphC5fni2nEmh?=
 =?us-ascii?Q?YI3su8UHdAfpcfo4soPsdarh+9+gcIbNJZvIvBIfiyTSttfDNKW+AKtX4XiB?=
 =?us-ascii?Q?rib2gnUjfLEwpxeyV0qFXyJvVki9Jj1/6ttwvJ4feyHa8K8hOt21oxQXQjwk?=
 =?us-ascii?Q?1J3FE64YfKmqkt+g0wtnXrW4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6101446d-e066-40ff-6639-08d8d836c320
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:08:18.8837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbinGBnX6YkfHt4JucPZo2WnSYOdV7FD+let18nM2rkM3av6HhLlHTl+IeIG8ofCvPWrcAtLVljrDxwlLXUZFlE4IdbSCQPgr2flPUAB7oE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4556
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "VMRUN and TF/RF Bits in EFLAGS" in AMD APM vol 2,

    "From the host point of view, VMRUN acts like a single instruction,
     even though an arbitrary number of guest instructions may execute
     before a #VMEXIT effectively completes the VMRUN. As a single
     host instruction, VMRUN interacts with EFLAGS.TF like ordinary
     instructions. EFLAGS.TF causes a #DB trap after the VMRUN completes
     on the host side (i.e., after the #VMEXIT from the guest).

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..466a13c 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2002,6 +2002,118 @@ static bool init_intercept_check(struct svm_test *test)
     return init_intercept;
 }
 
+/*
+ * Setting host EFLAGS.TF causes a #DB trap after the VMRUN completes on the
+ * host side (i.e., after the #VMEXIT from the guest).
+ *
+ * [AMD APM]
+ */
+static volatile u8 host_rflags_guest_main_flag = 0;
+static volatile u8 host_rflags_db_handler_flag = 0;
+static volatile bool host_rflags_ss_on_vmrun = false;
+static volatile bool host_rflags_vmrun_reached = false;
+static volatile bool host_rflags_set_tf = false;
+static u64 post_vmrun_rip;
+
+extern void *vmrun_rip;
+
+static void host_rflags_db_handler(struct ex_regs *r)
+{
+	if (host_rflags_ss_on_vmrun) {
+		if (host_rflags_vmrun_reached) {
+			r->rflags &= ~X86_EFLAGS_TF;
+			post_vmrun_rip = r->rip;
+		} else {
+			if (r->rip == (u64)(&vmrun_rip))
+				host_rflags_vmrun_reached = true;
+		}
+	} else {
+		r->rflags &= ~X86_EFLAGS_TF;
+	}
+}
+
+static void host_rflags_prepare(struct svm_test *test)
+{
+	default_prepare(test);
+	handle_exception(DB_VECTOR, host_rflags_db_handler);
+	set_test_stage(test, 0);
+}
+
+static void host_rflags_prepare_gif_clear(struct svm_test *test)
+{
+	if (host_rflags_set_tf)
+		write_rflags(read_rflags() | X86_EFLAGS_TF);
+}
+
+static void host_rflags_test(struct svm_test *test)
+{
+	while (1) {
+		if (get_test_stage(test) > 0 && host_rflags_set_tf &&
+		    (!host_rflags_ss_on_vmrun) &&
+		    (!host_rflags_db_handler_flag))
+			host_rflags_guest_main_flag = 1;
+		vmmcall();
+		if (get_test_stage(test) == 3)
+			break;
+	}
+}
+
+static bool host_rflags_finished(struct svm_test *test)
+{
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report(false, "Unexpected VMEXIT. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
+		/*
+		 * Setting host EFLAGS.TF not immediately before VMRUN, causes
+		 * #DB trap before first guest instruction is executed
+		 */
+		host_rflags_set_tf = true;
+		break;
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
+		    (!host_rflags_guest_main_flag)) {
+			report(false, "Unexpected VMEXIT or #DB handler"
+			    " invoked before guest main. Exit reason 0x%x",
+			    vmcb->control.exit_code);
+			return true;
+		}
+		vmcb->save.rip += 3;
+		/*
+		 * Setting host EFLAGS.TF immediately before VMRUN, causes #DB
+		 * trap after VMRUN completes on the host side (i.e., after
+		 * VMEXIT from guest).
+		 */
+		host_rflags_ss_on_vmrun = true;
+		break;
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
+		    post_vmrun_rip - (u64)(&vmrun_rip) != 3) {
+			report(false, "Unexpected VMEXIT or RIP mismatch."
+			    " Exit reason 0x%x, VMRUN RIP: %lx, post-VMRUN"
+			    " RIP: %lx", vmcb->control.exit_code,
+			    (u64)(&vmrun_rip), post_vmrun_rip);
+			return true;
+		}
+		host_rflags_set_tf = false;
+		vmcb->save.rip += 3;
+		break;
+	default:
+		return true;
+	}
+	inc_test_stage(test);
+	return get_test_stage(test) == 4;
+}
+
+static bool host_rflags_check(struct svm_test *test)
+{
+	return get_test_stage(test) == 3;
+}
+
 #define TEST(name) { #name, .v2 = name }
 
 /*
@@ -2492,6 +2604,9 @@ struct svm_test svm_tests[] = {
     { "svm_init_intercept_test", smp_supported, init_intercept_prepare,
       default_prepare_gif_clear, init_intercept_test,
       init_intercept_finished, init_intercept_check, .on_vcpu = 2 },
+    { "host_rflags", default_supported, host_rflags_prepare,
+      host_rflags_prepare_gif_clear, host_rflags_test,
+      host_rflags_finished, host_rflags_check },
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     TEST(svm_vmrun_errata_test),
-- 
2.27.0


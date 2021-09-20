Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89979412A0F
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 02:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbhIUAtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 20:49:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1032 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233661AbhIUArs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 20:47:48 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KM9TWJ000513;
        Tue, 21 Sep 2021 00:45:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=X3Dcu4BD8KeuhnwThoJlaQebOhVvtkY1ODCNIn2W7j4=;
 b=hIvstuZT/CryQtXH8XDg4eoxoRiZVh6HSetzqbSFPElvZjoX9tgZ/VS8sRJ+p+kXzc2z
 Unw80eYo+/jjzti/8jM0yM9F67PcEpHCz8ZrvJ6hyX6Xdbtev5k6rwW7b9pStnzzM72t
 dmV+OV1AJhc4415ZLlrLbLeZfW7wrhxws5SrIRf5P4ro6Vl2A7kyVFF83ekw61nkkd0r
 6LpV11sy8r4dh3/2zIZcvlWCtlwDBZD5MOMZgsudbZnzBUC9nA1u7mQSBGxVJVbwgMgX
 E0PxqW/QGxSD/dd2cF/jfAb23wd6gQQih0vZFCLQ1pR3dF1od5lU/TGf6xWB93aX/zdR +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66hnn5yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18L0eshu023679;
        Tue, 21 Sep 2021 00:45:51 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by aserp3030.oracle.com with ESMTP id 3b565db8cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EinEddWLGoRoMxMU393ysyLnp/Cm/9D6Ki+5G9bdOaG1OTkFJVvBRA/If4FK2VLv+9/6U/tyhsIgxkOFrwlK3UKTSumkbhhvoeo4CDKJ7xWS59d/Jujk9fX/YF2CtU9O4D+Cz1KUZm7xtgteznt4nkT9LmLKuyDGS+EoNBXhVXreKekmN4rx90SPKV/TVEVDwNNBDglIfMT/Lt2sh+ovtbzWlUaTWSzD6585aF4BDC1/D6BrXZE6E/sbUmGdw/7UNGeCbkqesSVKKHsMgioYKun/pPeiHEvmNNM4yo1CwPhumkhUnjms0+s3P50wMi3OfEZUi/ul36h09fmNDBSNIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=X3Dcu4BD8KeuhnwThoJlaQebOhVvtkY1ODCNIn2W7j4=;
 b=OMn57I62Vw/vsof38fF1MNzkS7rGaC3CBoSywb9Phhx+EfSPLaUZgnICFGgk7gcYLBeFTWplcTKFhwUILGNjl1u/9xeAeXsOgAYiU+osrnVj85IWi+A+ocpxyA+wPyazvHzYOsnVPDOaTe+Db8f7eTMroDcB7v+77jaaazwBTuYh8CETLYOmnjXCjcTjLwwfzO60u2nRa7s0qgpdTVvDc6M1fh+I0r2uZHoZ3w/zsFGSEq0VpXGdBr5X4GunDRgNO9qpshMTW7+Cc7gzd/9BAe+4CPHJHrdaU5EDzuehMhKZcNdqE04p7/qpo4wQVyGqNGDXS2qS7jec93n54eul7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3Dcu4BD8KeuhnwThoJlaQebOhVvtkY1ODCNIn2W7j4=;
 b=I4XWwzkttkmmKaZ1iQWUGf4LYMWefBlSr0i5Ok6cds299fjVEADqkG0cKZXaMb7NperXLXDy1F7QTF29OsXuRlOwOwP7CNuYassTQNSa4K894OYGRKoy9ex/qRANIiK2aHYsrxX1hBmNMnWbbh7T7rXXA6kxfsO7y1VO5bEqfKI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Tue, 21 Sep
 2021 00:45:49 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 00:45:49 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [TEST PATCH 5/5] nSVM: Test optional commands and reserved encodings of TLB_CONTROL in nested VMCB
Date:   Mon, 20 Sep 2021 19:51:34 -0400
Message-Id: <20210920235134.101970-6-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::15) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR02CA0002.namprd02.prod.outlook.com (2603:10b6:a02:ee::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 00:45:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e1e42fc-7d4b-4cdc-e305-08d97c99282a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4426:
X-Microsoft-Antispam-PRVS: <SA2PR10MB44263BB8180862017E2F39FF81A19@SA2PR10MB4426.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lz6S435vWlRATxHB4nPkCFxxleeIA9sib0tx1X8R3g8EEmZqdclF23XypKq7nYVGwjHljbSRl5Qd9BMJLtWCly2Gy/Rqf9V/ZE28YRajONKth3MlVqvpsQ4T1Vonp6u4c6R1Eh57p+QIgdgfRZyuQT87nxBKC2je0XtxOPkyPntktFDK4UdCukrVu/oZgH6MQm+QN4q8Ru0zg73DDliw6yg7/EjZQgSu/lTTVrHFiVHVGQdZEGhPG/wE2s1lmlkWjkxiClMNTIQYeJlSitG5M7WeFma20y1/t8+Vxo46kbruYmpjFu93f3HM0xpXlsg8fskB9u/CXVXU5fxQpztuYLgpQ3Crb3CVQPK10ClFmvjS/+ySfYe+Ea2qbjV31WNUwyzUdCkxgF/jyzBCJKIV4DU2VohC1kAqFoiHtry2F74eFg3QGZrzvxbht6r9nO0dEucx0RySgMwxsPoECncOSGN1ELWKQIlm/VwvqCqn5F/pp8Uu+51oF6G4shaaDiFVghzmOTETwmTjPUrfOUarCyQNc1V2H4Vd1XciQJlppRkYOd72dtWcMJbZ84QkPPud+2vuW7o0hiNavtECkCiatbXGsycIerJj6eNl5rE7tjFnlrx3AYN2V0SHcjVRTa2RBlZOYfrKipiQuPtFE0N3Diq0jQRHOyqq0DFtrn6SQtU28pzUS/HCGJ9cJMMj81UQFaEwEVVEYZ/mM1JCrvvjpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(2616005)(5660300002)(2906002)(66946007)(956004)(66476007)(66556008)(6666004)(186003)(26005)(8676002)(7696005)(52116002)(38100700002)(38350700002)(6486002)(83380400001)(478600001)(44832011)(6916009)(86362001)(8936002)(4326008)(316002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YqS7XUQtyjfgcoaWeqzJDCSBt1kA6ube6Rj7T8oAIfXACjPnlZbv9s4vlMi4?=
 =?us-ascii?Q?juT5z5TxQXtQEXyoa7OtbF3Vz9GbdlJ8KHPTGY5rtAgsFRt+Twvq3GppEzXL?=
 =?us-ascii?Q?ml1+IDAEQ1Is5WAxnoQGTERUcgaBMhlMrKLo42OcpATb0rKCsDtuikhSTixB?=
 =?us-ascii?Q?f4oyiV1AF5SFaBDVlH0CdOqX5r6NkhWSFnpUGDzud196SSR2PV5wfJGOc1FJ?=
 =?us-ascii?Q?OCptMhprslKXlPVL6uZXfOXW30gGkOcQHSnRIJPVz4AitbpFeP0p6K1E6SUG?=
 =?us-ascii?Q?V6enuwq0K0iSaLEIuyLyffSLW0QI2n55lo/GsExuXardneLoUmiJPfNvXoEy?=
 =?us-ascii?Q?lnFrMwis88/Znhjn/QAUtZ68s/t46Sn3Ondts92hlPPLK4zD0gMsyc39gUyI?=
 =?us-ascii?Q?tIx9ekW9Yq9nrL1HuGzO+mt+5nsz4I61D3O+jvKz43qZPzX0G1yZ+k92XleQ?=
 =?us-ascii?Q?PRPi+3ld/F+sWfQ5aCKvBQFaFYGghPMIK5yMDRxYaXigkKynd+jncu0O6i10?=
 =?us-ascii?Q?+RUUBFotKtehuqjFD/TPITMpaBeQB3LCnYhSz+PYiBcF5Pge9w1y2bFjkJv5?=
 =?us-ascii?Q?l1ygGTnnGNRUMarwXYZCPpoei5aLUVgHt2+ef2D6yRPWAsAudxx9lzqhk6eU?=
 =?us-ascii?Q?MH2iUReLn5zcj+UcIf41rMERTIQKLfQashXo4fyhZ9+V/lwuJOLgqgZoHNmp?=
 =?us-ascii?Q?vTvuTF0WhtIHwCXEKSUoqPeuzEF5t3z46R5d9stRMyRa4lmCB7KyeTDen3w9?=
 =?us-ascii?Q?5NVEDMnwqdhP+2og31doMzTTG/g3Qn0rDGGJhfcLOIscw5Tvtbv7ZkHE+kdu?=
 =?us-ascii?Q?L7qShuFZvzKOvlXAMY1ufE+lbYSXVOwDku/0QKrImVYNzvDXDpyidjaCQ31D?=
 =?us-ascii?Q?DCtXBr3oVHrABcH8qsbQAMbOUpHmyObxt48xPnYmYRdgZ5TIX54/SFxeqn8B?=
 =?us-ascii?Q?pEA/jpSGDDbTsCiqRhxwwsElI7SAUaopf1spQU7oCwwPb4gmlb/uwTlSIJBS?=
 =?us-ascii?Q?V0+xQr0qvOv5qoCdYuhpRLUPgQLfJlASaFZOkFmV8VsPIb/PWj634Uwv0DFS?=
 =?us-ascii?Q?OAaU3860dLYAIPtemDPrYkNNvFotipIPg0fT3q5ff26NstK8PNiVuSa+9zYb?=
 =?us-ascii?Q?c1p4BocWRjfk93GEVA1VvjVkzsq7jP5oPk/gBXnCPlOgJUXU8jB8DLjcChrz?=
 =?us-ascii?Q?EhG5cZkaaccesJf25yYeQi7dCiXEdBTzI2DCRUk5P3X7NB2A/6fsSFcTYJJt?=
 =?us-ascii?Q?9S3Gnf7XClJv6hHIl7/1yxt/ShMJ3gyKiOZeG/ZZEtfx9sYHejtOh5FM3hol?=
 =?us-ascii?Q?kU6krCGFtnjhwEW05E/9BgGl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1e42fc-7d4b-4cdc-e305-08d97c99282a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 00:45:49.7474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tacHCn2hVcCJIlMWb+/hmwV7uL1OSMspLBegnCGYEzeAaCDYAMKKt1L4wn+BI1u3fb7Ql5RxNr7bLmOdMVyAPFMztp3Hi20HYeBWy6Hd3fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=973
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210001
X-Proofpoint-GUID: PBtsn81hiJuf1maku2mAFMdSngfnsiL1
X-Proofpoint-ORIG-GUID: PBtsn81hiJuf1maku2mAFMdSngfnsiL1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "TLB Flush" in APM vol 2,

    "Support for TLB_CONTROL commands, other than 0x0 and 0x1, is optional
     and is indicated by CPUID Fn8000_000A_EDX[FlushByAsid].

     All encodings of TLB_CONTROL not defined in the APM are reserved."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index b998b24..fa1bb89 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2562,6 +2562,41 @@ static void guest_rflags_test_db_handler(struct ex_regs *r)
 	r->rflags &= ~X86_EFLAGS_TF;
 }
 
+/*
+ * Support for TLB_CONTROL commands, other than 0x0 and 0x1, is optional
+ * and is indicated by CPUID Fn8000_000A_EDX[FlushByAsid].
+ * All encodings of TLB_CONTROL not defined in the APM are reserved.
+ */
+static void test_tlb_ctl(void)
+{
+	u64 tlb_ctl_saved = vmcb->control.tlb_ctl;
+	u64 i;
+
+	if (!this_cpu_has(X86_FEATURE_FLUSHBYASID)) {
+		int ret;
+		vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+		ret = svm_vmrun();
+		report(ret == SVM_EXIT_ERR, "Test TLB_CONTROL: %x, CPU doesn't support FLUSH_ASID (encoding 0x3), VMRUN failure expected",
+		    vmcb->control.tlb_ctl);
+
+		vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID_LOCAL;
+		report(svm_vmrun() == SVM_EXIT_ERR, "Test TLB_CONTROL: %x, CPU doesn't support FLUSH_ASID_LOCAL (encoding 0x7), VMRUN failure expected",
+		    vmcb->control.tlb_ctl);
+	}
+
+	/*
+	 * Test reserved encodings up to 0xf only
+	 */
+	for (i = 0; i <= 0xf; i++) {
+		if (i == 0x2 || (i > 3 && i < 7) || i > 7) {
+			vmcb->control.tlb_ctl = i;
+			report(svm_vmrun() == SVM_EXIT_ERR, "Test TLB_CONTROL: %x, reserved encoding used, VMRUN failure expected", vmcb->control.tlb_ctl);
+		}
+	}
+
+	vmcb->control.tlb_ctl = tlb_ctl_saved;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2572,6 +2607,7 @@ static void svm_guest_state_test(void)
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
 	test_canonicalization();
+	test_tlb_ctl();
 }
 
 extern void guest_rflags_test_guest(struct svm_test *test);
-- 
2.27.0


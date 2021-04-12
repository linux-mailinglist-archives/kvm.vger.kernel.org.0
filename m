Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBC735D361
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbhDLWp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:45:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51640 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343834AbhDLWp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:45:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMdots178396;
        Mon, 12 Apr 2021 22:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=2EMn9uMFXeNgQNiDVN4wYZm/Gnofl2uKwEUkz2ZMcuw=;
 b=luD9/8Ww5ALEuwPTH9yZH9UQ2f1l+Chsw1gbQg04TjwcTaolQL6Ja8e0gylnuN34+lQn
 dacRVTKfrANC4BTNZGRS1A0MHyFXPlXW1XBYQWR/XI6Hym6zs98s+xrrpIoA8PWqpp1v
 xcbbMR7IDJniFZXsJmfKYF8o/R4U5xjm5WQTG+cYwpkBzhFW7a2Gla09rtx4k5CbHDvL
 ObsnUMdQL7GEBDSyA3YTZVc9pg7uGq2SumyK0bmhNIXyMncg+NoJkLL0wNxrqVQVaWad
 RcvW0Vtr40l2/wrtcWZZj7zfDbFx2TcOVl2cxNt+l2DWpBKRLOeij55ov5SQe9iXxlkC ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nnd9nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CMfR7B009071;
        Mon, 12 Apr 2021 22:45:05 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by userp3020.oracle.com with ESMTP id 37unsrhcft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 22:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wz49uRnYwBN2cwMKmXnj9cJNE0Z/L8BFbL3qTgjgO93TNKaUBVeM60EEIV/acVzmS+W+WKjKoamKSDQSfi0HaMf7kV3AiD2MUVOctRHWLk7OfhiFAkwEFFW4cJSFIbcDUuDgvYfdESp5Tl1Hi4WqTjo/JAwmDmG5Fnh8B09rvNPKoVdtD7TGCS9vSrmQWwW1vhworS5LwVsvzBaq2SmeoW6A/0Dmio1rTWWlArppz6HARkUGlJTBoGQy/qKIj0F09xoKxOZKwqtXtTcrs7c/3gQGla1am/uj3aEiQNTeQje5AFMEjzKbta5bgpqbjcS51F0iMfOOkgeU8Ert5SrV8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EMn9uMFXeNgQNiDVN4wYZm/Gnofl2uKwEUkz2ZMcuw=;
 b=fDGegYdCfxAh4nIz1RQtVlWQ6LxVG3FxAxEX4WAxmh7QRoEkNPOJ0UqEtqdiV6MO29RYin8SsyCjyfO/QAzST1XEXZ/N51gxn5KlCrpAi8dL2HXuVj7iZdKzbfx280ud/1OgMwChEvva7tTnF3azzDDWxyo/vFMtA+8dOWueBZQw6GrjXe71OkH4+N/d4dEKahL+pbkt70MLUb1dDiRz6IMoCbfGfKcQyek72m36gqAlWLNMynxGDfa/n1KeGB2pluSdAPHTfMzg3KRtPPnUiTRJLN96Y16RHtT/gYFpILlJkLCW8hoAeAx/7xQc2FiVeBVSq0Exoqm4c9L5RNOOIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EMn9uMFXeNgQNiDVN4wYZm/Gnofl2uKwEUkz2ZMcuw=;
 b=B0hcKZdW6qKRRVMFfEv6NUGoa80Bf2BhuoLYatQUp1N5vOkvJpoOIzs9ShyXo9nzTxT6CXTLWEGDNBq5KVu99VWw03j7PefnlqLA5HHBcRSF1Svo1In4UTL6GEzWpXk4UxBYRQLlqO9/qm8lpQ4EUmkqEwmgTfdlcE9Z43RnALc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4683.namprd10.prod.outlook.com (2603:10b6:806:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 22:45:03 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:45:03 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 4/7 v7] nSVM: Check addresses of MSR and IO permission maps
Date:   Mon, 12 Apr 2021 17:56:08 -0400
Message-Id: <20210412215611.110095-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR06CA0058.namprd06.prod.outlook.com (2603:10b6:a03:14b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:45:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbfd420a-f913-4729-8a17-08d8fe049c50
X-MS-TrafficTypeDiagnostic: SA2PR10MB4683:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4683203E0939949CABC1304981709@SA2PR10MB4683.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJopkmi9VaeJ/F7xXLwJKxj4j/Q3khmKx7jiOly3MvTYOtd0/qKrccM65ljKlTLEr/xbiL0hYseghqwQqvsYCUIfRNQD1vYqwvO6rv9GC3OoCQeOWmqf19/Dwv+PFwEyk9aPWkUy1dizJNX8590BH2nc23ULH3Mo/UaYVYRZzHh6oWz7Sbq3QL1VJnqLqUJ6+KGda1sPPdXReZ0aag267H84S9gxQhZ6Vs1BQqs4I222pZ25JPCDakfz7lxSMrlkgBxQeNCO/kJNPEml8eipxyQvCVpgB81ne63Pb349j/SVB7JmRZN+TSBdxhZnq1IpdH61zztTjqK0VfCQcw9RCwNgoVHVZV4wFaxEnf+Mp7IxHeHimR7x8kEEueQxnNGjQNAZZk6wzKF8SoznjPbxwgygOlFPnBdCMulwUbvK0nxjG/8D3ZMulU7icq8yfcXtYBi6xeLD3CWrhGLyys/fqPn3Cg1I+FgSOnl8eRymsFhLD2SrBRNOGkLIAoZp7ldjWT5Elf8JAKddvA0pIh8Ib8gCYH8xxzl5bUUwl0e2YrniopcwbvTdXgFklp9utQogdsGZbjvtu5abI7hTRoRFWpYbfVse4Nj7bjBf+cIJB7cJM1sAdu0WzAwFnNQTjmuFKiOO1BBQS7i+V0PDfgZJfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39860400002)(86362001)(1076003)(186003)(478600001)(26005)(6916009)(4326008)(8676002)(956004)(38350700002)(38100700002)(5660300002)(66556008)(66946007)(2616005)(66476007)(2906002)(52116002)(16526019)(8936002)(316002)(6486002)(83380400001)(7696005)(36756003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CKBZrMM3/nCBF8kM31+JiwZTn98opi6AMFeFRAPHqGyqROshyRKKC6SOrqIl?=
 =?us-ascii?Q?dk/6CaY8vtwnn1P1Q5Lsy9kGp4XBr7JpCKn2fEogjPDa20Z0vr5EnfD06g+j?=
 =?us-ascii?Q?aDKOV4xRAeIxAe9NN33fKohMpwjJrFw+3/vm+UosH5F7pUdmFfO12jFTj59V?=
 =?us-ascii?Q?Q2yJBC8sWa/IMV13/a4smynnVzV6z4SmgXSozmD23pbieI3MPyznnSRPoFp1?=
 =?us-ascii?Q?8HvESYRkoFvZGbo7PodHIuMVleXFei7r6mUQXxLE3I+VVtCsvr6ooz2QzaGY?=
 =?us-ascii?Q?+o25vewQyskW9lIsxY84J4ts7nqy0WriUwm+rqFDDS8XCE0OOxFw95XxU+rk?=
 =?us-ascii?Q?8foFywI39ns31XoiUX2O5VEWdSMRfuhqg2W0yTvuyQqpntP4umsqykEixUA2?=
 =?us-ascii?Q?9ki/alKonF/hnoNbCyG8Bc41oV6i2iaEZ7x2sO0mHRacBq5fzucN40UAeglh?=
 =?us-ascii?Q?i8OqOpcU8ROXzhoOP512ausBI/oKZPwwG85ocB1bS7LOmAsurRnq/QeUcDzq?=
 =?us-ascii?Q?xxi113YltYWq6mvocI7BmhxTW/2HOhOGBisgg+9TMRK0dAdpCE+SU2/M/MTw?=
 =?us-ascii?Q?VS3WqWFqWtAZl+/A08tvpR/Hj8meJizz9Xlle0yCHX7DpqtNXDgv6MwotjP5?=
 =?us-ascii?Q?m8tPAxJc6VwrgG3zuj/xsPohYA6gCmBQ6H4HU+vS9EVHPP0nD4XOB4+kec9G?=
 =?us-ascii?Q?jwBw3HRtZnCjwj/oD6bpPWHXOBQZcSvkjcuSmxYw64UbypOHqyflX0EbHKyB?=
 =?us-ascii?Q?WjKXja+73UZhDUBRq+Xdlr0mgOq9mTkNURJbJxJ35smkBeXGYijbkNGfB75C?=
 =?us-ascii?Q?bvU/U5XsM/7BBDVepjrDxHeZckVhoElEQmE+YwJ8y4WhCqNxuULd8791duwf?=
 =?us-ascii?Q?QmU9exdDz0ACj+3FGLLYmI2CzOEsbBKAhywS0X/XYzMnjvEaGSdzlCwVtrrr?=
 =?us-ascii?Q?2NDWkijFicqG9vazE1DcQitweJTtjN2dsCTp/vPba++5COiLAO8gAw2WHt/p?=
 =?us-ascii?Q?5uFjws9FziM6oIyzgqDav0XguLjYEaEOGkVCwvanNwFwvLYe3f5K7IkDtzTV?=
 =?us-ascii?Q?EfCOFm26GDotQTo2dUMZbsO5IKeFyYifkRyOmvTfc/RxlB0aJMyWrCAlk3IR?=
 =?us-ascii?Q?CzUQMtv+uXOIM19O0jo+EcOArnNMMJDlMDJFUUcAXZEkAibgeuQZLhp94LjD?=
 =?us-ascii?Q?eFY3DWR6la5sibf50Wx18B+IsuILIw1416luJR+UdBMg6Ad3EcghOLXr/v7n?=
 =?us-ascii?Q?ev50/JOhUPAkrx5IPO541Gk4WjeM5pF1lInhFHXWSB64AKVwTg1VK4caMLSX?=
 =?us-ascii?Q?/trbSlYShCxuDAI4SMwYvIGv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbfd420a-f913-4729-8a17-08d8fe049c50
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:45:03.0632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPFQaqH2viQAea1yIpq2nGy8jJ+yTK51qd/eGxhLg8hds/Wt/si29TxZzbgnf9wCP7J+IdS+SVSEoA3Pf+DuxtwIk52lOt8ui6wlyRNAnMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4683
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
X-Proofpoint-ORIG-GUID: 2nx2ij2rwEe-1eL-VVyiB0A4TWjnGDT3
X-Proofpoint-GUID: 2nx2ij2rwEe-1eL-VVyiB0A4TWjnGDT3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120146
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
 arch/x86/kvm/svm/nested.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fd42c8b7f99a..c3e5f4e7c987 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -215,7 +215,19 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
-static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
+/*
+ * Bits 11:0 of bitmap address are ignored by hardware
+ */
+static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
+{
+	u64 addr = PAGE_ALIGN(pa);
+
+	return kvm_vcpu_is_legal_gpa(vcpu, addr) &&
+	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
+}
+
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_control_area *control)
 {
 	if (CC(!vmcb_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
@@ -226,6 +238,13 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
 		return false;
 
+	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
+					   MSRPM_SIZE)))
+		return false;
+	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->iopm_base_pa,
+					   IOPM_SIZE)))
+		return false;
+
 	return true;
 }
 
@@ -602,7 +621,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 
 	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
-	    !nested_vmcb_check_controls(&svm->nested.ctl)) {
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = SVM_CONSISTENCY_ERR;
 		vmcb12->control.exit_info_1  = 0;
@@ -1250,7 +1269,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	ret = -EINVAL;
-	if (!nested_vmcb_check_controls(ctl))
+	if (!nested_vmcb_check_controls(vcpu, ctl))
 		goto out_free;
 
 	/*
-- 
2.27.0


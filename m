Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCE732D88F
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 18:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbhCDRZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 12:25:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54304 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhCDRZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 12:25:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 124HJECZ047378;
        Thu, 4 Mar 2021 17:24:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=QI/01gCYJtbVwXjSZMN/T9wCYTg5pnHJm1SftJjKZlQ=;
 b=hnngr2vLV8TXie+FLtyLXxFz6G8GUOHWGQ15icIBwkBp9LCKVJbCb+thomCfZHZm59W0
 9KlIdQdchVNAdZg1VMkSBjiT2ZNYPe0zLtucEftMRrtM8HUD4Da5gwohlGRYG5WFyJW1
 7scdTlmc0LSgEDacs97pV7JsM+JIdjiZE1aobY2q41EPPXkHKRffVSl7dXhhr3gehw2m
 9ox5yIll1Z1c2BcH4q6+YdhjiejLpX/xGtiL8ZN5Z+fNiX82CiALaVgUOfKsc9+XMcwB
 pqepveLHL8nd8tc8dxpXJvkSobepgcC4TEd20Dx9AsI2h663KeJScHcdL6MwpHFmu6oq wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36ybkbfyen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 17:24:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 124HL8JE156527;
        Thu, 4 Mar 2021 17:24:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by userp3030.oracle.com with ESMTP id 37001143c5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 17:24:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQuODTMUDXBu38Z+dp0ZSWfY3eK+qOsWmEM+3x0ZXftWTphnLscGxdLpSmje6lfvQ6UrZJ89SwjrDLJZFEcWrES0AfrUURRM3bpEG8zvjD44mQY/qqwV1jFdzjOBRwVcfMKyDzPqtITGPK5GRVM6HOgqsv/67if/oVlJYjgSRshZ/wtySppyaQqdiARIdS74C2EaK47Odh4Gt/y4JewR0KSJnSsrAD9oclYflAifQ89bei8r3DZ+RQnRfoAbEVx9DnqOPZL+f/50HUekpuyizjGZmDZwJQ2weCfWVkvYDF8Kb1DoFaBiOMsm7E95XVG7StJWMKVT1icI8sGCGENNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QI/01gCYJtbVwXjSZMN/T9wCYTg5pnHJm1SftJjKZlQ=;
 b=cYosle6c0tBD1hydm4DlGgkHX1M29BDXPjauzah/wQymCL2yji/dcVCqCebPFLKS0uyIQgnYLn6rQUPgCJyLpcQOVZBJNlLIiQVxlhkuCJl5SrxTcgDXhqqi5gOF2YoA2DNlCT5NdMsI/b38KKLbgR99F8SiWWbNKlgPaMk87KoJ/vIIwTGv9ru4I5Pg6QV0WV5rkm/zVnEVhO6a/ZMdxryt1pSEo7k/l/GO0JQchBICiutN53fR+neubE073J92chxgpOuYHs1zQmAQJJ78dnD/42knCjTPdmEFJ5WvvcBfPrfb1YjJl9MpuE6EqE08PT/A0YQCRAO9ybHRLXlP1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QI/01gCYJtbVwXjSZMN/T9wCYTg5pnHJm1SftJjKZlQ=;
 b=nNibweOppJOD/Z3RWkJ0fVHpKcgFpyPZb0qAcw1pZUwPlfCAxnBh8HYCVv3S4on2FDvKEY+6rXGRU47MsQYGIpTFJ0ibfHuWCMnyvi9zJBG7gKI+7tNPCZD1hnjiJaXEKLXsfYPXiVLmq7lps3/YZUjf2Ie205ptS9aatQtr42s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 4 Mar
 2021 17:24:36 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3912.017; Thu, 4 Mar 2021
 17:24:36 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH] nSVM: Test VMLOAD/VMSAVE intercepts
Date:   Thu,  4 Mar 2021 11:36:13 -0500
Message-Id: <20210304163613.42116-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210304163613.42116-1-krish.sadhukhan@oracle.com>
References: <20210304163613.42116-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: CY4PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:903:77::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by CY4PR06CA0025.namprd06.prod.outlook.com (2603:10b6:903:77::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 17:24:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b0dc5e9-0ff4-4c04-f861-08d8df32620f
X-MS-TrafficTypeDiagnostic: SA2PR10MB4682:
X-Microsoft-Antispam-PRVS: <SA2PR10MB46824CEC6DD4ABE7EF9237F581979@SA2PR10MB4682.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IoX/dEJf83hXkbAEexhFQWdXn0IyqXInxd5kVp0sBhQZ7RtApOyO/abubeJ5PEAKv0tOhQQl9DuoElX5OTnGer+uDHfVMVUbND9tq1JjosT8uI/zx7Gwi+S92U+gwtDvXkVL2p1iRETQncg/gtOi0oUd8DOC1lqMgF7sfQpRPcgrOcbkkUx6QoUrM0EY9YWxyo3V5QDGG9m3KhSR4UnwljatT1jbSEXa/B/S8oaAXMinVnurJDoEsWYrh2YKIqEuXWzZqS2lKPW8tNNNOGWkNKohTlEoZcvi1YQArBcBqoR1nseWKtarVhdlpeJ6OhiePEm2bNx/nP0rsm2eeSRRW8KVVdcLaOAIdO+vbL9bEQgDoK4YTpN+pap9YAYUVUqOROqzDOp9ZakECls4h49E8LZ688r7nLfM9eR7DHGaJ5hzbqwdAFu26AJsg71zZtFlfvFd5Q7uWGfqjhZvnjyrDxcac7voda7lZ+NPTGgVJfgxGkycNDhVSJX54CG0BdU72zZfSUyi0FynrLCXHT1kig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(396003)(39860400002)(6916009)(186003)(83380400001)(316002)(36756003)(4326008)(8936002)(1076003)(16526019)(2906002)(5660300002)(26005)(44832011)(86362001)(6666004)(956004)(478600001)(52116002)(8676002)(7696005)(2616005)(66476007)(6486002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xFnxcZGLCpXuQ48T7+B/at9XlPqkrmXPsKzgdSssZFG52AO9LUT223SLBp3j?=
 =?us-ascii?Q?bIsJ9doKDbFqg77aNI2CDlCXDsUk4Z4KO6aYtHV7YRNxOLkyNovYYfYcrbI2?=
 =?us-ascii?Q?8f8lFPMK0zX7+JynqNlFKg/iw0kY9EnAsI9lKIHgjBWGPc6l1E0RoLlfhjwX?=
 =?us-ascii?Q?BfruT+W6Gb6vcVJxYFrF1bCV8HZ6yuEzTX1QSE2EoQw6V2gZSZ0lltHO8FC5?=
 =?us-ascii?Q?OWfhSrQynDugyL4IRZ3m/YRQTrmajiLuOXASSnMdB7OMViRaLcH0L0YPHqfh?=
 =?us-ascii?Q?bQx3+MAmIhCh/RMy1JHYzBp4R8vulqCs/idcFtaDe6EiGnNe7ZDmsq+FLuuf?=
 =?us-ascii?Q?8ycg7ihD4qjA6LKFQx1R4TSQIZwIKUl7Yypcq+EA97ayhv3412xWsPwSH9yU?=
 =?us-ascii?Q?bV4dJq8c2c88rlAa37P/9gBcRshH6775gm3zs0nvpd2YzAu1bw89uLJMM58b?=
 =?us-ascii?Q?wQiaHodXAwAPUFzelwCWCg8IjabJu5rJGC8ie/Ixji3cZ5cScRa2epAh+lbE?=
 =?us-ascii?Q?wZguvIGYmNE62WD6yGxfzZQh93fCTFfPHw3tQXuY4CrrDPCrxPDV8lC0S7ax?=
 =?us-ascii?Q?XD7A/yy/rkYHbehX1xKg/0qw4NRdyBFBD1ut8Cc7Dz9O/Re/P5ZvflM5KABJ?=
 =?us-ascii?Q?OMJ7z+qO0EexMY5JmubSlTYPrIYcwYutqpEtS6o4gLQvIkWmJCyUmLq6OU5V?=
 =?us-ascii?Q?PwbHBGZYvNfXHxmpcIas59HAfze9KeRav5O+iCQuVfIhjSrrLQ9yWzpK88Xy?=
 =?us-ascii?Q?ZrTuX2BX+BGWKv/Xg0SVvhwr1GmjG+Z5xqpQEYWQJgbySwN7gqzT51y1ZOa3?=
 =?us-ascii?Q?PIKW3zdqd0vlyNlelImANqYiySgHF12TEsRg7k3i9KGLxz59KN8ojD569K76?=
 =?us-ascii?Q?bqfk0cWmO9l99Je5yUFPnGiFMRsCfD/o38bvKLbAW+ANq5IbWcmoxOqjp9vo?=
 =?us-ascii?Q?Y/VwF0EeVcnmU9ne8tLc6TanEh+tO8nKiCJEcBPeUmWzguUD/WsgGXIPdr1y?=
 =?us-ascii?Q?NGleheUAgTSzyHOIf2Qf52ksBX30mv0ugxDadPyDh9fzDVzNcrZFZXXynfvz?=
 =?us-ascii?Q?/rtA/fsbCzvbOV5utUMiDs/tgWdCYfZEFCwpHWxlqJPX8y4bPa3Y2easNFE/?=
 =?us-ascii?Q?IeAHnhdYBFa8ReynI7Vvmv2tB9DC+OGq6e3U0kcl7ktWGOaVy/HO82GoAngY?=
 =?us-ascii?Q?3EI9Mu/wfECZL2xAbNG9TTYXqEgWXCgauKG+b0egDp6hs2WpAyWp7j7AlSlw?=
 =?us-ascii?Q?PveFd9FtY8q5zHzsigwBq2uBrKB4EgdvMVN0nkBIcybKXcUzGBDDI3q+Xzk4?=
 =?us-ascii?Q?yltDm37UPckF59EWvgZWS1PX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0dc5e9-0ff4-4c04-f861-08d8df32620f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 17:24:36.1596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53njGOpv9ikVOBj/Q5c/7T8p525tdjC6awlh0XzxjjR411D7ja7+eG9IlqnYTkARsX8e0fhlOsEPItTJpJg1LFsSpC0FkPV16ScjZM/+orI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9913 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040081
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9913 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If VMLOAD/VMSAVE intercepts are disabled, no respective #VMEXIT to host
happens. Enabling VMLOAD/VMSAVE intercept will cause respective #VMEXIT
to host.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..7f4e63e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2382,6 +2382,69 @@ static void svm_vmrun_errata_test(void)
     }
 }
 
+static void vmload_vmsave_guest_main(struct svm_test *test)
+{
+	u64 vmcb_phys = virt_to_phys(vmcb);
+
+	asm volatile ("vmload %0" : : "a"(vmcb_phys));
+	asm volatile ("vmsave %0" : : "a"(vmcb_phys));
+}
+
+static void svm_vmload_vmsave(void)
+{
+	u32 intercept_saved = vmcb->control.intercept;
+
+	test_set_guest(vmload_vmsave_guest_main);
+
+	/*
+	 * Disabling intercept for VMLOAD and VMSAVE doesn't cause
+	 * respective #VMEXIT to host
+	 */
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
+	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+
+	/*
+	 * Enabling intercept for VMLOAD and VMSAVE causes respective
+	 * #VMEXIT to host
+	 */
+	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
+	    "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
+	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
+	    "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
+	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+
+	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
+	    "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
+	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+
+	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
+	    "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
+	svm_vmrun();
+	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
+	    "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
+
+	vmcb->control.intercept = intercept_saved;
+}
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
@@ -2495,5 +2558,6 @@ struct svm_test svm_tests[] = {
     TEST(svm_cr4_osxsave_test),
     TEST(svm_guest_state_test),
     TEST(svm_vmrun_errata_test),
+    TEST(svm_vmload_vmsave),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.27.0


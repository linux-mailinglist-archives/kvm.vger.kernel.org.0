Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3F130D15A
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 03:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhBCCRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 21:17:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49754 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhBCCRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 21:17:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132FliO008298;
        Wed, 3 Feb 2021 02:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=cOTE7Y8ZqD5+Y50rLYXL8ENXmTwJEN8O4esUDbNCmqc=;
 b=0dnuyx8gQu9oPUkKEoLyiMRuCk/v7Pl7pEWUVu1Jj3LrTdWUxZNWq5m0ThOcPTaemIo7
 1CSDOaxPv6FiW170AfKHHJpvW/wMnmTKgGMIeee1gELYCvzQIY9I9Ro5Iby7Gx6devpa
 7NAWUnmQvo6lC4wZ+Bzbs5cAgJoRvutUZoA5gCCalTUT9nezuk2Ac/UUiaNqHjFII5I8
 rOVPL1nEQeqqH585MDJhuM+zLsSy2w+yqctKdygZdfZ5NXsnr+ztaQMEeRBAeiLIZw/q
 3Xw29xoz5V8bWzOaMhw/YVV94C0LdEzXrhBHQI4fn+VsaM0MSc5Rz05TaO/yMqZ+k4yG FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cydkwq0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:16:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132Eanb110778;
        Wed, 3 Feb 2021 02:16:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 36dhcxqdsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:16:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD60Wu6p2y1tr7Ig5Pq7hAOVDqu9xdVJnFOyMoqW/z5qEl2FQiZgWxE80FTXRyc7PfuhevnMjlxo5jqOi55iYZ+mZJA++bU1JndGou0zP10TrWXqmnu9rt9Cy8fft4DudOgbGiv20QxcrZxk2oiiyUpc3Rg/x4VtTD7fSS45ADNPzELuls+UReLOlDhLMYxOgb+Z3EfTXRCNIYtwpj6R5MmBduQhSjkcF9Gn3HjwBu8QzwIKOQtjwB4aPWclbq4/wWrgRA3Ia5hoft6lBsFTUHuMuk4lDB3uSr6wjfH3l8nzkDBI5OTQ4CC+gUln8TARnE5vsvj9qVMH5jmjViC0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOTE7Y8ZqD5+Y50rLYXL8ENXmTwJEN8O4esUDbNCmqc=;
 b=CzOVDn2qLYzMM5ws1zt7LtOzixC7ZbOQVdINo6MI+Jblblbtghjah0LUEOT/4msaKPwlmfNNAdgZPf3y42VOoqSLYbctj0CQSeqG0iDHuJYd0XOmOOUrfxN2JSFo+Wtb8H3x5B3WWSsRTFziX3C+VJSUc1R+kc87Gt0cD4wBEDhxxycCd7u9V5lRnxJAxVBM0PLv9cevm0UZIZEFSSYE7ZxJATE3HFFzkxJ+fPTFvouRxmk3ANsNj/v+MOJ/XfpmGD4VzmC9r6aBiUuu+uH6wC2wKyLfB5ptXhSxAI18XsO09rPlXtN5mESSkwPHjbdvzPyqQbf+HmYwOwUBpxLBjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOTE7Y8ZqD5+Y50rLYXL8ENXmTwJEN8O4esUDbNCmqc=;
 b=Vove83Fe9nof2JZ6gacMN5/dNlPMx7W218oUmvUCvGMttfa3kcALrV1Tn5ygu180a6ORZnoc84clO9K3UDJ8wNlfaEVGErtJ74GGcwaOe3WISym8U2kWh99bSIMbTIFh8N9BC9rQOOoD03Q/cbBf3daOBFp2IRn55jwUFQ7e7FU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 3 Feb
 2021 02:16:47 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3825.020; Wed, 3 Feb 2021
 02:16:47 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/3] KVM: SVM: Replace hard-coded value with #define
Date:   Tue,  2 Feb 2021 20:28:40 -0500
Message-Id: <20210203012842.101447-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
References: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR03CA0096.namprd03.prod.outlook.com
 (2603:10b6:a03:333::11) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR03CA0096.namprd03.prod.outlook.com (2603:10b6:a03:333::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 02:16:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f5d3c58-c0c2-4856-e69e-08d8c7e9c182
X-MS-TrafficTypeDiagnostic: SA2PR10MB4793:
X-Microsoft-Antispam-PRVS: <SA2PR10MB47937B05D025DAA1670E274E81B49@SA2PR10MB4793.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MXbeph7s57xoFdBIbLZZ733u3GlhL8kSydX8IK7eBgJngM/CbXoqWYH588+iZk7Ez59aiW0DeUDTSOzEw083msjLkfpsKGVUX4pNLYwIimzDB2yTtSea4Xb+VmLYI6MjJuzZOiLPLdEXUuoOKIQ0WQKSwouPJF5IPMgq/uAMFWQkMJxkMSW/KyAaXxXuXLSMIh78V0jCy6q6oWTW6KyWYl3l3wyjD9x55ja7AE9yqmkBNzxvT63uwgd8liLlBe7LmWZJIaDpTIbCbWTyBOic6Qa29Pq1EW3yso2ULqfT0IwSgRzp4pTBWqGXAK6QLi+Ybdn36v46VQG6X2ztdU2AoZxV0ty/ng8xnXF5kMQxd5rMUVjJd4UpkB5ZPPSsRJVoOusNEf4Mp+YGYgNiKKc3LaWh9FgWrwpSCE6LI4IjBQSvtau6+ZXOr5bOcy5bru5u+BoyiFOnIzuyubavFudRxBlZa/gvapw5QjpRlOh0QW03cDug+OwOFnKDlEIasXMxSEWZaKjuIzrWq5MW8/lkzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(346002)(396003)(136003)(316002)(6666004)(36756003)(8676002)(66946007)(16526019)(66476007)(6486002)(7696005)(83380400001)(4326008)(6916009)(2906002)(86362001)(4744005)(5660300002)(956004)(186003)(1076003)(44832011)(52116002)(8936002)(26005)(478600001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m+tKoxS5gadJjLYOwMRb4i8bV4kz+TAnzAljPQXZ/5GOXZ8o0r3pVVCFG4FN?=
 =?us-ascii?Q?7kvLbtKrhH8zGMBPP/cx9uTWjJchGdvB5qcf5ehrPJfoNst2JDyCCZMnd+rJ?=
 =?us-ascii?Q?KEAc5GadehYEUH2c8MzcN+jr8bEKzVM8+7jNeH9fzrHfd8NmqFHez7YXcogh?=
 =?us-ascii?Q?tGIbHXv8CLIO3c3qcUbntzmhFmhKbsV9kTuWUAxBGti1+RhJvzNFRhEsX/3u?=
 =?us-ascii?Q?jkLYYhJW6OaVOMYDLgZZWHwYgCuCJfTkPRU0/k4hHQGE+quKiHT8jajst/BE?=
 =?us-ascii?Q?wUCdVBdXwwJjMYNWv5taX51dNb1n0pH170p3TbbEXu6Wc4nK9RHaCr2JYb5e?=
 =?us-ascii?Q?6av4Ub7vJ/X6XGC+hD+ifbwIBVryqhomfxIOFeTtQO+uNM1jtFeDHCbRqas1?=
 =?us-ascii?Q?mXXVZBlFT4s9Pk2ojSRsgJBfJUfVdSEZnP4MDvDuEZBCR/CVinwAjiBPfxIz?=
 =?us-ascii?Q?7PwdblYfxQythjdPJsnUuviF7IJy7eL4KF2dYoxoywbDTs2PH+3vayOeKAe9?=
 =?us-ascii?Q?oqibEWmSfwbGd8Hq/GPN1+ydRx1iXLBheB+x1N/Rdi+eY3tEdYcSr23QLh6t?=
 =?us-ascii?Q?rYGp8x1BZYJSwdS3eSQaZil7Mh/ByQEnh7wBCY9iECHxxm0OcE6g/jwcVAQO?=
 =?us-ascii?Q?3cz3C7kJEqP21Lh2e2zlRshHKKpbTPezArwW4b3GIuCOhQtorTjaMXdNbiCg?=
 =?us-ascii?Q?5wVHMcxSag+9/YfWs/wkOCxxWVysQeLSPKg6zwuMHd0yaZjkSBMEloAEbwOY?=
 =?us-ascii?Q?XnUaOrwlstMA2MJ8ZpPW44l+YwPxiY6cVvPHwNchNghOI/F4tkv40J6VZU6F?=
 =?us-ascii?Q?WVZgGptHhmLTy6L/NhWpkQ2g060c8OtoWIc7oEWVUewDk1lbGTQP9CC7sNkF?=
 =?us-ascii?Q?68SaC5C/Ks1kGvbAErQzBnc5DSsPczhdjqBttnPMikBw2K7MAOTCOKCU5Z4S?=
 =?us-ascii?Q?dg0+ITgtOetF+DPg0OaGjMuQaWf0ggsI+O9Za5GApJRjzZMrA77lP6dyz5K0?=
 =?us-ascii?Q?MlV+R4Zys/CXiNsExB3TviJhU4ag5DcO+832xpHfMAgUvYeWL+XTdXk4h+uc?=
 =?us-ascii?Q?R9MkjUce?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5d3c58-c0c2-4856-e69e-08d8c7e9c182
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 02:16:47.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbf+U6OkSJ8nvckq35fG2oeoPm8XdQuk3rd6SJhRqY2XATCOIyvde0Bu49og3N5ZGV8/wAD5c7v8y9iysL9Qgf10eIioppGnAV2n0BYII0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=849 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030007
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=906 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the hard-coded value for bit# 1 in EFLAGS, with the available
#define.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f923e14e87df..5435f5cb756b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1202,7 +1202,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	svm_set_efer(&svm->vcpu, 0);
 	save->dr6 = 0xffff0ff0;
-	kvm_set_rflags(&svm->vcpu, 2);
+	kvm_set_rflags(&svm->vcpu, X86_EFLAGS_FIXED);
 	save->rip = 0x0000fff0;
 	svm->vcpu.arch.regs[VCPU_REGS_RIP] = save->rip;
 
-- 
2.27.0


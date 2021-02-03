Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F20030D0C7
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 02:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhBCB30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 20:29:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46254 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhBCB3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 20:29:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131Nb0H136145;
        Wed, 3 Feb 2021 01:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=WTznxVx8ksFCjA6Rxz97G43Gj9FIcS+R1neaENZFKRU=;
 b=jh2UvXNtaNsQhn9FP3KTWF2TUIg7NuiJLNVI4sC0dae9xAltnRE1ebtzYEoyz5f3cirH
 +dQWWOs0gFQ+u/hRl8YLrBis86PH65+kppCwtVw87k4Xwk//+42KsHm4LNkRnbSiIMgd
 +cChHwDZfkxN2z3R9CWlkNU/ElKXq1NN8wEg+6ucDQHd8AHNHgbv4r8OZYfB1HKIMONz
 TVK1qxTUiv+AUkqRPq8xWlf7KqJseHRmtAlfZpD/Tc+IQrOyneaXTV9O0erhO+w2njkD
 Pc6mx6ry7ghN79C2nsavhuhqjBwXDBlzwh3PyAwX7z7roGruhmYnyicAI4GblRxMDD4c Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36cvyawtnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131QYPl101028;
        Wed, 3 Feb 2021 01:28:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 36dhcxnvvt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9wDruorWadUqqDTAnwSl0PN22AGYRrr6hh136WcTlJVBJ4GSsQAYRw7Lc+qP89GkGse77jDcsDAzpA6hu6hzKdKjB2zFtOiMf4ZgHZZi9QOKkrbfRM9IQPS0LXPRZkhDkChi1uVyAs3P98UHVy/Ion97hL3AnpN64T8zb6sNRYGZ9Qmk9xxmx0zWITSS5WlZYEhjLDL0vFfSKJPN54l4l233ZpEHtz9yN1Dzx7bvgkinNuDeUazMPuVFqBCCMsfyFk02HmLtFElv9zkTnP2iNkF4ZYku2RwowpAGF37H8R2Xz5Ra2ILupPAkqcR8X1cl6mQrq9l8msd9hVbCZOTrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTznxVx8ksFCjA6Rxz97G43Gj9FIcS+R1neaENZFKRU=;
 b=NV3UIKcg3HoJoDYX8VowRCBy91lS2ByfjuwEogF0i3Bgn9VXLoAKT1JiBHFN5ND6/RgmTB/zcwT/Q/93FFsyJ3IeOva4OChiLt6vUU1w15p9mlE3v0DAzR/7Z1GXP4SCAc3qLSoNW4NSvkZXhNoebSMi4uXl/N8SFBiaye3+o0BBw31G3yA4fFrZIKvD/xvioSqCciyVEYVNkgcQOeFyKzlzPJQbEntziGkx0lwBHJkOl0DPX0UakWEDAzRn8EOh/p3amQja4IrrfAuHTaBFyvL/HNKaXjJpcTWT1YA3EUREx7tPiHTpaSZiRbSwh3sNAAiIeh0xflxFWTFxJ/ADnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTznxVx8ksFCjA6Rxz97G43Gj9FIcS+R1neaENZFKRU=;
 b=DA+j5q0yDtc1lhqg5FyB+xRsmPXcz8E3QWmqkzAPPebiD6zfBGqhkz5pvBrfBtPX800TCwG38yyVjgenWs3ChtrYqxS/SfRGn0PKC1bZ3pKQ4MnlsS4MMkdyDmiJ4bYkiFXHWJ8DZ8TTCMopVC3SCmet03R50DVLjxSJto60uIs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DS7PR10MB4941.namprd10.prod.outlook.com (2603:10b6:5:38f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Wed, 3 Feb 2021 01:28:38 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba%4]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 01:28:38 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/5 v3] nSVM: Check addresses of MSR and IO bitmap
Date:   Tue,  2 Feb 2021 19:40:32 -0500
Message-Id: <20210203004035.101292-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
References: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR05CA0073.namprd05.prod.outlook.com (2603:10b6:a03:332::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 01:28:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d31b110f-102b-4b32-d1bb-08d8c7e30863
X-MS-TrafficTypeDiagnostic: DS7PR10MB4941:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4941074C40AC60771A3A033581B49@DS7PR10MB4941.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xaMtfsIK7Sjrgi8MMkVV5q/WYxK64QI6DIGAzBOZIuexjd3sVTXu5CCHobSN+ASmyfcgPBIyeJMUAEPeAtGyGfem7CMF2CeyfaARDBd2kcX1WWDNNoxBxJIzWbA42uuGCAiIXXA7jd+4bUF7L5AcFcA6nK3VqJ0LsY/ys/ElobRtWKUnYWPCZ3bZoc8C5rswSaIslRu6t7MEowNAgBnZEUGSWnVTXAG2M7g+j7E17grA4lAEI1zKMs0XezU41xgOvt/ynVOzLz5web8SlE6NHfiqUo7xSMpGKqnc3jM/NUpA/na98cSwe0CD6j+5SKWzMiLq3w0H8rGTNRpe9zKuCbR9oSfUpz3UgQp00ZE8s102KGCGOEekbm1hHx64mFmQ74pVr5TeMmEgX6+qe5CR/K20R3jquXYpUD3LUDqAuqs0R346TB29L4t20DvSKiYHIYrikRcBZa4Xy2Vx+kZT9EDF/A/4U1rRYp/Elu+P5AEyRW9yTGU2IuwXOBkRAW+mdP9NiPlwi7BfJivgP5cqww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39860400002)(396003)(316002)(36756003)(7696005)(6486002)(83380400001)(6666004)(2616005)(8936002)(1076003)(66946007)(2906002)(186003)(4326008)(5660300002)(86362001)(6916009)(66556008)(16526019)(44832011)(956004)(26005)(52116002)(66476007)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lS/ZdrRP8IDYm16eLEfEVLMR8jWF59C1z2SwjhjMdmLU5V5AKNKpNo4qxYKx?=
 =?us-ascii?Q?2URq5g/QP7OT/wnWCAUwH6bgWTu5arhsW7sgpDNyouFav62OEzEcgKclyIiX?=
 =?us-ascii?Q?L47GiFY7c/M+3RUbOef00Yj65+5V809Wwhsi6Act9V4IHyTwCwp6q8EmdrTx?=
 =?us-ascii?Q?4rw4W7elfZrgOmIDJXZkExJ6IeK/pSqBg4cHuI/LHuzLl2UdHQ2c1emn7bbf?=
 =?us-ascii?Q?prZss6r68RP1+tGaEu+OzrnYeu5gPbMo3ZdX5lYgsutOs+t55h++ZhgX+S+h?=
 =?us-ascii?Q?WxYSoH8S+RALU6QcR7YMNns4CN/gsMuOs2F/HRD45qtbLhLuT4LjfCl3W7ld?=
 =?us-ascii?Q?m6PmGN438telk0KSjOTbZ+BQ8KYTpDn7HG+2sFjN3F54nRSuu3JHkc9+d1Gf?=
 =?us-ascii?Q?TtezAXcJNkkzMUbQ9duO+AdZktppkhAiHuGneSY++syFLJS9ewaH4fz96lrb?=
 =?us-ascii?Q?ZmHJ3BPMqd020kBJyIwVQJCSzsNvBYwxTHebbA6cgLeqQhTi+BimYyeqrj2b?=
 =?us-ascii?Q?pMhzssbL0i6H+ONIEypEnvHFgSbvtpQnF3tLu9JQzC+PYyCpn1vyxtxhoD19?=
 =?us-ascii?Q?wDnWktL9n3wYKybHaVf4HI/F1B4L2tjChy4Zup1ev+0y0N7R5nI9DcbI0WyB?=
 =?us-ascii?Q?/hB4buDM/OXp+ExrtsPjSEbqG6xoXWEikagIH3d9nfy5R6mLFoQRQezTUTS0?=
 =?us-ascii?Q?STZHQaQXRbUhLRkXwkxhI3XDd4a9rgyDic4t/HRpTCxdXLoYlhg6Jbz4m89D?=
 =?us-ascii?Q?mbO6QeJFTIcOdtZi/gQiM+y7IC/WZwVhzbDfnl7GAlgeRdj9oclherytTwdl?=
 =?us-ascii?Q?HEnSRk0mlboG0Hac9bsxnNt4PfMbSP3IYvrEBCiNePRTgbmHJ+5I//TtERI+?=
 =?us-ascii?Q?ealCd14BJLcWWuA9bWfra20HBtWfDrJk3FhE/SF1QaulvZS2G+ASqB23LG2h?=
 =?us-ascii?Q?fkbmxVHIK4d/MpCz3uvtgo3bmRX0a6XYqkWlq/NccJk1C3o+8pfH48XLRGfj?=
 =?us-ascii?Q?nq1Rs0nmpO78a6TV2MlOGrxxqjJ2QpxkJdt7pgl/7BMLOBBtMbugxJPUOdbU?=
 =?us-ascii?Q?HEFiPWc8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d31b110f-102b-4b32-d1bb-08d8c7e30863
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:28:38.8356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85x3a7pMhr2XpIFCD85iPKi1KMQOXchY5behlSfxClf+ofKjwY0BY0MnTVmMYBcZViz4zwljjJafK16kuwwl3SVy+ejXnC1yzTg7yp6/hf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

        "The MSR or IOIO intercept tables extend to a physical address that
         is greater than or equal to the maximum supported physical address."

Also check that these addresses are aligned on page boundary.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7a605ad8254d..caf285e643db 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -214,7 +214,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_control_area *control)
 {
 	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
@@ -226,10 +227,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	if (!page_address_valid(vcpu, control->msrpm_base_pa +
+	    MSRPM_ALLOC_ORDER * PAGE_SIZE))
+		return false;
+	if (!page_address_valid(vcpu, control->iopm_base_pa +
+	    IOPM_ALLOC_ORDER * PAGE_SIZE))
+		return false;
+
 	return true;
 }
 
-static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static bool nested_vmcb_checks(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
 {
 	bool vmcb12_lma;
 
@@ -258,10 +266,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
 			return false;
 	}
-	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
+	if (!kvm_is_valid_cr4(vcpu, vmcb12->save.cr4))
 		return false;
 
-	return nested_vmcb_check_controls(&vmcb12->control);
+	return nested_vmcb_check_controls(vcpu, &vmcb12->control);
 }
 
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
@@ -488,7 +496,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	if (WARN_ON_ONCE(!svm->nested.initialized))
 		return -EINVAL;
 
-	if (!nested_vmcb_checks(svm, vmcb12)) {
+	if (!nested_vmcb_checks(&svm->vcpu, vmcb12)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = 0;
 		vmcb12->control.exit_info_1  = 0;
@@ -1176,7 +1184,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	ret = -EINVAL;
-	if (!nested_vmcb_check_controls(ctl))
+	if (!nested_vmcb_check_controls(vcpu, ctl))
 		goto out_free;
 
 	/*
-- 
2.27.0


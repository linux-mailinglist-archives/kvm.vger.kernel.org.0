Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13CB30D145
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 03:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhBCCLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 21:11:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54550 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhBCCLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 21:11:16 -0500
X-Greylist: delayed 2512 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 21:11:15 EST
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131Ov8o015765;
        Wed, 3 Feb 2021 01:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ugCSFC1iVd4a2j339N6QLI0N07JAM3x2IumLR0xXfOY=;
 b=YSXAMq9FgYJgYO7emFWT5UPbwnKTnHj2gd6S96kAkk6vDcLIuVsdYPZh9cFyMyjhz14W
 SQ47bj1ic/wRwP56uMEs8Ku1KP0JtXSgB9/B8Q/k31oz762jR48liHw/+3zxxw0g21rH
 P4bcf+UrSrx+diMSAnMvPKg9GM6Q/KL7ewfwDH6M/0nPyK1pZlANjmubysRCSANEAfrh
 bNA1z8yg2YXP3Cc5J2PInk30nLYXp3op99tVFSg05Kkj2cLV6os3Gr4gxFenpRpzZdLL
 7gYayEB2WPuenh3L4a+Yxz20ynZsRJiJ6dmlDQNPnH/3pDMFfJgHACIkPVWzAlR95TVy Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36dn4wkg5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131PVPI071745;
        Wed, 3 Feb 2021 01:28:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3030.oracle.com with ESMTP id 36dh1pxvu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:28:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfvEOdi0XukrcsYkODspwE6qh6fpE+Z2ARwa7SGHoou29bfYcid4+3R+4xo/fJ5+nHHXPCwZKBtvLWwPDbG1J7YmrZXOnBxF5TquKeigxaTz/66DY00QoPTDY4qCZqHZqrrHjxEf5dNXynTZwUOS2DBE9un4NQrB2LoreSNE8TJUXssMfFboNLoyfXpysgu5/4+tTimty4Yhd1ZCdU6X0jplNOXOXOIOccTQZ3uEz8QL60EnhB3XAKl7a2biKmZwPC6MfgIekYoz8R0TeuKShdL0o957L4QnHq3uNs2F/aYRs/yFBzznPfE5n7WCGhGlDyFAdiiTlJFppUFn9ICvMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugCSFC1iVd4a2j339N6QLI0N07JAM3x2IumLR0xXfOY=;
 b=m5oPyeYHbXOf7Ihg9zENfrGu7hjSCr89OLj96QamAcUYnbj1TWZRpRvr5nlpmeN0b/nnWoLop8lBgmYs4jTEqztPuqPNo+E/q+pVGNvksOgFVRVOJ8lSXBRahIXE5guHRRTdYlYbc52Rj1Xzo4VTYLJTLxLCcMtVC8RmVWjMs+MJ/gc7A3SC/cyM4PM8+uTxND04ISzqs4i6LJhmrdUkEiJmImC/ciI2yVg1njZh76sO6voH3I4AUgxLPOfawnKBDKgbiYuEKmc84YiQZ/TYbGPBMa7dNmT3nWGPEiCcAFDhpsmuIENYyl1uYXoB62Cncn+SXbqawJwCxJqX9syYWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugCSFC1iVd4a2j339N6QLI0N07JAM3x2IumLR0xXfOY=;
 b=hDN3UILJ4TWcErcaGHXhkTLkjat9GP79RF9d39nS9+iwoqX5UHKSdkF5dDRkbcMdpNcme+2Tum//CSJZ2qdwekbdP5YTu3n++Ycs/zXD3uekXZWKThJEDSKeVXAIbmfdHhK4oGKsEVdYQNi4FE66hV9vGkauf7PL3R5fsU1Qh8I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DS7PR10MB4941.namprd10.prod.outlook.com (2603:10b6:5:38f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Wed, 3 Feb 2021 01:28:36 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::29f2:ddd5:36ac:dbba%4]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 01:28:36 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/5 v3] KVM: nSVM: Check addresses of MSR bitmap and IO bitmap tables on vmrun of nested guests
Date:   Tue,  2 Feb 2021 19:40:30 -0500
Message-Id: <20210203004035.101292-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by SJ0PR05CA0073.namprd05.prod.outlook.com (2603:10b6:a03:332::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 01:28:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc03f38a-1ea8-424b-4476-08d8c7e30697
X-MS-TrafficTypeDiagnostic: DS7PR10MB4941:
X-Microsoft-Antispam-PRVS: <DS7PR10MB4941F4234251A5C55275588B81B49@DS7PR10MB4941.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e900Khiugn06Qc34vtzrtfXDBpoZxFWzx6QA06T2wPa/L7ceKoVoUdki+XWN9D6+D5pPdtrDynlbsfC0r6aC6WieduZB1xkOCwmn9Tn+CtoowywLnRgbHDrF4nHis1Kmr2xGEV/1l+2+qC04B6/oTocOwFPClim7QqCjsjonppQ5O33e1ist4jLbvtvut07k+oSV37zRGvhBnd0eb42rWktpqe99ZGvIM21zvLldeXY7693Cfw/b02OcJrvYMWdh47gEOQtHcx4UHxinWImkOIftkz4sjW9+Rdkn+fF7ewXtZsnH7FJt1bULbW5ZKYh4axIKtTJ+cMnrbW90eZH92sAuu4n0PqP6vPLmfk646TSA7wMaduAp8QrNg531jLwbDexC2IznpEPpcLSvtAvoRmefZOYZwf5xwr/cR+0uixqR4h3w06aI8hOaqhltmx3O5EwGkjov65XRNT4Z9kOatNsyhSOAGDj4juknHz5tFkoWrZWDKs+kQKhO0OP3KEmZr/IESfTqQC8+Tp4nznkZhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39860400002)(396003)(316002)(36756003)(7696005)(6486002)(83380400001)(6666004)(2616005)(8936002)(1076003)(66946007)(2906002)(186003)(4326008)(5660300002)(86362001)(6916009)(66556008)(16526019)(44832011)(956004)(26005)(52116002)(66476007)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yjjw2ny4qV36YHFag04S+MwEIaeu0f4xz8RxZrdhOC/fhKudl2R0iqsyCIlG?=
 =?us-ascii?Q?wc6xLfVExFYSFvwRnX+jdMl8Ug7fLgihtBeGnwY4w3eFRneddKt1zqEiIJ8Z?=
 =?us-ascii?Q?1GBBAyXQ0syMs/8qwQWbJKbnpsxttUqPFaAO7cChBnJWy9jkx8EEy9N0OYgF?=
 =?us-ascii?Q?cGgqLXJR2rMCrOevp82PSYWq6Xww00TkDfkfsopNSc6XJtZ8ZJP+Ig/D5kvz?=
 =?us-ascii?Q?TFJ1yoBVSSKSLtFaYOdelJcIvVbvFJt7jTVuD+jR80rnEAPRlTYJXtDOR4DQ?=
 =?us-ascii?Q?uaNHRF9TbdR7oXGaqohBYCZl5dadet0TakxUtZbHF0CAU1r1DoO2bsQEDYFL?=
 =?us-ascii?Q?eEGe57CN2W2KyxY0kthcXFPk4qXH7MA7YWVzAyHeUijulgXXdUwrVVqnNMx5?=
 =?us-ascii?Q?5FKRYx2ffu+8FevjvWE2gt9p8G2HX5SC36aAs7O85Q147IcXTFkkKwhl2+vg?=
 =?us-ascii?Q?iI/1SFIV8epBXj3xvt+928SL4URK2vbbFgYtC0y4q5hkeCn4uJpwByfNiSbC?=
 =?us-ascii?Q?WxJQ8M0432pSjBplAQN0Ail7R6t7I6F/dLMvwDFP8yPkGO2rqmB9ypfAtQrq?=
 =?us-ascii?Q?Ll/gpNj6ogIWGGZpqkKmoxjmguf3l8XoqVouCqmwGZHYoV9TjGB2AR7amaQ/?=
 =?us-ascii?Q?aSDIQ6V7NAA7asgSZHTIF/XQiMtQgvj2iafrgLVHRUGGVuUyfrmQeAPa6uwu?=
 =?us-ascii?Q?2e5o7CZ9/k/ShfzpcfFO6s89LiYK0vqHywt4CHgzqkt9dukaafzEkAV3pHAt?=
 =?us-ascii?Q?lFv88gIWXMzLgbPdPa/2rJyaROzJcj0wAXFD73vJtoX2qXyOHQ7bFQduE3CQ?=
 =?us-ascii?Q?VGNdl6NEh7Dnw2WJ2JgX+gTHha98f5Yeg2Vp5TfKtrp7A5duUCk4ZNkdh2KH?=
 =?us-ascii?Q?SvydFbwwUXIYM/zw9TFXHQzYjVeEDrMN9bJozKKC+hYy27n3kmR/YmXI47R/?=
 =?us-ascii?Q?zHmKsoXAGLvahhnZpEqmTip5RZ6Sa0Qdo7aWnT4vyqVLv0rrPHVAum3UrRXw?=
 =?us-ascii?Q?ViHPb6Jrzdz5qN2iyE0uKAvxOmeBmCKbeNME/dGNe30HFMxBG53x294tfW7b?=
 =?us-ascii?Q?SWGSFRPl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc03f38a-1ea8-424b-4476-08d8c7e30697
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:28:36.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSDDoZVLfzVxeDnfRxozZX9whGdqBhonNbQqd1MOMk+5UlJ/IdWwQQ5rw0CmWiKgtt0RyeyHehxSXh5lgVuFy2MAoisP+cv3tZjbH8fASJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=792 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=972
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3:
	1. Moved the #defines for IOPM_ALLOC_ORDER and MSRPM_ALLOC_ORDER so
	   that they can be used by nested_vmcb_check_controls()
	2. Fixed the wrong check in nested_vmcb_check_controls() in patch# 2
	   (which was patch# 1 in v2).
	3. Added a clean-up patch for nested_svm_vmrun().


[PATCH 1/5 v3] KVM: SVM: Move IOPM_ALLOC_ORDER and MSRPM_ALLOC_ORDER
[PATCH 2/5 v3] nSVM: Check addresses of MSR and IO bitmap
[PATCH 3/5 v3] KVM: nSVM: Cleanup in nested_svm_vmrun()
[PATCH 4/5 v3] Test: nSVM: Test MSR and IO bitmap address
[PATCH 5/5 v3] Test: SVM: Use ALIGN macro when aligning 'io_bitmap_area'

 arch/x86/kvm/svm/nested.c | 63 +++++++++++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.c    |  3 ---
 arch/x86/kvm/svm/svm.h    |  3 +++
 3 files changed, 39 insertions(+), 30 deletions(-)

Krish Sadhukhan (3):
      KVM: SVM: Move IOPM_ALLOC_ORDER and MSRPM_ALLOC_ORDER #defines to svm.h
      nSVM: Check addresses of MSR and IO bitmap
      KVM: nSVM: Cleanup in nested_svm_vmrun()

 x86/svm.c       |  2 +-
 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

Krish Sadhukhan (2):
      nSVM: Test MSR and IO bitmap address
      SVM: Use ALIGN macro when aligning 'io_bitmap_area'


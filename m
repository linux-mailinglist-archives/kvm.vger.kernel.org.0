Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93F530B434
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 01:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhBBAdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 19:33:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhBBAdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 19:33:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1120OGUb097502;
        Tue, 2 Feb 2021 00:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZD3O6UhLJAWSFXbqdeC30GFnxxsqy5F0A2XspSE2k3I=;
 b=PBia5cAmKQbTLfL02K1RqdfgADjeFbpPyPPXB+edblVO4k8uH4KbgexZd9qjwJgpTOCD
 t26wDioy/zJXbrC+Zwp08VpFF8Hk1scD4NnsgATR85J+G4ELVsTMoUqY5KforgIgi4mi
 lmBWxEq8z00CQB7gFSpSKzRmWg1iNZ3LyitbIIjKrrAAqSZP5jkf/lNW9vUmj6jVPMSo
 Hh2aesFDbkJpgRWPyU2l/f7rjaafi3Opqc6517FKc7Tl8zXQdJy5XB0DBzMYdl6i6vv3
 E7bsw85C9+oLoljjs9BzUkwhH2mmTfRdALhCIOxoPlhbAjf8rxa150FN/fuLyS/Axcdx cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36cxvr07u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 00:30:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1120KV5P186621;
        Tue, 2 Feb 2021 00:30:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 36dhcvt94y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 00:30:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lf4t45QDoB8vll5RTRng2L+O3TkPfHd9ckJcWVodwi4GawJMKYDpYZk0P1OcsROvpUty1ZbF+uiJ9cQhGrlA6GA9CyVVv+gS703oWInoicBFDuHqZp3+phPpXraVYeLVhZY8rHIAQx9KI4+03158RLMfkoeVIgQU0V9uxHkqBb3F0P6WQaKdIsfONCPEdRgOzF9cPnZaS9TbAXeRGJcHJZGFThErMCszIpNEP2GWnFDVcaXikK3Fr1W3r2x/pNoTI+L9n4uOUMGNnWlhCPR8xsltCbcMglEJH5uChlEV6O8WwewAqkVauYNZwCLSay8CwRZ41bSbDBmAURSVmPtyVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZD3O6UhLJAWSFXbqdeC30GFnxxsqy5F0A2XspSE2k3I=;
 b=DfasdOxinepCiln9Dct2P7UCfhH8jxG2Jb1uFLu1+e0DT3i+0GhuYU+ZajCa40teQBtZ+lAS7vSMRZnMhyOC1D/rybPImxSBZP5oxEdDLthF1mib/2MhnLoAf+vGfW9gMTx27hCFIvy6/6rtFutKDUlXMnFYxoKIn9Ar3ZjseLyZyFaSJ/8N/G9sFMoeJLPDbbLT5EDyWc5UpDQrbsWyGF+uvKI8UlBXJMe0ORzoquubL1jkFjsqsL7e07cThFBri/+ZJ6bL02ClCw3J3a1BlQIvqow3RthVjGoFHtwqbB7cRuKhhVhx0tmXsMycNLVoCsaFXViyRzz84jf1REzQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZD3O6UhLJAWSFXbqdeC30GFnxxsqy5F0A2XspSE2k3I=;
 b=FQiyxGGt/mSdey1cVbyrJdyugBVpA6nyKJT0SUNzOIs5GoSp53oQTA7Q0Ig17NYh843rGmx4y21BkEwpIAipXvFyEozqXffIiAnqWLLA1gxLsTSn21BzsQ1st+nC09VaFkod8yhpnZeVFLsWYNVGPSdpqkspsYUfK8/BHd1jP28=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2823.namprd10.prod.outlook.com (2603:10b6:a03:87::15)
 by BYAPR10MB3080.namprd10.prod.outlook.com (2603:10b6:a03:87::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.21; Tue, 2 Feb
 2021 00:30:48 +0000
Received: from BYAPR10MB2823.namprd10.prod.outlook.com
 ([fe80::adef:30b8:ee4e:c772]) by BYAPR10MB2823.namprd10.prod.outlook.com
 ([fe80::adef:30b8:ee4e:c772%3]) with mapi id 15.20.3805.025; Tue, 2 Feb 2021
 00:30:48 +0000
From:   Stephen Brennan <stephen.s.brennan@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: [PATCH] KVM: x86/mmu: Remove unused variable invalid_list
Date:   Mon,  1 Feb 2021 16:30:37 -0800
Message-Id: <20210202003037.899504-1-stephen.s.brennan@oracle.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2606:b400:8301:1041::13]
X-ClientProxiedBy: CH2PR07CA0038.namprd07.prod.outlook.com
 (2603:10b6:610:5b::12) To BYAPR10MB2823.namprd10.prod.outlook.com
 (2603:10b6:a03:87::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2606:b400:8301:1041::13) by CH2PR07CA0038.namprd07.prod.outlook.com (2603:10b6:610:5b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 2 Feb 2021 00:30:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5fd25a3-8ada-4c5f-ef53-08d8c711c95b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB30808A3A30F038D70A9AC3EADBB59@BYAPR10MB3080.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:270;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xA+BF3XVoVWabkvzc4KdKX/6hwYg5mUtYZb6V9lr/skHEa6gCpvjyrNMYlbrrGiqPnCdTFyoh0bPq3fg6pSkASSgK5Vfrt+Iq5zSvHuAtIZC/UWvlgFJrmNJq8MiQns8fL26b7fFY7V1FST935c+3Q9k6M6DQC5xooB4PEEqsOJTDqSHzq8d1u4CaBrZ+TRjufYs+LuE0EYSXvPYMqPA2fijZyvew0aMZ2Ie0Y+lr2MehZZF1IdqdwX5gGVI5L+8jAxcGlqlemjLfAi7/HLwvPEJH05X7YaXPALfpNvM5XBAvdEzyoCszIssp6qNPEC9v1oAstCs/YM42OlyC5O2wfFdEQT8r6TMOg5j/aeBHT7j9znmE+Ylj4D6zgWnvU/H7yLLJyvWNs++efuc0IURg9vAcpENas64MMTOPC+MFxoVpowv9iecaD5QSQaJlSdsY3TIb6K2z0yzbquxHOK4u0zy7UgBg2/DiC1P+VhhUJmSxcequD9HmeUblbgzvmR0DZXg93PpEg74mGHpPgRj2iqqmuMitxPENDUVOHDy9AImk95XlqSz4A8oGfSglgKKAu3+vYkqNwtBey0b5zwP6pSsMS9xlFHs7taxPPkMQBXPPgXKbqWHq/2u7tSBhRgLDSeUhG4ag74o6DbelGKtI3qjUtA7tK7wsQ84z6KDbi6PvwphGwjZJW+dJ2VNMJebI+dadhBP6kcwmMM9Rs3SRPYhOz7SzMIZcI3d9w4yq+yqVF3oaYrGu5cjqTXFOL8Lx+mRc5YJsWQM0NWEcG62x/OWMh0Uc3ohE8AIiU+0+nW5YXBQx0ICz98qUY73QzbN3UlZ6neisLuk1ozBuWrwowC+nL8YVf21DnwXrTWx9wOdPLLnnILzdeQVmHNozGN9ElAVJuDX2J2u11sdsf0q0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:BYAPR10MB2823.namprd10.prod.outlook.com;PTR:;CAT:OSPM;SFS:(376002)(39860400002)(136003)(396003)(366004)(346002)(110136005)(478600001)(52116002)(83380400001)(8936002)(16526019)(186003)(5660300002)(86362001)(6496006)(66946007)(316002)(6666004)(7416002)(1076003)(2616005)(4744005)(66476007)(66556008)(36756003)(921005)(2906002)(8676002)(4326008)(6486002)(103116003)(107886003)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7uwqWfKuaYGi6xC0qs2YTsFsiHASWmMSFs1V9AeOxZHgA3dr78aEdFL9P58n?=
 =?us-ascii?Q?RHAds16noYtDm0giTnHQuRfausKFB52zxpSP1UI9BYqWTYIpY0jjv3wjZ8T6?=
 =?us-ascii?Q?ZVWWDKXLtDdqyEcX1E2u3/3+OkQLNhT1Fl1R64XNESl7YG0TexnYRbel73hb?=
 =?us-ascii?Q?6IAdUH4ulicyfm7BbtDyvy0314CgBtt4IaIrrk22gc/Cs9ymC282Zu5OPwIL?=
 =?us-ascii?Q?qP1DGVqi3gSGfXFxiyC++SQO5OZbCWFvgRYGMShvqzATPnoCCDvQK3OWAw3j?=
 =?us-ascii?Q?UrKFjzHYli7375uUVIeBOmUmFxCvWjUaJnq+jyOiHDJNseSD1FoNNMXqHvKH?=
 =?us-ascii?Q?gRdq9ljASx6ddThysdQ/Xi2mZADrQj2AWlrpuVf7UNxXoL4n0yfD/yWhUHjy?=
 =?us-ascii?Q?d4XhWUWkbIN18luKEYHKdXztRLeMSaztz5VWRiADVn7LKyNjTdqskUUnUmgc?=
 =?us-ascii?Q?P0s7IeuO9h14Z1LHIaB12ZXjY0eV4awphKpNdjGkjef5j0WhToKKL1SkBP2i?=
 =?us-ascii?Q?Xqw9XRrPMu+ZhIeEzLnN0ncPjHpl2eNq2tZd4+CkN7wZTXyPOYJMI0CBiKN4?=
 =?us-ascii?Q?vb9u74h1WXgNgR7kIPdKkQ6/Xsv3z5px/Z098WOuzaQmnBYqpEzNjjzrIt1x?=
 =?us-ascii?Q?atel2dMUkFbur6Gz0waYa886/QoZX+ZyoEC8GMn9a2hVoE3MCtDW3u60dOQB?=
 =?us-ascii?Q?6gsPJ9+ELKODlixgMIB5S9aAY0GziPrNzootX4LjP9moLnhtFVr3i51OUHxX?=
 =?us-ascii?Q?e9xw/GIAmk6vh9yP6EIRCKp/8i0DEBFKNNzYVbuVNbjTfFvpwBMcqRfktjxt?=
 =?us-ascii?Q?2QboiqE5NhUZCRJlcW5uW4Uyy7Aw8qBYj+Gy3LvhdQvaxWZK3gfC+T9IQ9je?=
 =?us-ascii?Q?S33+eGGN5g2IgVDMnPvwjLdpRSUOgWH+/5RcdeittvYew6wW2XVGQW8HHohV?=
 =?us-ascii?Q?4l0wxK3cKqMEVdlo8mMIEqMM9qpyDTOCejh2EAxEe4a9+fAKAwvh2xOGJZZo?=
 =?us-ascii?Q?Xj1rEOysEBkWn2FuuNDOlW4TP9t6GzH6JWzvDC/VjDhZC1R9rU2XG63uLN2I?=
 =?us-ascii?Q?wCGXbGfUvPFGiB+CW9TZSxDAZd0pww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5fd25a3-8ada-4c5f-ef53-08d8c711c95b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2823.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 00:30:48.1341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQzYMFXyHn/XxK2nMYCdoHPmJZDTJA8VbEs4Z4QBh0OlOSZyjvLpvrNaHJquysrUR5OKV6taJ5OpGwE+g/Ho8OaGZkMlOUI9kThsCykSLmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3080
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit ebdb292dac79 ("KVM: x86/mmu: Batch zap MMU pages when
shrinking the slab"), invalid_list is no longer used in
mmu_shrink_scan(). Remove it.

Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..4b42c7a08e42 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5736,7 +5736,6 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		int idx;
-		LIST_HEAD(invalid_list);
 
 		/*
 		 * Never scan more than sc->nr_to_scan VM instances.
-- 
2.27.0


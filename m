Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4695E323232
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 21:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhBWUjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:39:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbhBWUi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 15:38:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKZfYZ025982;
        Tue, 23 Feb 2021 20:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=nCcdMOgHx+exsmG+se5QictMZ3B74JDcMoga/+8aTVQ=;
 b=wnzCX2JYMu4MHziwSzKhvdyHjitTnl3yp+OZunKk5GZXengDGQCJ0bA97YHFVcVxGUPi
 LWOZbciKT+Lcj0OtEgmI+U/CPy+zjWNpLAftyoNmIiNUCro2+bwXQzzE8lmSI2hMoTJb
 OSXkRnIqOgz6sNXBJBwiivoDPi6walPT7SmIJPEswaHf25TDzSCWTnJ8zTfSXnvYFoPW
 LXBVJ+y3RaoqO7Vw/Y228uyTWhNDogKtmgcJ1v9uzuImwo96bTMkSttlDybzZREEeMF7
 j9V4dcU/LmLND5rZwjtWVEqgd0Wvwi7hX/ZNg58bxWA3M86ehlDRGIyLfP0VnHxr/p+5 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur0t5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:37:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKa8Jg028329;
        Tue, 23 Feb 2021 20:37:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 36uc6s8h41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pp5hB8ss0a5uwWG5x+MxT8Z46DUT6JtlFEgbQfvalJoBEvvNwYooQjm/2GQC66Gx0n3d/0OSbVgcfqd8waCc2fD8Oj/7jy4Cget9n1L0UNNSh6hJ9ByGAKFLWeSb2ZlkQIoocXj61Uf9Ocpz/zSOjpv0lqfoOruTdN+mwxw37nddXGIJqTOBMpolVJUN2g/o8wzllpSBddHRyLQVVhcDEaiYeBGqF0X/oKZ0ZLyDNAsHnCdSb76prmRkPEiceTSvjboePjUgM0XtN1fm4fVIWWHAC+V3ixiBELc3rAZaoxMz2bbv54AIJi9fFQm3vVVlUTEM7aYVYAvZEyZZxXQF4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCcdMOgHx+exsmG+se5QictMZ3B74JDcMoga/+8aTVQ=;
 b=hL5MQxI2V4tz0Pq9e81/zs2euzTRTRwM+mnX3ph2GuBHDKvKUke5ozNNNm0qKuNZHysJPo0Yw5rbgDWCrlaFgKSjpH4PlrLvcT02tZdWwrHkc2N3L/0Np/WYbl7/YKavh7evWGc1JTdkid6wv2JKDViAfUiR3wJDhFNdAMFax8jkr35d5uvF+t4veU8Qefmjemek/0/Mr4Jt9vdJ1Tok+StypZCjPRefTbMojI36sHXkxSYA6BE6B1xhnifESPQAmk4Ss8ViUmTph0US3Ebzyd0mrNu4L3EZ2UamRmv3JknJT8z7KtIlvG9RzPLeS9ftTVowYivRuMBWvSHOl61hZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCcdMOgHx+exsmG+se5QictMZ3B74JDcMoga/+8aTVQ=;
 b=HR9YXnC8kWOHIqJ58jLL5puaXevKfbodadxD1QaC9b3XOY3FSn+DPzqSUAIdDgHGD5xFoAtPXrNccQX49tvYeitpyVg7HQzAhxwnBiM6SyPq4a3lwsyBtVJPHtBDOzdNPrU0gHsXrm9rKomZerQRi7qln7FMYe48tyFyj+nSQ/c=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BY5PR10MB4114.namprd10.prod.outlook.com (2603:10b6:a03:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Tue, 23 Feb
 2021 20:37:00 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14%7]) with mapi id 15.20.3846.041; Tue, 23 Feb 2021
 20:37:00 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: [PATCH 1/1] KVM: x86: remove incorrect comment on active_mmu_pages
Date:   Tue, 23 Feb 2021 12:37:07 -0800
Message-Id: <20210223203707.1135-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.16]
X-ClientProxiedBy: BYAPR07CA0044.namprd07.prod.outlook.com
 (2603:10b6:a03:60::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (138.3.200.16) by BYAPR07CA0044.namprd07.prod.outlook.com (2603:10b6:a03:60::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 23 Feb 2021 20:37:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 479b1ce6-9873-46c8-c5bb-08d8d83ac550
X-MS-TrafficTypeDiagnostic: BY5PR10MB4114:
X-Microsoft-Antispam-PRVS: <BY5PR10MB41145B1CA1E67EB59F320409F0809@BY5PR10MB4114.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wz8zyH88T5kx7HN/gqxtIVTs4W5oKdRHJIJFEpw/cfCfRhGKvbNujF2X3/g8NGTr67GWnQUkBkE7q4oV0nWPvfI3KRBOqDEmh4yut3mbo2w7+CKBy9zPeqlpUz1OVP2k4HYAPxqny6ktTLzsAvhjTkGUN2FzuAXOE1m4D7ewy+svfYGeOdnnr7JVvmBOHyYXfYCsoSGq0bTk50IRSL9dvDmhdMawAFM7+AP+qUfhwLFwoZu3rN/8NMwlYaDqS2Y0iBRRWzK11GebZ+Fmt6w1cKhNwpd0ocMyI+ur41l8CzepzzXPkLW8LETKb5EM1wMqNI4wAxphCQ+Vk+H/MVQWl2Sdd6x3xdq0rhokH19IOp6HXOBP1DUMSNTuetS8cNGs5cvorWnO88GtqMLGDVBzuY16j5/3mBqku8YplcB/Da6gwenHyJ3oSpgOFppfDwIa5Z2hWi++A8q9zAHav9FEmmYkd0jnzASefqAyOYP6NEcAdDD2ipA8hc9sKErU9Pb8MEe+15jHcPyGTsEkaUZzDGy3xkCRVkJN1FWH2oRuiApBOKMRaVZc8ux1eqrLVPmPhRMqBxGxZdbs/Ek0MxHLjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(346002)(39860400002)(66476007)(36756003)(2616005)(52116002)(956004)(44832011)(26005)(83380400001)(478600001)(66946007)(4744005)(66556008)(6506007)(1076003)(16526019)(86362001)(316002)(4326008)(7416002)(8676002)(6512007)(69590400012)(5660300002)(186003)(6486002)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hEPkpk8ApuoITbVlPawvZKhptdYRn1v87jNaWjtOByNlC3cHy70N41zSLlMR?=
 =?us-ascii?Q?hyE/3b2greh5wZj1bdXw/XNF2SXbmZ0RqnI+en6zG5nQL4h2VETXKom6F/oc?=
 =?us-ascii?Q?x2Zavxu4D39J9s0TM/+PT4P0H6sLbyKfPelToaDF9eftvC0p9SxRh95iN5DF?=
 =?us-ascii?Q?5uQwSWSY9747bl7qOJ31rGkSjNJEylja8vMckBW4d4cIZBO+kZrzy5LAjfuK?=
 =?us-ascii?Q?sfBBrEhe4OfqtPJ+/ea/uz+yto0DDs9i5J4Psj0hwxdGg0JI3yeNiZTAEALP?=
 =?us-ascii?Q?ncoookCDTpVdntmu433Xk3ODE63FN9DUYgPDHoXVMc3wZ6KYQ0T8UEixyJFy?=
 =?us-ascii?Q?UBkoxGumUsQfLMmI14O7ZMC+m39iMZzBOBAfDpZiOWbB2OGt35AQOpCm8iA8?=
 =?us-ascii?Q?BAGBKjOi8zu/mFP4G9twDfeuFN8mUld5auXHb2Ar1waNfvQKL7L5aTgz1WDY?=
 =?us-ascii?Q?pEMvHtP3Diy8FHHH/qlnLJsfzlfxEtz5+WVhDrIiVoo08Ue5WUKqrAZdiqyU?=
 =?us-ascii?Q?OlCf9PE3kKmgJsfomznGs8H0TTWxIiLnUNf+0ZRa0tdNd4JgDXkHrgR3r813?=
 =?us-ascii?Q?rwK2wQhEpN2t/9fDk//dgtbCnn7aFHFcCqmSh0V5JYOIFnT/rCk3cpYt8e/0?=
 =?us-ascii?Q?i1NYMfsXEPMv5kC9bdlTQ8+wFOppXt7KQ+yulN7rNvBt3i+nP7/+3GuYk5SN?=
 =?us-ascii?Q?vhK23G+Y0ReIRZuTuYOi6OrOuQWkbpw3YUXxI89ukUoZzTGV6T25rjkPjNlK?=
 =?us-ascii?Q?aq/KIEMtLg2NfiGI242W0zPHzcsc22EQpHLv4vDByDfwoMK1mpGOsZ0XRs/H?=
 =?us-ascii?Q?MRYbbJuYyKBCDNYqMasGqaqEjgdC6KtZGFXMcWl3tUeEMwgh35l96fwQ3vNr?=
 =?us-ascii?Q?R+mrDNutCZqtJ8wGI1MtIgn6bwkbAJT8QNRAvLOGfWeHimmNCP/PEED6VB64?=
 =?us-ascii?Q?AP6RVFKHxo1Brg3UHfOsEC3ja6QmehKnUZgHRtqjtvCdL+leTG6yA8k1hypU?=
 =?us-ascii?Q?gBFnGsB2tFT8ok1wOlUdzglPsHYdwcq7GouShzAbgUpxTdSgjHcE8K/S5XRg?=
 =?us-ascii?Q?N66Jw1thLnmmMipSm9n/uhiZNh17lYJ2fi/rLJkEMJb5a127oZkH+sUd30ND?=
 =?us-ascii?Q?Ok2fZWLh8QUyrZ2alTcT2aKkcPAbif3R2jm331VAmwutUflC0o0qWVrGIHwz?=
 =?us-ascii?Q?/boV6t5GirLUuwvxwS2cc+ucNp8/IhLyXIT0FD7UAXkawj5atUvM8PRTTBtY?=
 =?us-ascii?Q?2+1uh1Um01POuvHx2HK1iMNywhaqXXLY3nG3tmvDV21fzyXx+sFGv3TgBoFW?=
 =?us-ascii?Q?7O9mABMx6SuH9MD3Kvqrnbaj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479b1ce6-9873-46c8-c5bb-08d8d83ac550
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:37:00.4412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8Mbavn7ZASJ9mxD7pJtOLFoE9HGgDXFgv9CjU3+2WTT3RDJSXjWfHJFuiv4a6t66OixXfQ6Rkkt7uJODKDJTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4114
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230174
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'mmu_page_hash' is used as hash table while 'active_mmu_pages' is a
list. This patch removes the incorrect comment on active_mmu_pages.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 84499aad01a4..318242512407 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -937,9 +937,6 @@ struct kvm_arch {
 	unsigned int indirect_shadow_pages;
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
-	/*
-	 * Hash table of struct kvm_mmu_page.
-	 */
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
 	struct list_head lpage_disallowed_mmu_pages;
-- 
2.17.1


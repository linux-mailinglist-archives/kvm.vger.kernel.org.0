Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B839325D78
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 07:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhBZGVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 01:21:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhBZGVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 01:21:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q6A7ne174164;
        Fri, 26 Feb 2021 06:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=RGffaJ9rBMbqmEqn0vIHiLolMApwBwZmco4pO91ey8Q=;
 b=JXI7EqrjbH+L86C+zf4ucCY8WaI2Q17r67B/kCL4dXrq9sXr1y8wHiJrA5ERcklCEaNq
 QPrY73OxZwoNrnjxapKd9qgwxHv+XCOYWbITebETFTFKAZ4JxuV2+QwiTJ/J7+oX0qvA
 dbW4rsjMooMQuFqivUzTorx2zUNcX0pSV8UQAzMMourR4kPMYIfItwIaFotlVCgkF9GO
 CBKxO1Use4YjXlr9TZew1+kwltSkh0C/wJCBTvwh+4K4e7LAxIKrGPrhJIvrYvwh4fdd
 E2pI3N86sbUkrRHeP8PMR0NpkJwjj1JSZD2bhOSTYS9HPJVpkk5Z7ibbYteNaWj0Ymw4 Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsur8vk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 06:19:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q6AjVW005633;
        Fri, 26 Feb 2021 06:19:40 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by aserp3020.oracle.com with ESMTP id 36ucb31j8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 06:19:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuMizV4j7Y2UcEGoE9Nx56E9IuQMff0pSRcp7YZaB4S6ipI2mcFDoLNSvhl2p10ssyTLrOZi40gPp35H3mBnDqFGGHEkrfnmSo+ZD8UgSVyQYuUGPxLuyJdalNdPtDKaaGo/bGjxOeSkJpLx1pT/n+zQHBq64qt1XFzF6NjdgffjbIP3EhqCbBQAra9z/54xfOCHiE5SdrrLAgbo+LS1HDCNFDeV/uy707fQkvwXDUhW2w1pBJFwrL/xPM5BEISGOi87tTJmypakJOG1Fw2pdic6lGir61KUUvsLPfbmYLOqFmSTdJ0NCsdGbMp5W1uYo+1SOhE2znly8SE96agozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGffaJ9rBMbqmEqn0vIHiLolMApwBwZmco4pO91ey8Q=;
 b=RX7in5tc9R15dMTgmmEANJpnTgcep1Pf3vqhkabPEtpI41rueXp8K7lcVNt0rxccV4PkC1Lz6tuvq+7HXGmfnbmsgSugVg730KREJ5QPKN5BBZPkJq/bZyqcXwEU99OKUIMTNgbf7T9CctEB2JTEtmb6oeRoJ5Fhp9sYnj1rkEjaquRb6jezrh5WQ+a84ZGlKUVY+3fKg5TkZVuQPdGQa63DeJKZ+BLEu3X9/zfJA1lD8dnSc6Q215zjsHJ4rEr5nAGvtZFvotGuBfj50Cs5h1jK1VRBKoflierVs7rGetkK7LhUSyehZQ3cFoxcmedyVnfy6r2ZafboDLQh9YuUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGffaJ9rBMbqmEqn0vIHiLolMApwBwZmco4pO91ey8Q=;
 b=bSE04fqnnQVxp74xmaFaFlL4SK8qirFkEeQqSLxBLXre4bydtfYWQvCMlmso0xq4+TZS8PuU03fI+7a94skLnikV23RbRETaowMoKzOB06wMoMcCX751h0C0pFjhaaSTWykj+f9NCF+stDmMaRi5npmruGUbZwLZa0wk7J8Bl+8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3206.namprd10.prod.outlook.com (2603:10b6:a03:155::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Fri, 26 Feb
 2021 06:19:37 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14%7]) with mapi id 15.20.3846.041; Fri, 26 Feb 2021
 06:19:37 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] KVM: x86: remove misplaced comment on active_mmu_pages
Date:   Thu, 25 Feb 2021 22:19:45 -0800
Message-Id: <20210226061945.1222-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.16]
X-ClientProxiedBy: SN7PR04CA0112.namprd04.prod.outlook.com
 (2603:10b6:806:122::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (138.3.200.16) by SN7PR04CA0112.namprd04.prod.outlook.com (2603:10b6:806:122::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 06:19:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0796cc0f-c244-4548-3b65-08d8da1e7e35
X-MS-TrafficTypeDiagnostic: BYAPR10MB3206:
X-Microsoft-Antispam-PRVS: <BYAPR10MB32064EF1E84E320A331AC63AF09D9@BYAPR10MB3206.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DednicTjP02jIGeZE60i7O+5TTFZjf/3dnIt9o5ELHOAFp7TOwSEvJW9twtRwjg67aXFhDzWTSas3eysKEbXEdt6fXos22Sr/a5Vwk2JLSnWn5igZT3Ygk/dEj6YLvUGJ4UReP4aWgxLscDTf2VMFriY3VRxRCkkr42CWteNmISkaC47De83rfF98W0wD9Px4yKV9OoUljb3SAf2NB/SGLgWWIeZv6OSJ5VLhFbrmbeTGbuFY4N3FgJ2amAbeX2hEijEbx71XH8YEfhhB/c/ZUUcnwlhS+GwDuND6ciwelNVSZW2joadTtznlw4zPw7FLLmmsO7Po1Q7MpNtU2iVoo825Y5YqgcfQhbvzm3Dxx4VpHY/EJz9b676GoiolhIU23Y3MMf4iAoEYjhq2nSvIk9PC0SLn3ZSePyjJdgROGcBDCQVeeq8fTXQWEYyRWjR9rXz6USza6TjqTHB7dNoJZwU/P1TJkbAHundTrktj56k47ku3XiERYbDa3PK1HOI6/qv865xtMPJCaENvzAz29HTvYM221IjMqnqEJw2vh7lBYHg0ioBueE/uQn0Urw94AlTTG76bEMsrMvkGLhy/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(366004)(376002)(36756003)(6666004)(2906002)(52116002)(86362001)(1076003)(4744005)(8936002)(16526019)(8676002)(6506007)(83380400001)(6512007)(66556008)(66946007)(66476007)(26005)(956004)(316002)(4326008)(7416002)(5660300002)(69590400012)(2616005)(186003)(6486002)(44832011)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Tk84Ok2GR1cBBdsZDFhoHFIU7sgiGCUfK5PMwS3kMXcSPXLvwMSxW/OOJ+GC?=
 =?us-ascii?Q?5lpFuXIzqwD5vR4FgfNezpBp6jAPsNOws7y3e/sAvXoixq9WJxYZrRaqZc8C?=
 =?us-ascii?Q?LpeW7rp7P6HFg3OzbIvr7BTl0h2C7YJDSeg9Eis+tptlJMTaos4oiX4WXaNZ?=
 =?us-ascii?Q?xqNSMTEfmHaUVm5Zb3IMPoefN7+rCHZe/XDgbzckaQEynEAzNkteYgCBQt2U?=
 =?us-ascii?Q?VB4O7WokmF2VdRUI8IFV0i1LzX8NB/UnE0dSLFFs7lMKgZenwvmZ1g2jg0cn?=
 =?us-ascii?Q?O295NSDRwfh62pRBWtIbxRwu8yFWA43lXqM0QD9mve8u9GULL5PlVoivi/lH?=
 =?us-ascii?Q?c7QreqmdLJ5JL36n6y4Gwx/+Cj+62kDVgDczYprUaA4OiEXnlLzpzD5HwdUl?=
 =?us-ascii?Q?TYx83Qs0C470CqgUvtX6PEIYWK/n33PQb6To3IsSP4avH3b4QBOdGdw5KZy4?=
 =?us-ascii?Q?ax4KwbsyPxGHxP4OLEmNwkYqJTjXTl8+G45DQJIHeuL/ii9Zx4Qc4MBf6/jg?=
 =?us-ascii?Q?kXWcaxl4YC2mtND6lPlgYSYPeTWHVv2iuv4cDrOMqfIVJTUfxJMhSehj+P7d?=
 =?us-ascii?Q?Xc2U9JCvPCeBf6CPn9Ye5R9bFKrePPPa+BjYHSmEHdHlfQmuukO5TozxdGya?=
 =?us-ascii?Q?UIZNISlcUVV+Cp74HkXd0EizwDSmlKMLOAsdmQRs1u5ocH30dRhsXzQAzEAR?=
 =?us-ascii?Q?IrhkbxWb2GK8BFw15PtPxjWnojaMHtNwLXX35aHGAKPLC15YxtkcSaucpC0i?=
 =?us-ascii?Q?iuPjP9KCGsD4n1Sngr0ywsr1Zqcsd7ye6IYWcImYbUT3L8OjFKZgCtaxCpjO?=
 =?us-ascii?Q?c3UmZBCZSxyrkGLBazrVMw7MTAqNpJJvJ1Vz06a76cSdnAW5lH2b3xoe7skI?=
 =?us-ascii?Q?UH3mju9uk3aYThW3R9udH9f1ivNna1uooNh9Q+M37MlTgUYgzcKyvatBhJP7?=
 =?us-ascii?Q?Tc1a+asCMLfAZ9ZKf0Ot7tsr6V2xlsibNwLGACmqgEG7/I0+bEMYjMuPpNiU?=
 =?us-ascii?Q?hTHgLcQ/qWAMR/skNNuZ68u7+d0jRrAllzkkPQY0e6l6lOH7kekXE2/QSMqP?=
 =?us-ascii?Q?rM8Kw8Q6i0r9Uop+lLZFXqeyl5INjDV/AaTo7dN1+0Cj12yiPbhWEJvgkgqv?=
 =?us-ascii?Q?tIgFX7aZ+7rqgRQNxVZz+U6et7TVos1RrQvg+wII76zMkn4yWk8pYMTOctfo?=
 =?us-ascii?Q?npXxIIbDKIch2VJf8PV16d3vpDJG0aLvkHt0bHV1FrZ84LNAUn8r9VQqVJKA?=
 =?us-ascii?Q?sbjbI96Xgpq/5jERk5mUeGE4d4iEg+tpQWF0XXq+rQyI2qIEjpkykADcUrcl?=
 =?us-ascii?Q?QYMP1ujzL27BdZnIp8Z9lWjO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0796cc0f-c244-4548-3b65-08d8da1e7e35
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 06:19:37.6615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dn/IagKiRpR4tXYMhbHVPcClB2JBTIHNUFjva7x6NPy1tIb8weV3nQzebho5LFHlLFujrFQ+65db9yA2q6076Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3206
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'mmu_page_hash' is used as hash table while 'active_mmu_pages' is a
list. Remove the misplaced comment as it's mostly stating the obvious
anyways.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
Changed since v1:
  - change 'incorrect' to 'misplaced'

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


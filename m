Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D9A3467DD
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 19:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhCWSjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 14:39:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbhCWSi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 14:38:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIOjDI166831;
        Tue, 23 Mar 2021 18:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=BL5GJjqPb3UGDbiKYengH5LU8rxeB4qWKQj44cG12Vg=;
 b=UiCTxQIgtVRfqM0+XV9COjXnUOdBYCeQoSpvmGJn6Hr9myQzkXexWnzIIqoY/u2gFJ/E
 2zw5I1iqeIxZIlRu41g6Qp3z1XIzMsIsMDmTkg5vDbUWJf1SztKuUZMvKqMHjHzPlN/V
 8xpSC/oUCncqCpEn9by9Yr2+BJm59F1qz7xFMzBVzEAICtRRJJgLSmqVdE/xbiYB3Mdm
 ZvoPgZcbZUqjV8l6CLwcgKGPd+lKQbQ6ODa84hAJJN/cMdmjxGMEqo5cJLKIWmjI+dx0
 YoHcHrIQ2jWnPTqI5mN5/FkZkq+cQOJvfy9SNdUrVSwlSms3ob4fbz0ZX8FxZI429cBN 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pn063m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NIQNRF075340;
        Tue, 23 Mar 2021 18:38:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 37dtxym95e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 18:38:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVnkCqcw5qb531Fe++NGsaUnlL+AOjhvViIHM0pfE8AyhT/teLcK0nPrq/9gq3K1Dp2pUGRnNaGaRIK8sXygCxhbtNp8xi4JJtIdoQmTaiZ2h/XaRtf89j8Wa+8sUO/NcbCn4/9XttoX5X3L7i60NE6e0s5lBAJw4At2ZV4TiqUSe/3K10VcZ+DomM/Wru0lQQeS1oqj/19ArKLYdlP/TepGH8tgGKCrJo4yTGDbpGX2O7uHrNcp5XeRZtfrEVQHBvXI6OWMSeH6vJGLIfWBnskQv+cqDUrSq6hI8PaXwyE0XuXd5VT8jGo+Ubc8C7CGIhh6HeVkuxrafYhKxn/8vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BL5GJjqPb3UGDbiKYengH5LU8rxeB4qWKQj44cG12Vg=;
 b=jFWqBZhk762KFd2KpA4SGjXUQROMFDZbuQjMbzysbjtsUVbmPIStzYKpzv1b3fnAXlgX+epLS1fmw3wWhCcBbyLdqKwjEX4znt7fizht0Mrou14nfj2iFaxG6iWUk2cEjAlUky/n3hDnQZDlr6B1cXqcB4Tn8WjpbpBz3SSwm8rqxeB7vejJnxyrfu5xextWD3QeaPFjpscZGrYsHNUSRKHw8ryvnp+XCJCZjY1SwiJ35a05w5/nnHv+061sxdYWI01Qf7Rc280O/bgV7s6jby+Vd8uB03N0FW3ZSKBrvfNtrS1e6qck1AMbVbxvh9EG1QRlLNp7Upt5CF6ggBB2+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BL5GJjqPb3UGDbiKYengH5LU8rxeB4qWKQj44cG12Vg=;
 b=tZGIQMdvbScz+giOH8jDGi6++JLaBLyf+T6wTbi9WUoNeTykfjsibKsU6XldT7HGUbzIilpY/OnIlrWK09tgjNdWJNXHsOqKGo3Nzq1YrvNOxEnmv5yjeoEb301gKgLCI6CTeuWlM3Tw2tiJuxTnLHMcMN+LuT2gDav6wvtUNXM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2829.namprd10.prod.outlook.com (2603:10b6:805:ce::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Tue, 23 Mar
 2021 18:38:50 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Tue, 23 Mar 2021
 18:38:50 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/4 v5] KVM: X86: Add a utility function to read current RIP
Date:   Tue, 23 Mar 2021 13:50:04 -0400
Message-Id: <20210323175006.73249-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
References: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BY5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::21) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BY5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:a03:1f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 18:38:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 654814fd-d5ec-4045-0261-08d8ee2ae450
X-MS-TrafficTypeDiagnostic: SN6PR10MB2829:
X-Microsoft-Antispam-PRVS: <SN6PR10MB282975EFA3B081FDC0928A1681649@SN6PR10MB2829.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NsgMvWqanxT7Czt5+i/8+htFnNNAw2C8I1OzuGz7sAAB6eAtT3xUmOiWCUUP+VWOUjDcHvm85eieXTJYKJg/AvQvPafcYdubN2XH+0hYbwWLs9c3z00XW+7LaEMpYPVV6PzpqqKdYjwKk2quBFBe8jrvhwklGwSBeqBmzP7+1/ZFiVLTKsJmwGh8vaaDX9e840MFaOXFNa14LqvdCK6wmNlST+XcTq9v2kQsV2hrcrjuQcpGQrTjlwm8lNiDfHZ0bbxgvkfjuzfdlOGYT8vbG/sl7VQNR9mQS2+GRnsVkLk8JbacFja7g2mdSQiVow+MCOu/ArHU2isR36ogk8cl+RunzvRUcHkkfnSTBKJWevP9vhCinv5myHHXFueozyPIEYRauHa+ZOUrK75StclUwysKDZxygq+qiKDQq7x9qkv3JL8sjoaSya6BYvCAw2k6Kwmiau+fdbSTfQhnT/xmGule5ftGLe4eRo8aBu5wonWh8vK9Lvsf77yluS//3MiAyQFjpPlkC0ODTcgNi6zJHjMWMJyZh686EB/WeGq74bvcIlLSa/mpiQs+rfd6gZtNcHe7AOjkIFhjJnRHiSNLLCvquMvN5fihtV76M8V2fJH8LT5hJXauRicTMPV5KARmvNLMH+PsEFhTXZdPXW1PQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(136003)(376002)(396003)(6666004)(44832011)(52116002)(1076003)(7696005)(86362001)(66556008)(956004)(66476007)(6486002)(2616005)(66946007)(36756003)(26005)(5660300002)(4326008)(38100700001)(2906002)(8676002)(16526019)(316002)(8936002)(6916009)(186003)(478600001)(83380400001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?E9X7WgIvHkZp11KSJMkH0g9xWg3G10rqSefMGNudD9fjOuHI6BALgYkahNXL?=
 =?us-ascii?Q?65ZYrzbi5vwxNEgwmP7hRgp3XuMaOIA1nCPpSexIcl/aUcdqE/4ndRB0/80c?=
 =?us-ascii?Q?tzI6d+NXPTcJRPmMPhiyZUziZvnrWA9t18apqTKEj9dMbuqdefdEviGUpWrU?=
 =?us-ascii?Q?oQNMnaR/8YiCYuVGIywwGFB4vP0w3LAdXj1bynLzQaEhsiuuPIGzdHydKf5n?=
 =?us-ascii?Q?0gReRHo/UoBMSMsc0HiXpoqbbKuO6FGsl6D0LDve4c9UUQbuJKXB2wilngoT?=
 =?us-ascii?Q?wln1VPDNmA2Eur0NOn8J2MlDuZBHVDwBY3w2JaOwZkbqxMXw2xL/Th4gNX/J?=
 =?us-ascii?Q?2K+od3dbuZ6cJGx3Pa1TBb6ktJy0TExNM1V3hRKKGvbbdCmggz5OzhO95s5r?=
 =?us-ascii?Q?nCs0ZGq9bLvgYI1lG0FcI6/hNpoe1H+8Q/PoAc9jOtimjaF64lk4fMRdto1G?=
 =?us-ascii?Q?tMR+okVz4tPoKTGGW51/7BjBF9ssu/B80iYiT2hTczTXbBTyvYDvL6/d08PR?=
 =?us-ascii?Q?faOFi8m5zaMP4j3mlmDmY5OuyOqfNqNEHFf3czQi6EwBkl6mmPMRSl965bEq?=
 =?us-ascii?Q?E/c/w8UzJYV3BGTEKxQ+ghukNcODXdRkhdKKG433Gg4KqfHYyNtndOgEI3kY?=
 =?us-ascii?Q?BN58cig1yHTZQf0YEnKUL2tSQ4QZZ6FxR7c5/0zxOFP8FTHow8L5NAymI63o?=
 =?us-ascii?Q?KZigw/JvwZpayl7I38Dx20XfaUJhBFJhOMiV+TK0IpIyOCifiXEVoNmI1IGb?=
 =?us-ascii?Q?c+7Oc3poXCdDZNVL1jrzsA45v3cPAV2cJd7Gwah2ZlchmdMfZOveoJ2YqUSR?=
 =?us-ascii?Q?3VsRtkH86lgQG92KVd/csPpgj8bZ+VmWY9YuI0heePLZOWoFhPOFznPzh8zr?=
 =?us-ascii?Q?n1W44/DKvk72LYhLxqc+6GwlrD8ekAbU/LbF2OquIb/Cs/NVuIXLb+OobQEM?=
 =?us-ascii?Q?b/9g/pmWQ6K64mcAKT+Fae99aMOcJlBGrUbrXL9fHKxmZDLmzu3PJsYKgcKi?=
 =?us-ascii?Q?Pgt881kCj36CuL5vCdbw/wE3BGrNKlJQiYVhqceQvLwsFRTPJLUZ43NGUrup?=
 =?us-ascii?Q?rMA2Eq4wipYgbNuuo4xv1ar3P6IHmYDbSalgMAJ9grJE9aowgnFlJnj7kEgd?=
 =?us-ascii?Q?u0wE4ZXSOt2Fz2Nw2Qmje+7F1fbq2WT8xKoKJp7ARA+2kjhcT+H7gPhvs/AF?=
 =?us-ascii?Q?qmsEkG9APhNbruQzOTF7GchKjwoRFUNu+cFuZ6fDs8IO1rgssI5N2HoojtGQ?=
 =?us-ascii?Q?9JGVHJ5CBHiPDeGBqOQtHyBsmF22WGv22CLFizBM6t1Ke2fizwLK91YcdyQt?=
 =?us-ascii?Q?xLAE0lBq/alTMHvz8K0bN7vl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654814fd-d5ec-4045-0261-08d8ee2ae450
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 18:38:50.1266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DId1yENxREE1xiG251hlUYW9fKcpWl8cA9Narx8kyQukRClkObpTaTjjcQN7hi47ZdRmCKI7nt8XfrIplfTqKQE+8dv0vHw9XiRDLgkBERE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2829
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230135
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9932 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests may require to know the current RIP to compares tests results. Add
a function to read current RIP.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/processor.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 87112bd..5604874 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -489,6 +489,13 @@ static inline unsigned long long rdtsc(void)
 	return r;
 }
 
+static inline u64 read_rip(void)
+{
+	u64 val;
+	asm volatile ("lea (%%rip),%0" : "=r"(val) : : "memory");
+	return val;
+}
+
 /*
  * Per the advice in the SDM, volume 2, the sequence "mfence; lfence"
  * executed immediately before rdtsc ensures that rdtsc will be
-- 
2.27.0


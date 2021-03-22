Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2377344F65
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhCVS7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:59:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhCVS6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 14:58:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MInoIl020437;
        Mon, 22 Mar 2021 18:58:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=K+cmskWO4KMrstqQI6PxoqOUASU42S4XbV+9Yen6tHk=;
 b=wdMSahwyVY/Gg3IMQ/62qsZWZj5MoUp+7VmwpH8m/hiau6x4yp9zBtrn+HyCKTnzu98S
 uj7YpZuCQYu/sQMgCL1LVEek+/Wlv+3gAis0yF3LR6zeSyocViLo+2fg3+UFhNHpNMWZ
 ZB4xEUxs8mVagubK5iKpL0ooWsYzPHC9hnOPLAIsm2tYeOD+hAS1E/J7aAjtdHrn+da7
 6NtLh87SKmvX4FQhzgk5ZDVzpK7S0QAw+P1CgirwRrYTnzVpcIfhK/2wwzuGpvSMbHah
 YJ08VLfvRIxVwd7GUovd1o2CXw1Ij7emIagicmR/MgFCvO/zMNM3U2Ec0HoU3DW7zGkL pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mch4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIo8It135034;
        Mon, 22 Mar 2021 18:58:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3020.oracle.com with ESMTP id 37dttqxyc5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 18:58:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmw2wzaGm/lrOvgd1/yGhJKAwKmn8u+uQIsrizcmrfF/YnVLh4IJeS4iyBilHu0wi6mW3Fs9tE1NhA6kbi7CUM6J6u+tBtpcidj1NOTV0J1yLsUOJGV5kGYpy3kbN2TcYLGV6ngWfQ85JazUlXw/LJHs8e3EE73n3lV0vjvuVX3gXNm+/10o0blDOuZK90lBA4lahLDBdLsLogtQbcVxJpUs7GP5nreVgelilrO3fZoRGAfWrIVFKKg6BToSakvrloYxRfXlDReV4eIHOHj/7GiofKgr+q6bBqrqy+roGhoA8Y0e/jYFDlMkZ/YIE7rvXApVuFlEJeShlnlFbSCX2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+cmskWO4KMrstqQI6PxoqOUASU42S4XbV+9Yen6tHk=;
 b=HBwWZXiDeik07Wo+ClVb3yN5Ww8f9YxqgPaM7VtKxEnfBpkHLFdh7u5KsH9mw6kc284lvkz/M0LkILeixw7iX9r39yGttjkSrTsB5KdED+cDAi09RZy0eKt9Zt5ZOgGHFcTjT2HyR0djgBc4kYeN6G1ej9W9ZwE4JbiAXJ2le5C05qe0GfogjBy8GBGJdRH9lu9o9gRzS3MFUs4r+o1hRETw//8pIo1DsAm/9HX+WNLD5DSMUvaCI2fl4QkijHnvkYEx6iosmOHioIG2sfXWt8JMGo6PT0kTWlNeUdyfFJoy+D8+eq5gHH64DyFT52OEJDJjHEH2fDEESEvCwxgmsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+cmskWO4KMrstqQI6PxoqOUASU42S4XbV+9Yen6tHk=;
 b=ULkS5Y/CbcaJC7DBSGBLhCZd6SNP87WYCKutkGEGehJfkBzCiaO9XBR6yF1zEA0TRK3e6LKTSEv8U1U59cf3rrim6Ar9cy124Kyv110YQa+Ahsu7w4Nzuq+bWd+Gy6MqC3O3xr27wsP5UBFlGGW9SnJ3Kw+yWk8XHVTU+WFVNBA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 18:58:42 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 18:58:42 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/4 v4] KVM: X86: Add a utility function to read current RIP
Date:   Mon, 22 Mar 2021 14:10:05 -0400
Message-Id: <20210322181007.71519-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
References: <20210322181007.71519-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: CH2PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:610:60::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by CH2PR14CA0021.namprd14.prod.outlook.com (2603:10b6:610:60::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 18:58:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf39692d-455e-478d-f53b-08d8ed6482b8
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795FAD34862A0980BB88DD981659@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IS90RJ/Iy51asc4rAlWmPHGqudkDpHoHWyIIfYPBN0TWozf5uZ98qFeLnWPrm7uur6pIhMaiMEvQo1+Aqa8uhlrQHiWj7mi1Di+Jm7/JDmrze+vUQ4IxLFKQ2dw+9zt1k+pOnhr5xak0uRExbCJ0xSh5HozqfvrzGAyYUXcjLZEY2QgoQhl3tO3SoKTCAKQDMJEwHedc/yYcyjaxLLme5bVcczEaSRydVAFT4wWJoE5lVXaJdMGBzPY/WbyIu6hMt7885SYvyOoy7huGxXMrw02BfU46pAKASaW2qcsd93ORsHZPbcMLZerM7E5do5P6XSlL4rxzWoXxVKebi1qEgafcvAObO6IgK+EejJoYxbEYi+g42FwhtIHZG7qa4xduCaysjosFS9sbm1LJ3vwg6uPNTiAnjObk45oDWxR3Kh3+LtjZ15O6ElG4kGv/wav+cYG/nOwYvWoNIKxvaJrNLYoxVl3/TRDbv9LaTyC/i3H6hOW7wtNUXagmRk/zE6GIc0EUXaFhcGwvzVNBObMSYzn5dRmJ2xYH4UpBoVDa8GX8Q3MWqr40NJVeIM1T1vcbeovX00nYb8nFyq2Q6ecbcacOWobYE2fCC2doiAGhJCvi8H3oYbWaonKBBm2//LNz80/cDeDw2X1oPMw/FQkrJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(6486002)(2906002)(16526019)(186003)(6666004)(26005)(44832011)(5660300002)(66556008)(86362001)(52116002)(4326008)(2616005)(316002)(8936002)(1076003)(7696005)(4744005)(38100700001)(36756003)(478600001)(66946007)(8676002)(956004)(66476007)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xNrjkw/EAC95T9iBB9z/N/M1zVNwLBPUMazpKiZaXNYTfymRj2LW28Srjm5o?=
 =?us-ascii?Q?jQtstUJuyWI4pmmz3gGsJdUAgQbd2BrW727afYDawyEvBQD5U4SqXNkL5i1+?=
 =?us-ascii?Q?UHtOmUbwcCn/ymL+LDsRqanx0hawCjXaSFW0R/e4A3+LR08G9/dgVsxKmGGE?=
 =?us-ascii?Q?DoFO6THmqelfl36VBVt0UYOoHKoYLHczEmT4FukNTMeiuY+fIFF+RKfMmHwR?=
 =?us-ascii?Q?ih6a7UAPkCa0fyQHHtPRLagxFtWdiPyzvV0Da/Rt/d/0N62zZ6AMPW5F2p0p?=
 =?us-ascii?Q?HrU4OY9ZW8970V4OXppPvEDuF4uY9aQLTDowvb2OqRXVgLz4q0p04x3qfkq1?=
 =?us-ascii?Q?FuY0e1KB7n1SpwTDIT/R5YPRfePlupT28px4btO58n6pDot6NBhJeyDYypo6?=
 =?us-ascii?Q?Kt1LtDTyG4YKeR+kPnfbIpf2KbBXgyM4hlD9aZzJzW1tHrFhXgZZKUydys/1?=
 =?us-ascii?Q?F+oaRv3GQclpCkJgo5u9wmR0giQ/36wKSjlslP58gFGAuHpe/ZV6LYqXaXc4?=
 =?us-ascii?Q?VsVARkZm7oIdPBIHhfbhor1Lyqz2dt152OmlHTj1LVUhrDRy2bDX+6paKBhH?=
 =?us-ascii?Q?1cN2KP8Q5R41yuBNlIyiCHLitvya19WFFJ16+jYPJ9PT/ND6s5q2daNh9mTT?=
 =?us-ascii?Q?oUKZHdvOL5tfdJ1weqLcU5DJhEFjGIDC/OqrfmBm2xfUzbpbeEJtdIvCOCWe?=
 =?us-ascii?Q?l9NPQIPQIAGxZ0NR093cn2AX2Qb3IyVs0sMqn05dTYqtfFEg4ykOKTy25vFB?=
 =?us-ascii?Q?mpf1Xt7tQmGjjg8n1wBuuUuvchpGTNYAg9m6sxhuG6iJbzy6CWp/yA5DFiFc?=
 =?us-ascii?Q?NhpyuUXDJDwDY/DQjW1BrrYpMvnSaSXyc5gTdaAS+DCQfZCMr59wRL/r5sQV?=
 =?us-ascii?Q?C05CN9zI9zlG4YA4ZVmjgJeYislrVqA4bbuEQjUG1T3CgXpbCT64+dPzTMIG?=
 =?us-ascii?Q?IVHrRvz8QoysohYuSp1RE52e4Aw6io5oCAHerGIk+oY2Cy1hUCL3HZRPRzSk?=
 =?us-ascii?Q?crahnOUykoqr+Crv9YZrS+O8Hvfo+ykmEgmZeJnXo0G/wcf1KK84EBrS2bKT?=
 =?us-ascii?Q?a5AjLamdBdPJa7baJuH6dPkNiCterjYOwnBHo0+0vV1X7nTV7xe+G/MrCpZO?=
 =?us-ascii?Q?VbL/sRGHVjW5qzcmdu7LJxH+fSTCKTccCzeJIS+WRjTPTr2sj9IFc4YA+Cvr?=
 =?us-ascii?Q?sqLjSyCRNdmi0LYihjajjEstO8a9LdRLBQMXbNHWaC5mgZ0ZpWzTawRoAQ8v?=
 =?us-ascii?Q?nKV9ADUG6j5h0aTme6t6ZLROd30qek6h9KOMl6vW0238F79oCRxs6X7EUPQG?=
 =?us-ascii?Q?Z6LeIPnCannc5P4VtSrgPGOP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf39692d-455e-478d-f53b-08d8ed6482b8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 18:58:42.3014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tk41P/0OI6d8JKWebUnwUzMbFLArxTl5tYYnO8cnuXjFibp2WrSs0Bq/eBJ8NztWBfmf6OQ0EtOuC4u08wVkxTrQr1JIBqJjlrVptkNsJTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some tests may require to know the current RIP to compares tests results. Add
a function to read current RIP. This will be used by a test in this series.

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


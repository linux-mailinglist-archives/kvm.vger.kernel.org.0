Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBA3412A12
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 02:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbhIUAt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 20:49:56 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38420 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233862AbhIUArx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 20:47:53 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KMMmuu000365;
        Tue, 21 Sep 2021 00:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=RBCkjd3HVra5Z7vuBrWk6TO9dXdTNRqTe6Gnk+AWLvE=;
 b=c9I1R6W3igws54MgvHxZ6cvrY8vur/BUq7QEtK4faBobNk+03J8MBkfp0gPFj/gFGiHM
 Pv7aFZmllFYWaE3rCD7NGr7as0smBZJW4HSQi/G2GihcSuB5i4jZZKskPiMYfjpS+IMd
 LzTB3EZW8REMI0HO2Culp7fLyhwyOmuOEanTzs6jWR1E6eJXuwL1W4uwgj4Oe+jpt0a7
 lnrwYKQi1UQGUkRC/mOc2owFRj+nGQj/Jdk4KkqgpWQnPux8BrKh4+cTZbb6wSIWHm4b
 ohuE6YIRso7TILNSHGhX6vE+10Flm48E5yztEH5viRtkACDfNRWudmvGKsnbs/q26wiR Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b65mrd19g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18L0duaB104009;
        Tue, 21 Sep 2021 00:45:46 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by userp3020.oracle.com with ESMTP id 3b5svrf3tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 00:45:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fn8dwf/r68NaniNzXLlqfXKCSH8fXdYgAjXpmWKqStJZbvHkjs1gdVow4XFGz93REyQI25D2h8EtqCY7nPy0hbZGlSMOP3wJmqsTbQWauCylkZiUQ6reh7wexuenMqa9guumoSXrMcoThCg/ECK+a4Yej/K3eDOuYPEqRJ2X6YISKjq6LFpsw0StIG2D47j1j+oH2FFNlihBa4aMN0cEeGSTHudD1AQwwfZvppOqeRvcKnDCYzvKRfVc6E7j8P71HlEbXwQOjlqqTrdLIaw1Q9SrDxNmiygsWv+vYWgX5Do5jmnLIsJRGxaOD18ZJkgRTVhP6trmD5MktEBMvKIeng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RBCkjd3HVra5Z7vuBrWk6TO9dXdTNRqTe6Gnk+AWLvE=;
 b=T+iWU3bHZcJWDQ47Wx330XcdGXZY9WSYxc0fO9Uo+vqWT+yetrOOl4LSBgi58LJn6qAtALA4iPe6S6c96sc9xP+pNbBO6Ybd68dqVBF70LLMZWiu+GPTrAqLuMexQ5P23bnoaAQRcszddM+SFx9FdIexkBvLrk91+XMfoIpvFHeRWuzzHFjyB86pF65XLrinNOlgsl1aLNd9KffCvVvE4WPYiLAa+b54XtYHWMtcTVqB/3+mQDe2Z5A9R7ZdJeH4YfVU+1cpNq39vQLS6NLdlzEIu8Zu7C80rEMWAJJUOrGXEZ38LcflLuXolN7EHJDszsKy8LllR6QPax/nEmKQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBCkjd3HVra5Z7vuBrWk6TO9dXdTNRqTe6Gnk+AWLvE=;
 b=X4e6RAWDWw+213ETTYf404ZsrPwlP/MrQ9L0Wle6NY8xIyffHm/DcY6nGNwl38Q9OXT/xZYGHHF3UJwNGgrIiqXqNG+ZFUCDoPv9ZnO1Aud/D/kDb5RDO6Xhn10DYp3vMZH2iSR8eFsZDGemopj2WaBRqfkAcUBNP/lj+u7Q3uY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3086.namprd10.prod.outlook.com (2603:10b6:805:d6::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 00:45:43 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f12a:c57a:88a7:2491%7]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 00:45:43 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 1/5] nSVM: Expose FLUSHBYASID CPUID feature to nested guests
Date:   Mon, 20 Sep 2021 19:51:30 -0400
Message-Id: <20210920235134.101970-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::15) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR02CA0002.namprd02.prod.outlook.com (2603:10b6:a02:ee::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 00:45:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb73d13e-0dba-46cc-6650-08d97c992489
X-MS-TrafficTypeDiagnostic: SN6PR10MB3086:
X-Microsoft-Antispam-PRVS: <SN6PR10MB308647BA5BC7253F05C3458581A19@SN6PR10MB3086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CS87H22xBNjTbT6J7mMZ+oQezcIiAFd3YhEZfRKk2WxKKJyURl3PSdANmmxA5Aw/CdSxiv+JTBk4TPVwCiIY1aqyZUW6x0/XzQ1e9uvfgJ+gnZDTK41pJFGMqHC0lPlgLe1Jm/2o2gOg5yRXOnAc95kzG7UYsuHXuYyDC4OnFimXS6DdVwvDHRLU7lPYCOLsE9PVgeNw0zJ7l1q3Nc6XSTxtSUdGZE6cgXqp8nPStMq2du2L5W9OK3uyp9NGIIPNRsqK7opepsivip0BaLnDwOwzESD/8juYtEjO/7nksIaVhwgI4tE+IOpIxDXkXgk9+2eVfLhxoPwt4YKDgd93e5yaG0Ppm6McrWl2joD525y123tOOUhup+UUW6rBlirXlykLlQKsLn20s68Fc+i2/FTxZf+ovdeYGX85oKMLkXnaC1r64VVLN6ddpslAUkYJ+oOzBE2WCWaAQxYiWD4yIYQoPAq+O1csVsIqdsHLzSSQGdun3AWC8C8Ijz1uob0Pn8nUYKCbcEdEWG6sqs7FXBmOIEtozEIiPqSRkIEv28R9VKu9S490mtwEIWqx1JY1yJWzhnc66gmmjc5myYNNkBh18+CWJHmwntnhjPjgi1DCTNNLod8DnhR+1xTi+968S2GvYFEDw7c7wRqHSHWSB1MmOqUQrWpF0KkCoLzEgSWvSYJzB9xO984zn75NX7NBODQyHeesEwD12r99GrkS2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(396003)(346002)(136003)(66946007)(2616005)(316002)(186003)(8936002)(86362001)(38350700002)(6666004)(478600001)(2906002)(38100700002)(6486002)(1076003)(5660300002)(956004)(66556008)(8676002)(4326008)(66476007)(26005)(36756003)(6916009)(52116002)(44832011)(7696005)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NZQ+6fMsJsGcCafHlMVkUrkceXq5fYDQQEFJjV6xhCO5M7ftaz97QbA9+bZW?=
 =?us-ascii?Q?Uw4bcJb7FtF5gsWHpUjYgYezN5hhNv2jmdipy0QsDl1WZV3UWPT/1x12iWVH?=
 =?us-ascii?Q?QLJLcvgyJDt2WWPnafhzzCZCWC0GVD3bqcTDpp+IPZJHNj2PLRbVhsYI9d3P?=
 =?us-ascii?Q?te1oyi8Wlbp650uggGuraptf+1C2fomXNrpOQ1D+mCiXFdG3nZQllOl2/URx?=
 =?us-ascii?Q?NsV/pBwmAMPBRIOViBjK02nLkBNBNRD1Up5szR8LeskTZJM2yhMyyjWWAVin?=
 =?us-ascii?Q?Zwl6GM6XamNnOV0NhDiIrvfkVzhNKiCoXRnSGrQVRhRT3HhrGWsRQnM+HZfC?=
 =?us-ascii?Q?jqdLtXGn+OYvLLJGwEEYyh3l0NDnRCXQ5RnxzKDn8xjumh8C82/0YGj+G/Lk?=
 =?us-ascii?Q?FMbsNbqImEuuVvnNSvmAqD6eu3z4h1/fFcB6/AtX6lSrdQNryEsIQnzhbZK4?=
 =?us-ascii?Q?WTWFBCR9Wx4qaPoBug6537VmAKnO4pZlMtUKJqwj5D4Vy9gQrf9i+jYDHikB?=
 =?us-ascii?Q?HT4OBdi80lh16JjTvLoBLcXa60o5+oY/n4x9tKV9SOhT00AysaDiesmyJF81?=
 =?us-ascii?Q?ZxQ/bguYSJKSlXg4TbyFzDhGGZPW47r4m8DqugLf8UDS546ItLP0WNFo0LFt?=
 =?us-ascii?Q?Vv/vtEAx4gFaJ6Kw6ijhoYqWrjNA+AGkXQ8hAWqkcer74TCfJ0pJDRxy5zBX?=
 =?us-ascii?Q?QYi4DCN9UbBQsplRLOjs4LnC6UFy133H533k/jtA+lGKOB7dn2A1jNVslBgc?=
 =?us-ascii?Q?73OSs4IOGyS/elvgzphInSh6LE0gdNffz2uKoLA5oU28SqmeVV69N2Ij/EJ5?=
 =?us-ascii?Q?2yp6BEGwFINBGSTIv2JnmZe0OcvW11Ibpj5FA4Ms7cTKTRgah0ujpkCrtnxL?=
 =?us-ascii?Q?ge/6yDnNWN/xLHE6Z+bFRPQOqwreWYh6scFLRzWeCDbas/1QBhQMnCn5oWoB?=
 =?us-ascii?Q?dJBakPaHW9ZlBmc0C21Tr1IrlfOpJrf3ixENa+/cE09f7pnabLeAi0QnJfmY?=
 =?us-ascii?Q?/gJV6V6bLZHNF415Q3FOZUZkLWQk/cHeBEb133s/+2oc22DIcc7Cd3KG/P66?=
 =?us-ascii?Q?WUe3tS0zGRiS5iMglAifZyohM4piS+4OSq7M389gvSQJ4dys7x8KNT3yGKgG?=
 =?us-ascii?Q?n3Cmjgt9TstfY/zgWbIOwpoXUPlgnDC9e8SDA0wLCfe2AR/hqlo3ImJlaiX0?=
 =?us-ascii?Q?dcIzN4eJA44rEjv4SHcqcRoKH13IZNc19t5UqHbIR31mTlyM60mOQmolj3kN?=
 =?us-ascii?Q?ulK4EIjRafW98gC5w4nJZYqKwltk8JYK/rzKtVpPySVYFdfK+LqkG2+lbZDU?=
 =?us-ascii?Q?W+EvCeKYXCbaC1J/wsERgkI0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb73d13e-0dba-46cc-6650-08d97c992489
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 00:45:43.6639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neY3szr0y2hfrp2RItn4L7qT1IJwOwkMKbl7yP+86XVDPKlR/368lKZEAyfWC/e6yJWCTxJ7lVS3UBsyTaXZ7kXpQmAgXGdo3QAwrEtskLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3086
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210001
X-Proofpoint-GUID: 4VGVZdXlblgXMzaXOeTQWdL2eArWq1vk
X-Proofpoint-ORIG-GUID: 4VGVZdXlblgXMzaXOeTQWdL2eArWq1vk
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The FLUSHBYASID CPUID feature controls the availability of  commands
0x3 and 0x7 of TLB_CONTROL. If FLUSHBYASID is supported by the VCPU,
those TLB_CONTROL commands will be available to nested guests. Therefore,
expose FLUSHBYASID CPUID feature to nested guests.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..0f8748af8569 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -931,6 +931,9 @@ static __init void svm_set_cpu_caps(void)
 
 		/* Nested VM can receive #VMEXIT instead of triggering #GP */
 		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
+
+		if (boot_cpu_has(X86_FEATURE_FLUSHBYASID))
+			kvm_cpu_cap_set(X86_FEATURE_FLUSHBYASID);
 	}
 
 	/* CPUID 0x80000008 */
-- 
2.27.0


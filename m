Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF697389AF7
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 03:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhETBkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 21:40:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45648 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETBky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 21:40:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1Yule109268;
        Thu, 20 May 2021 01:39:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IKAVD0XFtWIucAnUPlcr309tmIti/Kk37cc+DBUWkiw=;
 b=FJ1cybjjC4HwNrSKOZvKB6NUME75YjxYfNZI5CpdylBVBv+1Zn2nSCnpxx+9UHi5yC8M
 P7z+nH6vLtLIxf4rb+oozPsxudgHjR3u1k22QoEUbzfFUVyQ1zNqMtXr4L/vgNVFefea
 6hgmSRG11fTTZjh7Pw/gDwOZmn0CyJndGu0bfm4ILQZRAVua8dkdOKqJkaFwCBYvvvmJ
 OPAj8ohdIGeauzcQs/iCIHpTTTuXwGiiXOor+CGBd8HIVlxfVizC0drGO6cnQdENwtMe
 a1N69qjWBNWTXQyNOt5Uh7UF8AgCbPAjxQvg92svIeNqRpbcYXPdZIDyFk7qZ8cEJKvF IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38j3tbkb44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1a6nH017253;
        Thu, 20 May 2021 01:39:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 38meckwdm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXW2AYUzTodqYvM7AchFS0A1h5ucLNkMrK9ixUHOCiugIGqGstE0p1V+cirGFVcWPUl3bry0kAHqWyB/yI53TpVq56yqcxafw1U9B0ad5w7wi5G5dupstiTVqoEZDdnxvHnUFklItmeN/+4zmEzwfhvUAkX8GC7J7nl/vZrhEmpsM1ZCKtkbu5g5nLkBwL45En9VxEZLnqjjtX6q3KGdDPSMkbdIlsYkmtD+/zy1YcIjBEPdtIsnj7oJ952/vdCGbBtOlj0T0jUfvD3km6n4+nxKltr5Gkr4OT0dnAR1bGHjSzpD+v6qQuCdrqg/IXX9tLRCwoKTggfFK/pSGuvrEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKAVD0XFtWIucAnUPlcr309tmIti/Kk37cc+DBUWkiw=;
 b=V7GMI83yDcGoXlmAgMtToPnahZv5DwjLPjKtWdxpZWUEgaEyZ11lzLPnVZslj8W08QcklhhWH9fjLWUYk36Dra++K/H58Zy5NZo7LGlGTkGFrwsI+qGYByk8/mvXDjrfrxiy1PGJSMG/tovTExbCI6NFGw/yh1dwjHCPeXIlYFG719M1xvhRDOr+YHbErZvEVR6acDqeYXQr0orJ3Wcy2Ph5RSI9/bthJtRbir8kGObi+nodS+3k/eig1Os9jccOQzaLoHaGGqtQrk1/AAKkdFHQjSfitOrlxrms59WVGscJFKLHopt8Tv/VB3A1gbe0wjKvKUU/fQ9Va7HZSZhEcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKAVD0XFtWIucAnUPlcr309tmIti/Kk37cc+DBUWkiw=;
 b=fqqg+5cbdbdq2Kgwf+9pJsmxpRfIq04wiqb+lgscnU9RXzSovFIdBMbEnHgucVS+VOkm17fSIV4IuOS1ba2TqJtNp+DaNejWWeqawAnHDJTRJyG2BrbrjG3ISZ8lVNri825s2A9J+BKkxzl7V2KngT7e1lqonmla5AFMyHjByPs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 20 May
 2021 01:39:27 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 01:39:27 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/4 v2] KVM: nVMX: nSVM: Add more statistics to KVM debugfs
Date:   Wed, 19 May 2021 20:50:08 -0400
Message-Id: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: SA9PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:806:a7::8) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SA9PR10CA0003.namprd10.prod.outlook.com (2603:10b6:806:a7::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Thu, 20 May 2021 01:39:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e97cf11b-9f24-47ce-07fc-08d91b301af1
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:
X-Microsoft-Antispam-PRVS: <SN6PR10MB29435C82044DCD49824D76F1812A9@SN6PR10MB2943.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8UyU9AHcUi8KwElPG2p6iAZquppieXcm0ec8RvN1DbPahdCVTaSbvPNVAIEjhVX9DuJZ/2U0IGk5iwhMA66arWslY5AuepXMzsYw0RkR3wDZsxZ36RL/Zn4lG/YxHyItxufKeUSS9FOEQgtLhjoEdFPuI6VBjdIt5zhYG2rtbrcy3cRYxc31XGxIaHuY5+ZSoqbbml4xDnzjISiY3ai5mZUB58SxURfqr5Azbr5q5sJiRIFUITWDmd7tNlVMygY75033bcsaOzcejvgOdBZlgYdGK8umQhnjieTuXvxXbtmMWGnLqr9Pn4UltTzigsGKAtkKrInY5rlt4Us0h/jIO17yrT9caKDBmy4mjktpLV47j5JAuVJ9eVx7J8+Luixw6lBU/ONr3n2IA2yuzQC4J8xBgWFoXkh8cSbu2LOZmnytn5CGsVSN+zIvgMb5GvsTX1Q9ozE5/U/Xi7qeDPHNN0ohIkMtaVHN3ZzA0Whe6z1pvSD6tsBzS7sENVmvxh6f1bHC4Ck1ZaNsF7l6hpaaZJJutZeq1EO9rmY2Gl1CorulvgSNfxPbpXHcTVHvOQ0qwLlP1mwT7syIRWOcaJTwGhCl68VZzzIoLV+lkXmDCpWTlNuFFKMgcKKn8HOOPBls3UQ4/p/lv0SD8oBNOpAkPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(396003)(136003)(346002)(1076003)(6486002)(38350700002)(6666004)(86362001)(44832011)(38100700002)(478600001)(83380400001)(66946007)(316002)(186003)(8936002)(7696005)(6916009)(956004)(2616005)(52116002)(5660300002)(4326008)(26005)(16526019)(66556008)(2906002)(8676002)(36756003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YTHZdX9ZeHHlLZV0ie/isNMcZxbxc2ld9rPP22+vPUtRKbqzD1kEr4TRNixi?=
 =?us-ascii?Q?EvTnbn9yTYSjf3F4Erq18EjzXOVFf+jOSrbtV6ejtkDFtZYbdupfNaTitEU4?=
 =?us-ascii?Q?oz381WbrhhEMdnC9ooOiqFIlXrwhT6EYAif0Y4Q9bltVbuORqRSce1WGv6Zl?=
 =?us-ascii?Q?Nznbj0HjqAnvx435E1s+8I7JD5M9XvLDw5W3B3gOQHK8j36vAc/rIsjgofXw?=
 =?us-ascii?Q?shgHYRNO75OopvI6tXUVkycYH+wZRGYuSG0iRh2nkp/ntPr4YvkV/1rTitdu?=
 =?us-ascii?Q?l8P6vWd2qXdrm0YXDJ1HxtXjceH8Zt2NITXRkI2RF63AHKlvx74P1D2yVU40?=
 =?us-ascii?Q?owuM8y3LEo0oUJBSTroNgpzi/Ya5vq0b1+6C/Q5VhyRdMRLx6uVsoFGrhQSo?=
 =?us-ascii?Q?XV3bJlL7wKa6/LW9aDgL6g7x9/vVRB/U/CvvPQXNC90hSIjopoMXlVy5PQ0t?=
 =?us-ascii?Q?Gyz9wQvNOiVF1heg/+Ch0HzRBSQ0EGj7I4NGDx3oiqwYpUx4UnZjxYVy+rBU?=
 =?us-ascii?Q?horu1KLtWN0dcv4r3wlZ5GB0SBoGS+CCwVyfo0eHFFjsXp1m9G77eg+W2iOB?=
 =?us-ascii?Q?fS6evYHkNsWWf7RUzoCozerWF0l+Jc6yif06kzZmnY1duEVxS4Bux+rnLhHQ?=
 =?us-ascii?Q?oY0GXfZs5nefnu12SKx0iQhtwOcLB9nE+bgFb7XRqKc3/XpQAS4u1ZTwAcCD?=
 =?us-ascii?Q?9X/Wp+fr2a11yq9YJjGAPNtZ6UCaGw2TdMUmS0iEhNayi0moVMbffZPCBxRe?=
 =?us-ascii?Q?IYo7Cm+CiSv2Ip8e30sZL4MfVxgV3M+LAwsKNYN9awx15Y/Ng3gBF2Gxv+tp?=
 =?us-ascii?Q?2u+rVVhgeYvK437oPphTo0XB4h6kX/iBYxnWOSgnn6hZT9ZI+oPmixNnYPzv?=
 =?us-ascii?Q?PDCrs6ewyaJxX/+TYVH8l2eb9OC3JHIGCjpfGth89erWt3gBRQj1T5ThBOMq?=
 =?us-ascii?Q?k7QNP4bdeKVZU43bng2HPl2Ygm9LfYNg8Zj1iBtr0/d/KjR1MbW3FkePIWQL?=
 =?us-ascii?Q?8ysOng/Qsbi40AwFISBkFb7N3obFsjPA1ChaMjQkbr6anCFQpSvBnmOOUh29?=
 =?us-ascii?Q?A9rM6cDm+2MJPvd58KZ05Oueo2NVGNSGdAideaSP7C68a/aYPG7Ro5VB0CZx?=
 =?us-ascii?Q?Wqqhq+slh0xxG1jUaZOgoS/V7HIZ0selagILTYoDBAwIBwODQufYd7ujznw9?=
 =?us-ascii?Q?oQogxaDK5A3sQihgHsl9cVThcbQAtl3Vx2oYOkkZQaTV1peOoiJ5YCy/tt6Z?=
 =?us-ascii?Q?eX5gY6kKfYrtsi2H5ws/7C5GD48Q4kyF9/qL9kqd97M4I1Ip7UPsDbDjfqM3?=
 =?us-ascii?Q?1s+SQNSO+1HgdkPy6KokXOHh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e97cf11b-9f24-47ce-07fc-08d91b301af1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 01:39:27.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NR7Tx5xYuKXZcdoRNSwr8yI50CGngiCS9DMLiTMJ75vKs+DgSsqMOUUcrPgakFqLbYh6g7dXDg+G2nLj0G7pH7VRxYuabzgWlTKoAYqb3qI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2943
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=897
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200007
X-Proofpoint-ORIG-GUID: p_XDDp1vLrkm-Pr3nNbmk6fKWLlZuRe5
X-Proofpoint-GUID: p_XDDp1vLrkm-Pr3nNbmk6fKWLlZuRe5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	* Patch# 1 is new and is not directly related to this patchset.
	* Patch# 2 now tracks only those guest-entries that pass all
	  checks in hardware and make it to guest code.
	* Patch# 3 removes the 'nested_guest_running' statistic that was
	  added in v1 and instead adds a stat that tracks how many VCPUs
	  have run a nested guest.

[PATCH 1/4 v2] KVM: nVMX: Reset 'nested_run_pending' only in guest mode
[PATCH 2/4 v2] KVM: nVMX: nSVM: 'nested_run' should count guest-entry
[PATCH 3/4 v2] KVM: nVMX: nSVM: Add a new debugfs statistic to show how
[PATCH 4/4 v2] KVM: x86: Add a new VM statistic to show number of VCPUs

 arch/x86/include/asm/kvm_host.h |  4 +++-
 arch/x86/kvm/svm/nested.c       |  2 --
 arch/x86/kvm/svm/svm.c          |  9 +++++++++
 arch/x86/kvm/vmx/nested.c       |  2 --
 arch/x86/kvm/vmx/vmx.c          | 16 +++++++++++++++-
 arch/x86/kvm/x86.c              |  4 +++-
 virt/kvm/kvm_main.c             |  2 ++
 7 files changed, 32 insertions(+), 7 deletions(-)

Krish Sadhukhan (4):
      KVM: nVMX: Reset 'nested_run_pending' only in guest mode
      KVM: nVMX: nSVM: 'nested_run' should count guest-entry attempts that make it to guest code
      KVM: nVMX: nSVM: Add a new debugfs statistic to show how many VCPUs have run nested guests
      KVM: x86: Add a new VM statistic to show number of VCPUs created in a given VM


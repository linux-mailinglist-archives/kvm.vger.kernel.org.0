Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91C8362D54
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 05:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhDQDjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 23:39:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59374 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhDQDjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 23:39:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13H3cn1N190196;
        Sat, 17 Apr 2021 03:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=4YZC0WEcfqWhEV59yxnLZgecUqMHkcIlw2k9qs0lVpw=;
 b=jMUG1x4785AncE38HJO8KcwahWle7dNI52dMcYfdarl3MjLTC0dDCwrEVGUju8IE6gYH
 GLZu+O9YDjmTRqaHBRgBLQoFlGV8e4R88ZbBT1B1SZ5uOxHdwQXOJIZoEA0TdTL9WVDw
 2mXxMblEAy2FNiSU/GF1jxn6/la9o66E7QDkfBCAcnZSmSCG2W2hz23TBeRRu7JoMlsv
 oqFB3ods63Kh/l1KHI0T+oNz+noKFsov69mTCykUVlIqcNpXUeGmFrvGJv1GrO9OeFIE
 Lquu+PIAyEYzZg5ayLHScbtP4D5dZXbExeT2GPiI6kR4iMfEXhT1efl/N1zcBcweHuQ+ 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37yq3rr101-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 03:38:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13H3PgKV190340;
        Sat, 17 Apr 2021 03:38:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3020.oracle.com with ESMTP id 37yq0jsak2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 03:38:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgcsePZXC7WLLCJz+LZFolypwrH88YjcHJ5SWz6rk+b2uxZ5ZW/8c/u9OcWCV3XLMABRXfFmtkvtBEweXd1W6Noo7ErzxOsEVP/ng6RxWdAELVIE/BhPVyxoSk/jypXDLJCL5wETKA063KGfdBrCnc3bIuSJHOe9+K40SN3egpiKKly9/vgrsx5RLZzkgzV4HqgCcTsHWHZ85KvmTgG7hXBAd2sv5t6qqKl+4fTMDP0lNT0WCV0ZOiORQQHJiqXfp8HOHgnSdqmwWmL+01y8TIq72QGew2uWvjiB4y2nkLZcHCJ9PKvYOu7cC/BWHozf/tC9Ga2x4yI7yYQCY/dqbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YZC0WEcfqWhEV59yxnLZgecUqMHkcIlw2k9qs0lVpw=;
 b=c7iqCcL62VY5d5zjfZyy4OG48rO2qyX4dd+LihZvXuNFGdgNn0IWcfDH5JoFlSZ+kd4KP465PsR6lKaNh94nNMhtk/QjPtOQn5nnRNOm0WQXO6ANSfVcCzen1Wzd8YpW3OCwnOPRt/gk/B10Cd6if+nwIajMq1jiTXDmvNCNQG93L1u07PVq/xunybMp2LMPxujjr7TJ0tyP2PXiyp1yeQLXS+6qg/ELpQa8g07TuJ8hvs3XcT5zjghcQPWHBwF506wgR68CkDTj8h8YSZ2v1LZc1p7sMjQ5w6BTcWf+cSdWEfkCpO2mkbbATVOHZhZvPkrAKiAybBwjnQVs++kURA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YZC0WEcfqWhEV59yxnLZgecUqMHkcIlw2k9qs0lVpw=;
 b=hXvjJTcwxpmnZR/onlEmEU6wCNaQAPVkC5gs5SY1qVPmfZK0QQtuUBvx2WuVMguG0RnEVvez90ZBZNDjeYzqSdqB4EJjoCjguUX2RqU91PGkX6p8qhIUZ5c+QEn5m6ycSTKrVRmXuj7kr6uaVjXapijAKe2w8iPxNxZVnxPp2io=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Sat, 17 Apr
 2021 03:38:46 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4042.018; Sat, 17 Apr 2021
 03:38:46 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH] KVM: nSVM: Cleanup in arch/x86/kvm/svm/nested.c
Date:   Fri, 16 Apr 2021 22:49:54 -0400
Message-Id: <20210417024955.16465-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:74::21) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:74::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Sat, 17 Apr 2021 03:38:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90eda4f0-2ecb-4ee9-095b-08d901524e3b
X-MS-TrafficTypeDiagnostic: SA2PR10MB4665:
X-Microsoft-Antispam-PRVS: <SA2PR10MB46659A987B2C434C3C316813814B9@SA2PR10MB4665.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k4sPKV8mNmwgjr8spm/WwvJhQKIIFuuvd75+J6SQLwLsuW9td0gK6M5lzY3UUGsRlc2HuJa2xPow2t7Pkle2Qa3os+nskDuYIwR16n+aGXDZAE4uugUEJMyhNxEBws9SyFh1EBVmmOhBbY5mQEzIIjnAQ0RqOcK0gkUewobXT8pa+10d4HmJKNHl2hz/AAyVWvfXlAihsqCj+ccarokw3TXeiFSuq+voJlJJEHu1LjaLbFtafQ0cJ5UsPP/22MbiiUtaEJX+66Hblj8OCzacCapVr9tTQUi8x6g1WfQ1h+UL1WPF5nX1ASs2yVoo+VDqZaH4Hr8r1B9wmCEMMalAI8biE52sIrQj3EvN4/eXk4n7fJ+rB51AUKpBv6cDt4D0LsVgmGFid13G4fu+GbYxd9MmbqmV8Gfbn3Wb82zWWq9u8M6dqBsHCJe4Cry+g0x7pa9n0s/M2e6h/PnMa2ST3OlmwvRbm5Fpf+WbKcWKp0wI6b6DkR5iPRAgeqWWnmil6cBn6QCPJKefropqVesFWcCty93SVzFH2hDVnVZ5r4UPxExvmVIdifUJp+hbn/utJtEN7VbEEUzGpSa4sBxx4bX5NgwQE5ZqpcOi6AWdeLPLejITpA7ClWPqiAEjfK98WO/wN6z5jOjYmR+pidvZIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(346002)(136003)(4744005)(66556008)(6486002)(956004)(83380400001)(6916009)(8676002)(2906002)(2616005)(316002)(5660300002)(478600001)(66946007)(66476007)(86362001)(44832011)(8936002)(6666004)(38100700002)(4326008)(7696005)(1076003)(52116002)(26005)(38350700002)(36756003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qX3E9zP5Ll5Ga4x23E3OyLPiTMB8BgHxSPp1oZGl/ctyrvUzgEr2z1HX9muj?=
 =?us-ascii?Q?g6NsrHUBHUZJfUWII4vtzzJFT7DuNU3teDIrtiRr4JmMRDiCw6OLW3ca9i/G?=
 =?us-ascii?Q?Ipj/ORXOVpz/K+9vFigADAuTdShftiYauC9c6h3yWuGPR3Pzx8BOsJBkKR41?=
 =?us-ascii?Q?7WJ6+iAzBM2DKWjQX0R5pW6Red5ia5YY2WRM4yOfdCploeu8dIK/Ja8L/Aze?=
 =?us-ascii?Q?gTEG7V2HU26jBKQcyDzIlS09WzmtWZycxtBsB0DWkzt8SR+na78r0duxdU2L?=
 =?us-ascii?Q?RkvZKcPpuATP/i1Hi4JoestuZTHo/xlIE0ep2AB/arayrgSBYdSI7PNJPm2Z?=
 =?us-ascii?Q?0loqC3pchG/CCHMrtKhlfl9EjRR4c8fRQbEKEIuomH/BI+ckXkRvMTTAm01a?=
 =?us-ascii?Q?jSQQAK4vcQyLg75dEfhG3VeyKWvYlfN2KNy42PZnSaIL27UmrI0j1yZ8PLmo?=
 =?us-ascii?Q?YuqAD04/Z4Hm55Yf3MATkfg5GWGZ1v73NbtPhgotayJ3xb6BMvB5slW19SKG?=
 =?us-ascii?Q?4SFSh3bBLJQpMK1JUBP1ZySzBxTYEzJ8B8IL/iRGr0aPVNcjSq8lwLD7pV4w?=
 =?us-ascii?Q?lgePD+ZNkscnGnLP5swbmJzpstznoDE6GFRWm0YGEUGDlv2htW6WrcMS6IZj?=
 =?us-ascii?Q?w2rKVrk9SqypeOPavxYtVTAuImlHVqj/hfSnAuXl4StL7FdQ7XCSvgACffe3?=
 =?us-ascii?Q?A3iBxTsX12WCWwblc6IAzbfOzqcJN7f/SrgkOgsfY63AjeLzj5ln5rr6eIuv?=
 =?us-ascii?Q?7IxO0r5j4kELgSubA/ocQx1lbQutwERKoKHwhpo9ogNHrXr6Ms6ucXDfKOVc?=
 =?us-ascii?Q?qAxYBMGJQh1hgcmUs13eH2UKfsgGEDeIwAiBhnq1XGM0HL24Qpxc47sl95sc?=
 =?us-ascii?Q?DYJY0R0dFjaey5KaS8+JluMGOtEcHWQjE+mK6wdUMQcxrq/y8b48sb/pXuba?=
 =?us-ascii?Q?6V7/vcJXJV484OUP/kbPnu9AUzN+T9HgTbhRjr3+qmt1SimcHjns6xQQw3Ay?=
 =?us-ascii?Q?+BUXNtUbsnX1rvpMWbufLlTq7t5C+GgQxn1fYuFsm6y/g1fwFgvMR3wT3KlW?=
 =?us-ascii?Q?Ub1BbAB12es6GL5ViwrEcSuGpnq2ulhoABmVBn/VQgrj5zdb6oy7dV4txM15?=
 =?us-ascii?Q?lAm+lDkflUjpoNPuoXPMVivgJ1/ZbQO9rh52YDA1UlZUQwyxFVTm7QmmklEj?=
 =?us-ascii?Q?/QyDIkhsu1adoV6PhhgOYf2WQMyiSWr3HrHwZzm9iAGsaG8Ms5BNR2tiIzI5?=
 =?us-ascii?Q?JGTGgqApHPhaL/+j/JTSs0+biLM1qorun/exUzgrmEXhZfr4bvAjhk681A88?=
 =?us-ascii?Q?4VoR0xq+Epw0uX2FMWoPeOmd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90eda4f0-2ecb-4ee9-095b-08d901524e3b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2021 03:38:46.4421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9auYVE6HHElQVnYSb4U6TE/fxgFY1G3R/JtZZjqgVHjAoMqHvBSFjwDiAAtVCDw2jjGwfBGBN99HNRm5sBXJvtpR+zx+RAuSPEomtp7z0X4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=705 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170022
X-Proofpoint-GUID: flXJyzi_sRNhR-et7iC1uBm78CLjfAeL
X-Proofpoint-ORIG-GUID: flXJyzi_sRNhR-et7iC1uBm78CLjfAeL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=896
 impostorscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170022
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This cleanup was part of my last patch-set:

    "KVM: nSVM: Check addresses of MSR bitmap and IO bitmap tables on
     vmrun of nested guests"

but I decided to take it out and send out separately.


[PATCH] KVM: nSVM: Cleanup in arch/x86/kvm/svm/nested.c

 arch/x86/kvm/svm/nested.c | 267 ++++++++++++++++++++++++----------------------
 1 file changed, 141 insertions(+), 126 deletions(-)

Krish Sadhukhan (1):
      KVM: nSVM: Cleanup in arch/x86/kvm/svm/nested.c


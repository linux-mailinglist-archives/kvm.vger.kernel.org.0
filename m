Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C917563FD29
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 01:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiLBAhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 19:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLBAhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 19:37:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D799B82
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 16:37:10 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B20PEVf024840;
        Fri, 2 Dec 2022 00:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=14VI+7tC9JZ/5H23OXDWNC+e/UWDTR/PfYwG22dUupQ=;
 b=bvoAxKZPnBNEs3CetSrJdu6w7sKOTQJ6Vx5Ng9LQ2ICRDpBVB9ce/QsksrcfDEnxt8tY
 /5uA+62p/F8nZLRfI8cF4y1+O19yjeFlfl1IU86R3kulHXEkY+dO5znmLgciiykauY9v
 r2XMXTe5829/iKnDFF/sQWoNy1zP86Kb8uOpiFKjJOl1PvgJZfXw+S4raF0lRlnszUVY
 l+3CtVVCmRlPBC2Aqaf607OrC54JyylTEarNzZdasPM5IAMSyTk7JQU+7ze/yqIPRdyB
 U/fSwM/gthVYr50cYlvnHWm+DFop7wYTy9vsISPdMrTdhX4BcoCmfhUInRPQXsVz5pzi sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m765w02xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Dec 2022 00:36:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B202RXs007636;
        Fri, 2 Dec 2022 00:36:12 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398brgwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Dec 2022 00:36:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTfD5Hkb8znM4kKdvEL4ZCTEbJXFTC2merK+sUW9E/x5IqU2TDnwWtYTnlpORt7BJl+aZHIWGVV+uPUmWUEXJFvKeotYAXo0LMITsr9mKnTl7iHVHg0+zaQj9QE7TpB7/FCHB2tN/XiGGdgK0YTT0ggNE/6eELlc2PAh9rpYzo5TnFnXxR65QbbehZpaNTH9SuCkG84kLeGaKL75Qo6e/a6VXr4f58uWxmAXqPgyy4dvUo7eek5T4noExT9++ug5TrImbJEZcQFf3DZ6f7pkrPBrBeN0fdSAVrPeU8/ht/p5tU5bNS2yHnpuZJWkvRC2qWJVAgC6+iuQjAO6YhI0/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14VI+7tC9JZ/5H23OXDWNC+e/UWDTR/PfYwG22dUupQ=;
 b=Ih0Shcvjz3IEqhl+mQahc6K3A6yylvWw82yV4bt06m8v6HdpMKkB1PAH72EZQQV43gW6Y0INITon3f9NnQZ0TUoQPI0fF6JWzxBebxdfWNWzertJfdQ/R7D5SH2z0PAucLc9n3EcbEkH3VSI86a93QgOkBzpt7o1pQafvp5B5igw8couXZnKAHIFWl7XkZGsDzEIODXgowVYtaflrIRM1XPY5umPYrDnrNHLVopEtSL0Pcich9Xlab12oJyEa6/4c0ZjTXSEZ9ehnQWPGkJv+wm15lLb5THwbakFVuX4+CjRpDjcMjK7OuT3DKFU+q4qCMpgPkpti9fqEvuz051qIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14VI+7tC9JZ/5H23OXDWNC+e/UWDTR/PfYwG22dUupQ=;
 b=yFa7JP/yNZCNT+LVeOGCcOv2jETsDewrSEizjif5ytjMEWLMORCwMVgNwt9ym1pyywX/bOQ3ctJcJYpljTjAo7fbUnM1Vq1v2b4EC1fbKZ2oanrxNSldxm20IZK7kUC/IAl3+wSt9RjnEURIZUP1pcdzOCye+SYrVTT/gSeskZk=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM6PR10MB4396.namprd10.prod.outlook.com (2603:10b6:5:21e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 00:26:09 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7%7]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 00:26:09 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        likexu@tencent.com, groug@kaod.org, lyan@digitalocean.com
Subject: [PATCH v2 2/2] target/i386/kvm: get and put AMD pmu registers
Date:   Thu,  1 Dec 2022 16:22:56 -0800
Message-Id: <20221202002256.39243-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221202002256.39243-1-dongli.zhang@oracle.com>
References: <20221202002256.39243-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::33) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DM6PR10MB4396:EE_
X-MS-Office365-Filtering-Correlation-Id: 3151831f-e9b6-48b3-2ad4-08dad3fbcf08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uC+DagLP5Af7MKiLs8LNYxmZZHodBQS71d+NJf1xz0oxxGoDbl9nzetQrZ6PAYH0I065QM1jPUGi+Ts2cz16xm6wO45scNdXhP7ZRINqhlnjaJL34URDPCB+Wue8cX+CW4pNyd8H89+atNVr7kOPnqHc/9X7lmtR7ktGMmiOWbx4kY5g3JdAkyvjNqD4acbiBcyhWfcwTzJ1/DKO6ocdR6NllYBauw/hCLVbRJwqhU2vWyiXh2aStexz1k3sea3yq1EC4qNmu9ybH7lLHYxF48a86etk5jTHUa9NulmQCnYXOR4FPWeTPawWMzNVx2f/VfPwWYEq/dDFDa2b+I8ehfVvPV+IsN8uinTNU0lr129RITMDZ9hmHDDMXhKa6N/UINzyQTN4Tui73t3VcXaPy9hV7MDYSQtJStP3TCn95QSrMMpyvpo3qVli6fwXaDDqx8d7JUF2tLSw35JQPGblBEalFlAX2QY0NgQ9PckIHPO+GhVe20gPWYyR4JpjDwQNfoaURV4FGhy6U15u7X5RaXoNJj0K31NkjANDSzrFf5lzmCW0kjP7o+AjvXinz8Rd02hyB1f/aHHu3RP0DjqRws6OoXm/B2b4Mw8kGwBoa1ZUVJTHo/hj52JDLZdPIFGpOHcpianCZfAfWXGa9IZWZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(36756003)(86362001)(316002)(6486002)(44832011)(8676002)(66946007)(4326008)(2906002)(5660300002)(41300700001)(66476007)(8936002)(66556008)(83380400001)(38100700002)(478600001)(26005)(6666004)(6512007)(186003)(6506007)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krqkIf6IihO25wu8XRBzOLY6u+AU/qVKZ2o2zSGAi+W5N4pbNr81v8smxYZc?=
 =?us-ascii?Q?+N7W8zPtw2cHvB3DN5mSuyskbfTBsWunG0a+1Q796p2MK4ZudU0JM0ITt7mr?=
 =?us-ascii?Q?YPHGkcS1vMf5NldoTpwLWMQgbgb/ApllzMuvLKsjBchfqHoUx3bSZAwVEIdW?=
 =?us-ascii?Q?UPHWkL8i7vnCnPnpEH6NN/D06NYmfUxmm5vmIQCbbao2FGEUidUv3eBxHi85?=
 =?us-ascii?Q?3sYc3u/+bDZNqsFoNe4+378RkKwi9jOmf/n1kJytS86FbUeWy2xX1AR1b421?=
 =?us-ascii?Q?9YmDcegCNPpeJr6/R2ydfUWkWn+tqBAWqIyFzP+guhq6NthGShU1stWpLNGs?=
 =?us-ascii?Q?E3TgivS3POdAsKwQbndyQncpOx+kqTr4DsdkY/Wo8vDtKgXc6Wk+YMwFx+3f?=
 =?us-ascii?Q?OEAw1nxWo6hiMgcKXg24KKg1PzHWAFcV6knjDOufYG2Eg8T+soaScKFkmzbg?=
 =?us-ascii?Q?Sw7gFaBRE9gDGlF8kVQmZIRzMVGt6jkypW44c3QmmI3Z8ygnwU5e4kUrQljN?=
 =?us-ascii?Q?JvQard7j40TKOd8Uu204HQAPymYFgTNx3VkCROe1M/tl7OK2km6jP1/gmrnz?=
 =?us-ascii?Q?tjosYchUcfMv+bA05calVpRjTpRkULLCjrbh5i70qtGG74cLp4X8mlZin8DP?=
 =?us-ascii?Q?WhX/FTeyPhcbtfwHShm/IpYvtfaHTRW9Ymf26sxmCuJxISiiD9T7daDsdjLn?=
 =?us-ascii?Q?jP88LBs0Up7ZvGBYO115UFSUqv3qgaD0AJIqtSvPDVFu26cFAAZLfSv7AUWc?=
 =?us-ascii?Q?nkjp5Btij48ERMmo0645SMITGqJT9+slMVr9bEzseYDQsEtnrmMfltzr3lbz?=
 =?us-ascii?Q?yqOkVruTx6i3Jn87u12M6QJo/tvcjvHUzcNlUqgMnEAb/GUkNPTC8Y/jrpjy?=
 =?us-ascii?Q?5YVR1FYd+sJDXOooe4rztuv6RpuGksanFOett79ynMeK+SkVl1a753cS6PJk?=
 =?us-ascii?Q?gpGpRZr7lhTrxMJN/fTfwet8Ns/fFZsahsdsRCbe/bTp9ERgHvK8e61NNp9u?=
 =?us-ascii?Q?TXBnzsQ3mO2Cg335bfxrSlJcKElmUDX9ksDCGgSuC/Z38FMGCRiNwhBWemrC?=
 =?us-ascii?Q?EXSJl9HLSWUXkt2lP7jpcFSDcwoGB27QEL6kvL9QhPcTYUzj971NRwaUEPXb?=
 =?us-ascii?Q?PgRFHbu6tYkC42NEPRnNyFGGFD2Q8vY/OSQhdc9ZCdZaO+rkz/QyoOK/bOcq?=
 =?us-ascii?Q?Xj8bM/8yVEI0hDhcyA4WYrfswEXV8aWNgfs1HQiKQDBLWlrWUiJCqgaYyb3q?=
 =?us-ascii?Q?+nglWkz1Ca7wmGEY6BIge4GrxRXUzjDFEilKDShtBh1rK1bmd2w5J+ek0CR5?=
 =?us-ascii?Q?xGaGY9lqrvyYSVXrv5C89aUpd7Za1spE3s4V/SRE0wEFr9yRlox5kTaQZ+NP?=
 =?us-ascii?Q?CdHzUgFy6X251oXTGIpCdXouT/A9Pk7Z1kuxq5F5pUZDqfrnMVSfVzlksZgM?=
 =?us-ascii?Q?zcQaKvUciyFotbWsV+PQZ32wSG7nsUqPZPeNX26ZwPHlNjXHmznVXGVFPMyq?=
 =?us-ascii?Q?jCgRqxuKy9DMbxr2N0/eEMdk0R7x5Zy4QToHZStfmQ8eump9eeklTm4MZVyZ?=
 =?us-ascii?Q?C6DEfj3GmrdvbFu5qk8wPeVMlLbU7hhiwCZeSbKT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?LtoyKfY1fhfG7vMrFpHfKARgJbPEFlD41n/GzHGDycZ5jwi9wLzxvPwbBakK?=
 =?us-ascii?Q?ElRLIPnF1FL8u1IKbWzZfFGCPceB0PgRtKvYJYiI7vh6Die1il7LPUTC2iLz?=
 =?us-ascii?Q?wOsMv+aOexqKYU+hRB1oZNF5eEeghdSzStG6CiTP3rvivfJPKVYYtSaLnyEH?=
 =?us-ascii?Q?43LxqHL5hxJWSIYymohAivV5lrsiNW6+L7XOIesb0ye5XavzW1q2LMDqHWTh?=
 =?us-ascii?Q?sXo9k95wbRAoJSttab7V1WGhpsdzXm2V/IRI+Qng1VT+NrpegBntsSq7CBsO?=
 =?us-ascii?Q?LXUiFVOtuspgM2eT9LFLqZJVaMZ70ER9dQCQfImtHb9GX9ZzjHJNrMbosAGs?=
 =?us-ascii?Q?SuT2gRI5ijuBmQKY7P+G7tMmurDtCRNXC8X/gDuNBq51B2hykVDGsn7e3ytn?=
 =?us-ascii?Q?7nFW9riUXNe+xz9fqbyyNetgI762n8hNt/D1n89+DtWv8VhUluoX89j0xwGR?=
 =?us-ascii?Q?tX/r2SmQwLEXkYlSMgxDEvFL38BsuGXX4JiDqLeoNmm3vLYDH0KuhLmrq+7u?=
 =?us-ascii?Q?1M3OIGCHajnvi3D+z7oZI4Z056vBpGBle4yucYWrQftMGlfjER4eH0gwpR1H?=
 =?us-ascii?Q?SSJvPIp8az6eSFehvna/pG7n9l03pGs17WRCsU/7ohYhu09Rkq0l94aFiqx8?=
 =?us-ascii?Q?GmkmcNnyqNw38uighYzFvBcrHs0ETjIXGaXmskI5MnTSqmTRCs6+a8GZrBnK?=
 =?us-ascii?Q?ciaf1Zgf/Nw4bLTd3L/IFmXwdY1pr5S5dtGLeIrM/NhPAAOzjGH9K0V8v3Nr?=
 =?us-ascii?Q?ehZBPJDXgpOEC589znL2oc2gHvqjc64V+gkO6jyiJHL5WLsEcgFRzcPNmw2R?=
 =?us-ascii?Q?y7314hO779+8OVesBDu0hKmmhylaYelL+Aye2YZTmumlM5mtcwxyN03ClgJ7?=
 =?us-ascii?Q?6CA33t62uNH+0xp2nl7sD4OwyzFVvZphyaJhBO9IxIQzVSyeRMdnvu9Kz2oW?=
 =?us-ascii?Q?IRT7LTlEL18kRUZlr5/D1g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3151831f-e9b6-48b3-2ad4-08dad3fbcf08
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 00:26:09.1267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDHmS+VUU/pFKlAi7VC7hLZjuUFFUjMTo153GDGw0wCDbwMePRYkBsWv1olPc2VyRPTEucu8+OowQ7BXBHYcaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_14,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212020003
X-Proofpoint-ORIG-GUID: R0MJPss_L8gUbEFWDT5f2rA3vSrS0faP
X-Proofpoint-GUID: R0MJPss_L8gUbEFWDT5f2rA3vSrS0faP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The QEMU side calls kvm_get_msrs() to save the pmu registers from the KVM
side to QEMU, and calls kvm_put_msrs() to store the pmu registers back to
the KVM side.

However, only the Intel gp/fixed/global pmu registers are involved. There
is not any implementation for AMD pmu registers. The
'has_architectural_pmu_version' and 'num_architectural_pmu_gp_counters' are
calculated at kvm_arch_init_vcpu() via cpuid(0xa). This does not work for
AMD. Before AMD PerfMonV2, the number of gp registers is decided based on
the CPU version.

This patch is to add the support for AMD version=1 pmu, to get and put AMD
pmu registers. Otherwise, there will be a bug:

1. The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
is running "perf top". The pmu registers are not disabled gracefully.

2. Although the x86_cpu_reset() resets many registers to zero, the
kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
some pmu events are still enabled at the KVM side.

3. The KVM pmc_speculative_in_use() always returns true so that the events
will not be reclaimed. The kvm_pmc->perf_event is still active.

4. After the reboot, the VM kernel reports below error:

[    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
[    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)

5. In a worse case, the active kvm_pmc->perf_event is still able to
inject unknown NMIs randomly to the VM kernel.

[...] Uhhuh. NMI received for unknown reason 30 on CPU 0.

The patch is to fix the issue by resetting AMD pmu registers during the
reset.

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 target/i386/cpu.h     |  5 +++
 target/i386/kvm/kvm.c | 83 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d4bc19577a..4cf0b98817 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -468,6 +468,11 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
+#define MSR_K7_EVNTSEL0                 0xc0010000
+#define MSR_K7_PERFCTR0                 0xc0010004
+#define MSR_F15H_PERF_CTL0              0xc0010200
+#define MSR_F15H_PERF_CTR0              0xc0010201
+
 #define MSR_MC0_CTL                     0x400
 #define MSR_MC0_STATUS                  0x401
 #define MSR_MC0_ADDR                    0x402
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 090e4fb44d..296cd4cab7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1987,6 +1987,32 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    /*
+     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
+     * disable the AMD pmu virtualization.
+     *
+     * If KVM_CAP_PMU_CAPABILITY is supported, kvm_state->pmu_cap_disabled
+     * indicates the KVM side has already disabled the pmu virtualization.
+     */
+    if (IS_AMD_CPU(env) && !cs->kvm_state->pmu_cap_disabled) {
+        int64_t family;
+
+        family = (env->cpuid_version >> 8) & 0xf;
+        if (family == 0xf) {
+            family += (env->cpuid_version >> 20) & 0xff;
+        }
+
+        if (family >= 6) {
+            has_architectural_pmu_version = 1;
+
+            if (env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_PERFCORE) {
+                num_architectural_pmu_gp_counters = 6;
+            } else {
+                num_architectural_pmu_gp_counters = 4;
+            }
+        }
+    }
+
     cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
 
     for (i = 0x80000000; i <= limit; i++) {
@@ -3323,7 +3349,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
-        if (has_architectural_pmu_version > 0) {
+        if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
             if (has_architectural_pmu_version > 1) {
                 /* Stop the counter.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
@@ -3354,6 +3380,26 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                                   env->msr_global_ctrl);
             }
         }
+
+        if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
+            uint32_t sel_base = MSR_K7_EVNTSEL0;
+            uint32_t ctr_base = MSR_K7_PERFCTR0;
+            uint32_t step = 1;
+
+            if (num_architectural_pmu_gp_counters == 6) {
+                sel_base = MSR_F15H_PERF_CTL0;
+                ctr_base = MSR_F15H_PERF_CTR0;
+                step = 2;
+            }
+
+            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
+                kvm_msr_entry_add(cpu, ctr_base + i * step,
+                                  env->msr_gp_counters[i]);
+                kvm_msr_entry_add(cpu, sel_base + i * step,
+                                  env->msr_gp_evtsel[i]);
+            }
+        }
+
         /*
          * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
          * only sync them to KVM on the first cpu
@@ -3814,7 +3860,7 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
-    if (has_architectural_pmu_version > 0) {
+    if (has_architectural_pmu_version > 0 && IS_INTEL_CPU(env)) {
         if (has_architectural_pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -3830,6 +3876,25 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
     }
 
+    if (has_architectural_pmu_version > 0 && IS_AMD_CPU(env)) {
+        uint32_t sel_base = MSR_K7_EVNTSEL0;
+        uint32_t ctr_base = MSR_K7_PERFCTR0;
+        uint32_t step = 1;
+
+        if (num_architectural_pmu_gp_counters == 6) {
+            sel_base = MSR_F15H_PERF_CTL0;
+            ctr_base = MSR_F15H_PERF_CTR0;
+            step = 2;
+        }
+
+        for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
+            kvm_msr_entry_add(cpu, ctr_base + i * step,
+                              env->msr_gp_counters[i]);
+            kvm_msr_entry_add(cpu, sel_base + i * step,
+                              env->msr_gp_evtsel[i]);
+        }
+    }
+
     if (env->mcg_cap) {
         kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
         kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
@@ -4115,6 +4180,20 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
             break;
+        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + 3:
+            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
+            break;
+        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + 3:
+            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
+            break;
+        case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTL0 + 0xb:
+            index = index - MSR_F15H_PERF_CTL0;
+            if (index & 0x1) {
+                env->msr_gp_counters[index] = msrs[i].data;
+            } else {
+                env->msr_gp_evtsel[index] = msrs[i].data;
+            }
+            break;
         case HV_X64_MSR_HYPERCALL:
             env->msr_hv_hypercall = msrs[i].data;
             break;
-- 
2.34.1


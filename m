Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB79389AF9
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 03:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhETBk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 21:40:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41590 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETBk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 21:40:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1bGhs155718;
        Thu, 20 May 2021 01:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=X11dOUZciKxmw/EEnQz1c/bn26jxWa9bmuE/WSNT9ls=;
 b=VzrFcmExobruUzmtEmmTm1saLMPxp9Wgl+kVt4onBNd/NleWpo3yE6NYY3EwJjYiaIxD
 qhqp350CDw+57GdCaySogJ/P/O2ZJn1jZOpuXD5nh5PbhWTDHRbRPg16A6tgjqU0lVH6
 m1nkFgboNbtBEoCu9jG+2K2TZ2bE1+HLnuyDBEG5sbWdeZAfiIpT8z/RTqemweHSI3qL
 j6RHN5APwzWqItFXSWm/zGqLjK42kow1E/YX3HDK2LRaxl+FFG6VdwXULKJu7L5JTbkp
 PYoZjjYfbXybpmxT/1t4flCvuL3TYy74K5vRTrINOkpD8XTKp/FT1oZdMemeiLdAQh3S EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38j5qrb92x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K1a6nJ017253;
        Thu, 20 May 2021 01:39:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 38meckwdm7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 01:39:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJBEDRJW4Iok/QHIOTTOoeoaE79K6UkzT49B5zYWeXYNEcHsHz2DNdCTs0TgrODkFzRkigSwDTD/jRWpJURQzR2ljTaNVa3Yru2G7lsVYdP7EohHL/st6m7AYyl18KNSGlAP61PJUmZF3Ffz4iyXl6tXudLrBOyKt+JPXyMe+gxq9G3KFHyaFGiiAZCZZbo4P4LryzJlGjr9a/yU3qhzYaWdYyqiPJodDXIOz5wJovoxl+Uc9PeFSWn4eUktNvLBwEm0vNheRUDdsawa86YJJG6jeyd0iRPuUgK5Isj4uW5fgj7Ro9/KclpPmlGgDDOJPVDr9Hn9qWRNvVwaCJf55A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X11dOUZciKxmw/EEnQz1c/bn26jxWa9bmuE/WSNT9ls=;
 b=lx++fJUdAlQ7gSZcoojiyKm+kQCF+F/34l+3FJ3K54q9mfyla9DM5IJ9potGMCQ2DKgIZ8hz+RpTHEUEj6X0OXG0+x0lR6ByefLoOh37NL4viNZz2rvjH89NnR0xnYByhkqdUCQ2Fhw7p2L3woLfZLABVW/ovLOj1fTDdsWvZVD9NAO5L0CJDXpDs8lW+WoJsYonnIV1FBsgjJALychNLIMUiVMcWDIfa68gWVgKfVYc0UALPqaXS0yJQr7fs1jpeSAc4tS8G8NKZDxPzqbe4Np3NxZ9l1Vcwjfx12r02fBKwIo8IYbjy1b9ODmz6HHs06u0oy8D65tYgz/gfMgpHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X11dOUZciKxmw/EEnQz1c/bn26jxWa9bmuE/WSNT9ls=;
 b=MCKaIoJRoNniKxJqV51tKj2QxvqOtnoZXRNzgQM5yKo6XM3TPgARJOfwwpbFW0ztIs/A1/sy/dpiSDYsEKRikbgcvCgEXBb3EfMd4387O/K4WoielhpYSeRu8bb5t2cTZqj3MjPz9pSIWaIp5VQa+NIAMkqUu+KN2ktGQFgTF5Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 20 May
 2021 01:39:28 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 01:39:28 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/4 v2] KVM: nVMX: Reset 'nested_run_pending' only in guest mode
Date:   Wed, 19 May 2021 20:50:09 -0400
Message-Id: <20210520005012.68377-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3b925e15-b8fc-4193-a949-08d91b301b60
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:
X-Microsoft-Antispam-PRVS: <SN6PR10MB29436BE31E70CB3298FB46CF812A9@SN6PR10MB2943.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7I5bbkW1KgABQMVlhrltQMddsGGhEhbGDGRNNl8U01M4qV3VNpD4JIkWi/yQ8oEV6upSvsVoHSmJpeNQ1NOmSr9de+uhjSU8z24VT6Y77b+vbVsP4eJjW27/HtmNRO7RLjOYJ/wg5dxOI0OI2IjULSLx3OLFIXJk9zQkXfGgcW7m1KM2Isxa10CW1mmIoBfdzhV+gUKiExEpEO0oEmTd9CDYY/ypkDMIaERp2oSRzmNbfVgKGlRvKtnZFGBEw40lRzIrRsRiOe/dvbSK1uCWiQEHYsvqZpnqdswHsbPChebv1Sl8td87Rii2zNRXpFVftRE7k+SdTObHhBdcl38qemNGDcKtGtjuLi6XmVcvxND2GYRRCal6IP1cNRKDmOuGFPzn/VV+0l3cCM4W8Z6W+pUqsBk0rljhFKAHskmPwvEeysrDbv9/+OILq4lt8rTLsvdExYTkP1LbsIguCE83+IUooYAVnGqD8Jj6phGN7kEPBjeKc2n6bNtZGwLSCUf9QCKBs5VPvHO75YeVcq3tL35fI0MV1gHIFIpAQWXCAdZM9m2ZbUL7DmUZ69kiF43er/WZCBx+I5ts04NngY7fE1y//WfwXRgLsxeU7lJ2H8VWV4umTRhgnFCa3PqBmWhzYGoI8ZiI7eqKKw1LRXiAXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(396003)(136003)(346002)(1076003)(6486002)(38350700002)(6666004)(86362001)(44832011)(38100700002)(478600001)(83380400001)(66946007)(316002)(186003)(8936002)(7696005)(6916009)(4744005)(956004)(2616005)(52116002)(5660300002)(4326008)(26005)(16526019)(66556008)(2906002)(8676002)(36756003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XOk6RvyJ8NPxb3plrP38lAokJIY5Xa94Ux/30O995ByI85HAjr7xxet1sVew?=
 =?us-ascii?Q?nC4A6aft7ve3UgBCgvUcNWsnjjVATe0JBzpJts7Hssjs5B1ItlQdr425ykdQ?=
 =?us-ascii?Q?uPjzKyCR1eqgSj1iuEpU9w4552gM6H/4jWDfjtr51rst7AJsj7DvoBozQEgm?=
 =?us-ascii?Q?Xd13anlOewFY5WkXhowrlVdrAwZYjE9QZa9bmNYhwUkwClgNfW/0w3CxgacM?=
 =?us-ascii?Q?xGhDMBUWBqCbWWaX37mWQx0VLmI+9MP6DaRayjp0SH+MN2hVggOKxVD2uyqP?=
 =?us-ascii?Q?ZYHq4ABkA7bSznYOXg8dOdfI0JaMv3unYr/Rl0CzbPzS6ZuXRUQ5e9DU66nh?=
 =?us-ascii?Q?pQNAT43bfNdoZoPcTJM64Mox3XbUY6QWcLJR2h+RkOm4bcIpiGQf91rRjhjS?=
 =?us-ascii?Q?fTOBCS0VLALcIt3DyOz8CJ40aiITUdmxwo0OXEwDC8hxCaziu5zRBqHQzGxi?=
 =?us-ascii?Q?EKMQgsJ0mRqAth50BSijbHUYGIYyddgMjLZcwYUF36H+vM+6B6bOJ52lFklp?=
 =?us-ascii?Q?fyVBecqlTx7c/ZO+I0Gmctb5fcrTDcP1pKUYdHfckDhD7tlmxkrCaftechmq?=
 =?us-ascii?Q?US/Wh5wFc7WMLFJvfQFXxkUNhs6/mX/Avd+P/59NZyPPOzFxhMrXD3/VUO/W?=
 =?us-ascii?Q?zKtYqSINOhlfYfRjMMEftcy6bD2zmgyp+SC6ef6QwLcQd2PAByAB7VdM1SVx?=
 =?us-ascii?Q?3TQOMtuLAD9EhVbVre/ceL1Hw8qx2Bc/ONO3bcrlyTV/ruwi4t9rj/O+NpUZ?=
 =?us-ascii?Q?0Oe2Lxauy6qHRg9r9XE0XwkIF/PRW4+PhtrEPSS0AhL/2TokfMOKsVspzozR?=
 =?us-ascii?Q?QtXiIVlawR+RDusQeEDwdPqOP/w2eQDd7jajZNuFSs+iE/3TLlhNLBPcRmQv?=
 =?us-ascii?Q?AItHt/A0NPwKVSBWnOxPFT1NWKj0+soAhzSYXxx3CUwAewAsSJI/BDTQdqog?=
 =?us-ascii?Q?/gzaIQHwG77c5LrdnQ/0KOsf/18ldaS1KxSNF6JQrygvTtgCMQahVwWE9zw6?=
 =?us-ascii?Q?g+ByUNMo55n6PeJ7HD3yUlr2LktGAMjlYmjYyMsNnIWpbOZZRZmyxD1VfgHF?=
 =?us-ascii?Q?Vu0cMJWfvWpLLaT3Q2LnqBw+Z7EaA48b5TcgrqVzfYeTnlIoVx1RxcbzpXwO?=
 =?us-ascii?Q?cpyvLO7Gca0ECYfAoHClDK83CvhOZhrD6PBIvVkkyZnEIJk2IhapHBtAID5M?=
 =?us-ascii?Q?TWejbIImaNLCP30LbSx13yABoG8VF4MDx8zpJvcs1SIuYPvdg5dIO2xdwVOZ?=
 =?us-ascii?Q?VZM8xzqOGbyf3QIO50qxz9IEcfuq49Wwbfb2MHV+yY07s1BUlgB3/4ENR07s?=
 =?us-ascii?Q?kcHaL2WQWk3w01yVMmN5eAwd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b925e15-b8fc-4193-a949-08d91b301b60
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 01:39:28.5403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5D4SQ3Xl1qXdVSlRsM1WIsP3gZrWK7SdK/Kcp7In9EY4MS0Z2+4ByFouagMt30uZzXUq+UNAuUK7lKKu9nHdLxrYvOK9+0C8E2kaGXwy74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2943
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105200007
X-Proofpoint-GUID: T5b7sJ8xW1yfG0qNKT3N9WZ6KusbuVgj
X-Proofpoint-ORIG-GUID: T5b7sJ8xW1yfG0qNKT3N9WZ6KusbuVgj
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, vmx_vcpu_run() resets 'nested_run_pending' irrespective of whether
it is in guest mode. 'nested_run_pending' matters only to guest mode and
hence reset it only in guest mode.

Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f2fd447eed45..af2be5930ba4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6839,7 +6839,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_host_xsave_state(vcpu);
 
-	vmx->nested.nested_run_pending = 0;
+	if (is_guest_mode(vcpu))
+		vmx->nested.nested_run_pending = 0;
+
 	vmx->idt_vectoring_info = 0;
 
 	if (unlikely(vmx->fail)) {
-- 
2.27.0


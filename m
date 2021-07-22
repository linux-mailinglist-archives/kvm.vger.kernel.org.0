Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2C83D2669
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 17:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhGVOah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 10:30:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39046 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232524AbhGVOaB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 10:30:01 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MF2t1i012211;
        Thu, 22 Jul 2021 15:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dDFKFeoVOd6ZrJK59txHmbLkby1MtMNPdM4HKmOgfCo=;
 b=EvyAwFBmKazO7Hro9GzROeUbKplLCdVB1qAtAfvdGVBruNOQRk3p64OLgY1+L+4sosIp
 ZRjkyM1EN8rk5ATvh2KNUasKmJLOvDfyMlVE0v/ooSzfDMc6GuSsHGUtOZnW6dtYXTL7
 jsJ+eXqRUYcYK4njeaFsl+Pej52axoHmh1Ui4+oN5Jqmz1k5dkEFOzZTI+8NzDd5Uq7x
 MTW0pAYchPE3pu5aXu7azcEC1Wv8xiqDwTiDEEGJmgtXUN40nub6y+jAutXSX7oTnYwz
 OnL9URT/HphBohU/AYXs6OhPXyPNnmOmo5I8eWm089jXJe1aD9RX8I9oMoEMIrquPPlI ZA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dDFKFeoVOd6ZrJK59txHmbLkby1MtMNPdM4HKmOgfCo=;
 b=rktf13+er3RkwEIdNX+p8xNOmhbcssjHQ3DP7kWtmc2nZuCvor7Me39i64D2SuBvxlw0
 JWHR/ZoIg7/qbXNZII3Orc5eMpw4NuPoAhxFNbLBWDLvhSEOGDmxbp7LmRHy635IzVgd
 /FIp9lJfmHYFYmc4sFLLmXHTT7NMyR3ecKabiXvrEdlOpoGbCuFn3m5rNp+HgrrHwQ1t
 Xut3/R6RryNVrLtWoFID5/4rkSPlJJGitnxm6LO4ZkgipKw442DGNedZ3UyGzzc0AIM1
 BAFCqLgoRL4D+H65wimlmAr7+L2SpO1+OhE0HxhIV5BfrVlWWA5VXFlld6yocKTDv7ZL HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39xvm7skqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 15:08:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MF1HXv010973;
        Thu, 22 Jul 2021 15:08:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 39uq1bcf15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 15:08:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTn8Wo0Y5Q70xETFokqGHrqmZEsxs+P+AcGFWW1XRWt7R4lMa3B9JYvgwornyOzp3SMDWudfKT1ig/xxTkyVbxkz6xT3RDD0Ln0iNt6D7t1tqSMaeTquoVXxfjKF3vJv+3m2Xp1KLwXXux98Qh84wwBJ55Ch1EMevJXQOBLAUH7/ZKpRnmYi9EgbKrYlxK2BQOAzh+fGACE39hqER25lhrPe/yvsmCTmE87FI7JHX/7mFIMGQoBDmZ/UCn90kzQ9YDSO4U2CTCxnfR6JevkDSjPV1/jsD2KksrPhHg25bhZPaHWiM9xKryYp0x2FMU6Yj0HeiG3F95Anz+f9pMUi7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDFKFeoVOd6ZrJK59txHmbLkby1MtMNPdM4HKmOgfCo=;
 b=A1cd8N6I3UWLtWg6wN5kCzO/bkOBCwqme4kog1BH9mfxwx38buu+cFGW1Wi0ihNzS2soe7VObCk6fQPpfHpN0KfdSXlxMR51w78R7YTJayWFc2sg+65YwUpXW0acOEhSPP6MK6umfO3HU6TlHIyQvmSjmzQXiYB6V65R4jDbxwm1jZpTnqrcDUH4v1YQgDKm+ZDLCNtelvPSDDml+bPmgAwyTSkUcJgWNo2ifzvxXyZZwAMT1dIRUP0l/vq3snSSY3VUSlcQxcZ9lLhU5KYKRuMxb8Baml2ZrzIANiAUNqxOvk1QvQ/SNR5KR2QZP8775kLbWjk0ZIlsmIGXQ8dqYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDFKFeoVOd6ZrJK59txHmbLkby1MtMNPdM4HKmOgfCo=;
 b=duStpeYXyCsxcJp46pzU4/Jy0VdYPeSq/tl6vopRr1MG1khAVgU9uFL9LrXt6SdN8RsAre3Ua1yF6C+fFPRH1p8eisxuINsmkFPfdjqh8J8cmopw4g6uwtuidLyX/trgN3cHRBlzPegRY+kG83hd6sJiZxDRuwX84GgFPr01oDU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BY5PR10MB3972.namprd10.prod.outlook.com (2603:10b6:a03:1b6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 15:08:01 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::fd75:49c3:72bb:ca64]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::fd75:49c3:72bb:ca64%5]) with mapi id 15.20.4352.025; Thu, 22 Jul 2021
 15:08:01 +0000
Subject: Re: [PATCH] KVM: Consider SMT idle status when halt polling
To:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        mingo@redhat.com, peterz@infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210722035807.36937-1-lirongqing@baidu.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <fcdfd388-60f3-2c71-646e-5638ee0b5dde@oracle.com>
Date:   Thu, 22 Jul 2021 08:07:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210722035807.36937-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0093.namprd11.prod.outlook.com
 (2603:10b6:806:d1::8) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700::11e9] (2601:646:c303:6700::11e9) by SA0PR11CA0093.namprd11.prod.outlook.com (2603:10b6:806:d1::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 15:08:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4977f449-2364-44d2-4365-08d94d227f94
X-MS-TrafficTypeDiagnostic: BY5PR10MB3972:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3972EA0FA0B10E67A6481FFEF0E49@BY5PR10MB3972.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0SQTUUw+EBdYWrOOMLbvmXMU9mlohfrnfP1UulChpBVYSWzClo7V9JUCwJjySJpNnjxal2xPXD/yOrmOOx/efqc/M80v1KvHsb0+3F2Rbd/CU5BGpFoqT69TtwVooWxfcLx+K4OVkE8UJD9b59myVRUWfF6WuRKhIJJummt14Df7oa0Fv/CweJ7kCJWDzPaIUyC+qq5bW8InogXGV4XS+e8iyTf3rj8sWFr3GD/bnppSyh3oa7HPwUqVF+AX59olQ0kj9zXK8SMEtD1bXm0BanJZSCrFWuvAYFk7bbyLninyhQaOpgsZ2L+vYeUvl9aZKqs1mg/teZfXsc+fLqxfN64x82EgzFs+DczN6iCtr3iiowrUG46RUs1MEZQUWc22Yy0r5g5jyybkfad1HgllESSmr/iKkUHziajnTPh0tuQW7VGHp1p3+8fFN/c9vHFYWFQK0sRAyfRJPpT/juCV+/ggxHOiEQwe1kLOU4uIoIQ/JSQrxHZJ6jR/NT8ZTuBV+QNXgH0gmcoVlv6LcO6G46IjtVoxk010p8U05ymEnX184iQQEKaHtD7G6niz1R2UbsQrBDBcy5R7TPdxQJwOArA8hxWdKiPozOPiYNN3FxBWbJ80qKzBLwe2fxzezFPEkxnX/XPNagoTC4El/adsqo8Jilgp1ffbTmed8gX8ztZRrC0IrMdIKhwaufCl8py+1qRVXgJEXb9hfdovtUqvRCLvJt8Rl9/sXh2G3HJsbiw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(346002)(136003)(366004)(2906002)(86362001)(38100700002)(8676002)(2616005)(5660300002)(316002)(66556008)(66476007)(31696002)(31686004)(66946007)(186003)(478600001)(44832011)(8936002)(53546011)(83380400001)(6486002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVl3dTBYMFdLT2sxRjhuSHBiR3B1UThSVWpLWDNjMXN1citBdThuV1FINzM2?=
 =?utf-8?B?eUw5VmRBSjIwK3UrVkdTcEttRklTR2hab1lZYU5XcWZyV0JYdHNkSVBOZnlv?=
 =?utf-8?B?T0NobStiRnE1NzR5SkRBdDZoYkw2OFJLT3JkY0ZSZ2VHNmc5SGlBd0RhSEUy?=
 =?utf-8?B?UWhhRTNwL2l5U0VvSk5QbjI2VUtoS0R3N3E0b1lqVHEyb3g0eE1SQWc1cEhN?=
 =?utf-8?B?bG04am5IaEhRZWdwV29rZk91TWhobVRobWpVU1FwU0VCWTBGTlZWcUd6d0Zu?=
 =?utf-8?B?TS9lQjRYVUJITFRxMCtqaE9XcmJWVmozMUUrSXdXMUNjVlMvbG5iMGo2TEdB?=
 =?utf-8?B?S0xBTkNYejRaVHc4eCtLWUNHdGRXZ2Ewd1V5OWJsSFhuOGhLSTN2Sk4xa0dD?=
 =?utf-8?B?a2ZhTkxhUGdiS3dINmlHbkZsWnJzUnNGR3Fkd2hBN0lmRHlhcFU2VjNvQ0RS?=
 =?utf-8?B?TFJDTXBUVjFIaGJ4eXpSMmZ4UnRjVHh6b0ZIR3pNb3FxNXhYeGNwMVlTSExQ?=
 =?utf-8?B?OHl1YzBzM1RicFYrMTNIMFI5VVVvVVpoV3lPWGFzTXgrNCtJUFM4Q1VRekt1?=
 =?utf-8?B?UnI4eGpMWGJLSzlHcVlIN3FIcjg2SmZZVVhVWFpPYmk1emhYMXB2S1h0bFlD?=
 =?utf-8?B?bUp2SjF2NDFxaGVYU3M1bFZPY3FIdkU3THF1L1Vwa0FzREFKMWVEenhkamVL?=
 =?utf-8?B?UGhxcTA3KzhubDhCbHhZdE9abDV3ZnRJdS9FZGFiQWM1YUtKeTZwSVFSUGl1?=
 =?utf-8?B?UW5UbVl3eTRFTkhoVzErZTl4d24weTl5UVBqclhBTjdPQWFpRTg1eCtWakJo?=
 =?utf-8?B?RG1KT1Jvd282OGRoeXNJY1QwV0dDOFBtN1MyNVl3dHVzc3VTa0FkSUNQL1h4?=
 =?utf-8?B?SEErTEZ0c2lZTTlPdFBObUlMRDE3YVNWUHlUbGRGeGh2QURJNGZSaW0zUnZ3?=
 =?utf-8?B?WUJmbGxGMjNHVkhGcmdFK2Z1U0xCZmxGRjdQaDZQSEgveXlxM0pCL3RuUTJs?=
 =?utf-8?B?by9HWUFOZFAzRTFyR1Y0YkRpQXkxSlJRdmx6K0VGWUlocTFkNVp3enE3Q3BK?=
 =?utf-8?B?SGdXODZ4c041Vm0wdTFWa2syV0Y5dU1HUTNYRXFDcFRCQmswVmMrYUhvMlFS?=
 =?utf-8?B?cFg2UFpUMGZtbFdsMmZINzNENDBiVlNtSVlSbWJudEFBSjNTMENDbytQdUE3?=
 =?utf-8?B?c25KZXpLWjZSbjJWR3ZzNlFIeFRhekEweGFMRzhKZ2NMTUUyOEFacGJsUWJI?=
 =?utf-8?B?cTlHbGZqWW1vcUk3Z1Q4YU9oNGluZGpVME90Z0hnK1JmRDN5eVN2MHh2WjV2?=
 =?utf-8?B?UUZaYTdYUHBQRGx5bllaTVR2S0lRU0lJTXd2R3RYUFVPT2JuMm5xZFlqK3FK?=
 =?utf-8?B?c3RiZTB0S0lBajFMOUJ6U3dHTDNWenQ5eGpNcUt2Yjh5bkNKaXV6T0V5Mjln?=
 =?utf-8?B?b21iYUZBUHRGYm5wV2ZXS291MzlzcXpYcHdhckFBMDBpaC80cCt6SitDWmdB?=
 =?utf-8?B?RHRzS1VIZHRDUEZhaUlnVVNYZ1dtY09GbHprc0d6ZXN5eWpqaTlSenE3ak52?=
 =?utf-8?B?UnFlZ3BHRnNiM3BZenpIS0NGNzR5RHozbmdRVllNNEo2SWZybVpVVitsOFBi?=
 =?utf-8?B?U0d0TWkzaEJOOE5NaEpRK0JpL0ladWRxM003V1FZT0dwQ3p4M2dwbG8wZTJH?=
 =?utf-8?B?V210R05zamhlQU1ocWwyNDd5NVdRcHZTZHZOT3p2RmlMM0ZYS0JHZXh0VllI?=
 =?utf-8?B?aFgzTlgzWkNWaVJKN1NqZk9veGl2N3JiYkUzc1ZCTmRYTVJpampVcWNtaEdF?=
 =?utf-8?B?aVVYTm03OUxCbW5FRzVUZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4977f449-2364-44d2-4365-08d94d227f94
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:08:01.5415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1REyPh7/G1Hi+fL8QcCRontR6zN1WR4bTnFXo0pdoYSyn4OJOv+XoLSDweaatZXVkwvjFSPKSstUqCnTG3+Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3972
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220101
X-Proofpoint-ORIG-GUID: OTPdKhZPU9uvo-XEVh3TI-35eC7282z8
X-Proofpoint-GUID: OTPdKhZPU9uvo-XEVh3TI-35eC7282z8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi RongQing,

Would you mind share if there is any performance data to demonstrate how much
performance can be improved?

Thank you very much!

Dongli Zhang

On 7/21/21 8:58 PM, Li RongQing wrote:
> SMT siblings share caches and other hardware, halt polling
> will degrade its sibling performance if its sibling is busy
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  include/linux/kvm_host.h |  5 ++++-
>  include/linux/sched.h    | 17 +++++++++++++++++
>  kernel/sched/fair.c      | 17 -----------------
>  3 files changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae7735b..15b3ef4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -269,7 +269,10 @@ static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
>  
>  static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
>  {
> -	return single_task_running() && !need_resched() && ktime_before(cur, stop);
> +	return single_task_running() &&
> +		   !need_resched() &&
> +		   ktime_before(cur, stop) &&
> +		   is_core_idle(raw_smp_processor_id());
>  }
>  
>  /*
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ec8d07d..c333218 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -34,6 +34,7 @@
>  #include <linux/rseq.h>
>  #include <linux/seqlock.h>
>  #include <linux/kcsan.h>
> +#include <linux/topology.h>
>  #include <asm/kmap_size.h>
>  
>  /* task_struct member predeclarations (sorted alphabetically): */
> @@ -2191,6 +2192,22 @@ int sched_trace_rq_nr_running(struct rq *rq);
>  
>  const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
>  
> +static inline bool is_core_idle(int cpu)
> +{
> +#ifdef CONFIG_SCHED_SMT
> +	int sibling;
> +
> +	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
> +		if (cpu == sibling)
> +			continue;
> +
> +		if (!idle_cpu(cpu))
> +			return false;
> +	}
> +#endif
> +	return true;
> +}
> +
>  #ifdef CONFIG_SCHED_CORE
>  extern void sched_core_free(struct task_struct *tsk);
>  extern void sched_core_fork(struct task_struct *p);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 44c4520..5b0259c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1477,23 +1477,6 @@ struct numa_stats {
>  	int idle_cpu;
>  };
>  
> -static inline bool is_core_idle(int cpu)
> -{
> -#ifdef CONFIG_SCHED_SMT
> -	int sibling;
> -
> -	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
> -		if (cpu == sibling)
> -			continue;
> -
> -		if (!idle_cpu(cpu))
> -			return false;
> -	}
> -#endif
> -
> -	return true;
> -}
> -
>  struct task_numa_env {
>  	struct task_struct *p;
>  
> 

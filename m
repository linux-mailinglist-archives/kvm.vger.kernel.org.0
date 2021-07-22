Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E808A3D2687
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 17:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhGVOkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 10:40:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42332 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232605AbhGVOkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 10:40:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MFGrmd004035;
        Thu, 22 Jul 2021 15:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9Jg38C70JaNd2ePyQZpnUvkVn5fiLNXSJgx5eRqdqoc=;
 b=NslRLfPf1F7GEOIpPR9lcEdCPCEhl8MAiUWQQJ/7N7i1fjyhqVz3sKKmmYZT6Bg16ERN
 vtuL4Kon6dKCxFq7yRhAYGKZZEIeYrTQDbSW/x0M4GO3MUUKRt8KiXPfWGnzW4OCbtuh
 j31DoN3QY2zmM1Tz0+OodfYMMjBlfx0qx2mzjhP4yYHJZrDlmUI6unFLtKgSsUOijo0r
 BzJC7pjhpMzHqWXdn7gHTMJjWRdpFsbOsA3bKJYy9mHUlGLsDYgNLYTv84XGX061Ji1k
 Sh/zIlRR/95RtEqofmnup9NCRaiw0s+4yeih290YJpcSD1EVSvPLtS6X85rn8d0clpy9 gg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9Jg38C70JaNd2ePyQZpnUvkVn5fiLNXSJgx5eRqdqoc=;
 b=dHw6eqs25Fix3E0ExS54/8uhKDtl9r2VXU2Silo3xgySMSnC3e2zZsbPSPfZgvzyT8Il
 roxmHsGavrGNomh6rVnVFt6NTGqRuMDpX9j0KmI+pxSI+PuBWxgaswks4aJJ7a3nWRTt
 dFYV0HWVoD9b5elddDb8sDrK/YZYtCdyItxli639syJM5L4c6ufmtkAh7qCLJzq+Iab8
 n27FdHebkhfCLFuVE2ushPLy4Ao91F6nmjvTW2FJqwExslNt6ykR6Zf2+b9h2MOSU5so
 xfSURBVhaVhsaMihh6lUV6VltlgO4WNirQm/qKAbJXj7GlgMhpWKUe4z5ew3mjdX1R0G rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39xvm7smya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 15:20:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MFFECF065869;
        Thu, 22 Jul 2021 15:20:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 39uq1bd1fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 15:20:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijJHL7xzQ6sIXuV+/LgHHCnb6NvPYxhxIdE1k+R7U8T+6StBYAXpPa/zBW/sOyBo7A5UGzfcp/QdJHIm/aiYFBFZWNdOJVuQqaH/lkNpUCdYIgvPWxEzL+A8gX5CMZ3fGv2hJiceEH71TlWsVFSDSO2NTlem9vLUSWHbvrBJHYbCkGZnZj0AsPvJR6CP4rILYpzkeXawdBwp4vrt0+P9+xzdWTQBf/YJMBiUa1cO7b8Ls/uthVS58ExennDuxefyO4F3hyET00V+UFO/yLbBfePOHn8ajXssO91vI/4JqeEaWDF6iORScSnufBVn2iJ9ztfabomdn9/E7PWW95ww3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Jg38C70JaNd2ePyQZpnUvkVn5fiLNXSJgx5eRqdqoc=;
 b=bMfqZ8hQETg9NIRcZ6xClOQYaxkgL5NwUmGtxTZkKdSp29l1Xow8u1Q6q0ZSQNC4/BzEHIVJKqu8zVPLwIElaBz7fglg+O7PUySv565RoY2/kzDsMtQmyfLBYjB2/kAjGmUCtBVzzwIybP/iprv4TvfdnQwqHBP/aTq+PzBjAsNjUhXXiluVGJr0zffRUOwTNMdhi0Y/2WZ57t+TP03R9M7iBQlIb+NH2eJX9jJBfwG2qnGDmuCndoEjuCpdO3E1NfG5z3k/uo0JQD0ZGaIMuNkkcJKPaookG0Ybx/T/+gPI/NGufZyz5Zxq7+9W9/31N8l8/gBBgZsco5HUavVdFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Jg38C70JaNd2ePyQZpnUvkVn5fiLNXSJgx5eRqdqoc=;
 b=r21ME4tMD97D1yKl7OXY2HNvWkiCba2/ddGCoLPVzqH38YMaYSvmS6oJdWH9hu0KR1YLIpdICDKvD704iqC45DXM0Nan91sZv486HJHf3Y2a2MoV56hEJkm8M2GtJvRRhWq4yV4IHRrMb/KAxhX4em7xsSZn5BptVc+bUIbtJM8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB2823.namprd10.prod.outlook.com (2603:10b6:a03:87::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 15:20:17 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::fd75:49c3:72bb:ca64]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::fd75:49c3:72bb:ca64%5]) with mapi id 15.20.4352.025; Thu, 22 Jul 2021
 15:20:17 +0000
Subject: Re: [PATCH] KVM: Consider SMT idle status when halt polling
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com,
        mingo@redhat.com, peterz@infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210722035807.36937-1-lirongqing@baidu.com>
 <fcdfd388-60f3-2c71-646e-5638ee0b5dde@oracle.com>
Message-ID: <e981a94b-b429-b444-feab-eb352bc3e99e@oracle.com>
Date:   Thu, 22 Jul 2021 08:20:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <fcdfd388-60f3-2c71-646e-5638ee0b5dde@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0084.namprd11.prod.outlook.com
 (2603:10b6:806:d2::29) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700::11e9] (2601:646:c303:6700::11e9) by SA0PR11CA0084.namprd11.prod.outlook.com (2603:10b6:806:d2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 15:20:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 836d0918-2297-48c9-9900-08d94d243624
X-MS-TrafficTypeDiagnostic: BYAPR10MB2823:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2823EDC3DDEB0BEA802EC9C4F0E49@BYAPR10MB2823.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0O3RyG18+CzuoxWOiIfi9MiIp3Q0AeWqYhxf8o4ATS6J7ejMfbAzeaJb1ZFH3JnwUUL3OCx096hqg5Eb+RtaJ1qqeJ5lPKDzdZAwL42Kl/a9Tsjq3DsM87w75TVh8yK+SVzcYbl2Uwe/9M3JWS5XIfNnvuhtysFNO1AGXKwjRzkii0kqqa1AWTsREiiZIkQ7PyOQv8du00DQu7yd29Y9JYnt9+wNFsNhyYH/jjaelQSas4vXvM1CCmQt5XJnrvBLABNocj29uRSTr0xqTAkPYoScecBQ9893wBpV9hlDQvVBXxYjV4SAPjFF0H9hNgdxAMAEQ8tR95MfsVKC1/QJqVHX6PnFXL3hGbLrKH6Czpi41+BncKxPwwccwLxMhZlzHx8nKxOxhv1Och27fIgFdFQzCPZ/fSgjuW5UxqQkB2BapjoW7l0UmzojDwHd8G91uv4epe/bRSGODcl/8OV1Tej5+VlFwX4S525oLuqRn0dln8VzTM4dMXh+xW/h0Gh6tonKk2jJgvOSgzBmmmpXNfk3N/0r2lgA8BAM54FUgeUA43SlhRQKGugEc/kvygsu4RGXRVLM8K6f+0psHCP40pM/I9xhLWbvtFQeNNzBe6x9AZNpoLGOE2qMOnqheGDRpC5KeC3Q/sMpZ74Ia6FHKCN9fFmLFhbsdZzSSKmLkC3acN0A5IopPHmsqtRVRm/Cc6DakFESLe3GduvMy4RaFj3plz3B2fL8Q9uWSz6STSM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(5660300002)(186003)(316002)(66476007)(66556008)(8936002)(31696002)(2906002)(31686004)(66946007)(86362001)(53546011)(508600001)(8676002)(36756003)(38100700002)(6486002)(2616005)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGdiNEgvdGc3ZmMyQ2RTR2l5MnRJUWkxbkwzNmljclJZYkwxRloxRHRJalJW?=
 =?utf-8?B?WXZmK0x3QzZEZHNRR1E2R2FJUmtVWk0rOTdxK2FOY1pUSlZCVVVvaktSWkg5?=
 =?utf-8?B?Q2c4bnpHa3p1VHNPRWtzbktFcnNWSTN4bDRoR29YRXNUYTBvR3dVaFJpOEhv?=
 =?utf-8?B?VTBaSGRPM1lqc2V2Qk9abE5BbnpzL3RzZm9PalB5N3ZuL3Rqb1NuTVVHUnhm?=
 =?utf-8?B?ZWxmbVB3UlBXb2s3dTV1Mm9xcUd0RkJQWVVEUDJBQzJKR3dIUWJQMFQwU0wx?=
 =?utf-8?B?YUIxbC9VZHNMd2c5OVIydHJFZ0NCdysvb21aeG50K2wwSGhjWmNWcGJUMW9v?=
 =?utf-8?B?Y0plQXN2K01Lbnp4YU9OaG5oYkVuQTFvUEp2RVBrUmxIazcvQmpnR0kwZVRl?=
 =?utf-8?B?RnlQcUI3bTVTbWxsRVVmRGRWdjVaejFFa1lCZ2hUVU5SNnhIVE9Qb2NlSzBD?=
 =?utf-8?B?bEYzUjFsMjZQa2ZFd0pVQkpXNDNHejJzazdqM1UwM0tGckFZUDdNWVREMEVG?=
 =?utf-8?B?dWNRUnBkVHd2MjF0N2lGRzR2N2ZsOTk2d1h3ZGtSbnJGSytyVWVKN3N4NXpw?=
 =?utf-8?B?UWZidzhNQmVlOHd3QklPeEVNYzg0TU80MXZQUyt2WDUxYTJFS3FHWTlaMndU?=
 =?utf-8?B?ekhIRnpCZk1ocWo4YzNLbVo1ZlZDKzhMTVp4MHN3MUREQkxGdjZxY2hUc1lj?=
 =?utf-8?B?OEY3VndYa2N1Q1RWZEgzZFlOV0NLNWVWek0vSUgrZmhwZ3NnRlI5WEkzLzZp?=
 =?utf-8?B?WmtvcGhUMXRIaTArNVpDRHlYVGtNb3VXSVJ4TlNvNWY5Tk5XNlhIQVlGMUd4?=
 =?utf-8?B?eko5clVLSXZ5V2VyUTB1bnEySzJna2E1Y2ZINFBSak03Z21iUm0wUTNpSHhP?=
 =?utf-8?B?MVlSYzBNcjl6U3hnckRjUGlaVGt0NDRaL3JvUWdSK3RIdkVBK1RseXJUUk1x?=
 =?utf-8?B?SElCVjVSc2M2R0lpdzRTL2owZWVTTEtjWEM4RlZrOFkzSFU5SVRVVjh5UGpB?=
 =?utf-8?B?S0s2TGpYdjFpeUh0UXZNYzl3VENVK3gzQkdxNEJjcnBZemc2NkhhSmwyeDRw?=
 =?utf-8?B?TWljVjBQcGdJUThEYm9NcnljUnZ4elk0eDlnczRnOC8zdExHeXorQ3ZacGlV?=
 =?utf-8?B?bVUrN3UyaS9jR3J2YTU4TkhVQ1p4ZFFIdk81QytJODBwa3VFeTYyVmU3Z1Jl?=
 =?utf-8?B?VEliZlA5dmRZeHNLYXhDNlFUSldSc3hYUEIwZ3RKOUtpaWgwM0JSVHJpSVR4?=
 =?utf-8?B?Z1Yxa0xZVUg4a085VzRiUER6dnRlYW8rd24vL3ExaEtoa3dyWHhJcEZGRWJK?=
 =?utf-8?B?YWJKRkg4NndEYnhTUlZVWUhUbm5PSXhod0pGWisreVN3djE4RTQ4L3JyU3Q0?=
 =?utf-8?B?TU5HaWtXRVc1OFcwSkdTcEFCMnRmaXVGWSt4eEtzd1M5MEtjMGsrSFZYYXpx?=
 =?utf-8?B?bDBxOFZvb1poUWN4bE1LSnUxaTkyRHJXYkduNTRUc29vNS9zV1M4Q0RCYmxZ?=
 =?utf-8?B?aFVrUVgxTlBjdlJoTGZPOWc2MDNkSzB5SUFXNmw4cTdvaUJSMDJqZWlOSW1T?=
 =?utf-8?B?TkZNZ3FhSTJYaUFYRnR2a0VHOGd3NlFGRlNkMGFoUGpZcFdvUXRDMFlNVFpT?=
 =?utf-8?B?TnNoeVh3NTN2b09sK0x3TnExaGZaczVrYUFkKzZYeUNvNE01Vk5lMldlRDAv?=
 =?utf-8?B?MDVWZGd1a3Y4T3JuZks0c3hnVG1lUkF1cGdNdEtiMEFZdnZ6NW1kSUNRVUMz?=
 =?utf-8?B?YWI2RXFFSnFiNWloN3VWMXBLcXhFc2J5MDZKZSszdThMc3ZUb0IyQmFXRnpU?=
 =?utf-8?B?dXZFQ1VkdHpmZkE0QWdWUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 836d0918-2297-48c9-9900-08d94d243624
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:20:17.3414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6O1UScn1YmSgntszIg4FY0Na+rU34PxiMvEF0l9YoX43yFBNsrRjxkJdgHE//G7OYtvoHqxAaescjeyRuQUByA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2823
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220103
X-Proofpoint-ORIG-GUID: VevcF2T7uyEYpdHLOMDw1ubxy51wpfPy
X-Proofpoint-GUID: VevcF2T7uyEYpdHLOMDw1ubxy51wpfPy
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please ignore my question. I saw the data from discussion.

"Run a copy (single thread) Unixbench, with or without a busy poll program in
its SMT sibling,  and Unixbench score can lower 1/3 with SMT busy polling program"

Dongli Zhang

On 7/22/21 8:07 AM, Dongli Zhang wrote:
> Hi RongQing,
> 
> Would you mind share if there is any performance data to demonstrate how much
> performance can be improved?
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> On 7/21/21 8:58 PM, Li RongQing wrote:
>> SMT siblings share caches and other hardware, halt polling
>> will degrade its sibling performance if its sibling is busy
>>
>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>> ---
>>  include/linux/kvm_host.h |  5 ++++-
>>  include/linux/sched.h    | 17 +++++++++++++++++
>>  kernel/sched/fair.c      | 17 -----------------
>>  3 files changed, 21 insertions(+), 18 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index ae7735b..15b3ef4 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -269,7 +269,10 @@ static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
>>  
>>  static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
>>  {
>> -	return single_task_running() && !need_resched() && ktime_before(cur, stop);
>> +	return single_task_running() &&
>> +		   !need_resched() &&
>> +		   ktime_before(cur, stop) &&
>> +		   is_core_idle(raw_smp_processor_id());
>>  }
>>  
>>  /*
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index ec8d07d..c333218 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -34,6 +34,7 @@
>>  #include <linux/rseq.h>
>>  #include <linux/seqlock.h>
>>  #include <linux/kcsan.h>
>> +#include <linux/topology.h>
>>  #include <asm/kmap_size.h>
>>  
>>  /* task_struct member predeclarations (sorted alphabetically): */
>> @@ -2191,6 +2192,22 @@ int sched_trace_rq_nr_running(struct rq *rq);
>>  
>>  const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
>>  
>> +static inline bool is_core_idle(int cpu)
>> +{
>> +#ifdef CONFIG_SCHED_SMT
>> +	int sibling;
>> +
>> +	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
>> +		if (cpu == sibling)
>> +			continue;
>> +
>> +		if (!idle_cpu(cpu))
>> +			return false;
>> +	}
>> +#endif
>> +	return true;
>> +}
>> +
>>  #ifdef CONFIG_SCHED_CORE
>>  extern void sched_core_free(struct task_struct *tsk);
>>  extern void sched_core_fork(struct task_struct *p);
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 44c4520..5b0259c 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1477,23 +1477,6 @@ struct numa_stats {
>>  	int idle_cpu;
>>  };
>>  
>> -static inline bool is_core_idle(int cpu)
>> -{
>> -#ifdef CONFIG_SCHED_SMT
>> -	int sibling;
>> -
>> -	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
>> -		if (cpu == sibling)
>> -			continue;
>> -
>> -		if (!idle_cpu(cpu))
>> -			return false;
>> -	}
>> -#endif
>> -
>> -	return true;
>> -}
>> -
>>  struct task_numa_env {
>>  	struct task_struct *p;
>>  
>>

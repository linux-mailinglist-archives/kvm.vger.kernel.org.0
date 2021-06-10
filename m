Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AEF3A2258
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 04:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFJCrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 22:47:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFJCrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 22:47:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A2fr1G113791;
        Thu, 10 Jun 2021 02:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GnkVInhkE0UK5Q6woCpkZ4CGZTsOfp+tyJCkqMjTzyU=;
 b=SYix6OTFrnAMibc4KXdUV4mF8hhyrGaJ1TVRvSGSlxPsDfg5YWh5FBKpCyyZtYW7HlGG
 cRJRaOoA7i4cZGA9sawKZXF9uOE8c/tU1y/pDb4MipXMPZoIhLbis+lDdY84j2Lelnn2
 DWjkTjPoeraiMEsPAydS4w8F8WQz6Ruuy16CfH7oDbUe8cBrWo6ozu1prQqFkt8lhBFg
 nFSM3ea2WV0C0b02+Na6oTWknrb9agxhS0as8tC52YhTcJlWPMUzOcIMm+NJSLyvMeg/
 Qlly8mj4KMtmUxzFFZA/butj8tzm1qE+a81riRzmMr9caGfjiO199xL/MeKoP9a4AzJs cA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3900psapjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 02:45:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A2eVHb002397;
        Thu, 10 Jun 2021 02:45:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 38yxcw697k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 02:45:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceTEkIefY8v23QFcxj0YVS3h6sELe2Liz6ksvNJ/4n+mA8kLxAjomIw2TILX9tqRCvIGDm0KseFso8vRAauitTfeAZrqUgfDM/umpGb+POmBthmWtp57nnN7lqqqq+lZdDN2PwvISumkwvCbFToI0hDd8kDOp0NYQDAIluJka3FzP2QX9WTCW0KgPdUohEmqGAVDF0wqWcty82+AbjMC0M2OATLdBVbUjij4lfcrTXb7Y9+emK3vY2o29Sy46V2fgtSGNSVaoF9A2MayZDR8SkAQvhraAjZ5s7a99SbZYfVOqmFlPKWPrk+8/+OmW1vtbL6MxTOVSSeWTYUu6LyueQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnkVInhkE0UK5Q6woCpkZ4CGZTsOfp+tyJCkqMjTzyU=;
 b=dQHb/O75Lojw+uOuw7RJk6ZfeyKox6ifZzrm3WlL2LojXAh3KTYwVT4CJ8elUlrlIZPDYEA5IDxl0o4+wShA6nCroKtuvjgi8vT2tzcOPEHhCDNcH4Be5oDk1WFFbE4l9tboeVN9iS8SA/fwAm2vjIbbGC+IBELF1o64JPDBTgKpCheu9+e9EFKQXQrhlzS49FPKZzyBUWSklz7JdmoGScLFSM93pMbO8owi38iv0qJ6TykbSDCQo2mBCyQkNXmGY8Vbnn1pAJVNcywVNoyBnWuUVyggYDu7L3BJ/ouCOt4MNdIQnXm0xCD1MrvZ21d7SkVgm4MxMnHgcQUTOheg2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnkVInhkE0UK5Q6woCpkZ4CGZTsOfp+tyJCkqMjTzyU=;
 b=Fw+bXvjt5qmQyLX4rxvoYbRx9wL+62pRRR59jpPO9EFohvHooz3Gk4ZYoRskOv1VlrfdixFcp8TrCCI91IX22yiQmVKj7ZEX7MEPTlg08gYDTk0zH1sA4aVcfWU4mAXblGnyMi71SbYYOk5UNXQygJMlLADwI0LeBVA7M8vkRUY=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none
 header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4586.namprd10.prod.outlook.com (2603:10b6:806:113::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 02:45:06 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Thu, 10 Jun 2021
 02:45:06 +0000
Subject: Re: [PATCH] kvm: LAPIC: Restore guard to prevent illegal APIC
 register access
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>
References: <20210609215111.4142972-1-jmattson@google.com>
 <8b4bbc8e-ee42-4577-39b1-44fb615c080a@oracle.com>
 <CALMp9eRvOFAnSCmXR9DWdWv9hzpOFjMXoo6a2Sd-bRBO3wnd-Q@mail.gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e58c19b4-fb4e-04cc-fa58-43d3dfddf5d6@oracle.com>
Date:   Wed, 9 Jun 2021 19:45:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <CALMp9eRvOFAnSCmXR9DWdWv9hzpOFjMXoo6a2Sd-bRBO3wnd-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SA9PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:806:20::12) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SA9PR03CA0007.namprd03.prod.outlook.com (2603:10b6:806:20::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 02:45:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f7ec9b2-3f24-4825-ffb4-08d92bb9c132
X-MS-TrafficTypeDiagnostic: SA2PR10MB4586:
X-Microsoft-Antispam-PRVS: <SA2PR10MB45868F0D6A65A992BDBE5F7D81359@SA2PR10MB4586.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:541;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 31E37uPVTtDPk3G7Kfugo2Nxwa1aafh/yhzoFdkKsT99dLLp3l67IFFlcD4H5Wyec8mkaQOVt4M/Q4KipqSddzpZjPU+yPCbldHBvk+b1Ywu4R/GhNY2U21zXAfv/eUVbBjnZdIVwZnMY9bankNV9rsqwXTqPVbtUjtKW1On30sKHOKX8YiMek47WIqZQOP2nhXBR5cgG1khgpI/XyqorFd+wPY0zABLPV4DTMCVsbSFz0CZ2cvQgCI7s13Wysb26IVQf7c6pcBE/WccRVsYelhgRLT0jXTL98DVJ7Tc0JPg3AF5RoPV50WO/I6wgUSTlWwxZo5yj8qrDsszcTtnKjXaXhwPq3NP1P78DVQAvYu+Q7GROW5WquRp6UnCyvQC3asf+FRqFjxQeDObboH9VZNX1YAtDhJhQuLBG5I30E3NwvwzBN4g+ZQxjNA9QOFcskwCaQwhI4HZfnkXvSVdhozKNlUayH8DbrT2W0J7vUMx9RrXL0WdQ6vCt4iexXo1Q/BkeX+9L290ijYAJDaOb6vKoJNYCFbQ1AKC1GGz/bA6ULQptEW/ewUmnM+5VdZ60sU40ojZiMHSLrc5hwUvjhXLD0yEozS9sUC1va5Uj1yp2nG/8FciaDTCyiWi7xqjRWHplWrMh5wu0dsJCpqyDtIM3Sy9Wl9O3jpegNqcNAd/IXpZvKTWzzrakYv+BQN+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39860400002)(44832011)(8676002)(2616005)(8936002)(2906002)(54906003)(316002)(6506007)(66556008)(31686004)(16526019)(478600001)(186003)(4326008)(53546011)(86362001)(6486002)(36756003)(66476007)(5660300002)(6512007)(6916009)(38100700002)(31696002)(83380400001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWFiRURDRDhyVzAyeHJUWWk2eFJYZHFMQWNjeElYL1o2bXN0cmthZk9DYVpu?=
 =?utf-8?B?YUd1Y3RUZDdSem9zd2dXKzRtWS81a1dxTC9KemdOanVCSk1tVnhwOU8xS09i?=
 =?utf-8?B?ZVZuWitnZmxoV3AxaXkyMjloeFhqQW1STkFnV0RJK21rQk1yblRTK21jTmNJ?=
 =?utf-8?B?eElGV0VLYWJxS296Z1l2b3RkQStqUDBXdkU4YWFOQTVST0l5dWRxMmdLdnB1?=
 =?utf-8?B?aHZybUtFeXducGYyWVlodXU5RllLWTU0WDhodnRRSVhPcUlTekNVV0tWRGpw?=
 =?utf-8?B?d0habWdSV0FQUHpNRVVJb2ZWc2JKYUxNQ0VLcklGeXZTdWdnL1cweE5HNWM2?=
 =?utf-8?B?VkYySHltSmNVdGk2dHNIdDlvNzBkZkZEKzR6ZE96UTdYMndmZjhLNUhsK0h1?=
 =?utf-8?B?VHIrMUNrSm1vLytYcFlLL2NWU2c2TGs0ZDhydTN4ZFRpZEdrcU9LZFhXQ0Mw?=
 =?utf-8?B?OFUydkFzV0g3R2t6NTZ1ajZ1bWEzYjZubGROUFFhN0pVcTlDY1BxZithdVM2?=
 =?utf-8?B?a2xicDRQY2I1K01RNGVDc2JSdnVJZUQ0by9NQ1hycWYxOXhsMTh3bmlUV3M0?=
 =?utf-8?B?bllWMUFnVUVqNm1JY3BiZGtaYXg3a3pZNUx6c3Vxelh2THJKbnBoSGQrWkhP?=
 =?utf-8?B?cWhvc3FyeEJYa0huTUZoaWRvcVNJTGRkbUpSK0ZKWXJzclJlR1dLQWFFTC9Y?=
 =?utf-8?B?dXZSbW5xcE9rSWo5c3o5ZElQLzFrRXhia3hOS3cybG13U2lrZHRBSmc4dUJN?=
 =?utf-8?B?MUsvVm9tUEEwUjJUYXR1V2xKL1cwKzZ4a29wVmpDR1RHU2FaODRxbzF6YVZD?=
 =?utf-8?B?QVJheGdEakpCc0srTzk2OTBCWjYzSHVkTm9EY2FqQVdsaU9aL2ZUbkY4WmVC?=
 =?utf-8?B?OTFSRlFsaDhFNEx6Z044YlRWclRMY1piamQwU2U0azVBRjRCNHpUWWpnOVYv?=
 =?utf-8?B?S0RLTUVnOHFQS0k3QmlXUXBHanM3VWdQSitmNzhaZ0hzZHhFRjg0cmpFU05k?=
 =?utf-8?B?REJZL3hrUUVwZ2twZjJpbHJQcElhbEk5VXRQL3NCV3FHQzlaYTgvY1pYd29U?=
 =?utf-8?B?dkpBSWhFbTRyb29UZWFjWWN4eDlrMitNMkIzQ2JncEtoanFpUTVWaHZib0Nk?=
 =?utf-8?B?L0RmZlZSazBLNWtJdGgvcVJHdVFPa2NQY1dvRmltMDU2aXFQcmxYL29wb0I3?=
 =?utf-8?B?Ym1sMU1xei9vanAyNE4vdTJKczQzWVZOOGpKcnFlR3M4WkozbTlaVnNhcklk?=
 =?utf-8?B?Q3JVdmFqTU1RazdxbmlVMGVZSEJ3WmcvOC9uakt4S2c3WXdlMm1UY0JZYmxX?=
 =?utf-8?B?alo2VkdWei9tT1FETGkvdXBPdEtJZUZqVFN3Q0VJeVZLWDgwaUpUOEdVNm1H?=
 =?utf-8?B?b0w0ZzI3dzlMZWxId3lLaHFZU2NIMU1IeFdlN3BrdlRSeGFtRmF5bVF2MGxQ?=
 =?utf-8?B?d2ZBaUVyTkwzbmpzOXBPOWtlRXl5TnBZa0Y2NS9oU2RlRFYzS0VhcGZzSHhW?=
 =?utf-8?B?NG1FZTNjUGRLblg1VU11cjNyTndaNmw4ekdQZVZwUDI5L0tob3FwbWVTUzYx?=
 =?utf-8?B?Mjl0UFJ3c0RCeFBwYVMxSWUrek9kNkVBVUZJQjNiZnlrN2hmeUszTWhyWXdq?=
 =?utf-8?B?bHZVeFAwYS9yZjZUVi9TSGxnVFpvN0dkeHpSWDhnci9NdVlzWEtXZmt1b1JR?=
 =?utf-8?B?T2lRNnFjaFJjL3BkelpPeGEyaHNXT0dQeDdQSkgxdkNMOHRkenIrMHplUkxu?=
 =?utf-8?B?MVJ6WktsWDl0Q2lITkJDT0hPQ09HSzRPbGV5OWtlS2FvMUtQekRIUUNPZXF2?=
 =?utf-8?B?YWx1QW1sN0lKZ2xTekZwQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7ec9b2-3f24-4825-ffb4-08d92bb9c132
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 02:45:06.3003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJmNQNkWkRwjS/QAOrbK7stHMMCYjhpcbL19RcH7vkwrGRoH/gQ7Hp4E6KqsBF+bjujX1wcci5rWpeWekHX/Yg+WY9Jkwa7quDsRvZQDJF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4586
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100015
X-Proofpoint-GUID: 9I7jdRc8iUXM8QVxN8eD0i7RNHj8_Vu3
X-Proofpoint-ORIG-GUID: 9I7jdRc8iUXM8QVxN8eD0i7RNHj8_Vu3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100015
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/9/21 6:48 PM, Jim Mattson wrote:
> On Wed, Jun 9, 2021 at 5:45 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
>>
>> On 6/9/21 2:51 PM, Jim Mattson wrote:
>>> Per the SDM, "any access that touches bytes 4 through 15 of an APIC
>>> register may cause undefined behavior and must not be executed."
>>> Worse, such an access in kvm_lapic_reg_read can result in a leak of
>>> kernel stack contents. Prior to commit 01402cf81051 ("kvm: LAPIC:
>>> write down valid APIC registers"), such an access was explicitly
>>> disallowed. Restore the guard that was removed in that commit.
>>>
>>> Fixes: 01402cf81051 ("kvm: LAPIC: write down valid APIC registers")
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>> ---
>>>    arch/x86/kvm/lapic.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>> index c0ebef560bd1..32fb82bbd63f 100644
>>> --- a/arch/x86/kvm/lapic.c
>>> +++ b/arch/x86/kvm/lapic.c
>>> @@ -1410,6 +1410,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>>>        if (!apic_x2apic_mode(apic))
>>>                valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
>>>
>>> +     if (alignment + len > 4)
>> It will be useful for debugging if the apic_debug() call is added back in.
> Are you suggesting that I should revert commit 0d88800d5472 ("kvm:
> x86: ioapic and apic debug macros cleanup")?


Oh, I wasn't aware that commit 0d88800d5472 had removed the debug 
macros.  The tracepoint in kvm_lapic_reg_read() fires after these error 
checks pass. A printk may be useful. Or perhaps move the tracepoint up ?

>
>>> +             return 1;
>>> +
>>>        if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset)))
>>>                return 1;
>>>
>> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

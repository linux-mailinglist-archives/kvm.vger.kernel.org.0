Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9AC643CC4
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 06:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLFFt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 00:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLFFt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 00:49:56 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0611401D
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 21:49:55 -0800 (PST)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B5LWouW015295;
        Mon, 5 Dec 2022 21:49:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=AtOKNdLHpq0Y2KItm12AjHoBmxQI8Hquf5nuxk+KqlM=;
 b=wAwwevoF0NBBsvFYa5HJh/L9bVnmGE7GJKUekxR6/tXqOfsWA+TvujBVLdMalosQ9yf0
 /8Nvx/Cwxcv5qovw9IicN7Mu5n93HVJIRnt/REEgveio2kRU0I0PrqMxX40MzgZBwp4i
 g57wkmSe00sVNWZhJ61ulfMIOTKYkKyf5V+qSYmRMOFVNyxd7NEo1eLZ6ZJxnZ7PuB7D
 DcJJJ0y8dAoPagh5d2ScYkCF+x+Bc66SSApwN3OxIOo8NWsJUU2/fnjBWrtaiwB7078q
 BgXB+aCa89G2qkZIWkM1gbwd6tk6oMhy+jKwt8Z3bn7BFGBAkqxzUsL5dVYYmoY0L8UW RA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3m84ve5whr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Dec 2022 21:49:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGekfEJ+/YpINL/svNuBvz1sW93N3BGosthlapjYOdJxVyjbM33qV3pEvjY420DbR9mUM2Uy0dfd7bIP35XTS68+b3ySiaBIYGLxMtuA9C/llxvwaql8pkwYDFu+gUsafPj5NCKOg6iEMrPSaTRCNSbkd7fbpyVPMuWuA23RyT0NIH7dPKXI0+cDrKwcHyBiLhoPsUuCH7ZkhmV132oC/G44clXadVfaKo5IdBltggXze55QZK2MdiDIPjFIiOvrsHLy/I/RwS387mjY3FwNi57u/V7wPPnT2Wi8MFhcwsKGthDO4CW0yLTos/+8XjYGtMGKjxzVlR6qU2jqDkQ0Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtOKNdLHpq0Y2KItm12AjHoBmxQI8Hquf5nuxk+KqlM=;
 b=jbnSyy+o+svZ8UjoiRklz5alr0uclRYF3Bp7beyYguUBiThJV5bjhs8HJb8hJVG0TOEi0wAOuoNeyjjANR4/nj9q6aHroxzhRBdn05Z7BYe8o2Uc5thSL6Ni9+UxmroPhJ8UfnzM5559ha57ygrKal2pPmwAWB0S/3F0np4iU5CmQd0+5Iw4xKEJ59myOp6EUnP98ZGxfcsTJvSF8GxV2WUYajTitJRikiczfpVc5YhFjzG+s4j4vaRcrT+OJ2jspezODhruVpxaukrv56a0xTVHvnbCbYQHLB4Be3UnPoWzWhyDUWWhXhMnhgzyAWiDod2eyZXYf93MJ+DA1JhW2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtOKNdLHpq0Y2KItm12AjHoBmxQI8Hquf5nuxk+KqlM=;
 b=sM12e3mAqMVV+BLrMtFSNkgBoGFZB3HHlyA1HHpPHFv3A/fs59j69dZik2WEY6RgL5W3/Z71jTkWwOaQ70EFYlhvZJWQGobpdYdYpGgDLwYUHzW/ZFHlpnrQcdjP4jnkE5/th2rkZL8DQxuYjfe11J+gvMK9ZRNBvOMXgNHclL/ZlQwiyMvHj9QIuAE5IzKRscHZdnG215n37XmOUd0Ccya0/+Os1vDMBXyqeB8C505UkdLZL7aqStdBEFLaC+Z72ZdjRXSspzC9IAzK3kUeRTMc+AVMusfkTdlEpjhAup8NdiVig3XetD+Oclx7604Qv+AjzAN9TDp12HOy4NoxUA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA2PR02MB7817.namprd02.prod.outlook.com (2603:10b6:806:134::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 05:49:02 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%6]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 05:49:02 +0000
Message-ID: <0cde1cb7-7fce-c443-760c-2bb244e813fe@nutanix.com>
Date:   Tue, 6 Dec 2022 11:18:52 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH 0/1] QEMU: Dirty quota-based throttling of vcpus
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>
References: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0047.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::18) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA2PR02MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: c68af669-a95a-42f5-3041-08dad74d93a1
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lx3SwjzBaIw6n4WITTgTLpKyqvjoI0DuhYffSwTtdfZoabenAzJ5XTe+JA1raC9so6+F2wh3lS7JzIG2VDWSKz6Q2m34A7ogpIp5GqBnEKSQ/2o++nTv8weRWAJDuBz13+LtTP88D0AEFbxw3fnGuzU0BaPmZifGbEZnPHeKS3it2vO5isEOhQu7fZQlapwqQCa7+PxkWlnOAn0dpN8yueIOlp6Za6PdhqwZw4uNMODy6SS6pT5ukOjwOqHanY9dEWapqRHbq/9g9ogVyoLxbO1g9MLumRuhJpyCIfVqVatLQpmfEoqJIAjGTd0Ok1p/NpU4TuDnYQTPsXWGsevF0bnygG+f1aTVP207WkmENLheGb+7n8lDY2hp5BcsIoyu4yV92739mnGCzDTFNIZItCsgiHQQ6NyRcR0NdgMThnFAH3YUqflw9ngpv6/TbaNPhob4XH7R5aQrRLn3fw9waT0T2KLVb56vwecRKxzzhAFtckXm6TXVgIyn5CEbiXhknfVJzdL5JG3mAeZTUn7jQaMJPDOWJpLQFyw1iWHi4hBOYOFdoeRvm6TZVm5ETknvSIyyZMN2i6zjHhbSXGltstNEAQLyI7JnTsGJyBhpWDblGvc9PpoxubUOAnTcxGv5FfVPTfWABXB7L6IhTfE2FsnZ6UtdshcI5tYNuepksDClIeqrVdT6yTuG1lxpMThYkN6u9PsVJTcwWTukxzzJh/0VU9k5t9Gzh29WkeL+40su/s9iqRPwrO2glWxh2mJrkxhWmbyw6YaxSZ7iA3syBJqQ8+pSvQgmW9VoOycXHglTEI9whgHOqnUsi64AFj6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199015)(83380400001)(86362001)(31696002)(5660300002)(8936002)(15650500001)(2906002)(4326008)(41300700001)(478600001)(8676002)(26005)(6512007)(186003)(53546011)(6506007)(6666004)(316002)(6916009)(66946007)(2616005)(966005)(6486002)(66476007)(66556008)(38100700002)(31686004)(36756003)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VllFWjYvYVA3bzY3VWZRdEE1VE1mcktBbHAvQ2MzUklManh0ZHpBMG9BekJZ?=
 =?utf-8?B?VmNYN0JYd284VXM0V0VpRW5hRWpKbmtPQkJwZXBLYndLbXlLZ2JsTWZUZWdU?=
 =?utf-8?B?WGxaampsaVZUamo2Y0Q4WEhJWWFWY0huaHBWZXI3TTRzMkx2UDZnRzQwWjJq?=
 =?utf-8?B?azc4RS9rR0tiSk5kby9DdHhPNWlkaXZkZDFIbXlhWXZZbS8zc0JVTEF0SUVX?=
 =?utf-8?B?L3U1a044WmVGWGIrVDVGUHJNbzg1UVhpRDAwbnhmd1BDU2RwTE1hMlhnMXVv?=
 =?utf-8?B?eVN1eW1kTjEzM0IvRmtpT0lNU0lURWhyRVAwSXE2TDRMWUJ3alV6WW40WXFB?=
 =?utf-8?B?azcxS0hhMEs4eCtZL09tSFQ3QjUvajZSQWJZVmFmbUNVZU54T01oUCs3dUNq?=
 =?utf-8?B?amg4NGUyMFJvRnVTc0R6cE1xMi9uSUhDaEFZaVhWL0FwWm5KY0JBcTZFcnVG?=
 =?utf-8?B?eStJQ2ZuNFZSaDcvczJ6eExhanJBK3U5N1BLODRsUFVKM1NlZEtCR0ZaaVZU?=
 =?utf-8?B?bjdWMFZqR05mRnBPTUxKaVJsZHF2M3BzMEJsWGVqTFMzZmpwbzdORnZMNXZZ?=
 =?utf-8?B?VFJLZ291dXBrUlZValgxK2VxUktqUFZURmt5bS8rRWdiRlk4VDd6TWx3L3Ez?=
 =?utf-8?B?WDgydFNvZTR3VGcvUWJzTWVvUEh4eWpUMUpjTWNKU3lWWER1UlRWbnFCVkQ0?=
 =?utf-8?B?ZUE0aldYRnZOazhRazR4dENIblpSTFE0Rkg4RmIzQk44Mkw5a1B4Ykd2bXZs?=
 =?utf-8?B?Q3pveENpcHIxeFd4b2FkUU05RnYrTlBBZW5XSURyV1B6K0hibk1yTGdHSXJ1?=
 =?utf-8?B?SFU2eGZGeFNWbElKK0l2N3lzOHcrUHZ0N2I4UjVzakNYcEZkbjRqQnBPTFVS?=
 =?utf-8?B?QWFlWDZaNHdEbldobE1HcENrY3hSMUgvVjk3R3ZxL1lWaGVMWjR5WXE5ZlJj?=
 =?utf-8?B?NFpqcWJYOWRkM3Nua1k4OXJXU1E3cWx5dng2eGl6TWVQWXNKQzNoZlVsUTkw?=
 =?utf-8?B?a0gzbm5BVXBrZmVXeVEya1JpU3pFNXpLV3hrMm5odU91cWU5dFducHF6WVIr?=
 =?utf-8?B?R0tQTkN4MStvbkw1R1ZrR05xZC9RMWI3R1FJYlZhVHdxMWRaMGFJTS9uMG40?=
 =?utf-8?B?RExPTTRERlFxTDRtN0pzZkIvVkFDMWs4OGNhQ3htanViWmZkYkx5dzlrKzls?=
 =?utf-8?B?eFhjOGQrZVplMm5YRTZrYXErc1FXY3pEdEJaQVZ2UW91YzdZeHo0aXp4UFBa?=
 =?utf-8?B?b2MyTTJqRnR0bGs0TWZoeHJpcjRRam5kaXd1VjRsQ1BCTkxaaUZwS2s4YmNa?=
 =?utf-8?B?WmdHWDJJeWdkRFlpRUlWalV6c2Z6bWRWZUNWZnJsUnFrUm0rVjVmckpDVHov?=
 =?utf-8?B?WTJ1eCtLeURhQmFTSjdEd0xkMjhpUU9tQmRmcmZ6aVNUdEdLRHVSQnViN2JJ?=
 =?utf-8?B?b2xzangvQ2YzbDdONTV1aHhxVldTbnBiZkRLeDdGMzAwa3UwMENpNW5IZS95?=
 =?utf-8?B?bzV1NmhJSGREZkRXY2wvcDQrTzUvNzE5MndXS0hqb0VPRk04MHQzVGpIOVhI?=
 =?utf-8?B?N3JjUlNBT21IaGtMTjZySFpNaURkSHJabUJ1d2hsTmFTQUxLSXo0Q043V1Fl?=
 =?utf-8?B?U0FaWlFLWWVtNVkydUp1ZTdCWU05amlSeWtJbHc1UEVoYm90ZXdPdlVyQmtI?=
 =?utf-8?B?MmozL24vME5hYUlNTGJFd0JJdUMxZ25SYzRML2hoNzBiVzNSZHN0RFdCa0dW?=
 =?utf-8?B?dnU2WDlidmdYZG5zTHFtdGgvbFhvV1NKM1MxQk51eHBycHJOdENYcXZxZTNo?=
 =?utf-8?B?ZGVEeTNlTUwyZm5PZFRtTGVpU0QwSTRjemlmMFNwc29FcWkwZVR6TUtCVHFt?=
 =?utf-8?B?RzA1RXQrZjIvem9FRXcrMGRrNW1GM2tZeWRUN3dUTmIzQW9ZUlROOUNEckY3?=
 =?utf-8?B?Q0xKMEVySlhTQzRVZDRNUTUwaXJFRWMvWXU1bzV1UGNNOXV0YUdkVmhIbm5N?=
 =?utf-8?B?eTlla2E1eHVRQ0Q0RW56V3RheENFKzRYbHB4ZjI2azhOVVc4aGg3QXhEVXQ4?=
 =?utf-8?B?K1lkczJ2cXdzNCtGRXBQZDBoVXY0MlZRcmorL3RnVFlIdlRPK0xVRHhZdURO?=
 =?utf-8?B?Wk1BVUplbkFzMlFNRnRWSCtVSWYwbTNSelU0bUhEWmlxWERnbjlCMXIvTDQ2?=
 =?utf-8?B?bHc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c68af669-a95a-42f5-3041-08dad74d93a1
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 05:49:01.9988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIBhAISUN+Tc95hhshPZ9S3XXBQ/OmfxiYGSTt0+8BKXtlllqkcEMi1DPd9uOHJJaJjRh/T4G26IRkvexNQCG75vPje9ay4lAp+KbMJ+1Lo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7817
X-Proofpoint-GUID: oY094uOLXnzdsGEuPpdxmiaanhTW2YBu
X-Proofpoint-ORIG-GUID: oY094uOLXnzdsGEuPpdxmiaanhTW2YBu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_03,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/11/22 4:24 am, Shivam Kumar wrote:
> This patchset is the QEMU-side implementation of a (new) dirty "quota"
> based throttling algorithm that selectively throttles vCPUs based on their
> individual contribution to overall memory dirtying and also dynamically
> adapts the throttle based on the available network bandwidth.
> 
> Overview
> ----------
> ----------
> 
> To throttle memory dirtying, we propose to set a limit on the number of
> pages a vCPU can dirty in given fixed microscopic size time intervals. This
> limit depends on the network throughput calculated over the last few
> intervals so as to throttle the vCPUs based on available network bandwidth.
> We are referring to this limit as the "dirty quota" of a vCPU and
> the fixed size intervals as the "dirty quota intervals".
> 
> One possible approach to distributing the overall scope of dirtying for a
> dirty quota interval is to equally distribute it among all the vCPUs. This
> approach to the distribution doesn't make sense if the distribution of
> workloads among vCPUs is skewed. So, to counter such skewed cases, we
> propose that if any vCPU doesn't need its quota for any given dirty
> quota interval, we add this quota to a common pool. This common pool (or
> "common quota") can be consumed on a first come first serve basis
> by all vCPUs in the upcoming dirty quota intervals.
> 
> 
> Design
> ----------
> ----------
> 
> Userspace                                 KVM
> 
> [At the start of dirty logging]
> Initialize dirty quota to some
> non-zero value for each vcpu.    ----->   [When dirty logging starts]
>                                            Start incrementing dirty count
>                                            for every dirty by the vcpu.
> 
>                                            [Dirty count equals/exceeds
>                                            dirty quota]
> If the vcpu has already claimed  <-----   Exit to userspace.
> its quota for the current dirty
> quota interval:
> 
>          1) If common quota is
>          available, give the vcpu
>          its quota from common pool.
> 
>          2) Else sleep the vcpu until
>          the next interval starts.
> 
> Give the vcpu its share for the
> current(fresh) dirty quota       ----->  Continue dirtying with the newly
> interval.                                received quota.
> 
> [At the end of dirty logging]
> Set dirty quota back to zero
> for every vcpu.                 ----->   Throttling disabled.
> 
> 
> References
> ----------
> ----------
> 
> KVM Forum Talk: https://www.youtube.com/watch?v=ZBkkJf78zFA
> Kernel Patchset:
> https://lore.kernel.org/all/20221113170507.208810-1-shivam.kumar1@nutanix.com/
> 
> 
> Note
> ----------
> ----------
> 
> We understand that there is a good scope of improvement in the current
> implementation. Here is a list of things we are working on:
> 1) Adding dirty quota as a migration capability so that it can be toggled
> through QMP command.
> 2) Adding support for throttling guest DMAs.
> 3) Not enabling dirty quota for the first migration iteration.
> 4) Falling back to current auto-converge based throttling in cases where dirty
> quota throttling can overthrottle.
> 
> Please stay tuned for the next patchset.
> 
> Shivam Kumar (1):
>    Dirty quota-based throttling of vcpus
> 
>   accel/kvm/kvm-all.c       | 91 +++++++++++++++++++++++++++++++++++++++
>   include/exec/memory.h     |  3 ++
>   include/hw/core/cpu.h     |  5 +++
>   include/sysemu/kvm_int.h  |  1 +
>   linux-headers/linux/kvm.h |  9 ++++
>   migration/migration.c     | 22 ++++++++++
>   migration/migration.h     | 31 +++++++++++++
>   softmmu/memory.c          | 64 +++++++++++++++++++++++++++
>   8 files changed, 226 insertions(+)
> 

It'd be great if I could get some more feedback before I send v2. Thanks.

CC: Peter Xu, Juan Quintela

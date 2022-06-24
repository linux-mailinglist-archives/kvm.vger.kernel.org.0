Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284A85599AD
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 14:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiFXMa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 08:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiFXMaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 08:30:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669814B431;
        Fri, 24 Jun 2022 05:30:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5opBQIEQWT5NzAbPgx9XrIVQrj7n1YqDbRaVrRo5n8SO+HEW2xyi545hCwnUh0dxyOPzlXAU9D1fOUrL9RkUHIpFWwSkNNy/Qg/hTJVvkwgqPWL6obU3x5FOk9ueRDXclaN6DYfDI8HSC3JPxLAgztUSFxQSmj57ppDfM5d0y8DwRgozuO5+yu0krn5+G/IFykDMwMv2VU22NBla5DU5XRWdnwuyGUWUWtoApCrhErajMR3zZOmzSmtMrkOUa1eHOx7ijQzR8RBOFEPOa3CvftBYNTRJwURlyiAP1iCw+m8/2l23fRUXoUkHM+1bmH/0juDtT/D6+M3JIxp89c/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMPmu2Fe6yR94GQqxAO3sebqFZDwqmexU47jHEZ5fnE=;
 b=HRlN16bd7NOB9KMzmDrubngWaD6HR1G74igWEHdLyinzWFnugKPoc7Hr2RnrjUf8EECrDCEgDa2FTHI5DD5JVRUA2YEdf723CTbb6GhynMBpQ94M5IGwybtutT7zNhaq6HH12SDaK37BV7RAuSnlXg//s9SbG/MNaVvIliTw2I8ENuT59Sv8Xer20odmlr8z8POJJJxL0PxUkkRayF0kix27SDgbFYf5R3deCuc594o293TkhrKHKPzk7VqAtLqNlznopchsHFmov48x1fFji0mWR+iaoNQD7t1VbWpmoOnXOwtdtBsrycwy7Fm2NEoN2/MV0rvRU2F6PGSc7yo+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMPmu2Fe6yR94GQqxAO3sebqFZDwqmexU47jHEZ5fnE=;
 b=f/kqVElJdQlCz/N0maM40reFvDbYtUKVjXZnCUjGFu8frY4ixSsVi6ZSJ44JYvI8wev812HNSH5UAPvJIUhnvjzxK2QfW0qmxTqN6xWt3blPGXFQeVeVo8uZf3DJ0Jy4LhIzObNzQKWBY9O8k2O58wWxM7mDYQJ5P/V/b3uXmzqnFHM72K6wPEQxZQOAQXjss082hTwN0JM8YP0V6t7KDSvAanCK/CxBDAO+xGa6so8vmS3bWA2sWkI6aawfyyupXMfY5rgVonNFrYeBhP3lxTI0jYGmszW3JSJrH1JdEamxqIL4s4fLEVNKQh1/iOljI+crNgz12/6XKusn82VVEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by SN6PR12MB2816.namprd12.prod.outlook.com (2603:10b6:805:75::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 12:30:18 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%8]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 12:30:17 +0000
Message-ID: <f152e97f-0d07-e7a5-baea-3ae7de5662cb@nvidia.com>
Date:   Fri, 24 Jun 2022 17:59:58 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-3-hch@lst.de>
 <ab47e216-f027-2083-308b-89c6aaa2e806@nvidia.com>
 <20220623201844.GA48313@nvidia.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220623201844.GA48313@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0174.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::12) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbfefa9c-f6f5-4a93-85e1-08da55dd4bb2
X-MS-TrafficTypeDiagnostic: SN6PR12MB2816:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m5Fejk6YE4IBKYTsI4KPDGeRtJn278CaaYgGD8E6ivY0F1qlfpJJ6bJEEuzsyhM0Sq6rAT+n3KyjTI0nOZUfGE61jVQ3IMwOXoFan7u6RoIJO2NEehEanDG/iycIdUkW0ykbgWMMQTeClxKKZYcA5abpHnoX4lrrOFrjFuyJkNRFMw8CkcI9MQzk+9dYmDNWfU9SXyhWOXRI5prgCQx380sjF7aD4LHoVuhoZA3pKzFurAGrjp1D0joEHXyXGYR9IuHBmLYOS9s5GSFCRd/iZPWe7Np1wiiCAof84fzOpcge6QFyW7YPqDvSB6XindpIkcGnXzJCax7fKrUEc619e6TbRnZZQ4fpOSsQb865d2FRjadNiumuKlT8Dib240CTkAYrheqPRHY51Lr2sMPz6WGBvo9JLPSA+W3Cq/IRW4eFgGr5M3ppEakpNlxTbBh6cXlH3nH+j/1lW0J9SSB+9Dyz8P0rjMrMcuPVHnv+V8yGHWV35N976TQla2ObgEtW3dRLs+t9V0A+r5DrUiNJQigjbpM1q0Lcs3kJkOyos+lo7TLZ2lAekc46oXB9f47eFvFVzFRI9E3k6AMwhm0daS0W/Ha6mXkBOQ/gUDcRd8Lb8KKYuFfnq0nVCH8l5L1HO2U0g/u6A8kq7WGtpYVZ9gYG/cWVn5H3WANMw+ZE0Zz2cVAqijzBR0X6yj5Blzwl8kj7bTwxOFNSH4fj52YF/R2affL0CjHFp82wBEoCQFy46bqoc7itkbtKku/kKOoF8uVZUlM9DoTRFvC7G6LIwLThTpkE9xx2aLc3Zo1oqBjDLrKE6Rzn/WEP8MOUGNjO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(54906003)(316002)(6862004)(478600001)(37006003)(6486002)(31686004)(53546011)(6512007)(8676002)(55236004)(66556008)(6666004)(8936002)(6506007)(6636002)(2906002)(66476007)(5660300002)(66946007)(7416002)(4326008)(26005)(86362001)(36756003)(41300700001)(31696002)(186003)(107886003)(2616005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1ZpTUxzeVJHT0N6RzRDL25ob0sxR0ozd0RPOGRUMkx6V1hjMCtyN1A2dzJ4?=
 =?utf-8?B?b3lpQ21QVFZnOE5mcFVFNW1hTlNpU285cGNsT1NmbUIrMTdLY2tPanR3MWhP?=
 =?utf-8?B?OFB3bTE3anR6RnE4bVR5TEZKeFEvaFZ0cXVQY013ZjVCOGdWNVhFU3ZpL3Zu?=
 =?utf-8?B?U2p2NHZtNTFrMFJFL1V5RjgxaG82ellSbGtVb1psNlozRytKRFZHdS90ckVR?=
 =?utf-8?B?WWRSWGN4cEowZFlWbklKWWVIYlBZK2VTNEdSeUJZSmozbVVkVTBIRXJqQWhI?=
 =?utf-8?B?WkVCTUgzK0t1TzVodktuWnRMZjNGbjdxNGJ0ZUVjalFPSkhvRGVZdThqTURS?=
 =?utf-8?B?U2RucjcvRDNpYWFSUFBUS2xXbWN6RkcwOFBhaE16Zzlnc3ovOFgxcFhuczJj?=
 =?utf-8?B?TDRreVNOeWJPSER1RUliWndBMThGcTFBWnVMZCtQNUNxY0ltZDNSbHZoT1Ar?=
 =?utf-8?B?TjVNeWlHeHZ0MmI4UWtiNmpYOVIrQ09zc3dqejhEakRwVHdKR0ZOZUdoa1VV?=
 =?utf-8?B?RGw1L0lvQ2toUkRhTkk1MTZHYVZQWEZSOTQ4WTUxY1Z3UUVwNFdOdjhJNzNB?=
 =?utf-8?B?S2F4SlVBMkt2Y2xNSGlHdmtLM2cyRVBtVDdhMHlRNi9RSURHSjFQa3h3L2Ru?=
 =?utf-8?B?RWcxMUM0S25UVERLWllCSkgrRHBwei9QM2JURHlLdW9GUUFOZHZUNCtsT2hI?=
 =?utf-8?B?eWJ0UDdQaGRIUmIrTWlFRm9oR29PQmhQN0FrMmw4UTFxSnRPcnlMU1g5WnhN?=
 =?utf-8?B?elFaYzlvT25SS28yamJjZm1XajRsd04yZWpLc1o0ZHkwNWxScTJXSVYwVERI?=
 =?utf-8?B?aTV3MXhOSE9wYk1adldaUGlXZ1huakxFdHBLeEdkVXFtY0ZRZEhwRWNSRmJV?=
 =?utf-8?B?VFExQ1Nqa2o0a1V5TzJndGVnNVVTZjdSMXNjSytjbWdYUXR5UmYxUjFpOFBo?=
 =?utf-8?B?b1hFYXR3RFFWTzJFZ05aMlZVSkloYlh0VXVScmM0UUUxUGwvSzZSVUUvVTMr?=
 =?utf-8?B?Umw1aGRyVkRrYUZ3ZTYxUmhRR01yV3pFbnhWa3hkY09TcS9wYzZOelBQUlRS?=
 =?utf-8?B?U1UzVldqcjRsVnpXTEYyaUtJSWIyekhldktiQnRQcXBxeXlvSkZwVUxkYnBI?=
 =?utf-8?B?NUZoTmt2OFZZUmZqV2JST2Zwb1dWQWdrZWNPS3BXQnhVMEs3aUI5QjJKUTNP?=
 =?utf-8?B?SEVPRXVjL3U2R3hvM1Z0U2JzS2xQQ2IxbHk2Q2ozSzFIcERkREt1L1k0VjRz?=
 =?utf-8?B?em1TT3VqMHFQVFQ4OGRUM294bk5UcjIxSStqR0xqUVdLMjhhaUVteHM2V0xo?=
 =?utf-8?B?b3RNL3NvYy9pSzNpZUs0U3lvaW1wOFg4ZFIwSmRPUysvVU9LT0wyUTFCdEpM?=
 =?utf-8?B?ZlZ5aEVSWkxPR2FoZDFYS1ByVVZUaktBMUN3aGJtbHBORUppemJXWnR4OHhi?=
 =?utf-8?B?RUFmMEhQSmtlOWNUZDBHNkhidk1NTHdYQ2lHdmxxSDZhcmVmdUhjME9kTWRR?=
 =?utf-8?B?dzVxemVSOHN6OXVaRGsybGpBQnNnZWxrNWpFZ1lBWW83TGVSQkkxRUloRlgw?=
 =?utf-8?B?Qkw4MHhpQlI1WFBobVhpZnJ1VU9FRlZyL1JDVkZoTytiQ29uWEoxUDRqcXJO?=
 =?utf-8?B?d05PV0R2V0UzUHBJc2VONU12RUVBdVBQLzZXeHNrWWQzUjRMdDlWeFN6cU1p?=
 =?utf-8?B?RWJsSEs2TE9UTWJqRG9QdU9zU0ltaEpkV3R3WkYwUkthQ2JTUUMvMS9sR240?=
 =?utf-8?B?UVRIcm52N3FJbnFUQ0wxKzZIQzNyOWZwU1VaSWIrZ1VRaWM1ZHZxTTJHdXpj?=
 =?utf-8?B?bUtyQUM2cSt0UEpYYWY1VGx1dE1CczFTTUZQRCtzeXdZVFkrbnlBQ29wNysy?=
 =?utf-8?B?Y3E2c0dmRW5MWEluS2pja21pTG9MaG1ZRlN3V3RKSjFxOTA0UlM2OEY1eU42?=
 =?utf-8?B?LzVocnFaTk01Y0VtU3BEVGVZZlpPaWZDNzZSYjM4VExHc240QjA4eW93RFZm?=
 =?utf-8?B?SkQ2TityTGU5NVJoNUtYTmR0MDNhSVpqNEpDbmxjVEw2RjQwRC9yemFUZnZz?=
 =?utf-8?B?WE1DNHJCMm5WQTBxRkRhNW9iWHEzUG5OZ1ZIbXdKUlF5Wk5rMUVxSHdPTTZp?=
 =?utf-8?Q?N32teUNlZ5RRHEZQtLtLnZgle?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbfefa9c-f6f5-4a93-85e1-08da55dd4bb2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 12:30:17.8094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/gTvejTNvfzWZWoCwX1DR6AqPf4cchhlkNsyDKRbOPQhLOnFnr96SuBEWQwzfRRPeaU4K5dwcn98LG8qG9lIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2816
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/24/2022 1:48 AM, Jason Gunthorpe wrote:
> On Thu, Jun 16, 2022 at 12:59:47AM +0530, Kirti Wankhede wrote:
> 
>>> @@ -110,7 +110,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,
>>>    	type->kobj.kset = parent->mdev_types_kset;
>>>    	type->parent = parent;
>>>    	/* Pairs with the put in mdev_type_release() */
>>> -	mdev_get_parent(parent);
>>> +	get_device(parent->dev);
>>>    	type->type_group_id = type_group_id;
>>>
>>
>> Here device reference is held and release multiple times for each mdev_type.
>> It should be held once from mdev_register_parent() and released from
>> mdev_unregister_parent().
> 
> It doesn't make any sense to put a paired references in the
> register/unregister on the struct device - the caller is already
> required to hold a reference until unregister completes.
>

then this need to be documented in the comment above.


> The reason this is here is because the type->parent is used in a few
> places and is put back in release:
> 
> @@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
> 
>          pr_debug("Releasing group %s\n", kobj->name);
>          /* Pairs with the get in add_mdev_supported_type() */
> -       mdev_put_parent(type->parent);
> +       put_device(type->parent->dev);
>          kfree(type);
>   }
> 
> If this was a simple sysfs kobj with only a show/store we wouldn't
> need to do anything as the natural kobj parentage holds a ref up to
> the struct device - but this kobj is used internally, ie dependent
> from mdev_device_create(), independently of the normal sysfs
> life-cycle so that doesn't protect enough either.
> 


Life span of 'type' is from mdev_register_device to 
mdev_unregister_device. If device/parent is being unregistered then only 
types are removed, so referencing 'type' from mdev_device_create() is 
still safe. Therefore, parent device's reference should be held and 
release from register-unregister call.


Thanks,
Kirti

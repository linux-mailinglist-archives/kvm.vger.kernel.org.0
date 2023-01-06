Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0E36602B2
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbjAFPEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 10:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbjAFPEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 10:04:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1A86087D
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 07:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673017440; x=1704553440;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tLYWRgEr7N2IPU0GqeLahv2vXv3PObPNZeWon9XyWRs=;
  b=EY1tzRXULAGF+IZ75RDPW2EQjz8Z4I2bmnosEvm4du2NkN0KMKagMHwH
   FqXfRT0LywlZCom/1uhm+sNHLSZi/A3cVliPLK1I6GpChppkKzoxY6sFC
   dBsQve/hjAd75XgOHo97s73LiA9fiFhT/39lwZZVb1bFcGkgu674r8rTq
   UNwEeO6/Ajy8QawPSp0qW9X8ar4DS74/B5VkjvS6eEvoNZodsUjc+p3Vq
   UVK6y/O+GkdOQq9DT1iR0QSmtm1bAA0D9JFAf1YHnNdrp2HR7sxcTKixQ
   rNCyEUI6v/1bnydF4f65j8lJPEsPS0PYhKRf0NOEtPnN7w/b7j2c28y9n
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="386943018"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="386943018"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 07:04:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="829925958"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="829925958"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 06 Jan 2023 07:04:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 07:03:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 07:03:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 07:03:59 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 07:03:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDdLQ/HgW2ajcfNEzminonkgPCWve+ddZm2tb9miAwSOSpRS16rwmn6iDDkGzDP4iKqZ4AoiyZhKjxH8miRanlwqRj3I9TQnfmvZe7yVnZasnZDPV1iQXy0UPyXuqVbmo4HXtLSWVuWpweIKeESQ/FnTjv+jvoCn54nJD5HCn9LxTqhnS//t8NAf9G3Q4dvkNZir0+NpqsARMqBkcMPLHFcFbdSj+VcgpuHuuu1Vq1VlV3bl8VFqGLbprLiin94V0jXGqZkX4qN9/wczoGF4brOF1FPBtNIAWud1aCq59/CdI9ZB/jth8jcqqRFtivofi7PF7bmzwSdW4ffazbJ7sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VouFSccWyfmc7gSxAeBT8HSswJPAIOw9eokFUyjKsUA=;
 b=CCPpp9us0Gi0y8PSsxoe7XAyFOeOGAUsn9xL7+MmUzN6zcdoSXgNh0Ht9mUWwR3k0JXMaF2/4criWWH82fZuNn7K29fx4im13tDZADgzyw8VVqm2HrFlcBUyA/C2SBi6PRbeqYchg+MZoIzKsEaWwLIDONUJk1W6XaPgA4LYZDcM4dm9rQZf3UvOTgBfNtjlu/qgE3bKqDM04wGX2/o8JSh7hUaGYTaRcdvra8vt/TbADS9HpnNBH8OGL2W1OI47eNiXqQE3JmBV0aRpOu96WVHpw4WykDlZesyOlOoMvbGigrT4iSOcSnoK7cFvhEzxQapl/J6sQ8MoUww+mvsxyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7605.namprd11.prod.outlook.com (2603:10b6:510:277::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 15:03:56 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 15:03:56 +0000
Message-ID: <17e6b31c-1149-018b-e76f-f3c82e702144@intel.com>
Date:   Fri, 6 Jan 2023 23:04:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <cohuck@redhat.com>, <eric.auger@redhat.com>,
        <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
        <mjrosato@linux.ibm.com>, <chao.p.peng@linux.intel.com>,
        <yi.y.sun@linux.intel.com>, <peterx@redhat.com>,
        <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-6-yi.l.liu@intel.com> <Y7gxC/am09Cr885J@nvidia.com>
 <6af126f0-8344-f03a-6a45-9cdd877e4bcd@intel.com>
 <Y7g2WhrDFHpPPsaH@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y7g2WhrDFHpPPsaH@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::18) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: d0e32830-f2fa-409e-6e6a-08daeff73b40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OD2NYqJfiQYbzIFudjGmth1ZS8HWd78GHyMDDqHoMEv0T/3rLl5RTX6NTY6SwlwdO+7K0NwwndlkZdKnqBQw6CR5eZIimdeljuaZ7mEVrel8UgbzzvBnQYKWCtjiFn1mqpf9sgLPAD2IT1G62ix9XbxYZwjaJTtWNnPUTOeEEqVfkeh4y1q5KUbkaZrN1nIb/Bs49JLTTnZwBnM6iokZlxfKBAIceg1ZVSHtZ8kFTxZdo2Jp/2GipAfcngeKO8Fa4/Q9ZD88grurwqAjyPZqdjAB1ZSTDvngkV+vrmu7Wn9J+/YasmJQ7KVS4i3QlYvhaWhj891E+aUghVAh7g5bTirXL6n5AV27I6gyL8gsD66sDIEjsvt0/qTIjzK5tHUjYouJy4U3Qy9LY0wlJ9v8AEV72KPwb4eTzXvLSGSGpyl7B7ijvHOcO1gzX5ubGYWT5F7gl7ZO8PA2RC8XAqg15qs01LuvJidnuCzoRHdXIEOX84sP4vRB0fKkN4yyy7V9Az3+spF9tGu0h2/oYgzxwPr8DC2U3ZH/YOE2G/gQmsmrbh5iYAt3KkfB3S8Ss/YX6IwQO3pTPenDY2ISaapXGoL/+QmyDbZImdDZYd/eqdjgfK5GhifUJBEyTipJDzYk4J5W0ETpf3TOua9kS39J4xl3RrshPKw75GfAmykjoEb3BZ8QTzQlq85Gjll1tPQgppuwBqgkoDRgMU+lrfzoas/T0iuodcYNfjbS/k82TQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199015)(8676002)(36756003)(82960400001)(8936002)(2906002)(5660300002)(7416002)(38100700002)(83380400001)(31696002)(86362001)(41300700001)(6916009)(31686004)(66946007)(6486002)(66556008)(478600001)(6666004)(4326008)(6506007)(6512007)(186003)(66476007)(26005)(2616005)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0Q5cmxmR0xvcWdQZFU1MktqNm1BYzJWQWQxNUlMVUdCbnRLdGhqM2xLL1hm?=
 =?utf-8?B?OVlxemVEVU1oQlJLRWRONkZySDY4L216OUxMM3hmQnlhQmgvZzZKdVhKbzdM?=
 =?utf-8?B?SzF1YzVrMjRsUVlXakZaNmJsUW9OeGxSNWdFMkMybDBFeDZBMjBCSEFhTXZL?=
 =?utf-8?B?ZERqNk4wNFVxKzE3MXVsSnVtZ0p5QzVKWG5FZE9QRnNJSkRhQ1QvOFFQNDcv?=
 =?utf-8?B?bDB0WXE4NUdyUVhLRXR4K1hvUTkwV3o1V0M1RVhYY3BVQ0UwMGlZcUh0MXds?=
 =?utf-8?B?ZUFIakk0SGtWRlRDQm1SSFExTHJQMnFPajhPQWlEUFhzTkRXdFR4QmNjQVlP?=
 =?utf-8?B?dyswNEw0L2JsTTZRaVBlekZFMEkrYzlpZlNINXBuSE9sNmhrbnVkRUNCRDRT?=
 =?utf-8?B?ZmhaRzkrbFgrcWttT3pGa2cyZTlvd01RY2c1QXE4N1p0b050U1dRMU45dmFm?=
 =?utf-8?B?Nkh6WGFka0ZHd1JIZXFsZVl6bzFsTGx2cVllT0kxcWROTGV6ejBWblZEejdp?=
 =?utf-8?B?RUMxQkVWdjk0Q09ycGphS1Fhb1pVejVmM1FvSjhpSW8wTS9vQ0dZVm5lTVcw?=
 =?utf-8?B?Z0RGVWNRNm52Z2hEWFlFQ2pRT1B5U0M4ayt4a3FPZk1LQjFvVzZ4VGp2SU91?=
 =?utf-8?B?ZFVvbWErQjRZeUlqQ2RzZFQ3TFZ4aEh2SDhYbWlyZ2VyajVTNGFtZHYvbmlZ?=
 =?utf-8?B?d3VqQlhiTFVDT1ZRYVhFWXNYYTUxVUphWGlxTjJ4cXNyaEYrMVAwRkI1V3N2?=
 =?utf-8?B?azRZbHhiV3ZQME5ld3ZNREQxRVF5Vy96UXZlUEZVWFVkQ1FBY3BmQkVGazBD?=
 =?utf-8?B?cUc4ZjlrZVhpVzFzUHZ4M0ZzVkZrbDZLM2ZwZC9pSzEvdFdNNEhIUXRiS3Ri?=
 =?utf-8?B?d2ZCN2M4OUNJTG9PMWdyNVQ5N1J1Um1KcXZsQTR4YlJSeTB3SVFpK3pnWEdD?=
 =?utf-8?B?UC8xeDdOdnpDbm4rTlZhY2pVNUx1R2xkOEIvb2xveU03QS9FMlU4c3VTTjAx?=
 =?utf-8?B?UnBkVHhtRytlNnQwYnNweGs1RGJwNWZzZXNYUEpScXptL0pRUk5TaTBXOGpN?=
 =?utf-8?B?VDJYdWdpQVZ3eW1rV0d6MXJtaE5YZ1BFYTNNSlBHTmJLT2VZdUhoeE81SFBi?=
 =?utf-8?B?VFNqQ2JwRGozU3ZCR1E2aGdhMXh1RDVtZ0txNUNYRDhuOGlIcENQc1dXeE9s?=
 =?utf-8?B?UjhTWXphVzhhL1dFdGtkSXFkOVlTNG9CV2dVS2dvSXhHTTArUW9lS1k2Q1U1?=
 =?utf-8?B?ck96T0VxQ0g5NFF0dnBvNm45VG9kWHRiZ0VBTlNBVGVSR212aFo4MzZKNmFy?=
 =?utf-8?B?UnhuTm5KL2Nob3pUanUya3N5NjdnL2NGUytFZHRYM0pFRm5lZGdnb1Q5RzFR?=
 =?utf-8?B?cXREWnhHNnVUN1ZYVUZYQ29odU14RDYrTldMWkZuTGVhanFoZEZ0Q2pMeDRi?=
 =?utf-8?B?NUd0WGc5THVxNnI5OWthRmtlQVJBS2g4SlpYTG9XSUUrR0wzWXJKaDhZRUoy?=
 =?utf-8?B?MG9rU2ZqODdIaVB0azM4Tlg4Vm9NSk1LcXY5d3NCU0tNcVFOTVNERGxMcTJa?=
 =?utf-8?B?cDVHUTJ0cHRpQnBiS3J5U2tEME16dXlGSE9ibGEzMHpkUTBpU04yRUVRWDd2?=
 =?utf-8?B?WVYwb3JHaWQxNVNxREhEZjJnb3dSRGlmNGhsYm5lSzRwMTZFRzNzWElRcTht?=
 =?utf-8?B?UXdrWXRQRm0xY2t4K0trdTd5VnphKytlR2I5OHhDMWdjSWRKUnNFL01raFpI?=
 =?utf-8?B?MkljenRRbHNUOVdySUtvREdZS05LbnFOYUlnSUdqZjNXS1hKWEdzalN5ZUgz?=
 =?utf-8?B?VUxQZ0lSZmVXcGRkVGNIU05JK284RWpJMzI0cUdhem8ycWNzVE5aUklad1ht?=
 =?utf-8?B?LythZkRoTncyRTFzb3Z5ZHl5Y3Q3V0RlRi9PRitGV1l0RGgwMmlNV2ZSL1dj?=
 =?utf-8?B?Y1RhY2lHbE5IUG5mWGM5YzRTdGxMQUJzU2w4d2x2S3BZYVFjTFkvWUljWWtx?=
 =?utf-8?B?aCtyM0VXdmFHK1dLcWk0c1N5bHd5S2RHZWZ5T25KWDI5ZlRsOWd2c3hOdExu?=
 =?utf-8?B?WDN3SGtVNkxWQXNXWXkwbyt3emtwVmhoK3VZN1dGTGdXSGRWKytwMjc2ejNR?=
 =?utf-8?Q?wyp1zl5R3Y4VqjiS0I5qmek9Y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0e32830-f2fa-409e-6e6a-08daeff73b40
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 15:03:55.9509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sY3j4YAYhw+mZqEETGbffW3FHU5HsjyyB+p/WUHmj9v/N/DH2Ex72b743lgZsjULHi24J1DEdDAL/92XAnqzpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7605
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/1/6 22:55, Jason Gunthorpe wrote:
> On Fri, Jan 06, 2023 at 10:46:56PM +0800, Yi Liu wrote:
>> On 2023/1/6 22:32, Jason Gunthorpe wrote:
>>> On Mon, Dec 19, 2022 at 12:47:11AM -0800, Yi Liu wrote:
>>>> This defines KVM_DEV_VFIO_FILE* and make alias with KVM_DEV_VFIO_GROUP*.
>>>> Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
>>>
>>> Do we have a circular refcount problem with this plan?
>>>
>>> The kvm will hold a ref on the vfio device struct file
>>>
>>> Once the vfio device struct file reaches open_device we will hold a
>>> ref on the kvm
>>>
>>> At this point if both kvm and vfio device FDs are closed will the
>>> kernel clean it up or does it leak because they both ref each other?
>>
>> looks to be a circular. In my past test, seems no apparent issue. But
>> I'll do a test to confirm it. If this is a problem, it should be an
>> existing issue. right? Should have same issue with group file.
> 
> The group is probably fine since the device struct file will not have
> any reference it will close which will release the kvm and then the
> group.

you are right.

> 
>>> Please test to confirm..
>>
>> will do.
> 
> Probably kvm needs to put back the VFIO file reference when its own
> struct file closes, not when when the kvm->users_count reaches 0.

yes. Seems no need to hold device file reference until las kvm->user_count.
At least no such need per my understanding.

> 
> This will allow the VFIO device file to close and drop the users_count

yeah. It's interesting I haven't hit real problem so far. But this does
look to be a circular. When I ctrl+c to kill qemu, I can boot qemu again
with the same device assigned. anyhow, let me add some prtink to check
it. thanks for the catch.

-- 
Regards,
Yi Liu

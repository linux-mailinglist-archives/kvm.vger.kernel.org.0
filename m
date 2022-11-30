Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6768663CF98
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 08:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbiK3HJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 02:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiK3HJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 02:09:24 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0087D25C5A
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 23:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669792163; x=1701328163;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tlbwFGnZjll72wPDyVC6gclw1AofVnI/4u3Ivl8lMpA=;
  b=iYOYz6M9C96A2vBD1NweoHZhue0DhXNiLit4rj92nw3uXjnjLSbe/Kid
   vmDy50sH4OrRB6a5KIdmv1me9HBaxyWjN1vbn2e1UD0BFJqmAKdeO1ASH
   N/cKdWdgFgqRgt1iMWc6G6IfsiN2zeZcaM90DTVt28dppjctKcQcQZ0Dr
   /puunHUEHRyvvOz5uqjtxrXvwY8IFm6LCh1yuLgvZWsCX9ng6XJ+DsKD3
   lEv8z89+tGnyjxnmJeEiToIUlNUCb+m0b243jpwOiQZ6zyYf0pBs1wuzf
   HtwcWB0swZckey+T7NDxT+JuQjmWJt8PkKxLori1DuEquh16YQjLUc23B
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="312940987"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="312940987"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 23:09:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="644101627"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="644101627"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 29 Nov 2022 23:09:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 23:09:20 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 23:09:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 23:09:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHv/UfPTTNwejaNbErLyRyDpqghP9RstY+wh8V8nrbuEAxuUiCiI2+j50sOi9j8gDEQZsq8V/InonpR0tK1JisNCIgHcaHFgl1+ZVSRURom/2O2iQfhoUlq5/bhz7my4BP0ujsM35ehsBZ3bOWMU/2ETq+4i4bBU9XzxbmvYTLLlW08rpNKiuxUN23ld8TFSOIUY+mHn5LnEz0sd96LOv/KYXUNHFra4LFnOGAlz9dzz8opR3H4FA5oQ6buwCH8bTKQRXXoOOVJ12mPViZ+TKiV0NzWth2nlyqqt0TvjKVVStYO3ievTKSpwKORxil6Trihm0QcGO711kKffC9cMyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MXy4skneOsKfrinVaAmBvrcK2Jj7AeAYwUGAj0MOtmA=;
 b=CPqUk/w0uJYt7R9kO+pBE7fG1BtbEqwrS4AL0HtrxBiCXKc7bgW9wM0evn0nDEBTQPhxcxRL/k6TVgvInnMJcOhOJudAV62os5VAe6oUq7p0kXt4cJ5ZHk3oDbqQv1R5y40y21CrCRD9Kp3hADXDAT6h01UCdQ5+F/jmcJNEOe9e1vfC1a4EndMU+nrEmBU4srDEgdCPxdXMqtqHiFGP3vrpa3AppAhe1IhY5axMldg/6xPrK5JPfGKAMnApdqzx+X3h1TX+wqgqhK0HgeH7gtgIA/6Y7CHM2b/9lzZijH87IrfLmnWyUrCdXMK2CwgfV5RiQtI1uRWpJtSjdLfEAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB5086.namprd11.prod.outlook.com (2603:10b6:a03:2d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 07:09:19 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 07:09:19 +0000
Message-ID: <3b31c2ed-8a06-316f-0b9f-ac8ce6dd8f31@intel.com>
Date:   Wed, 30 Nov 2022 15:09:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 03/11] vfio: Set device->group in helper function
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-4-yi.l.liu@intel.com>
 <BN9PR11MB52768F967E34C3BE70AA0FCD8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4e180f29-206d-8f7c-cc20-e3572d949811@intel.com>
 <BL1PR11MB5271B4790C8C90FDFF813DF08C129@BL1PR11MB5271.namprd11.prod.outlook.com>
 <Y4YIwH5TT88D3vIQ@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y4YIwH5TT88D3vIQ@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b5d542-e032-4001-47dc-08dad2a1cbde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8j51f46F2HBP1bAIlIsgxztODl4h11qJJQ7dTNTPoozM0U/NB+bdnDn+mYpbbTwQpejV9qXCv3iINuNrgMeRAnU5kqQwHudGPgzzxpewZjQmgwGgsMUDQzWDuSXceLil9u2mbg0HgUfKPkDDvx6pGW3Aug0LTB3jbdbKL9RrFAwodbLxiLQ9cND9Ttky9uZbHh1TQ1ntNGoZOW0Pbfe4Z4+MBj0YT6kkYbIunmhxQ0v3QzErgrIx6ogUl+HP9o8cyU3/bywxw+6ULYP0bN7wwqSFMD1JYv01vQiVhlhbopYh2CnoJgMhUkANsgsgd3WVD9MZYxGQHPgnJ2FGIdgyPX3KP2MsPVHellmZEetidz0KRo8uPNVTvllnoZp/JDLk4oPKVYbOu3OQu8Eh4Q10X4HQTAyjZpQoq2ytEtj+0sBV7B8/EyaK69DckLC5UTCNLp2Y1RN5jQtPjCQ1CwBKNR+ktZvcN6qgoSk5CJPcsq7iOGj5B7zMMzwm83+qKQUHwb9FffotglYRsKJAFOZE7v+kvIguVVFNWmzYwIr35WLiLPeg9Dxr+k6uYjBoMtuRcu3qSUXUDpkiybUJOGzZYa8C3q73FF2quvfgiACXQx1fOWFP2EeqtTZF2GSx+crfhKu4gxJL3M1Fe4J5i53h+aysmKNEPmrtQ7rtVdac+/jWeHkDv2pCE+9Y51tzOliF68KnjxZZThJPKeJVdKZnSHuh80dUrGGHK/JwQsmrfMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199015)(2616005)(186003)(31686004)(6486002)(316002)(6636002)(54906003)(82960400001)(86362001)(36756003)(31696002)(110136005)(38100700002)(6666004)(53546011)(6506007)(26005)(6512007)(478600001)(8936002)(66476007)(8676002)(2906002)(41300700001)(66556008)(4326008)(5660300002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE5HczVZdmI0R1dqMDUyWDhscVpoaU53b01RNWtUejZLT3Njb2kyTUs4NzRk?=
 =?utf-8?B?MHNXNlRYeUZRWVdWdll4eEt0NklJZDQ3QkduMUhndHp0OWdJcWJtOGFnbmxH?=
 =?utf-8?B?RlRjbzZjOXVqR3Nlb0FHcVQ0M3hSTUhsUE12TWtTUldHL1A3S0d0TVhseHF5?=
 =?utf-8?B?SE1nS0NFdnhOcFhhWDF3S1RDaS82d05YUWZVa3p0ajU4OVEyak5WZDh1ZTJH?=
 =?utf-8?B?Ry9GNDhqcGh0eDBFZUIwNWtyb3g1bzBxREozK1BHRmwyVkNGYTNGZlI0Sm54?=
 =?utf-8?B?d1BTYk9ZbjNyZ1Rmdmgva3lIblZSbTltSmJxZmVBOGw2a09Bdm12NjlHcXBU?=
 =?utf-8?B?WnIwVjdCZ245U3hEdlhONGhIVXUweXAreXlZd3U5UDZSSkh0RldoMHdubmFP?=
 =?utf-8?B?TzZuSGliSjBDYTdqRVgya1ZERXZyUEFqN0lsSGJRTlc1RUxTOTRvRnM0ZHpn?=
 =?utf-8?B?dGZCMkMxWWk5ZFNVR2F0WFAyandiUG1rS2tsNW5Ub0NhYzR4SWxRK1ZNSUYv?=
 =?utf-8?B?MEV1T3JnNUlzUDNlNUZJbEMrdUp4clJhWVZvTDF3dnplazhDTGV5Z2E4RGd5?=
 =?utf-8?B?QldxM2tTbWtBTkN5QWZZMWM5VGJmMlB0cytmRThsTGYxMzIxTmcxODdHbE0z?=
 =?utf-8?B?MjRCWXpna1ViSnJtVytmTUJTaTRPemdEd0dpYjBwTFFkU1ZrOUJyZkpObGk0?=
 =?utf-8?B?emlwbFJCditZdUNuMkZmYVdwOC9UMmh0ay9RUDRoeURLSWFhMUc4Mk5oRFZS?=
 =?utf-8?B?MzhOMFZqbCtkZHhPSTMwclNxYmJGanBnenlGdWVremxwSHNjU3NBYTB1VUlK?=
 =?utf-8?B?RVpUSkV0Q3NVTFlZdisrV2RTVEJIcEFsL1Z3T3JOTjMxaGwvdUVwRnMyMG5p?=
 =?utf-8?B?T1gyRFVmRnRRNndlWCs4N2RIbm9ic3pPWFhTWU9lc2s5K2JIUWZWczZtWWF3?=
 =?utf-8?B?N01QOWFIMlRSaTQ2eUxvMVFqWUU0U09NUlhqZ1VSYzJKNGRlbjZ0SUxyMEdu?=
 =?utf-8?B?UW5BaDZRbXhHbFNseW5HQ25CbVVyVlFGNWVXL04wZjAxcUp3WmtieDE3dFFO?=
 =?utf-8?B?SjJ1R2RqTndrVHUyUVVTQ0RobnlVOERTb1YzL3ZnZENGOEpMYTZqODYwNmJx?=
 =?utf-8?B?TUY4NWdTak9iN1FReTVrSDhqbmhycENuR2FTR3Fabk9WNnF2UUVodStOOHNl?=
 =?utf-8?B?a09vZ0tkcVgxQ1l1eWtQdEpTNGxtYkYzQi9pVlUwQ1BxT3QzOFo0d1RpTnFU?=
 =?utf-8?B?UTZsQ29MOFdqbDQwdUw0MUZoUktLUkV1b0I0YUFSWURPTStvbjV4LzNWeldC?=
 =?utf-8?B?K3h3TGJHbWJOL2I3VWx4NzN6SU9hKzJHRCtLUWlTQ3ZvaVpFdEdYUFlyQWhZ?=
 =?utf-8?B?bzg0RThHSkU1aFpFdzVDd0g5YnVzSXNWZnpySHl6aExWQmdnbWcxeU9jK1V2?=
 =?utf-8?B?cFBXY1hyRm0za0VSOU05UGxRZ2VRWDVXMDhYQjhSZ2lrdjA3M0tkVUJIUnpv?=
 =?utf-8?B?MGlETDJqNHVBc3Z1bXgzUnVUOTlRNlJsUnhZa1JEeG9kd01jR2oxNDI4YUpj?=
 =?utf-8?B?S2E4OVNuUi9TSnVuNEdESkxvbEpJSkR3bzBpcDNjRzFYNkYzeGxmNDF4RzB5?=
 =?utf-8?B?b0V3dnRGZjFFRzFXY3I1d01RaDdMR3I3ZzlEbG5nL3F1b0kyblhuWnlTSUh0?=
 =?utf-8?B?aEN3RFpyWDBOakhPZFRIVWZ0S3hOcTY0aVZVMEdoVUVMd2FJSnNyUGdMQVlt?=
 =?utf-8?B?Z0t6UVJBSXFqNmdFaXFRK1lKNGU4KzZpWjNqcjJsVmZ4djlYaGJmeDhmdXph?=
 =?utf-8?B?VVhrcjh1Q2U2L2lNcThXdWlpVUpJVTBTSWFxeWN6OExnQ2xSd2tseXpYWTA1?=
 =?utf-8?B?TnZIT0N2N3drbHhDZnNjWVhyclRvRHFXd1lqOW96K0FXaWgzc1RJYkNjQ3lu?=
 =?utf-8?B?R0hhdzNmT0oxbDJ1SExkdXZDdjVEYXlnSU8rOGpRSStVejV0NS8rUEtPSnVF?=
 =?utf-8?B?dXpLK1c5Q1dQTUY1dndxVHNacGQ1QmtqcGhHeitDN0E0cFdKakN3RFg4Um5Y?=
 =?utf-8?B?bFN0NVBjMy9zUUQyUTJPY1R1Vi9LYWVTMjUvSFpIT0V2OHk1cXM0VUJRVjhT?=
 =?utf-8?Q?fruSmNKpTtPYpL3JJObpj0u6T?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b5d542-e032-4001-47dc-08dad2a1cbde
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 07:09:19.1678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuWbE3c8GM9fAEXXVGpvMERxspSnaff1qySCV/XickP+Y+uBhb52baSRZ6FUwDs0/6QxvaW8FvF8h9pSh1AdhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5086
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/29 21:27, Jason Gunthorpe wrote:
> On Tue, Nov 29, 2022 at 02:04:01AM +0000, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Monday, November 28, 2022 5:17 PM
>>>
>>>
>>>>> +static int vfio_device_set_group(struct vfio_device *device,
>>>>> +				 enum vfio_group_type type)
>>>>>    {
>>>>> -	int ret;
>>>>> +	struct vfio_group *group;
>>>>> +
>>>>> +	if (type == VFIO_IOMMU)
>>>>> +		group = vfio_group_find_or_alloc(device->dev);
>>>>> +	else
>>>>> +		group = vfio_noiommu_group_alloc(device->dev, type);
>>>>
>>>> Do we need a WARN_ON(type == VFIO_NO_IOMMU)?
>>>
>>> do you mean a heads-up to user? if so, there is already a warn in
>>> vfio_group_find_or_alloc() and vfio_group_ioctl_get_device_fd()
>>>
>>
>> I meant that VFIO_NO_IOMMU is not expected as a passed in type.
>> It's implicitly handled by vfio_group_find_or_alloc() which calls
>> vfio_noiommu_group_alloc() plus kernel taint.
> 
> The code is simple enough to check the two callers, I don't know if we
> need a WARN_ON - and it isn't actually wrong to call
> vfio_noiommu_group_alloc() for a VFIO_NO_IOMMU..

this function also works if the VFIO_NO_IOMMU is passed in. But no such
usage in the code yet. :-)

-- 
Regards,
Yi Liu

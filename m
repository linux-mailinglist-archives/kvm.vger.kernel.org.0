Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8FA637A6B
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 14:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiKXNtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 08:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiKXNtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 08:49:45 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60A71173C7
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 05:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669297778; x=1700833778;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vpRplNDnjJee/464yv2clkYGxQlZq9FAswOssA5rgvg=;
  b=Da6zf+BhJ9oyJedW/vtYbpJcWzbn4MLg2UL/2exAgXlCBOSypi8ZtbAA
   Z+ceRDLLsns9hsunPnIcLB/MVQ309R6lLwtXGusGfKQQIH+ChGpEkrZei
   rmZj2Fzf0PUfoWRhxzJZvaESh8K5TQwcvZ7t3Eq8P21kvrLG7mqfLrnT+
   Ay72rIFp1237s/eZ9aWoHFDUo0yx6WAEf1ELjp5W5+AFq1PmRNV9VfHuA
   fZmAJeYjOnD7E0dz0qriHaD9EtKEqOmzjV7hYtOuGH5Q+HVBIhYaFZZrL
   ajcW2SWXA8uDRXwbXk3LhlTB6qZYMYYrdWjGJZwv+0pjqkEmWY+oEziZx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313005535"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="313005535"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 05:49:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="731146654"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="731146654"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Nov 2022 05:49:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 05:49:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 05:49:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 05:49:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 05:49:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqIW0wSW9R3GVXmvYaTvdLih1d38OwIxrBRXSFUSHSHpP1d85PqYGRIeo9KJ2RWhKefdlbItVR3kHglcVFOxbmF+80OB7lKAUWWIzuyzBsTTIN+a1KB0eBJlZ0IYFM+opFnX3GLAp0wF5E2imCQbkAcLOvC8FjYzM+P5GsQSQFJW6CGTqfS0uGkkSxDXRoPZZ6LPaWe8cpEo7xl+v68swtg9VEfoqmaMqKNIKWh96YHfVSQxC4jNljyhE33QyGSqPQqfmcwRht2nRzoABXUF50P1fFk5sh2j8imMEfDGuYoBZJyBc1JHqx9FBymypqlxkHHWKfw9KSWiTTJX2YrH1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2l5Oh2LEe+7x7d/HoXf4lBDf4Q7XNsVUyPJn1X1Glzo=;
 b=G1/JN+y+ywPHiVXxPhq/ZDJESpPVtae71PsPCxKffILqOBrgHfYci6BoQaK8igdyhDyqWR17zt0gRKzTTyYk0C9L/60UQQrP90Cn5V0YlCt89WiMAcj6Chh6E9CZ0h75eB5wveT/BO4Z8dtkvcvCwx3S2hF/q2yrKNc86GjYRGETWkk02t7hoGWiGosV4xOABEZkJdI+pZFF5sekKhukfuP1HaTiKcSTM147VOMeyC0yTG5FXsk7HzPtg26NpvO/ZqX1wWl+jQiCmrfG2Zx00O1rT2gNwGbE4e9mAHBC1yNj+t4ptnNivN+edFr4zvmI2nZZ4slwqkwvGbxmY3LCjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5425.namprd11.prod.outlook.com (2603:10b6:610:d0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 13:49:35 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%6]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 13:49:35 +0000
Message-ID: <fcb43043-0547-e368-f8a4-a396bf7c7390@intel.com>
Date:   Thu, 24 Nov 2022 21:50:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 03/11] vfio: Set device->group in helper function
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <nicolinc@nvidia.com>, <yi.y.sun@linux.intel.com>,
        <chao.p.peng@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-4-yi.l.liu@intel.com> <Y39u3446TXjcxkUz@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y39u3446TXjcxkUz@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0156.apcprd04.prod.outlook.com (2603:1096:4::18)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH0PR11MB5425:EE_
X-MS-Office365-Filtering-Correlation-Id: 84bbb533-6030-4373-c973-08dace22b8f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GU94U9bO6E7KYUqDYYaHlU7IP5vkZnzqzahQMXs5XExM83thWV/mhOSw+tZK2qTamCaM9grhom4E6rOnUbvS/bi4RNgHHYeao5NWyPE4vK4C47PnwJEPDUEmy8mBnqIk7Ha/FZ92biGJ/mpr4QYadTzj11qevUmsEw4oQg8v82fG97XuzaHX9HXIQQI04PowwR29Hdv5TcM5Fs+xQ1qfMMb+6I6/nYVszrGt+ikGlFbDKmmaGukLxJ6I5ruZj1UygHxFs0GO7f4c22rAhuiNATMFTwen58v3jfOVOvk82ej3ZBsE2WeeQXwnypZJzPld3KiZv3SDVQMOEcS2m4qB03j3yFlpvFZ3/U8Sa2mEIc7jOx3E++EJGYe9SxFtV8vKTYcWQJrpemA8T340aMXbvMTERLIrI1dxIRpAwYK+amfi8wLdG7kflRBZ3B88b44mq44e8oELC8351G0TEr6Xv1krUMPMxcTWC8n7mAuBhIO4kbNxrTDa+bOu2i7AAzQIqk1i3ngh60S7vs8h+OxHNDdqAifmOww1Dx1PAEUfzzUo40+zxOH/Gx5gJysyUw95iIZPrOydyN8rqMLgaIIftJK5G8A7Xc5+5AWYWg5V+HcHkxcHJUh3avzFMzNs6nxI8Y74m2TL6euAInBCV1tj5CQe/u90SJje53HfczorX8LWuQbw/eW33VV0firrT50NLh++bUZKc3ZiYJeN/kl4lTp8wQjTHB6AmuNivfo+6fw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(316002)(6486002)(36756003)(6916009)(83380400001)(478600001)(6512007)(6666004)(6506007)(31696002)(26005)(53546011)(86362001)(38100700002)(186003)(82960400001)(2616005)(31686004)(5660300002)(41300700001)(8936002)(2906002)(66946007)(8676002)(66556008)(4326008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a214Vldtb1diWnhqTXM1UTArQ09WUkN4VUlRcDJuYUNYRWFCRCtLcmVBYVJH?=
 =?utf-8?B?cVhUaitOYXo2UC9SWllzWEJscVB6QTFqODRVWkFKbFE5bmhjNVVIT0lxcGt4?=
 =?utf-8?B?M1FqdS94Z1ZXdUtZQ3BtWVllNkZSc0hsaWxSak1UelNidFJndzR3bUw4Mi9w?=
 =?utf-8?B?b1VMRkFIYmNsYVI5TkI0Rkh5RmRYODNGNzJGeGhvSEFONzluWWJPcWN2NmlX?=
 =?utf-8?B?c2hKalU2azNFaERkMmtDbFJlRVY3c2NkT1Q3TVFmMW1kMFhoS2VQRmVVVlZs?=
 =?utf-8?B?M1VxYStLODl0QXNhb3o0Ukl3dldKTS9HOTBhQmk5K1BkZlFxcHpEa0RFdFNT?=
 =?utf-8?B?SjU0d3BFRytvVyt4UkcvRmFKWUpFN2kvQ2dIL04xMEFYc1kvTGtUWHFLRjJY?=
 =?utf-8?B?VUQ1Vy9HSU9PcGpTT1ozbUpzdkdHeTA5NERzdlpFNjB5amgxQXJzc1FvQjFD?=
 =?utf-8?B?WXFyVEtGZ2xmQ0tsbXFqMHlEZnl6em1hK2p5K1QzMjhwTXRsRlBHUElvUEho?=
 =?utf-8?B?YVp0QktoRkk3aWZwOVc0Z2RLTHBDZDNvV05HNi9NZFNkQW81MGwzZkdRaEN2?=
 =?utf-8?B?M25Xd1VMeE5UamJ6czRMeDZFZEo0elVmQzVYd1FQajZLb3lqK0pQaWlLc21z?=
 =?utf-8?B?QkIvMlgvYlhyd3lvQVNJcnFVTmJyREF6K2tUSzlKMjYvc1pvUmFFRnB6bS9C?=
 =?utf-8?B?ZHBJSGtTYXFJcUc4TExNNE1BTGg1bkdjUUtBd3RoQTVIVUthQjFtdHhjWjQy?=
 =?utf-8?B?ODVuODBYc05jL2JGSldCeUJNRGs2UjY5TjFBNjJHRjZwbVYvNjJEelJiY1Ez?=
 =?utf-8?B?V3dpOGVoSnJIQU9YVTh2NEFjcHgzdEdKVTRweTlsdFJna1FqS3U3Z0JJQlpZ?=
 =?utf-8?B?alAzNkozUGtOZjFPaWFnaEpkNFFoRitUTWZVclkzeDJwVXlnMEkvMmtZQyt3?=
 =?utf-8?B?ci9EU0kvcERMMkhBYUZ6Rm1LQ1N0K0J4endQV1FJY0NZRXpTRTRIeHduRkJU?=
 =?utf-8?B?ZmRXTkpXRUI1QzRsSllVdVgvc2c2QkVSQ0VZK0J1SlExSXU2eWluYUVoNXRn?=
 =?utf-8?B?dTF3cWw3T3RDb2paMitwaVFsdFVBU2pFWStaTmZqbW9TTjVQQ2RKdWNrZnNS?=
 =?utf-8?B?NGR2d2dOVXNITUp3RUpVVzBoalVmdkpzRWlXQXNUYXpoSzB5Zy9VcmxwK1R4?=
 =?utf-8?B?T0JTR1U1akNMSHVUQkVESEJRcE5oWXZzTWNST0RmdDhwSi9ldERQMXlpWDBq?=
 =?utf-8?B?ZSs4ZC9MOVM2Qkpwc2FvMG9hbEgyeGRQb3pBeVlPTWRSUHl0aEd4RzhNVXZ2?=
 =?utf-8?B?NTJQVGQrREdPMkVCR1lvcUY2SHJpWEt4S2RrTmlsaWtyYXR4b3VXMlpSbUtx?=
 =?utf-8?B?OEQwTEdVVlA4cU1VMGREWm9jVXBwNEpybHZFcmt5eDBGaVhOeVlnZ3lYZlZG?=
 =?utf-8?B?bE1ydFJRWjhydUR0Tm5lNmVZWjV4bXNjaUpSaW83T3ViVldVYXorZU5KS29N?=
 =?utf-8?B?T2U2VjFUSlowcTVJYzBSRkNXbFpOM1FQZ3pJYXFyNmJ5aSt4Q1paNE1zZlBU?=
 =?utf-8?B?YnJtOVB0MVJNZm95YnpPWU1tSUVQdkxSNXV2dGI5amJwSGRNaGJXeHEzMFJG?=
 =?utf-8?B?UEJDNlNnSEdWQUJGTUdOZGljYmJKUkYrdUVNdEVrL1pRSkd5YmxyTnRBb2oy?=
 =?utf-8?B?U3RGdXI4TnpsaFh0bVZLM2EyWlZ6T1FyUkxCUTJDL2V5U2Q1RGlaM0FpOVVh?=
 =?utf-8?B?d3FXTTNlUkY0VGlsMHRiTTRaY2NSbERLZjNKR20vZDZTQ0l3dDJ0eVhVZ1ZB?=
 =?utf-8?B?UnpJTHpGeUhJUGJKQzROVnNFalN0U0plbGlDODdOTWMvUkQ0bVdwcEtEMi9y?=
 =?utf-8?B?dkxKdnduZzUvVG9qUnJhb29uV3M1VDM1UldvUlg5aGV5RlVyY0dRSUV6R3pZ?=
 =?utf-8?B?dVE4bGcrSUpvT1RUdE4wVTk4Q2RBRUhTbExwMUR3R2RXT1pncU8zWXVKOW0z?=
 =?utf-8?B?M3BnY1dOaGxyWmFvSnErVjlhU0NyQnZ2NUZkck1PTlNrdGhWV2I5aDVxWUht?=
 =?utf-8?B?TmZocnpUMzU3OTJvRUVHTTZqYXlLbzh3S05Ta2lJazFoSHQrM0lveS9ESFVT?=
 =?utf-8?Q?dM41m7BUYxtxxhyEScDjrB1we?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bbb533-6030-4373-c973-08dace22b8f9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 13:49:35.7057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fy07GhjrgAAHKoVhV+HyxD2yZBBERyXyvsEheVPTveOa5I/OYOB4yJ/gBhts1QjQAZGsgLRi+4BS4kua70qrkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5425
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/24 21:17, Jason Gunthorpe wrote:
> On Thu, Nov 24, 2022 at 04:26:54AM -0800, Yi Liu wrote:
>> This avoids referencing device->group in __vfio_register_dev()
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/vfio/vfio_main.c | 52 +++++++++++++++++++++++++---------------
>>   1 file changed, 33 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index 7a78256a650e..4980b8acf5d3 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -503,10 +503,15 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>>   	return group;
>>   }
>>   
>> -static int __vfio_register_dev(struct vfio_device *device,
>> -		struct vfio_group *group)
>> +static int vfio_device_set_group(struct vfio_device *device,
>> +				 enum vfio_group_type type)
>>   {
>> -	int ret;
>> +	struct vfio_group *group;
>> +
>> +	if (type == VFIO_IOMMU)
>> +		group = vfio_group_find_or_alloc(device->dev);
>> +	else
>> +		group = vfio_noiommu_group_alloc(device->dev, type);
>>   
>>   	/*
>>   	 * In all cases group is the output of one of the group allocation
> 
> This comment should be deleted

ok.

>> @@ -515,6 +520,16 @@ static int __vfio_register_dev(struct vfio_device *device,
>>   	if (IS_ERR(group))
>>   		return PTR_ERR(group);
>>   
>> +	/* Our reference on group is moved to the device */
>> +	device->group = group;
>> +	return 0;
>> +}
>> +
>> +static int __vfio_register_dev(struct vfio_device *device,
>> +			       enum vfio_group_type type)
>> +{
>> +	int ret;
>> +
>>   	if (WARN_ON(device->ops->bind_iommufd &&
>>   		    (!device->ops->unbind_iommufd ||
>>   		     !device->ops->attach_ioas)))
>> @@ -527,34 +542,33 @@ static int __vfio_register_dev(struct vfio_device *device,
>>   	if (!device->dev_set)
>>   		vfio_assign_device_set(device, device);
>>   
>> -	/* Our reference on group is moved to the device */
>> -	device->group = group;
>> -
>>   	ret = dev_set_name(&device->device, "vfio%d", device->index);
>>   	if (ret)
>> -		goto err_out;
>> +		return ret;
>>   
>> -	ret = device_add(&device->device);
>> +	ret = vfio_device_set_group(device, type);
>>   	if (ret)
>> -		goto err_out;
>> +		return ret;
>> +
>> +	ret = device_add(&device->device);
>> +	if (ret) {
>> +		vfio_device_remove_group(device);
>> +		return ret;
> 
> You could probably keep the goto

after the change, only this branch will use the err_out; may be not 
necessary to use goto. but keep goto may have less changes in patch
file. e.g. I'm ok to keep goto.

@@ -527,12 +542,13 @@ static int __vfio_register_dev(struct vfio_device 
*device,
         if (!device->dev_set)
                 vfio_assign_device_set(device, device);

-       /* Our reference on group is moved to the device */
-       device->group = group;
-
         ret = dev_set_name(&device->device, "vfio%d", device->index);
         if (ret)
-               goto err_out;
+               return ret;
+
+       ret = vfio_device_set_group(device, type);
+       if (ret)
+               return ret;

         ret = device_add(&device->device);
         if (ret)


-- 
Regards,
Yi Liu

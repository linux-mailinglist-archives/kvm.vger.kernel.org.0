Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24755662971
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 16:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjAIPKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 10:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbjAIPKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 10:10:05 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CC51B1EF
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 07:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673277003; x=1704813003;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A1OZgWubTgwVIYnDg9d7g2vJTPjY5cLozSfmGNUH54M=;
  b=fzbVFKNfe6HN9P1i5ZUIy4hrbFJl7aLYCda6wTVScmqM1lT1mIyX1I+h
   ICAbfvujQy1skVwvwxNcLa0yIViisU0PcU7ErtctJEFDW9RM0MmOqYSk9
   HtIf015UgMO8ZQXJGtXhBWf4cwlb0b6QcYss+jBpPchQrYGNrE5dNwDoG
   WMNjvPMAgIDASz8gLeth1W7WvGbVVl+F12orQWd35xqGPBnbXgqhGuipD
   mdKWJwEDqz/fCa7FX7jtLUd4TPjBEKqijr45JlMsHAo4PbJpXWQtrM0uf
   ip+EyzsYs4/WMgL5r2W4WsStr8cz8enoLyLwPTaAktEY+D2dugOl77qoE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="324899293"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324899293"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 07:06:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="985420061"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="985420061"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2023 07:06:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 07:06:24 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 07:06:24 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 07:06:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vm9kaz3vP99vcZE5qKBr1+aiKGuGuyw7KJtsKrJblTyO5YWVq7YwdSDMp4Zhc3rI3wgGjIaWXhO0c1i31iIbAwGwYfsp88L5XD3lFrAIrEt8RJqJjajSqWuHvPMohI2A+Bkhpi1tTRm+X11q0ZdTZliMHTcnX86e0nUIm475cikA95UgP7WRT0e8f2Rygp8roLtwyALP3FJQlNdIEy1adzztTfelGRiqHqZQyAtlQpkZ6bS/83hbQ4A7w9Px1BHi3iXYwq/gYlz29WBsqMLGvVlffG11NvaWegCuwRIFpV/I3ZGekj7X9YL7fpckKbKfldltZj3fPoqlfJX8yrs2tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=druq2UZTNt8xJW4UGasIzBase2KBATEf1PpeGRM4rZ0=;
 b=U/urM6jmawvgNqekK6eJkDG4L8IKudMlIvtn+mgYI8BeIlE3TMb1/g/1Nk5ndyP4jlIFpEjBB6Ds1N1sZrZc8f7C00NXCWk90GIfKdX3i2MVqO8gtns0dT9x8WMAdBm2OUF88oz2Yme2U9Qd/8l8kB2gQYEwlJ6KsPm1TjtUAxbk4wwC8Si3XOGy4jmBT0++FQbJYc+B/vGkY+lhL1NZQG21h2WQ0DsA+Q3wNKmB9YKzb/CHr0hfic8HY9vPn9pahdm2wVP8JuL2af1dUfb7irCQIvAVna6kxNW7AAq71laQKKsaj6+cndxu8SvCG1JQzZl3fzHnwjxRkVfV2rjTwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY5PR11MB6211.namprd11.prod.outlook.com (2603:10b6:930:25::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 15:06:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 15:06:21 +0000
Message-ID: <f7ee1b8d-0aca-d211-b75f-04048bc367a2@intel.com>
Date:   Mon, 9 Jan 2023 23:07:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-12-yi.l.liu@intel.com>
 <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y7whYf5/f1ZRRwK1@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y7whYf5/f1ZRRwK1@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY5PR11MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: ca6fcc07-35fd-46d7-b2f9-08daf2531146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2wi4Jrid5BvgHfvsHz4OdP17Sqh1HueH8pM0X70xeuniuk1hZUl29cY1ayjztNvtAmSDxvanO7Pu3mFgJy+DFmIKaLDj8WiPNx3QleuH6cuB9Zf3K81f6dalaFrO3IhXTMX8Rq5gh5V0eq7PXoB82sHMjdl8pvEpzY25DDqRG5v2R+2cISEF9YJUUhpkL81LECBpDMAWvyZFGq2Z74j0+4951q1F4VGJEo8QYoLLzjmjfWtAAXNt3FfnW+xRlP2aC911/hr20douHrngXc5y+OVhfJZ7hME4C5RJi2l10A8esaO2VZZwedb36y76pLSPbFGWRmr60WKTMqVtxQp8j+irrMVq2/bQTCwAayxFj1GMA2PPwaqOAF7orF55/Ecv6SL/3DRVWQg40euKjv/EH5Ml+jyfnLrRebIMgbobniyqzqDOpoecOuuWxISTqPe7RnEUqlbEYMRjBGb+ahojWUhP3PBEzfwbSUsHnlMC4O2sHUGROJ1UTreuuSd+YvAgTGdYtAXXjm9Ptjl7RuRo3ZDQoJWKqxbKEW7zA8hmDQn29fdivRlMiwmMx+JP9E52f3sO163SmXmZKJjyU9G8g9POD+JLqOHVWai4ldZsRcAOOwQx9e6OLgbvlD6gCCLbLv05QGWboLcDOeNMlx+siies5bmdMShXu+OubXNwPB1GyPjQdMl5hXO6TCsT+z85arcCgGi8BZHvSeD2qgVGCi43StmKs4qv/442E5MMKks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(5660300002)(316002)(7416002)(26005)(186003)(6512007)(6486002)(478600001)(2616005)(31696002)(41300700001)(8676002)(54906003)(110136005)(66946007)(4326008)(66476007)(6636002)(66556008)(83380400001)(8936002)(36756003)(86362001)(53546011)(6666004)(31686004)(6506007)(82960400001)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE1YdTJ6LzB4WUNza1RmZFpMTVAwTmcrdVZzQWNpWlZpTWpSZ2xZdk1DbFJq?=
 =?utf-8?B?TldLZ2dwcnRPaC80empydTZwWE9pYTdSMlVNUERhUHZGN1dNYzRKSHlIdzFa?=
 =?utf-8?B?NllVNE5scjdYN2xWUEt3VEkwa2dGSW56SGwzNDQySXZLWXBoQTZkVFI5SE1m?=
 =?utf-8?B?SEZ1U3ltLzNIRmJaWjZpSHZEMkJRZ2ZrVmRzZlJMK3BEMHg0WkJQOXA4WitP?=
 =?utf-8?B?aWFyTEh6bmMrOW5mL0Y4U2ZvdWg4WWhBTFZ4aVpEYXNZR2xmZHFKN3dwRXNN?=
 =?utf-8?B?cnJ5d3dDcE9sd3NKYklCZk9mc2d2eExWY1hRSGpYTzNEODc4NzZheU9TQ3ZN?=
 =?utf-8?B?czdpYnhsZ1BOTExRVnJBb2I5MjF6M0NmU2dueG1NYTFUNnNuOTN5L1NKTDNG?=
 =?utf-8?B?NzFCNFZVcVAveVJXSTY4OTI2bkZFRGZsbDlpRFFGM2E1TzJYTjlhdlAvd09O?=
 =?utf-8?B?WVlkc3RMMzB3RGlRM0djTzFRNlF5ckRUWGxXeTNZNjR3a2w3S0ZhN3JNS3Fm?=
 =?utf-8?B?Z0huV0U1ZEVCVVU0eFNnN3FTbEFPTzRFNnlWVTMwY1BaSm1Va2Nka251RmFs?=
 =?utf-8?B?TmtCVm9uV1Y3SjVoUS9wVWttVFRlSUhjdURFdHB0NTVYMXlQbXhLclRaNVhL?=
 =?utf-8?B?UlAxVy9UL3VIMGRLTnNLVFQyaWNCcXhOWTdkWmc4MG5Udk5Ed3o0QUpBRVlp?=
 =?utf-8?B?bFFheTFlL0VqZHNubGU1NUtUTklEOGQrb01tVmlwR3N2N2cwYWYrYmhtV2pP?=
 =?utf-8?B?UjJYYlltNnBMZ2gxc2tHU1ppRmxUUG1iNFh1K2dYOUpaaVlQNUQzRlk4QUs2?=
 =?utf-8?B?WDY3UkQ5Mzd1eVEySFRKdDEvNUsxSmRualZYelg1RHNFb3pTV1RNRHpzbm9u?=
 =?utf-8?B?aGZ5Y0JkTVdGbndjWE8rRmNPOXJRSnIyMEtZeVR0NE1VOEYwTkhjeUUyQlUr?=
 =?utf-8?B?SnhNeENYcVQ3d2tpYXlDbSs5RDYxbUdjZGtjZlNOSzN2WlU0bTJFRlJtbk0w?=
 =?utf-8?B?ZUs2U3RJckhIRm5VSW9EYWdsYXFJeFJpWktVYUhaN3JhWjk4dVNRYTdkWUsx?=
 =?utf-8?B?c2NQcEVsWnlZaVZrVUx3ZWFDblR4Vi9jREZCbHRVUVlwQnFVQ1h2SVl2UHNj?=
 =?utf-8?B?VDlKdzFiVTNOMkIyOU92N2xFZmdzczlZQlRHZ1ZzZHZMMEFxVFhyZnc3eU9O?=
 =?utf-8?B?ZHNQbUFvUk94ZEpQK0Qvc0c1Wmx0VjhkYnh0YnVldUFFb1pqM0dRaE9vNU4x?=
 =?utf-8?B?bzZTTzY4ZHFrRU13WC83dVZSNnhNVHlGV1ppYTZseFJ5R1E3aDRqRXk5UjBa?=
 =?utf-8?B?UzIxeEErdHZrT2NyenBYbzdPV0h1alcyeTZwVjkxMUtOSmlBRjJWQjNvU2h6?=
 =?utf-8?B?b2ZROU5KYjMydHlSNTF4d2s0eVhGaHVVTitZY1p6VHI3T3BDNnVyRm5BVHZP?=
 =?utf-8?B?Tm9pTzV2Q1MrNjRXQW5DekZjamJmRVd6MVp2SFgwREtFczcxd2g0NnBLcndT?=
 =?utf-8?B?OGE3Ulk2M3ExNUNpR2FKSFozMlhKcEdpSjZZZVVxU09lZDc1NE00Z3E5b2hQ?=
 =?utf-8?B?aFdSNXNyd1V2ZjBXejFieEkwVUlVaFc5aGk4cGU2TkZiWUowcllLMGcxYll5?=
 =?utf-8?B?Z1lEZU9ERUloNjVQYjZSMFhEbXhiQVhBdm5Zdnl4UnRVSkdmTHBDSGZTYkJt?=
 =?utf-8?B?cUttSy9TTW1tOUh1RVBxbktRWlFJbm5NYzZhQzdzUW9kU1Fzb05zWis0NkNt?=
 =?utf-8?B?SG9MbDFoRDdYNU9kTnc1RnJicHo0NFR0N3ViMGxEM3NVSlFkZDhEYWoyQWV3?=
 =?utf-8?B?aGhPRG9jblBza290Mys3dkxUUFNoZVJFMkswTDVaK2hWdVAwOXFzc0lMOFZx?=
 =?utf-8?B?bm42dFV3S05qdGp5eGhFTnhiUFJiei81NXFxSlI2SkFJZ09NN3ZncW5ORjdY?=
 =?utf-8?B?bjI1RTkwUGZ4UDllNjdOb2pGVFdaVUdEZEl6TFFRQ0JCQ1BnaG1VMmhhTVdF?=
 =?utf-8?B?YUw5Ry9HbmZ5Y0hBbmFJaFRlRWIwaFZqblFCcGRUTmJBNjZldUJ3QVFpdEFL?=
 =?utf-8?B?NWNpZ3JRYlBzWlpzU25GazgvME9tZGZRcTM4Y2pOK3FpRWRoYnFWUXJzaGJQ?=
 =?utf-8?Q?8SBKK1mjBMij1M9PNjxBNWHm9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6fcc07-35fd-46d7-b2f9-08daf2531146
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 15:06:21.3649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5pxTsK5KAu3/S8TO/4Di/yvyqnn1uY/a3TCaK0FvMJU8iUd78zIpTbK5jewKC+m1W6UEaf4pYTf2sJQgLxP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6211
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

On 2023/1/9 22:14, Jason Gunthorpe wrote:
> On Mon, Jan 09, 2023 at 07:47:03AM +0000, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Monday, December 19, 2022 4:47 PM
>>>
>>> @@ -415,7 +416,7 @@ static int vfio_device_first_open(struct
>>> vfio_device_file *df,
>>>   	if (!try_module_get(device->dev->driver->owner))
>>>   		return -ENODEV;
>>>
>>> -	if (iommufd)
>>> +	if (iommufd && !IS_ERR(iommufd))
>>>   		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
>>>   	else
>>>   		ret = vfio_device_group_use_iommu(device);
>>
>> can you elaborate how noiommu actually works in the cdev path?
> 
> I still need someone to test the noiommu iommufd patch with dpdk, I'll
> post it in a minute

I remembered I had mentioned I found one guy to help. But he mentioned
to me he has got some trouble. I think it may be due to environment. Let
me check with him tomorrow about if any update.

> For cdev conversion no-iommu should be triggered by passing in -1 for
> the iommufd file descriptor to indicate there is no translation. Then
> the module parameter and security checks should be done before
> allowing the open to succeed with an identity translation in place.
> 
> There should be a check that there is no iommu driver controlling the
> device as well..

yes. I used ERR_PTR(-EINVAL) as an indicator of noiommu in this patch.
I admit this logic is incorrect. Should be

	if (iommufd) {
		if (IS_ERR(iommufd))
			ret = 0;
   		else
			ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
    	} else {
   		ret = vfio_device_group_use_iommu(device);
	}

-- 
Regards,
Yi Liu

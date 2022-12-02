Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583B064080F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 14:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiLBN5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 08:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiLBN5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 08:57:12 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4516EBD0E7
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 05:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669989431; x=1701525431;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D5YkO9cr3sSUwqPPV22gUqrclD9IvID82IoppEWumrk=;
  b=aSPYrxn4G9TE0EdWPwf+mYjMNGS02IDJNe4aevIae/iplebQmTVCuJtV
   VfQCpznbL2/sTeIM0dc9NuFM8vJA0blD5dK4yWimm4EH5/jgDSeAob6MS
   NjuvNdd1HsYDPiSUZ2ZMyM5P6P+HjCNkAt2hKOrr6k2EoepRMIh6SH2da
   Ip4qSKqHvZMS0OyQUl89YEKfMUefO217kxQzHY2fxIpl0vRmPIj7IklSB
   IlsWQV2uCykYOC35O6pfTnzsP9tkCLBvAzEtKj9HRkMPHCkzdt8ZR4+c6
   ElYew9Xj0QNPSvk+SLCiUyui7Qv37lhMKmTVWxWXjhve9p1sA7kxDc7yB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="314659931"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="314659931"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 05:57:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="819441457"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="819441457"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 02 Dec 2022 05:57:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 05:57:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 05:57:10 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 05:57:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzxeMsfDnMOuU48yvo+DNznyBSA/2bzHj5BCFhDOrHxL/LZ0cVE2EmjjJur0I5/undxljxdv0/db61DaV8JONh5NHZSzyoKDagYISHDsxJgfcQnFNyWuPeKa3J6Wk1uBjIDb2sjsHrZd8C+EI+Vm7id0S0a4C2pVBGdiL3tksKplj/elJ6eDbROHJKyNp6DtMU4GYfzLVV1dZ/oxzqh/K1Ivwj5H0Oz1+tg5Z8CBJEE7ZCuq+JUXliMKLXH0XVOtkxRSciJLMnfAGdjBHrC0gS+DOdUYzWimGsqODvQaNBGN+ETA1V92JP6JPQ+FHR5LU35Eh7WBqNPMc9F/snR8pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5Ldkc8Ml/hO0Hysx5OD0NPCvjduELcI1wn0Z0jdc/Y=;
 b=oGC0TxToEaYzUn8viuWdU1WwV9qTGivqF3Q2+giGzSwuWxhg6DYt+6MQmEEnHrVnUR14KrBtP5cgVRJ+jlHJKto2pSBiwOr0odVIpdAbCVDII9YHKoxq87irgraa4NZJmeq9fpkED8dqmlBYWunmdXFJy6xuDUdDKL8oKV9N/tcN4VGkvQN3j5J2+T1/UqpJr9EV7bvjvipaEf123E9vXvs54OrvvBksHzxLsRBx4uF8FUMuQV4cOUnTeDm2oYSE+a8jdCgvWCk8SWWpMBt39dym75zWBHMApAptz27jhjYAsBBtuK1LhfTfqNbCAoNwJ13axGLvVvm13vgE3KIKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4984.namprd11.prod.outlook.com (2603:10b6:510:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 13:57:07 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%5]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 13:57:06 +0000
Message-ID: <86c4f504-a0b2-969c-c2c6-5fd43deb6627@intel.com>
Date:   Fri, 2 Dec 2022 21:57:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 00/10] Move group specific code into group.c
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <kevin.tian@intel.com>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <Y4kRC0SRD9kpKFWS@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y4kRC0SRD9kpKFWS@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB4984:EE_
X-MS-Office365-Filtering-Correlation-Id: 312c795b-0447-4cc7-e091-08dad46d182a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bK1oND3k5mv831g7Zpn4C8DhvTKAuup4oqwEQ4MAmnC2IoBlYwUl9eJqvBfAWbtexWdvbriwQYd26lF+NK3LzGs8yg/knTQ77Z17XKLQiWy+3YJFnwH+BkFnYJ2L+wVLIc+iIs6VdgVFhx4HvHc1OS9ZQQnTK+AE9p/VH3hntA860+FRJXYlTYeB0myE01F3ecbSCxrpriXbs0J/ruQYzfNzQBSF3l5SvbAfLzifrRUHcaH/K6cKeqzfw4/zE0URyhKm+sDpuc6OAWzSMWDK7/kKEtM2Fz8LXbgPwnyVHPBVthrZuXgkmNZnIOnezu80RB8AympsLqgeC+hjB+HNbJ6+RYIpeb32hXD39Pam9qkOQBYcNFAwL5hwd+3QjvXPNOv016dGf+tnZxMVE+pWv68qc352V9L0lHU/M89fWS6WI9SVtn7iYk04W2H0PWzed/trVr3RXGHTSVtuzYOVXbJjGrYoJkkhONYasHFMsgggHfZq76ugOyuHvjC40lnblBHVDJ4SiBAz3B5QGBHGSrFpZCfQw5RCc/ZPbnUvUb3BB6Gc0/uuyB6UOh2GlzuYYjQzpAeoUIQDu11x0W6Ijpeyw7rJvqVfCwHcZNZY1oFCe4rI9AxG1SSxezTaGKAjthxZkN2gYc9PxFcKxM9PXFVKNANn0vW3h79JMnYzZ2TX4WKm9uS2vPN8IzSO4jSPDvQORTe2xF3BuRPTKvCKjITw1PjjnhURtTY//mCEO96rplzI33qhaqoew/h7/6aWJyOmxRekYSNqqt0gyS8RiAD5IhBD1xBY9HTWoyzXVwk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(316002)(6512007)(26005)(8936002)(2906002)(2616005)(83380400001)(5660300002)(41300700001)(186003)(36756003)(66946007)(66556008)(4326008)(966005)(66476007)(8676002)(31686004)(478600001)(6666004)(86362001)(82960400001)(53546011)(6506007)(6486002)(38100700002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHJaSk1KeU5Dd1BWTHZPTWRUd1R3aGgwNnJ0Tk5MWTFEYVFYcy9NeXRpTnRq?=
 =?utf-8?B?R0o2M0hVM3FHSGc5MzVBaEZEd0FsWm0zQkN2RzByWloxTStqUHlWRjJLa2tZ?=
 =?utf-8?B?cGhLbVFLSEZSZzhsV2o2TlZQNWlJMUtOSGgveFl1QjROM2tUSS8rcnJlRlNV?=
 =?utf-8?B?Y1FGWXJhUDNjblVERTJyOUdSS3gvS29keFkxc0FMc3NvM20yandGVlR0c2dN?=
 =?utf-8?B?bUJJYXhBcUZRTXkrZEZZOXlvb2tTb3lGd1F1R0JNRHIrb3hrYjBUVWdrMWFa?=
 =?utf-8?B?Z1JHSGN2U3pzaEY3MUZiWllPU2NOTEptS09TK21pWndtMUlzaEpvNmlpZDFH?=
 =?utf-8?B?eXdDWTFhVjkzQTBwTEI4MmRKZWpkZmRQa3AxZEUvTjZLSXEyWjV4OFlYNE5Q?=
 =?utf-8?B?RkpPNjhRNzhmQWhyaDVybmp1T2h4b2R4ZTZEc0F3TGVtT1Y0Q0JJb0tOYmY2?=
 =?utf-8?B?V2FsYzJidTZXYjV2cVpYS09uWW9qazZlWStCYS9KZlFDeDNZNFVicjJ0N0Zi?=
 =?utf-8?B?bjdmMFgrVWR4ampqbHJKZUR5SE5uSXIvOEVJZHRUeHlKcG1UaFR0M05yZmdL?=
 =?utf-8?B?N01DRWk3MWRVeWIwUWw2YTJmL3Y0c01jTmNpOFBmRm9HbWpvVHQySmhYMUVh?=
 =?utf-8?B?TGZpcTVoZWtVVm5CTTlRY0hZV0tEUW9jRlh5NHlNRG1TdGYzV09OZlpQbS9W?=
 =?utf-8?B?TllzZXlpYnVWSWppRFZZTmNXcmFVcGVOWUFwc1Fra05GNkZPWXBRV3RyK2c1?=
 =?utf-8?B?ZEd1N2tSRGNSb1hhSlFOSXhRc0h5WXh6OWRuY1JjdFc1Ym50cnBuT1hsS1I0?=
 =?utf-8?B?QjlNQmw2YmxqWUlGbmlWSTNkY1hMUHU2dE9zMmJrMlAyak5EYzZ6a3M0OWlQ?=
 =?utf-8?B?NHlPeVgwenlBVVN3K202a01wMHB0N1laWmIwS0lNZ2tpRm85Vm1wanF3YzhK?=
 =?utf-8?B?eDIyby9rQmVLR0FubitLaVRTTlJKYTA0SnBhb1JiQkxwU3JwNW1MMENpK3dv?=
 =?utf-8?B?bjFNR2FHT3pSYUx5ZDB5TENXU3Z0TG95bXNzbUJqZVcya2U1YU1zZjhXdHBN?=
 =?utf-8?B?L0NyUWI0aERqd0gvenNDa0RYbmI0dGZjU2w0UHZ2Ukh6RmRZakQ2MVQ3YjlE?=
 =?utf-8?B?d1o3eTZIV0ZpYkVqaGo3SlY3NFpvdGtXdzk4V0F4RjZMb1I4NGxKYS9XSVhN?=
 =?utf-8?B?dFBtVkM2RS9IUE1tTWxVM0pjLzdTanZRK1VxMUtFV0dGc01mTmZlMVhWc3ZJ?=
 =?utf-8?B?cTY3azhoSlF5bkpjejExMVZSWFo1enpMUTU3MUNuNVhXZFVJd0NRRE90dnlS?=
 =?utf-8?B?YjJrVGM3TFNWWWVJSDRqWDJTUkJjZUtHN1VmV3BtTmdlTTA0NldkSDJkRGpm?=
 =?utf-8?B?OXJyc3pIZ3dNUzJrVTFuZXI2Y1ZFWjdEdVp5Rmc4RXFxWVpOUktZaldzWUw4?=
 =?utf-8?B?UHlzTndaUUFjZFhJclQxTDNnSUEzWmpaVm9tOG4rT2h4N0NTR3hsS0hGQ1ZY?=
 =?utf-8?B?a0R3Q2xYcHBSU2VzZFZsWUxKb1VseWZBRTd2Q3Q4OWZxWTk0c2JKWEYyWm9w?=
 =?utf-8?B?UC9IcmZNSFA0VXREZXgxd2hXVDhDYUthUktkclQvTkt1UUF5WXpRaVp4SlB1?=
 =?utf-8?B?Q1dwUjNxeTVzMC8zR201dnVPbVFWVTZROHhpeXJXejh4cnlDOVhPVHNEVlFo?=
 =?utf-8?B?d1A0T3hIWVlHNktSbUVBWVdWRWlRTjBVcHVBd1dScS8wKzlhREorc2ZMMmdR?=
 =?utf-8?B?M052N3kxVmRoT2xMS2QvenlDUGcrb1ZzLzNSSHAzQStkUDdFZGc3M2NVblVT?=
 =?utf-8?B?UVNvT2R1K2k3SWJPL2RHNUQwYzFKdlpqbmowdnRPNFNvT2haejRoT2pML2JC?=
 =?utf-8?B?ZEJEWnlGM21LUWc5UWZCTVZsOTQxeXdGRkdQZGJ0R1NYRTAxVHk3T1Q0UWJJ?=
 =?utf-8?B?bUgrTCtvcWp1R2tzb2xzcUNhZUZTTjc2QWZRZ2s3VEZlK3lZRVdBbjJYdHIx?=
 =?utf-8?B?NGwzNklTYmpxQmcvaHBJSkNWZmdFQkRURXR6djdnZm1vRGhBVnFLamE4TlY4?=
 =?utf-8?B?TURnZEUrTEwwZkJvS005aXF3bndjYkZiV2xwV1lJSVEzcGo4ZnBmVVl5ZXRw?=
 =?utf-8?Q?qa2/JN1Us7/PiFPAE5rR8oJJq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 312c795b-0447-4cc7-e091-08dad46d182a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 13:57:06.2560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mCr0IcTNg+lFZ7+ImCvF6SL5u+hEbEbAWUrr6gfTjTZsfh4fVkbP9rGbTdgbzFDAgogbAIVBIKvS2/j2EjOohg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4984
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/2 04:39, Jason Gunthorpe wrote:
> On Thu, Dec 01, 2022 at 06:55:25AM -0800, Yi Liu wrote:
>> With the introduction of iommufd[1], VFIO is towarding to provide device
>> centric uAPI after adapting to iommufd. With this trend, existing VFIO
>> group infrastructure is optional once VFIO converted to device centric.
>>
>> This series moves the group specific code out of vfio_main.c, prepares
>> for compiling group infrastructure out after adding vfio device cdev[2]
>>
>> Complete code in below branch:
>>
>> https://github.com/yiliu1765/iommufd/commits/vfio_group_split_v1
>>
>> This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
>> dma_unmap callback tolerant to unmaps come before device open"[4]
>>
>> [1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
>> [2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
>> [3] https://lore.kernel.org/kvm/0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com/
>> [4] https://lore.kernel.org/kvm/20221129105831.466954-1-yi.l.liu@intel.com/
> 
> This looks good to me, and it applies OK to my branch here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/
> 
> Alex, if you ack this in the next few days I can include it in the
> iommufd PR, otherwise it can go into the vfio tree in January
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 

thanks. btw. I've updated my github to incorporate Kevin's nit and also
r-b from you and Kevin.

-- 
Regards,
Yi Liu

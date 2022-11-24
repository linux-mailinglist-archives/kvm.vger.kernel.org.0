Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB8F6370BA
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 04:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiKXDEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 22:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKXDEn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 22:04:43 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7E8B7396
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 19:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669259082; x=1700795082;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nvbpV0WWe2mRcwL4HGY9LMlFeef/eXxZ9jnrcmRjvdY=;
  b=OtmiVoeZau7CJHx0i+fF3K5VJkXXGCnu/h1y5o7PiYpyF2+9Gc/+t2xg
   Y0bfHspinDCMQH5/liEvLC8r8P0i8/yg59nzP1sBrPjUIOpOWOE14gTCX
   W/LEoI+1VuYOep8gvg6gEwbgtkJgQETuKzUdycxuspcl4V76SkorBmrjw
   tGCu6hbmdLGc2gf9Vj0Ye/KNPg+Vt0z2jLsjgpVvsy7B000tlzRab5TJ5
   /VRxA3YRNBcaJOWAiWxOlhiwVryDRzALQrlrFLz3ySeK5ZsbN9+dDcOh1
   +81DciIplYFBnXZGXp/TbEN76I6W2WFgDQ4cgNdeLRQ/mbfsg7pzMPQWz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="316024773"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="316024773"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 19:04:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="766935740"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="766935740"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 23 Nov 2022 19:04:32 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 19:04:32 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 19:04:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 19:04:32 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 19:04:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnS7CF9Mu7hJYKd+k0nVOWiNr4+gYOO5FSDobbZ6BccSIrU1f6WZ9nuxIyNinBw7dUkS1jbL9HMsmL3Dk/TAjP8DGIJUuKJMkW8NmYo3HXF60UslmVe0iFUMFD2KMl4h00shi61chNbXHUQCkJiINJcSFWCRsh++33UZeTgTVU11Jwb210UCI9gyrhptNfEjL2IZmDsAkVaQAQc2f/Fo/aShjhY7gcH7XbF3a25ZcPp274a/qwLpnwVENMFNtlzMwR4pRucjsXm/vNObPKIenDBTl6XrqiNAN/MRfF+nQRHrpWSZ+hj8F+RtrRG7cL6oQPRB9zbs42zFbfAhOF37Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DnRTdsom3ziAXo2FSYGg6ZK+P0/zcfDa7gwyYc1DAh8=;
 b=PfzAOhPef1mKoehHCdP3x9Pc4OPuHzN6mNh/ms1pPED3bhmwKoVtK1pOv4+wV9NVv5mB9qf1qNJfeld5BUeU0YAKpTS0W4N98jZWY2wzezClo5nI3/Pg3l+9WgVFgGQDLfbYj8aGOjcRovPp1A5auPyBKlJKPwCwRrsTK3qGyQ+bLBzIWsiXnOURL/OLOW3j978ubzOAUEe9lnds+eSzRU//j4oNEB1nZtLYTqq2gpUXUywJqr2CCIqA3GXmkDUfg3I5K/+83MCUqK5fVfctcR/eTwDbHbV6r/u3Xo20hxnrFbmX2CbradYRzKejas+pnW0dVdVVGmmeSEUW0VuA7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5299.namprd11.prod.outlook.com (2603:10b6:610:be::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 03:04:30 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%6]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 03:04:30 +0000
Message-ID: <8b247f62-f41c-2256-9e9b-e2995956481b@intel.com>
Date:   Thu, 24 Nov 2022 11:05:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 09/10] vfio: Refactor dma APIs for emulated devices
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <nicolinc@nvidia.com>, <yi.y.sun@linux.intel.com>,
        <chao.p.peng@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <kvm@vger.kernel.org>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
 <20221123150113.670399-10-yi.l.liu@intel.com> <Y35PjWQbzRy+oMi7@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y35PjWQbzRy+oMi7@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0026.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::13)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH0PR11MB5299:EE_
X-MS-Office365-Filtering-Correlation-Id: b0483851-1acb-4340-797f-08dacdc89aa2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5i/PV49ksYBvea42DU63+gB5dHz33NQVWumyxCg2DHG62NMnf6SPM2/Bsa0pETyVg+qUierl/mrA274TiUjCD1hMWPuh6Hudx0tWU9zgug2pjM32t0iTKcFW5o9iR3fR6tV60iQwue/tCxD1HHNwK4iuFhY1CDjiy0aGfntVh8TFL9aVx8zbCdbp/wSJ9UpcEL+vZe3qbgWEvFGQOpd/SpB2cBXy+PB9y3PhRmQJL9kT/w8qBUJeO8VObjPLQeik+1tv8PDeksLPntRwkkWIWXGrIMEefq2r7D2deMyb6RcR53UIgfw61I8Pi+Mx5GejHQg56j0l984kaJ7ImN9/PlKRI8bbwRBHjU4E6YL7JIoqhVbs0YkEIYe0tyxr+lyM3URqadA2MBMzQ1oK+TBH1/Z7X6zaKXc2dN5dyEEKtq/A5UBuSxdYv5ojzIKkXPY+gtjNcIWIVub2+Eth+9CVAJC2/pLHj5cREiU3p+kqfPaKA9IhkGy9C3J+Ij3PWKGILNqxEekB/QpfALm9VlXZsn1QOSR/TzIgZysAmGK82P48MfSHkJVLdpPqGFeG/lbo7SS+eAmRRS4a63YM096NUDJBN9T38hIYBkZmKZRHA20KcxxwMe9k0k1VZP+Y8RQkLd6LPTk3wCMclBF+8DUjJMaQfYNSnrqIIxUVT6mjixDbIEiPPsfDxLCzZQ8xkRprQ7sTb6Jtna0S4Ua1G2sml+NpeN8piyY9HPOV1l1+1q8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199015)(36756003)(86362001)(31696002)(6486002)(6916009)(6506007)(6666004)(6512007)(26005)(53546011)(478600001)(5660300002)(8936002)(41300700001)(4326008)(316002)(66946007)(66556008)(66476007)(8676002)(2906002)(38100700002)(82960400001)(186003)(2616005)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MC84ejZxZ29rK2lqa3FEalJ6aWFyVC9DQ1hjcktKcThxTjZ4VGZzbkNETjVY?=
 =?utf-8?B?N2pMd2lRN0hMMUk3QjMwdEhyOGd0TnRBaVRyMEJ4MVp6amVGeThlRmN4cHRW?=
 =?utf-8?B?SSt0bFpFeVc4U3BwU0E2SXNXaThmQzFabGZ1Q1NqUEZ3OFE1a05OeXg1V24y?=
 =?utf-8?B?VDlTQ2QxY0FadTdGK045d0YwK2RDUndiQW9SZDRnSXhxKzhxS0c0V0NBKzM5?=
 =?utf-8?B?ZXdpZ1JVdmp2NTRoa20wVGJmSHBEang2U0VkUG5taFlkZjB4eEVURU5JZzVT?=
 =?utf-8?B?R0RQb3p1dmthQ1dYd2N3L3l1VEZ0SHgvNG1Lc3JEeHhjd0dHTFhydDM4MnVt?=
 =?utf-8?B?NktUQzdEU0pzaVh4aE1zUkdBUGY5VVM2OG96Vjk1ZjRoNGtVSkhreS9lTjg4?=
 =?utf-8?B?SWlUdXBOOXBjbVV1UlNQNVRjSTZxT2NsTnkyNFF6UWRGenIzeGNjVUNFd1Fh?=
 =?utf-8?B?MkM1dWt4eXFqWmI1bzlycTI4NFdCQ216blpSRy9aQ1FWbmtYdDJ3T0ZhVXNx?=
 =?utf-8?B?MEZzN0ZMN0VtemlOUTFpRGp5S2tvZnEvWStPOWRtWUJEKzgrc2h0RWdaT2xn?=
 =?utf-8?B?S2M3N3hPdThaWXM5Q09ES0ZCSXNZMGt0TkNyV1lUeUJtdnNpR1E1Y080UDlU?=
 =?utf-8?B?dXM3aExncWNWWU1mYUtDeXNhL1ErNmlaSnB6UWdOdmJoWHpSVkc1SjZzRkJF?=
 =?utf-8?B?M00rWDN1Y00wNWdBU2lTVVFwOVdaaGt0RmZNV3B3YWFEZlAxZEdmY2tBQ0l3?=
 =?utf-8?B?TlVPK1h6TXdJUDhoRE1Vb2RMcTRQTTRpWkxRbDRRYWRPUHU0a25xZVBmYmhD?=
 =?utf-8?B?SVQxSmZJcHNYSDRrQXFjam92aTU2UUYrdEdBSk1NVjF1dUdHTVFOMFhRTkV0?=
 =?utf-8?B?K2ZkZXQyL29YaUwwbWdlVktMSTFHMDczMHhzdGNaNytOaVlJWDRpdHVKVlJ3?=
 =?utf-8?B?UXFoVnNyZHVsdysxa3REQnFKaGNBQm1PUEVaQnVwWTErUlRMekRZa0lFazcx?=
 =?utf-8?B?MUlQOUp0LzVZYUpYZDNvTTNFOVNZcEFld1NXVFAxZXRSc2tqQzlWUVdkMVNa?=
 =?utf-8?B?WENEZHJhSTdId2dmeERnZWpqWlBIN3paeDYrQkZRRFJTUTdnSHNtaW5xR3RJ?=
 =?utf-8?B?SVF5OGV1RGhKa0dNaEUvd1pMSEVBSFBhSW00bjVsTGw3Z0VHWnFwSTJaQ1VD?=
 =?utf-8?B?OGRsR2VtMlFJbFk4cEpGZVFFOVU3a3ZvK3FKd1FHUjR3dlQvc1JLekVHOW03?=
 =?utf-8?B?bkhaTW5PdjZoa05GMFU5OU03eC8zWkE4bGdWUEtDbDZpRmY2S1ArWkcxaVVL?=
 =?utf-8?B?L3ZxeXdBTDBRK05EdFE2azZhRTZoYmxEaTYwU3NFOUQ1dnRSNnlpRlRUdW94?=
 =?utf-8?B?ZVB2WlUweDhuVXE3VGF0SkIzRWxzVE5XUXhvZU04YXh3anEzTVpacnlnVVFn?=
 =?utf-8?B?OXh3L01MQVJ3aXVNSFZrcW5oajAvemFML0ptZ0lWNENSL2pxRVJXTzhwVGI0?=
 =?utf-8?B?WEZqcmpZcDl6U3NqSnovZ0dsV1dndXV0S1U2dGQra1hpdVlUREdLc05QR3lM?=
 =?utf-8?B?QVA3S0VsWThrcEdQMXZnTHZtSTBCMHNYeTBFb1VpNXJCbVB1MWt2RzZUZDMr?=
 =?utf-8?B?em1RZ2VIUWQ3djN3ZEhhemxlazBNV3VZMmFVRnRNQUZYVzFZaUh6K1pkaG9p?=
 =?utf-8?B?STYrby9KL3lGUTk4WXF0ZGh2VDk2QjNtTzVGYjZaL0VJMzVKTkhpc1lpYjZl?=
 =?utf-8?B?Q1VTMGMzb0lvVVQxYzhDamoyZGFleTcrQmtEeEJUSmViMTJiUzQ0WHYzeEk1?=
 =?utf-8?B?Z2YvYkZpT1lkR25aU01RaFA3R0NQOGhXUnhsRFZvay9KYmtKeWpxSnJKM2Yz?=
 =?utf-8?B?WXFoUHhPUnhnVi9xU3lZRXV5K29pZHUrYldhRFgxT0RNWUdwZDdoODZIbHls?=
 =?utf-8?B?ZWZsMkMxdXVSUFZVL3YxeHIzL1BKRHhBYW1qdFIxR25Pck40Qml6Y2lDUXd6?=
 =?utf-8?B?eGIvcDZPK1Rsb3cvMlJuNCtKa3NKeFhYZitqU0I4MnBXc3ZiMWZJeUtFR0lJ?=
 =?utf-8?B?UERWVEVzUDViRmFJTWNSUU82bVNnc0FUTnFFZDgrVW82NDJXdm85elRpNWp4?=
 =?utf-8?Q?Ft7bn5qHLwId3c7Q9zWFjqTMX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0483851-1acb-4340-797f-08dacdc89aa2
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 03:04:30.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vu8z49ZInrD0QviPGgOInm3640sbhTtkXZZVCGCs5pg6ZdwZ3xqJj4seHIT5AIX+SPzND0pYPXACwjPcMqbDSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5299
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

On 2022/11/24 00:51, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2022 at 07:01:12AM -0800, Yi Liu wrote:
>> To use group helpers instead of opening group related code in the
>> API. This prepares moving group specific code out of vfio_main.c.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
>> ---
>>   drivers/vfio/container.c | 20 +++++++++++++-------
>>   drivers/vfio/vfio.h      | 32 ++++++++++++++++----------------
>>   drivers/vfio/vfio_main.c | 26 +++++++++++++++-----------
>>   3 files changed, 44 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
>> index 6b362d97d682..e0d11ab7229a 100644
>> --- a/drivers/vfio/container.c
>> +++ b/drivers/vfio/container.c
>> @@ -540,11 +540,13 @@ void vfio_group_unuse_container(struct vfio_group *group)
>>   	fput(group->opened_file);
>>   }
>>   
>> -int vfio_container_pin_pages(struct vfio_container *container,
>> -			     struct iommu_group *iommu_group, dma_addr_t iova,
>> -			     int npage, int prot, struct page **pages)
>> +int vfio_group_container_pin_pages(struct vfio_group *group,
>> +				   dma_addr_t iova, int npage,
>> +				   int prot, struct page **pages)
>>   {
>> +	struct vfio_container *container = group->container;
>>   	struct vfio_iommu_driver *driver = container->iommu_driver;
>> +	struct iommu_group *iommu_group = group->iommu_group;
>>   
>>   	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
>>   		return -E2BIG;
>> @@ -555,9 +557,11 @@ int vfio_container_pin_pages(struct vfio_container *container,
>>   				      npage, prot, pages);
>>   }
>>   
>> -void vfio_container_unpin_pages(struct vfio_container *container,
>> -				dma_addr_t iova, int npage)
>> +void vfio_group_container_unpin_pages(struct vfio_group *group,
>> +				      dma_addr_t iova, int npage)
>>   {
>> +	struct vfio_container *container = group->container;
>> +
>>   	if (WARN_ON(npage <= 0 || npage > VFIO_PIN_PAGES_MAX_ENTRIES))
>>   		return;
>>   
>> @@ -565,9 +569,11 @@ void vfio_container_unpin_pages(struct vfio_container *container,
>>   						  npage);
>>   }
>>   
>> -int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
>> -			  void *data, size_t len, bool write)
>> +int vfio_group_container_dma_rw(struct vfio_group *group,
>> +				dma_addr_t iova, void *data,
>> +				size_t len, bool write)
>>   {
>> +	struct vfio_container *container = group->container;
>>   	struct vfio_iommu_driver *driver = container->iommu_driver;
>>   
>>   	if (unlikely(!driver || !driver->ops->dma_rw))
>> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
>> index 3378714a7462..d6b6bc20406b 100644
>> --- a/drivers/vfio/vfio.h
>> +++ b/drivers/vfio/vfio.h
>> @@ -122,13 +122,14 @@ int vfio_container_attach_group(struct vfio_container *container,
>>   void vfio_group_detach_container(struct vfio_group *group);
>>   void vfio_device_container_register(struct vfio_device *device);
>>   void vfio_device_container_unregister(struct vfio_device *device);
>> -int vfio_container_pin_pages(struct vfio_container *container,
>> -			     struct iommu_group *iommu_group, dma_addr_t iova,
>> -			     int npage, int prot, struct page **pages);
>> -void vfio_container_unpin_pages(struct vfio_container *container,
>> -				dma_addr_t iova, int npage);
>> -int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
>> -			  void *data, size_t len, bool write);
>> +int vfio_group_container_pin_pages(struct vfio_group *group,
>> +				   dma_addr_t iova, int npage,
>> +				   int prot, struct page **pages);
>> +void vfio_group_container_unpin_pages(struct vfio_group *group,
>> +				      dma_addr_t iova, int npage);
>> +int vfio_group_container_dma_rw(struct vfio_group *group,
>> +				dma_addr_t iova, void *data,
>> +				size_t len, bool write);
>>   
>>   int __init vfio_container_init(void);
>>   void vfio_container_cleanup(void);
>> @@ -166,22 +167,21 @@ static inline void vfio_device_container_unregister(struct vfio_device *device)
>>   {
>>   }
>>   
>> -static inline int vfio_container_pin_pages(struct vfio_container *container,
>> -					   struct iommu_group *iommu_group,
>> -					   dma_addr_t iova, int npage, int prot,
>> -					   struct page **pages)
>> +static inline int vfio_group_container_pin_pages(struct vfio_group *group,
>> +						 dma_addr_t iova, int npage,
>> +						 int prot, struct page **pages)
>>   {
>>   	return -EOPNOTSUPP;
>>   }
>>   
>> -static inline void vfio_container_unpin_pages(struct vfio_container *container,
>> -					      dma_addr_t iova, int npage)
>> +static inline void vfio_group_container_unpin_pages(struct vfio_group *group,
>> +						    dma_addr_t iova, int npage)
>>   {
>>   }
>>   
>> -static inline int vfio_container_dma_rw(struct vfio_container *container,
>> -					dma_addr_t iova, void *data, size_t len,
>> -					bool write)
>> +static inline int vfio_group_container_dma_rw(struct vfio_group *group,
>> +					      dma_addr_t iova, void *data,
>> +					      size_t len, bool write)
>>   {
>>   	return -EOPNOTSUPP;
>>   }
>> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>> index cde258f4ea17..b6d3cb35a523 100644
>> --- a/drivers/vfio/vfio_main.c
>> +++ b/drivers/vfio/vfio_main.c
>> @@ -1925,6 +1925,11 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
>>   }
>>   EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
>>   
>> +static bool vfio_group_has_container(struct vfio_group *group)
>> +{
>> +	return group->container;
>> +}
> 
> This should probably be
>   
>    vfio_device_has_container(struct vfio_device  *device)
> 
> And it just returns false if the group code is compiled out

sure.

-- 
Regards,
Yi Liu

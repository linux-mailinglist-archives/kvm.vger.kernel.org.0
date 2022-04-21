Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FEE50A313
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 16:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389635AbiDUOtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 10:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389641AbiDUOti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 10:49:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7B542EC6
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 07:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650552399; x=1682088399;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7BeEX8hbPEfRKnJDlhhxzba4cHEVz4kjxqDZFhZEP4I=;
  b=FhBa94IrTXqLGks/jyRWiM+yMqxUUBm+NY7jMGiJa4osu394++SKcb4d
   vgNmQ+khnwgVMSyvkeh+Lb8IvikrdDjON7n082S97l5XiPJaNu0vtevkv
   d+chPe7gYvplCXXR58RSq4fQbu7+i6eZu4ltSP8I6iAcZ9jl12/TU+Go7
   bq5qdaGKNE5pEGZSTP+pgMVXkcln9RNtR4tefO532X7PTWsjs/R+r9ACm
   8YA/OMyXaBbAs9pR0LhUvUtiWo1Qg+YOzlzsDAb0KO1vtsiqaWC16tcu7
   G10072urSkGY09xKBVVZuScVEnXF65nOYBe/aupcLc6jJ2rpsD1lmaaR9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="261967580"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="261967580"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 07:46:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,279,1643702400"; 
   d="scan'208";a="511094324"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga003.jf.intel.com with ESMTP; 21 Apr 2022 07:46:37 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 07:46:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 21 Apr 2022 07:46:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Apr 2022 07:46:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7vRLlNmBQoL+tV3mjxo4fydbwc9+3yumS5KasvIYLljym8v+XT3fEvvNYz1Koqz39O1mfishfV9joHhPZ5iaBW3hqiPigDqu5qb5azP4zvNgeyyrjUh8hy2XdUQ3lZ1rAvbCD9xHzeXP+X1bKNsTPVI9Li5Zg4R+Tb3LAuNBDJVbEVaRlfp0G28rZ+b7vY59fGwwP1G6Bh6ETrFp5eIXBqcBeKPb0Fd+gbsTL9nBpPfXH7dRno3JMMmAl3P/K6e3wcLUCqbcpnUJMcMRUcN+LVrhiuMDtKbZyBUMGAwxOQ3gk61Ie6+hRcKNFEN2ecD6setik41oyNEOb4CznLAQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1BvxIsUhh3edHsvxOYH2i8bPm8uqJ24FxSlDvRohCU=;
 b=XtlT4NphzMkii18IcLsvzu6cb2d3id1Cq/TaNGcrku1PqrJXtyEzNBe7jc8dxUEg0iDDV5O8KFDXITvJ8FqD65iTVOEs8dN7HKHdj6HU94k8q7klteVpa+Z/DUneI8eKMTjrtR8Ur32WO+u4jA45DkV9VjaS4tddOMp0D/el1cYdzqbEMdyh1qTTjUuCkMiqRCiyMpRrfuTG2QWIU1QVXyUSm1Cj6bdlDtxBEuANPlIvJ383+ZSJPCreekUT+d5FVM+P0lG5bEIfkE0CsNefogZV1/us2gBXaxbYvTFRixCoz6sSZvR1G7mZQiiP/npnXVW11oKbtxnoF0lFG2HhGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB4997.namprd11.prod.outlook.com (2603:10b6:510:31::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 14:46:35 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%7]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 14:46:35 +0000
Message-ID: <4f8ff189-2a40-80a1-d55e-3298d1f22152@intel.com>
Date:   Thu, 21 Apr 2022 22:46:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/8] kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into
 functions
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Kevin Tian" <kevin.tian@intel.com>
References: <1-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <1-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR04CA0086.apcprd04.prod.outlook.com
 (2603:1096:202:15::30) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d17dbd13-5f3a-4ac6-6746-08da23a5bbbf
X-MS-TrafficTypeDiagnostic: PH0PR11MB4997:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB49971C14219876752D2A5E71C3F49@PH0PR11MB4997.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RR9uEffMquVIOY5xZ56SifwvVWKEQxt/AyTw5n0RIGdZbs/jHXeuGj8MLcTZWKrWDvSzt4tLgGJ/1pDibR4aCstIz6RUhhRQJTvv6sMldy+Yz9qMmQyhQPdBVaG8f5R7/Yx9V/0APAUrK6RywGdwv/Wxv1AsB1EqdaS9xBCLMQta17m3MQLQtRt7pCxDUY7g0clG19H5Wtf2G2nfXqAruLrw158eir2migpGATRcN3XeIPzFWO9mjGQBhCzwiI5407Mxw5dyP13sTjl2bOSeP3Xl2iuI+6lkciuKxrq3bR7yUhznqQ0vDe494c/Oqsr8qoh9D4WHKTpk5oFKI2Q3ctOO79gP0S+aG9eBH9ry7MB5LLBNXiYGfH7W6Q5739mOsBxCz3YEWYValJvd19i19y72e/fjtFBaxNWeCQ7v0uQtqU0F/QcPp4ktdAHUI+1s6Dexb/SAcY6lUKN5XTSxsnutc3v0ZFAbMhxst+kzVaeOFWcD5r/ytY8ioBpn79YcJHrD1vOyR2OBeRVhpUh3Vi7iAcYmeq2aO5OSfy2ViVDp6F9KNBrcbjkzJGf8Kj+h9uj3xRoHdUhja9iJKP/EzRbTzgnsxksMZtirxEZ9zzlqVsysBwi8LI9ucAaX5u06o5N92urGlaok75YkwhBB15FrS6fHgTODTbYNbKVizb7St8oDcfb2DOfsfr0q8LIRkZhCV9Efoxc6K1iz+nQFRGqDbf6/fvFktjZRBGEcud+ISJ0nxOwWlOFWozwsYhm1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(53546011)(6512007)(26005)(38100700002)(6486002)(4744005)(5660300002)(8936002)(6666004)(2906002)(82960400001)(83380400001)(107886003)(86362001)(508600001)(2616005)(186003)(31696002)(31686004)(110136005)(316002)(66946007)(54906003)(36756003)(66476007)(66556008)(4326008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDN3YXcvOTFFZG5kLzdXZk4yMkJnY05aUEhVcmExaWlueGFxOVIvb0MxSmRI?=
 =?utf-8?B?bjNpY2xieXo5dklERkwyME1QRUQva2F4NVBFb05KUzNlRlFyWTBtYmN3eko5?=
 =?utf-8?B?eW1sU1Nwczg2cEJxS21WK3V5UURlSGRuZUtucHNxZFlYeE92bGdudDFOUkVE?=
 =?utf-8?B?bVRwdXBYb2RVMnJYODNTc2N0R3d2ZFJrVmpBeTlORm0rSGdPTGVMK0hGTkVF?=
 =?utf-8?B?VHdGL212bUdTcVFROGpWL3dJVzUzWnY1TFkzVUVtZVFsRHZSVVpzcWJ4OTVJ?=
 =?utf-8?B?TGdyN1QvbmlnNm1VRzduaktWdU9BQUk2NUViL3laenRwRU5sZ3FYdG8wWW1O?=
 =?utf-8?B?VzN4ZW9aWWZGUXNSeEwvaWVZbW9FRnVJNGM2dFlPQWI2MlJnbkRFWXpJOEI1?=
 =?utf-8?B?RWRndDNFTUxnYWNnNG5QeEZhUDBuT2s1U1dvOFVSVXRPWmJoQk1zUDl1QjVv?=
 =?utf-8?B?VkJ1aHdYUDhJbnZmaFVPczJpUmlUUjFWS3M5QTR5WHZ2TnppanZ5RURUbFhs?=
 =?utf-8?B?RE5lWDMxS1N5SENmSUZOb0M2R1pqWFhwdVBDWTViVCtSbUxHREt6NnhkOXNm?=
 =?utf-8?B?S1FucDNBQjNrZmxTbVNSZVZEQnJiZXdQcFl2YW05alJscThkMnM2NHBJK0tx?=
 =?utf-8?B?dTFaN3F3enlkZUZBNnhYSkYyMTZySDcyQ0F1aGhhU2J2SnhuMkx3ZzlyWUhq?=
 =?utf-8?B?c3Y0Q1RWK2R6aW1jU2I0WXRyalVtSklTN09kdjkrRVpFWlVFYU9kT0IxaW96?=
 =?utf-8?B?OC9VSVliTk1WMGF3TVQ4U2JRQ2x6UWIzeWt4dTVHN3EvWDZGbjVWSGpRRGd2?=
 =?utf-8?B?SVZueDFNb041MTZsc2FHdENPRjJmQnl1SFpGVFdlcXIwdVMwWEVQM3dFbUc1?=
 =?utf-8?B?d0NtTEt6NVRTcjI5SXJqSGFjdTZlQXNoUE9nWDRCMWExZTR1WE02V1pYVnFU?=
 =?utf-8?B?NDNqbnI2d2k3RjJIdFJ5bVZQZTJqMk1OaHNyUmh1UThaZnFrRFF3bmlHZng0?=
 =?utf-8?B?VUNqQTZTcldlYkIxREtwYmdySEtVSXVMcjdoMjYvTHZtOWgzdzl1YURxcGZi?=
 =?utf-8?B?aTI3SWNxZklOVkY4K0JHdkpXQjQzS2c0NllkalVTcmVtYXZGRDFuN3RIUVJP?=
 =?utf-8?B?T2piZk1PQzJQamFBSnZBejFCdkNpNVNRaXRWdmVjZ1pRTDBPV05weEdEbDJL?=
 =?utf-8?B?TlE3S1BFNXdMMHBCNzRFdGNKb2VzNmxzMVZiUm1uRWZ4VDFZUWp5RUw0Uks1?=
 =?utf-8?B?MXpBV1Uya2RYaUpGcWR6M0JuVzcrTnZEMk9yMzg0TEVaQ2ZOWDVBR2hmLzZH?=
 =?utf-8?B?OVdVSnBia3VHRHBQNTVLSnV4Q0ZHQnZBSHBad3lhZXc2S0JyY3ludkgrR2J0?=
 =?utf-8?B?UkxRajBCTjhkQnVtMnRHTkw2dkRXNGVsV1pDQk1SdkxFQlhvK3pGaDdpRG94?=
 =?utf-8?B?YUhTcnpRZXBMajFlQjZLOVhPS2pqM1ZLTzBObjlvd0NSUHRuMmc3MVZGaGRZ?=
 =?utf-8?B?UWhLaVRkY1VKRVhkNEJLOWJYN3hpUW9sejIySnZNVm5lVlkzYnUxZzZKQksw?=
 =?utf-8?B?YWliaXBTdk45UE8xbnBwQ2R1cmRVamRJdTBNZ0NlL1RjajkwVG9DeE9mZGti?=
 =?utf-8?B?b0MvTUdVblY0V1BLaHU4N1BDME1UYnNBbGdJRnMzYXdMNFc2aUM5Z2Nvajdz?=
 =?utf-8?B?R0liR0o2K3lPY2phdFhma0xBMG9ZMEwvY3I2QndyRGZ4QXlaQUlZNEJpM1g5?=
 =?utf-8?B?dlJ1WXMrK2RHOVFVT1dxSjlXdnVqM1R6RVI2QVFZbWhhTmI0SEViV1h2UkJw?=
 =?utf-8?B?K2w3M1dTMDdDR3hXOXF1NEtScnFuM1hDQnZzaTlKVkY0QnNEYUtyb0F5NUpF?=
 =?utf-8?B?ajZsMGFlcy9CVHN3cWRSRDFyV3VsQlpkN1BuZGtvbE5PYWRkbmgvcHUzczEw?=
 =?utf-8?B?bjVndzJKa1dmMlhmU2VEczBTZFlEL3VuTlExRTNjM292VEhMWWx1RjhrZUVX?=
 =?utf-8?B?VVRJbzlTdW8rOTMrcVVBL2pRUTIxWnZKWkUra0d1c1o4VjRFU0tRc2N0UHRw?=
 =?utf-8?B?QUFsSHg0QzlXSnBtaER4ZGExRU15WUZtRVNXR2NFQW9oTEtUdG1mZEp4RGhx?=
 =?utf-8?B?eGwwUnlXUzBoaDV0eWl5WFA2Z0JtTVhHdXhhT2plcWhjczNadndPbUxmV0pl?=
 =?utf-8?B?QWlGNzNPR25vdzJoOHRCVkdTRFJCYUtyTFVmWGN1eUpneFdkdFY3ckZGL0cr?=
 =?utf-8?B?VnlhTFZJWGMzM0ZDbXpla2ttRitta3YyN3psK0pheXF3djNGMW9QamlHSURo?=
 =?utf-8?B?MVFGanVWZi9hbzQzTWN2MFhYSmpLOE5pYURJcnlvQmtDalE5ZVJVRjZPajJx?=
 =?utf-8?Q?qWNJMjVzyeJf/9ZE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d17dbd13-5f3a-4ac6-6746-08da23a5bbbf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 14:46:35.6554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u004DHDX9ipORMPfbpuf/VPrxZhbdOHxdqH/cgojOrVzWCfYDj0VcTQWBXbnlxw0XsL1atEOOOIpBiL/XBB8Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4997
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/4/21 03:23, Jason Gunthorpe wrote:
> To make it easier to read and change in following patches.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   virt/kvm/vfio.c | 271 ++++++++++++++++++++++++++----------------------
>   1 file changed, 146 insertions(+), 125 deletions(-)
> 
> This is best viewed with 'git show -b'


Reviewed-by: Yi Liu <yi.l.liu@intel.com>

-- 
Regards,
Yi Liu

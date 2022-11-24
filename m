Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CBF637574
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiKXJoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKXJoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:44:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07902125201
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669283058; x=1700819058;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UsWk2CenLWB9FKBjovaM2rqBbNI4+LCMWQSBhjyPCKM=;
  b=Pa+S1ksaNCI5nyVUw8BmE39VoDvsxiMBmnKOCPeBPOEsAfVqNZYrU4mJ
   jZoPpSaIQbMDJ5CIVl5yikxTuOJkp4Nlb/vJnBjA4cXS8eqmGG7GU9sCQ
   ygVuFC4ucoh8rfxgJdf9/57WtGGpHjesU0oPo/XX6rfwrvAE1NlmcoW+W
   FvIkwAjytRj38syc15/7Bub9QFNqWRJUzzUEwizwN002A8Y3NJ62OFykS
   0JynDIwG0XQdQy1Zce9fu1VwVOtWXSv7+UxUS0+mG09I3dLtIh604TD3A
   9DhpJ8Pqa/F4fvN4GRJXEZgldbQESxmvBTzrCDUn3OCa8XfYUtjYTeP2z
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315414716"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="315414716"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 01:44:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="675033449"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="675033449"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 24 Nov 2022 01:44:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 24 Nov 2022 01:44:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 01:44:16 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 01:44:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWXjd26GH69w79JmqfV1DM982m2Ts6uTCTv1rg+6vbywkhUheFnJhkyj/1+4p8YZ7pFio+ybAw6NflQyCUTKajKMpYKTuihUK3t98m13TGTqOTPFHs4oweZI5J/HbUYWgCPEQo1xxMCNvizYdMyCMBKdJeIovYTX6wrUjHAySlwyB4HLjBP06aw9AQi41bVIzQ0G0fWtusuIq8z/axK3GunmLIqvBit44zcDzcRLxnBiOJc5rSHYyCgS2BuQmnAJpZWeixOJgghS8R0ESw/Zur0a4daOFWdn1TQic3JTNy7NuBuOpGgwsAGXpjoIGLAbMr+csgps4cN3muzO744jNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUPPrqmC6pduzehGSvs5I0uXhgH+O7qVAqOZuDhlWsI=;
 b=JDw/MVvtD815zK2oUi4yzYyXmX68uX7uWOJzbEclpVs3lz+O5Wgxsc6ueyVcgJIB13zIXtP1Dhm6DILbzOE39RM0NV1aI7VJOcBuyunLLwhQiiV1eIkr4IGixVHeMZMn4cOF1VgnP9umqtass9CJQqg6mvyV33zSSCkaktKfJdYqw6h38dv6quuKlDaoHS36OXbjJmgPz9FiRvhdz650dcBlub7C1cUH4/phDdEApkQxsSMT0b7Lfo1LGkVQ8+PgXw/OZGfQRJTIDIX1P5b6wDSjN65Zz3nn0ogsdCsCbz7mqus2fAf0FIOgaRgDI2t3kcGMw1RpsZABko1zzGi2Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7677.namprd11.prod.outlook.com (2603:10b6:208:3fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 09:44:09 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%6]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 09:44:04 +0000
Message-ID: <e7c54b5a-da27-018e-a573-90c4af43f48d@intel.com>
Date:   Thu, 24 Nov 2022 17:44:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [iommufd 0/2] Make mdev driver dma_unmap callback tolerant to
 unmaps come before device open
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Halil Pasic" <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <BN9PR11MB5276DE5010A39F50C9C657AB8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276DE5010A39F50C9C657AB8C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0014.apcprd06.prod.outlook.com
 (2603:1096:4:186::11) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: 810cb902-3d7a-4702-2ab3-08dace006c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfAuAwy75vx+AGehHpkLsy6G6/ZriI0MfPC35iYnrw7n3xn18uI9ttSM9dV2QcaW7ygn1m01yNiqBP4T7C9macrIk89VvJjVQaPqgz8k5tUNW02VpI07LMkzrs9ktgsXi3joSbw8BLy0vNprf/vduGt4CcFZpNYJtkvyhX0+icZlo1cf9xZbaJSHJ61rAT5lBVwaYOUwGIBNmS1c0YV3jLbEmuRvw8j1Ew7oKYSHldtvWN1F8DpoOcloaY+AmBr/JcRWh1GGpU4KNBGI4PxJB2qV5PIG4GUBDibLl31NH4iwA1LCdYPSFYcExJgwaC4WZOTaxlWEQQebV/jGnSNdwd77L3OjUkfFKjTj4qXFwC4QUTsMhPK7gJezsSATVZ9XVxd0CMNadC8yizB6LMH5zb+DGf15PnqcyHmsr7WOmUyOgNgMbgm42hgZwmsORKYShkVuLGpb/UAWVEKfuhCG9YznqAskcAzLmoB4F/Hjk9yQHicU0IS4njghOJ92j9mlciWdnM1Oj29rr5uWRWTxmGmBIEZDm0GrQTvrzj60HzbQcAuoxoTKpCIW+enFPfGZTYfRjmbMGokkMlGpgPg0ktvPt+eWJkcpGvJZmn5lS/OY9cJGemnL80QUVooMpSpg0zYPSAAoQHGWY0aS3N4Dak0+AKsosED9uAQlVl1g07udI+saW3S4VNLH/l0GQmHvxhYIPuwsk0MWka5Oarqeso62o8nE91LY3n6/VdBhl58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(4326008)(38100700002)(83380400001)(2906002)(86362001)(8676002)(82960400001)(66946007)(8936002)(4744005)(31696002)(41300700001)(54906003)(5660300002)(66556008)(53546011)(6666004)(6512007)(26005)(2616005)(6506007)(186003)(316002)(478600001)(110136005)(66476007)(31686004)(6486002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFM2WFpjb3QrUmI3ZnV5R2tvT3Fua3p3UFk4eERBa00vUmxFWjFQYTRIaHRo?=
 =?utf-8?B?M3ZSRStFeC84eEZjWUlPTm1neVBON1M0NkdCTVNoRDJvMExhOW4rRENyZE9O?=
 =?utf-8?B?Myt5blZBa0RydzN5Uk45dXRvTW9POG4xaUJFa0Y0MkU4anNnT2Vuc0x5S2NK?=
 =?utf-8?B?aDV5bXA3MDlvMjFBeEZ1QjVFc1RuRUdlTm1IdURXczcwa1BxNWhwV0ZTQ2Np?=
 =?utf-8?B?S1B4K29VSFJ4UWxPWkhDck10azVxTWtjc0E3YlVkN29YWU9obFQrcExTN3FQ?=
 =?utf-8?B?NFFCVWJlZWVoUWlmeHEyT0dLeGU4cng1bzZoMGdjZG9TeGFmUG5oNzY5TER3?=
 =?utf-8?B?S3FrTG10a3EvekxuTHEveU00RlZqSWJVQjY2Mk5CWUZmYWNqZ3JTbWdhemFz?=
 =?utf-8?B?WWVxbXBCM3VYR0VuNEI5Q0dxcUxSL29lRjRVWThUVytvVFR1MUV5OGU1SUlv?=
 =?utf-8?B?bEJpbkhRMDZxTERCV3ROdDdOb0lNZ29TSGtkOEpXdkJsWkVkc2VxWkg0Y1lM?=
 =?utf-8?B?alRwdzBpLzBOQkQ0T0lvMDJhbDlLTVFiWk9ZUTN3WTdRa21lTVF2WWpNTEdw?=
 =?utf-8?B?Q3JhNGhoQU9YRkhKeUhocFhGVlFLM3V1azM2L2ROZWE3M3BxOU1pdU0ySmxq?=
 =?utf-8?B?SDBBR3VkL0lsS1lTa0srOXNReW1rTFBPVlE4bm5GMDgvYURrdGhVcjI5TGhH?=
 =?utf-8?B?VHlPaUlaRlRLayszN3prdkxqZWlueWQ0bm1FUGl4V0JtcjJXVjA2MDdUd2Qr?=
 =?utf-8?B?SXREdWFDS2w0aXpiTWdKYU9FVHlKZHZDM2N5cG1Rc1pzMEpXdGo2UW9KdWNW?=
 =?utf-8?B?azEvaXZyMTJ0MGNSNEl5alR3NXJDdEJWYXlzcTJQODhxTzJDdWxBVlpmUlhk?=
 =?utf-8?B?cDUzdjBZTTJONWx4dkt1bVIwYnlMNUtqQ0hMbE1vcUVlTUU5SFVBa0xnN2VX?=
 =?utf-8?B?SnhWTGR5d0tsMng0V0lvaDhRdHU0d1JwVjgxNHhsSDNSTzI4VGRmckREb0Fr?=
 =?utf-8?B?aVJhcE9tOGlObllhazJDNVFFSHgrd0NweXNhQ1A5K3dqdVl4N3lTNWtxTDA0?=
 =?utf-8?B?b3NNQ3kxTDZVU1dvMzlGaG9pNkFESyt0TmJENjFkcnZRN0NuRHZ6VWFhL29H?=
 =?utf-8?B?TUdueHR4WUowZHVnSGcvYXVWZlUvSEFHMmZHdTJGRkdkNDh6MVQxS05qZTRN?=
 =?utf-8?B?Wkk1N1RnNGtYR0N2eXBxM3lWaFF6dmQyT0NZRmIxLzVpRW5zK0xnSjVyYnVX?=
 =?utf-8?B?clBNYVFrb1RrcGhOWlV3TmEzeVhHV0UxRnFhRG5KSnRGaVN5K0g0ZWlVY3ZZ?=
 =?utf-8?B?TUhVckxjRXZYWW9Od1U0MndYMElLemRRRXJnaDZqSTFyc3ZqZUZqQjRPUVZH?=
 =?utf-8?B?WWk5dzdiR0M4NUcxU0tDdlJFQitBbEp3TVE2SHYzUTh2ZytLN1JmU2FBN2FY?=
 =?utf-8?B?eU14djFqTXhXelpvRWFUV3VGanBGZUlrak9YRm9menRQODdVbThNcUFhYkpR?=
 =?utf-8?B?aWFiSWl3WFcrVmE2MDJXWGw1aHFNWjdaMDRFeHlsMDdjM2RBVG1Ibmo5cEEr?=
 =?utf-8?B?bjF6cUFIYVFFMVhpVFhtcDgyWWZITFdqRGJmdHh0RmpoSHJOdzh2TC95alAx?=
 =?utf-8?B?bFptLzZrb0pJdWZSRjN3OWh4YlpFZnJvM1N6dkoybFNCVEJDUDdIZlZGejNm?=
 =?utf-8?B?R09QWitWNVFDenlLOHV0UWJmN1BBUUYzb28rcjVCRHBqL2p6YVJ3WU1CNUJr?=
 =?utf-8?B?S09RZlF0NXMxS2pGcmYrSVRTMmdqRHBuNWQ5MHFKTTJGYURucXF6dzZVWFg0?=
 =?utf-8?B?ZFZDZ0NuRnkzQnZNUndmcExUM1VWcnhFVCtqa2hjOEhkb0tOQ2kvQ2JGcnor?=
 =?utf-8?B?SWtSTFV0L2NuanBGZHNNTC83T05MZmdvOUFNOWc5ZUdGVWR4eTUzY0M1UUhh?=
 =?utf-8?B?QVFybWY4bzJlL2JwVWlFSVU2QVh5OE56aE05QzlZazM0UFVRa3lFT3JpS3dY?=
 =?utf-8?B?RjhCUE0wQjg5bVIzT2RlT0R3bG5YOHkyc0FIeE5OVG9MeFNMaGEwdHhZaVIz?=
 =?utf-8?B?a1FLY3NsZVV1OXpIcm9TU3V0LzNBSXBlR0FtNG84c1I1OHI0NW5NRHZCMFEr?=
 =?utf-8?Q?6ztaZ+6qQ9QMuRc7iLcaKKhlp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 810cb902-3d7a-4702-2ab3-08dace006c8e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 09:44:04.6048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fL/xH8HCP2B/EhzMEAt8jo9QP4B9jy16XrOIxvXiMWXtJKUyELGVwZ2AW26GZD8sE3du4WRbLU8dg5UnNUmMpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7677
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/24 14:50, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Wednesday, November 23, 2022 9:49 PM
>>
>> Jason's "Connect VFIO to IOMMUFD" introduces vfio iommufd compat mode.
>> Under
>> this mode, vfio_iommufd_bind() creates an access which has an unmap
>> callback,
>> which can be called immediately. This means mdev drivers may receive
>> unmap
>> requests before the mdev is opened. For now, most dma_unmap() callbacks
>> are
>> tolerant with such unmap requests, except for gvt-g and vfio-ap. This series
>> tries to enhance the two drivers.
>>
> 
> there are only three drivers (gvt, vfio-ap and vfio-ccw) providing
> dma_unmap().
> 
> I'd not call the situation where only one driver is OK as "most
> dma_unmap() callbacks are tolerant".

oh, yes. will refine it.

-- 
Regards,
Yi Liu

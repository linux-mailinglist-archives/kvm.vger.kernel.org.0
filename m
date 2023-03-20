Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AB36C14BF
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjCTOao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCTOal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:30:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD1D13539;
        Mon, 20 Mar 2023 07:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679322640; x=1710858640;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=viGDXBMLg1XfAGZQtXGF6ftUVhhbVTn0gCcBzcRhXVM=;
  b=ij73a0r690bS6kWNzlSF62egHEaweid8HtdJbnNZKBw3UU/f97UpMJe0
   1vveZ5EjAXYu1bbwDmSWRj8yiMqvnzYqWNyOtY92R5vcqgqs/vdnp1oog
   EeE24evt9VnQG+1b3Nw2qgI5l3y/zUYTvoM6qTxu/NfTP8gAWOTZtIOfT
   AwwUjLb4SgWj2s09ly0OAiDh7hzAgpYNE5snYlDFBHF7sosujM3+UBUhO
   ksAhRl+Idy0TrMRHeFTu0dOUYTsgkEH+HBD1KiaLmjyZ3LDYk3eoz4ugk
   LmQj0SNXEtv8cbGlp+wdgLLA4Uxlzsdne/03l35OICEpHGOCAFki+wY3K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="403547489"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="403547489"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 07:30:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="1010500250"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="1010500250"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 20 Mar 2023 07:30:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 07:30:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 07:30:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 07:30:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGhgRSuwMRHnSBRV4QQPkbfha6suRuXDKud11LRXMExN6lwsDMEmMQbQXl3m/Pg1wGRb822fQTbMvXTIf1N/LMNRvLFVyiuO2T15rLKUC7s9RZGJlzSNceoJmtdIHI8P7DR2gHQaFM7JrsrLxxVC02PDdsEczVioGWzCGDQeT8HxbDLbSRqyrXIrTon0bq6ftRDSHSjEGpDAR68ugFzvQDCBPHpdZNaXmT5wuLGpct1JPji6FdYo1tGHe1F3N66NzDbjVb/JOY206Cmtl6jckaYoy1vK+eaPqXC4lImXYTRyzCRa68us5uSHCejkgI+X8Csy29mP2noNxlSJ5vxsGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lv7EPrB7PvlCcoRKGARpcwh1dzPq/Qwsrt2Gofn4IRY=;
 b=PlKsSg3B0/a2RKcLQYi5fEqp0iGurJ3qH8DAxY42s2Iiiugq/ig3VKAcsGmLFZKBmExAn/35NwQdxUXbvvmkpil528vXCEBdoHI+1hcrroQY99sIzsbHQzZ1dWzeLArNRLrW8POxUR7nw3t6MhTwfDtNyRdz+BQN528aYHa+JSEqNRlrOD4Q0k0Hg8SIm84d18kGCvf2zre1NzNQuz9hLzaTCj4dHMYjH16Vh4Mj0GbYHWkvmNV1KSwxk7fKKzShW5k9vltj5NqtjLiVAQBld2hAL1BaPXkSft1MCJJE4W8AhbHwWzqaZWTZ1U5AZXd0nTY4w7lcKV6UrNoaL7qEFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN6PR11MB8195.namprd11.prod.outlook.com (2603:10b6:208:47f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 14:30:36 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 14:30:36 +0000
Message-ID: <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
Date:   Mon, 20 Mar 2023 22:31:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
 <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
Content-Language: en-US
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ZBhpNyrBr9nm5Ae+@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:3:18::32) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN6PR11MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: cf5ba849-c84f-403d-b937-08db294fab4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1pUsC3ZfMMVeAhSI3KLfbHy6HOHLgZmDW4bRjeIC4lcPKEzR/GQL6s2ZVPcRYnIeIfpvhR2A4wT5RYPjBzV0LfQKMsIkgUiBTVDZmcmzZp8axOpaukbkKkLGFesRnphjj3XGyf+J23f7JuGUERsLx32DfpLFF3V6pHHUrmKe9I9eA43H6CWWepWxV+xJEfNkHH0KYrFXTDc/JJrlLP59vkoVXKVtoeHoKCtI9QjEk0r1h6le9uxNEXfGjh8gOIppO1aWyr9vdcFMjKLryze0Lc2sEcbVLRkCsSG9yFi1W9teg6VTl3mFYZcoQal29kA7j7Re5+wmBS2CmJl0fNhiWAeisNy09eTbgsecWqga7En1VdaO3M+qacDcNV/3BSsWR4BVU+H/e69Y3lzjzSstBuPUAz7HVB6u4gbDy8xmrVMV/MSr1o1dcqo+n4nAuYtT9yBulO9TYflYfSmKEdtroNcBV70jG1E11B+Zxq7SLQ6S8Wob9Lf0CUByi+ZBwJR4V2QC39B82CO0VhIxM+DA/wwdcdJXGjZArTUn/HHjyP84bPnR2rFzJJ4V7UIMgofMYactMhh9tXqUNVrsys7RLU4gfkHgS3K6bpNj/KlVho/Z+I3EM/06cSDNXOgelrlvdTF/KLU2d4XPN17BwXGm4lzec1wn4dgFGvyOpMSDjHl9lWyfE10TQ83ZlhbRUBnMTWAR81kDG6YZifNbaaBkwuDN1gg0J2s+x/cwHb37CqU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199018)(31686004)(2616005)(6512007)(6486002)(54906003)(316002)(6506007)(6666004)(7416002)(478600001)(186003)(53546011)(26005)(31696002)(38100700002)(86362001)(66946007)(2906002)(5660300002)(66476007)(8936002)(6916009)(41300700001)(82960400001)(4326008)(36756003)(66556008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGxRZGhKaDh1TlFpZk5kZ2J1b2FaR1NrYWIydXdHaytSdEhYZWxncUEySjJm?=
 =?utf-8?B?dVRNNWtaQ3RYQnF2ZnNmWGxxUHYxdTVSY3AyOVFTWXRReXREbTJZSzNoWUdV?=
 =?utf-8?B?QUNqVzB6SU9HUnJQM2lXeUlJeFV6SWtTaG5DZWhFdnlNRU1tQXgwb3Y2cEhw?=
 =?utf-8?B?Zk5XR1lUMFJTU1B3RDY3b1B6a1dtc3JRSzlqY0xzdE5ST3dxWmc0ZE1Ndmx6?=
 =?utf-8?B?RkVZbUQwTWZTdU9RTCtWc29RMUsxWmFOSXpBdVdwbTRUbGtrVVFSbFR6d3lD?=
 =?utf-8?B?bm9EKzlqUEJmc0owWjZmSTBqS3U3MmM2bjFxQXlFSm5TaEF4NU14K2x6a0Ja?=
 =?utf-8?B?eXBrYTk3U0dITElFRDdWVHd0ZjhOUWZtZzBIV3UvNDh3eFBqZlVvN0hRL1cw?=
 =?utf-8?B?ZGVkVjhzT255L1FaY2YrZFp4U1BKYndlVkd3enF5TGhjMDl6bGRUZXZsSDN5?=
 =?utf-8?B?MnFLZFdIc3FJMXErM3BCaVNlMUFaY1JMMFdEekNKbmQyTkFYR2ZrcmY0ZzB6?=
 =?utf-8?B?Y3VsRU5XTUY0M0htekZTeVd1dUF5QVNwQ09udFo5NEdLdlhiU1RIbE1Kd2hB?=
 =?utf-8?B?cEVHUUVwVWRKUStmcnJnTVFZRlVTelppeDhZWlkzYmp5a1QrbTlWVC9zODJC?=
 =?utf-8?B?RUYwM0M5QS9rWWJseXB3ZWYveWpQN2lxblorbFJJYWIySUU1YnM2bkVvOGpU?=
 =?utf-8?B?TmwwN05zQ2w1UGYzMkk2LzhZK1k1Tk4zVUlUUk9aY1pvRklXMUhMZXk5TnFz?=
 =?utf-8?B?NzdheWN6UDVSTEZBbFN6d0VURloxQlM1bHNFSXRuZStRZDF1U0JVZWZpNm93?=
 =?utf-8?B?MVErWkZ2SDkvanpGRWlmemh4TVVUQ1pVeU9sR2dpSC9pTHZlSHhBTWU0OU02?=
 =?utf-8?B?OEVRaVB5a3JGL1FvNkVBZlIvKzhXYWN4Z2FFRjZTZW9zUkdudHM4dlJRZk0y?=
 =?utf-8?B?TjZYcUxtbnU2WUJTdzdJektheG4ySCtLck1TK0dxQTZ6ZVdudFZYNTZKL09J?=
 =?utf-8?B?b2lzK3Z4aE9ZMm1RejJkWkcrL0t4Z3ZqejRtck0vVE1VWkxZOG83djBKN095?=
 =?utf-8?B?R2ZIZGZuRkxmZzkzS2ZEdWxjc2RFcnUzck50UVdzZzBQZFJlTGg5c2dSWUN1?=
 =?utf-8?B?ZmxEQkVLNHlORnB3U2x2UmF1MERUSkhlTkQzSFVSbHluazJhYkprOVlDa0ZX?=
 =?utf-8?B?SkFyR1liVVlaSFg4OXM0dWt5Vm5EMlFndk1QZllPejh3c010MTNxd0JENmlv?=
 =?utf-8?B?cld2cnZKZHRHellnUmwrYk9pQWxyaFF6d21IRGxoQ1dCVzFjeTRyRm5JRndY?=
 =?utf-8?B?em5KYjgwaEhQMGMxajI4TjdQTlgvb1VzQ0lieXJlR3dRVDVXUkVuQS8wUVBz?=
 =?utf-8?B?S1E5NXNuaEtSK05Dbkk1NGpNYnhQem16VSs2WUhqZUhMTGg2VitUN2JqRzAy?=
 =?utf-8?B?b3JNcWJDRHhhazFkMUNkS3cxaUlZZTVCNE94TTNCMGk2ZDY2R0VQSXZ2L3Zp?=
 =?utf-8?B?QkcvaVpFQ0FuOXhEYmhuOHZPTUpFOUpFVkxxTUI2MnNCZWpablVsTUdoQkZE?=
 =?utf-8?B?NnVMUVZFaklGMklYMHRXb05rUDZ0b1lLbUtlWjZWdVdWRUxtczNPWjV3SGhU?=
 =?utf-8?B?d0J3WU01NTZiVnNMQzFTRUgwYkFLb1JrV1FsQjJKbDlFdFdHcmw0OUdpZzF2?=
 =?utf-8?B?a1JnWUlycFVadmxSRElmWlpOc05oUGdaUXpad2V3b1FmMk11QXlBZFFoV2sy?=
 =?utf-8?B?WlRTS2JNRE03Skd5SEN4RG1NQTkxRm4zVDQrU0pLVGg4YUZ3d0tJLzJNMjl0?=
 =?utf-8?B?dTA5YW00N3ZXcmdBbnkvSUJGenVuRFpIR2dTYUxyTDYrTmMzWkNKSy9ybnkr?=
 =?utf-8?B?cFhCRnBaV3lmM20vc0tOckNXMGVvSnQ2SlAxby9mLzF0NjFFeWh3K0c5NWIv?=
 =?utf-8?B?OUwyeVZOZXRaTWp1bDIwV2dacXliUGhKamJVZGRpVnBIYzdWajhsS2F1WlB3?=
 =?utf-8?B?TVcwRSt6QnNlTXpxbzB5WlBmTXF0dkc3cWl2TFBNbkw2ci9jMEVSMVAwVGVG?=
 =?utf-8?B?Z3ZUdVlYWUlLYUVRM01OMzJseUcyOXVDNWRnc1lENUM4eGM1amhDZFN4aEtN?=
 =?utf-8?Q?Qvpfeb6cU2qzi5Od/R+ADPZ2K?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5ba849-c84f-403d-b937-08db294fab4a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 14:30:36.0387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUOr+rgCgPIjTdWIc0x6C9E3IOlbUvjLGXnY0+RqM2tfp53+G6hz9+S3pJ78ojADJ8nBiy0hcd74gcJPAfuG1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8195
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/3/20 22:09, Jason Gunthorpe wrote:
> On Wed, Mar 15, 2023 at 04:40:19AM +0000, Liu, Yi L wrote:
> 
>> # if IS_ENABLED(CONFIG_VFIO_GROUP)
>> static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
>> {
>>          return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
>>                 vdev->group->type == VFIO_NO_IOMMU;
>> }
>> #else
>> static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
>> {
>>          struct iommu_group *iommu_group;
>>
>>          if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
>>                  return -EINVAL;
>>
>>          iommu_group = iommu_group_get(vdev->dev);
>>          if (iommu_group)
>>                  iommu_group_put(iommu_group);
>>
>>          return !iommu_group;
> 
> If we don't have VFIO_GROUP then no-iommu is signaled by a NULL
> iommu_ctx pointer in the vdev, don't mess with groups

yes, NULL iommufd_ctx pointer would be set in vdev and passed to the
vfio_device_open(). But here, we want to use this helper to check if
user can use noiommu mode. This is before calling vfio_device_open().
e.g. if the device is protected by iommu, then user cannot use noiommu
mode on it.

-- 
Regards,
Yi Liu

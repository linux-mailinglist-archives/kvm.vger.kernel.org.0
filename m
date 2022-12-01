Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAE663E927
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 05:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiLAE7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 23:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLAE7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 23:59:01 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAB2A0BF9
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 20:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669870740; x=1701406740;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QaVL/TcvvJbma2xpN/28NS7DKvsjWL62SJ9ven1LARc=;
  b=K15GQ8welerLq2hblkHPmXhW3JCCYivcRS5F9/N6sQBzcrypFtvs0Ie5
   a8YyAmbe6A4yPaV8BTo+sbpkVJNuPvCC1LEV1YXQt0Q/LZTPetvOv7oaN
   8IDvPDX7qoV3uLEsDzYhbwQkfzR1PZwUBJ8qKIPn5eNQ93Qj+r8MuqbP2
   Jm3Jot8BIZlDjpNNWGIYpepWcLPqMw+0h8f0oLUu4/NhekZ4wFk+hwXn4
   F5mD6HAToURdtwHthwJ9cdHQckUS934qEftmOfmVrALEqFmlOtpXCXBfC
   pBc3zNr6jcNEKK5gax6ArnOsfkYiYhz7HbHFo3H0dTbrskqjKdrqE3IwE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="314288145"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="314288145"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 20:58:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="713080809"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="713080809"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 30 Nov 2022 20:58:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 20:58:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 20:58:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 20:58:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhcNaBGSR1F293kOBF+gJRbE3yl8dDAkwkCSgG7lYoSnNdyF75dqLK3cxZs0q1bmJMX/2SdenMCt8C6Ou5oqwa0jbZ68gyZyLgMDsqlo9lUnma/ku72iDtTlG1YvS4uDs6o2UIQLu17MNleChR9yywKPTIXYXYizZt7ZiN2wePT/4JDf7tipQCFdIjJSmA5CxmUz8zxycku2aYadk72wIG3RkLGw+pZrF30FGNMi0qsIa1ScQYWk7wRjffBaj/7S9TE3bcDrqCZDvd//qEIiPbfXwYnUcPZ8iJXGmG5OGRvA5p+G3OaaZwgW27SuOTP4Ezj79igf4GTSAQ2Gukih8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKepuAXqVS9/8bjUABHc3bS6DxvETKXjfANIKTl3yzI=;
 b=lPD44nb0+BhFycUxtBR5im93UCtpx4o6vLUUv5GQHPPxtl99oqHEFJy1fmaBn8JrmSXhiy86uQMIdRNd9pcgmTJk5OcPpKmLJzYjMZWY4IR2Nyn7ZN9lVNHNC7AsaNYXHbtGufqL/74B3ktlL3fz9A/zuM5QZU9RXLZA2vSHzNUSyUdXBRTUtVh2xqjHNChBhrZVKGyYb7zFOZKsaUaAmGLHQh8dYGa3N28UHwT3QkvoTkuYv+Kl0gMUDURWjsr9wOGtEWg9BYCXKuYkcF2hZoNl2Y3kPEuEf4sHqBwNCThBaWdKmtNVwzuTz25HYe8TQEYQpxgbOFcsyoeKqznTJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5228.namprd11.prod.outlook.com (2603:10b6:408:135::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 04:58:57 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 04:58:57 +0000
Message-ID: <73b25971-8915-1bb0-4c72-9750ec44199e@intel.com>
Date:   Thu, 1 Dec 2022 12:59:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v6 19/19] iommufd: Add a selftest
Content-Language: en-US
To:     <eric.auger@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Daniel Jordan" <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>, <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        "Joao Martins" <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <19-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <48c89797-600b-48db-8df4-fc6674561417@intel.com>
 <Y4dfxp19/OVreNoU@nvidia.com>
 <00d43a82-3262-5248-a066-e71c608be0a9@redhat.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <00d43a82-3262-5248-a066-e71c608be0a9@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0110.apcprd03.prod.outlook.com
 (2603:1096:4:91::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BN9PR11MB5228:EE_
X-MS-Office365-Filtering-Correlation-Id: 8940ec4b-a297-47c5-9917-08dad358c06a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/41dNwQGQdF7gpHtZkl04MIO9/CjIx7yhtJHyxZqzUPQkPFi1m93y1yJFx40lLJKlht2eoj/WLKEDklwmKfjF2zttPHif5tvMwgxJ7mjzmntHTBPObAU2JLdHZkMBxNp2NyT7+p5MK6r9QcWdtO32GJRimlPn9POtuIQbfGryMWBk5th6FqiDVZ+3i2Mn9iRMLDIlzaCHfgP39PgIEdOdoJMW8F9a61EX+mMDBNp1Ts6Z29A8rw2huJYlOX6BPnKljQhAP50x0DnRzQxF8k/k7/66TMGT24IsDCF/IJKZ8NdXkZuOifvWBay3qcdJ2wYK/d2nTlTvXyKETFfsNAxPBsrYbiTAx2sPrmOML4FuuqRgFp0ZiSD+5gf6aqz3UdPIECwQ3F0YYlBLgDoS7FggmiCwZ3tNSHq1zrn5mIlVgcSawTPo3nhZkxDhZguqhljW5U/G8x29+lVTG87nypVH9/s840rYHXmrWAMqPmRycGRNJSU8QSUnRzAK3pToCj5Zxd/vuhhNZiLngWcFvJJJVSj/RENKc5MJSjQG5qsDqnC4TGhRCGIjQJ2xKqo+6xe0cIdRYNgGr+Z70RdU1qlgaL3bO/4xCJEk4IGgT5hOYj42ZeufzKRc6TWJDwWTdhTu9pEptid2OxkJTBbFE1lag6eodcD67r/eFSHcFANmzDOcHtlPwZdY689ehy+2gQQ0jPCyF67aX7XZ/Q2y9u9VG0cP+754Rolvr2Cx1CL9c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39850400004)(136003)(366004)(376002)(451199015)(31686004)(2616005)(54906003)(6916009)(6486002)(316002)(36756003)(86362001)(31696002)(478600001)(82960400001)(38100700002)(83380400001)(6506007)(6666004)(26005)(186003)(6512007)(53546011)(2906002)(5660300002)(66476007)(8936002)(41300700001)(66556008)(4326008)(7416002)(66946007)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXpIR1pSc0svU3dBNDhZRkE5aDdCd3ZUTzFsM2paZGExTzR1bUJ1SVp5T0pO?=
 =?utf-8?B?cU9EeTEwYTdZZno5T1lBMUwxcW5rY1M4TzlxVXJsQ0plUVZrWFUzRzJ3UFl5?=
 =?utf-8?B?djBQTGFaMFlSSkE1alZaZjlQMjJJd05Tb0xXMk4vM081QXJ6R3JHZm1QWEhV?=
 =?utf-8?B?TUlDZitTU0VzYUtDekFlNklEbWovRytGeEJVUVpmUjlmaFBEM1Bqa2RwZURL?=
 =?utf-8?B?VE8vZzR0elhjd2ZEQjQxd3RtMXlMWnNYUFptSEc4Y3daNURIaHNGRkRNM3p2?=
 =?utf-8?B?T3dVN2x4eko3U2dxaDFXWkNnMzVValVYTGhOVUFHSzNBNStCME5oWmh0aXJi?=
 =?utf-8?B?R3hRTDdXWkdReDBWRjQ0UjRBNk9JUnJSSXZpcjJKanZLZDU3bElvRW5OeUcx?=
 =?utf-8?B?UXoybEJydU1wN3Ezc2ZLL2txa3pRSS94TnpmeXhZWDZybG9yZTdEeVVRRG1N?=
 =?utf-8?B?NkgwRCthYk1RV1pVZzhWdVRWNXUyZ2M2Sm5RLzdPMU1rZU51NmhVWjdEUDR6?=
 =?utf-8?B?NFFXaTQ2VzNhK09JMnFGbWpWMG8yN1hFU1ZaRkp5Q0hBdElMSWlnb0hpaXBy?=
 =?utf-8?B?bjkzMkp1bE9sWEs5THlqNHQ1Si91SnVIdjVabm9FVnRuOG56b2NOZk94dUM3?=
 =?utf-8?B?Tml2VEllRnFESmdnRXR3aHhtTThVYkVOemhkTlRNcld4V1ZOSkZYd1V6bm1K?=
 =?utf-8?B?WlVMbFRkenJUR08xNGVpaVFhNTdqSUFHTnBYZTFWVzhOSkZkb00rbW9aL1hK?=
 =?utf-8?B?dTNiTEFHK3JVeTlKOTVUM05LR2hvUlNpK1RvRWg4d05Ld3MremI3Z0Z5Lyt6?=
 =?utf-8?B?R1VKdFFBclZSSDg0SzBIdXdHVVpWcHlXT1h3dk9IYjZMMEFGQXR5WnFpbHJx?=
 =?utf-8?B?TnFQZ1RCS2pYVFluYjdyejhUZSt0c2JJbmloVXlCd2R6MENpRGgzTVNibTNR?=
 =?utf-8?B?RmZCNTFlbmJ6eXJNSHZXcVRiY2hPdThPc0tBc1NCL3BsTnZXejFVZUFqcUNy?=
 =?utf-8?B?OGY2VWFkdXdQdldUNFE4azRmQU1KZ1RuS3lxbGpTQTZIRGU0ajR6VkJNanJp?=
 =?utf-8?B?TEd4TGJaejltY0FSVE4zU3RmY21qWkR4Y01SRzZOYlQwTmVJVlpuV054cVda?=
 =?utf-8?B?ZEJmRlV4RXFGT2E2N29tZzVPUDZqOU1yeTZNbzZYV1hnZTN3TjJtVmVkR29s?=
 =?utf-8?B?UXdqMmhxUEwyb1dsNHdVbld2U1VWSitoRFBIK3gwZkJqd1pHSDR6QmhsbU1P?=
 =?utf-8?B?OHVUQ2VWZDBkVzIxaGovanArb1BJWFNNSjNmWm1PSk9pL0RPR1pZNjJvOGZK?=
 =?utf-8?B?d1REeW52aUVkNEh1T2tyc05HeXY2VjFTM2p2Ni85MEdlc3BDdlBqV2FBcHVn?=
 =?utf-8?B?bTNIQmZXYlhBRmVCYis2dGtiOFRQcnhNRFV6RnhOSVNQamhCTkF2OHFnd1k3?=
 =?utf-8?B?S1gyby95RVFPeml4SG5aSWhPSkR2Z0Q2WjVoR0ZTSmh0ZlhvdnB5SDhZdDBp?=
 =?utf-8?B?SnVOTERhTVFRcDFHYVkvaithQVpoQWU0a2IrUHNJQ1UrNlQxcGJ6b0JjL0p6?=
 =?utf-8?B?OHJpaGVaYjVqNXZ0RW9oTmVnQkI5N0FlNklJUWF1aU5aT2lJYStHZUJjUU1a?=
 =?utf-8?B?VnZDNG9kYlZ4M04xWEIzM0t3Rkp6L3B2Q0kvTEpwOU5zcGNQVnd2YUxsaU0z?=
 =?utf-8?B?UWluK05hT2lsU05ETnVUakFLQjhQT3FMVk1SL3dHcTJ5aE9VOUZjb1M4dFFo?=
 =?utf-8?B?NXF6KytHcGZZWU16dEpOajl1aThqbUlkZENXK3Fqek5sZHlyUktld2NJYVd5?=
 =?utf-8?B?ZnBmM2tpc25ac3JxbHQxZThlVDBFWmRSQ2lkTjYzMlpDcldhTkdiak9HY1d4?=
 =?utf-8?B?QjlkQ0Q1VFBPc0xxSjdMY1JCNmV5UjQ1d0hBVzY5OHdEbkhubTF2RlYyTzZG?=
 =?utf-8?B?U2tyaWgzMzdKSG5pNmI3bVUrbjlWUW1JWjJwbFBiVnBoSG1lR0VZMXlLOS9P?=
 =?utf-8?B?aW5LWG1jVmc0L1dJaDZ3NnNSMlhUU2xLdzFzZjF0SnpFdFA3bTlGd05NUElz?=
 =?utf-8?B?d2xpZkI1RjJxclVyQzZOeWcxcTlEWGd4dUlUUHQ2aTlCV2NnSGxmMDk5NEcy?=
 =?utf-8?Q?2b1VA8vTTYAcv7g48MA506Qve?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8940ec4b-a297-47c5-9917-08dad358c06a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 04:58:56.9057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SKwBNIM9Z73YGVqM3gUMy7m56kCjPoOgkb/bTCB1nrhG7sD19jDfHYCUspnpDSn4wfqAWcnD4tF1rt7p3Uo9UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5228
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

On 2022/12/1 01:18, Eric Auger wrote:
> Hi Jason,
> 
> On 11/30/22 14:51, Jason Gunthorpe wrote:
>> On Wed, Nov 30, 2022 at 03:14:32PM +0800, Yi Liu wrote:
>>> On 2022/11/30 04:29, Jason Gunthorpe wrote:
>>>> Cover the essential functionality of the iommufd with a directed test from
>>>> userspace. This aims to achieve reasonable functional coverage using the
>>>> in-kernel self test framework.
>>>>
>>>> A second test does a failure injection sweep of the success paths to study
>>>> error unwind behaviors.
>>>>
>>>> This allows achieving high coverage of the corner cases in pages.c.
>>>>
>>>> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
>>>> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390
>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
>>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>> with sudo echo 4 > /proc/sys/vm/nr_hugepages
>>>
>>> Both "sudo ./iommufd" and "sudo ./iommufd_fail_nth" works on my
>>> side.
>> It is interesting that you need that, my VM doesn't, I wonder what the
>> difference is
> 
> That's the same on my end, I need at least 2 hugepages to get all tests
> passing.
> Otherwise
> # FAILED: 113 / 121 tests passed.
> # Totals: pass:113 fail:8 xfail:0 xpass:0 skip:0 error:0

that is it. :-)

> I think you should add this in the commit msg + also the fact that
> CONFIG_IOMMUFD_TEST is required

yes. valuable to add it. I guess Jason already done.

-- 
Regards,
Yi Liu

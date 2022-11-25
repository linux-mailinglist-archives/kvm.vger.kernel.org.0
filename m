Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5622638C31
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 15:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKYOcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 09:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKYOca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 09:32:30 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AAF251
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669386747; x=1700922747;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QydOS7kx7sYcx/TRF8QBACnPTvHtSNfrC+O38tnqHjo=;
  b=j60yKidj8wxul/M2P8OMF8dBTVHYFXjBxlzjlDqxOud9AE+uBZyeuGAF
   +I+OzLsyLskYcNNbobsxzJiHYnFWzAHjdEXQ4L3uh752DKOI/7VfnPqE3
   9ka+BKXHdudqwVkQecJYnIC/hZr74QbYuW5v+yJUJL0AdmQMmg7r5xoV9
   40HV8lME8Cz0CH3yRjLBCEcDh8hXBvKDgo/goLkB2Cu3rCZVB+CLpaemu
   2WndtyfJFyb6GV4vnIRenebAhILU5jaekmp6LGnfYNMInZDbgW3UcHLLG
   UtjwzRzn048D+G+Lgy3Vw0yqHJuKxqmZThvovVVSp8+bk/O2co3JC6ZQA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="314527005"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="314527005"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 06:32:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="767387011"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="767387011"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 25 Nov 2022 06:32:26 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 06:32:25 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 06:32:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 06:32:25 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 06:32:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G99+HMFyGKdgwLEW76n0BTC6aYeKsw+ZIphwcknKqoL8YzFJynTTwt6kT2jix1IdSBc7vpFNtnaHGXq2CpOPRNJPkcWqG88vh29A8jDfl4HKsjjAqJkV8f6o4O4Pi4T9E1UJjXD1dDcqP5rTEGJy8km4IoDsbiTV1NkZdFiJRts5j/R5MVW2DlCD+0DYuh7Zl0kKBzsy7sXM73dX1o4I40snbCpCI+elG9Nt/6mxM3kKh1DVuvmCj3pv+Tou+YD26m074lpsuX0pss5lMyLPeToT9abcMFtGLYUJL64LIYk4Q5+B+7MOUeWT7UyZp+kPnmyQWPvObVz2Vh7q1yYjJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAgGGy9ekLc92MYTevjKU+XMo6v9HXEbY9kL/qSftEU=;
 b=kEs4WNkQtj/PVRQbiqoNyrt8WY7Add3Ll4TTYrwRPujvud5+18SaT+iIoSavKtzC7lCVdmNzYWZRxG7ppLKSSYFDx+Zm8qkk5/7Bznc0bzNpaZYMdqjBwv/Y2YX+sgLKqMAIC2wor3wQTETggSOEPIHOd/fqHGt6oZUdFSODohTfjxRA72/WaHVOcMw7ww+ATBeLSaxhteFGeAx8g2Vm4mNyNUMcvhSSb6Segf4u2GhinLv3/orCMTGfcl0vswFkkbmR0TpJevl8XH9dpMZsv64tms3d5U76YZnWSEr3Rz1YZ8uFLppxH1EWeYtHsF2FgjFl8bCulT8LADP53yFXWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB7273.namprd11.prod.outlook.com (2603:10b6:610:141::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 14:32:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 14:32:24 +0000
Message-ID: <4013c422-0658-48e0-ea59-d8f6adc68008@intel.com>
Date:   Fri, 25 Nov 2022 22:33:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and
 _last_close()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <nicolinc@nvidia.com>, <yi.y.sun@linux.intel.com>,
        <chao.p.peng@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-9-yi.l.liu@intel.com> <Y3+GHbf4EkvyqukE@nvidia.com>
 <955100c9-970a-71a0-8b80-c24d7dbb35f2@intel.com>
 <Y4C28lraaKU1v8NE@nvidia.com>
 <f73ee554-807b-0123-bd93-3e3ba24feaaf@intel.com>
 <Y4DN6Q28mVAm+/w1@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y4DN6Q28mVAm+/w1@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0067.apcprd02.prod.outlook.com
 (2603:1096:4:54::31) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB7273:EE_
X-MS-Office365-Filtering-Correlation-Id: 61f16c3e-7bd0-4248-c4a4-08dacef1de5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hP6YF8ITTVC6kfYltD7YcTLSh+eQtqe9KS7TdDDB91BvSu1VXzOPqH1Jzv1dGHWKko+b4cyGYK9Wpdy0KiAy6NqeVZ28fRI6HLpy/vTHE8YutiK5uakADmklSNTWTgxGMZ4ffoS4vww76bMqtpIbg+aKqsW0KnohNy7NnagTSCEXfojOpvzlrTs5ZbV135Hd7cBWHehvR4CbJ6QAYJfggEdO//xWPwiHDRvf+K9jQHwP8JfrSPeg3pZi7jolEx1sZtQPyHS2LDgeRUOyF+aH7Nzv0UZrDFtupNnUhrWJdwmjqF6+ZoIFcX8xL8EuN4Q2y7g/P7bnmBM7cp07aiOfsxHoeM/YICJn3rrwNOFvVYdwqS8pq1dFFTP172CDflTaW2sjAVsWk2+xlPP+rbGzk/RuqpmQPHzP4/UXjKVAilBfy8DQYZE9r54FMNgMuoYYVnN8Ound5CCoDr9XUDBgwymZrRxeMkFGBQowTHFAoc6h7tJkmxI30N/91FZxW2unAjZeoR6aVdza0jchA7Bk9zydQXrMz4hFGeIU5wTN+kzBF+FjFS2mGedYHuwY3FKFDEJMbr1hjslFINF6KYzs7t7/IU1XBdsKXEmqhDTh//TsEq8m9UM+1I6msIk/asKuc3ghYdnlpS7wc5Ap3eYA+zXo+L8T7ocOl0Cy3gFqNNSmqbqMr5Pt+p7wd9jntCt+aLscLPVWLGcdsbfO8cEOo9ikbaaQd1lOqZztNWft1xQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199015)(38100700002)(8936002)(41300700001)(5660300002)(4744005)(82960400001)(31686004)(31696002)(8676002)(66556008)(4326008)(66476007)(6506007)(53546011)(66946007)(83380400001)(186003)(2906002)(478600001)(36756003)(86362001)(6486002)(316002)(26005)(6512007)(6666004)(2616005)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SE5oaDA2NU5JUVAyRVFVZTlMUUNWWnZKTzVqUURSeXdRT1ZaaWdpb0VEbTNv?=
 =?utf-8?B?YmY5MldmZTVNaDlTOFZTTkczTUVpTkIvM2dZNHY4SDRNbW9jdHFQaXZDdnN4?=
 =?utf-8?B?cElldU1SN3M4QitUUU0wTGhoUE14bUF6OUdSaXNPOTg3SE5heElLZzZkK3BV?=
 =?utf-8?B?cFFiUVNCRG9acTBsUnFQVGtsOHRTWDhrcFBJSUlkRy9ZMVlvN1Y3Vk9nRkQr?=
 =?utf-8?B?RTRWcW9lL0hWc1VFem5hang1b1FJTmQwSVRGcjhFUkVOVFNKdWVJQ0x6NWN4?=
 =?utf-8?B?S3owQ1c1b1BOUzhXb3dxTW5hK1p6ekd2bCtkSHJQNjZEWi9NcitoNkVHUG1L?=
 =?utf-8?B?NGR4emJhdG1LV3ZDTzRHZHhySlI4Qnl3aWwwODV1UFZvOCt0d0NtTWFSdDVh?=
 =?utf-8?B?WXhYWHpmSWd2WVlLVlQvRXlVOU05Szg3dFplNlV6VzBpOGtCb3lTTFVabHpG?=
 =?utf-8?B?RUQ2ZXdQRkVSR1FIY1NCbGhyOXJmNG1xSUU2UTZsS2Vta0R6RWpyVUlRY2ty?=
 =?utf-8?B?N2JiM2lGaHRSTk9HMzVTZU1EcGRocm41aWJFOCtOVDhUOVVGUlFETTAvelpj?=
 =?utf-8?B?Nml5ZE96czhEcThONE5Eb3VVc3pPSXE1enRDRlNiazkwQlFyOERpVHFIVlAv?=
 =?utf-8?B?VFUzRWRVT052Y0pUSUtmNlNJU2JLNmN2cWZGaS9jdkdaSEpaMC9jeWRjTWZS?=
 =?utf-8?B?d1BCdUR2dGZpd0lwdGZwR2hmWFFrUFNtOG83aE5mQ1lDQmI1Q09CQ2VjYVZ2?=
 =?utf-8?B?M0lLN2kvdyswc2dHSnN4L05yMFAwU1VkRVJCak9mbFVTZ3N4TlI3angveXky?=
 =?utf-8?B?Y09nSXhHVll5NTYrSnBhVVM2emJpVXlHSFMxNTlNRGZwSE5zY3o1eVNyUDgw?=
 =?utf-8?B?SlRVYldyL1NmRmRIRGUxZXVQb3NpRjB3L21NUkJpaXFEWnFmNWNXZGFWVVo3?=
 =?utf-8?B?QXJIVURXcTcrbHlWaWd2bE0ydytQWURRU1VTRk1xdXduejRNRTZNL1NGMlZX?=
 =?utf-8?B?U3hJOHNjTGhoK0ZUWncrd09VSEZrN09nSmI1T1V2b3lhdHc5SUpSRElqRXdi?=
 =?utf-8?B?aXZ5akkzN2tjdDJ0b0M3eVF5c3JFTC9CM3YyVS9JSG1Cb2VwbCtSSVROdjJm?=
 =?utf-8?B?OENmR0RZOVFXYXZ0K05DUnJBN085cmZXMW9GMDNBUjlRVURPazlmbGhnODFW?=
 =?utf-8?B?Z0ljMFk4MUlCdFJ4NVhDdnVpL3lFRUlKT01NaG1qODVqSWpvWUdNQzc2OURE?=
 =?utf-8?B?VXU1a2dYZ0lxcVRFWHJuVWN4aHp1N2RBWjIrSVZ1MWgySzRsR0wvaytHSytG?=
 =?utf-8?B?VXFlWEpaeEVPYktJZzBtclQvV1AveE5rZ0wraERsMkttS0pvREFSY0lCaHAx?=
 =?utf-8?B?a2dLY0ZpZHBWcE1PbjF3Z0RXRFRydzlOb1lDams3dHo3djJKT0g0dVhzS3hN?=
 =?utf-8?B?SVVpeldUU1VpMGNPdG5jaXNrRHRSMSt1NzU0aExPb080VTE1RjJWRkVmYm1Q?=
 =?utf-8?B?bmE5NXJEZW45OGxnNHJtdEdvb0hlWUw2NjZLcTMxcW9ZV0FzUDROVFd2cGJm?=
 =?utf-8?B?VFBRZDdzbG4yZ3ltZGRVWHJaRlNMd1ZsT052R3RlM1NkS3dhWEtKWWt2VnNZ?=
 =?utf-8?B?Z3lzOHJJd1NoS29RaVQ3VUxPaXFCN3N6UDJqcm1xV2pJTitTckhOY3JIL0pk?=
 =?utf-8?B?SG15VmdYMmtndFY4TDdVN212TlFQb1R3TDhmWE84aXlJUnorSlBVN3NpNmRY?=
 =?utf-8?B?RXlaemNJU003NURIYk9sNE84SDRkMExTVktSUTB4QUdTTWtGTEFrcC9wM29O?=
 =?utf-8?B?Z0RhRlMxaUtJN1NKdWNlYWVCb01TWHVMeEJFdTBkWUFWMEQyZndXdFZaOGZt?=
 =?utf-8?B?dll6eGNQdU54eUhGY3BVQ1ZmVXNIS0lMc3FkYVZaZ2R4T0dQL3h4SjJsd1ZN?=
 =?utf-8?B?UzR2WEFaRTBzK0V5NG53ZG5TNmhUMDBrSmNldnJLbjNuaDNhQzl5dUxXQTZ2?=
 =?utf-8?B?dTFOaE1XTmZSalU5N3VXVXJPRXRWUWFUYzJmalgyZnUxKzBiNklpdkdidytJ?=
 =?utf-8?B?SjJPaTYrN3dhekRBRFdNSy9POEtaVXpydVVOZmxHbnFQRXhZMUY2MTdBQ1Jh?=
 =?utf-8?Q?63Ul9F+Nu4hpxAqLocFre3giV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61f16c3e-7bd0-4248-c4a4-08dacef1de5a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 14:32:24.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xGse3kKQjc44uKbgshMgJaxDhf3xa3TSAkCfd9cG5+8yT8HnQu3K9cwFMRKdDouTBNRj0kx2VXX6pPCMIwYGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7273
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/25 22:15, Jason Gunthorpe wrote:
> On Fri, Nov 25, 2022 at 10:06:13PM +0800, Yi Liu wrote:
>> On 2022/11/25 20:37, Jason Gunthorpe wrote:
>>> On Fri, Nov 25, 2022 at 04:57:27PM +0800, Yi Liu wrote:
>>>
>>>>> +static int vfio_device_group_open(struct vfio_device *device)
>>>>> +{
>>>>> +	int ret;
>>>>> +
>>>>> +	mutex_lock(&device->group->group_lock);
>>>>
>>>> now the group path holds group_lock first, and then device_set->lock.
>>>> this is different with existing code. is it acceptable? I had a quick
>>>> check with this change, basic test is good. no a-b-b-a locking issue.
>>>
>>> I looked for a while and couldn't find a reason why it wouldn't be OK
>>
>> ok, so updated this commit as below:
> 
> Yeah, can you update the cdev series too, lets see how it looks

yes, it's wip, not finished yet. I'll update tomorrow.

-- 
Regards,
Yi Liu

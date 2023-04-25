Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E956EE61D
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 18:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbjDYQwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 12:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbjDYQwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 12:52:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B47D307;
        Tue, 25 Apr 2023 09:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682441558; x=1713977558;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bH4TJM6PDkTqHDYELYn+hJgSZEFCgX1Ky+2TrmUptXU=;
  b=BpX7njmFPfJsU1oduEcdJ3IV8VDugMm2to/h0i/oXQBOpQsHk8wJ+r0m
   VC2Cci/UgGvyFEHskiOQzeCzhC5yKCut1I9qhs8hCpx7zZ9remMlXnbOT
   iQpScId0jlTA2E1Vog3+fkZupnFCuQURMuGgS88hQQcTUKHrLtxCr47eo
   o0SF53ohtHVKPS4rELBnpRyTDYvMXO3XG/ScAJNR0hnz1eRAb+JBiHJN4
   q4opyjXn5KmapVX6ZbFA+piq/pYtoPg6gMPWVSNq9fkXvt/NJnUYA4y9m
   VgOP8398dIRZfMRk2gY++ALmEzEQclI72sp8v0NGj3KYnQBjzarfvCxbC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="345585933"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="345585933"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 09:52:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="817762049"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="817762049"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 25 Apr 2023 09:52:35 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 09:52:30 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 25 Apr 2023 09:52:30 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 25 Apr 2023 09:52:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1BXfmTXDZ18bA+KHy3eZvCciLNbBk2lVeYvx8qB2MtTwl46q7HeN2LVXV8lR3zo05QovODr2Q1lMCZNlVqOBnrdE60qhPvYMg9rPi410ET+mBFNboTdVx5GohIh+0F8KwhBzN86j1Qz2S3uMfXDMJbRXtPPz+DY6pGDt9JBpkbD/iL7fKYSvZo6iRVO0dvq1PvuaJ7h9vSkfyRehRaCvM6agjbHLJ94TwmpJNyuWkQIFKAFK8aOledChdd/nvgqBgHWfTwy0UYo1YIc0DYYhSIIdyQrzdV/p8t2KeAJLbUbNzUqPEaljcu4HcloI4Xi/qHj5E5xoNVClWxgZq5ReA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9KdZyhVsvjGWkYUg5pNKkMbtGFeVAyVJ7FdYJzY7KY=;
 b=DbgIkpWg4aaeUigf2fkDUD4dIVqbx6ZK4i4L+yiXXKJtA37VA/eofqNxEgFQ+vtHG7GJ26zligL7vBkXueERpzQvk96rzYvnfOMNBYpuTHxEQ2LB5zpamW9jwInF4UvpyPylFDFA7Qnr2XfE0IAOI1NrP69lPLhUFLSq4/Q6mrtG1mHjvg/TRPpdRmxs0Evm2z/+sryWyx9UBx5oPfniMtuKwRV2roUGPye3uDwwsAU6YUTORRHVxWYpPhQaxLr08siBtMKiQ5lHYZOBMkUDWr/VCmujildMbj2El9GYJqDMHrYnDfmfNF39X3shxAhla+gS1v1RVNMpWIjA2oVYJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by CY8PR11MB7897.namprd11.prod.outlook.com (2603:10b6:930:7d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 16:52:28 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::2854:770d:2a43:dbc6]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::2854:770d:2a43:dbc6%4]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 16:52:27 +0000
Message-ID: <c044a192-ab6a-9ccc-8eb0-46f9fa6821e2@intel.com>
Date:   Tue, 25 Apr 2023 09:52:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V3 08/10] vfio/pci: Probe and store ability to support
 dynamic MSI-X
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1681837892.git.reinette.chatre@intel.com>
 <0da4830176e9c4a7877aac0611869f341dda831c.1681837892.git.reinette.chatre@intel.com>
 <20230418163803.46a96fdc.alex.williamson@redhat.com>
 <64b99d1c-073f-cbc3-6c5a-100fa23bcb13@intel.com>
 <ZEa/rTKja3Xpy/j5@nvidia.com>
 <5167f01d-fcfd-d821-40fd-c53f4fc135ff@intel.com>
 <ZEfpB7m3bWr1bPlv@nvidia.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZEfpB7m3bWr1bPlv@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0046.namprd11.prod.outlook.com
 (2603:10b6:a03:80::23) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|CY8PR11MB7897:EE_
X-MS-Office365-Filtering-Correlation-Id: 0929f9fc-57ea-474f-1989-08db45ad7347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdfgVNipI4CzYJcHqJCcBPc7xtQ9wLQxuShcq+b77VAXjIx1O6OXN35pTVt4RSUUStSzDdmB8ev4bzswHg2xnsdN9pveylme2g3x2qD2EwfxB3a1OrkO3rt93oaKcaFytcZOJZ7/6I0l5FLM5w5lGt0sCdbjtwLc+cJPVppCWI7nE1bU7AfnkgfcuuVgeoNdaxf8XmFVA0xYtkcGvfF303n5n4h8rzT1565gd0CiAZoX3ijmucVfhV13jpOIhI5r0LCAcqXzAdM6UGzgsZusqGnpKGeVvh//ZKzrwP1A+YARBGiPWpOM8vp7RpYwyM2OMtu49hku790YRVCaPUPSgVZ3RWlEHfXusXZ+cz+JmfZ+GRFXunR/KqsttUI9HhwCpdtGcNtXTkDn7e34pvO/2Qo49OJrrn0YWUssAD19vp1uVQGODVNcgIdazzSFcqZjFOlG2mSExZLK5vn+rdxdgzLqKwg7rkXIRiTcTorJFB4aa2GAWz4UQv5DjR2G6vCndhazmpL3Z12HbA1XydXssk8QfdXpnx3kKeQYlVxzg+srrnUguG9I4jWhRZMXVOLQvUycXyJfGrJ/6rjKMvhcewf5D9F/huFtOQVaVCffkzVqM7oMPSVgv434cVMWFO+QPeQ6QotmtnUfEgS9lS5L1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199021)(478600001)(2616005)(83380400001)(53546011)(6512007)(26005)(6506007)(966005)(66556008)(6666004)(6486002)(66946007)(31686004)(186003)(41300700001)(38100700002)(5660300002)(44832011)(82960400001)(316002)(4326008)(6916009)(86362001)(31696002)(66476007)(2906002)(8676002)(8936002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFFLSm5BZHUwWlBMdnU2a2hhWDZFYXhLL3VEVVdKUVcwakt0b2wxRSs5MjBr?=
 =?utf-8?B?ajRHRkE2TnUvc0NFSlp6cjAyaS9EVG94aEg4QThVb1Jqc0cvaHBDcEM5RUdT?=
 =?utf-8?B?ZnN5QS9hdHFINk5temlVQy90WmZBZEVYUTY3Z3NTcW5qbGhnRnJXamFsRlhl?=
 =?utf-8?B?QnJuRjhJYnp2TkRPLzhRKy9aT0tpS1hmVTRXK2ZCZnBGVEh5RVVDTTF4bGhs?=
 =?utf-8?B?cm1BN3UwMlA0TmZ4M3hjVE1JVWVOb0tlSElkMENZOWtFV3A0MjVRV1NCT1Rk?=
 =?utf-8?B?eTJnNnJ0V1hxQklhQURwOUtJaGZlaVpJa0lNOEVIc29HYVVsc3lHNWtsNFo5?=
 =?utf-8?B?TTFWcTlVWWl5L0pLK1lTKzdZbWR6RS9FVkNCbGVUVENUdmNkNnZYbUtueUpm?=
 =?utf-8?B?QTJPVEtyem1CeXJuU0VINVZQR1RyRURWMnhyeUdXODgxcUFwTW55aE1mVStw?=
 =?utf-8?B?R0FDRjRKckpDWGMyQ3ZhMUhtdVhiZDFSSEQ4Q29aMnkySm9NWHpxcVlnLzZR?=
 =?utf-8?B?WkV3Qm1RUS8xMUFpU0d5R1pHa3FPU2NuenZwa3FHTjg2ZE1HN2FDZWtkZ0ZI?=
 =?utf-8?B?TXZsK01TSCtxQnBGMkc5Y2c4YnlsUXZqM2wxZlV0alk2dHZlWFkvdnl2YTBl?=
 =?utf-8?B?SlpwOENXam9XUW16eC9qWlRGMldwYWpTa0hkK1RmRjErYm0vQ0tsNzFQL1hB?=
 =?utf-8?B?SlRONHVRZWd3NnZ6b2JMWUZqVHRYRnhKc3J4R1R0bjFMNnRqaFlmTmlLL1BR?=
 =?utf-8?B?RE9Jd2tnUldSOWpsY1JieUdOZ2I2cHNjS1B0NldMZEp1N2JyRXRwckhINHpZ?=
 =?utf-8?B?clJrRWt5d2tHSnkrN3V3MlVZdzJoN3c4RDZCRFU2K2FOZzRlTEZoRjAwRUo5?=
 =?utf-8?B?Mi9oWXB2QitzVFo4ak1lcVRFa1g3T1VwZWY2dVV5VEpKNTY3RDc5NnhRNjY0?=
 =?utf-8?B?bzdDb3JZZE5yandhOXhWSkg1eHB2T2JpejJ4aEZrLzZkQ0dUSnBneG1RalNi?=
 =?utf-8?B?Z1RmYjl4NWNTbnVTazFQODJaUHFwVDE2Z29lTjFCTE0wUFVaZDlYemZIbFJ2?=
 =?utf-8?B?c3I5THdxYkpPWFZPY1RNR0cvNmpwQ1RnODRTQUE1R0pBcEswVGhKVFI3aE5j?=
 =?utf-8?B?emVuODVXL2h3cHdIRVMxZkZoWk5kQ0hUYmhrSWdrVHZUUEJqNEJtUU1LM0hh?=
 =?utf-8?B?bGZuQURNR3FWT1ljV1Vkb1lmUjlBS0JyTFMvaGRIYWJmbmFXRS83S3dmSXpa?=
 =?utf-8?B?NGNHelJRcTdZOERHSG1PSXZ3SnBQclU3cFQyMTg0NWh4cWxMTDdKM2xrUkhP?=
 =?utf-8?B?U1UvSW5oSVJZV1J0OGNFWW9GY2FFd3lsRkExUDVzS3BKVlMyWEkzbUNWUjA2?=
 =?utf-8?B?QUZ6K2Q2M2dxSnliRXQyODZTRW4zT1I0bFYxd2ZoY0RTeWdaNHJ3SjFGbnow?=
 =?utf-8?B?WGtVVHBIV21PR1JRVE83c3VxY0VlcXBUaE1BdjlSbEpUblV3aW5OTTJNM2hN?=
 =?utf-8?B?U21aZ2Q5M0VadTVielY0Y3R2bkhtRHVwR3hrbkVULzlUNVRPakNNdzBMZkkw?=
 =?utf-8?B?ZDZ1eHRiR0ZpeHl3U3IxV1hDSnBJczBrN1ZSY0k4dHZEMk5hbGdOTU00aU9H?=
 =?utf-8?B?OXUyMVVveVkyN202Q1lWN0lPRGdsUGpWaGVBc090czQyV0ZuSkxQM1VkbUFu?=
 =?utf-8?B?TWk5SGMvRUt5SWxpUzBSZ3krTzU3RytiNEYwOTg2eTZQNHp3a0IwMEtuZmZl?=
 =?utf-8?B?MVA3ek1sMmlIU1BoQXBOUVpGZjRFMGFYdmZLek1sK0ZmMHl2NSs4VDhoNjdB?=
 =?utf-8?B?QmpNc3RHZ2hxOVBVOHlRT2dsa2ZhZTU1bFpha01qM2docFJkVjVScnZ2eHMy?=
 =?utf-8?B?SHFFcGt0Y0taaWJ0MXBkYlNMaE4zcHc1S1VwWDZqTEt0WE80RlF5b0Y1SGg1?=
 =?utf-8?B?aU1yc0YwOTB6WmhBVkt4bTBaYW9IS3Baeno0NWVLYXU1eHRFR0Y3bjA0YlZZ?=
 =?utf-8?B?KzNwS1MxNzZwVlQwckRJMUVyVVN1SmlwZWtFdGVid1haZ0YvUDhDMTFQTEQv?=
 =?utf-8?B?Q2NYdzluSFlITDNndEdLNGxKME01b0RUUUd5cWNGWjNXVFgxdWpCaGZJLzYv?=
 =?utf-8?B?T3JKU0ZIYmxza0p6SVZFYlBhL0FuNnc0L2hMSUZDUGRzdGpsaForaklpVnhZ?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0929f9fc-57ea-474f-1989-08db45ad7347
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 16:52:27.2268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxQ5LKX//BEE1VF07wh+P3QEwoHP3+sbFKGr9jjQO0MADWy2echxg2kNy7k5OGmFGUUMFebNPeKhdkl0Ywf53VDPH3hPcCkvySm4mTgGcTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7897
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 4/25/2023 7:51 AM, Jason Gunthorpe wrote:
> On Mon, Apr 24, 2023 at 04:52:08PM -0700, Reinette Chatre wrote:
>> On 4/24/2023 10:43 AM, Jason Gunthorpe wrote:
>>> On Wed, Apr 19, 2023 at 11:11:48AM -0700, Reinette Chatre wrote:
>>>> On 4/18/2023 3:38 PM, Alex Williamson wrote:
>>>>> On Tue, 18 Apr 2023 10:29:19 -0700
>>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>
>> ...
>>
>>>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>>>> index 4f070f2d6fde..d730d78754a2 100644
>>>> --- a/include/linux/vfio_pci_core.h
>>>> +++ b/include/linux/vfio_pci_core.h
>>>> @@ -67,8 +67,8 @@ struct vfio_pci_core_device {
>>>>  	u8			msix_bar;
>>>>  	u16			msix_size;
>>>>  	u32			msix_offset;
>>>> -	bool			has_dyn_msix;
>>>>  	u32			rbar[7];
>>>> +	bool			has_dyn_msix;
>>>>  	bool			pci_2_3;
>>>>  	bool			virq_disabled;
>>>>  	bool			reset_works;
>>>
>>> Also, Linus on record as strongly disliking these lists of bools
>>
>> This looks like an example:
>> https://lkml.org/lkml/2017/11/21/384
>>
>>>
>>> If they don't need read_once/etc stuff then use a list of bitfields
>>
>> I do not see any direct usage of read_once in the driver, but it is not
>> clear to me what falls under the "etc" umbrella.
> 
> Anything that might assume atomicity, smp_store_release, set_bit, and others
> 
>>  Do you consider all the bools in struct vfio_pci_core_device to be
>> candidates for transition?
> 
> Yes, group them ito into a bitfield.

Will do.

> 
>> I think a base type of unsigned int since it appears to be the custom
>> and (if I understand correctly) was preferred at the time Linus wrote
>> the message I found.
> 
> It doesn't matter a lot, using "bool" means the compiler adds extra
> code to ensure "foo = 4" stores true, and the underyling size is not
> well defined (but we don't care here)

Looking further outside that email thread I do see using base type of bool
is common. I will use that. Doing so also reduces the churn of this
transition since only the data structure changes, not the code. 
>> Looking ahead there seems be be a bigger task here. A quick search
>> revealed a few other instances of vfio using "bool" in a struct. It
>> does not all qualify for your "lists of bools" comment, but they
>> may need a closer look because of the "please don't use "bool" in
>> structures at all" comment made by Linus in the email I found.
> 
> IMHO bool is helpful for clarity, it says it is a flag. In these cases
> we won't gain anything by using u8 instead
> 
> Lists of bools however start to get a little silly when we use maybe 4
> bytes per bool (though x86-64 is using 1 byte in structs)
> 

Thank you very much for catching this and providing guidance. I plan to
include this change to struct vfio_pci_core_device as a prep
patch within this series.

Reinette


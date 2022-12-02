Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA609640096
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 07:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbiLBGhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 01:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiLBGhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 01:37:14 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871F39D822
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 22:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669963033; x=1701499033;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0KUj/JR1gV3YfPuoj9wF7dNtSfhkMeLfpJRnPPmKhg8=;
  b=fPQ7SeM8dQo9O4eaNN/OBHwpf0ECgGFWJx/MIohzXBvbM4R4DhebrOV3
   KTKb4cMo+Pd/iASuaKqOHyPE3XJZBSQrMiwm79ZXXR6aJ7+X/93WYKw+r
   M4+GuguN9P4V2RQmkzCwoBb/QY099/Tbkwe48RCnmR2vblzp5jZEqT039
   w50h7g1GWY1agiZPBp+tT3g3iEv8+e6Xs6PLWhjHiz03WhOvWcPTj3kFP
   c8HfYOIZoMyKSUxnKdGriSBmyPyBnTy1F6NpU+apnt7gD5UQeWBRLacoc
   z4gvnemXN4KuC+ot2zNfDNU7VD2kUBwZyOpc5B1km6lxKAv8d0oeBU9NH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295581892"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295581892"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 22:37:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638655786"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="638655786"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 01 Dec 2022 22:37:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 22:37:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 22:37:12 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 22:37:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHKKiPnQwL/2yvPDSSuZE7IORXWaZcMnnpda2X/9VlNxrkaocJYZXxMjvYmbeUXGDPhXsT5Z4shy+pyGWFT8FFNWMMh96eSliMk229aZ2PfMIh5xbJSZtz+A13XgpwCItlhsGn5VAQ0tcfGv+TI7O2sX2AcGv2vgikdVyNJyCG+ief9gWAsEKsmXZT+OsbrLPmA7jtQ9TUDb5E6OMEu7RtNB0PlXMYB2AUnnKQoKIw15LW+Ikghgy+vzGB9yAp3Cbpv9Wx9gNBwRHemI2f0X0E4BYtzZ+MRdzE7uzZ+fJzGTN27svzn9jlgPrjwWO1fmffxre3RLescd25paF2C5qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66IWaPSkjW1+m/JdBm2i+cw5tYFCVKl/+x3zOn6/RHs=;
 b=AL2IGMKAkUqDY/f26BxcAd6oUOaKDT3gjgiStony6ncj3AgxnZeuDo4SDXoWJPgDGuEdyUtxGcCjkMgdJhL8WFT4rfmhPCz60Dg8QcDH/v9u7GPudk8/sAxfuj8ff+Y3EibxsSjiKDZVBATZdZHp1Drgpe+qI5Qy0oeBoidmMZbP/opABOiw+w4K+sKGy0re5KHmSWVc3ZJdFOxVu0chCg8gXJp4McP6QE0I8WoYyBqcRlGgqydJaEghntqLyjYQGradyCtt8brNT24ngb0X8L1FGPvQuy/ChH6lywCySb3dD+aeIYN8icVa4q3ZRGduOR7KkrPCFeCMJaxoa9SZHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by SN7PR11MB6852.namprd11.prod.outlook.com (2603:10b6:806:2a4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 06:37:10 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::df5b:7a63:f34b:d301]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::df5b:7a63:f34b:d301%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 06:37:10 +0000
Message-ID: <436de503-071c-f872-3350-483f3594eeee@intel.com>
Date:   Fri, 2 Dec 2022 14:37:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 06/10] vfio: Move device open/close code to be helpfers
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <20221201145535.589687-7-yi.l.liu@intel.com>
 <BN9PR11MB52768BAD331C3733CD0D91978C179@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52768BAD331C3733CD0D91978C179@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0116.apcprd03.prod.outlook.com
 (2603:1096:4:91::20) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|SN7PR11MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fb678a5-df7f-456d-6a51-08dad42fa3dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t82xHPiAgRdYkVn2OaSldizps1rP+cqosRHNYo/SnHdM4n3/SCDaPR9eBcCE5EvJ3KmPfXEPkKaDH3P4fD8ch8jjT4ZlQUXwlMVwJyjV9BTh5b7joFmVYI8Fn5o2MVOXScXyvsEmK6rFwIRzMPG3+VgX5Mt9ZxJ7OftTTnq0zNf/Dm0EBVmwe6zbcsrdLMZ0ULX2WKL9pd3NURtGOzz2mGnCqSJw9ybgDhUDI9i0YRujC2L9uypOdBQ0p23PJjY0fdpTBR7eMLfKhTReyZflj7tsGt/xe6T0ax7AFfgQ0SvA8S69D1d4glpsk4CSHtLdtcxOiHbCpL6y9b7gV5OB4XQDOr/rIO9OkTMEMQieKShelXEqcqvHW7mgWUowATrVYkWMvmP+Tcvvd/aDr5v2XzkfhXUDTt+nXHb8qYa37mzqn4c3E59S7QqRI8azNZc/POid81QSoiLgg1W4N1gtFV1MhXNtyUR3BEqGfMK6T/LxdyEjCdc2gqmQ+T/RgBGLYJqANJ80sHlk0s08y6ScCVfsnEjEWziyGdPmXwUcmwQUvp8lfIpM+jYIkjqckKMif5xSn+htc4OIs7/C5H0DPPF4C6uJ7d2yZ8cAKnmJFgz6kPEh6oiLj//LeO8uyaTkNFXnxJ6EfPm6DsDRKN69li1jQKG/Whg8LZyiBHWqZIwjlqriO5KJDLsrbNoHTLxN+d3uRyevMQc2bRpBBJC33SN2WRBZBofuMuyobCDUrxQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(478600001)(6666004)(186003)(6486002)(6506007)(26005)(6512007)(53546011)(31696002)(54906003)(2616005)(110136005)(5660300002)(8936002)(36756003)(66556008)(83380400001)(316002)(8676002)(86362001)(66946007)(66476007)(4326008)(38100700002)(82960400001)(31686004)(2906002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXh5K0ZjY0NjamN1eHBudzlaVmNhQVU1MlFOMXdhSFRORmRHVHBFY1ViSGlE?=
 =?utf-8?B?ZFl6bTBmNkZuVnU5MnRZR2xWNUVtZ1J0Q0UyK3JNeWJ1YjZNU3lsWGY3YXF5?=
 =?utf-8?B?dU5XRmVFSldkS1MzS3ZZRFpBWHVNZTdYNjBpWWtYZk5sbmVPblVkUTFyS3pY?=
 =?utf-8?B?NWZTNWh3RENtUUx5T01UWmNDbmF2c1krZGdualozTEREckNJYStMRjZVY2py?=
 =?utf-8?B?dUlHUG1oR1ljclY4QXNwM3M0L053V29UM2xLMkhrLzdPWXVadlY5TG1JcjBY?=
 =?utf-8?B?Q3ROUGRuWUZZZTlvSEpXSTdyVVAyU0N5eEFmNGk4NUEycWlxVXlweEQ2amVp?=
 =?utf-8?B?cnBRMStHQ3lHNEIvVno5UitLUDBDZiszcGs0UENub0Rlak5HWW9aNnV1cEVy?=
 =?utf-8?B?TXRMaElqTzhKR21FblR0SG05eXZpVDVCdXFManJPbTgzQ1ZVOE40TlhzcVdH?=
 =?utf-8?B?bUxGZzhMQlFqc0thVXRtMjFEZ0ZTYTNWaUhTWnloSmFRcm52cGRvWnZTa281?=
 =?utf-8?B?SUV2OVg5dzNVVWJXWWRnQ1p5WGd6d2NIUGpZRXF6QkN1YUNVbUV0dDV3M3pR?=
 =?utf-8?B?dWh0SnplVjY1cnBEbkwvWjFuaXMrNTV5Um9FR2tIZWM1TFdJSmZzMjhkeEdP?=
 =?utf-8?B?c25MVG1HTWxwaVRvU3dpVXhJc2tRamtzQzdmb0ZLS0ZKMy92cnBBVHo3aU1Q?=
 =?utf-8?B?NFFnKy9JbkZ3L1RJbUZKTFYzOWJ3aWNnZEdIekxOTGpSbjZFckwyeWtCYzgr?=
 =?utf-8?B?a2xDYlo4YTBrSFAvYjNtUEQvcTlmMWsrSGJMOUl5RGQvZjdGRDJCakc0Uk1k?=
 =?utf-8?B?UVJwQi9mWTdZa1hrQXI3UjMrZGFZMnZvM3dENDdaNWpWbzJKRnNWMlUxK0dh?=
 =?utf-8?B?SStxQ3lXc1Jhcnk1S3JSVnBtaUlBUExIMFpkNDVDQ2JpdWgwN2JzRTRTbnBR?=
 =?utf-8?B?WTJYSXU3eUdqckpkT3doODUzTWJyQUR5NzVqTWRnaWNtWFVzRU9yS2VJRzdZ?=
 =?utf-8?B?SWF6SUZLZlJFL3pGTVJmOEQvQUNxUXR4VkhFUmNNMVpuWkNjckpsbVVGSWF4?=
 =?utf-8?B?ZmcrUjUzdHpOK1B2QXBHRmh0UWJ4aXNKeDNsc0R3QlU4dm0xcDZ3YTkwNHFP?=
 =?utf-8?B?VkFsdGxPWVFqbzRLMDVFZ0Q2TFZGNVdsMXc0VnkwRjlBRzYrRWNqYXBiQzNS?=
 =?utf-8?B?Ym81ak1DbHBiaS8xUGg5TXhNdUtoNTdsOXVGbkJLZmhWMXhsQ1B6ckIxQ1E3?=
 =?utf-8?B?MmZZYmFHY0tmd0J3blA1V3pDZVZYZ25rVExGUWFPeGl3MlVPNzVXY2lIRkhq?=
 =?utf-8?B?ZEVMQmMxTTMrWmtXSGlHRlpWUWpORmVyeVllSXp0UDVONDA3MnVDUnFYRlBH?=
 =?utf-8?B?V1JrQkVJaFdhRFFPaytyeHRUSWVtTi81djFGNmFWSTdLQkJWM1dXWXozZkpw?=
 =?utf-8?B?elYxbzFCRTRPMGNKTHpsbWMzZzhNQjNxeGoydHQ0dnE1clQ3Zjc0Wmp1MHdN?=
 =?utf-8?B?Z1RPbTJlZS9Db20zUmVReDVBVGZ0ZmorUzlkeTN0ampCRTZSZ3ROa0FtOXNT?=
 =?utf-8?B?TkIzTEQxVUNDY3BhMmRaNWNwUTRUbkhWWHVyUTVSV2d3RWxTNk1lMWFCRTBm?=
 =?utf-8?B?MlorTkxiaEIyNk9BSVYwT1lkdEU3Y25FMzdGRFRmZXU4R0FxdE9NRmpLZllF?=
 =?utf-8?B?SXc3ekRhdmFNZERUZzh1L1poRml4VHF0RXZiL2RpdndIMS9HZkN6eDRIaVZU?=
 =?utf-8?B?L1JJOGNVeG1uQU5ueEtpZk45UXJTcjhJenN1cjNRczZ1bC9FVWJZRllvSlR0?=
 =?utf-8?B?ekZwd3J4R00wN0MyZ3NQU0liRlJYNmZhZTNKTDRuS29pVlM1NkxuOWZRdGp4?=
 =?utf-8?B?ekJLYm9aTlJqK3ZzZXNhdUJBQVJjdlhvYm0wMlYrc0Mzdjk2RDJiTVNPNlpW?=
 =?utf-8?B?ZkxBb21VSndvRG5ka3hmUEZVbTRHT0hkd1FCQWx1WFJZY3oxZVpxNVE4SXc2?=
 =?utf-8?B?N3ZoQkt4WkpyQmRQbElSb3JnL1pHU3N1cVZMZmJ5dUFqL2FiWGRuSXByN2Vn?=
 =?utf-8?B?czgraXFCSFpSUWJCRUtkUjVHUE5TOWhRTUo1YndFQ002YzBuTWlVdXFwNktq?=
 =?utf-8?Q?eQeUEtH25XM3X2eFpNsXrFL3K?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb678a5-df7f-456d-6a51-08dad42fa3dd
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 06:37:10.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8OwGzE+paejOB4navW766ZEObJi9UGuQ8GJ0xqC3zElT9jDcsnXu4KXekEihNgbezHVLQVkVGqrNxGG52z+AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6852
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/2 13:44, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, December 1, 2022 10:56 PM
> 
> subject: 'helpfers' -> 'helpers'
> 
>>
>> This makes vfio_device_open/close() to be the top level helpers for device
>> open and close. It handles the open_count, and vfio_device_first_open()
>> vfio_device_last_close() do the container/iommufd use/unuse and the
>> device
>> open.
>>
>> Current vfio_device_open() handles the device open and the device file
>> open which is group specific. After this change, the group specific code
>> is in the vfio_device_open_file() which would be moved to separate group
>> source code in future.
> 
> It's clearer as below:
> --
> vfio: Make vfio_device_open() truly device specific
> 
> Then move group related logic into vfio_device_open_file(). Accordingly
> introduce a vfio_device_close() to pair up.
> --
> 
> With above:
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

thanks, I'll update your comments into the github branch.

-- 
Regards,
Yi Liu

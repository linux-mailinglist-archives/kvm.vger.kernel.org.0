Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4343A635F53
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiKWNXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiKWNXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:23:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409DE5E9D0
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669208651; x=1700744651;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+W3yZKeeU6qMW3eKgL6opuYZXjbOc5Kr0vSJShmyjzg=;
  b=Eu+DoHmSSdFtcTm7l+eWlLnqZD5k7e6J6+GaMpei/jIcicEQSKGJbJ/g
   B1qEt68gtEv4G2Fpfm8HtIbBQBH+rWuKCouDIzOt1AtyBJnxX5iPus0mF
   +TiogltvFT/0MqLpIXNI43NuU6sw7lNYGrP+VDlRPIRoP2w49ANSMkHEp
   FnsL5Sha6/405UipRgW+Q1aNssllHl/H5siki5TnLiEZOuS5cj0u4WzN0
   i65nUgTGG4+Uf6hV5QvmV1uLmfznat6rM2rj2S5kWUlhjjfnClN9qJZRV
   w4pE/F06W9VizR9Vw8Y9ms4Iw2lh+4iA4qzwT5XKq1ts9kwsBldFmBv4r
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="293768743"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293768743"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 05:04:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="816471999"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="816471999"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 23 Nov 2022 05:04:10 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 05:04:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 23 Nov 2022 05:04:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 05:04:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHu1l9jjhDSUZ0Ko1joGEU1PVXVK+GFT6uQIJ7C8EgsyCoIUlfJnqOodCZ79DMDEGamKHLNNyNzEsrSXrQ83fYH2S+whOVdLvRKWdSRJDfDRuu+q94v5gS8LgSJcsTKgSLPI3t4zeTwWneo+LjLynvrAPc0ndf8IbHw+glZZw8MadS3Uw0mXHmMSUMPO6iSjZcA6MVph/Ur2nWCaBzfAgiPiGAGcb1uQG5H0hnXUumtdjCwnm7PgRHbHueGVy7eWA6s0OXZPnnvls4mc1LzlueUyQiY87vHLEC8G1v8plcf06zcVZEkSHwa0qnmshliZ/WxJrmlZpFBQ3ljdc+sSRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdrobOLFvvNWOCDPhcKR16ZHCxRrO/qBtNpXJN1upI0=;
 b=JG0lxi/bUrYEjCgEq/OTsw9B9ip8ginTwBXX7EjTshjH+CpY4KtBqGhtPnIOfhZlb8NyId/ty+qcnallo1xzj1zWNFM8Cx50cLJppVO2roIRsQC2dM0HEDPBZJXgbZk1FblTFqxvx1+wSBBqNA40beOpw+o6rPR/S9ncqqIUfGgpl1mT3zOTbq/+u+jISKD3J6AsRQzfBVBQwHsEi3lZ4ZNQXg0oL5BIQLZM5vMq43o4M3UUgptLvy1kTFqu5zYOFdXklWCCtTY4rP1UpckAx0TQaKvgk0ytKP1sImbNhvvUY9Cq+tp+1ljBbfChcje/OmkatUO2CyPmSgmk3CHILQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB7117.namprd11.prod.outlook.com (2603:10b6:510:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 13:04:07 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%6]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 13:04:07 +0000
Message-ID: <063990c3-c244-1f7f-4e01-348023832066@intel.com>
Date:   Wed, 23 Nov 2022 21:04:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v3 00/11] Connect VFIO to IOMMUFD
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, Yu He <yu.he@intel.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <b35d92c9-c10e-11c0-6cb2-df66f117c13f@intel.com>
 <Y34ZTYah83eE1tm9@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y34ZTYah83eE1tm9@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:4:197::20) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH8PR11MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca95565-6bf3-42ee-e1a6-08dacd533496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMMawFPGrEe9ywBhIhLyx0uVyIu5MzBqKqUG97TxnXpTd0pqfL8iqw183nRyXSpNk8PJuoBYhwP/3oAv5WLkv8MKndPQRijW9vLDBCSf3eFODbbEEOAMdUwRVUcJ71oRamraJRPutSiU8xr4zc06CNzsjoFNCl2cLPq1MqnEYU0LQdA9H3xEW0+mtTsOW/iJ/kvBlqNkPV7E8gpwieExVYcSVzZvWnCiZGNlsJ0CawSLf8LcCkSqJnwbYdG8VjMMxybdbwNmj3FNJAJrq7lwLHwyClwzL3tdHgdKqnAunQB63JTpR/Cr1c7FKNuEsvJcUGu7cdDnWuJ/GVNAnRU8Tg8Fmp8IGPSXCjjV88fJ7gjpyZgyRKIiJ68qbgNaHX0EWkKZ+6HBNGwqxztS73qNOWH4ktYpfABoCqWNu4DOEPigmnN4ZLViuEc+mZWxMYdWgAbispj8iF3kmyMe4WjgSFhIEjjYZsK95xW585btmR6vZ6mgq5uotzdTk6/O9HwGYZzR81H3KuYbgZZPBAwc1FXl/WlasQcDYt+xzygqGLZ7lYjAcfirrUG63WFETMFVKnCae1ONNgMmdU0rFVu+VhHkmqohYLHZfL8jyX0ilCM8QmDtjZujWWf2NviHODGqz3egUbu7Fs4JllBXBqamnk5nZ2feFlDDphfjw0/E/sSjSWTgxOUtROnMr3omuUcRRvm60bLUFp3hFOK8Q4sr05ZBpEb5SIGTCp5fv71jxvJ/SmEVowar71tTad906P4tLdQVncNMDZWCJG073oJ3O0fl/bwva80iDPcRlYqWKv4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199015)(6666004)(6506007)(6916009)(6486002)(966005)(53546011)(478600001)(26005)(316002)(6512007)(4326008)(66476007)(66946007)(66556008)(8676002)(54906003)(82960400001)(2616005)(5660300002)(8936002)(86362001)(41300700001)(186003)(31696002)(31686004)(38100700002)(83380400001)(2906002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGplcHBwcjdhTjV0OTMyOXprc3hVdk55bUxGNVluaG1mRUtjdm9WOGtOUE5S?=
 =?utf-8?B?UDFRK1E4RmxVZXFJV2IvQnZhR3B2MEZHeVIzdkdidHpDOGJDSGRmYzdxbEN1?=
 =?utf-8?B?Q2Q2RGlpS251NXFsMDNuUnVlWE1ZTUdNS2xyejV0bWZMR2xwZkczUlZLaS9P?=
 =?utf-8?B?VmZzRGsyZFh4N3l6ekVXdW9Qc3E2YUNMWURMVWo3RSttcEJZSUtoVkcxQzM4?=
 =?utf-8?B?d25aWGk3aWdMMm53U1gxY3B2Y0g2Q05zSk9jQ1RJTkQ5U2tKMG90VE5PaVZm?=
 =?utf-8?B?czhia3VGL3hzOS9aT1Y4T08vSXZpamcwSzlWajVXb1dwYm9uS0I1QWovZWZT?=
 =?utf-8?B?UVNVNFJKWktWbGNLeDArN0VKdGR2WTYxOHpla1Nab3I5K1VscDNsRjNXYkRQ?=
 =?utf-8?B?NWwwOWVLN3U4anJydDNOZ1NnY1Y3aEx5R1Q4d0ZWbmhkTU0rMXNUQVFxeTlt?=
 =?utf-8?B?a0VwUVNCN3hYcTdGdVI0ZUVqK01xVXBGalF6SG1wOEo3TXFJQ2ltb3BYRWxK?=
 =?utf-8?B?a1pCTG1sTEZwd1pFN25aYkpKMEdDNU9uN2ljQkNEU2dSZUpScWRoRjVya01p?=
 =?utf-8?B?N01ZUmIzVU9DUnFvRVVQUXdOTnRleEh2cnNkS2lLak9ZQkpJZkp5eUlmZTM3?=
 =?utf-8?B?cmE5ZGZTMVFLS2lSRUV6d1VWUUQ3WnZuTjNGVzhYVkxpNnJhMnhQcVdpL1VX?=
 =?utf-8?B?V2MxVlpSYVJjMEpBN2ZnYkR1SFkvM2IzNm1jc1czaWdaNzM3cmU2ZlJ1bkI3?=
 =?utf-8?B?NmhycHlJOGFGT1ArUW9FRXR3aVgrczkxM29MdkZGWHJaOWFCVkxvb3ZGK2VF?=
 =?utf-8?B?NFgyUXp5QVZNUHYyVkx3NU9yaUhmOGsyMlVSZnF3OHVDUHpXSHpzSkhHaUtu?=
 =?utf-8?B?UGtlSEZjaVVXci8xampKejlTNEJXdTJkRnV2cDJVU3MybjdvZW5rOFpZZmhQ?=
 =?utf-8?B?ZXdQUkxjejRMcDBlekhRVDZwLzIzUmg2MWpBc2pybmdhenNmbE8vaTU2cXVX?=
 =?utf-8?B?K3ZGbkpxSklNWjRwckw5ekp1Rk9hNEo1RTlWSEIrdVlPY3l5Z3pqZnY1dW9i?=
 =?utf-8?B?ZW1CTzArVkRIUzNkY3QrZm11cVN6SGdOdEFmWkNyN3NHZjUvQTVNTlI2d3BE?=
 =?utf-8?B?aGp5RkpNQnlnMU01d0w4ZUVGL2libGR3MTN1NlFOYXA3VmFsL0pVRzJwdzBL?=
 =?utf-8?B?TXc3bFpmZldFczhZZnlnN0pvc1NraWRRUEFhTGtXQmF3Y01KZlJld2M4WUth?=
 =?utf-8?B?b0R1UUMwN09NN0RoRE0rUGcwcWczZW9SbWgrVmRSeEllZUc2Mlh1c3lVdjRV?=
 =?utf-8?B?RHA3b1ZrR09Ib0hWOXRDbXlVTUt0V0c1NTl3T2Q0bkU5Y1NKQlpzM1Ztb2Nh?=
 =?utf-8?B?SnZza3BuRHdMenJnS0RpR3FIQnN5VHVsaVhjRlh6YVBOdDd5RnNZY1kvZ2ZQ?=
 =?utf-8?B?cWpraWx3QXpvWDl4U3hXVllOOFZPNG1rdTBiaEFOWGlBNmJ5WGs2dmVHTUdk?=
 =?utf-8?B?THhhdmNhL1l6SzdTQWxFUzNuaHhIMEx3bCs5d0lNVjJ1clVWRWFpM3NvMzJM?=
 =?utf-8?B?OFJYSC8vNnR6MjJYYk5HM08vWDNUL1MvckNwL0pqbjVLemJoRTVVSU5pOWtp?=
 =?utf-8?B?bWF1cWsvbTRxNENBaTZUdzNSV0Z5VERKTkN6b0I5dVJMUGhRQjdMN09VOTNn?=
 =?utf-8?B?Mk1LUXN6a1poM2VMQVRjM2ZORU1rYWNscCt2WldLQUJwa21ic3VkckxDYldm?=
 =?utf-8?B?aGZVRS9JUmxuVnRuNUFrc0VkUUl6VkdpYzRGWnZaRmNOZE1sc1I2N1l6ZFpi?=
 =?utf-8?B?Skw1WlNRcnlydU51UnFFWjBmandUY1NPTzhvQUNoODM0MTUxUWc2bWhIQTlX?=
 =?utf-8?B?UnIzREYzNk5TOEp1RVlmNVdkc1duSnl0ZUxuZ0JsdGtJL0luWmJ5eFJSNjdj?=
 =?utf-8?B?MU1CcEZxd1lEeFNXenpmVVNiYjBHeHhWcE1ocGtUSmpLdUYxR1dsVnVJNEpa?=
 =?utf-8?B?WXlvZ1JmY1pUTGNGOUE0REJqWEZQZ3lDTC9EODc2RndiOXg5aWFIeUhmWjkv?=
 =?utf-8?B?blVTZEJ3RnJtMTF5akxFK2IwZ0pwSUJQejBZV053dzRLcHh2TzhBaDR1aWdM?=
 =?utf-8?Q?nSgVkftNUq8eb54Z0bpyiIjwy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca95565-6bf3-42ee-e1a6-08dacd533496
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 13:04:07.5410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0C+7XVsM/PRWcM+Z2C0YLU7923oE6YQyeMBGOsvv8t/DXOcShDyZXYSsdSBP5DLqeKQCfPGtya7PK2g/YLVM5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7117
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/23 20:59, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2022 at 10:44:12AM +0800, Yi Liu wrote:
>> Hi Jason,
>>
>> On 2022/11/17 05:05, Jason Gunthorpe wrote:
>>> This series provides an alternative container layer for VFIO implemented
>>> using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
>>> not be compiled in.
>>>
>>> At this point iommufd can be injected by passing in a iommfd FD to
>>> VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
>>> to obtain the compat IOAS and then connect up all the VFIO drivers as
>>> appropriate.
>>>
>>> This is temporary stopping point, a following series will provide a way to
>>> directly open a VFIO device FD and directly connect it to IOMMUFD using
>>> native ioctls that can expose the IOMMUFD features like hwpt, future
>>> vPASID and dynamic attachment.
>>>
>>> This series, in compat mode, has passed all the qemu tests we have
>>> available, including the test suites for the Intel GVT mdev. Aside from
>>> the temporary limitation with P2P memory this is belived to be fully
>>> compatible with VFIO.
>>>
>>> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd
>>>
>>> It requires the iommufd series:
>>>
>>> https://lore.kernel.org/r/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com
>>
>> gvtg test encountered broken display with below commit in your for-next
>> branch.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?h=for-next&id=57f62422b6f0477afaddd2fc77a4bb9b94275f42
>>
>> I noticed there are diffs in drivers/vfio/ and drivers/iommu/iommufd/
>> between this commit and the last tested commit (37c9e6e44d77a). Seems
>> to have regression due to the diffs.
> 
> Do you have something more to go on? I am checking the diff and not
> getting any idea. The above also merges v6.1-rc5 into the tree, is
> there a chance rc5 is the gvt problem?

that is possible, I'll let my colleague revert it and try.

-- 
Regards,
Yi Liu

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906397D5342
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbjJXNxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbjJXNxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:53:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F783269
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698155355; x=1729691355;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YMZi4eJ/TvV9CaZcwzTUhNFqFZCXCw5rrpvjnVRZIMc=;
  b=BZUTS9SDoCUmIjEpDUAL+dfD6FsteXTOFZkiHw8yAbA99YPVc+obivWs
   i8GmtEWfVjvbcamDH9Pf9kS37Ij3kaCmMcSeDQKi1wCO5lw01fw2pAcK+
   xscRKTHwXMHhnuaMFSWZp/UMYJoCeAGTU+Xi7fOd2C3Zhkda5+DaKG1K5
   ITGbHTs5wdTYBWiCrm0sldBDo5T7nKAT0xCfH66v4HXCOGIVs7h+KmDgD
   Ykvj9hAXBrVJGFAAI3sEonH7xN3IWp5sN+mKHaruMZUKxNebSpCoEoAxU
   EA3nZcrC8cBHSkZollthCS3YlKARvRIZdhcOi7w7YAjkRKi+DwDjcPcBJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="384257292"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="384257292"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 06:49:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="708288005"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="708288005"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2023 06:49:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 06:49:11 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 06:49:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 24 Oct 2023 06:49:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 24 Oct 2023 06:49:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bF6ps6/bTqwtLDReEyVgzn7L1v2tLSpr5suE6XB0jQpapI1AyjoiGDD76JByadqAFxUTztJA9rYOdPUuBKQLlMTw2X2t6sXf3+Ohj3rz23c5ftu5qnkjSZz+IN0bJYTpvKCFm08wUmnMnAqS+9sQ0U6/oKpo576Sb065lW9hKyV52Ywt+K7exOjr68tag3hKdy1Z0R8xvAzyQe7G2P4IZ7ezv5UQ19/HOfg84qvye0rWkl3GhDUQqlA274DBLu5rXH1R45jWkmnWgqV4HgzjU4H0mkT6WNmil3SnHGqKxF/PPC+Z4qoOq//a40JbW0AZvnt631EpN3HriArZR12Y8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kswplIOogXyVR83ijfJzOBLIRi9R7rnfpW6tT3lG4jY=;
 b=ZGRo4KXl/OEl1VrogeOZ/aNG8pMHcuL61sf+ZqvmoqcdWc7FwqDdTQ0ifJPoZJktJjhwl78AR9hG769SA/Ny8lSG86SGU/a2yzkxe0OU8maGUmphV7gMFRGd7jXCobP0UN5c3L4VuPj0AStUmRyoO5i4iJfFiQXKkNH2KhkxlLyh3eVtYvOAzEMYaLZspqIDYKQIq3+XvN/0O6UMwIGG0boekoh0hcaYWvHaBjm8/F67sza8yt3aeMsHSFpVauoxQc9n9J2xFnopYjinNj6TH8cq0qgwzcBXZXaVMAVPp7N3sX7tZyoBvaq99z29tn7Qbblg++EzZ3Yt0aFcTshnaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7768.namprd11.prod.outlook.com (2603:10b6:8:138::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Tue, 24 Oct
 2023 13:49:07 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::f8f4:bed2:b2f8:cb6b]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::f8f4:bed2:b2f8:cb6b%3]) with mapi id 15.20.6907.025; Tue, 24 Oct 2023
 13:49:07 +0000
Message-ID: <d24d7ca6-4ff3-492f-9492-e830c4180057@intel.com>
Date:   Tue, 24 Oct 2023 21:51:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-13-joao.m.martins@oracle.com>
 <ad8fcbd4-aa5c-4bff-bfc8-a2e8fa1c1cf5@intel.com>
 <2b4beb4c-3936-4a75-9ecd-6d04e872bd90@oracle.com>
 <61c0fbad-b441-4a8b-968e-c3c36f18e8bd@oracle.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <61c0fbad-b441-4a8b-968e-c3c36f18e8bd@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: 9994e37e-f857-45eb-9f4d-08dbd497fe35
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VYoAZI50ZyIl96Yzr7gUHLy84SEvyeXZctTx7UKp++t3wdljfQEjDnRcQDIZP8Zpc+bR0SZkBOIC82s+iXgqZAxDPqdTYEA1vfcKi+nSClJX4j2UqAHSAxxKdrPYgl5MzMxb1d9SnA6cLBi9QrSmyi3gYXo1QulrHApqRF6gMYhJEFLEtutaukwLTrf3UacmmleQMZD8AxcXLz0JnbfdUWV+O4Z+rV5jFnyj/BUx56XV9V3lcfH+dsl3hL1W9hSomDK+AcG+KUKabYAm2r+xWyXZTgwElwUZIWm8sx73Hy+bsbDiZsBiXDzqrAFiCotNVbjxpi53NR41QKt++wxHlaN8ik5rXLp2uweFVc6EKgHfqtDfz3qdMmoldB5amiu3TdyEM//vELvEUtpSardyEL4cG/oNV+PA0mkcPnXM8Lpiyy8ztSZ4LtCXbE4lc/JmrumSSbI1OwAf33Mrx02TMKG3t4xcS7YqBuYWl8XY02FELT8g0XF5r0Pq8fohZMg2CWxsEAyfNVVsZ9QhGBJ9rjqhpfnscV5cmGGpG+xGRBcrl0lE+0mXLiB3ao/SXm5rk8UvfL9mOlbfFRrDuMge645x/UmHV+E5esbyDFWY/5jojb33ilQWebGSo0WdOAfdESPQasuCNBk2TaqRK0l6pt6N8OVXZCANrVTuPNTLZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(376002)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(6506007)(2906002)(38100700002)(316002)(66476007)(66946007)(6666004)(54906003)(66556008)(478600001)(82960400001)(2616005)(53546011)(6512007)(6486002)(83380400001)(86362001)(41300700001)(4326008)(5660300002)(31696002)(7416002)(36756003)(8936002)(8676002)(26005)(31686004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTR5d0Vhb1BwWHZXejlINVZIQ0ZRYWxqa3lzRFFPSmVQRDEydHlBZWoydVRY?=
 =?utf-8?B?THU1VDRnelhTT01leHdWNmxaSHpwUTk2dTZueVg4THBUcWtXZXZYdmRDa0NB?=
 =?utf-8?B?YlhhUnhXR050amxVQzQ3SzNZUGV5MmFxTm1ERVNoc0N1b3hMaGdiSkwzMzJC?=
 =?utf-8?B?MGtrUmRCZEtKc1I2UUFGWWlQbGRzVHoxbjZGZzRqczVRWDNtZHNNcTl4NWIy?=
 =?utf-8?B?aE5xTmtlOHc3WS9yd3JieTBlVG15Rkh4WVFBbElOVHpJWlVncVE1cDAwc2hR?=
 =?utf-8?B?RFZjQ3JtVDVhaWcyUVNJRm1YU3VFZVlqVHYzbmJkblphL29wNWpjTHgvTXlO?=
 =?utf-8?B?QUttOUE3OFN4NkZNK3NzTVJUZnZhNFdyZ1lTREZnNnVkUmlIalBNd0lzRjlv?=
 =?utf-8?B?WW5lQ2lIQklHaWtDdGtLL0FXSlVubGIvcFkzUlZJVDdiQSt5ejlDM3NPaGpZ?=
 =?utf-8?B?eFZVZnVrOC91RDdremtndTVVTUtVQy9FTy9NR1BXcVpLQnkrWkV3bnNrbnph?=
 =?utf-8?B?b2xaY2hVSFlDUThaQjVRVUJ0eUtuQi9DdnByc1VDcjNOdzNGUFo3ZGpXWlBM?=
 =?utf-8?B?cGtPb3ZZR3RJVDcraHpBVGVLRzF5RTJZdEtES1RnOEszSVd0U1JCa0pqZWxG?=
 =?utf-8?B?aExqOTZDWEx0MUhDLzM0em0wWXVRTC8vRHlqdy9JdDc1YjZVWHBkazMrK1NV?=
 =?utf-8?B?T2EvS0VBOVJEMTZZYTRWNEt4WUE0bUxhZXZLK1VhU1U4azhKSjFYMUQvTlE3?=
 =?utf-8?B?R2FLdGZvbjlVZU1vYVlJbUdKcnc0emRiMThJWG10TEVVWVdtM1d4dkQ1aVZn?=
 =?utf-8?B?bG0vVUtxSWc1ZVZUV1l4Y1hVUTlnbDQrakZMYkR1SUV6UEpkYm9Qam0veVhY?=
 =?utf-8?B?cHplUDVEZE0wZFoxaW5ndGdSUEVqU3FEaldRZnJDNUhDREVQaEdaNlJUQXpF?=
 =?utf-8?B?S2pEUVljN2Z4UVBlcHBzWUt6WEw4VVI5ME5mNWVwWGdibFVQZm5FSU1LdlpM?=
 =?utf-8?B?dTlyUG0yc1pRZnU0OWh2NHhRQWtDdWJRSERmZWhmVWlweWpkWGJxTlBqNGRo?=
 =?utf-8?B?SW5senNiQXRVY21kdVh5WStQcmtHRE9mQWNBa1BlemVscFN2VlVxZVdjWk53?=
 =?utf-8?B?YnFMZjlWWGxzaUk5VHJKbU9sV3dyWlZpaE1xY2s1MWxhbWFVWGs3dHF2YWRG?=
 =?utf-8?B?b3NFSGtyeURwWGZWS1UxMzJSVW1YMXdRdTg3cGpZdzVmQW9TVXJaVjJxNTha?=
 =?utf-8?B?U25ibjBBb2M3cFR5b1VIUDYzNGgxdVU3bEl0cm9raXVyVEVLeVMrRmUyS1ZN?=
 =?utf-8?B?UGdZdzhtdjNub2JWaGJZaXdmb1ZseEJBT294cXdqa2FQcGgvRmJKUERMUzFU?=
 =?utf-8?B?Y0Vka0ZPbTBSY01saXF2ZkN0aXBYTVVDdGt3ZFAzNml6RmlBQTNPRW1NZ3Mv?=
 =?utf-8?B?MS85eGxlVDh4cmg4cnZBcU9TbkRXZTFQUzZHd3VzaXJFUVJOOEFYNGdBa1NG?=
 =?utf-8?B?aFl3b3dCdEFYYU4rRzNjYjdIdlI5Q1ZNci9SNzRhdXNCTkpjbnBiQ2JqaGM0?=
 =?utf-8?B?SzhPSnZaczQ0MUtGaFQ3c1VYUEwrT3VXclFXb3hmcDhReTllSUxJdW1WbDYv?=
 =?utf-8?B?eUtSWUNqTjZXOTFsZDhLSEhCSFR5TmZlRXFzdEthNVZwM3RSR00vSlU1Y0xk?=
 =?utf-8?B?Rnd5S0gyTU1jdDZCWk0zN2lSSEVueGcrMmVZSCtCK2VYYXlFNmRFY2VpMUxh?=
 =?utf-8?B?YWZ6TmNrVWgzVHg1NWNSSkpwYlZCZnpObGJMS3Q1RGZUYU1sUWpITUx1VDFr?=
 =?utf-8?B?Vlp6NmszaktyOC9URzNDUWc3SmwvVkFRZlpET1hEL3JOdkoyQjBhWXlUSmdM?=
 =?utf-8?B?YXdhQVk3VG5ld3JVbDdsbnR4bWtiQUpsOXJsNWVHUkdZVXRTMkptUzFCVThJ?=
 =?utf-8?B?N01KbThPcDVGVXorNzBqaU5hK0RjN1JITHcyWFNieWlFdGttb2tTeVpteFZo?=
 =?utf-8?B?bjg4L1NqRTZja0ZuZ1NHWTdZR2ZHZE1aRGhKdGUwU3QrUTl1c2hLek5oV0Ry?=
 =?utf-8?B?K1RpWi9HakpZajFrektRVkZJWHN0M29tYnhOZUJyZjUrODF4MzdPOEVUR1JK?=
 =?utf-8?Q?uwJiAbdUEngN4k/Lautq5hzS2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9994e37e-f857-45eb-9f4d-08dbd497fe35
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 13:49:07.6839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBb9LL4yKjbwS0N+WoYc51aYV9VSRx78VT1nYCEjXN5EwgGzuuLTo4kfRukjAbxpV4E4e0HaCv6KMxStlB+zXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7768
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/24 20:52, Joao Martins wrote:
> On 24/10/2023 13:42, Joao Martins wrote:
>> On 24/10/2023 13:34, Yi Liu wrote:
>>> On 2023/10/21 06:27, Joao Martins wrote:
>>>> ---
>>>>    drivers/iommu/intel/Kconfig |   1 +
>>>>    drivers/iommu/intel/iommu.c | 104 +++++++++++++++++++++++++++++++++-
>>>>    drivers/iommu/intel/iommu.h |  17 ++++++
>>>>    drivers/iommu/intel/pasid.c | 108 ++++++++++++++++++++++++++++++++++++
>>>>    drivers/iommu/intel/pasid.h |   4 ++
>>>>    5 files changed, 233 insertions(+), 1 deletion(-)
>>>
>>> normally, the subject of commits to intel iommu driver is started
>>> with 'iommu/vt-d'. So if there is a new version, please rename it.
>>> Also, SL is a bit eld naming, please use SS (second stage)
>>>
>>> s/iommu/intel: Access/Dirty bit support for SL domains/iommu/vt-d: Access/Dirty
>>> bit support for SS domains
>>>
>> OK
>>
> FYI, this is what I have staged in:

sure.

> Subject: iommu/vt-d: Access/Dirty bit support for SS domains
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 4e25faf573de..eb92a201cc0b 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4094,7 +4094,7 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>                  return ERR_PTR(-EOPNOTSUPP);
> 
>          dirty_tracking = (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING);
> -       if (dirty_tracking && !slads_supported(iommu))
> +       if (dirty_tracking && !ssads_supported(iommu))
>                  return ERR_PTR(-EOPNOTSUPP);
> 
>          /*
> @@ -4137,7 +4137,7 @@ static int prepare_domain_attach_device(struct
> iommu_domain *domain,
>          if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>                  return -EINVAL;
> 
> -       if (domain->dirty_ops && !slads_supported(iommu))
> +       if (domain->dirty_ops && !ssads_supported(iommu))
>                  return -EINVAL;
> 
>          /* check if this iommu agaw is sufficient for max mapped address */
> @@ -4395,7 +4395,7 @@ static bool intel_iommu_capable(struct device *dev, enum
> iommu_cap cap)
>          case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>                  return ecap_sc_support(info->iommu->ecap);
>          case IOMMU_CAP_DIRTY_TRACKING:
> -               return slads_supported(info->iommu);
> +               return ssads_supported(info->iommu);
>          default:
>                  return false;
>          }
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index 27bcfd3bacdd..3bb569146229 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -542,10 +542,9 @@ enum {
>   #define sm_supported(iommu)    (intel_iommu_sm && ecap_smts((iommu)->ecap))
>   #define pasid_supported(iommu) (sm_supported(iommu) &&                 \
>                                   ecap_pasid((iommu)->ecap))
> -#define slads_supported(iommu) (sm_supported(iommu) &&                 \
> +#define ssads_supported(iommu) (sm_supported(iommu) &&                 \
>                                  ecap_slads((iommu)->ecap))
> 
> -
>   struct pasid_entry;
>   struct pasid_state_entry;
>   struct page_req_dsc;

-- 
Regards,
Yi Liu

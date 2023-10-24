Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFAD7D4FCD
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbjJXMck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjJXMci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:32:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9882AF
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698150754; x=1729686754;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gn11pjZNKZhyjg+wkw1okKPZU1Rks0/9QUsiPsXw/vE=;
  b=BBowyCjm0lfwWaC5oN+BX5LtbFErrYxKmVpHWiiRa/Il9LpQG7MWH6g/
   JG8ew53ZmfbXrO6DQwiNiajkqvS6ks1yDvHpw3ULHsg4anzbNb9RCCWVv
   wAA1CZXN3vhnTPfRnvo28hONHLx0+VSPlmtHtW8D9pwclSf315DPLvwCm
   Jp0nxWvxtEXRNUVwqql30JHY1EMkeb9xacuCHUjJI1FUEWA/YpKokPrsq
   tS5wYNK+O2wl7NERthITG3sBvz8+cdkZ18f2tm6s0cHEiUEX0VB7O8cY1
   VgNFx1lJlJkcM2xl7tcjYhbTrfQbidAH2j5agLs8+d7SB/2kNk2BQFznC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="366389380"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="366389380"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 05:32:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="751989347"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="751989347"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2023 05:32:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 05:32:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 24 Oct 2023 05:32:33 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 24 Oct 2023 05:32:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gq5b4WX4UU73NAHxt4P0O5Dy+sl2ffXwqmBtV/H8O8MG51tJMWQFsWRqdQMJNchkThk/NTBl/gvFHr/LQWEYsS0RIwJa7XXbuwu9LPkJVlDUqqUkHePITg/mC/cG8gMP+p0boQgSMSX6mvqfVJMdcxrSTUqh/t/ZSg26FzprXrfkvxAOtag8Lnz3aZMC4ni/wpLqBbtGgdAUG8R/xnVg7ys7ZHrSos5mitd0gK8eLm4rqcjAoUatfQ+t2Gshr8WQT1SrfJBMQHpnVAbKEuuJa5nBRW20fnmT/7hT6AB87wvfNg2JTfWyZedGu75hgXNLb1YZWOZIN6pfMLLjoUR9uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/e44wq9GRJ6++a9nYtSUQPcyRYwDQmGeH2Stnl1kO5w=;
 b=e9ybxDteILkjh/GT/iDEotNVdFMdm+SFXZ6J18P9UmBv+bpB9PG4u/44wVNWTCIP0T0ci5a5VO4aiFqZtkQpgyRPsEoffnVyiJTo5cLMJWivtx8+eZxZFt1ui7UKSe+CfehsR/sQMq54HSrjxaKtyxoVnlwjQOZvLd7YwaLNaIZXzGTMsWRw3InaqUZH5t72DPDDyT/rnN8ns36dos2y6aVdt6Ojim+5DI2SlhX+AevdvlAwPvsRUsmR22LcSxTbQfJfiw04TCJTz2YSKkxOJisSGzaLJDeZKMzjHFcE3D8DIkjlcXUSwjoPBYTHPA6C8xTIubxobP+TFvOUhk8laA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB6866.namprd11.prod.outlook.com (2603:10b6:930:5e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Tue, 24 Oct
 2023 12:32:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::f8f4:bed2:b2f8:cb6b]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::f8f4:bed2:b2f8:cb6b%3]) with mapi id 15.20.6907.025; Tue, 24 Oct 2023
 12:32:29 +0000
Message-ID: <ad8fcbd4-aa5c-4bff-bfc8-a2e8fa1c1cf5@intel.com>
Date:   Tue, 24 Oct 2023 20:34:57 +0800
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
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20231020222804.21850-13-joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0165.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::21) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB6866:EE_
X-MS-Office365-Filtering-Correlation-Id: cdf9998d-ae8c-4d31-73e1-08dbd48d4931
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zNwgmscOdu1But46wQgqbrHq9M8FLRn/IhOZxkaUQSbu5BKwFns8iN7qKi+gkOC3fxATwDFIoIeNMO+iZ2qYaUAzKW5paOtv0d2JxN/57iJLaQscL+h3vjplWjsvtnNE6O7E1V5kZHuPCw+dBQkJcUuou/BFLOjGH50sA8Tro7wpZX+LUW1/hiqJPM86VVjgsKzD+ZsRrikYw7zgbtsB3Essx7XbOJfxIRPHY0gXmXFMYqLX2cIikET+6JZDd01Lp35iym1yPqJNGSUeDfTYkvTsmGP+7YAZ0TweqQjVlz3a0xPBHAT7VTlxazQ6rfJGVpYKFN9EYuQMHMWUpatrQqN2xBvSzUDKp/Eu2+56vB12IAMffsnV31PRNYhRsDLRHsgI5u1P2z049IxNmWV42FRa/FRVIilNNzBBDsR/UIYT+C8/nOxir5i11OlYyiUxCTwz5DQWjy5tNBkpSHGNTmX5/Y/w/k5/rpVk5TWzcozfZlKy8lw2bmOgScm6BeSTTdxnzw7eXz8jpJMCEVoG/rgU/BKD7wZrvi+3w3lDOEK4QGAakUQ8rO69Fawq0lwtz6zCMAWpgnjjcxf5EyU7YZd/o6EgdASp/e879lip19M8vLMJu4wUPYyYbttSA+VjcdrqyCkh1FUfNW6Q1WJGqASI5IVBGHNYaSizrSrmhLZYHxFEahvwQZOkG7tCLQYg01w7y6qv6Vke6uTwslgdNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(39860400002)(346002)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(53546011)(6666004)(66476007)(54906003)(66556008)(66946007)(478600001)(316002)(5660300002)(8676002)(8936002)(4326008)(6486002)(31686004)(6512007)(6506007)(41300700001)(30864003)(2906002)(7416002)(2616005)(82960400001)(38100700002)(83380400001)(26005)(36756003)(86362001)(31696002)(14143004)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1JBd0NKZGNaWTU5citoaGlNZE1mSlJaMlFiYm5qdmZIR0hnK05MRTlvUW1V?=
 =?utf-8?B?Nm56QkZEUEU4bEZ4S1k0QjJZdmpCOTlUSlJHcFY3dkUvNmplc3hxazVNVk9N?=
 =?utf-8?B?UFRUaWYxZXZYRjVPVWZGY2lwSW9VZ2RXeHBDZUxnSWloVXl1eE5uM05sck1o?=
 =?utf-8?B?dXZ4YzJCcWw4M1AxTTNBbk54NDRSRzhVSThVVm5SU3ZVRjZGMUdDM1hCV3Az?=
 =?utf-8?B?V0ZnTXp0QjlwR2ZmRlRCY1Y1bEtzQ3I4TmNHdHZwQTkrUmhoMG5Dc0RGdkFU?=
 =?utf-8?B?YitpdmM5Ujlla0NVcnNiTmp4cVBnSm9YYUxaQ0tnaGpxZEIwUHo1Z1hueXV0?=
 =?utf-8?B?UUZSYkxZNHF1aytuejVJeVQ0cWcwem03d3hZZGxGclRDSjFTc3hJMzJlY0hv?=
 =?utf-8?B?dUs0dWYwWmY5aUc3RXAvckVjcVRGYmdGMXBtaFZhWTRZRjhvUnFwaGM0eXpn?=
 =?utf-8?B?RGFRRmdvWnpmQnhsTDdaK2YyUTJERnorS0d0MHFLUDNHR3Ftd29vVmRPdVVm?=
 =?utf-8?B?WXd1NkVheTd2YWlaM2hQUkFSeC82bXdqbU5LWCtQWUpOWExkeTFFNnZVS0JM?=
 =?utf-8?B?ZnpFeWJ5ZVM0MW15VnlRcVgyWGpyWUhCaUtRN3M5SjN6N0tsTnp0SGxIdkpZ?=
 =?utf-8?B?ODMxTkYyckIyQlBGelJyc2drS0hVN3BMbjlDakk2bjk2YVdUYVZ1QytHc0hu?=
 =?utf-8?B?OUZDd1lqVWR4VXcyWGdPNWJGTXZRWUg0c3V1azRka2lCbzlYd09xdmVOajk5?=
 =?utf-8?B?UWFDZFk0TmNvb254aUtydU4wUFN5MVZ0eWFjTkFkcldKS3VkQUptdTV3SE96?=
 =?utf-8?B?TEJKWndBRjllSmpld1AwUWJXZ1Q4TzZOQmFpem5uamUwZHdUWTJNQ2hXcjlj?=
 =?utf-8?B?eG1WOXhqTEl3Uk05WEx0VkYvT1pybllkbjduSGRvU1FwdnNUSVY4cVFpektO?=
 =?utf-8?B?c0pTd3d2am9abG0zYzI5dWdBZGQ1dm1ZeUE2dkJBNkVXQ0NyTDZ3S1JsWEVW?=
 =?utf-8?B?RUtpMkJzK0U5L1lIUWVMN215d1BSR05tOEEzZW95bmFsRVVROFgwUGdGVjBt?=
 =?utf-8?B?eEhuTm00NHA1WEJKZHhZbVZHWGdpcXZTcVJIaUNJSEFhR08yb1hFYjRBTGh3?=
 =?utf-8?B?VVAzcHFaS1NNTjBLdmRVbG1HM0o2UVFvRVVNNHZPWFRSb0M4UlMxeXMyMDF5?=
 =?utf-8?B?RlBuZXI5eFQvVjlmMk9VeWZCUTBFaS9RRUxNZ2hwK1BuWi9aeHl3ZG1hN1lL?=
 =?utf-8?B?a2I3NGhSRTRVMGdnL3RKU0NhN0ZEWkJFZ25La2hUb0c5TTVFSHVBQ2VJSjlo?=
 =?utf-8?B?ZkgzckNoUkNSWWtEcE1sbUczNG1FSEJCMk8zd2tYcFEwU2hUaHZBWjRETkRs?=
 =?utf-8?B?eWp5OHBLRUkvLytJd2sxYmk0RktLdmtKdlRQWm1GWnNGVFhiQ2c1TW1oMDBK?=
 =?utf-8?B?Q0tqZ3JFZUY3VE1TVnhCekhsZjJPdUhvdkNEcklhS3l5cmU3eG9wZjJEK0Zy?=
 =?utf-8?B?UHp0M0diK0JUcXdEaUpZb3hTRHBiUVd5dG91VldudzJ1WmwrOVR5Z1ZmYkYr?=
 =?utf-8?B?UlRiR0U0TC9WZWFrQ0xUWjRUaWsxT2c1Nm1OZkYzVkV1ckIrcVlaRElPbzQ2?=
 =?utf-8?B?NWN5MVpvVHdhdk5iTStLRFBmZHFtWk5zM0djYVl1NURmai9wN2VSRlZDd0N2?=
 =?utf-8?B?T2FyTGFhbCtBSkROWFU4QVRuNFFGTDJvR2FMNG5ZZFc4YWNacHZGbXowU09D?=
 =?utf-8?B?RGpNM3J6RTNPSkZCZlIwWlZpa1d2cXlSUXVteFRlS0gwUUpnREZacCtXMnhS?=
 =?utf-8?B?RUtPcjVncEN1YlVET0cyVzBCNngyR0hGOUVVYy9aQ3VzM3VGZWNDdThvL2V5?=
 =?utf-8?B?aGlrVVZ0aDE5NE5mcTEvd1FacVA0NE96NnByVEdBMk1CblpWQzVUNmQrenZS?=
 =?utf-8?B?M1FWQU1UVlhnVE13ZUZBWUcvR25oMURnRmorUzgraG9WR2FEc2JadUF6ZXB2?=
 =?utf-8?B?OFhhM2F4akI5WnF0UmlibDMrNGI3bk5NR3JTbnFQby81bDNkakxrbzhQWGlX?=
 =?utf-8?B?ODJaTWRWV1J2RmJtTlAva3NDcW5vN1EwREZQbmVTb2hRWGowMythM3NiSXhN?=
 =?utf-8?Q?UVmbqy7BUSur5IKZR9alvPRxv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf9998d-ae8c-4d31-73e1-08dbd48d4931
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 12:32:29.3464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VE5rw4L6trIIM5+YndeVvFFOB9v3reJ+7aY/VHFezFJZFxKtIH41z7KNjPngKOWrQS9PO9xMmNq5X0XmAXWpPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6866
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/21 06:27, Joao Martins wrote:
> IOMMU advertises Access/Dirty bits for second-stage page table if the
> extended capability DMAR register reports it (ECAP, mnemonic ECAP.SSADS).
> The first stage table is compatible with CPU page table thus A/D bits are
> implicitly supported. Relevant Intel IOMMU SDM ref for first stage table
> "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second stage table
> "3.7.2 Accessed and Dirty Flags".
> 
> First stage page table is enabled by default so it's allowed to set dirty
> tracking and no control bits needed, it just returns 0. To use SSADS, set
> bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
> via pasid_flush_caches() following the manual. Relevant SDM refs:
> 
> "3.7.2 Accessed and Dirty Flags"
> "6.5.3.3 Guidance to Software for Invalidations,
>   Table 23. Guidance to Software for Invalidations"
> 
> PTE dirty bit is located in bit 9 and it's cached in the IOTLB so flush
> IOTLB to make sure IOMMU attempts to set the dirty bit again. Note that
> iommu_dirty_bitmap_record() will add the IOVA to iotlb_gather and thus the
> caller of the iommu op will flush the IOTLB. Relevant manuals over the
> hardware translation is chapter 6 with some special mention to:
> 
> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
> "6.2.4 IOTLB"
> 
> Select IOMMUFD_DRIVER only if IOMMUFD is enabled, given that IOMMU dirty
> tracking requires IOMMUFD.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/iommu/intel/Kconfig |   1 +
>   drivers/iommu/intel/iommu.c | 104 +++++++++++++++++++++++++++++++++-
>   drivers/iommu/intel/iommu.h |  17 ++++++
>   drivers/iommu/intel/pasid.c | 108 ++++++++++++++++++++++++++++++++++++
>   drivers/iommu/intel/pasid.h |   4 ++
>   5 files changed, 233 insertions(+), 1 deletion(-)

normally, the subject of commits to intel iommu driver is started
with 'iommu/vt-d'. So if there is a new version, please rename it.
Also, SL is a bit eld naming, please use SS (second stage)

s/iommu/intel: Access/Dirty bit support for SL domains/iommu/vt-d: 
Access/Dirty bit support for SS domains

> diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
> index 2e56bd79f589..f5348b80652b 100644
> --- a/drivers/iommu/intel/Kconfig
> +++ b/drivers/iommu/intel/Kconfig
> @@ -15,6 +15,7 @@ config INTEL_IOMMU
>   	select DMA_OPS
>   	select IOMMU_API
>   	select IOMMU_IOVA
> +	select IOMMUFD_DRIVER if IOMMUFD
>   	select NEED_DMA_MAP_STATE
>   	select DMAR_TABLE
>   	select SWIOTLB
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 017aed5813d8..d7ba1732130b 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -300,6 +300,7 @@ static int iommu_skip_te_disable;
>   #define IDENTMAP_AZALIA		4
>   
>   const struct iommu_ops intel_iommu_ops;
> +const struct iommu_dirty_ops intel_dirty_ops;
>   
>   static bool translation_pre_enabled(struct intel_iommu *iommu)
>   {
> @@ -4079,8 +4080,10 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>   {
>   	struct iommu_domain *domain;
>   	struct intel_iommu *iommu;
> +	bool dirty_tracking;
>   
> -	if (flags & (~IOMMU_HWPT_ALLOC_NEST_PARENT))
> +	if (flags & (~(IOMMU_HWPT_ALLOC_NEST_PARENT|
> +		       IOMMU_HWPT_ALLOC_DIRTY_TRACKING)))
>   		return ERR_PTR(-EOPNOTSUPP);
>   
>   	iommu = device_to_iommu(dev, NULL, NULL);
> @@ -4090,6 +4093,10 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>   	if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ecap_nest(iommu->ecap))
>   		return ERR_PTR(-EOPNOTSUPP);
>   
> +	dirty_tracking = (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING);
> +	if (dirty_tracking && !slads_supported(iommu))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
>   	/*
>   	 * domain_alloc_user op needs to fully initialize a domain
>   	 * before return, so uses iommu_domain_alloc() here for
> @@ -4098,6 +4105,15 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>   	domain = iommu_domain_alloc(dev->bus);
>   	if (!domain)
>   		domain = ERR_PTR(-ENOMEM);
> +
> +	if (!IS_ERR(domain) && dirty_tracking) {
> +		if (to_dmar_domain(domain)->use_first_level) {
> +			iommu_domain_free(domain);
> +			return ERR_PTR(-EOPNOTSUPP);
> +		}
> +		domain->dirty_ops = &intel_dirty_ops;
> +	}
> +
>   	return domain;
>   }
>   
> @@ -4121,6 +4137,9 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
>   	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>   		return -EINVAL;
>   
> +	if (domain->dirty_ops && !slads_supported(iommu))
> +		return -EINVAL;
> +
>   	/* check if this iommu agaw is sufficient for max mapped address */
>   	addr_width = agaw_to_width(iommu->agaw);
>   	if (addr_width > cap_mgaw(iommu->cap))
> @@ -4375,6 +4394,8 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
>   		return dmar_platform_optin();
>   	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>   		return ecap_sc_support(info->iommu->ecap);
> +	case IOMMU_CAP_DIRTY_TRACKING:
> +		return slads_supported(info->iommu);
>   	default:
>   		return false;
>   	}
> @@ -4772,6 +4793,9 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
>   	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
>   		return -EOPNOTSUPP;
>   
> +	if (domain->dirty_ops)
> +		return -EINVAL;
> +
>   	if (context_copied(iommu, info->bus, info->devfn))
>   		return -EBUSY;
>   
> @@ -4830,6 +4854,84 @@ static void *intel_iommu_hw_info(struct device *dev, u32 *length, u32 *type)
>   	return vtd;
>   }
>   
> +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
> +					  bool enable)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	struct device_domain_info *info;
> +	int ret;
> +
> +	spin_lock(&dmar_domain->lock);
> +	if (dmar_domain->dirty_tracking == enable)
> +		goto out_unlock;
> +
> +	list_for_each_entry(info, &dmar_domain->devices, link) {
> +		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
> +						     info->dev, IOMMU_NO_PASID,
> +						     enable);
> +		if (ret)
> +			goto err_unwind;
> +
> +	}
> +
> +	dmar_domain->dirty_tracking = enable;
> +out_unlock:
> +	spin_unlock(&dmar_domain->lock);
> +
> +	return 0;
> +
> +err_unwind:
> +	list_for_each_entry(info, &dmar_domain->devices, link)
> +		intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
> +					  info->dev, IOMMU_NO_PASID,
> +					  dmar_domain->dirty_tracking);
> +	spin_unlock(&dmar_domain->lock);
> +	return ret;
> +}
> +
> +static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
> +					    unsigned long iova, size_t size,
> +					    unsigned long flags,
> +					    struct iommu_dirty_bitmap *dirty)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	unsigned long end = iova + size - 1;
> +	unsigned long pgsize;
> +
> +	/*
> +	 * IOMMUFD core calls into a dirty tracking disabled domain without an
> +	 * IOVA bitmap set in order to clean dirty bits in all PTEs that might
> +	 * have occurred when we stopped dirty tracking. This ensures that we
> +	 * never inherit dirtied bits from a previous cycle.
> +	 */
> +	if (!dmar_domain->dirty_tracking && dirty->bitmap)
> +		return -EINVAL;
> +
> +	do {
> +		struct dma_pte *pte;
> +		int lvl = 0;
> +
> +		pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &lvl,
> +				     GFP_ATOMIC);
> +		pgsize = level_size(lvl) << VTD_PAGE_SHIFT;
> +		if (!pte || !dma_pte_present(pte)) {
> +			iova += pgsize;
> +			continue;
> +		}
> +
> +		if (dma_sl_pte_test_and_clear_dirty(pte, flags))
> +			iommu_dirty_bitmap_record(dirty, iova, pgsize);
> +		iova += pgsize;
> +	} while (iova < end);
> +
> +	return 0;
> +}
> +
> +const struct iommu_dirty_ops intel_dirty_ops = {
> +	.set_dirty_tracking	= intel_iommu_set_dirty_tracking,
> +	.read_and_clear_dirty   = intel_iommu_read_and_clear_dirty,
> +};
> +
>   const struct iommu_ops intel_iommu_ops = {
>   	.capable		= intel_iommu_capable,
>   	.hw_info		= intel_iommu_hw_info,
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index c18fb699c87a..27bcfd3bacdd 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -48,6 +48,9 @@
>   #define DMA_FL_PTE_DIRTY	BIT_ULL(6)
>   #define DMA_FL_PTE_XD		BIT_ULL(63)
>   
> +#define DMA_SL_PTE_DIRTY_BIT	9
> +#define DMA_SL_PTE_DIRTY	BIT_ULL(DMA_SL_PTE_DIRTY_BIT)
> +
>   #define ADDR_WIDTH_5LEVEL	(57)
>   #define ADDR_WIDTH_4LEVEL	(48)
>   
> @@ -539,6 +542,9 @@ enum {
>   #define sm_supported(iommu)	(intel_iommu_sm && ecap_smts((iommu)->ecap))
>   #define pasid_supported(iommu)	(sm_supported(iommu) &&			\
>   				 ecap_pasid((iommu)->ecap))
> +#define slads_supported(iommu) (sm_supported(iommu) &&                 \

how about ssads_supporte.

> +				ecap_slads((iommu)->ecap))
> +

remove this empty line.

>   
>   struct pasid_entry;
>   struct pasid_state_entry;

Regards,
Yi Liu

> @@ -592,6 +598,7 @@ struct dmar_domain {
>   					 * otherwise, goes through the second
>   					 * level.
>   					 */
> +	u8 dirty_tracking:1;		/* Dirty tracking is enabled */
>   
>   	spinlock_t lock;		/* Protect device tracking lists */
>   	struct list_head devices;	/* all devices' list */
> @@ -781,6 +788,16 @@ static inline bool dma_pte_present(struct dma_pte *pte)
>   	return (pte->val & 3) != 0;
>   }
>   
> +static inline bool dma_sl_pte_test_and_clear_dirty(struct dma_pte *pte,
> +						   unsigned long flags)
> +{
> +	if (flags & IOMMU_DIRTY_NO_CLEAR)
> +		return (pte->val & DMA_SL_PTE_DIRTY) != 0;
> +
> +	return test_and_clear_bit(DMA_SL_PTE_DIRTY_BIT,
> +				  (unsigned long *)&pte->val);
> +}
> +
>   static inline bool dma_pte_superpage(struct dma_pte *pte)
>   {
>   	return (pte->val & DMA_PTE_LARGE_PAGE);
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 8f92b92f3d2a..9a01d46a56e1 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -277,6 +277,11 @@ static inline void pasid_set_bits(u64 *ptr, u64 mask, u64 bits)
>   	WRITE_ONCE(*ptr, (old & ~mask) | bits);
>   }
>   
> +static inline u64 pasid_get_bits(u64 *ptr)
> +{
> +	return READ_ONCE(*ptr);
> +}
> +
>   /*
>    * Setup the DID(Domain Identifier) field (Bit 64~79) of scalable mode
>    * PASID entry.
> @@ -335,6 +340,36 @@ static inline void pasid_set_fault_enable(struct pasid_entry *pe)
>   	pasid_set_bits(&pe->val[0], 1 << 1, 0);
>   }
>   
> +/*
> + * Enable second level A/D bits by setting the SLADE (Second Level
> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry.
> + */
> +static inline void pasid_set_ssade(struct pasid_entry *pe)
> +{
> +	pasid_set_bits(&pe->val[0], 1 << 9, 1 << 9);
> +}
> +
> +/*
> + * Disable second level A/D bits by clearing the SLADE (Second Level
> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry.
> + */
> +static inline void pasid_clear_ssade(struct pasid_entry *pe)
> +{
> +	pasid_set_bits(&pe->val[0], 1 << 9, 0);
> +}
> +
> +/*
> + * Checks if second level A/D bits specifically the SLADE (Second Level
> + * Access Dirty Enable) field (Bit 9) of a scalable mode PASID
> + * entry is set.
> + */
> +static inline bool pasid_get_ssade(struct pasid_entry *pe)
> +{
> +	return pasid_get_bits(&pe->val[0]) & (1 << 9);
> +}
> +
>   /*
>    * Setup the WPE(Write Protect Enable) field (Bit 132) of a
>    * scalable mode PASID entry.
> @@ -627,6 +662,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>   	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
>   	pasid_set_fault_enable(pte);
>   	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
> +	if (domain->dirty_tracking)
> +		pasid_set_ssade(pte);
>   
>   	pasid_set_present(pte);
>   	spin_unlock(&iommu->lock);
> @@ -636,6 +673,77 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>   	return 0;
>   }
>   
> +/*
> + * Set up dirty tracking on a second only or nested translation type.
> + */
> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
> +				     struct dmar_domain *domain,
> +				     struct device *dev, u32 pasid,
> +				     bool enabled)
> +{
> +	struct pasid_entry *pte;
> +	u16 did, pgtt;
> +
> +	spin_lock(&iommu->lock);
> +
> +	pte = intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		spin_unlock(&iommu->lock);
> +		dev_err_ratelimited(dev,
> +				    "Failed to get pasid entry of PASID %d\n",
> +				    pasid);
> +		return -ENODEV;
> +	}
> +
> +	did = domain_id_iommu(domain, iommu);
> +	pgtt = pasid_pte_get_pgtt(pte);
> +	if (pgtt != PASID_ENTRY_PGTT_SL_ONLY && pgtt != PASID_ENTRY_PGTT_NESTED) {
> +		spin_unlock(&iommu->lock);
> +		dev_err_ratelimited(dev,
> +				    "Dirty tracking not supported on translation type %d\n",
> +				    pgtt);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (pasid_get_ssade(pte) == enabled) {
> +		spin_unlock(&iommu->lock);
> +		return 0;
> +	}
> +
> +	if (enabled)
> +		pasid_set_ssade(pte);
> +	else
> +		pasid_clear_ssade(pte);
> +	spin_unlock(&iommu->lock);
> +
> +	if (!ecap_coherent(iommu->ecap))
> +		clflush_cache_range(pte, sizeof(*pte));
> +
> +	/*
> +	 * From VT-d spec table 25 "Guidance to Software for Invalidations":
> +	 *
> +	 * - PASID-selective-within-Domain PASID-cache invalidation
> +	 *   If (PGTT=SS or Nested)
> +	 *    - Domain-selective IOTLB invalidation
> +	 *   Else
> +	 *    - PASID-selective PASID-based IOTLB invalidation
> +	 * - If (pasid is RID_PASID)
> +	 *    - Global Device-TLB invalidation to affected functions
> +	 *   Else
> +	 *    - PASID-based Device-TLB invalidation (with S=1 and
> +	 *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
> +	 */
> +	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
> +
> +	iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
> +
> +	/* Device IOTLB doesn't need to be flushed in caching mode. */
> +	if (!cap_caching_mode(iommu->cap))
> +		devtlb_invalidation_with_pasid(iommu, dev, pasid);
> +
> +	return 0;
> +}
> +
>   /*
>    * Set up the scalable mode pasid entry for passthrough translation type.
>    */
> diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
> index 4e9e68c3c388..958050b093aa 100644
> --- a/drivers/iommu/intel/pasid.h
> +++ b/drivers/iommu/intel/pasid.h
> @@ -106,6 +106,10 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>   int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>   				   struct dmar_domain *domain,
>   				   struct device *dev, u32 pasid);
> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
> +				     struct dmar_domain *domain,
> +				     struct device *dev, u32 pasid,
> +				     bool enabled);
>   int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
>   				   struct dmar_domain *domain,
>   				   struct device *dev, u32 pasid)

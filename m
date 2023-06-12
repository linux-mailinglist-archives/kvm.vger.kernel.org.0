Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848B872BAA1
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 10:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjFLIah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 04:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbjFLI3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 04:29:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E42235B1;
        Mon, 12 Jun 2023 01:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686558528; x=1718094528;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KMp6RVNOn/qCBkXZZoovJ12qqOjjIwhRNOtgKkv37iA=;
  b=B95ubpvaFbnk+BAmtBbscgHMrlTxFvSDfbRJT/I4ksaAQOTwfiTqe+C7
   kWV7HP0i9n6eFVIRNxZZm3L6fK7qChxgtLRrp7I26X3PMmEwod0cIyOWU
   hbzIlv9XwQ8ITudo38ggozv/c/9cNxigDz3v1G6QtyPDWc3eeucqJO18y
   7h7RHX/sSit0sZiiUU40dXaWvYTHRVxmOzlkgs3HQop8f2yDkcuYeTJ9p
   rpJhowukjUUEG8JZp18UEwzdWGCPAPLWJMtxOu88TXX2b1p1NEfteulMH
   M/Ut/BAz8P1NjAfDsSwbJx/rXpZLqpFCV4LKnLf8t6QWV8NPzyVs5dBj1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="342666160"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="342666160"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 01:28:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="855527775"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="855527775"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jun 2023 01:28:46 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 01:28:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 01:28:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 01:28:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTq2kPQPD1a3Hba3I1usHYqW+ZmGLo8ZAypP8GtioH9W6ryDlcVIKClFdIsaoHRzcStK7pAUgfz/3zWBP/h2cmJbcJrsEV06DWFnIrQgQk6kQ1LQEm1m9y9ukO39NxtiGekCzWw036VvZ7+qpXGVSjUPhz0IeBuGRV8P2heT1LcAS03eLEiSPjzW6z/rrbsq1XCv/3ybXn/ZHM/TkLMg1klKSRbWKkH8vp2HM1V+4M7mDRMGuzYGlNB62uQ7XKlQZZJszw1YQH7n2ib8lYH7bFbjRg9E7akPNQIrTZfGYZ3+TfwklEI+oHiowX/rqRvT5LMD/ICawq6k7PU9oq/n0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNgzMGXgCRejNDFncnLXztbNV6tS4BoRKzyyJESeW1c=;
 b=C/yPaPdH7XLf1k6UkfeGwRalR0sXH9bDW3bgb9G27te0p31waEA02sbDvIFiJ1UIkYACWs9GDny6Um1F94WJ7ObIHsnt2yZgL80nAc+Jv1ibYrmvWEb0sSbOAtRwtlNq52QGwsnmVpQ+EMbaEYlYeICYYNED4Dh4oINwHvUmHHvk/9cpX//DjyXruqg6MKockPADza+MVb4mpLfzOBwpcK6qGfl3UAn6Yz/0aqMWiFfPlISJR48JynfJA8nHLdfkMkQfwmGVr4fCAoVCWR2WrtmPYjqdRWWQykSlBUkK+8nz3F5E1IaEcGZ6GRQZdJz4xzFpKxe2FT1icxA1tqxWfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5469.namprd11.prod.outlook.com (2603:10b6:5:399::13)
 by CH0PR11MB5316.namprd11.prod.outlook.com (2603:10b6:610:bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 08:28:44 +0000
Received: from DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::1439:6bf2:b876:cec5]) by DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::1439:6bf2:b876:cec5%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 08:28:44 +0000
Message-ID: <8cc1d69e-f86d-fd04-7737-914d967dc0f5@intel.com>
Date:   Mon, 12 Jun 2023 16:28:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Content-Language: en-US
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Kevin Tian" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
From:   "Liu, Jingqi" <jingqi.liu@intel.com>
In-Reply-To: <20230607035145.343698-2-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::6) To DM4PR11MB5469.namprd11.prod.outlook.com
 (2603:10b6:5:399::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5469:EE_|CH0PR11MB5316:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e4a646-537f-4a96-c667-08db6b1f08d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HZSubGkFTt0Qn6R6rsYXGOtXOtHoa448RIyLzFC7Bs3lXPapAbfNLnSkmtlqBsG1BKmouIWIvWr8zthgq8nQ5cln1uF3Zl3Cj11Vh0xYo5AlHot7pvU4mxelgdOjQaSp+u24b1rSdGGWK+o4vQ1fO7dqMuE+KLs9lPH932aY5aLVt+56MdwG1GIhxfhi2ZoU2DhSxq73GRJYm0gAQJQCCyF1ENBEYhjzIn0sVLFzFcvkEOMQOpzi14dndHtGFq0cwxTgJ9K9w3oc0ftXGwgLPcnKSp5BIi2gDZvX9eN2SlP6ks1kDM6NqIvGDjGs5D/WBi8f1w3pb32Sw6CN95acQdCLfKnah1BBHdh89TvD22iI5jliw1b3x+RJuxxf06n8gx92XuUpNOTZo/pbXOzyNWeMPIQsHPgXJlRqPo+TS+0DmYwLTUm22cG76QkzSbOFSOPR91s17UdTa8O0Jiqaszp6DIqI7UqlKjX4RUvphjt5TAByCZ9O6ZgvYY9OTO6zwHWp18mW72ZXIJ6+HSuTH71tZKfiziYdjUnfCpFK3KofKbTyJKpgRxYNkYfJURjgHEAXSRQ1olHK7sKjfAKTdWdtL/iy55ZUJ4OQScFrkEezEvd2peQS81cTNkxkYxoZatM7p+ZQ4jxLMHe5RmvhVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5469.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(86362001)(31696002)(7416002)(6486002)(316002)(8676002)(966005)(45080400002)(41300700001)(82960400001)(83380400001)(5660300002)(26005)(38100700002)(6512007)(53546011)(6506007)(6666004)(8936002)(66476007)(36756003)(66556008)(4326008)(66946007)(478600001)(186003)(31686004)(2906002)(2616005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXNTU1JQL1hNYU4wM0ZmeUp4QmJ4em9QSmV0cmtwaUFRVWl4NCtiSVF6akFj?=
 =?utf-8?B?SmtWc2pab0NTams4eEI4WkRzNEw1dXhJRjVMQTVRUU1vemRUYkNDelZoUC8x?=
 =?utf-8?B?MnRKSzRDMzlQMFd3OFFMdVZBaFFPbm8rc3U0RCtUelFVbG54bmZLQ3BLNTZS?=
 =?utf-8?B?bGtBNkI3bHpBTjFGZkh1Nzd3OWVXMW9TeUdBT0dOaDNBNXNpRk9hUk1pM1Nq?=
 =?utf-8?B?cE1HSzE5RzdlZ3BQUjZBeVI0SHNrcGJrQ2FKUGdhQWFTTlY2SnFwOVp6RTdj?=
 =?utf-8?B?UUltOXgzLzROSWdYVnZGVTZ4Qnl6aDk1S2lreGl6d3JMVTNiU2Q1LytaWjNj?=
 =?utf-8?B?MFVIeFVvcjNUcHNoOVpzbXhIRGlnMXdtazBWWkpWSVNXVnVqaURDSUFnVEdG?=
 =?utf-8?B?WlAwZmFJMHBGYkR4TWtjVzZEWWNLU0xNSVZWWWllbTU1UVA2cG5ReFpjVXJo?=
 =?utf-8?B?M2U5Tm81d1NYenB2b0F2S09GN1Nvdk9Qa01YdEVXb2NNTTVHOTFQMVU4ZHp6?=
 =?utf-8?B?ZnNCVXllK1UvR1NWb29maUpSMTdLUHovSGtpVFBHV2xSMlRMS0ZpV282bTlQ?=
 =?utf-8?B?ZUhIZGRTZ3NhOUJrSTQ5UW9qNE1OQmpnY0V4VzNWNHpTZGdIVjZ4UE0yaVRE?=
 =?utf-8?B?cGlFTWZnRUdRUEFmZndaazcvM2l4anRXNE5vTjRlOXptTm5VczF3ZjZDRWFC?=
 =?utf-8?B?OWkrL295SFVtMGhGYStySTYvRVFSb2pKWGJleDRPdktReFdOYjVSUjd2RGRL?=
 =?utf-8?B?Z3JDZFpHNTlva083ZHRjbE5Dcjk0NlozS2FqVE8rYlZweHpoUFBoM2hzb2lY?=
 =?utf-8?B?RmlaR2cvbmd1eHc1U2ZaOVJRaW1PZElKZEFvUjRwVUM1T0FscmI3T3oyeW9B?=
 =?utf-8?B?cW5mUTlVU2NUZU9SdS9mMlczVm9nbzRucGo4c3N6VXEzbG5lZGNwRjdKa0hk?=
 =?utf-8?B?TmxmWTM0TmhBbVRPcFFKTEVjN3VQZ2VmeWpjNHM1MURVRHRndlY0L1RvK0d5?=
 =?utf-8?B?NjhlNzFTdUNab3hmNUdxc1Z5YmRTY2ViQld3NkFCbGppQTd4alFkMnA3RUhv?=
 =?utf-8?B?SWt5bDRpNVZ4RVlzemxyT1dUZ0pSTm5hREJaS0NTNE1JeUNMOEhZZ3hWZy9v?=
 =?utf-8?B?V21FSHlMcVZoWkRNMDVxM2U2ZkY1S2VEc3p5UjJvZGt1dmNEL2ZEZXdHRHFD?=
 =?utf-8?B?QWdHYU5MSVZ2UU94OGg0UkR1bGNUN3B4VkQ5UnNvNHMvT20wLzArekNWaGVG?=
 =?utf-8?B?TER1U2pGYTNVK0ZLSmZtUFh0QXZEa3VPcENTelZIaGF4ajdGbzFIMEZKQzZW?=
 =?utf-8?B?Zi9vcGQvbmJYOHBpQW1UeXdvSGZEOW44RlJ4WFRCYjQveUFUM1R3T0lQRWVT?=
 =?utf-8?B?ZU9ndUFhbEFsUUt2NlRJL0VDUjZKRTZPVjhNckZOdGRoaDJaUkNCWmhVSjMr?=
 =?utf-8?B?cllkTE9XOFlqREtzWjNid1Y2RE14VXlxTHRZaWxHaUFzOEwyOGcxeDd2RGk3?=
 =?utf-8?B?U0NwNmR0TkMvYi94bnZrbkk4eVU4bXNwU3RDYVdmUzdSZmM4eVJSUHVHeVRt?=
 =?utf-8?B?UUtFaWdsZjI3T29nbjhRd1JGdmprN3dtYmlxeS9kQU9kdkdTUkZOTEdHRUV5?=
 =?utf-8?B?VCsxclZiRzh2VjRhdHpUSUg1OGw2VFE5TWhmODVhbWwvbG80bFJiNXdiUHd3?=
 =?utf-8?B?U1Ftb0NvN2ZER1hzZDZlOFJ3dWltYnhFTGI1eW85MGpCMFp4RDNzWjdwQmJQ?=
 =?utf-8?B?bGpKci9YZzN1OU5nTmQ5WWVqUHZ2MlVOR1Nrb3pYb2NFYk9vRW5wRytSQmdB?=
 =?utf-8?B?RUlPQVhLekZLT2FiUURsdjkzR0RBbFhOSkVMU3dEYll5Ulh6aXZBbzNFbWk3?=
 =?utf-8?B?bUp0am5QY3JHTjh1anZmSFUrajcxbFA2eHZhMFV2Y3haalZuNlFGL2VXemp1?=
 =?utf-8?B?VDk1MkdjTTkyanVrZ2ZXTFdQK2FxeWdaYUNrU1pEaTQvRTM0UGRUOEQ4Z3Zv?=
 =?utf-8?B?a2gzcUd4TE9sNnZKczNUU2FEcWhkV3BUalNxdHVib2h0bHkxWEJyMXpqZlV0?=
 =?utf-8?B?NmpvS0JxVXZRUEVLOFRGaG1kNjdxVmtmRU5IOHhGR2lDekdIYS9RMFNYTm50?=
 =?utf-8?Q?RydmYFFYx5g6i4HPuT+2WtMzY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e4a646-537f-4a96-c667-08db6b1f08d1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5469.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 08:28:44.2390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/mC26MFp82+pseTTwIstA8lFKLOGOOo6lpOqiQpDtE+sI0y+fYjK6PGP4sheXNr/fBX34SORxL3sN47xNJuxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5316
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/2023 11:51 AM, Lu Baolu wrote:
> The IOMMU_RESV_DIRECT flag indicates that a memory region must be mapped
> 1:1 at all times. This means that the region must always be accessible to
> the device, even if the device is attached to a blocking domain. This is
> equal to saying that IOMMU_RESV_DIRECT flag prevents devices from being
> attached to blocking domains.
>
> This also implies that devices that implement RESV_DIRECT regions will be
> prevented from being assigned to user space since taking the DMA ownership
> immediately switches to a blocking domain.
>
> The rule of preventing devices with the IOMMU_RESV_DIRECT regions from
> being assigned to user space has existed in the Intel IOMMU driver for
> a long time. Now, this rule is being lifted up to a general core rule,
> as other architectures like AMD and ARM also have RMRR-like reserved
> regions. This has been discussed in the community mailing list and refer
> to below link for more details.
>
> Other places using unmanaged domains for kernel DMA must follow the
> iommu_get_resv_regions() and setup IOMMU_RESV_DIRECT - we do not restrict
> them in the core code.
>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/linux-iommu/BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   include/linux/iommu.h |  2 ++
>   drivers/iommu/iommu.c | 39 +++++++++++++++++++++++++++++----------
>   2 files changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index d31642596675..fd18019ac951 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -409,6 +409,7 @@ struct iommu_fault_param {
>    * @priv:	 IOMMU Driver private data
>    * @max_pasids:  number of PASIDs this device can consume
>    * @attach_deferred: the dma domain attachment is deferred
> + * @requires_direct: The driver requested IOMMU_RESV_DIRECT
>    *
>    * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
>    *	struct iommu_group	*iommu_group;
> @@ -422,6 +423,7 @@ struct dev_iommu {
>   	void				*priv;
>   	u32				max_pasids;
>   	u32				attach_deferred:1;
> +	u32				requires_direct:1;
>   };
>   
>   int iommu_device_register(struct iommu_device *iommu,
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 9e0228ef612b..e59de7852067 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -959,12 +959,7 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
>   	unsigned long pg_size;
>   	int ret = 0;
>   
> -	if (!iommu_is_dma_domain(domain))
> -		return 0;
> -
> -	BUG_ON(!domain->pgsize_bitmap);
> -
> -	pg_size = 1UL << __ffs(domain->pgsize_bitmap);
> +	pg_size = domain->pgsize_bitmap ? 1UL << __ffs(domain->pgsize_bitmap) : 0;
Would it be better to add the following check here?
     if (WARN_ON(!pg_size))
             return -EINVAL;

Instead of checking latter in the loop as follows.
     if (WARN_ON_ONCE(!pg_size)) {
             ret = -EINVAL;
             goto out;
     }

Thanks,
Jingqi
>   	INIT_LIST_HEAD(&mappings);
>   
>   	iommu_get_resv_regions(dev, &mappings);
> @@ -974,13 +969,22 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
>   		dma_addr_t start, end, addr;
>   		size_t map_size = 0;
>   
> +		if (entry->type == IOMMU_RESV_DIRECT)
> +			dev->iommu->requires_direct = 1;
> +
> +		if ((entry->type != IOMMU_RESV_DIRECT &&
> +		     entry->type != IOMMU_RESV_DIRECT_RELAXABLE) ||
> +		    !iommu_is_dma_domain(domain))
> +			continue;
> +
> +		if (WARN_ON_ONCE(!pg_size)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
>   		start = ALIGN(entry->start, pg_size);
>   		end   = ALIGN(entry->start + entry->length, pg_size);
>   
> -		if (entry->type != IOMMU_RESV_DIRECT &&
> -		    entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
> -			continue;
> -
>   		for (addr = start; addr <= end; addr += pg_size) {
>   			phys_addr_t phys_addr;
>   
> @@ -2121,6 +2125,21 @@ static int __iommu_device_set_domain(struct iommu_group *group,
>   {
>   	int ret;
>   
> +	/*
> +	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot allow
> +	 * the blocking domain to be attached as it does not contain the
> +	 * required 1:1 mapping. This test effectively exclusive the device from
> +	 * being used with iommu_group_claim_dma_owner() which will block vfio
> +	 * and iommufd as well.
> +	 */
> +	if (dev->iommu->requires_direct &&
> +	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||
> +	     new_domain == group->blocking_domain)) {
> +		dev_warn(dev,
> +			 "Firmware has requested this device have a 1:1 IOMMU mapping, rejecting configuring the device without a 1:1 mapping. Contact your platform vendor.\n");
> +		return -EINVAL;
> +	}
> +
>   	if (dev->iommu->attach_deferred) {
>   		if (new_domain == group->default_domain)
>   			return 0;


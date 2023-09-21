Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6047AA0B4
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjIUUrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjIUUrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:47:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98A890F26;
        Thu, 21 Sep 2023 10:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318447; x=1726854447;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=avmG6rVRyyA8LBMOCQwgFga4fgiyFve9xJhluZUHsDU=;
  b=I/r0fBgr5SqyPuL9ZnA1QPA7GQGuzKxNrWcYb82ZUPTOjsHwxqt3QUEL
   RSS24CcMK7X0FJ2fy9oNnTUsZWMyk7R1IFvc8QhhXYKIlYemaRuvCe40s
   2P4+TS3u+4+EZkf3VxiqJAThBmPbdMAkyCNKEAYZXdC05JZc89U7CJwcx
   /UqPwtuXl8b5isSgCZ73/tdA+7AYjkDszBlYVicFIiie3doU+KaYU4jIE
   sh2HEMgrI5y64KjSt6dBufakqJj9szUskhhCsHyCnW/Ux4e9Q6Rb2T28C
   ERKVSHgLVqTm+44tC1NqZqKfZfj+Uqyu6w9HFcs0S5AeVD9lz4Y0dYC7z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="377847594"
X-IronPort-AV: E=Sophos;i="6.03,165,1694761200"; 
   d="scan'208";a="377847594"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 08:26:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="837327452"
X-IronPort-AV: E=Sophos;i="6.03,165,1694761200"; 
   d="scan'208";a="837327452"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Sep 2023 08:26:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 21 Sep 2023 08:26:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 21 Sep 2023 08:26:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 21 Sep 2023 08:26:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXkcC5jpf6tAJRwQwJXorC2PdUZDKdaugE7PItu0Nv5OoYVCQddzDpZcvcPuZiNC0hfBgqUO1S9htIQobeDBZgBwPVy57pVWgrPWv20lwUBrDS30a7eBQXoagtxul6TxgnqixD9MGNJifiGKdBTakVuWcENeHh8iZ1/JnpXnY0M9v9+rZqLi8TDTYsBwIvHUU/Ey8SRKM57dztDodyCNUQoGtcIHthK6aMQm56YWe3xx3oaAFQuBAkK+YCck08zqWFPXgskKYpDzi63tnTB9D3N9bRb8sISXys6lg12rR1433zuIy0BRgEv9d7PV5l6xC6nQBZ1m0VaTPvizyD0p7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdsnoJvITLi+eW/9xiZUUQjGdwkT8cjMxQnNjxMaRmE=;
 b=lu3VTMJ+V2Jx2CoSPJtEWKTU9IH0Hp0zaFwZD/IwLnra88PXC7Gl5TTp/EP15oaJwL2FIkwgFYRhMX97MMNhZUOOnk22E0oExunpGiGVHFAV7rQMlMjCbpQSrz2w2zgdB8JK7hf0KAmmITPY7aCMjiM69ohbtmhMJzX7Wwb5UporXBXVvPqjeT3A2ViYvFNNcrEMzUBwHYz0XC/t/olbyyG7vpdcyjlJXyyWXjcavDswOSWdgbJp94qbwWwabVw2Gyk1qWoyM2dYTjT/dYgJWKqRfEd/Tejqo0pfCV/2vNsf5rtPl/hFtZv+zsMN/QoS4uUy6ZEJS6j9Jquczai5Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5469.namprd11.prod.outlook.com (2603:10b6:5:399::13)
 by SA2PR11MB4891.namprd11.prod.outlook.com (2603:10b6:806:11e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Thu, 21 Sep
 2023 15:26:09 +0000
Received: from DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::8df:98a8:95d7:5bf4]) by DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::8df:98a8:95d7:5bf4%6]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 15:26:08 +0000
Message-ID: <f20b9e78-3a63-ca3e-6c04-1d80ec857898@intel.com>
Date:   Thu, 21 Sep 2023 23:25:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 09/12] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-10-baolu.lu@linux.intel.com>
From:   "Liu, Jingqi" <jingqi.liu@intel.com>
In-Reply-To: <20230914085638.17307-10-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:195::13) To DM4PR11MB5469.namprd11.prod.outlook.com
 (2603:10b6:5:399::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5469:EE_|SA2PR11MB4891:EE_
X-MS-Office365-Filtering-Correlation-Id: 82e18e2b-d6b5-4229-28de-08dbbab71445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fhJK7QFq1wDVqP7cerHH56a69WfS+KCYbGmiLJDrI2n546ZymiOrAsbenIczjXbE9Fq1HliVnYovROEq7wlS3w70EOyClpmhHtU/aqoG98AITgwFKCSw2E7az6j8srB2H0Hlo752vvKO90PXXyKnssm8f/h/Gd9XqQtoePUvLPE/wa+4Dp00146yRHC4Hw0TNY9OF+VRaeacLHqoTA66b1kKDl5kt8+IqCYwap4bx24qbLxegXKGPwwkzPhGhZNX6QBXNFxxEU2ccBvcReBzwEh0/kpoprW0Y3e5Opqt4iujDCIDeFnIaFCMCLBvPM8kuUkoLN3NClW9AMQoEllRCxHec1NWmZfjDR2mOdfb1q2auxezsqICTz+BqlmK8yYVsiXEHGlc4mffwBcLxKnn9wJkf8u4bBJvn3O0cfXQzX7i4SWjaInI7COVouCEruJqjw1nRJQSz/woQYRDBlAb9Rw1Z9GIEopPxw1/xqibR///+LcQEHAS/LHt4E2FW1HU0Xkup5Sd4iyN/2q6Ih+kPj+py0CCSB1ALDik778i1tOL+Lg85PySbWU5L5YmwtSAmQCDkpGMNPlYAm7aDGJgkOOvOV9ilaC1edOzZd3K5UaT6oksoMOWx3Vo+Yh8Ht5gpM4ud3krIxoWdx/xeWt8DjxIMkQfLA1xyL0NfoejA8o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5469.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(39860400002)(136003)(366004)(186009)(451199024)(1800799009)(2616005)(5660300002)(26005)(41300700001)(2906002)(7416002)(86362001)(38100700002)(82960400001)(31696002)(36756003)(4326008)(8676002)(8936002)(83380400001)(478600001)(6666004)(6512007)(6486002)(6506007)(53546011)(110136005)(316002)(31686004)(66476007)(66556008)(66946007)(54906003)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVM3YTdLazBPZlJpNEdXQWdZZ1MwTkloVjBodndkRlZQb1dvUnpnbHkybkxa?=
 =?utf-8?B?bzRkdG83YzNlSlN4ODYrMkl3NWxYZXRkb0ZLRUFHbk9WQTNxbXZQOHJuUzhl?=
 =?utf-8?B?cjBIN1dPUElGZVFpTWlKQ0NWVUpIY1RIZ1EwT0MxTkVCUFFLUjJQTE1ieUR6?=
 =?utf-8?B?TVVhbHNpTW4zZVlhek9pSDZjS1ZXWVh2TnNYN0RsSmMyOFhaMGFJMllJSzdS?=
 =?utf-8?B?UjMzVG80aEFJL2FDcTRRa3BIQk9BdDhIQkhGLy81aGZNdzNVazg1WjFkM3ZX?=
 =?utf-8?B?NGg3TW9ueEp0RXpVVkJuVG5LYVUweXBXSXQwNkJuV2NUbEtqSjBmK3UxRFNs?=
 =?utf-8?B?NWJaR09kclFvclZ4VVlySkhxQy80RE5XdG5PbXVaSHVlZDlyVlNIY3Q0RWFW?=
 =?utf-8?B?WG5ha2g3OXlaQlRkSEpJZVJrT2g2eUpEYmtrY1FsUnZ2QnB3ODZsZExicmZs?=
 =?utf-8?B?WEg4NzkyL2FjalNDeHpHdWR2S0dHaGpaRUR5S2IwbG9rTncvaGdNWFppRTQw?=
 =?utf-8?B?ZlI5bEdxTjNiNVRPeFB1THo2Y3IxWGlTbmJXREhhckdpQVR1TlV1eUV5VTdk?=
 =?utf-8?B?N2RieW4va3FMenpWUHo4OVZKdEhoVlhkcFZ0N2c4UnVoMWIxdmswTFlGZjlI?=
 =?utf-8?B?cWc3VGN1NC9tZUp3WnVGUFZIdVFLWCtPUzE2UFFabzVNY2FZQm92MytENjht?=
 =?utf-8?B?aW9TZGFrZUpYOVI0Uit2QVFvcDAydU8yN0ZISjJpWnJ3NXR4UkxIeXROWU5n?=
 =?utf-8?B?aHc2TVNpeTBIbGJEV0FvUW8wVVNtc1R0elRkaDVTS2dScnRqY1BEajhmTGZO?=
 =?utf-8?B?Yk1BQ091Q0x5bmw0K1RkN2VRazIwZ1FMdDdlQmNhSlJsWFNUOUpNYXVuV2Qz?=
 =?utf-8?B?VDdHQUtKT3dzZ3ZSaE1vRXBFNlZZZWJmczhDOW1wMnd4M3JVcSsrRzFGMVd5?=
 =?utf-8?B?R0dHejBwQW90aEJMV0ZUSTA5b0srR2VnbVdrdzFIcTVzV3liUTV0OXpPY2p6?=
 =?utf-8?B?ck9FUy9DSU1XYXRFNm1CZWlMeW9aa3hmNm1HK1VjYlZtdEtDV0x6a0RobUxJ?=
 =?utf-8?B?RkNkMUtyZitDT1VsZTRqd2VTS0tyTWtHbk9QUDBoZVA2YlNjODNvTGtMYWdC?=
 =?utf-8?B?YTVLY3pGbC9VdU5QYUpva3ZjMnQwazQyWUVXV3NDb0hGb0tydU9NVisvN0Q4?=
 =?utf-8?B?K2RTbGR5K1hHSXI4UFN5a2hsVTZiR0NoUjk2NnRaVWdtV0grOG9tamVTdkRr?=
 =?utf-8?B?dTVwaVNIdlN2cWtQdzBCRThPYkwwZFJLZE1iR0p1ZC9rWC9MMVp6T3JLT2xJ?=
 =?utf-8?B?SFFVZVhJTmNLWjFnNU5ZaEVMOFpHYldjbHhXWWZOTW4rSjROd2gzNEhFeTBr?=
 =?utf-8?B?VnJQSExCYlpONktkUjZwRkFhcWQ4S0N3VysxS25tcWw3NXozOHVScTBIS0Rs?=
 =?utf-8?B?Z3JoQ0JwWWhKUzIxMk5mVzEzQURIaFFlMklESk1ZbWJSNERpaHpkY2kzMWNR?=
 =?utf-8?B?L01RYWk2TW10ZXB5MU1YdHpSdTd1RnM1Y3R3aXFIeDkxcU1HdjF5eHl3enBC?=
 =?utf-8?B?U0FiT211UXRQcmQ1dzRiQlRhRTlNV3pvVTNYYllIdjk5eklJYXRDdHNVUS9U?=
 =?utf-8?B?cGNCUlBEdGhzdkVuKzdMbm8wcnQ2eEp2ckpBWGxNTyszZDBpc2lKN3AvWXFH?=
 =?utf-8?B?YTdrZzlmU1AyM0R1ZlJVYWluNlBCaG53a3JxcmZvQWFlY2FvTHAxZHFnWU82?=
 =?utf-8?B?TXBwUHpySHBJaXFNNE9uK3o4SjZTRlk5Nk1CS3JVUkVFU0Y3VUFoQlQrdysz?=
 =?utf-8?B?bGVEZ0FQMEdrYVNYZ0RQVXZFZFcxbGdpSXRKWHBtWGMxeWZBNnpJbkV4QkZx?=
 =?utf-8?B?UE8vbEFnSk9xUmwwQksrWHdDMHY5QlhzS1FDU0d6cnJUY1pVeFU0SVlOV3Q3?=
 =?utf-8?B?VXZwUGxXcDMzKzhKSWZHWXYya2lhN1BmNU0wOWZtUFBWUmZudEtxQjI0dmw0?=
 =?utf-8?B?bnFSTHpXYi9rZitPU3E4ckVsTGxiNitQS051UXJxcGk3elU4c1E2cEhsUlpG?=
 =?utf-8?B?WGsrRmE0MGRlUXltMEYwUEdrMk45Q0ZKdjl5MVRkODU2RmZvbGZPeVNsc0lJ?=
 =?utf-8?Q?nrEaTGIoudLfPFRWWm/EeeMuX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e18e2b-d6b5-4229-28de-08dbbab71445
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5469.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 15:26:08.8217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SB6rDNucE+MLHzuSx9M2UQ14AYs45YsJT2tFDkQCuBLq7dKvD+SpscMX0onsnkXjCJEs6LTmrHL5Rx78BsINLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4891
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/14/2023 4:56 PM, Lu Baolu wrote:
> Make iommu_queue_iopf() more generic by making the iopf_group a minimal
> set of iopf's that an iopf handler of domain should handle and respond
> to. Add domain parameter to struct iopf_group so that the handler can
> retrieve and use it directly.
>
> Change iommu_queue_iopf() to forward groups of iopf's to the domain's
> iopf handler. This is also a necessary step to decouple the sva iopf
> handling code from this interface.
>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   include/linux/iommu.h      |  4 ++--
>   drivers/iommu/iommu-sva.h  |  6 ++---
>   drivers/iommu/io-pgfault.c | 49 ++++++++++++++++++++++++++++----------
>   drivers/iommu/iommu-sva.c  |  3 +--
>   4 files changed, 42 insertions(+), 20 deletions(-)
>
......

> @@ -112,6 +110,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   {
>   	int ret;
>   	struct iopf_group *group;
> +	struct iommu_domain *domain;
>   	struct iopf_fault *iopf, *next;
>   	struct iommu_fault_param *iopf_param;
>   	struct dev_iommu *param = dev->iommu;
> @@ -143,6 +142,19 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>   		return 0;
>   	}
>   
> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
> +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
> +	else
> +		domain = iommu_get_domain_for_dev(dev);
> +
> +	if (!domain || !domain->iopf_handler) {

Does it need to check if 'domain' is error ?  Like below:

          if (!domain || IS_ERR(domain) || !domain->iopf_handler)
Thanks,
Jingqi



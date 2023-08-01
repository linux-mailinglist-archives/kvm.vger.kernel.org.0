Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6A476B347
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbjHALao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbjHALan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:30:43 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B278C7;
        Tue,  1 Aug 2023 04:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690889442; x=1722425442;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7W4sPPK819iIDNsFL7+NSiXK9Y5jzHk9HdKan33CE/s=;
  b=eQmxE71PGEaX0baFGSIUIGHHVTbPWBClsHa9WmX8kihprEf5gR/otwAw
   BwERsaBIP8MBIJNAIKFlNlnhlDOtsQuALGlWnrKLMNlLJPJlaelI+4Jqj
   2UwZCTfkBC1LKe/bpnYqkIA4K0T8ANklIrV1RqZisxc0iKh3ncvqtC6G4
   BLOd4GUYmRcoanTYMUBvLVp7jG7GZsVEiql/cSiNVRX4fAGgNzhcbfuFQ
   NvhuXwTIDgBLt5hHSPmoF7ODlFnr2bzrshVjmNAGfwRiwVvrDrQzL9ECQ
   luOOwZ4vbfqBiTG+tMTn331t0cBHD1y/Xh0F24+w7u53nAOcQqF9s9Lo5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="433109461"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="433109461"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="902526061"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="902526061"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 01 Aug 2023 04:30:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:30:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:30:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:30:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7UpTtAaZ1FQzDCFqYz5CcFuQ3QlQo2bWdGU4NfBGZ4+p8+aMbA7XGjckQXJw8cGxK0APsmPBsrToqHWZ5CdSEfMv5IsNeG8L51AbVh4VJEpXwylL+X0rTUVmGD+nNEj5Of41XPyU0Tt1o9k/+BhnjiZTnS4q32xpxdTBjKwmBeoCraCEvQU+4cVPMkmW1sCohgJq9uRJ8FXKW6m76/khZDRk4axzx+iynxtRp7xzNio2yX3HU7uEbLmmyy0IZuXzr6Z/+B4HB1A4lHywcTRCnwcPmC6eYXPjhYsRVH/FxWjj1o1kOeF5yCj8oHdSyibqSmUwxWigyCFh33NcJGClw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BXfI++YV4wnfwtprf5rHaF7QQtjhQ+QlNrGkZGqjJ/A=;
 b=jwAaNP4LB/DUXyDLdugUih6s6QLAtTDK+I6dBpCWhY4tyThnAzWDq71y8YyTCVIkhTFgV7pHykgjc2SMNuYkv100aa2uATWt9MPc2briwN14NXQ/zmfnMKdJ4jN6qBbs69/qvJSEFjS4YPcGS26ButiJ7n0v4heuUgq1lOMkH9qw2MRrL5xYM51fK0zTnJBXdq5xWYLmyYQClMcqlF18XKxL1dRyqi5qsJJzU+ZLil7g4AW2MwHrQmf4JruxhpHDwUimT1xEnqX7PzjWXoxla3UNyD1gHTr8St1MaWHtDySG953gHxIfO+NXdc/cE3zoBbpmVJBFT0vGGl2zQW+iNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.42; Tue, 1 Aug 2023 11:30:28 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:30:28 +0000
Message-ID: <3edf5f82-bc4a-9fda-93c2-a2d4b4b8e973@intel.com>
Date:   Tue, 1 Aug 2023 14:30:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 10/29] drm/i915/gvt: Drop unused helper
 intel_vgpu_reset_gtt()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-11-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0195.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::6) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|SJ0PR11MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 42725d84-1995-4dd5-15cf-08db9282b504
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jTNGNqB/+FYyx8wXEK59OjK78aJspRq8eVCPQfoOy7/H38M1BVyrcDXpnP8HrvGgJ6PLRZZVX0MYW8GdZSXa9imo76QtyunUqUS7iFnXNbnLyqXpQFkw//CJgn8ct0DPTKY51Zy2KzDBvNbUtNrOZj9TiLFXIQBP08y/YMoau3d/31vibXwT6ZuKYAYfQU/Y5sQJauQlRBRD1sfgUC3vvKqv97/beYeM+zP78bztxzHn3+o0kH+BgxsQvVmbPFjJS4YSAjcCu9y9Cr7ZaBWRvl8/vdInz2oWBVlsW9JHTjddlgNyeaOW2/atkIVPSoJSOcR9ZAoGR5u8qJ7DY+QRleMBqqt/pB5GRJ66ioyuhNbYIikkCS94jCxoav7RkC0SjAsvYv8/+QehrVO1RUIaf5B3uflSYvWttELUgX9BGGZwzeCIbzO4Ax11s5Ft6DA2ayCddGYxf1IjeEoP8MB2Ybi0qAPCARjhQmod3HwP3BSroPIUFhXFHfHUTj+j1D22X/sSUEDBtsKYlGUijNSTR8J0DIJn2Lc1ARogZ9MuG4efq37dPHadAOR1pVIWig5AP9nwKsVIlxFv6kRPqbvsfvtNPfdx6neK52SIYCal0W4I4xxzDaY3X60cvOZNfX22SwOa87vOb54nkynyPc8fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(38100700002)(82960400001)(31696002)(86362001)(36756003)(6512007)(478600001)(6666004)(6486002)(2616005)(186003)(26005)(53546011)(8676002)(8936002)(6506007)(5660300002)(66946007)(66556008)(66476007)(110136005)(31686004)(54906003)(4326008)(316002)(41300700001)(2906002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjBRdlZJa2hhaGExNnplQlZRNEN3WHFEY1J6UGV0LzM4Rlo1cXZKVnNlV2hj?=
 =?utf-8?B?SHl1cnNWWU0yVzV4N2hWQ1luRE94NDFZM0VVOXhBckpvRVhyVWNpR3JTd1R3?=
 =?utf-8?B?NkNYKzdjTTQ1dldQYjVzRnRrb2NZMTZKazFpWXp6cHJBV3hFTHpHWEx1NFJ1?=
 =?utf-8?B?RlNHUHh3RHkwbno5YnJEdWhIeXZWZkNqcjVoR2JickFBa0FhWUIwbXBQU29z?=
 =?utf-8?B?K0E2UVJ6QXdTSVphSFlKVlI3dWtSd1kraGNvNzZqQnprekRQa0svcEZhVkxV?=
 =?utf-8?B?R2VtMWJ4cXo4KzZsZVp6OXo0NXlBdjFqQjNEUE9aWHVreXZ0dE5FOUw2WDZt?=
 =?utf-8?B?NUJDU0E1NW8yR2dNaS9ZbkNkeVdYMjQzYkRMdWFyRzR6SlNsRm04VWpuRG8x?=
 =?utf-8?B?YTB4MkczelJlTzMxWmxYNnpuc3J5cGhjUUJUMXFRZDIxWGszK0p0THo2NFNk?=
 =?utf-8?B?Tng4cUFMRjB5dWp5Kys5NjJkcTNON1J0akRVdzk5Q0EwR0FsSFpTZC9nWWVr?=
 =?utf-8?B?dDJxN29QOEh6MFNpME02ZW9tTTFOTkZGZTBEM3lNOXVZS0lhOWZueGRDWk1H?=
 =?utf-8?B?YzBYN0dpMHBmTVVqcVpsNGVGaTFHMkRxc2hHdWdrK0g1SnBuUUZFVkgyN2Ni?=
 =?utf-8?B?aldOZ2V1SGJXeGxOTDBSNUxqL1VtaWVNT1lucWFUOFdxVFdUdUFIQUpnY0ZX?=
 =?utf-8?B?ZGpKNnFkYVFyam9xYzFtSnY2MUlyZmNqdkwyNDhjTHRSbjVIZXZFeVMyWnh2?=
 =?utf-8?B?bUdtTzd6SzhFQlJDbFl2Z1I1Tm85QWx1dmczei9jNUQwQlVnZU9MYTh1NUNP?=
 =?utf-8?B?NUVCakVDamlmYTNXK2tNWXVkU1EydXVWNWpvZXRqSDNmNng4YW5UaUdja1do?=
 =?utf-8?B?NW9HUDBzL21hZWlpcW1ZMWtLdkFEdkhNNkl1Nlk2U1M3b3FESmk5Qy9venM4?=
 =?utf-8?B?UllBbDhIL0xkZE8waU5LS1Ntd05kZ3ozQ0NDQVg3SlRBOXVYL3ZpbjFXaVNi?=
 =?utf-8?B?Vjh0RTdaSm9uTmFLalVxRENVMlFJWUZydWxPdGk5Y0FTT082RmpnM3dQZ1R5?=
 =?utf-8?B?M09CNFFLZjgwazAzb28vMTh2elplbGtCWkhNdjNEbHZqaDlMN0NIVmRGRVV3?=
 =?utf-8?B?c01yaWZCM0FIZ0tGUysxNDY3clJwdEdiaDQrQVg2UW15eDVhTnBSUGxuUFRM?=
 =?utf-8?B?QWZiNDVobnVGU3BWcFRQc1pOS1NhbWU5ZFVYOG9mSjBKN2htNWxNSWdlL3Iy?=
 =?utf-8?B?eHJxYllNSUVtWDRzS1pIcUFrSE55NjlDMW11M0VVaktWbUQvOEVKcjJIdlln?=
 =?utf-8?B?a1hzMlZ4NGZiaDVIdktCTndzZDdKbzQ3ZW1aeGRoRDZQS1lnTGVYeEI1M25Z?=
 =?utf-8?B?OG1VdGtLeFBJUmRCMHk0UmhlN1lPdzhOc3RXUjltME5xRXFVSWdQbnVRT24z?=
 =?utf-8?B?RHJMQnFDUEQxZ3BkelZoVUEwMHRVWDlTRWxZdldoOVMvSHUrOEpMWkluTCtZ?=
 =?utf-8?B?cVFGRHZRS2lOOVo0UWdnUERFZG13QVJlcktKeDNCVHRCSkF0SEpXY1BkQ2NC?=
 =?utf-8?B?YVIyVVoyWGYxZ0ErVndKcm1CM1NwWjd1YkUrc0txdTNPRDVXNGNLcDNoNlhu?=
 =?utf-8?B?SFJvMnVHSW1yOHNEc0pVZVNoWklWYTNvallUbjR1SERUemE1VjRwZllZL3Br?=
 =?utf-8?B?NkY1OFNvbzFVQkRHcmNWb3YwRVFTSHFaK0d1aXFMYzZ1UjVXUkNDQnRDanZx?=
 =?utf-8?B?cWt2a1FFVkpDNFdQeGkrTXVHdUsvdUQ0bW83WWNhZG1IVFh1NWwvT2VjaUZD?=
 =?utf-8?B?WHMrT0FJekxXOStXQUFFZ1VkSmN4QkJyK3J3QUpBZlV5RHNZb2xVa2JHcVVC?=
 =?utf-8?B?MHBtMXRsb3pOVElVN0NidmN3bGRJb1pZc2NKRkJkSXdtakEvVkF3aWRQVVQv?=
 =?utf-8?B?YlgyQ3RHMjVwbEdhK3RNRTlRWndGeHpxRE83am96bHpBbWlMR3NaaTdVQlAr?=
 =?utf-8?B?RGhTVTV1UGRuaFZleFFQVFptK3pKQU5GUUhTNmsvbitvNEhvM25QbGxHdXZi?=
 =?utf-8?B?WTBlVTE5ZXVtdGdyR0pBckJkUFBva1lib3ozcGw4NU5aVkR1SFJ5Q3g3Z3kw?=
 =?utf-8?Q?FxbdbfIC7FdzrRnOLBTiIpMt2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42725d84-1995-4dd5-15cf-08db9282b504
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:30:28.5832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BJ8HWuVLBgf91zMtt3GEKwm7qG/K1vFP5qmfoyE/8UCMUnQRrrio184cWqsNQWkQ73zB9gsmi9VqdpApedDTnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/2023 4:35 AM, Sean Christopherson wrote:
> Drop intel_vgpu_reset_gtt() as it no longer has any callers.  In addition
> to eliminating dead code, this eliminates the last possible scenario where
> __kvmgt_protect_table_find() can be reached without holding vgpu_lock.
> Requiring vgpu_lock to be held when calling __kvmgt_protect_table_find()
> will allow a protecting the gfn hash with vgpu_lock without too much fuss.
>
> No functional change intended.
>
> Fixes: ba25d977571e ("drm/i915/gvt: Do not destroy ppgtt_mm during vGPU D3->D0.")
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/gtt.c | 18 ------------------
>   drivers/gpu/drm/i915/gvt/gtt.h |  1 -
>   2 files changed, 19 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index f505be9e647a..c3c623b929ce 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -2817,24 +2817,6 @@ void intel_vgpu_reset_ggtt(struct intel_vgpu *vgpu, bool invalidate_old)
>   	ggtt_invalidate(gvt->gt);
>   }
>   
> -/**
> - * intel_vgpu_reset_gtt - reset the all GTT related status
> - * @vgpu: a vGPU
> - *
> - * This function is called from vfio core to reset reset all
> - * GTT related status, including GGTT, PPGTT, scratch page.
> - *
> - */
> -void intel_vgpu_reset_gtt(struct intel_vgpu *vgpu)
> -{
> -	/* Shadow pages are only created when there is no page
> -	 * table tracking data, so remove page tracking data after
> -	 * removing the shadow pages.
> -	 */
> -	intel_vgpu_destroy_all_ppgtt_mm(vgpu);
> -	intel_vgpu_reset_ggtt(vgpu, true);
> -}
> -
>   /**
>    * intel_gvt_restore_ggtt - restore all vGPU's ggtt entries
>    * @gvt: intel gvt device
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.h b/drivers/gpu/drm/i915/gvt/gtt.h
> index a3b0f59ec8bd..4cb183e06e95 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.h
> +++ b/drivers/gpu/drm/i915/gvt/gtt.h
> @@ -224,7 +224,6 @@ void intel_vgpu_reset_ggtt(struct intel_vgpu *vgpu, bool invalidate_old);
>   void intel_vgpu_invalidate_ppgtt(struct intel_vgpu *vgpu);
>   
>   int intel_gvt_init_gtt(struct intel_gvt *gvt);
> -void intel_vgpu_reset_gtt(struct intel_vgpu *vgpu);
>   void intel_gvt_clean_gtt(struct intel_gvt *gvt);
>   
>   struct intel_vgpu_mm *intel_gvt_find_ppgtt_mm(struct intel_vgpu *vgpu,

Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>


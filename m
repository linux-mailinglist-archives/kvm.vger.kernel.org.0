Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B2376B32E
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbjHAL03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjHAL0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:26:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793C41BF9;
        Tue,  1 Aug 2023 04:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690889159; x=1722425159;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kn5fe1vhbg0nTceOEUm+whnzjHJ7tFWTNiC85abxgSI=;
  b=iu/7p+PmZrslfNbbV4mN8Cy5TXb8iILPQ3OejypPx7jFU102S+c298sH
   hbWEQ/wxhc2DbEP42SW41lfcYzNfjeVQsqh30eemn2LJ1PXs/51gkMQR+
   ifovblgxyIQn/RqOC9N/rD/L0RNc7MfG9LElUIeQj0BSw+KWB44DXmv5I
   H2lfhvzIz/iSMxH+06RepkP8AXdkiZJs/KP3wUuauHUXGCDi5uA72EBLS
   QBiPEuFmoErcg0hm9+/9jybQE/6TX3BXWg+BV1z+nP0siQpg6ucy2Occ4
   i8uwV9Sdx4Q4xMzKTDqor7nqz322s9dakIlYLGpYBABafrE9GzNK1i2u/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="435595266"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="435595266"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:25:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="758301325"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="758301325"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 01 Aug 2023 04:25:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:25:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:25:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:25:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZiUBNI8IRVDX31HxfkV0+wlPGMV+ny3TF2IC55vOQinwarz3I+873Z2CgMMtMAsUDWyBfqpdg16pd/fTfJcb37pAfreeom98GoeG5OCZXhgOq86OfEFhH6REsCJaRiwpxlgyO9AIsUcWz2ND1kpJGbRfyTxdZD+6xs0BF8Jh+CfC/fw2inMCEyHQvbTvDiIomQNd47qwYwut3bqlEpvKjitQHCgFlGrF2DbM8N56vIygwSwoeskczCRqVHxytXaYZt/lGyZ4uPIbNCP0TtruXvti4Yjk6jcVC3myLERT8SN5pl29P+tZSoSbqGlenbklsq0dOXG1Qpj1v28B1RPiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PxUt2PZUAtc0x1qyIgXXZgivtfbSjS6zxTtoynYW9RE=;
 b=XfCOP5JtaO6HCiMKYR3iXqYGTOovD0CZRRiPPSLtTiUKFjVaPwEozI/pypV2IBiDIJwhqJrfHxw+tiA/nDSZMSHpl66dYbJSqHUJleeXgd6uk2yqguuHR+teX0D0xqEFkJ8MTO3RNZp7gbx9cR791weL4dk3KP0RziUXI8R276Pylz1uYYxWAfwvpaSO8d5uwhfkbCfb8VoDqVllwOYagOfySstynwAWupXD/zh0HGH7eacB/4hkL+3hPacbaVuBGYlYuDZp5Ei1ruUgiW0Wvjvo9CsxpkqjzOGinr5Gwvxy8V5rXWoMgkyLUV5XbHNGGIl/Tw3+A08Dh1jIjIWOoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 CH3PR11MB7204.namprd11.prod.outlook.com (2603:10b6:610:146::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Tue, 1 Aug
 2023 11:25:56 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:25:55 +0000
Message-ID: <a1d56c78-fff2-0c98-48dd-e4d66b1437e5@intel.com>
Date:   Tue, 1 Aug 2023 14:25:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 05/29] drm/i915/gvt: Put the page reference obtained by
 KVM's gfn_to_pfn()
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
 <20230729013535.1070024-6-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::16) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|CH3PR11MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: eafc120c-94be-4187-f369-08db9282125c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/15oBwXiAWEXij7ctffCLRijelnJhS87ivv1+TQ+Mkfk8/pOrVF2254ONTG4saCk+L+nM4Oy92P8LYvPK43i/bp3CtNGbvHQ2gIhBebvXk+Pj8c8SecPdfKtZLq1PiM+VQhQadlZFO1R+TFrjTp+gaq63A7eTP1yBgBFqQGPX7s5x1zkHfZknAiFaXtKqSVoSN0WUOuVcu8UZ3h8HwlgY+wuc1TjPp5XIf2eIw5f3CiBCBAnT3FYo1Kv06D/yMgU6nGc7uTP1r7CcfIJqM950oQRTKo3GmHj2K48M9XzQkFT7FjSRz/P2hV4otte08qvqpII+bLIDTl17UL9pFRSSERnQGKTTam08kAmYXEAcRs73V3m5AOMEBjvOuELFrbcolnN9wdansXMNsXASXJahKgi6glRrIyvNNd3U5qf+4eJoqLrVN3azr89kUW3Q0pxg1x7mAiOdwb4OHp4ddQeWPPLYSwawKUYk2akrvZyqzESJZn6QFSPnPkgaRgR3NadJWHMGFSX9Q9cZQvqnnXWQ6UXLEoi7EGOoJHyMQsyNjnI3eWse14d2sCAzptZZwO5YlLTpQdxx2GSjF2n92SfJAU3NIuYZuxKKWeerznWFd52fkSPPkgqNCqoE9CoPcqV6Qp43U1Aqd3Tp3xcxVNvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199021)(82960400001)(110136005)(54906003)(6512007)(26005)(6506007)(36756003)(6486002)(8676002)(6666004)(8936002)(5660300002)(66946007)(66556008)(66476007)(53546011)(4326008)(2906002)(2616005)(83380400001)(478600001)(41300700001)(31686004)(38100700002)(186003)(86362001)(316002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3JnSW83VHl3emhwUkx5VnBXMGdmS1hpM2NkaWRydkFRNmNWdkZLTDFxL3hN?=
 =?utf-8?B?UnpBQVJZR3Aycmh1amhlQjRuZ0JQOUFzc1NQRkVLb25GcnFPYVN0Nkc2Yy8v?=
 =?utf-8?B?eWJwUVNNeU1YVXVxd054SGowWVNxcHQrTXIwVU1UODJKZTF5RTE5RDl3RFB4?=
 =?utf-8?B?YjFZdG9mREFSTk11cDFrY0c4bnlqZzlhY2xqcU1Sbzl1Nm5lZFB2UCt0QUFm?=
 =?utf-8?B?VXlneDZ4a3NwejVXcHMyd3FZdnhXWGFFZUdGU1dsOU1qcU9DajdKVVlIakpa?=
 =?utf-8?B?WlQwci82YjVmWnVsRU4vN0VjbFNCM3RhYWJ5aVhZMEpMRFV2VkNkc2RmMk9B?=
 =?utf-8?B?bDV2QlhVaE9zVHorQ2pZYXUzWGpVeWptZ3B4UEpReEt5MnZhcGNwK3RMdWZz?=
 =?utf-8?B?YjBkS0J0VjJ3YzF0Q0pBdUtqaWdwOE85K3RnaTl4dHcwTTlTS05RRlZWRzNC?=
 =?utf-8?B?RVR2aFhTTzlQSVAybUhFOW5kRzA5aWtBN2dEdHRPWEVKcTc0NXJLVTk2bDh5?=
 =?utf-8?B?THdCSnlndENId3poM3Uzb2kycnoyRGx6UHB4TWZNVVJuNjZIbnpseUVuWXIy?=
 =?utf-8?B?d0VOdmNNK1hmblVFS0FVaVFlM0xDOFFUK1lHTnpkWUMrbnlTV2FaVWNZU0dm?=
 =?utf-8?B?bVkybStxb0UvK2JmU0NOVjh5ZlZYVU1td1FVSC9zd3BiQVYzb3Z2dmFJN3B5?=
 =?utf-8?B?V3lRQ1lXeUZjUXRqeUVsbC91SnE3N0txWHB2RVp1b1kzUHZqSkpzUmo2SDl2?=
 =?utf-8?B?WmtwQ0xnU3pkTklEUnV5ZVBlcVJmd3hZdnZHMkt1QnVtSzZ1SlArSWRrdGg5?=
 =?utf-8?B?c2xsV1NqVExoSGJRUC9DQzJwWTdaeFlUMHlSMTB5YmpzUFFIb2tZTnExN05y?=
 =?utf-8?B?dTh3WlQzTU9JSnhrV1FVTStJNVJXb09GajJiL3RoNEROTzMwa3pLQmxMR0lO?=
 =?utf-8?B?SjdKQnl4UHd0K1lWVzFWbWtFVUViazlvTXB2T3NiTzRUQWpLS3oyZytBK29h?=
 =?utf-8?B?Kzl1cHl1clZYQVVlcVM4V3pIbFBNT1YxVFdXamF5RWRJa3dmZjBjdS9GZnhh?=
 =?utf-8?B?L2ZhT3JiQUVHejZlTGZYZVpPUzNOd3I5bVFBT2JkeVJhL1FQQWpNdzU2OExY?=
 =?utf-8?B?eVNxRGc5OExTR3J2NC8zTjhFWVRVR3p1UThwcWVjQmRJYXA5WHVlYll3aXJa?=
 =?utf-8?B?RWNhQTlITytlZkladnAyY3ltVU9WU0ZNTWlZSUR0UTBQS1BvWEltMnp3V01Y?=
 =?utf-8?B?VGptdFZla2IzTGlHZXFVWUtxOS8rWTc3YkZFcitoUFpHWU40UXUvK3NwcUVL?=
 =?utf-8?B?cmhIRFkxaHI4dXA5UjJKY3l0VFJqOVJWWDZsZ1hwOFpNeFJuSlh6VFRkeDRJ?=
 =?utf-8?B?K2ZqUW1QNHpTS1A5cHJkemJiRU1uQzNjSXN4emhJSHBPc1Z3YVN3eldpenVx?=
 =?utf-8?B?d1JaTnVMdlhIZDlYR0lORzFSRTBrMlgxbmw5bmVWcWcvMVBSMFBFSmxQY2Zs?=
 =?utf-8?B?ZGR0SVpabm84b3dDOEMzVEIxZUEySWp1dG1wUld2U0dZK3pyM0pBdS9MR3JE?=
 =?utf-8?B?M1hDY2VpeG9KS0Z2YzllOWhvYmVnbFFEV2NtOVZ5dis4R1V5djZTZzd4L3dE?=
 =?utf-8?B?QWZQRzFLa1U1MU5NQmZmbzBNdEdvQTRMZWxVZWZSVytPc1JHUzZna2tYNVl5?=
 =?utf-8?B?Z2NDa0pkUmhmSE8xOXo4cjZhTGpNNWtkdVpuY3Nyek11TUdBQ1p3UGlaZUY0?=
 =?utf-8?B?Rzhtc3A5akc5RUxMS2pmYVVoMENuaEJob1NGbFVCWE5CTi9hemJRclBQd1Rm?=
 =?utf-8?B?RzBHZTVHNVRoWUc0NjBQNGNvemlDQ1FpWW1kSm5PTExqM1NzamVlc2NLZ2ZB?=
 =?utf-8?B?OTNxYWo5RWZDNG5PTU5Hdk9MNHFDa0ZRVWl3ekJJaTh3QzQ4MzA1TE9pcCtG?=
 =?utf-8?B?OWNaUnlDNWg3SUJINVcxVXIzM2x0RFJoejJ1Mkg3WWNtZjZ0Y1JpaDYwWnM3?=
 =?utf-8?B?TWZ6WlZLd01qa01mamMyTjM3c1NsZUhVbTRQSEtPRFl3Z0VDOUZWT0hSOENZ?=
 =?utf-8?B?STVkSlJjbXlmZVJQZ2J5SVE0WnRBeHFxeDdxS1Zvby9va0M4SEdoQi9VczBY?=
 =?utf-8?Q?PKEwnt/AdHDdsMPl0iiIHdqrp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eafc120c-94be-4187-f369-08db9282125c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:25:55.6758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iei5C2hBbzIgLuBCw4aW2yZJsmDGwBLm1hHLrJOSgpAq4tVjKhOh+AtwLWI4ZTG+5FIxRIBuhnJ+SzphzeGAOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7204
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/2023 4:35 AM, Sean Christopherson wrote:
> Put the struct page reference acquired by gfn_to_pfn(), KVM's API is that
> the caller is ultimately responsible for dropping any reference.
>
> Note, kvm_release_pfn_clean() ensures the pfn is actually a refcounted
> struct page before trying to put any references.
>
> Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/gtt.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index f30922c55a0c..5426a27c1b71 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1158,6 +1158,7 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>   {
>   	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
>   	kvm_pfn_t pfn;
> +	int ret;
>   
>   	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
>   		return 0;
> @@ -1171,7 +1172,9 @@ static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
>   	if (!pfn_valid(pfn))
>   		return -EINVAL;
>   
> -	return PageTransHuge(pfn_to_page(pfn));
> +	ret = PageTransHuge(pfn_to_page(pfn));
> +	kvm_release_pfn_clean(pfn);
> +	return ret;
>   }
>   
>   static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,

Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>


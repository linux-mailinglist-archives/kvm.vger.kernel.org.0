Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD5B76B33E
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjHAL3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbjHAL3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:29:09 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DADEE5C;
        Tue,  1 Aug 2023 04:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690889345; x=1722425345;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JkHcv6rbvfI9ptSXtW3GU0R4scO1kuWAXJg53Ztn/XQ=;
  b=Fhq8RFoHH15ULxQyvL7PimxB6ZEqBhKFO/alWLwC0aiKXltQ6oDH/2zO
   zVhiTjO4+Zm3amG5xvR5ZBurNQ8+xkY/10wcGsGq8utfiqpxFxnzGFheM
   qitku8vTFr1s6y+MULLo5NjSaLFpAHVzKPTe7hE+m273zFP1Lzn7EY3Cc
   r+g/az/ubwoTWYEK6pdQEj/eHVLAox9mW0u5EipZbKKwz5b8wCbbCVes+
   Hl0oCmid4iYlTZ1A8yuUivT5dIH39KxVpxgV3Y9uRPPwIoeEqTKSDgyNl
   1hibmBPYV1lSvsSpJZp7OUNrNbZVi1swLuBBEr53Ovg7qzz9WnEgk8+Xo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="433109156"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="433109156"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:29:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="902525790"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="902525790"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 01 Aug 2023 04:29:04 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:29:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:29:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:29:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGuwKHAjFncGFWt73x0WrYgeG2nr7tACPkJtqaQJXaNgSipJWv43hMV4aTTjCcEtFNsyRtBP8DuM28H2c2Vdcw/UneSFYCs9pj7o5ANVQ05jDYcsv16jLFauNs2Aa9MmOxiI9hyWxz4ZvzUMloe34VVDykEe2RNwxbLmjVLpR7sjXtnIg4BNVulXvwK0ku8NSiGBx0dOfjkxnnyROYtDL4S5pM9Rv5TMf84R5+RjfnkT8cniexWrOVnTI55Ir9Lh2ko+uv+crRN5y5chgZzX5nozrOn0W90biyZDBb8Bnu5LLVfMqcf16OdRVFtojSNfD/ioMNXTITJ3gGKoiS4vmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4l576/YigkZOF3KqVcr0sgpX22RiF7N9Vend7Wd8x8=;
 b=HSI3EyFk0Xxp9EZh1IHdUZsaPap0JmWobAsBcJaKF7byuthRdlF2AdOmneH4XIm94HfF8upqvSoZ4q48mYpxxK5+0gIT1J9f073jUogWdgl9wRPB0eaUgvUOF5JzAi2z+kXVJ+d1wIUmUgj6ZxL7h/lhECxyOtLgeDLbVACbVtlfQNWVRtvoX1iu2cLnYKsxWujKQfk8FAnUoxFl/TTHAdbRiL6LgZ12e2wuASFjBJj/hK+Bz90pcxQrCoDJn9/71p7sreBtrjLb6JtQAfAHd0wnSkxxDmos/t8h5fgG25cPmCBokrh96ZIf+34Ya7dpCjY6eNWGe1hlF4pAj59c3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.42; Tue, 1 Aug 2023 11:29:01 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:29:01 +0000
Message-ID: <4bce1e71-5d9b-34d2-cf7d-6feffe131f09@intel.com>
Date:   Tue, 1 Aug 2023 14:28:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 09/29] drm/i915/gvt: Use an "unsigned long" to iterate
 over memslot gfns
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
 <20230729013535.1070024-10-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-10-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::9) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|SJ0PR11MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c9e4fe6-9c36-4baf-5001-08db928280c7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1HYwmA5ZEpuXShtG/nUIt0u9eCqt2ZXJxKvnGp18o2ZKb//9BBJWo4sK3BWREsAKmBTqJXQmfis/QASopufpecP33Mxp7mWt+XHQ9/Zcre5lZ9wireMmgUs3OqhR24slY7C2qiQyyGQ0soFxFjpzW6jR+TDdIlT9F+sb6jiBRcORot0Nnj9bQzrAYtGJOHWOFWkDkKbB5AMvvN26xjptVCZTfUYDBT/Izh9zXRFpjqzni1sQgBxWaFwHLXAaRE1N/jjitvqXjFkTHGyikCO+7MdacI1X7PMKqcixU09o3Uef1fWzkQPwCt1unhr7xTS7wL70zTG/cCUQYLCAEhO82VBmPvLbLoqevbFEpeZLsTnkLPJuwUh+KZhvJ/H5iCcyfugz1seUyv++5z1E3+UhI0QReVjRU8xTFnzPULFI4APo5lXzjo8z1AWnFWYGXrayP7p0Bhtqs5sv2lST0oE4k4gs0HCEqmQPQIJ6HLGbtFDmD2lrVzMCZFKtNlyvaysfA1sIeAcmvnnfdSsSL7bT77ECJNTbUP2RL7/4p2GI50QDPASkYqpe/OFTEqrYvVHaHcMccbo1PNkMNWcQagmaEwuE3o386NCcxwAwmhl47VlK9Ui28QNoHbgtIOTiLGINcDPIKsJuzCymz2BqklPKew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(38100700002)(82960400001)(31696002)(86362001)(36756003)(6512007)(478600001)(6666004)(6486002)(2616005)(186003)(26005)(53546011)(8676002)(8936002)(6506007)(5660300002)(66946007)(66556008)(66476007)(110136005)(31686004)(54906003)(4326008)(316002)(41300700001)(2906002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVJpRlAzUzAzdlo2aURzWmoyZThuREtlclViK2JYWXlUV05pSm5naGEwci81?=
 =?utf-8?B?MUNyL1NsbEVaUzlTRjd3NXlvNUZKa3RlNUNERzBFd1pFS0RtYnVlUXJld01j?=
 =?utf-8?B?THpDTGlraE92TU9OKzNSbUsxL1hNYnAzdk4vSFVTcDRzbkJrd1FrYWVWNnh4?=
 =?utf-8?B?NHhsVzJZdXk5cVBldnlWcGozZS9mdTJ3eWNVdTYxaStPNUdWemdsTEc0eVRN?=
 =?utf-8?B?UzRHTkp4ZlRKREVMeUhDWTJwZWZTT0s5ckhNMENENkplMWRjQTRwTTFVSklV?=
 =?utf-8?B?N2wxZkRBM0pwZ0s4TXBUVjFaOHVFTFFTdTdOWTJFZ0lldURUeU9uOUdKYm9E?=
 =?utf-8?B?S0ovVXFTdE5NR21YRm0wNGRER0kwNlN1Y21WZ3IwVVNnTUJVVGF6d2cvY2xP?=
 =?utf-8?B?WUg0Nm96MGF6SE5qc0wxMmxXQmFLZTJobWhoR3BUaENvRm9vYkhHTEZmTzdQ?=
 =?utf-8?B?Misyci9kZTRwcUE1VE93YU1tbFJnSUNMU2lKZ1ErV0w3SGRoVzVLUnREdmlo?=
 =?utf-8?B?YlpqTnZwMDNCcS9tcVZlem44bGdJdFRyV09Nang2d1JqTkZreElQZnI0a0pa?=
 =?utf-8?B?UTJpWUU4S1ZldGhodDkrdnRqMFowRzl3SDhEblNEQS9KZStDWXh5OUhoRTk1?=
 =?utf-8?B?d21sNkNJZ24xVUJnUEROUjZKdVU0YnFhRkxmZlFiMy9ZeUpsT1VGSXhEdG1j?=
 =?utf-8?B?WUxOaUVzU3hYU1NrYzgyeUQxencrTTBkMU96ZUNXMUtHakNCdUxnb3pUNFls?=
 =?utf-8?B?Q0pLbnpCMXdxVlZKRi9iUmd1dUlyTitWUWJBUU9TVWswaURqR09EeFBoQm9U?=
 =?utf-8?B?RHhzUCtyeEN5RzdFVmUyM3FYV09QdVM3cGFNRTE2S0FkOW9CZTVoeVdsci84?=
 =?utf-8?B?d2VydVNSZHVkSHhSSGZzOHpkbStIM3Y3QTMwcUF5NEp4Q3F1Z3dQemcrSjNB?=
 =?utf-8?B?ZVVVeWh2MDZlRlNjYm5PcVk5SGkwSUhsWHZ5K0tieUloNDQrY01mR0JDS3lE?=
 =?utf-8?B?OUd3b1NldXoxbCtLUDZ0b1FwSWFnSDRsbGNuUTdWeXpvN1kycDlvSEJJSkYr?=
 =?utf-8?B?RnEvblF6d3JrVWVNQWlocjNLR0ZwSWFybzJaZUY5dVA5U3NEYVpyOUFRRkk3?=
 =?utf-8?B?Tmpkd1RRU1dmc3loY0Q3aUk2NE1aeVFJay9DbXJwYStiQ29wZmtIOENBR2pO?=
 =?utf-8?B?Qk1sSVFZcXMyK1F5cjBoQ3cvOFY0ejFQWmtzTm8xMW14OUNULzA1RnlIMzdN?=
 =?utf-8?B?cHcrL3Fwa3dHdTJqSFdRRWc4N05Yc2M2bWYwRkhNY21LeXVVNjJpN0k2cnRQ?=
 =?utf-8?B?KzBpaTdWZWVNVHMwZjZMRExtMFI3QzlWYlBSU0Y5UXdTNWUvUjJHQnplek8x?=
 =?utf-8?B?UHZrd1Y4ZEN2Y0J1b0V3cndhcDJzb1dITmVRQ0ZYcjlEQU83b2hrTmdTTVNa?=
 =?utf-8?B?bFN6eitUT2pDdGIzc3pYUlFWMGRJb1lxUHAzVW5aRUFyaWE2RXk4eS91VkNV?=
 =?utf-8?B?bzRIREFBN1hVcjM4akloTldMcjRSOWg5YTUvazNiVGdjVml4MnN2T0xKVFl3?=
 =?utf-8?B?RHRLV3hyUEhzaEhGMjQ1OEpOY2JKZWV3anhjVU1tWGlSYTh5STNtMmF3NjVw?=
 =?utf-8?B?QitpTnJOVkpqb2lKVVY3NkhUeXpwcXR5QkFrdDA3em13N2VkeVdLTDFUUjVR?=
 =?utf-8?B?YlQxbVBNVmIwZjZXWS9vcjZQRGF3cytZWTZ0UElFYUJiSXNxMEE5cEhEdGFR?=
 =?utf-8?B?N2YzRkxrUUJuNUNZK2dBc251TXY3aFlZNmpNVUFwQlAxaFdsakxhUnFKQW1i?=
 =?utf-8?B?N1A5ZkEydEdKaWl4dXVlTEZMaXBmeEhlTEw2QTY5dVVRSC92TDl4OWxZYk5Q?=
 =?utf-8?B?c3phQXZDK1BIUWJuOHFnV2h4T2xMbzNHeVppOVBzekRhM1BHdDBaZEQrdzBr?=
 =?utf-8?B?dVZad0RhVCt6MjNPWm56OTIyWVgzaEFSVkh1dXgzL0tTbU5vQk8zRjJHd0NC?=
 =?utf-8?B?bXRTaDZxcGxoTkNDTlVMYnBqRnhNcHdST0F0TXNiMjRtV0QyOHVEazZkRXg1?=
 =?utf-8?B?aWpNcm92QlAzcVlpU1FweExBUjVYSkJBbGlvZ2VpdzhObURuYkJqeCtBdlZ0?=
 =?utf-8?Q?BKbnBjRKOqFoBRN6wD3Frtt/A?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9e4fe6-9c36-4baf-5001-08db928280c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:29:00.9370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ooq01j5AlIKcBuhfbhjvrn2ibmAWw+96OcC115hF4uTNe/m/4D03n9zq3rA2/LMOi20/7U2ZndUkCRuD7/njQQ==
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
> Use an "unsigned long" instead of an "int" when iterating over the gfns
> in a memslot.  The number of pages in the memslot is tracked as an
> "unsigned long", e.g. KVMGT could theoretically break if a KVM memslot
> larger than 16TiB were deleted (2^32 * 4KiB).
>
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 97c6d3c53710..6f52886c4051 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1620,7 +1620,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
>   		struct kvm_memory_slot *slot,
>   		struct kvm_page_track_notifier_node *node)
>   {
> -	int i;
> +	unsigned long i;
>   	gfn_t gfn;
>   	struct intel_vgpu *info =
>   		container_of(node, struct intel_vgpu, track_node);

Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>


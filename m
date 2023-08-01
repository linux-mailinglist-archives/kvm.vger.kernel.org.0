Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9EF76B306
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbjHALVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbjHALVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:21:12 -0400
Received: from mgamail.intel.com (unknown [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67AC1BDB;
        Tue,  1 Aug 2023 04:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690888738; x=1722424738;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rGSYKW5XJtHKfozE4PVOikgYf77WKQVKdvFCnBVgY+k=;
  b=d1CcnUvdPmLczdLxseJkRa0N/N/GKQ3m3XQKblcCtmDwsTeiwev25QuO
   kzz6ukGRpacM72LD5veTV6LRuhl47UPKt9p0dS7HWOWOoWBYYBeAkxChI
   2T7a8s8EFc48yzQGmw5Nd8ukYozZe7D76x/uZTIUQgwGKE2pZPxn7hseJ
   cWk9XnCcJaMGbxFrxCZjefh0ntSzKwY8qhUG4B8mOybLBwo0uTJEBZBVL
   obq3/bdCGb/yLZr+ENQHsP3xZVpamYqsqb3xI0dD7xcbYSgFKKMRCG6/B
   R5qQNcv6jpVv8VcGbAkrGQJAXh5aRuTEDfIcdAKsX4fnBWkqkLeSDfls9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="435594036"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="435594036"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:18:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="1059364701"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="1059364701"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 01 Aug 2023 04:18:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:18:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:18:52 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:18:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXKHuZ7bMcBAkEXyUSxZ7ES7GTtvVTapoNsiMM85K1LOqKlhgRQnqyn4TvJyi05mm1T2ihCF1gNT2RGqnwrtZoqd9tW35skJW7DQAh8MV89DThhPM/vlXe+obA5T2gKB6nZkI8vk6BGYOXtXopzlKJrP+pJ4dxzZI4ZyuLS0ToNzN5aLq7ZpJMQP68Q8JBRSgitat2/Jfvz+yItGF9VRV6RwB08n/xKroKp3CTkTMUvr1qaiGOHVHehI87G3WYYaZjXzrkxEugZylIl5JQIYZTQkVfcWafTtq0PaMYB2l+2mVtjH5OXQIA4HVE/Hgj6i7WXBpzpat8HECxfeJnDpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCK6eHVSbtfngog4Ksr9YvP+pl74qvz8ne7QKpdTPUo=;
 b=hINO+/vXSAtGLBzZWktW2TlLtc4Odg/FgyJa6MUjqGaalp0284y6V6Rku/2XUhYWhwP3YCSserepvUvGH07/SG1LomxWBI3ft+1CaqTY/wH2n7Ex4n5BCtOKobRVJXVrdyeXsBI2egVREbq8oCgIOeNHPRSp8eDxNKTat5HeKpIHO+W/5e0aY6mAPaD8lYCRBQvPnCT4C2SYxsMU2liN4BiyBnjGReWaqVuswvsrxfs6TBvGKNjH7W/CjazoBmTIMajNxkwyo8bbsrxq5zO9wLmvIsPq0XDNZmjBUbuDKkvtUbel+Xwyys0pqogRkUaKqJwhYLIG5CWW3iGS6/zp/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 DS0PR11MB6495.namprd11.prod.outlook.com (2603:10b6:8:c1::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.44; Tue, 1 Aug 2023 11:18:50 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:18:49 +0000
Message-ID: <b88e5ced-f7f4-5fc7-b7bb-df0201697444@intel.com>
Date:   Tue, 1 Aug 2023 14:18:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 04/29] drm/i915/gvt: Don't try to unpin an empty page
 range
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
 <20230729013535.1070024-5-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0226.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::19) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|DS0PR11MB6495:EE_
X-MS-Office365-Filtering-Correlation-Id: 15d2ca82-3334-47af-3eef-08db92811488
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MXcbIOEnrys2LElPwA4HqHu8qLdhBkqNKBOy43T4eFMYuiaheYoH2JcGyFw5bjDJDWJIeZh6W9DodygGQGGkEdR0LE+vgS1kj4tnBLvCwCaP3umO0B9zG4KKQTM5daDUCnFcCl5Erbwxo7eijuxvGtqABm0u3XPmEyzSlIQKEKyGu/5x9zOQpjNe+8z+FJNgtQRZtnBzhET5ZTW5wn/bgbcOdkZJAjPsQVXc/HCDABPC4PsyrwbvZmYb6oSOLyLDc/DU8UUeyJ704L7QcO2eKExZRk3TRKW0f45NKzmlmutc68VCDanywdahJEwNhY2/1GtOrkF2zqyxpzIOkjcSTCHZFaf5q0vOyr8Boe2JmhscKVJdqRl7x/os3AN1JibeOOcEfX7Muy0DcBrL3rV2Jzw+q0nA4Hn0kDZGVkSKhmEV1XgjUQ3n+q8AsGP6Q7MyLMdv3Om7Qcm/XwEqDYPUZz/YgTT1nK1DK6p+VIXcVrKSpstQuZxf+tPG0LNH07DeEzsRQXqBLdUUr1omh2XQpK2hu6IcRRMcSHQPwrr79nEc4X9zEZv7tu44TQLil4dhiZEkv0+xKXNe2T/2b7uPizpAsWxtsSBk0jlVXWzHi/Ow0P54V/IFuAR815L9vaD/iUvbq2sAkZopGcc75Pqciw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199021)(478600001)(38100700002)(82960400001)(36756003)(31696002)(86362001)(6512007)(6486002)(6666004)(53546011)(186003)(2616005)(26005)(6506007)(8676002)(8936002)(5660300002)(4326008)(31686004)(66556008)(66476007)(66946007)(2906002)(54906003)(41300700001)(110136005)(316002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2tjc2NacDlZWk1PNVhLYk9QVlo4c3ljNmoxWDRNSjNORnZJMEZndVpheXIw?=
 =?utf-8?B?akYwUU85MnYyaXVtVm5WSHBuQ1Bua2NTeEMrc0pkNHZJSlVEcHZKczFkbWtB?=
 =?utf-8?B?NjRPNXhsakQ5RGRLSEdzMTdRZENGOHRMeFNZZlRwWmJodStuRUhXV3U5U3Nv?=
 =?utf-8?B?MVdXMWRJcERmT1J3T2RydWdYc3hmYXFkcEZqZjVjbzVWNFNBcXVzcy9zd2JN?=
 =?utf-8?B?THg4UHhsU2pidHVEMm51YkhoS2dQbHl3NU5LanltM3AyMmJQNWt0V2pjU2Ns?=
 =?utf-8?B?ODZsUk1VazVMWkplU0FHWG1pWEFCbmIvME95bGJ0K0dwdVh6a0U2anpZdy84?=
 =?utf-8?B?L05aYllEczJEZkRNM2V2djZtRVphZHpUeStGeFhRamV0TWp3cng0L1pLQlBr?=
 =?utf-8?B?T2VidHJaNFlObGhXOWVlZVUrTDk4dHB4Vm1KTS9QZy9ramFHdDlpcGpGMklB?=
 =?utf-8?B?NWQ1QnorcHkvNzVmYnNqaHZEdG5ZMFp1N3FKczR3V3k0cFlVSXFNWTNVSjBp?=
 =?utf-8?B?WlhoYzV1LzEza09mWXFtR2lsK0YzNDR6aU1xeHY3U29pSUJuVW92Z1lvdmd4?=
 =?utf-8?B?UTl5SjJ6YWlnWmZOeFBmRnpFSlNzK0pKN1d4b1F1RStMUFlIVndmMlpBb0g5?=
 =?utf-8?B?Ukx1azdSWkEyVXZmdGxYc0tFa3ZkMWdpY1BrNklxN0FNVVBnbU1rL09SajFj?=
 =?utf-8?B?d2ZwYXZQSGoxUEY3MmEyNWtuQm1aUytKbGVCdVdkWi8zd0tSMFoyL1RqZ0N4?=
 =?utf-8?B?U1ZaQU9EUWtQNWM1ZFdRZENoQWhGbnJ2YjJYK2tpeUVhdTY2M2FhSmMrSk1F?=
 =?utf-8?B?N0tZL29RNEJKQjI2aC9Od09Ock5henhUaWdJakFWaWNmR0s2bUxjRXJ3aC93?=
 =?utf-8?B?S2ZIVXA3R3lYcFJ0dDZ3QW11UVV6cjQ2a2Zsd29FQXEyY01oWU9qVXc1Skxy?=
 =?utf-8?B?RHcxV240b203OS9XalFySDFmNER2Z2hSS04wMFgzTTFONEY5bWhyRGhQYnhK?=
 =?utf-8?B?TlBwZ0pLd1BBUjNmU2ZzM3FCZGMyOFQwYVRHSjBQVTdaRVpqRGNoZHJsTnpz?=
 =?utf-8?B?YlJpQkpYbTFQWlZLWkttSlVIemdhdWt3VGlzVFQwZFA5Ky9pY1E2dGt6eEtk?=
 =?utf-8?B?T1NRNmN5cE1jNjc2ZUhRTUZCSENzSWRLcTcxYkRCU0Q2K3dTSWk3V0szRGZi?=
 =?utf-8?B?NDBJdkNyd1ZaZmZVTURlWVIzRDAzVnZtMWJ4V1B2bk5FeDhiUWpSZjFVd0wy?=
 =?utf-8?B?cFdXRE15Z1FCMVdENU1SckJZa1dISXYxN0lybUx0YkY3Rk1oSFhmb2Y2YnZn?=
 =?utf-8?B?NVQ1cTBYRHgrc2t4bURpZUM0anUraVZ2NWREczhhb0lPTlozMjcvZVgxVHVD?=
 =?utf-8?B?aDZpMDlFbW9MVGIrcmthYklKSm9XeU9GMTRaRW9jZkQrZUxkQmY2cWR5dzhS?=
 =?utf-8?B?dUNjQ0dicGhlNUp5YnI1TEdMdnBHcC9QNm1ydHM2NGZPNUR2VEJjUHh0dVVC?=
 =?utf-8?B?eHFXYmg1b0NGdHhyaTEzME1FRS9tVmNwaDZaNXlpNktFMG9sMWt6RHBSWjFi?=
 =?utf-8?B?N2tWVXU0ZTVSUG80V1dPbmQ4OUIramtjSDJhMEhkZ1RsQkMySFNUYk9qVU0y?=
 =?utf-8?B?cGp0ZWRDbkVCNklBNjRtVmtSSDFvY1RiK1lMRzJTaU1CZXFPMk85ZVFHdjNw?=
 =?utf-8?B?aEtWaWZKOGw4ZzBiRDcxSVE0UmRUNlBqZFFzUksvZDJaR2NhVCtjNGEvMHAx?=
 =?utf-8?B?UmMrVVZMd3ljK1BER3kwdGFOTFBBZDRLZ3o2bFlRN0FUYnlVTkNoZzBxVXVG?=
 =?utf-8?B?YlExVjdNeTNWZmdJZHpkS3dZUmJIc0lYY3JyUDE5NUV0dmt6UXAwVm4yYk1i?=
 =?utf-8?B?VmlzdlVsTGFidElHNnZRWi83U1IrY2R3d1FieWJGTHpYb2VuQnZSeXY4cU9q?=
 =?utf-8?B?SHVRY0hQV25ERjhVU3dZWndVajJ6aHFIQUh4WXdLOVJMc2JGVUh3dXBjaXNL?=
 =?utf-8?B?cGpyTjRhQW53NFRtbU53Vk50S3dFczdsZ1BBTy9aK2k3Wnd6TlZSdFVSVCtn?=
 =?utf-8?B?aDdBYlI5ckNjbDhRdVd2dU1EL0NLNlhvYVRCRTdBNnVtalB1RUxaZTh1Zks1?=
 =?utf-8?Q?5vDaYY5MfLk1nnyWNFNFYxTmo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d2ca82-3334-47af-3eef-08db92811488
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:18:49.8725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzHvTatribODZbUYaz4qNDzgDeKzSvyqt9TqEoDMS0dbqAZ92oowzFd6PbyAyOycPXkmRDx+jbsccYCPEYEXpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6495
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
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Attempt to unpin pages in the error path of gvt_pin_guest_page() if and
> only if at least one page was successfully pinned.  Unpinning doesn't
> cause functional problems, but vfio_device_container_unpin_pages()
> rightfully warns about being asked to unpin zero pages.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> [sean: write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/kvmgt.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 429f0f993a13..0366a699baf5 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -172,7 +172,8 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>   	*page = base_page;
>   	return 0;
>   err:
> -	gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
> +	if (npage)
> +		gvt_unpin_guest_page(vgpu, gfn, npage * PAGE_SIZE);
>   	return ret;
>   }
>
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>



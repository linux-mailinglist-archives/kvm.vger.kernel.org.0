Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9E278683B
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 09:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbjHXHWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 03:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238047AbjHXHWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 03:22:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C5CE66
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 00:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692861721; x=1724397721;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VIjpgFJwc75poWxS4jyVdLFcK8gTj0mkb1S5BO4U9Uc=;
  b=ndnhRgD9F/daFeMjJ33VgGEmtr6a8rK38mCnPOT54+b5xuWinGmZYQoY
   g65k2bg0WBQ+rtcsmoHIWDsiaDqVOquzC0q3iENIbMDkM6UGq3eeB/flb
   q8p4bOpmuYBH76g/k+mbG6N6vO2Gz1Nx4J56YeunaEbU2BwqoRAAm7e96
   RJD62bF6E1GzklUake/PGfSK4yWCK1LmkpSbWLi+5o+RdZH27UYEUFSpY
   AyfuY4Yzt+ur/iCw/Jo/r4ot/BsDhcz48O3cctUyLqvKG4LEaZWJLhpeE
   +E2Uc3KAJFf+Z73nG6hizYuI6H8Hyhx+FqadeDHlExUmB7OJhxkqSnaZ/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="460724104"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="460724104"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="730488520"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="730488520"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 24 Aug 2023 00:22:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 00:22:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 00:22:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 00:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UayDwaudXm39VAVdRujtcagHPnAYvRCU3ds1h2/HnuZCcvJf5XdsrkoafgaH0ZWMZ9yP4LK6xvv8gRGNHr5WCjkrnSZglZW4gng3E9HmHGd5qJbkfYn6MzjXLMhIKzjbvwKHHsVfu0TWoq0YS+YzBIKmX1HcHmT62NstBbiV6ZuN9qEMJnO7hNSrHa8kEaR9MU4y3aC7B8jiNmwMNDtTuYk21IhWo8HGm8ekgaNt8MU+5fNg9qovn01nN+RBtfRaybdF5bjiz8CuXOaAviuMwbbFxnV7vvIwo9korAYnTqIQ3t3VGaZvDx/CtRYLRDC0qnapX5lhwax7zwQt+BAeeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iONsn+8OuR2ZmQjjjWG/kl+WwukTUDQJYXl6SUY3Pz0=;
 b=NFqxzuPGS5uhCUg3KWiFa/0BHCSohLxAAHmegn27AteIhyfyIDvhHV7Pi1AzhF3h9YlD68xSCRteNghmfqOVtl/oid3OAJDKtAJQrS8x/9caaRYrw0DJWdPCF3aDqZus7DMmdw8CpZ8EG+qu4x2eQtk0Sc07nzX9GB6iUIyqlM0K/Q1MCNcaJw4rKblQzRCjhicxrDvoTByJJWJzBKiUPpoCFq6erEY2jbI/PYpkdT7fGHG5/oBS82DU7425L9sMhPC+lNJ/DBuwyPruFMLEHt3dk3wMEaDAqHbh6X+58u/Cz/yCzqWSgYsF00wTxuNpmw/KIoO7famNjxqT6ue5+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by IA1PR11MB6292.namprd11.prod.outlook.com (2603:10b6:208:3e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 07:21:56 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::3f7:57fe:461d:83c2]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::3f7:57fe:461d:83c2%4]) with mapi id 15.20.6699.026; Thu, 24 Aug 2023
 07:21:56 +0000
Message-ID: <7629706c-0b7e-a8d5-ed52-21c6eeecd184@intel.com>
Date:   Thu, 24 Aug 2023 15:21:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 43/58] i386/tdx: setup a timer for the qio channel
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Igor Mammedov" <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        <erdemaktas@google.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-44-xiaoyao.li@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20230818095041.1973309-44-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|IA1PR11MB6292:EE_
X-MS-Office365-Filtering-Correlation-Id: e826564e-6f38-4c31-bde8-08dba472cb17
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vmx3YJwoaNRND9SMwbabRX4TJVlRh9XPPe/WCrTV0jBhYVFdQxKYDqmNMTtFoZANxIMGZbN9UBZHyhoSflvDwuXdYntQh8aByksjGq62BqWu1fWWGhll6eW7mjFp3cy5sjJUJe/P15Z2SrE21aC/mXLfAsT5rCk3ZFaQ9eyYXdP48/Xaq27jwgknhnJZwnYXpxckPrsRidaK+XWYVmPzfvsf8Ny5a0jvcFPDm6PozYUAFRSexpnRWv6OX0JLX2btc5KPBAWDKTZELwPR+YNmRTmtycJujY3DTw3iAooqTI6Bdhs+y4h+ItjdYPzENt0cRixE0shTcCMIe6VzdAjUyOsjQA0xyzn0s0XvY6Ao1R6yz1A+cU0UzASkkKntdPjkpOgGKqno976bdKV9W1mmDMUJ6CvsBCMFW81GlBuDS9LWfd4X0q4wXR5oq8im0wnlgYSaM6dmsFuay/Gog6tSMEh5O+ee+H2YpnMTfLTEkIXMeIx69iAxrD+mX9ICEXKlNC2Hn+NLec9D4zSCO1NNo7PoQIxliRBo5zFpAuw8IDmDETZpv94ZX0fBj1B3QXnaHdlx2e/sAxsCbH3eGiq52qUNEq6UVXtUBUI/LTLGDW4LZdB3ivgwei8oXIEHLncFd4Wedz3xIhkr/NtjThUf9So8u2PD++sRk0XLqXH+zkw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(346002)(136003)(396003)(186009)(1800799009)(451199024)(2616005)(5660300002)(4326008)(8676002)(8936002)(36756003)(83380400001)(7416002)(44832011)(26005)(921005)(6666004)(38100700002)(82960400001)(66946007)(66556008)(66476007)(54906003)(316002)(110136005)(478600001)(31686004)(53546011)(41300700001)(6512007)(2906002)(6506007)(86362001)(31696002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dm9oSW5ESHZhNnNZOE1GRDhMcFp2MkpMejhocWVDRzJ5RVIrRUlDbndZb2xD?=
 =?utf-8?B?S1pTQ1BlaUE3L3hxQ3dEQWpBYjF3aXZkQiswdlZYQTBpOXF6aHB3T0VLb3Ji?=
 =?utf-8?B?QkZJeWhqVWdDelI0K0JFTzltNjBsTzVFSDNLbXVaVjZpOWRLdThXaDcyb0d2?=
 =?utf-8?B?d1lCVVQ1NEZhWnF5bU5BbUk0cmZFNy9CTEcxeGY4Q2VYd0l5OUpqVVVIN2tW?=
 =?utf-8?B?aEMyVlRoeU4yb01YTDVBMG11Z3Q2UVhGQkVWSjRRU293UmxoYXRra3pWSWN5?=
 =?utf-8?B?eVRWWXdqMWJpNzZoeFptU0VlWndDUW9IMVQxa1NTZS9kMW9JeVlQVTdYeHNs?=
 =?utf-8?B?VzZEOEJFbENJQzg1QjFQTUxTb05VWnNVdjkyUWVGZGFPRmZxSDkxL2lsUW1M?=
 =?utf-8?B?Y2l3alRPRU9MMmlBNytDZkxBdVpPQ01qNVlvRWJaMlEwUUdxQnhTc3R6NWZU?=
 =?utf-8?B?TktSQ0VaSE5HMG9HV2ZYTm5Ndk4rcjN5VEhpSTJVeWZ4T3JSelhKY0JXZm9H?=
 =?utf-8?B?OFNYQ2NXOEZnVkhneElmOW5mM2ltZVFVNFZJUUVDaWUvczA3Y3JGdGhFTDBw?=
 =?utf-8?B?WE5CNzRKVUJKRlBoblVidkFBWWw4dUQ0REhncjhhc2N2LzhRSEYzZ29qQjk0?=
 =?utf-8?B?TDhZVUFTSTRhUzJNVXVaQXdoaXZzS0dzRk1MS3BVU0d6UTJieGpPeVZmNEhi?=
 =?utf-8?B?R1pOSWpKNldJUlV5VTRxUlo1NWVjMVhNb0phUzcvbWlINWhkSG96Q25tekEv?=
 =?utf-8?B?NVNjRTRLc2FTZDdFV21LSVQ3SW5EMk9KeVFkTVQ2KzlKQ1dsY2crOGVkcjcy?=
 =?utf-8?B?bzlxUytRazZwaXc3WWtuZCtKbmI5SEhDRHJJVU9WS00zWTRtdTY1eFJGWTdo?=
 =?utf-8?B?TVVCREN0WGVQcDF2WWE3MHY1anIrR2lwa1VlYUlnalVsRlJLWXFFZ1lRMFpP?=
 =?utf-8?B?Z29oS1JzNzkwWWtxa09oY3hCeDh1YU96eXIrOHREZUJBQVpKb1hURklHcGxZ?=
 =?utf-8?B?L3VnbHJNYWdVZ3lCK1Q5Nkx3ZVFXTTkrdi8vTllBYTZVSHhGa1BuYllrNXBO?=
 =?utf-8?B?aFpQMHBIZjIvR0VmQ0VzNHR0ZXRkL1JuVHhwVno5aW1MMFNGQzBNTFRNM1FO?=
 =?utf-8?B?dkhpaGZDdzUwUm9lOU1acDNUMmZxcVpyUURoZlE5MmhhOWVtY1g0RkpNejJk?=
 =?utf-8?B?L3czWFJWVU5IdXA5OHR1cnA2NGZjeHZib1ozcjcwWi9vSis2NGpUZVpCTXM2?=
 =?utf-8?B?TmJyQVFLb3NDTEpSVUd4cFJvUW91aFUvKy9DVGIrcXVDQlI1MWRqWHRkNWxT?=
 =?utf-8?B?K2owNk1zM084c2ZFUXYxTG5xMDFqN01uUzFSeDVDUmdyRFgrbUxFTmJiTlpI?=
 =?utf-8?B?MzVBVTlHSDNWdTZldE9tRWRyQW1CaGxWTm1CbURuWVpyUVVnZVNEaHdCdU5S?=
 =?utf-8?B?dzRiaTJxS0tFSGhXYTROZXQrSHNuWXEyTWpyOWN6YWJlWTJwRVZERTRHT3Zx?=
 =?utf-8?B?anBQV2lDbFNlTGpEMVNCNGJYbGNjcmRJM0xtVk5mSW5LR290aVkySzhmWlNw?=
 =?utf-8?B?cDhlM1FZNWhqbHpUUGMydTVEcDZ4R25zaFl5aWZrbmgyaFRpekovN0xJdkpU?=
 =?utf-8?B?c2hCQ3owR05vb0tabURKYXRrK2tiQWcvMFpiS2RvSkxmaHowcHhudWJ3Z3pP?=
 =?utf-8?B?UmQybWJEMndvdGE4MDBLYUV0YWxDOWFsQVdLdGRKdlNXYnVCUjRwNUg0NUlr?=
 =?utf-8?B?OTBMM2NySGhVTk9od1J6ZHBKdC9GaDNjOFRsQlBNL0V1TGNYVHJYeVFIQThC?=
 =?utf-8?B?ZHFvZUZrMmZaaWswbEZUNkJjUjloNDBBZGM4bzJ1NmZjQVZjUzlWNFY3T0RI?=
 =?utf-8?B?VDVtS0FGaFVqRmU2cUZtNDhaM201azhITEdDcHA2TUJEdVgvcXRMa1cxUk1o?=
 =?utf-8?B?Qi9xcVVRUGpyU0hrUlZQbGNjN254TG5TR1dHT3RpQWJsWmRRdjBMT2kxakEr?=
 =?utf-8?B?ZmxTaVJha2Y0U0dyUXdGUzJ6bll5ajlkcFBIcktYQkJxeC8vNkhONnJGanpP?=
 =?utf-8?B?OUkvNk1yRmtPam9abldRVXREVGxzUHpwOFg3MjNwOGhWcVN5M3d1cDUxUU9R?=
 =?utf-8?B?VjdSaEV5MnhQaGpDYjVMam5VOWVTVFpXVVRMbkpkNi9IaUEvaHgxWjlMQkdq?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e826564e-6f38-4c31-bde8-08dba472cb17
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2023 07:21:56.2760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lmKM+JowAgdDzZ9wtVBquwzF10MiN4VpXQNWKu/7I5dXoJUX0A0pN8NT9Xy90sQcIMPNj1XdI+pxOWQHx0YqBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6292
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/18/2023 5:50 PM, Xiaoyao Li wrote:
> From: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> To avoid no response from QGS server, setup a timer for the transaction. If
> timeout, make it an error and interrupt guest. Define the threshold of time
> to 30s at present, maybe change to other value if not appropriate.
> 
> Extract the common cleanup code to make it more clear.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 151 ++++++++++++++++++++++++------------------
>  1 file changed, 85 insertions(+), 66 deletions(-)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 3cb2163a0335..fa658ce1f2e4 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -1002,6 +1002,7 @@ struct tdx_get_quote_task {
>      struct tdx_get_quote_header hdr;
>      int event_notify_interrupt;
>      QIOChannelSocket *ioc;
> +    QEMUTimer timer;
>  };
>  
>  struct x86_msi {
> @@ -1084,13 +1085,48 @@ static void tdx_td_notify(struct tdx_get_quote_task *t)
>      }
>  }
>  
> +static void tdx_getquote_task_cleanup(struct tdx_get_quote_task *t, bool outlen_overflow)
> +{
> +    MachineState *ms;
> +    TdxGuest *tdx;
> +
> +    if (t->hdr.error_code != cpu_to_le64(TDX_VP_GET_QUOTE_SUCCESS) && !outlen_overflow) {
> +        t->hdr.out_len = cpu_to_le32(0);
> +    }
> +
> +    /* Publish the response contents before marking this request completed. */
> +    smp_wmb();
> +    if (address_space_write(
> +            &address_space_memory, t->gpa,
> +            MEMTXATTRS_UNSPECIFIED, &t->hdr, sizeof(t->hdr)) != MEMTX_OK) {
> +        error_report("TDX: failed to update GetQuote header.");
> +    }
> +    tdx_td_notify(t);
> +
> +    if (t->ioc->fd > 0) {
> +        qemu_set_fd_handler(t->ioc->fd, NULL, NULL, NULL);
> +    }
> +    qio_channel_close(QIO_CHANNEL(t->ioc), NULL);
> +    object_unref(OBJECT(t->ioc));
> +    timer_del(&t->timer);

Xiaoyao, I guess you missed a bug fix patch here as t->timer could be
uninitialized and then timer_del() will cause segv.

> +    g_free(t->out_data);
> +    g_free(t);
> +
> +    /* Maintain the number of in-flight requests. */
> +    ms = MACHINE(qdev_get_machine());
> +    tdx = TDX_GUEST(ms->cgs);
> +    qemu_mutex_lock(&tdx->lock);
> +    tdx->quote_generation_num--;
> +    qemu_mutex_unlock(&tdx->lock);
> +}
> +


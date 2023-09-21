Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C320E7A9E34
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjIUT6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjIUT63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:58:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA4551F64
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695316622; x=1726852622;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tgb3Es+ac60/pb2SWn2V+kFpgWcTynwjYSb+iQwQL0w=;
  b=bMRWCXivoEcjfR0ZFt31x8IQaJjBPj9/uslWbk4weZlwunohyE7bECEi
   9zYiqEVAAtJBWtzkYNpw1ZuyjVZR/XGi/bg5umgzCRNlpy7UfxB7qnFNX
   JWr2HQ0vSAMRVZ5GyULdxb7GWxqua7TYFyGDVpmqGrQaCXxROqqlTYgIf
   L7mJ80808lS17kkKk5+vzBDQOT+KAtTr0xjN4L+DKn28TUZsQD1F/NdIY
   pei/boGdbAlhQ9quvxqTHZ0QXFm13SULIibfidQTCHPKWV45udlrg0SCG
   mfgi75gd+to30GlsUriTT8DA1AWf18/8dpN3p2zaQyKmTgP+g7sI72DKO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="380373509"
X-IronPort-AV: E=Sophos;i="6.03,165,1694761200"; 
   d="scan'208";a="380373509"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 02:04:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747014422"
X-IronPort-AV: E=Sophos;i="6.03,165,1694761200"; 
   d="scan'208";a="747014422"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Sep 2023 02:04:05 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 21 Sep 2023 02:04:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 21 Sep 2023 02:04:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 21 Sep 2023 02:04:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHA8NwVzBP2HceyGrNcGMBpGXJzvegt694uTdvZ8xbAlpUbZpdGoBQxw82AvcZbCGc1omMNc2M8iSZhRV87TfyK1ZEHmBWt1sJmGc04iy26dUwnxxDoXcVQwHx/MBOpdf/3SJ2s+q9enc1TBXZEV80ETgauKBn7rCINiV1iqIWLHoZq82xI1F0PT1qnkrEOvpvkUel0igt+hurrforkbg5ctX61bsOjQb066N9x6v5haSguej7ihNsjq1KY5yUTwFtMhN9f1/Gm8tjSHeGVv+eSP3y8irl9+2yJUObz+ALpERnR/crudMr2mdfv4G+3bAJYtWUS/rDWaGhxtEEEfSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAtMuqgEtDJtzib+BnKcGsjqvPvDMulPSUtTSwFzPcI=;
 b=c3Xlb5AXzkJKHslTwNZm0XtIBGY91+jmG5FuX6hBIOv7d2HGZjNq87H7mpqzgyQrVutcubchgpebeK6XGS/IA0idMinGQafmyyW8k7ZarzQRcstK8aqPIfx9t9ZUUYKhZjw4NHCWu8PR2j9B2eVAUyyN8QO2UuDC/RK3IqifV5GRKjJrzF64GwX/SMSsvs1y1ykpyJkuJB0WnaSKQmIaFmtSMSHtpxh3KAhlVITeentWcqeBQ5LISmOv3v+0Cw2UPN2J+9vlC0xQI5lHi2WjyqzrXhvErrrw74EhDd/wukB0KzQWoDkXcDIdgHNSGeBlQTLM0vHi0gX4Gkp8Ju0VSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7459.namprd11.prod.outlook.com (2603:10b6:8:144::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Thu, 21 Sep
 2023 09:04:01 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6813.018; Thu, 21 Sep 2023
 09:04:01 +0000
Message-ID: <ce2bd892-0c42-3d7b-cd59-a397b840fee5@intel.com>
Date:   Thu, 21 Sep 2023 17:03:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 4/4] target/i386: add live migration support for FRED
To:     "Li, Xin3" <xin3.li@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "Li, Xiaoyao" <Xiaoyao.Li@intel.com>
References: <20230901053022.18672-1-xin3.li@intel.com>
 <20230901053022.18672-5-xin3.li@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230901053022.18672-5-xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bdf4c51-f2ba-4893-080b-08dbba81b231
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ++1iC2mylcAllspQIDiVjrXEYv1qxyGcAbz4y9rRPQnOUQOQEaxirsyIf1hr/vKIchm0WbYd40a4u37aYIIN3zn2G5Z6giK/yHRtjTPtKNN4boiVpesCBsGetX2QbZ5v1yYwmE743PHbjUYvTMtSEv2TCnO4otwOkoaeEyZf90Wa2wQmvAAIAQ8aac6VUOyeU/H/6SwZPUG8QajIYSSThKcKX38Ns7m8D8am017d6r0w5YL1a04oJU5cHmiNQVeBRlaT+mrKRGe6Q2D3z8MEs5IQL82BXkGpGsyE4YFsWxCGIEgR/Chx8ibfCfuaMtcNrpS3i43f4sutDt+wq4e5UMRob6W2DyH3zLFgbYNFefa8u7uSRM29H/NZYel1v5MafB0Qt7ahWEn14Hg16MATuqWDWf9nDLRRuuUxJAT1XJ71jxXo+25DZVvq7hpk2Ow9BJ+fpWn8YlfLQcF6rio8NveZupZrXoFzuWn0Tz0qgihGs38lkfOLDn0K1r+sfZbud49oGg/8+/AXEJICw8xcTZYQZNEo+6Bj9HXnBjz0tqxbcAmRqT+B2UtMAi7cunkZqYF+YmVg0N4XR5ideSJLGaMMwZPzv2nOSZwmuRT2iGbYsdsCv6Ffo2iQoGYjguq3sIaes+RppGYXdn6+MXtugw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199024)(1800799009)(186009)(83380400001)(31686004)(6486002)(6666004)(478600001)(6506007)(53546011)(38100700002)(36756003)(82960400001)(31696002)(86362001)(26005)(54906003)(2906002)(2616005)(6512007)(4326008)(5660300002)(8936002)(110136005)(41300700001)(8676002)(66946007)(66476007)(316002)(66556008)(107886003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVdiT1BFVEhUaExtV3YxZ1IxT1pnVWlCbmlHVVJ6MUhIZHBzc0pUMEFPMVNH?=
 =?utf-8?B?bk9mZlo1TTcvbXpHY0EzWUc4THRJN3JFeVUrOE1Ib0tGelFtd28yNWpILzI0?=
 =?utf-8?B?UEQ3bVI0MUJhQ0t6MnhRMUlVSTJVc0RCc296aXlmbDBaMlQ2ZDVWZnJaK3lY?=
 =?utf-8?B?NEc4eCtJYnNFSVBnMXFJczRDTm5oTHJJakp1SDB5RlF5WnY3UTFRZGE2aDVJ?=
 =?utf-8?B?Y0t6eHhRdDRTdEljem0yNGgxa1J3empIR200UzlrM1dZdXdrV3pqTUp1eFY2?=
 =?utf-8?B?S2NHTEg5Z0FtTU0vR0FzbTNLckJlQ0JLLzBsbk5OemQ2OHlUcDU4cFFXQUZR?=
 =?utf-8?B?bFlCNzFjN1l2b2hoVFpzVGZJVW1QazhzQjIvUTZHT3Z0OHFvNm82Zkw5NXEr?=
 =?utf-8?B?Wk5CZDRBUjBIWVZGamUzb2k2R0Vxakd2VmtIeWxJT1FBR3V6bnVZaWlFcFg3?=
 =?utf-8?B?QmRMeEM5WkhsS0x2WjZYR1ZZTUFFcUpMMFhCZFV6L2dmQXQvcTQrZGQrbkFH?=
 =?utf-8?B?d0QvUXRhT1NWQnRwU3g1VkYxMjVKZU81U3RZa05nYnBpeEsrTTRsV3hPd21y?=
 =?utf-8?B?OWxodXlqYjZTbWx6SWNvU3doRkw4NVV6SE96SHc2VGM5bEVhb0hJMzAyazBB?=
 =?utf-8?B?Z2c1YUp5OEhxQWV0S0taUCtkVUVLd3JZZSs2Y3JIMnJZcGE0SVVMeHpzTFNC?=
 =?utf-8?B?VzdhcUVpQ3RZakozajJ2ME80OHhqTzdhdnpGZ0dRWDhiWVVWc3B6ZmMyOGZm?=
 =?utf-8?B?ZjM3Q2poMU1JUE5lQS9VV0IwUXZxa1RMdmZkejE1NVNHcWxadVJydnhiaGEw?=
 =?utf-8?B?VnVQZTFXWnVVSlMyenMzK2hJZnEzVHNJcFBLaGhETUtGb2syTzIzMTZBblhO?=
 =?utf-8?B?MW9raTFKeWtYS2xFTFhGVG5zVmxWbDIrZngrcW8wSllOM2VZZ2xxVlpxbHRE?=
 =?utf-8?B?YlBxWUR4Szh0UDFqa0FDajZDL2JnRFpma2YxRC9wWkliUytXaVIzczNzWStU?=
 =?utf-8?B?bHM1MU9iWGZDY1J4Y3BYMnR5Ym5LZ09OZllzMTlGTlBkZUVWMXpDVm55aTVQ?=
 =?utf-8?B?cjY0TStEZHduVG9KdWxyTmFFdjh3RkgrTkY2Y1ZueUVFRzhGdkp3UThjNG9K?=
 =?utf-8?B?MVVNNUJwMlRndHR0Ynkxb3ovVThXYkx0Qjhwb3BXVGJXbzFtcFlaNjVyVmwz?=
 =?utf-8?B?ck16akVrcmlRTGdOWTJwTitHSnEyVDZUeFZSRThWdGdpM2wwS09qV0g2V2ox?=
 =?utf-8?B?QnYzbVZuL3J5Tk14R2N5cjNRSmJjejFybkNoVmE4T0I2ZUtJdkE5d1EvMlhV?=
 =?utf-8?B?NWV2QUpvejM2UFZ1L2xyeWFUbU5VNjJLMDQxM0F2U0RSRklVcEI0MldrVVlt?=
 =?utf-8?B?KzNUSmFPZENiUm5YYVRQR0NtWjE4VWFHSER0OXRqRytRdUVyaElmQjczdnhx?=
 =?utf-8?B?enRKMFVCT3lTbWlub3ZvUVVycXhHQzJwWnpWM3hxNWNqVDhjeHBzcW1YRW1R?=
 =?utf-8?B?U3VSVHcwdkFxSytNeVZpaGI1TmkyNmJyNzhyVWVNb0x3amhOQk1USGh5SDZ2?=
 =?utf-8?B?aFFsVWZscHd0Z0JnUFAwck5nSXAxVUxtMjA3QWc1VVVWSmhYbTVUZyt1cFg3?=
 =?utf-8?B?SS9hakhMYllKNVhxdzhQZDA2VHNSb2thQlovdVJDMzE4OXRzOFhVWUMweEJJ?=
 =?utf-8?B?VVBVTGN4cEUvMVRvSVpwSG5qWTJ2aERSb2hHMzF4TjBoQkFYOUwvVDdWQkx0?=
 =?utf-8?B?aW9TWkd3T1orM1RIOEcyTDVRUzlXRjJOWkE5amZIcHN0aW9iZDNVaDlWckFI?=
 =?utf-8?B?T21qZERYRjE4MUR6MXc4NnkwdjVjcDlmaTFzZWhHSml1enhqNUFHaVNHUjhl?=
 =?utf-8?B?WDFGKzJ2bTFMUFV3WnVZWmU5bzJOTklzYmIzMi9BcDNyNXlGV1JBN09ZUldS?=
 =?utf-8?B?TkdramY5dEorbkpVbWRxVlEwRjhPeFZaWUhkejFhUk1qUEFZSlF2MWt0UDhD?=
 =?utf-8?B?aEljcllJUGVMK3ZZcjhQWllnK1FXSEFlVVVKV0dyRDZ5NWExbWZUc1Awemg0?=
 =?utf-8?B?K0Rvc2ZOTVZGcjl5T2ZCYUJMY3RieFBwR0ZlZjdRN2JybDY3Rk0zcWJJNnVG?=
 =?utf-8?B?ZnRsdGd5eTA0dUdmUXdqZW16TDhtYjlLZjAvV0lIUUl3dy9HcWpENEYzRG9B?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdf4c51-f2ba-4893-080b-08dbba81b231
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 09:04:01.5683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeLRgyi4PFS1zq3+o20mb2SniGK5b0FLyvI7eInKQH2gnzIHComeiK9l/wGhFtC9MvbBTkkUqPwC0f/xVyHMQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7459
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/2023 1:30 PM, Li, Xin3 wrote:
> FRED CPU states are managed in 10 FRED MSRs, in addtion to a few existing
> CPU registers and MSRs, e.g., the CR4.FRED bit.
>
> Add the 10 new FRED MSRs to x86 CPUArchState for live migration support.
>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>   target/i386/cpu.h     | 24 +++++++++++++++++++
>   target/i386/kvm/kvm.c | 54 +++++++++++++++++++++++++++++++++++++++++++
>   target/i386/machine.c | 10 ++++++++
>   3 files changed, 88 insertions(+)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 924819a64c..a36a1a58c4 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -529,6 +529,20 @@ typedef enum X86Seg {
>   #define MSR_IA32_XFD                    0x000001c4
>   #define MSR_IA32_XFD_ERR                0x000001c5
>   
> +#define MSR_IA32_PL0_SSP                0x000006a4       /* Stack level 0 shadow stack pointer in ring 0 */
> +
> +/* FRED MSRs */
> +#define MSR_IA32_FRED_RSP0              0x000001cc       /* Stack level 0 regular stack pointer */
> +#define MSR_IA32_FRED_RSP1              0x000001cd       /* Stack level 1 regular stack pointer */
> +#define MSR_IA32_FRED_RSP2              0x000001ce       /* Stack level 2 regular stack pointer */
> +#define MSR_IA32_FRED_RSP3              0x000001cf       /* Stack level 3 regular stack pointer */
> +#define MSR_IA32_FRED_STKLVLS           0x000001d0       /* FRED exception stack levels */
> +#define MSR_IA32_FRED_SSP0              MSR_IA32_PL0_SSP /* Stack level 0 shadow stack pointer in ring 0 */
> +#define MSR_IA32_FRED_SSP1              0x000001d1       /* Stack level 1 shadow stack pointer in ring 0 */
> +#define MSR_IA32_FRED_SSP2              0x000001d2       /* Stack level 2 shadow stack pointer in ring 0 */
> +#define MSR_IA32_FRED_SSP3              0x000001d3       /* Stack level 3 shadow stack pointer in ring 0 */
> +#define MSR_IA32_FRED_CONFIG            0x000001d4       /* FRED Entrypoint and interrupt stack level */
> +
>   #define MSR_IA32_BNDCFGS                0x00000d90
>   #define MSR_IA32_XSS                    0x00000da0
>   #define MSR_IA32_UMWAIT_CONTROL         0xe1
> @@ -1680,6 +1694,16 @@ typedef struct CPUArchState {
>       target_ulong cstar;
>       target_ulong fmask;
>       target_ulong kernelgsbase;
> +    target_ulong fred_rsp0;
> +    target_ulong fred_rsp1;
> +    target_ulong fred_rsp2;
> +    target_ulong fred_rsp3;
> +    target_ulong fred_stklvls;
> +    target_ulong fred_ssp0;
> +    target_ulong fred_ssp1;
> +    target_ulong fred_ssp2;
> +    target_ulong fred_ssp3;
> +    target_ulong fred_config;
>   #endif
>   
>       uint64_t tsc_adjust;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 639a242ad8..4b241c82d8 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3401,6 +3401,18 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>           kvm_msr_entry_add(cpu, MSR_KERNELGSBASE, env->kernelgsbase);
>           kvm_msr_entry_add(cpu, MSR_FMASK, env->fmask);
>           kvm_msr_entry_add(cpu, MSR_LSTAR, env->lstar);
> +        if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP0, env->fred_rsp0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP1, env->fred_rsp1);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP2, env->fred_rsp2);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP3, env->fred_rsp3);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_STKLVLS, env->fred_stklvls);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP0, env->fred_ssp0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP1, env->fred_ssp1);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, env->fred_ssp2);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, env->fred_ssp3);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, env->fred_config);
> +        }
>       }
>   #endif
>   
> @@ -3901,6 +3913,18 @@ static int kvm_get_msrs(X86CPU *cpu)
>           kvm_msr_entry_add(cpu, MSR_KERNELGSBASE, 0);
>           kvm_msr_entry_add(cpu, MSR_FMASK, 0);
>           kvm_msr_entry_add(cpu, MSR_LSTAR, 0);
> +        if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP0, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP1, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP2, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP3, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_STKLVLS, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP0, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP1, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, 0);
> +            kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, 0);
> +        }
>       }
>   #endif
>       kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
> @@ -4123,6 +4147,36 @@ static int kvm_get_msrs(X86CPU *cpu)
>           case MSR_LSTAR:
>               env->lstar = msrs[i].data;
>               break;
> +        case MSR_IA32_FRED_RSP0:
> +            env->fred_rsp0 = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_RSP1:
> +            env->fred_rsp1 = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_RSP2:
> +            env->fred_rsp2 = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_RSP3:
> +            env->fred_rsp3 = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_STKLVLS:
> +            env->fred_stklvls = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_SSP0:
> +            env->fred_ssp0 = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_SSP1:
> +            env->fred_ssp1 = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_SSP2:
> +            env->fred_ssp2 = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_SSP3:
> +            env->fred_ssp3 = msrs[i].data;
> +            break;
> +        case MSR_IA32_FRED_CONFIG:
> +            env->fred_config = msrs[i].data;
> +            break;
>   #endif
>           case MSR_IA32_TSC:
>               env->tsc = msrs[i].data;
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index c7ac8084b2..5c722a49c5 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -1652,6 +1652,16 @@ const VMStateDescription vmstate_x86_cpu = {
>           VMSTATE_UINT64(env.cstar, X86CPU),
>           VMSTATE_UINT64(env.fmask, X86CPU),
>           VMSTATE_UINT64(env.kernelgsbase, X86CPU),
> +        VMSTATE_UINT64(env.fred_rsp0, X86CPU),
> +        VMSTATE_UINT64(env.fred_rsp1, X86CPU),
> +        VMSTATE_UINT64(env.fred_rsp2, X86CPU),
> +        VMSTATE_UINT64(env.fred_rsp3, X86CPU),
> +        VMSTATE_UINT64(env.fred_stklvls, X86CPU),
> +        VMSTATE_UINT64(env.fred_ssp0, X86CPU),
> +        VMSTATE_UINT64(env.fred_ssp1, X86CPU),
> +        VMSTATE_UINT64(env.fred_ssp2, X86CPU),
> +        VMSTATE_UINT64(env.fred_ssp3, X86CPU),
> +        VMSTATE_UINT64(env.fred_config, X86CPU),
>   #endif
>           VMSTATE_UINT32(env.smbase, X86CPU),
>   

IMO, it's better to split this patch into two, one is for FRED MSR access, the other is
for LM support.

And move the FRED MSRs from basic x86_cpu part to .subsections part because FRED
doesn't belong to basic CPU registers.  In the .subsections part, you may define a struct
to hold FRED MSRs then add  .needed callback helper for QEMU to query whether FRED
MSRs are necessary for live migration.

See other features, e.g., vmstate_msr_intel_sgx


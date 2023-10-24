Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CD97D471B
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 07:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjJXFxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 01:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbjJXFxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 01:53:50 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2076.outbound.protection.outlook.com [40.107.6.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E805D9D;
        Mon, 23 Oct 2023 22:53:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOaC1L2VVBfEY4LSUkgzY7Lra4fkrAh7pDGOURAXD8Q+CuI/5jAed3L9cOdSJtHt/Tx0AvCkHyaudH7Nrsj3nOo0Avo7gR4hvmK9r9P6uH2edTrRChRQ4+Lkq3tGoFExVXpc5ddSi1SUHh4BZoZQQAiRGZydoSQJijrMB/NmJKr/vB5fi7dtJTQcAaF4PzGJRnDBKq4aUhwWj6tWuzZBAD39FLW8nJKGv692aXrCT5y982SVXMTdXhnXxB6sI2mFcItPGHGc4MvD8qANrCntoj6Rvkqh2fuGhH98l7Gn9PXX5jwsj4cw7lsqUM7K9BB3dNis4stDLWrEpBZwVmo2Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFU2ksAvIDGKM1H8nyu75i89Lgyb0NOBf74wCgY6ZAo=;
 b=X9PKgwbDJf8FTjPvaVtAI366t1z9Iombywp5DrjPEwFtr8onZcD6AX0VzAf6ZKfaBdNJTmA9k2qTfemSXCp4oGB8J+4F52WkEvO7u5//rs4e9O/jJ1i5mSnqzgaYCPa2IqavatplAgDWVc2PucV+ylP0xXNBFJ34HqnItTSdxadhpSoNljazVKD40LoJlRyZQXhoPCcAhloP6D1R5PjTRqohs+khFtJKPAV4yxkQ0pfrzM5w4kruPzQnMlKRW2Pet7F4IOTp9VZsYTs8pnr/2cTWmO8a+wA9kLGm9mvsHmnnlEp6qPMIWmx0PD7DxG89yP6u5FVL6uC3/Lp34sRGjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFU2ksAvIDGKM1H8nyu75i89Lgyb0NOBf74wCgY6ZAo=;
 b=5mn1XHmY2S+JaS4OO4OZgRVsm0MWEQptZdJqLaGlFJImar06quVBwbCA38JwSUWaN/sXQlsDFlq+A7v3rakJPPh33dcwK6QeYcuCoBHn9kleVJoHEdjwYETBqDAkUfB9dSuKuwAyUSJaqEgw1wOjA9yGux+c4j4dpj9ootLEc2HZmvliJD7V9pzGnFMYw1irUcX2SLXC7nIvEw1ftqNCp83dTnkWIWdiQsvMNvgd4jUAQok+gQ9SUNEL1DinfebOS7qon05orh92kYoGMa1vOxZzDYIt91kpVHVgiFPqkK6zS6yvqD3qDBkEBr5M7oSOfsfK5e+mgTAD/bsGXpUQMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.10; Tue, 24 Oct
 2023 05:53:44 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6933.011; Tue, 24 Oct 2023
 05:53:43 +0000
Message-ID: <33857df5-3639-4db4-acdd-7b692852b601@suse.com>
Date:   Tue, 24 Oct 2023 08:53:40 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 12/23] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1697532085.git.kai.huang@intel.com>
 <ac0e625f0a7a7207e1e7b52c75e9b48091a7f060.1697532085.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <ac0e625f0a7a7207e1e7b52c75e9b48091a7f060.1697532085.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR2P278CA0082.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:65::11) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: fcbf2a2d-caed-4870-919a-08dbd45594b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BMdnNHh5c8q9+6ipAGcntfVK1SfikFmPOsNpJGDVPVjEFewSWinRPorLX6MSEtdwRgOCxiKfibiWQr2A9owhPp7WQqxS/MNfAJMfiNN0xRDmgbZeBQLKLde3OQWpS2ucWOMHQWWJJ9xH+LwekMOzOfvFqKUwNNlREZI8E+H6O+3lispAS6lBUdKibvZyOtbL7F/Nbgovazx9DwZr3A5GQoGT0kkjLHMGAoE81+0mnK6fPfDxJLcQepZd6zUpELjuiLHdZEZuOa8Jx2s9X+uCYGcUxKqDJ/McAnA3fVG4XMD1LqBf1lRSqSwgfJ7H2QmmmWT/xR+IpAgKw0GRTgizN3/qacrhlYcSxRXD+v1r37doVCk+uK3qOuRdhJqobP/518EDggde7Mvgq/tYE0Gj/maDdaVY3GZhTcPojtEsY1VxOUibKbF+LeH5qgdqS5PxFu68dKHLNagv8YcM8BszfrnCYXmw92uaWLbc0+SEY5tXV8YqFUqGS1V+44hjxC85HO6mIFU3Qle/bVX3ey39sMgAY9AeF2nndYagWSZr3XoRMiBKLY8bNLxpc1dAfjbri6iQcTdyH4uaPwi+mBZrVWM+bD1Htb3glfxvbY0MQyTGIMcuhMgPaEMJZUfkeTEQPwcp1u73lGPdBlFL1nRnI+UBt3NmyoNJQz60teKA1lw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(376002)(136003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(38100700002)(316002)(66946007)(66476007)(8936002)(66556008)(478600001)(6486002)(8676002)(31696002)(4326008)(2906002)(41300700001)(7416002)(36756003)(5660300002)(83380400001)(2616005)(86362001)(6506007)(6512007)(31686004)(17423001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YldFOGIxclVkWGFCZE9rb2FqajNTZmRuZmpqSTR3SVF5VGpCR0tEd1B1VFJY?=
 =?utf-8?B?d3lNSlc0S0V3ZWd1T1FuVWxCcHFjYzhvK1VTcXd3aTljUmpLUXYzeWlrc1Y0?=
 =?utf-8?B?T2JsRnZFSlR1Wk1hS29PVW00bzNGRVJ2UHhJY3Y4YUJwUnVtMEttTkhLUnRx?=
 =?utf-8?B?dVExZmxnNUowaCtUbi9jeFBMa3YzZENCanpkUU41V0NsdjVIc1FFUEMrS0c3?=
 =?utf-8?B?N3NvU2w5em93ekdub0cycm9tMU1IMFd2ZitYdmsvOXhWaUZJUXRwRWpORVMv?=
 =?utf-8?B?cjZNcnNmUmdqOEhaVUU4UStTb1JKamdFdmUvdTRidUQxV1lzR3ByaDhxTkcr?=
 =?utf-8?B?UkgvSmJsVDRDckFncTlaaHpmZmtnUHowVEIyOHBPUlBjQ3plejNMUmt5eWI0?=
 =?utf-8?B?Mkw3eWtwRzkvaUxIVm9pWWJWRVoyNFZlSGU0NDNiZWFPVVN4N20xTllFQWhw?=
 =?utf-8?B?SVZwWVBLaGtzbUZrdFFWL0RUelFoZVd1cHpLWHNDdHdFU01OUyt6RjJ0bC9W?=
 =?utf-8?B?ZkZjaW9IdjdQK25VLzlGY04wdS9TNm9zMzZPSnA3VlFlZ20reEUrZmlld1pU?=
 =?utf-8?B?QWdFcFdWTlpmU0loRmhRQnJZdU9MK2FPSjV6cTA2N2J4d1RNYklKMXJCOG1r?=
 =?utf-8?B?S3N2dDIrTk9NcGpHZXRzZUM3d3RUcmZRNytXVTI0b3lHajNvNUdhZnoySDZN?=
 =?utf-8?B?NzZ2WFFUbWJrZmJ6am5rbWcyZXkrYWNtWkh4NUxxcFZkQTNDajhKcFpsOWw5?=
 =?utf-8?B?T0FnVlJpSjZYb0c5QkxCR3BmR3B5NXM4TWJmM2F4ak50RTdxSE1wdk9hTVdZ?=
 =?utf-8?B?WUtQazMrUzlOS1cwT2lmM0Z4d3FMTHpnMkJ5cW13Smw4RWlBZTM4MnE1UGdR?=
 =?utf-8?B?V0hyNExTN2VlaUdHWWkzVGc2UFpiRjAxQ25KQ0pXZXp1OTBwbi9nZEVrRDly?=
 =?utf-8?B?R2RwYnZWdm5oQm8xUGMxaThzM1l2MG1na2V1RGRXeE9yMDJuS3hGdkliVVA2?=
 =?utf-8?B?VnppYm9tQzJReWoyeXZjSU9RTGM1MUphbE94OHBzNzJRUnhpdzRFbXBxanVH?=
 =?utf-8?B?TWcyb3luZzBWQXp5STcwYm1VSzEwWE9LMVRlcnVHN0t0TWVERFV3bzFxVTJS?=
 =?utf-8?B?V2MwdGRnRktUSmlvVmZxZVI3cmJvOWVuaWM2ZEM1RjBaYjRtb1IzZHFSaEVB?=
 =?utf-8?B?TzZFL0JvUmt0NnM4Rm9ONzN3cHRORFNWQnZlQ2xXcnNLbDdUM3kvTDVSczZF?=
 =?utf-8?B?SFpVMFh1NWc2ODRwbCttTGlUVUovVDQyemMxM0k2SFUrRDNrcUVwY1VuRmY0?=
 =?utf-8?B?dC81d3lkT2dqMjZDOXl4aWFVbDIvM2xNR0VxaWFLSjVFSC9sQzFtbkhBRm56?=
 =?utf-8?B?dE56L0dqVFZJendZQ2Y2S3dpMG5KS1hjVVdiZ3I1S0JMRUNMSno4YTVqbk84?=
 =?utf-8?B?Sm8xWnlNeFA5aThvUWprazBoTnpQcGdCd1NKQUZoWC9SVFllU1YyK0M0MWFl?=
 =?utf-8?B?dktRbFNjS3BEQVM1YXR1S1pnZDNsa0hXbFJXN0FGRkVYVXJuR3RrY0txNzA5?=
 =?utf-8?B?RHB2aFZ2SHQ2TThzRUNaSHJCZEsvTG9HUjhCSkxRZGVmZ2x1Q1U2YTA1QVNY?=
 =?utf-8?B?ZmFWMFhDSHFRUlAwalVhVnI0RDB3UktocXVkMkRUczJaSHd5bFB4c1RVcjZX?=
 =?utf-8?B?K0ZkWDhLNjkwNmlucmtMZGM0R1g3L2gzNnVlRkVzV25HMWVyWklxZmQwQ0tP?=
 =?utf-8?B?ZEtuS25PVXlhYWRQOFN0bklvTzRQeWFrZ0J4NTdnOW02SlZUZjgrWm5TSVJh?=
 =?utf-8?B?NUpaZDdvQ0g0ZEY0NDg5WlVBbitiQ094clA3TG5MT3BpSlNwQ1ZtQTl2UW5r?=
 =?utf-8?B?N0Y1TVNOQlZ2RUtDZ3I3dSsvSWQvN3FBeUtJclQrVjViQ2FUT09VL2h0SmM0?=
 =?utf-8?B?b0pYSklrQVVrRWZzeUY3MTJpUVV6OHhVbjZsdFhlTGdhdlo5aThCRmtON01z?=
 =?utf-8?B?NllMRmxRc21zTlpRd0VvRU1OUlJ6UXRpWm1kRi9rdXZyY0VwckdDWmlrVmlo?=
 =?utf-8?B?K3JiakRyUDN4NGJMUnJvdzZtR3Fwd2dwMy9iTXJDZ1lmVUFFbzMyRHFDeUZP?=
 =?utf-8?B?RUMwb3c5TU1JZGhaKzVidGZQTytLdEpnT1M4TmZIRmVXekd4V29KMkpJQzRY?=
 =?utf-8?Q?F3rhcqBX8w8HXloCeAMQnqru908zo5rhtym+mNhfMGPZ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcbf2a2d-caed-4870-919a-08dbd45594b7
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 05:53:43.7402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PdYg5ergWztMTdCuNwXuziWMxwzz6CVimZkGtV0psr5ZM3Tg4dyS4j0j1MEOj+hNJXDG42F3EHdVXXwGUMfcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.10.23 г. 13:14 ч., Kai Huang wrote:

<snip>

>   arch/x86/Kconfig                  |   1 +
>   arch/x86/include/asm/shared/tdx.h |   1 +
>   arch/x86/virt/vmx/tdx/tdx.c       | 215 +++++++++++++++++++++++++++++-
>   arch/x86/virt/vmx/tdx/tdx.h       |   1 +
>   4 files changed, 213 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 864e43b008b1..ee4ac117aa3c 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1946,6 +1946,7 @@ config INTEL_TDX_HOST
>   	depends on KVM_INTEL
>   	depends on X86_X2APIC
>   	select ARCH_KEEP_MEMBLOCK
> +	depends on CONTIG_ALLOC
>   	help
>   	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>   	  host and certain physical attacks.  This option enables necessary TDX
> diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
> index abcca86b5af3..cb59fe329b00 100644
> --- a/arch/x86/include/asm/shared/tdx.h
> +++ b/arch/x86/include/asm/shared/tdx.h
> @@ -58,6 +58,7 @@
>   #define TDX_PS_4K	0
>   #define TDX_PS_2M	1
>   #define TDX_PS_1G	2
> +#define TDX_PS_NR	(TDX_PS_1G + 1)

nit: I'd prefer if you those defines are turned into an enum and 
subsequently this enum type can be used in the definition of 
tdmr_get_pamt_sz(). However, at this point I consider this a 
bikeshedding and you can do that iff you are going to respin the series 
due to other feedback as well.

<snip>

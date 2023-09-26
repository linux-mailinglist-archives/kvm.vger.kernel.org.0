Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574F47AE788
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 10:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbjIZILJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 04:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbjIZILH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 04:11:07 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2040.outbound.protection.outlook.com [40.107.6.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD51FC;
        Tue, 26 Sep 2023 01:11:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJIiNVnIi1U9Gun+B5TKso75IXXKPeqFiqfKgkSr+CD/Ht+FavBSUI2qkPuyrqFFkF5+wKorbHqtt0yYUaCS7brK64Qq/uyDLWLIYguFw7mDdxxyeRuQ5+rfnmPMjAohrAyhQ+bs78++draT+5QApwpWpG1XBBxTsa2F1DkTKprKmW5njIkSQop2z+6G6RkgGemMc0AW5IqGrBUdwCZzsJwPpqGwJ4SvxEp+OiTG6FZGpltkSNoxsZHn47Tgo9Ds6GBHNfu4mm4RjMX0psThqZjfa9Ehuy51NyDKjoC9/3dN6T/UZR9+utgmehJoVW1B180GrKHPdzfyAUHaMX4Uqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TyZEe6WbNYUl0OlEuOpwvuzVbgy4StGtpHEjSLuTn/I=;
 b=Eqan70rzVaXbRYv8THfTRE3yN7h7D3ApmrK6Q/rYKBTahB/SkTta4kJmNRRS8kbTBVA5+Cj9nacRwZ76uVF59nBPW5GbiHP0vvnlWE7WIC2wcp9ELTDA5RXkadXlZ1lHMx5IsBJq5/3tCCC5H3H36idXpz0uTq+s8QebPKVj76gINCAJ4MEmWBnxa01E7UKQinRd5P3N/okL0UmAhuxxAwWnwtIEFSB2VQLB9xOKN8b5eo6gM2lHuJz8C6QihwA1pIQIB3UgvmFBfMrTE5YOdOBRaISSvluKRzeSxrnFRpwRFkJENkdcEE3pg7nCdt1bVA0SaoOScpQD/o1vubSzpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyZEe6WbNYUl0OlEuOpwvuzVbgy4StGtpHEjSLuTn/I=;
 b=cuw5VU3ZvbBN3If06lGMF0LrgE6QKNg2SAE2+a3PVQQnOGDbT+XJnuHiVBovgxLqprlA/Q2B2zrTtbAtE792xsZcuRf5801QkUFKDMagyukbExfSe5C2IOOnOeF6KQ4QUAHPr47VActxtreXX0Xd69OrDe+1wvadCUwnAwUlNaCJcpbGCuN5LEWgJQeHYF+FPvAmG06nu07HScRksNhXj4mMfWTvMcIhCTbNTTXoRkENbKooFmb5E760sXXGypTjMdSsbJG+1nSOoI70tFGBukAgBWBfZKlJY33oKR28YKnFebSTtMsEsSIbLkaHHrGk0Zq2wAZe+LPOKDwuE/Ee3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PR3PR04MB7308.eurprd04.prod.outlook.com (2603:10a6:102:80::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 08:10:57 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6813.027; Tue, 26 Sep 2023
 08:10:57 +0000
Message-ID: <7acd7bb3-0406-4fd9-8396-835bfd951d87@suse.com>
Date:   Tue, 26 Sep 2023 11:10:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
References: <20230923094212.26520-1-xin3.li@intel.com>
 <20230923094212.26520-6-xin3.li@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v11 05/37] x86/trapnr: Add event type macros to
 <asm/trapnr.h>
In-Reply-To: <20230923094212.26520-6-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:802:16::24) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PR3PR04MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: 61b92aee-8ee6-488e-04d1-08dbbe681ca8
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bj4NER64y4VtiS3kn8raEFPN1DmEnYc55dWznaSvLP1k5Ik/7yTT95+eNZLQqP57km+Z+rvuCZMiImSZb9D+Z/mh/vmwMX2jk7lJYynhUjH8eIwKE8CUVWurRrMYL8cB2+7IghuboC5K1LsIGbCJwJ3gPwWDvrW6ps6EEuAkeRCdfPA9k3Vt9MpuJk63dnOP6kDemUbX11hNTKMR4WKapcXvfCSOzVBztEtWV4pVShDNFDA7/EtRv81el3GO5CuiEl26X2ObgzsRCc84B7wR6wcIyEojVO/eJesUcHOLFxBzZP30RNW5Bc/TMijzfJx3g32joWywDBdr8VcsE/AQZsX6Z3gHf3pV99AOMzpunK9d6UaWrkj4TpRd6q+2M7x68TOHsZA1Su5qyc3cFalxSdBMW9tIxgFSUza4wyrfOAYht0YjBqLhFG+iOw+u8/+UDhsyPtWKBDJNGmf+ec1rW2fU03BeE6uBh1IrkaphroUqI/7KBHFmZ9Swl5YwEwXGcrjGQIswOcRUmut4SkCRFxlqQh+FUOL/7fOn2CJ0A1IRLJZP4UK7M9Pn9FYBeDN8lv+rVcKarssroBek6Lmh0PiX1p+kz3PmX+E2WCwq8gKVvyigt9HhCbL3o4EVw2xpWqfj1FiiZ+TkNe30gLvAYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(366004)(376002)(39860400002)(230922051799003)(451199024)(1800799009)(186009)(83380400001)(31686004)(5660300002)(66476007)(66556008)(41300700001)(66946007)(4326008)(6486002)(7416002)(478600001)(316002)(2906002)(86362001)(38100700002)(6666004)(31696002)(8676002)(8936002)(2616005)(6506007)(36756003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkltcHBQNVc0dFFiVWdKQ1BHbWU2TjNEWnJHb093aE02TnVZekhDKzJLTTdI?=
 =?utf-8?B?U2lJYVVBZkhobk4zcVUvMlZzOVAyQzBHbjlTWjJQSXUwN2psVnRvYnBabkV0?=
 =?utf-8?B?L08yKzF1UFlOU1ZjZnMrc05TcFkxUEkvbURHUHJYcTY5QjlaMVNxekpTM0Mv?=
 =?utf-8?B?ZXdqaGpBMyt6ekRwZE5nbjNjbzBVTWpxZjk5anFtSWlJTlh2RU5EemxteTNn?=
 =?utf-8?B?bFlLOXJPNFR4NXpHeUorMkpLRFdLcDRQV0hwaXNHM1ZINmNxdjFDMHg4VUx5?=
 =?utf-8?B?bVhDU0JzM0MzdlR2WG5zRERxMG42TEFoc1VDZDg3R2lsb0pjdTRvUnFIRTNt?=
 =?utf-8?B?YmVJeFhhZ0RIU1BsdVRpYUJ5c004VjZINEZpeCt2ZnYrRVJEVkc5aXhpR2pQ?=
 =?utf-8?B?ODFUNURDUkd5eXBpMmJoZG9Uc3U4V2hzRy96NEhENzBDTFZ3LzhkcEFIRGFx?=
 =?utf-8?B?OXliZm0vbEJTaUlJaldOWGJkWlB0YWFva1YyYjQvVDFmKzVRblIvRkFQN0ZP?=
 =?utf-8?B?YzFVbEdJeWh4YXBOdU9OT3c2YW9UbFNnbUpFbGhjM2kwS09OTlFqd0RYc0Jm?=
 =?utf-8?B?MGJIZVhsY3lIVWdxVzRUdlFmWCtBWk1KOTV6VTdjUmlocER4VzBOS1BGTFFq?=
 =?utf-8?B?WXZlNDdEQTU0ZmpnNEpYNUlRWWh6ZG5peC9wMUFDMjFnWHQraTBobWNMQkVM?=
 =?utf-8?B?UlBBbkgzT3lVVDh5eDJyNVU1Snd1RnpIWXVwQ3gyQXNROEpBSU4zck5NTDZR?=
 =?utf-8?B?N1pUbHlhVThmUWJSR2ZlUWJOTnB5RkRBOFl3WU5rYThwR2JiWTR3RFIyMFE4?=
 =?utf-8?B?QnNwUGdDREk2ZUQzWnFWR3NhWm9kbWE0MDY4V1FmWmR4WjlSMGRDbXRJaWVy?=
 =?utf-8?B?UXZRalFYYk9HcXF4WlRRWG5LdUNJdlBwb2JFK2ZITzlPOVZCOUZiSUN3NVVt?=
 =?utf-8?B?RkxJNTVBa3Q2OS9tL1FLL2xFTnZqOXBQNTQ0Y0FWT2F3MmlZSTgwejNnUVdW?=
 =?utf-8?B?RWRwcjJ2eGpTa2llWXdNRWM0QjF0aGNrRFl5a3o1MWpCTy9id2IybFpGZ0pi?=
 =?utf-8?B?RXVQeGNSY1lWMFRRZ210MUhnbGV3bUszc25iMjdSTWZ1WTVrNmFxTnRCS2t5?=
 =?utf-8?B?MGJnRk04aG9jV3ZEOFVDN0dBM21LakpHQUtFSUZYN1NFcTRSUWpDcldZL0w1?=
 =?utf-8?B?MW1UaTVTM3Yxc3B4K1JDaXpkOTZmZzA3R2c4bkxuVm55YmpyRmg5aHJIUFJN?=
 =?utf-8?B?Vk5SSGg5UHlaL1Y0bHY3QUdKVTRpbVIvZHg3cnF6T3hwU2dQTXZjb3lvdllH?=
 =?utf-8?B?UElvdUNlQWorVzN0SHZGc1Vld1VkR3U1bXFRRzA2WWJYZElvVTFoSk9kUjdX?=
 =?utf-8?B?aE1weWNrTXhKN05WKzBITysweDF1ZUZuUlM2VEtzeHhqTTBaSFFBTGFpYW1I?=
 =?utf-8?B?d2FSaDBESDBVOThhWXIrOTB3YU1lN29nZFZiZTFtT2hqTWI4MzRmVWNtSDhF?=
 =?utf-8?B?aGpzVU55NmRJYlVzMmhkdUY2OXh4RkNGMUJBRGFCSXg0MTRnSGJTZzlQaWFT?=
 =?utf-8?B?cWdsNXlWQkx0SmZzaVA2UTNmckkwNDZoYXoyejB6aGl6b2F0Nml2a0tmRHFG?=
 =?utf-8?B?SXVoRThKMjRiZTA2NmxhOHBIdysxaEZMM3pSNi9XK3F6VDg0YWtBMzdqYzls?=
 =?utf-8?B?NnVWTnB0eXNXVkE2V1dxTisxcFVkN0FxcEkrZFFaZkpQdklUaGNNZDI2Yk1j?=
 =?utf-8?B?SUNUWGhrZ3ZQOXdjdk11QTFVK1REbnBYYmpxNUxqU3ZtUlFtMW00RHV4Z0xT?=
 =?utf-8?B?cDF3YVNXVUNUOGY0NElTTTVwYTR1SmV1RkJrdWRhUnBLQUh0bC9hTlQ2UUZp?=
 =?utf-8?B?d2NkRlVDWEZQRHVSdUFZTnBUWU1XSGtlQmJGaVVvcWtvRUYvUi8vZHVPOCtz?=
 =?utf-8?B?UGpzYmJZbEtIM25nS3ZzN1gvNzloWTlCcTNra1NVRGx3U1h1RXFIY29wYTFW?=
 =?utf-8?B?b1d5a04xUEhndEliSk1CVmhudUZ0NGt4ajNTWE9GenVUWE5MYlR2OWRFZGw0?=
 =?utf-8?B?eU90ZnlCc2xvRlpoRUwwaFY3anpHSUhuZVVDOFNFanVYMHp1QVFQRUFzMUQ4?=
 =?utf-8?B?ZjZRWFNLK0RhN05aTUJTV0lDcjF2QlJhTGxTT0wrRnBhYmM5Qnd6MnZrNEFx?=
 =?utf-8?Q?jbAeNkLMfloYBTj4wqmF3Ql9JKkm4nQdxLEbNxuUnYAs?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b92aee-8ee6-488e-04d1-08dbbe681ca8
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 08:10:57.1043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQQtphp/I8e249xxRsoJ1ChPtcaMKCw4h8sW1UCNb4HN53zVtTsdbziEYYiHhNSUdT7OUsfbM9whycS58j6DCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7308
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.09.23 г. 12:41 ч., Xin Li wrote:
> Intel VT-x classifies events into eight different types, which is
> inherited by FRED for event identification. As such, event type
> becomes a common x86 concept, and should be defined in a common x86
> header.
> 
> Add event type macros to <asm/trapnr.h>, and use it in <asm/vmx.h>.
> 
> Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
> 
> Changes since v10:
> * A few comment fixes and improvements (Andrew Cooper).
> ---
>   arch/x86/include/asm/trapnr.h | 12 ++++++++++++
>   arch/x86/include/asm/vmx.h    | 17 +++++++++--------
>   2 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/trapnr.h b/arch/x86/include/asm/trapnr.h
> index f5d2325aa0b7..8d1154cdf787 100644
> --- a/arch/x86/include/asm/trapnr.h
> +++ b/arch/x86/include/asm/trapnr.h
> @@ -2,6 +2,18 @@
>   #ifndef _ASM_X86_TRAPNR_H
>   #define _ASM_X86_TRAPNR_H
>   
> +/*
> + * Event type codes used by FRED, Intel VT-x and AMD SVM
> + */
> +#define EVENT_TYPE_EXTINT	0	// External interrupt
> +#define EVENT_TYPE_RESERVED	1
> +#define EVENT_TYPE_NMI		2	// NMI
> +#define EVENT_TYPE_HWEXC	3	// Hardware originated traps, exceptions
> +#define EVENT_TYPE_SWINT	4	// INT n
> +#define EVENT_TYPE_PRIV_SWEXC	5	// INT1
> +#define EVENT_TYPE_SWEXC	6	// INTO, INT3

nit: This turned into INTO (Oh) rather than INT0( zero) in v11

<nit>

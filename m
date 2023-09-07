Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153CA797571
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbjIGPrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 11:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343770AbjIGPbN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 11:31:13 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on0614.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B711FD8;
        Thu,  7 Sep 2023 08:30:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8ofcB2wNNgHWX+O2UA4tvi2/D0CjMCmU3sxhIXfhXo3EC5073LWEWHOZHvHo1nN5ccKNtYYEUZvUnAplWyqxrKJNblMPM6BhF4Q/fbQLDczhcyoJw8FJrtUDmUi7fKB6WZDpx5NLxRXETFnFx2gpLrw24Q/QfU0f3V9Twug7obejG0/PhEA0YA4qkP5I9DXEoZo7vN/mKUUtFdqEyITN16WX4mkZxP10UBsfbiBeJBGz2IQ4Krj3VlcwMICGZjw6SZnkN7wPl8kqNx8r8gVUq1QzGss0hMDRORo2VfgIF6HaPw9Kjwd69PdxOP4ekUL6THPfLgDBt3xi0LnAHNkFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cR9unmMY1PvkRy8NUmpdnm4mle/Uwv67QLUUL3khaUM=;
 b=Kt81S4Mua379ObNDApzaqOMjhi0M/nHa0ns4XSz4FhXTVklT4t6TYPazz/AU51MRzr3rwOjxPZlbtDlaXPwA4fC2DRdKIIk6n4I1J0qIlrLsfRRM7T60C6GFaik7YYvGkiEbITfVr/NFzpDu021aH10VHAFYj3hAtLet3dwAD+5XSDNnqryNJ8ixhsqy8BkpQT408W4VJ4wEeLxidZeUyzn+mpwtU2Q1lwJl3sApJ/VBc3r/RplVuN0i7c1cZAyYwQrVEmEhUi2BMPd9SG1uNKAXvDpcPg98Kt8dQAtzvWKxvLckEAwMwKt0W3CVMhnRh+aaB5CmSnBny7DDlfL1Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR9unmMY1PvkRy8NUmpdnm4mle/Uwv67QLUUL3khaUM=;
 b=Jky38k6fGjI6Nmts3LBMEVV45I2ZMguo91eHc/U8DOLE2IW4gR5x63crzX1tLNAHAAbJYbLnIfrRlRO9Ox2zM+HKb59zjKQxFwy9jdLO+DDbZy6yKcu0cZFSFrJXGTCDmwaMyFRGDRVX02fXBHmBu2ZAi0xbc4E3Xs38qQ3d7dpnweMVuIaCz8RETiOhdeW1/o5/9gipSXi0fEVRISFvS5Z0s86+7WNxbunzv4c+PPL/1UJ3oOF8fzDxUkWfxu6KGOm2507fY9zIFytARqPhXWPu64L+zMiUv/MXchZ00N/f6dl4DM4hmliZpl3TJXZosvFbITXke+Fh47TiO0uL1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by DB9PR04MB9645.eurprd04.prod.outlook.com (2603:10a6:10:309::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 12:45:38 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361%2]) with mapi id 15.20.6745.034; Thu, 7 Sep 2023
 12:45:38 +0000
Message-ID: <7523faad-23f0-2fcb-30e3-b0207d71e63f@suse.com>
Date:   Thu, 7 Sep 2023 15:45:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1692962263.git.kai.huang@intel.com>
 <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v13 06/22] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
In-Reply-To: <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0074.eurprd04.prod.outlook.com
 (2603:10a6:802:2::45) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|DB9PR04MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: d8960e50-0fcf-43ad-37b5-08dbafa055f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zDaQW83YkI/Itjzo5t3B+oiC3zrSP5Af8qKTrb/HKuKqr2wEnwM3/hWCq2wf05GFv5B6qTBjuH78BcJEnPj20msv3lvdw5AL+961GdB+Kwa2JriI2kF05Pn1ioazyzM0JWdY26HEnxE9Vbx+nldxBsHUK1jYuJscnmFr8JQqVEuaG6Pb8Ek3OYCQntjrWbxZZP110fJKU50DMLZKiSUNEmYeDHac4/CUrjVZfdoULvsGUnF33mTiS3LTyktfy2i720NBqSe2YQwhYFNmB4QlYMa02CeK+eoQ9DcH7J+VKU/XSghVdpgigmWBC+hyTkAljRhDmNWT/rZnafNKkwXbVIlGG1QywF9lv8Kz0hb154Bn0jlSef2qyq7lJsQ/lhFum/p316WY14zPkKMyr2WXYx6CAqyuYdWD3sJSPDJ9hPAijdjYgJsRmyCX9lireiTVdWEHe0jaV8jSSAadcpRjwaovWeLBMIJJHR0rFYZuP5FifmnSJwW0apBadjfvYF8JANBo1yW17Px/tH2QqZutVJ/i+0kALMh/xUrxLBrgWdLFF1TdsJjc5Bg0P83T7Sb0H7QAzDjxnDC9uWSXDPSqpHRfR56PHVMjgMpNpu48Xx4Ema80sbtiBByIerRWJ0C7uLrDbskNh33m8EQRBncjvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199024)(1800799009)(186009)(6506007)(478600001)(6486002)(86362001)(26005)(31696002)(5660300002)(6512007)(83380400001)(31686004)(6666004)(2906002)(38100700002)(66556008)(36756003)(2616005)(316002)(66476007)(66946007)(8676002)(4326008)(8936002)(41300700001)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTA3b2h2STVEaU0rTk5OV3FtclB5L2VtdExVOGU5R0JBNEE0ZHRVV0dvZlJo?=
 =?utf-8?B?WnMrN01tSmFEWmFOT2U0dVpvVzJ0ZUZzL1hzUmlHcE5BK1JMMitUVHhiY2NH?=
 =?utf-8?B?aVNLaEVVS3VmM0ZlZXd6WmZiZTVDbkJ4QU4zbDlLbHBXM2tPSUJiYVErdGxs?=
 =?utf-8?B?RnlPYWY4Y2hjMTR2T2lqSS94aWdWbkJQRGxrR2xFeUhZMnFLVVoya3RaYldx?=
 =?utf-8?B?RFNtejVLQTZsQVkzQzVzOVZoMC9ObW5BYUZzRmliTWdtT3lmWHpiR3NZd0tl?=
 =?utf-8?B?UThLbGwyMjNCclkzQ1lsSnhSNXRSWUt6NzU3N2J1Mml1NkhaaWVVR2VzTys0?=
 =?utf-8?B?NnBYVUNNUkVtTm84Q0xnL09uZ2xMZURqSTlNWGNhMklIVXBoSmF2ZkpDbFJt?=
 =?utf-8?B?NFFaZ0NrRmJSdkRFR1VGT2g3NTlieU0wMUFhOXdsbmZ5Tkw3cXU2UmZVNGMy?=
 =?utf-8?B?S0FCSEhOYzZxRnhBcG4rb014V2JjR09rVG5hQWxYUCt2elJSUGg5N2lMODFR?=
 =?utf-8?B?RWkvblcvNHNLZStVTGl5UGdxUVA2RUxOamx5Tmhoa01rVXdBdjZic0N5Si9I?=
 =?utf-8?B?S2lLdGNkSEl1cWlKcW5xQ0tQenJVTStDNXhCY0VPcUp1MDRxbzJhUDBmRDBG?=
 =?utf-8?B?QmpTTHR5MWNDcmtnUHhCQkNPK1NicG44OGlKd0F6QzZjMVQ0d0RhWXVHa0w1?=
 =?utf-8?B?TXBPM0I3Rk0wVEZOKzJwOGl2dTZVN2VjeEpFNERBTzRYZkFReVlEYlY4VDR0?=
 =?utf-8?B?OEhQdmg0SWJyVng4Z3BHbVlMYzJPaG9kTUo1SUFDNVdNSXoyejduaStRSXpH?=
 =?utf-8?B?UDFYR3EydHkvVW5pamtXMzRxc3dHSjVDOCtFRnNxTXhpTUFCazh5b1EvYUxv?=
 =?utf-8?B?Y2ZLWjlrNzBuNk9NNnA2UEg4cjJBSThSaEg1cHhDWTNHUE1zMCt3NmdzREgy?=
 =?utf-8?B?bmpYTWxtMmFjaExYT2gzRGJ2YWF5b2ZSQXZFZUNuZzJxZW85Q3k0VXMrY0l1?=
 =?utf-8?B?OGxkMklWVjhybHd0ZkxtTWJ3ZXhuenY5Sk9adFB5MWwveXI5cjl3dTF0VmNz?=
 =?utf-8?B?WTlBa3RkNzNTUExoY0ExdlJEN09IOXRQYjFteXdDVHdqMVFXZjRTQy9SUGtF?=
 =?utf-8?B?NXJFdUlTTkZrRWhHOWRTY2dzRytOZW51cVRleThGMWtDbC9IZmZCSXNPdWxD?=
 =?utf-8?B?amJkT0cwYVUvWEp6elNZUnRBbzFvZ1UrQVN1NVhqeFo1bmVycUFXNTlqRk9n?=
 =?utf-8?B?MTZSY1hZUnEyZUFUbTJzL1dpWk16a3V0WGxsY0VaSWc3R0NqeWpiRXVvVDA1?=
 =?utf-8?B?V0Z0Si9nWndiQ0hFbmIrY2FQUnJVUDMwWlorS0JVVTkxVit5U21qTStYOXNX?=
 =?utf-8?B?aFBEVXEyamYvZGx1MGNOa04rV1piNkZLUHcwcExCZ0ZkZnJ3eHdBV3gzV2hB?=
 =?utf-8?B?NjdZemhTUmc2Z3lsMzJ6bmtWbysxUDJmdFFFK0tWVXM4N3ZXUVZGZXE0bVRp?=
 =?utf-8?B?bFlwbENveXZsS0ZnMGdXZmxuaTArbkl1VjRzSVBOWFhMdFVIYzlxb3RjYTV0?=
 =?utf-8?B?UGVqN3RxU001aTBVdjJrbUJTdnEyN1JqRW9uQU5DTUVqK3RQdlFIRXNxK2dI?=
 =?utf-8?B?NTFiYmdCQmFPL1FxenRlZk40ejF0Wjl4RHUxcWl3Mm9oa0t0MUxKZkFLbEZv?=
 =?utf-8?B?N3p4T0dMZ2s2allraCtZaUEvRlVGQXB0WXdnSWF4QWZVNWd5V2wwTGpveGdn?=
 =?utf-8?B?cXJCa2J1cnZyNFd6d2VPVEFpL0J6TmdydkgvOTJrbXViTDVaeWJLN252cEhx?=
 =?utf-8?B?UWRDcTJhbXNOWkl0bktDOCtpeGVxeVlzSG9qckp0NnRDOGRtZ28xWldPSHJT?=
 =?utf-8?B?U2txSDVVbzc4VzYzYjNXdlJncGtWS3BMdG1QL3dKUXJ1MzRaN0c4dlV2MmJn?=
 =?utf-8?B?S3NyejRLb2tPNXJuM2hSVjhZU0x3RWtWMzJkc0k3aW84UWI3UEpYMDZkWkky?=
 =?utf-8?B?dzhBSE44NlN2WjZxYUdMbElzQ2VRQSt1MGhzLzBHZ0tGKzBBYjBBNHdvYTRz?=
 =?utf-8?B?eHMyUEJMenZISERxZVlBTjFUOTNab1lySUNSVStXV0VjbmRaaEQ2U2JEUW5I?=
 =?utf-8?Q?ZBAXR7uWGbt7kkozFKj+JoI4s?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8960e50-0fcf-43ad-37b5-08dbafa055f8
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 12:45:37.7461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1v7kBG8N4Z37dpmmDMHU2+zaF9OuApkDphKALD+6RUO61zNgADlOZ4zDU0wdsdxbl2N5M20CyCh9iW2NjP9B4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9645
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.08.23 г. 15:14 ч., Kai Huang wrote:
> TDX module initialization is essentially to make a set of SEAMCALL leafs
> to complete a state machine involving multiple states.  These SEAMCALLs
> are not expected to fail.  In fact, they are not expected to return any
> non-zero code (except the "running out of entropy error", which can be
> handled internally already).
> 
> Add yet another layer of SEAMCALL wrappers, which treats all non-zero
> return code as error, to support printing SEAMCALL error upon failure
> for module initialization.
> 
> Other SEAMCALLs may treat some specific error codes as legal (e.g., some
> can return BUSY legally and expect the caller to retry).  The caller can
> use the wrappers w/o error printing for those cases.  The new wrappers
> can also be improved to suit those cases.  Leave this as future work.
> 
> SEAMCALL can also return kernel defined error codes for three special
> cases: 1) TDX isn't enabled by the BIOS; 2) TDX module isn't loaded; 3)
> CPU isn't in VMX operation.  The first case isn't expected (unless BIOS
> bug, etc) because SEAMCALL is only expected to be made when the kernel
> detects TDX is enabled.  The second case is only expected to be legal
> for the very first SEAMCALL during module initialization.  The third
> case can be legal for any SEAMCALL leaf because VMX can be disabled due
> to emergency reboot.
> 
> Also add wrappers to convert the SEAMCALL error code to the kernel error
> code so that each caller doesn't have to repeat.  Blindly print error
> for the above special cases to save the effort to optimize them.
> 
> TDX module can only be initialized once during its life cycle, but the
> module can be runtime updated by the kernel (not yet supported).  After
> module runtime update, the kernel needs to initialize it again.  Use
> pr_err() to print SEAMCALL error for module initialization, because if
> using pr_err_once() the SEAMCALL error during module initialization
> won't be printed after module runtime update.
> 
> At last, for now implement those wrappers in tdx.c but they can be moved
> to <asm/tdx.h> when needed.  They are implemented with intention to be
> shared by other kernel components.  After all, in most cases, SEAMCALL
> failure is unexpected and the caller just wants to print.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v12 -> v13:
>   - New implementation due to TDCALL assembly series.
> 
> ---
>   arch/x86/include/asm/tdx.h  |  1 +
>   arch/x86/virt/vmx/tdx/tdx.c | 84 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 85 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index cfae8b31a2e9..3b248c94a4a4 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -27,6 +27,7 @@
>   /*
>    * TDX module SEAMCALL leaf function error codes
>    */
> +#define TDX_SUCCESS		0ULL
>   #define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
>   
>   #ifndef __ASSEMBLY__
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 908590e85749..bb63cb7361c8 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -16,6 +16,90 @@
>   #include <asm/msr.h>
>   #include <asm/tdx.h>
>   
> +#define seamcall_err(__fn, __err, __args, __prerr_func)			\
> +	__prerr_func("SEAMCALL (0x%llx) failed: 0x%llx\n",		\
> +			((u64)__fn), ((u64)__err))
> +
> +#define SEAMCALL_REGS_FMT						\
> +	"RCX 0x%llx RDX 0x%llx R8 0x%llx R9 0x%llx R10 0x%llx R11 0x%llx\n"
> +
> +#define seamcall_err_ret(__fn, __err, __args, __prerr_func)		\
> +({									\
> +	seamcall_err((__fn), (__err), (__args), __prerr_func);		\
> +	__prerr_func(SEAMCALL_REGS_FMT,					\
> +			(__args)->rcx, (__args)->rdx, (__args)->r8,	\
> +			(__args)->r9, (__args)->r10, (__args)->r11);	\
> +})
> +
> +#define SEAMCALL_EXTRA_REGS_FMT	\
> +	"RBX 0x%llx RDI 0x%llx RSI 0x%llx R12 0x%llx R13 0x%llx R14 0x%llx R15 0x%llx"
> +
> +#define seamcall_err_saved_ret(__fn, __err, __args, __prerr_func)	\
> +({									\
> +	seamcall_err_ret(__fn, __err, __args, __prerr_func);		\
> +	__prerr_func(SEAMCALL_EXTRA_REGS_FMT,				\
> +			(__args)->rbx, (__args)->rdi, (__args)->rsi,	\
> +			(__args)->r12, (__args)->r13, (__args)->r14,	\
> +			(__args)->r15);					\
> +})
> +
> +static __always_inline bool seamcall_err_is_kernel_defined(u64 err)
> +{
> +	/* All kernel defined SEAMCALL error code have TDX_SW_ERROR set */
> +	return (err & TDX_SW_ERROR) == TDX_SW_ERROR;
> +}
> +
> +#define __SEAMCALL_PRERR(__seamcall_func, __fn, __args, __seamcall_err_func,	\
> +			__prerr_func)						\
> +({										\
> +	u64 ___sret = __seamcall_func((__fn), (__args));			\
> +										\
> +	/* Kernel defined error code has special meaning, leave to caller */	\
> +	if (!seamcall_err_is_kernel_defined((___sret)) &&			\
> +			___sret != TDX_SUCCESS)					\
> +		__seamcall_err_func((__fn), (___sret), (__args), __prerr_func);	\
> +										\
> +	___sret;								\
> +})
> +
> +#define SEAMCALL_PRERR(__seamcall_func, __fn, __args, __seamcall_err_func)	\
> +({										\
> +	u64 ___sret = __SEAMCALL_PRERR(__seamcall_func, __fn, __args,		\
> +			__seamcall_err_func, pr_err);	

__SEAMCALL_PRERR seems to only ever be called with pr_err for as the 
error function, can you just kill off that argument and always call pr_err.
			\
> +	int ___ret;								\
> +										\
> +	switch (___sret) {							\
> +	case TDX_SUCCESS:							\
> +		___ret = 0;							\
> +		break;								\
> +	case TDX_SEAMCALL_VMFAILINVALID:					\
> +		pr_err("SEAMCALL failed: TDX module not loaded.\n");		\
> +		___ret = -ENODEV;						\
> +		break;								\
> +	case TDX_SEAMCALL_GP:							\
> +		pr_err("SEAMCALL failed: TDX disabled by BIOS.\n");		\
> +		___ret = -EOPNOTSUPP;						\
> +		break;								\
> +	case TDX_SEAMCALL_UD:							\
> +		pr_err("SEAMCALL failed: CPU not in VMX operation.\n");		\
> +		___ret = -EACCES;						\
> +		break;								\
> +	default:								\
> +		___ret = -EIO;							\
> +	}									\
> +	___ret;									\
> +})
> +
> +#define seamcall_prerr(__fn, __args)						\
> +	SEAMCALL_PRERR(seamcall, (__fn), (__args), seamcall_err)
> +
> +#define seamcall_prerr_ret(__fn, __args)					\
> +	SEAMCALL_PRERR(seamcall_ret, (__fn), (__args), seamcall_err_ret)
> +
> +#define seamcall_prerr_saved_ret(__fn, __args)					\
> +	SEAMCALL_PRERR(seamcall_saved_ret, (__fn), (__args),			\
> +			seamcall_err_saved_ret)


The level of indirection which you add with those seamcal_err* function 
is just mind boggling:


SEAMCALL_PRERR -> __SEAMCALL_PRERR -> __seamcall_err_func -> 
__prerr_func and all of this so you can have a standardized string 
printing. I see no value in having __SEAMCALL_PRERR as a separate macro, 
simply inline it into SEAMCALL_PRERR, replace the prerr_func argument 
with a direct call to pr_err.


> +
>   static u32 tdx_global_keyid __ro_after_init;
>   static u32 tdx_guest_keyid_start __ro_after_init;
>   static u32 tdx_nr_guest_keyids __ro_after_init;

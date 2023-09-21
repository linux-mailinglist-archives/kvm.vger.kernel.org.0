Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F967AA1DF
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjIUVIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjIUVHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:07:38 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07646A77;
        Thu, 21 Sep 2023 10:09:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cz4aKIUi+IRUoFZMpKUTnvuhfrHrua6gv2KuTZaluP+m5/8MV5mnp8f/IozduEPs7PDZienKFryI93yiZZQcvrSNbpgSNkOuz+rhk09uq4BF77gqqglEmVv0UK2YqOoMbIS1zED4dFdJdNyLu0M+XPQUkvKg0bxWCh+mh/4H7KD7FW6Bo712DOOld/AJoCjZiRe9Gxx31tN2kJoIUNo8V5evgcJFzHiHpkMyf1W9XicfETvxYIbo8RefgLt+FbwcMLbgMcY7d0gYh2siIYD+cxogx8Sf0XG05czv9bRlhi/9oX7HJxDRo0lg8hEtoKKMW4VcDir2nK6nimCOvtmWkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tteY01czoQxqLsrAQIn/17VJLh97CKwm9ZSf1j+VPDg=;
 b=cO+U7Hig+ztMeshLsvKEewwoT1sJLvm1bnUJSfGYaNZ/FNbotfrYVkjKDMY+Y3K8BdQqdfuKC7TRsQvpf1DalotHTff1TStDd84nNE3If2Ye9Cff06Y1ijUEe3OkujDfMgM130fMCcZ4ZQWhwOkS3LjDIoOJPlI82+PEVYfBKMb0vkopNSeblwni5NVeO47B2KcijGVHrfiAi4iLa8O4fgawAElYzAae+/kS80r+agf+BYSLjGgulxfEoKMFP5CARFJpg1SU3tQILynLctAENLw+lsBXf4GXy0S3BE1wHO2MD8wjVfLr3yD8cKCmz0DLBxkW5+dTyucbwH4KIfct3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tteY01czoQxqLsrAQIn/17VJLh97CKwm9ZSf1j+VPDg=;
 b=KIY0oPafEbWXSbW20fqs+W0S03S5/Ek6AOIeC6VTnBSAehnTM8aKc2Ghkae5Z2XJ68hFskOq7cDnpMDIk1qO+8R+dLfNiAevNJVKMA0CKIo/EiknUYIcniGirUzUkmJcOU3NcMM4KIQZIH52t9HhMdexpqkJOyRovrwiiIdF8jHxpYFMX9nXosNkOeWvEDbHqUeb3dfLO3B7Gra8E4b3G7L4oLBiEvpAEH+FtUANIkLal4oYoAcPXXKB5FwWz7X/ykMgUN8wSYY390ri8kB1iZb2Q30Bha0BwQHfVYas6LthO5aKJylvEdUOX8NnZoNONovBDbWbBhoVmzWPbGx4JQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AS8PR04MB8372.eurprd04.prod.outlook.com (2603:10a6:20b:3b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 21 Sep
 2023 09:48:20 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6813.017; Thu, 21 Sep 2023
 09:48:20 +0000
Message-ID: <22921663-0e5e-58c0-c6c8-c45f991790ea@suse.com>
Date:   Thu, 21 Sep 2023 12:48:17 +0300
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
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-29-xin3.li@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v10 28/38] x86/fred: FRED entry/exit and dispatch code
In-Reply-To: <20230914044805.301390-29-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0902CA0059.eurprd09.prod.outlook.com
 (2603:10a6:802:1::48) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AS8PR04MB8372:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b1b8fa2-cbbb-4088-1fd6-08dbba87e39a
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KOMQkc9HYTkoe2RETAgiqf0V7BcqNeddf3VQGum57sbjxkxQeg9qRXou0QiB5a15nOR84haqA33XxrHzerCvYRQI4BD36Wk3Nf0B7aAAFaCAy5Jdls37EnIajbA8+7wO4b+bavf1Gsc+VHC0bM2YtNCNyHh2O7Aqkl3erfRdP9QIf6OxgxpupnKDsHaUcSjR6STOvE4IXyUltkujmfaDZPLTVGaMnq1p2u1D6oBwbcKm13uiwIAkPI/G+c8M++P3asPWbEEddLZ7LSkHl5e8Ka8llKUUfngBtvPYKIath33vx/vWChMluX0Nc75Jn0Li5MLPAL39q71EfDyjaATVy4S/gA1uDBWCU+LEY4XRuN9z35BSxx5t8haxxl+2dXWaUJKb2VvDiQQyfDIQTT/ezOo9HphFxQPrQt2KQ48+VWudhj7815NUa8yZv7KyLQ9AJFc8uIut4auAmd99/F9QiJSMsjtyp09GyHN8izQSfwiVHcL5CK6uK5Fp92RYyW4lPuZwCc615hH9557g8uuK/QpthkFkWOU4DA9D5wE4qXASrvw/fQnMvLbiM+jAS88zqs3ciVaTw8vIXd5hp/m0bMdUSvkTWfaMSPDc3wRvRZc1bZUBqrL8AoigOg+OUzNvaQvRJN2/AQ7jE3li125iWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199024)(1800799009)(186009)(26005)(2616005)(31686004)(2906002)(5660300002)(83380400001)(8936002)(316002)(31696002)(66476007)(7416002)(66556008)(4326008)(8676002)(41300700001)(86362001)(38100700002)(966005)(478600001)(36756003)(66946007)(6506007)(6486002)(6666004)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2JnV01GSm5Zb1dvbGQ3Q3FrWUhWV1lOeThvSUNmM1dsMUVqbVhVRDZaaWdl?=
 =?utf-8?B?MjhhYWVJNjV0RXRtT3VZc1p1WFN5RWdRWStPL01laDFQZlY2MHAyemozU2Fa?=
 =?utf-8?B?L0w2anJMZERzbWNSQkZyaVp6V3Jxd3VLVVFoYlk5QWVTcWF6MmNFR2xVckR2?=
 =?utf-8?B?Zitvc0NGQnpVc0NSZmdQbXMvcEpWb0tmQy9ZRDZObFJWeGwvcHFBM21QQ00z?=
 =?utf-8?B?aWFaU3JoTEdhVGJpMnBvbFhrcEIwczhGcDhyN0lVa1Nhajk0YmprK0ZzYVNW?=
 =?utf-8?B?aS9uS0tmcXZGK1VlV1FqcWZ2MEoyUVdxZFNPcHlKV3FZLzl6djl5V21pYWZt?=
 =?utf-8?B?a2tSZGRQMFEvLy9MQUl4bXRuUU1saGFta1daNU5FMGJsMDhoMHhPUlc3N0w0?=
 =?utf-8?B?R0ZPeEtLR2pzek53Z2s1WlJvM1Ara3B4Q0g1OVdOQ3VqeFp4MW96SmZjNDR3?=
 =?utf-8?B?NE1xeFN6czM1Q1ZkMnBGQWRnZDlTd3h0QmJmSGJCWnluZDNwSjhabVpWaStV?=
 =?utf-8?B?bm1XZkNXU0k2aDFPcDNLRmowa3psempVMVJvTlJUOGs2T2RoVjdGaG1rdzFI?=
 =?utf-8?B?dW1waTZuczFJaFRUUjcvWkpCWnBqOHpFREtNOVpFTk05QVIxRHVQczFGUnNK?=
 =?utf-8?B?a2RpMklvOHF2VDE1aXZJb3JKY2FqSUN0cnZtR3J4SkJGU0VnYWU1WmpyTmYv?=
 =?utf-8?B?QWY2UE5GZDZHQ01ydFkzR0E0UDQ4UzQybFdSM1V0Qjl5T3JIMGM1VkNERWp4?=
 =?utf-8?B?NXFrTklDUjloZUJpMlpyY0ppTVhpTFYxS3BmUXVHVHV6ZUI1cmNDNiswQXpT?=
 =?utf-8?B?L3hDSUtUMGs4TzNPenNLSk55QmFTZllBTWhCTzU1SW90ejVpeE1ZbTNQTzN1?=
 =?utf-8?B?aHU0RmZXejFwNHdObnBDSzdXTnVUN1NyZUsrOEo5NzBsTm43WDVocE5URnc2?=
 =?utf-8?B?Z1pmcnlML0t3R2ErNXU2VFdUT1JqNUNYOUVZbXJSc0Qzb1o1cWQrMFcvelE0?=
 =?utf-8?B?RjlMbHd5WlV1SHVhMWN0NjRkdVB6UE8renJ1Yk1veDRQODR3V3ZNR0Rxa2Q3?=
 =?utf-8?B?K3VYSENvMm8zclVoME53Q21lU1lVWW9jaE1GNThOQUZ3M0ZPQ1Q1VjFIM2tr?=
 =?utf-8?B?cVl1dEhPOWcvU25oblQ3SER2QXlRZDVFY1EwMDBVNmF0V2paNjF6cm9sNnZ2?=
 =?utf-8?B?aXluakw1WUJGd0RrVnM0WjBhWmhaRzRCaWxGK1BmZDAzV1pzUGhnVExZcGZk?=
 =?utf-8?B?dng0c1J0VmZSRU83N0QwTGFuaWsvMlZmNHlaK3lQTjVaZGU0YTcrS1VaNXRo?=
 =?utf-8?B?SE5UQ3RRMnJwREVid1VuY0grdnVkbXdOOHNOeW5DK0RIaCthVWt3Ym8zbjlL?=
 =?utf-8?B?ajVmSzFOTG1xcVN5RStkQ1dmVTl6VmlYRFpQYTZ2dVRXL3dUTXF2VCsrbVRM?=
 =?utf-8?B?TVlVUWcvRXl2TjI2RTJzaGhMK2g3cllvcVRxcHEyc25QRzg1dnlkeWVuOG90?=
 =?utf-8?B?anFTQTdXVFpsdDNPWi9nNGQ4QkxiL1Z4YXVGdUgwK2dTaWU2cnlaVENLcHVw?=
 =?utf-8?B?K1dtd3Rrb2pQbTNLcGJ2QkN3ZzB2cXdUTDZLWCtVSTVIMG1PU3RpK0VycVBr?=
 =?utf-8?B?a24xSFl1M3lqWUZjbTNFT0VscFpIZ2lQVUUvbVIzalo3VWZIR1NtVXhvdThQ?=
 =?utf-8?B?NmhtVnZzOG43VldQNHJzbkhHQmQwMm1tTENYUmpjb2diTXk5ZzZZWnVSME1r?=
 =?utf-8?B?TUc5QmdYcklDUFNTYVlBM3VsdHFNUldmTElaL3V0MzRpNUdSSU1JRFh3N1Zl?=
 =?utf-8?B?R2lkdFRPdERhaWhzQzBsYTdGV3AvTURBeWdIb3FjUDRCUFNDOVZzcUpHb3hS?=
 =?utf-8?B?bFJHU0NqZXkzZWd6cHc2WTlnQjZESlZlYVA4NXBKcHNpcDJiQWU2NEZOaWRP?=
 =?utf-8?B?dk1ydk1rQ29ubmhkeGxGbkRtWmRxczdKOHU0TzJCc3gwRXlzek1DNmIxaHlB?=
 =?utf-8?B?Z2RsYXVUdVFFWWIyL1huSG5EZWhud1VYekhWdjBIdzVNRW9rci82NzhNY2xH?=
 =?utf-8?B?bFRNMFhaZlYzVk42akRoZTB4OVcvcWNrdVNoOEpPbVRGd2ViVDRDSnRoQkk4?=
 =?utf-8?Q?MCItzrkc8EjMAQoSeb188ZAIV?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b1b8fa2-cbbb-4088-1fd6-08dbba87e39a
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2023 09:48:20.6861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tfHyb3jA4LxAPzHm6Ad2rv1ExUj8mdshAfWKSYyD60NtpHZTrRXvvnzMsEf1JtcdG4UChwFSElA1TxfQEDXQgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8372
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.09.23 г. 7:47 ч., Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> The code to actually handle kernel and event entry/exit using
> FRED. It is split up into two files thus:
> 
> - entry_64_fred.S contains the actual entrypoints and exit code, and
>    saves and restores registers.
> - entry_fred.c contains the two-level event dispatch code for FRED.
>    The first-level dispatch is on the event type, and the second-level
>    is on the event vector.
> 
> Originally-by: Megha Dey <megha.dey@intel.com>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Co-developed-by: Xin Li <xin3.li@intel.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
> 
> Changes since v9:
> * Don't use jump tables, indirect jumps are expensive (Thomas Gleixner).
> * Except NMI/#DB/#MCE, FRED really can share the exception handlers
>    with IDT (Thomas Gleixner).
> * Avoid the sysvec_* idt_entry muck, do it at a central place, reuse code
>    instead of blindly copying it, which breaks the performance optimized
>    sysvec entries like reschedule_ipi (Thomas Gleixner).
> * Add asm_ prefix to FRED asm entry points (Thomas Gleixner).
> 
> Changes since v8:
> * Don't do syscall early out in fred_entry_from_user() before there are
>    proper performance numbers and justifications (Thomas Gleixner).
> * Add the control exception handler to the FRED exception handler table
>    (Thomas Gleixner).
> * Add ENDBR to the FRED_ENTER asm macro.
> * Reflect the FRED spec 5.0 change that ERETS and ERETU add 8 to %rsp
>    before popping the return context from the stack.
> 
> Changes since v1:
> * Initialize a FRED exception handler to fred_bad_event() instead of NULL
>    if no FRED handler defined for an exception vector (Peter Zijlstra).
> * Push calling irqentry_{enter,exit}() and instrumentation_{begin,end}()
>    down into individual FRED exception handlers, instead of in the dispatch
>    framework (Peter Zijlstra).
> ---
>   arch/x86/entry/Makefile               |   5 +-
>   arch/x86/entry/entry_64_fred.S        |  52 ++++++
>   arch/x86/entry/entry_fred.c           | 230 ++++++++++++++++++++++++++
>   arch/x86/include/asm/asm-prototypes.h |   1 +
>   arch/x86/include/asm/fred.h           |   6 +
>   5 files changed, 293 insertions(+), 1 deletion(-)
>   create mode 100644 arch/x86/entry/entry_64_fred.S
>   create mode 100644 arch/x86/entry/entry_fred.c
>


<snip>

> +
> +static noinstr void fred_intx(struct pt_regs *regs)
> +{
> +	switch (regs->fred_ss.vector) {
> +	/* INT0 */
> +	case X86_TRAP_OF:
> +		exc_overflow(regs);
> +		return;
> +
> +	/* INT3 */
> +	case X86_TRAP_BP:
> +		exc_int3(regs);
> +		return;
> +
> +	/* INT80 */
> +	case IA32_SYSCALL_VECTOR:
> +		if (likely(IS_ENABLED(CONFIG_IA32_EMULATION))) {

Since future kernels will support boottime toggling of whether 32bit 
syscall interface should be enabled or not as per:
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/entry&id=1da5c9bc119d3a749b519596b93f9b2667e93c4a

It will make more sense to replace this with ia32_enabled() invocation. 
I guess this could be done as a follow-up patch based on when this is 
merged as the ia32_enbaled changes are going to be merged in 6.7.


> +			/* Save the syscall number */
> +			regs->orig_ax = regs->ax;
> +			regs->ax = -ENOSYS;
> +			do_int80_syscall_32(regs);
> +			return;
> +		}
> +		fallthrough;
> +
> +	default:
> +		exc_general_protection(regs, 0);
> +		return;
> +	}
> +}
> +
> +static __always_inline void fred_other(struct pt_regs *regs)
> +{
> +	/* The compiler can fold these conditions into a single test */
> +	if (likely(regs->fred_ss.vector == FRED_SYSCALL && regs->fred_ss.lm)) {
> +		regs->orig_ax = regs->ax;
> +		regs->ax = -ENOSYS;
> +		do_syscall_64(regs, regs->orig_ax);
> +		return;
> +	} else if (likely(IS_ENABLED(CONFIG_IA32_EMULATION) &&

Ditto

> +			  regs->fred_ss.vector == FRED_SYSENTER &&
> +			  !regs->fred_ss.lm)) {
> +		regs->orig_ax = regs->ax;
> +		regs->ax = -ENOSYS;
> +		do_fast_syscall_32(regs);
> +		return;
> +	} else {
> +		exc_invalid_op(regs);
> +		return;
> +	}
> +}
> +

<snip>

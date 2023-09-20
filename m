Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A643F7A821B
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 14:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbjITM5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 08:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbjITM5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 08:57:36 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2056.outbound.protection.outlook.com [40.107.104.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995518F;
        Wed, 20 Sep 2023 05:57:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAZVgqnoySM1SFPM72YJjzQGGbWBVNLbEdbKsHX3g9Pbfa1zVS7u9FE86jxte9HYaoGV2EqpLkEhMp933VkXaSo9rpHMJXOneRW7qWVe5fgv8s8l4FgYm3tTDJZD22x/gDQaHzsOZRQ0QuPn70H/RLCm0cuFVyQ2fHME/sqfXPDRyD2M+N+wN7CHKzidS2w7K7dC1L1+++IuASsiP527PcbybM0C8nAp4sLmmp0aWcjydwRu7cn/ccY7yr09k6ZpqBwgKl8EWeLCXUd4lGu3ug4fVMJBeuC3C7lZMDobRo30AujIsHkaEFH0Pt5hltuX1diA31MQ9FU6A2xC/KloNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsfk6HkGCqPcF9+Kkje7EojINs0xmHo2oq3TsscSXGQ=;
 b=NNXaukbWObrLJe3AD2f2O/fDYt1hqquUdfrviFmZBzqU0ok9TzreOp/Ci/ROXWEyC5XvAn2YulGEFIADtFMZpIK9FknK/O8Xrp+o0X14AuWyJ89FzBW6LlDB39QAvmo8esHSrlyvUyS4mE5EZWyN/zTsWe+VB0gJ7qSvnPpeVuwvmLBkaBU7BZB2zhWMKaEZzdGIyppftZnWgF1jc7J8jJup/G+HIIaL66PhS1aoZ7SgAL5ksmICPzF8KCaI4RTuGL0KZODpLagQZmu3II36J3HbwMHSL/5zwRQHk1kv3gNeCi12c04+GyadRf3fp/RsXFsRsxOeRvaPO7TOlHobZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsfk6HkGCqPcF9+Kkje7EojINs0xmHo2oq3TsscSXGQ=;
 b=SjkEMDdwNKB96U61G+2zoBR+qiXYCMc3sqzJ9gtPMM6ALYO0XaN3Wcz2QasuEK42CJRsKPWS4SdADh/srSc17lUu1poBpAPo/KorxKz8LFseQGN06W6k0VFq28sDVDWKPbghZZkm7QjGfmJ1cI+rt43BRdnvMY8KOD1P6UmDJ6A7VLWVf5wrzqLfwJRZoohCrqFfL/svPELLjcxeXTVIlIxVRuZsBwb69x8GpT8KArW3BaClSCxHDZWNyGVoATcJT3DvZspzhNT3Q5xmoJBfOjIlgzhFzzbLB6E31xHkWP4EyKluKUIg1ra7w2COuKYhnlDv1vLPcmuswo6+OE781g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com (2603:10a6:10:1e4::15)
 by DB9PR04MB10035.eurprd04.prod.outlook.com (2603:10a6:10:4ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.19; Wed, 20 Sep
 2023 12:57:25 +0000
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31]) by DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31%4]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 12:57:25 +0000
Message-ID: <336f77d6-1d94-d2b7-f429-855bfbc3f271@suse.com>
Date:   Wed, 20 Sep 2023 15:57:20 +0300
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
 <20230914044805.301390-17-xin3.li@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH v10 16/38] x86/ptrace: Add FRED additional information to
 the pt_regs structure
In-Reply-To: <20230914044805.301390-17-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR06CA0116.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::45) To DBBPR04MB7788.eurprd04.prod.outlook.com
 (2603:10a6:10:1e4::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR04MB7788:EE_|DB9PR04MB10035:EE_
X-MS-Office365-Filtering-Correlation-Id: 8111326e-af4d-4c67-ddc8-08dbb9d922e6
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTxmR9O25KOptguzvwqgjJEdy+F4lYPo/mQ1M6ZEvUSNjfv9QrXdBz70j4HtPlvu1VepXu2UjkagOKmXtRi8BgQW1hyxmX+YPSLBxTzPrQ8sTe+zYrlwNiGEFlGGy5SDnhcx8k50hXCAOFfjr5NsNj3asfQiH94I7q0nRe39TCW0K8sH3/0AQ6Xfk3wYkQUdC/SOq+kxFSc2Qtf/MWSmIkCyZJgmZwd1rbO6FtS25q7VtUADmfK5M8cZTqzGHCP8XbPVo7uI5Xpg27ab/V1QeKxttAsqbQS21z3A1khIaFnwh3lxa1yZh263jAnC2ym1vngFgQ2JUZIrQoLTiaRcA9qaurfJsWjppQHn9GeM8xGmGQaLayqT4PkKwPqlwEIUGFvVLrsXj9TYJUKEvDMuYmvAMVz1cAqwJXFUi9QIP+SDqvdW1xdzNMzD+ffijd14L7mXfMTtQkuCy34e/WSz95xm/iXUfhuBtzC9m4soYXB2FMeb9DCUVCm2ZVlQcrV4yQdQ+0dwhPPN66HgemmnksVKudAAb3gFzxkHiEqusQO1XF1qUzWjeCRSuZ4FUW6V8Aq0PIYJzAdW0euLJH07Dnr67QoeKTAmLMTW7RAoItzx/edqUZ211X4y9dGvxCR99iMW1APg0DrGluPpq4pBYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7788.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199024)(186009)(1800799009)(2906002)(31686004)(5660300002)(26005)(66556008)(66476007)(7416002)(41300700001)(316002)(66946007)(478600001)(4326008)(8676002)(8936002)(6666004)(6506007)(6486002)(6512007)(2616005)(36756003)(38100700002)(86362001)(31696002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWJmd0xzUUZiR0M4c2RvemNUTm53ZTB4UjZya2hub1RmVi8yWlJpWXUxaTli?=
 =?utf-8?B?c3BKVkROQXp6TDV0djJPWjN6Y29xTVEwRWdZRDhCckJGU2djSU9Cd04vWnYz?=
 =?utf-8?B?dGR5M3ZyT3dmc0RWN1dBYnhaWXl0d3pTc3ZTYWZWSWd2TDY2aUo2dlV0UVpu?=
 =?utf-8?B?WWNUM2FvRlQ1TzhOdzNmSVdnV2FDRTdCaGpYRWhoVDVvVGpWWVJxam52Tk1x?=
 =?utf-8?B?SW5WOGtnMVhrQ0VxT0VmQjBSMDlEVWluN2kwQUlBQWFjVFBCWit6dktTb3JR?=
 =?utf-8?B?RkREck9pZzNZRHYvY21GZEUvdjhDWDR5OFFuc21WNUE3TzNWWUxtR20vN3Mr?=
 =?utf-8?B?UDQ2b0lKdW5NSmZJVGltU1p2dXRTV0FlTHBRd1lCZ1A1SnQ2MUNFTHBGdWcr?=
 =?utf-8?B?YTZmU1dJVXp6ZmJtYllpMVhQUzdKaW1JMk9OaS9LL1FEckd6STJHMk9Dek5q?=
 =?utf-8?B?YWowcDV5L05TeEdqOVhRcGlNV3NZdTNhcTRtV1owTEFUbXZqaE45QW9SdjZY?=
 =?utf-8?B?WEIyY2xCYVhTVGJXWTZUcDBKeFYvTjZQVEVpU0VER0NYYnpnSDRqWDRLbm5L?=
 =?utf-8?B?MEJodkM4OXQxSUZqVlpBL1lhVmthZjMwV2Y4M3JDM1BPQ3BUVGNCSjFLOWx6?=
 =?utf-8?B?ZUlRcGlsSFdieC9NQVJpQkNielkwa1NVYmdwT1Vtb1dlYlNmTmtaREMyZ2lp?=
 =?utf-8?B?WmxXeTRIeUdaZWRnNExyanpwYmxYUmdIQ09IS2xWZGVhU1RXZGRockRpSkxC?=
 =?utf-8?B?bXFhSndkcytXb1k1UTAvd1B4WU1iZmZWOGh1cll0Q3IyWlhhZzJZZ3BWUUxF?=
 =?utf-8?B?MlRpWEl4MUdDZlU3TXhhRW4vYnNqN2lMbVQvM3BWbzhBTENKSjVZRE4rVW5l?=
 =?utf-8?B?dlU1WmMwNXZ3OEJ2RHZpdHljdHU5bFNoUy9TQllDaUJ5N2dCY3E5aGFUUzBN?=
 =?utf-8?B?Ti9WNzkwYzFQN0ZUVTh5OFpGeWxmL0MrZ3FPZjhuUnpMTXJYL1lSbGo1ZkE2?=
 =?utf-8?B?VWlLWlhobDVEZytoQTY0ckN5bDhoNDRYVlpsSkprNnFpU2dYOHZVK3F0aUhv?=
 =?utf-8?B?MEJYODZHcmRYU3hhMVU2V1NUVkNpcitQNEN6S0NpMGJGazdSUW04QjgrQTg1?=
 =?utf-8?B?QWJWT1RSYmZiR05sY0cwRnZnVThUQXorenJxM2k2T2Z0aFhMbUpZeE9GUXhl?=
 =?utf-8?B?MndmQzBhR3piVk45TG1pWTErYWNSYXRxaW1UeHdpbjF0TFZjcm96VGE0S3lY?=
 =?utf-8?B?K1BCRGp6SC9PYkhGZXNyaG56UUxFUDRyNWhPVnYwTHpwWTV6VXd0emw1TXhW?=
 =?utf-8?B?d2ZuUE52SFZGam5tT1VQK24wSGFpMENMMitGc056NnRzdzJaNHhVbjIzZWxs?=
 =?utf-8?B?WWUreXdOL21IT1YvN3diY0pmR0srai8wMVFEOWhOOXBYTDBxYldVZG5PRGtn?=
 =?utf-8?B?Qm9vcFdoUERJbTA0NTcvWFZ4NmlOZVpkRlVNWitsUHQ3NjYyUlpWNjF4cG8v?=
 =?utf-8?B?dTNiMmdJYVJzU1hrbFNCdnh5R0RZMTVnK2VtejA3MTBXb1VzRjF3T3NVR3Ja?=
 =?utf-8?B?bWpndytkaFordHBhRy9TK2s5dVFpekVPeVdVMDlNOHk5clFYcjlFWUptdytE?=
 =?utf-8?B?emUyT1RUZUl2VUIzUGdsNzZPTmordDljN1B2WjFSYUM2SnpKUjEranNXcUFz?=
 =?utf-8?B?cEZ6eTJpN1MyQUxWR09KK1E5YkdLRXVtc1V5Qmh3SXJvZVpKcTYxT2ZJQnJq?=
 =?utf-8?B?d1FXN3N1VDRpZVhEOUFRMDg4aEZKcXBETTZuZ1hUY2Nmd09mTklPM2F5SzNo?=
 =?utf-8?B?K2tNd2Q3Z2RBNXBQZkcvbndMN0E0MU9HQXN5dWYxTDNKbjFoYS9zNnFINGpI?=
 =?utf-8?B?ejdRREFvMThwTjZjWVV0eUhWelpkVllDQUEwcmhMRUdWVmFoZDdOUGx3UUtp?=
 =?utf-8?B?UW1nVzFWZGo0ZGhtWTNLQVg4enNPclBrVzA3U3pKS002T1cvd3p6N2NyS2hW?=
 =?utf-8?B?UDRLaW9LclhzNEM0QUEzUnFJVGUzczEvMlc2cFFTcnVKRXRhcVZQWm9CNUxn?=
 =?utf-8?B?OUx6aVhwNjUzQmJGdlMyUkc2cDlrOUxJZUVKZG5tWHlTaFUrNTlHNDJ4cFpB?=
 =?utf-8?Q?zsH57f4DgrdsglAao7XlnE08g?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8111326e-af4d-4c67-ddc8-08dbb9d922e6
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7788.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 12:57:24.9866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXhOY7ixChTVihr5+RJ+9ZoTH3AgeseEFNtnEN/BP+vUyQg4PQ1lOOX3hn/CW0ibYWa87aEN5V8AvV/qVdp1Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB10035
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.09.23 г. 7:47 ч., Xin Li wrote:
> FRED defines additional information in the upper 48 bits of cs/ss
> fields. Therefore add the information definitions into the pt_regs
> structure.
> 
> Specially introduce a new structure fred_ss to denote the FRED flags
> above SS selector, which avoids FRED_SSX_ macros and makes the code
> simpler and easier to read.
> 
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
> 
> Changes since v9:
> * Introduce a new structure fred_ss to denote the FRED flags above SS
>    selector, which avoids FRED_SSX_ macros and makes the code simpler
>    and easier to read (Thomas Gleixner).
> * Use type u64 to define FRED bit fields instead of type unsigned int
>    (Thomas Gleixner).
> 
> Changes since v8:
> * Reflect stack frame definition changes from FRED spec 3.0 to 5.0.
> * Use __packed instead of __attribute__((__packed__)) (Borislav Petkov).
> * Put all comments above the members, like the rest of the file does
>    (Borislav Petkov).
> 
> Changes since v3:
> * Rename csl/ssl of the pt_regs structure to csx/ssx (x for extended)
>    (Andrew Cooper).
> ---
>   arch/x86/include/asm/ptrace.h | 51 +++++++++++++++++++++++++++++++----
>   1 file changed, 46 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
> index f08ea073edd6..5786c8ca5f4c 100644
> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -56,6 +56,25 @@ struct pt_regs {
>   
>   #else /* __i386__ */
>   
> +struct fred_ss {
> +	u64	ss	: 16,	// SS selector

Is this structure conformant to the return state as described in FRED 5.0?

— The stack segment of the interrupted context, 64 bits formatted as follows:

• Bits 15:0 contain the SS selector. < - WE HAVE THIS

• Bits 31:16 are not currently defined and will be zero until they are. < - MISSING hole?


> +		sti	:  1,	// STI state < -
> +		swevent	:  1,	// Set if syscall, sysenter or INT n
> +		nmi	:  1,	// Event is NMI type
> +			: 13,
> +		vector	:  8,	// Event vector
> +			:  8,
> +		type	:  4,	// Event type
> +			:  4,
> +		enclave	:  1,	// Event was incident to enclave execution
> +		lm	:  1,	// CPU was in long mode
> +		nested	:  1,	// Nested exception during FRED delivery
> +				// not set for #DF
> +			:  1,
> +		insnlen	:  4;	// The length of the instruction causing the event
> +				// Only set for INT0, INT1, INT3, INT n, SYSCALL
> +};				// and SYSENTER. 0 otherwise.
> +

<Snip>
   

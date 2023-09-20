Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E7C7A7515
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 09:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjITH6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 03:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbjITH63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 03:58:29 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2068.outbound.protection.outlook.com [40.107.241.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0D5D6;
        Wed, 20 Sep 2023 00:58:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxQxgMpahAsdJhjj6Zpzme7qltUysMHyyhQWSxF07SEm4SOdtHUlG0eIS3LyYhbbPAHsjMHvvNvhUkMtxKl8hSEMrp4fA46kJnHvD9p56K75ryTK79K/HW3KfkkJFyiMgcg51r3iFsJ4ZbHWSVMrBbELnxoqllWrUCO6dwdOXwiOLisIcujhiAh59LR54zpQwXi5R2l0mtcXkPl3xVVZcr/xAZZzM6CTXdAWuX21vOHWiYqC9F3OC8WChd9UBqIr4H5yOuZ30B0PSdSJerD7Ml9AmDkWoDqBoktOZ+2OQW/z4CTHxad+0BxNw0LS4TnTg9UkciQBYgv9v3cIq/hcXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqzAt/nNndS6ciIZ4al8oV2o0FAUsbEZseqb83RuJbY=;
 b=ZzpV7venmCETmrcC575+F8ProTW9iWSXvq/Kg18MDOfoopLDFZvQY3NIuoUezA3bTCOXa1x/x3l3KbpUYsEd04xi9vZRqTH8FqO++y05XyYvDmJaFBzvJ7JB9Wiy1mNaoFiSkWVUiCaj9G6bcGT/QiPkC1qfnfVL4s+8OXT3XzXlv90g/NTzaoPOUBB7f4HjAlVsZn9UyXnXOh2e0r0CoGwP1NJJnbcDZ6bGOKgj4c1gZuZXBl90j4p/RSDmTCmndlFku7GmmbqHCXkd6Czq0UQqonSOToajCUXBpCyNBJ0AVv1estUOKzkUeom+qdaGF0eZFCEjdWUYEW5QOLLXMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqzAt/nNndS6ciIZ4al8oV2o0FAUsbEZseqb83RuJbY=;
 b=Z6K5PspWofMMzxJjTH29VNThvPJV4VMJaZHvn0dadR4lKWftTVS45g53vitPdJf9OGByVmN8EP4CWCZL2+Ydo5mprLhfFn9puFyP1gZ69GS5J8vm2XsiYc9nOk61VIHW8rIqL0UjYZr1vwHXtWue01hPMrLBMfi6GdM/u49eC2qoGR9wCkctxePoBT8KWppAF9ByHYm/eeMHBBlncitdYO07jIFC9LJ/SrI4jUf+7aVHsu9QhTmDOubm3Qvb4aUsP8IACYCTOz/Ebx01YQmlmxN4f82jpCb4n2aqM+0JGXwGYpv2mvolJc89deuLG/CLZmZ2M3MibghesFcIoBRbWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com (2603:10a6:10:1e4::15)
 by GV1PR04MB9119.eurprd04.prod.outlook.com (2603:10a6:150:26::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 20 Sep
 2023 07:58:17 +0000
Received: from DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31]) by DBBPR04MB7788.eurprd04.prod.outlook.com
 ([fe80::5b25:12c8:9f51:9b31%4]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 07:58:17 +0000
Message-ID: <dda01248-f456-d8d7-5021-ef6b2e7ade2c@suse.com>
Date:   Wed, 20 Sep 2023 10:58:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
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
 <20230914044805.301390-4-xin3.li@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20230914044805.301390-4-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::20) To DBBPR04MB7788.eurprd04.prod.outlook.com
 (2603:10a6:10:1e4::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR04MB7788:EE_|GV1PR04MB9119:EE_
X-MS-Office365-Filtering-Correlation-Id: 80bc802f-28ef-4998-92a9-08dbb9af5916
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1TwKv3hP2KwjHU2HAp8pXPgTzzxfoEMMnje/TPsKF40rw3SNrcbP/GoeeNh5rZEW8td982q+7MmRUKwVgwbaMXMewPp2mxuYOEVQCvBNdyuAyLxFn+u2uWE/4ytW8iQlOY6OY+mVIE7TYIKsC65axnfniyRILU4TJaf2bfYWOmtElxbQ9KFr0smdYmdRUciNVkX2TrpDvTlbnbrN/zMcRGQFyD6iE0uJvRAJsNUGoVooLqdojviExyE5zSPd2V82jtvKIS/k2LCun6lj5Fwe8KjV1p73lcs0uC1/vUbVjfBMI+7OOTkRM42zr6fKz+1VUMiJw6kH2vIx/Qflt+u5Df6ava+T9FqfT0NS+8sWnZ8139c7fV8Sj/4KPBs7ozcjx7BjyxXZq8iB8VLTZix16DA/nFXJeYDdlKN9yzjWrNZVnLRn8QKIvSts/nF9goMiky5hlzxqv5zhoCAVTWHwCBq1FMLBX8iTS6pWO1ti6z44D99PFTyO0eH//8AZ07uBiE7koBX39Qy5S2RJgaTY1PjB7zlvVRvRxvyaLw4qSRsCspUGawuMpJ2sQbHgSQMmS+fdgm/RrVcDpZI0HYxjfbVyOr7XP70IVW0MlvNrQZxbMAXKVy4YZbRrbBN00jkY/CH8I3kMqAoGO+Jl10smieb+Fnx13Yc4I6T7KoFh2iGADdjMeY6StkXfAi1UHxOC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7788.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199024)(186009)(1800799009)(36756003)(38100700002)(31696002)(86362001)(31686004)(8676002)(66946007)(6486002)(2906002)(5660300002)(66476007)(66556008)(8936002)(478600001)(6666004)(4326008)(6512007)(316002)(7416002)(41300700001)(26005)(2616005)(6506007)(133343001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFB2K1NlQTg3UFRaVzN2a3J1WmpqMEJETVV5aC9yMlkwWTJiZjJhK1AzQ0xB?=
 =?utf-8?B?NGZEYkw2UXhEQ2tVRlBSUEJvdzdTMUNQNlpVcU5xSzlGK2dZUlhuTDVWOS8x?=
 =?utf-8?B?em5EQXlMaVQwbVJiSDVvSmZTWlBPaTFjSkw1NjNyUy83RUl1MmNLeGJTNkty?=
 =?utf-8?B?OWJBWmNRSUlOZzN0TS9PdHBEVVBNL0VNYVFLbFhGSVFNNXFZVGRROVBPSDEv?=
 =?utf-8?B?ajA2UXhTUXNaWWJMem9waDBQV3RHNzZGaVdpZ3JwTlRxandhelhvdFlFKzE5?=
 =?utf-8?B?K292TGYzc3RVZ0ZtZGlNQVM4aTlEeE1jazA3d3N5RHgzVkR3UjQ3b0ZOSzdS?=
 =?utf-8?B?eElpdHRSWDVsZWZhWjM3MUxOYnJQcEdyL1ByK01tSXVxdC9GZitTV3VwUnV4?=
 =?utf-8?B?STJSUVFZSnpPTDBZc3BFQnB0QWhGTXI4Mnl0R1J0SHlJUTBHVlBpWUVOeTlZ?=
 =?utf-8?B?Z3paZUhXYmtpWmxWbnFZRWh2R05EQ2VlSTZRRG1zUFdqNDdadTlmR1VFd1Rr?=
 =?utf-8?B?WVNsRFRYd2hrK1NYZUozRjZVZzFvMEdoQjRkOUM3K0pCTTFrR3FYaGpyYzJZ?=
 =?utf-8?B?WU81M2R5VSt1VG5zRC9vWHdKVWZhd3lUaUpSODJuVnZXZkgzWnZ3THNQRk00?=
 =?utf-8?B?ZlJwUkcyZExwNm9yU25MVXQwT21sUWYzUERBQktwbkk1MTdHdnJDQ1pKYjhm?=
 =?utf-8?B?ZG9sUEh3dWluT0tYRkpsbWxUT3BoZkk4T0FPNGtnbnBRQVVkZXBlckhrZlNn?=
 =?utf-8?B?aFgwNHBKS1NFcDF4UDNhaXpLbExoM1czelBXbThNakRLSklVR0EvdE55ZW5x?=
 =?utf-8?B?N1JRbHRWTmk5dVNmbXlxQXM4UncvVXNkR2N5Q01xWXRrL1Q4bEZJUXdrYlJq?=
 =?utf-8?B?M2pTT213K1JaR2RsNUc3MW9GU2NqYVQ4cEdDNEczQWg3bHZ5MnZKalAxNGUw?=
 =?utf-8?B?b2svNjVnU3RGU2MvVU94TExWWlRWdXQ3Vzg3Um9XcjBra1JmNjVkSjAvaUwx?=
 =?utf-8?B?bThMNTV6a1hQWjFrRXpXcTRTYnhYOUt6cTY5c2NCYnF3azR5aEJQODQxZVJJ?=
 =?utf-8?B?ekh0Y0R4R29yR0lneHpNRzZVVnJmcnRPTlpOZFJNN20zci8yRkdJd2ZEUGM0?=
 =?utf-8?B?Qm5YTExYaGN2RlRGRVRpVXMyb1k0TFB1OW5lY3UwVFpOanRsSzhsSEw5UzRP?=
 =?utf-8?B?VUk1M25nWSt4N1l2Z2pMY2dTNWhPbzVrSHlQYkNlZ2dTQURDVGlpKzEwWm1h?=
 =?utf-8?B?RG82cHNLVmd5eGlQTHJVcjdoVkRaSFpQZzB4Z3lheW5ZcTFrUktXRk9nME9n?=
 =?utf-8?B?MXUyZUdNWGFNaW9YcmdjdFBJZTVoNWM2akw1WlRwRWtFdEg5cXQwNFcxWTVo?=
 =?utf-8?B?VUpGcVA4dTM3K21nVXA2SFBGdHhOWkVqbnRHVHl4djlJUWw3SXQ5aGlkSFNs?=
 =?utf-8?B?M0FURmZ5TXVjS01FSmdEalQ1Q2tzMHVOdFh6bVJlait4NndiUUdHZ20wT24w?=
 =?utf-8?B?ZXk2aXZKYVJqT3JEUWdSbDRPT2Joa1l1Y1M5aERXUE9tSm5YUkhFeGZ5YUFN?=
 =?utf-8?B?eUt6OTRGUjZaK241Y1RBV2UxM0ozNEdKUVR6aUNjZlpoSENsdmVCcmdLVjF1?=
 =?utf-8?B?cmlEZkpVdEVUbmJDcllBdUFzWDRrcEdTVjJTM1ZBSXJaY1dyMG0xZ3ZqbUs2?=
 =?utf-8?B?R2I3N01pMEFGRk1XeDRwL0VuQ1cvZGxta0k4ZFpGci9YYlAzWDNFN3RETm4v?=
 =?utf-8?B?VVBSdDlrQk5VcldlL1k0OXVONkVpa1NmL2lPMkpacUFDTStCK0ZHallTRU9G?=
 =?utf-8?B?Y0xUWUpaVlUrVEYvUHBnKzg4cVRtK1JrTVllRUxwTklPT1c1VEMyd0xVSXU5?=
 =?utf-8?B?QnQvYjRKMjArNEpSdTcrOG1nZ2t3b0lRUkdvWWY5Ulp2WDA3aW1DR3l0NXB4?=
 =?utf-8?B?b1VFdVpWUUJQaURMQjQzcFVZTnZGanRKTWRueTNJK0VCWngwb0xZVUhKeldW?=
 =?utf-8?B?dlFydVV3cEl0TEV5UkdacWJaQjBiRW1VVlowVVJkYXEvWExsNUlaM0x5Nlhq?=
 =?utf-8?B?RWc1bTZJMFJHT1R3L1orQ0VVSWZ5UkZSR0tPaTVXUm0xM2d6dmRmN1V3RnY2?=
 =?utf-8?Q?9gThm3uUYxbFA8RsK86lryaBt?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80bc802f-28ef-4998-92a9-08dbb9af5916
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7788.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 07:58:16.9751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYzkTC0I3XnKs4KQJ5OEe+Q2UhWjQUVM1QgyLdI0Aacy3lDhSCgCYPGMZWZxdgC1q3dHv4M+7HUs2kgPqEJaMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9119
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.09.23 г. 7:47 ч., Xin Li wrote:
> Add an always inline API __wrmsrns() to embed the WRMSRNS instruction
> into the code.
> 
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>   arch/x86/include/asm/msr.h | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
> index 65ec1965cd28..c284ff9ebe67 100644
> --- a/arch/x86/include/asm/msr.h
> +++ b/arch/x86/include/asm/msr.h
> @@ -97,6 +97,19 @@ static __always_inline void __wrmsr(unsigned int msr, u32 low, u32 high)
>   		     : : "c" (msr), "a"(low), "d" (high) : "memory");
>   }
>   
> +/*
> + * WRMSRNS behaves exactly like WRMSR with the only difference being
> + * that it is not a serializing instruction by default.
> + */
> +static __always_inline void __wrmsrns(u32 msr, u32 low, u32 high)

Shouldn't this be named wrmsrns_safe since it has exception handling, 
similar to the current wrmsrl_safe.

> +{
> +	/* Instruction opcode for WRMSRNS; supported in binutils >= 2.40. */
> +	asm volatile("1: .byte 0x0f,0x01,0xc6\n"
> +		     "2:\n"
> +		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
> +		     : : "c" (msr), "a"(low), "d" (high));
> +}
> +


<snip>

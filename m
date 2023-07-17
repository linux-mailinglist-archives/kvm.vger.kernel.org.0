Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721E1755C4F
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 09:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjGQHCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 03:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjGQHCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 03:02:11 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2070.outbound.protection.outlook.com [40.107.21.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065C9F2;
        Mon, 17 Jul 2023 00:02:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fS7l6ir8bOrBEJCfn9DfobAhFpASrBIVvEkV/lujABBLYjpILTgF4rlGhm/6jqpijjnuRJd4PWnGEwG89kbrfdEIxlCL6bcVCNk89rGass/IasX0M97H/BCgCyx3BLwa24vjkn514qh/5lZMVrQAu1lU8IJ7BrxdUfHnXeOtAisp3G70GRKMH9T321RBP+yCKjPvBeeTslYGkd4JBrPRZmW8eww+FKlXlmRmqeEGvsP7QimVeAujo3iAh7sV9QuH3jpFmCegK5FK5HTHYaJ2p3gVHq4HowMwcoFSarsFhA4CZHJu4KWjHbpN2A4qVuIYiP7XmcHJd4DldW0ywQjIUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E9N9QBLnyJh2/+sky0F+4xlcGYVGO/7ui1fo6syKMDU=;
 b=D3/J01QQg6Lb/L/Bn1OD24TGVFU7eZNfX8qUk+bP0CG7Lk+Q9hU3FBx6wjTsTMdJcGVz1plE2Ev7Le4eWfDQKw+kDaAWlMuWdFU1A+t7K3NTnC5u59ZMB7X6IgQ6/MD47gXXYG6tm6ckJl4tSDwL3nIgxZpMAJZb4P07ZEnyri0o9HEqP9S+CVG2G54ImG7OMmBE6C8ZwGkRrOjC0ETCotYKeeu0nTR3O7jDx+NDwnMWM3x8AQjncFgGxfxRqCfcGmNYX3so9Lhu+nqA90F6I/4Px+0d/ddWGvF1NAKNG5lkg6hOqCcHsbJO219NpvXdM4vgzDbr87OlswbKFDj9dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9N9QBLnyJh2/+sky0F+4xlcGYVGO/7ui1fo6syKMDU=;
 b=tf2wiU6qUdLZCDRLUH9u2RfcDxiPUCoy+uJ9MO/vbSmWVafO+AVs7bumJf9KBtsCTRc0IRAuGZRU7oACGRynySdTHrj3HbebDlNbmFgpOfHYA+XuuDVwh9VZC34vmzLACKxqQ0DMbBqMFplFQXN627zEpbHIUMZZjk5DGBTio0q8BM4PRgWKNHuQyR3bQC5cGO4IvpCS68sJmLHTmpWglkyRIN6qMBhBZxKsq+U/EmrBQI70dptclVC+B99SRl8ChrcqbajkciVH0v+9XP4csGHJ0v/bLixsNh9pPt349VGEzEE/xaY83SfT6cVZfY0eKtYgXYN34WYXR4xM8IPm2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 07:02:07 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361%2]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 07:02:07 +0000
Message-ID: <6b425468-3aac-0123-c690-df8d750ce29e@suse.com>
Date:   Mon, 17 Jul 2023 10:02:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL
 assembly
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
 <c22a4697cfe90ab4e1de18d27aa48ea2152dbcfa.1689151537.git.kai.huang@intel.com>
 <b95c4169-88c8-219e-87b7-6c4e058c246a@suse.com>
 <71396c8928a5596be70482a467e9ba612286d659.camel@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <71396c8928a5596be70482a467e9ba612286d659.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: e30fecfe-db12-4f42-2789-08db8693bb7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0jYxeAfgjR+pAqRMEj333j4C2vodRYgogKmn82YtHreVdp42SCVq2+AHQvMWJ1XlAK5fvgMW3xMc44/ZH6jwas7+tLgqWcKbfJZ0De8Yi3/pTlgaPvUPjHRMuG10RlJSnazefwMjWem1cSg6fWA/JaRtqM7fK9ClrsrjuOMLJ8UhN7x/kSvOVKRYtd4ZeR3mkO8RCdLydY6lhxNvJp+3+4g9hJGlr/fxEsenCclk8lT1d6biz1I7Z1PP9Z0R5600OOIYFKSm8JIaqrQA3eJOPmWqTZk5ZQis02lkaSTH/qr8cjisRwmJHR4fDV4GbkvYo7uMtXL7Bc1xKu4P0MFWvMZjAKCfW6/1p2xQqm/a0hbA0s/nC5jUoMJoOvM84Zs/wklTX25klYLyEIZgqsiIxXnnWS0lln0f/FUYLBRB4RvK9bEL5RKBD8oeiQuyAbU49BDT+twx1jFX456A55TrHui4neRXRQEZsoLQYe4+ml3zYasXLMRxREV9UWMWXGP4U0V23y2Tmqyk+6YzexyfeWz5OfyfyUAxhT8CsMVenaRIZmPNeOFIKu77ZnE/QN1jD4wFzuhF5377ZAtEG6Dp4Chg5atoqhW9OKZgMT++HBqHohnukmSsXzkGsz80SC4s6KIYthgpBt9CBnfuh0KGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(346002)(136003)(39850400004)(451199021)(31686004)(83380400001)(478600001)(186003)(31696002)(2616005)(86362001)(6486002)(6506007)(6512007)(66899021)(66556008)(66946007)(7416002)(38100700002)(54906003)(110136005)(41300700001)(2906002)(36756003)(6666004)(4326008)(8676002)(316002)(5660300002)(8936002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yng0T1k0cGZOZUtwMXptQ3NBRmYvbkY3dXRNTGswbWhjMWFENUkweGpuUUhV?=
 =?utf-8?B?a3M5RHFqS0l3NWNLcmFBaEdxaVRYSUcvTDVVZ08vN3JWaTdnNGtPbUxvbWVw?=
 =?utf-8?B?TzJ5VGQ2cmhnZytvMlRvcFdrZU8xdHdUWkd5clFibGJTZ05tZ1ViaDM5KzZy?=
 =?utf-8?B?dHVia0FYU1FxeEhlTGRWTHpYWjVGbHNLckF5c2wxYnRwQnI5Y1liUU13QXo2?=
 =?utf-8?B?M3BYSGsyNGtvNG5uQ1hmeklvYVBJZ1FYeUk5U01pZ0xqdnBxdkRSMHYzL1NT?=
 =?utf-8?B?Z3hYblBJTHFkbWZMc1hncEx3UXJZRWxiNm5JYm5yOTFyRTdnSzVtODVybEFu?=
 =?utf-8?B?c0VoR2xEQ1lRUWNsVi9IUGUwd3JDTDNJdWUrbVhxS2FMNW9mM1BiVkRuTzVx?=
 =?utf-8?B?MDFNV3JaajNMcjdCcVFQYmo5cFQwK3RVQWhsbVcxRUE2RW0vRmFEVWw4SmNG?=
 =?utf-8?B?dkwwc2FweGwrZE54THNVUC9KTEZwNE9SYlduU0U0R0x2cmdlOVBsQ1hqWk5y?=
 =?utf-8?B?OC9BOFYyZm5VRGZWY0FWbDZhOHVJREtDYk1EV3J0a01JVHNWQVplT0NZSXdk?=
 =?utf-8?B?ZzBxbXJ5WmM3UmxnUjl4cjFWS3lHTnE0M1VUVHBXdEVQRmVhNXQrNlQvTXNy?=
 =?utf-8?B?dDR4bXV4azlwUk13MVRWM0JmTm1mcWQ5eTJqdHJKdXpJTHpGS29ycndCbXRy?=
 =?utf-8?B?RVB4WmxFM21paHp2UkV5TnpMNjdGd0grTnRNdGNBT1ZxR1Y4YkNITjE3SzZX?=
 =?utf-8?B?ZVNTUEwrdGdHdC95NnBiNWhqaUtMQVgwRUJyay9aTWs2WUFHYkVBNDlCSFRY?=
 =?utf-8?B?MDVmdU9jT2VFc3VKTzV0aW5TUXZBODRib0lmQ3g1SmNQbWRjUlh1djdvUmpD?=
 =?utf-8?B?cFkydDZzZ0pHekNEV3V6aUU2bzFWcUdqajZ5aTRuMkJtMlJBK3FldTZLbEtQ?=
 =?utf-8?B?S3JsVkp5aUVmOWR0NXRZZ2k5Y3p2QWZkbDZnWG05MWZrR1JTSHpEOUhJTk00?=
 =?utf-8?B?ejR5cEkxcEdzWkMyUXdNejljeUV4clBmTGJCZ0lYdmsra3JLUWNkZTRhMlNJ?=
 =?utf-8?B?cGEwaXFrSE1ic3lMbHpRb01rZHBtM3hRdURrZ2s2cVJ6RHlWRC9lR3RqSkJs?=
 =?utf-8?B?TG5uci9uQlVBTEV3VFFWVnlqdklaa0VndnZFbGZwWHVQVDVtYVErNytGbG1h?=
 =?utf-8?B?YXh1bEhKVnFObncyZFdlbmI0Y00yNWxGbDFaNGtBRitIeGRUQ3BqbzJQSERZ?=
 =?utf-8?B?aXlvaHArS0swN1ZBSzl1R1hQejFaZWJtZ2NrL3JvSnBPbi8zeEE4K3BqMzcr?=
 =?utf-8?B?RCtqOWM0TjQxSGhETUh3dzMyZkd6Rm4zc0hYbzVhVGtuRHI4STdQZS9MbDg2?=
 =?utf-8?B?REt3U3NLbi9EV2VHWTNEVDhzN1cyT1pFeUQ0MFk3ZkhaRUZjUUk2aFo2MTEz?=
 =?utf-8?B?aTZweUJDVytYNlZWWUJhZmgyaGdSZ21EY0lwQlhoOE5jTXl2L1cyUEc0S2Jx?=
 =?utf-8?B?MFFxYjcrblB5aU53SUJpK245bE9jNS8rMEZEUnhHZXJndEZIRWFJeGkzalVn?=
 =?utf-8?B?TDRIdU9FZ0FDclRLWEdTYmgwTVd3b00zK0c4WmxDQnFuVHBydlEzL0ZNV1hv?=
 =?utf-8?B?cndHdWlESjFSR0cxTCtxUGFGYkZ3S0hGUkhMWDVKOHFwKzVncERXTUtLZmNK?=
 =?utf-8?B?Q0IwRFhMbkdTNDVwRmo3Tzl5dkMwRStQMGttN2lMUUtwcHBFZ25ZYUpNNFIr?=
 =?utf-8?B?WitpTGhJdEt0NlV0cmtOb21EckxRNG1Ub3R6aUVTVSs3UER6ekUxT1F2b0Mz?=
 =?utf-8?B?Z2sxMDE5VFpiLzFTay90cVo5dm9IcGRXM0dzZmpRcEJxSUMyc0tUQ0dRNEto?=
 =?utf-8?B?NGpYVFNEUk1MTWt2UzduSVphM0dzVHVYRmVKMVBpWWRsT2gvS0syOGNDRUkz?=
 =?utf-8?B?VWpLcmZUR3RsQXFzVUZkZ3B6QlZGekc2T1JaUVVPbXF5UDgySWhJZnFIU05x?=
 =?utf-8?B?bjhzc290S0h4U3BDV1ZLWk9ZdjREZXVUTitjQUphZUZGRjFaNjcrYTB6d0ZP?=
 =?utf-8?B?TC9PTUpLenMwSldNZy9lSHlnTzk1SEFUdU1qTkF3b0NrdllEMHJxTy9kY2ly?=
 =?utf-8?B?UmZLTFA5SFdTZmxRS0c3Tm1DaUNPZVdMTXhORzVBS2N0eUZhYjhCUVJZb045?=
 =?utf-8?Q?RyAG35qjh3iuHL5l4XbcwVhyf9eMDQoxHh2rVlZD1Lpd?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e30fecfe-db12-4f42-2789-08db8693bb7b
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 07:02:07.0334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCZygl5rikC64YQxB9q3BTaFzAo6U5nMhxVZPsiM3p5k6CBJVElGZZ6+9R16cVlI+LjZe2KKHGz0mU2f2kWiSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17.07.23 г. 9:35 ч., Huang, Kai wrote:
> 
>>> +/* Called from __tdx_hypercall() for unrecoverable failure */
>>> +static noinstr void __tdx_hypercall_failed(void)
>>> +{
>>> +	instrumentation_begin();
>>> +	panic("TDVMCALL failed. TDX module bug?");
>>> +}
>>
>> So what's the deal with this instrumentation here. The instruction is
>> noinstr, so you want to make just the panic call itself instrumentable?,
>> if so where's the instrumentation_end() cal;?No instrumentation_end()
>> call. Actually is this complexity really worth it for the failure case?
>>
>> AFAICS there is a single call site for __tdx_hypercall_failed so why
>> noot call panic() directly ?
> 
> W/o this patch, the __tdx_hypercall_failed() is called from the TDX_HYPERCALL
> assembly, which is in .noinstr.text, and 'instrumentation_begin()' was needed to
> avoid the build warning I suppose.
> 
> However now with this patch __tdx_hypercall_failed() is called from
> __tdx_hypercall() which is a C function w/o 'noinstr' annotation, thus I believe
> instrumentation_begin() and 'noinstr' annotation are not needed anymore.
> 
> I didn't notice this while moving this function around and my kernel build test
> didn't warn me about this.  I'll change in next version.
> 
> In fact, perhaps this patch perhaps is too big for review.  I will also try to
> split it to smaller ones.

Can't you simply call panic() directly? Less going around the code while 
someone is reading it?

<snip>

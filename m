Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F48C7CD6BC
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 10:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjJRIj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 04:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjJRIj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 04:39:27 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2080.outbound.protection.outlook.com [40.107.13.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5038B6;
        Wed, 18 Oct 2023 01:39:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnfqLVthOwu43E7/ns/uOoJ5dnW8c4JZKW3R+DQX24lIPU9epMjlEhnq0S3LiZvEcwdNHjAa0NVHpr3k3duj6Zk6S8oss/LPCGPJ9qUmet8Rs2NyNbChaiPHMvvQ9CaECvIT1Pw3H7QNTVv/XNQKbH0l/YdPr4hu7k4a1fWnhDcnJHFc4Xak3l9VW5opG2/Fis+ZyQNvTeMlfnpFHrJxN6MME5iUkKjnx8RJkPHuaLmPt7WueV/UbHbC/MVDQmQ6TpkhgGEjvsgwoz4O3Sa4eLpFk19XBzMDJe7odtcxm57TxRPxYEn/kOzp31ugEzUe1b39QaQHEO6SHf8EBeXCTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7UI5s3dTCwMdHtpAkmElCvQ6YLbLGofAcvxd7kuFCw=;
 b=moQ5mXjIrM4yVkytjuT42rTmUw2wMNyoyWN+C3RsGySymjHZKkldeKMCLqFghjpTpE9fJgzNABFpTEAJsUgiZ3hiXmOkfQww9+Qob5Amh0tXb5gasQv4ro34cMUnFsmXLi0B3j0S3va7y6VwuaZ9HYigl5FqcECubyGKWBBh0TId7pyDxYuEB7jThB84tGzUcESk5rTxmVZJEy96fiNtrbOMQUsWNyujq1nDLb8nl5th1V3H14/p0Sunocq/f+m26Sq1GS1lcT9ffKdfUgFWJMFlrDrQhWRyMLOas/4SYMeNxVWo+gO61lmt0iYJBJBG1dyPxv1nsd8F6ChLLMC7IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7UI5s3dTCwMdHtpAkmElCvQ6YLbLGofAcvxd7kuFCw=;
 b=owBqA1EJDsNBekkvTD8IR+/fP5L6IgNc8nX5iLBU8p4WlJSrrTkoG7QOejktPKclzvnOTbibplJ9APpEQlsEVTYamHL8STN0qRK2DULz3UXZ07TOZtWFNNCduIvLKzmugVL26fcTvOt7OZJ4gSWB48abG8xFXxu4C+yeXM43DVAnwu8PAP7PL8W4pM0FeKSBE2kcjbUD6TGpfqURymJ9kiq2EfOGB6pSzP64Iwwmbu22oaw383zrqg8wQoqvEf+eyY/psi/BBi9CrjzcZPnAttYvzXsbKW7nEwrNSKSWlUl77O4/UeVPR650B1sCYWAIL3TceRto1hbjWYn3LYzAuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PA4PR04MB7757.eurprd04.prod.outlook.com (2603:10a6:102:b8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 08:39:20 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 08:39:20 +0000
Message-ID: <5fca35af-b390-46d1-b5ab-9312fa740599@suse.com>
Date:   Wed, 18 Oct 2023 11:39:14 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/23] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <cover.1697532085.git.kai.huang@intel.com>
 <4fd10771907ae276548140cf7f8746e2eb38821c.1697532085.git.kai.huang@intel.com>
 <ea983252-0219-46a7-99be-5a8d22049fd6@suse.com>
 <a0389bcb3fa4cd1f02bff94090f302b87d98a2e3.camel@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <a0389bcb3fa4cd1f02bff94090f302b87d98a2e3.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0102CA0029.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::42) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PA4PR04MB7757:EE_
X-MS-Office365-Filtering-Correlation-Id: 90d1f41b-a38b-4b38-c2fb-08dbcfb5b8d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMYvrN+AIbwg2ffdZUBXy7MafHLnjobEfLKqelnbqvtYuVlMFI3ask6vFF0jCchfxKssYB/HZs7zIlFMSN3nhPJk0iyhXBdUbs4u+WL4qPOpbVoM3euPxH2tUmwS5NhRyq9cih/Ou3JuWWJXPWmZN7xmR0HPntLyrdB43GxaUJ6GqsXCbtt8j119rJ5ePQVqyX7zZHeDhhHssUgoUPa47jOevvBBxvzRVQ13z2ruH7sFj5Qv04GZomoMXNJj0v2tfxKpavF7vyug4dmw0UmJLgOZnMYIi+nO0abwYz7csMYW8AMhyHEj2haSoLBLlEp6MqiVsRVxVKBqlBhtL+X8gzLsjiS1bj/6NNkHJRjGZrLTY5U7Wx9P0g3LZisVVaRIVwlEhaBaBH2zK+8zmWI7+gNx1IWaii3HDA+adNQ8ux6BU8/4N4+32/a4fZbY3cu53Ux5h4Xdl8sN35SuBmeWidrsDuXYmaGE3wmM4xFTeGAQ6hAMxs3l6esH/D9/hQygV03y9JjvGcTcPx6Fn52ociw4JrAcY5NRqqnASQhp3+km6yOAQ5EqaDEaaKnq6vVyuuHhokDX2vqyj+38OiVcXVUqK9p/USPAAmPr5ImiyxdHCH6piM7qCqN2hYW4bS/9mXDYQXeFepigUBxrnpUQSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(346002)(136003)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(6506007)(6666004)(6512007)(2616005)(6486002)(478600001)(83380400001)(38100700002)(31686004)(66556008)(316002)(66476007)(110136005)(8936002)(8676002)(4326008)(66946007)(7416002)(2906002)(31696002)(86362001)(54906003)(36756003)(5660300002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEVTTG0zNFkvMXRqdDZRNVR4OSsvQnY1V2tScUMrdFpWanJtZHNzcDA0d2pG?=
 =?utf-8?B?SUxKcTJwRHBGVGdVREE3aUtuTGJGQmNXMUtoWS9Pa3JqbGJscFFyd2xMbFdM?=
 =?utf-8?B?V295TkVHZUtMdjNrc29XWExUYTMySGpjUTlqZk1ybFJiNThPUGNFK3ZuUXB0?=
 =?utf-8?B?c0RoaU9LNzg4a1BOMHNFUEViQWJVZ3RnOUUra1Y4dVJoa3JNbGt0NkRId3JK?=
 =?utf-8?B?dnpnMmhsUTVvRnIwdXdZT1liNjNTMkJxZWxGOWdCSTdLc3pZbnJWMFBLQXJR?=
 =?utf-8?B?eVVVK0pDSkVnR2pPUnUxMkRRRDlDa3NCcUpBam9TSVV5WjNEOEdDN0hYZjhi?=
 =?utf-8?B?SSsyaHJxQWZnMW1vSXNHVWJIRVcxR0xRa2ZYNHdIeW9BT1dXVHdRM0FFR0lF?=
 =?utf-8?B?a09Rak5RUlNIVytVSXpZdnorbXgvb1hVSXJ1ZzQxSnNmV2lySnpuTkRuV0NF?=
 =?utf-8?B?aXFkN2xtVC9FYWJVYllKd3U3K3I4c2FCWXFJTTdMOEtKNXJEYWJTMEtNZ0FX?=
 =?utf-8?B?Q3VWZlhJZ0lyeDZNeS9lU0NkZWJNUWlicmlTSWhtVGpSMEJ1OHBkZmJMQmY2?=
 =?utf-8?B?QzJZYzB3UnNNZ3FhQUNDK1pLUUtuUnBRYkUySlZvRTRyUmJxMDFNY1R0R0VH?=
 =?utf-8?B?eEx0UU9TUFMxQkg2c2xqK1Bsbkx2a3g3eFBDb3dha0M0a3N0ckZjai9Qdm1N?=
 =?utf-8?B?YVBXRDJpc29FMGFVNWY1T1dpUDJXWUpOdVJtMktIZ0VlcXcyYUxJcFlXNm82?=
 =?utf-8?B?OXhXdUlmNWtrZExyZVFYNWhsUDJZdjEvazg4UzlKKzRBMXczeXpObndNTTlP?=
 =?utf-8?B?YWVLRlpwdkFtdUs1TUVEY2tHS21XbTNYcU9weGVvVEVOK1EwQUJmdzg1UWJ3?=
 =?utf-8?B?NldkUnFYUWs3VHJlcmdjUGdRam9hblVvMXBkWmhwMi93bmJMOHdzNUNacFlR?=
 =?utf-8?B?cnBHcFplNldlcUNMRkRYbTlzYWNCODJJU0VkZW13OWU5Smt2My9WY25RcFQv?=
 =?utf-8?B?RGs3bkVjQUdwYjVBOVg0WWh6V1RZdmpveDdoVzZKbnM1YTdNRWdFYndvV3R2?=
 =?utf-8?B?Q05TZndYbUxaY1NpUFU0UzdZYjZTVllOYWZ0Vjd6Z3pNQlkwNHYwSjZoM0FM?=
 =?utf-8?B?YzhLd09jQXZBNGpTVWxEcEFJVlBoekFlT0gyOXFLVVZRNjBKdENtN2J3dGNn?=
 =?utf-8?B?MlBqbXRoeXpZV3RnbHNXYWU0dWwwb2pleWkzSVUyak00SFdicWVSelU3QW5m?=
 =?utf-8?B?Q0lXREYzd2NyOWJIWkFTSUUwYlpxNnlUc2U4eE1zMWhwSXNId0lHK09EeGNS?=
 =?utf-8?B?Q2xoYVRQdEVZaElPQWNrRitHV2ZVOXVPS1RjZzlXK1p1STdINXJMS2ZScnMz?=
 =?utf-8?B?M015b2doYUx2RG14YlUvOWRpbU5VSDFlOTFYV0VLckx3TjhnQ0hLVnNMVEpR?=
 =?utf-8?B?d2lTeXB5cXo1Y0txTVVzMXRTeEhDUytFTFBORElrdnZLQXdnWllvbFpERVdE?=
 =?utf-8?B?Mks1RW5QR0h0Ym8vVEVJNmxsa3hwN0Nlbk1mZTR1WS9rNHNjaDcvdVJzbU1C?=
 =?utf-8?B?Mm1XWUFCSlV2UEowd2VuNzYrd1doamZSajM5eHppN3lqdmczdm9iWUlZK3FT?=
 =?utf-8?B?aVRWRVV0RTdBQ2k1aVNHRHZiQjFQN1JxQmc5ekN3TUpZaExFK3FGQktZV04y?=
 =?utf-8?B?aHZVQml3ZFBNTVkrL1ZpNlhhZkpFM05jY0FCd1BEa0djNXRpNzU0K3ZrV1Ja?=
 =?utf-8?B?VEtIY3VWbjFYUDdndUtDZUk3N2VkUGtkZTh5NDNsRWcxeWxIOHpTcTMraTdI?=
 =?utf-8?B?Q0NNb2crK1Z6NFpVUTd3TEtLUWFiU0NYYUs3UkQwWi9YYThrNGYxODFBNVJ4?=
 =?utf-8?B?VEtQaXRSS1pFK1hIMk5RTGg5NE96amk0dnJjMlZWVEloTFNUVWVmcFU4TWlT?=
 =?utf-8?B?TE9Zd2xCbWN4cllQZnh2OVhsMndPZlJCQkJpNmE5SW12a2VwdDU5MW1Fblh3?=
 =?utf-8?B?MzRISGVKNXFBWU04NEZxeng3amNqVGw4aXdlQzVSOUxMTHZoTG8xbmtPK1hs?=
 =?utf-8?B?YTdrNmNCZmVZRkIwNkVKSG9kelAwdWgvZHZRdjRyOHhhZVlVOXhxMCtPME43?=
 =?utf-8?B?Qyt2RnBxQncrRzBQQy9vN3AxSTF2NXVWblR6WnJOck9WWnh1bFpuSm1NT2dS?=
 =?utf-8?Q?QJRGzjRldS9oq1hwK8iyA3tl0zqbhlXyIkjEA2Qj1wkp?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d1f41b-a38b-4b38-c2fb-08dbcfb5b8d5
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 08:39:20.1309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4CNU+cnsPveovWfR4qm6JTwDckAo+4ljT6B4MLC6gzrj/FwIRj6baR1CEv69pFN6YWzwaLmmlRU8YUs35HWkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7757
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.10.23 г. 11:29 ч., Huang, Kai wrote:
>   
>>> +/*
>>> + * Do the module global initialization once and return its result.
>>> + * It can be done on any cpu.  It's always called with interrupts
>>> + * disabled.
>>> + */
>>> +static int try_init_module_global(void)
>>> +{
>>
>> Any particular reason why this function is not called from the tdx
>> module's tdx_init? It's global and must be called once when the module
>> is initialised. Subsequently kvm which is supposed to call
>> tdx_cpu_enable() must be sequenced _after_ tdx which shouldn't be that
>> hard, no? This will eliminate the spinlock as well.
>>
> 
> Do you mean early_initcall(tdx_init)?
> 
> Because it requires VMXON being done to do SEAMCALL.  For now only KVM does
> VMXON.
> 

Right, then would it not make more sense too have this code as part of 
the KVM bringup of TDX. In fact by keeping the 2 series separate you 
might be adding complexity. What is the initial motivation to keep those 
patches out of the KVM tdx host series support?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABB162A12B
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 19:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKOSQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 13:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiKOSQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 13:16:03 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0BD2FC09;
        Tue, 15 Nov 2022 10:16:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VV+waz+FvN5Uc+6+BKqVOMDTgZcANMaxLEgAq6mn05NoXDWwIaG/6r5LrPBJm7soZGVnaiE+WAllTTUJg89JimD7rfFsIRtA7YHKRUf6KlysrFGYDtHU8pZruL8pooQWwpgfCKW8X4ROsHx5rOFKTW367nq7+L8wuabf7eVtlihRpO4KukBLAV8FjBxOKF5QqCt0L4YPLmr1zhsv0VwgTaPA2MRENo5muKDkjVJO5MgyPX5wUg4ihKGUPV9364Mo/7NDCPLCaHiohxksGJFLj+58jFoSYjDYXo/JnEyVKJlkALkiY0Vzck3TCFvjNk/uOgWO6h1ylXP4hxGosPWVhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pbuQQl22wNBU+mFzmLG/SDd2DPdZDySS1BuB9hjmWA=;
 b=RI/p/lfHi2aY9CVsdOJJILJ0XzjgLmQQebUtpTveihsusiW0hyqJwaUS7M3IBG3OXwDatPRWzra12Md+IiSkjhSLZ5Nk0P8yRXFpFoRndqdwRmDyPNDRVK38UCfo89yKhCayyKoOuqB2JA7f5Wz0M/lmPEjgfuBq+1tYaWvI6peedDYITX6ALbw2I9uNHuqUPYC5so84sadAeWAOt+kx4QnCsdJKex9DFapv1BN0AtYLY0cjwSPh8fY9gr9QznxGc0B7rOgUF+lmdibF+IkmnbqWMr7busZ9jISnL5BMBan+xSiiSO4kNvT6Qn0/94mb5e6tcXNAazEGjK7UqIAOwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pbuQQl22wNBU+mFzmLG/SDd2DPdZDySS1BuB9hjmWA=;
 b=z5WWk1m9HvwpT1M4XgJsglIGVKp9K+FudKDJhlnUoC8cnH8FOvYSuhx5+Ug8KYYp1iYizLJf1/wwdRVttMmj6rb2VPQN+sfMnw9iqPrjYkC3hLjfUZ5oU10TrbMrn/JtwZ0WnGj2MSh0wLHK7C6fX86GGCJbCpyho71Svbnc5Hw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN9PR12MB5100.namprd12.prod.outlook.com (2603:10b6:408:119::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 18:16:00 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 18:15:59 +0000
Message-ID: <9d9f1afe-c981-4df9-f012-89c4cb783cc3@amd.com>
Date:   Tue, 15 Nov 2022 12:15:52 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
To:     Vlastimil Babka <vbabka@suse.cz>, Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic> <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
 <7882353e-2b13-d35a-b462-cef35ee56f51@suse.cz>
 <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
In-Reply-To: <5b27a05e-09ad-9139-67b1-77b90731419f@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BN9PR12MB5100:EE_
X-MS-Office365-Filtering-Correlation-Id: 32913797-0ac7-4ee7-ab18-08dac735729d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56AxmeIVxkwVhVJRSem9KC/AYZbSgDutRORug87Np55fGh8z77E7tcs/zROXmkL2TQxZVNJpFtGtwLCTqz55f+xnW9feNAONSngkdD6zJPxy5cLhL+47PYatUzfU5wFhqc/HuPTts6ZoYScFDuu/fJXxj4NZH/SMtVa009U48UCedGZ05+LGjClvI9A2/5LZpbUJnU8+0DlvEVczlGakbkcvCK0vGLXhxAQjTVguWg2AWGtUuLt/EuSJf+Ma0ibcm7NdKB+77Wcat+SPM0oZdiWKiRJiHZ4nf/5tIZkXdf7UYZ+BGuhQLdz1KIOIH9kWZ2RldvPzeIq4F7WxWhCjZmMFRsbM0ACTkerUwBMa6HkIlJSqGuj5lNCPDyvk0vCzufBp2KECEQ8VVhlAQGJ2rul4ojYpYBOkDvDOXVqiKDEzoNYWumch/MZ4XeKsqzUlMx+iqouW3M4Ys1WT/jvpeyhHlJMKhER3XxZQb4xj9Ll2pP6Bc5qzEWlor3cZ9r0MPWiIieMModVpTvi7gNjHXxi6xTpN3LgFW0iBJLo3hlTNWq9rSf8P2epigcAvk2DS4I2lze+iU/nwvH8z4x80QYjE4U0De1ZJK8CYhZVksP+jR6EswiDeht1HHPNlxOjR3HxVmpU0h1MeOgW589Ed0GiT1YJaok2IaRdGmcaMUKV/9ZoN0jILdxlhd9CHl2eOUU462t3ApcqdMLsO3qzn88Jubf7cpzCGGQ1q0NPw+JQ7/O30WFtyD6cDLLH8qJnTIfn3axrGBgcSWs1MehY3w3yMHnqT4JhDXQRyTe7pbZjiAjQtPxuZKvKj5vZ5F6Y9Cj9Nb5cMOI4um7nMlyJ9dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199015)(54906003)(36756003)(31686004)(86362001)(31696002)(83380400001)(6506007)(5660300002)(7406005)(2906002)(7416002)(2616005)(186003)(53546011)(26005)(6512007)(38100700002)(66946007)(66556008)(6486002)(110136005)(966005)(6666004)(45080400002)(66476007)(4326008)(8936002)(316002)(8676002)(478600001)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXdoTXBaYit2ZWNmd2xrbG8xQzdxcllaSDF6dlRIZ05jTVpVODhMTXRJZHY0?=
 =?utf-8?B?cjhQMk9mTmViSmVZYzg0ZVp0eG45cGl5WmxRWFIySkNXS1FLb2pVcyt5TWh6?=
 =?utf-8?B?ZGNwR3o2ZDBrTnV6RzcyVW1FTUtkaXV0RXU5UHZydnBITUhXWGlSQ2E3a0ZX?=
 =?utf-8?B?SzZpaGNrRTI0VFMwWTFoQnp4Rm9xSHZJY3l0MWZNM2N2a3AvbEpxRHRIMjBM?=
 =?utf-8?B?amNiVnNYaW9xejZuSnVhWWdwcnA5eldIcmZTOU1wR3BZNjcrZVkrSmJ2ck04?=
 =?utf-8?B?SlVvNXdtdzdZT0pacmdRak9md2ZaMnFuOWNPenMvTENXeloyZ2tzV2lBdVJ0?=
 =?utf-8?B?T1dpbmQxb3ZmZUlSdXJMbEt6Vnlkang2VzE1MmpGOFJ6bUNNeDZBU0hTZi9N?=
 =?utf-8?B?WnA2cXpmek50WUIyMmFscVRKeGdnY05ETHovSlFDSTRud0tMSWxkQUxNbjhv?=
 =?utf-8?B?QUIzUzM1Z3kwK3FzODFTZTlMaHZoc25zWjdhRUVFWE1OdVYyQ3RsdVB1dzNI?=
 =?utf-8?B?UmRDYnBaT2xDQmRFblRpN1hLQ1ZOMWhSaVVaR21NbGJ4M0pSdk1ha2JsejZG?=
 =?utf-8?B?bzFUTGRvR2NLR1FYemN6MVp4UGNXYUdoWlZlM2RaL3U4NldRZ1EyNWYrM3lO?=
 =?utf-8?B?WG1QRkM4ZXRVb1AxY1pLTDJ3YmVEWHZCZm1tRE95L2d2eWlRMHkvZmFIcjZw?=
 =?utf-8?B?RzVvUW1HZEZVdmVlbDQrNk1hNkRNdWRQdmFYWmRNd25FblBxeFlnbmM1MGk5?=
 =?utf-8?B?aUo2YXB4dDFMdXUxVFcvZXZOQklubVpEZXovQ084dlo1QTNVR2pBc3plcEo0?=
 =?utf-8?B?bXZxWUtHNUtyM1laejdMY0JBOTZIWi8rU2NGS2N6SDRhRi9EMVNkWkZDY3Nw?=
 =?utf-8?B?dXUxOFhnRnBmamxxbDFheFhPSE9Gbnhvc1NvZm5XdnZYYkRLVFphOG9Qd0Uw?=
 =?utf-8?B?M0VIMkhMRmxMbG5RZlhWK3ljRlY5VTdxRUNzUDRPSUJ6anBmclJma3l2YjV6?=
 =?utf-8?B?c1BEeWJHb1RvbWRZNllaaC9Tem15a1ZnUmwwVkJ0WU4xZm0xLzgxZjROeGhm?=
 =?utf-8?B?SktuM3BuTC9RUlI3SFRRY2pzWDYyNWUza2t5T2xxQmVLaFpBM3hJKzRmaVJl?=
 =?utf-8?B?WHNpQXdoUW8vL3Q1YmVKQ2RRMko4emY3c2xCeFVPQ3lqQ3J6OVA4c2cvR2ZC?=
 =?utf-8?B?OXF1elFlQ3hUbTBEODhNYmxNUnc1Rk9ucWkzRms3MzBUdk1vcDl3dkpiWkJU?=
 =?utf-8?B?L3dRcEp4RWpnRGQ0UW9QQzBwMTRTZyt2N09PbWNoS0pOMzlpcDJlcGJmTERP?=
 =?utf-8?B?allOOGp6NlZRdThycEZJRE52SEIzTHRielBQeUxGaDBCV1lwcEc4VkZnb1VO?=
 =?utf-8?B?VkJtenpiK2dKT0FraXd0MjJjSWI4blgyZUc4a0lPMkV3V01RZFBvdWFTVU5O?=
 =?utf-8?B?NmFObXZMbUNrT1Z0WkY2RUlaU0FnMjROZmxuYjFRUXQ4QjgyNFhhOHhsZGVx?=
 =?utf-8?B?OEhHbHliL1NsNUlSNG84S3l5KzB6TWYzeWpPR2Y1MU5mWVZva0c3bHRKVS9y?=
 =?utf-8?B?SDVnNjFGMkVuWVhtQU0yM2NweXNzQjFMUEdZNUhralF5S3FuTVhRUnJKd0Ru?=
 =?utf-8?B?emVLWGxVQmxTU1FuZW9nWVV0NTJGR2E5a3dpbnVRaW9wUDZhYk5TaW45ZTZX?=
 =?utf-8?B?MVcxM0NOcmsxOHhaeEpVcUthNWJNcFVwTDlnM0xLa2NWREh4eXlzQTlURWlo?=
 =?utf-8?B?VVVYNlVHUlhGbzQxWk5KWDB3anQwV3hHMytOTVNUY1VKcHdkUWNHWmlheWdI?=
 =?utf-8?B?QTRPbEthSVdRRU9iL2lna3dIaFJpakVSWGFxLzgrb2o5eVNka1FyYjJrNlZ4?=
 =?utf-8?B?K0FxQzdjZlpBbnVObWw5dUhYSDcvSjJoUk0wN0M2dzMxUmdGbDlJVTJnSzZ4?=
 =?utf-8?B?WGt6MnljV09Jbmg3UXZCL2VyNDc4bld4bUp0Tjd4am51SHpBMXFOUzdLc3lK?=
 =?utf-8?B?VkdXbk9odENaZTRmclNGTzlFRHd3dkxCWFRvZHhyaW9obVF3UmRhZVBTaEEy?=
 =?utf-8?B?QjRSVTRGZnk4SmRycWVob21kS080YVRxTkFxVU5YR1Z5cFN0b055SjNVbXJM?=
 =?utf-8?Q?3Clr6Xqw+2JQAxtE1RoZFrYCo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32913797-0ac7-4ee7-ab18-08dac735729d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 18:15:59.8194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MV+gUo+e6+udhR4I0fOthNnVPYPloFO8bBj/tegQO5yS7Fvc4QAzox73e5FSfKFLqcSV4yaCLtdhvYW3Zu/e/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/15/2022 11:24 AM, Kalra, Ashish wrote:
> Hello Vlastimil,
> 
> On 11/15/2022 9:14 AM, Vlastimil Babka wrote:
>> Cc'ing memory failure folks, the beinning of this subthread is here:
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra%40amd.com%2F&amp;data=05%7C01%7Cashish.kalra%40amd.com%7C944b59f239c541a52ac808dac71c2089%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638041220947600149%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=do9zzyMlAErkKx5rguqnL2GoG4lhsWHDI74zgwLWaZU%3D&amp;reserved=0 
>>
>>
>> On 11/15/22 00:36, Kalra, Ashish wrote:
>>> Hello Boris,
>>>
>>> On 11/2/2022 6:22 AM, Borislav Petkov wrote:
>>>> On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>>>>>        if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>>>>>               do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>>>>>               return RMP_PF_RETRY;
>>>>
>>>> Does this issue some halfway understandable error message why the
>>>> process got killed?
>>>>
>>>>> Will look at adding our own recovery function for the same, but 
>>>>> that will
>>>>> again mark the pages as poisoned, right ?
>>>>
>>>> Well, not poisoned but PG_offlimits or whatever the mm folks agree 
>>>> upon.
>>>> Semantically, it'll be handled the same way, ofc.
>>>
>>> Added a new PG_offlimits flag and a simple corresponding handler for it.
>>
>> One thing is, there's not enough page flags to be adding more (except
>> aliases for existing) for cases that can avoid it, but as Boris says, if
>> using alias to PG_hwpoison it depends what will become confused with the
>> actual hwpoison.
>>
>>> But there is still added complexity of handling hugepages as part of
>>> reclamation failures (both HugeTLB and transparent hugepages) and that
>>> means calling more static functions in mm/memory_failure.c
>>>
>>> There is probably a more appropriate handler in mm/memory-failure.c:
>>>
>>> soft_offline_page() - this will mark the page as HWPoisoned and also has
>>> handling for hugepages. And we can avoid adding a new page flag too.
>>>
>>> soft_offline_page - Soft offline a page.
>>> Soft offline a page, by migration or invalidation, without killing 
>>> anything.
>>>
>>> So, this looks like a good option to call
>>> soft_offline_page() instead of memory_failure() in case of
>>> failure to transition the page back to HV/shared state via 
>>> SNP_RECLAIM_CMD
>>> and/or RMPUPDATE instruction.
>>
>> So it's a bit unclear to me what exact situation we are handling here. 
>> The
>> original patch here seems to me to be just leaking back pages that are
>> unsafe for further use. soft_offline_page() seems to fit that scenario 
>> of a
>> graceful leak before something is irrepairably corrupt and we page 
>> fault on it.
>> But then in the thread you discus PF handling and killing. So what is the
>> case here? If we detect this need to call snp_leak_pages() does it mean:
>>
>> a) nobody that could page fault at them (the guest?) is running 
>> anymore, we
>> are tearing it down, we just can't reuse the pages further on the host
> 
> The host can page fault on them, if anything on the host tries to write 
> to these pages. Host reads will return garbage data.
> 
>> - seem like soft_offline_page() could work, but maybe we could just 
>> put the
>> pages on some leaked lists without special page? The only thing that 
>> should
>> matter is not to free the pages to the page allocator so they would be
>> reused by something else.
>>
>> b) something can stil page fault at them (what?) - AFAIU can't be 
>> resolved
>> without killing something, memory_failure() might limit the damage
> 
> As i mentioned above, host writes will cause RMP violation page fault.
>

And to add here, if its a guest private page, then the above fault 
cannot be resolved, so the faulting process is terminated.

Thanks,
Ashish

> 
>>>
>>>>
>>>>> Still waiting for some/more feedback from mm folks on the same.
>>>>
>>>> Just send the patch and they'll give it.
>>>>
>>>> Thx.
>>>>
>>

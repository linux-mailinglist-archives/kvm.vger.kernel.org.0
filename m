Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575F865F6BF
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbjAEW1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbjAEW1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:27:22 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396F9CE18;
        Thu,  5 Jan 2023 14:27:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8NWHAzGhqKGY+1t/2mK26JvW6V6/ug/Y84vkJL+ByrzWDYnQi5OuqoqwBVzgZqyn9DFfMGPFCgynlADwxOkIv3ubHV62ofIoqrUhRDFkfj8+YHOwd2zJ4lmMYz3jMqdoaioL7lcbzx73AygP30AGBirgB++iYinMuIRjebv56zyPUilGukFkJ7PX7t8Q1dez+ZmjwaVSfPMdheA22Fw0LTTs5rWKdoJ+F6c2zdH/RXNzfPwAZHQ+lUiCKtN331fxOJGfAPrg/TN0TmNwH4SkfFkKmQqi+Qc3Cwv2VBhNa84OOMzFFuLBiDgud8zgvu3mkvk8DncniD90qoiKO2Owg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kov5YgNpUqHfiT9HU4ge1riP6du8KGTw4CBNGDpL1VM=;
 b=YPicrlmh8ewL+Jis06tTkeUvqURHgY5eYvvzSGpwyltW3UZREXmLc46znviUc5O0awVcaQBLvfVRQHIcPuarQ97ZiVeSms7axwTd1EuGJYnZRUPNd6LrztuPsJJBLF+y5abLSzk1tmrMOORwQFzFuPLWPxkI8NW8uUUiCvStm4JWSDcO4GWXfkgLMUc/d6vu+DlOezikzvlM2nVl7b6WIQRj/eZFPc6fOVuNl3ayeiahqtnHfBvOBAbbLBj9kT7aP0mux4KcSwaOolldh7UoHEyB66juQaFakX/zv4SGVN6pLTx+i7NiyU5JJaa8ocWsgF9LF71G5cpFV7vDRhA2zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kov5YgNpUqHfiT9HU4ge1riP6du8KGTw4CBNGDpL1VM=;
 b=TJzaFYyYtEVBNdYqKoQh5ypApRW85JVboXWwCowf1joW21+Sc45uaUr9ZkQEOiJGCufXjQUG6NTSjvEDnsIffr+QI2C29jyxlwknW+/IEtLMJEkp5lIU8SBIBX0xxLr9x6w5NHuhOY8BSOsbNQFZKJNF96RRwqHwiBcwaFBN0SA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB6207.namprd12.prod.outlook.com (2603:10b6:8:a6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 22:27:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 22:27:07 +0000
Message-ID: <993e0896-cda6-5033-ad0e-e21508a58077@amd.com>
Date:   Thu, 5 Jan 2023 16:27:01 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic> <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic> <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
 <CAA03e5GKCcevo7goyyRqWrgk3KeFPTddb-E2pRmgDmyPSNxDvA@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAA03e5GKCcevo7goyyRqWrgk3KeFPTddb-E2pRmgDmyPSNxDvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0006.namprd14.prod.outlook.com
 (2603:10b6:610:60::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: cb2cbdd7-5837-48e9-534b-08daef6bfad4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/Gh9YK78dd9WheAGJnJuTyx93A3Wn1Y07PY28C0xhAjzdUi6gMJRV5b0IVnXpL/M2EvrQhwxR+soiN+/P0N0OuP4nxb74KjpCxJ3EMAE2656mJthX6fFyviSRxD2wcyQaw7oD9xsSYO4V6xSkXPMWrQv25bZZ6CXi0d4+ZVGjzVZtuQGlk9+dUHa97WNqjkO28EurC3LTEGLbY28ENBboe9FKKmaEyZwGuOUuA9xQzJZvJxWamecwnr0CMEu3ojeYCWB54v1MfdyfDQs4w0KaNwAnocoYpCd1Zw/L9rQAip8AOmBV+4UiLlkG+DQSZNmchPO/LSr/AckmB6mJbIvXxa6INYq4bpjVnA7j1hErvgHyqM5vxx5TUxFJE0ZQpoUaEk64eETQrsSKGt+I+9xtjqPZxj2lB8EExen7JTPe/ofEKyzpIu1xugWCOWYpuYq2r5/0ncCfxBDb2g9c8E4hTqOHJa4A7Ova1x9vDZMRtqtb4fRvBAOFCtkN/Zm90xU2/m82g0C6D1MTy1oVy5It6c3iZOzHhuVa2iXHidOuejZShn3myyyWUtaxELLpQPgW/KT/MGQ5YjGVTSuyYeuSj1iZAx5zUuLPAelgupR/T6NrUSiJcfMYrVhV0fM81KmLFbYFypQyAKg8rnH/Nmo5C4Y5m4sExE/YNsJ0aRNuQwy0HncXKSUkaIFPCyhcv6sLH5X7ene2pGiMSqJvERujA93FrPfZ11q8IBAgjsMUc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199015)(2616005)(83380400001)(2906002)(86362001)(31696002)(36756003)(38100700002)(316002)(54906003)(6916009)(66899015)(7406005)(7416002)(66946007)(8676002)(66556008)(41300700001)(5660300002)(66476007)(4326008)(31686004)(6486002)(8936002)(26005)(186003)(6512007)(53546011)(478600001)(6666004)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zml6WHZKQ2R1dmJlbnRlNEFjTjFST1BwNjY5QWxGalBVZ1BZblFBaDA5ZVdV?=
 =?utf-8?B?SlVaWXRhTWNsL2tsRXQ5VE5CZmpqcWp4VDdyamRIZ2VJeCtmb2NqMUVUTFpi?=
 =?utf-8?B?d3BGdFNlVHQyemxhL3V2aTBsUzNQd1hBRFNSWG5TVStUalJIdU5NeENwNEx5?=
 =?utf-8?B?WGFjc2lseDIydVlCaDE2ZkYrU2tEUXdFdWJyV0plMTl1N1hjd1pNU3dJY081?=
 =?utf-8?B?WjNjcXFiQ2xxbWJZZW9NcS90eTRoTU10VmU5MXU3RWJnbjQzc2cyNlVXK2tM?=
 =?utf-8?B?bDU5WWFQUUFqK01YeTI0YXBzQlNSaUxLblQ0dDRvV3dCdmtJaStrMGJsdFcr?=
 =?utf-8?B?MjgybGt3MG9TZkpGMW1EckNYSmhNUnYyOG5yY0JhdmtxSWxGaTdLRkkzUmIz?=
 =?utf-8?B?ZWIzWDgrOWVtbnlPOUQvbmx1ZS9kNEVTNnorN3JTSDFhSnFPa3V5TlpVOUxr?=
 =?utf-8?B?RFBkRVdKQTlGcGNhMW45ODVZOHZXeERENVA3Y2FkcVhzRUJjTFBWaWFpazI5?=
 =?utf-8?B?OXVqRjBWNHdJNW9qQWNHcXZOWkhNYW1qbVN6M3NDdkgremI4M2R3TjVsNEJp?=
 =?utf-8?B?b3NYSWtaY1JYcVJBK0ppMGs2U3ZiTStoQnh6LytPNFBob2ZQd0NsVHhyM1hK?=
 =?utf-8?B?WGVTVGVndmlyTE9NTVora0JseTlmdVppMHJ0VTc0TjNPanc0aGZuVjZCM09T?=
 =?utf-8?B?WTk1SXR1a0FjZy9kaWkvTUpySHIybUxtNGVhUXFXNFRSdXR6R08rSzhiaHVD?=
 =?utf-8?B?cW13RzRaVVRCV2txRGQxQVVzVHdjallWWWlkdHJ1OTdQTVZwLzllOHFGSHRm?=
 =?utf-8?B?b0tIaGp0KzJvMWY0d1MzWGtWSnc3dW8xTGZScmhLVWRlQUkrU0Y4eVhnTDg3?=
 =?utf-8?B?WTJwV0JJOVNQUm5oTlRDTy9oZ3RuKzRsby9odDRmNVlyNUxWZFpHNjNuUUQw?=
 =?utf-8?B?NjJFdGxxbEQ1Z242V05ETmMweFV1eG80RHFHamorQis1YytoQ2RvMVE5WnY2?=
 =?utf-8?B?NnpFcmpsSWlvSHFzOTNtS01oVDlnS0tkbzdUZmd2OXBESkpiZjh1NHNaNXc0?=
 =?utf-8?B?YWpGbTc4dlpyZVNEZW02QS9EenBHdXhTTkVxemhFYnlYSE1hYVRTakdVREN5?=
 =?utf-8?B?OWhPTUlqMkxTYkpRTTZyZzk1cStIVkdUMGxRV0wyb1pLRjRlVTVXek16Ujh0?=
 =?utf-8?B?YUpnSm9MQWlPUGljOHlzb0ZWSFB2TGRwYkxaR2pobG5ZVGZJZUtEZVFvTGxR?=
 =?utf-8?B?dXlvVStBR2FKWm9SUFBMaU01UmowYm1DVUhmQVlHV3hmMXMyMlBaY2cxbXcw?=
 =?utf-8?B?V254L0p2V01FTnlRUytMYk9VUkhjK0RDeFhzRFQ4SDJEYWZ1aEJTWVpzWmw5?=
 =?utf-8?B?Tm5OTWswOVI5bmxnUy9hVHlIajBSbVAyMmVaTWlTR1hncWE4NXB6c1lyMVVR?=
 =?utf-8?B?eEZCd3dWTU9HYmh3U3VRRStBS0hRZXc0UXlaMkNWcG1qSXVpZTIraFF6ZVZ6?=
 =?utf-8?B?dW1ZdTE5bkdKM0l1RVhjRkpYT3ZrdGUxOXJUaWVwV2k4L0hCSWFGSlJZOHBs?=
 =?utf-8?B?ZTF3NTVoYTU4OFhoL0xFd0xud2hsU3V5UmhSMkprOUJwZStkaWYyc2Y3QWgv?=
 =?utf-8?B?QUMvTWlHdGhYdmhDQmp3ZGJQZ1lDVUtDZ2RDSTBaVUlrekJ5cHRzTW5xekRM?=
 =?utf-8?B?VHkxdXFKZmtsbzViN2M3NmIzM21jaE11b1BwbHFtcWpGaUhlR2U5QWk0Y2Y0?=
 =?utf-8?B?MzhqbzhBMUR2TGthZCtHc1J5VEUwL1RnYUVGRzIxb1JueXQ0TWZtOHpiRzds?=
 =?utf-8?B?U0xZN2xaRDhWeE1IcktBeFhkQ2NiV29YS3BjUWRJWDJGa0djODRRZmkyNXEx?=
 =?utf-8?B?MnozR2xFTjZHOS9YNWpnOXpCc0R4ZXlQUmkwZ0pjakUrUitPYWtNVDJ2Z1JY?=
 =?utf-8?B?UXVtMHhlNzd3bDUvcm95UWtXMjBBOGkzZG5zaFpUNi9rd2s2MnJtcnRvMGZK?=
 =?utf-8?B?S1plbTlYUGEzRkxicVhicVJPM3BONmN0RGFjem5HN1JoMTBDUDIvWEFsdlpi?=
 =?utf-8?B?OG54NUYrNHo0MlA4dmpsWWJoZVlOYlpwWWNRTkxJYXRDbXJYYTBRVmVjMnlG?=
 =?utf-8?Q?9ipDnSHo1vXjGrDIyPnTxKROM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb2cbdd7-5837-48e9-534b-08daef6bfad4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 22:27:07.7291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 271jxbbUzOgBXCnMzW6Du1bOFZlLbxKxltAvutzs9aZF72VqzIPc3IMlgQKTAyr26wGS+cicBz7g3m7UcQibyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6207
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Marc,

On 1/5/2023 4:08 PM, Marc Orr wrote:
> On Tue, Dec 27, 2022 at 1:49 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>>
>> Hello Boris,
>>
>> On 12/19/2022 2:08 PM, Borislav Petkov wrote:
>>> On Mon, Dec 19, 2022 at 09:00:26AM -0600, Michael Roth wrote:
>>>> We implemented this approach for v7, but it causes a fairly significant
>>>> performance regression, particularly for the case for npages > 1 which
>>>> this change was meant to optimize.
>>>>
>>>> I still need to dig in a big but I'm guessing it's related to flushing
>>>> behavior.
>>>
>>> Well, AFAICT, change_page_attr_set_clr() flushes once at the end.
>>>
>>> Don't you need to flush when you modify the direct map?
>>>
>>
>> Milan onward, there is H/W support for coherency between mappings of the
>> same physical page with different encryption keys, so AFAIK, there
>> should be no need to flush during page state transitions, where we
>> invoke these direct map interface functions for re-mapping/invalidating
>> pages.
>>
>> I don't know if there is any other reason to flush after modifying
>> the direct map ?
> 
> Isn't the Milan coherence feature (SME_COHERENT?) about the caches --
> not the TLBs? And isn't the flushing being discussed here about the
> TLBs?

Actually, the flush does both cache and TLB flushing.

Both cpa_flush() and cpa_flush_all() will also do cache flushing if 
cache argument is not NULL. As in this case, no page caching attributes 
are being changed so there is no need to do cache flushing.

But TLB flushing (as PTE is updated) is still required and will be done.

> 
> Also, I thought that Mingwei Zhang <mizhang@google.com> found that the
> Milan SEV coherence feature was basically unusable in Linux because it
> only works across CPUs. It does not extend to IO (e.g., CPU caches
> need to be flushed prior to free'ing a SEV VM's private address and
> reallocating that location to a device driver to be used for IO). My
> understanding of this feature and its limitations may be too coarse.
> But I think we should be very careful about relying on this feature as
> it is implemented in Milan.
> 
> That being said, I guess I could see an argument to rely on the
> feature here, since we're not deallocating the memory and reallocating
> it to a device. But again, I thought the feature was about cache
> coherence -- not TLB coherence.

Yes, this is just invalidating or re-mapping into the kernel direct map, 
so we can rely on this feature for the use case here.

Thanks,
Ashish

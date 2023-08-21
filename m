Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B83C7834F8
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjHUVoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 17:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjHUVoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 17:44:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6DA13D;
        Mon, 21 Aug 2023 14:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atQpNDpRvyxuSS6ZkrpZcacPXHqPxUpX+8uxPaIoqLtIe7s0/VqlIr+qNlj7qu5RNxkIy2r9bUII/bqM48uCyAxNY9cv2+3y47WXh10bsy7ZtRUZwbeBq6jz/PSvcHe7o52Sdd9mlnepcYKLlPUhQwuxe1KwMplow/tSxKoKnanE6Sn1FZExxDNPyRICebIF1P5nXz5eXN8KBopJWpu0dlO0vi6zx0jWCO6DbDUTMOfMJK418/Y1jQ5+g6YyF+UBsRDa7XcGFmxa0NTOUIb4IqB184pFHsxJMhubsUv7jREnIhVJ6KXNPUOD/hsOaDCF7Uk/03eiUuwSm+QBJLO/0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=613CMAj7Lt/zjJaAE+Mr0xZ/QD7w9yfz3FwBX5j2/ZQ=;
 b=Jn4oQ1W2FBdgxwwHY47Jbhgg9Bjk2qZZOGNN7BpJ63r967gcRO1uQ/V5s5vgOWG1OJY+DWkZzn5vl4sKIa8Lu4gEUebEbbJwqinRbx8evelFGT4sAFd6xGujc2XMDsNVfnEvOCi4/WVWAHuJ0tyR6YNLUuDR4/OQ+HJjUbopyhspTO9a21lJDtmnBpTnT2WF6qAZv3qeKX0Ghhaxy6LtWNjwrFHH8epVxKTXug8gomAy5emRlZEuT33VzrGnDYvaUrXLRhtWeXVnZ6JZnWYOw2Bd71jGeIAnPoheAXSr9hhQMV09KvHtQnN596EoMS54Z+1Dg8r8cEkNX4cykZagUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=613CMAj7Lt/zjJaAE+Mr0xZ/QD7w9yfz3FwBX5j2/ZQ=;
 b=atjwjAe5KDQEcNqsiQwnMCCJUyOERscp+iQgAAuJOcsGQUBjm1sOd7zH7J3ZxVY/E20yG4cZzCWG8Lv9iXpw2/A8PNZ/cV/hhFrw6Y8w9MijT/T6M7jqHvzpOfz8u2y86cB9DXPHaQpSMduafNHOeg2T9LWjq0m3YS6ULyuNAI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN2PR12MB4046.namprd12.prod.outlook.com (2603:10b6:208:1da::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 21:44:41 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b%3]) with mapi id 15.20.6699.020; Mon, 21 Aug 2023
 21:44:41 +0000
Message-ID: <df49bbb2-92c0-7792-ab90-e748be570b5d@amd.com>
Date:   Mon, 21 Aug 2023 16:44:37 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jacky Li <jackyli@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
 <ZN+whX3/lSBcZKUj@google.com> <52c6a8a6-3a0a-83ba-173d-0833e16b64fd@amd.com>
 <ZN/0aefp2gw5wDXk@google.com>
 <CAL715WL9TJzDxZE8_gfhUQFGtOAydG0kyuSbzkqWTs3pc57j7A@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAL715WL9TJzDxZE8_gfhUQFGtOAydG0kyuSbzkqWTs3pc57j7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0117.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::32) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|MN2PR12MB4046:EE_
X-MS-Office365-Filtering-Correlation-Id: 412b00df-7563-4d0d-35b8-08dba28fd369
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+GDlmIR+zqrcIgQq/LeGmGX3Cgo22inUj9unTniBQSY2QGJCz4LAewuO650nHxVM5/3lr/yzbu7ZAuSVCPJnCUa5imZUJDxY+TYjIxSUwQ5GzhD2ue8XToPiv/5HYLLuUfFgMr+rUiPu9K1sYPqE7auNAYk0+TF2SXO293Ar24iaIlcyH0+SuSorTR2nnshkQZwDmja3qssMSZXclxI5HIJn5bOZ7pi/TSeDKh3J120OOhOk6ogPKAPSubBbwT0YlkcNOWm6PvqRf0U3/lFDbCCckJmmdy8QAGCIt67AnwCp/x3+3rsLgWq5OGWBjADyF0nKoDbkjgHbeQoo3xMhkxrODifHPXqtNduoUGnqZk+v8SI1VkJxqAILbQR5YVXy3Ib4n55nvbHUbuS6H19p+PoVUfE/X2jCPvMH5GcEEq7u+ruTnuz3ufRO5hTXwPpHbSznVLEp0mN/awr/emsWzwE5sXgA9ma9QgleoO48vTSRe35pCC0b75ty++zdd2BlIJDqrKwr33dil2vO7wuUwOCEwrJyG16VEXhqhwcXTHZNUMzzm6iU8fb1TxPH+0rJs1a/1jgmlcc/xV0t2lBrWS4rNZbJgh+IqH6Ha48+KsF+cK02C6fdxblTOmrzSIYFWH5RUlX9XFAMBpQkXYpNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199024)(1800799009)(186009)(2906002)(83380400001)(7416002)(53546011)(6486002)(38100700002)(6506007)(5660300002)(26005)(31686004)(86362001)(31696002)(8676002)(8936002)(2616005)(4326008)(66946007)(316002)(6512007)(54906003)(66556008)(66476007)(110136005)(478600001)(6666004)(41300700001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UE9Dd1lkL01aNTBUZmJ0VHFIQlZRemNFV2Z5d1JLVjdSdDZ1YUV1dm8yZ3FX?=
 =?utf-8?B?R1JGN1JkcHFyZmszM3VpK2FoUUl3QWhPUnFiVVJTM0lnSlZIbmF0czhRcTZl?=
 =?utf-8?B?Yk5PQmlxNnBxQ2Fyd242c2ZtV05qTSt6YXRCKy9zK1czTStLZHFleHRaK2xm?=
 =?utf-8?B?eDh0Z3QwVzNvRmJEVVF4aGJ5dUlvTm1ObW9TL08vNmtpVVM3WnBQbWFlaHU5?=
 =?utf-8?B?cjdhWEhxeElqUUJlbFNCTUN4Yk95ZWZqN1hJeEM0QXRsRkhSMWpPUDFPSVB1?=
 =?utf-8?B?UVVxbjJsZzg3MzNsWFQ1dDZOUVFvNDhubHBBMXM1bUFRTmdTSDFPSWM1WVJB?=
 =?utf-8?B?TjFVQzZkR3J3d2ZxUnU2ZlFJK1laeWxVc2tGMHJKc21TZXRJMEs3RkIvRU5F?=
 =?utf-8?B?WkZvdWdzYzdMUDhBSEl3TWVYV2JuQThJczZ1SE9md0tBTWVXSWdIcEFhcXJT?=
 =?utf-8?B?Z09YLzA4d1QzMnRKVUxhdVM0TU53OEZpZTFsT095SzdmNTdMOGxRYkxNS0VY?=
 =?utf-8?B?aEtHeHpQMGhXNEEwdmwwOW1ZVXJyMEhocS9uRkRhNnRXL1EzUTZ6Mm9kWVZt?=
 =?utf-8?B?bzdYUWlCdDZUMTlsMlA1OUphTWlFS3FGMkQ2elZYanZJYUY1RVJUaE0rc2o2?=
 =?utf-8?B?SmZzcWRhTWxqZU00UGVxbHJBNXcwdTJnbnVWWVRmeTlYRFlJTVpFTktBcVBP?=
 =?utf-8?B?MkpETEI4dnRkTmw5WjJ5T0UyL0NleS9aKzNDclNLVjdPU1JKUzhwYUkydGEv?=
 =?utf-8?B?Z2toSW1FbXlLYmtCZUNxTmJqQzFFbll6bXYxRlZ4VGc3YS9pZS9rTzdlSmtU?=
 =?utf-8?B?TXA1WTVIUlA3K3htNmZNWVc2QUV2OVY3a01FZ2FFZ3Y1YTZ5bm1XazB2UlVG?=
 =?utf-8?B?ZUxWc20rMXFnYzQ3ZWt1NWtBYmkvNFptbDcrd0o2Z2J6eU1tdjBDMjhMYjZx?=
 =?utf-8?B?K1FwY3ROVTk3OU9zd21WWnJyRFVadU1TdUQvdnMxNVlwNXJPaHhRcTZra1pE?=
 =?utf-8?B?K2tOSlNjSC9tdjN3aW9wakRmaEtrcFZWMVl2V1cwSDNkREFVVVJ4dGlIUTZN?=
 =?utf-8?B?bk1STXY4alBnbzlna01yaytzU0RVWC9Oekk3NUpxaCtXNktKOEY3NXcwdjlV?=
 =?utf-8?B?NUNaNVdQL2VKOVFrMXZHM0xaZ3EyTzh4eEFXY3daWlMxaFg0ejM0ZzR3WmJ1?=
 =?utf-8?B?NW9LRHlNWVhGaTRjODVhSUhoM3JISVdxOHpvdGpTRnJFNHpxN216d0xteWNX?=
 =?utf-8?B?TStHRVVxSHBROERLSTRPZEROcCtNN0MzZk9lSmpYcmFCTkVtZ1ZMZnpNVDhI?=
 =?utf-8?B?YzFwWi8reXpjOGs3bTdBdFpmN1UvclZiZE0zbzcwRWhzTlNMUC9IakNpSWdt?=
 =?utf-8?B?ZzRib2orUXJLa3FZWHU1ZmkwQWRlWFF6V2liUzVGNEQzb2VtMWliR1U2OS9u?=
 =?utf-8?B?M1FZNWZJRHE0OWNqNi9MNnpJWFREdmFnbDYwWE5FVHZvSThGTmhaanZpeWVS?=
 =?utf-8?B?Y3ZRRVh3NEUwRmdwSGpzSEJ0WnkxR205SFYzdkQvbUZkWEhXT1hMbDhKa2t4?=
 =?utf-8?B?ekdvYnB4eFdUdjAzNHI1K29NQzJtQWlJYW13cElrUUhDanFWWWtkWXFlRTRx?=
 =?utf-8?B?VU96V004czZua2JneEFGdC95Y3h6WDlKQ1pudDlGWEFLV3lxeEc5TGRNWEJP?=
 =?utf-8?B?Y0RyMFRxZXEzVlkybUlwUS9mRFUrMEIwM0VsSGdWdlVKQzR5SE5VMDVnSGdk?=
 =?utf-8?B?ZytFWVpYOE9KY1BiWGlwZHNjSU1Nd1JzSElXQWx4d2lPaWc2dGp6blBrOE1y?=
 =?utf-8?B?dlBMZEQvbXpLVzJzenBNNkZyQ1FYV3Q3dEJKb2J1KzcrTnZ3dmRKM1kvS2Yy?=
 =?utf-8?B?R2JoTjhsZlhSeTFiRG53U2o4YmVlL0trbjhET2UzN1FrWVlhd3N6TEpxSTNt?=
 =?utf-8?B?cG1tMTNOVTkweUpnUUZGZlk3dDBOVSs4OERGdHhySDBYcDRyTjFRK1ovY3BE?=
 =?utf-8?B?Nk13Qi9ibWVpSVpoN2VJUzIvdTh3bmNUTEI3WGhCelU5SG5KYXpjQ3B1MFBK?=
 =?utf-8?B?MWk1cVFBQnY4NElCYUEwV2FIL3oydmI4VWFLdHE5Mk1WY2JkUXpxcUNUdWNT?=
 =?utf-8?Q?u42l+1WHkEKpXXF09mZjmW+GU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412b00df-7563-4d0d-35b8-08dba28fd369
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 21:44:41.6518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6epRltLNEdj5Sabe8f0j8aHhMPIiStCNcut6kO2DKKZ5dhnfCfq7N8YzCsIbHg6IMmqaTBplIkVe3e7KqEesbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4046
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Mingwei & Sean,

On 8/18/2023 9:08 PM, Mingwei Zhang wrote:
> +Jacky Li
> 
> On Fri, Aug 18, 2023 at 3:45 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> +Mingwei to correct me if I'm wrong
>>
>> On Fri, Aug 18, 2023, Ashish Kalra wrote:
>>>
>>> On 8/18/2023 12:55 PM, Sean Christopherson wrote:
>>>> On Tue, Aug 15, 2023, isaku.yamahata@intel.com wrote:
>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>
>>>>> kvm_mmu_invalidate_end() updates struct kvm::mmu_invalidate_in_progress
>>>>> and it's protected by kvm::mmu_lock.  call kvm_mmu_invalidate_end() before
>>>>> unlocking it. Not after the unlock.
>>>>>
>>>>> Fixes: 8e9009ca6d14 ("KVM: Introduce per-page memory attributes")
>>>>
>>>> This fixes is wrong.  It won't matter in the long run, but it makes my life that
>>>> much harder.
>>>>
>>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>> ---
>>>>>    virt/kvm/kvm_main.c | 15 ++++++++++++++-
>>>>>    1 file changed, 14 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>>> index 8bfeb615fc4d..49380cd62367 100644
>>>>> --- a/virt/kvm/kvm_main.c
>>>>> +++ b/virt/kvm/kvm_main.c
>>>>> @@ -535,6 +535,7 @@ struct kvm_mmu_notifier_range {
>>>>>            } arg;
>>>>>            gfn_handler_t handler;
>>>>>            on_lock_fn_t on_lock;
>>>>> + on_unlock_fn_t before_unlock;
>>>>>            on_unlock_fn_t on_unlock;
>>>>
>>>> Ugh, shame on my past me.  Having on_lock and on_unlock be asymmetrical with respect
>>>> to the lock is nasty.
>>>>
>>>> I would much rather we either (a) be explicit, e.g. before_(un)lock and after_(un)lock,
>>>> or (b) have just on_(un)lock, make them symetrical, and handle the SEV mess a
>>>> different way.
>>>>
>>>> The SEV hook doesn't actually care about running immediately after unlock, it just
>>>> wants to know if there was an overlapping memslot.  It can run after SRCU is dropped,
>>>> because even if we make the behavior more precise (right now it blasts WBINVD),
>>>> just having a reference to memslots isn't sufficient, the code needs to guarantee
>>>> memslots are *stable*.  And that is already guaranteed by the notifier code, i.e.
>>>> the SEV code could just reacquire SRCU.
>>>
>>> On a separate note here, the SEV hook blasting WBINVD is still causing
>>> serious performance degradation issues with SNP triggered via
>>> AutoNUMA/numad/KSM, etc. With reference to previous discussions related to
>>> it, we have plans to replace WBINVD with CLFLUSHOPT.
>>
>> Isn't the flush unnecessary when freeing shared memory?  My recollection is that
>> the problematic scenario is when encrypted memory is freed back to the host,
>> because KVM already flushes when potentially encrypted mapping memory into the
>> guest.
>>
>> With SNP+guest_memfd, private/encrypted memory should be unreachabled via the
>> hva-based mmu_notifiers.  gmem should have full control of the page lifecycles,
>> i.e. can get the kernel virtual address as appropriated, and so it SNP shouldn't
>> need the nuclear option.
>>
>> E.g. something like this?
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 07756b7348ae..1c6828ae391d 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2328,7 +2328,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>>
>>   void sev_guest_memory_reclaimed(struct kvm *kvm)
>>   {
>> -       if (!sev_guest(kvm))
>> +       if (!sev_guest(kvm) || sev_snp_guest(kvm))
>>                  return;
>>
>>          wbinvd_on_all_cpus();
> 
> I hope this is the final solution :)
> 
> So, short answer: no.
> 
> SNP+guest_memfd prevent untrusted host user space from directly
> modifying the data, this is good enough for CVE-2022-0171, but there
> is no such guarantee that the host kernel in some scenarios could
> access the data and generate dirty caches. In fact, AFAIC, SNP VM does
> not track whether each page is previously shared, isn't it? If a page
> was previously shared and was written by the host kernel or devices
> before it was changed to private. No one tracks it and dirty caches
> are there!
> 
> So, to avoid any corner case situations like the above, it seems
> currently we have to retain the property: flushing the cache when the
> guest memory mapping leaves KVM NPT.
> 
> Of course, this is fundamentally because SME_COHERENT only applies to
> CPU cores, but not DMA. If SME_COHERENT is complete, flushing is no
> longer needed. Alternatively, we need extra bookkeeping for KVM to
> know whether each page has dirty cache lines. Another alternative is
> to filter mmu_notifier reasons, which is the part that I am planning
> to take. thoughts?
> 

Now running SNP+guest_memfd with discard=both option enabled:

# bpftrace -e 'kprobe:sev_guest_memory_reclaimed {@[kstack]=count()}'
Attaching 1 probe...
^C

@[
     sev_guest_memory_reclaimed+5
     kvm_mmu_notifier_release+60
     __mmu_notifier_release+128
     exit_mmap+657
     __mmput+72
     mmput+49
     do_exit+752
     do_group_exit+57
     get_signal+2486
     arch_do_signal_or_restart+51
     exit_to_user_mode_prepare+257
     syscall_exit_to_user_mode+42
     do_syscall_64+109
     entry_SYSCALL_64_after_hwframe+114
]: 1
@[
     sev_guest_memory_reclaimed+5
     kvm_mmu_notifier_invalidate_range_start+869
     __mmu_notifier_invalidate_range_start+152
     change_protection+4628
     change_prot_numa+93
     task_numa_work+588
     task_work_run+108
     exit_to_user_mode_prepare+337
     syscall_exit_to_user_mode+42
     do_syscall_64+109
     entry_SYSCALL_64_after_hwframe+114
]: 2
@[
     sev_guest_memory_reclaimed+5
     kvm_mmu_notifier_invalidate_range_start+869
     __mmu_notifier_invalidate_range_start+152
     change_protection+4628
     change_prot_numa+93
     task_numa_work+588
     task_work_run+108
     xfer_to_guest_mode_handle_work+228
     kvm_arch_vcpu_ioctl_run+1572
     kvm_vcpu_ioctl+671
     __x64_sys_ioctl+153
     do_syscall_64+96
     entry_SYSCALL_64_after_hwframe+114
]: 2
@[
     sev_guest_memory_reclaimed+5
     kvm_set_memslot+740
     __kvm_set_memory_region.part.0+411
     kvm_set_memory_region+89
     kvm_vm_ioctl+1482
     __x64_sys_ioctl+153
     do_syscall_64+96
     entry_SYSCALL_64_after_hwframe+114
]: 104
@[
     sev_guest_memory_reclaimed+5
     kvm_mmu_notifier_invalidate_range_start+869
     __mmu_notifier_invalidate_range_start+152
     zap_page_range_single+384
     unmap_mapping_range+279
     shmem_fallocate+932
     vfs_fallocate+345
     __x64_sys_fallocate+71
     do_syscall_64+96
     entry_SYSCALL_64_after_hwframe+114
]: 5465
@[
     sev_guest_memory_reclaimed+5
     kvm_mmu_notifier_invalidate_range_start+869
     __mmu_notifier_invalidate_range_start+152
     zap_page_range_single+384
     madvise_vma_behavior+1967
     madvise_walk_vmas+190
     do_madvise.part.0+264
     __x64_sys_madvise+98
     do_syscall_64+96
     entry_SYSCALL_64_after_hwframe+114
]: 69677

The maximum hits are seen with shmem_fallocate and madvise, which we 
believe are response to shared<->private
GHCB page-state-chage requests. discard=both handles discard both for
private and shared memory, so freeing shared memory
via fallocate(shared_memfd, FALLOC_FL_PUNCH_HOLE, ...) would trigger the
notifiers when freeing shared pages after guest converts a GPA to
private.

Now, as with SNP+guest_memfd, guest private memory is not mapped in host 
anymore, so i added a generic fix (instead of Sean's proposed patch of 
checking for SNP guest inside sev_guest_memory_reclaimed()):

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -593,6 +593,9 @@ static __always_inline int 
__kvm_handle_hva_range(struct kvm *kvm,
                         unsigned long hva_start, hva_end;

                         slot = container_of(node, struct 
kvm_memory_slot, hva_node[slots->node_idx]);
+                       if (kvm_slot_can_be_private(slot)) {
+                               continue;
+                       }
                         hva_start = max(range->start, 
slot->userspace_addr);
                         hva_end = min(range->end, slot->userspace_addr +
                                                   (slot->npages << 
PAGE_SHIFT));

With this fix added, the traces are as follows:

# bpftrace -e 'kprobe:sev_guest_memory_reclaimed {@[kstack]=count()}'
Attaching 1 probe...
^C

@[
     sev_guest_memory_reclaimed+5
     kvm_mmu_notifier_invalidate_range_start+812
     __mmu_notifier_invalidate_range_start+152
     change_protection+4628
     change_prot_numa+93
     task_numa_work+588
     task_work_run+108
     exit_to_user_mode_prepare+337
     syscall_exit_to_user_mode+42
     do_syscall_64+109
     entry_SYSCALL_64_after_hwframe+114
]: 1
@[
     sev_guest_memory_reclaimed+5
     kvm_mmu_notifier_release+60
     __mmu_notifier_release+128
     exit_mmap+657
     __mmput+72
     mmput+49
     do_exit+752
     do_group_exit+57
     get_signal+2486
     arch_do_signal_or_restart+51
     exit_to_user_mode_prepare+257
     syscall_exit_to_user_mode+42
     do_syscall_64+109
     entry_SYSCALL_64_after_hwframe+114
]: 1
@[
     sev_guest_memory_reclaimed+5
     kvm_mmu_notifier_invalidate_range_start+812
     __mmu_notifier_invalidate_range_start+152
     change_protection+4628
     change_prot_numa+93
     task_numa_work+588
     task_work_run+108
     xfer_to_guest_mode_handle_work+228
     kvm_arch_vcpu_ioctl_run+1572
     kvm_vcpu_ioctl+671
     __x64_sys_ioctl+153
     do_syscall_64+96
     entry_SYSCALL_64_after_hwframe+114
]:
@[
     sev_guest_memory_reclaimed+5
     kvm_set_memslot+740
     __kvm_set_memory_region.part.0+411
     kvm_set_memory_region+89
     kvm_vm_ioctl+1482
     __x64_sys_ioctl+153
     do_syscall_64+96
     entry_SYSCALL_64_after_hwframe+114
]: 104
#

As expected, the SEV hook is not invoked for the guest private memory 
pages (no more invalidation from shmem_fallocate() + madvise()).

Isn't it better to skip invoking the KVM MMU invalidation notifier when 
the invalidated range belongs to guest private memory ?

 > In fact, AFAIC, SNP VM does
 > not track whether each page is previously shared, isn't it? If a page
 > was previously shared and was written by the host kernel or devices
 > before it was changed to private. No one tracks it and dirty caches
 > are there!

The skipped invalidation here covered the case Mingwei mentioned above, 
where the pages are changed from private->shared and subsequent freeing 
of shared pages triggered the invalidation.

But, then why are we concerned about this, i thought we have concerns 
about the case where the dirty cache lines contain encrypted guest data ?

Thanks,
Ashish

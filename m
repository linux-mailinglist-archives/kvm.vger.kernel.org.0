Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2B27B587A
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 18:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbjJBQdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 12:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjJBQdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 12:33:17 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54B19B;
        Mon,  2 Oct 2023 09:33:11 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1qnLqu-0003gY-Cc; Mon, 02 Oct 2023 18:33:00 +0200
Message-ID: <e8993457-9e28-434a-b4e8-25ffcbee6517@maciej.szmigiero.name>
Date:   Mon, 2 Oct 2023 18:32:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Ignore MSR_AMD64_BU_CFG access
Content-Language: en-US, pl-PL
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <0ffde769702c6cdf6b6c18e1dcb28b25309af7f7.1695659717.git.maciej.szmigiero@oracle.com>
 <ZRHRsgjhOmIrxo0W@google.com>
 <8c6a1fc8-2ac5-4767-8b02-9ef56434724e@maciej.szmigiero.name>
 <ZRHckCMwOv3jfSs7@google.com> <ac402dd4-8bf3-87a8-7ade-50d62997ce97@amd.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Autocrypt: addr=mail@maciej.szmigiero.name; keydata=
 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
In-Reply-To: <ac402dd4-8bf3-87a8-7ade-50d62997ce97@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.09.2023 00:25, Tom Lendacky wrote:
> On 9/25/23 14:16, Sean Christopherson wrote:
>> +Tom
>>
>> On Mon, Sep 25, 2023, Maciej S. Szmigiero wrote:
>>> On 25.09.2023 20:30, Sean Christopherson wrote:
>>>>>
>>>>> Hyper-V enabled Windows Server 2022 KVM VM cannot be started on Zen1 Ryzen
>>>>> since it crashes at boot with SYSTEM_THREAD_EXCEPTION_NOT_HANDLED +
>>>>> STATUS_PRIVILEGED_INSTRUCTION (in other words, because of an unexpected #GP
>>>>> in the guest kernel).
>>>>>
>>>>> This is because Windows tries to set bit 8 in MSR_AMD64_BU_CFG and can't
>>>>> handle receiving a #GP when doing so.
>>>>
>>>> Any idea why?
>>>
>>> I guess it is trying to set some chicken bit?
>>>
>>> By the way, I tested Windows Server 2019 now - it has the same problem.
>>>
>>> So likely Windows 11 and newer version of Windows 10 have it, too.
>>
>> ...
>>
>>>>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>>>>> index 1d111350197f..c80a5cea80c4 100644
>>>>> --- a/arch/x86/include/asm/msr-index.h
>>>>> +++ b/arch/x86/include/asm/msr-index.h
>>>>> @@ -553,6 +553,7 @@
>>>>>    #define MSR_AMD64_CPUID_FN_1        0xc0011004
>>>>>    #define MSR_AMD64_LS_CFG        0xc0011020
>>>>>    #define MSR_AMD64_DC_CFG        0xc0011022
>>>>> +#define MSR_AMD64_BU_CFG        0xc0011023
>>>>
>>>> What document actually defines this MSR?  All of the PPRs I can find for Family 17h
>>>> list it as:
>>>>
>>>>      MSRC001_1023 [Table Walker Configuration] (Core::X86::Msr::TW_CFG)
>>>
>>> It's partially documented in various AMD BKDGs, however I couldn't find
>>> any definition for this particular bit (8) - other than that it is reserved.
>>
>> I found it as MSR_AMD64_BU_CFG for Model 16h, but that's Jaguar/Puma, not Zen1.
>> My guess is that Windows is trying to write this thing:
>>
>>    MSRC001_1023 [Table Walker Configuration] (Core::X86::Msr::TW_CFG)
>>    Read-write. Reset: 0000_0000_0000_0000h.
>>    _lthree0_core[3,1]; MSRC001_1023
>>
>>    Bits   Description
>>    63:50  Reserved.
>>    49     TwCfgCombineCr0Cd: combine CR0_CD for both threads of a core. Read-write. Reset: 0. Init: BIOS,1.
>>           1=The host Cr0_Cd values from the two threads are OR'd together and used by both threads.
>>    48:0   Reserved.
>>
>> Though that still doesn't explain bit 8...  Perhaps a chicken-bit related to yet
>> another speculation bug?
>>
>> Boris or Tom, any idea what Windows is doing?  I doubt it changes our options in
>> terms of "fixing" this in KVM, but having a somewhat accurate/helpful changelog
>> would be nice.
> 
> It's definitely not related to a speculation bug, but I'm unsure what was told to Microsoft that has them performing that WRMSR. The patch does the proper thing, though, as a guest shouldn't be updating that setting.
> 
> And TW_CFG is the proper name of that MSR for Zen.


So, should I prepare v2 with MSR_AMD64_BU_CFG -> MSR_AMD64_TW_CFG change?

Thanks,
Maciej


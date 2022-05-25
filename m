Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BE05337D6
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 09:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiEYH4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 03:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiEYH4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 03:56:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333B17C147;
        Wed, 25 May 2022 00:56:48 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id a38so15418198pgl.9;
        Wed, 25 May 2022 00:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Zm05XcXPghYiNpc+KlNS6PwBY4711oDaHig2XlH5SNk=;
        b=XgQKOjE5xDeRr+2CajcBj588raMpn8m6GdSAt+OFHTXOfPoNWvdIRVIPXmRNpkQiwS
         Dt+DTv+HG7Z/+bEa4XRpWKSRI+KGjlzrhUmHWAgIAm1EX+LlJV6UykNreQl74jSbOGcD
         o+UzFwWRyEPaAX2c+2j6kmtZErdJnOWiCIOgrTt3FQsBrR/4GzTnAVML5L30b5PfTLDE
         3tx4pwN5kYW7fomNAzkuFqXd+NKNz+4TsaXu1ivDie2xAjt+4IWmdYDxdvtlI7ndXdUt
         e8jlVe5jW2Wj1oDVcZOky1w6ST/9JpJ6gIAghPQqghDBnFlJisIoYzZn4pmxhmZ6QeC9
         9nRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zm05XcXPghYiNpc+KlNS6PwBY4711oDaHig2XlH5SNk=;
        b=vPwcRWnZK9EuJjC6f7uS/KM9CoZWNVQfzEnrAIgZSZYhC4+tZIlAIjpnGkJE0B+1Sx
         6XccGo40d6FVLbbElDnepLPXCrZhyMFBU1k8U/TEuVqnwQo+wY1YSvzE4B6dgzUfij02
         eAjUFQxOdBbIYmxZlVC9rl3Rk31Afpj33PLalZqSOCTcKbrNJ39e2NYyrvESHX4ReQzP
         iiHYpQNSKk1fbcjEyyxqq98031S8m9BM2yaiKdApY8LFvaDq0K011KAEgFqXZgBhIekH
         hDOuY5NtTLOhdGLB+T2nTGA33aDzwNlksMLRD0TKwSgXelrvogubODlfAirB5ZkOHJj/
         tQQw==
X-Gm-Message-State: AOAM531OlMMk8/w+ZSs1D6pXDdqHh5C3+x8YyEaDIogMWlz/NjsbhaYi
        ++2khy86eah8asZH+hDTuJo=
X-Google-Smtp-Source: ABdhPJzfFjwZH3iuAagKE5QOGPydwSpjXz/cFak0YbMGZbDWoP8Xc12oso0ibWM7nQgQsvP1eXURFg==
X-Received: by 2002:a65:60cf:0:b0:3fa:a259:a6fe with SMTP id r15-20020a6560cf000000b003faa259a6femr6625349pgv.222.1653465407633;
        Wed, 25 May 2022 00:56:47 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.86])
        by smtp.gmail.com with ESMTPSA id r5-20020a655085000000b003f60df4a5d5sm7855365pgp.54.2022.05.25.00.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 00:56:46 -0700 (PDT)
Message-ID: <f379a933-15b0-6858-eeef-5fbef6e5529c@gmail.com>
Date:   Wed, 25 May 2022 15:56:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH RESEND v12 00/17] KVM: x86/pmu: Add basic support to
 enable guest PEBS via DS
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20220411101946.20262-1-likexu@tencent.com>
 <87fsl5u3bg.fsf@redhat.com> <e0b96ebd-00ee-ead4-cf35-af910e847ada@gmail.com>
 <d7461fd4-f6ec-1a0b-6768-0008a3092add@gmail.com> <874k1ltw9y.fsf@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <874k1ltw9y.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/5/2022 10:46 pm, Vitaly Kuznetsov wrote:
> Like Xu <like.xu.linux@gmail.com> writes:
> 
>> On 19/5/2022 9:31 pm, Like Xu wrote:
>>> ==== Test Assertion Failure ====
>>>      lib/x86_64/processor.c:1207: r == nmsrs
>>>      pid=6702 tid=6702 errno=7 - Argument list too long
>>>         1    0x000000000040da11: vcpu_save_state at processor.c:1207
>>> (discriminator 4)
>>>         2    0x00000000004024e5: main at state_test.c:209 (discriminator 6)
>>>         3    0x00007f9f48c2d55f: ?? ??:0
>>>         4    0x00007f9f48c2d60b: ?? ??:0
>>>         5    0x00000000004026d4: _start at ??:?
>>>      Unexpected result from KVM_GET_MSRS, r: 29 (failed MSR was 0x3f1)
>>>
>>> I don't think any of these failing tests care about MSR_IA32_PEBS_ENABLE
>>> in particular, they're just trying to do KVM_GET_MSRS/KVM_SET_MSRS.
>>
>> One of the lessons I learned here is that the members of msrs_to_save_all[]
>> are part of the KVM ABI. We don't add feature-related MSRs until the last
>> step of the KVM exposure feature (in this case, adding MSR_IA32_PEBS_ENABLE,
>> MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG to msrs_to_save_all[] should take
>> effect along with exposing the CPUID bits).
> 
> AFAIR the basic rule here is that whatever gets returned with
> KVM_GET_MSR_INDEX_LIST can be passed to KVM_GET_MSRS and read
> successfully by the host (not necessarily by the guest) so my guess is
> that MSR_IA32_PEBS_ENABLE is now returned in KVM_GET_MSR_INDEX_LIST but
> can't be read with KVM_GET_MSRS. Later, the expectation is that what was
> returned by KVM_GET_MSRS can be set successfully with KVM_SET_MSRS.
> 

Thanks for the clarification.

Some kvm x86 selftests have been failing due to this issue even after the last 
commit.

I blame myself for not passing the msr_info->host_initiated to the 
intel_is_valid_msr(),
meanwhile I pondered further whether we should check only the MSR addrs range in
the kvm_pmu_is_valid_msr() and apply this kind of sanity check in the 
pmu_set/get_msr().

Vitaly && Paolo, any preference to move forward ?

Thanks,
Like Xu

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBC96DD294
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 08:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjDKGR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 02:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKGRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 02:17:24 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F04172E;
        Mon, 10 Apr 2023 23:17:23 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6323df83c50so708925b3a.1;
        Mon, 10 Apr 2023 23:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681193843; x=1683785843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BdbVkg8JyVfPMjY9O+nWcIOh6JiElSZr72TQmD1pDj0=;
        b=UZ20y0ZMlCDJnO+kMTdAhQFQQQ3xbEzUouWx7A1ZTXqbda2RQSVqNL3qz0T+dD5UvY
         fVT3DbJKfqTrElkl7i3n8a6VVMEjWLLjG0wyIarf/uYnGh9tSCLPgT8hqeU/y8Cw5bQI
         QLwhQgIyXFsh8ghqx2uAkhrTsrNL0VunHeXtb9izPeos0oPy5vlwd9v+AbPBB8yOaNW5
         PD9jlgP6UUCNe+w0JBddMfScwnR5EvXlR6+ezjRG7WJFwHPGi57lifSpuERjNW2ehfPx
         +O5RrpGiA2PXqt+ugexsF/Sy2vobz24P9kpDqVJtOKarA6htAjSKLvVq7OGKlgbixkUV
         5WmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681193843; x=1683785843;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BdbVkg8JyVfPMjY9O+nWcIOh6JiElSZr72TQmD1pDj0=;
        b=JLPqdZDpmMXmVxjKHdDqnb/RQ9Q0t+Dgv8VmAEIyNQCgODY7pibeQcRiL8PzeJLcSb
         nX2xzhvklc+9huITfUACNTYzUNMvSTG8ajSpWnFxpw+uqE5FlHU7TvcKBCPh9mXuI02z
         X9w+BZYzZqfMYzHRNzngZtyftqLTgDVbaSCiFkp45jKXYLXUngMXP5f3H7Yq9cOez/8f
         xImsXjmW6WrjSWs2IIvXlmvDUOxCKWdpd0Wp+7n2akN5N4mQXHD79Imd6FHzPw2Fc3Tr
         Iq8jAv71IEZKsjyZEqQBu8xyd4M/zrAFBDz5B72xz41f1Glf0PpzllU4vwixDrvRr8Qc
         HLsQ==
X-Gm-Message-State: AAQBX9cKev3IWXaYmxU8K4QkXOhjRwQcumKVwiB5TMMOJ3zRH9tovrth
        ymhP1gL0pKfNXmSn1Mpt2IA=
X-Google-Smtp-Source: AKy350ZDPJL5OX5Mp+D4qACbGypTzsBkULKk2A/pCwhhVZ1p15j/YVZA7oXLTryKvh84MoD09VO31Q==
X-Received: by 2002:a62:4e0f:0:b0:624:1ab3:da1a with SMTP id c15-20020a624e0f000000b006241ab3da1amr1965415pfb.29.1681193843216;
        Mon, 10 Apr 2023 23:17:23 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e20-20020aa78c54000000b0059085684b54sm9197105pfd.140.2023.04.10.23.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 23:17:22 -0700 (PDT)
Message-ID: <9a7d5814-9eb1-d7af-7968-a6e3ebb90248@gmail.com>
Date:   Tue, 11 Apr 2023 14:17:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH V5 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230410105056.60973-1-likexu@tencent.com>
 <20230410105056.60973-6-likexu@tencent.com>
 <CALMp9eTLvJ6GW1mfgjO7CL7tW-79asykyz9=Fb=FfT74VRkDVA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eTLvJ6GW1mfgjO7CL7tW-79asykyz9=Fb=FfT74VRkDVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/2023 1:36 pm, Jim Mattson wrote:
> On Mon, Apr 10, 2023 at 3:51 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> Disable PMU support when running on AMD and perf reports fewer than four
>> general purpose counters. All AMD PMUs must define at least four counters
>> due to AMD's legacy architecture hardcoding the number of counters
>> without providing a way to enumerate the number of counters to software,
>> e.g. from AMD's APM:
>>
>>   The legacy architecture defines four performance counters (PerfCtrn)
>>   and corresponding event-select registers (PerfEvtSeln).
>>
>> Virtualizing fewer than four counters can lead to guest instability as
>> software expects four counters to be available.
> 
> I'm confused. Isn't zero less than four?

As I understand it, you are saying that virtualization of zero counter is also 
reasonable.
If so, the above statement could be refined as:

	Virtualizing fewer than four counters when vPMU is enabled may lead to guest 
instability
	as software expects at least four counters to be available, thus the vPMU is 
disabled if the
	minimum number of KVM supported counters is not reached during initialization.

Jim, does this help you or could you explain more about your confusion ?

> 
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/pmu.h | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index dd7c7d4ffe3b..002b527360f4 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -182,6 +182,9 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>>                          enable_pmu = false;
>>          }
>>
>> +       if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS)
>> +               enable_pmu = false;
>> +
>>          if (!enable_pmu) {
>>                  memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>>                  return;
>> --
>> 2.40.0
>>

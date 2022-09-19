Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BB05BC4B7
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 10:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiISIuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 04:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiISItq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 04:49:46 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119CC237EC;
        Mon, 19 Sep 2022 01:49:22 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bi3so99351pgb.11;
        Mon, 19 Sep 2022 01:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=f4lJ3N0uKHqbaTlJ2yJchpCS7uT21SgUgyF132AXj88=;
        b=Kvt6IxivfZ9AdelKHj+0aVmVKjmSEK59vtDHoyQlD/1I0ytsotSWHqyBD2fL6vqMQB
         R4sM8C3e7773ITsR5x2bG3GVybnaeQjcRbeRjK1yBz2y1LEE0uA2Lr3ioFSCdbPrXhY5
         Lz+pLENV6AedTARCPjT3lQoSC4RyuNdo3Wy0MZRlaX85qsulXcEgRLCP9xWjvHzwspZU
         6TW3L70d35OPXjAKS4J/v0p51LHiDn3aLisTbfvWoiJAA2GDoFqhWTurroc6oCOYKilf
         oOnt3KcxndHTbS1r77Z4pW22/qLhajoKsOb45SJlYBp98k9pT7YZh+VsRL53p2zYEC3T
         39Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=f4lJ3N0uKHqbaTlJ2yJchpCS7uT21SgUgyF132AXj88=;
        b=YQkmssABbvmdieD8mQjLKcj6KS+iRtcLNojBxFSL+7onslYPswLa3s0POynpH2ifrt
         lNcqe8BYfx2kB4jlabWndILqa1O6xL9z8FYYH79wt6TkGE+HfHoEY7b5IK6ubVr4cV2L
         zThh0SR1i8aQUqhfLXugxk3XSVwnr8TRyIZj2PEFX11Ym17u0d+Ef0TNwZ8GMBJBXLCD
         GJKDremaUObmfUyFe6kOrHMyJOJW6TinQlbJwd4DZpwz3LUR1kHYl5f0V9Q60Y52URPX
         fLDOGqybL7z8wvAcH/V8DK7QFvi7Gyr+89hHQz4gA+ZdrleLQd/r0uX7k+YTD3JYPFtV
         gQuw==
X-Gm-Message-State: ACrzQf21DQ/6ukqFpQ1Ynv6CQ6I0xWnWH7sJZq7SREylQlnVgQziQcP5
        hUNmmIuD34sMlNiT+PuiWqk=
X-Google-Smtp-Source: AMsMyM5WyR2QEL3sFfFzy9AA6p83zqLW8oRvtZ5YMWGujrMZH5OhGa2LxH3pz3VfAMzCjuLMU8RsAA==
X-Received: by 2002:aa7:8058:0:b0:54f:1644:a4fd with SMTP id y24-20020aa78058000000b0054f1644a4fdmr3525961pfm.63.1663577351766;
        Mon, 19 Sep 2022 01:49:11 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w16-20020aa79550000000b0054555418ca4sm14692040pfq.29.2022.09.19.01.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 01:49:11 -0700 (PDT)
Message-ID: <f3cc0afb-f24a-9b71-1f55-db4c437cc458@gmail.com>
Date:   Mon, 19 Sep 2022 16:49:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 1/3] KVM: x86/pmu: Stop adding speculative Intel GP
 PMCs that don't exist yet
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220907104838.8424-1-likexu@tencent.com>
 <CALMp9eSPfxPunKW-K6LLPxsXdaeezKU=2G9Sdh7FS6VGb3goFA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eSPfxPunKW-K6LLPxsXdaeezKU=2G9Sdh7FS6VGb3goFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/2022 12:33 am, Jim Mattson wrote:
> On Wed, Sep 7, 2022 at 3:48 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> The Intel April 2022 SDM - Table 2-2. IA-32 Architectural MSRs adds
>> a new architectural IA32_OVERCLOCKING_STATUS msr (0x195), plus the
>> presence of IA32_CORE_CAPABILITIES (0xCF), the theoretical effective
>> maximum value of the Intel GP PMCs is 14 (0xCF - 0xC1) instead of 18.
>>
>> But the conclusion of this speculation "14" is very fragile and can
>> easily be overturned once Intel declares another meaningful arch msr
>> in the above reserved range, and even worse, Intel probably put PMCs
>> 8-15 in a completely different range of MSR indices.
> 
> The last clause is just conjecture.
> 
>> A conservative proposal would be to stop at the maximum number of Intel
>> GP PMCs supported today. Also subsequent changes would limit both AMD
>> and Intel on the number of GP counter supported by KVM.
>>
>> There are some boxes like Intel P4 may indeed have 18 counters, but
>> those counters are in a completely different msr address range and do
>> not strictly adhere to the Intel Arch PMU specification, and will not
>> be supported by KVM in the near future.
> 
> The P4 PMU isn't virtualized by KVM today, is it?

According to [1], P4 PMU has ZERO number of Intel Architectural Events, and
the KVM support for non Intel Arch PMUs has been dropped recently.

[1] 
https://www.intel.com/content/dam/develop/external/us/en/documents/30320-nehalem-pmu-programming-guide-core.pdf

> 
>>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
> 
> Please put the "Fixes" tag back. You convinced me that it should be there.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>


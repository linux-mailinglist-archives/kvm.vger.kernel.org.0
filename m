Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C4148903A
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 07:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbiAJGeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 01:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiAJGeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 01:34:20 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDD6C06173F
        for <kvm@vger.kernel.org>; Sun,  9 Jan 2022 22:34:19 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i129so2536532pfe.13
        for <kvm@vger.kernel.org>; Sun, 09 Jan 2022 22:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=g0xjUSllIEypB6wmkEHOMhoO298BokUlUVtDCALFcfo=;
        b=Tx+ERSZcktqPaSyOpex3faw1Ibc/dJvbmZt2Up2VgN7QvQzjpt5qkwztZn+Er+VxvF
         FwLAVOrhtaNRdXOAbuzAktR2mb0DHPEpt99nEQXmmNsKlyECngWutDi5OrIG69esntwq
         /xp77AdPVdIijbXIjuUJj0anhlRbScl5VZnyHElmDXli9zovchsPL8OkslRsYq8u1dVf
         J3abWw8PrOeDMDNNYG0wzfgqMRBD2Wpf7PoMOQIYghzWkXGmzF/3PDZwIesT3Mw+pHTx
         JUyd8cHqnYAPQeO1JIXb1wyq1ZI42JZmq9RKrpJdincnivb6yu7z+VCDQnqsPSj3z2Gv
         gz4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=g0xjUSllIEypB6wmkEHOMhoO298BokUlUVtDCALFcfo=;
        b=biI1meL5P9S3R9Wbsjntj5KdnxOjCT4PF4naRL4Q966i6mw5Iv3R97z5VQFiKAFp2J
         YLnQs23JVzzf5+mjRk2EQt5qdGfTgbAAL+MkGJPylESsracJeaFu2+4uzTe35QOc+N4v
         IjMPrpIhbwW3+oXxjhcpXOjlksgV4iauq2i+5XMyLKATDpFsfHzTtKXzfSHlMPizXcln
         d81gxL76xMFfDjb4XPxEiYRGn/bvcMtykdrwclzyujCeKm1MeMNB9qeQUIwa350RzMmg
         3tDAXnj0a0FbI3yDDpmhqRT/Dadw2qbFMUdPxnZNW1FOYDRqhjDLviZNnrxJIN2TwSgO
         Pz6Q==
X-Gm-Message-State: AOAM531EM96Ru4vLtRSJJCPkaFW27ueGiMzfb6UVaS6tiWecc8VCyjup
        O0pQI6NDSBOyYENjk1Y3LNr+ru8TUvbVgSUgh+E=
X-Google-Smtp-Source: ABdhPJyjx3TVX/lNemqCK0kb+R5TgYbp6SMfcjFZRgQkbgIZVvQL5vcjk4HY7Tz3Ey1OA2SHfspJoA==
X-Received: by 2002:a63:6c04:: with SMTP id h4mr36567194pgc.30.1641796459228;
        Sun, 09 Jan 2022 22:34:19 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s14sm2255373pfw.33.2022.01.09.22.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jan 2022 22:34:18 -0800 (PST)
Message-ID: <0660da46-3429-ac45-6fd8-4ada3341ff65@gmail.com>
Date:   Mon, 10 Jan 2022 14:34:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20200529074347.124619-1-like.xu@linux.intel.com>
 <20200529074347.124619-4-like.xu@linux.intel.com>
 <CALMp9eQNZsk-odGHNkLkkakk+Y01qqY5Mzm3x8n0A3YizfUJ7Q@mail.gmail.com>
 <7c44617d-39f5-4e82-ee45-f0d142ba0dbc@linux.intel.com>
 <CALMp9eTYPqZ-NMuBKkoNX+ZvomzSsCgz1=C2n+Ajaq-ttMys1Q@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test full-width counter writes
 support
In-Reply-To: <CALMp9eTYPqZ-NMuBKkoNX+ZvomzSsCgz1=C2n+Ajaq-ttMys1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/2022 8:06 am, Jim Mattson wrote:
> On Tue, May 11, 2021 at 11:33 PM Like Xu <like.xu@linux.intel.com> wrote:
>>
>> On 2021/5/12 5:27, Jim Mattson wrote:
>>> On Fri, May 29, 2020 at 12:44 AM Like Xu <like.xu@linux.intel.com> wrote:
>>>>
>>>> When the full-width writes capability is set, use the alternative MSR
>>>> range to write larger sign counter values (up to GP counter width).
>>>>
>>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>>> ---
>>>
>>>> +       /*
>>>> +        * MSR_IA32_PMCn supports writing values â€‹â€‹up to GP counter width,
>>>> +        * and only the lowest bits of GP counter width are valid.
>>>> +        */
>>>
>>> Could you rewrite this comment in ASCII, please? I would do it, but
>>> I'm not sure what the correct translation is.
>>>
>>
>> My first submitted patch says that
>> they are just Unicode "ZERO WIDTH SPACE".
>>
>> https://lore.kernel.org/kvm/20200508083218.120559-2-like.xu@linux.intel.com/
>>
>> Here you go:
>>
>> ---
>>
>>   From 1b058846aabcd7a85b5c5f41cb2b63b6a348bdc4 Mon Sep 17 00:00:00 2001
>> From: Like Xu <like.xu@linux.intel.com>
>> Date: Wed, 12 May 2021 14:26:40 +0800
>> Subject: [PATCH] x86: pmu: Fix a comment about full-width counter writes
>>    support
>>
>> Remove two Unicode characters 'ZERO WIDTH SPACE' (U+200B).
>>
>> Fixes: 22f2901a0e ("x86: pmu: Test full-width counter writes support")
>> Reported-by: Jim Mattson <jmattson@google.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>    x86/pmu.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/x86/pmu.c b/x86/pmu.c
>> index 5a3d55b..6cb3506 100644
>> --- a/x86/pmu.c
>> +++ b/x86/pmu.c
>> @@ -510,7 +510,7 @@ static void  check_gp_counters_write_width(void)
>>           }
>>
>>           /*
>> -        * MSR_IA32_PMCn supports writing values Ã¢â‚¬â€¹Ã¢â‚¬â€¹up to GP
>> counter width,
>> +        * MSR_IA32_PMCn supports writing values up to GP counter width,
>>            * and only the lowest bits of GP counter width are valid.
>>            */
>>           for (i = 0; i < num_counters; i++) {
>> --
>> 2.31.1
> 
> Paolo:
> 
> Did this patch get overlooked? I'm still seeing the unicode characters
> in this comment.
> 

Hi Paolo, please help review this one as well:
https://lore.kernel.org/kvm/20211122115758.46504-1-likexu@tencent.com/


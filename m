Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8BB2ED081
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 14:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbhAGNSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 08:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGNSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 08:18:39 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B86C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 05:17:58 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id q18so5641387wrn.1
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 05:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MMe0MhQILmLXNtJaUVZuGyxVT1LscrzchpAs5TqvH8I=;
        b=eNBd+DrCtcLQTejJ9dl349Q1NDPdPku1Mu5zN25gorsp5X9z1hbbJQ07HLhlQJaAfg
         yhyuZuxwxyPXVyS+R6wCRwWMSxWCNeyWJDC3XlwGcuPB5bdYmi3F8+Ja0yKQfBMeI3T9
         dF0P9Na/C2oW8LaeW5l7x5DZ2gsAH+EHk2eTH0wgqCRm/+LJ0BpGsp+ZDtmraOC6+xbU
         KzsIWeHoetS6qprytN14gHPVGucr4AVomBCSoE/A6/HECmlgpmKDDTV/BK4M5OgIg7N8
         I35PAPM7gg3kRL64BHCE5z0SB8ThUxG2Mhdsv8j1ir//iUzCWskR4XjsNTp3lAqzvqRH
         EfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MMe0MhQILmLXNtJaUVZuGyxVT1LscrzchpAs5TqvH8I=;
        b=ZeLQuOAslbtsyJdTy4OgHLiADpg3jGb3ZmzZrFKTUTYo/pxnEUlPXh/E2qyW5OuqMy
         vV/BmRtgoehdZmMtNDN6KV3ktjPONB5HBj5GUzM/2/ohCHBqfWUGaGPmi6d/ju22P7SW
         N51zamndBDcx+stgQ11VF5SjD3lLR6UYrSLR+J2rLN3/8BP7n5XiSDMOiWvns0jXD2a4
         3mfb/5JkgOeRaBqMmGfkXjiTAfNFNbZxNpr8AYmDEDbHAAQNfCkfWsiFpnSkT7oQUoeU
         Iq+0izHv7K2DVtZqdM5cDuEhmok6djjLb5QQmwyA6AoDlAKHsfHyHUNb0G/GyaBTKcnP
         +HhA==
X-Gm-Message-State: AOAM530gah5vQO2COOmGqGQRXIo0O4V8JDurMVbMouqcKXj4e/gTKdCh
        E5/Bk9yooW/UfK9dKtunzQKsZa1h1qg=
X-Google-Smtp-Source: ABdhPJwLxOaz9Wymqm6dXRj8kd/3Bl27c6h1SIhtXVUnQvhyY7WZ/qUPHRaG80jtM0G/3g4R0hWsAQ==
X-Received: by 2002:adf:d082:: with SMTP id y2mr9091383wrh.301.1610025476979;
        Thu, 07 Jan 2021 05:17:56 -0800 (PST)
Received: from [192.168.1.36] (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id a62sm8694423wmh.40.2021.01.07.05.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 05:17:55 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available()
 helper
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-4-f4bug@amsat.org>
 <508441db-8748-1b55-5f39-e6a778c0bdc0@linaro.org>
 <40e8df0f-01ab-6693-785b-257b8d3144bf@amsat.org>
 <af357960-40f2-b9e6-485f-d1cf36a4e95d@flygoat.com>
 <b1e8b44c-ae6f-786c-abe0-9a03eb5d3d63@flygoat.com>
 <0a0d8d4d-a0b6-dde5-e32d-17746ef57d53@amsat.org>
Message-ID: <6b266ee5-2c27-8aa5-f1c9-1540231f9bf8@amsat.org>
Date:   Thu, 7 Jan 2021 14:17:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <0a0d8d4d-a0b6-dde5-e32d-17746ef57d53@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/21 10:04 AM, Philippe Mathieu-Daudé wrote:
> On 12/16/20 4:14 AM, Jiaxun Yang wrote:
>> 在 2020/12/16 上午10:50, Jiaxun Yang 写道:
>>> TBH I do think it doesn't sounds like a good idea to make 32-bit
>>> and 64-bit different. In fact ISA_MIPS32R6 is always set for targets
>>> with ISA_MIPS64R6.
>>>
>>> We're treating MIPS64R6 as a superset of MIPS32R6, and ISA_MIPS3
>>> is used to tell if a CPU supports 64-bit.
>>>
>>> FYI:
>>> https://commons.wikimedia.org/wiki/File:MIPS_instruction_set_family.svg
>>
>> Just add more cents here...
>> The current method we handle R6 makes me a little bit annoying.
>>
>> Given that MIPS is backward compatible until R5, and R6 reorganized a lot
>> of opcodes, I do think decoding procdure of R6 should be dedicated from
>> the rest,
>> otherwise we may fall into the hell of finding difference between R6 and
>> previous
>> ISAs, also I've heard some R6 only ASEs is occupying opcodes marked as
>> "removed in R6", so it doesn't looks like a wise idea to check removed
>> in R6
>> in helpers.
> 
> I think we are in agreement :) Your comment seems what I addressed
> last month as this series:
> https://gitlab.com/philmd/qemu/-/commits/mips_decodetree_lsa_r6/
> (I'll try to rebase it and post during the week-end.)

Bah actually it is already on the list and reviewed =)
https://www.mail-archive.com/qemu-devel@nongnu.org/msg765234.html

>> So we may end up having four series of decodetrees for ISA
>> Series1: MIPS-II, MIPS32, MIPS32R2, MIPS32R5 (32bit "old" ISAs)
>> Series2: MIPS-III, MIPS64, MIPS64R2, MIPS64R5 (64bit "old" ISAs)
>>
>> Series3: MIPS32R6 (32bit "new" ISAs)
>> Series4: MIPS64R6 (64bit "new" ISAs)
>>
>> Thanks
>>
>> - Jiaxun
> 

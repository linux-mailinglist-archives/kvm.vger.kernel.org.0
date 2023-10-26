Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD17D7DD2
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 09:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbjJZHxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 03:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjJZHxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 03:53:35 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097D8186
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 00:53:33 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3175e1bb38cso145828f8f.1
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 00:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1698306811; x=1698911611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7x9v8GLS8Ef4TSWddzkM6oKYRbalxE6ofrX2SJE4Hhk=;
        b=CWspmAU1jzoo3ruPkZhvwnGMlmkM1yTW8MotKCI2v4UsTnmMGyu4zuiZppqpLsIMEq
         RIpjdUO7wCJ4SZq+yNzRmvJHzfgF7CAahW46HHpfXj7fElOkIGznP8es2CzG43RRpoJa
         +zRG1tKrvodktlizXCptKgYfKQJjGHj1LLTPngRNc+VGxPxbg4IRR53JPIMYqM9W7VXO
         RE3KLybye7PaQ9LLIsfChzHivW1YzxoOUA2T6bm1BfllSyT5AUV8n757Sd62+soxtTG0
         H3FpzdnZks9dn2Zj7XgUIBOmk2Z2lhqC9UV3VznRNzguyy4CXXGcZ/0icT8HjDQDb9bC
         mhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698306811; x=1698911611;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7x9v8GLS8Ef4TSWddzkM6oKYRbalxE6ofrX2SJE4Hhk=;
        b=RSc5c9p2/34sEWfzxkIaj1O66VPByzz7uGRt756kVOrr9ysCyxNnXGD9c7UUExIzZY
         /l7aOnNdvYvGiea9uqn1nw9tB8AK/7Y0NpyLLEny+nkge+PAxQMbcFPyMODXTkX27kE2
         xOPe/QpTmLlwsYkmTHJcmXDZB/lFpCat1OXWR+BTrNIVFOepLqtjQervR3uQrFJXGoWm
         ENxwM5XdCeeG/9W/OaPsjpoiu2ZvKiH02qPAxQztpaCYQ3uJ1gETEEvDORR9YeqifU06
         uw/rsgW563VsLZQI1jbpDf153OeGdEXmBYuzi+OYqkUJQE/GJT1n1Ey1PcMzP+evm6+O
         Bmtg==
X-Gm-Message-State: AOJu0YydVuxjkM8rxUBdZp+wRY/do2nENBC8KJ1+1oG3c6JKbFaHYRJz
        wmlVGSe/jLIN54BfZfo1pVubFw==
X-Google-Smtp-Source: AGHT+IG8Fy+FLDWt7XCFmuIyub2r57w0404DNmOT+0P54B+ng8YYa8QMTcKkAo6XgLR/tBBzmEzROQ==
X-Received: by 2002:adf:b1d1:0:b0:32d:8be3:f3fe with SMTP id r17-20020adfb1d1000000b0032d8be3f3femr10181449wra.7.1698306811079;
        Thu, 26 Oct 2023 00:53:31 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:b380:32be:257:5381? ([2a01:e0a:999:a3a0:b380:32be:257:5381])
        by smtp.gmail.com with ESMTPSA id l21-20020a056000023500b003198a9d758dsm13780134wrz.78.2023.10.26.00.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 00:53:30 -0700 (PDT)
Message-ID: <db7ca9ba-27aa-482e-9986-67622b4cedb2@rivosinc.com>
Date:   Thu, 26 Oct 2023 09:53:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] riscv: Use SYM_*() assembly macros instead of
 deprecated ones
Content-Language: en-US
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20231024132655.730417-1-cleger@rivosinc.com>
 <20231024132655.730417-3-cleger@rivosinc.com>
 <20231024-e122c317599cd4c6db53c015@orel>
 <da308888-0e47-4ca4-b318-8f089421dc0b@rivosinc.com>
 <20231025-d21b7077ff99828bef7cfaa8@orel>
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20231025-d21b7077ff99828bef7cfaa8@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25/10/2023 08:50, Andrew Jones wrote:
> On Tue, Oct 24, 2023 at 08:03:52PM +0200, Clément Léger wrote:
>>
>>
>> On 24/10/2023 17:23, Andrew Jones wrote:
>>> On Tue, Oct 24, 2023 at 03:26:52PM +0200, Clément Léger wrote:
>>> ...
>>>> diff --git a/arch/riscv/lib/uaccess.S b/arch/riscv/lib/uaccess.S
>>>> index 09b47ebacf2e..3ab438f30d13 100644
>>>> --- a/arch/riscv/lib/uaccess.S
>>>> +++ b/arch/riscv/lib/uaccess.S
>>>> @@ -10,8 +10,7 @@
>>>>  	_asm_extable	100b, \lbl
>>>>  	.endm
>>>>  
>>>> -ENTRY(__asm_copy_to_user)
>>>> -ENTRY(__asm_copy_from_user)
>>>> +SYM_FUNC_START(__asm_copy_to_user)
>>>>  
>>>>  	/* Enable access to user memory */
>>>>  	li t6, SR_SUM
>>>> @@ -181,13 +180,13 @@ ENTRY(__asm_copy_from_user)
>>>>  	csrc CSR_STATUS, t6
>>>>  	sub a0, t5, a0
>>>>  	ret
>>>> -ENDPROC(__asm_copy_to_user)
>>>> -ENDPROC(__asm_copy_from_user)
>>>> +SYM_FUNC_END(__asm_copy_to_user)
>>>>  EXPORT_SYMBOL(__asm_copy_to_user)
>>>> +SYM_FUNC_ALIAS(__asm_copy_from_user, __asm_copy_to_user)
>>>>  EXPORT_SYMBOL(__asm_copy_from_user)
>>>
>>> I didn't see any comment about the sharing of debug info among both the
>>> from and to functions. Assuming it isn't confusing in some way, then
>>
>> Hi Andrew,
>>
>> I did some testing with gdb and it seems to correctly assume that
>> __asm_copy_to_user maps to __asm_copy_from_user for debugging. The basic
>> tests that I did (breakpoints, disasm, etc) seems to show no sign of
>> problems for debugging. Were you thinking about other things specifically ?
> 
> Mostly just backtrace symbols, but I suppose we can live with it, since
> it wouldn't be the only weird thing in a backtrace.

Oh yes, In that case, clearly, if backtraced through __asm_copy_to_user,
it will display __asm_copy_from_user. This is the case in gdb if you
disassemble __asm_copy_to_user, it display __asm_copy_from_user (which
is "quite" expected to say the least). But I'm not sure of what would
happen with the existing code since there are two symbols mapping to
same area of code. I'd expect the same I guess.

Clément

> 
> Thanks,
> drew

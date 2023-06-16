Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2D37327C3
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 08:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbjFPGiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 02:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbjFPGit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 02:38:49 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435E12726
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 23:38:48 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-98276e2a4bbso50336366b.0
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 23:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1686897527; x=1689489527;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bOtOw8QIOdNvfFnrXAoGaMKBuGCxmASOEQnYVJ4K1Tg=;
        b=Q1aZpVKmqN5xSNZ34/bMRPaX9cC4iRi8Edd7og4tH9D3Rpyyg6RyaXvZM387s948Ty
         DWAGauOazenhir7pzSNzZmPXMKEcipjBrEIaXuEQ1On5ePTX2ZWts9g7csXALU3gziYY
         XIGr4H7EYSdn/oCwtjmkaIE1dJl7rJ6c3zwdDd69Fi8uS3q0obfKLGDeCpDGxulyYPkg
         n7e/2dsI3xEMUbfEkK4n1yuvt9B6ccQ4BWV+vEw6Vnimj2jOSrAwGfwbg3BB0T9VKHE8
         ctiIiKf3cneRn1rALMtU41LU79AkwmZVDZmuElPTOHjzVhtonV4qKUrCgrq00i2cE0l6
         Mupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686897527; x=1689489527;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bOtOw8QIOdNvfFnrXAoGaMKBuGCxmASOEQnYVJ4K1Tg=;
        b=DF/YOZL3X6EwHKtXcYyywqUBDzGF4A3FystRTS4xGAiicWFy1XJ+bo2wpeLHIP4Nvf
         jae826V8hb9Ib03rCYcxADZ7yBrp+gru5lox68kVN2CXovLeCqNj/kgnwI34zQyg4tWY
         9JAyYVqIL7cT5WFOexCLC9kMgXx/4BlF+rnB6vrDOIeXt5G+qQs/wuZW/8A9mYkQcjuM
         WdL20dCwjajJ8IRayYjoQFtI8bSZvXdUTUOQ+wVC81q/by6E3bomfjvjySzJC4RLdWuR
         C8YTPyk0mKWvyp1cpJZ8Kfj6l2BEs1PEoyCvSEPEwMoPbeJY0rcXuv2QQ00/Q9dONngr
         ENAw==
X-Gm-Message-State: AC+VfDzwoTrw9B45I/NAq212gkAvQ3jt3rXAMNzECnPcnBV6E+/Xd9Mj
        ih5DcGTQdTdrSyfcXj1V+RVWlQ==
X-Google-Smtp-Source: ACHHUZ6SjpC/GY4C4spOblKkMr7C1oUxp/LK10lsRBqsFPrzn+mn468bcHT9wsRKNJqMrJaLLRwYEQ==
X-Received: by 2002:a17:907:360e:b0:96a:4ea0:a1e7 with SMTP id bk14-20020a170907360e00b0096a4ea0a1e7mr1121375ejc.50.1686897526443;
        Thu, 15 Jun 2023 23:38:46 -0700 (PDT)
Received: from ?IPV6:2003:f6:af16:3b00:baca:76bd:5313:ec6c? (p200300f6af163b00baca76bd5313ec6c.dip0.t-ipconnect.de. [2003:f6:af16:3b00:baca:76bd:5313:ec6c])
        by smtp.gmail.com with ESMTPSA id r23-20020a1709064d1700b009658475919csm10251142eju.188.2023.06.15.23.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 23:38:45 -0700 (PDT)
Message-ID: <fb38904e-f503-8d72-3031-c8f60421631d@grsecurity.net>
Date:   Fri, 16 Jun 2023 08:38:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v2 06/16] x86/run_in_user: Change type of
 code label
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230413184219.36404-1-minipli@grsecurity.net>
 <20230413184219.36404-7-minipli@grsecurity.net> <ZIe5IpqsWhy8Xyt5@google.com>
 <4de05ab1-e4d3-6693-a3c2-3f80236110bf@grsecurity.net>
 <ZIsr1acxWTbtiWKg@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZIsr1acxWTbtiWKg@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15.06.23 17:18, Sean Christopherson wrote:
> On Wed, Jun 14, 2023, Mathias Krause wrote:
>> On 13.06.23 02:32, Sean Christopherson wrote:
>>> On Thu, Apr 13, 2023, Mathias Krause wrote:
>>>> Use an array type to refer to the code label 'ret_to_kernel'.
>>>
>>> Why?  Taking the address of a label when setting what is effectively the target
>>> of a branch seems more intuitive than pointing at an array (that's not an array).
>>
>> Well, the flexible array notation is what my understanding of referring
>> to a "label" defined in ASM is. I'm probably biased, as that's a pattern
>> used a lot in the Linux kernel but trying to look at the individual
>> semantics may make it clearer why I prefer 'extern char sym[]' over
>> 'extern char sym'.
>>
>> The current code refers to the code sequence starting at 'ret_to_kernel'
>> by creating an alias of it's first instruction byte. However, we're not
>> interested in the first instruction byte at all. We want a symbolic
>> handle of the begin of that sequence, which might be an unknown number
>> of bytes. But that's also a detail that doesn't matter. We only what to
>> know the start. By referring to it as 'extern char' implies that there
>> is at least a single byte. (Let's ignore the hair splitting about just
>> taking the address vs. actually dereferencing it (which we do not).) By
>> looking at another code example, that byte may not actually be there!
>> >From x86/vmx_tests.c:
>>
>>   extern char vmx_mtf_pdpte_guest_begin;
>>   extern char vmx_mtf_pdpte_guest_end;
>>
>>   asm("vmx_mtf_pdpte_guest_begin:\n\t"
>>       "mov %cr0, %rax\n\t"    /* save CR0 with PG=1                 */
>>       "vmcall\n\t"            /* on return from this CR0.PG=0       */
>>       "mov %rax, %cr0\n\t"    /* restore CR0.PG=1 to enter PAE mode */
>>       "vmcall\n\t"
>>       "retq\n\t"
>>       "vmx_mtf_pdpte_guest_end:");
>>
>> The byte referred to via &vmx_mtf_pdpte_guest_end may not even be mapped
>> due to -ftoplevel-reorder possibly putting that asm block at the very
>> end of the compilation unit.
>>
>> By using 'extern char []' instead this nastiness is avoided by referring
>> to an unknown sized byte sequence starting at that symbol (with zero
>> being a totally valid length). We don't need to know how many bytes
>> follow the label. All we want to know is its address. And that's what an
>> array type provides easily.
> 
> I think my hangup is that arrays make me think of data, not code.

I can say the same for 'extern char' -- that's clearly data, not even
r/o data, less so .text ;)

>                                                                    I wouldn't
> object if this were new code, but I dislike changing existing code to something
> that's arguably just as flawed.

Fair enough.

> What if we declare the label as a function?  That's not exactly correct either,
> but IMO it's closer to the truth, and let's us document that the kernel trampoline
> has a return value, i.e. preserves/outputs RAX.

No, please don't. It's *not* a function, not at all. First thing that
code block does is switching the stack, wich is already a bummer. But it
also has no return instruction, making it fall-through to the middle of
run_in_user() and execute code out of context. It's really just a label
to mark the beginning of a code sequence we have to care about.

Now, we do not want to ever call ret_to_kernel() from C, but declaring
it as a function just feels way more worse than having a "wrong" extern
char declaration.

So, let's leave the code as-is. It's not broken, just imperfect.

> 
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index c3ec0ad7..a46a369a 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -31,17 +31,18 @@ static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
>  #endif
>  }
>  
> +uint64_t ret_to_kernel(void);
> +
>  uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>                 uint64_t arg1, uint64_t arg2, uint64_t arg3,
>                 uint64_t arg4, bool *raised_vector)
>  {
> -       extern char ret_to_kernel;
>         volatile uint64_t rax = 0;
>         static unsigned char user_stack[USERMODE_STACK_SIZE];
>         handler old_ex;
>  
>         *raised_vector = 0;
> -       set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
> +       set_idt_entry(RET_TO_KERNEL_IRQ, ret_to_kernel, 3);
>         old_ex = handle_exception(fault_vector,
>                                   restore_exec_to_jmpbuf_exception_handler);
>  
> 

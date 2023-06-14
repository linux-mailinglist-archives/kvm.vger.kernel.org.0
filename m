Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35980730990
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 23:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjFNVCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 17:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjFNVCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 17:02:11 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417F0A6
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 14:02:10 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2b4146fbadeso4147191fa.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 14:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1686776528; x=1689368528;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5X8hherlR2uhZ3CE5FD1YkO/sty7eWBacpdnuujDVLI=;
        b=rB4r9OvSMEIo4AHbPFAUrCFvEDPKJWRka07yF1oz3yLBakZxy7Culdya6lzKrtM962
         q5Nvwk2BU3Q6CBYwgy+3WiyizGuCKloOc67cvM35X8lWdJDFmoThrJyBcuRyybxdTVgP
         48K8uRdEf3P5Psb2ysUXUOidCKD5sxjmGOO6+3AlXAemqD1b4nHKBOiqBjhGhbNSnqnk
         75H6TwxS3wOxIHoKIQWj9QkP0xlwwOB+bFdfD3GciAJ/pagsU98FKt4RlXI2IilibrFF
         VE2dPU/0sMv/JJbqLbj2eclwNTbYJal1lITVICgWO7EkYfCPSBbD//TNBvkLVAJLTEUQ
         2XWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686776528; x=1689368528;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5X8hherlR2uhZ3CE5FD1YkO/sty7eWBacpdnuujDVLI=;
        b=kbuno1LslTnDkmTdKdokerKQceN/dpAMrpC0vl3FFbnqg7GjTMVpggpIW8FPcBVPrV
         y9XCj0xjfJ+v7VQ9puy4q9hHEZgkMs21zfAzZN5HKddAW9/dDmP+Zni0XfpH6yalQKuC
         Ck3nPG6fv5WVK5o4Fhcnbsywcx/KRdate3/jHs+tOgByJFTJTxYXRqyZA2tvEC8Qkoz5
         F3L9m+irt/j/+5JcSVAfgjxN5MrtZVWklqHg0gMn0Mi3xWP3uRDB+FH9X9cR4R+UnoHY
         YM1oYinP9v4AcWrpRiZFIiuutOQcwPa/dXqTGaOhy3+zDQJ7/zmOf3aIZ6V19B8QIFFG
         ULhg==
X-Gm-Message-State: AC+VfDz68ALfZIbJNEzN+zUXCB6sFw715Fs6JmxrADybFrO3zBYR/ERW
        IH1o1tvQdU17Er0zLnje0dPPY1V3CyqnuFOQANs=
X-Google-Smtp-Source: ACHHUZ56deJfjbC9b+AtgyHw5i+C3pO8ozYMpTddZu7aKJ00E3x5c7HiyZqGpEwd8HEBCZjomrlGqQ==
X-Received: by 2002:a2e:95d5:0:b0:2b1:bf5d:4115 with SMTP id y21-20020a2e95d5000000b002b1bf5d4115mr7249146ljh.13.1686776528315;
        Wed, 14 Jun 2023 14:02:08 -0700 (PDT)
Received: from ?IPV6:2003:f6:af14:3c00:9650:2efe:173b:4a64? (p200300f6af143c0096502efe173b4a64.dip0.t-ipconnect.de. [2003:f6:af14:3c00:9650:2efe:173b:4a64])
        by smtp.gmail.com with ESMTPSA id m8-20020a056402050800b005149cb5ee2dsm8140527edv.82.2023.06.14.14.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 14:02:07 -0700 (PDT)
Message-ID: <4de05ab1-e4d3-6693-a3c2-3f80236110bf@grsecurity.net>
Date:   Wed, 14 Jun 2023 23:02:06 +0200
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
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZIe5IpqsWhy8Xyt5@google.com>
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

On 13.06.23 02:32, Sean Christopherson wrote:
> On Thu, Apr 13, 2023, Mathias Krause wrote:
>> Use an array type to refer to the code label 'ret_to_kernel'.
> 
> Why?  Taking the address of a label when setting what is effectively the target
> of a branch seems more intuitive than pointing at an array (that's not an array).

Well, the flexible array notation is what my understanding of referring
to a "label" defined in ASM is. I'm probably biased, as that's a pattern
used a lot in the Linux kernel but trying to look at the individual
semantics may make it clearer why I prefer 'extern char sym[]' over
'extern char sym'.

The current code refers to the code sequence starting at 'ret_to_kernel'
by creating an alias of it's first instruction byte. However, we're not
interested in the first instruction byte at all. We want a symbolic
handle of the begin of that sequence, which might be an unknown number
of bytes. But that's also a detail that doesn't matter. We only what to
know the start. By referring to it as 'extern char' implies that there
is at least a single byte. (Let's ignore the hair splitting about just
taking the address vs. actually dereferencing it (which we do not).) By
looking at another code example, that byte may not actually be there!
From x86/vmx_tests.c:

  extern char vmx_mtf_pdpte_guest_begin;
  extern char vmx_mtf_pdpte_guest_end;

  asm("vmx_mtf_pdpte_guest_begin:\n\t"
      "mov %cr0, %rax\n\t"    /* save CR0 with PG=1                 */
      "vmcall\n\t"            /* on return from this CR0.PG=0       */
      "mov %rax, %cr0\n\t"    /* restore CR0.PG=1 to enter PAE mode */
      "vmcall\n\t"
      "retq\n\t"
      "vmx_mtf_pdpte_guest_end:");

The byte referred to via &vmx_mtf_pdpte_guest_end may not even be mapped
due to -ftoplevel-reorder possibly putting that asm block at the very
end of the compilation unit.

By using 'extern char []' instead this nastiness is avoided by referring
to an unknown sized byte sequence starting at that symbol (with zero
being a totally valid length). We don't need to know how many bytes
follow the label. All we want to know is its address. And that's what an
array type provides easily.

But I can understand, that YMMV and you prefer it the other way around.

> 
>> No functional change.
>>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>>  lib/x86/usermode.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
>> index e22fb8f0132b..b976123ca753 100644
>> --- a/lib/x86/usermode.c
>> +++ b/lib/x86/usermode.c
>> @@ -35,12 +35,12 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>>  		uint64_t arg1, uint64_t arg2, uint64_t arg3,
>>  		uint64_t arg4, bool *raised_vector)
>>  {
>> -	extern char ret_to_kernel;
>> +	extern char ret_to_kernel[];
>>  	uint64_t rax = 0;
>>  	static unsigned char user_stack[USERMODE_STACK_SIZE];
>>  
>>  	*raised_vector = 0;
>> -	set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
>> +	set_idt_entry(RET_TO_KERNEL_IRQ, ret_to_kernel, 3);
>>  	handle_exception(fault_vector,
>>  			restore_exec_to_jmpbuf_exception_handler);
>>  
>> -- 
>> 2.39.2
>>

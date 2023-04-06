Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1A26D913E
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 10:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbjDFILk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 04:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbjDFILi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 04:11:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E45E4A
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 01:11:37 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9476e2fa157so93186066b.3
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680768695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BoOqd0xJdAAqZznX9BqW+fG2YVKZERKSSsMI0PWSCV8=;
        b=S0ZBXfHy5j7+woCKZgdCFSSNP8I/0njihmcirkEXvsE75rrcR4Lc+8Yz214ENHkRFU
         sXzJKMzyGw8iC43Xxq+Oz5Mbm9p4h9Q5pLvcS1BCCwJXTP1wpn7C1XHIp3Fk2C/3zRDx
         gZtGCrvEtBgedyttM17lM1zUmb9ktmpKTpsU4HvnjIWQyABMyUgTrrMHGaXSlcFZ5t+u
         PFFUUvo49LRHf+X3yUXb0ZftEUkPtt5d1xfO+Z6ARvElcCArLSzj9SRF3luRg84gRBiR
         SO93Tty1v+9ngjytFAzpH0cMjcCpFcGQT+f1bzIRckzw6yqGouMqp+f/BTFB8rJhSsM5
         4Eag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BoOqd0xJdAAqZznX9BqW+fG2YVKZERKSSsMI0PWSCV8=;
        b=tlsEMZDTAqpvN76eBHGo0jiX3QJ9QTEQzb+6ESjYmpkYHcsTXxccaizBIU8eZM7MJP
         s3g6dBy1SFWC2a8yPY98NFYQOiESVvQONYjxwyUIgQUzzoTXstP5gWPdzKJsriyLch91
         PCVCIFLu567Fh2Dk83wfZSkNYNv+/hq7JM6ACbU7Buen/VpBSlhE7N9IirKIE+BgXgMc
         VB1/BQr5PhQw3NJypG3jXjogRb0oObSatH1kWfoXKyyfwkZ9D861gNIlQOCeHg3gLU4k
         I9DI1KaZzgy5eRJv0x5rAfD43vZyuN4s414mlQDXo4x8gcnPXhSUSSlnQQHq2+k/wf5l
         MruQ==
X-Gm-Message-State: AAQBX9dlC6L9pH5zqxtpKigNnNEbyuvB8lAE5c8wwRM5YQi6u3+MJsVe
        dc6dBK2Gru+VhIWz3VbE1d/ZtoR/ETsklPDesKI=
X-Google-Smtp-Source: AKy350bxMENWXbuLG5O/VjAiIM1BZ66a7ajkWgSVuGe3ZTctQML48n9kAVuwuNWcC7QN+mjMXYEAWQ==
X-Received: by 2002:a05:6402:b33:b0:500:2e94:26aa with SMTP id bo19-20020a0564020b3300b005002e9426aamr4992038edb.20.1680768695706;
        Thu, 06 Apr 2023 01:11:35 -0700 (PDT)
Received: from ?IPV6:2003:f6:af05:3700:e3dd:8565:18f3:3982? (p200300f6af053700e3dd856518f33982.dip0.t-ipconnect.de. [2003:f6:af05:3700:e3dd:8565:18f3:3982])
        by smtp.gmail.com with ESMTPSA id ek14-20020a056402370e00b005028e87068fsm385429edb.73.2023.04.06.01.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 01:11:35 -0700 (PDT)
Message-ID: <f34b3d78-a1c4-90cb-079a-2dc81a5e6e7b@grsecurity.net>
Date:   Thu, 6 Apr 2023 10:11:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Test non-canonical memory
 access exceptions
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20230215142344.20200-1-minipli@grsecurity.net>
 <ZC42RavGH2Z82oJd@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZC42RavGH2Z82oJd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.04.23 05:02, Sean Christopherson wrote:
> On Wed, Feb 15, 2023, Mathias Krause wrote:
>> +static void test_reg_noncanonical(void)
>> +{
>> +	extern char nc_rsp_start, nc_rsp_end, nc_rbp_start, nc_rbp_end;
>> +	extern char nc_rax_start, nc_rax_end;
>> +	handler old_ss, old_gp;
>> +
>> +	old_ss = handle_exception(SS_VECTOR, advance_rip_and_note_exception);
>> +	old_gp = handle_exception(GP_VECTOR, advance_rip_and_note_exception);
>> +
>> +	/* RAX based, should #GP(0) */
>> +	exceptions = 0;
>> +	rip_advance = &nc_rax_end - &nc_rax_start;
>> +	asm volatile("nc_rax_start: orq $0, (%[msb]); nc_rax_end:\n\t"
> 
> Can't we use ASM_TRY() + exception_vector() + exception_error_code()?  Installing
> a dedicated handler is (slowly) being phased out.

Well, you may have guessed it, but I tried to be "consistent with the
existing style." Sure this code could get a lot of cleanups too, the
whole file, actually, like the externs should be 'extern char []'
instead to point out they're just "labels" and no chars. But, again, I
just did as was "prior art" in this file. But if moving forward to a
more modern version is wanted, I can adapt.

>  Even better, if you're willing
> to take a dependency and/or wait a few weeks for my series to land[*], you should
> be able to use asm_safe() to streamline this even further.
> 
> [*] https://lkml.kernel.org/r/20230406025117.738014-1-seanjc%40google.com

Looks like a nice cleanup, indeed. However, the conversion should be
straight forward, so I don't think this change has to "wait" for it.

The linked bug report turned 1 just two weeks ago. About time to get it
some more traction. :D

That said, I'll do a spring cleanup of emulator64.c along with my change
to address the points you mentioned in the other test functions as well.
But likely not before next week.

> 
> 
>> +		     : : [msb]"a"(1ul << 63));
> 
> Use BIT_ULL().  Actually, scratch that, we have a NONCANONICAL macro.  It _probably_
> won't matter, but who know what will happen with things like LAM and LASS.

Thanks, will change.

> 
> And why hardcode use of RAX?  Won't any "r" constraint work?

Unfortunately not. It must be neither rsp nor rbp and with "r" the
compiler is free to choose one of these. It'll unlikely make use of rsp,
but rbp is a valid target we need to avoid. (Yes, I saw the
-no-omit-frame-pointer handling in the Makefiles, but I dislike this
implicit dependency.)

I can change the constraints to "abcdSD" to give the compiler a little
bit more freedom, but that makes the inline asm little harder to read,
IMHO. Hardcoding rax is no real constraint to the compiler either, as
it's a volatile register anyway. The call to report() will invalidate
its old value, so I don't see the need for a change -- a comment, at
best, but that's already there ;)

> 
> E.g. I believe this can be something like:
> 
> 	asm_safe_report_ex(GP_VECTOR, "orq $0, (%[noncanonical]), "r" (NONCANONICAL));
> 	report(!exception_error_code());
> 
> Or we could even add asm_safe_report_ex_ec(), e.g.
> 
> 	asm_safe_report_ex_ec(GP_VECTOR, 0,
> 			      "orq $0, (%[noncanonical]), "r" (NONCANONICAL));

Yeah, the latter. Verifying the error code is part of the test, so that
should be preserved.

The tests as written by me also ensure that an exception actually
occurred, exactly one, actually. Maybe that should be accounted for in
asm_safe*() as well?


Thanks,
Mathias

PS: Would be nice if the entry barrier for new tests wouldn't require to
handle the accumulated technical debt of the file one's touching ;P
But I can understand that adding more code adapting to "existing style"
makes the problem only worse. So it's fine with me.

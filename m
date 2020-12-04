Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B312CF6FC
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 23:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgLDWlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 17:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgLDWlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 17:41:22 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76C5C0613D1
        for <kvm@vger.kernel.org>; Fri,  4 Dec 2020 14:40:41 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id b2so7472982edm.3
        for <kvm@vger.kernel.org>; Fri, 04 Dec 2020 14:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yFuZpM48mzNWDi1/O1LkUT35WuH/+Ad0bs1eLP76xjw=;
        b=jn992NARi2yX6RVBXCl//T9T4jOqKAnXHCYRnLRqrPFYpIsTLqJZFp5kDe+dWbCzKC
         Q4dGRgVGr+z/+TikJaAhD2ebdRgSOWKp+gm1LNA1vZS38U16ybpLTP+YryMirJCUfAvW
         Oq1KyhL7HYN2kkIRd+dBujP0NNNd5S0O7rY28Ff6VNXhpkuIOxakPc+Aav8/y+JPJY4d
         6/2NYwjyUEJPgCkSgvBxltPZuCgFzI8XsdgbSoNnkUGE8z4fCwcM9EbCoop7Z5SUeJCR
         gabQlbTwFA4TiDfH8XIV4XOOCKCOx6VZ7yzNDnWV9zv1TlUOvszh4WH2AlkwzekCxTYi
         J9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yFuZpM48mzNWDi1/O1LkUT35WuH/+Ad0bs1eLP76xjw=;
        b=dBOjRQlYIOuD7lEo6qexeGaEX08Tuud/1QylmgS9Dt26qjsDlYhsWUi/GLIQcHh8LA
         njH5oXIA9U+IsdxwcVb5K72JpUYKRvsW9d/FPPW7/nNq9kmm/ldkdsp0vsji34Mzf/4d
         BWCUau5L+1KTxw4bmqqBmWz8ADtH/TdCC+RI/9Fuj3rp7iAcu365Xu0irf79uhiVHevf
         Qsz4WXGNvarFMxZcHbFZf6sBNirgcEpj23RiVzmC0XE8BYF/17hI3u54zfMl/0BbpzHz
         J/H1eD3htxie+fnucI4HBQfVvewSiEn80idLfXuP8k0zrFbsVXA0AG2dmKiSgjYjZAWB
         2XzA==
X-Gm-Message-State: AOAM5315p8usacreghHal37We3F3etXo14gtJjNBZjDaTBanAeb5ygjT
        bf/CbRw/YQX68KXw8QEkKPs=
X-Google-Smtp-Source: ABdhPJzympze9tyI6snkyWlCdfjmFbZCPUnQfJl2h34rcd2QwgUzg4LF92mQVV6Y40WN7i9rDWK6xw==
X-Received: by 2002:a50:9d4f:: with SMTP id j15mr9833060edk.69.1607121640667;
        Fri, 04 Dec 2020 14:40:40 -0800 (PST)
Received: from [192.168.1.36] (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id q23sm4168605edt.32.2020.12.04.14.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 14:40:39 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 6/9] target/mips: Alias MSA vector registers on FPU scalar
 registers
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201202184415.1434484-1-f4bug@amsat.org>
 <20201202184415.1434484-7-f4bug@amsat.org>
 <ac68e51c-650a-55df-c050-c22a1df355b5@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <f528a49d-2476-8e8f-e6e8-afc115864b1b@amsat.org>
Date:   Fri, 4 Dec 2020 23:40:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <ac68e51c-650a-55df-c050-c22a1df355b5@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 5:28 PM, Richard Henderson wrote:
> On 12/2/20 12:44 PM, Philippe Mathieu-Daudé wrote:
>> Commits 863f264d10f ("add msa_reset(), global msa register") and
>> cb269f273fd ("fix multiple TCG registers covering same data")
>> removed the FPU scalar registers and replaced them by aliases to
>> the MSA vector registers.
>> While this might be the case for CPU implementing MSA, this makes
>> QEMU code incoherent for CPU not implementing it. It is simpler
>> to inverse the logic and alias the MSA vector registers on the
>> FPU scalar ones.
> 
> How does it make things incoherent?  I'm missing how the logic has actually
> changed, as opposed to an order of assignments.

I guess my wording isn't clear.

By "incoherent" I want to say it is odd to disable MSA and have
FPU registers displayed with MSA register names, instead of their
proper FPU names.

The MIPS ISA represents the ASE as onion rings that extend an ISA.
I'd like to model it that way, have ASE optional (and that we can
even not compile).
You can have CPU without FPU, CPU with FPU, CPU with MSA (you
implicitly have a FPU). If FPU depends on MSA, we can not take the
MSA implementation out of the equation.

Back to the patch, instead of aliasing FPU registers to the MSA ones
(even when MSA is absent), we now alias the MSA ones to the FPU ones
(only when MSA is present). This is what I call the "inverted logic".

BTW the point of this change is simply to be able to extract the MSA
code out of the huge translate.c.

Regards,

Phil.

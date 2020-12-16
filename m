Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB332DBF04
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 11:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgLPKvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 05:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPKvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 05:51:37 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D44C0617A6
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 02:50:56 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id 91so22704622wrj.7
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 02:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xv90pGKHSd1iup8rHBBas7LG9OwRK+eYIdDVNAi+Y4Q=;
        b=Y8WyiA0pXnULlK5az9uL5SaoKyZt5CYUHj2IODFlWsPFIWlHbpVK6r4XiyTQUN33pt
         IYlYtmDt1025FXEkHJzd1vyomivhWp+R5h3zYYPe1dcSrg46dMNtByKsdfn558dHPrrw
         YKadNJktDc3UULjj7Y1QZIP7qNZJN2UYI6Myj1dm3qd/pOKn2tZy8ZyKwReLc7BHQBKA
         P4uyFt7cFABs8qduy8BDvqBOqWVy8R9jf1RcuuRFY5LywS3c73pFG2CThETYIl21szT0
         H/ZiYqa03NTcRd+5JDbwV/fmR0MrDljwS5sjn4eJWTVNOtbsKX0EVi49Yc+2ugWBK95O
         qr9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xv90pGKHSd1iup8rHBBas7LG9OwRK+eYIdDVNAi+Y4Q=;
        b=r4lzbtpXEitA+xw+9DuJqplfCSA513dyqveuaDTjSOTpAvMOUeybtfmSy8tCbqbX0s
         YwuImnaTH1Lf/fewEN8FiJDyPJ+jIb5nWlqWsADHsoGqMh0r/bcomNOW+QYkxVq2uCzD
         ce5rd/JDxIEh0J7Hy7ywUBaBm7/RCCespA1T42mb52bI/1kJnkgFCaGPEPsFoOHj8JpD
         BG+SOY1ccGlpFPER3zO0+LP0WPyH0RPx+dCezxG+MrRQoa8k+oloIEMplFEFZPpbzbEt
         rFGkA/YgpNYkflNid4YTMYw+91tQY/XOpI4p89rvjfjVn/Ts687nZd1OuVfIG5k4v2LN
         ta4w==
X-Gm-Message-State: AOAM533gPZPAOAIbh/tbxJwFwcyl4cfRyGFyfmKOkm/NLOL3QYOSRqqr
        m87iKzBteRHQ9IZVie3RgJaEvATIHxf01Q==
X-Google-Smtp-Source: ABdhPJwQfjTDc2P9bNpOrGqtI0lYbrDk2aMoShxBLBmrnbZ3rDbSvb1JSJSTXMYL8iorSSEjtVWgGw==
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr15934993wrq.47.1608115855152;
        Wed, 16 Dec 2020 02:50:55 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id o13sm2092470wmc.44.2020.12.16.02.50.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 02:50:54 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v2 03/24] target/mips/cpu: Introduce isa_rel6_available()
 helper
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
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <5977d0f5-7e62-5f8a-d4ec-284f6f1af81d@amsat.org>
Date:   Wed, 16 Dec 2020 11:50:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <b1e8b44c-ae6f-786c-abe0-9a03eb5d3d63@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/20 4:14 AM, Jiaxun Yang wrote:
> 在 2020/12/16 上午10:50, Jiaxun Yang 写道:
>>
>>
>> TBH I do think it doesn't sounds like a good idea to make 32-bit
>> and 64-bit different. In fact ISA_MIPS32R6 is always set for targets
>> with ISA_MIPS64R6.
>>
>> We're treating MIPS64R6 as a superset of MIPS32R6, and ISA_MIPS3
>> is used to tell if a CPU supports 64-bit.

Which is why I don't understand why they are 2 ISA_MIPS32R6/ISA_MIPS64R6
definitions.

>>
>> FYI:
>> https://commons.wikimedia.org/wiki/File:MIPS_instruction_set_family.svg
> 
> Just add more cents here...
> The current method we handle R6 makes me a little bit annoying.
> 
> Given that MIPS is backward compatible until R5, and R6 reorganized a lot
> of opcodes, I do think decoding procdure of R6 should be dedicated from
> the rest,
> otherwise we may fall into the hell of finding difference between R6 and
> previous
> ISAs, also I've heard some R6 only ASEs is occupying opcodes marked as
> "removed in R6", so it doesn't looks like a wise idea to check removed
> in R6
> in helpers.

I'm not sure I understood well your comment, but I also find how
R6 is handled messy...

I'm doing this removal (from helper to decoder) with the decodetree
conversion.

> So we may end up having four series of decodetrees for ISA
> Series1: MIPS-II, MIPS32, MIPS32R2, MIPS32R5 (32bit "old" ISAs)
> Series2: MIPS-III, MIPS64, MIPS64R2, MIPS64R5 (64bit "old" ISAs)
> 
> Series3: MIPS32R6 (32bit "new" ISAs)
> Series4: MIPS64R6 (64bit "new" ISAs)

Something like that, I'm starting by converting the messier leaves
first, so the R6 and ASEs. My approach is from your "series4" to
"series1" last.

Regards,

Phil.

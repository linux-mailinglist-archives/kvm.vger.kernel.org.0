Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D768979B86C
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbjIKUsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbjIKNQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 09:16:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE46EB
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 06:16:28 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-52a40cf952dso5879662a12.2
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 06:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694438187; x=1695042987; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m/qr8ZqIxkTb/NWVgB9FttOgrkE2LFvm9nGFJM1n4Sc=;
        b=Kf/+DWbzc7DYvQvAL+qsxxvJdQq4Dddx0RTz5dWeqFo2zh3aeFmBfGTicNnelcc5qY
         q/Z7+urP7wyupxLztrSmgRlX+aTRv/rpX7ojMC/OFZbP23lhDuhi/i/yWlBavbJOdVdd
         t5vue3OWa/GzywntarRMA8e10QIUPZed8ToUofbCWgCHNORjKF2HsATrPczrOf1kC5gs
         tpcYytl3UmBDxOmXtPLcO0YdkFQMd0F4LMC8gm1pAZCM/+dlFCbXLrbEaCalEI6UYE9C
         3hC8WY8CwQp17MWhwfdP+zDuAQPR2vYMfEKU9TjIciGO8xE1xVL8Aro9ycGL57JaLUhf
         QnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694438187; x=1695042987;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m/qr8ZqIxkTb/NWVgB9FttOgrkE2LFvm9nGFJM1n4Sc=;
        b=wvRaUkqnGsDO74uZGlYxXkz981fSilNJ2wdYS2Rb1QFskhLdexteffmwlUp3lrFYIF
         fMB2B/FLjWla+qFf/UfiJYQdzsskiuDXJdJe6oqFn9tYnjPUuJcYGBMsoVl8q57SaPQ8
         NPj/soJr1Apa/HNZMDsVs/KMNP/XGO/cWFkVAQiSOpV6oFVnjJtwYFpJD9Wac4LAlPqc
         WIp2eltX8p4xQcrIFXo10MTLdREY4qBsC1fEaM1yAekh1RLjYm35WYw+YoewxplPx4Y5
         yA1485zfrvRyPA//PhZorkBHfDihzPZhJl9LjdJdaiYf76cY4ZfcXZ6Rem+HY86IOCfB
         8NdQ==
X-Gm-Message-State: AOJu0YwSDd3MuKH6h2NJ5ugYVRUXkf7l5I2NWVvDW4GuuRS8PKT8Qyu9
        PdJN+vBx0I1U94S82XSjBEFpUQ==
X-Google-Smtp-Source: AGHT+IHhiEq+XYZSJeznSDREC20CgvswraPa7tPoayDxAcErlDuk9ftDwaxt5kA9sWAFSqmLdihcog==
X-Received: by 2002:a17:907:2cca:b0:9a1:f5b1:c85d with SMTP id hg10-20020a1709072cca00b009a1f5b1c85dmr7833573ejc.12.1694438187002;
        Mon, 11 Sep 2023 06:16:27 -0700 (PDT)
Received: from [192.168.69.115] (tfy62-h01-176-171-221-76.dsl.sta.abo.bbox.fr. [176.171.221.76])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090668c900b0099bcdfff7cbsm5324243ejr.160.2023.09.11.06.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 06:16:26 -0700 (PDT)
Message-ID: <a27ca97f-a8fd-01f0-78d8-8ad7fb31b7d2@linaro.org>
Date:   Mon, 11 Sep 2023 15:16:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH] target/i386: Re-introduce few KVM stubs for Clang debug
 builds
Content-Language: en-US
To:     Kevin Wolf <kwolf@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel@nongnu.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org
References: <20230911103832.23596-1-philmd@linaro.org>
 <CAJSP0QWDcNhso5nNBMNziLSXZczcrGp=6FgGNOXvYEQ6=Giiug@mail.gmail.com>
 <ZP8I9B3O4CTwTTie@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <ZP8I9B3O4CTwTTie@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/23 14:32, Kevin Wolf wrote:
> Am 11.09.2023 um 13:15 hat Stefan Hajnoczi geschrieben:
>> On Mon, 11 Sept 2023 at 06:39, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>>
>>> Since commits 3adce820cf..ef1cf6890f, When building on
>>> a x86 host configured as:
>>>
>>>    $ ./configure --cc=clang \
>>>      --target-list=x86_64-linux-user,x86_64-softmmu \
>>>      --enable-debug
>>>
>>> we get:
>>>
>>>    [71/71] Linking target qemu-x86_64
>>>    FAILED: qemu-x86_64
>>>    /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in function `cpu_x86_cpuid':
>>>    cpu.c:(.text+0x1374): undefined reference to `kvm_arch_get_supported_cpuid'
>>>    /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in function `x86_cpu_filter_features':
>>>    cpu.c:(.text+0x81c2): undefined reference to `kvm_arch_get_supported_cpuid'
>>>    /usr/bin/ld: cpu.c:(.text+0x81da): undefined reference to `kvm_arch_get_supported_cpuid'
>>>    /usr/bin/ld: cpu.c:(.text+0x81f2): undefined reference to `kvm_arch_get_supported_cpuid'
>>>    /usr/bin/ld: cpu.c:(.text+0x820a): undefined reference to `kvm_arch_get_supported_cpuid'
>>>    /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o:cpu.c:(.text+0x8225): more undefined references to `kvm_arch_get_supported_cpuid' follow
>>>    clang: error: linker command failed with exit code 1 (use -v to see invocation)
>>>    ninja: build stopped: subcommand failed.
>>>
>>> '--enable-debug' disables optimizations (CFLAGS=-O0).
>>>
>>> While at this (un)optimization level GCC eliminate the
>>> following dead code:
>>>
>>>    if (0 && foo()) {
>>>        ...
>>>    }
>>>
>>> Clang does not. Therefore restore a pair of stubs for
>>> unoptimized Clang builds.
>>>
>>> Reported-by: Kevin Wolf <kwolf@redhat.com>
>>> Fixes: 3adce820cf ("target/i386: Remove unused KVM stubs")
>>> Fixes: ef1cf6890f ("target/i386: Allow elision of kvm_hv_vpindex_settable()")
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>   target/i386/kvm/kvm_i386.h | 21 ++++++++++++++++++---
>>>   1 file changed, 18 insertions(+), 3 deletions(-)


>>> +#elif defined(__clang__) && !defined(__OPTIMIZE__)
>>
>> Another approach is a static library with a .o file containing the
>> stubs so the linker only includes it in the executable if the compiler
>> emitted the symbols. That way there is no need for defined(__clang__)
>> && !defined(__OPTIMIZE__) and it will work with other
>> compilers/optimization levels. It's more work to set up though.
> 
> Isn't that exactly how it was before the stubs were removed? It would be
> a simple revert of that commit.
> 
> The approach with static inline functions defined only for a very
> specific configuration looks a lot more fragile to me. In fact, I'm
> surprised that it works because I think it requires that the header
> isn't used in any files that are shared between user space and system
> emulation - and naively cpu.c sounded like something that could be
> shared. Looks like this patch only works because the linux-user target
> uses a separate build of the same CPU emulation source file.
> 
> So I think reverting the commit that removed the stubs would be much
> more obvious.

Yes, v2 reverts:
https://lore.kernel.org/qemu-devel/20230911131507.24943-1-philmd@linaro.org/


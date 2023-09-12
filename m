Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C60579D6AC
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 18:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbjILQo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 12:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbjILQo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 12:44:56 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14A910DF
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 09:44:51 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3ff7d73a6feso62074005e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 09:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694537090; x=1695141890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xYzn/3kOKpXxvHMz10ApcHvQSJG8FaIxGybsqApJRpA=;
        b=TUMThmfUX2UewFRi76kP0O9oPDHUjvwk4RnZ8MuPQa+QaFvbCAFOwJr5uyKJGcAd9l
         pAzWtH6M05OXc5+/oGKHxbQOI3lFAGN6KWRVF+PMy74Ov71EPpd8DB7ZWMUC6ojgSG7X
         IDyBBnb+FnoLekydtY6pj5Ni6QmXQJyXTzqNrfjk0DSPCBYiX1utq9YiHQaL5KTE0Psz
         YGgCemGDJUopqfaesoqdzG/rrllPOncgyuG101jt7Oa3aSVG8pQTwf3ddgHveQ9BGKiU
         AeVG38z2y6AnAFn/IsYW/Mta6gHcjcNDP53AshSe6N1Pd2qNJnld8+0ZMkp11xMif3ll
         VQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694537090; x=1695141890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xYzn/3kOKpXxvHMz10ApcHvQSJG8FaIxGybsqApJRpA=;
        b=Zx9EH34MYmsB2Z0p7MHnWqkSGTiTQ2ufeGO5u8loW82bim/UzZueJcvrACnNrUB2CN
         hCn7HayvSe0J/7Hun1XPbqgpTyAzaVMk4Dljm+JeLq8iYlcjcZICvlItgN6qVBNolNlp
         7mf7vRYidJMMQjuQbhBgQiY5OmTn1gNpXK8tmY1hL124keticGz3mjBBo88EbcXbwHwt
         oAkZjJm5OjRvu0PDu1owMgDDqkXqTo6jTVRsvnDO6b0bYq6wwMKsYlQWH11Zf4SeHvMF
         pj6ojO0W4XJXyFLmBhpwoOFdNq08Feh0PnXWHtbZ29S4lNJ8BkdEZUU/4RRva1Q3mICZ
         sHow==
X-Gm-Message-State: AOJu0Yyfjn7gcDVEh4kLmLDXWQm8+wMvDHWJf1DqwHsEhljVS2qjfFfP
        Bw5cnIBjDFj52+OsUuqGtLLp9A==
X-Google-Smtp-Source: AGHT+IH5vub4rBT/vbvswzxQwp1f1tgh1SGV+s0iqZ7V+FINUgCe/yHe8M0v8fp7xIKASp2eOFPd5g==
X-Received: by 2002:a7b:c4cb:0:b0:3fd:30cb:18bd with SMTP id g11-20020a7bc4cb000000b003fd30cb18bdmr12420154wmk.15.1694537090421;
        Tue, 12 Sep 2023 09:44:50 -0700 (PDT)
Received: from [192.168.69.115] (cou50-h01-176-172-50-150.dsl.sta.abo.bbox.fr. [176.172.50.150])
        by smtp.gmail.com with ESMTPSA id l12-20020a1ced0c000000b003fe24441e23sm13498474wmh.24.2023.09.12.09.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 09:44:50 -0700 (PDT)
Message-ID: <111b9277-59b6-7252-6ddd-13edff9b2505@linaro.org>
Date:   Tue, 12 Sep 2023 18:44:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 0/3] target/i386: Restrict system-specific features
 from user emulation
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <20230911211317.28773-1-philmd@linaro.org>
 <fabf2451-e8ad-8171-b583-16b238c578e7@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <fabf2451-e8ad-8171-b583-16b238c578e7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/23 16:07, Paolo Bonzini wrote:
> On 9/11/23 23:13, Philippe Mathieu-Daudé wrote:
>> Too many system-specific code (and in particular KVM related)
>> is pulled in user-only build. This led to adding unjustified
>> stubs as kludge to unagressive linker non-optimizations.
>>
>> This series restrict x86 system-specific features to sysemu,
>> so we don't require any stub, and remove all x86 KVM declarations
>> from user emulation code (to trigger compile failure instead of
>> link one).
>>
>> Philippe Mathieu-Daudé (3):
>>    target/i386: Check kvm_hyperv_expand_features() return value
>>    RFC target/i386: Restrict system-specific features from user emulation
>>    target/i386: Prohibit target specific KVM prototypes on user emulation
> 
> At least, patch 2 should be changed so that the #ifdef'ery is done at a 
> higher level.

I can try to improve it with your comments, but I have no idea of
x86 CPU features.

> However, the dependency of user-mode emulation on KVM is really an 
> implementation detail of QEMU.  It's very much baked into linux-user and 
> hard to remove, but I'm not sure it's a good idea to add more #ifdef 
> CONFIG_USER_ONLY around KVM code.

Do you rather v3 then?

https://lore.kernel.org/qemu-devel/20230911142729.25548-1-philmd@linaro.org/


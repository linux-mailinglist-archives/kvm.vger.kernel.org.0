Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A85B730A0C
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 23:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbjFNV6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 17:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbjFNV6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 17:58:43 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D12268F
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 14:58:42 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f619c2ba18so8980704e87.1
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 14:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1686779920; x=1689371920;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4mTppodWgtd+N5QQd4EikgMCJi4ycN++D1AdAy4k6eM=;
        b=haRhhrUcJbo7Fdc7+eeoCrs3OIRpFQ2blgszgJBn3KJE3T7yXVHzoMgAuSdtHiqz9S
         PTQKBdHn38WshqjtdKjCs2vIMkGTDwNKTsqeFiIg/rVlpPB4zhJLfDti408iEWkWtX2Z
         fMCTVSG7CqLVLg8t7DMXMRglfu6enK1oUVN9hFbYb8M6eSRwglnIv1JgeXXZbT6449wl
         aA6RmDpnrw68J5WWvoqyUK6wm3vCup/VF4QMq62qduLeOC9Z0gLyfyoh4NVBP39eUw26
         k0OyfGKCIMIY8vQKH6ND0XPe4XI2J9LuLaOrTJVCSCO8IV3jc0MH8ubkRgwt3KLpdFfu
         fadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686779920; x=1689371920;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4mTppodWgtd+N5QQd4EikgMCJi4ycN++D1AdAy4k6eM=;
        b=XC8X5YPNoJdYBhcL5ctyAqoE5sAruRJWRy62gzLXLHFhM4FnNj5LES9sFPF6fenpEZ
         IKnKj5yY6jx5SnvtTTngJthFdMkICz/OklYFJHjYfvcOPKrJiKJ19JOxJ2ltQbuu+SJq
         gor9NP7RKkh4Amy212VIUjsr6Erna0qAGdLIveGL3ceROE6PRIzHexU5mukNYyxeeKcJ
         FR4NKOZS6NbAUD2Xh6x7jhnLQjxrXgJfA3z6WSdQVfwAhKmfv3t6b5yh6h/jCdplTN9T
         QDswx5/9x3LbLViB5hz+KFROSP1M2D6Y+4bqcDjZL4z55Tp1ra1g/X+53Jo99s3fTzY4
         e8GA==
X-Gm-Message-State: AC+VfDyrqoV3/wLbCTtxt8kH2dkLwE+jrZ20jC1NW+R9DP3cPWLDY7CM
        i6DTRW3BXyEb9BsCCXtw3d5O+n8O/7Pgb0VM7fA=
X-Google-Smtp-Source: ACHHUZ5oJU1VYt2SGEj5JpdCxFnS+n642GgWf/NjSlFZgjkUCiXzNolB5UtFBj0XSgMBkDsb56vR1Q==
X-Received: by 2002:ac2:4db5:0:b0:4db:964:51b5 with SMTP id h21-20020ac24db5000000b004db096451b5mr7267246lfe.41.1686779920134;
        Wed, 14 Jun 2023 14:58:40 -0700 (PDT)
Received: from ?IPV6:2003:f6:af14:3c00:9650:2efe:173b:4a64? (p200300f6af143c0096502efe173b4a64.dip0.t-ipconnect.de. [2003:f6:af14:3c00:9650:2efe:173b:4a64])
        by smtp.gmail.com with ESMTPSA id o20-20020a170906601400b00977d3fb2a7dsm8460405ejj.76.2023.06.14.14.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 14:58:39 -0700 (PDT)
Message-ID: <fc4155f4-785a-0e72-d807-b2519e1f7509@grsecurity.net>
Date:   Wed, 14 Jun 2023 23:58:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v2 00/16] x86: cleanups, fixes and new
 tests
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20230413184219.36404-1-minipli@grsecurity.net>
 <168668855812.1968967.9918672463130718790.b4-ty@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <168668855812.1968967.9918672463130718790.b4-ty@google.com>
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

On 13.06.23 23:40, Sean Christopherson wrote:
> On Thu, 13 Apr 2023 20:42:03 +0200, Mathias Krause wrote:
>> v1: https://lore.kernel.org/kvm/b6322bd0-3639-fb2a-7211-974386865bac@grsecurity.net/
>>
>> This is v2 of the "non-canonical memory access" test. It evolved into a
>> small series, bringing cleanups and fixes along the way.
>>
>> I integrated Sean's feedback and changed the test to make use of
>> ASM_TRY() instead of using the hand-rolled exception handler. I also
>> switched all other users in emulator64.c to ASM_TRY() and was able to
>> drop the one-off exception handler all together.
>>
>> [...]
> 
> Applied everything except the code label change to kvm-x86 next.  I replied to
> that specific patch, feel free to follow-up there.

I did, but I have no strong opinion on getting it merged. It's just the
coding style I'm used to. If KUT's different, then that be it.

> 
> I tweaked "x86/run_in_user: Reload SS after successful return" to use an "rm"
> constraint instead of hardcoding use of AX, holler if that's wrong for some
> reason.  I'm planning on sending a pull request later this week, so you've got
> a few days to object.

I used "i" as a constraint as that's what KERNEL_DS really is: an
integer constant. But I can see that the stunt of actually loading %ss
without clobbering a register isn't all that nice looking. I used (R)AX
specifically as that avoids allocating yet another register for this ASM
block. However, there are still enough left and the stack pointer is
already restored at that point so using "rm" instead should be fine.

Just noticed that the constraints for 'rax' should be "=&a" instead of
"+a" as the ASM doesn't care about its initial value, just needs to
prevent the compiler from allocating AX for any of the input register
variables. But that can be a separate cleanup.

> 
> Thanks a ton for the cleanups!
> 
> [01/16] x86: Drop types.h
>         https://github.com/kvm-x86/kvm-unit-tests/commit/0452fa5aecea
> [02/16] x86: Use symbolic names in exception_mnemonic()
>         https://github.com/kvm-x86/kvm-unit-tests/commit/8cfb268d401b
> [03/16] x86: Add vendor specific exception vectors
>         https://github.com/kvm-x86/kvm-unit-tests/commit/f224dba008df
> [04/16] x86/cet: Use symbolic name for #CP
>         https://github.com/kvm-x86/kvm-unit-tests/commit/00d585d8731b
> [05/16] x86/access: Use 'bool' type as defined via libcflat.h
>         https://github.com/kvm-x86/kvm-unit-tests/commit/c304eda6ae7f
> [06/16] x86/run_in_user: Change type of code label
> 	DID NOT APPLY
> [07/16] x86/run_in_user: Preserve exception handler
>         https://github.com/kvm-x86/kvm-unit-tests/commit/d0ef95181cfb
> [08/16] x86/run_in_user: Relax register constraints of inline asm
>         https://github.com/kvm-x86/kvm-unit-tests/commit/45bafaf28fbb
> [09/16] x86/run_in_user: Reload SS after successful return
>         https://github.com/kvm-x86/kvm-unit-tests/commit/8338209b8245
> [10/16] x86/fault_test: Preserve exception handler
>         https://github.com/kvm-x86/kvm-unit-tests/commit/11aac640d01b
> [11/16] x86/emulator64: Relax register constraints for usr_gs_mov()
>         https://github.com/kvm-x86/kvm-unit-tests/commit/c66547850058
> [12/16] x86/emulator64: Switch test_sreg() to ASM_TRY()
>         https://github.com/kvm-x86/kvm-unit-tests/commit/9d74b31d1c81
> [13/16] x86/emulator64: Add non-null selector test
>         https://github.com/kvm-x86/kvm-unit-tests/commit/23c647d0ef29
> [14/16] x86/emulator64: Switch test_jmp_noncanonical() to ASM_TRY()
>         https://github.com/kvm-x86/kvm-unit-tests/commit/ac4f843474b4
> [15/16] x86/emulator64: Switch test_mmx_movq_mf() to ASM_TRY()
>         https://github.com/kvm-x86/kvm-unit-tests/commit/5a3515ea1bc2
> [16/16] x86/emulator64: Test non-canonical memory access exceptions
>         https://github.com/kvm-x86/kvm-unit-tests/commit/e3a9b2f5490e

Thanks,
Mathias

> 
> --
> https://github.com/kvm-x86/kvm-unit-tests/tree/next

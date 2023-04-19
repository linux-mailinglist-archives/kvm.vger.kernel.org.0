Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DF66E7E18
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 17:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbjDSPU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 11:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbjDSPUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 11:20:03 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A819FB754
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:19:31 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b73203e0aso16868815b3a.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1681917515; x=1684509515;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXO4Ni/kSG0H+ktMq4uVlmS1jzHn6kSPNbg8TaaS/64=;
        b=I4jQQN9eouwrtidT/DUB5WkdlKm7L9khwPMcUJauiyf8rJBlAame3Q6t26oPRiuSir
         V3NyYYQfjijqMtyz4ev2S1hLM+LwD+YrOUp2rTORUxgdnYFZWTCnXzqi0qurWwdWpAJX
         ferp2EQ10dVH3l6PH+pe0zSyJusaWqAVsodVenXc7KIql+/i8ytrAGSr+57wYwsRlH/k
         J627seCPgxf2b+o7lKaElPnIF/3SZHvf0nQbzYndGZeaNYzcTo0aiJj+u9mxtoxu0QF1
         YXmqCEBnVVBulUo18BOb3Uflq2ruhl3mE8lgHWtUtv48MIffji2W9NZh4wDSryamlC3T
         5CLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917515; x=1684509515;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXO4Ni/kSG0H+ktMq4uVlmS1jzHn6kSPNbg8TaaS/64=;
        b=UJS5B3WZE7KIXyZr0b71N62/bdPjtS1l1Dk3kmPoh4C8m50bgMWuIE2zIDc0Fe01nv
         c11I/U1A8si0bqq1uEAVL4QIJobbgdHFmdZxfaiiGiziDmZ4QxTzI454KzyF7Do/jL32
         uFhAsLxkxBiZBcY1QkExSDN6dbWABqiYzAFL+3of5X8ChkbJnVQm+kMfDLihkZVgQ52j
         Gy7uVXThmcDyX9547JJv5aYluOZsdeV1IuSe18S6nf1bQHF293dAwBeOzW6PeELa8xMr
         +kimWNu/bbGcgJ5kOxejMyQV0s2ARKJBwe5ojdabhRnOJ3ptHeIBCq13hb2V+vljODbL
         1NwA==
X-Gm-Message-State: AAQBX9dkAXc/wsM1C1s4gRvCVt+kRY/+nL+LSLZMnw/1FBRUBmfwxDZ4
        6ktVWl14wItWHr59A6pzi8VlBA==
X-Google-Smtp-Source: AKy350bZnV7c2T9bRz1wthVAe/bP3QzgvRgK4ReNB5NaaqF8YhlO6cXRmlyQ+YeTPBpXOFLIQygKdQ==
X-Received: by 2002:a17:902:e742:b0:1a1:a727:a802 with SMTP id p2-20020a170902e74200b001a1a727a802mr3393492plf.19.1681917514986;
        Wed, 19 Apr 2023 08:18:34 -0700 (PDT)
Received: from localhost ([135.180.227.0])
        by smtp.gmail.com with ESMTPSA id o4-20020a655bc4000000b0051b9e82d6d6sm6299141pgr.40.2023.04.19.08.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 08:18:34 -0700 (PDT)
Date:   Wed, 19 Apr 2023 08:18:34 -0700 (PDT)
X-Google-Original-Date: Wed, 19 Apr 2023 08:17:54 PDT (-0700)
Subject:     Re: [PATCH -next v18 00/20] riscv: Add vector ISA support
In-Reply-To: <87leinq5wg.fsf@all.your.base.are.belong.to.us>
CC:     andy.chiu@sifive.com, linux-riscv@lists.infradead.org,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        libc-alpha@sourceware.org, Andrew Waterman <andrew@sifive.com>
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     bjorn@kernel.org
Message-ID: <mhng-607b5023-8f07-4a82-b292-35078123e9e8@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Apr 2023 07:54:23 PDT (-0700), bjorn@kernel.org wrote:
> Björn Töpel <bjorn@kernel.org> writes:
>
>> Andy Chiu <andy.chiu@sifive.com> writes:
>>
>>> This patchset is implemented based on vector 1.0 spec to add vector support
>>> in riscv Linux kernel. There are some assumptions for this implementations.
>>>
>>> 1. We assume all harts has the same ISA in the system.
>>> 2. We disable vector in both kernel and user space [1] by default. Only
>>>    enable an user's vector after an illegal instruction trap where it
>>>    actually starts executing vector (the first-use trap [2]).
>>> 3. We detect "riscv,isa" to determine whether vector is support or not.
>>>
>>> We defined a new structure __riscv_v_ext_state in struct thread_struct to
>>> save/restore the vector related registers. It is used for both kernel space
>>> and user space.
>>>  - In kernel space, the datap pointer in __riscv_v_ext_state will be
>>>    allocated to save vector registers.
>>>  - In user space,
>>> 	- In signal handler of user space, the structure is placed
>>> 	  right after __riscv_ctx_hdr, which is embedded in fp reserved
>>> 	  aera. This is required to avoid ABI break [2]. And datap points
>>> 	  to the end of __riscv_v_ext_state.
>>> 	- In ptrace, the data will be put in ubuf in which we use
>>> 	  riscv_vr_get()/riscv_vr_set() to get or set the
>>> 	  __riscv_v_ext_state data structure from/to it, datap pointer
>>> 	  would be zeroed and vector registers will be copied to the
>>> 	  address right after the __riscv_v_ext_state structure in ubuf.
>>>
>>> This patchset is rebased to v6.3-rc1 and it is tested by running several
>>> vector programs simultaneously. It delivers signals correctly in a test
>>> where we can see a valid ucontext_t in a signal handler, and a correct V
>>> context returing back from it. And the ptrace interface is tested by
>>> PTRACE_{GET,SET}REGSET. Lastly, KVM is tested by running above tests in
>>> a guest using the same kernel image. All tests are done on an rv64gcv
>>> virt QEMU.
>>>
>>> Note: please apply the patch at [4] due to a regression introduced by
>>> commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
>>> optimizations") before testing the series.
>>>
>>> Source tree:
>>> https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v18
>>
>> After some offlist discussions, we might have a identified a
>> potential libc->application ABI break.
>>
>> Given an application that does custom task scheduling via a signal
>> handler. The application binary is not vector aware, but libc is. Libc
>> is using vector registers for memcpy. It's an "old application, new
>> library, new kernel"-scenario.
>>
>>  | ...
>>  | struct context *p1_ctx;
>>  | struct context *p2_ctx;
>>  | 
>>  | void sighandler(int sig, siginfo_t *info, void *ucontext)
>>  | {
>>  |   if (p1_running)
>>  |     switch_to(p1_ctx, p2_ctx);
>>  |   if (p2_running)
>>  |     switch_to(p2_ctx, p1_ctx);
>>  | }
>>  | 
>>  | void p1(void)
>>  | {
>>  |   memcpy(foo, bar, 17);
>>  | }
>>  | 
>>  | void p2(void)
>>  | {
>>  |   ...
>>  | }
>>  | ...
>>
>> The switch_to() function schedules p1() and p2(). E.g., the
>> application (assumes that it) saves the complete task state from
>> sigcontext (ucontext) to p1_ctx, and restores sigcontext to p2_ctx, so
>> when sigreturn is called, p2() is running, and p1() has been
>> interrupted.
>>
>> The "old application" which is not aware of vector, is now run on a
>> vector enabled kernel/glibc.
>>
>> Assume that the sighandler is hit, and p1() is in the middle of the
>> vector memcpy. The switch_to() function will not save the vector
>> state, and next time p2() is scheduled to run it will have incorrect
>> machine state.

Thanks for writing this up, and sorry I've dropped the ball a few times on
describing it.

>> Now:
>>
>> Is this an actual or theoretical problem (i.e. are there any
>> applications in the wild)? I'd be surprised if it would not be the
>> latter...

I also have no idea.  It's kind of odd to say "nobody cares about the 
ABI break" when we can manifest it with some fairly simple example, but 
I'd bet that nobody cares.

>> Regardless, a kernel knob for disabling vector (sysctl/prctl) to avoid
>> these kind of breaks is needed (right?). Could this knob be a
>> follow-up patch to the existing v18 series?
>>
>> Note that arm64 does not suffer from this with SVE, because the default
>> vector length (vl==0/128b*32) fits in the "legacy" sigcontext.
>
> Andy, to clarify from the patchwork call; In
> Documentation/arm64/sve.rst:
>
> There's a per-process prctl (section 6), and a system runtime conf
> (section 9).

I think if we want to play it safe WRT the ABI break, then we can 
essentially just do the same thing.  It'll be a much bigger cliff for us 
because we have no space for the V extension, but that was just a 
mistake and there's nothing we can do about it.

> Björn

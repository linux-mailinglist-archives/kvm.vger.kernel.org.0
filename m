Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6974D6EF666
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbjDZO16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241085AbjDZO1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:27:53 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F36C729B
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 07:27:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b4dfead1bso5980580b3a.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 07:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1682519271; x=1685111271;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NnfrgNZHQvPmGsQGCQ2h4V9BhDAlSy+A6A7k8SbgA24=;
        b=eOpmq+GDGamx4114B5EpekL4Oyi6BpGcYrLG1ZLSFRd4iz8TxkNUVd5310VpiQN8so
         n2FRk0eoE22cOOzY42nRIC0Ls2ePljs55GZZX6ZpVEFGXiU6aLZbWi08I2s/h+3sxJbu
         zU1S20zF71gDp+Vl44usUB7GoiVTUOXjRsRkbbTxz8EEpUBJHT3csZJMD6sUxPYrvrpN
         tPh10UXow658hfYWRzpaBI7LZW+ANBIOhmPR5ItdcdeeqtH6d9bc1j5X+aCxGzr3WYBQ
         8HsiUQw9f8lAHIIq/a7Q5+DaYHiuDYnWgcQ4mCoXBFWei2RhShL9Do8AK88Mvz/rBW4V
         1gCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682519271; x=1685111271;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NnfrgNZHQvPmGsQGCQ2h4V9BhDAlSy+A6A7k8SbgA24=;
        b=aSECKwsHzsdeYWz9+h5hIlFxWYx0zrNDgQNW3u64bXbQvfCwnnyQSIwHcAAuHuTbNS
         vQJakLNwn9xGGUj5gC4Q9V1mwIiK0HfaS+Po5P/OaLsoRn+zsdTnyI3AhM+4buCynt+b
         eutzfP6ojN7i9d6Ej9lYsEBWNBZCXMVfg1PiN+rr6Y6NvUKr6nFPs+lFbRicrqGVpFnj
         CyakY3Wmjaxy6sTO2lSi2CW8ACXuOxqwpQt+zKyDuHkjjQqVQsTUw6hO00xkaeSKocX+
         38au77AmTww3xpzZOAW7vOO5+XkY3ZqgjRfGdA+Fj8td1V9jl6GyP/Tx3lhqxe7gjt/0
         fzIw==
X-Gm-Message-State: AAQBX9d+Qb4VvqGjkgXmiZhrBN1QD53j2Qm06Oqo9lGuUpeFNWgbgh3j
        xzbPaxTIhF4nWRzcKCePcHyJvQJJRZ9uMOmOMmA=
X-Google-Smtp-Source: AKy350ZzkeDiV+RuULlH10ymkq/hl2JydbrghBEvMXstloracVB3tARE2D82tPElpB2dnMeA0GpyZw==
X-Received: by 2002:a05:6a00:1a86:b0:63b:62d1:d868 with SMTP id e6-20020a056a001a8600b0063b62d1d868mr27658451pfv.8.1682519270628;
        Wed, 26 Apr 2023 07:27:50 -0700 (PDT)
Received: from localhost ([135.180.227.0])
        by smtp.gmail.com with ESMTPSA id k16-20020aa788d0000000b00625616f59a1sm10964994pff.73.2023.04.26.07.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 07:27:50 -0700 (PDT)
Date:   Wed, 26 Apr 2023 07:27:50 -0700 (PDT)
X-Google-Original-Date: Wed, 26 Apr 2023 07:27:45 PDT (-0700)
Subject:     Re: [PATCH -next v18 00/20] riscv: Add vector ISA support
In-Reply-To: <CABgGipWbSFnAK=DwT9X2esPBVTi0p+Oft1NyWbZ60LOwHj4dgA@mail.gmail.com>
CC:     bjorn@kernel.org, linux-riscv@lists.infradead.org,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        libc-alpha@sourceware.org, Andrew Waterman <andrew@sifive.com>
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-47aa965a-2b25-4ac0-984a-c2e6f3a051ee@palmer-ri-x1c9>
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

On Thu, 20 Apr 2023 09:36:48 PDT (-0700), andy.chiu@sifive.com wrote:
> On Wed, Apr 19, 2023 at 11:18 PM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>
>> On Wed, 19 Apr 2023 07:54:23 PDT (-0700), bjorn@kernel.org wrote:
>> > Björn Töpel <bjorn@kernel.org> writes:
>> >
>> >> Andy Chiu <andy.chiu@sifive.com> writes:
>> >>
>> >>> This patchset is implemented based on vector 1.0 spec to add vector support
>> >>> in riscv Linux kernel. There are some assumptions for this implementations.
>> >>>
>> >>> 1. We assume all harts has the same ISA in the system.
>> >>> 2. We disable vector in both kernel and user space [1] by default. Only
>> >>>    enable an user's vector after an illegal instruction trap where it
>> >>>    actually starts executing vector (the first-use trap [2]).
>> >>> 3. We detect "riscv,isa" to determine whether vector is support or not.
>> >>>
>> >>> We defined a new structure __riscv_v_ext_state in struct thread_struct to
>> >>> save/restore the vector related registers. It is used for both kernel space
>> >>> and user space.
>> >>>  - In kernel space, the datap pointer in __riscv_v_ext_state will be
>> >>>    allocated to save vector registers.
>> >>>  - In user space,
>> >>>     - In signal handler of user space, the structure is placed
>> >>>       right after __riscv_ctx_hdr, which is embedded in fp reserved
>> >>>       aera. This is required to avoid ABI break [2]. And datap points
>> >>>       to the end of __riscv_v_ext_state.
>> >>>     - In ptrace, the data will be put in ubuf in which we use
>> >>>       riscv_vr_get()/riscv_vr_set() to get or set the
>> >>>       __riscv_v_ext_state data structure from/to it, datap pointer
>> >>>       would be zeroed and vector registers will be copied to the
>> >>>       address right after the __riscv_v_ext_state structure in ubuf.
>> >>>
>> >>> This patchset is rebased to v6.3-rc1 and it is tested by running several
>> >>> vector programs simultaneously. It delivers signals correctly in a test
>> >>> where we can see a valid ucontext_t in a signal handler, and a correct V
>> >>> context returing back from it. And the ptrace interface is tested by
>> >>> PTRACE_{GET,SET}REGSET. Lastly, KVM is tested by running above tests in
>> >>> a guest using the same kernel image. All tests are done on an rv64gcv
>> >>> virt QEMU.
>> >>>
>> >>> Note: please apply the patch at [4] due to a regression introduced by
>> >>> commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
>> >>> optimizations") before testing the series.
>> >>>
>> >>> Source tree:
>> >>> https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v18
>> >>
>> >> After some offlist discussions, we might have a identified a
>> >> potential libc->application ABI break.
>> >>
>> >> Given an application that does custom task scheduling via a signal
>> >> handler. The application binary is not vector aware, but libc is. Libc
>> >> is using vector registers for memcpy. It's an "old application, new
>> >> library, new kernel"-scenario.
>> >>
>> >>  | ...
>> >>  | struct context *p1_ctx;
>> >>  | struct context *p2_ctx;
>> >>  |
>> >>  | void sighandler(int sig, siginfo_t *info, void *ucontext)
>> >>  | {
>> >>  |   if (p1_running)
>> >>  |     switch_to(p1_ctx, p2_ctx);
>> >>  |   if (p2_running)
>> >>  |     switch_to(p2_ctx, p1_ctx);
>> >>  | }
>> >>  |
>> >>  | void p1(void)
>> >>  | {
>> >>  |   memcpy(foo, bar, 17);
>> >>  | }
>> >>  |
>> >>  | void p2(void)
>> >>  | {
>> >>  |   ...
>> >>  | }
>> >>  | ...
>> >>
>> >> The switch_to() function schedules p1() and p2(). E.g., the
>> >> application (assumes that it) saves the complete task state from
>> >> sigcontext (ucontext) to p1_ctx, and restores sigcontext to p2_ctx, so
>> >> when sigreturn is called, p2() is running, and p1() has been
>> >> interrupted.
>> >>
>> >> The "old application" which is not aware of vector, is now run on a
>> >> vector enabled kernel/glibc.
>> >>
>> >> Assume that the sighandler is hit, and p1() is in the middle of the
>> >> vector memcpy. The switch_to() function will not save the vector
>> >> state, and next time p2() is scheduled to run it will have incorrect
>> >> machine state.
>>
>> Thanks for writing this up, and sorry I've dropped the ball a few times on
>> describing it.
>>
>> >> Now:
>> >>
>> >> Is this an actual or theoretical problem (i.e. are there any
>> >> applications in the wild)? I'd be surprised if it would not be the
>> >> latter...
>>
>> I also have no idea.  It's kind of odd to say "nobody cares about the
>> ABI break" when we can manifest it with some fairly simple example, but
>> I'd bet that nobody cares.
>>
>> >> Regardless, a kernel knob for disabling vector (sysctl/prctl) to avoid
>> >> these kind of breaks is needed (right?). Could this knob be a
>> >> follow-up patch to the existing v18 series?
>> >>
>> >> Note that arm64 does not suffer from this with SVE, because the default
>> >> vector length (vl==0/128b*32) fits in the "legacy" sigcontext.
>> >
>> > Andy, to clarify from the patchwork call; In
>> > Documentation/arm64/sve.rst:
>> >
>> > There's a per-process prctl (section 6), and a system runtime conf
>> > (section 9).
>
> Thanks for pointing me out!
>
>>
>> I think if we want to play it safe WRT the ABI break, then we can
>> essentially just do the same thing.  It'll be a much bigger cliff for us
>> because we have no space for the V extension, but that was just a
>> mistake and there's nothing we can do about it.
>
> I understand the concern. It is good to provide a way to have explicit
> controls of Vector rather than do nothing if such ABI break happens.
> As for implementation details, do you think a system-wide  sysctl
> alone is enough? Or, do we also need a prctl for per-process control?

A few of us were talking in the patchwork meeting.  It's kind of a grey 
area here, but we're just going to play it safe and wait for the 
prctl and sys interfaces to show up before merging this.

I know it's a pain to have to wait another release, but there's still no 
publicly availiable V hardware yet so waiting isn't concretely impacting 
users right now.  If we flip on V now we probably won't get a ton of 
testing, so we risk the ABI break sticking around for a few release 
which would be a huge headache.

Andy said he'd be able to do the prtcl and sys interfaces pretty 
quickly, so hopfully everything's lined up for the next release.

>> > Björn

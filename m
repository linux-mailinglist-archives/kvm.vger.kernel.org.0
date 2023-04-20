Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621156E99A8
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 18:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbjDTQhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 12:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjDTQhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 12:37:04 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BB3192
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 09:37:01 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id z38so3429396ljq.12
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 09:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1682008620; x=1684600620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GaoOElEQ0goOV5AcB9fTNnR/4qFK40qSxrlBrcvfN5Y=;
        b=CV7+QEiz/91/5eLG1KsECNXNMCvTFnLjPK7KbXXAMVmEiW8DYf2xWYcDmVRMvTdOAW
         oSos0+eCkdCS6HuIjKQT3gEanvT5ABpuPIa5g8r4sTZSGahJSdO1vd16NENHnybpDtiX
         wW2Uc/5y3RsAtVx/iI2ZajRUgCdrRBjgziesG3AZRjRXqTfA2oFBt8e7ayONkK1x1Soe
         bGtqQPGW2w+Ek8bBkSb2b1pfvesC0F+WBWck8051pddoZhDrtH8PZBvfBoUSf4PICZsR
         1stj+KZA66+r0K5faUYmbXktnOepv/cUBuroI5B7cmjaiit5CmIQAf7MUOsRfebX+A2J
         4UuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682008620; x=1684600620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GaoOElEQ0goOV5AcB9fTNnR/4qFK40qSxrlBrcvfN5Y=;
        b=DdfvdkozLNi3c4rNCwOAmgWpLQUdkXTiMoY+vOV/CZ0EFmZDoYk3yiEV9LQZhsW7HL
         4dFShq3WzZ9GdwaWfk8zwFQhdD/bR/gV1LXJB1UBqjwvcuFII6W57dSVqDvRKhyZID8z
         JD6QVNUeA9kWag/TpUWEHcptdYDHhED55zqwtfv50JGKr9/vcMYzJYvSkMvRpbVSl9zm
         jY2lxdAXTSrpZlhqc8tKomfUa/Hulu9L2p025eJR56TYjT1EhkqI7agOAn03eDeoMP6f
         Lz1MxnsCkclqJrhrHxbEsbNXTozx2IO1R7wjcRHt/39eQsx/zPyNb8SZVr0GeQNozoAk
         4GLQ==
X-Gm-Message-State: AAQBX9eyFBFLNTqP0RNt1/Ee7iQaRLW0InWkwxR4cP7TMR/jJ88U86+s
        n6fOaq/n0hBY8pn9JCUmibCPv1pU2dZii0GcLkuNlw==
X-Google-Smtp-Source: AKy350Y/gCfruOP47zfXMzbSrGhfLdIMZSMEbrN+QX7vMyYfd5JW9/Vs/H3jmgt9AW7Bu0mWwJ7OZZMykmdImfvJGxg=
X-Received: by 2002:a2e:9c4d:0:b0:2a7:8606:7448 with SMTP id
 t13-20020a2e9c4d000000b002a786067448mr569407ljj.0.1682008619777; Thu, 20 Apr
 2023 09:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <87leinq5wg.fsf@all.your.base.are.belong.to.us> <mhng-607b5023-8f07-4a82-b292-35078123e9e8@palmer-ri-x1c9>
In-Reply-To: <mhng-607b5023-8f07-4a82-b292-35078123e9e8@palmer-ri-x1c9>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Fri, 21 Apr 2023 00:36:48 +0800
Message-ID: <CABgGipWbSFnAK=DwT9X2esPBVTi0p+Oft1NyWbZ60LOwHj4dgA@mail.gmail.com>
Subject: Re: [PATCH -next v18 00/20] riscv: Add vector ISA support
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     bjorn@kernel.org, linux-riscv@lists.infradead.org,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        libc-alpha@sourceware.org, Andrew Waterman <andrew@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 11:18=E2=80=AFPM Palmer Dabbelt <palmer@dabbelt.com=
> wrote:
>
> On Wed, 19 Apr 2023 07:54:23 PDT (-0700), bjorn@kernel.org wrote:
> > Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> writes:
> >
> >> Andy Chiu <andy.chiu@sifive.com> writes:
> >>
> >>> This patchset is implemented based on vector 1.0 spec to add vector s=
upport
> >>> in riscv Linux kernel. There are some assumptions for this implementa=
tions.
> >>>
> >>> 1. We assume all harts has the same ISA in the system.
> >>> 2. We disable vector in both kernel and user space [1] by default. On=
ly
> >>>    enable an user's vector after an illegal instruction trap where it
> >>>    actually starts executing vector (the first-use trap [2]).
> >>> 3. We detect "riscv,isa" to determine whether vector is support or no=
t.
> >>>
> >>> We defined a new structure __riscv_v_ext_state in struct thread_struc=
t to
> >>> save/restore the vector related registers. It is used for both kernel=
 space
> >>> and user space.
> >>>  - In kernel space, the datap pointer in __riscv_v_ext_state will be
> >>>    allocated to save vector registers.
> >>>  - In user space,
> >>>     - In signal handler of user space, the structure is placed
> >>>       right after __riscv_ctx_hdr, which is embedded in fp reserved
> >>>       aera. This is required to avoid ABI break [2]. And datap points
> >>>       to the end of __riscv_v_ext_state.
> >>>     - In ptrace, the data will be put in ubuf in which we use
> >>>       riscv_vr_get()/riscv_vr_set() to get or set the
> >>>       __riscv_v_ext_state data structure from/to it, datap pointer
> >>>       would be zeroed and vector registers will be copied to the
> >>>       address right after the __riscv_v_ext_state structure in ubuf.
> >>>
> >>> This patchset is rebased to v6.3-rc1 and it is tested by running seve=
ral
> >>> vector programs simultaneously. It delivers signals correctly in a te=
st
> >>> where we can see a valid ucontext_t in a signal handler, and a correc=
t V
> >>> context returing back from it. And the ptrace interface is tested by
> >>> PTRACE_{GET,SET}REGSET. Lastly, KVM is tested by running above tests =
in
> >>> a guest using the same kernel image. All tests are done on an rv64gcv
> >>> virt QEMU.
> >>>
> >>> Note: please apply the patch at [4] due to a regression introduced by
> >>> commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> >>> optimizations") before testing the series.
> >>>
> >>> Source tree:
> >>> https://github.com/sifive/riscv-linux/tree/riscv/for-next/vector-v18
> >>
> >> After some offlist discussions, we might have a identified a
> >> potential libc->application ABI break.
> >>
> >> Given an application that does custom task scheduling via a signal
> >> handler. The application binary is not vector aware, but libc is. Libc
> >> is using vector registers for memcpy. It's an "old application, new
> >> library, new kernel"-scenario.
> >>
> >>  | ...
> >>  | struct context *p1_ctx;
> >>  | struct context *p2_ctx;
> >>  |
> >>  | void sighandler(int sig, siginfo_t *info, void *ucontext)
> >>  | {
> >>  |   if (p1_running)
> >>  |     switch_to(p1_ctx, p2_ctx);
> >>  |   if (p2_running)
> >>  |     switch_to(p2_ctx, p1_ctx);
> >>  | }
> >>  |
> >>  | void p1(void)
> >>  | {
> >>  |   memcpy(foo, bar, 17);
> >>  | }
> >>  |
> >>  | void p2(void)
> >>  | {
> >>  |   ...
> >>  | }
> >>  | ...
> >>
> >> The switch_to() function schedules p1() and p2(). E.g., the
> >> application (assumes that it) saves the complete task state from
> >> sigcontext (ucontext) to p1_ctx, and restores sigcontext to p2_ctx, so
> >> when sigreturn is called, p2() is running, and p1() has been
> >> interrupted.
> >>
> >> The "old application" which is not aware of vector, is now run on a
> >> vector enabled kernel/glibc.
> >>
> >> Assume that the sighandler is hit, and p1() is in the middle of the
> >> vector memcpy. The switch_to() function will not save the vector
> >> state, and next time p2() is scheduled to run it will have incorrect
> >> machine state.
>
> Thanks for writing this up, and sorry I've dropped the ball a few times o=
n
> describing it.
>
> >> Now:
> >>
> >> Is this an actual or theoretical problem (i.e. are there any
> >> applications in the wild)? I'd be surprised if it would not be the
> >> latter...
>
> I also have no idea.  It's kind of odd to say "nobody cares about the
> ABI break" when we can manifest it with some fairly simple example, but
> I'd bet that nobody cares.
>
> >> Regardless, a kernel knob for disabling vector (sysctl/prctl) to avoid
> >> these kind of breaks is needed (right?). Could this knob be a
> >> follow-up patch to the existing v18 series?
> >>
> >> Note that arm64 does not suffer from this with SVE, because the defaul=
t
> >> vector length (vl=3D=3D0/128b*32) fits in the "legacy" sigcontext.
> >
> > Andy, to clarify from the patchwork call; In
> > Documentation/arm64/sve.rst:
> >
> > There's a per-process prctl (section 6), and a system runtime conf
> > (section 9).

Thanks for pointing me out!

>
> I think if we want to play it safe WRT the ABI break, then we can
> essentially just do the same thing.  It'll be a much bigger cliff for us
> because we have no space for the V extension, but that was just a
> mistake and there's nothing we can do about it.

I understand the concern. It is good to provide a way to have explicit
controls of Vector rather than do nothing if such ABI break happens.
As for implementation details, do you think a system-wide  sysctl
alone is enough? Or, do we also need a prctl for per-process control?

>
> > Bj=C3=B6rn

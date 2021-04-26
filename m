Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D7536B512
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhDZOkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbhDZOke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 10:40:34 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D79AC061574
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 07:39:52 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s15so66048351edd.4
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 07:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TasOpdV2QbBVNkMlotlhlLPBOUS2Vop9szkPM49qAY=;
        b=thW2vdceLhzUIgEw1H/1hv/gzDl6T/P2MOTikzUgqGq/6T29bk+8EDK/m0E9wKx3lZ
         gf/PZdZdd9xcndI8fghbyf7wqpZ/3airdtVSX/f4OolLb3RLdEIGshqTtzDvTs/SMJPS
         FA1n7mf85KyPCnLpAPiGlAew1biSvBJlOQiLGRyo7Hskoqz97bkPpx3lqN6c+mUqaXRH
         VOxSrm85Wu2x/xJ+YNEvNks8cWXUmcZb+yCScxzYoiC37h+KjBeaYkwK+zasekDzwpvM
         WCC+s3Cu7sNlYNg7W7MXEP7JTkCRnDG08wpG63P3iLvEtAXGCnL7sX5tS1uvIM7ddXp1
         SWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TasOpdV2QbBVNkMlotlhlLPBOUS2Vop9szkPM49qAY=;
        b=EKpK4KZe6YARbaU9Pze2g9rhTD+Z5R+mu7MXIYqkVg3IJHlRLWeLZeXLcoEqnLQnJc
         EJpkzPRXAfGrRP4HXjLCE+2FH0cELSklG75iw09tyRnDd51aRG4iX0iUAnJK2sMNJlpB
         R4XtJDiKlXB0TRfCSIjBQb/K5y2VsJK//rnCqpLNeTN7iTFL3kdZsyTJ0FZtOeBEffZd
         BdrtvNcGyv5zx0TurNlp3fNTqd/sws6U29IOY6KNdXo5n5gLgp04gsixVnYRJMF+S41N
         GOnKb5cMdSqyQnr28nnKldhZPdz9zm59yePt4AbF/0MWZjJwxxUnujYIV+idKvffgivz
         xCnw==
X-Gm-Message-State: AOAM532Ko+SowL4Ys1he6keC+Xt/jTC9yBAV5KsTDnvP2jvGowLHr4J1
        WRQ2fkIseSPzDAOgyK8jUh9+p15l1mPHpba80si7SA==
X-Google-Smtp-Source: ABdhPJwgz6I7IbKzxCmvdXw0+gfQSTn7Wl077lqeMK0y353RJgh8nGaXMnOlhRchuT5S+cSS99I4qgSQW5PKrZvpyLs=
X-Received: by 2002:aa7:d1d9:: with SMTP id g25mr14231981edp.30.1619447991042;
 Mon, 26 Apr 2021 07:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210421162225.3924641-1-aaronlewis@google.com>
 <20210421162225.3924641-2-aaronlewis@google.com> <CALMp9eRHpBd96j3ZFkoeabCbwUbTzkaP2+OnxNyN7TLOa=myig@mail.gmail.com>
In-Reply-To: <CALMp9eRHpBd96j3ZFkoeabCbwUbTzkaP2+OnxNyN7TLOa=myig@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 26 Apr 2021 07:39:40 -0700
Message-ID: <CAAAPnDE2J=cnwtuYUkdSx=gx5k_e3GTzqqGBFM81+VgJCuZNMQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selftests: kvm: Allows userspace to handle
 emulation errors.
To:     Jim Mattson <jmattson@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +static void process_exit_on_emulation_error(struct kvm_vm *vm)
> > +{
> > +       struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> > +       struct kvm_regs regs;
> > +       uint8_t *insn_bytes;
> > +       uint8_t insn_size;
> > +       uint64_t flags;
> > +
> > +       TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
> > +                   "Unexpected exit reason: %u (%s)",
> > +                   run->exit_reason,
> > +                   exit_reason_str(run->exit_reason));
> > +
> > +       TEST_ASSERT(run->emulation_failure.suberror == KVM_INTERNAL_ERROR_EMULATION,
> > +                   "Unexpected suberror: %u",
> > +                   run->emulation_failure.suberror);
> > +
> > +       if (run->emulation_failure.ndata >= 1) {
> > +               flags = run->emulation_failure.flags;
> > +               if ((flags & KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES) &&
> > +                   run->emulation_failure.ndata >= 3) {
> > +                       insn_size = run->emulation_failure.insn_size;
> > +                       insn_bytes = run->emulation_failure.insn_bytes;
> > +
> > +                       TEST_ASSERT(insn_size <= 15 && insn_size > 0,
> > +                                   "Unexpected instruction size: %u",
> > +                                   insn_size);
> > +
> > +                       TEST_ASSERT(is_flds(insn_bytes, insn_size),
> > +                                   "Unexpected instruction.  Expected 'flds' (0xd9 /0), encountered (0x%x /%u)",
> > +                                   insn_bytes[0], (insn_size >= 2) ? GET_REG(insn_bytes[1]) : 0);
>
> If you don't get 'flds', you shouldn't assume that the second byte is
> the modr/m byte. Even if it is, the reg field may not be part of the
> opcode.
>
> > +                       vcpu_regs_get(vm, VCPU_ID, &regs);
> > +                       regs.rip += (uintptr_t)(&fld_end) - (uintptr_t)(&fld_start);
>
> A general purpose hypervisor wouldn't normally have access to these
> labels, so you should really determine the length of the instruction
> by decoding, *and* ensure that kvm gave you sufficient instruction
> bytes. For instance, if the addressing mode involves a SIB byte and a
> 32-bit displacement, you would need kvm to give you at least 7 bytes.
> Speaking of sufficient bytes, it would be nice to see your test
> exercise the case where kvm's in-kernel emulator can't actually fetch
> the full 15 bytes.
>
> Can you comment on what else would have to be done to actually emulate
> this instruction in userspace?
>

Along with doing a more thorough job decoding this instruction we
should really have a way to convert the effective address to a linear
address.  This can be tricky to do, so I'd suggest letting the kernel
do it (because it already knows how).  I could create an ioctl that
resolves the effective address and returns either the corresponding
linear address or an exception in the event it fails to linearize the
address.  In the case we have here in this test I'd expect an
exception in the form of a #PF(RSVD).  I was thinking this could be
done as a followup to this change.

> > +                       vcpu_regs_set(vm, VCPU_ID, &regs);
> > +               }
> > +       }
> > +}
> > +
> > +static void do_guest_assert(struct kvm_vm *vm, struct ucall *uc)
> > +{
> > +       TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0], __FILE__,
> > +                 uc->args[1]);
> > +}
> > +

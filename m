Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D8756936E
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiGFUit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 16:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbiGFUis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 16:38:48 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B5713DF4
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 13:38:47 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1013ecaf7e0so22773376fac.13
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 13:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V4iWsM3zDJ62xZk9JpVza3Ty+C3Hx5QJjdlOMIUkfEI=;
        b=EDdwTSV2Gu4vOdeLlT31P2HN/4NychO6ng/goB8uYDSxRqx5+20DP6v25Jr2mVjy14
         ffhPDZJ7bWPeYiCsTfSOEF5WOm1Wxu2lXrMfGSYjEXgZc59MvMsUXgTcw4J0d6fuNzsp
         Mch07cuS0FZGE2DmmohXSTThXt/yjeW2guxvrmxiYla0Z9dtCY/5FGQ07LtKY5FACfUZ
         PhL0i7l/whYaj1re0ZgZkOsFkMpBA8KUnbu5ceOH9v/mS7aYoZwi+g1O6esuCjwfo0KH
         APsWNPcJNtLUQ53HjSWKhkIfgbVTevM4BT3D44v7miQ7aeRGtZS8e3TvTaqaLhAqc9x/
         NWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V4iWsM3zDJ62xZk9JpVza3Ty+C3Hx5QJjdlOMIUkfEI=;
        b=GrQZbrOC6rAeA/gwKFlP6nh1hJnuQ57iCRLzX3Q3MV+DJ0q0pjCmopnZbvoPfoRodY
         LQmASro25b/7O4SYihOik0qQks6tPCZWakjcpXnOO3ljG8S7af0ApnldhetpYBRXZAct
         3lBY3be31mvWanAvDpcCVwx9iI0wRPRoAQdjT9l4D5Qzqp/zSAHIn0xnLgUhkkVxOGw/
         O8uuhubfv+s2tVoCPFJN9k40EVYkWXOnrvrqGuD49JWjzlVbeDY4XLy4sw6RQTD2Yepn
         IMnXwx9h6iHRe8xuSBG9X3nP1OwARwg8HEA7CsitHgbPpDD2Rv2zM32aNODzRxevn9Xv
         sWfQ==
X-Gm-Message-State: AJIora+C8hM9GKFitEPwn8E+XZSHp+LYos56wvI8kZlYJt9Um3SYFEt6
        beCNlmGRjkBaY9rc+BXG5jkR572QiN1ZSI+4hK9nbg==
X-Google-Smtp-Source: AGRyM1syzblqUeyuUT+ro5BC+DlgiV8XGC8iARTfNRkNnhH/DBFePHvxiPweRw/BZRmhp+UNC73NHnBI+gsLazNmznY=
X-Received: by 2002:a05:6870:56aa:b0:10b:f4fb:8203 with SMTP id
 p42-20020a05687056aa00b0010bf4fb8203mr312197oao.181.1657139926714; Wed, 06
 Jul 2022 13:38:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220621150902.46126-1-mlevitsk@redhat.com> <20220621150902.46126-12-mlevitsk@redhat.com>
 <CALMp9eSe5jtvmOPWLYCcrMmqyVBeBkg90RwtR4bwxay99NAF3g@mail.gmail.com>
 <42da1631c8cdd282e5d9cfd0698b6df7deed2daf.camel@redhat.com>
 <CALMp9eRNZ8D5aRyUEkc7CORz-=bqzfVCSf6nOGZhqQfWfte0dw@mail.gmail.com>
 <289c2dd941ecbc3c32514fc0603148972524b22d.camel@redhat.com>
 <CALMp9eS2gxzWU1+OpfBTqCZsmyq8qoCW_Qs84xv=rGo1ranG1Q@mail.gmail.com> <5ff3c2b4712f6446d2c1361315b972ddad48836f.camel@redhat.com>
In-Reply-To: <5ff3c2b4712f6446d2c1361315b972ddad48836f.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Jul 2022 13:38:35 -0700
Message-ID: <CALMp9eRCV187TsdnOr9PWo+MMNT71+2uU8YNvc89EBgYYvxRQQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 6, 2022 at 1:00 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Wed, 2022-07-06 at 11:13 -0700, Jim Mattson wrote:
> > On Tue, Jul 5, 2022 at 6:38 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
...
> > > Plus our SMI layout (at least for 32 bit) doesn't confirm to the X86 spec anyway,
> > > we as I found out flat out write over the fields that have other meaning in the X86 spec.
> >
> > Shouldn't we fix that?
> I am afraid we can't because that will break (in theory) the backward compatibility
> (e.g if someone migrates a VM while in SMM).

Every time someone says, "We can't fix this, because it breaks
backward compatibility," I think, "Another potential use of
KVM_CAP_DISABLE_QUIRKS2?"

...
> But then after looking at SDM I also found out that Intel and AMD have completely
> different SMM layout for 64 bit. We follow the AMD's layout, but we don't
> implement many fields, including some that are barely/not documented.
> (e.g what is svm_guest_virtual_int?)
>
> In theory we could use Intel's layout when we run with Intel's vendor ID,
> and AMD's vise versa, but we probably won't bother + once again there
> is an issue of backward compatibility.

This seems pretty egregious, since the SDM specifically states, "Some
of the registers in the SMRAM state save area (marked YES in column 3)
may be read and changed by the
SMI handler, with the changed values restored to the processor
registers by the RSM instruction." How can that possibly work with
AMD's layout?
(See my comment above regarding backwards compatibility.)

<soapbox>I wish KVM would stop offering virtual CPU features that are
completely broken.</soapbox>

> > The vNMI feature isn't available in any shipping processor yet, is it?
> Yes, but one of its purposes is to avoid single stepping the guest,
> which is especially painful on AMD, because there is no MTF, so
> you have to 'borrow' the TF flag in the EFLAGS, and that can leak into
> the guest state (e.g pushed onto the stack).

So, what's the solution for all of today's SVM-capable processors? KVM
will probably be supporting AMD CPUs without vNMI for the next decade
or two.


> (Actually looking at clause of default treatment of SMIs in Intel's PRM,
> they do mention that they preserve the int shadow somewhere at least
> on some Intel's CPUs).

Yes, this is a required part of VMX-critical state for processors that
support SMI recognition while there is blocking by STI or by MOV SS.
However, I don't believe that KVM actually saves VMX-critical state on
delivery of a virtual SMI.

>
> BTW, according to my observations, it is really hard to hit this problem,
> because it looks like when the CPU is in interrupt shadow, it doesn't process
> _real_ interrupts as well (despite the fact that in VM, real interrupts
> should never be blocked(*), but yet, that is what I observed on both AMD and Intel.
>
> (*) You can allow the guest to control the real EFLAGS.IF on both VMX and SVM,
> (in which case int shadow should indeed work as on bare metal)
> but KVM of course doesn't do it.

It doesn't surprise me that hardware treats a virtual interrupt shadow
as a physical interrupt shadow. IIRC, each vendor has a way of
breaking an endless chain of interrupt shadows, so a malicious guest
can't defer interrupts indefinitely.

> I observed that when KVM sends #SMI from other vCPU, it sends a vCPU kick,
> and the kick never arrives inside the interrupt shadow.
> I have seen it on both VMX and SVM.
>
> What still triggers this problem, is that the instruction which is in the interrupt
> shadow can still get a VM exit, (e.g EPT/NPT violation) and then it can notice
> the pending SMI.
>
> I think it has to be EPT/NPT violation btw, because, IMHO most if not all other VM exits I
> think are instruction intercepts, which will cause KVM to emulate the instruction
> and clear the interrupt shadow, and only after that it will enter SMM.
>
> Even MMIO/IOPORT access is emulated by the KVM.
>
> Its not the case with EPT/NPT violation, because the KVM will in this case re-execute
> the instruction after it 'fixes' the fault.

Probably #PF as well, then, if TDP is disabled.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73260425684
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbhJGPZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 11:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhJGPZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 11:25:53 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97362C061570
        for <kvm@vger.kernel.org>; Thu,  7 Oct 2021 08:23:59 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id v18so24752946edc.11
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 08:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gHDuZTlGc2rJpzUr8UKQVYIrwD7USNVlq1NIiYVhYfw=;
        b=mDcKpPSJ2ovp2qaHHZZU+Pv3JPFKAItNwoNirvaUfu8rWw/zVQviJym/hwXiOsuqsm
         3yizOVJfWskSZ2toc+lfAaqMilOE0Fbwgh8nrgOPQPHz97sYE736T26FDoc25wGrOVh8
         yI/fjTOuVRiSpi8ptiMixbpo4Kr5EpGwqsI5fZkHjp/YqKziz3pwgNlvDGC1xWjZ8oa0
         aDB4HFQTQTXZ/6mREfakyGUvahUpBsGZHO3Dz9YgHPXXQczs12xYghxq08P3cWkNTYwM
         lfPGBnsnXHcbiBfAp/tj6BYC6C0qy1AAb9uv4BfWiYgBGnTWIhlPIKBILpkZhjXiwgEb
         FVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gHDuZTlGc2rJpzUr8UKQVYIrwD7USNVlq1NIiYVhYfw=;
        b=5DVmIl8VSVgrVDLfnJe67To1n5v4Vq8vgNhtvm49YmkUz3UjJegZG2yFqd4EUUu9fq
         I8GRfY5Gdv5x+CJ7GfRBOtqR21mnprqbqHFBB4Szw/OjvWvWJEhGR+Cp3dNwu9U9VIBG
         qNPEo6sBbgwBjI1urKf2c1dYSQDfd2itW0AdpZKhE7CUi4Exh08NC0p4ZwT3B3E0GPeB
         kFdPd5J5UBXKdx54SoJ9KY+FL1ZBNCWOU6GmlWAUb/m3MgVxwy/jzfVrONAbil24HkyK
         27P+DP8lL3LmKngfB88K1dHth2tgknfqjeG0XNSuaZnCP3lRA+C9bnMiwZzRxqGM8lIw
         WjDw==
X-Gm-Message-State: AOAM533y6nA3hQ+h1ouh1TxUxOl5r8Ad4sP/VtFD1Exa//WADP6vGZtW
        j09kP1TMtLroYV4iNRVEaHOzNV7MsblyjezBIvtlVQ==
X-Google-Smtp-Source: ABdhPJx8vDuz/FGDo+aeQxqTan7AcX4TUsajCf+a5kwlMl4oEVNWaMtznfPqVcaPbNQcX0D7KEHMZ9ZmfOq4Ji/etl4=
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr2419953ejz.499.1633620237988;
 Thu, 07 Oct 2021 08:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211006133021.271905-1-sashal@kernel.org> <20211006133021.271905-4-sashal@kernel.org>
 <e5b8a6d4-6d5c-ada9-bb36-7ed3c8b7d637@redhat.com>
In-Reply-To: <e5b8a6d4-6d5c-ada9-bb36-7ed3c8b7d637@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 Oct 2021 20:53:46 +0530
Message-ID: <CA+G9fYt6J2UTgC8Ths11xHefj6qYOqS0JMfSMoHYwvMy3NzxWQ@mail.gmail.com>
Subject: Re: [PATCH MANUALSEL 5.14 4/9] KVM: x86: reset pdptrs_from_userspace
 when exiting smm
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Oct 2021 at 19:06, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 06/10/21 15:30, Sasha Levin wrote:
> > From: Maxim Levitsky <mlevitsk@redhat.com>
> >
> > [ Upstream commit 37687c403a641f251cb2ef2e7830b88aa0647ba9 ]
> >
> > When exiting SMM, pdpts are loaded again from the guest memory.
> >
> > This fixes a theoretical bug, when exit from SMM triggers entry to the
> > nested guest which re-uses some of the migration
> > code which uses this flag as a workaround for a legacy userspace.
> >
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Message-Id: <20210913140954.165665-4-mlevitsk@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   arch/x86/kvm/x86.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b3f855d48f72..1e7d629bbf36 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7659,6 +7659,13 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
> >
> >               /* Process a latched INIT or SMI, if any.  */
> >               kvm_make_request(KVM_REQ_EVENT, vcpu);
> > +
> > +             /*
> > +              * Even if KVM_SET_SREGS2 loaded PDPTRs out of band,
> > +              * on SMM exit we still need to reload them from
> > +              * guest memory
> > +              */
> > +             vcpu->arch.pdptrs_from_userspace = false;
> >       }
> >
> >       kvm_mmu_reset_context(vcpu);
> >
>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Is this expected to be in stable-rc 5.10 and below ?
Because it is breaking the builds on queue/5.10, queue/5.4 and older branches.

arch/x86/kvm/x86.c: In function 'kvm_smm_changed':
arch/x86/kvm/x86.c:6612:27: error: 'struct kvm_vcpu_arch' has no
member named 'pdptrs_from_userspace'
 6612 |                 vcpu->arch.pdptrs_from_userspace = false;
      |                           ^
make[3]: *** [scripts/Makefile.build:262: arch/x86/kvm/x86.o] Error 1

ref:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues/-/jobs/1658987088#L443

- Naresh

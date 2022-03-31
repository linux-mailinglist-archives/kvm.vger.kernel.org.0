Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE554EE0D6
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 20:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbiCaSqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 14:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiCaSqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 14:46:07 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEFB62A1E
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:44:18 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c15so940181ljr.9
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=diyAQu32SyWgcK78gZv9L87yUVu3j7qP71reODwba1o=;
        b=UqbgxK9UN83aiwkzqr90FVU+g4GQhO1P9fQdo5SVxgiJS3H4HEpiwRMYTUTrjF8foN
         mTTPXOoAtgZAtuONfgKHKGNyL1adjPEpUxEMW6gnNHR7wCZg32NLNVoWI2hIm6pJHgGq
         Iq2bwgfEfuF1sry/T0T5pmWFkwYfsX8uqM5EGIQM6dG/qIpZNXgkY2MMDbKVbujAi203
         KGyFD0l516w94JwMMPRy/H284u003kpoJmpS8fYdvRnKRsQAjRY05hLLL6TuLLXPWVMQ
         QMn47ILMRgD6QmHNoynieIkZGtpEHi5pE9LnRJ3kiFzTLKRwaNiTiFY+MfrDJAyzSe+w
         tHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=diyAQu32SyWgcK78gZv9L87yUVu3j7qP71reODwba1o=;
        b=E6OR8D8EcfSS1NUzbTyXhK3Ja9/KBn0+JdqVyIa0k/2ySbc/czfHWITi7KJ+LTdoAK
         xRAzvmWMqkhfNLDwi7WjUdW/7lAwThNVHuK8HWvivpOpfIDwmDo42JQ6QOWshouBkbxA
         kjD3XTYdyO7nFOKqIA93hSZv+p6M2tWfvPlKy2V4wu4auNjbISjx0cEDrBorADIF8t4L
         GUjSjYMh7FqMGB/u0SJfzeZSudFoNnXNBGKj59lCMRVNEGzTkTm9yVYJJ+Ue+1db9MIn
         Y5+6unto4IL0knJIjDiu81tfFMHsC7HoJeNrh5HJd4NCupSOVYKB8ktqUJp7LJina585
         NkcA==
X-Gm-Message-State: AOAM531QMhC76XQKid29a/Ra+En7etCjXC7KFxB0W9XsXVkadBWrp7fq
        dlqB5nVudkpnZlPXFXosqGbrU+QqPnU3VUfKPLb8Gg==
X-Google-Smtp-Source: ABdhPJyY74baif8NZD4j5YnlvtauzWdN9TL4wEKLa67DPsIzl7mXAoKYOXhsFmJVLA1vY/sdLNuGWxMAzN8Bkm7oM6M=
X-Received: by 2002:a2e:6814:0:b0:24a:f422:e953 with SMTP id
 c20-20020a2e6814000000b0024af422e953mr4393064lja.527.1648752254252; Thu, 31
 Mar 2022 11:44:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220330182821.2633150-1-pgonda@google.com> <YkXgq7hez9gGcmKt@google.com>
 <CAA03e5EcApE8ZnHEwZdZ3ecxYvh1G3nF-YDU5mhZa-15QZ0tew@mail.gmail.com> <CAA03e5Ghw6rJ82GhGKW+sCDgDRpZPLmhq29Wgmd0H40nvbX+Rg@mail.gmail.com>
In-Reply-To: <CAA03e5Ghw6rJ82GhGKW+sCDgDRpZPLmhq29Wgmd0H40nvbX+Rg@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 31 Mar 2022 12:43:56 -0600
Message-ID: <CAMkAt6qr7zwy2uG1EaoZyvXnXMZ7Ho-CxQvRpcuUCx8wiA+6UQ@mail.gmail.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Marc Orr <marcorr@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Mar 31, 2022 at 11:48 AM Marc Orr <marcorr@google.com> wrote:
>
> On Thu, Mar 31, 2022 at 10:40 AM Marc Orr <marcorr@google.com> wrote:
> >
> > On Thu, Mar 31, 2022 at 10:11 AM Sean Christopherson <seanjc@google.com=
> wrote:
> > >
> > > +Paolo and Vitaly
> > >
> > > In the future, I highly recommend using scripts/get_maintainers.pl.
> > >
> > > On Wed, Mar 30, 2022, Peter Gonda wrote:
> > > > SEV-ES guests can request termination using the GHCB's MSR protocol=
. See
> > > > AMD's GHCB spec section '4.1.13 Termination Request'. Currently whe=
n a
> > > > guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL=
)
> > > > return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kv=
m_run
> > > > struct the userspace VMM can clearly see the guest has requested a =
SEV-ES
> > > > termination including the termination reason code set and reason co=
de.
> > > >
> > > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > >
> > > > ---
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index 75fa6dd268f0..5f9d37dd3f6f 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(s=
truct vcpu_svm *svm)
> > > >               pr_info("SEV-ES guest requested termination: %#llx:%#=
llx\n",
> > > >                       reason_set, reason_code);
> > >
> > > This pr_info() should be removed.  A malicious usersepace could spam =
the kernel
> > > by constantly running a vCPU that requests termination.
>
> Though... this patch makes this pr_info redundant! Since we'll now
> report this in userspace. Actually, I'd be OK to remove it.

I'll make this 2 patches. This current patch and another to rate limit
this pr_info() I think this patch is doing a lot already so would
prefer to just add a second. Is that reasonable?

>
> > Ah, good catch. But actually, I've found this specific pr_info _very_
> > useful in debugging. Sean, would you be OK to convert it to a rate
> > limited print?
> >
> > > > -             ret =3D -EINVAL;
> > > > -             break;
> > > > +             vcpu->run->exit_reason =3D KVM_EXIT_SHUTDOWN;
> > > > +             vcpu->run->shutdown.reason =3D KVM_SHUTDOWN_SEV_TERM;
> > > > +             vcpu->run->shutdown.ndata =3D 2;
> > > > +             vcpu->run->shutdown.data[0] =3D reason_set;
> > > > +             vcpu->run->shutdown.data[1] =3D reason_code;
> > >
> > > Does KVM really need to split the reason_set and reason_code?  Withou=
t reading
> > > the spec, it's not even clear what "set" means.  Assuming it's someth=
ing like
> > > "the reason code is valid", then I don't see any reason (lol) to spli=
t the two.
> > > If we do split them, then arguably the reason_code should be filled i=
f and only
> > > if reason_set is true, and that's just extra work.
> >
> > I think KVM should split the reason_set and reason_code. This code is
> > based on the GHCB spec after all. And reason_set and reason_code are
> > both a part of the GHCB spec. But I agree, folks shouldn't have to go
> > to the spec to understand what reason_set and reason_code are. Rather
> > than not splitting them up, can we add comments in the source to
> > explain what they mean?
> >
> > Also, my understanding from reading the spec is that reason_code
> > should always be filled, even when reason_set is 0. See below. But
> > basically, you can have reason_set: 0 and reason_code: non-zero.
> >
> > Quoting the spec:
> > The reason code set is meant to provide hypervisors with their own
> > termination SEV-ES Guest-Hypervisor Communication Block
> > Standardization reason codes. This document defines and owns reason
> > code set 0x0 and the following reason codes (GHCBData[23:16]):
> > 0x00 =E2=80=93 General termination request
> > 0x01 =E2=80=93 SEV-ES / GHCB Protocol range is not supported.
> > 0x02 =E2=80=93 SEV-SNP features not supported
>
> Reading this again, I now see that "reason_set" sounds like "The
> reason code is set". I bet that's how Sean read it during his review.
> So yeah, this needs comments :-)!

I'll add comments but I agree with Marc. These are part of the GHCB
spec so for the very specific SEV-ES termination reason we should
include all the data the spec allows. Sounds OK?

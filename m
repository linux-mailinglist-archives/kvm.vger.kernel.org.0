Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB494EDFE4
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiCaRt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 13:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiCaRtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 13:49:55 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA4B20289E
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 10:48:08 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-d6ca46da48so13329fac.12
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 10:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cktda7ofkXXBp7SytHSz32Mg+85lXetwHgTvxFnuI4o=;
        b=e0i6264GaxyETAG9/l1doQZZpykO5cao2+sP9V+Zni/7dlG3EzPqCrqlzUqFDyCX25
         0FTK5KbwDkoF+IZ9YCyNYez2IXnTvDSIoV4hiUX9FjHT2z8//fRWH8aPCKvl2QDPPxXD
         oZDO/FSV+t6UTYwxK7x7RgDqP05bBBV/HzDg3jWQWxbhdEiQb7y67B8qwSEBtfQ4L4Wu
         6oL1lDibB1gnt6uAn5Qf+UXCc4s13eOHXC3vzb3kWzt7Le+TfTsBgsJVKCVo6D2GZZIn
         IZVJjGTh6E/5hSyPmbNP/vpCWIwbIbwoIXNrTW9s/EHjrAeVj+EXnY7jBBI2TJ+btar1
         UvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cktda7ofkXXBp7SytHSz32Mg+85lXetwHgTvxFnuI4o=;
        b=jYSqs/++T4o8BxcAXB4hURlW73BgKoQTx50vPOyb+dOu6iaGhqbhNbytBnP9s5haw2
         VHy52lM6/zhPffzoYiTXVnaXI8IAoR+PTbmki0ogdGsWQmRM8XiCe06crtqcWMxxYAZg
         /nXhPGU0cWJC+Kk+twojnwyCjUBf0ZpFNHtMd+C7wWsv0mAGO53Kj11biBjLsZ0v4GSt
         2lwzE3jcqW7GoRCqggPARupjT4ckXFLPdT4mLF8qSCHxJoiafzcFwZN76/L3bDfAcMsD
         cvuWRrDWC1GSO53XXilq7n3w5vZGyCahWEw0LtUmaQW/7gRIPCJ6kvKkuEAeB7D9GOJw
         PNEA==
X-Gm-Message-State: AOAM531tE41fneQZNI/gNgSMJEXyhKQqDd3z+NfmbNXkfb8r2LRwD3js
        aWioadH/wyJY+jp4JQHIJ5EAAehMzGD0TaugRWFTAA==
X-Google-Smtp-Source: ABdhPJy2CkqquFKucncpwD+lrkR4EtKr/WfGhF5Qva2UXFISgBDgWQERTF3un4uHrsaU+Zmxm5hU4uFAUlP1vUzV2dQ=
X-Received: by 2002:a05:6870:40cc:b0:de:15e7:4df0 with SMTP id
 l12-20020a05687040cc00b000de15e74df0mr3265882oal.110.1648748887152; Thu, 31
 Mar 2022 10:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220330182821.2633150-1-pgonda@google.com> <YkXgq7hez9gGcmKt@google.com>
 <CAA03e5EcApE8ZnHEwZdZ3ecxYvh1G3nF-YDU5mhZa-15QZ0tew@mail.gmail.com>
In-Reply-To: <CAA03e5EcApE8ZnHEwZdZ3ecxYvh1G3nF-YDU5mhZa-15QZ0tew@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 31 Mar 2022 10:47:55 -0700
Message-ID: <CAA03e5Ghw6rJ82GhGKW+sCDgDRpZPLmhq29Wgmd0H40nvbX+Rg@mail.gmail.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
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

On Thu, Mar 31, 2022 at 10:40 AM Marc Orr <marcorr@google.com> wrote:
>
> On Thu, Mar 31, 2022 at 10:11 AM Sean Christopherson <seanjc@google.com> =
wrote:
> >
> > +Paolo and Vitaly
> >
> > In the future, I highly recommend using scripts/get_maintainers.pl.
> >
> > On Wed, Mar 30, 2022, Peter Gonda wrote:
> > > SEV-ES guests can request termination using the GHCB's MSR protocol. =
See
> > > AMD's GHCB spec section '4.1.13 Termination Request'. Currently when =
a
> > > guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> > > return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_=
run
> > > struct the userspace VMM can clearly see the guest has requested a SE=
V-ES
> > > termination including the termination reason code set and reason code=
.
> > >
> > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > >
> > > ---
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 75fa6dd268f0..5f9d37dd3f6f 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(str=
uct vcpu_svm *svm)
> > >               pr_info("SEV-ES guest requested termination: %#llx:%#ll=
x\n",
> > >                       reason_set, reason_code);
> >
> > This pr_info() should be removed.  A malicious usersepace could spam th=
e kernel
> > by constantly running a vCPU that requests termination.

Though... this patch makes this pr_info redundant! Since we'll now
report this in userspace. Actually, I'd be OK to remove it.

> Ah, good catch. But actually, I've found this specific pr_info _very_
> useful in debugging. Sean, would you be OK to convert it to a rate
> limited print?
>
> > > -             ret =3D -EINVAL;
> > > -             break;
> > > +             vcpu->run->exit_reason =3D KVM_EXIT_SHUTDOWN;
> > > +             vcpu->run->shutdown.reason =3D KVM_SHUTDOWN_SEV_TERM;
> > > +             vcpu->run->shutdown.ndata =3D 2;
> > > +             vcpu->run->shutdown.data[0] =3D reason_set;
> > > +             vcpu->run->shutdown.data[1] =3D reason_code;
> >
> > Does KVM really need to split the reason_set and reason_code?  Without =
reading
> > the spec, it's not even clear what "set" means.  Assuming it's somethin=
g like
> > "the reason code is valid", then I don't see any reason (lol) to split =
the two.
> > If we do split them, then arguably the reason_code should be filled if =
and only
> > if reason_set is true, and that's just extra work.
>
> I think KVM should split the reason_set and reason_code. This code is
> based on the GHCB spec after all. And reason_set and reason_code are
> both a part of the GHCB spec. But I agree, folks shouldn't have to go
> to the spec to understand what reason_set and reason_code are. Rather
> than not splitting them up, can we add comments in the source to
> explain what they mean?
>
> Also, my understanding from reading the spec is that reason_code
> should always be filled, even when reason_set is 0. See below. But
> basically, you can have reason_set: 0 and reason_code: non-zero.
>
> Quoting the spec:
> The reason code set is meant to provide hypervisors with their own
> termination SEV-ES Guest-Hypervisor Communication Block
> Standardization reason codes. This document defines and owns reason
> code set 0x0 and the following reason codes (GHCBData[23:16]):
> 0x00 =E2=80=93 General termination request
> 0x01 =E2=80=93 SEV-ES / GHCB Protocol range is not supported.
> 0x02 =E2=80=93 SEV-SNP features not supported

Reading this again, I now see that "reason_set" sounds like "The
reason code is set". I bet that's how Sean read it during his review.
So yeah, this needs comments :-)!

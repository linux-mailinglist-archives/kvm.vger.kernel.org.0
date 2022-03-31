Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23AE4EE139
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 21:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiCaTBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 15:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237874AbiCaTBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 15:01:52 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40CD1BD9A6
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:00:00 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t25so806667lfg.7
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 12:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9C1o/CsBf7IV+dPjddwQeMdeWUC6XaniU2LZq1nfURc=;
        b=RMZejOtFXFKr3uNwqcw3FjLQD82Dr/KWloy4LfGLpiB/A5v9gVTDo/rAZ0aqUZ61kM
         2lup8/X9m1Ef7jQNFIBeTZ664MYZy3PI4Oo3ZVOn5WR2qXqPN+ef15JNZJxbqJ3bVZ/j
         KZkWkXo3gSg6wsR7KEwKMgRqJuy4SNqX6sgL83Wqi2uf7hi9rfLWcCDp86gHMmuV86uN
         NtNe69+E/bjDn5/9p3H0EHIzoUhcDBxJ+08ovJfMpeUx5X1zgW+VNINVTk/9kHtr/ngc
         h9NjTkL4ANzOn6l/50eoIPUkCSJFfgWOjTg9N1oaU7lZDDzelQtqBK+TzOQeUM0LR9C9
         uvPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9C1o/CsBf7IV+dPjddwQeMdeWUC6XaniU2LZq1nfURc=;
        b=pvzOoua3ZJWlG431A+bGHTGfzIq0v/3A/IomjDrTalaXaAmsCDKFj/olXoB9TdYO0j
         YDvYRTNwA8W++lLK5aa5wn1Jk2OE4amPVyojEmZAkonDQC0PmUn5RelKvQEWnUuxdJGv
         wSDYMwdsDB+Wg2Od8D9HXvyOSK3dWQGGqkQO2Bc2pd1Z/IAEMoYSEu5QSs+a1AxmAB9D
         z8LGnOCemLytiAiMuQPD6GeCyB8ERRCcAx2EGnaUf9AtziS58go7sL7WlYDHq7H6VfGJ
         T4bZ1EMQkWU/yG66TE+BUVsLABkdPFHwdw/m/eEh/RrbKcCXtpYXAexUmG7ASHTlszOh
         tisw==
X-Gm-Message-State: AOAM533nEPutM04PKDFkfnphNR3dHSGU4qx+VaqLptWG2A6B0QIHTKML
        X3bFgbEuGrfeN9LhHhFpSgfk3HusMYV+UgBL6iZNpMHddatr+A==
X-Google-Smtp-Source: ABdhPJyBMLhIYcZxPxh68KkYX4Q8JZtBB+3VEPcHJVovm5O56OgYuMGT3kVGJxpoQ9H7Rtq1C3IAXW/fo9F7sr4pGnA=
X-Received: by 2002:a19:ee08:0:b0:44a:acce:7af with SMTP id
 g8-20020a19ee08000000b0044aacce07afmr11365906lfb.402.1648753195840; Thu, 31
 Mar 2022 11:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220330182821.2633150-1-pgonda@google.com> <YkXgq7hez9gGcmKt@google.com>
 <CAA03e5EcApE8ZnHEwZdZ3ecxYvh1G3nF-YDU5mhZa-15QZ0tew@mail.gmail.com>
 <CAA03e5Ghw6rJ82GhGKW+sCDgDRpZPLmhq29Wgmd0H40nvbX+Rg@mail.gmail.com>
 <CAMkAt6qr7zwy2uG1EaoZyvXnXMZ7Ho-CxQvRpcuUCx8wiA+6UQ@mail.gmail.com> <YkX46P6mn+BYWsv2@google.com>
In-Reply-To: <YkX46P6mn+BYWsv2@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 31 Mar 2022 12:59:44 -0600
Message-ID: <CAMkAt6oiXaDfzRWo0GDNGyFeA2f8DPmWGsJvpFpB1+A8XSz4rA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
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

On Thu, Mar 31, 2022 at 12:54 PM Sean Christopherson <seanjc@google.com> wr=
ote:
>
> On Thu, Mar 31, 2022, Peter Gonda wrote:
> > On Thu, Mar 31, 2022 at 11:48 AM Marc Orr <marcorr@google.com> wrote:
> > >
> > > On Thu, Mar 31, 2022 at 10:40 AM Marc Orr <marcorr@google.com> wrote:
> > > >
> > > > On Thu, Mar 31, 2022 at 10:11 AM Sean Christopherson <seanjc@google=
.com> wrote:
> > > > >
> > > > > +Paolo and Vitaly
> > > > >
> > > > > In the future, I highly recommend using scripts/get_maintainers.p=
l.
> > > > >
> > > > > On Wed, Mar 30, 2022, Peter Gonda wrote:
> > > > > > SEV-ES guests can request termination using the GHCB's MSR prot=
ocol. See
> > > > > > AMD's GHCB spec section '4.1.13 Termination Request'. Currently=
 when a
> > > > > > guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EV=
INAL)
> > > > > > return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY t=
o kvm_run
> > > > > > struct the userspace VMM can clearly see the guest has requeste=
d a SEV-ES
> > > > > > termination including the termination reason code set and reaso=
n code.
> > > > > >
> > > > > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > > > >
> > > > > > ---
> > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > index 75fa6dd268f0..5f9d37dd3f6f 100644
> > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protoc=
ol(struct vcpu_svm *svm)
> > > > > >               pr_info("SEV-ES guest requested termination: %#ll=
x:%#llx\n",
> > > > > >                       reason_set, reason_code);
> > > > >
> > > > > This pr_info() should be removed.  A malicious usersepace could s=
pam the kernel
> > > > > by constantly running a vCPU that requests termination.
> > >
> > > Though... this patch makes this pr_info redundant! Since we'll now
> > > report this in userspace. Actually, I'd be OK to remove it.
> >
> > I'll make this 2 patches. This current patch and another to rate limit
> > this pr_info() I think this patch is doing a lot already so would
> > prefer to just add a second. Is that reasonable?
>
> I strongly prefer removing the pr_info() entirely.  As Marc pointed out, =
the
> info is redundant when KVM properly reports the issue.  And worse, the in=
fo is
> useless unless there's exactly one VM running.  Even then, it doesn't cap=
ture
> which vCPU failed.  This is exactly why Jim, myself, and others, have bee=
n pushing
> to avoid using dmesg to report guest errors.  They're helpful for initial
> development, but dead weight for production, and if they're helpful for d=
evelopment
> then odds are good that having proper reporting in production would also =
be valuable.

Sounds good to me. Is a second patch OK with you? I think we get a lot
of cryptic cpu run exit reasons so fixing this up when we remove
pr_infos would be good. This would be a good example without this
pr_info or this change you'd have no idea whats going on.

>
> > > > Quoting the spec:
> > > > The reason code set is meant to provide hypervisors with their own
> > > > termination SEV-ES Guest-Hypervisor Communication Block
> > > > Standardization reason codes. This document defines and owns reason
> > > > code set 0x0 and the following reason codes (GHCBData[23:16]):
> > > > 0x00 =E2=80=93 General termination request
> > > > 0x01 =E2=80=93 SEV-ES / GHCB Protocol range is not supported.
> > > > 0x02 =E2=80=93 SEV-SNP features not supported
> > >
> > > Reading this again, I now see that "reason_set" sounds like "The
> > > reason code is set". I bet that's how Sean read it during his review.
> > > So yeah, this needs comments :-)!
> >
> > I'll add comments but I agree with Marc. These are part of the GHCB
> > spec so for the very specific SEV-ES termination reason we should
> > include all the data the spec allows. Sounds OK?
>
> Ugh, so "set" means "set of reason codes"?  That's heinous naming.  I don=
't have a
> strong objection to splitting, but at the same time, why not punt it to u=
serspace?
> Userspace is obviously going to have to understand what the hell "set" me=
ans
> anyways...

I am fine just copying the entire MSR to userspace.

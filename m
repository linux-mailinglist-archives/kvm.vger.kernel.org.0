Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9500E4EDFCF
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 19:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiCaRmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 13:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiCaRmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 13:42:37 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C03179B06
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 10:40:49 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-dee0378ce7so38094fac.4
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 10:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7t8mUtjRC3Sb4hnszYYVzRdf2lhjiSKhdjBRgU1Dbms=;
        b=YmkN7tnIGCbKxVwqntolf5WVNxlqtRVcVf+24gvNkt1eQGFktSWeM6e1VvDR5YBEB5
         1yuajZWkZipbGScPePiYnGRqwfiwPzzG0H3rdkoC3rxoJuP5wsWNmqyvd+GEhTPoREOW
         Afout0zRAzcgj3jtQOLd8eqJssDIH4b/Vv1R+mR1Aw2iIcPrG1PO+y6Ef/pi1zfUpWFH
         Q6bvAACOixipSs8NtTHXIfSYm6nN5+xnPhmST6rcJZkjrMB42sRxEQktQuEivUzA/Q+J
         zunFkAAo6ss/7BQSZVNbpAtgs6c/DhLmxEuqH7ZbNgZdWAkyj/rJv/JRO5s/7/tDpKfz
         4d8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7t8mUtjRC3Sb4hnszYYVzRdf2lhjiSKhdjBRgU1Dbms=;
        b=whbreMypXeaxURcYFUVI8gnjNX2iESfNnjsmdfBbMEOuIzTGbMXS9pXhYEG7jVBxuL
         /AurPLgPQBoFxCWvq9X4kueDMOW8Ey21pcqGH/DnXzlQIAkOCtxdvovntEl02EfPBjye
         aXUwtG1T+yQOMrO9EdbPfw2+JP8e3QEyJoNkGZcEag8sVIRJb84EcbTYCiAh9/c29x8j
         PrwA0EbF0MGDlR2oonrqpiujaQxfVdd2K97k1QMEc3LlRjIXkZMbZGee9TUCTMi8nMAp
         8RafDlj3jh3bWYCVBAIUR81LES5P0dQzTqtYB124IF8qv2zSu5P/JULIZWQJ8TJouWXF
         GO5Q==
X-Gm-Message-State: AOAM5304/4Y5KKYBypSSgFe6hBGu5Cey3/+0YwG16fDUwJc0n6GkRpP1
        fiUXBs4IGbBn7XOFw61sQZDdwocz36kuT27YZ7GC3A==
X-Google-Smtp-Source: ABdhPJwC+fHpJZdLhuuEO03PFdU7hAT8Vt+DsMpAem5ZGeo4gGxp4czhze9I/PLoLazy7DQ/IWWoRicWoJm9kiJVD/4=
X-Received: by 2002:a05:6870:40cc:b0:de:15e7:4df0 with SMTP id
 l12-20020a05687040cc00b000de15e74df0mr3251418oal.110.1648748448885; Thu, 31
 Mar 2022 10:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220330182821.2633150-1-pgonda@google.com> <YkXgq7hez9gGcmKt@google.com>
In-Reply-To: <YkXgq7hez9gGcmKt@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 31 Mar 2022 10:40:37 -0700
Message-ID: <CAA03e5EcApE8ZnHEwZdZ3ecxYvh1G3nF-YDU5mhZa-15QZ0tew@mail.gmail.com>
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

On Thu, Mar 31, 2022 at 10:11 AM Sean Christopherson <seanjc@google.com> wr=
ote:
>
> +Paolo and Vitaly
>
> In the future, I highly recommend using scripts/get_maintainers.pl.
>
> On Wed, Mar 30, 2022, Peter Gonda wrote:
> > SEV-ES guests can request termination using the GHCB's MSR protocol. Se=
e
> > AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> > guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> > return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_ru=
n
> > struct the userspace VMM can clearly see the guest has requested a SEV-=
ES
> > termination including the termination reason code set and reason code.
> >
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> >
> > ---
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 75fa6dd268f0..5f9d37dd3f6f 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struc=
t vcpu_svm *svm)
> >               pr_info("SEV-ES guest requested termination: %#llx:%#llx\=
n",
> >                       reason_set, reason_code);
>
> This pr_info() should be removed.  A malicious usersepace could spam the =
kernel
> by constantly running a vCPU that requests termination.

Ah, good catch. But actually, I've found this specific pr_info _very_
useful in debugging. Sean, would you be OK to convert it to a rate
limited print?

> > -             ret =3D -EINVAL;
> > -             break;
> > +             vcpu->run->exit_reason =3D KVM_EXIT_SHUTDOWN;
> > +             vcpu->run->shutdown.reason =3D KVM_SHUTDOWN_SEV_TERM;
> > +             vcpu->run->shutdown.ndata =3D 2;
> > +             vcpu->run->shutdown.data[0] =3D reason_set;
> > +             vcpu->run->shutdown.data[1] =3D reason_code;
>
> Does KVM really need to split the reason_set and reason_code?  Without re=
ading
> the spec, it's not even clear what "set" means.  Assuming it's something =
like
> "the reason code is valid", then I don't see any reason (lol) to split th=
e two.
> If we do split them, then arguably the reason_code should be filled if an=
d only
> if reason_set is true, and that's just extra work.

I think KVM should split the reason_set and reason_code. This code is
based on the GHCB spec after all. And reason_set and reason_code are
both a part of the GHCB spec. But I agree, folks shouldn't have to go
to the spec to understand what reason_set and reason_code are. Rather
than not splitting them up, can we add comments in the source to
explain what they mean?

Also, my understanding from reading the spec is that reason_code
should always be filled, even when reason_set is 0. See below. But
basically, you can have reason_set: 0 and reason_code: non-zero.

Quoting the spec:
The reason code set is meant to provide hypervisors with their own
termination SEV-ES Guest-Hypervisor Communication Block
Standardization reason codes. This document defines and owns reason
code set 0x0 and the following reason codes (GHCBData[23:16]):
0x00 =E2=80=93 General termination request
0x01 =E2=80=93 SEV-ES / GHCB Protocol range is not supported.
0x02 =E2=80=93 SEV-SNP features not supported

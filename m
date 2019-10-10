Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E23D2CB9
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 16:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfJJOmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 10:42:43 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33196 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfJJOmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 10:42:43 -0400
Received: by mail-lf1-f67.google.com with SMTP id y127so4614332lfc.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 07:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YuR3TusfqAXK0rceobyOV+ki7UjUeyNJzHvEP4K6Tdw=;
        b=Y1haPszVhFGkrksK43BDKb7039zA5Tqv01rGbUst32ssimcLR0dryf9KtoOXGsqwm1
         Q7U+92TatEUR5+pkdD29kGoki52/jFkl4JGSrCRE85rgCHvi853s+KU/HMJtL/vLqVTD
         5rPlKuieT3q/YH3E9Om89dxNar2Lv47zBn1U1mmihZL6n3xkzhaznZBz5zB1/1nPRwnx
         4OiEuHneSsOwdWmg0oAjuXB7+UziDAhYx0WBu1EUZzOJLKwQSQlf+AU3v0OD9a9mv8cx
         TcR02jfkou2gownr2w3Od+jfosEp4kak04FzjuW++QD3UXVzbifEuQHIno7YLnhVWYag
         gsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YuR3TusfqAXK0rceobyOV+ki7UjUeyNJzHvEP4K6Tdw=;
        b=iyyIL3npgJGt5GLLmL8gFRxpJzY4dG9nyf2At35Oz3CUYE7vlPCBMykDcOWdj63CE7
         HTxwNNiM1i43DNdKyrTTi91bh2YCkHbWtrlw8SzCvt7VcA8HVXruIgLkwQNuEbA7uWCU
         P1w6oXQ0+kB5ldInAbxzHAatbS7ZN9n+ifmzH1WtbvH/c8LjH2gDD7YPKtc9SDcQlFtY
         cVDXY+Ls7OJDFSapOgRq2L8QORvOAZ0ygQDfoctLAHE8+wKBsJ37NzqQ6TPIl4fCAUyD
         CzeJEhoZFykJyeRkaRgQhgoASZT1dLGA47mzTOJWDG4wpb7cy1ueJALeivO04VEQAbux
         QSDQ==
X-Gm-Message-State: APjAAAWqdBYGEoSvOQW2SBM8E23IcZVWEuKwmpgLPB/NbqrDs9Zl8+wW
        LgmY9429gaLKAkyKNJ0191b5DDNVZtFK717HLUIcWA==
X-Google-Smtp-Source: APXvYqxo3uozeHJKxJkmajKP74sfH+yEEStwaauRNimmla1O2hlEpCDULbuX2fKjqPR6WgCKGovXwQ1TUHjJj3uuuGQ=
X-Received: by 2002:a05:6512:25b:: with SMTP id b27mr6324830lfo.39.1570718560762;
 Thu, 10 Oct 2019 07:42:40 -0700 (PDT)
MIME-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com> <20191009064425.mxxiegsyr7ugiqum@linutronix.de>
In-Reply-To: <20191009064425.mxxiegsyr7ugiqum@linutronix.de>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 10 Oct 2019 07:42:29 -0700
Message-ID: <CAAAPnDHUAxHAfxUMsG0-zbBVGZ1EJx3bB+z327c1HrCYgH2o0g@mail.gmail.com>
Subject: Re: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 8, 2019 at 11:44 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2019-10-08 17:41:39 [-0700], Aaron Lewis wrote:
> > Hoist support for IA32_XSS so it can be used for both AMD and Intel,
>
> Hoist
>
> > instead of for just Intel.
> >
> > AMD has no equivalent of Intel's "Enable XSAVES/XRSTORS" VM-execution
> > control. Instead, XSAVES is always available to the guest when supporte=
d
> > on the host.
>
> You could add that implement the XSAVES check based on host's features
> and move the MSR_IA32_XSS msr R/W from Intel only code to the common
> code.

Isn't this covered by my comments?  I mention that we are hoisting
IA32_XSS to common code in the first comment, then in the second
comment I say that XSAVES is available in the guest when supported on
the host.

>
> =E2=80=A6
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e90e658fd8a9..77f2e8c05047 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2702,6 +2702,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, st=
ruct msr_data *msr_info)
> >       case MSR_IA32_TSC:
> >               kvm_write_tsc(vcpu, msr_info);
> >               break;
> > +     case MSR_IA32_XSS:
> > +             if (!kvm_x86_ops->xsaves_supported() ||
> > +                 (!msr_info->host_initiated &&
> > +                  !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES)))
> > +                     return 1;
>
> I wouldn't ditch the comment. You could explain why only zero is allowed
> to be written. The Skylake is not true for both but this probably
> requires an explanation.
>
> > +             if (data !=3D 0)
> > +                     return 1;
> > +             vcpu->arch.ia32_xss =3D data;
> > +             break;
> >       case MSR_SMI_COUNT:
> >               if (!msr_info->host_initiated)
> >                       return 1;

Resending as plain text!

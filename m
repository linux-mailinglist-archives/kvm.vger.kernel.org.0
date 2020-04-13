Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A461A6432
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 10:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgDMIfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 04:35:54 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40200 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgDMIfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 04:35:51 -0400
Received: by mail-ot1-f67.google.com with SMTP id i27so5490892ota.7
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 01:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AvGw2BENomW5mAjLN7te1eswf7XokhztvBZamCcaYj0=;
        b=uD8A8qgO9EqAhRj5jnTHJFUY7v3Kp1X0ZbRX5+kzzkRJbOVFzZMvIiC0vrd8AEbXu6
         j4U+LKqu1BGr1U7Iyv+gVYNLgnS1VGVayNBYCS2IHfvT2MLP6CobSya5jv/iUGy3TLgI
         nm1wc59YKGg1s266n/VVhr39Z0sn1jSlMGTUPUvRSslX08GMWK3H9oihKMZDUGRoCDcD
         xIAoJTdKpJInqVJYXUnt5AxEf7Yhxw6+V3EFPF7Fd1q8HNMdrOnUyEE4AQi1AgQodiaM
         2vFiaW3n8RvkIVFYrU1b0b3Z7ncEW4wNV2ia112RomwbVmIeuZQ8f08i5g2dGbk/dqaj
         Tb2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AvGw2BENomW5mAjLN7te1eswf7XokhztvBZamCcaYj0=;
        b=CSU/TlPpp0YG2CkrHXm6zpbpdx6g/GZO7XeCoQRpRm4fGBrJICssEhLHy1DzF90q77
         zwWKoN+9AZ35rBt3HYfK4MClALFjsVgGaxIOfrqRGF5PghThtO6JdLHM5ETljoF7MNAt
         /a8jjPOHtwIdn/SNJBYlkkkZM6HbmZdpFciPaxCPPWy5u3EE7rn92tr9kRd1Z238w9MV
         mg6mAFu9PW8DqmysnrMyD89r7MPzSL+HSIA7T2lG1gUtXISCdogPzWHwOKeo6vNDRoQg
         n3t6ph+aPuxVpiGwSPo/BTfUBWIJIuqrdsRqYpv8NOZSTR7LHKg5BLFQaxXxAW886i5b
         HJ9Q==
X-Gm-Message-State: AGi0Pub0G6ah8N6bx2OC608kcVXN/keINzdMOlzqFsYmb66n+m3ROzZg
        NgNmJ/Xu/AqPdpIqKx4S+sr96b3M+Ub4REXXUnJxuA==
X-Google-Smtp-Source: APiQypLGyU2+5UH8I4pQFfkdm4IeQucZnCldFkCGft+bJP32qprqeDoFkHg65jEskDU5xzjopyRhE7fXAcHOLPADm9w=
X-Received: by 2002:a9d:4b84:: with SMTP id k4mr3987928otf.233.1586766950301;
 Mon, 13 Apr 2020 01:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <CANpmjNMR4BgfCxL9qXn0sQrJtQJbEPKxJ5_HEa2VXWi6UY4wig@mail.gmail.com>
 <AC8A5393-B817-4868-AA85-B3019A1086F9@lca.pw> <CANpmjNPqQHKUjqAzcFym5G8kHX0mjProOpGu8e4rBmuGRykAUg@mail.gmail.com>
 <C4FED226-E3DE-44AE-BBED-2B56B9F5B12F@lca.pw>
In-Reply-To: <C4FED226-E3DE-44AE-BBED-2B56B9F5B12F@lca.pw>
From:   Marco Elver <elver@google.com>
Date:   Mon, 13 Apr 2020 10:35:38 +0200
Message-ID: <CANpmjNPSLkiEer3xQHHxJm_4o5Em0i3bvM7TMmNO46Vzv2cwWQ@mail.gmail.com>
Subject: Re: KCSAN + KVM = host reset
To:     Qian Cai <cai@lca.pw>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Apr 2020 at 21:57, Qian Cai <cai@lca.pw> wrote:
>
>
>
> > On Apr 10, 2020, at 7:35 AM, Marco Elver <elver@google.com> wrote:
> >
> > On Fri, 10 Apr 2020 at 13:25, Qian Cai <cai@lca.pw> wrote:
> >>
> >>
> >>
> >>> On Apr 10, 2020, at 5:47 AM, Marco Elver <elver@google.com> wrote:
> >>>
> >>> That would contradict what you said about it working if KCSAN is
> >>> "off". What kernel are you attempting to use in the VM?
> >
> > Ah, sorry this was a typo,
> >  s/working if KCSAN/not working if KCSAN/
> >
> >> Well, I said set KCSAN debugfs to =E2=80=9Coff=E2=80=9D did not help, =
i.e., it will reset the host running kvm.sh. It is the vanilla ubuntu 18.04=
 kernel in VM.
> >>
> >> github.com/cailca/linux-mm/blob/master/kvm.sh
> >
> > So, if you say that CONFIG_KCSAN_INTERRUPT_WATCHER=3Dn works, that
> > contradicts it not working when KCSAN is "off". Because if KCSAN is
> > off, it never sets up any watchpoints, and whether or not
> > KCSAN_INTERRUPT_WATCHER is selected or not shouldn't matter. Does that
> > make more sense?
>
> Yes, you are right. CONFIG_KCSAN_INTERRUPT_WATCHER=3Dn does not
> make it work. It was a mistake when I tested it because there was a stale=
 svm.o
> leftover from the previous run, and then it will not trigger a rebuild (a=
 bug?) when
> only modify the Makefile to remove KCSAN_SANITIZE :=3D n. Sorry for the m=
isleading
> information. I should be checking if svm.o was really recompiled in the f=
irst place.
>
> Anyway, I=E2=80=99ll send a patch to add __no_kcsan for svm_vcpu_run() be=
cause I tried
> to narrow down more with a kcsan_[disable|enable]_current() pair, but it =
does NOT
> work even by enclosing the almost whole function below until Marcro has m=
ore ideas?

This is expected. Instrumentation is not removed if you add
kcsan_{disable,enable}_current() (it has the same effect as a
localized "off"). Since it seems just the instrumentation and
associated calls before every memory access is enough, this won't
work. The attribute __no_kcsan removes instrumentation entirely from
the function. If the non-instrumented code should be reduced, it is
conceivable to take the problematic portion of code and factor it into
a function that has attribute '__no_kcsan_or_inline'.

Thanks,
-- Marco

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2be5bbae3a40..e58b2d5a575c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3286,6 +3286,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>         svm->vmcb->save.rsp =3D vcpu->arch.regs[VCPU_REGS_RSP];
>         svm->vmcb->save.rip =3D vcpu->arch.regs[VCPU_REGS_RIP];
>
> +       kcsan_disable_current();
>         /*
>          * A vmexit emulation is required before the vcpu can be executed
>          * again.
> @@ -3410,6 +3411,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
>                 svm_handle_mce(svm);
>
>         mark_all_clean(svm->vmcb);
> +       kcsan_enable_current();
>  }
>  STACK_FRAME_NON_STANDARD(svm_vcpu_run);
>
>
>
>
>
>

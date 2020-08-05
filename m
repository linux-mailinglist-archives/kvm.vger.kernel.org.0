Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7A223D3BF
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 00:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHEWBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 18:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEWBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 18:01:14 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCD4C061575
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 15:01:14 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g14so10057354iom.0
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 15:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uqSp37oiJ3w72FemAtPMIBTUnDdscTROB5pBcLt5rd0=;
        b=kUBOi5LEbff5SYUv8Kj67EPVrLNyodhY0aEE7NLRhaHu5Jcn4oNQ8ce9aZmyXfFH6r
         M3mM8QDG5b1GuFhImA+pXKlYM4JOaXDSrHD+dvuM2JpvfRIyuL7aiboxzSHlRLgnHyTf
         FA3EjiYSqxOwwehuwJiFMpHebW95HZyjOIbGX5PD+ATu90YMMEY1znRnFHDxrxbeDgtg
         dJvi+Ted7uO2aW0rvgq6aXlCtYAmGGAPXJ00EBUvJO+MLYp34cDPA38wBGhBqG5nT0Ly
         7OakiBjJv2J1NjkpAGioOEaHl/DpsGZJs7iyCQh+rAmkkSjL4UjcFfS51251u7+LUPMM
         GvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uqSp37oiJ3w72FemAtPMIBTUnDdscTROB5pBcLt5rd0=;
        b=ftjpdAtr4vOND6GDcpA5oxgQQpOoaVWERMGIi8JQtCnGoOZARglqa5hErbCjVuAJAC
         ODvy0TpfBIooYrojFP7V7QhMWvS5ZHg5iLNzXnBhKYPPGziX+79EfjwL6X+8zjGkGifl
         zZia0WD6cKnKSvciivPgkp5VaMcg+a+/OhA2mAtzgli04ufpHvJUoD84529jM8PLDN+w
         jHzoLIFWhT+sI4cyx44Z0H2mIy1DGQXeNjRtswubjAUmty9nmUggBcEtjEj+cGG/axpn
         TyDKuMxQbmImrHgQAB6hhnR+9fF03WeiWsq0Qma6C2wNN6LfNzXuLKxwTZldhEzVNyIs
         qMnw==
X-Gm-Message-State: AOAM532t7QGD+v41YVn6F8SvABi1MQjzQKjSZ5fHAw10OEcoZiE92AWi
        nqIjWGp+WbEeE83U36kfsYvlWX4hS7jkskSnDiSVkQ==
X-Google-Smtp-Source: ABdhPJxoJbK/ULwgLZwQkvJOfupOfkpqCjvr7v/8XZUUR18oWyq3bcPO1XT54lu9raGWfduwPeU5bgxhLnH8GuiS24c=
X-Received: by 2002:a6b:b4d1:: with SMTP id d200mr5666197iof.70.1596664873048;
 Wed, 05 Aug 2020 15:01:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com> <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
 <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
 <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com> <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
In-Reply-To: <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 5 Aug 2020 15:01:01 -0700
Message-ID: <CALMp9eQ4zPoRfPQJ2c7H-hyqCWu+B6fjXk+7SsEOvK7aR49ZJg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 5, 2020 at 2:33 PM Oliver Upton <oupton@google.com> wrote:
>
> On Wed, Aug 5, 2020 at 1:46 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 05/08/20 18:06, Oliver Upton wrote:
> > > On Tue, Jul 28, 2020 at 11:33 AM Oliver Upton <oupton@google.com> wrote:
> > >>
> > >> On Tue, Jul 21, 2020 at 8:26 PM Oliver Upton <oupton@google.com> wrote:
> > >>>
> > >>> To date, VMMs have typically restored the guest's TSCs by value using
> > >>> the KVM_SET_MSRS ioctl for each vCPU. However, restoring the TSCs by
> > >>> value introduces some challenges with synchronization as the TSCs
> > >>> continue to tick throughout the restoration process. As such, KVM has
> > >>> some heuristics around TSC writes to infer whether or not the guest or
> > >>> host is attempting to synchronize the TSCs.
> > >>>
> > >>> Instead of guessing at the intentions of a VMM, it'd be better to
> > >>> provide an interface that allows for explicit synchronization of the
> > >>> guest's TSCs. To that end, this series introduces the
> > >>> KVM_{GET,SET}_TSC_OFFSET ioctls, yielding control of the TSC offset to
> > >>> userspace.
> > >>>
> > >>> v2 => v3:
> > >>>  - Mark kvm_write_tsc_offset() as static (whoops)
> > >>>
> > >>> v1 => v2:
> > >>>  - Added clarification to the documentation of KVM_SET_TSC_OFFSET to
> > >>>    indicate that it can be used instead of an IA32_TSC MSR restore
> > >>>    through KVM_SET_MSRS
> > >>>  - Fixed KVM_SET_TSC_OFFSET to participate in the existing TSC
> > >>>    synchronization heuristics, thereby enabling the KVM masterclock when
> > >>>    all vCPUs are in phase.
> > >>>
> > >>> Oliver Upton (4):
> > >>>   kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
> > >>>   kvm: vmx: check tsc offsetting with nested_cpu_has()
> > >>>   selftests: kvm: use a helper function for reading cpuid
> > >>>   selftests: kvm: introduce tsc_offset_test
> > >>>
> > >>> Peter Hornyack (1):
> > >>>   kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
> > >>>
> > >>>  Documentation/virt/kvm/api.rst                |  31 ++
> > >>>  arch/x86/include/asm/kvm_host.h               |   1 +
> > >>>  arch/x86/kvm/vmx/vmx.c                        |   2 +-
> > >>>  arch/x86/kvm/x86.c                            | 147 ++++---
> > >>>  include/uapi/linux/kvm.h                      |   5 +
> > >>>  tools/testing/selftests/kvm/.gitignore        |   1 +
> > >>>  tools/testing/selftests/kvm/Makefile          |   1 +
> > >>>  .../testing/selftests/kvm/include/test_util.h |   3 +
> > >>>  .../selftests/kvm/include/x86_64/processor.h  |  15 +
> > >>>  .../selftests/kvm/include/x86_64/svm_util.h   |  10 +-
> > >>>  .../selftests/kvm/include/x86_64/vmx.h        |   9 +
> > >>>  tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
> > >>>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  11 +
> > >>>  .../selftests/kvm/x86_64/tsc_offset_test.c    | 362 ++++++++++++++++++
> > >>>  14 files changed, 550 insertions(+), 49 deletions(-)
> > >>>  create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_offset_test.c
> > >>>
> > >>> --
> > >>> 2.28.0.rc0.142.g3c755180ce-goog
> > >>>
> > >>
> > >> Ping :)
> > >
> > > Ping
> >
> > Hi Oliver,
> >
> > I saw these on vacation and decided I would delay them to 5.10.  However
> > they are definitely on my list.
> >
>
> Hope you enjoyed vacation!
>
> > I have one possibly very stupid question just by looking at the cover
> > letter: now that you've "fixed KVM_SET_TSC_OFFSET to participate in the
> > existing TSC synchronization heuristics" what makes it still not
> > "guessing the intentions of a VMM"?  (No snark intended, just quoting
> > the parts that puzzled me a bit).
>
> Great point.
>
> I'd still posit that this series disambiguates userspace
> control/synchronization of the TSCs. If a VMM wants the TSCs to be in
> sync, it can write identical offsets to all vCPUs
>
> That said, participation in TSC synchronization is presently necessary
> due to issues migrating a guest that was in the middle of a TSC sync.
> In doing so, we still accomplish synchronization on the other end of
> migration with a well-timed mix of host and guest writes.
>
> >
> > My immediate reaction was that we should just migrate the heuristics
> > state somehow
>
> Yeah, I completely agree. I believe this series fixes the
> userspace-facing issues and your suggestion would address the
> guest-facing issues.
>
> > but perhaps I'm missing something obvious.
>
> Not necessarily obvious, but I can think of a rather contrived example
> where the sync heuristics break down. If we're running nested and get
> migrated in the middle of a VMM setting up TSCs, it's possible that
> enough time will pass that we believe subsequent writes to not be of
> the same TSC generation.

An example that has been biting us frequently in self-tests: migrate a
VM with less than a second accumulated in its TSC. At the destination,
the TSCs are zeroed.

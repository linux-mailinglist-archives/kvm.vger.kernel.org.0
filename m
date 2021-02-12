Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F33F31A590
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhBLTl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhBLTl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 14:41:28 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF8EC061574
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 11:40:48 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id h6so864017oie.5
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 11:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/c4b6yKz0HEXc6n/wiM7Hlpo39HbqmngeOXmBMZY3lg=;
        b=DSEPVDKXJzYMeKLh6gaACh5qYoI6oEEcYv3FeC6FDvmRWXz5lJaZR7vEa+Vpx1jGHY
         yA4Suf2p0S3bUuMN7TNL38kDkb34A05WBhsnMN+jTRe/HVi6osBWVE68zZtAXUzXeScA
         pr9JlehFIQsO0d9KG4YJd2fiVAuRmcqhaoZcSqhHH8qlG3EJKKINh/b8NaaPi0vSt+Dt
         dS/gY7dqb0t8oAyhJKQVmL4SvYsLCYJ6VrsPF6ZnOyrpTw1+Uz3S+oJGHOUeQ7puIaa7
         LKtkQSggo0PnSHhEOMzn3S1PjDEv5WrrZX/f26T8ybFEZJDhieMr6VEdUmO6jYU9O2Al
         BpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/c4b6yKz0HEXc6n/wiM7Hlpo39HbqmngeOXmBMZY3lg=;
        b=BoGkQSKYDFu0o9WeJ+PpOUhTEvDn1TlW/WfFMDrDOA3HuaXUSGEUFR8iXnoxrggItQ
         JP/CZLhbKFtoH89WpcROa98D/wl0tq5YfKN0U2I9H+lzXIDzRZVXJEFbsjTELHfagEvY
         NWMPojQ/suaXDQLfcYc/HUKHekhv+rzVxTnqpiUBuCa7WtBvor9356n5CCCB+oVSjime
         8p9+yJNThqWBrVfTaDSdERLWetfko7ZoEkFfzIpn1Dxish3DSlYGPXTFW6JDj7qeZLCF
         Ul/oZaRwQUbp72y6SRoY3seMnDdlNkrFvRUo/ChY+BYYgZ1liwTXLO2J4n7gzJT9cyri
         GWEQ==
X-Gm-Message-State: AOAM531r3K7O0fL9rvVGbMRzD3mOcuJ7W7m4v6UNiGOZ3D3FmzTeL/uW
        lhudb8yPa0D797KcB9u08jQi1+nz2Rkta+heSWLayA==
X-Google-Smtp-Source: ABdhPJzf7QbMwjMydTJ8cYH0nai8OX2AsFdxcNYQrxVMIgZN0LGnjXhVNAYUX53ufFKTNI3JMjcO4ni4w4Zpx/8uh/k=
X-Received: by 2002:aca:5008:: with SMTP id e8mr778248oib.13.1613158847192;
 Fri, 12 Feb 2021 11:40:47 -0800 (PST)
MIME-Version: 1.0
References: <20210211212241.3958897-1-bsd@redhat.com> <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
 <jpgo8gpbath.fsf@linux.bootlegged.copy> <CALMp9eQ370MQ1ZPtby4ezodCga9wDeXXGTcrqoXjj03WPJOEhQ@mail.gmail.com>
 <jpg35y1f9x8.fsf@linux.bootlegged.copy> <CALMp9eSk1Ar0UB0udM050sZpGaG_OGL3kOs4LbQ+bigUr_s8CA@mail.gmail.com>
 <jpgy2ft6sn5.fsf@linux.bootlegged.copy>
In-Reply-To: <jpgy2ft6sn5.fsf@linux.bootlegged.copy>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 12 Feb 2021 11:40:35 -0800
Message-ID: <CALMp9eTC2YmG04WVVav-bgzq=6oZbu_5kd-6Dfog3SjkBJcHmg@mail.gmail.com>
Subject: Re: [PATCH 0/3] AMD invpcid exception fix
To:     Bandan Das <bsd@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Huang2, Wei" <wei.huang2@amd.com>,
        "Moger, Babu" <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021 at 10:35 AM Bandan Das <bsd@redhat.com> wrote:
>
> Jim Mattson <jmattson@google.com> writes:
>
> > On Fri, Feb 12, 2021 at 9:55 AM Bandan Das <bsd@redhat.com> wrote:
> >>
> >> Jim Mattson <jmattson@google.com> writes:
> >>
> >> > On Fri, Feb 12, 2021 at 6:49 AM Bandan Das <bsd@redhat.com> wrote:
> >> >>
> >> >> Paolo Bonzini <pbonzini@redhat.com> writes:
> >> >>
> >> >> > On 11/02/21 22:22, Bandan Das wrote:
> >> >> >> The pcid-disabled test from kvm-unit-tests fails on a Milan host because the
> >> >> >> processor injects a #GP while the test expects #UD. While setting the intercept
> >> >> >> when the guest has it disabled seemed like the obvious thing to do, Babu Moger (AMD)
> >> >> >> pointed me to an earlier discussion here - https://lkml.org/lkml/2020/6/11/949
> >> >> >>
> >> >> >> Jim points out there that  #GP has precedence over the intercept bit when invpcid is
> >> >> >> called with CPL > 0 and so even if we intercept invpcid, the guest would end up with getting
> >> >> >> and "incorrect" exception. To inject the right exception, I created an entry for the instruction
> >> >> >> in the emulator to decode it successfully and then inject a UD instead of a GP when
> >> >> >> the guest has it disabled.
> >> >> >>
> >> >> >> Bandan Das (3):
> >> >> >>    KVM: Add a stub for invpcid in the emulator table
> >> >> >>    KVM: SVM: Handle invpcid during gp interception
> >> >> >>    KVM: SVM:  check if we need to track GP intercept for invpcid
> >> >> >>
> >> >> >>   arch/x86/kvm/emulate.c |  3 ++-
> >> >> >>   arch/x86/kvm/svm/svm.c | 22 +++++++++++++++++++++-
> >> >> >>   2 files changed, 23 insertions(+), 2 deletions(-)
> >> >> >>
> >> >> >
> >> >> > Isn't this the same thing that "[PATCH 1/3] KVM: SVM: Intercept
> >> >> > INVPCID when it's disabled to inject #UD" also does?
> >> >> >
> >> >> Yeah, Babu pointed me to Sean's series after I posted mine.
> >> >> 1/3 indeed will fix the kvm-unit-test failure. IIUC, It doesn't look like it
> >> >> handles the case for the guest executing invpcid at CPL > 0 when it's
> >> >> disabled for the guest - #GP takes precedence over intercepts and will
> >> >> be incorrectly injected instead of an #UD.
> >> >
> >> > I know I was the one to complain about the #GP, but...
> >> >
> >> > As a general rule, kvm cannot always guarantee a #UD for an
> >> > instruction that is hidden from the guest. Consider, for example,
> >> > popcnt, aesenc, vzeroall, movbe, addcx, clwb, ...
> >> > I'm pretty sure that Paolo has brought this up in the past when I've
> >> > made similar complaints.
> >>
> >> Ofcourse, even for vm instructions failures, the fixup table always jumps
> >> to a ud2. I was just trying to address the concern because it is possible
> >> to inject the correct exception via decoding the instruction.
> >
> > But kvm doesn't intercept #GP, except when enable_vmware_backdoor is
> > set, does it? I don't think it's worth intercepting #GP just to get
> > this #UD right.
>
> I prefer following the spec wherever we can.

One has to wonder why userspace is even trying to execute a privileged
instruction not enumerated by CPUID, unless it's just trying to expose
virtualization inconsistencies. Perhaps this could be controlled by a
new module parameter: "pedantic."

> Otoh, if kvm can't guarantee injecting the right exception,
> we should change kvm-unit-tests to just check for exceptions and not a specific
> exception that adheres to the spec. This one's fine though, as long as we don't add
> a CPL > 0 invpcid test, the other patch that was posted fixes it.

KVM *can* guarantee the correct exception, but it requires
intercepting all #GPs. That's probably not a big deal, but it is a
non-zero cost. Is it the right tradeoff to make?

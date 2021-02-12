Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C598F31A3F0
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 18:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhBLRoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 12:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhBLRoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 12:44:01 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903B4C061574
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 09:43:22 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id q4so9127548otm.9
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 09:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ueLsT1PpHayONbeA4wkp8qTUPi1HCXdgnM5hYRnL65c=;
        b=JwRCJS2Zy/S3drhk2ntApJokf9CtdDQEyvBxMU5/puiVAOV0a31zJjpB3AtUNXDmhY
         aInOpBdD5+v5ia8n+dNiwuGxzl6Ei+O24NczJYv4FsEUWD3n8WNP8n8kItznd3eOCJCL
         Up9ogRRY7OCP5Oo8WJ2KESpwr9cieA0Bjf+xOeHdMR12+qUJTdKtjcWLqahcYqEVNAvt
         7pdVpfkqO+4sEYgQxqjOizhTSZ970GynqtRY3KEYcOV+2z8OR+lQYVIWzXYv4kN1RMBL
         SzeGE4XvC4zwIAAmPamWKJeQf+hMgca5mmq2m8iblEPcS0xWlJaqeLYHOyoPRbst8gcS
         0XoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ueLsT1PpHayONbeA4wkp8qTUPi1HCXdgnM5hYRnL65c=;
        b=FSu1LETMNHfenhwz7U3cqENeRRTu/CPcpHagajV61ovYoMI6pNN8G9y68LTcVwuMzc
         kYngTLdDzKpoksSPScDYU9MaIZnp2c+UkDvlqB6wHD0qU2eMc5RsGmKVU2VAygKg5t6q
         HENgiNZV/oONkga4ypwDhDYwkFMwLdGUX0RrarGwoF/10wMzZjWbbntu6rp9GQsIdtqS
         vg96/wck/CacgRQxg8qH+JDNz+cVbakxboJ9smR2d5X/H5voZoXlmmlpZtSeigcpNMzK
         ZrbxJIOFg8xPLgXecai4EbFrev2eDLfuddtDYGKisYzhfnyYVYIqAjI4N7tFtGN+IFYq
         BJow==
X-Gm-Message-State: AOAM5328be12WGVx7dKqbq2ye+aCIbicqcROOPwkZu5KoZJTjoDD0ILn
        Jsi1Vpgt0gFO0DHX7RpJ80kmW9J2SIp+iZsOk9MtWg==
X-Google-Smtp-Source: ABdhPJyy2ltjG5PPOUmwdB5lU5hXiCeiEyjFSK77X2hUAi5XOeBxqjcW9+sg/AeXp0bfcnxLuHePDB5qHe5L3SM9j10=
X-Received: by 2002:a05:6830:543:: with SMTP id l3mr2867099otb.241.1613151801618;
 Fri, 12 Feb 2021 09:43:21 -0800 (PST)
MIME-Version: 1.0
References: <20210211212241.3958897-1-bsd@redhat.com> <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
 <jpgo8gpbath.fsf@linux.bootlegged.copy>
In-Reply-To: <jpgo8gpbath.fsf@linux.bootlegged.copy>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 12 Feb 2021 09:43:10 -0800
Message-ID: <CALMp9eQ370MQ1ZPtby4ezodCga9wDeXXGTcrqoXjj03WPJOEhQ@mail.gmail.com>
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

On Fri, Feb 12, 2021 at 6:49 AM Bandan Das <bsd@redhat.com> wrote:
>
> Paolo Bonzini <pbonzini@redhat.com> writes:
>
> > On 11/02/21 22:22, Bandan Das wrote:
> >> The pcid-disabled test from kvm-unit-tests fails on a Milan host because the
> >> processor injects a #GP while the test expects #UD. While setting the intercept
> >> when the guest has it disabled seemed like the obvious thing to do, Babu Moger (AMD)
> >> pointed me to an earlier discussion here - https://lkml.org/lkml/2020/6/11/949
> >>
> >> Jim points out there that  #GP has precedence over the intercept bit when invpcid is
> >> called with CPL > 0 and so even if we intercept invpcid, the guest would end up with getting
> >> and "incorrect" exception. To inject the right exception, I created an entry for the instruction
> >> in the emulator to decode it successfully and then inject a UD instead of a GP when
> >> the guest has it disabled.
> >>
> >> Bandan Das (3):
> >>    KVM: Add a stub for invpcid in the emulator table
> >>    KVM: SVM: Handle invpcid during gp interception
> >>    KVM: SVM:  check if we need to track GP intercept for invpcid
> >>
> >>   arch/x86/kvm/emulate.c |  3 ++-
> >>   arch/x86/kvm/svm/svm.c | 22 +++++++++++++++++++++-
> >>   2 files changed, 23 insertions(+), 2 deletions(-)
> >>
> >
> > Isn't this the same thing that "[PATCH 1/3] KVM: SVM: Intercept
> > INVPCID when it's disabled to inject #UD" also does?
> >
> Yeah, Babu pointed me to Sean's series after I posted mine.
> 1/3 indeed will fix the kvm-unit-test failure. IIUC, It doesn't look like it
> handles the case for the guest executing invpcid at CPL > 0 when it's
> disabled for the guest - #GP takes precedence over intercepts and will
> be incorrectly injected instead of an #UD.

I know I was the one to complain about the #GP, but...

As a general rule, kvm cannot always guarantee a #UD for an
instruction that is hidden from the guest. Consider, for example,
popcnt, aesenc, vzeroall, movbe, addcx, clwb, ...
I'm pretty sure that Paolo has brought this up in the past when I've
made similar complaints.

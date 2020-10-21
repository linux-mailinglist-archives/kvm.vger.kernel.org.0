Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7212951A0
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 19:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503640AbgJURhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 13:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409082AbgJURhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 13:37:25 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DE7C0613CE
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 10:37:24 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 32so2603551otm.3
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 10:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+6rsahnTh6IwzoSQbeFyy4U0A2i3OAbCgqwKf1B0Cas=;
        b=Z4MtwaQkCSTHes7oMEgo9TBNB6B8L2e+PqgkU0l8vr09w4KR/UVhMP8OLBouMnl8o+
         uoNH1/WyZcGgJQWrptjV0vkQPFIRYFJwTXTIKMGocqBHIGsQiGiT3eSruPAH8lefdvV+
         60+AOHDsatEWY6/uJQhvtjbwLLWaFmaXHddmYSqAZsFetntGceffzL6lsi4tQYkYAs+q
         5LGgxYne1cAanK5cc+z2XQBRnZSjj2tbSr4Q9K1RseGaCSk8C3sk3SaOzmQrh3M/dKZF
         eXQCs3MNmiq6iTHrcjnPuc3ADWeMAMSTKBCcelBE70W8f1AuYf7xA9ajt+zrhdgjzvkF
         BrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+6rsahnTh6IwzoSQbeFyy4U0A2i3OAbCgqwKf1B0Cas=;
        b=omxW4pxApFIpBTsmBx12RxJZQV0lUFH2stwn17aePimGe5KXMMxI0YBzRskUrvumH7
         tLbOBAPl3BL4GFGOBQ+O11Kb8meV/zhaGlph9vqqYOhVfn6soI1mijxsC05FQIiRDoie
         ljJuKreENxNeZaY7kBrU2jcyxheE7QPVishWbapQ6Hd4JYer7V8lgPL86qGE1Si989rd
         LURUXPPd8jYia8qdtqjwDwnodXFDP/1ESO2ZUhD5OMXvHqi8c1zTpoW4JDFzO7BrJO0E
         /pb8a17yXL7UNBIVgSK5LjiuSbdYLR1yd0BIT2epLXzFAtHOm5bCixSlnlcOtQRpBlL9
         fwAA==
X-Gm-Message-State: AOAM530CbmdRk7sCF76vVDYMfFpbhV7lxk8ySei0uNauUDp6l+t/fRsP
        qq4sS0zxX7gssfQE6k5lJsNC2Ss6oVI5M6r/Huyrcw==
X-Google-Smtp-Source: ABdhPJzsHwm6VPJRwkOM1YLacsTtXR6ZnH+Ufk0UO9v6hJVFGYcmvvhhxLg1gLr+wGBhNuPnnOAQZbXssYOLpfqx1Lw=
X-Received: by 2002:a9d:51c4:: with SMTP id d4mr3260407oth.56.1603301844015;
 Wed, 21 Oct 2020 10:37:24 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRYN7acRAOhoVWjz+WuYpB6g40NYNo9zXYe4yXVqTFQzQ@mail.gmail.com>
 <CANRm+Cy4Ho7KF0Ay99mY+VuZPo8dkkh7kKRqjgY_QzPcVy5MCw@mail.gmail.com> <87blgv4ofw.fsf@vitty.brq.redhat.com>
In-Reply-To: <87blgv4ofw.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Oct 2020 10:37:12 -0700
Message-ID: <CALMp9eThJq=zhZ2qmLDzROM+ZYXwRPdSVuZG2RteRiWkN8jjbw@mail.gmail.com>
Subject: Re: CPUID.40000001H:EDX.KVM_HINTS_REALTIME[bit 0]
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 7:57 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > On Wed, 21 Oct 2020 at 14:47, Jim Mattson <jmattson@google.com> wrote:
> >>
> >> Per the KVM_GET_SUPPORTED_CPUID ioctl, the KVM_HINTS_REALTIME CPUID
> >> bit is never supported.
> >>
> >> Is this just an oversight?
> >
> > It is a performance hint, not a PV feature and doesn't depend on KVM.
> >
>
> True, but personally I'd prefer it to be reported in
> KVM_GET_SUPPORTED_CPUID too, that would mean that userspace is in its
> right to set it, just like any other PV 'thingy', even if just for
> consistency.

I agree. The documentation says:

This ioctl returns x86 cpuid features which are supported by both the
hardware and kvm in its default configuration.

If the bit isn't set, then it is not supported, and a well-behaved
userspace will not set it.

Now, if the bit were in a completely different CPUID leaf (not a
KVM-defined leaf), then one could argue that it falls outside of the
realm of KVM_GET_SUPPORTED_CPUID. But it isn't, is it?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C8F2956A4
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 05:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895316AbgJVDOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 23:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895313AbgJVDOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 23:14:51 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB684C0613CE
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 20:14:51 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id v123so24049ooa.5
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 20:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dFHeJScC+ePMHhspsU29EXyqBGnRxRFhKnOZsal/2Z4=;
        b=uhoER0Nc5mxRDzrs9Mh4Qq2Nn+Rq1Wrihx+Jk3Vy55Ir1jtem+75XsaLreqnQAlnq2
         SB/TvfWkaS6hsy+AeRidQK+YV86gnFcvRyY8rasjkmHWAEk2BOpTFYl07Yyq8aNqMKql
         ReLiZ/JRwFHhVgaZvj9KmXX2hO8YjtwpZFTfFDXsXJOnlu67Uui4502ujLTzD/JeKBw3
         QP6PnqpTY3jWSEo21xeocov9VoXqUCqAjGDj1hdpDZp2rJpNrqmH+7RCU0FpRQc4eB4t
         3j+OgIeZP4XlZhWtdcEmdnr5+Yfl8rgRec2ZDFgyosPQQS03b7PryJmRSQMjRBsPszgC
         M6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dFHeJScC+ePMHhspsU29EXyqBGnRxRFhKnOZsal/2Z4=;
        b=KoOqIAQwOEc6VxyWXn64tqQXNp1dLW+w8ZNlkWg5/NVAUS+wjiltO/ouK1JmakUbwI
         AZra0nYvM/Q/HkvlzJtdyE+wFvTuIy5Add+dfrdZjTkVFGs/BYtLI3/P/vrBomAqlmal
         ARzyI7eufFyV9f+DyvfIsSH+7NXw0asuuXuR0NPmAH5dXm7SPdbGV/eQrSPNn4r0Rksa
         pASXBw1wpRVtpwnc0X+XqO2ujg3JK99fpVyiKtF4Sw8kOkHVDl02MPUJ4RSizrWCKOOM
         8HATZNnVGDWQvuHrFrpXyjCZQSMN7Tz1xnC3rG/Oun3kaLuIcsua8ODrCY4i1c6/lCvL
         O8KQ==
X-Gm-Message-State: AOAM530BBhgSTC0ZYW8zkQDcelXU42L0slU5IMnCLGnZoje7jpxZjYYK
        ferSjmcilVRQ+k7rNGiz3GA+OQCs9DBn0aBRtQk=
X-Google-Smtp-Source: ABdhPJyOEOgRezRyhVDcsDzv5KAKIJ7iZy0CbEHJiIICCsFSboV1+orYo5TRgsPNMvQ9HxEpCvINu0InZAu3ZOcNxdk=
X-Received: by 2002:a4a:c54:: with SMTP id n20mr480108ooe.66.1603336491280;
 Wed, 21 Oct 2020 20:14:51 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRYN7acRAOhoVWjz+WuYpB6g40NYNo9zXYe4yXVqTFQzQ@mail.gmail.com>
 <CANRm+Cy4Ho7KF0Ay99mY+VuZPo8dkkh7kKRqjgY_QzPcVy5MCw@mail.gmail.com>
 <87blgv4ofw.fsf@vitty.brq.redhat.com> <CALMp9eThJq=zhZ2qmLDzROM+ZYXwRPdSVuZG2RteRiWkN8jjbw@mail.gmail.com>
In-Reply-To: <CALMp9eThJq=zhZ2qmLDzROM+ZYXwRPdSVuZG2RteRiWkN8jjbw@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 22 Oct 2020 11:14:39 +0800
Message-ID: <CANRm+Cyu_+NXbVCxg_uCd0ZN+U7HWAMEp-=fwn7+g-ZY6ztvNw@mail.gmail.com>
Subject: Re: CPUID.40000001H:EDX.KVM_HINTS_REALTIME[bit 0]
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 at 01:37, Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Oct 21, 2020 at 7:57 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > Wanpeng Li <kernellwp@gmail.com> writes:
> >
> > > On Wed, 21 Oct 2020 at 14:47, Jim Mattson <jmattson@google.com> wrote:
> > >>
> > >> Per the KVM_GET_SUPPORTED_CPUID ioctl, the KVM_HINTS_REALTIME CPUID
> > >> bit is never supported.
> > >>
> > >> Is this just an oversight?
> > >
> > > It is a performance hint, not a PV feature and doesn't depend on KVM.
> > >
> >
> > True, but personally I'd prefer it to be reported in
> > KVM_GET_SUPPORTED_CPUID too, that would mean that userspace is in its
> > right to set it, just like any other PV 'thingy', even if just for
> > consistency.
>
> I agree. The documentation says:
>
> This ioctl returns x86 cpuid features which are supported by both the
> hardware and kvm in its default configuration.
>
> If the bit isn't set, then it is not supported, and a well-behaved
> userspace will not set it.
>
> Now, if the bit were in a completely different CPUID leaf (not a
> KVM-defined leaf), then one could argue that it falls outside of the
> realm of KVM_GET_SUPPORTED_CPUID. But it isn't, is it?

Fair enough, just sent out a patch.

    Wanpeng

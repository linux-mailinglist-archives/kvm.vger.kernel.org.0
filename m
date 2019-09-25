Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEC2BDE2D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 14:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732410AbfIYMjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 08:39:37 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46296 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfIYMjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 08:39:36 -0400
Received: by mail-oi1-f193.google.com with SMTP id k25so4713987oiw.13
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 05:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xf5vFOXD7Mv1BXn2YAX9IJHa9Xt+SJ9sCNHzT8AZ1Ps=;
        b=dCtfYAMuI1zy2cjUfy0dkwHxfOr7av8c3ZaGzCU4DRtX0mV0jBUKVvwXyTmeHU5HJv
         HdmdaRaecpCXNkf8QdUjFwrYaLvjnq+gExJG4KrTo/xxXuqD4FXNLFuSSx8qe1T5ewkl
         pxT26rXIDQ1m2bZa0rjApefRPbqCj+tXgHnbTIcJsUo2jqawOtClMe0fOJ8aiEGUDw2s
         +ZTWnZfbFvJRp4hn4U3VTTkj+eQOFGGgcH10V1oBSjn3ARywPSGdFN+NRZ039vDIl+lf
         3IRBi7uV9LdDHFmhQgAXk4JQkPQ70R6exw37A0nxxneOlc2Hsl2nXZoClQYra7H47EER
         jeug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xf5vFOXD7Mv1BXn2YAX9IJHa9Xt+SJ9sCNHzT8AZ1Ps=;
        b=EF39W0lK/lMjmSWDs4y/5wEjfhVi6mSgMBPjBWZM36hT8lvwfFNGchBoVdn+o3IGj5
         uU0WFCUUxUcqIZVbEnPXYOwPw5ZwpQzVvi2hPII8R69qjQdGJ7rJL87gffa2682EwejR
         GFaQuL+AL/r72FlBvtvrWNzqlMvYtJd9d9CSyYPek5Jwmoby7dwL08NHpRVwwvgZjyX9
         1PlXDSKNAF/19GNXPa6jxwrZCSU77Gy5pZZeZ8lFrXqJ9HCOVZYVEl/A8cfYRuOhBvHE
         +46E6zzu1N5afXDZYFzMVrNKpUM4c01kgZ5uydhkPjOGeELgQGWRrQYIMcda61ZTE7nX
         +5kg==
X-Gm-Message-State: APjAAAWa8gc/iiF+AQG5GSx95INJFNf7vBLyv8VzHCMeS/2V8vL1w+Vz
        gCU1jc1ccmGcN+ilWItyfQll0TTz6dO1z2lsVWGeCw==
X-Google-Smtp-Source: APXvYqxYMpY1dlzqlS4B9tujbrtFz7tvtCmcTYopohKNOD2tKHVk1C09pXvx/8PLbfyHONbP+cLdD/90Th9/X6mBjFg=
X-Received: by 2002:aca:b646:: with SMTP id g67mr4371688oif.163.1569415175883;
 Wed, 25 Sep 2019 05:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190924124433.96810-1-slp@redhat.com> <CAFEAcA_2-achqUpTk1fDGWXcWPvTTLPvEtL+owNSWuZ5L3p=XA@mail.gmail.com>
 <87pnjosz3d.fsf@redhat.com> <2d5d7297-0a02-276b-5482-948321f5a8bc@redhat.com>
In-Reply-To: <2d5d7297-0a02-276b-5482-948321f5a8bc@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 25 Sep 2019 13:39:24 +0100
Message-ID: <CAFEAcA-bQvP1vA1E6jCeDz4LnqTwT8HoQWtDE3r4--zkRJsMYw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     Sergio Lopez <slp@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Sep 2019 at 12:33, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> On 9/25/19 7:51 AM, Sergio Lopez wrote:
> > Peter Maydell <peter.maydell@linaro.org> writes:
> >
> >> On Tue, 24 Sep 2019 at 14:25, Sergio Lopez <slp@redhat.com> wrote:
> >>>
> >>> Microvm is a machine type inspired by both NEMU and Firecracker, and
> >>> constructed after the machine model implemented by the latter.
> >>>
> >>> It's main purpose is providing users a minimalist machine type free
> >>> from the burden of legacy compatibility, serving as a stepping stone
> >>> for future projects aiming at improving boot times, reducing the
> >>> attack surface and slimming down QEMU's footprint.
> >>
> >>
> >>>  docs/microvm.txt                 |  78 +++
> >>
> >> I'm not sure how close to acceptance this patchset is at the
> >> moment, so not necessarily something you need to do now,
> >> but could new documentation in docs/ be in rst format, not
> >> plain text, please? (Ideally also they should be in the right
> >> manual subdirectory, but documentation of system emulation
> >> machines at the moment is still in texinfo format, so we
> >> don't have a subdir for it yet.)
> >
> > Sure. What I didn't get is, should I put it in "docs/microvm.rst" or in
> > some other subdirectory?
>
> Should we introduce docs/machines/?

This should live in the not-yet-created docs/system (the "system emulation
user's guide"), along with much of the content currently still in
the texinfo docs. But we don't have that structure yet and won't
until we do the texinfo conversion, so I think for the moment we
have two reasonable choices:
 (1) put it in the texinfo, so it is at least shipped to
     users until we get around to doing our docs conversion
 (2) leave it in docs/microvm.rst for now (we have a bunch
     of other docs in docs/ which are basically there because
     they're also awaiting the texinfo conversion and creation
     of the docs/user and docs/system manuals)

My ideal vision of how to do documentation of individual
machines, incidentally, would be to do it via doc comments
or some other kind of structured markup in the .c files
that define the machine, so that we could automatically
collect up the docs for the machines we're building,
put them in to per-architecture sections of the docs,
have autogenerated stub "this machine exists but isn't
documented yet" entries, etc. But that's not something that
we could easily do today so I don't want to block interim
improvements to our documentation just because I have some
nice theoretical idea for how it ought to work :-)

thanks
-- PMM

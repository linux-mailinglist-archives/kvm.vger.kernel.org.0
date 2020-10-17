Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6C1291041
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 08:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437245AbgJQG4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 02:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437244AbgJQG4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 02:56:03 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F3FC0613D4
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 23:56:03 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id p15so5125364ljj.8
        for <kvm@vger.kernel.org>; Fri, 16 Oct 2020 23:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wzkWOoKjInRI+O5FvJvA/t/AUj8a5RTpGl8TvIyMwpk=;
        b=qT5tSTupKtI9+LV08l4NhIywJjENbE/1819qMpMZ4wleQCC2UZcegHiJKzfH1HMZ3e
         VQ39ggQjsnoUsTrwcVQ97D1zQSE6mutGso5Q8ogf39SUNsMEKhaYEUFy/VRoirOjmt9b
         37fnHoejXu8BkEr6+HM11CFBIeNasDURFIHxGHoIweZ8GffWeTWMHjs1yf08SJ9aElhz
         uVubdWIw6/aHW+WMsmF6jE1F+EA14IbVZRX4CbiaSO5HESQkyn+DtfxAcYY1TXnDXa3y
         L0xoXUEVvRAwv4QmP1JweP+0D8VJwUznxwhWGyWIOZuxwKsIs2yP+PPDqRQknJmj0Lnw
         LbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wzkWOoKjInRI+O5FvJvA/t/AUj8a5RTpGl8TvIyMwpk=;
        b=r1jo/itQr2o+dV1Ntme5yKb8Lv7rNHlbeFqzdedxrErKcyEMhCue+0koaWXHA/YNjP
         em11RhuSlQDFhNoDUJt49uotEWoUuLXGl6q4Lw1ABOrTTA/0yOVXdxouvJ3SE1W4Luv5
         gf/dgwom0xu2yTit26JWKclXXamhVRuxrr7aqigj8GaHdNKh952AKGURXDUy+cMOfpc6
         jQ/VzBYpMhA+coGO0N3p9T9UD0uDhZbFljc4qklCQxN0xOisahg062YXYq/KowMpVFhQ
         yyev9w9nrRqNDxK0BHoT3/SeaOuT14LdRAG8kefK7slPaJUCkFxaUs61pVOS4+fRwhsI
         s8UQ==
X-Gm-Message-State: AOAM5331DaXMsFPQ45snPy38K/BXMUxZm/JgTtkBs5PgbMq2nGTPr6w5
        vBaQO8/1rf1pX+GHJFM6GHaRbWL3oTFdbEPG6LW8kQ==
X-Google-Smtp-Source: ABdhPJy+7ndzZeyQ/tSwJHmtK1PTCVWdHHr1LWw9yj8KnDosvV+fAVJTuHJyVyhRpmky/WIBh3xN8Pb/8hbCqMiC0A0=
X-Received: by 2002:a2e:8816:: with SMTP id x22mr2697080ljh.377.1602917761335;
 Fri, 16 Oct 2020 23:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu> <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com> <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu> <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu>
In-Reply-To: <20201017064442.GA14117@1wt.eu>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 17 Oct 2020 08:55:34 +0200
Message-ID: <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
To:     Willy Tarreau <w@1wt.eu>
Cc:     Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jason Donenfeld <Jason@zx2c4.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, oridgar@gmail.com,
        ghammer@redhat.com, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 17, 2020 at 8:44 AM Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Oct 17, 2020 at 07:52:48AM +0200, Jann Horn wrote:
> > On Sat, Oct 17, 2020 at 7:37 AM Willy Tarreau <w@1wt.eu> wrote:
> > > On Sat, Oct 17, 2020 at 07:01:31AM +0200, Jann Horn wrote:
> > > > Microsoft's documentation
> > > > (http://go.microsoft.com/fwlink/?LinkId=260709) says that the VM
> > > > Generation ID that we get after a fork "is a 128-bit,
> > > > cryptographically random integer value". If multiple people use the
> > > > same image, it guarantees that each use of the image gets its own,
> > > > fresh ID:
> > >
> > > No. It cannot be more unique than the source that feeds that cryptographic
> > > transformation. All it guarantees is that the entropy source is protected
> > > from being guessed based on the output. Applying cryptography on a simple
> > > counter provides apparently random numbers that will be unique for a long
> > > period for the same source, but as soon as you duplicate that code between
> > > users and they start from the same counter they'll get the same IDs.
> > >
> > > This is why I think that using a counter is better if you really need something
> > > unique. Randoms only reduce predictability which helps avoiding collisions.
> >
> > Microsoft's spec tells us that they're giving us cryptographically
> > random numbers. Where they're getting those from is not our problem.
> > (And if even the hypervisor is not able to collect enough entropy to
> > securely generate random numbers, worrying about RNG reseeding in the
> > guest would be kinda pointless, we'd be fairly screwed anyway.)
>
> Sorry if I sound annoying, but it's a matter of terminology and needs.
>
> Cryptograhically random means safe for use with cryptography in that it
> is unguessable enough so that you can use it for encryption keys that
> nobody will be able to guess. It in no ways guarantees uniqueness, just
> like you don't really care if the symmetric crypto key of you VPN has
> already been used once somewhere else as long as there's no way to know.
> However with the good enough distribution that a CSPRNG provides,
> collisions within a *same* generator are bound to a very low, predictable
> rate which is by generally considered as acceptable for all use cases.

Yes.

> Something random (cryptographically or not) *cannot* be unique by
> definition, otherwise it's not random anymore, since each draw has an
> influence on the remaining list of possible draws, which is contrary to
> randomness. And conversely something unique cannot be completely random
> because if you know it's unique, you can already rule out all other known
> values from the candidates, thus it's more predictable than random.

Yes.

> With this in mind, picking randoms from a same RNG is often highly
> sufficient to consider they're highly likely unique within a long
> period. But it's not a guarantee. And it's even less one between two
> RNGs (e.g. if uniqueness is required between multiple hypervisors in
> case VMs are migrated or centrally managed, which I don't know).
>
> If what is sought here is a strong guarantee of uniqueness, using a
> counter as you first suggested is better.

My suggestion is to use a counter *in the UAPI*, not in the hypervisor
protocol. (And as long as that counter can only miss increments in a
cryptographically negligible fraction of cases, everything's fine.)

> If what is sought is pure
> randomness (in the sense that it's unpredictable, which I don't think
> is needed here), then randoms are better.

And this is what *the hypervisor protocol* gives us (which could be
very useful for reseeding the kernel RNG).

> If both are required, just
> concatenate a counter and a random. And if you need them to be spatially
> unique, just include a node identifier.
>
> Now the initial needs in the forwarded message are not entirely clear
> to me but I wanted to rule out the apparent mismatch between the expressed
> needs for uniqueness and the proposed solutions solely based on randomness.

Sure, from a theoretical standpoint, it would be a little bit nicer if
the hypervisor protocol included a generation number along with the
128-bit random value. But AFAIU it doesn't, so if we want this to just
work under Microsoft's existing hypervisor, we'll have to make do with
checking whether the random value changed. :P

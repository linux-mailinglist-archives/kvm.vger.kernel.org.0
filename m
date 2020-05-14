Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85D11D3892
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 19:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgENRoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 13:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726037AbgENRoY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 13:44:24 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE4BC061A0C
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 10:44:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id nv1so3551565ejb.0
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 10:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dBNj399I9KBA4WQWKhfnOR9xwS6zN5XEq7yhXlug5ig=;
        b=NWXMu1Dz0IcgSIR0o7dkU8t+f692j04TewEeKSNlmIIzdaX3T3ipuK25pj1H/3k3Ry
         3pF5C82IJeYVbVx8qa7TgslPH1k84cCm84ZK0uc++QwoOHPnGtQjt40je2lVxCBkg5/d
         XyQH7u3Ceu6D2Xa75f0VFgs/1AKCyU7GeOJeY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dBNj399I9KBA4WQWKhfnOR9xwS6zN5XEq7yhXlug5ig=;
        b=LBvKg35jhdSehowfHEEX263H1DiC4+s1yaMLY56x31Mu/EEh24tHgpxSh/G1EP3hpC
         8zuxWzJMxZ3vEp9wJpfDDiRgHAihms3akAJXtAGF/X87gMq0HmJ20fT0Gaz0g+0Z91zX
         SLIkFnbk8a4rjyiC75cCtohmc4Y+3z5jiALemts083oY1K/tSa9oxXyoPJeR1rJ9smLt
         YCRAklfKTsqnzUp0LMQsv71cDhGI2tY0Enw3rNJi+YgHXRYJRLP1+WuuaUqfS3VW0JzP
         vOrSKQfWkQ3Z4Rxnxs4CrYfRzlG23l2x+YoESOeDQvm815JJog0HJ/xe4G417/bEsyna
         5DMA==
X-Gm-Message-State: AOAM531wf3+74MZ/MpQbtstXpjknupf2gmUJD9F/MwKZCTQQJppEOn19
        pAJyYpaeSc+XLKk7Ckp15y6aLke2P6xhgAmN4koOxg==
X-Google-Smtp-Source: ABdhPJxnLKW/hGCva4OlwaSvXXMHPteSUoNrCrzwbh93u10H8Nxz8iSIT2dLVaSMcTSaufzkcc2US+DOJ27HdWfBPD4=
X-Received: by 2002:a17:906:55c4:: with SMTP id z4mr4930727ejp.332.1589478260810;
 Thu, 14 May 2020 10:44:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200511220046.120206-1-mortonm@chromium.org> <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com> <20200513083401.11e761a7@x1.home>
 <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com> <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
 <0fdb5d54-e4d6-8f2f-69fe-1b157999d6cd@redhat.com>
In-Reply-To: <0fdb5d54-e4d6-8f2f-69fe-1b157999d6cd@redhat.com>
From:   Micah Morton <mortonm@chromium.org>
Date:   Thu, 14 May 2020 10:44:08 -0700
Message-ID: <CAJ-EccP6GNmyCGJZFfXUo2_8KEN_sJZ3=88f+3E-8SJ=JT8Pcg@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 3:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/05/20 21:10, Micah Morton wrote:
> > * If we only care about the bus controller existing (in an emulated
> > fashion) enough for the guest to discover the device in question, this
> > could work. I=E2=80=99m concerned that power management could be an iss=
ue here
> > however. For instance, I have a touchscreen device assigned to the
> > guest (irq forwarding done with this module) that in response to the
> > screen being touched prepares the i2c controller for a transaction by
> > calling into the PM system which end up writing to the PCI config
> > space** (here https://elixir.bootlin.com/linux/v5.6.12/source/drivers/i=
2c/busses/i2c-designware-master.c#L435).
> > It seems like this kind of scenario expands the scope of what would
> > need to be supported by the emulated i2c controller, which is less
> > ideal. The way I have it currently working, vfio-pci emulates the PCI
> > config space so the guest can do power management by accessing that
> > space.
>
> This wouldn't be a problem.  When the emulated i2c controller starts a
> transaction on th edevice, it will be performed by the host i2c
> controller and this will lead to the same config space write.

I guess what you're saying is there would be an i2c controller
(emulated PCI device) in the guest and the i2c device driver would
still call i2c_dw_xfer as above and the execution in the guest would
still continue all the way to pci_write_config_word(). Then when the
guest executes the actual config write it would trap to the host,
which would need to have the logic that the guest is trying to do
runtime PM commands on an emulated PCI device so we need to step in
and reset the actual PCI device on the host that backs that emulated
device. Is this right?

Again, this is assuming we have the infrastructure to pass platform
devices on x86 to the guest with vfio-platform, which I don't think is
the case. +Auger Eric (not sure why gmail puts your name backwards)
would you be able to comment on this based on my previous message?

>
> I have another question: would it be possible to expose this IRQ through
> /dev/i2c-* instead of messing with VFIO?
>
> In fact, adding support for /dev/i2c passthrough to QEMU has long been a
> pet idea of mine (my usecase was different though: the idea was to write
> programs for a microcontroller on an ARM single board computer and run
> them under QEMU in emulation mode).  It's not trivial, because there
> could be some impedence mismatch between the guest (which might be
> programmed against a low-level controller or might even do bit banging)
> and the i2c-dev interface which is more high level.  Also QEMU cannot do
> clock stretching right now.  However, it's certainly doable.

I agree that would be a cool thing to have in QEMU. Unfortunately I am
interested in assigning other PCI bus controllers to a guest VM and
(similar to the i2c example above) in some cases these busses (e.g.
LPC, SPI) have devices with arbitrary interrupts that need to be
forwarded into the guest for things to work.

I realize this may seem like an over-use of VFIO, but I'm actually
coming from the angle of wanting to assign _most_ of the important
hardware on my device to a VM guest, and I'm looking to avoid
emulation wherever possible. Of course there will be devices like the
IOAPIC for which emulation is unavoidable, but I think emulation is
avoidable here for the busses we've mentioned if there is a way to
forward arbitrary interrupts into the guest.

Since all these use cases are so close to working with vfio-pci right
out of the box, I was really hoping to come up with a simple and
generic solution to the arbitrary interrupt problem that can be used
for multiple bus types.

>
> >> (Finally, in the past we were doing device assignment tasks within KVM
> >> and it was a bad idea.  Anything you want to do within KVM with respec=
t
> >> to device assignment, someone else will want to do it from bare metal.
> >
> > Are you saying people would want to use this in non-virtualized
> > scenarios like running drivers in userspace without any VMM/guest? And
> > they could do that if this was part of VFIO and not part of KVM?
>
> Yes, see above for an example.
>
> Paolo
>

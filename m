Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBACE1D1E9B
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 21:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390356AbgEMTKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 15:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTKU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 15:10:20 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E42C061A0C
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 12:10:20 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id s9so510753eju.1
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 12:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lPjwX9hzEVA63xk4MIy5QujHyjNVVXE11UNbojwYjz0=;
        b=mjUVtYBqm5B6CRRXpDFGfGLMqoD2SBWDy4RKrUzpilcLwJcRvq6vbJeLU4DqQIpnuK
         QTLo5swEui5uHKHZV3qK48WtsUWoFzXsDEnz1/5x57VdvuUjxprGpwUia7wYKS4m2Tyn
         zdaTGfj6M6ysh6rY5QJHLC0MtZYCL5CVE5dSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lPjwX9hzEVA63xk4MIy5QujHyjNVVXE11UNbojwYjz0=;
        b=NoVwKy/Pez2uwD0wekkAuDSi3Sh//a4b39WyD/QXBpvIU8gN2Vx1RV5L+QoMWcdZzO
         Y7B7oQPhlpluK/VicDh8gjiAwqElKnjwoQdveLa/4q3w2TDKrx0oSN9xDax0mKd0pZMV
         SQa+VXLy+dOiqOacATEPyzCdvYO6OtcD7uud2zF13eEqeFhMdJt258ObX1oUW0dfpT7g
         iFAIWyRTrs/j06Frt4/huV8hRlTay0b6c2BmOy9OH+sFpuQF1vwSOLR9AojzdCHdb36s
         T2tcethqa8zSAkWCdmn7wJ562AxiMWM66sCvaJLv1J//eIDEgKb0YnFV5khkqT/VZlmh
         sZOg==
X-Gm-Message-State: AOAM530cg8121eXDR8JZ3U7A0si6oTssTnWjqzFsn18O+qetpNwMIuuO
        z8johY6zVmofyLR30CCxjuw18B7UOlEboIWkHjS+HZFQNrQ=
X-Google-Smtp-Source: ABdhPJx6nNYcD37ivtmkXrRGdMjyff1ToAcl2Tc+JpDb+EKOJGiK6XtwEg/zdjMRicslQZ/WyAJ2/btR4Vg7XEF7OHA=
X-Received: by 2002:a17:906:55c4:: with SMTP id z4mr478291ejp.332.1589397018636;
 Wed, 13 May 2020 12:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200511220046.120206-1-mortonm@chromium.org> <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com> <20200513083401.11e761a7@x1.home>
 <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com>
In-Reply-To: <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com>
From:   Micah Morton <mortonm@chromium.org>
Date:   Wed, 13 May 2020 12:10:06 -0700
Message-ID: <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 8:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/05/20 16:34, Alex Williamson wrote:
> >> Alternatively, if you assign the i2c controller, I don't understand wh=
y
> >> the guest doesn't discover interrupts on its own.  Of course you need =
to
> >> tell the guest about the devices in the ACPI tables, but why is this n=
ew
> >> concept necessary?
> >
> > the interrupt for this sub-device is unrelated to the PCI
> > controller device, it's an entirely arbitrary (from our perspective)
> > relationship described via ACPI.
>
> Ok, that's what I was missing.
>
> > We could potentially use device specific interrupts to expose this via
> > the controller device, but then vfio-pci needs to learn how to
> > essentially become an i2c controller to enumerate the sub-devices and
> > collect external dependencies.  This is not an approach I've embraced
> > versus the alternative of the host i2c driver claiming the PCI
> > controller, enumerating the sub-devices, and binding the resulting
> > device, complete with built-in interrupt support via vfio-platform.
>
> I agree that's the way to go.

I think vfio-platform only builds for ARM at the moment
(https://elixir.bootlin.com/linux/v5.7-rc5/source/drivers/vfio/platform/Kco=
nfig#L4),
and AFAICT vfio-platform is only for assigning DMA-capable devices on
ARM that are behind an IOMMU and listed in /sys/kernel/iommu_groups.
I=E2=80=99m not sure how much work it would take to get vfio-platform to
attach to platform devices on x86 and assign them to a guest, even
assuming we had the i2c controller emulation code* (part of the draw
for vfio-pci is to avoid emulating things in the host, so having to
emulate the i2c controller takes away from this advantage of vfio-pci
a bit). This might be a good approach for assigning platform devices
on x86 which are non-DMA-capable in the case you _don=E2=80=99t_ want to
assign all the platform devices on the bus together to the guest. I=E2=80=
=99m
not particularly interested in that scenario however, I=E2=80=99d rather ju=
st
give the whole bus to the guest, which makes vfio-pci very convenient.

* If we only care about the bus controller existing (in an emulated
fashion) enough for the guest to discover the device in question, this
could work. I=E2=80=99m concerned that power management could be an issue h=
ere
however. For instance, I have a touchscreen device assigned to the
guest (irq forwarding done with this module) that in response to the
screen being touched prepares the i2c controller for a transaction by
calling into the PM system which end up writing to the PCI config
space** (here https://elixir.bootlin.com/linux/v5.6.12/source/drivers/i2c/b=
usses/i2c-designware-master.c#L435).
It seems like this kind of scenario expands the scope of what would
need to be supported by the emulated i2c controller, which is less
ideal. The way I have it currently working, vfio-pci emulates the PCI
config space so the guest can do power management by accessing that
space.

** Call stack looks like this:

[  +0.000023]  [<ffffffffb53a029f>] dump_stack+0x97/0xdb
[  +0.000012]  [<ffffffffb53e3c0c>] pci_write_config_word+0x3c/0x56
[  +0.000015]  [<ffffffffb53e2cc6>] pci_raw_set_power_state+0x106/0x220
[  +0.000014]  [<ffffffffb53e2b0b>] pci_set_power_state+0x50/0xbd
[  +0.000013]  [<ffffffffb53e8ea7>] pci_restore_standard_config+0x27/0x36
[  +0.000012]  [<ffffffffb53e8d56>] pci_pm_runtime_resume+0x3a/0xa6
[  +0.000013]  [<ffffffffb53e8d1c>] ? pci_pm_runtime_suspend+0x139/0x139
[  +0.000015]  [<ffffffffb557011e>] __rpm_callback+0x7a/0xf4
[  +0.000012]  [<ffffffffb53e8d1c>] ? pci_pm_runtime_suspend+0x139/0x139
[  +0.000013]  [<ffffffffb557004b>] rpm_callback+0x27/0x80
[  +0.000012]  [<ffffffffb57419dd>] rpm_resume+0x53a/0x608
[  +0.000014]  [<ffffffffb51a4b4c>] ? update_process_times+0x5c/0x5c
[  +0.000010]  [<ffffffffb574193a>] rpm_resume+0x497/0x608
[  +0.000016]  [<ffffffffb58dfdb0>] ? __switch_to_asm+0x40/0x70
[  +0.000011]  [<ffffffffb574148b>] __pm_runtime_resume+0x6b/0x83
[  +0.000011]  [<ffffffffb574ac0d>] i2c_dw_xfer+0x30/0x3c1
[  +0.000012]  [<ffffffffb574a13f>] __i2c_transfer+0xa2/0x290
[  +0.000011]  [<ffffffffb565d12a>] i2c_master_recv+0xc3/0x10c
[  +0.000014]  [<ffffffffb56f79e1>] i2c_hid_get_input+0x2f/0x119
[  +0.000012]  [<ffffffffb56f79ab>] i2c_hid_irq+0x1b/0x22


Most important point: Am I missing something about vfio-platform working on=
 x86?

>
> Perhaps adding arbitrary non-PCI interrupts, i.e. neither INTX nor
> MSI(-X), to vfio-pci could be acceptable.  However, the device claim
> must claim them, and that seems hard to do when you rebind the PCI
> device to pci-stub.
>
> Paolo
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6651B1EDF
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 08:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgDUGfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 02:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbgDUGfR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 02:35:17 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0F0C061A0F;
        Mon, 20 Apr 2020 23:35:16 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e8so5241551ilm.7;
        Mon, 20 Apr 2020 23:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2GZ3FEJ4iPZ3+IRnrKx7fOdw1woztaKLuV+cLqPMCgY=;
        b=QxMVyfDLq1hToJoggNoJE9N+v6mbWwed+u3yYFj/4mgX0rFsfe4Ip4Py9Dz0VTHclg
         bqM/hQ5rFYOQQekWe+gAP6NTB3csVRytsir+sHfBjfeeIgCg30JjYsMcXuYLqshCa3bA
         cK3NiW8ghX5rClE2iWcsA+vlfYQU7p2psMRScc7MHcYGKJbcth9mWYCKKxiXs6UOrlcK
         QBSQxCd7tn5iQznHZnO+7lrzI30HYGB3FHg9wPyrH+kfLX/SdMCVQg5kgdz3cyHMUbQ8
         6C49cuZzT3+hV2xB9xHikkzaG9j40Yi3bZX8/pJMpQeWAgtLQ/jSo7XctVH0Uxd/PA4F
         FOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2GZ3FEJ4iPZ3+IRnrKx7fOdw1woztaKLuV+cLqPMCgY=;
        b=b4gfvENeSg3Sz8UmXhS2+z5DJOaBw9rfjb4YFbWsDRmLY8E6LLar/TNH5FdxHKdG4p
         XMoQRCs39HBZv7gDcoIUv8EXqJ2vYYDpdTDJlwou28M9q0j26Xb/pKHQO1F2yP142LFN
         ka37l2u64MVby4GCT7gKRpjiXCEcnVyvmacFuypfCCpx1Xmtizpo4daqu77/k34/+Z3D
         4/o/B5d93KQpQkbkpUn3cXs/epbkXjMRL3MX6PQ5X/wKfG+LOna9p7ztQxyhfWQNv50j
         1mzjAb0KMbG3ZXBiKyWh8xrKp6lt/1RBSMABFuxB0GEqTQW8xxOsVjvfdRff+DqTozW6
         Fytg==
X-Gm-Message-State: AGi0PuaJr/nKcZovVZkgLI9UHasgGnW2ehMx0rkyjpclWEswHOfjTw4X
        AR0/l4ydYX2G/xE7iaALaZFbJqdtk7nHa2qdV8Q=
X-Google-Smtp-Source: APiQypI0UjZj3RJkKhckLd67LZ5JWoeLzx1wDwHDSxBunlAoQ/EBiYhIkcP39F0zeF4gS3v76sDGDLlnUaj8mi5mmac=
X-Received: by 2002:a92:7c01:: with SMTP id x1mr12131737ilc.122.1587450916283;
 Mon, 20 Apr 2020 23:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200323075354.93825-1-aik@ozlabs.ru> <b512ac5e-dca5-4c08-8ea1-a636b887c0d0@ozlabs.ru>
 <d5cac37a-8b32-cabf-e247-10e64f0110ab@ozlabs.ru> <CAOSf1CGfjX9LGQ1GDSmxrzjnaWOM3mUvBu9_xe-L2umin9n66w@mail.gmail.com>
 <CAOSf1CHgUsJ7jGokg6QD6cEDr4-o5hnyyyjRZ=YijsRY3T1sYA@mail.gmail.com>
 <b0b361092d2d7e38f753edee6dcd9222b4e388ce.camel@russell.cc>
 <9893c4db-057d-8e42-52fe-8241d6d90b5f@ozlabs.ru> <76718d0c46f4638a57fd2deeeed031143599d12d.camel@gmail.com>
 <8f317916-06be-ed25-4d9b-a8e2e993b112@ozlabs.ru>
In-Reply-To: <8f317916-06be-ed25-4d9b-a8e2e993b112@ozlabs.ru>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Tue, 21 Apr 2020 16:35:05 +1000
Message-ID: <CAOSf1CG_qiR2HvSFVTbgTyqVmDt4+Oy60PNWY23K2ihHib1K7Q@mail.gmail.com>
Subject: Re: [PATCH kernel v2 0/7] powerpc/powenv/ioda: Allow huge DMA window
 at 4GB
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Russell Currey <ruscur@russell.cc>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 3:11 PM Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>
> One example of a problem device is AMD GPU with 64bit video PCI function
> and 32bit audio, no?
>
> What PEs will they get assigned to now? Where will audio's MMIO go? It
> cannot be the same 64bit MMIO segment, right? If so, it is a separate PE
> already. If not, then I do not understand "we're free to assign whatever
> PE number we want.

The BARs stay in the same place and as far as MMIO is concerned
nothing has changed. For MMIO the PHB uses the MMIO address to find a
PE via the M64 BAR table, but for DMA it uses a *completely* different
mechanism. Instead it takes the BDFN (included in the DMA packet
header) and the Requester Translation Table (RTT) to map the BDFN to a
PE. Normally you would configure the PHB so the same PE used for MMIO
and DMA, but you don't have to.

> > I think the key thing to realise is that we'd only be using the DMA-PE
> > when a crippled DMA mask is set by the driver. In all other cases we
> > can just use the "native PE" and when the driver unbinds we can de-
> > allocate our DMA-PE and return the device to the PE containing it's
> > MMIO BARs. I think we can keep things relatively sane that way and the
> > real issue is detecting EEH events on the DMA-PE.
>
>
> Oooor we could just have 1 DMA window (or, more precisely, a single
> "TVE" as it is either window or bypass) per a PE and give every function
> its own PE and create a window or a table when a device sets a DMA mask.
> I feel I am missing something here though.

Yes, we could do that, but do we want to?

I was thinking we should try minimise the number of DMA-only PEs since
it complicates the EEH freeze handling. When MMIO and DMA are mapped
to the same PE an error on either will cause the hardware to stop
both. When seperate PEs are used for DMA and MMIO you lose that
atomicity. It's not a big deal if DMA is stopped and MMIO allowed
since PAPR (sort-of) allows that, but having MMIO frozen with DMA
unfrozen is a bit sketch.

> >> For the time being, this patchset is good for:
> >> 1. weird hardware which has limited DMA mask (this is why the patchset
> >> was written in the first place)
> >> 2. debug DMA by routing it via IOMMU (even when 4GB hack is not enabled).
> >
> > Sure, but it's still dependent on having firmware which supports the
> > 4GB hack and I don't think that's in any offical firmware releases yet.
>
> It's been a while :-/

There's been no official FW releases with a skiboot that supports the
phb get/set option opal calls so the only systems that can actually
take advantage of it are our lab systems. It might still be useful for
future systems, but I'd rather something that doesn't depend on FW
support.


Oliver

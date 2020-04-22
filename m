Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C1D1B3AE1
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 11:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgDVJL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 05:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726077AbgDVJL6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 05:11:58 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A7DC03C1A6;
        Wed, 22 Apr 2020 02:11:58 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r2so1146238ilo.6;
        Wed, 22 Apr 2020 02:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HLA2X61U+G6ZU9bEd0gaBeZeOPn3A93++NR5CH7fB64=;
        b=J4giD/YBDck/mUz0NwFQmVGxTe9zC58MQlFLAUBAI8G5MB5vM1Rp3aJ6rpAtVprNOk
         fjK4+71GRvF2HV3KluQ3oGmf/X5xqtLOJdDGZs7SFWjzhOCE/UJxAO45q73x3htA1uff
         QFGDAoOK5RvuBFRKG19vPMWNefS/BkV8oQkA0du0Q/k4lgU3RXC68RSoydztfd87xOFw
         Oft5gwdc7SNDcoOKq4kdGGAvk2trvqzmbU46Xox7RnM/aSe0xUHsbJPR4EePZrbWO8DU
         HagahOT5NBK4iLVTpgdtYC0jPvdIhqXYRZLvtcSinDR5InMHTuOXWLl+btWsaHjppnji
         A55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HLA2X61U+G6ZU9bEd0gaBeZeOPn3A93++NR5CH7fB64=;
        b=D+I3xR2vtXgCGWECGmGxto17sH8fxMpnfjApXgFqYbXv8v599EA4az7jS8q8dun5r4
         Z9XVP/UX9M1i/ZtJ4C3lmuyV/WWfB/L66IxjqagyfurgnDyF0Az1dm8m5BvwqoJzGWni
         kQKWeVaUyCyuHbD4zsQrajNRYLt7zxpFBscq3liQ2clCMHeYD83pepDDUh9iotSlIgGL
         xJdDE3Cm6mrTXDNPX12Y6qAEHTLpDUFPOIZV5qpE4JpAaD05n86QNWt9V8sHAD1QPw+k
         TD/mV7/hFP29Z7AQ7+fqSJWjRMlO2CL7EzgierXCMJZSs/J8NiOObQuzykQuIfZNxepC
         zTJg==
X-Gm-Message-State: AGi0PuYB96lqu6KCEHsqDzGnGeSRkjZx59AbdqZ3fhKviiwKPXTrZiwr
        yfNys+LqvEvnKP9qjK71CDwc2/xJ3YokvukY1BoPCZ1Y
X-Google-Smtp-Source: APiQypLL1gvBGc4Ay2OA6p4ztYkG00xYbbpahoQ5ydSVzKBkM11/r29cjbEPIXT9B2oV7tkziJyE0MoGrx9YPZIi6TQ=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr24249236ilj.149.1587546717465;
 Wed, 22 Apr 2020 02:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200323075354.93825-1-aik@ozlabs.ru> <b512ac5e-dca5-4c08-8ea1-a636b887c0d0@ozlabs.ru>
 <d5cac37a-8b32-cabf-e247-10e64f0110ab@ozlabs.ru> <CAOSf1CGfjX9LGQ1GDSmxrzjnaWOM3mUvBu9_xe-L2umin9n66w@mail.gmail.com>
 <CAOSf1CHgUsJ7jGokg6QD6cEDr4-o5hnyyyjRZ=YijsRY3T1sYA@mail.gmail.com>
 <b0b361092d2d7e38f753edee6dcd9222b4e388ce.camel@russell.cc>
 <9893c4db-057d-8e42-52fe-8241d6d90b5f@ozlabs.ru> <76718d0c46f4638a57fd2deeeed031143599d12d.camel@gmail.com>
 <8f317916-06be-ed25-4d9b-a8e2e993b112@ozlabs.ru> <CAOSf1CG_qiR2HvSFVTbgTyqVmDt4+Oy60PNWY23K2ihHib1K7Q@mail.gmail.com>
 <ee3fd87f-f2b6-1439-a310-fedc614e6155@ozlabs.ru>
In-Reply-To: <ee3fd87f-f2b6-1439-a310-fedc614e6155@ozlabs.ru>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Wed, 22 Apr 2020 19:11:46 +1000
Message-ID: <CAOSf1CGeDCh-5TQ0mka0GG_gNeTY3EVtYkPvu=0ckrGe1VAqcw@mail.gmail.com>
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

On Wed, Apr 22, 2020 at 4:49 PM Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>
> 32bit MMIO is what puzzles me in this picture, how does it work?

For devices with no m64 we allocate a PE number as described above. In
the 32bit MMIO window we have a segment-to-PE remapping table so any
m32 segment can be assigned to any PE. As a result slave PE concept
isn't really needed. If the BARs of a device span multiple m32
segments then we can setup the remapping table so that all the
segments point to the same PE.

> > I was thinking we should try minimise the number of DMA-only PEs since
> > it complicates the EEH freeze handling. When MMIO and DMA are mapped
> > to the same PE an error on either will cause the hardware to stop
> > both. When seperate PEs are used for DMA and MMIO you lose that
> > atomicity. It's not a big deal if DMA is stopped and MMIO allowed
> > since PAPR (sort-of) allows that, but having MMIO frozen with DMA
> > unfrozen is a bit sketch.
>
> You suggested using slave PEs for crippled functions - won't we have the
> same problem then?

Yes, but I think it's probably worth doing in that case. You get
slightly janky EEH in exchange for better DMA performance.

> And is this "slave PE" something the hardware supports or it is a
> software concept?

It's all in software. The hardware does have the PELT-V which allows
you to specify a group of PEs to additionally freeze when a PE is
frozen, but the PELT-V is only used when handling AER messages.  All
other error sources (DMAs, MMIOs, etc) will only freeze one PE (or all
of them in very rare cases).

> > There's been no official FW releases with a skiboot that supports the
> > phb get/set option opal calls so the only systems that can actually
> > take advantage of it are our lab systems. It might still be useful for
> > future systems, but I'd rather something that doesn't depend on FW
> > support.
>
> Pensando folks use it ;)

the what folks

Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9561D1B744D
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 14:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgDXMZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 08:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgDXMZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 08:25:27 -0400
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708BB21582
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731126;
        bh=At8xmfKBJxQ9CafuQrxhSF7RQSm74iu7lK9/pffz/Kk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hSuoz731MrEwMi2PEd3c9/Zupwr84KMTfGVXuHRXhm9aYcqRY78XoDs+Mpcsx3yqj
         FY7Q37+129/tYtL2RZlzP0k3Pks6aQ6AAO2WWK9PoTkIpeGmMvZcI65R2iR/2l0ieX
         c0Bqu6hvqyghzrOyJIAUYtUacnE0LgptmtjJcXQg=
Received: by mail-io1-f53.google.com with SMTP id p10so10113729ioh.7
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 05:25:26 -0700 (PDT)
X-Gm-Message-State: AGi0PuZHEM6qOFtXjYdGg01KqBLiF5P76qXtPsbazP1amO/canTgH038
        aiAdRXtJ+u/OWOPeBQITRN3dNjQvMmKnp0l8Weg=
X-Google-Smtp-Source: APiQypJc/nkscRMyfcPd01oltQYjyEJquNAjGFcmgHSSoISonFfv+XMnS8tZSLIDvipgwz2NbSPAKVS/Gu9zhzUEeD4=
X-Received: by 2002:a6b:ef03:: with SMTP id k3mr8349793ioh.203.1587731125790;
 Fri, 24 Apr 2020 05:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
 <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
 <9e742184-86c1-a4be-c2cb-fe96979e0f1f@arm.com> <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
 <df9a0aeb-39ed-f9bc-c506-71d2f134bc62@arm.com>
In-Reply-To: <df9a0aeb-39ed-f9bc-c506-71d2f134bc62@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 24 Apr 2020 14:25:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEr0fVVG1xCxEJtcrrKe3_OYbOmAmbYy0TceSeX+3gfww@mail.gmail.com>
Message-ID: <CAMj1kXEr0fVVG1xCxEJtcrrKe3_OYbOmAmbYy0TceSeX+3gfww@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To:     =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Leif Lindholm <leif@nuviainc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 at 14:08, Andr=C3=A9 Przywara <andre.przywara@arm.com> =
wrote:
>
> On 24/04/2020 07:45, Ard Biesheuvel wrote:
>
> Hi,
>
> (adding Leif for EDK-2 discussion)
>
> > On Thu, 23 Apr 2020 at 23:32, Andr=C3=A9 Przywara <andre.przywara@arm.c=
om> wrote:
> >>
> >> On 23/04/2020 21:43, Ard Biesheuvel wrote:
>
> [ ... kvmtool series to add CFI flash emulation allowing EDK-2 to store
> variables. Starting with this version (v4) the flash memory region is
> presented as a read-only memslot to KVM, to allow direct guest accesses
> as opposed to trap-and-emulate even read accesses to the array.]
>
> >>
> >>
> >> Just curious: the images Sami gave me this morning did not show any
> >> issues anymore (no no-syndrome fault, no alignment issues), even witho=
ut
> >> the mapping [1]. And even though I saw the 800k read traps, I didn't
> >> notice any real performance difference (on a Juno). The PXE timeout wa=
s
> >> definitely much more noticeable.
> >>
> >> So did you see any performance impact with this series?
> >>
> >
> > You normally don't PXE boot. There is an issue with the iSCSI driver
> > as well, which causes a boot delay for some reason, so I disabled that
> > in my build.
> >
> > I definitely *feels* faster :-) But in any case, exposing the array
> > mode as a r/o memslot is definitely the right way to deal with this.
> > Even if Sami did find a workaround that masks the error, it is no
> > guarantee that all accesses go through that library.
>
> So I was wondering about this, maybe you can confirm or debunk this:
> - Any memory given to the compiler (through a pointer) is assumed to be
> "normal" memory: the compiler can re-arrange accesses, split them up or
> collate them. Also unaligned accesses should be allowed - although I
> guess most compilers would avoid them.
> - This normally forbids to give a pointer to memory mapped as "device
> memory" to the compiler, since this would violate all of the assumptions
> above.
> - If the device mapped as "device memory" is actually memory (SRAM,
> ROM/flash, framebuffer), then most of the assumptions are met, except
> the alignment requirement, which is bound to the mapping type, not the
> actual device (ARMv8 ARM: Unaligned accesses to device memory always
> trap, regardless of SCTLR.A)
> - To accommodate the latter, GCC knows the option -malign-strict, to
> avoid unaligned accesses. TF-A and U-Boot use this option, to run
> without the MMU enabled.
>
> Now if EDK-2 lets the compiler deal with the flash memory region
> directly, I think this would still be prone to alignment faults. In fact
> an earlier build I got from Sami faulted on exactly that, when I ran it,
> even with the r/o memslot mapping in place.
>
> So should EDK-2 add -malign-strict to be safe?

It already uses this in various places where it matters.

>         or
> Should EDK-2 add an additional or alternate mapping using a non-device
> memory type (with all the mismatched attributes consequences)?

The memory mapped NOR flash in UEFI is really a special case, since we
need the OS to map it for us at runtime, and we cannot tell it to
switch between normal-NC and device attributes depending on which mode
the firmware is using it in.

Note that this is not any different on bare metal.

>         or
> Should EDK-2 only touch the flash region using MMIO accessors, and
> forbid the compiler direct access to that region?
>

It should only touch those regions using abstractions it defines
itself, and which can be backed in different ways. This is already the
case in EDK2: it has its own CopyMem, ZeroMem, etc string library, and
bans the use the standard C ones. On top of that, it bans struct
assignment, initializers for automatic variables and are things that
result in such calls to be emitted implicitly.

So in practice, this issue is under control, unless you use a version
of those abstractions that willingly uses unaligned accesses (we have
optimized versions based on the cortex-strings library). So my
suspicion is that this may have caused the crash: on bare metal, we
have to switch to the non-optimized string library for the variable
driver for this reason.

The real solution is to fix EDK2, and make the variable stack work
with NOR flash that is non-memory mapped. This is something that has
come up before, and the other day, Sami and I were just discussing
logging this as a wishlist item for the firmware team.


> So does EDK-2 get away with this because the compiler typically avoids
> unaligned accesses?
>

There are certainly some places in the current code base where it is
the compiler that is emitting reads from the NOR flash region, but
there aren't that many. Moving the variable data itself in and out
will typically use the abstractions, since it is moving anonymous
chunks of data. However, there are places where, e.g., fields in the
FS metadata are being read by the code, and there it just casts an
address pointing into the NOR flash region to the appropriate struct
type, and dereferences the fields.

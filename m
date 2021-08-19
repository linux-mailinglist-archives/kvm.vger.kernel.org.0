Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2503F1000
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 03:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhHSBdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 21:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbhHSBdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 21:33:20 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C381C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 18:32:45 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id 14so5419133qkc.4
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 18:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qo2MsIXPqPv5VvJq6LQyvJSKStE9z/C19qzo0B1ToA0=;
        b=nA7kV1d7NodeTusNFegecqOiXfHClfnQn45FglU69HSjh0lRxz2u4T/wNQ2np21tIB
         +UIDAWvwiWn0wvGXYFOg4Gm+tZZbJdR87huD2QyjG5fVP26sWq8WWer2rVGw3H/G+Fcx
         pqtaMIT4shAtStAHttnbpN3RQJ+CCSXV8m/B4OPA5jErWXvFgNlCcAZ87YVEVPrKj/v4
         sDWArk+Lk0tOrPDy6VuFdjplCLKNpMtbpfA0SsUs717R2CsbGl9T1/mLYXtzE/GX1ASi
         tK2RqqLwxkJKkPX5FsUxJ61InSeote6q+YTsmg2lXdrUpz7dO26zeGe+11ZRqQMDka8N
         nw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qo2MsIXPqPv5VvJq6LQyvJSKStE9z/C19qzo0B1ToA0=;
        b=VEvWWzn0r2/q54+Cn5RSnV+gW84OS/D365ls7JhH3bx1THdMc55auPzdB6K1PxWh9b
         IWUqThVGr13ePUejK+8KwJqrg9GlBEUt4FNxNTSJdAkkoue4xeI6mGGJVyIxKmD87TNx
         N7MP9JMZkECIjj8pm1XpKfR8wlj17Apx3bmV3mK1U7aL/fFW7BvAyCn8FdcPqYceqluV
         bs7F32VGlC06SVEOwKJ4b4PjtsiWLqJa0wtlhMfjOfRlExyx/VmfSWepBUp+/OCOLWKO
         UM/ukHtZZiNimmTrKdbV9mieIvtoqb2Fd4r16sLwRfAsK9cuEA8z//0oc4fIS/HDtmEX
         467A==
X-Gm-Message-State: AOAM531flLweDIXNKa1L+tZGk4LWdUvwhugATwbq1UUmSUHIVm9IlKRK
        5Y031zv+afOh09OtKKQt1ig/qqfR48ivPW/NAf1FDw==
X-Google-Smtp-Source: ABdhPJwd/s3LzsFEtLYDThddFTqD76bXBEESWPiOVS4UaWZg2qyn44pIa0SCEEmucFFXWoK1+BrmXqIS0N+ui8Qo5Ns=
X-Received: by 2002:a37:66d1:: with SMTP id a200mr1217378qkc.440.1629336763931;
 Wed, 18 Aug 2021 18:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210702114820.16712-1-varad.gautam@suse.com> <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
 <YRuURERGp8CQ1jAX@suse.de> <CAA03e5FTrkLpZ3yr3nBphOW3D+8HF-Wmo4um4MTXum3BR6BMQw@mail.gmail.com>
 <71db10eb-997f-aac1-5d41-3bcbc34c114d@suse.com>
In-Reply-To: <71db10eb-997f-aac1-5d41-3bcbc34c114d@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 18 Aug 2021 18:32:32 -0700
Message-ID: <CAA03e5H6mM0z5r4knbjHDLS4svLP6WQuhC_5BnSgCyXpRZgqAQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     Joerg Roedel <jroedel@suse.de>, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Zixuan Wang <zixuanwang@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 1:38 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> Hi Marc, Zixuan,
>
> On 8/18/21 3:52 AM, Marc Orr wrote:
> > On Tue, Aug 17, 2021 at 3:49 AM Joerg Roedel <jroedel@suse.de> wrote:
> >>
> >> Hi Marc,
> >>
> >> On Fri, Aug 13, 2021 at 11:44:39AM -0700, Marc Orr wrote:
> >>> To date, we have _most_ x86 test cases (39/44) working under UEFI and
> >>> we've also got some of the test cases to boot under SEV-ES, using the
> >>> UEFI #VC handler.
> >>
> >> While the EFI APP approach simplifies the implementation a lot, I don'=
t
> >> think it is the best path to SEV and TDX testing for a couple of
> >> reasons:
> >>
> >>         1) It leaves the details of #VC/#VE handling and the SEV-ES
> >>            specific communication channels (GHCB) under control of the
> >>            firmware. So we can't reliably test those interfaces from a=
n
> >>            EFI APP.
> >>
> >>         2) Same for the memory validation/acceptance interface needed
> >>            for SEV-SNP and TDX. Using an EFI APP leaves those under
> >>            firmware control and we are not able to reliably test them.
> >>
> >>         3) The IDT also stays under control of the firmware in an EFI
> >>            APP, otherwise the firmware couldn't provide a #VC handler.
> >>            This makes it unreliable to test anything IDT or IRQ relate=
d.
> >>
> >>         4) Relying on the firmware #VC hanlder limits the tests to its
> >>            abilities. Implementing a separate #VC handler routine for
> >>            kvm-unit-tests is more work, but it makes test development
> >>            much more flexible.
> >>
> >> So it comes down to the fact that and EFI APP leaves control over
> >> SEV/TDX specific hypervisor interfaces in the firmware, making it hard
> >> and unreliable to test these interfaces from kvm-unit-tests. The stub
> >> approach on the other side gives the tests full control over the VM,
> >> allowing to test all aspects of the guest-host interface.
> >
> > I think we might be using terminology differently. (Maybe I mis-used
> > the term =E2=80=9CEFI app=E2=80=9D?) With our approach, it is true that=
 all
> > pre-existing x86_64 test cases work out of the box with the UEFI #VC
> > handler. However, because kvm-unit-tests calls `ExitBootServices` to
> > take full control of the system it executes as a =E2=80=9CUEFI-stubbed
> > kernel=E2=80=9D. Thus, it should be trivial for test cases to update th=
e IDT
> > to set up a custom #VC handler for the duration of a test. (Some of
> > the x86_64 test cases already do something similar where they install
> > a temporary exception handler and then restore the =E2=80=9Cdefault=E2=
=80=9D
> > kvm-unit-tests exception handler.)
> >
> > In general, our approach is to set up the test cases to run with the
> > kvm-unit-tests configuration (e.g., IDT, GDT). The one exception is
> > the #VC handler. However, all of this state can be overridden within a
> > test as needed.
> >
> > Zixuan just posted the patches. So hopefully they make things more clea=
r.
> >
>
> Nomenclature aside, I believe Zixuan's patchset [1] takes the same approa=
ch
> as I posted here. In the end, we need to:
> - build the testcases as ELF shared objs and link them to look like a PE
> - switch away from UEFI GDT/IDT/pagetable states on early boot to what
>   kvm-unit-tests needs
> - modify the testcases that contain non-PIC asm stubs to allow building
>   them as shared objs
>
> I went with avoiding to bring in gnu-efi objects into kvm-unit-tests
> for EFI helpers, and disabling the non-PIC testcases for the RFC's sake.
>
> I'll try out "x86 UEFI: Convert x86 test cases to PIC" [2] from Zixuan's
> patchset with my series and see what breaks. I think we can combine
> the two patchsets.
>
> [1] https://lore.kernel.org/r/20210818000905.1111226-1-zixuanwang@google.=
com/
> [2] https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@google=
.com/

This sounds great to us. We will also experiment with combining the
two patchsets and report back when we have some experience with this.
Though, please do also report back if you have an update on this
before we do.

Thanks,
Marc

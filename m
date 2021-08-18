Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1001E3EF7B5
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 03:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbhHRBww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 21:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbhHRBwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 21:52:51 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A09C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 18:52:17 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id y144so1245083qkb.6
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 18:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K9cGV/bQnvIU70B+bzceYi+yYSYuqAcHwpt18Lo9Rtw=;
        b=WOrM92z5TG0QGj0Sd66P3624D9HNAokSuQcMCcm/5oro26ZL/Kx9PRqeURusV6vmdo
         D11Hp2ZjGal5RNDgQquGF6tYaXKw1o/7iig25JGgg756+RIIsdh2eO4qiQ0KIklm9cSo
         7GVNj/HVLu/HmP2Os3IFoNfiJ5uNxoNlJjD8giNED1k4Xz/a0cMgP4ag45hNdaGydTUq
         QTjsNcTyOIGf56uu/H/GNRSEtWlvnBloOXwfPbF/tTkj04P5uFATJSuxXBmARjF1DXOk
         RehKBwblxGFnQPff1oEc0Yz3ZZ8N/SaVTdl98FbNiK3S87YqN1OQOLTs7TaZkhJV2DuX
         IlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K9cGV/bQnvIU70B+bzceYi+yYSYuqAcHwpt18Lo9Rtw=;
        b=Deq87NTNYdIJpYgOLXRhxosvxE9nQWi+4tYLhwahjRzbGenKEvVZsTqtOjK47EcRV/
         fBd5XsVdI3T0zOk1eiG1RXnjAkVFOfHs9mA7/R/iEFogXoffCoI2xek3+iqTh060PuRE
         0gfcK+L8MZ4cYbo8hbJdYUiYnP9qS4+jZd5su/zZDK65fjBTVFYNMWOkZp82Faj8bL7+
         PM1QkjfY0VZXSNHv7ONjAw2fCbFKtoP7ltZOg8wqBDdElBNBtlqy6VZqyA4Yx+5dzQ15
         +IV95WG8gZf18Yw1cBznZMvwqWylHqvP7ktvUvqBmM4Wc8iHGlEMQdCoZ1UKt4qg90qP
         4dvw==
X-Gm-Message-State: AOAM530953Z8w/Xl36S06qHxmZ/c8czgI96BEq6gJGHGGIoAZFONYfou
        K2hJ1LjzuwLsJ/j18445O8bHi4TmlDwkKAYN/aWijA==
X-Google-Smtp-Source: ABdhPJwUGaPJAcf7ZY3glyfDe01/RiBPl232bSVi8CCynx/cbvS7pPlfrJjmGcZrIJB76jl7or1XQQtywu1tePphoYg=
X-Received: by 2002:a37:45c9:: with SMTP id s192mr7190967qka.21.1629251536754;
 Tue, 17 Aug 2021 18:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210702114820.16712-1-varad.gautam@suse.com> <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
 <YRuURERGp8CQ1jAX@suse.de>
In-Reply-To: <YRuURERGp8CQ1jAX@suse.de>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 17 Aug 2021 18:52:05 -0700
Message-ID: <CAA03e5FTrkLpZ3yr3nBphOW3D+8HF-Wmo4um4MTXum3BR6BMQw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
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

On Tue, Aug 17, 2021 at 3:49 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> Hi Marc,
>
> On Fri, Aug 13, 2021 at 11:44:39AM -0700, Marc Orr wrote:
> > To date, we have _most_ x86 test cases (39/44) working under UEFI and
> > we've also got some of the test cases to boot under SEV-ES, using the
> > UEFI #VC handler.
>
> While the EFI APP approach simplifies the implementation a lot, I don't
> think it is the best path to SEV and TDX testing for a couple of
> reasons:
>
>         1) It leaves the details of #VC/#VE handling and the SEV-ES
>            specific communication channels (GHCB) under control of the
>            firmware. So we can't reliably test those interfaces from an
>            EFI APP.
>
>         2) Same for the memory validation/acceptance interface needed
>            for SEV-SNP and TDX. Using an EFI APP leaves those under
>            firmware control and we are not able to reliably test them.
>
>         3) The IDT also stays under control of the firmware in an EFI
>            APP, otherwise the firmware couldn't provide a #VC handler.
>            This makes it unreliable to test anything IDT or IRQ related.
>
>         4) Relying on the firmware #VC hanlder limits the tests to its
>            abilities. Implementing a separate #VC handler routine for
>            kvm-unit-tests is more work, but it makes test development
>            much more flexible.
>
> So it comes down to the fact that and EFI APP leaves control over
> SEV/TDX specific hypervisor interfaces in the firmware, making it hard
> and unreliable to test these interfaces from kvm-unit-tests. The stub
> approach on the other side gives the tests full control over the VM,
> allowing to test all aspects of the guest-host interface.

I think we might be using terminology differently. (Maybe I mis-used
the term =E2=80=9CEFI app=E2=80=9D?) With our approach, it is true that all
pre-existing x86_64 test cases work out of the box with the UEFI #VC
handler. However, because kvm-unit-tests calls `ExitBootServices` to
take full control of the system it executes as a =E2=80=9CUEFI-stubbed
kernel=E2=80=9D. Thus, it should be trivial for test cases to update the ID=
T
to set up a custom #VC handler for the duration of a test. (Some of
the x86_64 test cases already do something similar where they install
a temporary exception handler and then restore the =E2=80=9Cdefault=E2=80=
=9D
kvm-unit-tests exception handler.)

In general, our approach is to set up the test cases to run with the
kvm-unit-tests configuration (e.g., IDT, GDT). The one exception is
the #VC handler. However, all of this state can be overridden within a
test as needed.

Zixuan just posted the patches. So hopefully they make things more clear.

Thanks,
Marc

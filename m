Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46323402E53
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345839AbhIGS1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbhIGS1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 14:27:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BCAC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 11:26:14 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so7608wms.4
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FhXgO4soHUfxUZvgfxgTnbg0Q339mdYzMA/DtCHulwM=;
        b=XujAKCsnSv1SoIEqIFBQX0tSV/UFdURbpRl6b/A2AzaV6EgVVpRy4fvqRJVNkfktOX
         XgjoLQtKKvIP1kxEyMRpoFzl4pPsgCNTm6Maus1bw1cg4j7VovCDgC3FeuTGZa6Q8P6Z
         7rnnb6gVceVdPykWLjsC8x4JFbHsqMK9HqkgsmK1F1AuHUxmTZuOYPrn1iKWo37teFlf
         XyNBkiSk1IDWaMvYWR6D2aoS9EWu25NKX0eSuR1FAqWNn3zM+4SMFeOLiaWQSQcOVheA
         oOlcrn9LQGeM+m4Y2PQ8vztisubnmJ3/mvJFjxngs4HaqH69lQlE3bXs7fb5qn4z7xoq
         7WzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FhXgO4soHUfxUZvgfxgTnbg0Q339mdYzMA/DtCHulwM=;
        b=apTPqY7Ti90qrzJXM6BDkksMmUCIGznDQrCrCysLm2BUlvnNUscnl3d587lex0pQSN
         7ZWd6MPj2+d+4hSdBy3c2MFNg8JdoniomgWIdC5NUugHmQb/7rrRuAyucZtOYjXVX/X5
         0Dn7dpwy5XDdMp7nn1+gqTQ4/+XFn6ickbWvBaCvTguYS8KtZPfVSwSyvn5V9DRg6+7R
         mLDnbPbPJYU2AbWie09xds+WvRcjtap+EabF+ZpE9IVXRzK5ps4QZczYUFCeLZYACVOV
         OWCvhxFFYZg+THuX1ICj8LrlpP6KpLq9xql9CEi1TwbLYLzI5M226eNa9pIfNSamAZi4
         mksQ==
X-Gm-Message-State: AOAM533u5mU6mzRXpljHrlCPA+RvtLA7sawxdjAUuM6lwORRveolKLs9
        hGuz21z41OZ51c0TSKPB27A/xFvydb20+tPnYvdM0baSk2Y=
X-Google-Smtp-Source: ABdhPJwMBtgoNU1DNZ3wjpbNoTr8qYBDuvceJ9eIxrnJpE3hgXpGIxe2N2Hyd1ZrAxjAa2aJTCxvA5d0Q8jsAy15RLE=
X-Received: by 2002:a05:600c:19d0:: with SMTP id u16mr5288352wmq.21.1631039172877;
 Tue, 07 Sep 2021 11:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210822144441.1290891-1-maz@kernel.org> <20210822144441.1290891-4-maz@kernel.org>
 <CAFEAcA_J5W6kaaZ-oYtcRcQ5=z5nFv6bOVVu5n_ad0N8-NGzpg@mail.gmail.com> <87bl54cnx5.wl-maz@kernel.org>
In-Reply-To: <87bl54cnx5.wl-maz@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 7 Sep 2021 19:25:23 +0100
Message-ID: <CAFEAcA_MRyd2AcgAhvEwJY8LGbHoyz_JgTdMGAEtGegvZB0d7A@mail.gmail.com>
Subject: Re: [PATCH 3/3] docs/system/arm/virt: Fix documentation for the
 'highmem' option
To:     Marc Zyngier <maz@kernel.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        kvm-devel <kvm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Sept 2021 at 18:10, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Peter,
>
> On Tue, 07 Sep 2021 13:51:13 +0100,
> Peter Maydell <peter.maydell@linaro.org> wrote:
> >
> > On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > The documentation for the 'highmem' option indicates that it controls
> > > the placement of both devices and RAM. The actual behaviour of QEMU
> > > seems to be that RAM is allowed to go beyond the 4GiB limit, and
> > > that only devices are constraint by this option.
> > >
> > > Align the documentation with the actual behaviour.
> >
> > I think it would be better to align the behaviour with the documentation.
> >
> > The intent of 'highmem' is to allow a configuration for use with guests
> > that can't address more than 32 bits (originally, 32-bit guests without
> > LPAE support compiled in). It seems like a bug that we allow the user
> > to specify more RAM than will fit into that 32-bit range. We should
> > instead make QEMU exit with an error if the user tries to specify
> > both highmem=off and a memory size that's too big to fit.
>
> I'm happy to address this if you are OK with the change in user
> visible behaviour.
>
> However, I am still struggling with my original goal, which is to
> allow QEMU to create a usable KVM_based VM on systems with a small IPA
> space (36 bits on the system I have). What would an acceptable way to
> convey this to the code that deals with the virt memory map so that it
> falls back to something that actually works?

Hmm, so at the moment we can either do "fits in 32 bits" or
"assumes at least 40 bits" but not 36 ?

thanks
-- PMM

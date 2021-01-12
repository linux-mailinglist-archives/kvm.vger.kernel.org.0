Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171B62F29A4
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 09:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392270AbhALIDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 03:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730224AbhALIDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 03:03:52 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5FAC061575
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 00:03:12 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q137so2174883iod.9
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 00:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VnTxaX+GcY6DoNNSvT9wnlvYtM3nEO/7XTuG0gI1XWs=;
        b=hfewghNPsFHp0mZQ+UZ+OAL6KYCEVjtoKn/ofJLXtxK6bQR+/fPOXumwrsQQi8qJ1F
         Oo3BSdV4VqTSYKQIR9PnRXSRwtmzHLvfv5Ebx1RfISFIHbv3FHeeZQpcRl6GDsVBxceY
         LV77Cc/ErsL6i4hIERPP2pFaBijUtp4eo3X5agAzm2qNoBhFDKsUS6xa16s/UrPQ2Ffw
         drLRvW4lPdFCJFacI1SaQZ2PyCUeIBaChFvvcVq57U6q9CXW5LXSb+ZJDA1fhzJBEGiz
         MVB0FECGgX/Wdbl3M2FpmLJ6TK+brHfJaZm5PbQwna1/aSmmm2awr6d4hoVpwBXzVhJE
         J63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VnTxaX+GcY6DoNNSvT9wnlvYtM3nEO/7XTuG0gI1XWs=;
        b=lLb2V2wwsoGy+RWZ0BcFWdPC2IQwkOM7Wv8RBj8KS7ZzbEe9BJTxQN8S8YtH2rGVLr
         87TtwqVJm5OJFX+9t4bsrwQxNz5sZ09qrQ96n29NgbRACKiUMHiGeoEHwicaJcpAyzcm
         RJinA+ROE1J20AedxV8ogx56smXyWo1u5cMAafJlO9fokgjTVHYLNFQwOHPeW7WjZCah
         nqvS7I7hQXlYadKjyk0k6SxocMTuknWgRhPr6qvSttQY56NbVJFjab4p99jVUE5qUhvu
         +vhmAkhjW+jE3oKL/g7O0EecgfUOfWwoS4ErB9n2FoHVzXL4WgxOVQ7Hwgfb52yiQjOL
         ZVjg==
X-Gm-Message-State: AOAM533yrunA/3lfIDgQYSd8nC6SvAuvUijcAQL02PZv0VhNOxtqWxhw
        6k0uAG5HIL0SzNK0wYaAxQdoJSFUjmDUzvTG4DGn
X-Google-Smtp-Source: ABdhPJxHFSudvR9q1GJeSbnDqoM/WeTWTAEfSjcQMZGj5ZF/7oNNSYxbVsaGYPUrJ4AVt1YeEp6bTXyLDMfDN4l9iVY=
X-Received: by 2002:a92:98db:: with SMTP id a88mr2851932ill.106.1610438591803;
 Tue, 12 Jan 2021 00:03:11 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org> <CAJc+Z1GFHp17+ROTyDnfS4QLs0kCEVBCD7+OBkHZA53q-zmiLQ@mail.gmail.com>
 <47c1fd0431cb6dddcd9e81213b84c019@kernel.org>
In-Reply-To: <47c1fd0431cb6dddcd9e81213b84c019@kernel.org>
From:   Haibo Xu <haibo.xu@linaro.org>
Date:   Tue, 12 Jan 2021 16:02:59 +0800
Message-ID: <CAJc+Z1FCQ483Rye9mL=2v2RB+5UMfGRm6WNnKYXxg7Lb=cqPaw@mail.gmail.com>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
To:     Marc Zyngier <maz@kernel.org>
Cc:     arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Jan 2021 at 16:59, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Haibo,
>
> On 2021-01-11 07:20, Haibo Xu wrote:
> > On Fri, 11 Dec 2020 at 00:00, Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> This is a rework of the NV series that I posted 10 months ago[1], as a
> >> lot of the KVM code has changed since, and the series apply anymore
> >> (not that anybody really cares as the the HW is, as usual, made of
> >> unobtainium...).
> >>
> >> From the previous version:
> >>
> >> - Integration with the new page-table code
> >> - New exception injection code
> >> - No more messing with the nVHE code
> >> - No AArch32!!!!
> >> - Rebased on v5.10-rc4 + kvmarm/next for 5.11
> >>
> >> From a functionality perspective, you can expect a L2 guest to work,
> >> but don't even think of L3, as we only partially emulate the
> >> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
> >> as well as anything that would require a Stage-1 PTW. What we want to
> >> achieve is that with NV disabled, there is no performance overhead and
> >> no regression.
> >>
> >> The series is roughly divided in 5 parts: exception handling, memory
> >> virtualization, interrupts and timers for ARMv8.3, followed by the
> >> ARMv8.4 support. There are of course some dependencies, but you'll
> >> hopefully get the gist of it.
> >>
> >> For the most courageous of you, I've put out a branch[2]. Of course,
> >> you'll need some userspace. Andre maintains a hacked version of
> >> kvmtool[3] that takes a --nested option, allowing the guest to be
> >> started at EL2. You can run the whole stack in the Foundation
> >> model. Don't be in a hurry ;-).
> >>
> >
> > Hi Marc,
> >
> > I got a kernel BUG message when booting the L2 guest kernel with the
> > kvmtool on a FVP setup.
> > Could you help have a look about the BUG message as well as my
> > environment configuration?
> > I think It probably caused by some local configurations of the FVP
> > setup.
>
> No, this is likely a bug in your L1 guest, which was fixed in -rc3:
>
> 2a5f1b67ec57 ("KVM: arm64: Don't access PMCR_EL0 when no PMU is
> available")
>
> and was found in the exact same circumstances. Alternatively, and if
> you don't want to change your L1 guest, you can just pass the --pmu
> option to kvmtool when starting the L1 guest.

After passing --pmu when starting a L1 guest, I can successfully run a
L2 guest now!
Thanks so much for the help!

Haibo

>
> Hope this helps,
>
>          M.
> --
> Jazz is not dead. It just smells funny...

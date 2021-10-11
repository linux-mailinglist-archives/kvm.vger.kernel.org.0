Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E3F42942A
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 18:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhJKQKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 12:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhJKQKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 12:10:48 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D82C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 09:08:48 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id h2so40050806ybi.13
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 09:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1IZZmHpZJEGprcsYAoU/nu0GgHlWLkOakQbKNK/k+g=;
        b=mlNCnyY4+Gk9mJudvL1KHNimChN7ceAZU9hjGcP5sZ7iTcoagcnLWxwUeYVNAyM+vp
         p/piW8IlvILBF5cUKYWqNUaWI66sa3uFU9Naizabxy2GVKcfUqgGMfsuB1mgpZel2lo+
         szN7rwYLncZl2e/VXu26Ms3xhLiS8ymdIKMG9t1YfF2F5bxGN/wcMZRdt+brJj568bcP
         qH5wo6vjFzazyqt79hptbGV3TRra5D1HsJN1T6gSj3jv9NoaVr4pjCXprrPHV4KVI9vf
         6yWPNM6BteQ3qVlijR70EhltzdADxwVmmDrTEcyaCdTtckBo3z5eSUX84kL88do0j+sH
         WNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1IZZmHpZJEGprcsYAoU/nu0GgHlWLkOakQbKNK/k+g=;
        b=3fTe/TZXfFAqPBIQ8LCSNWN37G1n6/7HnNjfYwjKvzAlPrzPkfVvYWFkBp4Z328gZl
         xYzB/OEd1VbIVS0a4txFdNi1Mn3s1I5Y8D99KiDypCOeoDztQLE5jLUDJ1FtwEw0fsCK
         s7MUocQWu8HT7YiCcaydU3TBcZx4nwq5Q+rZtlO7Qls2EYfLXioP1zxFow7KpGjoWFWc
         uad++BtMWmHM3sCI/TFYTWrxvR0XxM4KuBouVC4XYHro3SqgAeU6iyKahLKULs4zUzrx
         lyJNm4SD8QgGxvWV/dpJJVFaOKgUW2SnSKOjbEvgfxGBZMZc8cT5cgQRFhcC5whfoXP2
         grjg==
X-Gm-Message-State: AOAM533iFA87+2RiBzpG5X/h/spIa4YTcsR8FcfRhvtxPKAF6xJTwoOK
        xWFve8m8Jo7Pj2B+Mcg3jUGFX+PN8rkBnwVxBGVfYg==
X-Google-Smtp-Source: ABdhPJxoWeF/9UsD/zG3Z5AIQx5G4xvBwCI4PzBsciydwuujm6dRP5CD4YLqtZKa5iw/bktpgnu/NNxz4ay1XCAt02I=
X-Received: by 2002:a25:2f8e:: with SMTP id v136mr22214178ybv.350.1633968527209;
 Mon, 11 Oct 2021 09:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211007233439.1826892-1-rananta@google.com> <20211007233439.1826892-4-rananta@google.com>
 <87y270ou3y.wl-maz@kernel.org>
In-Reply-To: <87y270ou3y.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 11 Oct 2021 09:08:36 -0700
Message-ID: <CAJHc60w1JVHH0SGq8WiebbRNQKeZzavdO6S701yTjmmA=NHqHg@mail.gmail.com>
Subject: Re: [PATCH v8 03/15] KVM: arm64: selftests: Use read/write
 definitions from sysreg.h
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Oct 11, 2021 at 1:15 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Raghavendra,
>
> On Fri, 08 Oct 2021 00:34:27 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Make use of the register read/write definitions from
> > sysreg.h, instead of the existing definitions. A syntax
> > correction is needed for the files that use write_sysreg()
> > to make it compliant with the new (kernel's) syntax.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
> >  .../selftests/kvm/include/aarch64/processor.h | 13 +--------
> >  2 files changed, 15 insertions(+), 26 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index e5e6c92b60da..11fd23e21cb4 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -34,16 +34,16 @@ static void reset_debug_state(void)
> >  {
> >       asm volatile("msr daifset, #8");
> >
> > -     write_sysreg(osdlr_el1, 0);
> > -     write_sysreg(oslar_el1, 0);
> > +     write_sysreg(0, osdlr_el1);
> > +     write_sysreg(0, oslar_el1);
>
> The previous patch has obviously introduced significant breakage which
> this patch is now fixing. In the interval, the build is broken, which
> isn't great.
>
> You can either rework this series to work around the issue, or I can
> squash patches #2 and #3 together.

Thanks. I didn't realize this. I'm fine with you squashing the patches
together (I guess I would do the same).

Regards,
Raghavendra
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

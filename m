Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEA53FE5CA
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 02:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244710AbhIAWof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbhIAWof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:44:35 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00149C061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:43:37 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id c6so3958ybm.10
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U+r4CwgKG+yEodhHzC7nFI5Y9Wnbyo4zL9qFFX9zlnM=;
        b=JOkMP8RXO6jdIjIDD6ZH3jrv9UvB6l279lUpP6filw3CBk6k1N1Hwj4bB+HLyMDRma
         boD3ZbnLqtdnNwuqesuS2HLMkqRyrZHeaia+pvNPCT5BKtEqWOmyEyiXQxJAyJC7Tf9q
         4ZnqybnkHfs+Ms/08GdCeE+nkY2Z4/6wD9jZtk51UPliBiGeD3r02osFUGdJfXWK+37N
         Rh2HJkrC41dh2GjZCh7Y9ajtEv3CGhIGQOw3dol55gzG/dj6A8DAPpPCYb1Sl+W+o/jy
         0sCXMnz+HIYSyDRFWFsuXdBSq+fQWnvW9N3oN7tIEn+y26OGONWz2qjuMjcUCQuC9gw/
         GLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U+r4CwgKG+yEodhHzC7nFI5Y9Wnbyo4zL9qFFX9zlnM=;
        b=I+cZJwG30Jc8gh8Sm2PwafmEUVrEcTCE+B3HeNo8Rsc2EGBmOnUSqVQQ06NuewMbKa
         s2uD5nSpUxFkVLq/5cf0dYr6duQ6ZoCyvxdOlRigp8qucRwF91TExOR7YDHRY9otZ9Yb
         eG7+nQF8PYw9fezKi0oeBdo+wpLT956hzhTV12sMI2UlXE5ynb7SYxeogmBHwiP9j10s
         Hl7gVXpRuLjPBDkyx+WltJxl89D3vETNixuUWQhNf6JPHEF+3vhF9zZmRu3J22eW2nI6
         phTobADxnZzUurV4SFuycz5fZ8HXTpFdLO26Yke7yRu/pgyHixrtXKwK1kBrrBNR6IPc
         6hhQ==
X-Gm-Message-State: AOAM530LlO6Wm1pL9NuxMUtY5jA9F821ZGa+cF7EgcM0aK067gdw6e/Q
        RqqhfFQVfPJnJoqzElVyLq4pxV7pzH0ww4YEdoWDJA==
X-Google-Smtp-Source: ABdhPJzi+Lf0Xejnkm0ckXhh2uNvzEvpcGrgx17PRpTaVpfoZFF6sLe4mbguXZjsOTaBLHIIADIlXq1Ey2THBjkzhnc=
X-Received: by 2002:a25:6507:: with SMTP id z7mr276648ybb.439.1630536217085;
 Wed, 01 Sep 2021 15:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com> <20210901211412.4171835-2-rananta@google.com>
 <YS/vTVPi7Iam+ZXX@google.com>
In-Reply-To: <YS/vTVPi7Iam+ZXX@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 1 Sep 2021 15:43:24 -0700
Message-ID: <CAJHc60wx=ZN_5e9Co_s_GyFs4ytLxncbYr2-CzmTUh5DvvuuNQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] KVM: arm64: selftests: Add MMIO readl/writel support
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 1, 2021 at 2:23 PM Oliver Upton <oupton@google.com> wrote:
>
> On Wed, Sep 01, 2021 at 09:14:01PM +0000, Raghavendra Rao Ananta wrote:
> > Define the readl() and writel() functions for the guests to
> > access (4-byte) the MMIO region.
> >
> > The routines, and their dependents, are inspired from the kernel's
> > arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
> >  1 file changed, 44 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index c0273aefa63d..3cbaf5c1e26b 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -130,6 +130,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
> >       val;                                                              \
> >  })
> >
> > -#define isb()        asm volatile("isb" : : : "memory")
> > +#define isb()                asm volatile("isb" : : : "memory")
>
> Is this a stray diff?
>
Oh no, that's intentional. Just trying to align with others below.

Regards,
Raghavendra
> Otherwise:
>
> Reviewed-by: Oliver Upton <oupton@google.com>

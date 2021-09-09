Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C5405B42
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbhIIQuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238519AbhIIQuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:50:24 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE58C06175F
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:49:11 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id z18so5161659ybg.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+RgoVMQufwJ1iQH8D3qsEs6NeJAccH1we8wbejIgaA=;
        b=cKYHvkvuT7X76SxD/wV7YqPOMI1NJnCntmtpLCPUNYxyJ9kJmg1gz9JmPF8j6aZWCp
         HkUfLN6kOAf5LDuVEu+pXws7bQINvVC+T+LEEAor5KfA35yFRFVrURB3lc2+sX6+x8GM
         PzsCJaynqKz2jVTUHEL0fGsZpjHslFS5xMQwWj93foGhmNCnNL6CCsOiBH8anvLtHz0n
         yLWSMLlZi5dJczkFF96IfwEUwqoGsDFhBEfhAkmfrxcGIuKY48mSwUmU5GT/8Nob6l5I
         bZNfoDgt9wxtcx2nSN/Z0cTmkA7ttTgOGC2d2uM3N1eo3Mwa//VA8lA6J54Xcww3kP3h
         HU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+RgoVMQufwJ1iQH8D3qsEs6NeJAccH1we8wbejIgaA=;
        b=BLxJ6UP1hBI3NTd/7p7cx4vW+4pacxGZjoVR9KeKZ9seqRv/4f8ER8qq0MJhWRrIUT
         AVCSlGQw53555b1qLmrBp9a6UGtP1YdTujSw+aD8pF2cVLkXlzNxCAcXKMAeVvTnacST
         81Xv0AQt0Cp0Gkhl+5TH1kaE1i+bbbOOsbtQVp/u81knfQoO0Lqd5sFDNJ5FmJATqkUQ
         hGciTXuCmPDZbJpmOQ1RzsRzGyatyfx4Gv50LM49V8lAvTisS+e+S1wuzqNCLKulFgey
         nLN77p2XLdrA2hZNUWYorg44vin8gZRqze0EaI/Aw1Smw2rwVaDHMtzwjcuyfNEGaJW3
         zG2A==
X-Gm-Message-State: AOAM530YisBSUyrodS912UUVsJsl/tOfRpNT035WgGLg2r+dEf35PgCK
        o1hFrsKm0+A8AE8pq1tkPQ0IJndaVTIXzwAIbMuWQQ==
X-Google-Smtp-Source: ABdhPJwYzxkIizwJV6evp1HhsQhKyxmT4fexYZ5FumlIdEfFU+MXdO/TKphQSop5An7mY+3rnXaNQ/1679+nvib75Zc=
X-Received: by 2002:a25:c504:: with SMTP id v4mr4742567ybe.308.1631206150502;
 Thu, 09 Sep 2021 09:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-5-rananta@google.com>
 <YTl5RQjJ0EFmhUlG@google.com>
In-Reply-To: <YTl5RQjJ0EFmhUlG@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Sep 2021 09:48:58 -0700
Message-ID: <CAJHc60zkJ472fW7iAqMoW7JKLzXYwfYdZcAvRyYrxY-V04bTmQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/18] KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
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

On Wed, Sep 8, 2021 at 8:02 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Raghu,
>
> On Thu, Sep 09, 2021 at 01:38:04AM +0000, Raghavendra Rao Ananta wrote:
> > With the inclusion of sysreg.h, that brings in system register
> > encodings, it would be redundant to re-define register encodings
> > again in processor.h to use it with ARM64_SYS_REG for the KVM
> > functions such as set_reg() or get_reg(). Hence, add helper macro,
> > ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> > into ARM64_SYS_REG definitions.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h      | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index bed4ffa70905..ac8b63f8aab7 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -26,6 +26,20 @@
> >
> >  #define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
> >
> > +/*
> > + * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
> > + * SYS_* register definitions in sysreg.h to use in KVM
> > + * calls such as get_reg() and set_reg().
> > + */
> > +#define ARM64_SYS_KVM_REG(sys_reg_id)                        \
>
> nit: KVM_ARM64_SYS_REG() perhaps? Dunno which is more readable.
>
> > +({                                                   \
> > +     ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),          \
> > +                     sys_reg_Op1(sys_reg_id),        \
> > +                     sys_reg_CRn(sys_reg_id),        \
> > +                     sys_reg_CRm(sys_reg_id),        \
> > +                     sys_reg_Op2(sys_reg_id));       \
> > +})
> > +
>
Heh, I came up with the logic faster than picking a name for the
macro. I guess KVM_ARM64_SYS_REG may be more readable, just for the
fact that it begins with KVM_. I'll change it.

Regards,
Raghavendra
> Could you also switch all current users of ARM64_SYS_REG() in the KVM
> selftests directory in this commit? You can also drop the system
> register encodings defined in processor.h
>
I did that in a separate patch, but I can squash it here to avoid confusion.

Regards,
Raghavendra
> --
> Thanks,
> Oliver

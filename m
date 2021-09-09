Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE04405B46
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbhIIQvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbhIIQvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:51:12 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADE6C061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:50:02 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id y13so5173576ybi.6
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZZOGzt5oKbWLt2jfyo0/YulPHEm4sBwR6royMlN8x0=;
        b=NRaEOqyBM610pgGJsqTqL4Gdbp/NB5GTK4jCV/T1gFFYlvThnghqZylNnYIGe3OXV0
         fN1hbhdX7yXdr7kCCk4Tg2v6p0xlI7I1FEEKIu8mquddRmJ3eb5cwNTsoFUeX3108ilX
         cKRAXjtWECHFTSAm3CtzOPse6OECVtJvbuvPiG6jyJbmivIZB1NqupLU/BkMUN5+mxnu
         CBq4ATdHpCeZAPpoihGvjEVhOSQi/jJT9OksS+A7+Ep+BXpE1duD8YRrQnxRoJ8DJO06
         +T02alyunIml6+cqUxAbq2/82O3P2HKjWqBf/p28vKQGkbylTqKv6OOsXgwV+MzRelnV
         fnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZZOGzt5oKbWLt2jfyo0/YulPHEm4sBwR6royMlN8x0=;
        b=r/gpm6wr0yWPxrbFzHj/yYmuxO5yuhY67Bh9/q3ThaXQ6pefpzCjzq4DcnJuBph3kK
         DeDtE4euu9hxyS9zZrPkpPlxkPiQm07Sa3euV0GCL+rByofenqx47drqrI9zSIbJj0Ou
         7USqtklFzsBT8SmMtNk46Z81moYd8GxhEMxpS60W555t0BkEDMy8jZrIizg6n7wMLyED
         txh6XnsqUr51zUYOisYEiic3tgcshGtKsDoMaCMWPjj2Ynuh7AuotnEkrYRbEN6X53U1
         JHZ+9irzj7Mwtf8ewXxb4JVfyS4wfpQdkVoAFFe2rhFNt2Ssqb9ln6eVQtl/6GTfDFfS
         zbmg==
X-Gm-Message-State: AOAM532o+pIv3DSS6L8z6132Wnugpjr7n27fOACJw7NjO+E7ja5ss2d1
        e1fsrQ/j5d/ugtPJh/4pR0ZY8Jkibdos5PxBYgc2zw==
X-Google-Smtp-Source: ABdhPJzWGqJzOaqHFiOaZZSFb/gHx+W2eWc2XTLC4gq0ldXwPD5pdi5JVNosEBPqyBM7wbyg4V3MzalTA9vcbJP2inM=
X-Received: by 2002:a25:cd82:: with SMTP id d124mr5134084ybf.491.1631206201951;
 Thu, 09 Sep 2021 09:50:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-5-rananta@google.com>
 <20210909070423.5z4eg7wkmswpdi33@gator>
In-Reply-To: <20210909070423.5z4eg7wkmswpdi33@gator>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Sep 2021 09:49:50 -0700
Message-ID: <CAJHc60yU8ihjS9Y1aPOkjv8MpPy0x7=X7kQxnU2aXUjYTe3M7w@mail.gmail.com>
Subject: Re: [PATCH v4 04/18] KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
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

On Thu, Sep 9, 2021 at 12:04 AM Andrew Jones <drjones@redhat.com> wrote:
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
> > +({                                                   \
> > +     ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),          \
> > +                     sys_reg_Op1(sys_reg_id),        \
> > +                     sys_reg_CRn(sys_reg_id),        \
> > +                     sys_reg_CRm(sys_reg_id),        \
> > +                     sys_reg_Op2(sys_reg_id));       \
> > +})
>
>
> I don't think we need the ({ }), do we? Anyway,
>
I guess we don't. Must have left it there while I was trying a few
things. Will clean it up.

Regards,
Raghavendra
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> Thanks,
> drew
>
> > +
> >  /*
> >   * Default MAIR
> >   *                  index   attribute
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
>

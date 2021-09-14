Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF98440B56D
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhINQ4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhINQ4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 12:56:47 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2227DC061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:55:30 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v10so29737318ybq.7
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CiT20f+n/K0wwGy2+rqWqUjT0xmQpOS21TTyMD2zlmE=;
        b=nMdL8uCTiQIMJh57mn76kJI1SjOunTniqob8xg06HjQHvwabBbiIEUoG1V/HxhbDRi
         B/xog7mzfm9my23apb9v85KQrza1TrtowTXKcScTJZ4+X30PxKKrUOYeTVD2fdrTQ2g/
         Pvq3Xd26dcI4NrPFe19pW1JvJMSQPv+FQM+wJPukchgr69OHjF+2wQwuSkDaWOtI3vC1
         4Fr7bjTmPKHnXsWIOqLwYPx1kYWVZFo4Ly2/tUV7HDmL2DWyYfQQ9iqgfRPK8yNidZJo
         EqqHurEf2kxlJDesWikVmli4MC0W3p/P7EdB3SdSe7MrTM8DJiYprZc2u2fgAqABTu27
         g4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CiT20f+n/K0wwGy2+rqWqUjT0xmQpOS21TTyMD2zlmE=;
        b=iFH3ZsEMzs6D0x8HhWUpX7L/jeq9hrtpBTvtATGC5Ol5qfmK5J5qeB0hSQ5T6hIJwt
         EdHb2xS7LmX243BxYZY1e2Hx2Kg5jv/O8Wiv668x1De54AM54AuNiToNoGs0kPhvTWJu
         isw8KdN3S4hLPJVupxfitE1HFgJUcx5b/d6+js5dJrM+Lal3z6+yMuu4E0fSf+MJl6SN
         mbwINNH9upInnpylx3SUiQFvPs5Xzfn19EuX3r8VUJLY0gUlvJqupTaC2mh8gQv3hJMu
         fR/DAn9I67Gk2fO9V71hRuQdLTk+uqALy68AdfgF8mkA4oFE44DKl7yGxjPQjyTIrvEN
         Mvzg==
X-Gm-Message-State: AOAM532wYG30iGxXO0ILf+tkIfxX/CbRpwqYGWtdt4n5q3o3XxJCy457
        awVEJvMCVVSY2iqDXqw2KtxHYbXRIeFyoeIuLjDrnw==
X-Google-Smtp-Source: ABdhPJy03PrI5vpf60tAG6fNSu3/OBlIZAi3gAIVabPc0hL49cirqfjGeryObR3PamSArsD9t9I5ApbE0cHps48WO0Y=
X-Received: by 2002:a25:c504:: with SMTP id v4mr202049ybe.308.1631638529167;
 Tue, 14 Sep 2021 09:55:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com> <20210913230955.156323-3-rananta@google.com>
 <20210914064845.4kdsn4h4r6ebdhsb@gator.home>
In-Reply-To: <20210914064845.4kdsn4h4r6ebdhsb@gator.home>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 14 Sep 2021 09:55:18 -0700
Message-ID: <CAJHc60z_712Q2pZGBYMx1XJ29++3LrO=TCczHCsoQFb1qWEw5Q@mail.gmail.com>
Subject: Re: [PATCH v6 02/14] tools: arm64: Import sysreg.h
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

On Mon, Sep 13, 2021 at 11:48 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Sep 13, 2021 at 11:09:43PM +0000, Raghavendra Rao Ananta wrote:
> > Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> > into tools/ for arm64 to make use of all the standard
> > register definitions in consistence with the kernel.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/arch/arm64/include/asm/sysreg.h | 1296 +++++++++++++++++++++++++
> >  1 file changed, 1296 insertions(+)
> >  create mode 100644 tools/arch/arm64/include/asm/sysreg.h
>
> Looks like an older version than what is available now (v5.15-rc1?)
> was used, but it's expected that these tools copies go out of date
> quickly and it doesn't matter.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
While I'm sending out a new patchset anyways, I'll pull-in the latest copy.

Regards,
Raghavendra
> Thanks,
> drew
>

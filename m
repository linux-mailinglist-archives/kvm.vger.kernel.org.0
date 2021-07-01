Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76A23B9362
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 16:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhGAOfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 10:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbhGAOfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 10:35:02 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9EBC061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 07:32:31 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id t24-20020a9d7f980000b029046f4a1a5ec4so6730136otp.1
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 07:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GTWJSM0xuYeJ1qxgbQHiMwUUzauF3cOKfHO15I4MhOw=;
        b=EygC7C1OvqQkptipYOSfVSwUc6YZNt5+lNvyBzvRWkOWnirOZ5wZ5dEsoamkLJSrj5
         /9B6RCY00Jxl7hENRq7PzVM0E7y+LFl/Zq9En80e2xztq0ZfSTeBnb2rLBJ0B7btNNvu
         VmYVBwzU4mhxmPmzpctJscT43Ul9Jn2DCd5DgNc3sB3joylfXFKMVIz5uHQzyQXU7iZV
         AvsFjjNLNPQWuSh2bM7QffkAjjXVhneH9SBuMvihGyPgnRcaQqd9047WD3+O7z9yiXXX
         N35Cvz55rAMmglMiCW5pr9ff+HoAErFWVkAA+hb05qKN9wEBJSrop38E/WXO+MK+WD+z
         AXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GTWJSM0xuYeJ1qxgbQHiMwUUzauF3cOKfHO15I4MhOw=;
        b=LKdIupX89L1XvAgCus7WXU9fslPHui2Nk8j5Y4oQjJzywIC/gKblfckfoC5c4YuKi+
         3sqNwXYdQArSkVppptd6WvwSNCZKnRFn1G28VNU74bAe6ddfalmGn/r5UDqyZSicwP/K
         7CjoBaPIMPToKpPrPsK5VXwRh5rLaAxOz2+sdR/76azjWiDIeeL2yPrUgaJRAbnReXXD
         YpiXoEy9ZLH7uzh/nS3QxlXWX0UprwWlSyOKYD9gFjezqYH8wiHI5QDkDroEDl6m24qR
         Tv6exKJiZMVh8kfn+/Y/tBv9UWDJAXzQM4zHserJ0fr9Zdvswub4be6KVJoe8aJQwwyf
         XnqA==
X-Gm-Message-State: AOAM531VNeZNuvpem7If1T8qjICIzfl3/g00jZcRMyNqf3q0raFX29Iy
        TqO8autO7fxeOtYdCBIa5+n7BLX3iYdmBItHr9CooA==
X-Google-Smtp-Source: ABdhPJzW0WFDucrNK/jthp+c5o1CjayKDRPKm1VqM1CogtX3ulAO6RQp4oH+Gl/UqH7nsn/hycliW0RuWuVZ1PFLkpU=
X-Received: by 2002:a05:6830:18da:: with SMTP id v26mr262263ote.144.1625149951088;
 Thu, 01 Jul 2021 07:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com> <20210615133950.693489-7-tabba@google.com>
 <20210701132244.GF9757@willie-the-truck>
In-Reply-To: <20210701132244.GF9757@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 15:31:54 +0100
Message-ID: <CA+EHjTwcJaQtgJK8Wiqj1W+oyNU8oycGdR0Kk-+5BJbyj5oEPQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add feature register flag definitions
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Jul 1, 2021 at 2:22 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:43PM +0100, Fuad Tabba wrote:
> > Add feature register flag definitions to clarify which features
> > might be supported.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 65d15700a168..42bcc5102d10 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -789,6 +789,10 @@
> >  #define ID_AA64PFR0_FP_SUPPORTED     0x0
> >  #define ID_AA64PFR0_ASIMD_NI         0xf
> >  #define ID_AA64PFR0_ASIMD_SUPPORTED  0x0
> > +#define ID_AA64PFR0_EL3_64BIT_ONLY   0x1
> > +#define ID_AA64PFR0_EL3_32BIT_64BIT  0x2
> > +#define ID_AA64PFR0_EL2_64BIT_ONLY   0x1
> > +#define ID_AA64PFR0_EL2_32BIT_64BIT  0x2
> >  #define ID_AA64PFR0_EL1_64BIT_ONLY   0x1
> >  #define ID_AA64PFR0_EL1_32BIT_64BIT  0x2
> >  #define ID_AA64PFR0_EL0_64BIT_ONLY   0x1
>
> Maybe just consolidate all of these into two definitions:
>
>   #define ID_AA64PFR0_ELx_64BIT_ONLY   0x1
>   #define ID_AA64PFR0_ELx_32BIT_64BIT  0x2

Will do.

Cheers,
/fuad

> ?
>
> Will

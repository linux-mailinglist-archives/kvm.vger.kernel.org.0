Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4032B3B9398
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 16:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhGAOzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 10:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbhGAOzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 10:55:38 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C787C061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 07:53:07 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id t24-20020a9d7f980000b029046f4a1a5ec4so6797242otp.1
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 07:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5EFDBeL4wmuZzEbs7W+rIl4VyjBJBLY3vyT7h6elrGA=;
        b=vV25TS8DGjTcLhoaG8JoSVRTN137gfLNlZwE6Q4PMet7uinfsLarQeqamk5xjmNLrh
         cTR7RTrlksJg+LwmIePOuAHbuEv/z2xx8+uHUX0jEdGxHg1H3ycgdcEeLVWj7p/JF06i
         ZxbbESPoOqDKqPjLul4K1iiCCOYUVM1r0xlFoae6ujZqLzzyq0HiIFOqxrBw+i6HWVlX
         5VP0div0jR4WLPf7Vnq8Pmy/HHs1TG7E7eEtikRNETJq44JHSa3CLcnOaIdYBk35lvWQ
         Y1GU2i/WF1zz+Is7N4CCjH9u1R0QAAjljxQl9D1dFcEy9byfiLPoYIxn+9rp1BLklEjA
         Sm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5EFDBeL4wmuZzEbs7W+rIl4VyjBJBLY3vyT7h6elrGA=;
        b=b8rXAWlF9/KSJzaqR8Jcc5VHjjRRGfqdOHYoJxg6ZPRPCw/S6tjohFAgGacI6yq6eS
         oWWvKTAXC1B86WgZt90HztJD8Toxzmf6ks8kppkHKPQesEwbnko+xVgMdVSNC1SzPyw4
         0W8p1ax/W2HtD870uicRuiJdHZrs3SfsBQFx8sfkRdHVMTmVznzOvASIOPA8EGZkVwnw
         fZ4Cje80NoeweczAPXkUVV6uJduhL2rPUgxgm8xYcTrJdfBje/yeC0sgfbJ91Np19lHg
         9EPO41FchWEIP7Op2VJF0xNid0WJqAMGILXDAAFkPcYN3XWzS79xq99is74xaV8yWrnS
         ZZ4A==
X-Gm-Message-State: AOAM531L38Pewynbr6FQeCs++Y6H50Latukss/x8zmKbathYaUgnDjdp
        3+/eJIT8MBjHs75JfspvaHs2/cESwKejYKnC+fIJ5w==
X-Google-Smtp-Source: ABdhPJyWv/g4Ufw9xByzk3S6K4RbKA13wD+M2R4G/yMkrndH3boaDzw5iojn1U42XqhCK2L7/zSG9LMBVCOlJuZFVHw=
X-Received: by 2002:a9d:17c5:: with SMTP id j63mr354113otj.52.1625151186279;
 Thu, 01 Jul 2021 07:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com> <20210615133950.693489-8-tabba@google.com>
 <20210701133311.GG9757@willie-the-truck>
In-Reply-To: <20210701133311.GG9757@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 1 Jul 2021 15:52:30 +0100
Message-ID: <CA+EHjTzssPziK9Vj3i7iUN5jtf=dRJdm+QoKJR7RTFzfbwB2Wg@mail.gmail.com>
Subject: Re: [PATCH v2 07/13] KVM: arm64: Add config register bit definitions
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

On Thu, Jul 1, 2021 at 2:33 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:44PM +0100, Fuad Tabba wrote:
> > Add hardware configuration register bit definitions for HCR_EL2
> > and MDCR_EL2. Future patches toggle these hyp configuration
> > register bits to trap on certain accesses.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index bee1ba6773fb..a78090071f1f 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -12,7 +12,11 @@
> >  #include <asm/types.h>
> >
> >  /* Hyp Configuration Register (HCR) bits */
> > +#define HCR_TID5     (UL(1) << 58)
> > +#define HCR_DCT              (UL(1) << 57)
> >  #define HCR_ATA              (UL(1) << 56)
> > +#define HCR_AMVOFFEN (UL(1) << 51)
> > +#define HCR_FIEN     (UL(1) << 47)
> >  #define HCR_FWB              (UL(1) << 46)
> >  #define HCR_API              (UL(1) << 41)
> >  #define HCR_APK              (UL(1) << 40)
> > @@ -55,6 +59,7 @@
> >  #define HCR_PTW              (UL(1) << 2)
> >  #define HCR_SWIO     (UL(1) << 1)
> >  #define HCR_VM               (UL(1) << 0)
> > +#define HCR_RES0     ((UL(1) << 48) | (UL(1) << 39))
> >
> >  /*
> >   * The bits we set in HCR:
> > @@ -276,11 +281,21 @@
> >  #define CPTR_EL2_TZ  (1 << 8)
> >  #define CPTR_NVHE_EL2_RES1   0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
> >  #define CPTR_EL2_DEFAULT     CPTR_NVHE_EL2_RES1
> > +#define CPTR_NVHE_EL2_RES0   (GENMASK_ULL(63, 32) |  \
> > +                              GENMASK_ULL(29, 21) |  \
> > +                              GENMASK_ULL(19, 14) |  \
> > +                              (UL(1) << 11))
> >
> >  /* Hyp Debug Configuration Register bits */
> >  #define MDCR_EL2_E2TB_MASK   (UL(0x3))
> >  #define MDCR_EL2_E2TB_SHIFT  (UL(24))
> > +#define MDCR_EL2_HPMFZS              (UL(1) << 36)
> > +#define MDCR_EL2_HPMFZO              (UL(1) << 29)
> > +#define MDCR_EL2_MTPME               (UL(1) << 28)
> > +#define MDCR_EL2_TDCC                (UL(1) << 27)
> > +#define MDCR_EL2_HCCD                (UL(1) << 23)
> >  #define MDCR_EL2_TTRF                (UL(1) << 19)
> > +#define MDCR_EL2_HPMD                (UL(1) << 17)
> >  #define MDCR_EL2_TPMS                (UL(1) << 14)
> >  #define MDCR_EL2_E2PB_MASK   (UL(0x3))
> >  #define MDCR_EL2_E2PB_SHIFT  (UL(12))
> > @@ -292,6 +307,12 @@
> >  #define MDCR_EL2_TPM         (UL(1) << 6)
> >  #define MDCR_EL2_TPMCR               (UL(1) << 5)
> >  #define MDCR_EL2_HPMN_MASK   (UL(0x1F))
> > +#define MDCR_EL2_RES0                (GENMASK_ULL(63, 37) |  \
> > +                              GENMASK_ULL(35, 30) |  \
> > +                              GENMASK_ULL(25, 24) |  \
> > +                              GENMASK_ULL(22, 20) |  \
> > +                              (UL(1) << 18) |        \
> > +                              GENMASK_ULL(16, 15))
>
> There's an inconsistent mix of ULL and UL here. Given we're on arm64,
> maybe just use GENMASK() and BIT() for these RES0 regions?

The reason I use GENMASK_ULL instead of GENMASK, and UL()<< instead of
BIT is to remain consistent with the rest of this file. It would
definitely be clearer here, as you point out. I'll fix it.

> Anyway, the bit positions all look fine. You're missing HLP in bit 26,
> but I guess that's not something you care about?

I don't need that bit. I could add it for completeness, but there are
a few others that aren't here either...

Cheers,
/fuad

> Will

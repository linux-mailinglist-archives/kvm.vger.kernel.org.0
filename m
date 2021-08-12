Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C69D3EA1E4
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbhHLJWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbhHLJWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 05:22:03 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A039C061765
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 02:21:38 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id r19-20020a0568301353b029050aa53c3801so6979596otq.2
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 02:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqzxZhoC6kB4bLqUJZe+JW0zSkiAmZThOjct2YoGtrk=;
        b=HPoN/8bJTBl1bSRYawtOqmugOiQTAvVhXUHh6kp8Vc90cfe2sFGjNYQyh+wXLozBgi
         DreDQP+SZUsq8hMCS8djvnOF7zWa99ckV+3qldfFeMtZ4ekgCKE9xWDY/85H8vxuWm+i
         iH7HeXkXYYHmpn6EGDL0o5a1yee2SMWYJ0ZF3i/gpzmWLcW9LdT2h8sUbwrqdu12WOR2
         g48Ly1Ixzv5qlzZSKRt/b4FJlYnXgz8C5Woe3MOeg6P1iIhR2+/MYxGQOMSr4U0S6J8c
         2L9ztLQfPKfLJJenp+v5pjgLwQWUP7b3CQPnn+r3i3HswSkZ27zLWWEsO4ZYuNtBV80a
         yldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqzxZhoC6kB4bLqUJZe+JW0zSkiAmZThOjct2YoGtrk=;
        b=MSuhK2i1zBuDkkLushJSzLVMwtniuXxI4ogSNnnF2adhf+kOyRn5T1It5ZZjVXSEIP
         7LxT+6/ETlv6XMesbqtcNbIdIC4jZSiOKIS7BUiOKsVPdH2E4JAopliWqnR1Q5rHokDZ
         T9KYG3c0HumqmioS069fJM4VVLi5m0QsWGtwat86C8KlKjvulf2ajnNqGXKTRoh5rfxd
         KWU4EpgVvr46Rfdu2yv7R9u6Gqjw9y02LCmLmPDhVh3wyg1L+jvzRQg3aT9hcOKtY0QX
         Kxoso1djqIOwyCFDHhgW2vj4kkULHBQsEYT3yW3/lSGvvH3a9fXHLWsET/46rXe1joa1
         sF8g==
X-Gm-Message-State: AOAM531V2EcjVo1bDvS3NjuruMiKSHlPdb73stRC+sWotGIz74Tr8McN
        w8yDL1+7i3ujaICwNAxCU1pOIN3hRXFHQs5d9BD2FQ==
X-Google-Smtp-Source: ABdhPJxi+S+EtgmGj3lxGi+NQp6K5VuA3LSkvVkLCD2i5Jd7cCNEoUuyhCMTn3mxudarNoNz+ZV9n0INWXwGyVVrJpE=
X-Received: by 2002:a9d:2609:: with SMTP id a9mr2679662otb.365.1628760097655;
 Thu, 12 Aug 2021 02:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-9-tabba@google.com>
 <20210812085939.GF5912@willie-the-truck>
In-Reply-To: <20210812085939.GF5912@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 12 Aug 2021 11:21:01 +0200
Message-ID: <CA+EHjTyXtVXEU7FMq53rmrgWuiikPzNnWJ7cj4EJkR5FCgj6Sg@mail.gmail.com>
Subject: Re: [PATCH v3 08/15] KVM: arm64: Add feature register flag definitions
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

On Thu, Aug 12, 2021 at 10:59 AM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:39PM +0100, Fuad Tabba wrote:
> > Add feature register flag definitions to clarify which features
> > might be supported.
> >
> > Consolidate the various ID_AA64PFR0_ELx flags for all ELs.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |  4 ++--
> >  arch/arm64/include/asm/sysreg.h     | 12 ++++++++----
> >  arch/arm64/kernel/cpufeature.c      |  8 ++++----
> >  3 files changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index 9bb9d11750d7..b7d9bb17908d 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -602,14 +602,14 @@ static inline bool id_aa64pfr0_32bit_el1(u64 pfr0)
> >  {
> >       u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_SHIFT);
> >
> > -     return val == ID_AA64PFR0_EL1_32BIT_64BIT;
> > +     return val == ID_AA64PFR0_ELx_32BIT_64BIT;
> >  }
> >
> >  static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
> >  {
> >       u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL0_SHIFT);
> >
> > -     return val == ID_AA64PFR0_EL0_32BIT_64BIT;
> > +     return val == ID_AA64PFR0_ELx_32BIT_64BIT;
> >  }
> >
> >  static inline bool id_aa64pfr0_sve(u64 pfr0)
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 326f49e7bd42..0b773037251c 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -784,14 +784,13 @@
> >  #define ID_AA64PFR0_AMU                      0x1
> >  #define ID_AA64PFR0_SVE                      0x1
> >  #define ID_AA64PFR0_RAS_V1           0x1
> > +#define ID_AA64PFR0_RAS_ANY          0xf
>
> This doesn't correspond to an architectural definition afaict: the manual
> says that any values other than 0, 1 or 2 are "reserved" so we should avoid
> defining our own definitions here.

I'll add a ID_AA64PFR0_RAS_V2 definition in that case and use it for
the checking later. That would achieve the same goal and I wouldn't be
adding definitions to the reserved area.

Cheers,
/fuad

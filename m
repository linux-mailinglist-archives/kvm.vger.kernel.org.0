Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926089CED6
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 14:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbfHZMAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 08:00:15 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:40300 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbfHZMAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 08:00:15 -0400
Received: by mail-oi1-f174.google.com with SMTP id h21so11862579oie.7
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SdfQ2/ZiXA4SobFkMH75D5kQJweG7eEDOUjmz6EtaQw=;
        b=C3CIXYqgt/x1iuJpoA5Lc5ckpFWRGFrU1aJfpYupHRh6f4CjaFi8Rpj32tmfteZZg3
         J1icu/Ng3guq1UjfOQ5frV+kwOApx8tvymyNMH14DzgKLrRvUjl7mnhBX40tBnKPfkSj
         7RcdVmOXb+VbZS6wW0417B6B/GLheBjtz6RszI1lCzUWWGgL73egpSqNrYOx8mnVrJWD
         LnvRERiNMJPYwo0y5G8pCtQGVS2QdbraOLjvjz9nj2rG37gOOeO3of+81MYiYsMIEajH
         8udVuZKBCl5g84SHHZ28Dxe6g4GVOknpYYx4CqAIFRj7E7izVDiNwNgAMNhs811q7gUM
         wgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SdfQ2/ZiXA4SobFkMH75D5kQJweG7eEDOUjmz6EtaQw=;
        b=HTn/MB80M6FVpFdPwqswwODSrhHfq00UmUmwGMAz9D70MKRhxgOvKG2enHxccb8WSb
         L5/huoyXK+fW1fBKrLVcqiXRvUcX1dy8jHYvp89fiWR73DUicJqVu40vB1QlNXs1HUvn
         woKtJX99H3HPkgvDNpL6wr6wzk6QuyMHRVyimtl1oYTRZ5wr4yKi8l3SXOp/jqVVFtUf
         5zFIpFkBuwcEgPwiAIdCPkrel+DPcPuZVGJNwedoAGXcxZe95GfGFUStk527Y+GU4yI6
         NqfYrZ54VjoP8FXMANgKif0Kt5NPR4LGsJL0tNmKCl+qxGnp0sGCIKabJR6vGd3DXXs9
         pSlQ==
X-Gm-Message-State: APjAAAVOoaUTaa8qgVWkSjOnockltmjn+qklAso0GiiMrkhoKEZvsZb3
        FzawG/zJJAmhBjStMK9t84L9fTpbenI5IWiZgSLSFg==
X-Google-Smtp-Source: APXvYqwLked0T5pqTrSBL7PmdICrZaA/CS6ycR/k0FpWc871ogXXJKjUSOPrHE9nXYjPm34iAtYF+Xe96bO/Y7f8cDw=
X-Received: by 2002:aca:4814:: with SMTP id v20mr12134850oia.98.1566820814025;
 Mon, 26 Aug 2019 05:00:14 -0700 (PDT)
MIME-Version: 1.0
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de> <20190629234232.484ca3c0@why>
 <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de> <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
 <20190826083806.GA12352@e113682-lin.lund.arm.com>
In-Reply-To: <20190826083806.GA12352@e113682-lin.lund.arm.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 26 Aug 2019 13:00:02 +0100
Message-ID: <CAFEAcA-eshVRaAMpdNkjbBXtiwHpkjVgUbnH5mkoXqTCkFD-FA@mail.gmail.com>
Subject: Re: KVM works on RPi4
To:     Christoffer Dall <christoffer.dall@arm.com>
Cc:     Jan Kiszka <jan.kiszka@web.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Aug 2019 at 09:38, Christoffer Dall <christoffer.dall@arm.com> wrote:
> On Sun, Jun 30, 2019 at 12:18:59PM +0200, Jan Kiszka wrote:
> > Hmm, looking at what KVM_ARM_TARGET_CORTEX_A7 and ..._A15 differentiates, I
> > found nothing so far:
> >
> > kvm_reset_vcpu:
> >         switch (vcpu->arch.target) {
> >         case KVM_ARM_TARGET_CORTEX_A7:
> >         case KVM_ARM_TARGET_CORTEX_A15:
> >                 reset_regs = &cortexa_regs_reset;
> >                 vcpu->arch.midr = read_cpuid_id();
> >                 break;
> >
> > And arch/arm/kvm/coproc_a15.c looks like a copy of coproc_a7.c, just with some
> > symbols renamed.
> >
> > What's the purpose of all that? Planned for something bigger but never
> > implemented? From that perspective, there seems to be no need to arch.target and
> > kvm_coproc_target_table at all.
> >
>
> There was some speculation involved here, and we needed to figure out
> how we would deal with implementation defined behavior, so we built this
> support for each type of CPU etc.
>
> In reality, most CPUs that we support are pretty similar and that's why
> we did the generic CPU type instead.  In practice, there might be a more
> light-weight appraoch to handling the minor differences between CPU
> implementations than what we have here.

The other future-direction I think we were thinking about was that
one day we'd want to support showing the guest a CPU other than
what the host is, at which point you would want to be able to
say specifically "give me a Cortex-A7" and have it work even if the
host was a Cortex-A15. But there are significant unresolved design
issues if we ever did want to go in that direction...

thanks
-- PMM

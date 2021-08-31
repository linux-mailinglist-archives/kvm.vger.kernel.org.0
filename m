Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AAA3FCDF3
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 22:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbhHaTi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 15:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbhHaTi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 15:38:27 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB49C061575
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 12:37:31 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g22so121661edy.12
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 12:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FH3ZSlU/Z8INGao+rLxahfTcyU/GCSs62/WclADOsck=;
        b=h511RekG+mtG6gnhDDBvcE0Tf6T9i3qFFBMD4PxXGNAH/dj4WOPL94T+m1W4oeWv9Q
         UcoyPUzDOibyNxEi/eDHjdaX1/4bJc7NFxWzRRY/APeQgG1BADIE6jKOOFoBdmQWFp8Z
         OPW2hzsjRkDG1BoYFgagMZZCs4Oa0chhCx+wEY+T40M8eZu1/J11Vlls5leiKk0KFsxF
         1WrN8JZcKSx0n/PyBb2H4XdD/2hBMn+dEPmznhZvAoN2MDBcU8lOaanX40toxQChvfT6
         fYIuq8Xbf2dCGMuIKF8Gqh5/CLMiw+wrL7Z/JxFG3C1ezzgEfy/qfTwmR+qix4UkUJFT
         LiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FH3ZSlU/Z8INGao+rLxahfTcyU/GCSs62/WclADOsck=;
        b=ntFuhx8eUB6u/DdFBN//I+r5CBO0Hd8ZSfnKUkrezQdxhBfXPEyktCoIIC1d9r566x
         p59FKDVR66RO3p5X1h7eUSGG4pXChBJrwB8hKFTVOowYitmXExR+vMWIS2KcBXBCUjjT
         GCM+Kni3SXbOmeNHab8P4Izx56YyHILxkQFYhWj+fW2tOOiWk06Ap8X/C6Cfar62PVLp
         nDMiDILJiMMmDICe29t2fcQdhq8p6h8AepLlHUPD7WskqYINk+GyKm363Z1Q2fGAVta7
         08qOsvfXBlccHs8CmCsQEFr4SIoBVcuDV3pi7PYedXe8lN0Qa5ynL00ERYFxu554p+ff
         otEg==
X-Gm-Message-State: AOAM532YHeNDD+bSZ/VHitq5s23TP7TkvOvPGuXqPQPG2+rRbRfPM9un
        JJCZIgHH06l7ozf9jDyCgo4W+IX3NJIQY7/yGLN+mg==
X-Google-Smtp-Source: ABdhPJztlU5ubKWYvgGEcZRN5s+a0YhzDIb34/VL84Go/WnjGbh30VCwdOD0+0QMVjorN+PJUBqbw0nHLCP5Aa1pG+w=
X-Received: by 2002:a50:9b52:: with SMTP id a18mr30980489edj.165.1630438650059;
 Tue, 31 Aug 2021 12:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-12-zixuanwang@google.com> <22303b79-1074-91ea-6af4-e3d5f4c5bcbb@amd.com>
In-Reply-To: <22303b79-1074-91ea-6af4-e3d5f4c5bcbb@amd.com>
From:   Zixuan Wang <zixuanwang@google.com>
Date:   Tue, 31 Aug 2021 12:36:54 -0700
Message-ID: <CAFVYft2GXA-NSj3t2AChfvogvJfR6SD4RMHehXyw+9bGOcKRxw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 11/17] x86 AMD SEV: Initial support
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 7:51 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 8/26/21 10:12 PM, Zixuan Wang wrote:
> > +++ b/lib/x86/amd_sev.c
> > @@ -0,0 +1,77 @@
> > +/*
> > + * AMD SEV support in KVM-Unit-Tests
> > + *
> > + * Copyright (c) 2021, Google Inc
> > + *
> > + * Authors:
> > + *   Zixuan Wang <zixuanwang@google.com>
> > + *
> > + * SPDX-License-Identifier: LGPL-2.0-or-later
> > + */
> > +
> > +#include "amd_sev.h"
> > +#include "x86/processor.h"
> > +
> > +static unsigned long long amd_sev_c_bit_pos;
>
> This can be a unsigned short since this is just the bit position, not the
> mask.
>

I agree. I will update it in the next version.

> > +
> > +bool amd_sev_enabled(void)
> > +{
> > +     struct cpuid cpuid_out;
> > +     static bool sev_enabled;
> > +     static bool initialized = false;
> > +
> > +     /* Check CPUID and MSR for SEV status and store it for future function calls. */
> > +     if (!initialized) {
> > +             sev_enabled = false;
> > +             initialized = true;
> > +
> > +             /* Test if we can query SEV features */
> > +             cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
> > +             if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
> > +                     return sev_enabled;
> > +             }
> > +
> > +             /* Test if SEV is supported */
> > +             cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
> > +             if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
> > +                     return sev_enabled;
> > +             }
> > +
> > +             /* Test if SEV is enabled */
> > +             if (!(rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK)) {
> > +                     return sev_enabled;
> > +             }
> > +
> > +             sev_enabled = true;
>
> Maybe just make this a bit easier to read by doing:
>
>                 if (rdmsr(MSR_SEV_STATUS & SEV_ENABLED_MASK)
>                         sev_enabled = true;
>
> No need to return early since you are at the end of the if statement. Just
> my opinion, though, not a big deal.
>
> Thanks,
> Tom
>

I agree, I will update it in the next version. Thank you for the comments!

Best regards,
Zixuan

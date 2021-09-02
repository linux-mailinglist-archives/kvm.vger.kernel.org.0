Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF663FF2E1
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 19:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346635AbhIBR4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 13:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbhIBR4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 13:56:18 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73C9C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 10:55:19 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id v26so5441736ybd.9
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 10:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gqxRE7kir7W0L8sbl3qxABrwWx/ImNi+hvYh+LGW41A=;
        b=cv9zdd1oi04eIr1gf7nRpzyMmnd2MFSg9K1LzVavTuRHOmcg94Y/OCdNFhlu8mz9xI
         oKwwTN71H2su8FeDC+5CjPNWW2dx1NeBB9PbWwtccN50LjfaiAYpRGr0Ktf0ocOj7pEc
         affqCVcuKVaXYBJZjI3dCdsWOzLl3UrUXHbrsmA3LZZ3W/ofMk0Fr8JJhlUL9286/lnE
         XGyK3RURH0w0A4PQaU5s8EqiyDQ9sOy9CTYyYXy5LIIaa5qXylR2Df1Ac854OuYRjUvh
         PoyzOpVUq7CiEfefE0vfqTjSVfZBzMW6vJinsJ9Og1Nw/ERoRneAoNly1w5levpfnQOu
         J1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gqxRE7kir7W0L8sbl3qxABrwWx/ImNi+hvYh+LGW41A=;
        b=HUl1obAbZXXifsr/LF8bqV7xy5XxBWAbarLorT/ByfoXflYboQiw5Dnr4DZl6ad0iB
         Ca7pjglVMzl1BmaHVmfgIM4P+oG6O8QC12xLJUtq3ABEwgC1kuK3BXxj6dXWXoDmFGSb
         W8fXE7W1XZM6pUVyMcY6f4t1sJhUYa+skPw4Hct6JA+J9S7n+etL/4lngIHQIWTJSGCU
         qeKOO70nIY300qS2i+yTosL4NvMcmaZxtF+t09dtpzau+FLetYXNo5vLiiSFpO5PvN1g
         kmdwOCgXTxXph8fsj00lFBMEpS/mDcGtq1qnitSAMBgjISdN+lYBgDV8X3Rf1EJRLujb
         n6hg==
X-Gm-Message-State: AOAM532Rs4yJNsWNJjvl5au997Ej4LMX8A12CZPWdhA+THxe5tebojCo
        0pE76m3zahudN61x9eXlGJEjdfumzYUxzlEespMrHQ==
X-Google-Smtp-Source: ABdhPJwUZwqrwOekpIYyTz0pzYA+LEPg2QXTbJ63dba3PQAQ8pp85mpwvFE+9uO8Y0Cnfe82N+/p5oaHg8isCinoM0E=
X-Received: by 2002:a05:6902:513:: with SMTP id x19mr5997339ybs.90.1630605318839;
 Thu, 02 Sep 2021 10:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com> <20210901211412.4171835-3-rananta@google.com>
 <YS/wfBTnCJWn05Kn@google.com> <YS/53N7LdJOgdzNu@google.com>
 <CAJHc60xU3XvmkBHoB8ihyjy6k4RJ9dhqt31ytHDGjd5xsaJjFA@mail.gmail.com>
 <YTAHYrQslkY12715@google.com> <20210902123110.royrzw4dsykkrcjx@gator>
In-Reply-To: <20210902123110.royrzw4dsykkrcjx@gator>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 2 Sep 2021 10:55:08 -0700
Message-ID: <CAJHc60xLj77n3pvqQNn_+LoLL=UZtQV+hz3r4VmPpqpZ7SBPVg@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
To:     Andrew Jones <drjones@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 2, 2021 at 5:31 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 11:06:10PM +0000, Oliver Upton wrote:
> > On Wed, Sep 01, 2021 at 03:48:40PM -0700, Raghavendra Rao Ananta wrote:
> > > On Wed, Sep 1, 2021 at 3:08 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > On Wed, Sep 01, 2021 at 09:28:28PM +0000, Oliver Upton wrote:
> > > > > On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> > > > > > For register names that are unsupported by the assembler or the ones
> > > > > > without architectural names, add the macros write_sysreg_s and
> > > > > > read_sysreg_s to support them.
> > > > > >
> > > > > > The functionality is derived from kvm-unit-tests and kernel's
> > > > > > arch/arm64/include/asm/sysreg.h.
> > > > > >
> > > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > >
> > > > > Would it be possible to just include <asm/sysreg.h>? See
> > > > > tools/arch/arm64/include/asm/sysreg.h
> > > >
> > > > Geez, sorry for the noise. I mistakenly searched from the root of my
> > > > repository, not the tools/ directory.
> > > >
> > > No worries :)
> > >
> > > > In any case, you could perhaps just drop the kernel header there just to
> > > > use the exact same source for kernel and selftest.
> > > >
> > > You mean just copy/paste the entire header? There's a lot of stuff in
> > > there which we
> > > don't need it (yet).
> >
> > Right. It's mostly register definitions, which I don't think is too high
> > of an overhead. Don't know where others stand, but I would prefer a
> > header that is equivalent between kernel & selftests over a concise
> > header.
> >
>
> Until now we haven't needed the sys_reg(...) type of definitions for
> sysregs in selftests. In case we did, we defined the registers we
> needed for get/set_one_reg by their parts, e.g.
>
>  #define ID_AA64DFR0_EL1 3, 0,  0, 5, 0
>
> allowing us to choose how we use them, ARM64_SYS_REG(...) vs.
> sys_reg(...).
>
> Bringing over sysreg.h is probably a good idea though. If we do, then
> I'd suggest we define a new macro that allows us to convert a SYS_*
> register definition from sysreg.h into an ARM64_SYS_REG definition
> for get/set_one_reg in order to avoid redundant definitions.
>

I agree. Will look into it, and plan to pull the original sysreg.h
into selftests.

Regards,
Raghavendra

> Thanks,
> drew
>

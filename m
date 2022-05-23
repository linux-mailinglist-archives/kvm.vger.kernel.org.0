Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DBD5312D4
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238294AbiEWQEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 12:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbiEWQER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 12:04:17 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E710962216
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:04:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a13so2992182plh.6
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jhSo+evTyBN+5x5Ja23QHpmtg9xuVErXLEhQ2yGFZ1w=;
        b=EfHv5eDzephBQ/fnioZ8xttfvuDMWnkf46VvKVHmAjFv3/aYle7zk8t7NVn/+7Ae6F
         1Z++54NjRHBRhWSx5xlifaWxLUwNPdp9i9kdsP9cahOVYLFx9w3zzHk6l6KoHvGgGifS
         aX5AxrLDRUM+lc1woLxrD2iRiMigYXbLsu6JYOgoOBdEo9rud3u0c1mzSdrNp5BUbkVc
         ifjit3gAtBuQ/ZhaldPyye1Z5uT5FIc1GA36AihmfpLJYO10n7rlwJ2N6yP2D/B07cQN
         AAw4h82f96n/68UOTLQ89f2ZfjDIZj6toKY4cqMjzkCFlXvQU+QmOoKpfN7bGptkd5Jm
         jvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jhSo+evTyBN+5x5Ja23QHpmtg9xuVErXLEhQ2yGFZ1w=;
        b=L3Q7lm4fvYgVKUxSjPZpe6X2f6roWNYdk/Gmt2NEeHVL2Fw6bQLaighbXPhW9XA90k
         hgFe8Mf7sjFCOjWwGlNn7IbACup5D/TQ8REHzSRncqRJwwLFTf7B95/RVtzEEquXKE0W
         7+53sVj6PCj+BfnE6rC2zknyx+vdf9RzpZwsvEXl7NggxJEEZJ2e4MfaOr+dn+71fIpp
         Og6HOz2v2TLtlrzYNdj6d99ygwULe9vjAoaO4jE+SOnlHKDGJ7wiJZKKJleziHarZ4nU
         aTFBMwtpHbLsOYFWvM+rWosQaN/471W/HL4cxqkXckkgkTG/Dmh6fZ/4lBo9NYXqqbw4
         Wxzg==
X-Gm-Message-State: AOAM532Nb6c3uv5st4FwYJtF6Q9UkRDmDTQyn8aWThWeHaJcDheE1+UF
        m2Y0R8dtfqqbj9lAeregghW6+rPZWbgyit2RplcSJQ==
X-Google-Smtp-Source: ABdhPJzwHc8W7czuXwrozEV0q7U1DaTIOt3SqCa/77tDCA4iQYAUyzkQaxVNYlr7yG3Qr1SNgck4S/1b6VlxyhUNVaQ=
X-Received: by 2002:a17:903:192:b0:162:23b5:d207 with SMTP id
 z18-20020a170903019200b0016223b5d207mr5905022plg.87.1653321855377; Mon, 23
 May 2022 09:04:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220520180946.104214-1-daolu@rivosinc.com> <YotUdkD2LIKqhYKq@monolith.localdoman>
 <YotVCkpajnskhQm9@monolith.localdoman>
In-Reply-To: <YotVCkpajnskhQm9@monolith.localdoman>
From:   Dao Lu <daolu@rivosinc.com>
Date:   Mon, 23 May 2022 09:04:04 -0700
Message-ID: <CAKh7v-Rm3Mtid7KymrbSwwVRoC=S1J0f4CSCbpHXmi1SA45omA@mail.gmail.com>
Subject: Re: [PATCH kvmtool] Fixes: 0febaae00bb6 ("Add asm/kernel.h for riscv")
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

Thanks for pointing that out - I wasn't sure where the number came
from so I basically copied from the arm one just so the compilation
can pass.

I am happy to fix up the number to 32 and add the compile error
message to the commit message like you said - would something like
this work?
-------
Fixes the following compilation issue:

include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file
or directory
    5 | #include "asm/kernel.h"
-------
Thanks,
Dao

On Mon, May 23, 2022 at 2:33 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Adding the kvmtool maintainers, I just noticed that they were missing.
>
> On Mon, May 23, 2022 at 10:31:34AM +0100, Alexandru Elisei wrote:
> > Hi,
> >
> > When I started working on the heterogeneous PMU series, support for the
> > riscv architecture wasn't merged in kvmtool, and after riscv was merged I
> > missed adding the header file.
> >
> > This indeed fixes this compilation error:
> >
> > In file included from include/linux/rbtree.h:32,
> >                  from include/kvm/devices.h:4,
> >                  from include/kvm/pci.h:10,
> >                  from include/kvm/vfio.h:6,
> >                  from include/kvm/kvm-config.h:5,
> >                  from include/kvm/kvm.h:6:
> > include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file or directory
> >     5 | #include "asm/kernel.h"
> >       |          ^~~~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> > compilation terminated.
> > make: *** [Makefile:484: builtin-balloon.o] Error 1
> >
> > Would be nice to include it in the commit message, so people googling for
> > that exact error message can come across this commit.
> >
> > On Fri, May 20, 2022 at 11:09:46AM -0700, Dao Lu wrote:
> > > Signed-off-by: Dao Lu <daolu@rivosinc.com>
> > > ---
> > >  riscv/include/asm/kernel.h | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >  create mode 100644 riscv/include/asm/kernel.h
> > >
> > > diff --git a/riscv/include/asm/kernel.h b/riscv/include/asm/kernel.h
> > > new file mode 100644
> > > index 0000000..a2a8d9e
> > > --- /dev/null
> > > +++ b/riscv/include/asm/kernel.h
> > > @@ -0,0 +1,8 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +
> > > +#ifndef __ASM_KERNEL_H
> > > +#define __ASM_KERNEL_H
> > > +
> > > +#define NR_CPUS    4096
> >
> > In arch/riscv/Kconfig I see this:
> >
> > config NR_CPUS
> >       int "Maximum number of CPUs (2-32)"
> >       range 2 32
> >       depends on SMP
> >       default "8"
> >
> > Would you mind explaining where the 4096 number of CPUs comes from?
> >
> > Thanks,
> > Alex
> >
> > > +
> > > +#endif /* __ASM_KERNEL_H */
> > > --
> > > 2.36.0
> > >

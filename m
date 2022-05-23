Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AA2531678
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiEWTdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiEWTci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:32:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFD9E97
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:16:07 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so134827pjb.2
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=guOycbK5/EyRijM0ulwOqat9Oy7FIS9ZI2dZi62v/vs=;
        b=RHm3uPKynTcMEh4y4WPUguw8GV9bETy8PME+jXAQ3Pw7JwXTFsDdw1ud+6hB8xInU/
         6HUW8Lflph39tRBkjIkEK2HiZbflKGCqnZBnJ7ajL6LxtDbNJv7gJl13kkAHlnXG4chN
         5sVtzVRP2RmaQqCLLE6MIMPWd1KKobB7QHNsQbR/3FqNg/qYta7mZh7KTySe+lVgF/JX
         K2+77WRcOgnJrFTG1LL5Jz690KUry7nfwD31Gh8d2vyxv9w/x0Or+vs4Lmig+yHfsjyM
         nKQQ8REwS/R62SYfpPmAUobQzFI+dqMkofURfDlXctmWveFKZZYfQoAeRHTl544uWVqo
         euQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=guOycbK5/EyRijM0ulwOqat9Oy7FIS9ZI2dZi62v/vs=;
        b=w2JGG5f0WfmN+qGMqOOqLl5SaOwqz5DE/T9qEExL8hnzjWVT/X487qadycDboPEh0I
         dGOVl1nBhuKg2RTBuJBoGHF/LH8b0GRjCbPBmcqbtBA+RMREBXng02VOk1tlT/LkA6bf
         QO3MlMkhp5sisQ3LM2mgUFJMZdqITA9rQoLHIsIYrmHics3CGg6/tYiylHIGkws7bmAM
         1RK0IqCCEaK76iurIpPxSqRD04kI5ZcHhW7IOp5KAMAIbIQu/Qg/MIhKa/iRUJVOSq6x
         etw34/5BBgsjWPfrIH0Obv/0ie7oiSVPR1wxyDLfMdivQ9urJtcJQ5HZutwlosyM31QU
         DmYg==
X-Gm-Message-State: AOAM531DyN/Ig73kmn0OaWVAzJ7SnAc2/w1EqJloe1wFWyfL+G19c+t0
        2FhxBY0bgGoyZwt0I1VxE0/ZX8x3UOzE9K+k/rjtrnyfGjvaeQ==
X-Google-Smtp-Source: ABdhPJziLgGj5VfFstC/x/4r1OZxKVgz7eTKv/Akwjrsv5JDrl6ztM8krTiMjVO6Y5pHBV/MMJ2jni/EzKrB5W+53bw=
X-Received: by 2002:a17:90b:1bd1:b0:1df:b6eb:2b20 with SMTP id
 oa17-20020a17090b1bd100b001dfb6eb2b20mr468757pjb.221.1653333366595; Mon, 23
 May 2022 12:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220520180946.104214-1-daolu@rivosinc.com> <YotUdkD2LIKqhYKq@monolith.localdoman>
 <YotVCkpajnskhQm9@monolith.localdoman> <CAKh7v-Rm3Mtid7KymrbSwwVRoC=S1J0f4CSCbpHXmi1SA45omA@mail.gmail.com>
 <You2EZ0xBWD29suJ@monolith.localdoman>
In-Reply-To: <You2EZ0xBWD29suJ@monolith.localdoman>
From:   Dao Lu <daolu@rivosinc.com>
Date:   Mon, 23 May 2022 12:15:55 -0700
Message-ID: <CAKh7v-Rnbs1uOGcDrB6a3+MFKbZX1_-4tgWJH-EKp_Wxd76D=Q@mail.gmail.com>
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

After talking with my colleague I have some additional questions about
what number we want to put there, as of now there is already a patch
that will increase the range in Kconfig to 2-512:

https://lore.kernel.org/lkml/CAOnJCUJrN4frY_OdQzO-yr5CrDLvj=ge9KY2d=XnGvAF-uQNvQ@mail.gmail.com/T/

It seems like a moving target and as riscv develops we kinda expect
this number will grow further. Do you think it is ok for me to at
least set it to 512, if not 4096 at this time?

Thanks,
Dao

On Mon, May 23, 2022 at 9:27 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Mon, May 23, 2022 at 09:04:04AM -0700, Dao Lu wrote:
> > Hi Alex,
> >
> > Thanks for pointing that out - I wasn't sure where the number came
> > from so I basically copied from the arm one just so the compilation
> > can pass.
>
> I see, I was worried that I was looking in the wrong place.
>
> >
> > I am happy to fix up the number to 32 and add the compile error
> > message to the commit message like you said - would something like
> > this work?
> > -------
> > Fixes the following compilation issue:
> >
> > include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file
> > or directory
> >     5 | #include "asm/kernel.h"
> > -------
>
> Sounds good, thanks:
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
> With the error message added:
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
> Thanks,
> Alex
>
> > Thanks,
> > Dao
> >
> > On Mon, May 23, 2022 at 2:33 AM Alexandru Elisei
> > <alexandru.elisei@arm.com> wrote:
> > >
> > > Adding the kvmtool maintainers, I just noticed that they were missing.
> > >
> > > On Mon, May 23, 2022 at 10:31:34AM +0100, Alexandru Elisei wrote:
> > > > Hi,
> > > >
> > > > When I started working on the heterogeneous PMU series, support for the
> > > > riscv architecture wasn't merged in kvmtool, and after riscv was merged I
> > > > missed adding the header file.
> > > >
> > > > This indeed fixes this compilation error:
> > > >
> > > > In file included from include/linux/rbtree.h:32,
> > > >                  from include/kvm/devices.h:4,
> > > >                  from include/kvm/pci.h:10,
> > > >                  from include/kvm/vfio.h:6,
> > > >                  from include/kvm/kvm-config.h:5,
> > > >                  from include/kvm/kvm.h:6:
> > > > include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file or directory
> > > >     5 | #include "asm/kernel.h"
> > > >       |          ^~~~~~~~~~~~~~
> > > > cc1: all warnings being treated as errors
> > > > compilation terminated.
> > > > make: *** [Makefile:484: builtin-balloon.o] Error 1
> > > >
> > > > Would be nice to include it in the commit message, so people googling for
> > > > that exact error message can come across this commit.
> > > >
> > > > On Fri, May 20, 2022 at 11:09:46AM -0700, Dao Lu wrote:
> > > > > Signed-off-by: Dao Lu <daolu@rivosinc.com>
> > > > > ---
> > > > >  riscv/include/asm/kernel.h | 8 ++++++++
> > > > >  1 file changed, 8 insertions(+)
> > > > >  create mode 100644 riscv/include/asm/kernel.h
> > > > >
> > > > > diff --git a/riscv/include/asm/kernel.h b/riscv/include/asm/kernel.h
> > > > > new file mode 100644
> > > > > index 0000000..a2a8d9e
> > > > > --- /dev/null
> > > > > +++ b/riscv/include/asm/kernel.h
> > > > > @@ -0,0 +1,8 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > +
> > > > > +#ifndef __ASM_KERNEL_H
> > > > > +#define __ASM_KERNEL_H
> > > > > +
> > > > > +#define NR_CPUS    4096
> > > >
> > > > In arch/riscv/Kconfig I see this:
> > > >
> > > > config NR_CPUS
> > > >       int "Maximum number of CPUs (2-32)"
> > > >       range 2 32
> > > >       depends on SMP
> > > >       default "8"
> > > >
> > > > Would you mind explaining where the 4096 number of CPUs comes from?
> > > >
> > > > Thanks,
> > > > Alex
> > > >
> > > > > +
> > > > > +#endif /* __ASM_KERNEL_H */
> > > > > --
> > > > > 2.36.0
> > > > >

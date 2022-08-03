Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8111A588E16
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiHCN7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbiHCN7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:59:03 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139BA6268;
        Wed,  3 Aug 2022 06:59:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f28so8285714pfk.1;
        Wed, 03 Aug 2022 06:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=ihBrwGWupH6+vGkMnpB2n2I1VXSYHNBjedrQXWU4/js=;
        b=NYXAIbIa9ECWfnAQKYZ1oHqFL0tGnGdIlmmwF6oZ9kbkqHJa/KDgsYsjT0sUIboneS
         87ErnQ68qMFhSbInEpUkAMT0CRM4Jgiifpv/OoDwWW4RuMIlBlkdtqN3fVhAZJ8v3Rtc
         d6iP/aKPH5tzeeCkq79FgY9207nl62agrQkIngUg687Ia1iw4slQ3imADs0s1DLIblRM
         5Txh08IhzK9pMyHb+hd+o6isfYCZo2zdlExTY5k3MCtwx1KkVp30CXQ+PE01lLOOHgDB
         QvarzCKVardJLQYTcHmt+lOqKX21OurBnOjODcKnM2DFwbov2vRfaFvo6A3G/vjmJ9bF
         wrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=ihBrwGWupH6+vGkMnpB2n2I1VXSYHNBjedrQXWU4/js=;
        b=ymsgw+tahmUZguLcd3HT0kdYcBM2ziyuCqTV9PbUbLUwGWaQQR4i4RwbwI2ySmCXLE
         QhCIIZn/qx0UcPj6MmqKBckXFFnN56X2/WPi5I8vcfGekCYuxNL2HFvHNvNun4NofGAG
         Xlsg/Fk+tY+0N6pc8+zc3U22tK9zjY1b7OLD8W1wxHOP05W0G5Ct5R45qEB2s9UG9CHN
         pWLzjWoePIb5FmFH0UaJ8vVZi6HEjxBZxGjcCvcPjyTxSOPaGZlh/DMUST3sTLTGYyPJ
         Tcy0+QozbsCJOVT7gX4dafIyTnVbHDokuWBd6nn/8upFEi6LIGFrkXh9hXh4zAZwcW+K
         2JDQ==
X-Gm-Message-State: ACgBeo3gwWq37kVZlE55QPfx9vzUGbxa27V6kXLrKkmQo1y5BArBW2hI
        Xo3ZzRvDxLKOEmXXIaS5uBmBSb9irj1zslpsvWY=
X-Google-Smtp-Source: AA6agR5vDSp3vcs0UIkbEis+5mv8LLWOKxeRcCpv9Nk9tstmh+gDbE/7Fz8/Oe0BbghlPFCDDS6qURmtdxAx/zzhO8E=
X-Received: by 2002:aa7:982f:0:b0:52d:9787:c5c5 with SMTP id
 q15-20020aa7982f000000b0052d9787c5c5mr12472770pfl.24.1659535142466; Wed, 03
 Aug 2022 06:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220802071240.84626-1-cloudliang@tencent.com> <20220802150830.rgzeg47enbpsucbr@kamzik>
In-Reply-To: <20220802150830.rgzeg47enbpsucbr@kamzik>
From:   Jinrong Liang <ljr.kernel@gmail.com>
Date:   Wed, 3 Aug 2022 21:58:51 +0800
Message-ID: <CAFg_LQWB5hV9CLnavsCmsLbQCMdj1wqe-gVP7vp_mRGt+Eh+nQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: kvm: Fix a compile error in selftests/kvm/rseq_test.c
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My ldd version is (GNU libc) 2.28, and I get a compilation error in this ca=
se.
But I use another ldd (Ubuntu GLIBC 2.31-0ubuntu9.2) 2.31 is compiling fine=
.
This shows that compilation errors may occur in different GNU libc environm=
ents.
Would it be more appropriate to use syscall for better compatibility?

Thanks,
Jinrong Liang

Andrew Jones <andrew.jones@linux.dev> =E4=BA=8E2022=E5=B9=B48=E6=9C=882=E6=
=97=A5=E5=91=A8=E4=BA=8C 23:08=E5=86=99=E9=81=93=EF=BC=9A

>
> On Tue, Aug 02, 2022 at 03:12:40PM +0800, Jinrong Liang wrote:
> > From: Jinrong Liang <cloudliang@tencent.com>
> >
> > The following warning appears when executing:
> >       make -C tools/testing/selftests/kvm
> >
> > rseq_test.c: In function =E2=80=98main=E2=80=99:
> > rseq_test.c:237:33: warning: implicit declaration of function =E2=80=98=
gettid=E2=80=99; did you mean =E2=80=98getgid=E2=80=99? [-Wimplicit-functio=
n-declaration]
> >           (void *)(unsigned long)gettid());
> >                                  ^~~~~~
> >                                  getgid
> > /usr/bin/ld: /tmp/ccr5mMko.o: in function `main':
> > ../kvm/tools/testing/selftests/kvm/rseq_test.c:237: undefined reference=
 to `gettid'
> > collect2: error: ld returned 1 exit status
> > make: *** [../lib.mk:173: ../kvm/tools/testing/selftests/kvm/rseq_test]=
 Error 1
>
> The man page says we need
>
>  #define _GNU_SOURCE
>  #include <unistd.h>
>
> which rseq_test.c doesn't have. We have _GNU_SOURCE, but not unistd.h.
> IOW, I think this patch can be
>
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/self=
tests/kvm/rseq_test.c
> index a54d4d05a058..8d3d5eab5e19 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -9,6 +9,7 @@
>  #include <string.h>
>  #include <signal.h>
>  #include <syscall.h>
> +#include <unistd.h>
>  #include <sys/ioctl.h>
>  #include <sys/sysinfo.h>
>  #include <asm/barrier.h>
>
> Thanks,
> drew
>
> >
> > Use the more compatible syscall(SYS_gettid) instead of gettid() to fix =
it.
> > More subsequent reuse may cause it to be wrapped in a lib file.
> >
> > Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> > ---
> >  tools/testing/selftests/kvm/rseq_test.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/se=
lftests/kvm/rseq_test.c
> > index a54d4d05a058..299d316cc759 100644
> > --- a/tools/testing/selftests/kvm/rseq_test.c
> > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > @@ -229,7 +229,7 @@ int main(int argc, char *argv[])
> >       ucall_init(vm, NULL);
> >
> >       pthread_create(&migration_thread, NULL, migration_worker,
> > -                    (void *)(unsigned long)gettid());
> > +                    (void *)(unsigned long)syscall(SYS_gettid));
> >
> >       for (i =3D 0; !done; i++) {
> >               vcpu_run(vcpu);
> > --
> > 2.37.1
> >

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3964B3A11
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 09:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiBMIIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 03:08:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiBMIIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 03:08:14 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7A95E763;
        Sun, 13 Feb 2022 00:08:07 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w10so4042054edd.11;
        Sun, 13 Feb 2022 00:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iSzoE/dBtyasT2BnJpIwUu2rMSPkqh/hGHEQuNqLzdk=;
        b=C+WZ+eH1c/+ZuI4bD3UmYtajl4ZhNZQkoGDJ2ebynTyte6r48567RNcKVOXLCLKJSF
         bj64exCerPJDd0ksl1zgJU+3iNaYQ4Y7Qn+vuIiDWFkDIFRGDIXXvMHHhjG/bjp2g21G
         okS825jPbfmVMoSR4nqId8nzfiSYLWa4cItItHI0jGpNG4ZWSNchk6lw+6OD/vA9pyay
         g06o1Y7d1Bhqc/KlTC4OT/9Ts/13WeRNAE1yAVb7Ln00gWGxBGWHozj9jaPam0Sqk96N
         dwaydeg87xKdS6QFjiF5hPtn3WCZ1I1pdwHdvKd11aVHk1MicLYJykTC3E3oRpVhuVMh
         ZO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iSzoE/dBtyasT2BnJpIwUu2rMSPkqh/hGHEQuNqLzdk=;
        b=n23kJr545kbUWfE8czSsRfCmpq/g09dlfamH0at7utKwBLqY1BU67ikENdoLM1uVw3
         o7uWoGFmSPQ2BX4vshF3vOexKupHz1ejV5A9rzHtoYa1iZBBzD7mdq0LwuKtufTyZa92
         FRtozETOqvz7EfHFs1XfR5hNVyANiKcUoceks98JC4T8rIx8OBtGFjSJQ8jBllJ/ZiRQ
         fNSOzSZVeiDrVHahbkX0aD0x55UdtsFnHUpU1Rae3hIDufqIyZwFlj1obsNOrOOX3qbH
         2r1/2zwCRfPRws2ddJyqNc7GwlUv8QXHDRzIZ20kYc1jrVCviVTJHb+OgLllcwTd+V97
         AgUA==
X-Gm-Message-State: AOAM530gD/AnVteg9j3U/gh+8mdSfaJuACelItO3ez7OJ53TX3qXWuhg
        LhzRaXAGzUI/TZ2bZ2Gf5b3GypaIsEHYoZeBqDU=
X-Google-Smtp-Source: ABdhPJzLqPBFQal2aP5BT6oi145eP2/7IczCOA0LLdKUGL9EEmrD1ozn8DsEoMlfahZwIh9pCr721fC2WkWr4h6Bah8=
X-Received: by 2002:a05:6402:1c8f:: with SMTP id cy15mr8632318edb.130.1644739686394;
 Sun, 13 Feb 2022 00:08:06 -0800 (PST)
MIME-Version: 1.0
References: <d3e6a461-5b37-ecfb-d63c-d35af27f2682@molgen.mpg.de>
In-Reply-To: <d3e6a461-5b37-ecfb-d63c-d35af27f2682@molgen.mpg.de>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sun, 13 Feb 2022 16:07:55 +0800
Message-ID: <CAABZP2yOA2n-xux8uUC72vVYc14JfCawoOzp_pnTGDvY8cRSnw@mail.gmail.com>
Subject: Re: Set environment variable `KVM` makes build fail
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        rcu <rcu@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paul

Thank you for your trust in me.

I think the following patch has a good explanation of what happened ;-)
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/=
tools/testing/selftests/rcutorture/bin/torture.sh?id=3Da7d89cfb8e1269cb6d22=
453adba56b8d0218589f
"The torture-test scripting's long-standing use of KVM as the
environment variable tracking the pathname of the rcutorture directory
now conflicts with allmodconfig builds due to the
virt/kvm/Makefile.kvm file's use of this as a makefile variable"

Thanks
Zhouyi

On Sun, Feb 13, 2022 at 2:03 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Linux folks,
>
>
> Playing with rcutorture
> (`tools/testing/selftests/rcutorture/bin/torture.sh`), a Linux kernel
> build failed, because the script sets and exports the environment
> variable `KVM`. I was able to reproduce that manually (on x86_64):
>
>      $ make defconfig
>      $ scripts/config -m KVM
>      $ scripts/config -m KVM_INTEL
>      $ scripts/config -d KVM_AMD
>      $ scripts/config -d KVM_XEN
>      $ scripts/config -d KVM_MMU_AUDIT
>      $ export KVM=3DXXX
>      $ make arch/x86/kvm/kvm.o
>      [=E2=80=A6]
>        LINK    /dev/shm/linux-kvm/tools/objtool/objtool
>      make[2]: *** No rule to make target 'arch/x86/kvm/XXX/kvm_main.o',
> needed by 'arch/x86/kvm/kvm.o'.  Stop.
>      make[1]: *** [scripts/Makefile.build:550: arch/x86/kvm] Error 2
>      make: *** [Makefile:1831: arch/x86] Error 2
>
> The directory `arch/x86/kvm/XXX` is created somehow.
>
> Is that expected? Do you know what is going on? I wasn=E2=80=99t able to
> reproduce this with other variables like `SND_HDA` for example.
>
>
> Kind regards,
>
> Paul

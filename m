Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007A24ED9CC
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiCaMsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 08:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiCaMr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 08:47:57 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B2D210471
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 05:46:09 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id j2so42170354ybu.0
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 05:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7oSbnIlDMLV6mSlKXym3qxASIjVDe/FX+PfPc1IezDE=;
        b=PPRREv5L5fAma5LxA0EXOv+JEtTK1iPK+MPh3OIPRHz/rg8IfACgFN/SgSSXZTkWut
         Vd5qRxwJ4iSEqVkv1OVVCK4UCXXZiaozOEH7wY1iCVvukejhkz8tan8UfHi7RBRwWpXn
         gfcNj13CH1AGfsVJML1nqs/GpvC8Z9Uz1Ttd5nAdDEVlSy0Qvjis+bUaTjhyG96jJ+BV
         nkzsTbUAY/bV7xK9JU9Tnq7vEfBuq6b750m3BmYvRdzb2vS2EpPEw3Kz8eBJ70g6I0A6
         GBtouaOm+5cicC866ZDFzAmADYfg28tFgegtLRf5qY6vYbTZcQOGpWouuFXkIwGVdFwi
         N1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7oSbnIlDMLV6mSlKXym3qxASIjVDe/FX+PfPc1IezDE=;
        b=PDh9g3CHIAw5S9ckwC70fENc5SY52I1uKGh3PDvNBRywZUveeFUSlnRRQHbM8ivMgY
         D1pUnZr7i8OYn19npzEPQnzDIc1OhvN45lrCENJlB1cnVRMKeg+9h468iYE0BWK8wFeM
         EXXuRap3R7FOAmdAWyxpAJ2zz1G2FlOfl3JUEznoN9/AoMA0EyGoDg85ALFvR6nxIWXH
         5Wh/LfXJrlLJXVJPJ8K2uhug/VMA588on4MrjT8U+2H23mIvrYnTrnSXDWmunLzoi2sY
         G94euzQJFh2ZdcC6vBiWUZraUAQlbr+fpwX54kOnEwRrXNcxjpWpBkwO0xgeVWdLgqLv
         U2WQ==
X-Gm-Message-State: AOAM531mKZC53kzfzFxP1pbF5Fgx2gRue/EHgtn8twtavSSz604kcV9b
        nwZmLcfASekQjGpYSgqKozsi+QYjnW0DYo/BKHOBeg==
X-Google-Smtp-Source: ABdhPJwGKVnhTsdd+AusUNKo/rR9ORGT2Uh2CECAGTbqF33pFQyfuq2Pl6u857Kk6DS9yR87O2kxivPuydHscRHD+y4=
X-Received: by 2002:a25:9846:0:b0:61a:3deb:4d39 with SMTP id
 k6-20020a259846000000b0061a3deb4d39mr3915516ybo.537.1648730768369; Thu, 31
 Mar 2022 05:46:08 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 31 Mar 2022 18:15:57 +0530
Message-ID: <CA+G9fYsaUWL4MfkmFJGyZ5WRjibieSLE1V1R8OPsWNmjeYWyUQ@mail.gmail.com>
Subject: [next ] x86: Assembler messages: Error: invalid operands (*UND* and
 .data..percpu sections) for `+'
To:     X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        regressions@lists.linux.dev
Cc:     Li RongQing <lirongqing@baidu.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linux next-20220331 x86_64 build failed due to below warnings / errors
with gcc-11. build log link [1].

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=x86_64
CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
/tmp/ccS5DmVa.s: Assembler messages:
/tmp/ccS5DmVa.s:59: Error: invalid operands (*UND* and .data..percpu
sections) for `+'
make[3]: *** [/builds/linux/scripts/Makefile.build:289:
arch/x86/kernel/kvm.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

metadata:
  git_ref: master
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
  git_sha: fdcbcd1348f4ef713668bae1b0fa9774e1811205
  git_describe: next-20220331
  build link: https://builds.tuxbuild.com/278RMAf1jcRHx7LwzjCMgFSMMLt/


# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake

tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11
--kconfig https://builds.tuxbuild.com/278RMAf1jcRHx7LwzjCMgFSMMLt/config


--
Linaro LKFT
https://lkft.linaro.org

[1] https://builds.tuxbuild.com/278RMAf1jcRHx7LwzjCMgFSMMLt/

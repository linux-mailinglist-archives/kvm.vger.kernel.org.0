Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7233176C31F
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 04:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjHBCxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 22:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjHBCxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 22:53:14 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131CF10C
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 19:53:12 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-486c9cd3b6aso1011522e0c.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 19:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690944791; x=1691549591;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b6/35ZoKcBhfJYY+Rmmtzdcbq9J4zFITai0RFdfSbKg=;
        b=GFFHVZxFzhErjyxupkWSnu/vaA8M1Nq7no8oPjk3qW1UIOCo5AKVjDfmJmi7ayFaJT
         vD+t4WD8+T+AY+agUnbVx89OBhk72U57EV0jFQh59gUK2/8m0ECt2ipZPB6NB9jfn+AT
         uhA31zLtxJP9fnwh50y3A0ZU+eBGnS8ZTf73tOKuiy1L/zKm8tXzYYlUw3c2kSZZtYvg
         jxlkGpCX7CEiIxgKaDbdUUFG1+NOX3u0Lp6yCLmU5YrWrVAdmDXu7T/zHJEtdhs2mXB4
         496KGV/XVZnw7gRe8On02O4wSFzzDh7AS7ti2PNiDd+lFX0Yn46zQeAwJf1ZHkks4KDu
         pi6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690944791; x=1691549591;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b6/35ZoKcBhfJYY+Rmmtzdcbq9J4zFITai0RFdfSbKg=;
        b=DuMxOOastkEb3NSei0aS8lr1hNNUgfS7HfFxDQraskRCS6YJdCnuF9a3wkgVnpcyGU
         BAM2a/g8PLzcPikuvPWiHqgAwQHFW8ZAzOXtre/w3UPhiB7WvrbCgKC08FL12vZMShKB
         ucGrSmul7H2NjRjG4y/bxE4PAlRSM/9qgVjiobI0RQJ6RcE4+aYclDKNxUDJosRNEswq
         yxllHNCc6IOzpfMkWGJJZyjYVKCZDpk5RS0R+EPBudLiQqsJBgRwRU86e7/Ew4o4E9Gi
         kzTKTbFO7UEgoaP1ENaKuzAMvv+e8ubp2NK9SYes9eCf4nAeW2regSe4hBlS0OKTzp4p
         dBlg==
X-Gm-Message-State: ABy/qLYl4Ox+oI8XON0QOGceyGq1Zw/hwSnxxC7bul8RHukU8u3L0sKo
        dEzAMi0QgdkzlDynefNLdHeTjleqWPg25QEB9bh6XQ==
X-Google-Smtp-Source: APBJJlE1gCA8tKH5sYTEP/FZeFFoep4cuyxkMCDwNwtcVmaE3u/k2C0/DAImLXlO/nZL9KA/7Dms2iGYeM3LrVk5CUs=
X-Received: by 2002:a1f:c304:0:b0:471:7996:228f with SMTP id
 t4-20020a1fc304000000b004717996228fmr3664338vkf.7.1690944791082; Tue, 01 Aug
 2023 19:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230801091925.659598007@linuxfoundation.org>
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Aug 2023 08:22:59 +0530
Message-ID: <CA+G9fYsv5dFJfjNq7O+CW3J9jEV0zDQiOR+8dyacwhpDih0xJw@mail.gmail.com>
Subject: Re: [PATCH 6.4 000/239] 6.4.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        conor@kernel.org, Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Aug 2023 at 15:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.4.8 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following kselftest build regression found,

    selftests/rseq: Play nice with binaries statically linked against
glibc 2.35+
    commit 3bcbc20942db5d738221cca31a928efc09827069 upstream.


    To allow running rseq and KVM's rseq selftests as statically linked
    binaries, initialize the various "trampoline" pointers to point directly
    at the expect glibc symbols, and skip the dlysm() lookups if the rseq
    size is non-zero, i.e. the binary is statically linked *and* the libc
    registered its own rseq.

    Define weak versions of the symbols so as not to break linking against
    libc versions that don't support rseq in any capacity.

    The KVM selftests in particular are often statically linked so that they
    can be run on targets with very limited runtime environments, i.e. test
    machines.

    Fixes: 233e667e1ae3 ("selftests/rseq: Uplift rseq selftests for
compatibility with glibc-2.35")
    Cc: Aaron Lewis <aaronlewis@google.com>
    Cc: kvm@vger.kernel.org
    Cc: stable@vger.kernel.org
    Signed-off-by: Sean Christopherson <seanjc@google.com>
    Message-Id: <20230721223352.2333911-1-seanjc@google.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Build log:
----
x86_64-linux-gnu-gcc -O2 -Wall -g -I./ -isystem
/home/tuxbuild/.cache/tuxmake/builds/1/build/usr/include
-L/home/tuxbuild/.cache/tuxmake/builds/1/build/kselftest/rseq
-Wl,-rpath=./   -shared -fPIC rseq.c -lpthread -ldl -o
/home/tuxbuild/.cache/tuxmake/builds/1/build/kselftest/rseq/librseq.so
rseq.c:41:1: error: unknown type name '__weak'
   41 | __weak ptrdiff_t __rseq_offset;
      | ^~~~~~
rseq.c:41:18: error: expected '=', ',', ';', 'asm' or '__attribute__'
before '__rseq_offset'
   41 | __weak ptrdiff_t __rseq_offset;
      |                  ^~~~~~~~~~~~~
rseq.c:42:7: error: expected ';' before 'unsigned'
   42 | __weak unsigned int __rseq_size;
      |       ^~~~~~~~~
      |       ;
rseq.c:43:7: error: expected ';' before 'unsigned'
   43 | __weak unsigned int __rseq_flags;
      |       ^~~~~~~~~
      |       ;
rseq.c:45:47: error: '__rseq_offset' undeclared here (not in a
function); did you mean 'rseq_offset'?
   45 | static const ptrdiff_t *libc_rseq_offset_p = &__rseq_offset;
      |                                               ^~~~~~~~~~~~~
      |                                               rseq_offset
make[3]: Leaving directory 'tools/testing/selftests/rseq'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2TNSVjRCfcIaJWQNkPwDQ9jn2ls/build.log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.4.7-240-g2c273bf138a4/testrun/18770115/suite/kselftest-rseq/test/shardfile-rseq/details/


--
Linaro LKFT
https://lkft.linaro.org

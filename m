Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8FC4315E9
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 12:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhJRKY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 06:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbhJRKYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 06:24:20 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9C6C061714
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 03:22:09 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ec8so69154010edb.6
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 03:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=87x3nqoZyNhvlsZlpX5QGgh9vIwgmThCTmliRoh6zy0=;
        b=iJRrv6+DeADalL6e6sEgX6OZ6xgVXl/Sz9ErRw2tpVXgs8+kDU0VfBoi6+ROzgKfpW
         CpYLNnaTR8PvCbcc0vOr53bLH38CdPU/UeFHTY43F7QMdjR1hkS/e652Y7jeaox2nJHs
         fcW4q89zMywSuuhdUEgipqRyhfChsH4vZaO0/RS1Gj9MKnMa3+pRM3G39AS5eRUBZh/r
         q5gKVmprsFkYG0kgrOFC7hWkp+oOtNSVdAtLuvIzJwX3JUizMtxipNVBQ3cDGeQWA1CQ
         hHFVRB694phEt9Tixu2rqX9ybNRxTOMWBQTja3fZ1AuRwZYjeBB6mWJkkCm0Odx/RGms
         7niQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=87x3nqoZyNhvlsZlpX5QGgh9vIwgmThCTmliRoh6zy0=;
        b=xp5TgBGnczBuzrpL8Uijnk1AqfRQlyuP9UrTt62OOGOajAVwx7BUnl6gwjywmod7gq
         Q/bA1UEbVtiHxgAvXCEQ3xLNLomvSPFYf6xK5ZFk3USY520ab1Q3pFPZoK7FNAydkIhR
         2IkVhi+T3rWWldM2o/s8biYmNCStTPN6epHwebI9yDAWZDPtcuCfXYTq2k2twqPU6azP
         CE2iSOBqQY/zQVZXRaZbyRX0IKxIqaRBWYFuozrM8A1KWm+29FNJ5zqEwVdDip813hDp
         4XqKGZCTCnOAfepj0XZ3Z9q1CqjlP+OsiPuSKxJ3gkQfAyDLoz7TIWYhzZXmzgUlIkEJ
         agnQ==
X-Gm-Message-State: AOAM532h8tLwbPPQ+nazY1o1IA//oDauKkVhwIItz3P8dig+kiQW3kpz
        /W9QNUBcEjWEO6Ixjyso5Nl6WGEYatPbefV9LMOVkw==
X-Google-Smtp-Source: ABdhPJy32ABQOwaX1ssk2eKl9PCN4su84bBKky3gjvsYOJ6tNLN5oylFXfhinb1P3QpJig5YOyWvyLNE+21x53vRTos=
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr29499177ejb.6.1634552527783;
 Mon, 18 Oct 2021 03:22:07 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 Oct 2021 15:51:55 +0530
Message-ID: <CA+G9fYt7FMXbp47ObVZ4B7X917186Fu39+LM04PcbqZ2-f7-qg@mail.gmail.com>
Subject: Re: [PATCH 1/8] KVM: SEV-ES: fix length of string I/O
To:     thomas.lendacky@amd.com, fwilhelm@google.com,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, oupton@google.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-stable <stable@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Please ignore this email if it already reported ]

Following build errors noticed while building Linux next 20211018
with gcc-11 for i386 architecture.

i686-linux-gnu-ld: arch/x86/kvm/svm/sev.o: in function `sev_es_string_io':
sev.c:(.text+0x110f): undefined reference to `__udivdi3'
make[1]: *** [/builds/linux/Makefile:1247: vmlinux] Error 1
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:226: __sub-make] Error 2

Build config:
https://builds.tuxbuild.com/1zftLfjR2AyF4rsIfyUCnCTLKFs/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

meta data:
-----------
    git_describe: next-20211018
    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
    git_sha: 60e8840126bdcb60bccef74c3f962742183c681f
    git_short_log: 60e8840126bd (\"Add linux-next specific files for 20211018\")
    kernel_version: 5.15.0-rc5
    target_arch: i386
    toolchain: gcc-11

steps to reproduce:
https://builds.tuxbuild.com/1zftLfjR2AyF4rsIfyUCnCTLKFs/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org

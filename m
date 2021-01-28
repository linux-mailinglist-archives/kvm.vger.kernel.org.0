Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56BE3068C7
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 01:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhA1AoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 19:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhA1Ana (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 19:43:30 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA5AC061573
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 16:42:50 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id i9so3193076wmq.1
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 16:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=4FUggc4yzu1KtYVghJzSJJr7MdA1Yc7w8ID3X4Mlw2M=;
        b=F+xs49xd/VAG5Vm+qCegbXtUW14C8tNcQpSgLW1vJ1JJutem1Z8oCxoGrjVvzuNnso
         8TIGOGC0dpl9msUfrnnUGuUXKX01aPdNT9kfZfuelfGz9zk/6VLsdMMdIH5ZugakqQOx
         eHLRXeBdi60nTXcku9IMazLo73M/8Mx8B16qQQj5N2zQHvP8xpDQdQ9O9E6/1B/PNeaH
         RLOtfxQ6+ywxN7t6rkj58wXxjCVJVFznAjYAI6EaqbWRE2fUSwi+HA+TKtCRf1n9V5qE
         50qtkx0TN2giWRnjzSsfiCzUccjz0IY3rTLlbG7/jVZhd/hLvOf2hTAOzxZShl7Gen3y
         zw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=4FUggc4yzu1KtYVghJzSJJr7MdA1Yc7w8ID3X4Mlw2M=;
        b=VVoVzKB/1KcWjA9ofb0uKGEFdaIqUQBUyszgrUrg0hyL+7zRJjuxVGO9JaNLDqiBYf
         JG3KpTcaEzDNYMKsF1/oj+Db+SbY8hsy7jTqfjSEfFbBTGEk5euUCMU/gjhvQN4HnnQ7
         fNJBjYmR8gWC0Ldd+nSJUjenw3v9Yv/fTEzEmpqn3hwcc1yEEdpGsPxV/OeNX3bB5JyJ
         GH+M/oID3kOH7hO4Ikj+d5en5HhVJP4H5V62TwVFI+JTjhaVSXzBhu/EQ0mJH2hWz6GX
         l8SfiKdbj78pUTlJ3ULHaMf1x3UbMMJq6zqBdG4Bu4xor26o8vWpIfYumtI62J43yeiE
         wg/Q==
X-Gm-Message-State: AOAM532zj+ZBER7LYvIinwgsGGPAqFsvodTCOvZrtTvQgFVFVep2kyUG
        7xI/E8CXKpt+nrd8lIm1rvBnxg==
X-Google-Smtp-Source: ABdhPJybTXFN9BRWqacIhqXMQQBrv/YSjbVjMcWL1N4zB9EwkDozKrP6iQxgjot5N25UyTcAVhw9sw==
X-Received: by 2002:a1c:f706:: with SMTP id v6mr6301059wmh.85.1611794569066;
        Wed, 27 Jan 2021 16:42:49 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id s24sm4020238wmh.22.2021.01.27.16.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 16:42:47 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 050D81FF7E;
        Thu, 28 Jan 2021 00:42:47 +0000 (GMT)
References: <20200929224355.1224017-1-philmd@redhat.com>
User-agent: mu4e 1.5.7; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v4 00/12] Support disabling TCG on ARM (part 2)
Date:   Thu, 28 Jan 2021 00:41:50 +0000
In-reply-to: <20200929224355.1224017-1-philmd@redhat.com>
Message-ID: <87r1m5x56h.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> Cover from Samuel Ortiz from (part 1) [1]:
>
>   This patchset allows for building and running ARM targets with TCG
>   disabled. [...]
>
>   The rationale behind this work comes from the NEMU project where we're
>   trying to only support x86 and ARM 64-bit architectures, without
>   including the TCG code base. We can only do so if we can build and run
>   ARM binaries with TCG disabled.
>
> v4 almost 2 years later... [2]:
> - Rebased on Meson
> - Addressed Richard review comments
> - Addressed Claudio review comments

Have you re-based recently because I was having a look but ran into
merge conflicts. I'd like to get the merged at some point because I ran
into similar issues with the Xen only build without TCG.

>
> v3 almost 18 months later [3]:
> - Rebased
> - Addressed Thomas review comments
> - Added Travis-CI job to keep building --disable-tcg on ARM
>
> v2 [4]:
> - Addressed review comments from Richard and Thomas from v1 [1]
>
> Regards,
>
> Phil.
>
> [1]: https://lists.gnu.org/archive/html/qemu-devel/2018-11/msg02451.html
> [2]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg689168.html
> [3]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg641796.html
> [4]: https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05003.html
>
> Green CI:
> - https://cirrus-ci.com/build/4572961761918976
> - https://gitlab.com/philmd/qemu/-/pipelines/196047779
> - https://travis-ci.org/github/philmd/qemu/builds/731370972
>
> Based-on: <20200929125609.1088330-1-philmd@redhat.com>
> "hw/arm: Restrict APEI tables generation to the 'virt' machine"
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg745792.html
>
> Philippe Mathieu-Daud=C3=A9 (10):
>   accel/tcg: Add stub for cpu_loop_exit()
>   meson: Allow optional target/${ARCH}/Kconfig
>   target/arm: Select SEMIHOSTING if TCG is available
>   target/arm: Restrict ARMv4 cpus to TCG accel
>   target/arm: Restrict ARMv5 cpus to TCG accel
>   target/arm: Restrict ARMv6 cpus to TCG accel
>   target/arm: Restrict ARMv7 R-profile cpus to TCG accel
>   target/arm: Restrict ARMv7 M-profile cpus to TCG accel
>   target/arm: Reorder meson.build rules
>   .travis.yml: Add a KVM-only Aarch64 job
>
> Samuel Ortiz (1):
>   target/arm: Do not build TCG objects when TCG is off
>
> Thomas Huth (1):
>   target/arm: Make m_helper.c optional via CONFIG_ARM_V7M
>
>  default-configs/arm-softmmu.mak |  3 --
>  meson.build                     |  8 +++-
>  target/arm/cpu.h                | 12 ------
>  accel/stubs/tcg-stub.c          |  5 +++
>  target/arm/cpu_tcg.c            |  4 +-
>  target/arm/helper.c             |  7 ----
>  target/arm/m_helper-stub.c      | 73 +++++++++++++++++++++++++++++++++
>  .travis.yml                     | 35 ++++++++++++++++
>  hw/arm/Kconfig                  | 32 +++++++++++++++
>  target/arm/Kconfig              |  4 ++
>  target/arm/meson.build          | 40 +++++++++++-------
>  11 files changed, 184 insertions(+), 39 deletions(-)
>  create mode 100644 target/arm/m_helper-stub.c
>  create mode 100644 target/arm/Kconfig


--=20
Alex Benn=C3=A9e

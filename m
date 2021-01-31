Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3685E309C54
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 14:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhAaNam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 08:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhAaLwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:52:04 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21B3C06178A
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:26 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id u14so10751050wmq.4
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1gCD684y2+yR8ZPFp0RrwyPF7ZTcIuoLv37e2hkgFE0=;
        b=n/rUycdc+ct+UAqDtNRrvH32lMXamGwdH/hrZpmxT5tFvY/s3Yt9F8aZkX9j4jtwqP
         ujuykrOso7k6mKqrGY4dNKu1x+SqgfERulsiFPHm7Bs9POeqwzV6W2qVO31s1MJffxLA
         Go5XmdNKRrrNV7xzzETC4xkxqMXnuX/xVwPduR4mNEZaQbjK5Kzuoy9up/bd2iUXZ+3U
         S9+bFqz2m53y3bVyiwj6pfQ3NXAHBSqMgrHbDF0KDJkEvY3squ+2FaeICfjkqIVBu2DQ
         dtE6Pn9JhTFPDzknw4DWaiVAtDRs4ZhplHKoalaxdC6xOtO+k5V8b5xEYZmwXr8jU8ck
         AMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=1gCD684y2+yR8ZPFp0RrwyPF7ZTcIuoLv37e2hkgFE0=;
        b=Dtp+wX4hKZ6CvPfn3pmnVi1/H/rEbUoFgapmWUUtRJRsW8bGDmS6FFxS/Bi1h1YHxe
         b+GtECgqFsbCDQjGVowzzRi6pJ053B/T3ZtfSnBaaarBC77FDqlIyqcMlVZvs7lu87d0
         FNbz5KQm2XExSrR1/gFFDSd8XNmKJ11TvTtyXaAR9tvJCvD+PVmyf+K4WDrHGv9bi3nB
         G59xP7x27rMnx12tkJ4pxVzFoqR5MzkC1ZVhDxa4nRm7JWjp+S+/Zlib2otALgKhLJlf
         QoT5tT6/cEYwsbxd0ujYBxwJo9H1d9zZ3pImOCXAmd4GugeQ4D3gKHMLH4xMdLjWoO/e
         sf8w==
X-Gm-Message-State: AOAM532cgcCqOPOlr4NpD4x317tYmrbPGpBrD1HNfE10DFDTaigQ1Do1
        /o3XkU7RgBSR8CtMyu0NioNEJXA09ig=
X-Google-Smtp-Source: ABdhPJxub8KK7dIC58IEzuZSU43m5r7m7PqN3sJd1N+IK8W88v9tfmfMGC7iaD18Qc5HF+HixP+deA==
X-Received: by 2002:a7b:c7c8:: with SMTP id z8mr10774027wmk.72.1612093825430;
        Sun, 31 Jan 2021 03:50:25 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id g194sm17384967wme.39.2021.01.31.03.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:50:24 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 00/11] Support disabling TCG on ARM (part 2)
Date:   Sun, 31 Jan 2021 12:50:11 +0100
Message-Id: <20210131115022.242570-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cover from Samuel Ortiz from (part 1) [1]:=0D
=0D
  This patchset allows for building and running ARM targets with TCG=0D
  disabled. [...]=0D
=0D
  The rationale behind this work comes from the NEMU project where=0D
  we're trying to only support x86 and ARM 64-bit architectures,=0D
  without including the TCG code base. We can only do so if we can=0D
  build and run ARM binaries with TCG disabled.=0D
=0D
Peter mentioned in v5 [6] that since 32-bit host has been removed,=0D
we have to remove v7 targets. This is not done in this series, as=0D
linking succeeds, and there is enough material to review (no need=0D
to spend time on that extra patch if the current approach is not=0D
accepted).=0D
=0D
CI: https://gitlab.com/philmd/qemu/-/pipelines/249272441=0D
=0D
v6:=0D
- rebased on "target/arm/Kconfig" series=0D
- introduce/use tcg_builtin() for realview machines=0D
=0D
v5:=0D
- addressed Paolo/Richard/Thomas review comments from v4 [5].=0D
=0D
v4 almost 2 years later... [2]:=0D
- Rebased on Meson=0D
- Addressed Richard review comments=0D
- Addressed Claudio review comments=0D
=0D
v3 almost 18 months later [3]:=0D
- Rebased=0D
- Addressed Thomas review comments=0D
- Added Travis-CI job to keep building --disable-tcg on ARM=0D
=0D
v2 [4]:=0D
- Addressed review comments from Richard and Thomas from v1 [1]=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
[1]: https://lists.gnu.org/archive/html/qemu-devel/2018-11/msg02451.html=0D
[2]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg689168.html=0D
[3]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg641796.html=0D
[4]: https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05003.html=0D
[5]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg746041.html=0D
[6]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg777669.html=0D
=0D
Based-on: <20210131111316.232778-1-f4bug@amsat.org>=0D
          "target: Provide target-specific Kconfig"=0D
=0D
Philippe Mathieu-Daud=C3=A9 (9):=0D
  sysemu/tcg: Introduce tcg_builtin() helper=0D
  exec: Restrict TCG specific headers=0D
  target/arm: Restrict ARMv4 cpus to TCG accel=0D
  target/arm: Restrict ARMv5 cpus to TCG accel=0D
  target/arm: Restrict ARMv6 cpus to TCG accel=0D
  target/arm: Restrict ARMv7 R-profile cpus to TCG accel=0D
  target/arm: Restrict ARMv7 M-profile cpus to TCG accel=0D
  target/arm: Reorder meson.build rules=0D
  .travis.yml: Add a KVM-only Aarch64 job=0D
=0D
Samuel Ortiz (1):=0D
  target/arm: Do not build TCG objects when TCG is off=0D
=0D
Thomas Huth (1):=0D
  target/arm: Make m_helper.c optional via CONFIG_ARM_V7M=0D
=0D
 default-configs/devices/aarch64-softmmu.mak |  1 -=0D
 default-configs/devices/arm-softmmu.mak     | 27 --------=0D
 include/exec/helper-proto.h                 |  2 +=0D
 include/sysemu/tcg.h                        |  2 +=0D
 target/arm/cpu.h                            | 12 ----=0D
 hw/arm/realview.c                           |  7 +-=0D
 target/arm/cpu_tcg.c                        |  4 +-=0D
 target/arm/helper.c                         |  7 --=0D
 target/arm/m_helper-stub.c                  | 73 +++++++++++++++++++++=0D
 tests/qtest/cdrom-test.c                    |  6 +-=0D
 .travis.yml                                 | 32 +++++++++=0D
 hw/arm/Kconfig                              | 38 +++++++++++=0D
 target/arm/Kconfig                          | 17 +++++=0D
 target/arm/meson.build                      | 28 +++++---=0D
 14 files changed, 196 insertions(+), 60 deletions(-)=0D
 create mode 100644 target/arm/m_helper-stub.c=0D
=0D
-- =0D
2.26.2=0D
=0D

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8201027DC33
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgI2WoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728206AbgI2WoF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:05 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Sm3Gm34Jjn5EWoNbFg1uRbBUxTP1yXhpa0ydpRV9pWQ=;
        b=DfJkfJrYWYEmrzSS/DwzH9maizUGiuRsF//vS5MkWBOnc3dR+q414QXHQv8M+4Jqxz9ni0
        67aDwI1+ndqOevka49kb4ff9fuZ/liToqMM434jytP4rsVsfM//4EAzU9ewtX6/uxIsERi
        ZRrKgb9xYVvgnoM+VwH7MNtYdPsa3AY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-Pm43bzf8NGKboPvbAZf0cA-1; Tue, 29 Sep 2020 18:43:59 -0400
X-MC-Unique: Pm43bzf8NGKboPvbAZf0cA-1
Received: by mail-wm1-f72.google.com with SMTP id m25so2428690wmi.0
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sm3Gm34Jjn5EWoNbFg1uRbBUxTP1yXhpa0ydpRV9pWQ=;
        b=M1YUl+rvq2zy9qC5q5eiH8usQmltnV2CoOSuc663I04FPTWJOXf+gVSASkP7BGAd7B
         tO0tjRONqnKjOATpjDet+nCnr80xDBvHSomrxfVyIe0sb4cN89zNwUzIOPd9JQRXLXHs
         Dv9t29yfos5ipRiVtgkQLmmn4iT+O/QB22Z1U/K7jE0WJSJlpyTX04PMHmVswJ7bVGCF
         r8PRrPJThlHlvf1DoU7PDG+BsINCdEfZRYNhUnjTf5fdqOLjdnYrBpuvCynrm+pXbnl9
         cBx+9/eCn71sQFPYvqMK7yvWC1qz1/jGi/8gS0+1Aa2wzMmsl8o+2Vs29LA3NqEj8QJ0
         zOWA==
X-Gm-Message-State: AOAM5317kkALBroFzgIdWV9HxbPk2vbI/uM+MFfs0b31fqD/0yX9HomY
        07Nte3mtSmNvZBJvERjTS/dOuDX8hhk+x8TI/2UMAHXoIHJEO7G5jl2YquDml6I4rc3ftAwm1QU
        5tTfX0J9N1LFH
X-Received: by 2002:a05:600c:2053:: with SMTP id p19mr6799089wmg.50.1601419437869;
        Tue, 29 Sep 2020 15:43:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzytBklMSd+mcQkWT4fWwubovRHL78gH/20a8RlxC2MfpeBb4ay504uDGUwZsnPRbVg7dNQwQ==
X-Received: by 2002:a05:600c:2053:: with SMTP id p19mr6799082wmg.50.1601419437666;
        Tue, 29 Sep 2020 15:43:57 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id t17sm8129443wrx.82.2020.09.29.15.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:43:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 00/12] Support disabling TCG on ARM (part 2)
Date:   Wed, 30 Sep 2020 00:43:43 +0200
Message-Id: <20200929224355.1224017-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cover from Samuel Ortiz from (part 1) [1]:

  This patchset allows for building and running ARM targets with TCG
  disabled. [...]

  The rationale behind this work comes from the NEMU project where we're
  trying to only support x86 and ARM 64-bit architectures, without
  including the TCG code base. We can only do so if we can build and run
  ARM binaries with TCG disabled.

v4 almost 2 years later... [2]:
- Rebased on Meson
- Addressed Richard review comments
- Addressed Claudio review comments

v3 almost 18 months later [3]:
- Rebased
- Addressed Thomas review comments
- Added Travis-CI job to keep building --disable-tcg on ARM

v2 [4]:
- Addressed review comments from Richard and Thomas from v1 [1]

Regards,

Phil.

[1]: https://lists.gnu.org/archive/html/qemu-devel/2018-11/msg02451.html
[2]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg689168.html
[3]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg641796.html
[4]: https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05003.html

Green CI:
- https://cirrus-ci.com/build/4572961761918976
- https://gitlab.com/philmd/qemu/-/pipelines/196047779
- https://travis-ci.org/github/philmd/qemu/builds/731370972

Based-on: <20200929125609.1088330-1-philmd@redhat.com>
"hw/arm: Restrict APEI tables generation to the 'virt' machine"
https://www.mail-archive.com/qemu-devel@nongnu.org/msg745792.html

Philippe Mathieu-Daudé (10):
  accel/tcg: Add stub for cpu_loop_exit()
  meson: Allow optional target/${ARCH}/Kconfig
  target/arm: Select SEMIHOSTING if TCG is available
  target/arm: Restrict ARMv4 cpus to TCG accel
  target/arm: Restrict ARMv5 cpus to TCG accel
  target/arm: Restrict ARMv6 cpus to TCG accel
  target/arm: Restrict ARMv7 R-profile cpus to TCG accel
  target/arm: Restrict ARMv7 M-profile cpus to TCG accel
  target/arm: Reorder meson.build rules
  .travis.yml: Add a KVM-only Aarch64 job

Samuel Ortiz (1):
  target/arm: Do not build TCG objects when TCG is off

Thomas Huth (1):
  target/arm: Make m_helper.c optional via CONFIG_ARM_V7M

 default-configs/arm-softmmu.mak |  3 --
 meson.build                     |  8 +++-
 target/arm/cpu.h                | 12 ------
 accel/stubs/tcg-stub.c          |  5 +++
 target/arm/cpu_tcg.c            |  4 +-
 target/arm/helper.c             |  7 ----
 target/arm/m_helper-stub.c      | 73 +++++++++++++++++++++++++++++++++
 .travis.yml                     | 35 ++++++++++++++++
 hw/arm/Kconfig                  | 32 +++++++++++++++
 target/arm/Kconfig              |  4 ++
 target/arm/meson.build          | 40 +++++++++++-------
 11 files changed, 184 insertions(+), 39 deletions(-)
 create mode 100644 target/arm/m_helper-stub.c
 create mode 100644 target/arm/Kconfig

-- 
2.26.2


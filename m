Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13A52D9059
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbgLMUUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbgLMUUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:20:30 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723CEC0613CF
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:19:50 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id y17so14366397wrr.10
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6aT0hnxN9Lk7mHwwTD8w8mjwYa5KaIbUi6jXCtHBCQM=;
        b=RXb4/2mjYb9G+dykIme3OPCkocGwJCGkzuu8clS4GEEKO6f7cta1u/r1bQAFbtjYbs
         /zKjnseBBJh+zQECv52jnZTPvPGT/ymFWc7pDbD90QNaj5dz37UZWRkhTBk7FY+rgDjt
         F+QlCoK1mzZabzzXwrCUAfOZqQSLPqqCRA2giCqCJqAcuQBzWZOp2daV1r3sVprGWe0b
         BjnWngxp7PVwrZb9yFA/RrSFnGcOtriXO9yUNmuBORsTQamxRLCuxwarWFm0qFSwCMdM
         7rzqFzD//+hkRkbjZmQcS9njY7E3xJBd6R450w3pqn4/J07XCNd3E/rmy7hUSHhV0Vp2
         3IfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=6aT0hnxN9Lk7mHwwTD8w8mjwYa5KaIbUi6jXCtHBCQM=;
        b=ffzopROiwaeRqk2LFjDbJr3wBNTCsAt0I5aRsghbsDjOUYVXSBlz0d0XUtF8fc4QFf
         56srBuQpH6j5EPboZmPErDlmYSYdfTXFpYUFXDTB0Gfy0NXyh2WOdKHg5tEdqlDV8p6j
         AnQfhDIXAJk0qi4R1loTZy7xHjoigygx/n8OSmNuwglAjojwkpaSL0tOIIIOazDr2FmV
         38Q3j9miqJl7WVysOFQhTqr6uEOshKdwd0IMGhRLIjD8w5mhemEvpEFGuZg1/h8BAnt6
         07QF322gmHMBdWWAA1s4iBbRVki8v9YGoJaVhd7cSOzmhR1nqNCuxXka9h3OJCqy45K0
         uEEQ==
X-Gm-Message-State: AOAM530DvxbfDrkmYRoSCSnV16dMx2v4dQJCnfb1NzJg5eKBgqCgMGlh
        0f+XaEeJ2xhifmoLZANgasg=
X-Google-Smtp-Source: ABdhPJzLu1l79ty9fZ484FlDoec/3Llbbu/ND5f33k0x8Pjnud30Pvq+O1w+UgnL5w5ESi994IyXZA==
X-Received: by 2002:adf:c454:: with SMTP id a20mr25225088wrg.314.1607890789069;
        Sun, 13 Dec 2020 12:19:49 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id i9sm31558614wrs.70.2020.12.13.12.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:19:48 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>
Subject: [PULL 00/26] MIPS patches for 2020-12-13
Date:   Sun, 13 Dec 2020 21:19:20 +0100
Message-Id: <20201213201946.236123-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit ad717e6da3852b5729217d7938eecdb81c546114=
:=0D
=0D
  Merge remote-tracking branch 'remotes/kevin/tags/for-upstream' into stagi=
ng (2020-12-12 00:20:46 +0000)=0D
=0D
are available in the Git repository at:=0D
=0D
  https://gitlab.com/philmd/qemu.git tags/mips-20201213=0D
=0D
for you to fetch changes up to 3533ee301c46620fd5699cb97f2d4bd194fe0c24:=0D
=0D
  target/mips: Use FloatRoundMode enum for FCR31 modes conversion (2020-12-=
13 20:27:11 +0100)=0D
=0D
----------------------------------------------------------------=0D
MIPS patches queue=0D
=0D
. Allow executing MSA instructions on Loongson-3A4000=0D
. Update Huacai Chen email address=0D
. Various cleanups:=0D
  - unused headers removal=0D
  - use definitions instead of magic values=0D
  - remove dead code=0D
  - avoid calling unused code=0D
. Various code movements=0D
=0D
CI jobs results:=0D
  https://gitlab.com/philmd/qemu/-/pipelines/229120169=0D
  https://cirrus-ci.com/build/4857731557359616=0D
----------------------------------------------------------------=0D
=0D
Huacai Chen (1):=0D
  MAINTAINERS: chenhc@lemote.com -> chenhuacai@kernel.org=0D
=0D
Philippe Mathieu-Daud=C3=A9 (25):=0D
  target/mips/kvm: Assert unreachable code is not used=0D
  target/mips/kvm: Remove unused headers=0D
  target/mips: Include "exec/memattrs.h" in 'internal.h'=0D
  target/mips: Replace magic values by CP0PM_MASK or=0D
    TARGET_PAGE_BITS_MIN=0D
  target/mips: Do not include CP0 helpers in user-mode emulation=0D
  target/mips: Remove unused headers from cp0_helper.c=0D
  target/mips: Also display exception names in user-mode=0D
  target/mips: Allow executing MSA instructions on Loongson-3A4000=0D
  target/mips: Explicit Release 6 MMU types=0D
  target/mips: Rename cpu_supports_FEAT() as cpu_type_supports_FEAT()=0D
  target/mips: Introduce cpu_supports_isa() taking CPUMIPSState argument=0D
  hw/mips: Move address translation helpers to target/mips/=0D
  target/mips: Remove unused headers from translate.c=0D
  target/mips: Remove unused headers from op_helper.c=0D
  target/mips: Remove mips_def_t unused argument from mvp_init()=0D
  target/mips: Introduce ase_mt_available() helper=0D
  target/mips: Do not initialize MT registers if MT ASE absent=0D
  hw/mips/malta: Do not initialize MT registers if MT ASE absent=0D
  hw/mips/malta: Rewrite CP0_MVPConf0 access using deposit()=0D
  target/mips: Extract cpu_supports*/cpu_set* translate.c=0D
  target/mips: Move mips_cpu_add_definition() from helper.c to cpu.c=0D
  target/mips: Move cpu definitions, reset() and realize() to cpu.c=0D
  target/mips: Inline cpu_mips_realize_env() in mips_cpu_realizefn()=0D
  target/mips: Remove unused headers from fpu_helper.c=0D
  target/mips: Use FloatRoundMode enum for FCR31 modes conversion=0D
=0D
 include/hw/mips/cpudevs.h        |   7 -=0D
 target/mips/cpu.h                |  20 ++-=0D
 target/mips/internal.h           |  17 +-=0D
 hw/mips/boston.c                 |   5 +-=0D
 hw/mips/cps.c                    |   3 +-=0D
 hw/mips/malta.c                  |  14 +-=0D
 {hw =3D> target}/mips/addr.c       |   2 +-=0D
 target/mips/cp0_helper.c         |  15 +-=0D
 target/mips/cpu.c                | 299 ++++++++++++++++++++++++++++++-=0D
 target/mips/fpu_helper.c         |   6 +-=0D
 target/mips/helper.c             |  64 ++-----=0D
 target/mips/kvm.c                |  11 +-=0D
 target/mips/op_helper.c          |   4 -=0D
 target/mips/translate.c          | 262 ---------------------------=0D
 target/mips/translate_init.c.inc |  10 +-=0D
 .mailmap                         |   2 +=0D
 MAINTAINERS                      |   8 +-=0D
 hw/mips/meson.build              |   2 +-=0D
 target/mips/meson.build          |   3 +-=0D
 19 files changed, 378 insertions(+), 376 deletions(-)=0D
 rename {hw =3D> target}/mips/addr.c (98%)=0D
=0D
-- =0D
2.26.2=0D
=0D

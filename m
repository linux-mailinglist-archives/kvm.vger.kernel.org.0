Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27D52D080F
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgLFXkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLFXkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:40:35 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED19C0613D0
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:39:54 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id g185so12067795wmf.3
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5+L/UCYh+Yz8OUjrhsORCjGrNemm4sUDpLhEt7FajQo=;
        b=TYlsC723yQq4wuLZ89hIbt3GLMlvebNYw7DemJ99SzC+IyJZaxauxVxo1c8dScEjJ8
         05QUUsRBA5/9UKGc3dPHQaTFKylQzLj109R2n/ahuP8Cl7/+e9vCp6FwqvU1x9VIWgEO
         EPT643LV0EQd9M1Ma0uydOQ25+0hgFUlrNAdZz5RHhNEHz1vzMUeusqIcfApxSfUgAY9
         y0s9JT/sKLxyaGN9Cv/Hd7SBOSJ9NEAgQUsBMkFYiWUToT7AgbDKvkaeCaDyzXFs62JW
         UlXWD4nGr60/GRa2k/tUoOi8AGuCaSD2ddAVvA+7LkWY15QC8CFYnOoNXgKa2ErxM6E9
         Djlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=5+L/UCYh+Yz8OUjrhsORCjGrNemm4sUDpLhEt7FajQo=;
        b=TNKZCgR1FXmTaIzvLXp44OPw0JlTa1NWkI8KF7pCSG+FxhvPEjvv2oiOs3ffB6Egxk
         9xxYzsjyD9LDscTi4Qz8JlTdyLf5qoY9oLB7cYo/kOl4HeJY8wSC8qRBUDqp/jcOl/DM
         /uesQ+smWfnjX2aLQyVgSwy4nYoXsV3+0K8FLuPmG0KT6lTdcrFkX0WPJE8lSvEG7G/g
         EZSP+OZK+unUOS0F9kiy7qfWrlF+ib38gwvtM1Zn5EcytVmIgKC4/Y76wwSuXsSyGXzM
         Hv7cqSqBXSLO/f5CK/M6ngQr22a65lZGfMYWg7kzIbrvHY2DuklkWEMZyT0AqHtLMVh3
         z7yw==
X-Gm-Message-State: AOAM530GDDRg8HNqHgHGBK8HarJKmL2OmhsiVTdDgB87QQTMyw1PaPrT
        Rh2hUDAzhLUTQwY/D7q1TaI=
X-Google-Smtp-Source: ABdhPJx/6UZchU4OJqxY2tvT2eli1u94pvJZRHJJdINdB6SatpJ2kqxPJiiPkn1ttDuNKKFU5dXzEQ==
X-Received: by 2002:a7b:cc12:: with SMTP id f18mr15639078wmh.110.1607297992427;
        Sun, 06 Dec 2020 15:39:52 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id z22sm11312366wml.1.2020.12.06.15.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:39:51 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 00/19] target/mips: Boring code reordering
Date:   Mon,  7 Dec 2020 00:39:30 +0100
Message-Id: <20201206233949.3783184-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,=0D
=0D
This is not what I had plan to finish this WE but well...=0D
at least it is done, and the following series will be=0D
clearer/easier to review.=0D
=0D
There are now less dependencies on the big translate.c,=0D
and we can almost build a KVM-only binary (without TCG).=0D
=0D
Yet another very boring patch series, sorry.=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
Philippe Mathieu-Daud=C3=A9 (19):=0D
  hw/mips: Move address translation helpers to target/mips/=0D
  target/mips: Remove unused headers from translate.c=0D
  target/mips: Remove unused headers from fpu_helper.c=0D
  target/mips: Remove unused headers from cp0_helper.c=0D
  target/mips: Remove unused headers from op_helper.c=0D
  target/mips: Remove unused headers from kvm.c=0D
  target/mips: Include "exec/memattrs.h" in 'internal.h'=0D
  target/mips: Extract cpu_supports*/cpu_set* translate.c=0D
  target/mips: Move mips_cpu_add_definition() from helper.c to cpu.c=0D
  target/mips: Add !CONFIG_USER_ONLY comment after #endif=0D
  target/mips: Extract common helpers from helper.c to common_helper.c=0D
  target/mips: Rename helper.c as tlb_helper.c=0D
  target/mips: Fix code style for checkpatch.pl=0D
  target/mips: Move mmu_init() functions to tlb_helper.c=0D
  target/mips: Move cpu definitions, reset() and realize() to cpu.c=0D
  target/mips: Inline cpu_mips_realize_env() in mips_cpu_realizefn()=0D
  target/mips: Rename translate_init.c as cpu-defs.c=0D
  target/mips: Restrict some TCG specific CPUClass handlers=0D
  target/mips: Only build TCG code when CONFIG_TCG is set=0D
=0D
 include/hw/mips/cpudevs.h                     |   7 -=0D
 target/mips/cpu.h                             |   8 +=0D
 target/mips/internal.h                        |   6 +-=0D
 hw/mips/boston.c                              |   1 -=0D
 {hw =3D> target}/mips/addr.c                    |   2 +-=0D
 target/mips/common_helper.c                   | 178 ++++++++++=0D
 target/mips/cp0_helper.c                      |   4 +-=0D
 target/mips/cpu.c                             | 309 +++++++++++++++++-=0D
 target/mips/fpu_helper.c                      |   4 -=0D
 target/mips/kvm.c                             |   3 -=0D
 target/mips/op_helper.c                       |   4 -=0D
 target/mips/{helper.c =3D> tlb_helper.c}        | 244 +++-----------=0D
 target/mips/translate.c                       | 262 ---------------=0D
 hw/mips/meson.build                           |   2 +-=0D
 .../{translate_init.c.inc =3D> cpu-defs.c.inc}  |  57 ----=0D
 target/mips/meson.build                       |  10 +-=0D
 16 files changed, 556 insertions(+), 545 deletions(-)=0D
 rename {hw =3D> target}/mips/addr.c (98%)=0D
 create mode 100644 target/mips/common_helper.c=0D
 rename target/mips/{helper.c =3D> tlb_helper.c} (89%)=0D
 rename target/mips/{translate_init.c.inc =3D> cpu-defs.c.inc} (96%)=0D
=0D
-- =0D
2.26.2=0D
=0D

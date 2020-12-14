Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638682D9F50
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408902AbgLNSis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408880AbgLNSiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:38:23 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A91C0613D6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:37:43 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r7so17447868wrc.5
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AG2rQ9Qtoq4dN1hxG3H/JYpJcOn2clPmULTzCCQTdSg=;
        b=dofAUxB8rl9deqttLdM9wJfdeOk+uMF9M+K33hBsYpo6ml/65Tvhhrx/vtw3QNHAMr
         wSHc6Q39uT6NgKHt6Z6400LcxQETiWX1FW2d0qESbGYMMR86dXK8xVcKc3da0RPmibJR
         Cft0X489fWZYC/kOlyTFkay+KSGwphpCPV7N9LIl/yWbPhdZZOxCdnJVliQ8BWgfQbbj
         mlOIg/YOIAnZFdrcEWMRDwaz1PBl4/KAq1BJzZK8k19847lFj0+KnTvIDxMZDxoYkNEA
         aTChfn07kynPe6FJ1On4KKkkAnMGA4Ceo3KLPvL4Z/kGzMMDbHCTfnLesTe5xdA8XHFA
         0d8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=AG2rQ9Qtoq4dN1hxG3H/JYpJcOn2clPmULTzCCQTdSg=;
        b=CBoAsxBjrQTbftxxulbuu4YTekQ06Tym3PgA0JtkSEei4B97mfbYxervnDzTkHOQ3g
         t+YcqOeemuRfUFg6q8fJO+ghVF/1qlWWhPReCvx3kADIfm5xOtCpjny2D2BEm33BEsQb
         1nqKTUEAO3eIsmFFNgr2llQNBE/7uZKHkcY51ll68AXYbGcQyxypP8M8sTjvDpTc4xL5
         0QUKzhvEt7uHQAy/1qxZbT2H4Y5dEV+Q2i5P4iRBd3C2hlx8q0dpbhZljVfUjJlTIWAx
         DRu1It6RujauClq+wL7KX6v0vczKbsNOeyqEUmL/uOurguCQPN6LcA0Oa8FUs8SlPTe1
         Tzlw==
X-Gm-Message-State: AOAM530MJ1SWSqAwZNRAUeLvTlYSyFarcFOl5PTMcNHU5Jby+EFzVrhK
        /FZme8ASJ6f1nO8JqcoMlmM7huL+GrI=
X-Google-Smtp-Source: ABdhPJyGIAR0xFDE405UQS33tC5brIhj4plOxCsmIutdMpwyktpCHuGbf+AeTk8Lgn6viqQ6dVnD1g==
X-Received: by 2002:adf:fe05:: with SMTP id n5mr22567213wrr.9.1607971062134;
        Mon, 14 Dec 2020 10:37:42 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v11sm3413358wrt.25.2020.12.14.10.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:37:41 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 00/16] target/mips: Boring code reordering + add "translate.h"
Date:   Mon, 14 Dec 2020 19:37:23 +0100
Message-Id: <20201214183739.500368-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,=0D
=0D
This series contains the patches previously sent in "Boring code=0D
reordering" [1] and "Add translate.h and fpu_translate.h headers"=0D
[2]. I removed the patches merged and addressed Richard review=0D
comments.=0D
=0D
Missing review: 1 3-5 9-11 14 15=0D
=0D
Available as:=0D
  https://gitlab.com/philmd/qemu/-/commits/refactor_translate_h=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
Based-on: https://gitlab.com/philmd/qemu.git tags/mips-next=0D
Supersedes: <20201206233949.3783184-1-f4bug@amsat.org>=0D
Supersedes: <20201207235539.4070364-1-f4bug@amsat.org>=0D
=0D
[1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg764551.html=0D
[2] https://www.mail-archive.com/qemu-devel@nongnu.org/msg764828.html=0D
=0D
Philippe Mathieu-Daud=C3=A9 (16):=0D
  target/mips: Inline cpu_state_reset() in mips_cpu_reset()=0D
  target/mips: Extract FPU helpers to 'fpu_helper.h'=0D
  target/mips: Add !CONFIG_USER_ONLY comment after #endif=0D
  target/mips: Remove consecutive CONFIG_USER_ONLY ifdefs=0D
  target/mips: Extract common helpers from helper.c to common_helper.c=0D
  target/mips: Rename helper.c as tlb_helper.c=0D
  target/mips: Fix code style for checkpatch.pl=0D
  target/mips: Move mmu_init() functions to tlb_helper.c=0D
  target/mips: Rename translate_init.c as cpu-defs.c=0D
  target/mips: Replace gen_exception_err(err=3D0) by gen_exception_end()=0D
  target/mips: Replace gen_exception_end(EXCP_RI) by=0D
    gen_rsvd_instruction=0D
  target/mips/translate: Extract DisasContext structure=0D
  target/mips/translate: Add declarations for generic code=0D
  target/mips: Declare generic FPU functions in 'translate.h'=0D
  target/mips: Extract FPU specific definitions to translate.h=0D
  target/mips: Only build TCG code when CONFIG_TCG is set=0D
=0D
 target/mips/fpu_helper.h                      |  59 ++=0D
 target/mips/internal.h                        |  52 +-=0D
 target/mips/translate.h                       | 166 ++++=0D
 linux-user/mips/cpu_loop.c                    |   1 +=0D
 target/mips/cpu.c                             | 243 ++++-=0D
 target/mips/fpu_helper.c                      |   1 +=0D
 target/mips/gdbstub.c                         |   1 +=0D
 target/mips/kvm.c                             |   1 +=0D
 target/mips/machine.c                         |   1 +=0D
 target/mips/msa_helper.c                      |   1 +=0D
 target/mips/op_helper.c                       |   2 +-=0D
 target/mips/{helper.c =3D> tlb_helper.c}        | 260 ++---=0D
 target/mips/translate.c                       | 897 ++++++++----------=0D
 .../{translate_init.c.inc =3D> cpu-defs.c.inc}  |  50 +-=0D
 target/mips/meson.build                       |  10 +-=0D
 15 files changed, 903 insertions(+), 842 deletions(-)=0D
 create mode 100644 target/mips/fpu_helper.h=0D
 create mode 100644 target/mips/translate.h=0D
 rename target/mips/{helper.c =3D> tlb_helper.c} (87%)=0D
 rename target/mips/{translate_init.c.inc =3D> cpu-defs.c.inc} (96%)=0D
=0D
-- =0D
2.26.2=0D
=0D

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1122DB6B5
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 23:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgLOW6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgLOW6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:58:42 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBC5C0613D3
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:01 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id j22so12047630eja.13
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XTmTU+I/QeMhja7w9GBCfSdZSiPSigvZOhS987dRJBo=;
        b=oLimqBnxuZ+ao84nN51By9sR65R1eDdf2BZhI5VRg1r+POA1uoJ4yBdwG1eJAvQFZy
         FFr5DVpTqFA0XzgvL2eMlOiyF/VKAZNEHVsK3EYX7AyjtPCDvlL9qeAsSZXVv8aT1RPt
         75HXpCGE1FFe4NRbNP64DXn8giZvtzdbmSJEy5BZNxIpJzJQWUjBA14GanuHOx0SsjAs
         tYu0auLQhExF1bItOUkAFFBv2uYsP60I//0Dc6jeIFr5ms02vzHi32TvIMbhTMLW4OLC
         rkSo8PheSiJs7KHdCw7+vdTnfg9yTZMK1uzI6885ZRZjZD+C7eyjIYm7hvdx61mKGVB0
         uylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=XTmTU+I/QeMhja7w9GBCfSdZSiPSigvZOhS987dRJBo=;
        b=PYfUibu5YeH5JLkkPrPuI0pW1YuaCFPVWV8vlY7msyVZ/8FDmJBnP6Ar+6xayJEZBh
         vpObczgXqVVLFSro3kdgJ2KPW7tEzVOk/fhUGpLxC6m4bw4DQrFFjG6c1JtNX2xIQZKZ
         2tGTmMVZKP0INS0RyszO+JN1YqOS4K9fFhLj3I34RoQJBxa0GHoPzPvJ5Wn1h0BYpVcO
         j/LzEXREEhD9ZCaw3PQzXG+u9z7xQd+ZBRZNRwtwm9oDW+PvMH5QSCMdqE+ivWCXaDjY
         OlRJzFIi1s6YtV41ZrQoZjQdox1o0VGLUiSfNZZWXLZtzUOcD+8k1lEcKXs0JxhZuqdN
         TO4Q==
X-Gm-Message-State: AOAM531YCuAZHhqeetoPrJ/hy+XxDe1AmnURIBMPPhEqbrNMew4yZWnU
        Yx2Ammrk+nchSpeKUrzbYt6kP8i3WVQMsQ==
X-Google-Smtp-Source: ABdhPJwyuY0SMLuZ8mv7Kg7MS1wODirFHVtTRpqubaTxWcwvu6I18YNN2a8WCyVz7eRcENkMSDW5Xw==
X-Received: by 2002:a17:906:e8b:: with SMTP id p11mr18861695ejf.92.1608073080221;
        Tue, 15 Dec 2020 14:58:00 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id o13sm19168231edr.94.2020.12.15.14.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:57:59 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v2 00/24] target/mips: Convert MSA ASE to decodetree
Date:   Tue, 15 Dec 2020 23:57:33 +0100
Message-Id: <20201215225757.764263-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Missing review: 1-3 14 17 19-24=0D
=0D
Since v1:=0D
- rebased=0D
- addressed Richard review comments=0D
- reworded some commit descriptions=0D
- avoid 64-bit ifdef'ry=0D
=0D
Finally, we use decodetree with the MIPS target.=0D
=0D
Starting easy with the MSA ASE. 2700+ lines extracted=0D
from helper.h and translate.c, now built as an new=0D
object: mod-msa_translate.o.=0D
=0D
Phil.=0D
=0D
Available:=0D
  https://gitlab.com/philmd/qemu/-/commits/mips_msa_decodetree_v2=0D
=0D
Based-on: <20201214183739.500368-1-f4bug@amsat.org>=0D
=0D
Philippe Mathieu-Daud=C3=A9 (24):=0D
  target/mips/translate: Extract decode_opc_legacy() from decode_opc()=0D
  target/mips/translate: Expose check_mips_64() to 32-bit mode=0D
  target/mips/cpu: Introduce isa_rel6_available() helper=0D
  target/mips: Introduce ase_msa_available() helper=0D
  target/mips: Simplify msa_reset()=0D
  target/mips: Use CP0_Config3 to set MIPS_HFLAG_MSA=0D
  target/mips: Simplify MSA TCG logic=0D
  target/mips: Remove now unused ASE_MSA definition=0D
  target/mips: Alias MSA vector registers on FPU scalar registers=0D
  target/mips: Extract msa_translate_init() from mips_tcg_init()=0D
  target/mips: Remove CPUMIPSState* argument from gen_msa*() methods=0D
  target/mips: Explode gen_msa_branch() as gen_msa_BxZ_V/BxZ()=0D
  target/mips: Rename msa_helper.c as mod-msa_helper.c=0D
  target/mips: Move msa_reset() to mod-msa_helper.c=0D
  target/mips: Extract MSA helpers from op_helper.c=0D
  target/mips: Extract MSA helper definitions=0D
  target/mips: Declare gen_msa/_branch() in 'translate.h'=0D
  target/mips: Extract MSA translation routines=0D
  target/mips: Introduce decode tree bindings for MSA opcodes=0D
  target/mips: Use decode_ase_msa() generated from decodetree=0D
  target/mips: Extract LSA/DLSA translation generators=0D
  target/mips: Introduce decodetree helpers for MSA LSA/DLSA opcodes=0D
  target/mips: Introduce decodetree helpers for Release6 LSA/DLSA=0D
    opcodes=0D
  target/mips/mod-msa: Pass TCGCond argument to gen_check_zero_element()=0D
=0D
 target/mips/cpu.h                             |    7 +=0D
 target/mips/helper.h                          |  436 +--=0D
 target/mips/internal.h                        |    4 +-=0D
 target/mips/mips-defs.h                       |    1 -=0D
 target/mips/translate.h                       |   25 +-=0D
 target/mips/isa-mips32r6.decode               |   17 +=0D
 target/mips/isa-mips64r6.decode               |   17 +=0D
 target/mips/mod-msa32.decode                  |   28 +=0D
 target/mips/mod-msa64.decode                  |   17 +=0D
 target/mips/cpu.c                             |   14 +-=0D
 target/mips/isa-mips_rel6_translate.c         |   37 +=0D
 target/mips/kvm.c                             |   12 +-=0D
 .../mips/{msa_helper.c =3D> mod-msa_helper.c}   |  429 +++=0D
 target/mips/mod-msa_translate.c               | 2286 ++++++++++++++++=0D
 target/mips/op_helper.c                       |  394 ---=0D
 target/mips/translate.c                       | 2352 +----------------=0D
 target/mips/translate_addr_const.c            |   52 +=0D
 target/mips/cpu-defs.c.inc                    |   40 +-=0D
 target/mips/meson.build                       |   14 +-=0D
 target/mips/mod-msa_helper.h.inc              |  443 ++++=0D
 20 files changed, 3437 insertions(+), 3188 deletions(-)=0D
 create mode 100644 target/mips/isa-mips32r6.decode=0D
 create mode 100644 target/mips/isa-mips64r6.decode=0D
 create mode 100644 target/mips/mod-msa32.decode=0D
 create mode 100644 target/mips/mod-msa64.decode=0D
 create mode 100644 target/mips/isa-mips_rel6_translate.c=0D
 rename target/mips/{msa_helper.c =3D> mod-msa_helper.c} (93%)=0D
 create mode 100644 target/mips/mod-msa_translate.c=0D
 create mode 100644 target/mips/translate_addr_const.c=0D
 create mode 100644 target/mips/mod-msa_helper.h.inc=0D
=0D
-- =0D
2.26.2=0D
=0D

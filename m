Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A142D1F0F
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgLHAhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgLHAhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:37:46 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5325CC06179C
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:06 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id f23so22197487ejk.2
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OWgkzaBL8Ks+W5c6hc//5jS9TAtR2BEXueICNpeXGzI=;
        b=dA3Jz1COIag7v1M7puPMdmwoXec5vp17JFsARrNCqYYWr9GEeAr97x4gvDHoEiUlRs
         61h7Vg50DmSQ25pu5RCo7FN4NlIixt75Dmh8aQCiiWYnU1GHti7ElSExMxy6xDh+YTTC
         0tUsR/1rk4BaEvtM4zpttMWb45vyR+RNfOsdA1yP6WuwRKk5+lrenQkpCkjuY3N2Gi1s
         VlnHCQBoRusSlPaQ6DnxhDFoTZJd46+WbYFizK7IRLMJld4kiQ1NzI+fKO/CY8/zFxHZ
         RVEK47YWVx6sSNuxdnrlY1ilkxemJKEwCSpwKP7wQamiBixRgdzEd8/6o/j2UqvlXJqP
         rw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=OWgkzaBL8Ks+W5c6hc//5jS9TAtR2BEXueICNpeXGzI=;
        b=E6nvlEG77qvjL6WnKOZamkPlCpq+IdWXJYppfpGslCNG2N6ZH8K6Zmg+2/yyex0g/Q
         RCnSSYVuB1bgbTleV1cHjq9yfD3oZMCI/fUrOOhiN6QOYozrYla1qaad7pu1g7XD3iWJ
         xA4z15UGdoEXrQMzjxWAnxYO0XjCRZqAnotr+0aQaGyV7RXo27Avo2DMVOUpXyw9UIj4
         9Ubcje+S6BvPAWYAh1zA4801qcexH0PHe2mJZT2dqXiT0hkTNpDV60IvMm86rSVyxy5Z
         vsNfSVXovmKFxNuhZoKfU/sCIkQoqcMVBBJXcLsY8QvbYE6QSiL5hOH3U8qWvGqfHjC9
         T1ew==
X-Gm-Message-State: AOAM531hyBO5APaedbJAXoQfnP3yZivUjyx0fgDp37FklkYNJMlFcHbb
        dyFL1r0agM7IRhYDs41JsS8=
X-Google-Smtp-Source: ABdhPJyOLT7IrJOkvySteoCMLX7D7ldLNTWfL3J3pXoTi91sQP7BLNIp4IPEJBTN7t8ugtAPLoMvIQ==
X-Received: by 2002:a17:906:b74b:: with SMTP id fx11mr21056135ejb.410.1607387825097;
        Mon, 07 Dec 2020 16:37:05 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id mb15sm13785560ejb.9.2020.12.07.16.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:04 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 00/17] target/mips: Convert MSA ASE to decodetree
Date:   Tue,  8 Dec 2020 01:36:45 +0100
Message-Id: <20201208003702.4088927-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Finally, we use decodetree with the MIPS target.=0D
=0D
Starting easy with the MSA ASE. 2700+ lines extracted=0D
from helper.h and translate.c, now built as an new=0D
object: mod-msa_translate.o.=0D
=0D
While the diff stat is positive by 86 lines, we actually=0D
(re)moved code, but added (C) notices.=0D
=0D
The most interesting patches are the 2 last ones.=0D
=0D
Please review,=0D
=0D
Phil.=0D
=0D
Based-on: <20201207224335.4030582-1-f4bug@amsat.org>=0D
(linux-user: Rework get_elf_hwcap() and support MIPS Loongson 2F/3A)=0D
Based-on: <20201207235539.4070364-1-f4bug@amsat.org>=0D
(target/mips: Add translate.h and fpu_translate.h headers)=0D
=0D
Philippe Mathieu-Daud=C3=A9 (17):=0D
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
  target/mips: Use decode_msa32() generated from decodetree=0D
=0D
 target/mips/cpu.h                             |    6 +=0D
 target/mips/fpu_translate.h                   |   10 -=0D
 target/mips/helper.h                          |  436 +---=0D
 target/mips/internal.h                        |    4 +-=0D
 target/mips/mips-defs.h                       |    1 -=0D
 target/mips/translate.h                       |    4 +=0D
 target/mips/mod-msa32.decode                  |   24 +=0D
 target/mips/kvm.c                             |   12 +-=0D
 .../mips/{msa_helper.c =3D> mod-msa_helper.c}   |  429 ++++=0D
 target/mips/mod-msa_translate.c               | 2270 +++++++++++++++++=0D
 target/mips/op_helper.c                       |  394 ---=0D
 target/mips/translate.c                       | 2264 +---------------=0D
 target/mips/meson.build                       |    9 +-=0D
 target/mips/mod-msa_helper.h.inc              |  443 ++++=0D
 target/mips/translate_init.c.inc              |   38 +-=0D
 15 files changed, 3215 insertions(+), 3129 deletions(-)=0D
 create mode 100644 target/mips/mod-msa32.decode=0D
 rename target/mips/{msa_helper.c =3D> mod-msa_helper.c} (93%)=0D
 create mode 100644 target/mips/mod-msa_translate.c=0D
 create mode 100644 target/mips/mod-msa_helper.h.inc=0D
=0D
-- =0D
2.26.2=0D
=0D

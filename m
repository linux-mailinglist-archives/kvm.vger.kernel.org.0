Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4DD2D1E9F
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgLGX4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbgLGX4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:56:23 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E9AC061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:55:42 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id bo9so21976774ejb.13
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kzl0AALsmS8BSI2s1yWwb1eTTjeSxRukzNssdVVqA8I=;
        b=PN/ZQBXNMBzJU80aKISghDI5zOgu9bkTExQbUVp9TffgV4DSdh8Gm0j09upPo7OVfV
         QIQVYYkLya7Whmg74erX1jwfvODegvzHQ+IDK2F+7S4yvyvKHrHSW7MFE+v8iRDgwrBb
         qEvRmCnLAN6FJERQwnSiTOyMnvUYPhvyg3Ii9Q/ZrFVJcG8cN8NINRsYfLuD3N0Dg+1A
         17FM47FM1HcYrdAg6PATgIKW/Xj4wFpfEDQ8J3wFWbROIxSUlwuDQIgmFz6ecTQ6jZK4
         UilqtuW3YV6B7gOEml3D5jC06nYF/busfgH4b+UHzdshegdwbUzH0sq7yjbWBEGLdjGl
         SPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Kzl0AALsmS8BSI2s1yWwb1eTTjeSxRukzNssdVVqA8I=;
        b=oeNYtIy7zd6kfCZPkcn9fAU+GY0/8E06JUryD416vM11PRK0AjDOag9LhZ9Koa3Ecg
         baMSgaVaP8emGd40Ye8HpJGwlumvZ3qBy3zqEuFyVC50cY1MmD0A8oX6w/RBUBojf8i6
         m/8SKPyDuP3xlJJBOPKB2S1BIkFON6ZamSUTY7A43cNyqiqQeF/g7+LbowdK0bIHhp8a
         MWaAhh6iqmYlWfR4s2H09YRuLFaNgpNAaDvFN742XQhVD38Ew7XwxLd9wS/ktkd3x2K6
         H/79E3ChgWC3XoeYqETkXWiF9ZZiIKvzVxciF/jivGOpqot5vJ2qU6qsN6JJbuON+OXL
         /eXw==
X-Gm-Message-State: AOAM532FE4sHdIuVxuP4fBE+o8fqbynbwibHwo5oyNjK40tB8VwmLcig
        ubwVy1zDFm3qGMQLyWwl2TbHfTb1Z2c=
X-Google-Smtp-Source: ABdhPJzVOcw+tUDWczT7m8MPPc4QIS0c7OXNkIN6I3lbJUhs0wn/J5cPJB+VnQLTpOm6ehLZyXX/7A==
X-Received: by 2002:a17:906:1945:: with SMTP id b5mr22157491eje.388.1607385341622;
        Mon, 07 Dec 2020 15:55:41 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id dd18sm13785298ejb.53.2020.12.07.15.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:55:40 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 0/7] target/mips: Add translate.h and fpu_translate.h headers
Date:   Tue,  8 Dec 2020 00:55:32 +0100
Message-Id: <20201207235539.4070364-1-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the 'extract MSA' series keep growing, yet another=0D
preliminary series.=0D
=0D
Basically we add declarations for everything that will=0D
be reused by code extracted from the big translate.c.=0D
=0D
Doing so now, we avoid the intermediate step of using=0D
.c.inc files, and we compile as different objects.=0D
(We would have to do this later anyway).=0D
Slower, as it involve more series, but we can bisect.=0D
=0D
This series is common to the other 'extract XYZ from=0D
translate.c' series.=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
Based-on: mips-next (https://gitlab.com/philmd/qemu/-/tree/mips-next)=0D
=0D
Philippe Mathieu-Daud=C3=A9 (7):=0D
  target/mips/translate: Extract DisasContext structure=0D
  target/mips/translate: Add declarations for generic code=0D
  target/mips: Use FloatRoundMode enum for FCR31 modes conversion=0D
  target/mips: Extract FPU helpers to 'fpu_helper.h'=0D
  target/mips/fpu_helper: Remove unused headers=0D
  target/mips: Declare generic FPU functions in 'fpu_translate.h'=0D
  target/mips: Extract FPU specific definitions to fpu_translate.h=0D
=0D
 target/mips/fpu_helper.h    |  59 +++++++++++++=0D
 target/mips/fpu_translate.h |  96 +++++++++++++++++++++=0D
 target/mips/internal.h      |  49 -----------=0D
 target/mips/translate.h     |  83 ++++++++++++++++++=0D
 linux-user/mips/cpu_loop.c  |   1 +=0D
 target/mips/fpu_helper.c    |   7 +-=0D
 target/mips/gdbstub.c       |   1 +=0D
 target/mips/kvm.c           |   1 +=0D
 target/mips/machine.c       |   1 +=0D
 target/mips/msa_helper.c    |   1 +=0D
 target/mips/op_helper.c     |   1 +=0D
 target/mips/translate.c     | 163 +++++-------------------------------=0D
 12 files changed, 267 insertions(+), 196 deletions(-)=0D
 create mode 100644 target/mips/fpu_helper.h=0D
 create mode 100644 target/mips/fpu_translate.h=0D
 create mode 100644 target/mips/translate.h=0D
=0D
-- =0D
2.26.2=0D
=0D

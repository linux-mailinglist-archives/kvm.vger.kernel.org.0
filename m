Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AA838ADA2
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbhETMKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239809AbhETMJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:09:56 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BB0C01CEBA;
        Thu, 20 May 2021 03:44:23 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d16so12036244pfn.12;
        Thu, 20 May 2021 03:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ln/GNcNq5Ro2OkNEh/LM02ElmNPWJ/3MY9XfiUntdlc=;
        b=C6COQJUoHVx1FUvpa/Y1+fgwUD5eOuVSngTVZKQOjmbeC5IMKGBGpirqwdq+yh6upP
         AAaOuC+kLKQtVyi05CWflFO1z5s11+7IHT3F0e0/Vo0zvqZDWUcE7XoXicuK9f+kQXI5
         opcyMD5UHfWrvGvjmkB6YUwXTFX5sNPzXPQil7/dwuPVpnLbdAMMDaTw7Z8VdnTP3cnr
         gPvwGl7MmoMV61feZJCu26gtXthY5ipd/i0Tl3FEle/ftQ+/Fhf5SsUBLwdZTWj+SfDS
         NcK0JqDQfoe+MGWgaYnFTpZLh2TY87+u5TXIm5qcqaBU76RLN4Pw9IsQd2P7NRzjfZdD
         NReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ln/GNcNq5Ro2OkNEh/LM02ElmNPWJ/3MY9XfiUntdlc=;
        b=t+8fwuE2JOOzIy12DLAYid1D+3vC34CtOQBI2JDrRr5EKiyKPBltwK9cABGZuZF8HS
         tDNmb7Hl6aBxOxaNEtnD05ppPYhZ0EvuRA+SZWiobTDzDggDuX/wilBM2YH3FLVn8qz5
         7pKjAbjYKP5gP2uLeKdWNKemzEUrtrgM05I1OXn1rPqNla9xUjUgDk5NPCacu6qHRPz5
         RXIxEuXAB5OM79p24c7wbl45PxnO3g1N/mPTv95sI7Ka+dJo4Ph73HJdk9wMJWy3aqoJ
         oC2iHbip/dJIXhhIj4/03r4CZg8zcE3kfkSgL/uR0g6mYtEDB/pVw+GpEVXy1aLezXKV
         qSrw==
X-Gm-Message-State: AOAM530NB2+a+oL6rG1YpNvdi9VHZ9P7FAlpIG/4Vcc336gtKrn12tyc
        7sdYoBgmE2PJ4HfNjuRESeM=
X-Google-Smtp-Source: ABdhPJyPJkh+woUNcvvPhjV9BLZHjDX9cfefs69QBlPovPMsvgSoJkKXNt+FopPHtSuynAjN2RWamA==
X-Received: by 2002:a62:2901:0:b029:28e:ef3d:10d2 with SMTP id p1-20020a6229010000b029028eef3d10d2mr3823125pfp.45.1621507463048;
        Thu, 20 May 2021 03:44:23 -0700 (PDT)
Received: from pride.localdomain (c-174-61-140-56.hsd1.wa.comcast.net. [174.61.140.56])
        by smtp.gmail.com with ESMTPSA id z12sm1762572pfk.45.2021.05.20.03.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 03:44:22 -0700 (PDT)
From:   Joe Richey <joerichey94@gmail.com>
To:     trivial@kernel.org
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Subject: [PATCH 0/6] Don't use BIT() macro in UAPI headers
Date:   Thu, 20 May 2021 03:43:37 -0700
Message-Id: <20210520104343.317119-1-joerichey94@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joe Richey <joerichey@google.com>

The BIT(n) macro is used in the kernel as an alias for (1 << n).
However, it is not defined in the UAPI headers, which means that any
UAPI header files must be careful not to use it, or else the user
will get a linker error. For example, compiling the following program:

    #include <sys/auxv.h>
    #include <asm/hwcap2.h>

    // Detect if FSGSBASE instructions are enabled
    int main() {
        unsigned long val = getauxval(AT_HWCAP2);
        return !(val & HWCAP2_FSGSBASE);
    }

Results in the following likner error:

    /usr/bin/ld: /tmp/cceFpAdR.o: in function `main':
    gs.c:(.text+0x21): undefined reference to `BIT'

This patch series changes all UAPI uses of BIT() to just be open-coded.
However, there really should be a check for this in checkpatch.pl
Currently, the script actually _encourages_ users to use the BIT macro
even if adding things to UAPI.

Running `rg "BIT\(" **/uapi/**` shows no more usage of BIT() in any
UAPI headers. Tested by building a basic kernel. Changes are trivial.

Joe Richey (6):
  x86/elf: Don't use BIT() macro in UAPI headers
  KVM: X86: Don't use BIT() macro in UAPI headers
  drivers: firmware: psci: Don't use BIT() macro in UAPI headers
  uacce: Don't use BIT() macro in UAPI headers
  media: vicodec: Don't use BIT() macro in UAPI headers
  tools headers UAPI: Sync pkt_sched.h with the kernel sources

 arch/x86/include/uapi/asm/hwcap2.h   |   2 +-
 include/uapi/linux/kvm.h             |   4 +-
 include/uapi/linux/psci.h            |   2 +-
 include/uapi/linux/v4l2-controls.h   |  22 ++---
 include/uapi/misc/uacce/uacce.h      |   2 +-
 tools/include/uapi/linux/kvm.h       |   4 +-
 tools/include/uapi/linux/pkt_sched.h | 122 ++++++++++++++++++++++++---
 7 files changed, 130 insertions(+), 28 deletions(-)

-- 
2.31.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656F24562CB
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhKRSty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhKRSty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:49:54 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601E5C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:53 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id s13so13456022wrb.3
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XS343c0IO3niqftwP4v6K7OUkGkeIMiA5I+9ZdZYBh0=;
        b=zjCZRzmU5VCoORz9MR7qg3iHeYGB+ARqpBgEFkojvl3nOwIzmuTPU5pdKUpWT8la3D
         UGY2TfUGFT4IEnWlBAxDQbMkUvtFSzNFeJogW9rLHEt6T2HeHxTkT2xjszrOKBdtUFb9
         HDYwnutRjR2KmtByWx8sGIFQ9tOlC16XfCsOjBG34gpIOtSvCfOaLbsfTOkaX+bQWFhq
         oOgZPpjmyct9bW6VdtSvsKyWBNv6blWpTi+XmkhSew3RZDofHkbxCG/imoO5BTFK/4fA
         3w7GEk/JPKDNoNsdN20Tm53RgVUyMk9bcZUxmPoeqoX1f3rybUdDDJYupwV2fRG6wp+b
         73Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XS343c0IO3niqftwP4v6K7OUkGkeIMiA5I+9ZdZYBh0=;
        b=0kliN04tLAIez+jA93zlHI+7SHozTVovRYvjCh4rsSTCM0fal7fDsw7bG5DFiLrugq
         UlKS8Vl7hOTMsm8l3eCe7UZyUbHazRFpkfEq6D7aGM2k0sLIRC4Q4z/dm1HhdRzepUcq
         zNhjGpz47WO1v2DkSxN3fcatDWl3pPezPVbiNL75xp4uGY2avuLnIywdlFLDkis3Rl68
         usVm576pZehmJpcrRnCjB4gV0mtNK4oDJ1+zfr4wFm5tKedqF06M8VYqA3X1s7G3kwXt
         PjTah7exCubIe/wDLywKczYpT8xPgRJ4ZI2+FY527PdKT8sDq3Vn6b8SYj69HKXIG/IN
         /ywg==
X-Gm-Message-State: AOAM533e/k15/uzQ8CE4YCkwQZuhnOdGQKiqJNCvZ43hXzkDKrO3tMlu
        m8tFXMWZL85WOSGrG0XuocVTrw==
X-Google-Smtp-Source: ABdhPJw2NzXqRxesIK9jA2HRDk+2Uk6jmBQZFD0hYkGO36LMi1zQxSDYgNlrw4ejSdORJel1NMHILw==
X-Received: by 2002:adf:f012:: with SMTP id j18mr33404834wro.353.1637261211921;
        Thu, 18 Nov 2021 10:46:51 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id 8sm9332039wmg.24.2021.11.18.10.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:46:50 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 3D38D1FF96;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v8 00/10] MTTCG sanity tests for ARM
Date:   Thu, 18 Nov 2021 18:46:40 +0000
Message-Id: <20211118184650.661575-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

It's been a long time since I last posted these but I'd like to
incorporate some MTTCG tests into QEMU's upstream acceptance tests and
a first step is getting these up-streamed. Most of the changes are
fixing up the numerous checkpatch failures (although isaac remains
unchanged and some warnings make no sense for kvm-unit-tests).

I dropped an additional test which attempts to test for data flush
behaviour but it still needs some work:

  https://github.com/stsquad/kvm-unit-tests/commit/712eb3a287df24cdeff00ef966d68aef6ff2b8eb

Alex Bennée (10):
  docs: mention checkpatch in the README
  arm/flat.lds: don't drop debug during link
  Makefile: add GNU global tags support
  run_tests.sh: add --config option for alt test set
  lib: add isaac prng library from CCAN
  arm/tlbflush-code: TLB flush during code execution
  arm/locking-tests: add comprehensive locking test
  arm/barrier-litmus-tests: add simple mp and sal litmus tests
  arm/run: use separate --accel form
  arm/tcg-test: some basic TCG exercising tests

 arm/run                   |   4 +-
 run_tests.sh              |  11 +-
 Makefile                  |   5 +-
 arm/Makefile.arm          |   2 +
 arm/Makefile.arm64        |   2 +
 arm/Makefile.common       |   6 +-
 lib/arm/asm/barrier.h     |  61 ++++++
 lib/arm64/asm/barrier.h   |  50 +++++
 lib/prng.h                |  82 +++++++
 lib/prng.c                | 162 ++++++++++++++
 arm/flat.lds              |   1 -
 arm/tcg-test-asm.S        | 171 +++++++++++++++
 arm/tcg-test-asm64.S      | 170 ++++++++++++++
 arm/barrier-litmus-test.c | 450 ++++++++++++++++++++++++++++++++++++++
 arm/locking-test.c        | 322 +++++++++++++++++++++++++++
 arm/spinlock-test.c       |  87 --------
 arm/tcg-test.c            | 338 ++++++++++++++++++++++++++++
 arm/tlbflush-code.c       | 209 ++++++++++++++++++
 arm/mttcgtests.cfg        | 176 +++++++++++++++
 README.md                 |   2 +
 20 files changed, 2216 insertions(+), 95 deletions(-)
 create mode 100644 lib/prng.h
 create mode 100644 lib/prng.c
 create mode 100644 arm/tcg-test-asm.S
 create mode 100644 arm/tcg-test-asm64.S
 create mode 100644 arm/barrier-litmus-test.c
 create mode 100644 arm/locking-test.c
 delete mode 100644 arm/spinlock-test.c
 create mode 100644 arm/tcg-test.c
 create mode 100644 arm/tlbflush-code.c
 create mode 100644 arm/mttcgtests.cfg

-- 
2.30.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F71E6ADD43
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 12:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjCGL3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 06:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCGL2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 06:28:50 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7163A87B
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 03:28:47 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so10166736wmb.3
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 03:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678188526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kfSglnpBNn9ufA2bE48Fm1KqCuy3CFXTGjlu6UUQwrs=;
        b=S4H+6ccP9I7lVPvNVrT7cP5NTyYxHGhxbTuyHVYhAJVawrOyG8nXMgvmFys3ebNnBq
         bngtJezZN/wZh+sTV0OZ0biXBusrBSKnwOqGiL8Ne7Fp7Q0lsweWR7JidKkvCs5SsiRO
         KoZ45olrXeXqVirLeDveteizromLyhjZVhc56v6HiefRWkT8fidtT2rvJTVZff/aWLaU
         Wk+rJxuz9wRP8Jeo5pT8HoijeYZKMFLNQG8qmRV7DuOBFMmsnY4yZlS2OKc0+gpuWBMP
         VqLI2KNyQFejFDoeKHCOXSWarODVsn2vBUJKAH6ZixK5JD6FCX6n7YsyEzIBiFQx7136
         bwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kfSglnpBNn9ufA2bE48Fm1KqCuy3CFXTGjlu6UUQwrs=;
        b=EG70Nn/0d973ntiZJzMKRjhXdMGxofsZT/DrKSmjhzjywcb7l75JRa/Bf47z1nwCZ4
         hGw1rPIto0MKR4DyQiU4WS0uZtM6anY12xM32KulLS+L8wSDGNIFLEjfd0BNPdAP/GfA
         lHHoSAWFsGMb2jhB1gp+llcFPQE50tuExeTsq9K9tVMLNkqMZYNoOcUcH637Ry0o5+TV
         t+YZGq86Vh0EWK6WKE4upb/lqiqfd6beuI8IsiUrKBdadita5RVjA/1dGw3xumLVaIV9
         Pfe50LzwWo+ftF16WejjnzrhCtZf4/uNiu+xzvWQ5EvNGgOEuGZ+aoKgPcWLPfQ/hcC5
         ALyw==
X-Gm-Message-State: AO0yUKVNzJ/g0Bsv3uC5ZfQGMcr/7mob6RYV53pGdH8y8PgyPGglZF75
        A0H9u5yKJbNbFde0C0NnVKYs/Q==
X-Google-Smtp-Source: AK7set+T1Pst0DnK4EjtQJNnqDEk2vblrvArfmuuy5f/wc+IDQ13UHyHQsZKH6slzFOJWxg9s613iQ==
X-Received: by 2002:a05:600c:3d18:b0:3eb:98aa:54cd with SMTP id bh24-20020a05600c3d1800b003eb98aa54cdmr8661502wmb.17.1678188526395;
        Tue, 07 Mar 2023 03:28:46 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id bi25-20020a05600c3d9900b003e89e3284fasm16533357wmb.36.2023.03.07.03.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:28:45 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 88A981FFB7;
        Tue,  7 Mar 2023 11:28:45 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v10 0/7] MTTCG sanity tests for ARM
Date:   Tue,  7 Mar 2023 11:28:38 +0000
Message-Id: <20230307112845.452053-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I last had a go at getting these up-streamed at the end of 2021 so
its probably worth having another go. From the last iteration a
number of the groundwork patches did get merged:

  Subject: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
  Date: Thu,  2 Dec 2021 11:53:43 +0000
  Message-Id: <20211202115352.951548-1-alex.bennee@linaro.org>

So this leaves a minor gtags patch, adding the isaac RNG library which
would also be useful for other users, see:

  Subject: [kvm-unit-tests PATCH v3 11/27] lib: Add random number generator
  Date: Tue, 22 Nov 2022 18:11:36 +0200
  Message-Id: <20221122161152.293072-12-mlevitsk@redhat.com>

Otherwise there are a few minor checkpatch tweaks.

I would still like to enable KVM unit tests inside QEMU as things like
the x86 APIC tests are probably a better fit for unit testing TCG
emulation than booting a whole OS with various APICs enabled.

Alex Bennée (7):
  Makefile: add GNU global tags support
  add .gitpublish metadata
  lib: add isaac prng library from CCAN
  arm/tlbflush-code: TLB flush during code execution
  arm/locking-tests: add comprehensive locking test
  arm/barrier-litmus-tests: add simple mp and sal litmus tests
  arm/tcg-test: some basic TCG exercising tests

 Makefile                  |   5 +-
 arm/Makefile.arm          |   2 +
 arm/Makefile.arm64        |   2 +
 arm/Makefile.common       |   6 +-
 lib/arm/asm/barrier.h     |  19 ++
 lib/arm64/asm/barrier.h   |  50 +++++
 lib/prng.h                |  83 +++++++
 lib/prng.c                | 163 ++++++++++++++
 arm/tcg-test-asm.S        | 171 +++++++++++++++
 arm/tcg-test-asm64.S      | 170 ++++++++++++++
 arm/barrier-litmus-test.c | 450 ++++++++++++++++++++++++++++++++++++++
 arm/locking-test.c        | 321 +++++++++++++++++++++++++++
 arm/spinlock-test.c       |  87 --------
 arm/tcg-test.c            | 340 ++++++++++++++++++++++++++++
 arm/tlbflush-code.c       | 209 ++++++++++++++++++
 arm/unittests.cfg         | 170 ++++++++++++++
 .gitignore                |   3 +
 .gitpublish               |  18 ++
 18 files changed, 2180 insertions(+), 89 deletions(-)
 create mode 100644 lib/prng.h
 create mode 100644 lib/prng.c
 create mode 100644 arm/tcg-test-asm.S
 create mode 100644 arm/tcg-test-asm64.S
 create mode 100644 arm/barrier-litmus-test.c
 create mode 100644 arm/locking-test.c
 delete mode 100644 arm/spinlock-test.c
 create mode 100644 arm/tcg-test.c
 create mode 100644 arm/tlbflush-code.c
 create mode 100644 .gitpublish

-- 
2.39.2


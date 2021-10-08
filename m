Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962DE427301
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 23:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243439AbhJHV0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 17:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243433AbhJHV0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 17:26:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB5C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 14:24:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 41-20020a17090a0fac00b00195a5a61ab8so6373959pjz.3
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 14:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ma1G3yGfaQwfzT4pbSLujND+YT1njLJT4i1NWl2m96k=;
        b=YpdwbxBSlHG2gZaIJ7ZyLLppum7LpYnksIfaL1nL1ztYmaJP9z7r6h1Jwoy/nZKyoE
         K0pvNtpfrm7ufN+YHhE3LjMx/2grUdWvvj6bYqGsncamqbldJqoycM6PPNVcS/pN61jE
         3TeX/UGcdXiJEcjUTN0pGE1IEfhiYnkA5HsXeCdPBHB2dUvaU928vdLZ/+JfzizKyqKk
         rlRGUf4En3q+9wv7A31D5QMeRaZRwd6Q6YQrQRVWf1DJyMYWi4bvc7sijA0X3LbtEwxg
         kO3VRqlpiswMdZjJAheGH6x4xtkdwjJojsKa3HFkUuaBPHg2KEMa0F/QXEO3tNruvD8g
         s2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ma1G3yGfaQwfzT4pbSLujND+YT1njLJT4i1NWl2m96k=;
        b=8Imrc2S9SaaEkDXd6NpgJJThMMe7sx6RZZL19uEw6NgDEOKWKwh9O0+N+36uvqoTnL
         ouACOLyHNcwc/TCAiI+4FsQB1m0sx9tnAP7Vejz2y8f0YmDGrx4t+oDrHWXp8Ug5AA1u
         MUmY2IhpKWwXqR9WsUlseExjFd7JN+DQ9cZH5RGzA3jVIaSEnKSSa7lrCk03vaDLjEt0
         2foGYBJjzNT9GeB/f40kS/Af/HldbxlIVI4tbT4TsW9/VywgiQBX4pfVXC6zrVCX39DN
         o1Ri1s8O1M7muuozU9oHQaQ4VyQGBhbfaduhWiyags1jcneqWTdkW7/Wz77N0WWCVEJd
         Z0fw==
X-Gm-Message-State: AOAM533sL8ne0H0YW0b+10b+GCeIciYJVUr4P4WMXqOL5einmfCSK4rc
        jA6Bki7EEVs9uoRT9TVCQ86AzD+T5c2XUa/i8QUFmR/tOWKsQzY1HGwuUJfgl6KZYp0rirR9W1Y
        /L6sC7b/DPEjM36ZN2OQTuADHc0Yp+D6zl0HKSRQ/6uaIUh8as52VL0kaB8311rM=
X-Google-Smtp-Source: ABdhPJz0kzEDmGHP0GCMC0gqYcmwmyOccAe2JAyUdO4mkMAFc5scMGA1f2yryNQ3uCYB4y6MBZ1Aypq7nlA0Kg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:a38b:b0:13d:9c41:92ec with SMTP
 id x11-20020a170902a38b00b0013d9c4192ecmr11787785pla.39.1633728295821; Fri,
 08 Oct 2021 14:24:55 -0700 (PDT)
Date:   Fri,  8 Oct 2021 14:24:44 -0700
Message-Id: <20211008212447.2055660-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [kvm-unit-tests PATCH 0/3] Regression test for L1 LDTR persistence bug
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In Linux commit afc8de0118be ("KVM: nVMX: Set LDTR to its
architecturally defined value on nested VM-Exit"), Sean suggested that
this bug was likely benign, but it turns out that--for us, at
least--it can result in live migration failures. On restore, we call
KVM_SET_SREGS before KVM_SET_NESTED_STATE, so when L2 is active at the
time of save/restore, the target vmcs01 is temporarily populated with
L2 values. Hence, the LDTR visible to L1 after the next emulated
VM-exit is L2's, rather than its own.

This issue is significant enough that it warrants a regression
test. Unfortunately, at the moment, the best we can do is check for
the LDTR persistence bug. I'd like to be able to trigger a
save/restore from within the L2 guest, but AFAICT, there's no way to
do that under qemu. Does anyone want to implement a qemu ISA test
device that triggers a save/restore when its configured I/O port is
written to?

Jim Mattson (3):
  x86: Fix operand size for lldt
  x86: Make set_gdt_entry usable in 64-bit mode
  x86: Add a regression test for L1 LDTR persistence bug

 lib/x86/desc.c      | 41 +++++++++++++++++++++++++++++++----------
 lib/x86/desc.h      |  3 ++-
 lib/x86/processor.h |  2 +-
 x86/cstart64.S      |  1 +
 x86/vmx_tests.c     | 39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 74 insertions(+), 12 deletions(-)

-- 
2.33.0.882.g93a45727a2-goog


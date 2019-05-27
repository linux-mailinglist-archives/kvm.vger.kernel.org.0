Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B5D2B26B
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 12:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfE0Kqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 06:46:45 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34450 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfE0Kqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 06:46:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id h2so5853694pgg.1
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 03:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YULeuaw6Jc86bWQlKIn+WYEbp/WlRteTq6uuOLuLmgE=;
        b=gnPHGGvc3H5whBiSLcsGnQAPbOAcnvtQRKdl/vtEacTw2uoUUb55Z/1g33VtJeM8f7
         Dny7JXEXAA4aTNuVqnZlSWTPyE2raU1rCEWDAClUzECIt2Pr1zeK+MjRTxueCrHE6N2g
         OBivMwsMQrV/ahBijej/AkRweU/BSjVJ6KCEKALUsbFedxkrN8n7MUgKIcNh2lkmUcHH
         xE/+M7M5uBSDGzYLMhyYYkDOxXgA8f5LDhaNsVnn7ak0ZS05zgNYQ0C9Waqiy3kOnSVp
         XLZWxTVybRQmvLsfd5nvSleX/qTywlAKqEq6SwemuXtOujyncAUx0pf73ZS0UPoBctu7
         u8+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YULeuaw6Jc86bWQlKIn+WYEbp/WlRteTq6uuOLuLmgE=;
        b=XVPsALNAApnEAIlQbGEDG6bvcWhE7Xig+5B2iNESiJZA4+IozBjtuk+3AjGPBvAvNU
         myXVZVxkKvLwuuDXuey9db41pWD8DYy4ELIL89aixyGWKSogNJ2a6v679rN22EXMKMGj
         H81sbmVxBP28rpMKyTh6SwwazimUSM4exCO5y1ykFsNcjZlgnm5NRwOdHjdMWfSI7CoW
         510J+c/YBME2BgjBIZSc8Lil5NuEMA30Aa17z/GlAC2Zwvi4XlnbNCug8FMzzdU9bMBz
         PN7XZAmx0/Srx9zdtZ4UTyCkFZz6rn24vIvv6hHWrl3F5NwBPVJtejEmq6WXzQIPlzRb
         vL3Q==
X-Gm-Message-State: APjAAAV75m90lVtcKkmcVJhsnWUvZdn09cNLOgpCDGqvoIxB2Dw1/Slx
        wMviowUepphvsKkyamPgpJ8dGRrE
X-Google-Smtp-Source: APXvYqyC7V1Bddt2ayGRgVkCJMHVJ9PYyLGgL/wJtpD3rLj4iNTzMOYpMH7u5Gm9y1nUaW+68DgSvA==
X-Received: by 2002:a17:90a:9281:: with SMTP id n1mr29517336pjo.25.1558954004814;
        Mon, 27 May 2019 03:46:44 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id k13sm10174792pgr.90.2019.05.27.03.46.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 03:46:44 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH] target-i386: adds PV_SCHED_YIELD CPUID feature bit
Date:   Mon, 27 May 2019 18:46:40 +0800
Message-Id: <1558954000-9715-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Adds PV_SCHED_YIELD CPUID feature bit.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 target/i386/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5f07d68..f4c4b6b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -902,7 +902,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "kvmclock", "kvm-nopiodelay", "kvm-mmu", "kvmclock",
             "kvm-asyncpf", "kvm-steal-time", "kvm-pv-eoi", "kvm-pv-unhalt",
             NULL, "kvm-pv-tlb-flush", NULL, "kvm-pv-ipi",
-            NULL, NULL, NULL, NULL,
+            "kvm-pv-sched-yield", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             "kvmclock-stable-bit", NULL, NULL, NULL,
-- 
2.7.4


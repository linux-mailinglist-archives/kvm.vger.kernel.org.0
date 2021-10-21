Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E92A436AF4
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 20:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhJUS5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 14:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUS5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 14:57:16 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62302C061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 11:55:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j18-20020a633c12000000b0029956680edaso591069pga.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 11:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Qk4lEaKaya+E1C8wbGdEqsjwimBdJ3TiOU6SLK/AfUU=;
        b=fCuzoTM1O4u3lRZzSryI/un9CYMFB/EYa8kISqnZvmmbFdlRaZO+xzO+dK6o87d5i0
         l9+nWcP3vSksT4CTo4HLS9FErlI2CmuJiz9yTjSgbmluoc7tbeNmCUjk6/jiXQLH1IJa
         X6L63OcrbpTpVY1nH/jPixwmQPThoyUMsmT93e8F8k5mZpJG3pQDwYKkZcBFFiAQHxa7
         I0bpQeylt2/Agjx9rXNQu281/UdMvJoanx4c0kZxgOq4ATLbmf4ELc7w5j7OnyWQCMM1
         2QHfLd+obfIZN2V++YtjiTW9GmtHxhepBP/BFT2/VIZPI9eEa0mBrZ0QLjqGeG95bstE
         l6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Qk4lEaKaya+E1C8wbGdEqsjwimBdJ3TiOU6SLK/AfUU=;
        b=0go0D0KbIQsVOAKVWasYEXbT1ndKKOZ/WEVL+o02+uToa3R79uJQDCmOgjoKP4YFbf
         cXMGlZUPXJLNdsLBv+tb6g9djEebzb5jWtNa+3Vdflf1aZkB8yLHZGOmDwtw/KPJQNkt
         eSNkCaPtynnsUtew3EuWiSggmp6cmp/H6QTCb1yY86sFHdChBWTZkScq0v9dFbp7381/
         3LE0154sgSp41Sclisveohjj65Gr21nQIGtbZr+gzJMu8OuVgerv90EReO9RxTfIEOoK
         UJvanc1WguZyT3/1eVL0EPLtDwbwAG0UO/y3E1lQA58ogvNaEK5HnDyDEOpQ8Vr+9DrF
         8usQ==
X-Gm-Message-State: AOAM532auzOT19n+9SNylejmyCNyltH+TJL0Riog86pDt0Ed54EuU1wE
        FJLvpgQU0wEJA/qGJCocFJiPnl2oQnpmEZvM0leJFaD6Qz+UbIeDa20+ZMR/Qj5Y2Ng4p+rXPcE
        xRRUW+kFDLvZ8++MzbRRdSgNNS/2TPx2zux8GYwSQDT4w6pQtrOAeFW7DJu2Vb/A=
X-Google-Smtp-Source: ABdhPJzIN1HSqZ4Edwv3Jrf2rfPfCDkm1rJ9ajwBCmsbnnCQKpodmM2MfFrn6I9bkyYkomUURpTL5IOgdHsGFg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:aa7:8b49:0:b0:44d:65a9:fb9d with SMTP id
 i9-20020aa78b49000000b0044d65a9fb9dmr7768931pfd.24.1634842499712; Thu, 21 Oct
 2021 11:54:59 -0700 (PDT)
Date:   Thu, 21 Oct 2021 11:54:49 -0700
Message-Id: <20211021185449.3471763-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH] kvm: x86: Remove stale declaration of kvm_no_apic_vcpu
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This variable was renamed to kvm_has_noapic_vcpu in commit
6e4e3b4df4e3 ("KVM: Stop using deprecated jump label APIs").

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7d66d63dc55a..ea264c4502e4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -343,8 +343,6 @@ extern bool enable_vmware_backdoor;
 
 extern int pi_inject_timer;
 
-extern struct static_key kvm_no_apic_vcpu;
-
 extern bool report_ignored_msrs;
 
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
-- 
2.33.0.1079.g6e70778dc9-goog


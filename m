Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557F92DB3CC
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 19:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgLOScl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 13:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbgLOS3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 13:29:30 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0B2C061257;
        Tue, 15 Dec 2020 10:28:16 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id w1so24451436ejf.11;
        Tue, 15 Dec 2020 10:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j5Nx3QP2QUef7kqAsxxArhCJKbbh/sB4VAtuIgHpzAY=;
        b=Gt7wfw6zKOz9640y+Pkyf7QD3YEYbL7AQxcBqBO+4SznKXSUJ40g+lwnP5nWJwL2gr
         vWCstbyjibsJ8zQNhOazJEfK2f5z18NyuSluEErqBgrAv/3/4RZ/ZWP8XqNHszdV0Xkn
         cd44ru/YuoUualt+VyBZIoC6mpTMCYHyeygE5SN4ltcm6YMbvHIvA3pHEWankX8GZRmM
         cZJMljLFsGlnnaUhVSFQFz+uUEcpoVQKYFohpydv5SosJh7S/5pXymYeJW8mgYQE/0+X
         0PHOpoMPxSRr3qtOVxjIUZmtfLLGRiLl4Irv1THjXn0SHQDPNvxPs+JPO27jzgW4pb/T
         54vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j5Nx3QP2QUef7kqAsxxArhCJKbbh/sB4VAtuIgHpzAY=;
        b=I9SXv/yUbLFn9yya9or8VVc7yB6BBB4K+A+gg/WREW0slRuLaBc9LTT24Msz2S6Ssg
         YaKr/4NBdoCPsqEMzSWps49/WZ9gIh5d5K2sDUDNBXlc6xT3OZSnWbSIfpxB1Fu+faA7
         Ap2xxxzdcJ8uT0j/1Qn9xgU3tvdpxRfRyyFgHANKuw8Gm3OVx0It2NhvRv89CXJJuBgs
         Bc2xBuwRDFTQlntZCNgdSWUPJTvppsopwWZb49+2u3Q4lj7+JADrpalA5RAqC6gzKS5u
         xv6VszMbJ8W7YmZ5LjPLJXf3em0Qn7w1ub5825tlszbJiFwaT50qCCwqwDi7XyrWf0tz
         bbgg==
X-Gm-Message-State: AOAM532ssfylyL7gxnMhjwBoEoXs1I7tmS9/AHu5f8wNDe/xjorOnqoX
        ytmkUZuu36vVsR82vVC8rTE=
X-Google-Smtp-Source: ABdhPJzgkJG3I3krAxjW5y1BK0JBdUBsjzDb5RiaXrUm2dscx5+KLiZP/Q5jBAn6KDXflPv29Viqdg==
X-Received: by 2002:a17:906:ce21:: with SMTP id sd1mr27506527ejb.396.1608056894785;
        Tue, 15 Dec 2020 10:28:14 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id r21sm7369228eds.91.2020.12.15.10.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 10:28:14 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/3] x86/KVM/VMX: Introduce and use try_cmpxchg64()
Date:   Tue, 15 Dec 2020 19:28:02 +0100
Message-Id: <20201215182805.53913-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series introduces try_cmpxchg64() atomic locking function.

try_cmpxchg64() provides the same interface for 64 bit and 32 bit targets,
emits CMPXCHGQ for 64 bit targets and CMPXCHG8B for 32 bit targets,
and provides appropriate fallbacks when CMPXCHG8B is unavailable.

try_cmpxchg64() reuses flags from CMPXCHGQ/CMPXCHG8B instructions and
avoids unneeded CMP for 64 bit targets or XOR/XOR/OR sequence for
32 bit targets.

Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>

Uros Bizjak (3):
  asm-generic/atomic: Add try_cmpxchg64() instrumentation
  locking/atomic/x86: Introduce arch_try_cmpxchg64()
  KVM/VMX: Use try_cmpxchg64() in posted_intr.c

 arch/x86/include/asm/cmpxchg_32.h         | 62 +++++++++++++++++++----
 arch/x86/include/asm/cmpxchg_64.h         |  6 +++
 arch/x86/kvm/vmx/posted_intr.c            |  9 ++--
 include/asm-generic/atomic-instrumented.h | 46 ++++++++++++++++-
 scripts/atomic/gen-atomic-instrumented.sh |  2 +-
 5 files changed, 108 insertions(+), 17 deletions(-)

-- 
2.26.2


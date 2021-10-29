Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22244402F1
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 21:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhJ2TNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 15:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhJ2TNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 15:13:13 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1339CC061570
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:10:44 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id s10-20020a17090a13ca00b001a211aa215fso5793548pjf.0
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KDWKTc1GJTEzUINDXTg5a2/zzse2UtRtRLssuaNb2rI=;
        b=aZiOLfvakJLdzV1huKFzd8QB4UdYtkzjaj0IBJj7fxt5PlUpmesvsxlOyfj82YZUPU
         ucDdOouegMOHvVzYGYpa74JsUOnHThoc8NWq8bDwMMi9tmsrXTRic/558wzeZArK7b7/
         KZtXdVyBK6VjaZFyFztF7nb7HOmWQANWn2wQmxSrABGcS5+Lz5Kimz/8eL3+h+8G0uBn
         NyeISAJ8ITRZfX6Lnu9h7bKBw7RToA+nb4vD+l6MBMMspWH9xKmPBkeddPfikgx2irzl
         3r9PrChcxb3KZryUbOAtRmdz7ttVlBAIFM+qywM1JFyfWA5hdRGGzGnNmh3at2KzGiy9
         Nk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KDWKTc1GJTEzUINDXTg5a2/zzse2UtRtRLssuaNb2rI=;
        b=BxMIIwnnYkYT7aP9ybe+Bw8u1vGcFE3lYI83nlsg3E327+3Fok4+9WS4bNlDHWoBx1
         UpK4hUU1PDjitBz5B9P79O8u5ZaxOmnz3OtfrcEIzwvKo5AAs6/nPbJYYiC9My5mB7g6
         FZh5Z6tFhENEbsHTI7f+LLRnTssoluu+1+vZHffVp+o3T6Q0CYRTi0TR15guZii6TWY7
         xQ6/x+bZkr8eOmQeRds5XJ0+Yso6PUM54r2AlwkRxcsARE/+kwsLv8XOiJzcVURqTY9x
         itCFT1B7fD+3qcpLw+r+466ZRFN79kTcdyUNX+vvUFEsBBHDgkyVvliERInbhG0zmWj4
         s5+Q==
X-Gm-Message-State: AOAM533BkbSSH6Pd4FZgJVLtLiIm4IkGvHsb4gbw6iwtqBduGsHFR2T5
        LMe/wz66clX+UJ9jcJcYzatNLc47zOJLdw==
X-Google-Smtp-Source: ABdhPJy1PYGpyojSgnzxnHnk5U7eEQcouMhhw6dvPDHHgehIitu1neNt4cVcQFxUw5K8PSLO6/l9dHCZoHFEWg==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b1])
 (user=cmllamas job=sendgmr) by 2002:a05:6a00:ccb:b0:47e:49ed:88f7 with SMTP
 id b11-20020a056a000ccb00b0047e49ed88f7mr12014429pfv.34.1635534643556; Fri,
 29 Oct 2021 12:10:43 -0700 (PDT)
Date:   Fri, 29 Oct 2021 19:10:36 +0000
Message-Id: <20211029191036.3166209-1-cmllamas@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH] KVM: x86: fix code indentation issues
From:   Carlos Llamas <cmllamas@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes the following checkpatch.pl errors:

ERROR: code indent should use tabs where possible
+                vcpu->arch.pio.count = 0;$

ERROR: code indent should use tabs where possible
+        return ret;$

Fixes: 0d33b1baeb6c ("KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b26647a5ea22..ff04b78ece5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6980,9 +6980,9 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
 	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
 	ret = emulator_pio_in_out(vcpu, size, port, count, false);
 	if (ret)
-                vcpu->arch.pio.count = 0;
+		vcpu->arch.pio.count = 0;
 
-        return ret;
+	return ret;
 }
 
 static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
-- 
2.33.1.1089.g2158813163f-goog


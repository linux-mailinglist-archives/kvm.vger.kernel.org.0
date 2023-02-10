Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B97692039
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 14:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjBJNvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 08:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjBJNvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 08:51:53 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD1F113D8
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 05:51:50 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id y1so5147024wru.2
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 05:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aedyPRD2OA/Q12cErqdU0gdmNaMluYoniD9K/9T9nvs=;
        b=70p0hxOWJF2H2xeeGVBp8GoSNG+I+DPpr/hafBYFRJTc3Zgsmd26bhaxEEKctOotc0
         6w7f1sEjIkFRhMOQvo0g0drEaomWGjSzB/C67bXhzit412wpIsnJ2fmaDy5d8CKfpNFb
         lJg8UTcRguffcf9CsYsfw9ToXFKjJ+bf8peNV+tqPiSB5KiWqEEBqOgaBUvlCQNXwEyU
         13O0mTFve+E+MEhy7ZMD5DXzpcjIvXUe7uNC6m1FdNTArFMu14yfeVMxyIppu8BmYhC6
         65GNsjHdSnL0OCgparmZiacvz6yBk/jK1APmVUBHAgiy5Buh1evrUxa7sABIjGn2Udqv
         rqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aedyPRD2OA/Q12cErqdU0gdmNaMluYoniD9K/9T9nvs=;
        b=Sl0YfsIFyuRKLtja7bP7BsPOg7D5TBJoypItvYDdtr8FreKZNHXZdnc9S7qm6kzNiY
         Wzk5uObdognNc9FJEimtgobzPgHzu+KXWWB7l1rqAg5iFy/lmFWfKgqYkI/BGTMWUeQA
         UfwZpsLzsNUREWO6KATpEudO/Xho0ppi7GvIXz6+h+7b+j3pOb2WCv+NNTxuk+pp7PSk
         y9ooJG+IsbdeiVDOwkATHQ/f1vaKYBACk67pcdsLCTm4XjOLztaXIg9iTkR1ZLseGlVy
         4Ou3ZSceuw5RnT8WIfbstBdtIRxHng1NnOY8bNmPXs1j32zwK7kB8HIG91NprQSx2XO3
         RWaA==
X-Gm-Message-State: AO0yUKWOzY7oGc9ODWSZY0SVQsqzYu88ABR7DAUaFvFuUjBD7mYtJ99l
        LQS5YyrquE271ZpnuEUSn9/vlWwXY/4ou/Kn
X-Google-Smtp-Source: AK7set+agwpUiQqJSdzsO953ZKOM/iK4IfFaBn5DDHj9yHKm6NJvhIg6Lyd+UYT0ZCB4pAvi/JCaXQ==
X-Received: by 2002:adf:fe86:0:b0:2bf:ac3f:a9da with SMTP id l6-20020adffe86000000b002bfac3fa9damr14335774wrr.7.1676037109466;
        Fri, 10 Feb 2023 05:51:49 -0800 (PST)
Received: from localhost.localdomain (cpc98982-watf12-2-0-cust57.15-2.cable.virginm.net. [82.26.13.58])
        by smtp.gmail.com with ESMTPSA id e7-20020adfe7c7000000b002bdfe3aca17sm3883549wrn.51.2023.02.10.05.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 05:51:48 -0800 (PST)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     anup@brainfault.org, atishp@atishpatra.org
Cc:     paul.walmsley@sifive.com, palmer@dabbelt.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        Rajnesh Kanwal <rkanwal@rivosinc.com>
Subject: [PATCH 1/1] riscv/kvm: Fix VM hang in case of timer delta being zero.
Date:   Fri, 10 Feb 2023 13:51:36 +0000
Message-Id: <20230210135136.1115213-1-rkanwal@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case when VCPU is blocked due to WFI, we schedule the timer
from `kvm_riscv_vcpu_timer_blocking()` to keep timer interrupt
ticking.

But in case when delta_ns comes to be zero, we never schedule
the timer and VCPU keeps sleeping indefinitely until any activity
is done with VM console.

This is easily reproduce-able using kvmtool.
./lkvm-static run -c1 --console virtio -p "earlycon root=/dev/vda" \
         -k ./Image -d rootfs.ext4

Also, just add a print in kvm_riscv_vcpu_vstimer_expired() to
check the interrupt delivery and run `top` or similar auto-upating
cmd from guest. Within sometime one can notice that print from
timer expiry routine stops and the `top` cmd output will stop
updating.

This change fixes this by making sure we schedule the timer even
with delta_ns being zero to bring the VCPU out of sleep immediately.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
 arch/riscv/kvm/vcpu_timer.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index ad34519c8a13..3ac2ff6a65da 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -147,10 +147,8 @@ static void kvm_riscv_vcpu_timer_blocking(struct kvm_vcpu *vcpu)
 		return;
 
 	delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
-	if (delta_ns) {
-		hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
-		t->next_set = true;
-	}
+	hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
+	t->next_set = true;
 }
 
 static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABDC6920CC
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjBJO1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjBJO1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:27:18 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BDAC171
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:27:17 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id o18so5253655wrj.3
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 06:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ceHLeqJb/8JC46v9fimPjQQwYVOelzaxlpfKlrdams0=;
        b=3mSFr7TZiIW7nwfOpoLLswRG9WNFL8JDi1jk9+/T63+a7gMH3vJqvEyLoBVdTZZfiG
         epkFXDb82SBfTr6eEabrcbpf9x0fJ7P5IroYSeE3SM8SGN1BxNx7nGuE93Kajt7hK8YA
         ETvf4C3ci3UXi0al3h9dS5AMIQVzmaTwPo2uMk8uTZRIEInFVVlKjo34bgMyxbYZ7IH/
         h+vCFY4fG76yJhWzPnzS7KjHvTG2kDuHDXV/womDoH9x3a4aIB+grdQwxA0rKtkDbe7E
         0Ys8ZDkanJtP32iHJN93nv2zYWPZh47/FYYkp24fgF+P6Xh4+P3BUGE++jgpdwT5ls21
         zFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ceHLeqJb/8JC46v9fimPjQQwYVOelzaxlpfKlrdams0=;
        b=Valn1UJHDVIAmmIPNsdh1xYmD4bS6zQX/fzz4pWh8qanJESh3hHC1NLjT9E+sGxhfy
         tykXqywMl8nfyEPnH1ALjsqxiajt4Bkq5GW3Tei8xWPUp8JIkAiK61qgrFXcxVHwXpvy
         Yf9fwoIChQJ/1g5scthd9//AKLfdGU4YZl1LgFGn5oTqI0TVDrO2McMB+qUp+mJRI4FF
         XawXI4Es67Cbriyzv2Uu/N+QyMNg0lxwDG8wxuyMwnAoBf0FErpSQ7yq9+rzJwfnteOf
         /kJk67OKV51kX3J3Mryg6KEWeWSAG8r2lv4q1gYorKPNFsf8gSqfhrJ3EXWMRLppsFsl
         nLKQ==
X-Gm-Message-State: AO0yUKUaZUXJCNwVEvDpM3/tMkhHbvngmAKaXCCByRIa4hyxwSNyrSrC
        PpDExCCsBzf55MXV9cHe5fIWiXjPVqgYtoID
X-Google-Smtp-Source: AK7set/Jbyl4v9fxcipnYs583qTKV9G6tdJI07ELZH8BUsyvkjhq67DR+Hc4GkvinyCHgpeLZqPm2A==
X-Received: by 2002:adf:f590:0:b0:2c5:48ad:d352 with SMTP id f16-20020adff590000000b002c548add352mr2339253wro.14.1676039236031;
        Fri, 10 Feb 2023 06:27:16 -0800 (PST)
Received: from localhost.localdomain (cpc98982-watf12-2-0-cust57.15-2.cable.virginm.net. [82.26.13.58])
        by smtp.gmail.com with ESMTPSA id j7-20020a5d4487000000b002c3de83be0csm3963968wrq.87.2023.02.10.06.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 06:27:15 -0800 (PST)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     anup@brainfault.org, atishp@atishpatra.org
Cc:     paul.walmsley@sifive.com, palmer@dabbelt.com, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        Rajnesh Kanwal <rkanwal@rivosinc.com>
Subject: [PATCH v2 1/1] riscv/kvm: Fix VM hang in case of timer delta being zero.
Date:   Fri, 10 Feb 2023 14:27:11 +0000
Message-Id: <20230210142711.1177212-1-rkanwal@rivosinc.com>
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

Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
v2: Added Fixes tag in commit message.

v1: https://lore.kernel.org/all/20230210135136.1115213-1-rkanwal@rivosinc.com/

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


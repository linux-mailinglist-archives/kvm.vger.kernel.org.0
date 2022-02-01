Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4624A586C
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 09:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiBAIXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 03:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiBAIXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 03:23:49 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35411C06173D
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 00:23:44 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id d10so51621877eje.10
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 00:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=moWXwRufmzv2uumLJS/9LAZ+TSxfYh9+Zsj12AAFml0=;
        b=megPh/BG5oFnZ49v1LXD50Xj/andQy3srFKAFC+gMyPjfTvGoYsIG3hfLiq4hYxtIB
         8iuFJWW+cp099IAO893rjhKCAI7teY/UWouMMrE7TJQehbHyaDR3nAqwlqxmsgfSwBli
         9f/DFJf4yXzoSnJA0VHLwRjiWbGW8jspI/EAtajH8hxW6yn7RfRW7Xs7xN/8j5u1MRLU
         sneA5mmfSueXTPSQvo+Qh1VoTKL8YJLj8VRO6qzHXLnTzddiOV77AdPRdMooMWFT/Wvf
         Rjubq2A6dSjKTSCKaLs390u3FQ7a+IlROa9jV9cSkyXu/5MwrnSW32MKoIqsVH+LaJf5
         oR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=moWXwRufmzv2uumLJS/9LAZ+TSxfYh9+Zsj12AAFml0=;
        b=PI1iuhT5ViYQuMfB3z2ZFOJdnoRGT6rh8i/lJVTuD10vTWKtqUGXpcYEdioip8/u1T
         ZhfwCaeVAJzwKZvK/Zi0Bzlc9+mBkpLIkuu1c86tYrU+obdukaItYk5fkdli6Jn7Zb3P
         FhMlHwPisAdNmtDC/d6EYWQdXj+YTvqzzDh0w/i3Uilbi356bwdWnE1L/SgEq5cEtNpm
         r+R6xEpxK/0EgRKuN4lmNhv4Z+1Gob91ek+DQfi8D07gT9fF8aimxmjMWq1cpdkJgdnu
         KsvicWhwfxgVbWo2lswV02TA/7wNAr0ex7wm9J/mVx4+/aeSLadKWAR4QMbtvve5n1RO
         4NGA==
X-Gm-Message-State: AOAM531nonaXkUxh8xIJNo83VvHkjuLeehgY4Ld9QVUQ1uPdIiAfJTtw
        +VBk4iN4oR7a0GaQPmpk73fj/A==
X-Google-Smtp-Source: ABdhPJzlSuQ0ORHAbwDAjB4y7DcyZYYBLC+IfC2qa+oxDfgJJAX2C9+sYwnhDEYPKiloCVEXgsoaNA==
X-Received: by 2002:a17:907:1b16:: with SMTP id mp22mr20683012ejc.537.1643703822407;
        Tue, 01 Feb 2022 00:23:42 -0800 (PST)
Received: from localhost.localdomain ([122.179.76.38])
        by smtp.gmail.com with ESMTPSA id w8sm14312133ejq.220.2022.02.01.00.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 00:23:42 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 1/6] RISC-V: KVM: Upgrade SBI spec version to v0.3
Date:   Tue,  1 Feb 2022 13:52:22 +0530
Message-Id: <20220201082227.361967-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201082227.361967-1-apatel@ventanamicro.com>
References: <20220201082227.361967-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We upgrade SBI spec version implemented by KVM RISC-V to v0.3 so
that Guest kernel can probe and use SBI extensions added by the
SBI v0.3 specification.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 76e4e17a3e00..04cd81f2ab5b 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -12,7 +12,7 @@
 #define KVM_SBI_IMPID 3
 
 #define KVM_SBI_VERSION_MAJOR 0
-#define KVM_SBI_VERSION_MINOR 2
+#define KVM_SBI_VERSION_MINOR 3
 
 struct kvm_vcpu_sbi_extension {
 	unsigned long extid_start;
-- 
2.25.1


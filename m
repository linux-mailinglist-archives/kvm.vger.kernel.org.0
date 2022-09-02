Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAA25AB70E
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 19:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbiIBRCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 13:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiIBRB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 13:01:59 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82F9DCFC8
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 10:01:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h188so2426303pgc.12
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 10:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=IdtU6srtyQUAra4AuQSnCBSrs6xPYmqcvUoxT84dqvs=;
        b=h6X6Jml+DFCgSlcblU7ih6G2hbgk9gPVz4m8qUHc5LeRkRfdc+Q90oEQPsOKEjx4mX
         75o8Q8QOeg/L1reH9+QfSoZQQPeeX7bKiQSpwwL2uNar65Sv7Os6bFo5qDFeKG7deg3X
         WyPv5UB0Ex2xD6K1KBZn7ViHcxlgBE4QdTV7GmDGFSyqOhh9RCLpk2lEaVYw7KAUUgQn
         tYHdVrGbqDc5AQJXZ4EOPCSu2NmWdpOHAOEWgfdiZN+9IJH8ekLSrHfAbMNLCsd05fJQ
         jAau0uoMXjVcdGhajRk9xw6tR9UdZ4n++pL8mQJH+NPbKOcdq1xDwN11izhb+qDSGh1J
         XPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=IdtU6srtyQUAra4AuQSnCBSrs6xPYmqcvUoxT84dqvs=;
        b=it9N+/hDrGQ5AFaHFbBZGD6UEBIDTL1JknTVAYW6/Mfn0mbgNforhtMWF1jb5RsyHA
         Ve8EfR5M8BB18XX8pORAe4YU6r4dkaFFqniH4kJMaHHZF+5I6UG+5THrBQ/IxRZuvTbp
         VRXE41CTEhVaDMFa89RB6iPb2PdVAvWBOBG+wEdX8DAx4xoRFFZTQ/94ExK3l9j9L7Ec
         z8OtP9b7FvRV//RGYvunQ+s/b+QMVlHTDSVHfcIYbEPrD4p6GIU8fxsVT8GV/ee+nAUB
         uHAUsFzi+k5YqcBGx8FdBrj0EVDaF4/wm3MYTOABxGG/B4csUs+phUHZ8aYGA6zYA+20
         if5w==
X-Gm-Message-State: ACgBeo2pa2UoLGFmo3FPOnITTwggUsuX2vLzJmD/lGmEiqQkAZmkNmwb
        rm9QLTEKTBqwMVBKn4Pfy/qDGQ==
X-Google-Smtp-Source: AA6agR6s8PyY3S+hAOSutXy8mJL01o/t3sjUFMZZYl79YgZSuqG1Ot/bMxugG/CWnUDsB4CVdyQgLA==
X-Received: by 2002:a05:6a00:8d0:b0:53b:2cbd:fab6 with SMTP id s16-20020a056a0008d000b0053b2cbdfab6mr6003300pfu.3.1662138115408;
        Fri, 02 Sep 2022 10:01:55 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.83.155])
        by smtp.gmail.com with ESMTPSA id w10-20020a65534a000000b0043014f9a4c9sm1638800pgr.93.2022.09.02.10.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 10:01:54 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 3/3] RISC-V: KVM: Allow Guest use Svinval extension
Date:   Fri,  2 Sep 2022 22:31:31 +0530
Message-Id: <20220902170131.32334-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902170131.32334-1-apatel@ventanamicro.com>
References: <20220902170131.32334-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should advertise Svinval ISA extension to KVM user-space whenever
host supports it. This will allow KVM user-space (i.e. QEMU or KVMTOOL)
to pass on this information to Guest via ISA string.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 7351417afd62..b6770ee08872 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -98,6 +98,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_M,
 	KVM_RISCV_ISA_EXT_SVPBMT,
 	KVM_RISCV_ISA_EXT_SSTC,
+	KVM_RISCV_ISA_EXT_SVINVAL,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index d0f08d5b4282..901bb5c0cb50 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -53,6 +53,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	RISCV_ISA_EXT_m,
 	RISCV_ISA_EXT_SVPBMT,
 	RISCV_ISA_EXT_SSTC,
+	RISCV_ISA_EXT_SVINVAL,
 };
 
 static unsigned long kvm_riscv_vcpu_base2isa_ext(unsigned long base_ext)
@@ -87,6 +88,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_I:
 	case KVM_RISCV_ISA_EXT_M:
 	case KVM_RISCV_ISA_EXT_SSTC:
+	case KVM_RISCV_ISA_EXT_SVINVAL:
 		return false;
 	default:
 		break;
-- 
2.34.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60ADF6DC2D9
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 05:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjDJDLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 23:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDJDLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 23:11:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDB63AA4;
        Sun,  9 Apr 2023 20:11:30 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d22-20020a17090a111600b0023d1b009f52so6133755pja.2;
        Sun, 09 Apr 2023 20:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681096290; x=1683688290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MrXPpTAZ2U7Dtc3azP6UwLsgOdV2TDhnTZz7lNXk02k=;
        b=Rj7AHNk2iaIdfRQnuT282gM5WtMSlcoqxAfJoQ+Gl+mDdisfztkwfFFU4bvqo5rqKB
         lU8aeNriLUQAr7UzGzd0pbA5SkyKisdVtIe8PUyeAGP/Q3QoK76uaaJUsVvaER3TK7Zh
         kiruktb/hdQ60x2yheLWan9ofUA7/WAdMsE089nkVhGA+VWvBhqudAEAvYhpizXM+Cns
         5EiX24NH4jbjbjGPFn8ChVWxcGsUPHBiANPT7ku68+WD1QHWsu4yT1/3/CPJk5jtOSFu
         8jpBl+HUQsTZ6TD2epHqnnl+owcOWC61KMt0SJ0LFZecpj3Fo3IgmLIQ15/rW8PnESnZ
         FU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681096290; x=1683688290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MrXPpTAZ2U7Dtc3azP6UwLsgOdV2TDhnTZz7lNXk02k=;
        b=kl21+T21rO5yuqa+cgGX36Arm+VLPEn9+w9LugTTAgVRv1m3SImKfypvHSo0cR4+yb
         M/+YCyDl6i6nqSG9Q/hhn7cduXxGxGHOT/swQ5IFmknEwJt/qO3P6/YiAG7poBLd6dTp
         Yjk9SfeGyKOCRKQ08o28SToKxnz7EHP+khEU4Al13uHPiYaSH73j8KRn92pEXSLOP/i8
         kIpDRK2hmlfPkJOavW4g8vouAwxF+VoWU8o/BkXv1tEoWPyFK/Bliwa5wbYRUZmKvb+K
         kJvfqLgg+ftDOTsSdzrlg/thMTafbkPgq6l6c3Xid0Z4DNv4kV+mhAfa7EbE0t0TYneN
         72QQ==
X-Gm-Message-State: AAQBX9cDjWZiustBcBYBSS2VI4HnEHG1kSdTd3jls+mlkKaYrkSdVVl5
        X6NplERNcLAtk5SSC9D/n1A=
X-Google-Smtp-Source: AKy350Y+WyV1d9YDDN90ETzUW12wP78TIrX5MPhkvKub2o8Ub+mT9WnOguUFOs6D9+o/5QImEuukng==
X-Received: by 2002:a17:902:c9d2:b0:19f:2ae8:54b9 with SMTP id q18-20020a170902c9d200b0019f2ae854b9mr6718254pld.32.1681096290111;
        Sun, 09 Apr 2023 20:11:30 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902654b00b001a19f3a661esm6509595pln.138.2023.04.09.20.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Apr 2023 20:11:29 -0700 (PDT)
From:   alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH kvm RESEND] KVM: i8259: Fix poll command
Date:   Mon, 10 Apr 2023 11:10:22 +0800
Message-Id: <20230410031021.4145297-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinliang Zheng <alexjlzheng@tencent.com>

According to the hardware manual, when the Poll command is issued, the
byte returned by the I/O read is 1 in Bit 7 when there is an interrupt,
and the highest priority binary code in Bits 2:0. The current pic
simulation code is not implemented strictly according to the above
expression.

Fix the implementation of poll mode in pic simulation by pic_intack,
and remove redundant pic_poll_read code.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 arch/x86/kvm/i8259.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 4756bcb5724f..bc5b758e8f73 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -397,35 +397,18 @@ static void pic_ioport_write(void *opaque, u32 addr, u32 val)
 		}
 }
 
-static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
-{
-	int ret;
-
-	ret = pic_get_irq(s);
-	if (ret >= 0) {
-		if (addr1 >> 7) {
-			s->pics_state->pics[0].isr &= ~(1 << 2);
-			s->pics_state->pics[0].irr &= ~(1 << 2);
-		}
-		s->irr &= ~(1 << ret);
-		pic_clear_isr(s, ret);
-		if (addr1 >> 7 || ret != 2)
-			pic_update_irq(s->pics_state);
-	} else {
-		ret = 0x07;
-		pic_update_irq(s->pics_state);
-	}
-
-	return ret;
-}
-
 static u32 pic_ioport_read(void *opaque, u32 addr)
 {
 	struct kvm_kpic_state *s = opaque;
 	int ret;
 
 	if (s->poll) {
-		ret = pic_poll_read(s, addr);
+		ret = pic_get_irq(s);
+		if (ret >= 0) {
+			pic_intack(s, ret);
+			ret |= 0x80;
+		} else
+			ret = 0;
 		s->poll = 0;
 	} else
 		if ((addr & 1) == 0)
-- 
2.37.3


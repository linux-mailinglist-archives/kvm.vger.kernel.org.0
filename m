Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014C86E146A
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjDMSn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjDMSnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:09 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A2286A8
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:47 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q6so3696822wrc.3
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411366; x=1684003366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEzPnT9BJgEXvliDbDR1VhVozm5deAohFLLUYFFrBSc=;
        b=H7aOLZRY/iUS6b27nuIM1MoBSXZt+ExRPdjmx7NTJX+eCcH2iDa1IFEWbjYKbi52eD
         Ok92+TL0FyyulJZNvnLMrwF/dq+qr1tT5ms5oCTKNsRiHK7BEPRzSApXqovau8owHlg4
         wEoAG6FhX1/AOt5hUcoeLxkgJX3npaMbzSh3H+5Ay7vYDfXr3CWd4FMScuv9tniYkaju
         pCcVhNkpXEiruVJt0BfseZG445yN6dmHLdLabK8WgMm20mUzEOIHrQPb6HqHmaJF89ju
         k4XB+XcmH3cu7LcpmoZcyeR4wj3ceBFgM6C8GocKK2mcV8Y64y/Jm8IRAJs5m3Qvndup
         d+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411366; x=1684003366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VEzPnT9BJgEXvliDbDR1VhVozm5deAohFLLUYFFrBSc=;
        b=VwcNWsq7zkQDeREnzB9CExMl8GCUFdJuXk1Rp9UXxk/gLofzQId0G7/rg/aBNCM95r
         sqnmaiKKrr/TOqSg5Gj3xjLZ4I03CFP6lt642WE8zW6LQdK82e5TTI4SDk7poPCljCfd
         NOXQZnPROn4BV6oxphhp1CE+auJOG40MkC2217y+LZx9+8f+Z3QQOmeT6/CRujzooHRo
         MdCvaCBacNufToFOpo0fGahi5MvphrfteTDxE6gJ8iTsb0KudngPZZlTZzKxBaHBhc6l
         kFDV4EUwSuBh6VihAA8QWyz40a/gzbrPXj9lVtwhOIfskuiojUK7Ffax4e3ObrjzVQiP
         GG7w==
X-Gm-Message-State: AAQBX9dDJAHs2oyJNGRpxCQFwlCSTyBQZ5MM1VTrqUyrB/EgBuT7ZVgX
        S08QvJHJaQStfVqGIWfpoyJxzw==
X-Google-Smtp-Source: AKy350Yk/Ft352jB0vtFJBgpo6mtO9m87CiPbw01r2kQx4ISkjhrBDTwRJ1Na1u6Ip5Kg4RHbBZJqg==
X-Received: by 2002:a5d:4141:0:b0:2f0:2e3a:cbfa with SMTP id c1-20020a5d4141000000b002f02e3acbfamr2139364wrq.57.1681411366044;
        Thu, 13 Apr 2023 11:42:46 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:45 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 13/16] x86/emulator64: Add non-null selector test
Date:   Thu, 13 Apr 2023 20:42:16 +0200
Message-Id: <20230413184219.36404-14-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
References: <20230413184219.36404-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Complement the NULL selector based RPL!=CPL test with a non-NULL one to
ensure the failing segment selector is correctly reported through the
exception error code.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/emulator64.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index a98c66c2b44f..492e8a292839 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -401,6 +401,13 @@ static void test_sreg(volatile uint16_t *mem)
 	       exception_error_code() == 0 && read_ss() == 0,
 	       "mov null, %%ss (with ss.rpl != cpl)");
 
+	// check for exception when ss.rpl != cpl on non-null segment load
+	*mem = KERNEL_DS | 3;
+	asm volatile(ASM_TRY("1f") "mov %0, %%ss; 1:" : : "m"(*mem));
+	report(exception_vector() == GP_VECTOR &&
+	       exception_error_code() == KERNEL_DS && read_ss() == 0,
+	       "mov non-null, %%ss (with ss.rpl != cpl)");
+
 	write_ss(ss);
 }
 
-- 
2.39.2


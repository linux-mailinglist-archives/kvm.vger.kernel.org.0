Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1726E145E
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjDMSnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjDMSnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CA8524B
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:40 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e16so1885869wra.6
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411359; x=1684003359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYGT5UY5doMRTiQspqkI0SekOpJHqqaQDCKMd+5DObo=;
        b=DQ/wJLeRsLds5mhQVNMv4zqyjAjdz7dbLKfC4jzGqjZ9n4F1+FCRJ7TamGdV0payKF
         n3XUdMAA/wcl83AFzr6aVoi8b9pQ7PaJqSPI6jTRjVacTPX2LybdI+4CoFsD5sV2UqsY
         XgocCTRkbcTn6jIaVESYvZQ6If+24XHLUbp3vtbnhtshiipnbi8MP+29uCQv1b6NV7b4
         E9xyvdSZJtLaaNKZOkMneqmsOFIqD+75691CpD0sUNccBfC97xMtjwZMRYy/WcFoCNx7
         N3RApX0dPH6LpF5QObZdiW5RETB/LbJD8vd2rX6XomfHPaMY8ORNVk5d4+bVQAv/GANJ
         OG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411359; x=1684003359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RYGT5UY5doMRTiQspqkI0SekOpJHqqaQDCKMd+5DObo=;
        b=eKlcLRsAaJ95xFV5iFxIYLZGkJisTUqXpD5ZnrGqdprEedUWk2st7gINJ0LM+TjExD
         hM4t4znSDtDR65uzcEZvTw9LGx9frQnUSs2XFPi3J1R/O0kbCCslpfouuUCIwtOFB5R5
         Ha/DLTUzwm6vfNjK07+v6Qqrh9+2vyBLv+thibjYJu8+GwavuOGImgXL/qCdndp/InNe
         p9DN4zbXEvT0XxJn5aRujhPdYxYuR/vkzikF5NSbTK1G4d9sQmV93X1MfaKEkbHN1M3w
         lU7Or3FznlEUpH3pi3ikJ4Crl6ztKxuPueDFuvJ3npxF+E5FVL1TWZL2s7v780OVzXFs
         JEXg==
X-Gm-Message-State: AAQBX9efRextuRk8cS9e/MCP5bitkjBUQ+Mke/XbaTwRattixt9DuCum
        qcv9EqyarvH0RLsnpKNYnkXkYw==
X-Google-Smtp-Source: AKy350YFvmzZEaXxvVYi+3HggSHUSHXpYB7ly4bYNCvkXr5dnEiaNvaj6JBVHVnynYCoBhA3TfJORA==
X-Received: by 2002:a5d:4d0b:0:b0:2f6:3930:fa7f with SMTP id z11-20020a5d4d0b000000b002f63930fa7fmr1747202wrt.7.1681411358707;
        Thu, 13 Apr 2023 11:42:38 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:38 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 04/16] x86/cet: Use symbolic name for #CP
Date:   Thu, 13 Apr 2023 20:42:07 +0200
Message-Id: <20230413184219.36404-5-minipli@grsecurity.net>
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

Make use of the symbolic name for the #CP vector number instead of
hard-coding its value.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cet.c b/x86/cet.c
index c01dd89d9082..42d2b1fc043f 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -83,7 +83,7 @@ int main(int ac, char **av)
 	}
 
 	setup_vm();
-	handle_exception(21, handle_cp);
+	handle_exception(CP_VECTOR, handle_cp);
 
 	/* Allocate one page for shadow-stack. */
 	shstk_virt = alloc_vpage();
-- 
2.39.2


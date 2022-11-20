Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4B46314BC
	for <lists+kvm@lfdr.de>; Sun, 20 Nov 2022 16:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKTPBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 10:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKTPBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 10:01:13 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ACB25292;
        Sun, 20 Nov 2022 07:01:12 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id io19so8466413plb.8;
        Sun, 20 Nov 2022 07:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MCLrwQhM0Vs6pVwurxrEwA9amBoFAvwidCNyO7UlwYA=;
        b=NI4+LX0CymQcB55vKxhWbUoYJlGz9m8X5APHdqNNzthbBoso0dAOJBaJPMiEm9puSp
         4zoBtQ5Nwuiri9sWzBik1Y+59EylyGX74RPIg+v9/sUEymaUB5ROwUPAwveXO1vDokiX
         jzSuU0HEZopqndRbelJ7ku4clvVb0JkSzlW+6EuiVllxfqcNbBQZjmlgJDIJE2nhkpOl
         pDgFtb2+JS3txjK8989i9tGAOVPWW19Uwp1CjLwL2SkLMSvvRLfDL7mk/DRdlXlHvFp8
         bVdouMBma3GWGN90UXe4q9hc3czC1tJK4Qd18CBxUyCFH/3rXVif9vjlz31opSB9Zp+n
         g7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MCLrwQhM0Vs6pVwurxrEwA9amBoFAvwidCNyO7UlwYA=;
        b=sptcJyqPF3PfIRkwvIkb5ydkYxiOMAu98RUjVfubJuzXlwnCVEF5KiEPfcLpmF9a5y
         Pz6S8RcS4M/qNiy3NRaDuPHyvgKOAlQxJWrUmAc5i5OffSrvA+aNmvblzaM9J+8Zu2Bv
         F1PpTRTR+9NgxrYPbRdxK5v52Ph6rTaA/UOHZAP2ud9Q8m5XVg/YNf9QQawIDFr0oZIy
         IuDyZCfM0hAYZCjgdQPn215wb/jdCpv2BRtRbnk6DTgO1Lkn5wvFBPlrDMTeTzRjJDum
         FIdQM/GUZYnl7KlMJ44yAxGnUXQ15i8/RRR6RKVK7n+wR59pJojbM0rx6KVVLEh37wJX
         NjFg==
X-Gm-Message-State: ANoB5pmLWJreHfnoj3itllSbkcrdpPosz636/LEYX11mWEoEcUmylCbt
        hNOi7V+L+6TS+I/2wqg0eOPOcGikXiYgnA==
X-Google-Smtp-Source: AA0mqf7/b7wZMXPyTA7iZx+4+biCvLKIXvBRwXpeMLNBn6Mj5UuDULuKvytNsGrszJHWQpk6NNbXzw==
X-Received: by 2002:a17:902:f813:b0:187:30f0:b16b with SMTP id ix19-20020a170902f81300b0018730f0b16bmr640520plb.14.1668956472488;
        Sun, 20 Nov 2022 07:01:12 -0800 (PST)
Received: from localhost.localdomain ([122.50.209.51])
        by smtp.gmail.com with ESMTPSA id 3-20020a630903000000b004761e544ec6sm238167pgj.89.2022.11.20.07.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 07:01:12 -0800 (PST)
From:   Mukesh Kumar Chaurasiya <mchauras.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Mukesh Kumar Chaurasiya <mchauras.linux@gmail.com>
Subject: [PATCH] KVM: Using __weak instead of __attribute__((weak)).
Date:   Sun, 20 Nov 2022 20:31:02 +0530
Message-Id: <20221120150102.138956-1-mchauras.linux@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adhere to linux coding style.

Reported by checkpatch:

WARNING: Prefer __weak over __attribute__((weak))

Signed-off-by: Mukesh Kumar Chaurasiya <mchauras.linux@gmail.com>
---
 virt/kvm/irqchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 58e4f88b2b9f..cf2e9a3fec04 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -157,7 +157,7 @@ static int setup_routing_entry(struct kvm *kvm,
 	return 0;
 }
 
-void __attribute__((weak)) kvm_arch_irq_routing_update(struct kvm *kvm)
+void __weak kvm_arch_irq_routing_update(struct kvm *kvm)
 {
 }
 
-- 
2.25.1


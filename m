Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF4B2D9075
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404142AbgLMUWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731160AbgLMUWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:22:05 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD934C0613CF
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:24 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id d26so1171237wrb.12
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=34Gjpun7TNPsoaQVN38Yv8sG5iP6wLHtCCAjvvFP5UI=;
        b=BU3fUzi8DAzwsnOmXIJ76k8U4DrKlFD4XgiVs2SUI68jQ+iKUDSlr9JBsXwLewlN8J
         MDR35+6wJWQKp8NZ9NCwBBFSRnMsqAnE4kblbrdxgeuWNBEgv/KEOS0YdV54clSlunOG
         pmTEXF9/gqvpn1SUxQw/jGe9BhmRL4Ta/pxCNPx0KXBSGzNjJlwbTDdqT/R+1ppD9VNL
         wkVNTJ8ynCM0zNSOgU0iy4PdzHWWKAuBZ/3AdppawIr0PPXO7UCVzzV8EwKG0NrYen3X
         SCTqipVjLZOjlA5KRD6wCyMiGZh4cUAUpU9+md9tmT8RKZJHvo9KXxw561Vqvhqj9hvy
         VlYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=34Gjpun7TNPsoaQVN38Yv8sG5iP6wLHtCCAjvvFP5UI=;
        b=BTWPsicxF/nZFh9ZgenAAu4ZplGge4bz96elU8Oi62EUmDI3bvJtfq/BD/7kPz3Bm6
         Rnrzd/OPf+uDrQh3FBlELkO6gh4s2fX5nvZYpd3jy6nKf0wnkmtg6NNHga1rXpWJXJ+5
         v8POaDhoH9WL9Fyl8BuzSOj+lTfwYbJlBAWQRSlryaOnpcPtmwOLGG4avK3lmjk8U9la
         99zKBBpnkdKF2lvFnYYIHXB1DD3DumRd53gaw37cP/XC5NkZl0I29DJ0OAfOgIYLz0BC
         PUXabKJfGjaIqcUVOXTLTSVmvWpUAXsBkbUuImagZcbTCt9VhkfK4y5CK0eiiBHJ4qM5
         vptg==
X-Gm-Message-State: AOAM532R/95ZZ87HXZgCiRZUWVjmA7+hSqX69wcqH2gwbvqJn1ZwJYKC
        A3rG+5MmIVV0dgLhZgQzBEU=
X-Google-Smtp-Source: ABdhPJxgeDq4WOxjOJQN0+vNyfwIGM036dcbEAa5GUj9cBrFjsN9I9AoZgNvo12QV4gNO6aX/iXePw==
X-Received: by 2002:a5d:6682:: with SMTP id l2mr25344695wru.213.1607890883667;
        Sun, 13 Dec 2020 12:21:23 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id m11sm12338992wmi.16.2020.12.13.12.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:23 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 19/26] hw/mips/malta: Do not initialize MT registers if MT ASE absent
Date:   Sun, 13 Dec 2020 21:19:39 +0100
Message-Id: <20201213201946.236123-20-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not initialize MT-related config register if the MT ASE
is not present.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201204222622.2743175-5-f4bug@amsat.org>
---
 hw/mips/malta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/mips/malta.c b/hw/mips/malta.c
index 4651a1055c9..f06cb90a44a 100644
--- a/hw/mips/malta.c
+++ b/hw/mips/malta.c
@@ -1135,8 +1135,10 @@ static void malta_mips_config(MIPSCPU *cpu)
     CPUMIPSState *env = &cpu->env;
     CPUState *cs = CPU(cpu);
 
-    env->mvp->CP0_MVPConf0 |= ((smp_cpus - 1) << CP0MVPC0_PVPE) |
+    if (ase_mt_available(env)) {
+        env->mvp->CP0_MVPConf0 |= ((smp_cpus - 1) << CP0MVPC0_PVPE) |
                          ((smp_cpus * cs->nr_threads - 1) << CP0MVPC0_PTC);
+    }
 }
 
 static void main_cpu_reset(void *opaque)
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B00927DC34
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 00:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgI2WoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 18:44:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728206AbgI2WoH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 18:44:07 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601419446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=66DSIrlhCeV+xyo2otn2L+hQAxSXyWg/ic5Sp/vZwto=;
        b=ULdr7Nw0p1uhfr5UCkjuiUaL2dOTdtdPFLV+UMWpBZ/eap+SKkd3qGujp1dxlIR2az3uyj
        AG1OCKtbGqfRl5kPkenxOgHRJDF1iwtaGhK34nhX3XJN+xzskHO0TTaRlrx+vJC1JpQ2pQ
        TVWew8ASE8Yc7cZiVsOz9TTNOXodVzI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-2qylDWBuOPmxHvBleHzlmQ-1; Tue, 29 Sep 2020 18:44:04 -0400
X-MC-Unique: 2qylDWBuOPmxHvBleHzlmQ-1
Received: by mail-wr1-f72.google.com with SMTP id o6so2351096wrp.1
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 15:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66DSIrlhCeV+xyo2otn2L+hQAxSXyWg/ic5Sp/vZwto=;
        b=t9r7pBlb4rC+G4YfFQr9oLBivT8NlBtfa5+wckvZDkgd+wS4+pGmhAwrjjM7Rm+35D
         9rw7io9+heidZwaV0ggg2k/Nfa3y7WyCr6q78LP5t+dxvsdXKAagO/0RAd1QnHYhMGRz
         l+QrVbJm0Z08uGIwMd8vOyqq7x54y+3lqZbykvXyLwU0fBKC4rNSD3cDn5JUXRHL9n1G
         KAN6dl6dLvSBSxhAWi5tY0+Iz3HZYgOGXWoK8e7Tya1wr0x+wqVfaSw8kZad29Jp0m25
         r3eZLW6hMf/g5p0NX+LcbgPkZ6abcSevqoc7/gNisDQOCesxhlwPq7lvija0lEUHFoQE
         ic4g==
X-Gm-Message-State: AOAM533oPbBsoCfzBdMM/KnqGntW8tP5Bzlp83NWpRSD3YgxpQMB/PmF
        U5MlqxhL6T1rpEIw1Paw8IwoGyi1E3Pu/lWB/4bM0rGpdz9mMeXDETH8bvpL4pEKFTZX9uTNpEb
        Zh7S0K+sVx9n3
X-Received: by 2002:adf:efc9:: with SMTP id i9mr6933028wrp.187.1601419443106;
        Tue, 29 Sep 2020 15:44:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/JFirmQq0FLOkZYRppQAwyrCFiFhW/sOaJqe1ygyRV//BqkXnJHjtm0eIPBJooqWr+G3TNQ==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr6933012wrp.187.1601419442929;
        Tue, 29 Sep 2020 15:44:02 -0700 (PDT)
Received: from x1w.redhat.com (74.red-83-53-161.dynamicip.rima-tde.net. [83.53.161.74])
        by smtp.gmail.com with ESMTPSA id t202sm7798963wmt.14.2020.09.29.15.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:44:02 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH v4 01/12] accel/tcg: Add stub for cpu_loop_exit()
Date:   Wed, 30 Sep 2020 00:43:44 +0200
Message-Id: <20200929224355.1224017-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929224355.1224017-1-philmd@redhat.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the support of SYS_READC in commit 8de702cb67 the
semihosting code is strongly depedent of the TCG accelerator
via a call to cpu_loop_exit().

Ideally we would only build semihosting support when TCG
is available, but unfortunately this is not trivial because
semihosting is used by many targets in different configurations.
For now add a simple stub to avoid link failure when building
with --disable-tcg:

  hw/semihosting/console.c:160: undefined reference to `cpu_loop_exit'

Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 accel/stubs/tcg-stub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/accel/stubs/tcg-stub.c b/accel/stubs/tcg-stub.c
index e4bbf997aa..1eec7fb90e 100644
--- a/accel/stubs/tcg-stub.c
+++ b/accel/stubs/tcg-stub.c
@@ -29,3 +29,8 @@ void *probe_access(CPUArchState *env, target_ulong addr, int size,
      /* Handled by hardware accelerator. */
      g_assert_not_reached();
 }
+
+void cpu_loop_exit(CPUState *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.26.2


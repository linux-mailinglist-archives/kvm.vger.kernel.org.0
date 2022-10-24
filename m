Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B09609D9D
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiJXJNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiJXJNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:38 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95CA5C951
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:21 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q71so8180867pgq.8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JI6xgwjY9qAqH7+ofTPnYV1zYKHo6juwDwO6LRgYnj8=;
        b=jeXWHrRuhJfHKrMJw+Wm/v2mHZG+d3nQmVwwV1pgTkEUdVTF6TgAIQA9ozunZ7qdAj
         55VuwScf4i9VwhiKJKX0BbTOkVdW13lqFUhgxRsh1a2VCSbDFL8BNAARh/wNPJ3t9fo+
         kZ9ff7FasfbmNTbJGAkEXpnBmwYUb9+4MjHZPXgk+iVuVCcgNufTbsjE6Aa9ZnWGOHJ/
         5lPHAF9poq77+TpF1OrFzo01495+c1RVlLEAa2eFgegAO1PGywJ4Nl2jLoYh4XKec18f
         Kb0dKCI2PcIPg/U3ZX9VYrUEVizVGOLFc/H1G0EZg9klnHA1kxPlY/+qyX9AyVdyKuOZ
         f45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JI6xgwjY9qAqH7+ofTPnYV1zYKHo6juwDwO6LRgYnj8=;
        b=0W3jZl28tmoGoKbahXlE23mrnSpySYss3ANm2RNBM9cYlzX6p68KfwU3yfreVhUgXJ
         YEMcqA/lDiOJI31OMHlS9owzjbRIWPGDodhToKE0XznuYJahNzpX5UKCR3NqGZ2o+Cc8
         TKOT/YyUsXraU7GEEz3F83KVYYFTTplbtTgkF2yzHbvk9QsPQ3l2x/1QfuNX6WwqmeaC
         9FIa7Q3cXX+/j525uGH8yU9BnRkFqhDTeTvSz524aEurc83upNzhLLLFwUGxyoAfC7uh
         2KHwL/nL1SKGMRHAvzo6ddk/88hMhO7RZoBO0IJ0zhavWYcUbcM5+XwEQ0eEjxUSgF/L
         Ic7w==
X-Gm-Message-State: ACrzQf3iLar9DxnBojsrceWwI7jTK184p7Zqw75+XY/1Tv//stPqkUjj
        Xsd+l1Ss2gxh/Y920DQUBII=
X-Google-Smtp-Source: AMsMyM5Axq2t8+gW/6YYwbpplXF8QRbtngzxHk8TeeJr6uPNp+k0P1ehnJzU5s4MN4RCt+4w5Bdwbg==
X-Received: by 2002:a63:211a:0:b0:451:f444:3b55 with SMTP id h26-20020a63211a000000b00451f4443b55mr26561891pgh.60.1666602801164;
        Mon, 24 Oct 2022 02:13:21 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:20 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 12/24] x86/pmu: Rename PC_VECTOR to PMI_VECTOR for better readability
Date:   Mon, 24 Oct 2022 17:12:11 +0800
Message-Id: <20221024091223.42631-13-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

The original name "PC_VECTOR" comes from the LVT Performance
Counter Register. Rename it to PMI_VECTOR. That's much more familiar
for KVM developers and it's still correct, e.g. it's the PMI vector
that's programmed into the LVT PC register.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index d0de196..3b36caa 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -11,7 +11,9 @@
 #include <stdint.h>
 
 #define FIXED_CNT_INDEX 32
-#define PC_VECTOR	32
+
+/* Performance Counter Vector for the LVT PC Register */
+#define PMI_VECTOR	32
 
 #define EVNSEL_EVENT_SHIFT	0
 #define EVNTSEL_UMASK_SHIFT	8
@@ -159,7 +161,7 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
 	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
     }
     global_enable(evt);
-    apic_write(APIC_LVTPC, PC_VECTOR);
+    apic_write(APIC_LVTPC, PMI_VECTOR);
 }
 
 static void start_event(pmu_counter_t *evt)
@@ -662,7 +664,7 @@ static void check_invalid_rdpmc_gp(void)
 int main(int ac, char **av)
 {
 	setup_vm();
-	handle_irq(PC_VECTOR, cnt_overflow);
+	handle_irq(PMI_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
 	check_invalid_rdpmc_gp();
@@ -686,7 +688,7 @@ int main(int ac, char **av)
 	printf("Fixed counters:      %d\n", pmu_nr_fixed_counters());
 	printf("Fixed counter width: %d\n", pmu_fixed_counter_width());
 
-	apic_write(APIC_LVTPC, PC_VECTOR);
+	apic_write(APIC_LVTPC, PMI_VECTOR);
 
 	check_counters();
 
-- 
2.38.1


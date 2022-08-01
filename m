Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD622586BC9
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 15:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiHANSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 09:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiHANSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 09:18:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7CA2B267
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 06:18:35 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id i71so4120256pge.9
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 06:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g3uW/u8IS+It3J0szOW84VRij0/I3c1Tajm068uaOKs=;
        b=j4bUPpxHfl/mO8/8NOgq2HD15KVdoSupsR3MX6c/hBiVS/6OCFEoacQUYzmrtS6WrY
         s1aiPhii4P5RK+HbrPLxJevnfobqZWd9heM2ZAGmWxmu1H0n7N1o+pWTle3wJK0lyIJO
         28A7W02RIWMXMb1DypJFNZIQlGdkTJtAQzZPqGEXtg1mE6rsTPV5Pip4r9isxvgPtNru
         77AWIySiMnEmpRaKuwk95UIbDJ4oTVrA6DWYpiDoCAAGYLAQtocPBL6pyUmLI0SAXoUO
         8vFcC4cC/+wMRg8S5o3SwQv311KrFhS1rc6CErGbNTWeCFH6nVlMGDhkeSOe3SY2q68I
         BbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g3uW/u8IS+It3J0szOW84VRij0/I3c1Tajm068uaOKs=;
        b=wqzLCE3m3KaKP3A+EBGHtWMfXtlmVAlLcSrKJnWe6k3Zboag0005CpU3BvJJM8v07Z
         RGJlTDWlEErv2uyZRkP9cjOTgeQ3R9Hy64yRvGnR8jS8NOr9AvKf9+wW8r7/yO75TiEt
         WJiPVrtJ2jgwsniHKumNMaRCpNk2Ap9jnZn0oLSXUhVrRY7I/whd+sA/pzrbVvXBI28I
         wNG+Rg4suvw8J4453sMEO4z1XVh+51Gy7ykRkQZrfsfKrKWKiDRR54TQDttAuSJf8Uzi
         i6VV3kZ9rO/jkdKoONWFzwT1Xx3v6KM5QzQpjY3Ps/sQ39F0UfBlzmrYkYPzYosjU/X7
         WuTQ==
X-Gm-Message-State: AJIora8ybshpVzKufLRYIH/g72DEvuA9jkHZSpKVUgNT8zLQ5YMk/eDb
        Y1gCJMyfFb3p1QyJbIGpOu0=
X-Google-Smtp-Source: AGRyM1s9DpiF4Mvi+gMi8V++frjUY3EuI743BMIKlaWzVeXZLCPLYGrHwkLZCG2awbwkKX1b6tMbNQ==
X-Received: by 2002:a63:f355:0:b0:419:8dfd:45d0 with SMTP id t21-20020a63f355000000b004198dfd45d0mr13289679pgj.226.1659359914373;
        Mon, 01 Aug 2022 06:18:34 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i27-20020aa796fb000000b0052ab912b0fasm8621351pfq.2.2022.08.01.06.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 06:18:33 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests  PATCH] x86/pmu: Reset the expected count of the fixed counter 0 when i386
Date:   Mon,  1 Aug 2022 21:18:14 +0800
Message-Id: <20220801131814.24364-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
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

The pmu test check_counter_overflow() always fails with the "./configure
--arch=i386". The cnt.count obtained from the latter run of measure()
(based on fixed counter 0) is not equal to the expected value (based
on gp counter 0) and there is a positive error with a value of 2.

The two extra instructions come from inline wrmsr() and inline rdmsr()
inside the global_disable() binary code block. Specifically, for each msr
access, the i386 code will have two assembly mov instructions before
rdmsr/wrmsr (mark it for fixed counter 0, bit 32), but only one assembly
mov is needed for x86_64 and gp counter 0 on i386.

Fix the expected init cnt.count for fixed counter 0 overflow based on
the same fixed counter 0, not always using gp counter 0.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 01be1e9..4bb24e9 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -304,6 +304,10 @@ static void check_counter_overflow(void)
 
 		if (i == nr_gp_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
+			cnt.count = 0;
+			measure(&cnt, 1);
+			count = cnt.count;
+			cnt.count = 1 - count;
 			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
 		}
 
-- 
2.37.1


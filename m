Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1CA13D98
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 07:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfEEFxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 01:53:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43786 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEFxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 01:53:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id e67so5004499pfe.10
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 22:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TbYxH0SpXVKzc0opAPWvNbeLL6XJnquRRyHW2D18r2w=;
        b=g5ylm6sya/K+bwb7ZNAiLM0guyEj8GrILmAhq2t2mxZU6J7a6YDpqvcZKYb/8OgR7u
         6MGA3EPKzieWEjR8zv6QI8wAjIe96Rmawu7ongfPYJ01dj2gCZE1TBY20mDZcLZ1NrS7
         O5f1m5MsE7H8sE5dF2dIZ7jbjY4KEmP5IPso26526kUtmXr7AeHH04x243Xdhu7iw2SO
         pAXXFYKCQOV0j9iCMW3Un4Dpu4CgLnRNmIE+JRBoy2+uy8X0z+xS62xA3RzIplVIEkKP
         F51sYNXQdDVYZedCXU5/XbCVXIaFGQ8DS+DncpHNdOltsJN8LbUnQ0iO2Z3tVvkRT9Oa
         nGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TbYxH0SpXVKzc0opAPWvNbeLL6XJnquRRyHW2D18r2w=;
        b=b+kS0XZ2DAzjVgRQTvBElgwy/48irotaHvMTqXFJRZVY0B8h56TCFn/zfYZAiFU1Vs
         1BejgG5eru98V1fWsnMb29cWFx32HkhTnEE+2ZrPl+lzrsVBB4joPf/KXpVpP/7afFiu
         VuVY+UR+UZ9MNIKXu3NfM9/wnhOCscn+4qQsEL5TerzS4I9la0FidBt6ltNzkd/rDXNP
         +1upk49yxXod3Ui527rtl1Z6GsOsRMtu1+TOnJO88TgAElGhLrtdyMAD0WL6obuWBMQk
         Gw1yjJqEDrccqh9I/hz4ujMCGKGN1qtDHItYkBFJ0nXn5xA0+JcRl9hyV3kBA8QK6NC3
         3Mkg==
X-Gm-Message-State: APjAAAV7WopJFJf91AENm3phSzUyIn4E7dAuvocGNgpAUqCRwCDRinpz
        xdVWmGn0aFZoqi4aUK8j1lk=
X-Google-Smtp-Source: APXvYqz5xv9pNPSAk+pVmpsh9gs5JIEUYAC2gRVfJe0bzIeMU1lfIXTO2EWUncgJh6SqlhUMCJZqSg==
X-Received: by 2002:aa7:9563:: with SMTP id x3mr15523361pfq.118.1557035617108;
        Sat, 04 May 2019 22:53:37 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id g72sm20634160pfg.63.2019.05.04.22.53.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 22:53:36 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: PMU: Make fast counters test optional
Date:   Sat,  4 May 2019 15:31:42 -0700
Message-Id: <20190504223142.26668-3-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504223142.26668-1-nadav.amit@gmail.com>
References: <20190504223142.26668-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The fast counters are optional. As the Intel SDM says: "ECX[31] selects
"fast" read mode if supported." Skip the test is the fast counters are
not supported.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/pmu.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index afb387b..cb8c9e3 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -354,15 +354,32 @@ static void check_gp_counter_cmask(void)
 	report("cmask", cnt.count < gp_events[1].min);
 }
 
+static void do_rdpmc_fast(void *ptr)
+{
+	pmu_counter_t *cnt = ptr;
+	uint32_t idx = (uint32_t)cnt->idx | (1u << 31);
+
+	if (!is_gp(cnt))
+		idx |= 1 << 30;
+
+	cnt->count = rdpmc(idx);
+}
+
+
 static void check_rdpmc(void)
 {
 	uint64_t val = 0x1f3456789ull;
+	bool exc;
 	int i;
 
 	report_prefix_push("rdpmc");
 
 	for (i = 0; i < num_counters; i++) {
 		uint64_t x;
+		pmu_counter_t cnt = {
+			.ctr = MSR_IA32_PERFCTR0 + i,
+			.idx = i
+		};
 
 		/*
 		 * Only the low 32 bits are writable, and the value is
@@ -375,14 +392,28 @@ static void check_rdpmc(void)
 
 		wrmsr(MSR_IA32_PERFCTR0 + i, val);
 		report("cntr-%d", rdpmc(i) == x, i);
-		report("fast-%d", rdpmc(i | (1<<31)) == (u32)val, i);
+
+		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
+		if (exc)
+			report_skip("fast-%d", i);
+		else
+			report("fast-%d", cnt.count == (u32)val, i);
 	}
 	for (i = 0; i < edx.split.num_counters_fixed; i++) {
 		uint64_t x = val & ((1ull << edx.split.bit_width_fixed) - 1);
+		pmu_counter_t cnt = {
+			.ctr = MSR_CORE_PERF_FIXED_CTR0 + i,
+			.idx = i
+		};
 
 		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, x);
 		report("fixed cntr-%d", rdpmc(i | (1 << 30)) == x, i);
-		report("fixed fast-%d", rdpmc(i | (3<<30)) == (u32)val, i);
+
+		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
+		if (exc)
+			report_skip("fixed fast-%d", i);
+		else
+			report("fixed fast-%d", cnt.count == (u32)x, i);
 	}
 
 	report_prefix_pop();
-- 
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA8A6172BE
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiKBXhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiKBXgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:36:32 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECBE167D8
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:28:28 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o15-20020a17090aac0f00b00212e93524c0so2507857pjq.2
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iC0/T0AhLSWTGEIBQBOFB08rB97eCOcnEVK/qTBONrw=;
        b=tZw/FyIVcLFV6FA43bzdEfF9B7To8LmWA2trx2hUjXhZIwCqyiHS5JPWpTe77VM+Zu
         A0vvMWIX0mmMQWsuW5gcXP3zUecRsw2cEjV1dUamNxNTGcfF4iz6i7W1YHi7fo209V7r
         71ruyH5ckKO+X8r5hZ/fgQw9WCkg6P0aeK1P9N3IfL9vGCZY4+40d3hRKxGy6cPRSIcX
         p9l2yO/RmzfjCYN3NyPDHhIPEt/IJqmX6893+qbHH/TBu0mbukYWgjozBLmpd7BUYWQ7
         aIkUPatwDmQMh/4L6DZOR53SFEGISgBmptXfdW0zNg5biLNXlqn8WbVsG6doRANl/F7u
         nS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iC0/T0AhLSWTGEIBQBOFB08rB97eCOcnEVK/qTBONrw=;
        b=YRrhan3oSd5DPv0GgPyHHexpYOqhVgWal3O3Iv0wWAWh6Xtwi1NvD5e+pKNtGOgxBE
         KOEFIBPTcsLiVJdiorVklvCE9e5WitirkNEzCBtbepJuvXLRAOjH8OJ6anjDYRFQ9HAv
         xmfAZVSGTx+YymIeLo8r7XrOjIgMEEuWredUy+eblTSKJ/8hyMKJ+wzaN2it+Iywby1r
         Kc6hLSBUSl6izJ351kSOimPXxPuLtPyNvF8urNTt2Cr187subs9gD0KKLFLQKa94Jj/k
         QDn9eRk30d+g45MbLh6PJwKQflGxYbhomUtEV0/2v8ik9DgrJHQt1Rj5PKJmbNUIoB43
         Whhw==
X-Gm-Message-State: ACrzQf2HeZVtKjOaKEY3P4ZofaIM3j//CnxJqEX3h2/+DT70AnfGaHXw
        zoMqICleNm9C4CGalh0QssZO9iwbQmCI
X-Google-Smtp-Source: AMsMyM61FNEiVQWuNH7mOrtoQRc8w0APwU7lOPDXjoN9Hj57SRUwOg2Sw6SxLFHZFguL9+guFX0Pqt4t0MYp
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:1d90:b0:213:d0a2:72ab with SMTP id
 pf16-20020a17090b1d9000b00213d0a272abmr21443758pjb.221.1667431667652; Wed, 02
 Nov 2022 16:27:47 -0700 (PDT)
Date:   Wed,  2 Nov 2022 16:27:34 -0700
In-Reply-To: <20221102232737.1351745-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221102232737.1351745-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102232737.1351745-5-vipinsh@google.com>
Subject: [PATCH v8 4/7] KVM: selftests: Use SZ_1G from sizes.h in max_guest_memory_test.c
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace size_1gb defined in max_guest_memory_test.c with the SZ_1G from
linux/sizes.h header file.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/max_guest_memory_test.c        | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 1595b73dc09a..8056dc5831b5 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -11,6 +11,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/atomic.h>
+#include <linux/sizes.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -162,8 +163,7 @@ int main(int argc, char *argv[])
 	 * just below the 4gb boundary.  This test could create memory at
 	 * 1gb-3gb,but it's simpler to skip straight to 4gb.
 	 */
-	const uint64_t size_1gb = (1 << 30);
-	const uint64_t start_gpa = (4ull * size_1gb);
+	const uint64_t start_gpa = SZ_4G;
 	const int first_slot = 1;
 
 	struct timespec time_start, time_run1, time_reset, time_run2;
@@ -180,13 +180,13 @@ int main(int argc, char *argv[])
 	 * are quite common for x86, requires changing only max_mem (KVM allows
 	 * 32k memslots, 32k * 2gb == ~64tb of guest memory).
 	 */
-	slot_size = 2 * size_1gb;
+	slot_size = SZ_2G;
 
 	max_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
 	TEST_ASSERT(max_slots > first_slot, "KVM is broken");
 
 	/* All KVM MMUs should be able to survive a 128gb guest. */
-	max_mem = 128 * size_1gb;
+	max_mem = 128ull * SZ_1G;
 
 	calc_default_nr_vcpus();
 
@@ -197,11 +197,11 @@ int main(int argc, char *argv[])
 			TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");
 			break;
 		case 'm':
-			max_mem = atoi_paranoid(optarg) * size_1gb;
+			max_mem = 1ull * atoi_paranoid(optarg) * SZ_1G;
 			TEST_ASSERT(max_mem > 0, "memory size must be >0");
 			break;
 		case 's':
-			slot_size = atoi_paranoid(optarg) * size_1gb;
+			slot_size = 1ull * atoi_paranoid(optarg) * SZ_1G;
 			TEST_ASSERT(slot_size > 0, "slot size must be >0");
 			break;
 		case 'H':
@@ -245,7 +245,7 @@ int main(int argc, char *argv[])
 
 #ifdef __x86_64__
 		/* Identity map memory in the guest using 1gb pages. */
-		for (i = 0; i < slot_size; i += size_1gb)
+		for (i = 0; i < slot_size; i += SZ_1G)
 			__virt_pg_map(vm, gpa + i, gpa + i, PG_LEVEL_1G);
 #else
 		for (i = 0; i < slot_size; i += vm->page_size)
@@ -260,7 +260,7 @@ int main(int argc, char *argv[])
 	vcpus = NULL;
 
 	pr_info("Running with %lugb of guest memory and %u vCPUs\n",
-		(gpa - start_gpa) / size_1gb, nr_vcpus);
+		(gpa - start_gpa) / SZ_1G, nr_vcpus);
 
 	rendezvous_with_vcpus(&time_start, "spawning");
 	rendezvous_with_vcpus(&time_run1, "run 1");
-- 
2.38.1.273.g43a17bfeac-goog


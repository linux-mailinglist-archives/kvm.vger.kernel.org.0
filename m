Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042FF62A06B
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 18:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiKORd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 12:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiKORd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 12:33:56 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25152AC5
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:33:54 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-373582569edso139551127b3.2
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qN910hWbp0G+0j1u4FtQw9avjTAO8HEceklYfG84xcU=;
        b=pMxNlPLcK0k/NwfW5wny+v/2L3HNUuuknK6Cou7WrBgtxIG8dNhFPVEXi7A1M9tgtB
         MtxuT2RBujIseHio1Oi/V7tN0/KDyIxSKUXXtsRX0F/8DtfSl6m5yl184ucKgCrOmBd5
         e51CBAOdLXcwl3ofwVIINRmkV3R5c9cEI2fPcd5k6zb7ah6RBRNtW5WQQ/qqRwAm+lXm
         Jo864etKkISYNMUTO2szVS+fwZ6kL8w+CdmGRk+CAGjw3nXBhJkVUkD2IUGIZug7VTtM
         v4NZ33hIowG6ntyTYBuOPS+QzSbXtBvVK7TXlU+DCJOPNiI029VG5/CtI8WkkiiSbWl1
         4scQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qN910hWbp0G+0j1u4FtQw9avjTAO8HEceklYfG84xcU=;
        b=nVSgHjgBx7vGCR2P1CyW7XPd7BnrN1EY5FpUuitG3YqG2ZCGca06X5aSZwx488EdDl
         jLfi/j25dBGbibtECWiJSjGD2lwqy4uoZLuF2aYNaul++hMzC1FENNhdApO1zvSXXRST
         CDfD6WRNVojECrvC/Ne2SdBeXKd60OU61M0dptn+D9iC+tT9UuYzrTx/juQ84bAhC7XR
         Rk1sGlx0glfCfzoz/w6BTuxcSkofZkdmq+NuZ86sigxAqGGtq57oPCGYxPX5+2UdNKE1
         4guDG+sppNe7H2C0w6yBpAw3qgafyhmOXLVAd0LejRz6bxjDcTI07UyqSu4Rpm02JZMB
         ndZA==
X-Gm-Message-State: ACrzQf1BHXwGWFj+r2+YB+Pw7Hx+Jd3GWIqustKhAg39PYjU4vdu7sL9
        zAnNGHCfcEzT4o5Imh1g7yEnjDxazbIE0V85u3o89GCXgQ6TrwD+QSoOjxbvZcuF6067SwixMJL
        bo533kOxaYnPSh35L8WwXDR7SIPN85OZsXArCu2LNyDgh0vJVQ3GTBgyx3UZHhJME9h/SMnE=
X-Google-Smtp-Source: AMsMyM4SGJ3fRCMs9hI1adFvA/DAzsP1MqlrBwcR31lxCdARpoZTkBSMqMNgrYFQrMDSd58nTKcghV94yXn+MQtQPg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5b:3ca:0:b0:6cf:dda2:8e64 with SMTP
 id t10-20020a5b03ca000000b006cfdda28e64mr49337908ybp.552.1668533633390; Tue,
 15 Nov 2022 09:33:53 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:32:56 +0000
In-Reply-To: <20221115173258.2530923-1-coltonlewis@google.com>
Mime-Version: 1.0
References: <20221115173258.2530923-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115173258.2530923-2-coltonlewis@google.com>
Subject: [PATCH 1/3] KVM: selftests: Allocate additional space for latency samples
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        seanjc@google.com, bgardon@google.com, oupton@google.com,
        ricarkol@google.com, Colton Lewis <coltonlewis@google.com>
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

Allocate additional space for latency samples. This has been separated
out to call attention to the additional VM memory allocation. The test
runs out of physical pages without the additional allocation. The 100
multiple for pages was determined by trial and error. A more
well-reasoned calculation would be preferable.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/lib/perf_test_util.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 137be359b09e..a48904b64e19 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -38,6 +38,12 @@ static bool all_vcpu_threads_running;
 
 static struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
+#define SAMPLES_PER_VCPU 1000
+#define SAMPLE_CAPACITY (SAMPLES_PER_VCPU * KVM_MAX_VCPUS)
+
+/* Store all samples in a flat array so they can be easily sorted later. */
+uint64_t latency_samples[SAMPLE_CAPACITY];
+
 /*
  * Continuously write to the first 8 bytes of each page in the
  * specified region.
@@ -122,7 +128,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 {
 	struct perf_test_args *pta = &perf_test_args;
 	struct kvm_vm *vm;
-	uint64_t guest_num_pages, slot0_pages = 0;
+	uint64_t guest_num_pages, sample_pages, slot0_pages = 0;
 	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
 	uint64_t region_end_gfn;
 	int i;
@@ -161,7 +167,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, slot0_pages + guest_num_pages,
+	sample_pages = 100 * sizeof(latency_samples) / pta->guest_page_size;
+	vm = __vm_create_with_vcpus(mode, nr_vcpus,
+				    slot0_pages + guest_num_pages + sample_pages,
 				    perf_test_guest_code, vcpus);
 
 	pta->vm = vm;
-- 
2.38.1.431.g37b22c650d-goog


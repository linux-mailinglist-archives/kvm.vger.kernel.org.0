Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE7C18A0B3
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCRQio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:38:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59491 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727095AbgCRQin (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FINdKLbbHP/xOh0Xglhm9n3sMdHfcvPlDNVTGKPb5V4=;
        b=LqlNH4lVfdOKQT/T6uqj9cUYH2Dc9BgVcmVKqhx5CJW7Y8PSL2UVFfaSYacOs8eiE6NwZ1
        l8nS5CSPNymFoFEaBSiSI4YuOkwnFQ5dgQb4IdG+kV2Gb+oVSPXXsdm5KEBwew0d096aoH
        qDmzpvgNIJF3vVQ6ywozpwo3hh/FuG0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-dkRxssW_MX6pGXwd0BvwXQ-1; Wed, 18 Mar 2020 12:38:40 -0400
X-MC-Unique: dkRxssW_MX6pGXwd0BvwXQ-1
Received: by mail-wm1-f72.google.com with SMTP id n188so1345620wmf.0
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FINdKLbbHP/xOh0Xglhm9n3sMdHfcvPlDNVTGKPb5V4=;
        b=BoNxMs/em3Efnvlvu6aGu6HOHlP3lQvR0vGNPeEoxqD5M6hWVyLyQxODoReP2ANJHo
         7xfDElAX7nyXRkyIBlnDhJWHq3e8vTOYauFg6hiYo8cwdcM0HZZcIQwyGqVjvKS/HY/j
         uItDdGuTWFI3TO8+NSzTUmnkI7J3zNreNgxieOSi2NzpRYvMEIpHbFCX/s1SlIpjIhJ1
         6P8gxTTJx7DkLT2TuG0/z9q6EcWWOJM55YzOejmcg9jOxwMzQncQRfJk2yCTvRSYeYZs
         BeQcWTJJQhyDVt2mhnDO670/+ASihZEBKbtVqr/ePVgnAIcn6sER6mhQiFe1JDFJ57GB
         aHjA==
X-Gm-Message-State: ANhLgQ3gNW+AfXWgPV9Iy4kbN0E0JBCP42DBnVvX8sQbcB06+z8mCXvy
        RmCxfC4LlpZRJ9oOgykOSx2posi7Hie1HRm+iY+3yagunDJ90y0nmoW1R8wt5J9e06595OEUCYE
        sirzaUvNA/9wd
X-Received: by 2002:a1c:e1c3:: with SMTP id y186mr2852244wmg.151.1584549519248;
        Wed, 18 Mar 2020 09:38:39 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vv8Z8cppQXQ29GsS0JjpdcT/eLmYBtaeDT+iFLEtrrWGXEFawmBCsPt4YkOsh7q/jt6uoOyow==
X-Received: by 2002:a1c:e1c3:: with SMTP id y186mr2852217wmg.151.1584549518972;
        Wed, 18 Mar 2020 09:38:38 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t9sm6764971wrx.31.2020.03.18.09.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:38:38 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 11/14] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Wed, 18 Mar 2020 12:37:17 -0400
Message-Id: <20200318163720.93929-12-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318163720.93929-1-peterx@redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a hook for the checks after vcpu_run() completes.  Preparation
for the dirty ring test because we'll need to take care of another
exit reason.

Since at it, drop the pages_count because after all we have a better
summary right now with statistics, and clean it up a bit.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 41 ++++++++++++++------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 139ccb550618..94122c2e0185 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -178,6 +178,15 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
 }
 
+static void default_after_vcpu_run(struct kvm_vm *vm)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+
+	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
+		    "Invalid guest sync status: exit_reason=%s\n",
+		    exit_reason_str(run->exit_reason));
+}
+
 struct log_mode {
 	const char *name;
 	/* Return true if this mode is supported, otherwise false */
@@ -187,16 +196,20 @@ struct log_mode {
 	/* Hook to collect the dirty pages into the bitmap provided */
 	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 				     void *bitmap, uint32_t num_pages);
+	/* Hook to call when after each vcpu run */
+	void (*after_vcpu_run)(struct kvm_vm *vm);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
 		.collect_dirty_pages = dirty_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 	{
 		.name = "clear-log",
 		.supported = clear_log_supported,
 		.create_vm_done = clear_log_create_vm_done,
 		.collect_dirty_pages = clear_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 };
 
@@ -247,6 +260,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
 	mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
 }
 
+static void log_mode_after_vcpu_run(struct kvm_vm *vm)
+{
+	struct log_mode *mode = &log_modes[host_log_mode];
+
+	if (mode->after_vcpu_run)
+		mode->after_vcpu_run(vm);
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 	uint64_t i;
@@ -261,25 +282,23 @@ static void *vcpu_worker(void *data)
 	struct kvm_vm *vm = data;
 	uint64_t *guest_array;
 	uint64_t pages_count = 0;
-	struct kvm_run *run;
+	struct sigaction sigact;
 
-	run = vcpu_state(vm, VCPU_ID);
+	current_vm = vm;
+	vcpu_fd = vcpu_get_fd(vm, VCPU_ID);
+	memset(&sigact, 0, sizeof(sigact));
+	sigact.sa_handler = vcpu_sig_handler;
+	sigaction(SIG_IPI, &sigact, NULL);
 
 	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
-	generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 
 	while (!READ_ONCE(host_quit)) {
+		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
+		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
 		ret = _vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
-			pages_count += TEST_PAGES_PER_LOOP;
-			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
-		} else {
-			TEST_FAIL("Invalid guest sync status: "
-				  "exit_reason=%s\n",
-				  exit_reason_str(run->exit_reason));
-		}
+		log_mode_after_vcpu_run(vm);
 	}
 
 	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
-- 
2.24.1


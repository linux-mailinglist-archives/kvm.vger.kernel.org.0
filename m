Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AB117EBFD
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 23:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgCIWZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 18:25:31 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35088 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727206AbgCIWZa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 18:25:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583792728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYsgWKedk4JgdTdZEDHh7mPLAInxvRsrPeWFUx8JX40=;
        b=HC+JvTIUSk33z3CcFJN/d3swebeen/tqDNc13uBsm5GeUqHn5rcApUmh9u1Mnvb3aBqCPb
        Vlp5WJPFUr5eLcuJjsjiIVKERRVsXQkgAxWoA98vNabJ6O5aUo6l7FjTpGkz2dZt+zFtt2
        FDU38XuhDF4Fr6yiOESuTVJ96D9b1oE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-l_O-RngGMXu3f0jx_aFtsA-1; Mon, 09 Mar 2020 18:25:27 -0400
X-MC-Unique: l_O-RngGMXu3f0jx_aFtsA-1
Received: by mail-qk1-f198.google.com with SMTP id d2so8360742qko.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 15:25:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WYsgWKedk4JgdTdZEDHh7mPLAInxvRsrPeWFUx8JX40=;
        b=eCh/DPOow3e8YqEsBpsB1Bp+iTK0lSy/N+Sti++xwOfG02WOnI8fI2i99Qi8Ky6CC6
         7e/KFKQSNxVmg47YeGamqp7/11DpnBaFREypFTqAM6L2fsZAB9QsIeKtL4fDn2T67uFt
         3O/M+ON5rjx876jMkzMGCSM6d+DhO1c6T577bBNCORCl+7AeA3EVVQxNyZn7AW6ptLD5
         VDgYS/TcQbeuLMf739pcmrpcItLLRnVk7621t6igxWbQLO4zn90NxJ1njC2mATo3nHoy
         yodNynD9gge0TSwIOmQRzoPssBvjxYYhDVBWcGIwwlhOsrTQru2hiZfmsfyiN5bAqSJC
         j5zA==
X-Gm-Message-State: ANhLgQ3GgLBXGDL3Sjot9A552l3RJIlwdYzsBrPV7OIM09Wrnbm1ssYj
        Odeq9LDVbvAw8FNnTPHLNWzzPh357Vs/dMvvzKuqecTosNmRZPLLNVtXJKz2IzT35h6ofBjc0NE
        Gb8jvLRk0txIK
X-Received: by 2002:a37:a0c1:: with SMTP id j184mr10432508qke.351.1583792726903;
        Mon, 09 Mar 2020 15:25:26 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vv2Ogo2VnD+jgwtXg8mGNvF8li+aVTc7yLXr21eAVFTV6vWz/X/IJj/CZ8DwudKU5ic+0psOA==
X-Received: by 2002:a37:a0c1:: with SMTP id j184mr10432487qke.351.1583792726674;
        Mon, 09 Mar 2020 15:25:26 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id j17sm23660450qth.27.2020.03.09.15.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 15:25:26 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v6 11/14] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Mon,  9 Mar 2020 18:25:24 -0400
Message-Id: <20200309222524.345649-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: 
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
 tools/testing/selftests/kvm/dirty_log_test.c | 39 ++++++++++++--------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 642886394e34..b6fb4f86032c 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -173,6 +173,15 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -182,16 +191,20 @@ struct log_mode {
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
 
@@ -241,6 +254,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -254,31 +275,17 @@ static void *vcpu_worker(void *data)
 	int ret;
 	struct kvm_vm *vm = data;
 	uint64_t *guest_array;
-	uint64_t pages_count = 0;
-	struct kvm_run *run;
-
-	run = vcpu_state(vm, VCPU_ID);
 
 	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
-	generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 
 	while (!READ_ONCE(host_quit)) {
+		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		/* Let the guest dirty the random pages */
 		ret = _vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
-			pages_count += TEST_PAGES_PER_LOOP;
-			generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
-		} else {
-			TEST_ASSERT(false,
-				    "Invalid guest sync status: "
-				    "exit_reason=%s\n",
-				    exit_reason_str(run->exit_reason));
-		}
+		log_mode_after_vcpu_run(vm);
 	}
 
-	DEBUG("Dirtied %"PRIu64" pages\n", pages_count);
-
 	return NULL;
 }
 
-- 
2.24.1


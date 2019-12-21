Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21737128689
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfLUCE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:04:57 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35221 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726847AbfLUCEz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 21:04:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aF1BdxIc7NPI7Dsk+3ZH17n/EhvhXEPJcTNSoSkH9Wk=;
        b=fMrC20f2urO0B/9dWHV/2JMkH3k/ATfyJ4S7EFgZiTLVoUPui0ADReRDRgl/0CaWUx8dgr
        jEOpiVt+PWiREb6c2nDQpPQOCzhhdYf/kF8biJtcq5SfeoOmTiLnZFo34mi8p2gjiG7txd
        aZ7udfbZXNb0/G+9qatmlKYL0oTW3hk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-4goukEwyMfKtlVIsPoSgzA-1; Fri, 20 Dec 2019 21:04:53 -0500
X-MC-Unique: 4goukEwyMfKtlVIsPoSgzA-1
Received: by mail-qt1-f200.google.com with SMTP id 69so7198895qtb.15
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 18:04:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aF1BdxIc7NPI7Dsk+3ZH17n/EhvhXEPJcTNSoSkH9Wk=;
        b=s0IzemJse1i2eyoKQyQgN5fRoQbjYXCtR230M4FIJyW+/VrM8GMvtUjfqtT/2vMpFM
         iAGAmyEqqp6DM8N1TXRLZzkt4OHsnyJ1swxJxc7S0NQWBbhlS4UakUA0uk0Jd41zDsmu
         jYgjGofG69J4UNkQsxkixUMbfR4QH33u4jvTfcFNxgnHwai9riFnvWr1HHhdkiZOi14V
         hfdW76XabMhYaWo9bXn2NQ/Oi701nom2/l7UYCLBxMlPVUugtB5g3hMdGVvjm8LeENJu
         l+JSlFI8gPJvv4F6JLt54UgWwgYq8s+dL8jPzWD8c07G/1N6ZNy/Mi+p6Di3pXjIoWv/
         8ijw==
X-Gm-Message-State: APjAAAX+XYwMmJ+2unRjCAu9p1DS415QWYfyqenYYS0lCQWWGw8H7jil
        0CSuAl4gDK4DuPZr8SD1s4KWVnXHMiZyq1j0/Z/pcyt85YjeimHOuLUsIouVYqB4FVAMnziumwa
        vOwKU3BY9ql65
X-Received: by 2002:a05:620a:8cc:: with SMTP id z12mr15136107qkz.48.1576893893217;
        Fri, 20 Dec 2019 18:04:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqze3wpousDtO1Cg3rCaokc2Y6UrcDWT7bSvUIYkyNCYe9jbngVW85Imns2BMqMGirE7oFeSTQ==
X-Received: by 2002:a05:620a:8cc:: with SMTP id z12mr15136087qkz.48.1576893892973;
        Fri, 20 Dec 2019 18:04:52 -0800 (PST)
Received: from xz-x1.hitronhub.home ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id t7sm3400114qkm.136.2019.12.20.18.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 18:04:52 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 14/17] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Fri, 20 Dec 2019 21:04:42 -0500
Message-Id: <20191221020445.60476-4-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221020445.60476-1-peterx@redhat.com>
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
index a8ae8c0042a8..3542311f56ff 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -168,6 +168,15 @@ static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
 	/* Hook when the vm creation is done (before vcpu creation) */
@@ -175,16 +184,20 @@ struct log_mode {
 	/* Hook to collect the dirty pages into the bitmap provided */
 	void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 				     void *bitmap, uint32_t num_pages);
+	/* Hook to call when after each vcpu run */
+	void (*after_vcpu_run)(struct kvm_vm *vm);
 } log_modes[LOG_MODE_NUM] = {
 	{
 		.name = "dirty-log",
 		.create_vm_done = NULL,
 		.collect_dirty_pages = dirty_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 	{
 		.name = "clear-log",
 		.create_vm_done = clear_log_create_vm_done,
 		.collect_dirty_pages = clear_log_collect_dirty_pages,
+		.after_vcpu_run = default_after_vcpu_run,
 	},
 };
 
@@ -224,6 +237,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
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
@@ -237,31 +258,17 @@ static void *vcpu_worker(void *data)
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


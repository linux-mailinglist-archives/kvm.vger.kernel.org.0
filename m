Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763E1135C00
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbgAIO6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:58:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22704 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732085AbgAIO6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 09:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aF1BdxIc7NPI7Dsk+3ZH17n/EhvhXEPJcTNSoSkH9Wk=;
        b=OmDXlBvgH7rq8KYaqPFNdHAfEhiFkGrqhZDT2RPlzNI82hkUBVh0dJIsC/+qQm8o0XjiLz
        GjsK/NYNPOof+iSNZ2aLV9YCzzyWRas2ob0qMAvZFYcrQRcD4WlzRUyZczWwVVutkY/A5U
        O43gaiJRLWVbgcMZ9Tckwek/d2SZA9U=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-uU328G38NZWKiO9Mf87s7A-1; Thu, 09 Jan 2020 09:58:20 -0500
X-MC-Unique: uU328G38NZWKiO9Mf87s7A-1
Received: by mail-qv1-f69.google.com with SMTP id g6so4276815qvp.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:58:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aF1BdxIc7NPI7Dsk+3ZH17n/EhvhXEPJcTNSoSkH9Wk=;
        b=e31XB1lrLgIAeI1zGKVgm76dPOIm8IbkfaFYj3FEKgsriAq3hsLI4UVTdwWCN0xFH/
         9iF96693WDHVMiQvIQljRULOd51M2hQLRDLP6ZQQBDEyCp08E/Ja5++MQ09BaHuz284q
         /WEOXi5GlzgQys++WI5HF+p5NjkJtUOde0jlzm9aWMmubZJXqIPqmacdgD2qk4o2NGwK
         kFyjLDIXah7f8H9D1XlCm+Ec5yTMSnHT7bwdSCUJ5JmPHQcj02PwtQqqSw7xEF4xsBaq
         oc/GDcOyNaDrabFkzswJcNkANtiRwlGQmTY9d7yLSMcBGUGEEIYlDFwaN+yLPqosMcvf
         2YmQ==
X-Gm-Message-State: APjAAAXhS7U7J+9+3MePywHB/oA4OUG/l8n4RJoR6HclFKoWLtEUddP2
        YJ3M3zw2OnG5PCk6huvhbtf0iIh0PyuvNOljwpQZ6oes55G0iZR1ff+oJnOKaTRQFzqboEUPtdx
        u0D23607/XlU9
X-Received: by 2002:aed:36e5:: with SMTP id f92mr8461790qtb.354.1578581899551;
        Thu, 09 Jan 2020 06:58:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyRwYVEXndV0U7BqbcKE99vl8mk+g1J4386LY+MgnHkwH4BOop64bg/+1s0dgEK/wCUhEN0lA==
X-Received: by 2002:aed:36e5:: with SMTP id f92mr8461782qtb.354.1578581899350;
        Thu, 09 Jan 2020 06:58:19 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:58:18 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 18/21] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Thu,  9 Jan 2020 09:57:26 -0500
Message-Id: <20200109145729.32898-19-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
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


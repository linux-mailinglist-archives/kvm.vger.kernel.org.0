Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9EE29CD49
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgJ1BiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:23 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:40384 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833041AbgJ0Xhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:37:46 -0400
Received: by mail-qk1-f202.google.com with SMTP id j20so1904650qkl.7
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=x6wLtdcIt0/96ievd4JxmwDh+1dU8Ex+ok+TDZduo48=;
        b=itfhbWhaPImJ0pCOH18DUxk6w9aL+vOw6DQBrq/KZBnRYqhUMnypvHoJHs4LLR6RvG
         ozwIoZGs7glu2fVnj8JGPq3GNxIjsLM/DHgXs8SbkWKqFkBd+iFAjDEp1ZljXFDNCsZq
         n76Z1UKhq8oXte/aS8kof330ypXIkitVhRl6ksELoVjV0BHHKiaOiCZYwDfjxoJYT4Rd
         yMLILqotZAH8zjHCo5C/uJMFBz3c2UpRkKMdxA/aJ2e0qu8bDLWJKeSUpP6YGaLhN4t9
         YQV6GZ5yaGDfwvEZ4sssB4EFhLs7lXgHLWXW6wK9mjhpvjJc6V1rI0Z8Rb29jOCS7h6V
         o6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=x6wLtdcIt0/96ievd4JxmwDh+1dU8Ex+ok+TDZduo48=;
        b=a765QyApem8J+ImSt+g4vIZRC4iSjY91WPgLeNnFvYl7nIvNNZDr4aRs/Jm4ttyqeY
         X8zi/hXUVSRDa6DrPLT04xesupCfEKjJJu12BV01AuTyn/rYizLa8s8VnieDYBcPLxy9
         chEC9wmnLdlt7Xn/dHbmlLgKG7RmYwCwJRrKVLv+XsD3PXD98YHnwagbBeUFBw7R1BwL
         l8MOPeaSwJyshMh7EY2V2T1nXV6tVm9Bgg7lgUZsQac8TwaSy33v8X0yPTAqaoPDwnul
         fmaN3IUfWx8UuqEU1lRn8UMkvV7UlhjaL8DnOAmicCa1s+DaTneHRDfKlaENn8UNciBA
         d8wA==
X-Gm-Message-State: AOAM533XG8zCam17XHSmqJNoaiGYBRUBiU6XxrdBZiuHijRhNBOLbWxk
        9H6DdryxuIxTc7vxm9A8v7jKc1li0Vi4
X-Google-Smtp-Source: ABdhPJzs8krdkxB8S7D+VTEBOFBuSiP2LcmV3o02NKDS1JF0CIIrz8hSTEvZUEyRqj4hRvr5onH84TugRn6m
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:ad4:4f46:: with SMTP id
 eu6mr4984942qvb.9.1603841863857; Tue, 27 Oct 2020 16:37:43 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:37:32 -0700
In-Reply-To: <20201027233733.1484855-1-bgardon@google.com>
Message-Id: <20201027233733.1484855-5-bgardon@google.com>
Mime-Version: 1.0
References: <20201027233733.1484855-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 4/5] KVM: selftests: Add wrfract to common guest code
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrfract will be used by the dirty logging perf test introduced later in
this series to dirty memory sparsely.

This series was tested by running the following invocations on an Intel
Skylake machine:
dirty_log_perf_test -b 20m -i 100 -v 64
dirty_log_perf_test -b 20g -i 5 -v 4
dirty_log_perf_test -b 4g -i 5 -v 32
demand_paging_test -b 20m -v 64
demand_paging_test -b 20g -v 4
demand_paging_test -b 4g -v 32
All behaved as expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c     | 2 ++
 tools/testing/selftests/kvm/include/perf_test_util.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 7de6feb000760..47defc65aedac 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -266,6 +266,8 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 
 	vm = create_vm(mode, vcpus, vcpu_memory_bytes);
 
+	perf_test_args.wr_fract = 1;
+
 	guest_data_prototype = malloc(perf_test_args.host_page_size);
 	TEST_ASSERT(guest_data_prototype,
 		    "Failed to allocate buffer for guest data pattern");
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 838f946700f0c..1716300469c04 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -46,6 +46,7 @@ struct perf_test_args {
 	struct kvm_vm *vm;
 	uint64_t host_page_size;
 	uint64_t guest_page_size;
+	int wr_fract;
 
 	struct vcpu_args vcpu_args[MAX_VCPUS];
 };
@@ -72,7 +73,10 @@ static void guest_code(uint32_t vcpu_id)
 	for (i = 0; i < pages; i++) {
 		uint64_t addr = gva + (i * perf_test_args.guest_page_size);
 
-		*(uint64_t *)addr = 0x0123456789ABCDEF;
+		if (i % perf_test_args.wr_fract == 0)
+			*(uint64_t *)addr = 0x0123456789ABCDEF;
+		else
+			READ_ONCE(*(uint64_t *)addr);
 	}
 
 	GUEST_SYNC(1);
-- 
2.29.0.rc2.309.g374f81d7ae-goog


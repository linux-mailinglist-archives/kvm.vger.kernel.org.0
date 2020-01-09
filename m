Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2978F135BF9
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbgAIO61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:58:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50381 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732101AbgAIO6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 09:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N5/gZPNP/QItlxsKYnUSc3SUeJf7pxYxkCxufAe+9+I=;
        b=BxajOEqEIJ7ndmuFZpDL/qhxSK08cCt+pyK/7sg3V8B6ay4Qub3mnd6275EUZUmIv5UceU
        0CA1Nz3PYMfrVVzauLLRwIDPyDezP13fXxq1Bb0N2Oys+UtbW2c6c0n7iv8hAcFiRNj4t+
        XVaLJI315PpXjeJ5D3ECcgEJRsdyPVE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-QR6wYwOCPbycDbna65x-6A-1; Thu, 09 Jan 2020 09:58:24 -0500
X-MC-Unique: QR6wYwOCPbycDbna65x-6A-1
Received: by mail-qk1-f197.google.com with SMTP id 12so4265221qkf.20
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:58:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N5/gZPNP/QItlxsKYnUSc3SUeJf7pxYxkCxufAe+9+I=;
        b=Et16tJPi5BIdEAOOPfuZeNfqDL/biAQotlXQi0PQxDVrrmEirC42Yj8qHheeD17hox
         Q/ht8LTql+og+OhrNKvvdk51G4RZ15a4uDME+n5N6pSrGmeQseVot9TgpDK55mdDdw4e
         oa/U+64W5OW/uxtu8NX8yj3j4YSzW6ZFKgDqYk1uzBiYHyw4U5mrGVP5yl5NrJG3lI99
         xESLBjxCw2Io0u9TwBNbVJ0lTWHDk29LM7Ju/zWdzC0AIDeSeigfjLXKk3ZxfbR5gLSi
         NfFQzUtqyT6LxUb7ZYeGAjCIloT10zDN1hOeAc5mUBAubvnvHf1x45GCa8Y/BPcsXWEo
         p3mQ==
X-Gm-Message-State: APjAAAV/oAIcIFEnIUD0Me6TNmDbBVdVyJSe6qyHNPLlWCdAlhCoJrmB
        1JUq3iWsFIYkBa+vCwvn7PnX/JFqIVY3CX0nhkiXdYP9Sb60K99tQEns35HHJt9BJ4f5d74Gr2d
        VUJh2aFzWumqC
X-Received: by 2002:a05:620a:1108:: with SMTP id o8mr9361845qkk.118.1578581903456;
        Thu, 09 Jan 2020 06:58:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqwbk+PEzju7o1lLOeEMcQhDn/PrsxAenkqs3X56jNWYL+hX9tnG49Zv7cb0rnQ4BjnnJdD5RQ==
X-Received: by 2002:a05:620a:1108:: with SMTP id o8mr9361819qkk.118.1578581903204;
        Thu, 09 Jan 2020 06:58:23 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:58:22 -0800 (PST)
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
Subject: [PATCH v3 21/21] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Thu,  9 Jan 2020 09:57:29 -0500
Message-Id: <20200109145729.32898-22-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's only used to override the existing dirty ring size/count.  If
with a bigger ring count, we test async of dirty ring.  If with a
smaller ring count, we test ring full code path.  Async is default.

It has no use for non-dirty-ring tests.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 6da97e4a9408..fb6c33dbaf35 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -163,6 +163,7 @@ enum log_mode_t {
 /* Mode of logging.  Default is LOG_MODE_DIRTY_LOG */
 static enum log_mode_t host_log_mode;
 pthread_t vcpu_thread;
+static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
 /* Only way to pass this to the signal handler */
 struct kvm_vm *current_vm;
@@ -235,7 +236,7 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
 	 */
-	vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+	vm_enable_dirty_ring(vm, test_dirty_ring_count *
 			     sizeof(struct kvm_dirty_gfn));
 }
 
@@ -260,7 +261,7 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	DEBUG("ring %d: fetch: 0x%x, avail: 0x%x\n", index, fetch, avail);
 
 	while (fetch != avail) {
-		cur = &dirty_gfns[fetch % TEST_DIRTY_RING_COUNT];
+		cur = &dirty_gfns[fetch % test_dirty_ring_count];
 		TEST_ASSERT(cur->pad == 0, "Padding is non-zero: 0x%x", cur->pad);
 		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
 			    "%u != %u", cur->slot, slot);
@@ -723,6 +724,9 @@ static void help(char *name)
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
 	puts("");
+	printf(" -c: specify dirty ring size, in number of entries\n");
+	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
+	       TEST_DIRTY_RING_COUNT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -778,8 +782,11 @@ int main(int argc, char *argv[])
 	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
 #endif
 
-	while ((opt = getopt(argc, argv, "hi:I:p:m:M:")) != -1) {
+	while ((opt = getopt(argc, argv, "c:hi:I:p:m:M:")) != -1) {
 		switch (opt) {
+		case 'c':
+			test_dirty_ring_count = strtol(optarg, NULL, 10);
+			break;
 		case 'i':
 			iterations = strtol(optarg, NULL, 10);
 			break;
-- 
2.24.1


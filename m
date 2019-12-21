Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D5D12868F
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfLUCFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:05:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24422 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726949AbfLUCFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 21:05:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6AXOUsRryqKjAteH3ZGpL2igYSciQ5+eIxg15f7PMTs=;
        b=RvUMUKywT23YNU/fD8DnuyYGSZFNdSpTOPrLWWcArT53UuibIAniYYdNnUbpOywpbAw7Sb
        bn2Q/jd8q5ov5lbnCa82E1XYBYuVh4O8/dGBhmBdEX70DXBUFaSThqLSxPwCAsD3rU86fG
        Tv/1ERKBye44DIgDUzfrUW3Si+lvNsg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-kXbxXB8BPoyS3_D-HfY4yA-1; Fri, 20 Dec 2019 21:04:59 -0500
X-MC-Unique: kXbxXB8BPoyS3_D-HfY4yA-1
Received: by mail-qk1-f197.google.com with SMTP id u10so7195886qkk.1
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 18:04:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6AXOUsRryqKjAteH3ZGpL2igYSciQ5+eIxg15f7PMTs=;
        b=E9JGlwqIBsCziVI8usPk8NxsY0Vj/6NIswfKDD4mEcTDU0GC/ytokwTACMgEGHflL/
         pXkHVCBKWIY7yAsyJ5nN+RWdnaorlpMLLmJtQQ2vNmFc/ax9DCDwPkfEqBgkKhI9JiIW
         eWw8SMpXFk68ZDCGPmAk0dIu5MPbRCJ1tYi4NvPqlIBRBqF+A7DBWe9XCIlh2MKVbyrZ
         KAR5C6eHHYhcJUoqZu+ukJ4ds+kImK1maT6GgWazNPy9HGSnZopqsojg2n9D0GvQpp3g
         310hI+YqK1HRxEbYApdksv8qoNYCsVtVD6n7TQdgIIkG2YQdafofG28i6M/YpeMywBss
         ASPg==
X-Gm-Message-State: APjAAAXSOC/QKKj1YcatB/e2BIc/0D27MjWqM6w3LXYJmPDHf0regT3C
        Kgzmrfefory8VQRvFhwx4CRECzIAPxUhLzvjAS4Jd6NFfLPmaH+CAdP9RCwogRezaaYYMUGLGFW
        ttYcGaYMKkR+G
X-Received: by 2002:ac8:7446:: with SMTP id h6mr4848820qtr.274.1576893899272;
        Fri, 20 Dec 2019 18:04:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7mCEEH7P71Ua3bJQg30Nbdfqj7jsDcLyCeU6SRd+ba4CAKL8QnQEnh20BOPcL0SFIEUGPhw==
X-Received: by 2002:ac8:7446:: with SMTP id h6mr4848806qtr.274.1576893899045;
        Fri, 20 Dec 2019 18:04:59 -0800 (PST)
Received: from xz-x1.hitronhub.home ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id t7sm3400114qkm.136.2019.12.20.18.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 18:04:58 -0800 (PST)
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
Subject: [PATCH RESEND v2 17/17] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Fri, 20 Dec 2019 21:04:45 -0500
Message-Id: <20191221020445.60476-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221020445.60476-1-peterx@redhat.com>
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
index 4403c6770276..fde3fa751818 100644
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


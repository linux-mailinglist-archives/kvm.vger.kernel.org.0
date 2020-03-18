Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386B918A0BB
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCRQjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:39:04 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:42388 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727445AbgCRQjA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AXYvTqES3aHnbh5WK0ERpDdm2N38lmJgT6vOPMS+6qc=;
        b=OEiOn7VtCY+Yrv8CVPLFvv+UiyCTU0RcCfcMk6ReWXoFUYSbldwGY3q4CHuHs+p2tCWVsr
        Y9t9M/xL+S50x/9akboEdPBmB05hvDbjZZfemNp4EN1hTfaXPsFfrWLHEVokQgVS/SW1n3
        aR07byqks+m02/oWgw4jCXksLPmnWek=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-ZIHPUJB3N-Kl9u9TelHqOQ-1; Wed, 18 Mar 2020 12:38:57 -0400
X-MC-Unique: ZIHPUJB3N-Kl9u9TelHqOQ-1
Received: by mail-wr1-f71.google.com with SMTP id q18so12604809wrw.5
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AXYvTqES3aHnbh5WK0ERpDdm2N38lmJgT6vOPMS+6qc=;
        b=RooFA0dmw8S2wMLL9+oiMSvlKWZ1VI0nC51RaoMdulAtwrP5ToWVXo2xKBevpHobBo
         nkq2u7ySgxAPWYUZXjaPsY4eAXK/I72xuxv0SP3/mV6Nw0dz35uk6nXveGh0yYNRLjgw
         0p3lOgcH6cnLZgjpI/QPMXH+ZQSS7Yd+Vddni2RW+hA1j5V/r5ZepCUyjw02dw68mAYI
         8mwQa5z36nrm8mhcCZ592V94w5SJ5rvOOouyFpYKxfVO89LQUEOZAMexYeRxJSg8m0VA
         bOA1x0x5Vi8m5juleFYbCJBoU+I+2cb7iEu1efdSV8Y3nMAkmvg+lBbL1NLimWlYXbbr
         7IGg==
X-Gm-Message-State: ANhLgQ3VbuFEWMgWfwii0RycZGc2i+3Fu7gxJWQoQ1eHBG01ZZWL4khf
        L0wAMwpORyPSBH3EUHig130cjrGsw9Prgw2OiSFTHywyao1uTCf+5B4pYzI5oHIIP2Cu6+stS8u
        6MCx14rEFMLhf
X-Received: by 2002:a1c:e1c3:: with SMTP id y186mr2853548wmg.151.1584549536321;
        Wed, 18 Mar 2020 09:38:56 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvf6jHChzCHVGdMOyvtc7+g7N7T6FZmb+FCWM4Z/FROv1KPqFvAwxJFpQUoFpljy/m8cbnwVQ==
X-Received: by 2002:a1c:e1c3:: with SMTP id y186mr2853458wmg.151.1584549535148;
        Wed, 18 Mar 2020 09:38:55 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a73sm4364843wme.47.2020.03.18.09.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:38:54 -0700 (PDT)
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
Subject: [PATCH v7 14/14] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Wed, 18 Mar 2020 12:37:20 -0400
Message-Id: <20200318163720.93929-15-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318163720.93929-1-peterx@redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
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
index 4b404dfdc2f9..80c42c87265e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -168,6 +168,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 /* Logging mode for current run */
 static enum log_mode_t host_log_mode;
 static pthread_t vcpu_thread;
+static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
 /* Only way to pass this to the signal handler */
 static struct kvm_vm *current_vm;
@@ -250,7 +251,7 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
 	 */
-	vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+	vm_enable_dirty_ring(vm, test_dirty_ring_count *
 			     sizeof(struct kvm_dirty_gfn));
 }
 
@@ -272,7 +273,7 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	uint32_t count = 0;
 
 	while (true) {
-		cur = &dirty_gfns[*fetch_index % TEST_DIRTY_RING_COUNT];
+		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
 			break;
 		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
@@ -778,6 +779,9 @@ static void help(char *name)
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
 	puts("");
+	printf(" -c: specify dirty ring size, in number of entries\n");
+	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
+	       TEST_DIRTY_RING_COUNT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -833,8 +837,11 @@ int main(int argc, char *argv[])
 	guest_mode_init(VM_MODE_P40V48_4K, true, true);
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


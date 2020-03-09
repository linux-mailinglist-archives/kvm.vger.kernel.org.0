Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B813E17EC02
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 23:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgCIWZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 18:25:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20849 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727390AbgCIWZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 18:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583792744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lv9eFQ9Kzg7exvd9kWxFWYuTarInnzxpnez1RQkbt+o=;
        b=Dkr8nI5uFtnfZ3RLZL+tH7RSH3KdqQUted9811Hw3hcZtxiY+VfZM/VrXhnQnwn+lthACR
        i6fdWgWeQk4quQP1ystCEZOimo1gbO2oISbgNcwWP0pD00rFtcTCtG52gO4Dslh0zxEW/0
        /FFwZc3nUDb3ICESyEFVBLi2hk0GtgM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-ThRRq5BYN1ih3AyqhoeBtA-1; Mon, 09 Mar 2020 18:25:43 -0400
X-MC-Unique: ThRRq5BYN1ih3AyqhoeBtA-1
Received: by mail-qt1-f200.google.com with SMTP id j35so7819120qte.19
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 15:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lv9eFQ9Kzg7exvd9kWxFWYuTarInnzxpnez1RQkbt+o=;
        b=VmM0xjJSxgF/y2iiibSii8VJbRDjahjcaWlBbPVsacaWR78jvd94/1FnYaCAts/UK2
         f68vQRNTqmoQ3sSSjXtQONBqjvbT1MqZ5CUsHhGdbRxNCMGPlrpOpdiBgeDh4AkEXXIf
         UaV6kNmhQyVvAKBlD8Hxo3cZSsFw1EQpFSG0ytyMgcOUVnp5H5kJ1FvrOG7IglVnmtLj
         1y/sZSkyWV2/JkDCXxzbiN2ElpcElNHpUzhozuKpl4r5VHC5xVAsrYdKMqmiQNP9brrg
         jfN4uWxy2qt2T+QqnerHqIlZ3nIidPS6c2W4C9U+gT21X0hARpoC4IP0jGmiAFI9AkMD
         mi+w==
X-Gm-Message-State: ANhLgQ3YX/P4y70Jh34H9cERB1RMJ8NuLz7zEvgjWPQH7KcxHks1SYzo
        dlrzXyh3bWKZqTEA+W2395uvkM+jCHc1Dm32SNbrPRhkzISODqMZfsgtKMBEu6tAq8sW1uzJ/17
        08WxFdmYQlYFj
X-Received: by 2002:a0c:e886:: with SMTP id b6mr16499380qvo.31.1583792742570;
        Mon, 09 Mar 2020 15:25:42 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsPtpOUg/cm4Otshe5Cw28CoeO4qDCsTFo+0ne7OfrggSuGkqc5mpGQRPZPwbGgFIA9BFALGw==
X-Received: by 2002:a0c:e886:: with SMTP id b6mr16499368qvo.31.1583792742342;
        Mon, 09 Mar 2020 15:25:42 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 184sm6156469qkh.63.2020.03.09.15.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 15:25:41 -0700 (PDT)
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
Subject: [PATCH v6 14/14] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Mon,  9 Mar 2020 18:25:40 -0400
Message-Id: <20200309222540.345796-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: 
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
index b07e52858e87..60f3921e6c40 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -168,6 +168,7 @@ static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
 /* Logging mode for current run */
 static enum log_mode_t host_log_mode;
 pthread_t vcpu_thread;
+static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
 
 /* Only way to pass this to the signal handler */
 struct kvm_vm *current_vm;
@@ -245,7 +246,7 @@ static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
 	 */
-	vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+	vm_enable_dirty_ring(vm, test_dirty_ring_count *
 			     sizeof(struct kvm_dirty_gfn));
 }
 
@@ -267,7 +268,7 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 	uint32_t count = 0;
 
 	while (true) {
-		cur = &dirty_gfns[*fetch_index % TEST_DIRTY_RING_COUNT];
+		cur = &dirty_gfns[*fetch_index % test_dirty_ring_count];
 		if (!dirty_gfn_is_dirtied(cur))
 			break;
 		TEST_ASSERT(cur->slot == slot, "Slot number didn't match: "
@@ -774,6 +775,9 @@ static void help(char *name)
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
 	puts("");
+	printf(" -c: specify dirty ring size, in number of entries\n");
+	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
+	       TEST_DIRTY_RING_COUNT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
 	printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
@@ -829,8 +833,11 @@ int main(int argc, char *argv[])
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


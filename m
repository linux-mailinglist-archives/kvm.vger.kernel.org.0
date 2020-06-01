Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5C81EA36F
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgFAMFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:05:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49582 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726287AbgFAMFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 08:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591013128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwkOICvOQaXOWcko8kpLlTGev7mN/mGmU8J6lWaTsxY=;
        b=aRZnfYKLBi44FswXqln9c4xmyj7LuC38QqNDYYDebX4kAX8x/FdhneVynSz7ewvEQjX/+s
        RnmKntO3MPRAROdrYTqAZyLIAkhWagvV9eQyFU1zCPkqa0eHVRcUyOEMqDQL/SRsHlB9N9
        jI2ru7Y0QU9agAlE2QQOIF+8xGooLBM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-BWHUEjHQMUuGjVH7ecvWPg-1; Mon, 01 Jun 2020 08:05:26 -0400
X-MC-Unique: BWHUEjHQMUuGjVH7ecvWPg-1
Received: by mail-qv1-f72.google.com with SMTP id k35so8325154qva.18
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwkOICvOQaXOWcko8kpLlTGev7mN/mGmU8J6lWaTsxY=;
        b=K7ZhCVyYj2tchQ/p7WTt2RSnY3oQWx1hfXZVybxdhY6m17NRNBYnukvdIghXkeIkk3
         gJpbtBaveuMB3QH1RuVuZvDqR0LLFpb9PQhCq9qfZDL7dd8/dOxCVYtcpTiRByzaLvAG
         dKXt8D/zzhRpKI2Aaswa0+yzgXVX2y6Kh6n86mclFN0udqcwQkmDLrqmDirkZUwJeLqA
         chKvW85LMtu2A5dXOFkcNJsESzU3ozJQ9r3Srbktsi4zD31leoP/CL6chBWkkYm44bku
         Ef6viU6OouIO5/9LY/Xl05yP6WkX+T2Ly8SxL8VaIPg7nf6iZsrILFUHTYhyX/GuBk0T
         xv4A==
X-Gm-Message-State: AOAM530P6XsWoY7g8Uoxv/pzgCAtclgD+iG9u8m3TnMO+JLZjiHFhAcV
        HTRjiAyOhyRozMCjremGPE2O0TRThL8qhglLZMqN7IBI5kXCpp2n8qvEyLwldgzbXPOYRG7VDRU
        94uF1t/OyyeYi
X-Received: by 2002:a0c:9c43:: with SMTP id w3mr19790536qve.38.1591013124245;
        Mon, 01 Jun 2020 05:05:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvY22DeT/UzGqiMnb/bCQX1PDyAgwc9UpvDgLpzeIsmvIbU0/QZmMV3JP6xj4py4MirvztkQ==
X-Received: by 2002:a0c:9c43:: with SMTP id w3mr19790468qve.38.1591013123625;
        Mon, 01 Jun 2020 05:05:23 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id y66sm14906164qka.24.2020.06.01.05.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 05:05:22 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v10 14/14] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Mon,  1 Jun 2020 08:05:21 -0400
Message-Id: <20200601120521.1581843-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601115957.1581250-1-peterx@redhat.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
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

Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.26.2


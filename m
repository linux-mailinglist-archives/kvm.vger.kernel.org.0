Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17691199E99
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbgCaTBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:01:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53919 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728433AbgCaTBe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 15:01:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mpD2kEQIv9tlf4VTpXdqhelQzLU1X8sWWcoS/iqQyA8=;
        b=bVWa4nzBsxvhKvnTAxhlNXchVtRc5K3HobKcbQCJ0FDkk6ifHS4Rbt3vaBRpR85EAgEL6C
        E44AKHCtFVMQlqrbTnjQ5EVyWmi6BA9xnsX7VVZgCYBjT8RLWrtDnvWdzItwy+6/EIrjZO
        WxE6pPeXOPL1KrtV7WC1/w3dDM8d/Sw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-dD0SqMYTPCy6FnWqWdQalw-1; Tue, 31 Mar 2020 15:01:31 -0400
X-MC-Unique: dD0SqMYTPCy6FnWqWdQalw-1
Received: by mail-wr1-f72.google.com with SMTP id f15so13459992wrt.4
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mpD2kEQIv9tlf4VTpXdqhelQzLU1X8sWWcoS/iqQyA8=;
        b=XL/qSILYKo6AOGzvDjIriIihUA8Wb99zMDNQNj2tGhVm9s08H8UqCmkF6j4JIioVly
         MZUMetNYSz5ZYS8P9Z7Y50dlNg+PndTtTBlJeMNWjYvkj6c2FnBzTbd4ezi3QD1U4fSJ
         KZQiKG08jeVNnIXShmIHKy53YUmxP0aGBnsVgClD/1BbuV9kzBCgnDoJ6dDrXgKNjw/6
         BATdRaBr8HBQgAYw2S2XKV1weVqp8lF08svH1ChLLhWWvvyxOJTE6XaSKbve6RVrLhPw
         GGVmrTdQPLeXS9QQnbC05fYS50WYfS9w9KytX8wSLPN+1myPCd1A0HmEqXKzgQP1v4a9
         DG7g==
X-Gm-Message-State: ANhLgQ0zUpsDfgqRl+wMprIJcDi9YfO+vUizOTYCvDnbQGWtM9nlLSwH
        paj5yIoybJH4ofAA1k5W7z/h2v5oIy9K9jeXdWyDZMIbxyo5QwBqPYt4b2MtlBvjhFpWzIXW1as
        HD11z57+pGX8l
X-Received: by 2002:adf:f4c6:: with SMTP id h6mr21661337wrp.353.1585681290530;
        Tue, 31 Mar 2020 12:01:30 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsHKybAaTsS9HEduBHy2riDVsEOagD3f8xBZunLDGxSK2xwbCHDHdt1hzqrHnjR4E9o0Hx1BQ==
X-Received: by 2002:adf:f4c6:: with SMTP id h6mr21661303wrp.353.1585681290320;
        Tue, 31 Mar 2020 12:01:30 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id h10sm29023479wrq.33.2020.03.31.12.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:01:29 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v8 14/14] KVM: selftests: Add "-c" parameter to dirty log test
Date:   Tue, 31 Mar 2020 15:00:00 -0400
Message-Id: <20200331190000.659614-15-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
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
2.24.1


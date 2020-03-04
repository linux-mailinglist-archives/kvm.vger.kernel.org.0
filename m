Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07564179727
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388378AbgCDRvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:51:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49076 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730059AbgCDRua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 12:50:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583344229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aPhWJqv+4wzEiT3LFbcYSbxVKlkBrz5Pq1CzcIRJ0kE=;
        b=E506fkHVxdv0IsAZA4pGvbVHIKal03bgBMK25vBN28kqWYqjjB/MEAJw9/1+kIheTgHWlT
        AyubfhTd3MIvvkKfLLtqIOlCoXIPQrcr5xzwFlzirr/58woGIBckAfJ/re7lzfG8/JQQLm
        AAv7nPa18qopECme8VfWxfAa7uFHbCw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-Jt4lCF9aNv26zE__2btfRA-1; Wed, 04 Mar 2020 12:50:14 -0500
X-MC-Unique: Jt4lCF9aNv26zE__2btfRA-1
Received: by mail-qk1-f200.google.com with SMTP id q123so1869254qkb.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:50:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aPhWJqv+4wzEiT3LFbcYSbxVKlkBrz5Pq1CzcIRJ0kE=;
        b=SngN7UaZyPPc/4xv54A6IuoeW8yO1oXmzaJF36hEVCG26/x0hZySNnCsz956Jl/1A8
         JTA554ZqjptCpWp7ZC6oiHo5n741NhkwPiSJt0kLUJH2QbHNbmLRKNfNjYd9mI7yefyE
         18aTL/70CSSHNlEeaa43PHId6l+2VM32npC+esO54aaHZKji2t3CoNVJu/SA9p2ubk1j
         FL/tJelcB0C6HISErKIapPy5/c6TNT9JsHbCTVsN1jkQbR3LQzPIqvcgoAYvds4/2dpl
         6Fm7PYGTQcSYuv5+5Pdyumgx97RZSLhpg/zHgJykp9uwaOVujyNYQzaeoGMkbOvYMmzD
         eafA==
X-Gm-Message-State: ANhLgQ1CyKd70Eoe9kBJdfXWlpxm5eFFQstHyKMb+1ZmLOJtvf6t6gqa
        73R8GYfKmJJrkz3a8G7lx6xAoqHozARWGdebnMXiG2H8mtKw4qvt4xkXVhtrO7YyDmiSIwdO3Y2
        UBmyUL5JEjreT
X-Received: by 2002:a0c:c389:: with SMTP id o9mr3138122qvi.232.1583344214248;
        Wed, 04 Mar 2020 09:50:14 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtq/beW3jj6OOypWe1gnWlD8BohLtxbBMiKHW9tcNSjrLXt9y0PqCqKQBMSsDlWebjpAVUrBQ==
X-Received: by 2002:a0c:c389:: with SMTP id o9mr3138100qvi.232.1583344213957;
        Wed, 04 Mar 2020 09:50:13 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id j17sm5252341qki.123.2020.03.04.09.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:50:13 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v5 07/14] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Wed,  4 Mar 2020 12:49:40 -0500
Message-Id: <20200304174947.69595-8-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304174947.69595-1-peterx@redhat.com>
References: <20200304174947.69595-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because kvm dirty rings and kvm dirty log is used in an exclusive way,
Let's avoid creating the dirty_bitmap when kvm dirty ring is enabled.
At the meantime, since the dirty_bitmap will be conditionally created
now, we can't use it as a sign of "whether this memory slot enabled
dirty tracking".  Change users like that to check against the kvm
memory slot flags.

Note that there still can be chances where the kvm memory slot got its
dirty_bitmap allocated, _if_ the memory slots are created before
enabling of the dirty rings and at the same time with the dirty
tracking capability enabled, they'll still with the dirty_bitmap.
However it should not hurt much (e.g., the bitmaps will always be
freed if they are there), and the real users normally won't trigger
this because dirty bit tracking flag should in most cases only be
applied to kvm slots only before migration starts, that should be far
latter than kvm initializes (VM starts).

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 4 ++--
 include/linux/kvm_host.h | 5 +++++
 virt/kvm/kvm_main.c      | 5 +++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0147f20f31f9..d2c6bd27053f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1284,8 +1284,8 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return NULL;
-	if (no_dirty_log && slot->dirty_bitmap)
-		return NULL;
+	if (no_dirty_log && kvm_slot_dirty_track_enabled(slot))
+		return false;
 
 	return slot;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1d887cce323b..4253cc5665c4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -351,6 +351,11 @@ struct kvm_memory_slot {
 	u8 as_id;
 };
 
+static inline bool kvm_slot_dirty_track_enabled(struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_LOG_DIRTY_PAGES;
+}
+
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
 {
 	return ALIGN(memslot->npages, BITS_PER_LONG) / 8;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72dfb84a08a4..00e09a0c013f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1153,7 +1153,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	/* Allocate page dirty bitmap if needed */
-	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
+	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap &&
+	    !kvm->dirty_ring_size) {
 		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
 	}
@@ -2429,7 +2430,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.24.1


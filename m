Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C5417EBF5
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 23:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCIWZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 18:25:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32604 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726698AbgCIWZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 18:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583792707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nyrDInEJang5FtswEWWF8Cqby5BmYpTki559+lPfEAA=;
        b=C0JQuXHN3veHnjxdnDeIAicDMPXtSA81Hq7wIuSNo41DsVD1a/u0wCwxjz5C+mQQRWTiK0
        OzYbgwmmH/hVsn+Kss82QVFe+9ZI3rLybsL99pGITnsmyEgI396PX7KyhShMt7BkVsb8mK
        whIJypSJEocD7OgBvz5Y17CA1sqmWQQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-DjDMA7eeMXKn0KAxiYIT-g-1; Mon, 09 Mar 2020 18:25:06 -0400
X-MC-Unique: DjDMA7eeMXKn0KAxiYIT-g-1
Received: by mail-qt1-f197.google.com with SMTP id w3so2297370qtc.8
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 15:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nyrDInEJang5FtswEWWF8Cqby5BmYpTki559+lPfEAA=;
        b=CF6QpCm1Y4qwGmxw978sp9w2UzJbxeAyWDvxDDsGEOaxVE76N+ikObojPXHNAiKC8A
         X2p2Ol7xIa7C9tLV9jG+QZtPGCNh09bZDYMaZ24a/+XIlryjLONKsWZrdNugh+FTCIbD
         j41vl9K3jVUJtr540SCbgIpbpeE0xgfKeHrMAhdpTV524IAdXpnBXRlPBPBctc7po8P0
         1cCaR4x/t5N3K/6A6AIxDrcSwrRgMbRA5Alj6TNOIeeJJDo6tzo6+sR4NvukF0WY4EXw
         X4XRjoHGsfPuZMQn5UZbP28R7uzIZ1RZg7yEcLflP1uqgkuAj9eo6K88KAQx0u825jvE
         F3ug==
X-Gm-Message-State: ANhLgQ3biho46fgNn1LOqdyf3nYbNHE7kjwLbineOOZtGVH57I8faL6p
        ls0WSMXoPDOA8hOU8OEJajSYADRfOmG8pGC7rR+2/J2VhpNBK3YEw/tMTTZIXFYu7lYxqTC+QVN
        bAwDQdikL8KD7
X-Received: by 2002:a05:6214:1583:: with SMTP id m3mr3723448qvw.215.1583792706049;
        Mon, 09 Mar 2020 15:25:06 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtjUAto5eTjA77zcu9I6ibufJ7MrPoPuXfurKB93iRAgbYocJhpSf9/yPvOuU1hl1tdvaQ0Rw==
X-Received: by 2002:a05:6214:1583:: with SMTP id m3mr3723431qvw.215.1583792705798;
        Mon, 09 Mar 2020 15:25:05 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id j193sm4815486qke.22.2020.03.09.15.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 15:25:05 -0700 (PDT)
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
Subject: [PATCH v6 07/14] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Mon,  9 Mar 2020 18:25:03 -0400
Message-Id: <20200309222503.345450-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: 
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
index f0993dec3b77..711ed191f663 100644
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
index e51a14d24619..1839d5c15a0f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1100,7 +1100,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	/* Allocate page dirty bitmap if needed */
-	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
+	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap &&
+	    !kvm->dirty_ring_size) {
 		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
 	}
@@ -2376,7 +2377,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.24.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A4E135C12
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbgAIO7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:59:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50348 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732058AbgAIO6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 09:58:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qo8B0RRH3HwVIIYkQ204ghyrR8Ipv7FatZgkB5Hr2Ro=;
        b=dZ4PuZ24tAZuRto9B9cOLtNO1lYtFuFB8OuBfaQSE6Urc4/1fJufPEIe+FMt6njKU/fV8A
        zpXw36BLuzq3DFy8u1wpisehjKohFCII/7wpLjcnsniEeo+XSsaBCSiKXC+Jc8DPQANzbr
        XZrIU4/yt0v+FNWgbCzrP9Fu1PyfZII=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-ZYyQCIdFNHa9W7wnw5IaMw-1; Thu, 09 Jan 2020 09:58:14 -0500
X-MC-Unique: ZYyQCIdFNHa9W7wnw5IaMw-1
Received: by mail-qk1-f198.google.com with SMTP id 24so4262339qka.16
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:58:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qo8B0RRH3HwVIIYkQ204ghyrR8Ipv7FatZgkB5Hr2Ro=;
        b=c+BIZXbMCUjWmVY1hzNrp2BfpEXJGTUmuLnVGB5hd0RgGlc5WS/u10gEX/E4+7QMpS
         qWBW/MwJGwFGk15tiq0wPEkSDzCxCBKvXS2URHPMJ3Ojwm6Ae3Sm95aXH8OsiYOqsvSU
         gtZukGSHxrs+WwDqpgOv/F8MgrV/oFvRhVqX4p5rKKSZ+UiulWUHnRpOXL/0lt3FvfPk
         4pTX9cuxsb+qpAVuIiotJlBc0nc6IjRFVgFAoklzggjAmxSgBHdn2U1IAVd9uWfdHw8F
         NGDUPNO4bnr1u3ovaaU0AwNjvqzoZ7BBW9Busw5UPORloSZc9JN0qR9chAPrYeN+G4H7
         AuNA==
X-Gm-Message-State: APjAAAXA72qGnt3LzkMPl6st9cr3xyrVR5EHsacg7vVYrG1ruV9aZwX8
        sT/xXoxD79Aom0H2bHRaqWUZKaB3tVkQ+iexUfljXeJxFXHjZf3WLCJQOblUaXQTHs3Lg5VFGCz
        ohuT40D/uJvo4
X-Received: by 2002:ad4:55ec:: with SMTP id bu12mr9341183qvb.107.1578581894160;
        Thu, 09 Jan 2020 06:58:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxap7TJb0aJMeIGMtE0Ap5zzFfcOhoJTtDvs6UIukIGtqjETcSsqkFLZb0v4jXm6uqUuxkLFg==
X-Received: by 2002:ad4:55ec:: with SMTP id bu12mr9341162qvb.107.1578581893880;
        Thu, 09 Jan 2020 06:58:13 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:58:12 -0800 (PST)
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
Subject: [PATCH v3 14/21] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Thu,  9 Jan 2020 09:57:22 -0500
Message-Id: <20200109145729.32898-15-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
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
 include/linux/kvm_host.h | 5 +++++
 virt/kvm/kvm_main.c      | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c96161c6a0c9..ab2a169b1264 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -353,6 +353,11 @@ struct kvm_memory_slot {
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
index f0f766183cb2..46da3169944f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1120,7 +1120,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	/* Allocate page dirty bitmap if needed */
-	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
+	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap &&
+	    !kvm->dirty_ring_size) {
 		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
 	}
@@ -2309,7 +2310,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.24.1


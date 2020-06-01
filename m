Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C241EA344
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgFAMA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:00:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49830 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727847AbgFAMAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 08:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591012822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tj3M9GjLpjXTRP2zr/iI1sEFZ7Qtzk7KE35E4h+RHa8=;
        b=Ljfi2MIYwt/rltSfnU90rM8+GIyYO54lex5Aqcw8wQGCxsyS+HaW/13PuaZ7HeG6uJqLFU
        1IMCI+jGmtmnw222EioBvW+ioE7Q4yOw6K8DH8K4l42REPwG1DjmymH60YnEJyfXl1z47D
        Ha5PfIwOXydP0x85fR+fYOh3J1WldWc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-A66SbjH4OMCiODFzNgBobA-1; Mon, 01 Jun 2020 08:00:19 -0400
X-MC-Unique: A66SbjH4OMCiODFzNgBobA-1
Received: by mail-qt1-f198.google.com with SMTP id y25so9678690qtb.6
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:00:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tj3M9GjLpjXTRP2zr/iI1sEFZ7Qtzk7KE35E4h+RHa8=;
        b=A9lolDQmkkN/4De70Bx1kHpzYWZA+HX08L5yBHe1ctKBwBAXxSPVq4vnMNS1eTR1PD
         9Wl7j9WwYfnMYi45Sz4/zpLoJ+lQdtTKjmC8XbNyGjmGRAcET0J8iVvd2tnDCUE5efzi
         +fXnTEexhbdgsnlMmIkqFyj0XGUotwdHvTnXbPyUpKCL+hiQvBCr99uosIrCtBG9qT4Q
         lYwFAyO8BeUM4PG9/9cQtRHWYOy0NG90K4q6GHVEJYMnjYYxunvNPQP4ASpjwEwtvOwb
         WEAhLQxT0vMapU5MJT+X0iGN+xCKIqODUC+0Qv7DjbXw8EO3bhRLQGQqh0cv0cbAmTHa
         JuJw==
X-Gm-Message-State: AOAM532okdnF3HL2dqqlo9B1a9h2cFU0Z1JTcgpfGwDuXq8BbLtIupm7
        H17SY3RAZPSNzr346HEQZhUbNC2iYEiOEyulAbAhhpygwNYsah2y/LeVbgSylWIKEehm/G0HxR+
        163RUelaNl7rD
X-Received: by 2002:ac8:4f46:: with SMTP id i6mr21377225qtw.317.1591012815786;
        Mon, 01 Jun 2020 05:00:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxs8HHsRlNE0/WSN+oN9g9A1UD0u3RQYIDPxI9QY66AOMD4xi8dYBagOrCCiLPVzN48gpbsrg==
X-Received: by 2002:ac8:4f46:: with SMTP id i6mr21377194qtw.317.1591012815472;
        Mon, 01 Jun 2020 05:00:15 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l9sm14474185qki.90.2020.06.01.05.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 05:00:14 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v10 07/14] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Mon,  1 Jun 2020 07:59:50 -0400
Message-Id: <20200601115957.1581250-8-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601115957.1581250-1-peterx@redhat.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
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
 arch/x86/kvm/mmu/mmu.c   | 2 +-
 include/linux/kvm_host.h | 5 +++++
 virt/kvm/kvm_main.c      | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 94d84a383b80..cd2cac77f6ad 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1276,7 +1276,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return NULL;
-	if (no_dirty_log && slot->dirty_bitmap)
+	if (no_dirty_log && kvm_slot_dirty_track_enabled(slot))
 		return NULL;
 
 	return slot;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a7eaef494f45..5081c6e2ae06 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -351,6 +351,11 @@ struct kvm_memory_slot {
 	u16 as_id;
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
index 6b759f48a302..daec04a4d752 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1294,7 +1294,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Allocate/free page dirty bitmap as needed */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
-	else if (!new.dirty_bitmap) {
+	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
 		r = kvm_alloc_dirty_bitmap(&new);
 		if (r)
 			return r;
@@ -2581,7 +2581,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
 				    struct kvm_memory_slot *memslot,
 				    gfn_t gfn)
 {
-	if (memslot && memslot->dirty_bitmap) {
+	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-- 
2.26.2


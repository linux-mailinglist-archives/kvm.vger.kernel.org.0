Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AB6199E8B
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgCaTAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:00:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55256 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730081AbgCaTAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SESLTHxgqRYHhPsVLzqJvHWTJelt1XN9kzslX/6S8Zk=;
        b=dI1kXfuKm2OvtKmG/+gAjg2MWojtbzUlE0F+5C9+vwMxaZQWslrRYYAgjuTx1TvNITH7K9
        Bn1c+o9uSdchG3NRYTAucTem5MmZgbRl4jHqsRjVmqEK75X1Kpc64rAt7IaEclV9c7qgjL
        qbJcM1qnS3Q/GxgroGwNZfI67gJNoMQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-k687vTMUOMu--lMc8x0lqA-1; Tue, 31 Mar 2020 15:00:48 -0400
X-MC-Unique: k687vTMUOMu--lMc8x0lqA-1
Received: by mail-wm1-f70.google.com with SMTP id l13so706752wme.7
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SESLTHxgqRYHhPsVLzqJvHWTJelt1XN9kzslX/6S8Zk=;
        b=kNIiKdv7Mw5lThOfNznymRaKBAt1wPL4KLM5A/kS2B+clFiHdAxc14fLFy7GuYj+25
         3xUETcMleeWBdM7kAokxli//SPMryHRUcKm5n/qn2EI/Y9Asr91fpENZI78Lmff0WUPl
         RUJoNZ0cArilaH9FeX+zzxrxgqP02zedfAMvfEfQHoJOuPPEUbdhKTPYFAqPAXEwO53x
         lLfKcDP5Dba6ZPE//IS7uednV3DRn/5DD3sY+Pn22xcP1CUfleUbTOapjCChlTKpv0I8
         mTJptIQnD2NWGOWcZVIjasbGUm7dq9fSU3N2jopcP+WBwOApN93HR5ZH4mj9B2px2M+Z
         MwBg==
X-Gm-Message-State: ANhLgQ2eyc1sPf/4nRPjtDYOl94fQ1y7WLlWJk8czgEs3QbxvHR192c4
        ox5fNzUyX/x11uaiwTeEFDXIJuNO1OFMBHA/cTWXTzqjqvVfLJjgqynNk8cg/1wgQ1rcklrTxNF
        c3//nd1YVk/QU
X-Received: by 2002:adf:de8b:: with SMTP id w11mr21613219wrl.397.1585681247276;
        Tue, 31 Mar 2020 12:00:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuWQEYgbG1VrqqRA6WBmQ4l+4RS20Li5aJu09zIM449p+Lv+I4MacbCZRb45tLfnecdgTH9sw==
X-Received: by 2002:adf:de8b:: with SMTP id w11mr21613194wrl.397.1585681247077;
        Tue, 31 Mar 2020 12:00:47 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w9sm30264179wrk.18.2020.03.31.12.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:00:46 -0700 (PDT)
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
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v8 07/14] KVM: Don't allocate dirty bitmap if dirty ring is enabled
Date:   Tue, 31 Mar 2020 14:59:53 -0400
Message-Id: <20200331190000.659614-8-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
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
 virt/kvm/kvm_main.c      | 4 ++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e770a5dd0c30..970025875abc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1276,8 +1276,8 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
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
index 291a9a9a1239..2061cafaf56d 100644
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
index 1a4cc20c5a3c..ae4930e404d1 100644
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
2.24.1


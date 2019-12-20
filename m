Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E049128393
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfLTVDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:03:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30018 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727802AbfLTVDr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:03:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G5ujQPtmC0gFSTE7FNk323KNrK3wygZRxxl448+O6gM=;
        b=XP6WYOIcYG02xC7R99/Bg73BCNwd7JieEaaClQWeiU5e3DQPTh0BGUSKNK26Os7c7b9lkz
        88p14JRoHTQPHsb0AtBwv1DdRDIcR4L9hO6XIvGqYhMHdbHm9SZXAYRyD1meptEr4qWwE8
        qOCiXh1rJHdiB/wZLV01gI6bri5Oa6E=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-jCJUZU5fNweUJOJmxBmv1g-1; Fri, 20 Dec 2019 16:03:45 -0500
X-MC-Unique: jCJUZU5fNweUJOJmxBmv1g-1
Received: by mail-qv1-f70.google.com with SMTP id v3so941714qvm.2
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:03:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G5ujQPtmC0gFSTE7FNk323KNrK3wygZRxxl448+O6gM=;
        b=sjxYhdhldA50B2EKfC3v8+S4uRBPePcIvLg6fIb0iN4q2vPg0L3Dm8pBZwHQZTDJvY
         NI7k0MiTWAIK6qndvsic4WUqj9Qzipf46D/Sd9FBGngJF7wygWVuHzng6TX1cHSLwhvs
         2RLUYcvaSDl7fKCE0qyREa51iV/ESUnE1zJ/bfdos8NJ5V9JDx9MkdjC8Jg/KlXpkBhE
         G0+AaH8iSzPhRjwBtbMzs46LPgAVOJSAH4Dz3FZLN+VZJUrbflckPqzeYO1W4aOXZzs5
         ZFxD7DJTxMNFd5fU05dBq9Vo+Xz066lUFfCOJ4HwYEZFkE6EheSQdqhfM6F3iN3DAmHk
         LmUA==
X-Gm-Message-State: APjAAAUaTlHdtvNKPH+wq7plg1fHwNtIkawelbJOCUXY7R4eJGQTj9RJ
        yY5zd5yCMn1unxjgQPSeUMefbhs7x4bIxfGHE+vObkx/OB5ulTh2ffsl9LtPueGmF3ScNkkf6aN
        ImU+wCK0+wJv7
X-Received: by 2002:ad4:580e:: with SMTP id dd14mr14365294qvb.84.1576875824950;
        Fri, 20 Dec 2019 13:03:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqyxPVpnfwVCOu4LfWvbWHlZuEFIEhIBc/T7743Ln11mThk5m+SLhgRM0jfbTzEg6gxWfurRpQ==
X-Received: by 2002:ad4:580e:: with SMTP id dd14mr14365263qvb.84.1576875824724;
        Fri, 20 Dec 2019 13:03:44 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a9sm3061018qtb.36.2019.12.20.13.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:03:44 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v2 09/17] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Fri, 20 Dec 2019 16:03:18 -0500
Message-Id: <20191220210326.49949-10-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210326.49949-1-peterx@redhat.com>
References: <20191220210326.49949-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no good reason to use both the dirty bitmap logging and the
new dirty ring buffer to track dirty bits.  We should be able to even
support both of them at the same time, but it could complicate things
which could actually help little.  Let's simply make it the rule
before we enable dirty ring on any arch, that we don't allow these two
interfaces to be used together.

The big world switch would be KVM_CAP_DIRTY_LOG_RING capability
enablement.  That's where we'll switch from the default dirty logging
way to the dirty ring way.  As long as kvm->dirty_ring_size is setup
correctly, we'll once and for all switch to the dirty ring buffer mode
for the current virtual machine.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 Documentation/virt/kvm/api.txt |  7 +++++++
 virt/kvm/kvm_main.c            | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index c141b285e673..b507b966f9f1 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -5411,3 +5411,10 @@ all the existing dirty gfns are flushed to the dirty rings.
 If one of the ring buffers is full, the guest will exit to userspace
 with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the KVM_RUN
 ioctl will return to userspace with zero.
+
+NOTE: the KVM_CAP_DIRTY_LOG_RING capability and the new ioctl
+KVM_RESET_DIRTY_RINGS are exclusive to the existing KVM_GET_DIRTY_LOG
+interface.  After enabling KVM_CAP_DIRTY_LOG_RING with an acceptable
+dirty ring size, the virtual machine will switch to the dirty ring
+tracking mode, and KVM_GET_DIRTY_LOG, KVM_CLEAR_DIRTY_LOG ioctls will
+stop working.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4050631d05f3..b69d34425f8d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1204,6 +1204,10 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1261,6 +1265,10 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1332,6 +1340,10 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
-- 
2.24.1


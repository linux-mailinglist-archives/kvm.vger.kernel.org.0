Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974341DFB73
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 00:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbgEWW5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 18:57:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31689 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388194AbgEWW5V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 May 2020 18:57:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590274639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAGIoUkJb7Q/UmS1Ezm49nnEfLOrht+NgaGhk+ByiYM=;
        b=FMzhQ6dOsMXmJ696GTy/tIIJemHdFuvwgoA9kCNgL4/yCJTmxQLh5uqFtY3Z/TqZpueguB
        8dnbFTY2mXnT+05jVoIIKYz+u2dnVkFmMbIVk0Uf30mKHJQGOiXuBGLj8/F9DTUkTRipIa
        QuoKf+EZFgM8s3pUrqxLyYrR5WLb8UY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-xHqdQZjVOROtiYNgI6J3Mg-1; Sat, 23 May 2020 18:57:17 -0400
X-MC-Unique: xHqdQZjVOROtiYNgI6J3Mg-1
Received: by mail-qv1-f72.google.com with SMTP id t11so14102611qvv.11
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 15:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAGIoUkJb7Q/UmS1Ezm49nnEfLOrht+NgaGhk+ByiYM=;
        b=E9uEFiV94gZvUJEhCUYeG2n/MgD0u7ajUqoJ5RsEbBsf0diENNFX/HyVzRHqeiGwdI
         zj5NlkL/rJm5hQJCvG+UJh/tOX2kJAEfoR8rQMcatkM8f5ydBelN8DvBJpGb8GHzSZDY
         Z5zcNKCWYUwEfvyComUlkfSOcZXBrxcEs+US/tWC0Ji1EOn416vsiPO2oiCKF97si+E/
         aeLmhoB++vY9negWR6bmG4gHHwd5iYyCDfRhq5dlT1zF8ejvAKa+t4J+n4/glvX4MijF
         nGvwUKSD0RmIIYEDkhKz5vQ4WekH5mA92mj5mN6/zhYnsJn4OkmwVpZVazxiJAaG7gmt
         FHtg==
X-Gm-Message-State: AOAM532XbEzTSjStszxbzNMm85zeR0HMriGwjTAVjx+spXwYdNwaP7+r
        aa1C11aE5D13wadmglgdvgau3KarBMwKmETOM9ozjv1oPmkqeZRUyWCzVAp+EatlbL5H+hefRBp
        fnznxE8JqUEEY
X-Received: by 2002:a37:9bd7:: with SMTP id d206mr457421qke.113.1590274637444;
        Sat, 23 May 2020 15:57:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQUZxjxiQSpACnFjVhQFmkqtrfVy1JBZA9grpCjSq55L1LWuUowmniQHaQALvSKWygQewfyg==
X-Received: by 2002:a37:9bd7:: with SMTP id d206mr457409qke.113.1590274637207;
        Sat, 23 May 2020 15:57:17 -0700 (PDT)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w14sm11630979qtt.82.2020.05.23.15.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 15:57:16 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v9 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Sat, 23 May 2020 18:56:51 -0400
Message-Id: <20200523225659.1027044-7-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523225659.1027044-1-peterx@redhat.com>
References: <20200523225659.1027044-1-peterx@redhat.com>
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
 Documentation/virt/kvm/api.rst |  7 +++++++
 virt/kvm/kvm_main.c            | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aa54a34077b7..d56f86ba05a0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6225,3 +6225,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
 
 The dirty ring can gets full.  When it happens, the KVM_RUN of the
 vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
+
+NOTE: the capability KVM_CAP_DIRTY_LOG_RING and the corresponding
+ioctl KVM_RESET_DIRTY_RINGS are mutual exclusive to the existing ioctl
+KVM_GET_DIRTY_LOG.  After enabling KVM_CAP_DIRTY_LOG_RING with an
+acceptable dirty ring size, the virtual machine will switch to the
+dirty ring tracking mode.  Further ioctls to either KVM_GET_DIRTY_LOG
+or KVM_CLEAR_DIRTY_LOG will fail.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index daca53ed5a74..9639cf8d8c9c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1355,6 +1355,10 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	*memslot = NULL;
 	*is_dirty = 0;
 
@@ -1416,6 +1420,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1524,6 +1532,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0698D18A0A0
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgCRQiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:38:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:55718 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727212AbgCRQiI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DbIEKxQZmIYFq1w/SkWKaND4GG5JNf/3dwSGOj/APts=;
        b=WpKfQH6MK6KLc9jnZqiWwM2g8Ns4F3JLBo1z7DiBE5EG7P4ytqyA79aVPCbOsetyeIe1iO
        AKkKlTJh/RoosoSe+A4+mrViM/OkM1C0JTUGXRsehzM8J1WW86yRewGNQHO6CZ0IeEruMP
        fXQ2Htn8Vxn2Z9xmCiBVckBGVHVatbg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-daILBt_BOb22_bwM21pb5Q-1; Wed, 18 Mar 2020 12:38:06 -0400
X-MC-Unique: daILBt_BOb22_bwM21pb5Q-1
Received: by mail-wr1-f71.google.com with SMTP id t4so8329077wrr.1
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DbIEKxQZmIYFq1w/SkWKaND4GG5JNf/3dwSGOj/APts=;
        b=sbMUXDA2Ilr7DwPsuhMq5A083xO1TxAhyJrwe9mxIm9uCdcRb9aqjlFNquMBT0E6LJ
         SGY389bYOQaXNARHVw2HOeEsw4uUuScS4wpj+WeGhmdzmqKM25UlgAPl/mFPuknXwwD9
         AMV8VH0uCjbNPk2BeUgRsObK0rtDUbFJ1cNXC/THmOl8fu1yeHibH7AeivHFuRmJqDR8
         tBBRcOq8vjNfC5Q0K7gbno2Bjj9fJ55c/kopCALLIblaDAQ/iKcJg+jYgu88NzFz2PLw
         pvOK5QVRoeC31x61ocRGABAjSH3LDP4URyY8OMWmYEpmlwzp7xCA1U4KwLQqgXkedFsJ
         5jZA==
X-Gm-Message-State: ANhLgQ3BNzdhQvoUta8ZKjgECP5Dp5hjls3H7jA+vkl+wTYoVwqqEwZ+
        zEBCgNEzwvTAOCf9Wjd7lDgT3O194tpayD51OCMLAmbw0W55PCMTe+ZvhYqM/ZXii8Of5LulIkg
        t1cHTb/G+gLJh
X-Received: by 2002:adf:82a6:: with SMTP id 35mr6519903wrc.307.1584549484983;
        Wed, 18 Mar 2020 09:38:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vskDRvP8NN5DeZ4TgxjRImfaEI44udphL2xmoaVwOJLB8nU4Tnt777CEjDBw7+H2bz/9rsV+Q==
X-Received: by 2002:adf:82a6:: with SMTP id 35mr6519877wrc.307.1584549484707;
        Wed, 18 Mar 2020 09:38:04 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id c23sm9140301wrb.79.2020.03.18.09.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:38:04 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 06/14] KVM: Make dirty ring exclusive to dirty bitmap log
Date:   Wed, 18 Mar 2020 12:37:12 -0400
Message-Id: <20200318163720.93929-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318163720.93929-1-peterx@redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
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
index 99ee9cfc20c4..8f3a83298d3f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6202,3 +6202,10 @@ make sure all the existing dirty gfns are flushed to the dirty rings.
 
 The dirty ring can gets full.  When it happens, the KVM_RUN of the
 vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
+
+NOTE: the KVM_CAP_DIRTY_LOG_RING capability and the new ioctl
+KVM_RESET_DIRTY_RINGS are exclusive to the existing KVM_GET_DIRTY_LOG
+interface.  After enabling KVM_CAP_DIRTY_LOG_RING with an acceptable
+dirty ring size, the virtual machine will switch to the dirty ring
+tracking mode, and KVM_GET_DIRTY_LOG, KVM_CLEAR_DIRTY_LOG ioctls will
+stop working.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 54a1e893d17b..b289d3bddd5c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1352,6 +1352,10 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	*memslot = NULL;
 	*is_dirty = 0;
 
@@ -1413,6 +1417,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
+	/* Dirty ring tracking is exclusive to dirty log tracking */
+	if (kvm->dirty_ring_size)
+		return -EINVAL;
+
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -1521,6 +1529,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
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
2.24.1


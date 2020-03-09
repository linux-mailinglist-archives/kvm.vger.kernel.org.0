Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E945F17EB71
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 22:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgCIVon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 17:44:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23387 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727146AbgCIVok (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 17:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583790279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mfTkC/PY7xB+DvD3BXQd6wkmojeJ73JPJ868luIW5QI=;
        b=dutyyN5B8uPaWEBOGjX06Y+CWxCH+fqjTv4Dpkw5+Ghwwu/Z3ej/IbzWxEumt8SxJk9GNr
        6sgPu36Yzm8W/+0DzhyN3YgC06mEWVDgVSusp4YYPax2Cq3Gl0qdRlxMIgUk9hBmhEnGiv
        G9E3rRs6d1+TDeW6k79LXer5WsYHrU8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-x9BBWIG1Nt6lkzGcoSYRQQ-1; Mon, 09 Mar 2020 17:44:34 -0400
X-MC-Unique: x9BBWIG1Nt6lkzGcoSYRQQ-1
Received: by mail-qt1-f200.google.com with SMTP id y11so5559714qtn.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 14:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mfTkC/PY7xB+DvD3BXQd6wkmojeJ73JPJ868luIW5QI=;
        b=tn1fRBO/qqhaGDwk9/YKmJ476gMKPspWFKyB2RrnyIzwWIeQF6DixVNtnjMDbm9btG
         0KmLM+e7IYsqBQhF2v/v+sIJJJY9kf77FFJ8HCWGedApZjXi1cMzQhc3/mM6Vt3uIsEv
         Ohnw6bakKT51pK7Ycbvhm0+NYCuS+bPryQjPSCOye+wowp90w/Qcd+cAWhiwSrYD01BH
         0LZ6xNNvd0429cKZJrCXkpggE6TvsURCQCoOKjwCeclWnebw2Ky0kVZC0IUpHlIT2D76
         VZbL2mMhH9zokR3ytNjEOotzH8h3KTTA6qEpm3sx/16ffGrtUpuXeK5kxOGVPOSlbY11
         yP0w==
X-Gm-Message-State: ANhLgQ0lKqxyBlQff/luHXXVqUAcqEfYo0NswAOpGtCeGAaL26G86Qq5
        KhqGJbN0DQMWP+upMex1m5TeQdGT45AYpQN8DMHR/Qh0zI96VfPAex1+IZ2sa0S9XKaPZ/8BDB9
        BKnjSAOX5+6a3
X-Received: by 2002:a05:620a:10b3:: with SMTP id h19mr17258503qkk.440.1583790273662;
        Mon, 09 Mar 2020 14:44:33 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvsM+A/HXt2SdA20F9/F6ZEZxnI2TYHMgtduNetNttyjBPSSVebBrYy4uvOhyP6E4shJ1zt5A==
X-Received: by 2002:a05:620a:10b3:: with SMTP id h19mr17258480qkk.440.1583790273430;
        Mon, 09 Mar 2020 14:44:33 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id m11sm19777447qkh.31.2020.03.09.14.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 14:44:32 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v6 02/14] KVM: Cache as_id in kvm_memory_slot
Date:   Mon,  9 Mar 2020 17:44:12 -0400
Message-Id: <20200309214424.330363-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: <20200309214424.330363-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cache the address space ID just like the slot ID.  It will be used in
order to fill in the dirty ring entries.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bcb9b2ac0791..afa0e9034881 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -346,6 +346,7 @@ struct kvm_memory_slot {
 	unsigned long userspace_addr;
 	u32 flags;
 	short id;
+	u8 as_id;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce0e5c1..e6484dabfc59 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1036,6 +1036,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	new = old = *slot;
 
+	BUILD_BUG_ON(U8_MAX < KVM_ADDRESS_SPACE_NUM);
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = base_gfn;
 	new.npages = npages;
-- 
2.24.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE12128669
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfLUBt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:49:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43236 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLUBty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 20:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576892993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5JYh7n3fhb27PXs/bYUs6lzlcg1ya8dgcofIlxRo1Jg=;
        b=ISlm3w2hHW49XoOwsizs8UUXrsEequmNaRXOOi7cmmZA2zDHG1ry3fu43jPguMRhqlUFiA
        ANHEr5anZC5Fl728oCADVEKvRpT23aT4+PcJmNRp5je/XUw41jKjN3SieglwU0HqS/p+qx
        WLEO0HNOcuL3LN1AAOVX/XXAvrT7qtk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-SDmg80l2PCq7OajmHy4WEA-1; Fri, 20 Dec 2019 20:49:50 -0500
X-MC-Unique: SDmg80l2PCq7OajmHy4WEA-1
Received: by mail-qt1-f199.google.com with SMTP id i3so7171896qtb.10
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:49:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5JYh7n3fhb27PXs/bYUs6lzlcg1ya8dgcofIlxRo1Jg=;
        b=t3owXb/otdPh/csOxQFeoeB6BHE+N/p0Hc6TZONB54/yy4a+r/SkoD2ReaFudG4dGT
         dqYFl+Sd91FlGTGIp0RTY/bErvZSiw7HCmrfbVXP+DFPIzpp9U5FlJ37AlYJlM9oTrrZ
         scYGbt/kMtRBNO5zZeg2ooi0pa5Lbn96OgpBeutlXqwUq9iY4taQ4G6MLzG8AsEpWCX8
         aI8HtKnAP9nL/csZmgcAseEuiYkf27WxRaFhj9LyCvKkPm0CkBw5QYCaT600jvzhpmtw
         zqQhF3wHgFkTvoFw4ZT1AYmrqVnxxegIimZQXjRgMrnzFhOA2JXG9zpubBAXanK8rdDo
         W8Xw==
X-Gm-Message-State: APjAAAVyeep3FgtNl2QwX3D3+oM3mqVt3SYworVsU8boFNvNwfdmCTxz
        2FJPufe1SBxQjrBoqMaHQN6TE0HX870O5gD98mJniT8tIsHnHk7eSjHGAmEYYNQP3YV1/JqlJh+
        BnADmHGd1jOtp
X-Received: by 2002:a0c:e2d1:: with SMTP id t17mr15471479qvl.25.1576892990173;
        Fri, 20 Dec 2019 17:49:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqz2f4YaxCbKnooBeaquHpX/lFhmLSfHle1bIaMFZ+SWobZuOjXMIOyhSsfc14XqKr1XMbX83A==
X-Received: by 2002:a0c:e2d1:: with SMTP id t17mr15471464qvl.25.1576892989964;
        Fri, 20 Dec 2019 17:49:49 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:49 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 04/17] KVM: Cache as_id in kvm_memory_slot
Date:   Fri, 20 Dec 2019 20:49:25 -0500
Message-Id: <20191221014938.58831-5-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's cache the address space ID just like the slot ID.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4e34cf97ca90..24854c9e3717 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -348,6 +348,7 @@ struct kvm_memory_slot {
 	unsigned long userspace_addr;
 	u32 flags;
 	short id;
+	u8 as_id;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1047173d78e..cea4b8dd4ac9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1027,6 +1027,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	new = old = *slot;
 
+	BUILD_BUG_ON(U8_MAX < KVM_ADDRESS_SPACE_NUM);
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = base_gfn;
 	new.npages = npages;
-- 
2.24.1


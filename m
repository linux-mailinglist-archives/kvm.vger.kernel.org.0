Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4E1135C19
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732045AbgAIO73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:59:29 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46455 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731964AbgAIO54 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:57:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EWV08i+y09T0shEQm4Du/cNi7j67EsBakky7HQM3iHM=;
        b=XoqMRlwKNuy1kh5HFK3GTjotAYxQSPD6ZXUydHAmmbS5nTouHc3aO0UhhmL2lxbCrqXzRQ
        XTsasPjEujaErIKF9NXOldLlSyatvLsZoRNPa2taTmHaFagqQWLN33XeV0S+XgNLt89pCS
        JxhWH/w78y+k6pZb+4JOizG3QveqVDE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-n_dCF6DSOI2xKB_7FwZoMA-1; Thu, 09 Jan 2020 09:57:54 -0500
X-MC-Unique: n_dCF6DSOI2xKB_7FwZoMA-1
Received: by mail-qk1-f197.google.com with SMTP id c202so4323500qkg.4
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:57:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EWV08i+y09T0shEQm4Du/cNi7j67EsBakky7HQM3iHM=;
        b=UTgiEgbkKHi4kv47xAgjV6+FlJD+KYlsViMkrdfTOoigQgXNCDa5ncKievfco9HB0e
         efrIApwTJV5t7SpQZu44VrvS74leqeH52SVASH/3lpe4cUHnt35yfA2AAJIMAMbh2VW5
         gt5tfFdMWhmWQbdYoJv9iy5Yr+XK2DZY9Vz4uSLn8hwHD93lBCWSMw4HKzN8PnDWtjLQ
         GC8VG/LYs5VtncOrMBiYDtleL5cbv07m0l5QGlLZp/nKPnotRYss2T0a/kdz1TC49erh
         yYh6GBzSCDcqkqc2VCk5ZaRb2M1ASjylPwSJU8B1Ztt54a9TpT0O+JKJDvk2ZN4Sq1JM
         02mg==
X-Gm-Message-State: APjAAAU7XEAoaMTkFB13lr4WkBfuVI2i1JEw4CBvG6Fx5rdFXQw6kmP7
        qM4pmTdoIk+FDm/WeVTJ7sekxBfxDlSKxoLkRqd1QM/w3Lz9Ka/PMp+r5A4rMdfzsAfLy61A+cN
        rNQeUhV0GtqFw
X-Received: by 2002:a05:620a:136e:: with SMTP id d14mr9774132qkl.342.1578581873443;
        Thu, 09 Jan 2020 06:57:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxCvoe5Ap6+5M5ORKV7xt2P5nsc1tcHZco1QoU+FUiuKNxmacCYbTCTEN1X9W8lMsTu+hLsCQ==
X-Received: by 2002:a05:620a:136e:: with SMTP id d14mr9774109qkl.342.1578581873235;
        Thu, 09 Jan 2020 06:57:53 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:57:52 -0800 (PST)
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
Subject: [PATCH v3 07/21] KVM: Cache as_id in kvm_memory_slot
Date:   Thu,  9 Jan 2020 09:57:15 -0500
Message-Id: <20200109145729.32898-8-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
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
index 2337f9b6112c..763adf8c47b0 100644
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
index 70b78ccaf3b5..1fd204f27028 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1040,6 +1040,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	new = old = *slot;
 
+	BUILD_BUG_ON(U8_MAX < KVM_ADDRESS_SPACE_NUM);
+	new.as_id = as_id;
 	new.id = id;
 	new.base_gfn = base_gfn;
 	new.npages = npages;
-- 
2.24.1


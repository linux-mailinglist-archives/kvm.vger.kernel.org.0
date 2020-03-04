Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A23B517970C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388203AbgCDRuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:50:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46893 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388181AbgCDRuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 12:50:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583344202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mfTkC/PY7xB+DvD3BXQd6wkmojeJ73JPJ868luIW5QI=;
        b=Ew6ViRSW+jgrTdZcI/bibJtVngLuS+9HaoL2K/hFIwkGcMUf7W+673w6idEWhGh/RTIY12
        j1YFh+sEkl+b6l7lu/M/EIySkFykA7GHmQHkyqAMtimrKDIZ2wlZ80mDA/eSxqJqNUWmVL
        4TiCJ7Q5Z6X0W5+df+Yu+Bjn9tZcz6k=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-9r8gH7akNu6Tsac76Ib7JA-1; Wed, 04 Mar 2020 12:49:57 -0500
X-MC-Unique: 9r8gH7akNu6Tsac76Ib7JA-1
Received: by mail-qt1-f199.google.com with SMTP id j1so1049331qtb.16
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:49:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mfTkC/PY7xB+DvD3BXQd6wkmojeJ73JPJ868luIW5QI=;
        b=gFb+Xg8ZxrFpru5k0YqzFoAK2nrGkOIvb1laWOS7ZfPZunNr4VPkSmxyR0KpEO0Kcc
         hg6M01PN8h//udxCy/TR34272jGrSsqI1jm8HsMaFuU8T0CrDjgCeoPiw9S3F3rwhEq1
         5O5M7i1L57U/CfFqjkW/ed5j3/fpN/BnaIOkoSyT3oD1niF9FeYESlq5jpo0OGeg9jyc
         KG2dKuQwSfXW/lntU7Y7iQKNRtEmWJJarrACqJA6q6tI2e40Wmg00m4HFDwz9QGwlPQ4
         d2d2lGVnEgEg0unqlEJ2wkBznGerEFIKUkmIxmwhZPOvgxR0LmvBzT/EkzgeTOyU+tgg
         d1Kg==
X-Gm-Message-State: ANhLgQ0I2+6cpUzF4MjxcqZpuJdOfJkp8OtuQmoD3w4qPS5jBgzZhnX7
        +QEiGdv98S2CmsB7BlVUKuqW9Gw2PrRwD43x7q3S5/Ykd/49G4Q18SM5miBUtaR0P/Rh9zw8Llz
        tV/Ppj8C/TcSv
X-Received: by 2002:a05:620a:2116:: with SMTP id l22mr4026041qkl.311.1583344197311;
        Wed, 04 Mar 2020 09:49:57 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvrMDWUEoj6vNcSrSe6DsUXUc0EpIPzTdDJM3axSpL8+wBuqbsoHgNqZ8SLGK51EOT04ppFQg==
X-Received: by 2002:a05:620a:2116:: with SMTP id l22mr4026023qkl.311.1583344197103;
        Wed, 04 Mar 2020 09:49:57 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id e88sm7085142qtd.9.2020.03.04.09.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:49:56 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v5 02/14] KVM: Cache as_id in kvm_memory_slot
Date:   Wed,  4 Mar 2020 12:49:35 -0500
Message-Id: <20200304174947.69595-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304174947.69595-1-peterx@redhat.com>
References: <20200304174947.69595-1-peterx@redhat.com>
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


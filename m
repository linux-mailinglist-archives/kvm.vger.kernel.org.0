Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E580135C07
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbgAIO5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:57:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46961 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731950AbgAIO5y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iOwBnRfuU+D9l17RCY4C+mlVimy3V5B0lUjjJ1K6zlg=;
        b=ZitsTMB9GqxN0L3wJGTl0fI5mP3dX9G96cl6ilpEZLfJAouO0RK39QzzMNwUvbuYKIivFI
        FFlIyoU5Axm2IroNrrFnWV+2RQCfj5+jf0ZfdwN+uLsayHcs4/m1m6N/+r9F5YmmZl2i57
        Nruvdx/Wc+Kv71USSE9L5jg+ZzFwIgo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-QN9pm6e6NfmaKMxYxZt3HA-1; Thu, 09 Jan 2020 09:57:52 -0500
X-MC-Unique: QN9pm6e6NfmaKMxYxZt3HA-1
Received: by mail-qk1-f197.google.com with SMTP id k10so4299100qki.2
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:57:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iOwBnRfuU+D9l17RCY4C+mlVimy3V5B0lUjjJ1K6zlg=;
        b=ov8agg6DUVLP3Sq3Qan04j6hV8GoOC70YkpA4Drumf0ud7Qgl6FmJibFuhHQC8SsWG
         scm1lp2XZwco8BUbxROKc6WeZQBRyTb6bZ2wW0PNGybrKcPHFjm8L4XXh8LqsvUAOU0x
         a6jBaNm27qZ+14PK2m63ZeOnKvzKxzu0jpBE7VqiNHKu13V7+gk9BRZJU3wzTXkt+BRm
         eVf24VM4VAl8j/kf44Udglpx3qhFTakhkw2iwHFWUKB9hA3a2JQUHx1rbco0KKPGDd3j
         US+y0SKEpHoa9cJyFbe/LEzM0pOJxe+A7znyqBo6nCYeiVUoDHebn+XECWrFpXYpjDA/
         RYFA==
X-Gm-Message-State: APjAAAWVkyX7bCdxtoB4SY9yWi8qotuETc5svrarcE4lg8oaTEKhpzNn
        dm4dOeEpiiN2NVG+RupNi4C4RSTtXNG8zLArdsq8kgBBeKxPnHv4vw4fHQ4lWsiyS0YxBNMz2W4
        6jRh+TbIIb/HZ
X-Received: by 2002:a05:6214:903:: with SMTP id dj3mr9256932qvb.27.1578581871239;
        Thu, 09 Jan 2020 06:57:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjzq+Zf7itjTFb9hX/DEDGZiDvjZ55SpaSIA4PVTPWagLi4h5EO3WDSjPMFAcJ3UFk0noDsw==
X-Received: by 2002:a05:6214:903:: with SMTP id dj3mr9256894qvb.27.1578581870928;
        Thu, 09 Jan 2020 06:57:50 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:57:50 -0800 (PST)
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
Subject: [PATCH v3 06/21] KVM: X86: Don't take srcu lock in init_rmode_identity_map()
Date:   Thu,  9 Jan 2020 09:57:14 -0500
Message-Id: <20200109145729.32898-7-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We've already got the slots_lock, so we should be safe.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b5a0c2e05825..7add2fc8d8e9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3475,7 +3475,7 @@ static int init_rmode_tss(struct kvm *kvm)
 static int init_rmode_identity_map(struct kvm *kvm)
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
-	int i, idx, r = 0;
+	int i, r = 0;
 	kvm_pfn_t identity_map_pfn;
 	u32 tmp;
 
@@ -3483,7 +3483,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	mutex_lock(&kvm->slots_lock);
 
 	if (likely(kvm_vmx->ept_identity_pagetable_done))
-		goto out2;
+		goto out;
 
 	if (!kvm_vmx->ept_identity_map_addr)
 		kvm_vmx->ept_identity_map_addr = VMX_EPT_IDENTITY_PAGETABLE_ADDR;
@@ -3492,9 +3492,8 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	r = __x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
 				    kvm_vmx->ept_identity_map_addr, PAGE_SIZE);
 	if (r < 0)
-		goto out2;
+		goto out;
 
-	idx = srcu_read_lock(&kvm->srcu);
 	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
 	if (r < 0)
 		goto out;
@@ -3510,9 +3509,6 @@ static int init_rmode_identity_map(struct kvm *kvm)
 	kvm_vmx->ept_identity_pagetable_done = true;
 
 out:
-	srcu_read_unlock(&kvm->srcu, idx);
-
-out2:
 	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
-- 
2.24.1


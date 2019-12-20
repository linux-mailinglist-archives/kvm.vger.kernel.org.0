Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51011283C1
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfLTVR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:17:29 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42081 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727504AbfLTVQl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:16:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576876600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5u+NdTdcxJqnd4CDcK36kvrGYVN4B69rZJAB5gjRDOQ=;
        b=XKfypzCnnuG8ym16HqYjIAMV/6Jx0su0I62m3jXSoXXerZSvjEZzMVNCXlmqg0eShinQFt
        ckNZZ+StSvBoPDLVM8ubNPXRudfz+8BkTCIpJ5VbRJRrdNCXdV2uahWkFXuNJPB1r+c7U0
        +9ukiSVntmtl6EQAhXGg+3NdcDFGK24=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49--7EbwAZjOGKS7wiqA20p3w-1; Fri, 20 Dec 2019 16:16:39 -0500
X-MC-Unique: -7EbwAZjOGKS7wiqA20p3w-1
Received: by mail-qk1-f200.google.com with SMTP id l7so6777028qke.8
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:16:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5u+NdTdcxJqnd4CDcK36kvrGYVN4B69rZJAB5gjRDOQ=;
        b=KC46hHQI4txyPfmL7gz6B/uFdo5ogx2JRFrc0WFrGJKcrA958DOOpg9Vc7bV8e0/X1
         /QeNJMYcRGmfsuAP0frF/1ldTvwXQoRjNShFQPZbyHUv5nf+zW0VA+L0FnNHXuVdEu4w
         MeHuiK8eOB82w0tg09SUMOIyk6H8fxP+sHNOWZCPx1SacMZgBKBtpAPvsp3T6qo4kmck
         gz4xd7+KSqgxjbBJ4Jd2wieX+wKYO54B6uzpt1cwt4r3mj9qQjv0QOSwdyiVYU4pykA4
         LCMfIOUOxbYxvr5J91/iA9OIY16ja5el+HjLWV4BvYTYlKf1Auh9r7RFNIqJJrXFgcIR
         OKiA==
X-Gm-Message-State: APjAAAXtvcUh7xgjLGqiMz+nlJHNiBk9Qr2p7WI+2yb3O30dhaVO9IW9
        CDy+vEEcuxWFqdMGNGcnOEnwC5tGgbiW5lnZ4M8j9CbJchDIWqz/6yJpxKA2Y6+VxvnHKigTPOQ
        YQbdNMUkQBv2Y
X-Received: by 2002:ad4:478b:: with SMTP id z11mr14206440qvy.185.1576876598687;
        Fri, 20 Dec 2019 13:16:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxoKvokYa9wz/VYk7DXc6sLhq1nQIWkintnAX/rU5VixNiHjfptm5B8929S8w9MKyIcQEcPLA==
X-Received: by 2002:ad4:478b:: with SMTP id z11mr14206426qvy.185.1576876598497;
        Fri, 20 Dec 2019 13:16:38 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d25sm3385231qtq.11.2019.12.20.13.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:16:37 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v2 01/17] KVM: Remove kvm_read_guest_atomic()
Date:   Fri, 20 Dec 2019 16:16:18 -0500
Message-Id: <20191220211634.51231-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220211634.51231-1-peterx@redhat.com>
References: <20191220211634.51231-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_read_guest_atomic() because it's not used anywhere.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h |  2 --
 virt/kvm/kvm_main.c      | 11 -----------
 2 files changed, 13 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d41c521a39da..2ea1ea79befd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -730,8 +730,6 @@ void kvm_get_pfn(kvm_pfn_t pfn);
 
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
-int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
-			  unsigned long len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
 int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13efc291b1c7..7ee28af9eb48 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2039,17 +2039,6 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 	return 0;
 }
 
-int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
-			  unsigned long len)
-{
-	gfn_t gfn = gpa >> PAGE_SHIFT;
-	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
-	int offset = offset_in_page(gpa);
-
-	return __kvm_read_guest_atomic(slot, gfn, data, offset, len);
-}
-EXPORT_SYMBOL_GPL(kvm_read_guest_atomic);
-
 int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 			       void *data, unsigned long len)
 {
-- 
2.24.1


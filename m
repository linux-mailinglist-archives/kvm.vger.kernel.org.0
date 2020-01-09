Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE98D135BE8
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731930AbgAIO5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:57:46 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46056 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731918AbgAIO5q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TtlFeY7HzyndokCyv32BVKkuZLgrN4WwINmZ03zf3D4=;
        b=FnNcQcpw6h+jf99h/piGPGq0KMQQrlSUrgE+BkQyGzIkj1CKNe5uhIhxEvbQbVAng8BZrA
        3PwwnTVLzTpubUxQzRY/Bg+tPPpSUNAKbwcZFRIiGy4chBgtwU7S3nLBfsWsbTS5H3lYZM
        W60h3XnBZS94aDaQh9WAIyV/lnrcg1U=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-m6icWMY9NiqVtbVBXcEf_w-1; Thu, 09 Jan 2020 09:57:43 -0500
X-MC-Unique: m6icWMY9NiqVtbVBXcEf_w-1
Received: by mail-qt1-f198.google.com with SMTP id m30so4364525qtb.2
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:57:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TtlFeY7HzyndokCyv32BVKkuZLgrN4WwINmZ03zf3D4=;
        b=dzKGmsTdk1zbfGqbQem7kKbSpGVLsGcLKiKCPAEh1rvZ6+171c+nHVkNzd2Et66ySs
         eD7/gX4dDCfzP+ZQG8U0TyvgfGx8hmpbqY2nihO5I9CX3p1DBijJt9uT5dOGbj7nMJOV
         QB+N7YZHfEkZUvYJPkyPjNS2Yfcwp57cuJycCIFSZtzixVcs/MKDEZ6FJV9Kj4rEiupR
         91UWLErwdUm+bBziZMup5t8E/QWP1/cm1V9KKm5vPRTABfMwqULHMGP114j/k20fCc3h
         z6HmXcqqYoXs5N6tuhFHZpxNx3Uu2Nz4dXg/eJfuvyd92axX3vJNHDbGhHwdmM6/j+HS
         OZOA==
X-Gm-Message-State: APjAAAUz6N3HpPuCcWel+8ZVv/tmx1MiOZJnGgd395Zc3L+qBNalT0Xk
        ij0chrEV2k6dR3z61jBFfZG9OMWDx59Fp+uZQvqrWKaDVLC0/UKhrVvW+Vd9h5ybgtDiGEwSASV
        zODS2xUxrOond
X-Received: by 2002:a37:52d5:: with SMTP id g204mr10243293qkb.215.1578581862081;
        Thu, 09 Jan 2020 06:57:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwGbU0IaY9Ud+rTAWvjCd+8O9eQGTqr/fi0Y9HIplgcF1WCujVwGE+E2M6bfObjr+FYycncdQ==
X-Received: by 2002:a37:52d5:: with SMTP id g204mr10243271qkb.215.1578581861864;
        Thu, 09 Jan 2020 06:57:41 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:57:40 -0800 (PST)
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
Subject: [PATCH v3 03/21] KVM: Remove kvm_read_guest_atomic()
Date:   Thu,  9 Jan 2020 09:57:11 -0500
Message-Id: <20200109145729.32898-4-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
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
index 528ab7a814ab..2337f9b6112c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -725,8 +725,6 @@ void kvm_get_pfn(kvm_pfn_t pfn);
 
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
-int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
-			  unsigned long len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
 int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3aa21bec028d..24c9cf4c8a52 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2048,17 +2048,6 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E71432262
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 17:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhJRPQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 11:16:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230346AbhJRPQ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 11:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634570056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ITZwjENSq81FiJiI76HRsEVj0Df1FfhM1x0DN4yhQYw=;
        b=BgchpXHwSbviu7AnPg5IT1DQeRwyG6LlYskHuqPuhqFtLtk7AN/xfGyvMSa+46yfX5ZRWj
        QJLoF+8r81gcWgIQHjWRP0Ux7Vb/HNS6xPb6Hzoc0t2dy67nqqoH8tNSIlFnWz46Ex8O+j
        JbgLe6XyTKCOi4PEYhko/4weJJ4lfPg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-gqBotatuOLS0cCSnivgCyw-1; Mon, 18 Oct 2021 11:14:12 -0400
X-MC-Unique: gqBotatuOLS0cCSnivgCyw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0663362FC;
        Mon, 18 Oct 2021 15:14:10 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D2215DF35;
        Mon, 18 Oct 2021 15:14:08 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Drop stale kvm_is_transparent_hugepage() declaration
Date:   Mon, 18 Oct 2021 17:14:07 +0200
Message-Id: <20211018151407.2107363-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_is_transparent_hugepage() was removed in commit 205d76ff0684 ("KVM:
Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()") but its
declaration in include/linux/kvm_host.h persisted. Drop it.

Fixes: 205d76ff0684 (""KVM: Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 include/linux/kvm_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f18df7fe874..2dc62a8cc96c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1164,7 +1164,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
-bool kvm_is_transparent_hugepage(kvm_pfn_t pfn);
 
 struct kvm_irq_ack_notifier {
 	struct hlist_node link;
-- 
2.31.1


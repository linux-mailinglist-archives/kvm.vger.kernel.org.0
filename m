Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2BE2F7C68
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbhAONVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:21:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731315AbhAONVN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610716732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72IdiNGgGPIu/gnrc+hSZexB39ZbyEkwh9wEWdrVo7g=;
        b=L3Q3/tFIpNcXe0+LnsP4gAPvKr4B22mes/ERRioA7xEE6sE1FcsMLOCIju73VDx1RnPmOB
        lR5sDk/hc7rKfICIJuDjSnLbvSOeOG0/bRkmXPzJLnfFzg1zXcGmLLJ0ifeTAW9NDzLSmG
        94awpr06fO+y5eK/AI50zgpcmX+Y8e8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-L0lTHd_oPn-vYgQajabVIQ-1; Fri, 15 Jan 2021 08:18:50 -0500
X-MC-Unique: L0lTHd_oPn-vYgQajabVIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75615190A7A3;
        Fri, 15 Jan 2021 13:18:49 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D11AA60CCE;
        Fri, 15 Jan 2021 13:18:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 1/4] KVM: x86: Drop redundant KVM_MEM_SLOTS_NUM definition
Date:   Fri, 15 Jan 2021 14:18:41 +0100
Message-Id: <20210115131844.468982-2-vkuznets@redhat.com>
In-Reply-To: <20210115131844.468982-1-vkuznets@redhat.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_MEM_SLOTS_NUM is already defined in include/linux/kvm_host.h the
exact same way.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c27cbe3baccc..1bcf67d76753 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -43,7 +43,6 @@
 #define KVM_USER_MEM_SLOTS 509
 /* memory slots that are not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 3
-#define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
 #define KVM_HALT_POLL_NS_DEFAULT 200000
 
-- 
2.29.2


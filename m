Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F1D2F7C69
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732927AbhAONVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:21:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732839AbhAONVP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:21:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610716734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CotuH+eOoDPL5jbXb8IsPjpc61Hl+KnhLM00c9Y+cIE=;
        b=RsaVdUV8WYHd6UeHjsiEZxqT1h3r1wmwnO+0tjqS7vbLA95T/uVv07olAbwtvyzHKtxY1a
        o67p7u6+zejW9zwOY7FdAV+StH3JWKpUvcP3dnbGZ+ABHHWNm/8AVz5p1d9fLUFJW+D2iu
        wmtKgeGBL/r+OvGLNBL5raCEOvy/Rn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-MrH8pzByNdePRJnWudwr-Q-1; Fri, 15 Jan 2021 08:18:52 -0500
X-MC-Unique: MrH8pzByNdePRJnWudwr-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70C9E190A7A2;
        Fri, 15 Jan 2021 13:18:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C401060CCE;
        Fri, 15 Jan 2021 13:18:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH RFC 2/4] KVM: mips: Drop KVM_PRIVATE_MEM_SLOTS definition
Date:   Fri, 15 Jan 2021 14:18:42 +0100
Message-Id: <20210115131844.468982-3-vkuznets@redhat.com>
In-Reply-To: <20210115131844.468982-1-vkuznets@redhat.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_PRIVATE_MEM_SLOTS is set to '0' in include/linux/kvm_host.h already.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/mips/include/asm/kvm_host.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 24f3d0f9996b..603841ce7f42 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -84,8 +84,6 @@
 
 #define KVM_MAX_VCPUS		16
 #define KVM_USER_MEM_SLOTS	16
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS	0
 
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
-- 
2.29.2


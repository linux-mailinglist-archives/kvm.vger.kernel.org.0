Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5349840075C
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 23:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhICVRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 17:17:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235876AbhICVRH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 17:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630703766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srdfcua/KZfG9uNgguKBUMzB10kEqV9qqqtP8+51J38=;
        b=WJf1oGoqpzr7LfSgsyFU7ORuTsrL0987fE7hTsW6h1N8JPBTJetxHEdGRwogWqXkTn2RgA
        CxI/VD6xDhwR/dmmRzMtuZYgjxvzxvJnMXpE+dPstCcqpp//gqCpdUImvBPh2ZSsNf9Zpp
        GU4ZKsIoXIobqnVPuNSq/cqpI8lrARw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-PiuHyiF4NYyMSZABL7S1fg-1; Fri, 03 Sep 2021 17:16:05 -0400
X-MC-Unique: PiuHyiF4NYyMSZABL7S1fg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC031100A242;
        Fri,  3 Sep 2021 21:16:04 +0000 (UTC)
Received: from localhost (unknown [10.22.8.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 718E318B42;
        Fri,  3 Sep 2021 21:16:04 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Juergen Gross <jgross@suse.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 3/3] kvm: x86: Increase KVM_SOFT_MAX_VCPUS to 710
Date:   Fri,  3 Sep 2021 17:16:00 -0400
Message-Id: <20210903211600.2002377-4-ehabkost@redhat.com>
In-Reply-To: <20210903211600.2002377-1-ehabkost@redhat.com>
References: <20210903211600.2002377-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support for 710 VCPUs was tested by Red Hat since RHEL-8.4,
so increase KVM_SOFT_MAX_VCPUS to 710.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
Note: I would like to get rid of KVM_SOFT_MAX_VCPUS eventually,
but I am simply bumping it to 710 by now, so we can at least
declare 710 VCPUs as supported while we discuss alternatives to
KVM_SOFT_MAX_VCPUS.
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e30e40399092..98e8538cecbf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,7 +38,7 @@
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
 #define KVM_MAX_VCPUS 1024
-#define KVM_SOFT_MAX_VCPUS 240
+#define KVM_SOFT_MAX_VCPUS 710
 
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
-- 
2.31.1


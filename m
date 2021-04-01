Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79F03518FE
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbhDARrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:47:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236247AbhDARoN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:44:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rU3RIc7ZbPs0ZRexkYqTMuHou64+ARL6X0Qz2sJLr4c=;
        b=bVlmHUkJoIBN6AaDwOfB1SiGZ9C/qye5dFZM/JaAF3uxFs6V5n8sINHpaf2CnB7c1YItf7
        97bx4v6U22l3I5Y7ucoO1igAUW8/6PYBkpYqRiaPECt8f30CZSw7sywRI7O9bGbH115fsf
        TIrwdtHorrLT0H75TDsGDasIpffIDhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-CuC3XtW2Mw2ABQ37Qga5OQ-1; Thu, 01 Apr 2021 10:42:02 -0400
X-MC-Unique: CuC3XtW2Mw2ABQ37Qga5OQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEE24817473;
        Thu,  1 Apr 2021 14:41:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD7245D6B1;
        Thu,  1 Apr 2021 14:41:55 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] kvm: update kernel headers for KVM_GUESTDBG_BLOCKEVENTS
Date:   Thu,  1 Apr 2021 17:41:51 +0300
Message-Id: <20210401144152.1031282-2-mlevitsk@redhat.com>
In-Reply-To: <20210401144152.1031282-1-mlevitsk@redhat.com>
References: <20210401144152.1031282-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 linux-headers/asm-x86/kvm.h | 2 ++
 linux-headers/linux/kvm.h   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 8e76d3701d..33878cdc34 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -281,6 +281,8 @@ struct kvm_debug_exit_arch {
 #define KVM_GUESTDBG_USE_HW_BP		0x00020000
 #define KVM_GUESTDBG_INJECT_DB		0x00040000
 #define KVM_GUESTDBG_INJECT_BP		0x00080000
+#define KVM_GUESTDBG_BLOCKIRQ		0x00100000
+
 
 /* for KVM_SET_GUEST_DEBUG */
 struct kvm_guest_debug_arch {
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 020b62a619..2ded7a0630 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_SET_GUEST_DEBUG2 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.26.2


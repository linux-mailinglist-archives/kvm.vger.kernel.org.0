Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED7E3A1781
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbhFIOjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:39:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238031AbhFIOj3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pckoH3+yQRv0sMag9hTgcQK97AOXiccI1lwisxbeoD8=;
        b=ZF3Q+Kw2XdXrq5Z6j5bcm2f0llHa8Y5Dn8bhIEAU6HIoHFpH4B/JD3ZV6vs5aHMITu2iD9
        LVETg45SkrDVftkzNYsjLF18V+yyEkTffrKVDKaIx8TG/4NRWa04gHvXtAtQigaBxC7TRI
        4Y1B71DcwasW7gR6Su9r1bG43BlcAms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-GYpWbdp-OMSOIcEL4xxzug-1; Wed, 09 Jun 2021 10:37:30 -0400
X-MC-Unique: GYpWbdp-OMSOIcEL4xxzug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2840B8030A0;
        Wed,  9 Jun 2021 14:37:29 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2E5119C46;
        Wed,  9 Jun 2021 14:37:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH v2 3/7] asm-generic: unify header guards
Date:   Wed,  9 Jun 2021 16:37:08 +0200
Message-Id: <20210609143712.60933-4-cohuck@redhat.com>
In-Reply-To: <20210609143712.60933-1-cohuck@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Standardize header guards to _ASM_GENERIC_HEADER_H_.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/asm-generic/atomic.h          | 4 ++--
 lib/asm-generic/barrier.h         | 6 +++---
 lib/asm-generic/memory_areas.h    | 4 ++--
 lib/asm-generic/pci-host-bridge.h | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/asm-generic/atomic.h b/lib/asm-generic/atomic.h
index 26b645a7cc18..b09ce95053e7 100644
--- a/lib/asm-generic/atomic.h
+++ b/lib/asm-generic/atomic.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_GENERIC_ATOMIC_H__
-#define __ASM_GENERIC_ATOMIC_H__
+#ifndef _ASM_GENERIC_ATOMIC_H_
+#define _ASM_GENERIC_ATOMIC_H_
 
 /* From QEMU include/qemu/atomic.h */
 #define atomic_fetch_inc(ptr)  __sync_fetch_and_add(ptr, 1)
diff --git a/lib/asm-generic/barrier.h b/lib/asm-generic/barrier.h
index 6a990ff8d5a5..5499a5664d4d 100644
--- a/lib/asm-generic/barrier.h
+++ b/lib/asm-generic/barrier.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_BARRIER_H_
-#define _ASM_BARRIER_H_
+#ifndef _ASM_GENERIC_BARRIER_H_
+#define _ASM_GENERIC_BARRIER_H_
 /*
  * asm-generic/barrier.h
  *
@@ -32,4 +32,4 @@
 #define cpu_relax()	asm volatile ("":::"memory")
 #endif
 
-#endif /* _ASM_BARRIER_H_ */
+#endif /* _ASM_GENERIC_BARRIER_H_ */
diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
index 3074afe23393..c86db255ecee 100644
--- a/lib/asm-generic/memory_areas.h
+++ b/lib/asm-generic/memory_areas.h
@@ -1,5 +1,5 @@
-#ifndef __ASM_GENERIC_MEMORY_AREAS_H__
-#define __ASM_GENERIC_MEMORY_AREAS_H__
+#ifndef _ASM_GENERIC_MEMORY_AREAS_H_
+#define _ASM_GENERIC_MEMORY_AREAS_H_
 
 #define AREA_NORMAL_PFN 0
 #define AREA_NORMAL_NUMBER 0
diff --git a/lib/asm-generic/pci-host-bridge.h b/lib/asm-generic/pci-host-bridge.h
index 9e91499b9446..174ff341dd0d 100644
--- a/lib/asm-generic/pci-host-bridge.h
+++ b/lib/asm-generic/pci-host-bridge.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_PCI_HOST_BRIDGE_H_
-#define _ASM_PCI_HOST_BRIDGE_H_
+#ifndef _ASM_GENERIC_PCI_HOST_BRIDGE_H_
+#define _ASM_GENERIC_PCI_HOST_BRIDGE_H_
 /*
  * Copyright (C) 2016, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
  *
-- 
2.31.1


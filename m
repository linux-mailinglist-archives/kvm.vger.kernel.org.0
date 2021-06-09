Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9506B3A1779
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbhFIOj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:39:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237895AbhFIOj0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:39:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdoIwVorE9T8/V9vqukYKSu4pZaPnXmuL5Pxnv3fIJg=;
        b=cBkPlruYNPl8/4L8ZKD/CKfQabQjqpoMC6t84714GrcHHGmRWq9u6i86rZGpPXx0llx73u
        FFESOuKVBSOkw5BPHVBhn3BuiS96n5Ykg5mbEJC8oewcFtD2UnMClbcJUJCnYWVHkhhhv3
        D2j5K0XxsT4Yq308eBohWe0nh6fNoxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-ucxfqehPNcGGai5AkcddPw-1; Wed, 09 Jun 2021 10:37:27 -0400
X-MC-Unique: ucxfqehPNcGGai5AkcddPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F0CA1012583;
        Wed,  9 Jun 2021 14:37:26 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A89419C46;
        Wed,  9 Jun 2021 14:37:23 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v2 2/7] lib: unify header guards
Date:   Wed,  9 Jun 2021 16:37:07 +0200
Message-Id: <20210609143712.60933-3-cohuck@redhat.com>
In-Reply-To: <20210609143712.60933-1-cohuck@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Standardize header guards to _LIB_HEADER_H_.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/alloc_page.h       | 4 ++--
 lib/libcflat.h         | 4 ++--
 lib/list.h             | 4 ++--
 lib/pci-edu.h          | 4 ++--
 lib/pci-host-generic.h | 4 ++--
 lib/setjmp.h           | 4 ++--
 lib/string.h           | 6 +++---
 lib/vmalloc.h          | 4 ++--
 8 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 1af1419d49b6..eed2ba06eeaf 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -5,8 +5,8 @@
  * with byte granularity.
  */
 
-#ifndef ALLOC_PAGE_H
-#define ALLOC_PAGE_H 1
+#ifndef _ALLOC_PAGE_H_
+#define _ALLOC_PAGE_H_
 
 #include <stdbool.h>
 #include <asm/memory_areas.h>
diff --git a/lib/libcflat.h b/lib/libcflat.h
index 460a1234ea6a..f40b431d1550 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -17,8 +17,8 @@
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
  */
 
-#ifndef __LIBCFLAT_H
-#define __LIBCFLAT_H
+#ifndef _LIBCFLAT_H_
+#define _LIBCFLAT_H_
 
 #ifndef __ASSEMBLY__
 
diff --git a/lib/list.h b/lib/list.h
index 7f9717ef6258..ed3e52b40075 100644
--- a/lib/list.h
+++ b/lib/list.h
@@ -1,5 +1,5 @@
-#ifndef LIST_H
-#define LIST_H
+#ifndef _LIST_H_
+#define _LIST_H_
 
 #include <stdbool.h>
 
diff --git a/lib/pci-edu.h b/lib/pci-edu.h
index 44b4ba168768..9db94aec0bc7 100644
--- a/lib/pci-edu.h
+++ b/lib/pci-edu.h
@@ -12,8 +12,8 @@
  * Edu device is a virtualized device in QEMU. Please refer to
  * docs/specs/edu.txt in QEMU repository for EDU device manual.
  */
-#ifndef __PCI_EDU_H__
-#define __PCI_EDU_H__
+#ifndef _PCI_EDU_H_
+#define _PCI_EDU_H_
 
 #include "pci.h"
 #include "asm/io.h"
diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
index 0ffe6380ec8f..3020ee22c837 100644
--- a/lib/pci-host-generic.h
+++ b/lib/pci-host-generic.h
@@ -1,5 +1,5 @@
-#ifndef PCI_HOST_GENERIC_H
-#define PCI_HOST_GENERIC_H
+#ifndef _PCI_HOST_GENERIC_H_
+#define _PCI_HOST_GENERIC_H_
 /*
  * PCI host bridge supporting structures and constants
  *
diff --git a/lib/setjmp.h b/lib/setjmp.h
index 2c56b4c68aaa..6afdf665681a 100644
--- a/lib/setjmp.h
+++ b/lib/setjmp.h
@@ -4,8 +4,8 @@
  * This code is free software; you can redistribute it and/or modify it
  * under the terms of the GNU Library General Public License version 2.
  */
-#ifndef LIBCFLAT_SETJMP_H
-#define LIBCFLAT_SETJMP_H 1
+#ifndef _LIBCFLAT_SETJMP_H_
+#define _LIBCFLAT_SETJMP_H_
 
 typedef struct jmp_buf_tag {
 	long int regs[8];
diff --git a/lib/string.h b/lib/string.h
index e1febfed7fb2..b07763eaef10 100644
--- a/lib/string.h
+++ b/lib/string.h
@@ -4,8 +4,8 @@
  * This code is free software; you can redistribute it and/or modify it
  * under the terms of the GNU Library General Public License version 2.
  */
-#ifndef __STRING_H
-#define __STRING_H
+#ifndef _STRING_H_
+#define _STRING_H_
 
 extern size_t strlen(const char *buf);
 extern size_t strnlen(const char *buf, size_t maxlen);
@@ -23,4 +23,4 @@ extern int memcmp(const void *s1, const void *s2, size_t n);
 extern void *memmove(void *dest, const void *src, size_t n);
 extern void *memchr(const void *s, int c, size_t n);
 
-#endif /* _STRING_H */
+#endif /* _STRING_H_ */
diff --git a/lib/vmalloc.h b/lib/vmalloc.h
index 8b158f591d75..346f94f198c5 100644
--- a/lib/vmalloc.h
+++ b/lib/vmalloc.h
@@ -1,5 +1,5 @@
-#ifndef VMALLOC_H
-#define VMALLOC_H 1
+#ifndef _VMALLOC_H_
+#define _VMALLOC_H_
 
 #include <asm/page.h>
 
-- 
2.31.1


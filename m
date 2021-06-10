Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7923A2D9D
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhFJOBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhFJOBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623333585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNhzmFjrf3dgp788YZlGE07kjXUUAi8znsNrFkRrkZk=;
        b=ZWVVN1Oq513CfdhH+Gels82S4t0HtzhF32WbfCee2hi8qD9rfhHLmK5nDZCY+PuZ0jFqlp
        mZkOBBCFWzmCqixOUhBJz4xfXbQ6kwNXGG4eVgiCnSxfVTPrPWfd6eB0XDeYEET/ZrlwUq
        yOxZkQUcgJEywl/stIv0TZjH8FB+Ef0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-k6hylX3YMWeU1jp3NFT6-Q-1; Thu, 10 Jun 2021 09:59:44 -0400
X-MC-Unique: k6hylX3YMWeU1jp3NFT6-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7450F9126D
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 13:59:43 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-107.ams2.redhat.com [10.36.113.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FE331007623;
        Thu, 10 Jun 2021 13:59:41 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 1/2] header guards: clean up some stragglers
Date:   Thu, 10 Jun 2021 15:59:36 +0200
Message-Id: <20210610135937.94375-2-cohuck@redhat.com>
In-Reply-To: <20210610135937.94375-1-cohuck@redhat.com>
References: <20210610135937.94375-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some headers had been missed during the initial header guard
standardization.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 configure             | 4 ++--
 lib/arm/asm/mmu-api.h | 4 ++--
 lib/arm/asm/mmu.h     | 6 +++---
 lib/arm64/asm/mmu.h   | 6 +++---
 lib/pci.h             | 6 +++---
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/configure b/configure
index 4ad5a4bcd782..b8442d61fb60 100755
--- a/configure
+++ b/configure
@@ -332,8 +332,8 @@ if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
 fi
 
 cat <<EOF > lib/config.h
-#ifndef CONFIG_H
-#define CONFIG_H 1
+#ifndef _CONFIG_H_
+#define _CONFIG_H_
 /*
  * Generated file. DO NOT MODIFY.
  *
diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 05fc12b5afb8..3d77cbfd8b24 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -1,5 +1,5 @@
-#ifndef __ASMARM_MMU_API_H_
-#define __ASMARM_MMU_API_H_
+#ifndef _ASMARM_MMU_API_H_
+#define _ASMARM_MMU_API_H_
 
 #include <asm/page.h>
 #include <stdbool.h>
diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 94e70f0a84bf..b24b97e554e2 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -1,5 +1,5 @@
-#ifndef __ASMARM_MMU_H_
-#define __ASMARM_MMU_H_
+#ifndef _ASMARM_MMU_H_
+#define _ASMARM_MMU_H_
 /*
  * Copyright (C) 2014, Red Hat Inc, Andrew Jones <drjones@redhat.com>
  *
@@ -53,4 +53,4 @@ static inline void flush_dcache_addr(unsigned long vaddr)
 
 #include <asm/mmu-api.h>
 
-#endif /* __ASMARM_MMU_H_ */
+#endif /* _ASMARM_MMU_H_ */
diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index 72371b2d9fe3..5c27edb24d2e 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -1,5 +1,5 @@
-#ifndef __ASMARM64_MMU_H_
-#define __ASMARM64_MMU_H_
+#ifndef _ASMARM64_MMU_H_
+#define _ASMARM64_MMU_H_
 /*
  * Copyright (C) 2014, Red Hat Inc, Andrew Jones <drjones@redhat.com>
  *
@@ -35,4 +35,4 @@ static inline void flush_dcache_addr(unsigned long vaddr)
 
 #include <asm/mmu-api.h>
 
-#endif /* __ASMARM64_MMU_H_ */
+#endif /* _ASMARM64_MMU_H_ */
diff --git a/lib/pci.h b/lib/pci.h
index 689f03ca7647..e201711dfe18 100644
--- a/lib/pci.h
+++ b/lib/pci.h
@@ -1,5 +1,5 @@
-#ifndef PCI_H
-#define PCI_H
+#ifndef _PCI_H_
+#define _PCI_H_
 /*
  * API for scanning a PCI bus for a given device, as well to access
  * BAR registers.
@@ -102,4 +102,4 @@ struct pci_test_dev_hdr {
 
 #define  PCI_HEADER_TYPE_MASK		0x7f
 
-#endif /* PCI_H */
+#endif /* _PCI_H_ */
-- 
2.31.1


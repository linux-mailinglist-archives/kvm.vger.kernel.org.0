Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6533A1774
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbhFIOjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:39:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236081AbhFIOjV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vdBWH0NN5RVcs+Ky8LQUJLLDTKdwavE0wet4jRY+IVY=;
        b=UXqc6Y2zn/dmwzBza1IBV+vK15n+2DUTRq2VFI71jNLX/qfrRp1e8RnEci4zUEmBccQlwY
        iU0CsFcvOThUXKp87wp9GS/BoDeJDvK4XjvsSoktCAGspWbtx1e1OPcibLBkOJ2uD7BYv1
        b8Oh+f3B1SeLw0y+WtRxVLZR92DAv+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-wCKholfbM6iAwud00jGFyA-1; Wed, 09 Jun 2021 10:37:25 -0400
X-MC-Unique: wCKholfbM6iAwud00jGFyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1764C73A0;
        Wed,  9 Jun 2021 14:37:23 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5435219C46;
        Wed,  9 Jun 2021 14:37:21 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for header guards format
Date:   Wed,  9 Jun 2021 16:37:06 +0200
Message-Id: <20210609143712.60933-2-cohuck@redhat.com>
In-Reply-To: <20210609143712.60933-1-cohuck@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 README.md | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/README.md b/README.md
index 24d4bdaaee0d..687ff50d0af1 100644
--- a/README.md
+++ b/README.md
@@ -156,6 +156,15 @@ Exceptions:
 
   - While the kernel standard requires 80 columns, we allow up to 120.
 
+Header guards:
+
+Please try to adhere to adhere to the following patterns when adding
+"#ifndef <...> #define <...>" header guards:
+    ./lib:             _HEADER_H_
+    ./lib/<ARCH>:      _ARCH_HEADER_H_
+    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_
+    ./<ARCH>:          ARCH_HEADER_H
+
 ## Patches
 
 Patches are welcome at the KVM mailing list <kvm@vger.kernel.org>.
-- 
2.31.1


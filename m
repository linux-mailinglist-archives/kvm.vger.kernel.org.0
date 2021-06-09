Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415FB3A1785
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbhFIOji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:39:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238047AbhFIOjd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 10:39:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/K++/bcdvbwlQu0OSohcPBViudVd7DNw3ieioYAfUZE=;
        b=F8CtkCjoTMvAf7dHGbAuPDPI/KZBQ7mBojNspHTncN2rpqe/UhYK95tkDjnKhMDP86+A2f
        x73s3QCqAFY0ERumdZJG9TZica5XkSbBjwtklvejBuuhFak6TLkfWkaLw25muqXldBEwt9
        hvKwuBI6HkYhIlS7ERQGB6eXi+QCqGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-M74py1JfNvuB42-ehWRqig-1; Wed, 09 Jun 2021 10:37:36 -0400
X-MC-Unique: M74py1JfNvuB42-ehWRqig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CC26801B12;
        Wed,  9 Jun 2021 14:37:34 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26C0219C46;
        Wed,  9 Jun 2021 14:37:31 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v2 5/7] powerpc: unify header guards
Date:   Wed,  9 Jun 2021 16:37:10 +0200
Message-Id: <20210609143712.60933-6-cohuck@redhat.com>
In-Reply-To: <20210609143712.60933-1-cohuck@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only spapr.h needed a tweak.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 powerpc/spapr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/powerpc/spapr.h b/powerpc/spapr.h
index b41aece07968..3a29598be44f 100644
--- a/powerpc/spapr.h
+++ b/powerpc/spapr.h
@@ -1,6 +1,6 @@
-#ifndef _ASMPOWERPC_SPAPR_H_
-#define _ASMPOWERPC_SPAPR_H_
+#ifndef POWERPC_SPAPR_H
+#define POWERPC_SPAPR_H
 
 #define SPAPR_KERNEL_LOAD_ADDR 0x400000
 
-#endif /* _ASMPOWERPC_SPAPR_H_ */
+#endif /* POWERPC_SPAPR_H */
-- 
2.31.1


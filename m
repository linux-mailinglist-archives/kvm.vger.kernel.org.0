Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639C215DA11
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgBNO7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56580 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729488AbgBNO7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lhQ95FNUtMXhrpDK0+GIsA1hKffoIJiX6fsAw123h0I=;
        b=auga1+SZ8Z4weMl37+q8KY+RaAFthYwkUZBfZ/9tTXgcZiF5ft0HTjNT+27cklupiGQuW1
        IvdX4fEDdJ4wmtjEY5vvFjvwo+6/S42C/MxFw7EVtdi9uuEGsalujWfUK4PbEPdPSwfVKG
        fTbuLXOPc+OMvMiGV9422VrYg2DhIpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-xRKglO5dPumLhq_UvSXQjQ-1; Fri, 14 Feb 2020 09:59:39 -0500
X-MC-Unique: xRKglO5dPumLhq_UvSXQjQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14278107ACC7;
        Fri, 14 Feb 2020 14:59:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 638118AC27;
        Fri, 14 Feb 2020 14:59:36 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 06/13] KVM: selftests: Remove unnecessary defines
Date:   Fri, 14 Feb 2020 15:59:13 +0100
Message-Id: <20200214145920.30792-7-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

BITS_PER_LONG and friends are provided by linux/bitops.h

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util_internal.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/=
testing/selftests/kvm/lib/kvm_util_internal.h
index ac50c42750cf..2fce6750b8b3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -12,17 +12,6 @@
=20
 #define KVM_DEV_PATH		"/dev/kvm"
=20
-#ifndef BITS_PER_BYTE
-#define BITS_PER_BYTE		8
-#endif
-
-#ifndef BITS_PER_LONG
-#define BITS_PER_LONG		(BITS_PER_BYTE * sizeof(long))
-#endif
-
-#define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
-#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
-
 struct userspace_mem_region {
 	struct userspace_mem_region *next, *prev;
 	struct kvm_userspace_memory_region region;
--=20
2.21.1


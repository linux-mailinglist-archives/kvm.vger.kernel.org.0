Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A72204B0B
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 09:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgFWH24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 03:28:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26932 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731057AbgFWH2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 03:28:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592897335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KOoSXZOmbiUr1rlTG1Dr2upX/xU5gp149xe2zR0H7ME=;
        b=UeuuIx/XMCRxn4A5gt9CcY40DMzsh9FuYtwsxWlQtRURcj8RIJTkxRFRXjqwVCL8Dpq1F6
        4JL653LCutGLT2o2w7LaLtWthNokdN3utUmSkqiFhA0ridLPqn2I/wyclBRCmwMBDSOftF
        hX4LlOEtwHI6V4JzDtShpbrL0aKVos0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-1Uup3uu5NKKfl9DPjjzKFA-1; Tue, 23 Jun 2020 03:28:52 -0400
X-MC-Unique: 1Uup3uu5NKKfl9DPjjzKFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29A50805EE4
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 07:28:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E86E25C1D4
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 07:28:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] lib/alloc.c: fix missing include
Date:   Tue, 23 Jun 2020 03:28:51 -0400
Message-Id: <20200623072851.30972-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Include bitops.h to get BITS_PER_LONG and avoid errors such as

lib/alloc.c: In function mult_overflow:
lib/alloc.c:24:9: error: right shift count >= width of type
[-Werror=shift-count-overflow]
   24 |  if ((a >> 32) && (b >> 32))
      |         ^~

Fixes: cde8415e1 ("lib/alloc.c: add overflow check for calloc")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/alloc.c b/lib/alloc.c
index f4aa87a..6c89f98 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -1,5 +1,6 @@
 #include "alloc.h"
 #include "asm/page.h"
+#include "bitops.h"
 
 void *malloc(size_t size)
 {
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5F614588C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 16:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgAVPXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 10:23:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44260 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725802AbgAVPXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 10:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579706633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=I2itWS0wOOp7E/+TSJmQdtjNsnsLCGY7CKG4AUVHbKI=;
        b=LJbZByBTgHQ8j5l+qP5u++HrZvZUhFoLCuh2oRAarWOoRAANymkEMLzsWoGMraE0gwGm0X
        0tHvKqCNWS4KBykm/AfGHW/424TM6QUKtnW0D7pwVRtt1DpuuCF7KCAuM0PnYf7EQOECRH
        0A2Kbu0gBnCDgacpX8XjfnCwWLq1g0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-LaBonfrhNkeL1UMsZ5v-nw-1; Wed, 22 Jan 2020 10:23:52 -0500
X-MC-Unique: LaBonfrhNkeL1UMsZ5v-nw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E516800D55
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 15:23:51 +0000 (UTC)
Received: from thuth.com (ovpn-116-176.ams2.redhat.com [10.36.116.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0746386452;
        Wed, 22 Jan 2020 15:23:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH] Makefile: Compile the kvm-unit-tests with -fno-strict-aliasing
Date:   Wed, 22 Jan 2020 16:23:31 +0100
Message-Id: <20200122152331.14062-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Strict aliasing bugs are often hard to find and understand (when the compiler
did not omit a warning), and kvm-unit-tests are mainly written by kernel
developers who are used to compile their code with -fno-strict-aliasing. So
let's use this flag for the kvm-unit-tests, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 4c716da..3834a12 100644
--- a/Makefile
+++ b/Makefile
@@ -49,7 +49,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
 cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
-COMMON_CFLAGS += -g $(autodepend-flags)
+COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing
 COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
 COMMON_CFLAGS += -Wignored-qualifiers -Werror
 
-- 
2.18.1


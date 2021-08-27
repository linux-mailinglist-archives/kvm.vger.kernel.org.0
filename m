Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F2C3F984D
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244976AbhH0KzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244860AbhH0KzJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630061660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8T0BPsTd+VSSupe/LZTj779EWVf1AbhJwg4MUwYljSc=;
        b=USdtQBaQvN89jzr9poYMTGv+Wo+4WntMJCLKk9Dy1H7l49FGFd3DmZnOZ9aTIw8LNuXWYI
        B20X5d7VvJxfbxyAiCjklt8+qA+19+SDdNFVnEDyZbxcgmiUdTxwdUkFNzb79tp3m6Qh3v
        FGAP+oL6ZLRoXT48WrpxIuzb3X72Bg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-UoeT-EPEMeWiuJa4LCIymA-1; Fri, 27 Aug 2021 06:54:16 -0400
X-MC-Unique: UoeT-EPEMeWiuJa4LCIymA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A042802922;
        Fri, 27 Aug 2021 10:54:15 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D624227CA5;
        Fri, 27 Aug 2021 10:54:08 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pmorel@linux.ibm.com, thuth@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests v2] Makefile: Don't trust PWD
Date:   Fri, 27 Aug 2021 12:54:07 +0200
Message-Id: <20210827105407.313916-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PWD comes from the environment and it's possible that it's already
set to something which isn't the full path of the current working
directory. Use the make variable $(CURDIR) instead.

Suggested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index f7b9f28c9319..6792b93c4e16 100644
--- a/Makefile
+++ b/Makefile
@@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
 cscope:
 	$(RM) ./cscope.*
 	find -L $(cscope_dirs) -maxdepth 1 \
-		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
+		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
 	cscope -bk
 
 .PHONY: tags
-- 
2.31.1


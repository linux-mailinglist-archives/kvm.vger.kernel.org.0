Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4853A5EE0
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 11:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhFNJJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 05:09:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232621AbhFNJJe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 05:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623661651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2dGZ4yZDAL4rNFEt2nLw4kJ03Uta2V0y6FyJ+2O3v+I=;
        b=WqA2YuHZWZUs3E7sWYm9ayjqRGFEQM/SwRDfXNPzX9fy3iiL1c9WE4+ccDfKcK6pIHah6h
        fDKnLdtpQPSBUrq84W64ygLi0IjBORCiuAyaNmF2JnE6owsZ5wRL1sNINAdgY699jWrW1r
        ZJyuz0qZUAOE3Q5bBgDsVLhk7t/wtDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-h8c9xdonNHqduQ4Pxs17Ow-1; Mon, 14 Jun 2021 05:07:29 -0400
X-MC-Unique: h8c9xdonNHqduQ4Pxs17Ow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04BB38015F5
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 09:07:29 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A0676091B;
        Mon, 14 Jun 2021 09:07:24 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, pbonzini@redhat.com, thuth@redhat.com,
        lvivier@redhat.com, david@redhat.com
Subject: [PATCH kvm-unit-tests] generators: unify header guards
Date:   Mon, 14 Jun 2021 11:07:23 +0200
Message-Id: <20210614090723.30208-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 configure               | 4 ++--
 scripts/asm-offsets.mak | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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
diff --git a/scripts/asm-offsets.mak b/scripts/asm-offsets.mak
index 7b64162dd2e1..2b9be2b439f4 100644
--- a/scripts/asm-offsets.mak
+++ b/scripts/asm-offsets.mak
@@ -17,8 +17,8 @@ endef
 
 define make_asm_offsets
 	(set -e; \
-	 echo "#ifndef __ASM_OFFSETS_H__"; \
-	 echo "#define __ASM_OFFSETS_H__"; \
+	 echo "#ifndef _ASM_OFFSETS_H_"; \
+	 echo "#define _ASM_OFFSETS_H_"; \
 	 echo "/*"; \
 	 echo " * Generated file. DO NOT MODIFY."; \
 	 echo " *"; \
-- 
2.31.1


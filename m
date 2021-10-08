Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA3426503
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 09:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhJHHFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 03:05:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhJHHFR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 03:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633676601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pPLO33osu52Cghfcg7vtxGHH5a1T8FRAcUsdEFz4W74=;
        b=ckmHQqHWZotgWkuoBVvGJ9kWxJr8dsEsE9wM+4KkkomdkgtJCpA+uDBHn2BL8pa7Z1eCyl
        MZ+Xt+pkoaqMnwsGU7AF37HsQqDH1KUYyy2jqSHpEqpPN/0jCd5+wIDgG+wGxvvak0v3O3
        Ri2ui5JK/RlQdXs3c65O00r0IFHUUOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-MtTjmlWJNWmHrdDYAO9c4g-1; Fri, 08 Oct 2021 03:03:13 -0400
X-MC-Unique: MtTjmlWJNWmHrdDYAO9c4g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD761800480;
        Fri,  8 Oct 2021 07:03:12 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8248C5C1A3;
        Fri,  8 Oct 2021 07:03:10 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, ricarkol@google.com
Subject: [PATCH kvm-unit-tests] parse_keyval: Allow hex vals
Date:   Fri,  8 Oct 2021 09:03:09 +0200
Message-Id: <20211008070309.84205-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When parse_keyval was first written we didn't yet have strtol.
Now we do, let's give users more flexibility.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/util.c b/lib/util.c
index a90554138952..682ca2db09e6 100644
--- a/lib/util.c
+++ b/lib/util.c
@@ -4,6 +4,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <stdlib.h>
 #include "util.h"
 
 int parse_keyval(char *s, long *val)
@@ -14,6 +15,6 @@ int parse_keyval(char *s, long *val)
 	if (!p)
 		return -1;
 
-	*val = atol(p+1);
+	*val = strtol(p+1, NULL, 0);
 	return p - s;
 }
-- 
2.31.1


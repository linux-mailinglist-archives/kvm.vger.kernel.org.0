Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2F6424E09
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 09:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbhJGHXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 03:23:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240389AbhJGHXp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 03:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633591311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CEWfT541yvpdoTle3msvvY0MkDFHBHqsvEkcHBGFiKY=;
        b=jDDr+njqBvlPWEBdO3JzMdLAjnMs7YlxfhbStJZMC8fdN4EXu5dunnss2Fm9ES86b6/BMc
        d9CUXMa5oSgNJp3qfTm2+czXoXQMFpPULUqxXZuqdLxGbitVkKX9YUiIKO55BlqyyqUd2h
        0z+fwLLK+wrdIiKmcRX4lzi7t6am4L0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-aX2JSNUANEydWENWnB5JjA-1; Thu, 07 Oct 2021 03:21:50 -0400
X-MC-Unique: aX2JSNUANEydWENWnB5JjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 873E1835DE0;
        Thu,  7 Oct 2021 07:21:49 +0000 (UTC)
Received: from thuth.com (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3CD810013D7;
        Thu,  7 Oct 2021 07:21:37 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH] s390x/mvpg-sie: Remove unused variable
Date:   Thu,  7 Oct 2021 09:21:36 +0200
Message-Id: <20211007072136.768459-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest_instr variable is not used, which was likely a
copy-n-paste issue from the s390x/sie.c test.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/mvpg-sie.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index ccc273b..5adcec1 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -21,7 +21,6 @@
 #include <sie.h>
 
 static u8 *guest;
-static u8 *guest_instr;
 static struct vm vm;
 
 static uint8_t *src;
@@ -94,8 +93,6 @@ static void setup_guest(void)
 
 	/* Allocate 1MB as guest memory */
 	guest = alloc_pages(8);
-	/* The first two pages are the lowcore */
-	guest_instr = guest + PAGE_SIZE * 2;
 
 	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
 
-- 
2.27.0


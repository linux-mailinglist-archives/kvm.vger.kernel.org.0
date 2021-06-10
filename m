Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD193A2D9F
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhFJOBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:01:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhFJOBq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623333590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fx4P1AWcI/t4nEynqEC+OGfVQRnoQFxSkbz5Bk3lO2c=;
        b=NAtOYdj81c9Y3xAINdReUryNPpEkEYrrv2gOsaWomkK+iJmQ6P+teXnHLg3uC8q89PmvgM
        pLWYZRtZP4VVBnPwN2L3L2zENSrvnGfeNxBatDcOqHGwzQOP4Mh0e/wWTN2eFN3fsNn9s9
        3cJhV4k3czt5i71+tGW9zgUBtdj/CaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-Y8cDpc9yOja_cRezyBrgPA-1; Thu, 10 Jun 2021 09:59:48 -0400
X-MC-Unique: Y8cDpc9yOja_cRezyBrgPA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B9A580364C
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 13:59:47 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-107.ams2.redhat.com [10.36.113.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29973100238C;
        Thu, 10 Jun 2021 13:59:43 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 2/2] add header guards for non-trivial headers
Date:   Thu, 10 Jun 2021 15:59:37 +0200
Message-Id: <20210610135937.94375-3-cohuck@redhat.com>
In-Reply-To: <20210610135937.94375-1-cohuck@redhat.com>
References: <20210610135937.94375-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add header guards to headers that do not simply include another one.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/argv.h       | 5 +++++
 lib/arm/io.h     | 5 +++++
 lib/powerpc/io.h | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/lib/argv.h b/lib/argv.h
index e5fcf8482ca8..1fd746dc2177 100644
--- a/lib/argv.h
+++ b/lib/argv.h
@@ -5,7 +5,12 @@
  * under the terms of the GNU Library General Public License version 2.
  */
 
+#ifndef _ARGV_H_
+#define _ARGV_H_
+
 extern void __setup_args(void);
 extern void setup_args_progname(const char *args);
 extern void setup_env(char *env, int size);
 extern void add_setup_arg(const char *arg);
+
+#endif
diff --git a/lib/arm/io.h b/lib/arm/io.h
index 2746d72e8280..183479c899a9 100644
--- a/lib/arm/io.h
+++ b/lib/arm/io.h
@@ -4,4 +4,9 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
+#ifndef _ARM_IO_H_
+#define _ARM_IO_H_
+
 extern void io_init(void);
+
+#endif
diff --git a/lib/powerpc/io.h b/lib/powerpc/io.h
index 1f5a7bd6d745..d4f21ba15a54 100644
--- a/lib/powerpc/io.h
+++ b/lib/powerpc/io.h
@@ -4,5 +4,10 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
+#ifndef _POWERPC_IO_H_
+#define _POWERPC_IO_H_
+
 extern void io_init(void);
 extern void putchar(int c);
+
+#endif
-- 
2.31.1


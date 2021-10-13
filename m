Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE2142C6A2
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhJMQp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:45:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233970AbhJMQp1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 12:45:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634143403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lz5CDg9arb0najgULW+/M6DTv6d0yEOGyraH8ND3vfQ=;
        b=EtdPM/l/tWjkU3LNZNhg4tszPPDBsdYesnZLByJ7S93dMvKSzzsmRaHP/lnoIc3baAs+AN
        EidsNoGkm6JO/siQGLIKt2bjWx2sbH4MHUMEqIwQ+/ZjwEfI8b860DldFwAonwXtPelhGK
        TEsIGBuUQvsniKBfV8Uw3VXm9on3f8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-PKMxXLqsNcayWrjdHveGgA-1; Wed, 13 Oct 2021 12:43:20 -0400
X-MC-Unique: PKMxXLqsNcayWrjdHveGgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D9F579EE0;
        Wed, 13 Oct 2021 16:43:19 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2FA65DF35;
        Wed, 13 Oct 2021 16:43:02 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, ahmeddan@amazon.com
Subject: [PATCH kvm-unit-tests 1/2] compiler.h: Fix typos in mul and sub overflow checks
Date:   Wed, 13 Oct 2021 18:42:58 +0200
Message-Id: <20211013164259.88281-2-drjones@redhat.com>
In-Reply-To: <20211013164259.88281-1-drjones@redhat.com>
References: <20211013164259.88281-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: 4ceb02bf68f0 ("compiler: Add builtin overflow flag and predicate wrappers")
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/linux/compiler.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index c7fc0cf0852e..6f565e4a5107 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -33,8 +33,8 @@
 #elif GCC_VERSION >= 70100
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #define check_add_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) + (b)))0)
-#define check_sub_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) - (b)))0)
-#define check_mul_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) * (b)))0)
+#define check_sub_overflow(a, b) __builtin_sub_overflow_p(a, b, (typeof((a) - (b)))0)
+#define check_mul_overflow(a, b) __builtin_mul_overflow_p(a, b, (typeof((a) * (b)))0)
 #else
 #define check_add_overflow(a, b) ({ (void)((int)(a) == (int)(b)); 0; })
 #define check_sub_overflow(a, b) ({ (void)((int)(a) == (int)(b)); 0; })
-- 
2.31.1


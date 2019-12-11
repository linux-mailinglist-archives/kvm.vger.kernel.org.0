Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE9511A7A2
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 10:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfLKJmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 04:42:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25231 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727888AbfLKJmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 04:42:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576057351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r9bnY0jHRcMWSnryCKwgblqBO5XHvZ1/TSPstgKyozo=;
        b=Voj3TF2IG1Pqe6gaYmK2aVi4cyPmBSpU9vEcgWtfdX1f7fTtFOuAzLy0oMtXciggrV2+/d
        yyRP4EjGGfYzicxdTCH+1ZUXKNI2BVb1sJTaoXJgbFBQNedzzQQat9vQ6QNz8sUHkDmVcL
        VUThAKT4Wll2k26fG7Lz932O2qPcwcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-0b-UkEbQOGW9renaceHYrQ-1; Wed, 11 Dec 2019 04:42:29 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D737A107BAA9
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 09:42:28 +0000 (UTC)
Received: from thuth.com (ovpn-117-11.ams2.redhat.com [10.36.117.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAA0963629;
        Wed, 11 Dec 2019 09:42:27 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 2/4] x86: Fix coding style in setjmp.c
Date:   Wed, 11 Dec 2019 10:42:19 +0100
Message-Id: <20191211094221.7030-3-thuth@redhat.com>
In-Reply-To: <20191211094221.7030-1-thuth@redhat.com>
References: <20191211094221.7030-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 0b-UkEbQOGW9renaceHYrQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change, just use tabs for indentation.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/setjmp.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/x86/setjmp.c b/x86/setjmp.c
index 1874944..1a848b4 100644
--- a/x86/setjmp.c
+++ b/x86/setjmp.c
@@ -9,18 +9,18 @@ static const int expected[] =3D {
=20
 int main(void)
 {
-    volatile int index =3D 0;
-    jmp_buf j;
-    int i;
+=09volatile int index =3D 0;
+=09jmp_buf j;
+=09int i;
=20
-    i =3D setjmp(j);
-    if (expected[index] !=3D i) {
-=09    printf("FAIL: actual %d / expected %d\n", i, expected[index]);
-=09    return -1;
-    }
-    index++;
-    if (i + 1 < NUM_LONGJMPS)
-=09    longjmp(j, i + 1);
+=09i =3D setjmp(j);
+=09if (expected[index] !=3D i) {
+=09=09printf("FAIL: actual %d / expected %d\n", i, expected[index]);
+=09=09return -1;
+=09}
+=09index++;
+=09if (i + 1 < NUM_LONGJMPS)
+=09=09longjmp(j, i + 1);
=20
-    return 0;
+=09return 0;
 }
--=20
2.18.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CDB27814A
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 09:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgIYHLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 03:11:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28408 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbgIYHLx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 03:11:53 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601017913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=httEJJ6m33HzqvzspuI8t33ctSQx1l0sZsHnr2kz/So=;
        b=Ajh01co4cOfBVOoLCqrkWnfmc2qjbif33+664/jcjX4bGfr49YoJnsj1SiPiyKKZIpfkGS
        E9Qmxgd+LgN0Lneq9Qq6K7/rOOv3+SlqJtiRZx15NrGscIT6VUz/nUOnrrvqya1DzheHzH
        JzQ++Gpyw1CWyJTw4I28iwXARu/Vo6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-zGktOluDMNyhYgkcZDV1WQ-1; Fri, 25 Sep 2020 03:11:50 -0400
X-MC-Unique: zGktOluDMNyhYgkcZDV1WQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1709910060C3
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 07:11:50 +0000 (UTC)
Received: from thuth.com (ovpn-112-251.ams2.redhat.com [10.36.112.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C0994061;
        Fri, 25 Sep 2020 07:11:49 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] travis.yml: Use TRAVIS_BUILD_DIR to refer to the top directory
Date:   Fri, 25 Sep 2020 09:11:47 +0200
Message-Id: <20200925071147.149406-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Travis already has an environment variable that points to the top of
the checked-out source code, TRAVIS_BUILD_DIR. We can use it to avoid
the guessing of the right location of the configure script.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 3bc05ce..e9c18e4 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -175,8 +175,7 @@ before_script:
       sudo chmod g+s /usr/bin/qemu-system-* ;
     fi
   - mkdir -p $BUILD_DIR && cd $BUILD_DIR
-  - if [ -e ./configure ]; then ./configure $CONFIG ; fi
-  - if [ -e ../configure ]; then ../configure $CONFIG ; fi
+  - $TRAVIS_BUILD_DIR/configure $CONFIG
 script:
   - make -j3
   - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
-- 
2.18.2


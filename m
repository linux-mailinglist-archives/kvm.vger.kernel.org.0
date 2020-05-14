Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1FF1D3D6C
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgENT1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:27:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728045AbgENT1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 15:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=o8rnt7e+9Gl0UnGQXfhXtKLH9lAy/5fTqs/wBF1Q9Qc=;
        b=NBqV5qOaF7Mdb/RW1EosrX/huJOO6195E/G2kuCRbIw2oXH8RK4gPiMRciScOqfMtMQpha
        m+PxBub1v5LGZ7uQuFunfWL42Pu7DkNUqRsFgMa7t/dr4ThKr0aMRfiNSrENc4/ruPgMhh
        g4zyHq/TjY6U21gK0EZ9YEwTbQmY7YE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-q8n0D7eGMPenzTiQo3AX_w-1; Thu, 14 May 2020 15:27:03 -0400
X-MC-Unique: q8n0D7eGMPenzTiQo3AX_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9C0318FF661;
        Thu, 14 May 2020 19:27:02 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF3755C1BE;
        Thu, 14 May 2020 19:26:57 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 07/11] Update the gitlab-ci to Fedora 32
Date:   Thu, 14 May 2020 21:26:22 +0200
Message-Id: <20200514192626.9950-8-thuth@redhat.com>
In-Reply-To: <20200514192626.9950-1-thuth@redhat.com>
References: <20200514192626.9950-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fedora 30 is end of life, let's use the version 32 instead.

Unfortunately, we have to disable taskswitch2 in the gitlab-ci now.
It does not seem to work anymore with the latest version of gcc and/or
QEMU. We still check it in the travis-ci, though, so until somebody has
some spare time to debug this issue, it should be ok to disable it here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 3093239..13e1a1f 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -1,4 +1,4 @@
-image: fedora:30
+image: fedora:32
 
 before_script:
  - dnf update -y
@@ -77,6 +77,6 @@ build-i386:
  - ./configure --arch=i386
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     cmpxchg8b eventinj port80 setjmp sieve tsc taskswitch taskswitch2 umip
+     cmpxchg8b eventinj port80 setjmp sieve tsc taskswitch umip
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
-- 
2.18.1


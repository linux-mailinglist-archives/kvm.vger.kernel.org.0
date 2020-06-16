Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EC21FBE98
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 20:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbgFPS4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 14:56:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730341AbgFPS4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 14:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592333795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=dp12gYHNFVGYlFsmwoQZhifxQecCGX/Lk1TlV4n+QT8=;
        b=UbkX4EU5sPPgI5RWcUGTHvw8jXpBaz85tzYk1Zqy1IgZCoPYxzUf0XWmEK9V92GvVA5tuo
        8z1hSueDm1S/MlP5LAh1Rb/hyEcJDOayLINpXDwMVNK0iZ2oSTdTetw6VA1T+Yfr0qAlFk
        AV43JtzuqwdAvKzropomBWwP1vnSNN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-XgicGo-6OGqHMAgYb8Ot0Q-1; Tue, 16 Jun 2020 14:56:33 -0400
X-MC-Unique: XgicGo-6OGqHMAgYb8Ot0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03EE210059C7
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 18:56:33 +0000 (UTC)
Received: from thuth.com (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BA917CAA8;
        Tue, 16 Jun 2020 18:56:31 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PULL 06/12] Update the gitlab-ci to Fedora 32
Date:   Tue, 16 Jun 2020 20:56:16 +0200
Message-Id: <20200616185622.8644-7-thuth@redhat.com>
In-Reply-To: <20200616185622.8644-1-thuth@redhat.com>
References: <20200616185622.8644-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fedora 30 is end of life, let's use the version 32 instead.

Unfortunately, we have to disable taskswitch2 in the gitlab-ci now.
It does not seem to work anymore with the latest version of gcc and/or
QEMU. We still check it in the travis-ci, though, so until somebody has
some spare time to debug this issue, it should be ok to disable it here.

Message-Id: <20200514192626.9950-8-thuth@redhat.com>
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


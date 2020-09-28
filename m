Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C99027B3A1
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgI1RuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbgI1RuU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:20 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=ScRS1N9ncw9iH/y+t8MQfMg5kqk17o/Y7KYIPkdo1yw=;
        b=fQQ8kRBXAUNiGQNpQ6VkMmcWRSYawTW601oH7sV5ny3lNH+7EjdaEhZKLPvQ50l2hwdWI9
        UHZkjK0q/tgkFkgjhi0hUzBEjsruh+CLR11AwZ/SQOoNz1904sCr3e7+6ly5Bj4T1bUbez
        J1Up9qLVhptF74hcWnY2uRU8furZMv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-voasKWDDP32khQQM8Z5vPg-1; Mon, 28 Sep 2020 13:50:13 -0400
X-MC-Unique: voasKWDDP32khQQM8Z5vPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A73931019626;
        Mon, 28 Sep 2020 17:50:12 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EB88100238C;
        Mon, 28 Sep 2020 17:50:10 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 05/11] travis.yml: Update the list of s390x tests
Date:   Mon, 28 Sep 2020 19:49:52 +0200
Message-Id: <20200928174958.26690-6-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the new QEMU from Ubuntu Focal, we can now run more tests with TCG.

Message-Id: <20200924161612.144549-10-thuth@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 4b7947c..ef3cc40 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -106,7 +106,8 @@ jobs:
       env:
       - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
       - BUILD_DIR="."
-      - TESTS="diag10 diag308"
+      - TESTS="cpumodel css diag10 diag288 diag308 emulator intercept sclp-1g
+          sclp-3g selftest-setup"
       - ACCEL="tcg,firmware=s390x/run"
 
     - addons:
@@ -114,7 +115,7 @@ jobs:
       env:
       - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
       - BUILD_DIR="s390x-builddir"
-      - TESTS="sieve"
+      - TESTS="sieve skey stsi vector"
       - ACCEL="tcg,firmware=s390x/run"
 
     - os: osx
-- 
2.18.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7CB27766E
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgIXQQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:16:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727109AbgIXQQ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 12:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600964218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=ESECcfgdi0HGJSXdiCODCNQ551VCvweWVqN1MQQXij8=;
        b=WL5PFyL0U2nahzqCxhXBKiKQ7RdGQbdqJo4REU44xsJSnG0DE86EB41D75fph4LuTa56nN
        O8oJJDXv0jsp6IkqpSY2+rTw2Roee4iTGWzr9utCN4Ek5wLSDgKorNrF4pPJFZUWxZdVOZ
        mKWGOV3+8Jn4FN462kEKxgJOJBeVjlU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-buxI-sCSMjKnOv96vtFMSw-1; Thu, 24 Sep 2020 12:16:56 -0400
X-MC-Unique: buxI-sCSMjKnOv96vtFMSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECC0D84E247;
        Thu, 24 Sep 2020 16:16:54 +0000 (UTC)
Received: from thuth.com (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6927473662;
        Thu, 24 Sep 2020 16:16:53 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH 9/9] travis.yml: Update the list of s390x tests
Date:   Thu, 24 Sep 2020 18:16:12 +0200
Message-Id: <20200924161612.144549-10-thuth@redhat.com>
In-Reply-To: <20200924161612.144549-1-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the new QEMU from Ubuntu Focal, we can now run more tests with TCG.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index f1bcf3d..6080326 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -116,7 +116,8 @@ jobs:
       env:
       - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
       - BUILD_DIR="."
-      - TESTS="diag10 diag308"
+      - TESTS="cpumodel css diag10 diag288 diag308 emulator intercept sclp-1g
+          sclp-3g selftest-setup"
       - ACCEL="tcg,firmware=s390x/run"
 
     - addons:
@@ -124,7 +125,7 @@ jobs:
       env:
       - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
       - BUILD_DIR="s390x-builddir"
-      - TESTS="sieve"
+      - TESTS="sieve skey stsi vector"
       - ACCEL="tcg,firmware=s390x/run"
 
     - os: osx
-- 
2.18.2


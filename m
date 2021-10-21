Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F8D436A7C
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 20:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhJUSXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 14:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhJUSXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 14:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634840484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l4m3WcWHUtM5Urr2MWyF4Icu0vJU9JZbOsjpTINFYOs=;
        b=DBFnTafomi6Na7LCYUivM9jvFZzPzDnwQni/6nhkO1DWf+OrYqFanRJ3QEXvs+7iSi8GVY
        zwFRNINCRfXqN7CRQicLMeKj0nFAtpfrUhwdaPoiHHBJx3Vtj5przbL8u8YDdRg2xLmkid
        s5Tiza0f2Eb449CkNSOmHx7xTQMaehU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-5GKDeLKZNveqiRSozPMvSA-1; Thu, 21 Oct 2021 14:21:21 -0400
X-MC-Unique: 5GKDeLKZNveqiRSozPMvSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FEF11006AA3;
        Thu, 21 Oct 2021 18:21:20 +0000 (UTC)
Received: from thuth.com (unknown [10.40.195.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E2275D740;
        Thu, 21 Oct 2021 18:21:18 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] gitlab-ci: Disable the s390x storage key test (which fails now with TCG)
Date:   Thu, 21 Oct 2021 20:21:13 +0200
Message-Id: <20211021182113.818393-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 429c9cc ("s390x: skey: Test for ADDRESSING exceptions") added
some new tests which require the latest and greatest QEMU, which is
not available in the distros yet, so the skey test is currently failing
in the CI. Disable it for the time being, we'll switch it on again once
the distros feature a QEMU with the bug fix.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 943b20f..4f3049d 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -62,7 +62,7 @@ build-s390x:
  - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
+     selftest-setup intercept emulator sieve diag10 diag308 vector diag288
      stsi sclp-1g sclp-3g
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
-- 
2.27.0


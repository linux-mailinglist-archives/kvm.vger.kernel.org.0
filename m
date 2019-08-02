Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2857ED5C
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389534AbfHBHXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:23:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389520AbfHBHXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:23:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6454D30EA185;
        Fri,  2 Aug 2019 07:23:39 +0000 (UTC)
Received: from thuth.com (dhcp-200-228.str.redhat.com [10.33.200.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30D0460925;
        Fri,  2 Aug 2019 07:23:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [kvm-unit-tests PULL 2/2] Force GCC version to 8.2 for compiling the ARM tests
Date:   Fri,  2 Aug 2019 09:23:29 +0200
Message-Id: <20190802072329.8276-3-thuth@redhat.com>
In-Reply-To: <20190802072329.8276-1-thuth@redhat.com>
References: <20190802072329.8276-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 02 Aug 2019 07:23:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm-unit-tests are currently completely failing with GCC 9.1.
So let's use GCC 8.2 again for compiling the ARM tests to fix
the CI pipelines on gitlab.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index a9dc16a..fbf3328 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -17,7 +17,7 @@ build-aarch64:
 
 build-arm:
  script:
- - dnf install -y qemu-system-arm gcc-arm-linux-gnu
+ - dnf install -y qemu-system-arm gcc-arm-linux-gnu-8.2.1-1.fc30.2
  - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-- 
2.21.0


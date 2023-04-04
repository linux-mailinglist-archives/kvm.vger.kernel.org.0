Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AF26D619D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbjDDMwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbjDDMwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:52:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA66E65
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680612670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F2tN8tAjTFZ5s9KI/an14rHKg5TjTf+rsD07Q4LSCCw=;
        b=TgmJDHEF6eRUVyvjnE/lQfhSIrfEmvr5c+dQ626o/jzSs9vRmCZjVffoBIwPukABpj3YiB
        B2mSxgJExdPnakI/f5Br3NxWFt1CTUee3LFKWY/aIVyrQX+gUkNoB8jCN/N4gSdoyHprKS
        pdIuoHy/P31PD5shbLHyABaEkW7gXJ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-759CEE5ZNmGz_Lgtzk3OPw-1; Tue, 04 Apr 2023 08:51:07 -0400
X-MC-Unique: 759CEE5ZNmGz_Lgtzk3OPw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D753585A588;
        Tue,  4 Apr 2023 12:51:06 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F26B400F57;
        Tue,  4 Apr 2023 12:51:05 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] MAINTAINERS: Add a catch-all entry for the kvm mailing list
Date:   Tue,  4 Apr 2023 14:51:03 +0200
Message-Id: <20230404125103.200027-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The scripts/get_maintainer.pl currently fails to suggest sending
patches to kvm@vger.kernel.org if a patch only touches files that
are not part of any target specific code (e.g. files in the script
folder). All patches should be CC:-ed to the kvm list, so we should
have an entry here that covers all files.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 MAINTAINERS | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 649de509..cb198ed7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -51,14 +51,25 @@ Descriptions of section entries:
 	   One regex pattern per line.  Multiple K: lines acceptable.
 
 
-Maintainers
------------
+General Project Administration
+------------------------------
+
+Project administration
 M: Paolo Bonzini <pbonzini@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
 M: Andrew Jones <andrew.jones@linux.dev>
 S: Supported
 L: kvm@vger.kernel.org
 T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
+F: COPYRIGHT
+F: LICENSE
+F: MAINTAINERS
+F: README.md
+
+Default mailing list
+L: kvm@vger.kernel.org
+F: *
+F: */
 
 Architecture Specific Code:
 ---------------------------
@@ -66,7 +77,6 @@ Architecture Specific Code:
 ARM
 M: Andrew Jones <andrew.jones@linux.dev>
 S: Supported
-L: kvm@vger.kernel.org
 L: kvmarm@lists.linux.dev
 L: kvmarm@lists.cs.columbia.edu (deprecated)
 F: arm/
@@ -78,7 +88,6 @@ POWERPC
 M: Laurent Vivier <lvivier@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
 S: Maintained
-L: kvm@vger.kernel.org
 L: kvm-ppc@vger.kernel.org
 F: powerpc/
 F: lib/powerpc/
@@ -90,7 +99,6 @@ M: Janosch Frank <frankja@linux.ibm.com>
 M: Claudio Imbrenda <imbrenda@linux.ibm.com>
 S: Supported
 R: David Hildenbrand <david@redhat.com>
-L: kvm@vger.kernel.org
 L: linux-s390@vger.kernel.org
 F: s390x/
 F: lib/s390x/
@@ -98,7 +106,6 @@ F: lib/s390x/
 X86
 M: Paolo Bonzini <pbonzini@redhat.com>
 S: Supported
-L: kvm@vger.kernel.org
 F: x86/
 F: lib/x86/
 T: https://gitlab.com/bonzini/kvm-unit-tests.git
-- 
2.31.1


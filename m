Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEC5557C8E
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 15:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiFWNKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 09:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiFWNK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 09:10:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAD052E9DC
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 06:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655989825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rmoM2sqrNH4gB4OMADyCrtt+JYV77lbslouxb07UaD0=;
        b=ZOv9Z+CamERy+09igdSDh8FrfwnlgW7YgEWF3MROYaaIf55Eunupitv3JbbEU+Ow0T+wZx
        St6iimL5PjE+z1fNmxu7NEG+OG3MvC4zgn9y7PiyBg/ZyqY6sLbyZoGeCE3tvc17/B8Jhi
        5e57xREOPI1ocsIHSKOxDYg1lXSSLUs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-l24YVwCaORSxh1PyRf7X7Q-1; Thu, 23 Jun 2022 09:10:22 -0400
X-MC-Unique: l24YVwCaORSxh1PyRf7X7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9A538032F6;
        Thu, 23 Jun 2022 13:10:21 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.193.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58C5940CF8EE;
        Thu, 23 Jun 2022 13:10:18 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com,
        thuth@redhat.com, alexandru.elisei@arm.com, alex.bennee@linaro.org,
        andre.przywara@arm.com, nikos.nikoleris@arm.com,
        ricarkol@google.com, seanjc@google.com, maz@kernel.org,
        peter.maydell@linaro.org
Subject: [PATCH kvm-unit-tests] MAINTAINERS: Change drew's email address
Date:   Thu, 23 Jun 2022 15:10:17 +0200
Message-Id: <20220623131017.670589-1-drjones@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a side effect of leaving Red Hat I won't be able to use my Red Hat
email address anymore. I'm also changing the name of my gitlab group.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bab08e740332..5e4c7bd70786 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -55,7 +55,7 @@ Maintainers
 -----------
 M: Paolo Bonzini <pbonzini@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
-M: Andrew Jones <drjones@redhat.com>
+M: Andrew Jones <andrew.jones@linux.dev>
 S: Supported
 L: kvm@vger.kernel.org
 T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
@@ -64,14 +64,14 @@ Architecture Specific Code:
 ---------------------------
 
 ARM
-M: Andrew Jones <drjones@redhat.com>
+M: Andrew Jones <andrew.jones@linux.dev>
 S: Supported
 L: kvm@vger.kernel.org
 L: kvmarm@lists.cs.columbia.edu
 F: arm/
 F: lib/arm/
 F: lib/arm64/
-T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
+T: https://gitlab.com/drew-jones/kvm-unit-tests.git
 
 POWERPC
 M: Laurent Vivier <lvivier@redhat.com>
-- 
2.34.3


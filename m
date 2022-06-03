Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E7653C92A
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 13:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238698AbiFCLOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 07:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiFCLOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 07:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BB0262E6
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 04:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654254842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=X2qi3uRsXFXrO710cW8bFVUywdhnyLrzntXAAfD8Q00=;
        b=eL2IoSxxqxsRR4S6EEDI+cfvaectm1iJZkk2hblm03xVQSGXGZV1lT05d/C5/zhcBCkAD7
        tDtY8/LBn+ghdtwskURgIWQKRqgF/86p8h8dBLgGjDozBB+nUZv6ZFiDgymtISXXKaEhAI
        7hiVd0FjoFrkO7b10JvBP/GYTFXQG7A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-jfQeBgHOO_q-xvSrci5lVQ-1; Fri, 03 Jun 2022 07:13:59 -0400
X-MC-Unique: jfQeBgHOO_q-xvSrci5lVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA82E280694E;
        Fri,  3 Jun 2022 11:13:58 +0000 (UTC)
Received: from gator.home (unknown [10.40.194.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9043D40CFD0A;
        Fri,  3 Jun 2022 11:13:57 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, alex.bennee@linaro.org
Subject: [PATCH kvm-unit-tests] arm64: TCG: Use max cpu type
Date:   Fri,  3 Jun 2022 13:13:56 +0200
Message-Id: <20220603111356.1480720-1-drjones@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The max cpu type is a better default cpu type for running tests
with TCG as it provides the maximum possible feature set. Also,
the max cpu type was introduced in QEMU v2.12, so we should be
safe to switch to it at this point.

There's also a 32-bit arm max cpu type, but we leave the default
as cortex-a15, because compilation requires we specify for which
processor we want to compile and there's no such thing as a 'max'.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 5b7daac3c6e8..1474dde2c70d 100755
--- a/configure
+++ b/configure
@@ -223,7 +223,7 @@ fi
 [ -z "$processor" ] && processor="$arch"
 
 if [ "$processor" = "arm64" ]; then
-    processor="cortex-a57"
+    processor="max"
 elif [ "$processor" = "arm" ]; then
     processor="cortex-a15"
 fi
-- 
2.34.3


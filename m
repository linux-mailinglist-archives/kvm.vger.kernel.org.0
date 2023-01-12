Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2047E6678A4
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240301AbjALPKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjALPKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:10:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2F16B5A6
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 06:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673535437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ige2YCGcW1rQeDBN8vG8IVxq5dR7qXsw3XV5Oj0aB8Y=;
        b=QhlvkjvOBjlRYp7zykKQ3MV69ETDYZwBvfYT2f9KjczVrIk7oSN42TT39nF9ujF2duZt8r
        boh3/a59CLp0Swnp/bF6b6YHAHWqapSqs2ibGeVwMtQN6fQ31evUORC2jFFaWJ3caO4fWF
        UXUllw76fDdDitxrXcESUy09r8Xn8xc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-rJr2GHgjP4KHbPCLUPp3tQ-1; Thu, 12 Jan 2023 09:57:16 -0500
X-MC-Unique: rJr2GHgjP4KHbPCLUPp3tQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 779EE296A608
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 14:57:16 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.194.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A386CC15BAD;
        Thu, 12 Jan 2023 14:57:15 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] MAINTAINERS: step down as vfio reviewer
Date:   Thu, 12 Jan 2023 15:57:07 +0100
Message-Id: <20230112145707.27941-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As my focus has shifted in recent months, my involvement with vfio has
decreased to occasionally reviewing some simpler patches, which is
probably less than you'd expect when you cc: someone for review.

Given that I currently don't have spare time to invest in looking at
vfio things, let's adjust the entry to match reality.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e278cd5d0de0..d1a1b30a3043 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21836,7 +21836,6 @@ F:	tools/testing/selftests/filesystems/fat/
 
 VFIO DRIVER
 M:	Alex Williamson <alex.williamson@redhat.com>
-R:	Cornelia Huck <cohuck@redhat.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git https://github.com/awilliam/linux-vfio.git
-- 
2.39.0


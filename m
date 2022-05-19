Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF32152DAEF
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 19:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242357AbiESRHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 13:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242362AbiESRHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 13:07:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFFBB4AE03
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 10:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652980048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cA8XpCgqR2HZDo3bjXS1Wce9SGgWko9yR1mE848KakA=;
        b=bUt5NudqrA0IxmqUw7q5P1qvjOyO2sPN0sHf8DKH5QJ3cV/k8Q0Bf7nHyOzfBMbblIfyUX
        dVC26MVUCl2quz9+shKJxF+tyu7i+HXbS3MziPJpdnjzUs9h1YBI9apUphEEUwlDQWpTid
        LeYPtdEWxI27gwcHwkuiBIu64CArG0I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-VA0p-dqQOQ-ikWy2Q6znhQ-1; Thu, 19 May 2022 13:07:27 -0400
X-MC-Unique: VA0p-dqQOQ-ikWy2Q6znhQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2140385A5AA;
        Thu, 19 May 2022 17:07:27 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B21AC2026E03;
        Thu, 19 May 2022 17:07:25 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, nikos.nikoleris@arm.com
Subject: [PATCH kvm-unit-tests 0/2] lib: Cleanups
Date:   Thu, 19 May 2022 19:07:22 +0200
Message-Id: <20220519170724.580956-1-drjones@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

1) Finally, finally, finally reformat printf.c and string.c, the last
   two files that had weird formatting.

2) Collect is* ctype functions into a new lib/ctype.h file.

Andrew Jones (2):
  lib: Fix whitespace
  lib: Add ctype.h and collect is* functions

 lib/argv.c   |   7 +-
 lib/ctype.h  |  40 +++++
 lib/printf.c | 427 +++++++++++++++++++++++++--------------------------
 lib/string.c | 356 +++++++++++++++++++++---------------------
 4 files changed, 431 insertions(+), 399 deletions(-)
 create mode 100644 lib/ctype.h

-- 
2.34.3


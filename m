Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BF852ED05
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiETNYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiETNYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:24:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A3D914916C
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653053048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aUYOoamDS6UnpmWoOZyVZqh/OUFS1KjTCC6uHfGXUFw=;
        b=NqLdV22RWOy5R4jmayLiM3Al8Wg9830oO+n9iiGcxe7YSzHXsz4AX1tnt13eUhEZ953Gdk
        U42D2TRK9/f5jeB/wpf2aCtmNalK3wZz05nMiqT6/bQ6b+wpCK89G15UyUw0bYe8bEDoTv
        hvhcni9mZMvMYXivsrmG2Mn77xFkGbw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-lh6mZjLGPzSCxGGyhNkKtA-1; Fri, 20 May 2022 09:24:06 -0400
X-MC-Unique: lh6mZjLGPzSCxGGyhNkKtA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 983443810D38;
        Fri, 20 May 2022 13:24:06 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23A6540D2820;
        Fri, 20 May 2022 13:24:04 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, nikos.nikoleris@arm.com
Subject: [PATCH kvm-unit-tests v2 0/2] lib: Cleanups
Date:   Fri, 20 May 2022 15:24:02 +0200
Message-Id: <20220520132404.700626-1-drjones@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2
--
  - remove a trailing whitespace [Nikos]
  - add Nikos' r-b's
  - add back a check for '_' in argv.c that got dropped

1) Finally, finally, finally reformat printf.c and string.c, the last
   two files that had weird formatting.

2) Collect is* ctype functions into a new lib/ctype.h file.

Andrew Jones (2):
  lib: Fix whitespace
  lib: Add ctype.h and collect is* functions

 lib/argv.c   |   9 +-
 lib/ctype.h  |  40 +++++
 lib/printf.c | 427 +++++++++++++++++++++++++--------------------------
 lib/string.c | 356 +++++++++++++++++++++---------------------
 4 files changed, 432 insertions(+), 400 deletions(-)
 create mode 100644 lib/ctype.h

-- 
2.34.3


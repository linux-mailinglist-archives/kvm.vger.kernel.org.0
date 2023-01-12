Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70057666ED8
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 10:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbjALJ73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 04:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbjALJ6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 04:58:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ED362E7
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 01:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673517328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3WUsYEK+WAIjZP0xZNYvtebHF2NnjyH4Auj2kySXzIc=;
        b=XmpGddwgTLqCYPNTPS5PJgbrBH2OZk80yM3MANOq761ARtVmuHc4S5+NO9h2zAK8DaPqHa
        2i4jLZ3UCWI60OFXEidLFgJogTOoLmW2T+OP2ibOEpZZ6PgKk43EVixWbVjDNJKBUr2i89
        fCu0xka6ah/Eive6tHO3X1oPxJ9+6Q0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-olaqUcvwOseGpoxGf0TFbw-1; Thu, 12 Jan 2023 04:55:26 -0500
X-MC-Unique: olaqUcvwOseGpoxGf0TFbw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD6A51991C40;
        Thu, 12 Jan 2023 09:55:25 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C9BC40C2005;
        Thu, 12 Jan 2023 09:55:25 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH] configure: Show the option in case it is not known
Date:   Thu, 12 Jan 2023 10:55:23 +0100
Message-Id: <20230112095523.938919-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When mis-typing one of the options of the configure script, it shows
you the list of valid options, but does not tell you which option was
wrong. Then it can take a while until you figured out where the typo is.
Let's help the user here a little bit by printing which option had not
been understood.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 configure | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/configure b/configure
index b81f2094..c36fd290 100755
--- a/configure
+++ b/configure
@@ -178,6 +178,8 @@ while [[ "$1" = -* ]]; do
 	    usage
 	    ;;
 	*)
+	    echo "Unknown option '$opt'"
+	    echo
 	    usage
 	    ;;
     esac
-- 
2.31.1


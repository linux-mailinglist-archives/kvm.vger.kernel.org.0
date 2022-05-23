Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C953167C
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiEWToE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiEWTg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:36:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49F57DE33F
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653333865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=InjuNukk5AWJl2Wwz5sSwlsD5KfOc4voU8ewp772j2k=;
        b=Yms0u5KtSYdsPXP8k8hN5x+7nPqGPROelrdJorDH3NSFxgLhj+ttnGqcjwL0eInPu8ju3E
        +juHTh+esRXuEKEHUZETtIfZUciS4a/+Qh3RCF5/4iVHvDj0PL4YygAW9e+79bTRqDykfp
        9L9gTqF5GRl6xM2sZYZE4SydNsRntlE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-vlreVST7O8GEWgS7BFZBbw-1; Mon, 23 May 2022 15:24:20 -0400
X-MC-Unique: vlreVST7O8GEWgS7BFZBbw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C37F811E78;
        Mon, 23 May 2022 19:24:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4634D492C3B;
        Mon, 23 May 2022 19:24:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH] s390/uv_uapi: depend on CONFIG_S390
Date:   Mon, 23 May 2022 15:24:20 -0400
Message-Id: <20220523192420.151184-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/s390/char/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
index ef8f41833c1a..108e8eb06249 100644
--- a/drivers/s390/char/Kconfig
+++ b/drivers/s390/char/Kconfig
@@ -103,6 +103,7 @@ config SCLP_OFB
 config S390_UV_UAPI
 	def_tristate m
 	prompt "Ultravisor userspace API"
+        depends on S390
 	help
 	  Selecting exposes parts of the UV interface to userspace
 	  by providing a misc character device at /dev/uv.
-- 
2.31.1


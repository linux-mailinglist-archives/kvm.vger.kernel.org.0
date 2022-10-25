Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B7960D14C
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 18:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiJYQH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 12:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJYQH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 12:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A8118499D
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 09:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666714075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5KspUNdpIMJ1oi73gHAhE34NL4Dzppd2Wwilq7mP6L8=;
        b=NvcTC61iqpXGy2+AhQpWLLJ9b4kq20C7zkVczavC5t5/9krFJ8yWuXviBUTWOu7gw1GRSj
        Udqk8sF6wij+YYXMKHeC/p47OtwUxHnQNLtPtCgLj51yphkKEP7kMMsLa51LM6wV2+S7p1
        W2zYhSr2C1xG96NVr9Tgq6UTXEWhv68=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-yzgsZNG4OMq5fO07-66Gqw-1; Tue, 25 Oct 2022 12:07:53 -0400
X-MC-Unique: yzgsZNG4OMq5fO07-66Gqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16775185A7A3;
        Tue, 25 Oct 2022 16:07:53 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.193.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9405410B235;
        Tue, 25 Oct 2022 16:07:37 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
Date:   Tue, 25 Oct 2022 18:07:30 +0200
Message-Id: <20221025160730.40846-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/arm64 development is moving to a new mailing list (see
https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
kvm-unit-tests should advertise the new list as well.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90ead214a75d..649de509a511 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -67,7 +67,8 @@ ARM
 M: Andrew Jones <andrew.jones@linux.dev>
 S: Supported
 L: kvm@vger.kernel.org
-L: kvmarm@lists.cs.columbia.edu
+L: kvmarm@lists.linux.dev
+L: kvmarm@lists.cs.columbia.edu (deprecated)
 F: arm/
 F: lib/arm/
 F: lib/arm64/
-- 
2.37.3


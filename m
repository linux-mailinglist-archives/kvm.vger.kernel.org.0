Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397E46A680C
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 08:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCAHUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 02:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCAHUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 02:20:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D2F20D3D
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 23:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677655167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9gte+UdZRbB1selX9b8PwG5UPjX8H5856UTwKQRAiBQ=;
        b=GJIya4J+kLaDGKxoqVgBYXGgsrocV3Aor7ghZKhdKxnkBKmylRDzBWqFvP2JFw85kyJqGt
        r/AzMTkxl+l+oeoQPziaYaFI/EEBENa+yP2jSnWrFqpnGlaF/5I+2jcLJzcp8osPDNKu0x
        DrYkdZgIbqfBcM/8HIy/TQRR9Wq6HwQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-rAl27tkgMeicRGncRPK1pw-1; Wed, 01 Mar 2023 02:19:24 -0500
X-MC-Unique: rAl27tkgMeicRGncRPK1pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 097653C0DDB8;
        Wed,  1 Mar 2023 07:19:23 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00A0018EC6;
        Wed,  1 Mar 2023 07:19:23 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        kvm@vger.kernel.org (open list:ARM)
Subject: [kvm-unit-tests] arm: Replace the obsolete qemu script
Date:   Wed,  1 Mar 2023 02:17:37 -0500
Message-Id: <20230301071737.43760-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The qemu script used to detect the testdev is obsoleted, replace it
with the modern way to detect if testdev exists.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/run | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arm/run b/arm/run
index 1284891..9800cfb 100755
--- a/arm/run
+++ b/arm/run
@@ -59,8 +59,7 @@ if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
 	exit 2
 fi
 
-if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
-		| grep backend > /dev/null; then
+if ! $qemu $M -chardev '?' 2>&1 | grep testdev > /dev/null; then
 	echo "$qemu doesn't support chr-testdev. Exiting."
 	exit 2
 fi
-- 
2.39.1


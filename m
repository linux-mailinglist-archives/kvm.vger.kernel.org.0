Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70E6233EE8
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 08:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731236AbgGaGJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 02:09:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28208 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731163AbgGaGJQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 02:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596175755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=xt0xwLPxB6x/Ia0P/cH9yWHtlLCZ5eOEcZLXWppsphM=;
        b=XjkTcV5ylu/BKodruIIpmnmFGGLm1BsKWV+Bb0oNKERyAkhL3QIPStNWgqC3q17GlxJQOY
        DJ9ekwk/QwFsSj7mJ09bXTn1GKSerKBDhkM+azbjgFwPRAD6aH9QJppeEsYVnPClHu5Hek
        EVG6iD+hdqloYpshvKq3P/UMgDHe3io=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-qjnOEAaxP06T1njFTjHKeA-1; Fri, 31 Jul 2020 02:09:13 -0400
X-MC-Unique: qjnOEAaxP06T1njFTjHKeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0ECE1DE0
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 06:09:12 +0000 (UTC)
Received: from thuth.com (ovpn-112-153.ams2.redhat.com [10.36.112.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FE99726BF;
        Fri, 31 Jul 2020 06:09:11 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH] scripts/runtime: Replace "|&" with "2>&1 |"
Date:   Fri, 31 Jul 2020 08:09:09 +0200
Message-Id: <20200731060909.1163-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "|&" only works with newer versions of the bash. For compatibility
with older versions, we should use "2>&1 |" instead.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/runtime.bash | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index c88e246..35689a7 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -172,7 +172,7 @@ function run()
 # "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
 # point when maintaining the while loop gets too tiresome, we can
 # just remove it...
-while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
-		|& grep -qi 'exceeds max CPUs'; do
+while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP 2>&1 \
+		| grep -qi 'exceeds max CPUs'; do
 	MAX_SMP=$((MAX_SMP >> 1))
 done
-- 
2.18.1


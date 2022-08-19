Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3724059999C
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 12:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347937AbiHSKPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 06:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348323AbiHSKPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 06:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB042DB047
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 03:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660904115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nE4XTLwKh6UtnjIJTfInkmm2bOQDhEPxLqhuAOXkzX8=;
        b=ZDXeXzZ0TAxlAx6jfO30WZHs4EUFcPoGRK5XbS0SkLME9MS2hjEfEsPsFqQ2Gjr6n7tG8z
        y+6suljgziW/+5PB9EoPbiR6gr51ku7i9Fq2xFiMThtPQmopQ4zgfqgvli1SqAu/ZHjl8r
        BbIniJCsj9tgR11msSzlGfvEZRpHypI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-yZQ2FZNnOQedMbMo9ugYoQ-1; Fri, 19 Aug 2022 06:15:12 -0400
X-MC-Unique: yZQ2FZNnOQedMbMo9ugYoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7280885A588;
        Fri, 19 Aug 2022 10:15:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B385C15BC3;
        Fri, 19 Aug 2022 10:15:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: MIPS: remove unnecessary definition of KVM_PRIVATE_MEM_SLOTS
Date:   Fri, 19 Aug 2022 06:15:12 -0400
Message-Id: <20220819101512.2346335-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_PRIVATE_MEM_SLOTS defaults to zero, so it is not necessary to
define it in MIPS's asm/kvm_host.h.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/mips/include/asm/kvm_host.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 717716cc51c5..5cedb28e8a40 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -84,8 +84,6 @@
 
 
 #define KVM_MAX_VCPUS		16
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS	0
 
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
-- 
2.31.1


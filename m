Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E144608CE5
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 13:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiJVLok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 07:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJVLof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 07:44:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE821DFAC
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 04:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666439067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pg7GS82zW5V1BGQH4TziNSaRtYTOpGK9o3yXWehsYs0=;
        b=ThBX6lZ8GIHU7ec03IArCz0hY1TZHL1uatzKUbS/9p2YrejKtd+C79OsGwoKDiXr1tRAhE
        eOKdHXbmUL5mz9X1YcJnJtxZxM3fL6mSMKkX8RQDJXV+kMVbh8JWWkgfkQ20wHimfNW4l4
        dU84luKd+wfQapp2iVPADSsbZg/RxsY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-kFhBy-jnP8uPpc0OR7aN8w-1; Sat, 22 Oct 2022 07:44:24 -0400
X-MC-Unique: kFhBy-jnP8uPpc0OR7aN8w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D79151C07550;
        Sat, 22 Oct 2022 11:44:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B835D492B04;
        Sat, 22 Oct 2022 11:44:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>
Subject: [PATCH] tools: include: sync include/api/linux/kvm.h
Date:   Sat, 22 Oct 2022 07:44:23 -0400
Message-Id: <20221022114423.1741799-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a definition of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.

Fixes: 4b3402f1f4d9 ("KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available")
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index eed0315a77a6..0d5d4419139a 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.31.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59401588DCA
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbiHCNs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238520AbiHCNsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:48:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD929459A6
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhUjnL8jffpBRvdK+83caHcfCkV1B7jouem6M9M/8vA=;
        b=cLTrNdjHOTmiFI9kSa1sTgz8q4WFdUFMMA587IZ4bgIj40/TxJV6gp0a6VIP4hFWyfJlq2
        +ZiVRUQeOGON3ZmtoZFjlYwAXeJV9X9AsKciBlmduhc+PBAfuO+v3o6WvLA8SKu4EfZUJw
        L75w+kP1pXMH+l8nfxOV6znfVl+4adk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-G36okjgdPZCuCkls8KJnOQ-1; Wed, 03 Aug 2022 09:46:57 -0400
X-MC-Unique: G36okjgdPZCuCkls8KJnOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14B02108C0A1;
        Wed,  3 Aug 2022 13:46:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 010E91121314;
        Wed,  3 Aug 2022 13:46:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 33/40] KVM: selftests: Sync 'struct hv_vp_assist_page' definition with hyperv-tlfs.h
Date:   Wed,  3 Aug 2022 15:46:53 +0200
Message-Id: <20220803134653.399519-1-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct hv_vp_assist_page' definition doesn't match TLFS. Also, define
'struct hv_nested_enlightenments_control' and use it instead of opaque
'__u64'.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/evmcs.h      | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index 367e027cd2a4..721e119783a5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -20,14 +20,26 @@
 
 extern bool enable_evmcs;
 
+struct hv_nested_enlightenments_control {
+	struct {
+		__u32 directhypercall:1;
+		__u32 reserved:31;
+	} features;
+	struct {
+		__u32 reserved;
+	} hypercallControls;
+} __packed;
+
+/* Define virtual processor assist page structure. */
 struct hv_vp_assist_page {
 	__u32 apic_assist;
-	__u32 reserved;
-	__u64 vtl_control[2];
-	__u64 nested_enlightenments_control[2];
-	__u32 enlighten_vmentry;
+	__u32 reserved1;
+	__u64 vtl_control[3];
+	struct hv_nested_enlightenments_control nested_control;
+	__u8 enlighten_vmentry;
+	__u8 reserved2[7];
 	__u64 current_nested_vmcs;
-};
+} __packed;
 
 struct hv_enlightened_vmcs {
 	u32 revision_id;
-- 
2.35.3


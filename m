Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E165614D9A
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiKAPBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiKAPAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:00:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26F964EF
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EODbDTkqTZBBymFnsXzTDVagmoVBHbitQaX3f99+ld8=;
        b=FVYtWzoL4WkIfyVkCgqrQgAL35vyIGww5sq136sR16NSxvCNB22Lzxn2pG/1xkEWGiabqd
        +1alRh9FVCHxsdG+1jxpAg8mrqkLkdkWR/iBalDMuLD9tPwz0vNZS+f4NrxLWHSJmcLGy0
        xNs1BJRKYC4XMxVh/Tu07EArp35TkRQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-f2DQYAPmN0eOuVbcNTz9Tw-1; Tue, 01 Nov 2022 10:56:38 -0400
X-MC-Unique: f2DQYAPmN0eOuVbcNTz9Tw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAA5F1C0A58A;
        Tue,  1 Nov 2022 14:56:37 +0000 (UTC)
Received: from ovpn-194-149.brq.redhat.com (ovpn-194-149.brq.redhat.com [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 500B4C2C8DB;
        Tue,  1 Nov 2022 14:56:32 +0000 (UTC)
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
Subject: [PATCH v13 38/48] KVM: selftests: Sync 'struct hv_enlightened_vmcs' definition with hyperv-tlfs.h
Date:   Tue,  1 Nov 2022 15:54:16 +0100
Message-Id: <20221101145426.251680-39-vkuznets@redhat.com>
In-Reply-To: <20221101145426.251680-1-vkuznets@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct hv_enlightened_vmcs' definition in selftests is not '__packed'
and so we rely on the compiler doing the right padding. This is not
obvious so it seems beneficial to use the same definition as in kernel.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/evmcs.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index 58db74f68af2..4b6840df2979 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -41,6 +41,8 @@ struct hv_enlightened_vmcs {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 
+	u16 padding16_1;
+
 	u64 host_ia32_pat;
 	u64 host_ia32_efer;
 
@@ -159,7 +161,7 @@ struct hv_enlightened_vmcs {
 	u64 ept_pointer;
 
 	u16 virtual_processor_id;
-	u16 padding16[3];
+	u16 padding16_2[3];
 
 	u64 padding64_2[5];
 	u64 guest_physical_address;
@@ -195,13 +197,13 @@ struct hv_enlightened_vmcs {
 	u64 guest_rip;
 
 	u32 hv_clean_fields;
-	u32 hv_padding_32;
+	u32 padding32_1;
 	u32 hv_synthetic_controls;
 	struct {
 		u32 nested_flush_hypercall:1;
 		u32 msr_bitmap:1;
 		u32 reserved:30;
-	} hv_enlightenments_control;
+	}  __packed hv_enlightenments_control;
 	u32 hv_vp_id;
 	u32 padding32_2;
 	u64 hv_vm_id;
@@ -222,7 +224,7 @@ struct hv_enlightened_vmcs {
 	u64 host_ssp;
 	u64 host_ia32_int_ssp_table_addr;
 	u64 padding64_6;
-};
+} __packed;
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                     0
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP                BIT(0)
-- 
2.37.3


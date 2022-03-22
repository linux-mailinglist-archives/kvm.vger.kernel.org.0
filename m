Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E04A4E451A
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbiCVR1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbiCVR1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:27:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA4654B405
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K72g0jmc7uvvumj5L9vLgtlPQocFQSwJwXDuIV0lYDs=;
        b=erAhUY2nNItOTxZGPqxNDN0v+5mqkYlsligrSDP7hu06utSpr6SWuYTVdAa2UhX4mFelQ1
        RzR7hoIqfD+SfugyK/B0C/aIVrKwjtheRFZK4zG8US/G6Ic7ARin5AiGR7JaSrtRZqXCIf
        K/jFDKk18xECwyu89y64t8a6fbJlR10=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-iRlNsCMLPmCsGb_tl-EdUA-1; Tue, 22 Mar 2022 13:25:25 -0400
X-MC-Unique: iRlNsCMLPmCsGb_tl-EdUA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41D9B82A682;
        Tue, 22 Mar 2022 17:25:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2ABF2166B2D;
        Tue, 22 Mar 2022 17:25:20 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 6/8] kvm: x86: SVM: remove unused defines
Date:   Tue, 22 Mar 2022 19:24:47 +0200
Message-Id: <20220322172449.235575-7-mlevitsk@redhat.com>
In-Reply-To: <20220322172449.235575-1-mlevitsk@redhat.com>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove some unused #defines from svm.c

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ea3f0b2605e5..fb31ed01086c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -62,14 +62,6 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 #define SEG_TYPE_LDT 2
 #define SEG_TYPE_BUSY_TSS16 3
 
-#define SVM_FEATURE_LBRV           (1 <<  1)
-#define SVM_FEATURE_SVML           (1 <<  2)
-#define SVM_FEATURE_TSC_RATE       (1 <<  4)
-#define SVM_FEATURE_VMCB_CLEAN     (1 <<  5)
-#define SVM_FEATURE_FLUSH_ASID     (1 <<  6)
-#define SVM_FEATURE_DECODE_ASSIST  (1 <<  7)
-#define SVM_FEATURE_PAUSE_FILTER   (1 << 10)
-
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
 static bool erratum_383_found __read_mostly;
-- 
2.26.3


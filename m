Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAFF5A6549
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiH3NmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiH3Nl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:41:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0528713284F
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcv5uz1YeS0YVWz+jZbDfSoBQT7SITAZLiwOPXNWye4=;
        b=bx+p8yhrKcvavrWTFh2yBO/WiHEAuFOsRxpkp+MbbfQKULPhUYm/68gDM7IvtsTIrIqSTA
        zVaig25khtcFSw1m1QrwkSJrMo7fEl0Q4X6XM1eit7vW+oPPs+NcOc6D+UMaBlvaRyDxxA
        SjOwatMG+HtxlkYk7KFyC62XgqjXWKI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-0DAfFfbZOmSBydPSWpCvNQ-1; Tue, 30 Aug 2022 09:38:53 -0400
X-MC-Unique: 0DAfFfbZOmSBydPSWpCvNQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86FCE2999B43;
        Tue, 30 Aug 2022 13:38:52 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E4EF2166B26;
        Tue, 30 Aug 2022 13:38:50 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 28/33] KVM: x86: VMX: Replace some Intel model numbers with mnemonics
Date:   Tue, 30 Aug 2022 15:37:32 +0200
Message-Id: <20220830133737.1539624-29-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

Intel processor code names are more familiar to many readers than
their decimal model numbers.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2e1fe1f8d764..0a8798ec49e8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2656,11 +2656,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	 */
 	if (boot_cpu_data.x86 == 0x6) {
 		switch (boot_cpu_data.x86_model) {
-		case 26: /* AAK155 */
-		case 30: /* AAP115 */
-		case 37: /* AAT100 */
-		case 44: /* BC86,AAY89,BD102 */
-		case 46: /* BA97 */
+		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
+		case INTEL_FAM6_NEHALEM:	/* AAP115 */
+		case INTEL_FAM6_WESTMERE:	/* AAT100 */
+		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
+		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
 			_vmentry_control &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 			_vmexit_control &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
 			pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
-- 
2.37.2


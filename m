Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3045B587FF2
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbiHBQLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbiHBQKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ED1F1CFE2
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6n9tuWBgKeRLEH4wWnbdkx5qCSjVwDLP+f69wKzLzc=;
        b=MzxAYIfsjXx673dWTEPPDmWOX7zBbmfwRnSaiVvHafIXvnf1KseEH5B5fctnPv+fg1IFF1
        1e0h+H1BuAsbxYL3kxjwu9UqIodqGzr7VDQAKGCOnE6CsYSevlfZjr+tZiCrS39ulyuZk0
        K+IQSfd5KXgyCO7opwlXcVTm6erFpjY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-xYsimLxiMcaJ08I7EVl_bA-1; Tue, 02 Aug 2022 12:08:59 -0400
X-MC-Unique: xYsimLxiMcaJ08I7EVl_bA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2032118A6524;
        Tue,  2 Aug 2022 16:08:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 767472166B26;
        Tue,  2 Aug 2022 16:08:56 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 21/26] KVM: x86: VMX: Replace some Intel model numbers with mnemonics
Date:   Tue,  2 Aug 2022 18:07:51 +0200
Message-Id: <20220802160756.339464-22-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a444f68f50f5..baf1054765a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2658,11 +2658,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
2.35.3


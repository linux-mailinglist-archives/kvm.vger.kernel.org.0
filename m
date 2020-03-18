Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9151F18A165
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 18:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCRRSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 13:18:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:24955 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbgCRRSA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 13:18:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584551879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CuFclgdlUZIfeKH6zTx3SlLSiEPACrqlHVtYi2J2TNQ=;
        b=WpYlUaFnlWylZ513qp5TgFMbdYwe99EwASrSJhPJnuBT8teUpUL1laW9Zuxl5VzCTr0SLZ
        ihIGcSCy/Ko3yqrhKduOdBC/i0WrklBNDTwArU7abYGoI4oCcTMw4cefCA57aHOrmqDwaK
        h2jN0eO/kTIagYpxcJVAY/tjTJJt5AA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-czp_yaSVNKa7agPMLyOJaA-1; Wed, 18 Mar 2020 13:17:57 -0400
X-MC-Unique: czp_yaSVNKa7agPMLyOJaA-1
Received: by mail-wm1-f72.google.com with SMTP id 20so1344565wmk.1
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 10:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CuFclgdlUZIfeKH6zTx3SlLSiEPACrqlHVtYi2J2TNQ=;
        b=sV74q+0UEMcLPQhE87MXdr0dzW7FbvGYQ0ZXLvfR7sqccjDfVFfy77/2ZXUIuEfpYr
         /+yljcosjXOkJvAybL7dbT11qSgPEvQQwwZiW/kjVYutxl3m6Paq8NqKLZYktmtd4w0b
         K00n5kZyOAmHlt5DQMsdcKCAQEV1rjrDO8j2/V3mYUe4LWL0zoby8UqrXOdB5wa6bfi1
         kTW0so9nUL0qrrqSEFW9500YSwHvNSsr+Tub8OEsKTZfa6ylznu9rcwA57PJ1CSJMCQQ
         ooXzliqR2sm1AeXrVNbZV9fgfChP82zND4bsgXJd9Z2pDLLNLjZdheoJGY5k/IMX0WiC
         Qe2w==
X-Gm-Message-State: ANhLgQ1iEH4W0CBz6iv8R+JmIh7/kVHF30gvx7MXqprs0d0P0NAQkNni
        ElTO5G9Ka3QaPs5KCdr7VIjHIbv6nigwH3ewORP0RDGsLP/ziREmpf6eUCzqQapJ1LWhPfCVJAR
        TORWXVZHPlc23
X-Received: by 2002:a7b:c7d9:: with SMTP id z25mr6495678wmk.25.1584551876380;
        Wed, 18 Mar 2020 10:17:56 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvLZDXsCkofLpkMC/8OH/AOs7wrSc1tcFIGLwrcu+GaQO7Kk/aiDF8sstgwLmu6SXzAqfxDMA==
X-Received: by 2002:a7b:c7d9:: with SMTP id z25mr6495646wmk.25.1584551876087;
        Wed, 18 Mar 2020 10:17:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r3sm10531597wrw.76.2020.03.18.10.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 10:17:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] KVM: VMX: rename 'kvm_area' to 'vmxon_region'
Date:   Wed, 18 Mar 2020 18:17:51 +0100
Message-Id: <20200318171752.173073-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200318171752.173073-1-vkuznets@redhat.com>
References: <20200318171752.173073-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The name 'kvm_area' is misleading (as we have way too many areas which are
KVM related), what alloc_kvm_area()/free_kvm_area() functions really do is
allocate/free VMXON region for all CPUs. Rename accordingly.

No functional change intended.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b447d66f44e6..f7ee7c31fe8c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2622,7 +2622,7 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	return -ENOMEM;
 }
 
-static void free_kvm_area(void)
+static void free_vmxon_regions(void)
 {
 	int cpu;
 
@@ -2632,7 +2632,7 @@ static void free_kvm_area(void)
 	}
 }
 
-static __init int alloc_kvm_area(void)
+static __init int alloc_vmxon_regions(void)
 {
 	int cpu;
 
@@ -2641,7 +2641,7 @@ static __init int alloc_kvm_area(void)
 
 		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
 		if (!vmcs) {
-			free_kvm_area();
+			free_vmxon_regions();
 			return -ENOMEM;
 		}
 
@@ -7804,7 +7804,7 @@ static __init int hardware_setup(void)
 
 	vmx_set_cpu_caps();
 
-	r = alloc_kvm_area();
+	r = alloc_vmxon_regions();
 	if (r)
 		nested_vmx_hardware_unsetup();
 	return r;
@@ -7815,7 +7815,7 @@ static __exit void hardware_unsetup(void)
 	if (nested)
 		nested_vmx_hardware_unsetup();
 
-	free_kvm_area();
+	free_vmxon_regions();
 }
 
 static bool vmx_check_apicv_inhibit_reasons(ulong bit)
-- 
2.25.1


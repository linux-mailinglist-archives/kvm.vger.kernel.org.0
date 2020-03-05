Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D3B17AE47
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 19:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgCEShg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 13:37:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47745 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725991AbgCEShf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 13:37:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583433454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y2yWNaYqjJ/RvKkVVduCbhM3C1I4Zkz6logIvpDXjRI=;
        b=DpQXySBbj5+q95FBbtMX5dH5e2K6asPAS1PJWYArG4SHh7JsOtn3iZEFYfx9nBYEcDQ/Mu
        81nT1u13M8Mh1JJgc/HaYkyLL1scbSK+DWajqImVUGBDt4CcbWZ4vJA2roWvom2Yqi36cX
        F/G00qKsdxpviD70lTNfPeOn0An0avE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-fj3C1rRJOTiNnTfqlayXpQ-1; Thu, 05 Mar 2020 13:37:32 -0500
X-MC-Unique: fj3C1rRJOTiNnTfqlayXpQ-1
Received: by mail-wm1-f72.google.com with SMTP id g26so1891078wmk.6
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 10:37:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2yWNaYqjJ/RvKkVVduCbhM3C1I4Zkz6logIvpDXjRI=;
        b=gAnV8D0ML75LFBHrgDrwPbLej6630R/4ZU1MfJ0e2WZMr0yrfI7n12hzQrYDSbsfmE
         SZ/YM0/6TYhd/qAFLXqTQWAixjImFfFVtvOjNWMM19IzI1XlQamqerqxlKAcvG5jJNl/
         s27pkSPIhQL2MhC2NXFAMGOnjxeYj3PM0VLgSDPFK9brdrHoolrjS2b8zNiEff5oXrFj
         ke8RIdvJSEgNKqSiSa84+d25a1tQzADbGKhS7L8ymN+Xi3qXOjzhGAjGkwYWqYDSA3Wf
         E7HcVG6Vg5N1uC9WZTC3okxGq/ewGF4C4oeDLIiFbYL7LE9cOoh6oB0UwpCqrkrnG17z
         fJoA==
X-Gm-Message-State: ANhLgQ1njeR1dOy0Vvos3lZlnZxdDjpEXHjgf0ZiiURtx259YtAyjkWE
        rPQpYHzpVunN4G/szaqwysEatIqKNjG7tu/M7/zQXhagi/v1wr4LtjMdDT76IkfUOXZkTQkoot9
        iew951HxoqL7L
X-Received: by 2002:a5d:4805:: with SMTP id l5mr251440wrq.11.1583433451434;
        Thu, 05 Mar 2020 10:37:31 -0800 (PST)
X-Google-Smtp-Source: ADFU+vt5yUT+iVGTGcKSZmbdeAb5G5VOmuV4IHK9ltTcOTR1wb/CGf1O1/ALTCR0TuslpOqF3DIkKg==
X-Received: by 2002:a5d:4805:: with SMTP id l5mr251423wrq.11.1583433451243;
        Thu, 05 Mar 2020 10:37:31 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u17sm9369121wmj.47.2020.03.05.10.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 10:37:30 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: VMX: rename 'kvm_area' to 'vmxon_region'
Date:   Thu,  5 Mar 2020 19:37:24 +0100
Message-Id: <20200305183725.28872-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305183725.28872-1-vkuznets@redhat.com>
References: <20200305183725.28872-1-vkuznets@redhat.com>
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
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40b1e6138cd5..dab19e4e5f2b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2635,7 +2635,7 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	return -ENOMEM;
 }
 
-static void free_kvm_area(void)
+static void free_vmxon_regions(void)
 {
 	int cpu;
 
@@ -2645,7 +2645,7 @@ static void free_kvm_area(void)
 	}
 }
 
-static __init int alloc_kvm_area(void)
+static __init int alloc_vmxon_regions(void)
 {
 	int cpu;
 
@@ -2654,7 +2654,7 @@ static __init int alloc_kvm_area(void)
 
 		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
 		if (!vmcs) {
-			free_kvm_area();
+			free_vmxon_regions();
 			return -ENOMEM;
 		}
 
@@ -7815,7 +7815,7 @@ static __init int hardware_setup(void)
 			return r;
 	}
 
-	r = alloc_kvm_area();
+	r = alloc_vmxon_regions();
 	if (r)
 		nested_vmx_hardware_unsetup();
 	return r;
@@ -7826,7 +7826,7 @@ static __exit void hardware_unsetup(void)
 	if (nested)
 		nested_vmx_hardware_unsetup();
 
-	free_kvm_area();
+	free_vmxon_regions();
 }
 
 static bool vmx_check_apicv_inhibit_reasons(ulong bit)
-- 
2.24.1


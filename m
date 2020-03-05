Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648DB17A2C1
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgCEKBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:01:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33403 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725816AbgCEKBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:01:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583402489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oswt/Kc8n1kZsUQ8QoQ1RiwQKyVHquWO2Ji98TMP3xg=;
        b=PsGdhXy0zwt+3ZjsuehX+gQ7rhoGYwAD/QviGvwePRZ1R4l0jXemQ6A0saP7RiORRIdbDI
        iANwdM9hxCWCUGZvE/RiAOleDF/3ApXXnM51KaZIIXtoavUfFtF/bkd0elf5xLs/pX9dNh
        Vz2MZTfVZtxypXpzwYyBxb5yj/ZQ4W0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-Sbip1xEpMwi7MrbWT18jsg-1; Thu, 05 Mar 2020 05:01:28 -0500
X-MC-Unique: Sbip1xEpMwi7MrbWT18jsg-1
Received: by mail-wm1-f71.google.com with SMTP id w12so1371979wmc.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 02:01:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oswt/Kc8n1kZsUQ8QoQ1RiwQKyVHquWO2Ji98TMP3xg=;
        b=D26/l+hkLdSYQl2QDWIPJCJxbz8u1df1n/tAD3SDtEU/gGr3L9pkHxVVjVDhjFf5IR
         GLovxkuLrptYCec6zvToHKHtDpq8xrEc7ttg1ONbLxcIbKNOK0rz/NClp8SOxbQqbF7t
         VkOpkfKS19FZtiEiQ2Ac8ta+Lyu+PATGj144YFtp4I06jfiWSZ95wllJzKeVV9DnSD5T
         Bpgwumk3LzK/DJ476Mkv5WBOlA8z8MvfCwRKyXIqRo24DDtN6nCXEkS/xMEH8mcH0qNr
         6o8gL+Rw1zaa1QLdABRSnWyySujk+lJ7oaUv8R9xx9QRTwMNEGCnH7sAlwuPb2VBACiD
         z/qA==
X-Gm-Message-State: ANhLgQ2AGDOkMjTzU3cJGUjqqXWtlU2NVCIqnlO8eiy0/66wUbezMr+P
        BRVVB19Fn23LOY5HQlha1+a7rCj35d3NH1+X7ckCnSasM9G7WkpnclTeCtN4Xm6UUJ7/lGeT3E4
        nhGYOyELx7NdC
X-Received: by 2002:a1c:ab07:: with SMTP id u7mr8242973wme.23.1583402486906;
        Thu, 05 Mar 2020 02:01:26 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuBnaABVorkSgwKmJdmaxfU2FtG7PnSy504t3kXi28pQPtb3RflQXkq36d2TuSjUNI9iAwShg==
X-Received: by 2002:a1c:ab07:: with SMTP id u7mr8242950wme.23.1583402486722;
        Thu, 05 Mar 2020 02:01:26 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f207sm10440025wme.9.2020.03.05.02.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 02:01:25 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: VMX: rename 'kvm_area' to 'vmxon_region'
Date:   Thu,  5 Mar 2020 11:01:22 +0100
Message-Id: <20200305100123.1013667-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305100123.1013667-1-vkuznets@redhat.com>
References: <20200305100123.1013667-1-vkuznets@redhat.com>
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


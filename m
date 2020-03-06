Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8AA17BD74
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 14:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgCFNC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 08:02:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34939 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726733AbgCFNCZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 08:02:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583499744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y2yWNaYqjJ/RvKkVVduCbhM3C1I4Zkz6logIvpDXjRI=;
        b=Q6oy0vfpoUSWpizjCenTyIP2H4xFppaP/aL07Tm8nzTBA6pdF1XE+jmnddi2ZcTyWuBlAa
        w3wCs136ssTu+Svp7AkJQeLFFeBLaCNSFlm9uStyelesBKIk/WmWKtDkm8F4UYOkp2ctCO
        /ce8cmJ3WZQZZHlewRo8GFYP/uo7N9s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-wG0-d9-HNH2lQX5CDpht-g-1; Fri, 06 Mar 2020 08:02:20 -0500
X-MC-Unique: wG0-d9-HNH2lQX5CDpht-g-1
Received: by mail-wm1-f69.google.com with SMTP id y7so859576wmd.4
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 05:02:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2yWNaYqjJ/RvKkVVduCbhM3C1I4Zkz6logIvpDXjRI=;
        b=gjBXfGAR4kLou//3lyaAI8T0E4rmodS85S0CpWR+wcKxcweqQXZmTjks6+1CPtjAsW
         T6tBFLIqqoWKLLdKeysTV3f8UHdPQzq+m+8r/UraopYsyUm0b/zWnbTnMVzA6iZrFFzO
         gMLaqvrj7KM3VcN8RqbmR1Pf7RjHCmV1O+b2GkxdFdFpw7XsOu6j1UmJDgjmCAfCYy6Q
         sYjBdbsk/76qY9MgJ4Lu65lJmFU8PLWhKvFuE3iFwxBY/WqOzI8qV6i0T/g366jofJml
         RuO5y9kYZIs4leEEVb8hT3mTCZTG6cBL9vMwu05hnKXQx95mz3lcCcb6QdtjVxu4yUPe
         lgfA==
X-Gm-Message-State: ANhLgQ3wwSqwi3cmsT1IqZC87bPc8lxZVrO8cLE21rjUBwdSnALTD358
        rSzBxD33rO+47z/Y2Hvybs/G/pWLC2fPgD3899N89tNPi+AuVE3BjdiSGcvAG5BeNuZfIFuAohU
        2BvXrbgZ4Qy4u
X-Received: by 2002:a5d:6690:: with SMTP id l16mr4193877wru.251.1583499739787;
        Fri, 06 Mar 2020 05:02:19 -0800 (PST)
X-Google-Smtp-Source: ADFU+vt1OXPzlEbyvBAvceW/RbmClBEpZeiagwVFOODbocvqNKeEiZjWeqYhWm0qnk58uiEN6mYnZw==
X-Received: by 2002:a5d:6690:: with SMTP id l16mr4193848wru.251.1583499739540;
        Fri, 06 Mar 2020 05:02:19 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id i67sm26613243wri.50.2020.03.06.05.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:02:18 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] KVM: VMX: rename 'kvm_area' to 'vmxon_region'
Date:   Fri,  6 Mar 2020 14:02:14 +0100
Message-Id: <20200306130215.150686-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306130215.150686-1-vkuznets@redhat.com>
References: <20200306130215.150686-1-vkuznets@redhat.com>
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


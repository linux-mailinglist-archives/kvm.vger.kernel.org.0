Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3E01779B8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgCCO7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:59:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41698 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726766AbgCCO7U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 09:59:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583247559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q3INcNmfvd0keaFFtSvq7kLrMBsEvlegDlXL3LDjJtw=;
        b=EkYGi/Lz6IwyKMUHm/arpMCGRnYzpEJc1+RORYLgOP9UheVQJGmVnVXlc3T8DuHPcdMh2z
        VYEFVWQLNkrShCuAM2AoKJPzLJhY9/zgKvXX5XwubRTjwkJAtFSlDcNE36FQoWYmDFPL91
        gYXA1mEk8lklbQsdzXDPkioj+8DHTHw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-bv_NlLNPMC2e5SvblASUDQ-1; Tue, 03 Mar 2020 09:59:17 -0500
X-MC-Unique: bv_NlLNPMC2e5SvblASUDQ-1
Received: by mail-wr1-f70.google.com with SMTP id m18so1304506wro.22
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 06:59:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q3INcNmfvd0keaFFtSvq7kLrMBsEvlegDlXL3LDjJtw=;
        b=G8FqkDHG8mFsPI1dJrsJrAFecRfXwCvSBYmtlyfi0gBtVSQCI7SNfR7mNlGoWwSswn
         GgLuDa9xfs6mDUh2EOCRsVt478R5YICCP93Hq7+Qox7QMy9lRGYfH6V8E/3T6Dk5ELit
         D1AH5v21hdB03DV9i6273JYeiHHczYzBXR1Fr0SPJulCa5QOELxbdBRDKev7Ks9A7gz9
         Ceg/gYIJ1xpQcIuh4ZnXD0CN1wryjSq2BSpSl9L+FjCoMu2+jXr1UOcxqkYZxpiJt/Ze
         2/BJUdu0cxjFhwZUrhO792YTKP45Uz5h8u5EJKcUbkGV7EQc8iGKVcc7PO0l6o4D0nsc
         s+FA==
X-Gm-Message-State: ANhLgQ3tTmmgQBfkEPovXUTn4atoU07m18mkXOgx2P2dilfRpN79eOvU
        XXaeG78zO1C1+YJqGM8JEUCJL59Hgi/JDbhlhbCASHIBON2VI8VorFdWYs5JIi6yN4LP6CRhrih
        HrGHBUZ8IdrYy
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr3142876wmi.32.1583247556403;
        Tue, 03 Mar 2020 06:59:16 -0800 (PST)
X-Google-Smtp-Source: ADFU+vt1RLURtABBn8aSSBG+jqW4QAi/m+dn0RH1ZEcCXqdMzBZSlAaAyddA7kBq72kciM4FXajzwQ==
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr3142865wmi.32.1583247556134;
        Tue, 03 Mar 2020 06:59:16 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id 12sm4252542wmo.30.2020.03.03.06.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 06:59:15 -0800 (PST)
Subject: Re: [PATCH v2 36/66] KVM: x86: Handle GBPAGE CPUID adjustment for EPT
 in VMX code
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-37-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <90df7276-e586-9082-3d80-6b45e0fb4670@redhat.com>
Date:   Tue, 3 Mar 2020 15:59:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302235709.27467-37-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 00:56, Sean Christopherson wrote:
> Move the clearing of the GBPAGE CPUID bit into VMX to eliminate an
> instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
> pattern in the common CPUID handling code, and to pave the way toward
> eliminating ->get_lpage_level().
> 
> No functional change intended.

And no functional change is done indeed but there is a preexisting bug 
that should be fixed.

cpu_has_vmx_ept_1g_page() has no relationship to whether 1GB pages should be
marked as supported in CPUID.  This has no ill effect because we're only
clearing the bit, but it results in 1GB pages not being available when
EPT is disabled (even though they are actually supported thanks to
shadowing).

The right fix should be this:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 84b9a488a443..8bbba8eb4ce5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -416,8 +416,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	int r, i, max_idx;
 	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
 #ifdef CONFIG_X86_64
-	unsigned f_gbpages = (kvm_x86_ops->get_lpage_level() == PT_PDPE_LEVEL)
-				? F(GBPAGES) : 0;
+	unsigned f_gbpages = F(GBPAGES);
 	unsigned f_lm = F(LM);
 #else
 	unsigned f_gbpages = 0;
@@ -691,6 +690,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x80000001:
 		entry->edx &= kvm_cpuid_8000_0001_edx_x86_features;
 		cpuid_entry_mask(entry, CPUID_8000_0001_EDX);
+		if (!tdp_enabled)
+			cpuid_entry_set(entry, X86_FEATURE_GBPAGES);
 		entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
 		cpuid_entry_mask(entry, CPUID_8000_0001_ECX);
 		break;

Paolo


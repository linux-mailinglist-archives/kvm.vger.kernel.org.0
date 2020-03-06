Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F1D17B8EA
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 10:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgCFJDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 04:03:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34640 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726185AbgCFJDm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 04:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583485422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6hHlu4u9pl0gr61Q0hqOcfTBLsfleChBZw4ki+HhSs=;
        b=hIMd7g9EAM5NflZCGSNIiP5ipNk234D4ro5J3DxdtU06XAUZuYyC3hrmwdHttv+MvK3qBO
        IoPgmHWInHgLL8Ihcc+On2WOOEsmtJAtyaKyf96hEGJRfl5H6eswf7QYgi8CTR/XsrFlxR
        nt5zVLD/ZUzjJ+bEd7YzNyMYUtlaxM4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-EDXjpXTsM9SWeIv0kcKZFg-1; Fri, 06 Mar 2020 04:03:40 -0500
X-MC-Unique: EDXjpXTsM9SWeIv0kcKZFg-1
Received: by mail-wm1-f72.google.com with SMTP id c18so633329wml.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 01:03:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6hHlu4u9pl0gr61Q0hqOcfTBLsfleChBZw4ki+HhSs=;
        b=sshAvmgxFVV1MMk9g/r+jpt7BKumJ7BCGj7OFhhnOwM5H0uuR/e4auhFEYjafPEjmo
         6Nx6io9iDosZADN0W/v0xPjtn0a6GG44ITx1iAjX3v2slX9I9Oh9x8qKHFRi2kAqeMmT
         Dr+/QxJlTUFQkzVlSHIdi4gIRwZP9RWtN5hmYtiaxaOAbcwZKw2eJV2AsGzOE9VFZ/7F
         9RS6ZIlbEr6HamK2u+5F5tlm116+ksH/qMS2FGy+0aEQmoH5JsoUlpsP9sNGgrb2hiaF
         nx5Yo7t6ui0n/QIZCmzmWj97SHfV7JbMZbD2DPgV/zAZufGA4WnN8VyVbzA1zoRiiOaQ
         vbZg==
X-Gm-Message-State: ANhLgQ0de9L7kZwOV/7+AdxEnDIUX5iYofvTeaLduF6Hr0nsotiA871y
        vDQw3cMsvhpf6wQresxfhFlGkE5HKIQia8zZBRpEGcaoTs1rKU50OGgFkdMQUvUwgS+cdf+pUQk
        iUbnPwDlHjCg6
X-Received: by 2002:a7b:cc04:: with SMTP id f4mr2844687wmh.134.1583485419347;
        Fri, 06 Mar 2020 01:03:39 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsZO2rja5Eg1hV4u0r3e03rSF/NHnpK/09XscrzRU6x3ksC1Fnqv688SJGqraKNNW3h7xNhIg==
X-Received: by 2002:a7b:cc04:: with SMTP id f4mr2844629wmh.134.1583485418812;
        Fri, 06 Mar 2020 01:03:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b99a:4374:773d:f32e? ([2001:b07:6468:f312:b99a:4374:773d:f32e])
        by smtp.gmail.com with ESMTPSA id v131sm13743426wme.23.2020.03.06.01.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 01:03:38 -0800 (PST)
Subject: Re: [PATCH v2 4/7] KVM: x86: Fix CPUID range checks for Hypervisor
 and Centaur classes
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pu Wen <puwen@hygon.cn>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
 <20200305013437.8578-5-sean.j.christopherson@intel.com>
 <CALMp9eRRWZ54kzMXdTqRCy2KmaUAq+HVVVzbxJNVdgktg65XCA@mail.gmail.com>
 <20200305192532.GN11500@linux.intel.com>
 <CALMp9eRxdGj0DL0_g-an0YC+gTMcWcSk7=md=k4-8S0Zcankbg@mail.gmail.com>
 <20200305215149.GS11500@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5567edf6-a04c-5810-8ed5-78a0db14b202@redhat.com>
Date:   Fri, 6 Mar 2020 10:03:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305215149.GS11500@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 22:51, Sean Christopherson wrote:
>> Ah. So cross-vendor CPUID specifications are not supported?
> Cross-vendor CPUID is sort of allowed?  E.g. this plays nice with creating
> a Centaur CPU on an Intel platform.  My interpretation of GET_SUPPORTED...
> is that KVM won't prevent enumerating what you want in CPUID, but it only
> promises to correctly support select leafs.

But in practice does this change anything?  If the vendor is not Centaur 
it's unlikely that there is a 0xc0000000 leaf.  The 0x80000000 bound is
certainly not going to be at 0xc0000000 or beyond, and likewise to 0xc0000000
bound is not going to be at 0xd0000000 or beyond.  So I'm not sure if
anything is lost from this simplification:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ed5e0bda672c..f43a8875c126 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -963,8 +963,7 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 
 	if (function >= 0x40000000 && function <= 0x4fffffff)
 		class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
-	else if (function >= 0xc0000000 && function <= 0xcfffffff &&
-		 is_guest_vendor_centaur(basic->ebx, basic->ecx, basic->edx))
+	else if (function >= 0xc0000000)
 		class = kvm_find_cpuid_entry(vcpu, 0xc0000000, 0);
 	else
 		class = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 12ddfa493bae..3cb50eda606d 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -424,13 +424,6 @@ static inline bool is_guest_vendor_hygon(u32 ebx, u32 ecx, u32 edx)
 	       edx == X86EMUL_CPUID_VENDOR_HygonGenuine_edx;
 }
 
-static inline bool is_guest_vendor_centaur(u32 ebx, u32 ecx, u32 edx)
-{
-	return ebx == X86EMUL_CPUID_VENDOR_CentaurHauls_ebx &&
-	       ecx == X86EMUL_CPUID_VENDOR_CentaurHauls_ecx &&
-	       edx == X86EMUL_CPUID_VENDOR_CentaurHauls_edx;
-}
-
 enum x86_intercept_stage {
 	X86_ICTP_NONE = 0,   /* Allow zero-init to not match anything */
 	X86_ICPT_PRE_EXCEPT,


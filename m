Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1637827D1C1
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 16:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbgI2Orf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 10:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728937AbgI2Orf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 10:47:35 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601390853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PtRKjvr2xKdnyYEHitFUee6d7Brs/dWCC9MF1YYO3xM=;
        b=IksYDtnuZyRBSML19JirOJP6+HOk2rU69at/CKVG9PYJQ4JUIhC6ZcYpfdXg3+e0CXp6RM
        B263CjemAjFMfUb6WiP2yJRNrTiQVCPvacxikZfF8S6OkGSOyAijkfYb+W9BqLrcDWX3Vh
        jIINX5GqxNURNBZntH5E7z26Td0owm4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-hgccNxGxMWK4aWJQo79dNA-1; Tue, 29 Sep 2020 10:47:31 -0400
X-MC-Unique: hgccNxGxMWK4aWJQo79dNA-1
Received: by mail-wm1-f72.google.com with SMTP id m25so1943943wmi.0
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 07:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PtRKjvr2xKdnyYEHitFUee6d7Brs/dWCC9MF1YYO3xM=;
        b=m2GeaumwIZ5fbjU3a8pWa1WB4H+zdOqpEP2edNxZTnEJW7CCdpVyjESl+locu0lEqH
         c0m5CU+9+/7tBTHI1QnLLPSbTOIqJF6dUm9TQk0DMpxxlrVY/t6wkXANutWGp7XnzdiW
         NOmDmbP64tK1PlaoFntTLFE0cA9LhKvXOY8bBSxRG5bNXuPgH2h4IKr493FCVG3RcgJb
         vDU/Ok5Q7VuFAQP5/0b7exQk2TIK/pk7HnncdskhuJjt4kbH+1gw21V6A4y6lBKZdnbg
         UpQbuDKSk4AeTuWev5RVW2wdPR0yWxwh8DhzuJwdbplJCVfQnBXsd+m3Sot+Swrt9dy7
         6EUw==
X-Gm-Message-State: AOAM531yp1CYKt0/BaknWis4HBbfmVyAC/4ZPgVotSDwfaN5KnKUNXE6
        1BVnvZHN+ep5EP5b9GmHQL0on34zRVIgcq9rbGieshqzZy1t1Vu3nBkrFt6nlh2RfVZzWN6stfc
        gD6CQmASeePmq
X-Received: by 2002:a1c:9c4b:: with SMTP id f72mr4941943wme.188.1601390850360;
        Tue, 29 Sep 2020 07:47:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVvIsgRlLltuU7/F3qHNhZaYh3pEjgJZUzHs5Wbg6c+re1FxA/iDBgncxK9LACmKogcerxaw==
X-Received: by 2002:a1c:9c4b:: with SMTP id f72mr4941915wme.188.1601390850039;
        Tue, 29 Sep 2020 07:47:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dbe:2c91:3d1b:58c6? ([2001:b07:6468:f312:9dbe:2c91:3d1b:58c6])
        by smtp.gmail.com with ESMTPSA id t17sm6687615wrx.82.2020.09.29.07.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 07:47:28 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Qian Cai <cai@redhat.com>, Mohammed Gamal <mgamal@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20200903141122.72908-1-mgamal@redhat.com>
 <1f42d8f084083cdf6933977eafbb31741080f7eb.camel@redhat.com>
 <e1dee0fd2b4be9d8ea183d3cf6d601cf9566fde9.camel@redhat.com>
 <ebcd39a5-364f-c4ac-f8c7-41057a3d84be@redhat.com>
 <2063b592f82f680edf61dad575f7c092d11d8ba3.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c385b225-77fb-cf2a-fba3-c70a9b6d541d@redhat.com>
Date:   Tue, 29 Sep 2020 16:47:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <2063b592f82f680edf61dad575f7c092d11d8ba3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/20 15:39, Qian Cai wrote:
> On Tue, 2020-09-29 at 14:26 +0200, Paolo Bonzini wrote:
>> On 29/09/20 13:59, Qian Cai wrote:
>>> WARN_ON_ONCE(!allow_smaller_maxphyaddr);
>>>
>>> I noticed the origin patch did not have this WARN_ON_ONCE(), but the
>>> mainline
>>> commit b96e6506c2ea ("KVM: x86: VMX: Make smaller physical guest address
>>> space
>>> support user-configurable") does have it for some reasons.
>>
>> Because that part of the code should not be reached.  The exception
>> bitmap is set up with
>>
>>         if (!vmx_need_pf_intercept(vcpu))
>>                 eb &= ~(1u << PF_VECTOR);
>>
>> where
>>
>> static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
>> {
>>         if (!enable_ept)
>>                 return true;
>>
>>         return allow_smaller_maxphyaddr &&
>> 		 cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
>> }
>>
>> We shouldn't get here if "enable_ept && !allow_smaller_maxphyaddr",
>> which implies vmx_need_pf_intercept(vcpu) == false.  So the warning is
>> genuine; I've sent a patch.
> 
> Care to provide a link to the patch? Just curious.
> 

Ok, I haven't sent it yet. :)  But here it is:

commit 608e2791d7353e7d777bf32038ca3e7d548155a4 (HEAD -> kvm-master)
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue Sep 29 08:31:32 2020 -0400

    KVM: VMX: update PFEC_MASK/PFEC_MATCH together with PF intercept
    
    The PFEC_MASK and PFEC_MATCH fields in the VMCS reverse the meaning of
    the #PF intercept bit in the exception bitmap when they do not match.
    This means that, if PFEC_MASK and/or PFEC_MATCH are set, the
    hypervisor can get a vmexit for #PF exceptions even when the
    corresponding bit is clear in the exception bitmap.
    
    This is unexpected and is promptly reported as a WARN_ON_ONCE.
    To fix it, reset PFEC_MASK and PFEC_MATCH when the #PF intercept
    is disabled (as is common with enable_ept && !allow_smaller_maxphyaddr).
    
    Reported-by: Qian Cai <cai@redhat.com>>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f0384e93548a..f4e9c310032a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -794,6 +794,18 @@ void update_exception_bitmap(struct kvm_vcpu *vcpu)
 	 */
 	if (is_guest_mode(vcpu))
 		eb |= get_vmcs12(vcpu)->exception_bitmap;
+        else {
+		/*
+		 * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
+		 * between guest and host.  In that case we only care about present
+		 * faults.  For vmcs02, however, PFEC_MASK and PFEC_MATCH are set in
+		 * prepare_vmcs02_rare.
+		 */
+		bool selective_pf_trap = enable_ept && (eb & (1u << PF_VECTOR));
+		int mask = selective_pf_trap ? PFERR_PRESENT_MASK : 0;
+		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, mask);
+		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, mask);
+	}
 
 	vmcs_write32(EXCEPTION_BITMAP, eb);
 }
@@ -4355,16 +4367,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->pt_desc.guest.output_mask = 0x7F;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
 	}
-
-	/*
-	 * If EPT is enabled, #PF is only trapped if MAXPHYADDR is mismatched
-	 * between guest and host.  In that case we only care about present
-	 * faults.
-	 */
-	if (enable_ept) {
-		vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, PFERR_PRESENT_MASK);
-		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, PFERR_PRESENT_MASK);
-	}
 }
 
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567E81AC849
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgDPPGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 11:06:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392446AbgDPNwN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 09:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587045132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JtZT59l+g5q4URhJXPd/sWhIspEh7jpqcBTOItYfg28=;
        b=UpbfD+TjxgVDFCkYpiX4MvbZlZ/3FysYkwB0fTH9tdCPq6BVHM5dQCfhYNPNxApPRdKI8r
        3FsrpcFlVWicKspJ6nDK0JJ5WUR7wbKDP1njDE/w32L2EkY/lVItDEr8Bn1dPQRMHk/LXg
        QDbFEDP3oaFVWwGLjfx6r3YF2NQT0YY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-hAF2UlOuNu2VqOWDadtarQ-1; Thu, 16 Apr 2020 09:52:10 -0400
X-MC-Unique: hAF2UlOuNu2VqOWDadtarQ-1
Received: by mail-wr1-f72.google.com with SMTP id h14so1737879wrr.12
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 06:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JtZT59l+g5q4URhJXPd/sWhIspEh7jpqcBTOItYfg28=;
        b=g9AuXpqx8Rqkzs0Uh3J524FjygN4LOrOLtrIhaHAYp48ia0oStdcTxZXhVUhctkR4o
         NTIRX7cUFgQlD0RT3AyDdkpAAyD8jf7yc9sY1cvrsYMY1osggYct4nkpEjbyM85NWFUN
         uOe6eke1AzbWz9cJu5xH9IdTEj/h6ShDUqS0VP7g8XjoSTrl6+UTPw6RDy3xYHta6nVD
         7r1G6JRu4S/ff8eUs/bfr5YOO5yO1fe7BfkT/h45kdu0ne90Rzaw3MH5ToxkngaPSdXe
         xrSQKsZYg78UHUJcPkM8A+VB7a/r+lGFfHdcWdXPeXsMTjoaX6fuOPie+XYjVhkENDH6
         btXA==
X-Gm-Message-State: AGi0PubeHNPomFzFIOT3NLoC3mjDhjMDWvU6LdsOMY+OZOTktAiEJJ+4
        ArPjOAMPOT1Uo0nZOVeKZwCvdMqjJiWyJSRNX1DVlhAMiqF5Wx9o8AwBc7+zpJLpG+TQlKixDAF
        Jjn3YIjOEyNCu
X-Received: by 2002:a5d:6950:: with SMTP id r16mr11568146wrw.388.1587045129597;
        Thu, 16 Apr 2020 06:52:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypK63/aYHcwyhd8tocTraFkjK2hYA4p1i+B3r5iNYJk8yI1wvmbWMNaX6XdqWAZjmgzyg1U15w==
X-Received: by 2002:a5d:6950:: with SMTP id r16mr11568119wrw.388.1587045129315;
        Thu, 16 Apr 2020 06:52:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id p7sm28032996wrf.31.2020.04.16.06.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 06:52:08 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Minor cleanup in try_async_pf()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20200415214414.10194-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <29248fbf-f0fd-74e6-3edb-ee5ad1e0b33d@redhat.com>
Date:   Thu, 16 Apr 2020 15:52:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200415214414.10194-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 23:44, Sean Christopherson wrote:
> 
> I'm not 100% on whether or not open coding the private memslot check in
> patch 2 is a good idea.  Avoiding the extra memslot lookup is nice, but
> that could be done by providing e.g. kvm_is_memslot_visible(). 

Yeah, that's better.  The patch is so small that it's even pointless to
split it in two:

From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86/mmu: Avoid an extra memslot lookup in try_async_pf() for L2

Create a new function kvm_is_visible_memslot() and use it from
kvm_is_visible_gfn(); use the new function in try_async_pf() too,
to avoid an extra memslot lookup.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d6cb9416179..fe04ce843a57 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4082,19 +4082,18 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
 			 bool *writable)
 {
-	struct kvm_memory_slot *slot;
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
 
 	/*
 	 * Don't expose private memslots to L2.
 	 */
-	if (is_guest_mode(vcpu) && !kvm_is_visible_gfn(vcpu->kvm, gfn)) {
+	if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
 		*pfn = KVM_PFN_NOSLOT;
 		*writable = false;
 		return false;
 	}
 
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	async = false;
 	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
 	if (!async)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 658215f6102c..7d4f1eb70274 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1357,6 +1357,12 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 }
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
 
+static inline bool kvm_is_visible_memslot(struct kvm_memory_slot *memslot)
+{
+	return (memslot && memslot->id < KVM_USER_MEM_SLOTS &&
+		!(memslot->flags & KVM_MEMSLOT_INVALID));
+}
+
 struct kvm_vcpu *kvm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index da8fd45e0e3e..8aa577db131e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1607,11 +1607,7 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *memslot = gfn_to_memslot(kvm, gfn);
 
-	if (!memslot || memslot->id >= KVM_USER_MEM_SLOTS ||
-	      memslot->flags & KVM_MEMSLOT_INVALID)
-		return false;
-
-	return true;
+	return kvm_is_visible_memslot(memslot);
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 


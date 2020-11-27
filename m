Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE422C5F47
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 05:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392459AbgK0Ehv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 23:37:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731606AbgK0Ehv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 23:37:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606451869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=reSpVWVmbz5ZAq+yI7I2HFVMKl5E/EcnzIr9MxvXcNc=;
        b=FhmFiv0N48HA2Gw7oRJ2Fa8CGLvtFtFcpFGsDfV+Sh1PJoTFZiAyT3TGlRaJeHwuNK1iAX
        qnH+B5yJKSKqpduHmkYmHtUigEAebAYmPnNiQLQoxnNR571C4qCo6Y4wM3xPWNV2RaYLQx
        N2lagyLBfTSnsalFcW8/RO3Z4wxNuXQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-_4FPhX3iNdGCCuz8fKYgYg-1; Thu, 26 Nov 2020 23:37:47 -0500
X-MC-Unique: _4FPhX3iNdGCCuz8fKYgYg-1
Received: by mail-ed1-f71.google.com with SMTP id c24so1973030edx.2
        for <kvm@vger.kernel.org>; Thu, 26 Nov 2020 20:37:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=reSpVWVmbz5ZAq+yI7I2HFVMKl5E/EcnzIr9MxvXcNc=;
        b=fEBlG9oWQoFZSgusDZ26Qm7cXw/A+2uW6yDiOfP2BNi1xLfqBZVjPcP/fG90cySeSM
         VMEeI/TfTUcJ5CRbfKxL2tFKzP67+gnkfzwjk8eZRhcgH0ZAQ+T4rQphDogzJsWD4IpZ
         L2uQb5eiB4WnLykk75N18t0bFhEI5q4FbE/hGegl5ilaeHTtAfBST44Q5j5dWK/SMltt
         JZT9P9esjTMOEDevkkndbL0AXXcJT3pGKyq2IDH6wW7OLtiFUChB5FqF6JnnIAJml3tb
         S2u1kJKkLX/RTAuJwii64PSq99unmhyDEXw8UponsG2AFUWMJ53dRvsT9QHvTRQGVFnW
         x5IQ==
X-Gm-Message-State: AOAM5328l+0VYtnH2ReWuHLTL8siwiDxQLvJl2Wvyg2UPRAtuKLZXOew
        lBcFVzPqZn+f5+khDBCSUBmvYCxsCHeihGiZ3QCtijuuS/d+h+8Pyua2RmzCb8Qr23y1oXjxg/D
        6oCHho93kDxmL
X-Received: by 2002:a17:906:fa13:: with SMTP id lo19mr3576227ejb.455.1606451865874;
        Thu, 26 Nov 2020 20:37:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCfte9vMjDbKrHsgVyuAwHrg8/e9veY/FjkE89m9a+xLt63wm85AXTe1qwBzfu3HEL0iwryQ==
X-Received: by 2002:a17:906:fa13:: with SMTP id lo19mr3576219ejb.455.1606451865651;
        Thu, 26 Nov 2020 20:37:45 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id 65sm4461204edj.83.2020.11.26.20.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 20:37:44 -0800 (PST)
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        "Borghorst, Hendrik" <hborghor@amazon.com>
Cc:     kvm <kvm@vger.kernel.org>, "Sironi, Filippo" <sironi@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Matt Gingell <gingell@google.com>,
        Steve Rutherford <srutherford@google.com>, liran@amazon.com
References: <62918f65ec78f8990278a6a0db0567968fa23e49.camel@infradead.org>
 <017de9019136b5d2ec34132b96b9f0273c21d6f1.camel@infradead.org>
 <20201125211955.GA450871@google.com>
 <99a9c1dfbb21744e5081d924291d3b09ab055813.camel@infradead.org>
 <95c0c9a01ea9692b3b18ac677d7e7c6e7636bfe4.camel@infradead.org>
 <26940473-6bd0-fc2b-f9bd-35a6a502baff@redhat.com>
 <6e7060415fe321a3969a76330b643116a5ab44d1.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH] Fix split-irqchip vs interrupt injection window
 request.
Message-ID: <49d8ac07-1745-e2af-a3a2-a0d8010c3914@redhat.com>
Date:   Fri, 27 Nov 2020 05:37:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <6e7060415fe321a3969a76330b643116a5ab44d1.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/11/20 22:48, David Woodhouse wrote:
> Although I do kind of like the symmetry of my original version using
> kvm_cpu_has_injectable_intr(), which is the condition used in
> vcpu_enter_guest() for enabling the interrupt window vmexit in the
> first place. It makes sense for those to match.

In inject_pending_event, actually.

However there's also an interrupt window request in vcpu_enter_guest():

         bool req_int_win =
                 dm_request_for_irq_injection(vcpu) &&
                 kvm_cpu_accept_dm_intr(vcpu);

and this one definitely should indeed stay in sync with 
kvm_vcpu_ready_for_interrupt_injection.  This gives an even neater 
version of the patch:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 447edc0d1d5a..a05a2be05552 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4052,7 +4052,8 @@ static int kvm_vcpu_ioctl_set_lapic(struct 
kvm_vcpu *vcpu,
  static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
  {
  	return (!lapic_in_kernel(vcpu) ||
-		kvm_apic_accept_pic_intr(vcpu));
+		(kvm_apic_accept_pic_intr(vcpu)
+		 && !pending_userspace_extint(vcpu));
  }

  /*
@@ -4064,7 +4065,6 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu 
*vcpu)
  static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
  {
  	return kvm_arch_interrupt_allowed(vcpu) &&
-		!kvm_cpu_has_interrupt(vcpu) &&
  		!kvm_event_needs_reinjection(vcpu) &&
  		kvm_cpu_accept_dm_intr(vcpu);
  }

or even better:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 447edc0d1d5a..adbb519eece4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4051,8 +4051,10 @@ static int kvm_vcpu_ioctl_set_lapic(struct 
kvm_vcpu *vcpu,

  static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
  {
-	return (!lapic_in_kernel(vcpu) ||
-		kvm_apic_accept_pic_intr(vcpu));
+	if (lapic_in_kernel(vcpu))
+		return !v->arch.interrupt.injected;
+
+	return !kvm_cpu_has_extint(vcpu);
  }

  /*
@@ -4064,8 +4066,6 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu 
*vcpu)
  static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
  {
  	return kvm_arch_interrupt_allowed(vcpu) &&
-		!kvm_cpu_has_interrupt(vcpu) &&
-		!kvm_event_needs_reinjection(vcpu) &&
  		kvm_cpu_accept_dm_intr(vcpu);
  }


since the call to kvm_event_needs_reinjection(vcpu) isn't really needed 
(maybe it was when Matt sent his original patches, but since then 
inject_pending_event has seen a significant overhaul).

Now this second possibility is very similar to Sean's suggestion, but 
it's actually code that I can understand.

> We enable the irq window if kvm_cpu_has_injectable_intr() or if
> userspace asks. And when the exit happens, we feed it to userspace
> unless kvm_cpu_has_injectable_intr().

What I don't like about it is that kvm_cpu_has_injectable_intr() has the 
more complicated handling of APIC interrupts.  By definition they don't 
matter here, we're considering whether to exit to userspace.

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C5A2C24B5
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 12:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732939AbgKXLjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 06:39:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727909AbgKXLjU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 06:39:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606217958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cOW9AP+FtQ6fH8fJ2Y4lCPfEd3mcrYQ9tsXTICs0PAo=;
        b=VV/5M6BFXMSEPwGw01JCkoQeFBDiftG5Mm09qMQENlQqBAc6S96LJv1Huda5f8fZjHxIbL
        HjTurlcgdvuVhr7KuSnTk1XTYQSi9kz2FdAXbsNT9LCwlDu4htNuNbRzJ23tq7UJafr9Ap
        ufyV8ZoKWdMYEFIAGpiGQGFgIbFDiNQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-jmW_GPTJNje9Hd6aHFWICw-1; Tue, 24 Nov 2020 06:39:16 -0500
X-MC-Unique: jmW_GPTJNje9Hd6aHFWICw-1
Received: by mail-wm1-f72.google.com with SMTP id v5so565552wmj.0
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 03:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cOW9AP+FtQ6fH8fJ2Y4lCPfEd3mcrYQ9tsXTICs0PAo=;
        b=mu/1OzOCxHjDQaRhgW8m+YzPpiWTdgtZ6UMjdfqgYLLhU2wFnmJnZAjvHtlvgfV3yO
         cJqJZlGs4o0Xuc+MVsXoF8/giWnX3jCUBj5eTtyrPuBWGtQh+QiAESkr5Oeof4GGz/5v
         VHVZskJrFIQyop6eFDTisdFR6vWHA+h6AQZb9o/TdM4fHjowh1mYeLVneZYFOttA0nBs
         qLE6nCsINs10gGUqrK0fSnINZhE1Uy3DtDUbPeSgyxuD0Tlc5HraJqMlLJgyx9jjigJR
         xla8xo6VZdXIh8Z1rVV2KjbuD0G/i2hKSPX7SxaBgCI3YIyYI1/at0yS3Z9fy1vCbp9G
         f/pA==
X-Gm-Message-State: AOAM533+2SEN9hWZpK6jxbjNEVkujwd6wRQgKQarjz7bxdSlcpsLQJ24
        zuj5DQAT17NDF8GMZYNVm4efyw8bjIncV8YOE+UiPQyIAckk5CH70jN3lpAe8wpPqM+Hy4KBkJI
        XDeFzhl0k1y19
X-Received: by 2002:a05:600c:256:: with SMTP id 22mr3884634wmj.120.1606217955032;
        Tue, 24 Nov 2020 03:39:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzd9llsbqF1ljSG18UayZZuFeWBhytEu3y8vCr1yADhBxuwV30iStuF+qpotJTMGR5f4aqR3g==
X-Received: by 2002:a05:600c:256:: with SMTP id 22mr3884618wmj.120.1606217954799;
        Tue, 24 Nov 2020 03:39:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z189sm4959465wme.23.2020.11.24.03.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 03:39:14 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     idan.brown@oracle.com, Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
Date:   Tue, 24 Nov 2020 12:39:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124015515.GA75780@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/20 02:55, Sean Christopherson wrote:
>>> I believe there is a 1-to-many relationship here, which is why I said
>>> each CPU would need to maintain a linked list of possible vCPUs to
>>> iterate and find the intended recipient.
> 
> Ya, the concern is that it's theoretically possible for the PINV to arrive in L0
> after a different vCPU has been loaded (or even multiple different vCPUs).
> E.g. if the sending pCPU is hit with an NMI after checking vcpu->mode, and the
> NMI runs for some absurd amount of time.  If that happens, the PINV handler
> won't know which vCPU(s) should get an IRQ injected into L1 without additional
> tracking.  KVM would need to set something like nested.pi_pending before doing
> kvm_vcpu_trigger_posted_interrupt(), i.e. nothing really changes, it just gets
> more complex.

Ah, gotcha.  What if IN_GUEST_MODE/OUTSIDE_GUEST_MODE was replaced by a 
generation count?  Then you reread vcpu->mode after sending the IPI, and 
retry if it does not match.

To guarantee atomicity, the OUTSIDE_GUEST_MODE IN_GUEST_MODE 
EXITING_GUEST_MODE READING_SHADOW_PAGE_TABLES values would remain in the 
bottom 2 bits.  That is, the vcpu->mode accesses like

	vcpu->mode = IN_GUEST_MODE;

	vcpu->mode = OUTSIDE_GUEST_MODE;

	smp_store_mb(vcpu->mode, READING_SHADOW_PAGE_TABLES);

	smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);

	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);

becoming

	enum {
		OUTSIDE_GUEST_MODE,
		IN_GUEST_MODE,
		EXITING_GUEST_MODE,
		READING_SHADOW_PAGE_TABLES,
		GUEST_MODE_MASK = 3,
	};

	vcpu->mode = (vcpu->mode | GUEST_MODE_MASK) + 1 + IN_GUEST_MODE;

	vcpu->mode &= ~GUEST_MODE_MASK;

	smp_store_mb(vcpu->mode, vcpu->mode|READING_SHADOW_PAGE_TABLES);

	smp_store_release(&vcpu->mode, vcpu->mode & ~GUEST_MODE_MASK);

	int x = READ_ONCE(vcpu->mode);
	do {
		if ((x & GUEST_MODE_MASK) != IN_GUEST_MODE)
			return x & GUEST_MODE_MASK;
	} while (!try_cmpxchg(&vcpu->mode, &x,
			      x ^ IN_GUEST_MODE ^ EXITING_GUEST_MODE))
	return IN_GUEST_MODE;

You could still get spurious posted interrupt IPIs, but the IPI handler 
need not do anything at all and that is much better.

> if we're ok with KVM
> processing virtual interrupts that technically shouldn't happen, yet.  E.g. if
> the L0 PINV handler consumes vIRR bits that were set after the last PI from L1.

I actually find it curious that the spec promises posted interrupt 
processing to be triggered only by the arrival of the posted interrupt 
IPI.  Why couldn't the processor in principle snoop for the address of 
the ON bit instead, similar to an MWAIT?

But even without that, I don't think the spec promises that kind of 
strict ordering with respect to what goes on in the source.  Even though 
posted interrupt processing is atomic with the acknowledgement of the 
posted interrupt IPI, the spec only promises that the PINV triggers an 
_eventual_ scan of PID.PIR when the interrupt controller delivers an 
unmasked external interrupt to the destination CPU.  You can still have 
something like

	set PID.PIR[100]
	set PID.ON
					processor starts executing a
					 very slow instruction...
	send PINV
	set PID.PIR[200]
					acknowledge PINV

and then vector 200 would be delivered before vector 100.  Of course 
with nested PI the effect would be amplified, but it's possible even on 
bare metal.

Paolo


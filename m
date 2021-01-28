Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060CA30764E
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 13:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhA1MpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 07:45:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231153AbhA1MpQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 07:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611837829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6DZ4ZGB2K4gNRDZAoppW1Ow33ypz6eIahutEvlIJxKQ=;
        b=T32p6CYkz6V0rJQd3/1rBHRW+fetzSw9ybLCXisi3KZr0O+uxOXt472J6iMAUjffcEzA2P
        GwxR9d9847OXvpzMPNOcBjTsRC8IPS0E6aKE45CMijEtk6mQBriHc4YIEvNOIO3i2Uc/wx
        pQZkq0nNj3SyAhWKNHo2IiYLUTEXcPI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-Z1FNZieoO0m6wHe1QFAyLA-1; Thu, 28 Jan 2021 07:43:47 -0500
X-MC-Unique: Z1FNZieoO0m6wHe1QFAyLA-1
Received: by mail-ed1-f72.google.com with SMTP id j11so3098771edy.20
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 04:43:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6DZ4ZGB2K4gNRDZAoppW1Ow33ypz6eIahutEvlIJxKQ=;
        b=tju3Nei2gQV+a/SfouM4P95itHuaXfQG50d6E5dE7iaB5PzPw7nrJthfCu8CGcnnpD
         WrcdCosyvoV+0cCUl3a7X7q3qrcbACgiEGfV2LBmTcm5fTVStW6ZaEz/CP5IFV7qk8Eq
         WfHJinIc70VUgtHBH/R/QqeFySnELleTveTjbU8MK54LIbuFFZnEXLzjfapHY9jZqRKl
         7qetBPNJQmdRDD75z5LDWtTfitWfazjlzBVrzTGqKUESZi3kdDBoZWIQx+g0xal827Ub
         Mh9fm2shkYWZ7+pmssqSytvQnzeKpIhJRU7UFT1sKSoCSqo+Wd3cImMU/pc8oBHoU2I6
         Cbww==
X-Gm-Message-State: AOAM532r8e1vOi9zc1Ib+ulOqpFhUmkyxLDTLUZWeGwv1k/D0bJwLm96
        UfsTVSrCTzuhIykSVn3u1DvB3gndUlTg2DvaWmbMooUp5tPXprCu7FwSjFLOc5J4fIm8Es0/6DW
        gkvx6BptBUXop
X-Received: by 2002:a17:906:86d7:: with SMTP id j23mr2899526ejy.5.1611837825739;
        Thu, 28 Jan 2021 04:43:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+7/aR0IkMr58q3tYOY3lcSzuiW99RFZBU+INUV4hn06MVyWygwy1ypwPKJpZZ361fX9OJhQ==
X-Received: by 2002:a17:906:86d7:: with SMTP id j23mr2899508ejy.5.1611837825503;
        Thu, 28 Jan 2021 04:43:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m8sm2971028eds.70.2021.01.28.04.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 04:43:44 -0800 (PST)
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
 <20210111195725.4601-17-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 16/16] KVM: x86/xen: Add event channel interrupt vector
 upcall
Message-ID: <3b66ee62-bf12-c6ab-a954-a66e5f31f109@redhat.com>
Date:   Thu, 28 Jan 2021 13:43:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111195725.4601-17-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/21 20:57, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> It turns out that we can't handle event channels *entirely* in userspace
> by delivering them as ExtINT, because KVM is a bit picky about when it
> accepts ExtINT interrupts from a legacy PIC. The in-kernel local APIC
> has to have LVT0 configured in APIC_MODE_EXTINT and unmasked, which
> isn't necessarily the case for Xen guests especially on secondary CPUs.
> 
> To cope with this, add kvm_xen_get_interrupt() which checks the
> evtchn_pending_upcall field in the Xen vcpu_info, and delivers the Xen
> upcall vector (configured by KVM_XEN_ATTR_TYPE_UPCALL_VECTOR) if it's
> set regardless of LAPIC LVT0 configuration. This gives us the minimum
> support we need for completely userspace-based implementation of event
> channels.
> 
> This does mean that vcpu_enter_guest() needs to check for the
> evtchn_pending_upcall flag being set, because it can't rely on someone
> having set KVM_REQ_EVENT unless we were to add some way for userspace to
> do so manually.
> 
> But actually, I don't quite see how that works reliably for interrupts
> injected with KVM_INTERRUPT either. In kvm_vcpu_ioctl_interrupt() the
> KVM_REQ_EVENT request is set once, but that'll get cleared the first time
> through vcpu_enter_guest(). So if the first exit is for something *else*
> without interrupts being enabled yet, won't the KVM_REQ_EVENT request
> have been consumed already and just be lost?

If the call is for something else and there is an interrupt, 
inject_pending_event sets *req_immediate_exit to true.  This causes an 
immediate vmexit after vmentry, and also schedules another KVM_REQ_EVENT 
processing.

If the call is for an interrupt but you cannot process it yet (IF=0, 
STI/MOVSS window, etc.), inject_pending_event calls 
kvm_x86_ops.enable_irq_window and this will cause KVM_REQ_EVENT to be 
sent again.

How do you inject the interrupt from userspace?  IIRC 
evtchn_upcall_pending is written by the hypervisor upon receiving a 
hypercall, so wouldn't you need the "dom0" to invoke a KVM_INTERRUPT 
ioctl (e.g. with irq == 256)?  That KVM_INTERRUPT will set KVM_REQ_EVENT.

If you want to write a testcase without having to write all the 
interrupt stuff in the selftests framework, you could set an IDT that 
has room only for 128 vectors and use interrupt 128 as the upcall 
vector.  Then successful delivery of the vector will cause a triple fault.

Independent of the answer to the above, this is really the only place 
where you're adding Xen code to a hot path.  Can you please use a 
STATIC_KEY_FALSE kvm_has_xen_vcpu (and a static inline function) to 
quickly return from kvm_xen_has_interrupt() if no vCPU has a shared info 
set up?

That is, something like

- when first setting vcpu_info_set to true, 
static_key_slow_inc(&kvm_has_xen_vcpu.key)

- when destroying a vCPU with vcpu_info_set to true, 
static_key_slow_dec_deferred(&kvm_has_xen_vcpu)

- rename kvm_xen_has_interrupt to __kvm__xen_has_interrupt

- add a wrapper that usese the static key to avoid the function call

static int kvm_xen_has_interrupt(struct kvm_vcpu *v)
{
	if (static_branch_unlikely(&kvm_has_xen_vcpu.key))
		return __kvm_xen_has_interrupt(v);

	return false;
}

Paolo


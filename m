Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE69F307BC0
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhA1RGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:06:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232850AbhA1RD0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:03:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611853319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dNqpVKrruT0OYPB8AFxCtPqgE/f8WBY7RjXAPaCWLGo=;
        b=MXBzhLdkfrUqCf4qqSr/JwkpYUmMSgJ0mLPJP321QcWxeYc+z9ERUjmyl4teDsiSbIZqJE
        PbOByCzaw9GV43DrSameFzyr4t0N/OYiReNUeAgzHpBuiP6Ry5+fB4TBNdwZex/tSs/u4l
        7asvOhEA1L5fnCKvXmk+R/SZoVqQqlo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-rjJbkrFPPiOLqvt6yB_bHw-1; Thu, 28 Jan 2021 12:01:57 -0500
X-MC-Unique: rjJbkrFPPiOLqvt6yB_bHw-1
Received: by mail-ej1-f69.google.com with SMTP id ox17so2468802ejb.2
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:01:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dNqpVKrruT0OYPB8AFxCtPqgE/f8WBY7RjXAPaCWLGo=;
        b=lr+BMsZVxr3FLcY3zwTF5pphXugKr+x93HNaHN1a85JyvH/ImuZG2JDG2rHwF+rY/1
         p6Uv95vq8vELYzAivWwnHnM6Cf9Q9MKcl+yVUpanlyMSKIthcmwdglHoVE9oJstJvv+y
         sPcs66L8Cauo81GYDnHLI9AJllp6MCJi0obXmnN+Nhf6mPGEDlnoiolxUiA9WkcaRG4Y
         8ZPNl4QE3SMoFclLGovz14+5h7ViBED1V5joqa4DHwvA/nSJ6mhEoAPZx74zzYKXKhxm
         BoOxAPA/sx8/iMei6kcjxmd6w6u3UkfwyQNujovDyNYjA6GaoncSERWE/KrskXEifgfK
         oY0Q==
X-Gm-Message-State: AOAM530ruzzVB5JOHTYmu3mspFeF87/L7y0kGnPp5wE2f4V0vucQ2vSB
        qJ0VkEMmiuUH+K1wgZ3BkrDzGzJ8+jSmOOADlETy2GJ5olkOqaD1DTt8q8enXCyjpuVf3qBSrxR
        Af7glTjPmt4mv
X-Received: by 2002:a17:906:8057:: with SMTP id x23mr314876ejw.179.1611853316654;
        Thu, 28 Jan 2021 09:01:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxujK/eaJ0fC/FD3LRg0rWCLiz0wykO6Jm1x6t4ZzQzFsnaTWCYrVGTOqNvGylJCvMZbW2tPw==
X-Received: by 2002:a17:906:8057:: with SMTP id x23mr314856ejw.179.1611853316414;
        Thu, 28 Jan 2021 09:01:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id qq11sm2593217ejb.74.2021.01.28.09.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:01:55 -0800 (PST)
Subject: Re: [PATCH v5 16/16] KVM: x86/xen: Add event channel interrupt vector
 upcall
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
 <20210111195725.4601-17-dwmw2@infradead.org>
 <3b66ee62-bf12-c6ab-a954-a66e5f31f109@redhat.com>
 <0f210bea8a8d800f5a36c8ac8abbcc4b0dd6c02c.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2be48efc-4832-86ee-053a-b9858f7065c0@redhat.com>
Date:   Thu, 28 Jan 2021 18:01:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <0f210bea8a8d800f5a36c8ac8abbcc4b0dd6c02c.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 16:35, David Woodhouse wrote:
> Well, right now that would return -EINVAL, so you're suggesting we add
> a special case code path to kvm_vcpu_ioctl_interrupt which just sets
> KVM_REQ_EVENT without calling kvm_queue_interrupt(), in the case where
> irq->irq == KVM_NR_INTERRUPTS?
> 
> Then we require that the userspace VMM make that ioctl not only when
> it's set ->evtchn_upcall_pending for itself, but *also*  poll for the
> guest having done so?

Hmm, right I forgot that the guest can do it for itself.  So the static 
key would be enough.

Paolo

> In fact, not only the VMM would have to do that polling, but we'd
> probably also have to do it on any hypercalls we accelerate in the
> kernel (as we're planning to do for IPIs, etc.)
> 
> So it has to live in the kernel anyway in*some*  form.


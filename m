Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B40314C69
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 11:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhBIKD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 05:03:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbhBIKA4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 05:00:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612864768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oO1f5647hsAczgPitl7kz7N8UDajjSDNwFp1vlB/YpA=;
        b=ejwfw+8fL/ZLGkF3g8XHQXDCLa48+MPUKMJBA4FoMTV/CM909ZameopZ/1qCiCW/vgjjMC
        E8GhjKG7Jsb5WnCuYWja4Zen2uPCUhBlxei2p0xs709mZUCNq/dcRjcIwy2qG2WJigiQ4V
        1IP2gjG8NEGsSr5kWXVP0DzLzdmqTDM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-4wRz8kvdPcmshAakYyC-9Q-1; Tue, 09 Feb 2021 04:59:27 -0500
X-MC-Unique: 4wRz8kvdPcmshAakYyC-9Q-1
Received: by mail-wm1-f72.google.com with SMTP id u138so1967429wmu.8
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 01:59:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oO1f5647hsAczgPitl7kz7N8UDajjSDNwFp1vlB/YpA=;
        b=XClYTAPFyIkYg6mLGVcaaM+UTKRrc0/yuI9z/AM5QWchQ9W+kmQjMtddXT4fHOFpnB
         NlbMsSVlcoWydyGgqxa+7AXdzhocCIAe8s8cNy7P6XlnRLhyrP7jAxnuUzHMdwYKECy5
         s2yT66N+fVQN8vNW5an+f/mcTJLQGkct5GYD9YqhVjtnbHHDB+YpgjIcfXYJB4s6qTQU
         R3g9R8TaiZte1flO+LVTqEc/nlrssZZDtXSNCUxGDTeMy4TUlxzncGpgVyQ552xoYMOv
         yF/IgCFNTptzLH8Bj0vl9QHw0NfnPOfKYJYAmjxTK3/BVd7D3mZ8xGp9VfgGIadocDVN
         T7YA==
X-Gm-Message-State: AOAM532Ar73s434zIrwPpyCAFbaJQwZ048NSjVVF/9FePAahWb2k2jZ/
        kQGAHPLAM5Ydhq07GbUbtVqrUPv4YVM8uE9WdXvVI6K9r+3/UpNmxPJ2pV/ImmX/GzBoREpvfB8
        dsRXUL+JeS+Gn
X-Received: by 2002:a5d:6b42:: with SMTP id x2mr24418006wrw.117.1612864765891;
        Tue, 09 Feb 2021 01:59:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzM8qBjqR+eGX3TOgQT9VWnFduZZQc47+PczDDZ5RPujawiDvqSfdFtLTaR4fFygtEt+uYCrQ==
X-Received: by 2002:a5d:6b42:: with SMTP id x2mr24417986wrw.117.1612864765687;
        Tue, 09 Feb 2021 01:59:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i10sm10970458wrp.0.2021.02.09.01.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 01:59:24 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86/xen: Remove extra unlock in
 kvm_xen_hvm_set_attr()
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210208232326.1830370-1-dwmw2@infradead.org>
 <20210208232326.1830370-2-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <68477034-8080-061c-41f8-fe08efe1d4c4@redhat.com>
Date:   Tue, 9 Feb 2021 10:59:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208232326.1830370-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/21 00:23, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> This accidentally ended up locking and then immediately unlocking kvm->lock
> at the beginning of the function. Fix it.
> 
> Fixes: a76b9641ad1c ("KVM: x86/xen: add KVM_XEN_HVM_SET_ATTR/KVM_XEN_HVM_GET_ATTR")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 06fec10ffc4f..d8cdd84b1c0e 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -105,8 +105,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>   
>   	mutex_lock(&kvm->lock);
>   
> -	mutex_unlock(&kvm->lock);
> -
>   	switch (data->type) {
>   	case KVM_XEN_ATTR_TYPE_LONG_MODE:
>   		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
> 

Queued both, thanks.

Paolo


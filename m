Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C35330E06F
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhBCRC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 12:02:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231530AbhBCRBL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 12:01:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612371579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XRU34nssYbCmuSXArQDVgrkQuF5BdhsW0MaIJFyN85A=;
        b=G5dZ6tFnvKMv+88mTD8eqc4zZcpE81aeUgDXhY5dZMI4AODdM7nM7ZL3DmrzVMf4c6x+bg
        Ar7GEqBip9ZKzjWNPd9azYJXifUgJWrcfBmoDSzwriCIhqm4fnboK3lswRaM2N7kooMhz3
        789JUmUaTBPPYFBvP14Kv4BunPG+O1k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8--kHLpSeYNK6RnveB_eqwig-1; Wed, 03 Feb 2021 11:59:37 -0500
X-MC-Unique: -kHLpSeYNK6RnveB_eqwig-1
Received: by mail-ej1-f70.google.com with SMTP id jg11so59592ejc.23
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 08:59:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XRU34nssYbCmuSXArQDVgrkQuF5BdhsW0MaIJFyN85A=;
        b=XqSEuGftUwUWugLB4T9qPBKu0ANc15uoTgpprvnJsT5XslgTM5QFKqiOfhDNSciCEc
         vhpatKq4LWkumD7M0S3a2Uuog/N/CS7Q2F/ThiNreyv6F8yKQiHatJhldjwYsEmu2v8b
         khkUZZ2eVi7Pq6GQNVi9TxU6z8tPVZ+QHecnudMd0oXbZj40C2CnKJkBXtNmrUjKKXrY
         AsH29PfBNEEhgwQPRwdzuyd+Ey9lXT7bk776WXA4ycMnSs0QTpmqo/aEDztWZeLtlEZj
         QDgQHtZFOJKitEHUxdEKCXArqBVEHoE6gfj9CWiGiHgFDr57AwetjkFErIzGkBPAWe5d
         VQfw==
X-Gm-Message-State: AOAM533Cn2uBNQGARsmEczQFnw6+ax4JaD/fDTDbCZqMiUAj9/1txwiO
        69jyfw5FZNIFVd2UyNTdP5AQbMEfVsR6V+WUnLVVmgxK/OZoIaMxglq/3fRiKMNgxVE8DIJEzZI
        m+27rsHl8m1gl
X-Received: by 2002:a50:fc18:: with SMTP id i24mr4102704edr.308.1612371575688;
        Wed, 03 Feb 2021 08:59:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJJsUWG8d3XAFzrqG/Cke83I76i2s1qv+As/o+EQgvA+OVcAUDyb1B38Ln9ShYJdQzL/tiEQ==
X-Received: by 2002:a50:fc18:: with SMTP id i24mr4102681edr.308.1612371575478;
        Wed, 03 Feb 2021 08:59:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id df15sm1071359edb.24.2021.02.03.08.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 08:59:34 -0800 (PST)
Subject: Re: [PATCH v6 00/19] KVM: Add minimal support for Xen HVM guests
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210203150114.920335-1-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aaa02510-f2af-f7d1-7af3-94297f43e282@redhat.com>
Date:   Wed, 3 Feb 2021 17:59:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 16:00, David Woodhouse wrote:
> 
> This patch set provides enough kernel support to allow hosting Xen HVM
> guests in KVM. It allows hypercalls to be trapped to userspace for
> handling, uses the existing KVM functions for writing system clock and
> pvclock information to Xen shared pages, and event channel upcall vector
> delivery.
> 
> It's based on the first section of a patch set that Joao posted as
> RFC last year^W^W in 2019:
> 
> https://lore.kernel.org/kvm/20190220201609.28290-1-joao.m.martins@oracle.com/
> 
> In v6 I've dropped the runstate support temporarily. It can come in the
> next round of patches, and I want to give it more thought. In particular
> Paul pointed out that we need to support VCPUOP_get_runstate_info — the
> runstate times aren't *only* exposed to a guest by putting them directly
> into the guest memory. So we'll need an ioctl to fetch them to userspace
> as well as to set them on live migration. I've expanded the padding in
> the newly added KVM_XEN_VCPU_[SG]ET_ATTR ioctls to make sure there's
> room.
> 
> I also want to double-check we're setting the runstates faithfully as
> Xen guests will expect in all circumstances. I think we may want a way
> for userspace to tell the kernel to set RUNSTATE_blocked and offline,
> and that can be set as a vCPU attr too.
> 
> Will work on that and post it along with the oft-promised second round,
> but this part stands alone and should be ready to merge.
> 
> The rust-vmm support for this is starting to take shape at
> https://github.com/alexandruag/vmm-reference/commits/xen

It passes the self tests, after fixing the self tests to compile, so it 
must be perfect.  Oh wait. :)

Seriously: this is very nice work.  I agree with Christoph that it 
should be possible to hide it with Kconfig, but I can take care of that 
and it need not block the inclusion in linux-next.

I've queued it to kvm/queue for now; as soon as the integration tests 
finish (the amount of new stuff in 5.12 is pretty scary), it will be in 
kvm/next too.

Thanks very much!

Paolo


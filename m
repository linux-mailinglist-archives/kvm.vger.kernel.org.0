Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A7B3075D7
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 13:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhA1MUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 07:20:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231346AbhA1MTu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 07:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611836302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TIBSGINAksuEgDksDAhK8QlccAX1deRKqkCRjek795s=;
        b=PEisd3/jkmnzeOrd99Y6lIDK0shbAxGIJ7Jlexxyco1EcHahjF9+iWZfTARSKc0n4BbH66
        MnFaNUCjDvmXeZ6bvLBb+sk5BhovHo42EVgT6IKI2YIGIS+HLw/eDKDvQDpybGS3C+8ed1
        WBa4PEixKtyHHQ4IqoB3dMDhZg4l14s=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-wN536P7HMKu9abPLJ7gL6A-1; Thu, 28 Jan 2021 07:18:20 -0500
X-MC-Unique: wN536P7HMKu9abPLJ7gL6A-1
Received: by mail-ej1-f69.google.com with SMTP id h18so2092346ejx.17
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 04:18:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TIBSGINAksuEgDksDAhK8QlccAX1deRKqkCRjek795s=;
        b=fgxLaFo4Y0tayslOQNNeV+H8AtVtkkGC+ZaFMthRPkfaQpNbDzdOFd2z44+XyfW057
         u24WKxScikHPaAMSRxlHXUjKJayXQgwwSl3Ba7YYYgdU+83CG7FCt6s0cgKC47OAn8UR
         +mpQNtO7vE8MCI3F1ZI/rMwYBQsgoWwaCRcRKpV4z5WYeC9KfFkQdtXROuYrFJXPC6VC
         WUZLACgPqKLhR/g9ZVZQTjIjWm6PGQbwg9CHUbLcygB1YWHNKxOoAP5CMVmimAaRb3gV
         YKrbQ672Gavz0WuVAM6leCA8nlxdO47fpQsNzQqO3Xua1UZ5B07WkIo6f167n2pk5MZ8
         tv+A==
X-Gm-Message-State: AOAM5307s01Tf+PrudihwUPvPtsrZz85TgheRMUdhUTBC+JVlKgvyDZo
        ybRUj3yN5G/9sUWQ8Ej3d1Nr+VI4fTJz2/J/Am/wVrl65jon1Q3NOXHi92OS2RZ8uVSwTU8lBR9
        Bh4GclbTUtuiM
X-Received: by 2002:a17:907:3e04:: with SMTP id hp4mr11222098ejc.188.1611836299186;
        Thu, 28 Jan 2021 04:18:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZRaqPYODIOHDRhDycgvl32QXdnyGtpOjEwmrtwjkTnR8T/edmJ6m0clNLLIrK8cVaYj45ag==
X-Received: by 2002:a17:907:3e04:: with SMTP id hp4mr11222086ejc.188.1611836299022;
        Thu, 28 Jan 2021 04:18:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e22sm2236929ejd.79.2021.01.28.04.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 04:18:18 -0800 (PST)
Subject: Re: [PATCH v5 15/16] KVM: Add documentation for Xen hypercall and
 shared_info updates
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210111195725.4601-1-dwmw2@infradead.org>
 <20210111195725.4601-16-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e79d508e-454f-f34e-018b-e6b63fe3d825@redhat.com>
Date:   Thu, 28 Jan 2021 13:18:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111195725.4601-16-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/21 20:57, David Woodhouse wrote:
> 
> +
> +KVM_XEN_ATTR_TYPE_LONG_MODE
> +  Sets the ABI mode of the VM to 32-bit or 64-bit (long mode). This
> +  determines the layout of the shared info pages exposed to the VM.
> +
> +KVM_XEN_ATTR_TYPE_SHARED_INFO
> +  Sets the guest physical frame number at which the Xen "shared info"
> +  page resides. Note that although Xen places vcpu_info for the first
> +  32 vCPUs in the shared_info page, KVM does not automatically do so
> +  and requires that KVM_XEN_ATTR_TYPE_VCPU_INFO be used explicitly
> +  even when the vcpu_info for a given vCPU resides at the "default"
> +  location in the shared_info page. This is because KVM is not aware
> +  of the Xen CPU id which is used as the index into the vcpu_info[]
> +  array, so cannot know the correct default location.
> +
> +KVM_XEN_ATTR_TYPE_VCPU_INFO
> +  Sets the guest physical address of the vcpu_info for a given vCPU.
> +
> +KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO
> +  Sets the guest physical address of an additional pvclock structure
> +  for a given vCPU. This is typically used for guest vsyscall support.
> +
> +KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE
> +  Sets the guest physical address of the vcpu_runstate_info for a given
> +  vCPU. This is how a Xen guest tracks CPU state such as steal time.
> +

My only qualm is really that the userspace API is really ugly.

Can you just have both a VM and a VCPU ioctl (so no vcpu_id to pass!), 
add a generous padding to the struct, and just get everything out with a 
single ioctl without having to pass in a type?

Paolo


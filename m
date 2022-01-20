Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E79494BDA
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 11:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376328AbiATKif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 05:38:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241959AbiATKie (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 05:38:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642675113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFpN3f0uduDA3tQ7l5sXIVy8xoN2m2qwc3s/2ZpwE2I=;
        b=TwvzgGXFzGfgd/FnDdeQydO62Zg1LpaukzGZtZmAawP+P0e7wExOM52uf7+Swjwe8GSwA/
        /wGefQ+Mtp9Fh/dn8iJgyOmwHA5HyheBDdY8wwMpUnctttECZJmUXuhOsDccsYdpCv1RzY
        0yVH7P2XJlGGCDpCZN9LQxxkzfuAMaw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-wYD9jJieNc2CVEzoWd0qbw-1; Thu, 20 Jan 2022 05:38:32 -0500
X-MC-Unique: wYD9jJieNc2CVEzoWd0qbw-1
Received: by mail-wm1-f71.google.com with SMTP id a3-20020a05600c348300b0034a0dfc86aaso6490808wmq.6
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 02:38:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sFpN3f0uduDA3tQ7l5sXIVy8xoN2m2qwc3s/2ZpwE2I=;
        b=kn2XZMWki2WeMUxtnSGEdj1z2U6B1i7/zfdZo6t0Z9pC5H6X7gIyG6thrQ4x430Pg9
         6DcGnGB9YHEOsK1c8sohdNETajha32Zkj+3jva2szLTqY8H7+GNzNQ9Fft7jumxIbRon
         aGDHgg7AOWcu9xoP/M7Id6qFbTa5KN/SkZ6osLk1yCJJSd4IpxAYEWN1JL7iT0WSXH7e
         Tm8E5KB2SLpNf13YA2FPyCbWVnQyVxzufoZ53/pvc69R8+5qa3WvhLvCA2PfEgjqwLaE
         zm7nvxW9ViUUh8OfiYSLpsXp9LcUqJT1eLy/YRLkfuKKNkaH3UVm8nKm3D/32I2KFvA2
         QyfQ==
X-Gm-Message-State: AOAM531AJzFNZc3F7+SmhbpjiIm+qUQFyMUwnHXUUAKn79y1aJJdsiyq
        k1+GmhbRfJR9gcxBqsLIVi/sFrqAJ/H6efeQ9/pIrDUX2v3zBTuKeUa1pL9QutvkvTW7J3g+4xM
        mIYUyBDrZJgvU
X-Received: by 2002:a05:6000:152:: with SMTP id r18mr3963421wrx.598.1642675111343;
        Thu, 20 Jan 2022 02:38:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfvIX06o0KrIvdE4knevl3OSMRO8haaYDO1DIVACVjH75Q5KDVwCs2c7eUgWYh9T6sdMZ1nw==
X-Received: by 2002:a05:6000:152:: with SMTP id r18mr3963404wrx.598.1642675111135;
        Thu, 20 Jan 2022 02:38:31 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id n10sm1005966wrf.96.2022.01.20.02.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 02:38:30 -0800 (PST)
Message-ID: <069c72b6-457f-65c7-652e-e6eca7235fca@redhat.com>
Date:   Thu, 20 Jan 2022 11:38:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-7-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220118095210.1651483-7-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2022 10.52, Janis Schoetterl-Glausch wrote:
> Channel I/O honors storage keys and is performed on absolute memory.
> For I/O emulation user space therefore needs to be able to do key
> checked accesses.
> The vm IOCTL supports read/write accesses, as well as checking
> if an access would succeed.
...
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index e3f450b2f346..dd04170287fd 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -572,6 +572,8 @@ struct kvm_s390_mem_op {
>   #define KVM_S390_MEMOP_LOGICAL_WRITE	1
>   #define KVM_S390_MEMOP_SIDA_READ	2
>   #define KVM_S390_MEMOP_SIDA_WRITE	3
> +#define KVM_S390_MEMOP_ABSOLUTE_READ	4
> +#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5

Not quite sure about this - maybe it is, but at least I'd like to see this 
discussed: Do we really want to re-use the same ioctl layout for both, the 
VM and the VCPU file handles? Where the userspace developer has to know that 
the *_ABSOLUTE_* ops only work with VM handles, and the others only work 
with the VCPU handles? A CPU can also address absolute memory, so why not 
adding the *_ABSOLUTE_* ops there, too? And if we'd do that, wouldn't it be 
sufficient to have the VCPU ioctls only - or do you want to call these 
ioctls from spots in QEMU where you do not have a VCPU handle available? 
(I/O instructions are triggered from a CPU, so I'd assume that you should 
have a VCPU handle around?)

  Thomas



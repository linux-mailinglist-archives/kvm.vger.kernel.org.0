Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA88279245
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgIYUhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:37:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726807AbgIYUdM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:33:12 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601065990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sot+/QGnyS6yekV7l/eBi6I0LwQeK7pgq37zj1y68LE=;
        b=Z/rDDF4pJ1Qx73dMTBT3glxoz3Kw+RZDRZ/OF3sYHwtK72uztz8ZlBRCY7T6UJtwnqU/Oq
        GpdLhH3P6tk5B405JMs4QWLqQvt/nm/iLbiMpXUUz6QotfQxM1RPpboy0wM269iizdw+o3
        LnBxhj0TTEh0imPOVT22PI0leM0AAWo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-eeG2-rzlNWuNbA-s7q9CNA-1; Fri, 25 Sep 2020 16:33:07 -0400
X-MC-Unique: eeG2-rzlNWuNbA-s7q9CNA-1
Received: by mail-wm1-f72.google.com with SMTP id m25so79670wmi.0
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 13:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sot+/QGnyS6yekV7l/eBi6I0LwQeK7pgq37zj1y68LE=;
        b=KH38KNT7UNP1IpC0C9k311tM8UKKDiFCqovnfy8aBelSqbehd0GPkRObfOVtTosVlj
         i/1EFOHyDGe4GRsIaBgWa/uvOQq9Y3RCbb9RoaumSeqLoo9nplTslLTmy/tfmXjbLIZ4
         gqNXnNHDMqps6R0Vs5Tu/DVig2f26oMjHIS3Rj5EMBesEyuZ5J2RCl9/ymm+pVCXI0Ma
         A3wGNHYup1ForJLCAfOvwBTdSvuanTQDUlH1Y/tt+IarWa6RS/2WB8xqCyNXUZP2l8Nu
         GTIMMUnWU5d+HkEkPKS8PGbkW4+Zh0fJZYrKzV+rzd0WjJOmmjD89lpLm+91HQHRwYWR
         jgYA==
X-Gm-Message-State: AOAM530YJe6UKAnRw9WLsKZGHbAb76VU2RggwwM9R9KHLqROFkJ3crFw
        uGs6RMLRZa1eXt5Ko36xFpniwLv4HSXZaa6UJ3NOOYQo2BuALvV53jcwzqCJLt3wsTTsu/jtTf3
        qc/zfFikvXqt+
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr286935wmc.143.1601065986053;
        Fri, 25 Sep 2020 13:33:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjmX4IdmpPgkCQcguVUy/ckV4Ql4y0Ql6TUZCqJVMEp5rK5WA4umqVmCC+6Ve6S+qGQxsBPg==
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr286914wmc.143.1601065985764;
        Fri, 25 Sep 2020 13:33:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id 9sm202984wmf.7.2020.09.25.13.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:33:05 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID
 more useful
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
References: <20200924145757.1035782-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3b4186ec-84dc-a146-6c0c-cbc62195beab@redhat.com>
Date:   Fri, 25 Sep 2020 22:33:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924145757.1035782-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 16:57, Vitaly Kuznetsov wrote:
> Changes since v1:
> - Rebased to kvm/queue [KVM_CAP_SYS_HYPERV_CPUID -> 188]
> 
> QEMU series using the feature:
> https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg02017.html
> 
> Original description:
> 
> KVM_GET_SUPPORTED_HV_CPUID was initially implemented as a vCPU ioctl but
> this is not very useful when VMM is just trying to query which Hyper-V
> features are supported by the host prior to creating VM/vCPUs. The data
> in KVM_GET_SUPPORTED_HV_CPUID is mostly static with a few exceptions but
> it seems we can change this. Add support for KVM_GET_SUPPORTED_HV_CPUID as
> a system ioctl as well.
> 
> QEMU specific description:
> In some cases QEMU needs to collect the information about which Hyper-V
> features are supported by KVM and pass it up the stack. For non-hyper-v
> features this is done with system-wide KVM_GET_SUPPORTED_CPUID/
> KVM_GET_MSRS ioctls but Hyper-V specific features don't get in the output
> (as Hyper-V CPUIDs intersect with KVM's). In QEMU, CPU feature expansion
> happens before any KVM vcpus are created so KVM_GET_SUPPORTED_HV_CPUID
> can't be used in its current shape.
> 
> Vitaly Kuznetsov (7):
>   KVM: x86: hyper-v: Mention SynDBG CPUID leaves in api.rst
>   KVM: x86: hyper-v: disallow configuring SynIC timers with no SynIC
>   KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID output independent
>     of eVMCS enablement
>   KVM: x86: hyper-v: always advertise HV_STIMER_DIRECT_MODE_AVAILABLE
>   KVM: x86: hyper-v: drop now unneeded vcpu parameter from
>     kvm_vcpu_ioctl_get_hv_cpuid()
>   KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
>   KVM: selftests: test KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
> 
>  Documentation/virt/kvm/api.rst                | 12 +--
>  arch/x86/include/asm/kvm_host.h               |  2 +-
>  arch/x86/kvm/hyperv.c                         | 30 ++++----
>  arch/x86/kvm/hyperv.h                         |  3 +-
>  arch/x86/kvm/vmx/evmcs.c                      |  8 +-
>  arch/x86/kvm/vmx/evmcs.h                      |  2 +-
>  arch/x86/kvm/x86.c                            | 44 ++++++-----
>  include/uapi/linux/kvm.h                      |  3 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |  2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++
>  .../selftests/kvm/x86_64/hyperv_cpuid.c       | 77 +++++++++----------
>  11 files changed, 120 insertions(+), 89 deletions(-)
> 

Queued patches 1-2 while we discuss the rest, thanks.

Paolo


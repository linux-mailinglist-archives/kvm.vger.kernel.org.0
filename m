Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD492A93FB
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgKFKTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:19:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgKFKTe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 05:19:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604657973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IEESCUKmdhXLSA4iMxhPM1Tip0ntZzoWBSXPRJnNCdE=;
        b=QoIiAsZJ8p8RngiQZOrhD0Sf4VAvgHYZG1d/rtzvcgiTFQQyievTNPC98v3yDFqudh6Uhd
        XvtheOy8foAHDnnF4twsSWVhcXN5MhClyZgexLNtYFumxrO2H0ovlL/nqhjDMiLv7SDtsm
        u82nHfL+cRBNxqCd2/FzbL2NApAI240=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-7QrF_Xb5PT2F343EJt4SPg-1; Fri, 06 Nov 2020 05:19:31 -0500
X-MC-Unique: 7QrF_Xb5PT2F343EJt4SPg-1
Received: by mail-wm1-f69.google.com with SMTP id o19so254617wme.2
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 02:19:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IEESCUKmdhXLSA4iMxhPM1Tip0ntZzoWBSXPRJnNCdE=;
        b=he43VhcRzhSyyxcnpX3sD9tQRDf0jAB7aTExaA24D2oFG3erN9mE9MUMgdwWOlGzPV
         wh2oOLnpY1i/g9dhIM6x9JehoA1xBlTMI9CvWvGuLa9AjSlg25qL9+a8eZ4HjCDXhcKP
         KSGonv+9g3O1qbYsE5flgaN69prdKieG7w3jLPe2szRyY0iz58qu3hA00vsJ4qPBBNSf
         CTbpRE//LeKeH0POcvNnEsrHO05LHxYzdn1B6Y0DgsI/Mhg4nDQqcWc8D0os7W1Rnvis
         uDNLRX/vfQ5+pAmtwp1vLRRCxul/Exu/KI+RXoPM3NxEpUmKWU4tsLCr9Bp5XUCfonc/
         Vcrw==
X-Gm-Message-State: AOAM533mYcBHYZ740bKfGfs9o0kv5pyuMcabTx7Knt6c0DBF3m+PYaNn
        G5CQ/1NtYlQZQLHlRnKwrkttXNBHVTpS5rOmwNrYBCyZp6ZSl+J1NVj4iAVO5pKbITAypfObo8m
        7J1cbNPWHewDf
X-Received: by 2002:a1c:9916:: with SMTP id b22mr1707709wme.105.1604657967386;
        Fri, 06 Nov 2020 02:19:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy4URoqcAcxLQZAfyqtAhP6FNfx4EsvO4UCAIcFJw0o3isANYzys7GBSVGJ0h8McO+dB+9NNw==
X-Received: by 2002:a1c:9916:: with SMTP id b22mr1707690wme.105.1604657967179;
        Fri, 06 Nov 2020 02:19:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h7sm1313311wrt.45.2020.11.06.02.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 02:19:26 -0800 (PST)
Subject: Re: [PATCH v3 0/2] KVM: x86: hyper-v: make KVM_GET_SUPPORTED_HV_CPUID
 more useful
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
References: <20200929150944.1235688-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dbe90b3a-bf0d-cced-5f96-c38a29ebd6a9@redhat.com>
Date:   Fri, 6 Nov 2020 11:19:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200929150944.1235688-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/20 17:09, Vitaly Kuznetsov wrote:
> Changes since v2:
> - Keep vCPU version of the ioctl intact but make it 'deprecated' in
>    api.rst [Paolo Bonzini]
> - First two patches of v2 series already made it to kvm/queue
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
> Vitaly Kuznetsov (2):
>    KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
>    KVM: selftests: test KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
> 
>   Documentation/virt/kvm/api.rst                | 16 ++--
>   arch/x86/kvm/hyperv.c                         |  6 +-
>   arch/x86/kvm/hyperv.h                         |  4 +-
>   arch/x86/kvm/vmx/evmcs.c                      |  3 +-
>   arch/x86/kvm/x86.c                            | 45 ++++++----
>   include/uapi/linux/kvm.h                      |  3 +-
>   .../testing/selftests/kvm/include/kvm_util.h  |  2 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 26 ++++++
>   .../selftests/kvm/x86_64/hyperv_cpuid.c       | 87 +++++++++++--------
>   9 files changed, 123 insertions(+), 69 deletions(-)
> 

Queued, thanks.

Paolo


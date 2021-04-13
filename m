Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D402535E1DE
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhDMOwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:52:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231165AbhDMOwP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 10:52:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618325515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uiuspi3kAcJpSAV4ULt0j0WV8oWELu9JdJSm5DjVPIw=;
        b=ixs//s62Ij0Apc0RBO2L/C2yO9a5ikCic4PM1Ruo7pV/T++t2H89Y5q66WcBoeozUYsoVe
        k3cDOki9QcSOkRcpP0fnnXkVlRXNrqSDhe9lBRdJiSswhXeRubeJpsZyxK1ohRV/TQyvWc
        hOoT92B52XTMdIZhpl9cmnIi9+HaVtA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-ZMMPi29wPoCbSOkjXvt9ow-1; Tue, 13 Apr 2021 10:51:53 -0400
X-MC-Unique: ZMMPi29wPoCbSOkjXvt9ow-1
Received: by mail-ej1-f69.google.com with SMTP id zj19so2247569ejb.22
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 07:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uiuspi3kAcJpSAV4ULt0j0WV8oWELu9JdJSm5DjVPIw=;
        b=rBnxe4L0Y/M1Qwv0ElXdnE1DnJ8zn08Mlz91ywr0mgKo4FLHj5IRq/K5UfRKM4xW5X
         7WkFl6968zvM4VWNHSR8hzCVRYycs6hps9xs29giBDQ59yPCtk6WwGi9J7ra0AcveIL+
         QSPfiOSuI2PDUzBMuD5JFCFT+v4va8eg2BXDK2AUcOFnOfUwM8iEyCY0AESwRfUMRSjA
         Py6+wQJnBbOu1cXVT+bQwsKfhPVr4uoFNZfDjA1CG7t36pR/Bky2UhboQoo01UfqV2+b
         6XucmiMYGNWOON3zGRinG5VXqKI3jv6W3RiBKoA8FQTBR7WuGxJcNYoPwjdt8Pb5SjI3
         Cr1w==
X-Gm-Message-State: AOAM5317HQsQ1sCpT5DgHJhtGi8zKLzj6xLGd+BIdYGLAQt60eRFIcGW
        RI7fIEK1NzSFKkuc9LUoO51MBPWP/ZFHKWhQ8YMvQ37r+fO1GBQQs2AWDlSD94TvUum9wTS7qQR
        2kpE0U3CZFK/+
X-Received: by 2002:aa7:c952:: with SMTP id h18mr35907668edt.269.1618325512515;
        Tue, 13 Apr 2021 07:51:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRAwGGF6rKAliD+NJrnoocig9lgh+NcU4AX5RI2IW0+VGKaBsyF+IPo/gcPpyvEJKNK5UN0Q==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr35907643edt.269.1618325512305;
        Tue, 13 Apr 2021 07:51:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t14sm7995787ejc.121.2021.04.13.07.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 07:51:51 -0700 (PDT)
Subject: Re: [PATCH v5 00/11] KVM SGX virtualization support (KVM part)
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <af16a973-29cd-3df0-55c6-260be5db8b12@redhat.com>
Date:   Tue, 13 Apr 2021 16:51:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 06:21, Kai Huang wrote:
> Hi Paolo, Sean,
> 
> Boris has merged x86 part patches to the tip/x86/sgx. This series is KVM part
> patches. Due to some code change in x86 part patches, two KVM patches need
> update so this is the new version. Please help to review. Thanks!
> 
> Specifically, x86 patch (x86/sgx: Add helpers to expose ECREATE and EINIT to
> KVM) was changed to return -EINVAL directly w/o setting trapnr when
> access_ok()s fail on any user pointers, so KVM patches:
> 
> KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
> KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
> 
> were updated to handle this case.
> 
> This seris was firstly based on tip/x86/sgx, and then rebased to latest
> kvm/queue, so it can be applied to kvm/queue directly now.

Boris, can you confirm that tip/x86/sgx has stable commit hashes?

Thanks,

Paolo

> Changelog:
> 
> (Please see individual patch for changelog for specific patch)
> 
> v4->v5:
>   - Addressed Sean's comments (patch 06, 07, 09 were slightly updated).
>   - Rebased to latest kvm/queue (patch 08, 11 were updated to resolve conflict).
> 
> Sean Christopherson (11):
>    KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
>    KVM: x86: Define new #PF SGX error code bit
>    KVM: x86: Add support for reverse CPUID lookup of scattered features
>    KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
>    KVM: VMX: Add basic handling of VM-Exit from SGX enclave
>    KVM: VMX: Frame in ENCLS handler for SGX virtualization
>    KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
>    KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
>    KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
>    KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
>    KVM: x86: Add capability to grant VM access to privileged SGX
>      attribute
> 
>   Documentation/virt/kvm/api.rst  |  23 ++
>   arch/x86/include/asm/kvm_host.h |   5 +
>   arch/x86/include/asm/vmx.h      |   1 +
>   arch/x86/include/uapi/asm/vmx.h |   1 +
>   arch/x86/kvm/Makefile           |   2 +
>   arch/x86/kvm/cpuid.c            |  89 +++++-
>   arch/x86/kvm/cpuid.h            |  50 +++-
>   arch/x86/kvm/vmx/nested.c       |  28 +-
>   arch/x86/kvm/vmx/nested.h       |   5 +
>   arch/x86/kvm/vmx/sgx.c          | 502 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/sgx.h          |  34 +++
>   arch/x86/kvm/vmx/vmcs12.c       |   1 +
>   arch/x86/kvm/vmx/vmcs12.h       |   4 +-
>   arch/x86/kvm/vmx/vmx.c          | 109 ++++++-
>   arch/x86/kvm/vmx/vmx.h          |   3 +
>   arch/x86/kvm/x86.c              |  23 ++
>   include/uapi/linux/kvm.h        |   1 +
>   17 files changed, 858 insertions(+), 23 deletions(-)
>   create mode 100644 arch/x86/kvm/vmx/sgx.c
>   create mode 100644 arch/x86/kvm/vmx/sgx.h
> 


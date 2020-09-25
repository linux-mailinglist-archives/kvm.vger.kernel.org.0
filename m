Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868D12793A3
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgIYVf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:35:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbgIYVf2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 17:35:28 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZHYOituAb5LHhfAlt1w3CoTgvVmTmpk5jRg1ddQ3b2w=;
        b=R8wa7GwNLiqfNBgnKsaw/XgknZnyVfI6NtVv7IsuRNMaagBHS5oeanWMF7qvGugdAyf/ol
        jCPfL9hcUa0xdrlANghLcssrO6vntOlXSZMXzluKXiaQz1WrYdc6rTV6U21Ol0rTWcjjez
        1A1mS60pFe6097sHxd1ISGhLGP26q70=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-knXrAJMJO5ytbhnjzrb10w-1; Fri, 25 Sep 2020 17:35:25 -0400
X-MC-Unique: knXrAJMJO5ytbhnjzrb10w-1
Received: by mail-wr1-f69.google.com with SMTP id r16so1572627wrm.18
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZHYOituAb5LHhfAlt1w3CoTgvVmTmpk5jRg1ddQ3b2w=;
        b=T4VLvRO9HnSVQhO/TmmB35tdJvDjhjRbvc19DHXl8QRRY1fS4GDtFCW1/jEFijiKoT
         40ClWaEAIdAcrb75XKLXTYFZV64VtVK2uc55qWFF3Xr19hMpF4li6q1TPdPVxXv9AzkV
         5EG3K4/N4DJcxZOf4Q8Zntdx6ODlga0O3oWwRXGLJun3IboDNmHv4M60EKnBnrR8Le9N
         wqSEZL8wXDLJmE+JuvqF/sg6R4z40ojO3znAIQe6FjnCrHeZaoh/zZqo165ZJhk0S7cI
         Gh0kxZHfp6jaJrEKRNRbSI0I4iOA+kICDkRxWO0QtNArsG0PX+g4mLDIM2wKWh7aJdYp
         ETIw==
X-Gm-Message-State: AOAM531tyWmPhgMOnFqdaGmq6HMUAMjmo8lDUnOkgE8hEFkWRnXZpChL
        /8gwGL1Ntn6IV9r5ozkq3CnAsm7hG6X/WTSTalkL9Me3VFglSZ7bFYxxqlDTPPEWcAXO+MVKDCm
        ebkfPJmTqHWSn
X-Received: by 2002:a5d:494b:: with SMTP id r11mr6420855wrs.227.1601069724452;
        Fri, 25 Sep 2020 14:35:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwn4RbXMFzPCp/BRf7V+eMbYZhwwKiG1kHbl7V/C024orzQO8thzzG/QBFKTzqW0VKFvPrHCg==
X-Received: by 2002:a5d:494b:: with SMTP id r11mr6420834wrs.227.1601069724186;
        Fri, 25 Sep 2020 14:35:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id k5sm329421wmb.19.2020.09.25.14.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:35:23 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] KVM: nVMX: Bug fixes and cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
References: <20200923184452.980-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <08e40284-201f-2d18-ff4e-c85b4f767f20@redhat.com>
Date:   Fri, 25 Sep 2020 23:35:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923184452.980-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 20:44, Sean Christopherson wrote:
> Fix for a brutal segment caching bug that manifested as random nested
> VM-Enter failures when running with unrestricted guest disabled.  A few
> more bug fixes and cleanups for stuff found by inspection when hunting
> down the caching issue.
> 
> v2:
>   - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
>     feature on AMD").
> 
> Sean Christopherson (7):
>   KVM: nVMX: Reset the segment cache when stuffing guest segs
>   KVM: nVMX: Reload vmcs01 if getting vmcs12's pages fails
>   KVM: nVMX: Explicitly check for valid guest state for !unrestricted
>     guest
>   KVM: nVMX: Move free_nested() below vmx_switch_vmcs()
>   KVM: nVMX: Ensure vmcs01 is the loaded VMCS when freeing nested state
>   KVM: nVMX: Drop redundant VMCS switch and free_nested() call
>   KVM: nVMX: WARN on attempt to switch the currently loaded VMCS
> 
>  arch/x86/kvm/vmx/nested.c | 103 ++++++++++++++++++++------------------
>  arch/x86/kvm/vmx/vmx.c    |   8 +--
>  arch/x86/kvm/vmx/vmx.h    |   9 ++++
>  3 files changed, 65 insertions(+), 55 deletions(-)
> 

Queued, thanks.

Paolo


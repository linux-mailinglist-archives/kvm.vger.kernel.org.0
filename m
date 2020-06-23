Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F446204DEC
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbgFWJ3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:29:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44067 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731887AbgFWJ33 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 05:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592904568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ajJ+XVgqd80OiAj1W9C4sv84loN6Y5MvSJ9QhGlkxac=;
        b=hfl3cQjxcsw3IlSGwo01IW1m2tCo0bFyXAZvqIu3OUIjtSdWA8ZssfmxyRKtu19XNFl2cP
        +SZ5vjS/zLS+F2cc/1/GdNzhmKpsRLEDdZwUZ0u+TIJeunuKvrbKlyueybIKUFU1kQ3Eck
        PSARfL870yNrojdjU79An6L5TjdbBbk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-foDTyR2EO3KuLp6VzyVYBw-1; Tue, 23 Jun 2020 05:29:25 -0400
X-MC-Unique: foDTyR2EO3KuLp6VzyVYBw-1
Received: by mail-wm1-f71.google.com with SMTP id t145so3364675wmt.2
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ajJ+XVgqd80OiAj1W9C4sv84loN6Y5MvSJ9QhGlkxac=;
        b=gCOMim+cjFts9fUylYvwSptQ3sYD7aq5JoI250FYY0uzw2E8UAwVQrdCmd3lUxoZfU
         V6SHY9dQmILB7ZgPvx/w/FxEPc+hUJYX7OIrLdx2AIZ5B8lB3rrCzMom4YlaoqZKrLV9
         TspjZlxRHupvGwsCw/VCRsJl611G8XGc1Gl0P/qzWAmUbygqSQt9h0PHPX06eCtdtm3Z
         VQB1ZgEyTvBA/d81mLpumUcc+ATzhtBM4d78hX3MQgEFf9kK/AOte54U65GRS2DTHQiw
         M+jJcXCZ7sm6N8EyAu1GC+2rzkNa9imwmMkNya1cEfv3AWnSsrsQlBCIPr/EGJozf2Qp
         bClA==
X-Gm-Message-State: AOAM532bJNAdWrHgC/uFdpdVK3sLz1ziByp7NYaf232zN9pRHAJLzoIc
        lv9GqGwu+2w57bkAzIMvBVVJlbDKX2H1QIVfms+VR7b1zXLmsimMaa0Yv+7aSqQLtZuwb9p4K/2
        z7YAY+35uGs8z
X-Received: by 2002:adf:edc5:: with SMTP id v5mr22137986wro.178.1592904564382;
        Tue, 23 Jun 2020 02:29:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyi0t0eO9OE/k/fvFbVP3kVJipI/hKNOaIVGI6mTWBUteX/R6O/GQfFqZl/noK6JU2o6s3ZRA==
X-Received: by 2002:adf:edc5:: with SMTP id v5mr22137965wro.178.1592904564145;
        Tue, 23 Jun 2020 02:29:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id j6sm3118412wmb.3.2020.06.23.02.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:29:23 -0700 (PDT)
Subject: Re: [PATCH v4 0/6] Add logical CPU to KVM_EXIT_FAIL_ENTRY info
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200603235623.245638-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <70ec23e6-0e7a-aaca-ee3c-4a11cc76aea5@redhat.com>
Date:   Tue, 23 Jun 2020 11:29:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200603235623.245638-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 01:56, Jim Mattson wrote:
> It's been about 6 months since v2. Sorry for the delay. Initially, this
> was a single patch to add information to KVM_EXIT_FAIL_ENTRY to help
> identify a defective CPU. It has gotten a little more complicated,
> since Peter Shier pointed out that the vCPU thread may have migrated
> between the time of failure and the KVM exit. Fortunately, the SEV folks
> started to make the necessary information available with "last_cpu," but
> only on AMD and only with SEV. The current version expands upon that by
> making "last_cpu" available in all configurations on AMD and Intel.
> 
> v2: Use vcpu->cpu rather than raw_smp_processor_id() (Liran).
> v3: Record the last logical processor to run the vCPU thread (Peter).
>     Add the "last CPU" information to KVM_EXIT_INTERNAL_ERROR exits as
>     well as KVM_EXIT_FAIL_ENTRY [except for "EMULATION" errors].
>     (Liran & Paolo).
> v4: Move last_cpu into kvm_vcpu_arch as last_vmentry_cpu, and set this
>     field in vcpu_enter_guest (Sean).
> 
> Jim Mattson (6):
>   kvm: svm: Prefer vcpu->cpu to raw_smp_processor_id()
>   kvm: svm: Always set svm->last_cpu on VMRUN
>   kvm: vmx: Add last_cpu to struct vcpu_vmx
>   kvm: x86: Add "last CPU" to some KVM_EXIT information
>   kvm: x86: Move last_cpu into kvm_vcpu_arch as last_vmentry_cpu
>   kvm: x86: Set last_vmentry_cpu in vcpu_enter_guest
> 
>  Documentation/virt/kvm/api.rst  |  1 +
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/svm/sev.c          |  3 +--
>  arch/x86/kvm/svm/svm.c          | 13 ++++++-------
>  arch/x86/kvm/svm/svm.h          |  3 ---
>  arch/x86/kvm/vmx/vmx.c          | 10 ++++++++--
>  arch/x86/kvm/x86.c              |  2 ++
>  include/uapi/linux/kvm.h        |  2 ++
>  8 files changed, 23 insertions(+), 14 deletions(-)
> 

Queued, thanks.  (It would have been fine to squash patches 3-5-6
together, too).

Paolo


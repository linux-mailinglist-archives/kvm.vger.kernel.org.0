Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2044F30F120
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 11:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhBDKp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 05:45:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60313 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235037AbhBDKpk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 05:45:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612435454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qc79/SydJqJc0GnAvKYNJ7NyXEgSRB74d6Ask0k4LBQ=;
        b=B6/elGDov7p13jE2mzlsdBwJlXZeLjnc3SwnX270ACOA2GG2UUufMl/wowkLf25CM2Q17b
        eUZQeI6uG5pZj09AMSyNPDpAL7ukU8x8BCRf8lzTDdQnxbquDDdAO+sM1SJD3mCIP++O+q
        2W15AZzkelBCoi+D7vAB7b3fM+hjFrA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-syeDcUdDPEWdZVsXp0XJgg-1; Thu, 04 Feb 2021 05:44:12 -0500
X-MC-Unique: syeDcUdDPEWdZVsXp0XJgg-1
Received: by mail-ed1-f70.google.com with SMTP id g2so2572595edq.14
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 02:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qc79/SydJqJc0GnAvKYNJ7NyXEgSRB74d6Ask0k4LBQ=;
        b=CssT3KGYJcrVnWPfu34LP6xW8/np+ZGM7/Vi0y5tSAQQi+YnTtab4s4SY87PAQxDzd
         VpWO32W4U3QZ6Yimfi7KNxrA1Ll/YiIrv/Xu4K7118ppZKqskxbkW57J0K45jxXrz14N
         AJNRpD9aI/5aNSKpKYjV8N0T8Tz+bya6PEZA/Lpozv+1YcPAheXXKdBeXi47FrdIEreB
         0F/Xa4+lo7b4OMdEagAqG1chDokez1YCSt99uQq1cCEunRfb+Iufpfz1kRF/xVRonOaT
         UoX+E2qVEAEtnTuf7SLW7GFJdIH1tuxr+XB6Yf/g8BUIGkmy4TTKlFqaHIkCmDQPoySU
         YfdA==
X-Gm-Message-State: AOAM533irMbrmeuM99hIjsFwad/NA5877beDJVVOiYQfeR9uMkF5rWtQ
        +IddIZoQ4AzzNxyGw6KgcLtIMlvwibFp5vS/gSFsDrFNjyIDWdYrId/V1ACO48ol68fg0Wagj5k
        awcr/M/u94uKM
X-Received: by 2002:a17:906:b28f:: with SMTP id q15mr7361958ejz.77.1612435451359;
        Thu, 04 Feb 2021 02:44:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwy+5l4EFKjhd+GCohRu7VTnNQ3UVBq14t2IhrB9IdvriyD15u2dLRadVo5ok1j+WIsJpTfLg==
X-Received: by 2002:a17:906:b28f:: with SMTP id q15mr7361943ejz.77.1612435451149;
        Thu, 04 Feb 2021 02:44:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hb24sm787738ejb.16.2021.02.04.02.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 02:44:10 -0800 (PST)
Subject: Re: [PATCH 00/12] KVM: x86: Legal GPA fixes and cleanups
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20210204000117.3303214-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <112585a1-713c-54ac-3d8b-ce913faec3a5@redhat.com>
Date:   Thu, 4 Feb 2021 11:44:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/21 01:01, Sean Christopherson wrote:
> Add helpers to consolidate the GPA reserved bits checks that are scattered
> all over KVM, and fix a few bugs in the process.
> 
> The original motivation was simply to get rid of all the different open
> coded variations of the checks (there were a lot), but this snowballed
> into a more ambitious cleanup when I realized common helpers are more or
> less required to correctly handle repurposed GPA bits, e.g. SEV's C-bit.
> 
> The last two patches (use nested VM-Enter failure tracepoints in SVM)
> aren't directly related to the GPA checks, but the conflicts would be
> rather messy, so I included them here.
> 
> Note, the SEV C-bit changes are technically bug fixes, but getting them in
> stable kernels would require backporting this entire pile.  IMO, it's not
> worth the effort given that it's extremely unlikely anyone will encounter
> the bugs in anything but synthetic negative tests.
> 
> Based on kvm/queue, commit 3f87cb8253c3 ("KVM: X86: Expose bus lock debug
> exception to guest").

Queued 1 for 5.11 and 2-10 for 5.12; the VMCB01/VMCB02 patches are 
unlikely to make it in 5.12 so 11-12 won't be in kvm/next anytime 
soon---but you don't have to care about them anyway.

Paolo

> Sean Christopherson (12):
>    KVM: x86: Set so called 'reserved CR3 bits in LM mask' at vCPU reset
>    KVM: nSVM: Don't strip host's C-bit from guest's CR3 when reading
>      PDPTRs
>    KVM: x86: Add a helper to check for a legal GPA
>    KVM: x86: Add a helper to handle legal GPA with an alignment
>      requirement
>    KVM: VMX: Use GPA legality helpers to replace open coded equivalents
>    KVM: nSVM: Use common GPA helper to check for illegal CR3
>    KVM: x86: SEV: Treat C-bit as legal GPA bit regardless of vCPU mode
>    KVM: x86: Use reserved_gpa_bits to calculate reserved PxE bits
>    KVM: x86/mmu: Add helper to generate mask of reserved HPA bits
>    KVM: x86: Add helper to consolidate "raw" reserved GPA mask
>      calculations
>    KVM: x86: Move nVMX's consistency check macro to common code
>    KVM: nSVM: Trace VM-Enter consistency check failures
> 
>   arch/x86/include/asm/kvm_host.h |   2 +-
>   arch/x86/kvm/cpuid.c            |  20 +++++-
>   arch/x86/kvm/cpuid.h            |  24 +++++--
>   arch/x86/kvm/mmu/mmu.c          | 110 ++++++++++++++++----------------
>   arch/x86/kvm/mtrr.c             |  12 ++--
>   arch/x86/kvm/svm/nested.c       |  35 +++++-----
>   arch/x86/kvm/svm/svm.c          |   2 +-
>   arch/x86/kvm/vmx/nested.c       |  34 +++-------
>   arch/x86/kvm/vmx/vmx.c          |   2 +-
>   arch/x86/kvm/x86.c              |  11 ++--
>   arch/x86/kvm/x86.h              |   8 +++
>   11 files changed, 140 insertions(+), 120 deletions(-)
> 


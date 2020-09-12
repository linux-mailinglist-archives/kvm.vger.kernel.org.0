Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9593D267B82
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 19:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgILRIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 13:08:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgILRIT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Sep 2020 13:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599930495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b+aSDGV/oYhX+ueon60NJNcYH7fljpcWGVTD4uc1ITw=;
        b=XrzqU2xdpk52ZIetXgkRIw1BS+smC6kktrkBR/23RDOTZjs9xDgbLGPREm5zbMNz7tFgWF
        /tDKoX1LcBLOucMkUO2Isb9EZu5YjX1W7YLjsvhap9ib0P9AmnduscJm0wyzG+E++7Ot9l
        lzXcaLQB/TSrFQNQJWbAe0btmpyUXNc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-J8Hr_Wb3N8ir1KOBn7M44A-1; Sat, 12 Sep 2020 13:08:07 -0400
X-MC-Unique: J8Hr_Wb3N8ir1KOBn7M44A-1
Received: by mail-wm1-f69.google.com with SMTP id m125so1853006wmm.7
        for <kvm@vger.kernel.org>; Sat, 12 Sep 2020 10:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b+aSDGV/oYhX+ueon60NJNcYH7fljpcWGVTD4uc1ITw=;
        b=Fwz5HLyyk2cDrlAM+wztBjCI9OY7NvF8vHc7BzOOW307OZuYsWxbQC6P6ELwV2PqBu
         mGmKwnWQajl7a+UcZ9uIMaaG0MQ7lx5Ydif7akdNol0YOTsPEcWsB9vIk2Xwb2aBIUIZ
         28kEPeSIi7FyGZxYePr94fl6vbprAjoVDWoaGp5nQmrAv9c91QHW1VDgK8KSmqgDaL8r
         XgwOhZaVe3kQRU9pokB1X6fiZ+1di6Lbec5IFPOdEFYW5fkoQTb3myw8uT6ZpS6MYdS4
         a6DQ7i2Zm9Ns9zwnYWvIUUl2kMEeM4f5gFUY2M0pNFgowe9ilpghVnhm25JKmUgqTNoP
         SEZA==
X-Gm-Message-State: AOAM532y5LFTmgR0prZz6oCm3EDdhacA8z1NcqmuAyLzfyJfHVTKyDCk
        AlGdeHEk8tx/xlpPv5AspOwnhjQLEF9d6FMwIFQWxno6na6cmS3hmWSAM3zBnM0YRk3KzxByfoM
        x37xsx8Ke20rT
X-Received: by 2002:a05:600c:28d:: with SMTP id 13mr7478767wmk.69.1599930486744;
        Sat, 12 Sep 2020 10:08:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+arxx14Ib8VAtxDMyB7LDmHJHMdm91Wz/F0wQ8IjDZ+BkwiiUUaCY2xfYJ34ZzSn7CPTRfQ==
X-Received: by 2002:a05:600c:28d:: with SMTP id 13mr7478748wmk.69.1599930486460;
        Sat, 12 Sep 2020 10:08:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9fd9:16f2:2095:52d7? ([2001:b07:6468:f312:9fd9:16f2:2095:52d7])
        by smtp.gmail.com with ESMTPSA id l15sm11136452wrt.81.2020.09.12.10.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 10:08:05 -0700 (PDT)
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Babu Moger <babu.moger@amd.com>, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com
Cc:     wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, tglx@linutronix.de
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
Date:   Sat, 12 Sep 2020 19:08:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/20 21:27, Babu Moger wrote:
> The following series adds the support for PCID/INVPCID on AMD guests.
> While doing it re-structured the vmcb_control_area data structure to
> combine all the intercept vectors into one 32 bit array. Makes it easy
> for future additions. Re-arranged few pcid related code to make it common
> between SVM and VMX.
> 
> INVPCID interceptions are added only when the guest is running with shadow
> page table enabled. In this case the hypervisor needs to handle the tlbflush
> based on the type of invpcid instruction.
> 
> For the guests with nested page table (NPT) support, the INVPCID feature
> works as running it natively. KVM does not need to do any special handling.
> 
> AMD documentation for INVPCID feature is available at "AMD64 Architecture
> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34(or later)"
> 
> The documentation can be obtained at the links below:
> Link: https://www.amd.com/system/files/TechDocs/24593.pdf
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
> ---
> 
> v6:
>  One minor change in patch #04. Otherwise same as v5.
>  Updated all the patches by Reviewed-by.
> 
> v5:
>  https://lore.kernel.org/lkml/159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu/
>  All the changes are related to rebase.
>  Aplies cleanly on mainline and kvm(master) tree. 
>  Resending it to get some attention.
> 
> v4:
>  https://lore.kernel.org/lkml/159676101387.12805.18038347880482984693.stgit@bmoger-ubuntu/
>  1. Changed the functions __set_intercept/__clr_intercept/__is_intercept to
>     to vmcb_set_intercept/vmcb_clr_intercept/vmcb_is_intercept by passing
>     vmcb_control_area structure(Suggested by Paolo).
>  2. Rearranged the commit 7a35e515a7055 ("KVM: VMX: Properly handle kvm_read/write_guest_virt*())
>     to make it common across both SVM/VMX(Suggested by Jim Mattson).
>  3. Took care of few other comments from Jim Mattson. Dropped "Reviewed-by"
>     on few patches which I have changed since v3.
> 
> v3:
>  https://lore.kernel.org/lkml/159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu/
>  1. Addressing the comments from Jim Mattson. Follow the v2 link below
>     for the context.
>  2. Introduced the generic __set_intercept, __clr_intercept and is_intercept
>     using native __set_bit, clear_bit and test_bit.
>  3. Combined all the intercepts vectors into single 32 bit array.
>  4. Removed set_intercept_cr, clr_intercept_cr, set_exception_intercepts,
>     clr_exception_intercept etc. Used the generic set_intercept and
>     clr_intercept where applicable.
>  5. Tested both L1 guest and l2 nested guests. 
> 
> v2:
>   https://lore.kernel.org/lkml/159234483706.6230.13753828995249423191.stgit@bmoger-ubuntu/
>   - Taken care of few comments from Jim Mattson.
>   - KVM interceptions added only when tdp is off. No interceptions
>     when tdp is on.
>   - Reverted the fault priority to original order in VMX. 
>   
> v1:
>   https://lore.kernel.org/lkml/159191202523.31436.11959784252237488867.stgit@bmoger-ubuntu/
> 
> Babu Moger (12):
>       KVM: SVM: Introduce vmcb_(set_intercept/clr_intercept/_is_intercept)
>       KVM: SVM: Change intercept_cr to generic intercepts
>       KVM: SVM: Change intercept_dr to generic intercepts
>       KVM: SVM: Modify intercept_exceptions to generic intercepts
>       KVM: SVM: Modify 64 bit intercept field to two 32 bit vectors
>       KVM: SVM: Add new intercept vector in vmcb_control_area
>       KVM: nSVM: Cleanup nested_state data structure
>       KVM: SVM: Remove set_cr_intercept, clr_cr_intercept and is_cr_intercept
>       KVM: SVM: Remove set_exception_intercept and clr_exception_intercept
>       KVM: X86: Rename and move the function vmx_handle_memory_failure to x86.c
>       KVM: X86: Move handling of INVPCID types to x86
>       KVM:SVM: Enable INVPCID feature on AMD
> 
> 
>  arch/x86/include/asm/svm.h      |  117 +++++++++++++++++++++++++----------
>  arch/x86/include/uapi/asm/svm.h |    2 +
>  arch/x86/kvm/svm/nested.c       |   66 +++++++++-----------
>  arch/x86/kvm/svm/svm.c          |  131 ++++++++++++++++++++++++++-------------
>  arch/x86/kvm/svm/svm.h          |   87 +++++++++-----------------
>  arch/x86/kvm/trace.h            |   21 ++++--
>  arch/x86/kvm/vmx/nested.c       |   12 ++--
>  arch/x86/kvm/vmx/vmx.c          |   95 ----------------------------
>  arch/x86/kvm/vmx/vmx.h          |    2 -
>  arch/x86/kvm/x86.c              |  106 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h              |    3 +
>  11 files changed, 364 insertions(+), 278 deletions(-)
> 
> --
> Signature
> 

Queued except for patch 9 with only some changes to the names (mostly
replacing "vector" with "word").  It should get to kvm.git on Monday or
Tuesday, please give it a shot.

Thanks!

Paolo


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1B367B22
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhDVHcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:32:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235099AbhDVHca (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 03:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619076687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8D9GIWFTGZiZj3WeGRpz+wktOpaAohBnJR5mNYvnkuc=;
        b=IDqmrFnVbm1VJYzg1O8DA73iLT1gyjxSwVRuQxc+CYn+Cv8kpmnyF+5Mc302fpuqlS7ScB
        lmapyZ0z8EjiolSNzGAG4FBdUOA/YRIYqnr+TBts5DF8nc/XehjuQ17KPoWVzrgic5pTrf
        Ra8x34rhHztez3QjgbrycARacMUKtIc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-2-7aW_U9PMCsrDyVREPDEA-1; Thu, 22 Apr 2021 03:30:52 -0400
X-MC-Unique: 2-7aW_U9PMCsrDyVREPDEA-1
Received: by mail-ed1-f70.google.com with SMTP id bf25-20020a0564021a59b0290385169cebf8so8884931edb.8
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 00:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8D9GIWFTGZiZj3WeGRpz+wktOpaAohBnJR5mNYvnkuc=;
        b=Lj3G4kNEsG16TVebpgZfKTG1Q1UeYYWexlbKttOD8/vgU+Vt4B1FsS5tuqQw771xkz
         hLfhh6pqF7CUVX5wjaZSHzEMjNjKo0RzGTyq/ktB8ngkDP/HYH6KYPEW7Tx2GQouhcuz
         9ba69EYOCZM0MhQ8gEoR/acu/L6t2JwQTUWeyXkhghTBmDr6guhd67iq5QdD+ogZol/7
         WSefbGwTOQ1MDPbF7I9qiH0RbSU7GLsfcrreUU6UryAzpBKpfadrKOPPq9IZu/p6dVGC
         K9le9Vi8LOfoux3Onaz/NUskOhAUwNoMdrkcn8uywjRhH0Q5HnV3d7taYldOKmg6GouS
         x6jA==
X-Gm-Message-State: AOAM533H8WzqTuGAM6Si2OujqUKGMuG8ZI9EDwXzSl31f6vMLaMZUEjA
        Bgy3w3SBxxB7quRpU2MukbmSg3F5hKZas5o1vTsKCI9PIwglwOhgwkTX09HLYaJ53YvwzTwpl4M
        5ljPqZvvJdLD0
X-Received: by 2002:aa7:de8c:: with SMTP id j12mr2162276edv.126.1619076650952;
        Thu, 22 Apr 2021 00:30:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3mvrL4ZJ61KJHLzD1c1C6gHJxkr5aSI3gbkOulhvlEJndx/nvXdauq6yHKvVg6F/H2JbgzA==
X-Received: by 2002:aa7:de8c:: with SMTP id j12mr2162254edv.126.1619076650788;
        Thu, 22 Apr 2021 00:30:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f3sm1251593eje.45.2021.04.22.00.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 00:30:50 -0700 (PDT)
Subject: Re: [PATCH v5 00/15] KVM: SVM: Misc SEV cleanups
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210422021125.3417167-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e32cb350-9fbe-5abd-930a-e820a4f4930b@redhat.com>
Date:   Thu, 22 Apr 2021 09:30:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 04:11, Sean Christopherson wrote:
> Minor bug fixes and refactorings of SEV related code, mainly to clean up
> the KVM code for tracking whether or not SEV and SEV-ES are enabled.  E.g.
> KVM has both sev_es and svm_sev_enabled(), and a global 'sev' flag while
> also using 'sev' as a local variable in several places.
> 
> Based kvm/queue-ish, commit 0e91d1992235 ("KVM: SVM: Allocate SEV command
> structures on local stack"), to avoid the conflicting CPUID.0x8000_001F
> patch sitting in kvm/queue.
> 
> v5:
>   - Use Paolo's version of the CPUID.0x8000_001F patch, with some of my
>     goo on top.  Paolo gets credit by introducing fewer bugs; v4 missed
>     the SEV/SEV-ES module params and used the wrong reverse-CPUID index...
>   - Add a patch to disable SEV/SEV-ES if NPT is disabled.
>   - Rebased, as above.
> v4:
>   - Reinstate the patch to override CPUID.0x8000_001F.
>   - Properly configure the CPUID.0x8000_001F override. [Paolo]
>   - Rebase to v5.12-rc1-dontuse.
> v3:
>   - Drop two patches: add a dedicated feature word for CPUID_0x8000001F,
>     and use the new word to mask host CPUID in KVM.  I'll send these as a
>     separate mini-series so that Boris can take them through tip.
>   - Add a patch to remove dependency on
>     CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT. [Boris / Paolo]
>   - Use kcalloc() instead of an open-coded equivalent. [Tom]
>   - Nullify sev_asid_bitmap when freeing it during setup. [Tom]
>   - Add a comment in sev_hardware_teardown() to document why it's safe to
>     query the ASID bitmap without taking the lock. [Tom]
>   - Collect reviews. [Tom and Brijesh]
> v2:
>   - Remove the kernel's sev_enabled instead of renaming it to sev_guest.
>   - Fix various build issues. [Tom]
>   - Remove stable tag from the patch to free sev_asid_bitmap.  Keeping the
>     bitmap on failure is truly only a leak once svm_sev_enabled() is
>     dropped later in the series.  It's still arguably a fix since KVM will
>     unnecessarily keep memory, but it's not stable material. [Tom]
>   - Collect one Ack. [Tom]
> 
> v1:
>   - https://lkml.kernel.org/r/20210109004714.1341275-1-seanjc@google.com
> 
> Paolo Bonzini (1):
>    KVM: SEV: Mask CPUID[0x8000001F].eax according to supported features
> 
> Sean Christopherson (14):
>    KVM: SVM: Zero out the VMCB array used to track SEV ASID association
>    KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
>    KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
>    KVM: SVM: Move SEV module params/variables to sev.c
>    x86/sev: Drop redundant and potentially misleading 'sev_enabled'
>    KVM: SVM: Append "_enabled" to module-scoped SEV/SEV-ES control
>      variables
>    KVM: SVM: Condition sev_enabled and sev_es_enabled on
>      CONFIG_KVM_AMD_SEV=y
>    KVM: SVM: Enable SEV/SEV-ES functionality by default (when supported)
>    KVM: SVM: Unconditionally invoke sev_hardware_teardown()
>    KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
>    KVM: SVM: Move SEV VMCB tracking allocation to sev.c
>    KVM: SVM: Drop redundant svm_sev_enabled() helper
>    KVM: SVM: Remove an unnecessary prototype declaration of
>      sev_flush_asids()
>    KVM: SVM: Skip SEV cache flush if no ASIDs have been used
> 
>   arch/x86/include/asm/mem_encrypt.h |  1 -
>   arch/x86/kvm/cpuid.c               |  8 ++-
>   arch/x86/kvm/cpuid.h               |  1 +
>   arch/x86/kvm/svm/sev.c             | 80 ++++++++++++++++++++++--------
>   arch/x86/kvm/svm/svm.c             | 57 +++++++++------------
>   arch/x86/kvm/svm/svm.h             |  9 +---
>   arch/x86/mm/mem_encrypt.c          | 12 ++---
>   arch/x86/mm/mem_encrypt_identity.c |  1 -
>   8 files changed, 97 insertions(+), 72 deletions(-)
> 

Queued except for patch 6, send that separately since it's purely x86 
and maintainers will likely not notice it inside this thread.  You 
probably want to avoid conflicts by waiting for the migration patches, 
though.

Paolo


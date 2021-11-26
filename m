Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A954B45F52D
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 20:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbhKZTaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 14:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhKZT2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 14:28:02 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1D5C08EB4A
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:43:17 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o20so42106045eds.10
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 10:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y1D4KPlh7YjhxLeSEByEcGKAHQ8NEL/KqF/coqV0Uq4=;
        b=lhXrcv1mLz3c8zUN49oj6kEwlwuZryoc6VqEjkhM2FpmrBFadEWuT6gDj1jNmqtPCk
         HffHRk7YwEH1jpeXFFXix0MGen1eo3a08hwPkC4rNNoqnhiaf3+PBxSWPswIO+71NPrZ
         QPfMMSOy7RRdGycJQJ9bF4mYt9+iFwCUEDxWAFiQF2/FEf71tqwmw3d/2qQKWMnBeJHj
         dCgimQlxkJ91ABpY9n/hWZxWB5Eyw78c0tSxh/uie/gwfe+3GJBsif/OLzLcbKLINrVa
         ANNJZViXnUrNHwz1A2vPUDoG1RX0Y/wudLHoD9fSHvgGKWmeWsEA4WkDjcZDQ1BDBKu1
         nqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y1D4KPlh7YjhxLeSEByEcGKAHQ8NEL/KqF/coqV0Uq4=;
        b=AJ8Rj0jS1+IpariGgf6AS2HhC4btzeh1xK7EfMZAjH/aSerDQYXG86PrKHD/vuCslG
         CorjgyG/e/BQt8mpP6+y9Fb8AjXvPvqH6WAf9zIYJaOe+PoECqV8fg2rOcriEgKLBPBr
         wYnB+6efArbDUtJ7WT6Q6wi2WbRtcshR6Kea88Rl2S2Qdhce5aBLtXzJeibfj8rCScQ/
         B09/DGrylhGNTRwScBcQHgEHAtC2gfd/lFHuY2IsA8WfGmggkxD+TBexq1nbtVvg2rGV
         aEJsno5Ppp2cLoo6RqxE5CaC8v/Ree0YxtAx2yDxn4WDASfs1F9MJCbbOpIb6PD8AKL/
         md8g==
X-Gm-Message-State: AOAM530G+/s1JVWnJbquiPaj6zJ4ekMtJh3IUozKEh8ryi6iofQMDCTf
        +4DWBd6hDqZLP5QnHAvpbcvOgKoJtl0=
X-Google-Smtp-Source: ABdhPJxO/RmzwDBcmTcIN8aJDQvaYN1g3CEP7ijNG7/EHhyES/IDAHR1JlFj3qcIRD0m43AASruUUA==
X-Received: by 2002:a05:6402:350e:: with SMTP id b14mr49249910edd.313.1637952195714;
        Fri, 26 Nov 2021 10:43:15 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id qb28sm3680510ejc.93.2021.11.26.10.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 10:43:15 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <34ff357d-c073-4a68-117d-63ccff1085cb@redhat.com>
Date:   Fri, 26 Nov 2021 19:43:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 00/39] x86/access: nVMX: Big overhaul
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20211125012857.508243-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 02:28, Sean Christopherson wrote:
> This started out as a very simple test (patch 39/39) to expose a KVM bug
> where KVM doesn't sync a shadow MMU on a vmcs12->vpid change.  Except the
> test didn't fail.  And it turns out, completely removing INVLPG from the
> base access test doesn't fail when using shadow paging either.
> 
> The underlying problem in both cases is that the access test is flat out
> stupid when it comes to handling page tables.  Instead of allocating page
> tables once and manipulating them on each iteration, it "allocates" a new
> paging structure when necessary on every. single. iteration.  In addition
> to being incredibly inefficient (allocation also zeros the entire 4kb page,
> so the test zeros absurd amounts of memory), writing upper level PTEs on
> every iteration triggers write-protection mechanisms in KVM.  In effect,
> KVM ends up synchronizing the relevant SPTEs on every iteration, which
> again is ridiculously slow and makes it all but impossible to actually
> test that KVM handles other TLB invalidation scenarios.
> 
> Trying to solve that mess by pre-allocating the page tables exposed a
> whole pile of 5-level paging issues.  I'd say the test's 5-level support
> is held together by duct tape, but I've fixed many things with duct tape
> that are far less fragile.
> 
> The second half of this series is cleanups in the nVMX code to prepare
> for adding the (INV)VPID variants.  Not directly related to the access
> tests, but it annoyed me to no end that simply checking if INVVPID is
> supported was non-trivial.

Queued, thanks.  The new tests are pretty slow on debug kernels (about 3 
minutes each).  I'll check next week if there's any low hanging 
fruit---or anything broken.

Paolo

> Sean Christopherson (39):
>    x86/access: Add proper defines for hardcoded addresses
>    x86/access: Cache CR3 to improve performance
>    x86/access:  Use do-while loop for what is obviously a do-while loop
>    x86/access: Stop pretending the test is SMP friendly
>    x86/access: Refactor so called "page table pool" logic
>    x86/access: Stash root page table level in test environment
>    x86/access: Hoist page table allocator helpers above "init" helper
>    x86/access: Rename variables in page table walkers
>    x86/access: Abort if page table insertion hits an unexpected level
>    x86/access: Make SMEP place nice with 5-level paging
>    x86/access: Use upper half of virtual address space
>    x86/access: Print the index when dumping PTEs
>    x86/access: Pre-allocate all page tables at (sub)test init
>    x86/access: Don't write page tables if desired PTE is same as current
>      PTE
>    x86/access: Preserve A/D bits when writing paging structure entries
>    x86/access: Make toggling of PRESENT bit a "higher order" action
>    x86/access: Manually override PMD in effective permissions sub-test
>    x86/access: Remove manual override of PUD/PMD in prefetch sub-test
>    x86/access: Remove PMD/PT target overrides
>    x86/access: Remove timeout overrides now that performance doesn't suck
>    nVMX: Skip EPT tests if INVEPT(SINGLE_CONTEXT) is unsupported
>    nVMX: Hoist assert macros to the top of vmx.h
>    nVMX: Add a non-reporting assertion macro
>    nVMX: Assert success in unchecked INVEPT/INVVPID helpers
>    nVMX: Drop less-than-useless ept_sync() wrapper
>    nVMX: Move EPT capability check helpers to vmx.h
>    nVMX: Drop unused and useless vpid_sync() helper
>    nVMX: Remove "v1" version of INVVPID test
>    nVMX: Add helper to check if INVVPID type is supported
>    nVMX: Add helper to check if INVVPID is supported
>    nVMX: Add helper to get first supported INVVPID type
>    nVMX: Use helper to check for EPT A/D support
>    nVMX: Add helpers to check for 4/5-level EPT support
>    nVMX: Fix name of macro defining EPT execute only capability
>    nVMX: Add helper to check if a memtype is supported for EPT structures
>    nVMX: Get rid of horribly named "ctrl" boolean in test_ept_eptp()
>    nVMX: Rename awful "ctrl" booleans to "is_ctrl_valid"
>    nVMX: Add helper to check if VPID is supported
>    x86/access: nVMX: Add "access" test variants to invalidate via
>      (INV)VPID
> 
>   x86/access.c      | 391 ++++++++++++++++++++++++++++------------------
>   x86/unittests.cfg |  10 +-
>   x86/vmx.c         |  71 +--------
>   x86/vmx.h         | 229 ++++++++++++++++++---------
>   x86/vmx_tests.c   | 327 +++++++++++++++++---------------------
>   5 files changed, 543 insertions(+), 485 deletions(-)
> 


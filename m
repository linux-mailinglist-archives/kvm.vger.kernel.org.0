Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0296B3A3045
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFJQMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:12:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230236AbhFJQMm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 12:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623341445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VS4G6uRSNNs/KszWVbhopgooCFpiUe/LenjZvAFJ6Aw=;
        b=N+g/xXwvyy6fmqc2JzK4Ci2hQ3dlT962rouN3u1ptlvMBiqr7cvpQOc0E16qwhPHU0Uqyt
        1IEyrNR9GjNs3vrRtVR4mq3ku5IVBO3NV37XmA7fYBM/oVE7+03Kxc/PjKe0H8S+QClaua
        XghE0k5Z/Z+Ff1mC0EZ4j8ExdRb+nJA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-KTsPy9KbN1S1lRgWT_DS3w-1; Thu, 10 Jun 2021 12:10:44 -0400
X-MC-Unique: KTsPy9KbN1S1lRgWT_DS3w-1
Received: by mail-wr1-f71.google.com with SMTP id k25-20020a5d52590000b0290114dee5b660so1188199wrc.16
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 09:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VS4G6uRSNNs/KszWVbhopgooCFpiUe/LenjZvAFJ6Aw=;
        b=hXgce3VeKilZ1Yn/LVUcS2aU7TOExLBwspDK0X6CYVzarVGPt6FIVXkp7PEtLfvzJu
         gm28buf2jpscPQ40rHoEoSTiSUeloe2/3SrWz/LSNfWoVnoqYNEL7aE7xyaL+ryC3Y6f
         sb7054tbUecr5RkwY8TggtozAZSlU1vANv8qG1sDLURWg+sUhOn6ijpF9aA+194c6ZMR
         l1vUqf2A+JwtrRIsW6rNfOnux9BH9Fudp/n79bstKLmfrADJXucZC6/FladaaIOk6JkC
         e9sBrzR67UWpAhx/CgTdUS7y+7KdLrjX/9zzERHaj8894UPFSk5uABPpI5eqYWgf3lKV
         ca7w==
X-Gm-Message-State: AOAM532qDzniwTsuqeugUNi/h1uYb8x9rPzBKQhCusPwjIufxUfHYNY3
        SA083KEza/86wQDj0O8FSSDVwBmR6eNjSWU+sjsBtNVANiiv77OC+vi7CLRjlVulRB9xDHAtzkQ
        TWOTbS0zGdiVf
X-Received: by 2002:a5d:47a6:: with SMTP id 6mr6253688wrb.203.1623341442198;
        Thu, 10 Jun 2021 09:10:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUTByA0JAGkuWD8EYKgRmSmIspyNmiyOzDq18cADQlPMBvLzOXTeu0qh1u7TrVJK+neXcOtQ==
X-Received: by 2002:a5d:47a6:: with SMTP id 6mr6253665wrb.203.1623341441982;
        Thu, 10 Jun 2021 09:10:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id t14sm3967871wra.60.2021.06.10.09.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 09:10:41 -0700 (PDT)
Subject: Re: [PATCH 00/15] KVM: x86/mmu: TLB fixes and related cleanups
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
References: <20210609234235.1244004-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5da71719-1783-0f98-072d-49139354b80f@redhat.com>
Date:   Thu, 10 Jun 2021 18:10:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 01:42, Sean Christopherson wrote:
> Fixes for two (very) theoretical TLB flushing bugs (patches 1 and 4),
> and clean ups on top to (hopefully) consolidate and simplifiy the TLB
> flushing logic.
> 
> The basic gist of the TLB flush and MMU sync code shuffling  is to stop
> relying on the logic in __kvm_mmu_new_pgd() (but keep it for forced
> flushing), and instead handle the flush+sync logic in the caller
> independent from whether or not the "fast" switch occurs.
> 
> I spent a fair bit of time trying to shove the necessary logic down into
> __kvm_mmu_new_pgd(), but it always ended up a complete mess because the
> requirements and contextual information is always different.  The rules
> for MOV CR3 are different from nVMX transitions (and those vary based on
> EPT+VPID), and nSVM will be different still (once it adds proper TLB
> handling).  In particular, I like that nVMX no longer has special code
> for synchronizing the MMU when using shadowing paging and instead relies
> on the common rules for TLB flushing.
> 
> Note, this series (indirectly) relies heavily on commit b53e84eed08b
> ("KVM: x86: Unload MMU on guest TLB flush if TDP disabled to force MMU
> sync"), as it uses KVM_REQ_TLB_FLUSH_GUEST (was KVM_REQ_HV_TLB_FLUSH)
> to do the TLB flush _and_ the MMU sync in non-PV code.
> 
> Tested all combinations for i386, EPT, NPT, and shadow paging. I think...
> 
> The EPTP switching and INVPCID single-context changes in particular lack
> meaningful coverage in kvm-unit-tests+Linux.  Long term it's on my todo
> list to remedy that, but realistically I doubt I'll get it done anytime
> soon.
> 
> To test EPTP switching, I hacked L1 to set up a duplicate top-level EPT
> table, copy the "real" table to the duplicate table on EPT violation,
> populate VMFUNC.EPTP_LIST with the two EPTPs, expose  VMFUNC.EPTP_SWITCH
> to L2.  I then hacked L2 to do an EPTP switch to a random (valid) EPTP
> index on every task switch.
> 
> To test INVPCID single-context I modified L1 to iterate over all possible
> PCIDs using INVPCID single-context in native_flush_tlb_global().  I also
> verified that the guest crashed if it didn't do any INVPCID at all
> (interestingly, the guest made it through boot without the flushes when
> EPT was enabled, which implies the missing MMU sync on INVPCID was the
> source of the crash, not a stale TLB entry).
> 
> Sean Christopherson (15):
>    KVM: nVMX: Sync all PGDs on nested transition with shadow paging
>    KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap
>    KVM: nVMX: Don't clobber nested MMU's A/D status on EPTP switch
>    KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush
>    KVM: x86: Uncondtionally skip MMU sync/TLB flush in MOV CR3's PGD
>      switch
>    KVM: nSVM: Move TLB flushing logic (or lack thereof) to dedicated
>      helper
>    KVM: x86: Drop skip MMU sync and TLB flush params from "new PGD"
>      helpers
>    KVM: nVMX: Consolidate VM-Enter/VM-Exit TLB flush and MMU sync logic
>    KVM: nVMX: Free only guest_mode (L2) roots on INVVPID w/o EPT
>    KVM: x86: Use KVM_REQ_TLB_FLUSH_GUEST to handle INVPCID(ALL) emulation
>    KVM: nVMX: Use fast PGD switch when emulating VMFUNC[EPTP_SWITCH]
>    KVM: x86: Defer MMU sync on PCID invalidation
>    KVM: x86: Drop pointless @reset_roots from kvm_init_mmu()
>    KVM: nVMX: WARN if subtly-impossible VMFUNC conditions occur
>    KVM: nVMX: Drop redundant checks on vmcs12 in EPTP switching emulation
> 
>   arch/x86/include/asm/kvm_host.h |   6 +-
>   arch/x86/kvm/hyperv.c           |   2 +-
>   arch/x86/kvm/mmu.h              |   2 +-
>   arch/x86/kvm/mmu/mmu.c          |  57 ++++++++-----
>   arch/x86/kvm/svm/nested.c       |  40 ++++++---
>   arch/x86/kvm/vmx/nested.c       | 139 ++++++++++++--------------------
>   arch/x86/kvm/x86.c              |  75 ++++++++++-------
>   7 files changed, 169 insertions(+), 152 deletions(-)
> 

I tried this a couple times but was blocked on what is essentially your 
first patch, so thanks!  Patches queued for 5.14.

Paolo


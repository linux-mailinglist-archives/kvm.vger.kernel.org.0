Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08A32951F1
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 20:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503833AbgJUSBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 14:01:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503828AbgJUSBZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 14:01:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603303282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xOMd3ovdN5AdHh0Qp+hJcCgYWSh7PiF+dyOCFeIRp8=;
        b=hpF8jKCdMdUuCTulc5UHMsJyUvYs67sSNoGxeAKhxlgutkqq+t85/2Q0AMQH4WMR+jO35N
        7hOCXMxjEPImJ9C4WjjjPt/o/skDQHD0SXjuK5g53Ty52cWW1O/7MCcEhmuO36NIEqTbcp
        baIiAjEqYY6e9i/oQgwVUDQ1sFx45Kw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-_Sw_L_TQOjuwVq_Qdasq1g-1; Wed, 21 Oct 2020 14:01:20 -0400
X-MC-Unique: _Sw_L_TQOjuwVq_Qdasq1g-1
Received: by mail-wm1-f71.google.com with SMTP id v14so1896617wmj.6
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 11:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6xOMd3ovdN5AdHh0Qp+hJcCgYWSh7PiF+dyOCFeIRp8=;
        b=AZhzQo3H9S33/HVWZD6zQZ1TjLRd/uZLtTWStmBAjdZuaFPqTyF5Ubl/TeETeepb3S
         lPK2zSyXlTTKmSKiZppfVyW0ud9NH9yUH3nx1R+R/tk2ksyBqORorWLcnMr0+tAFys0i
         hCHwKqGAHfcZ4nYpAbZnxcxiUMN5GWuShqnEHx3sOEsmJL+JBBQo7aamZrjFxf3e0vS4
         RVZeJKgBiTw2RcrhIrYdTo9AP9Yn9kmGQxNBXAbR3e+QgrotGbnLPizzgpoZ8GabBwxs
         /z7j1LPsyWiTC71e8Lugx60W6XgW8kbQV+tRoSjzfgR6mzcIyx9pwEJ6SbF/uWZStr9n
         nxXQ==
X-Gm-Message-State: AOAM533Bxy83RJyZQHTdkx1afaIbmhuyZKijmgXbmw6AP7FRtw1b95PV
        IUOuGGUkx/erotUuQ6ky12B1VWNiiiSG/ke/QhzO7yaJroyJlNR53gNJHmZ3rvjlMXOhrxGrrgj
        6iblPEMNnOIRK
X-Received: by 2002:adf:e4c8:: with SMTP id v8mr6017453wrm.72.1603303278938;
        Wed, 21 Oct 2020 11:01:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiraI0nVoPAX89/NGd4+iH6KeJNmAp1mjHAFLWrA/jZ9tDyrCgI+rRJg16l3vqkWRVjlIQCg==
X-Received: by 2002:adf:e4c8:: with SMTP id v8mr6017419wrm.72.1603303278631;
        Wed, 21 Oct 2020 11:01:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y5sm5114130wrw.52.2020.10.21.11.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 11:01:17 -0700 (PDT)
Subject: Re: [PATCH v2 04/20] kvm: x86/mmu: Allocate and free TDP MMU roots
To:     Ben Gardon <bgardon@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20201014182700.2888246-1-bgardon@google.com>
 <20201014182700.2888246-5-bgardon@google.com>
 <20201021150917.xkiq74pbb63rqxvu@linux.intel.com>
 <CANgfPd_YpHUat5psxPfewz2bQgNXpVZUpLnpP-2VjYsYS_q0Sw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6a8009d-cfe9-8427-1e15-4212e307ce60@redhat.com>
Date:   Wed, 21 Oct 2020 20:01:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd_YpHUat5psxPfewz2bQgNXpVZUpLnpP-2VjYsYS_q0Sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/20 19:54, Ben Gardon wrote:
> On Wed, Oct 21, 2020 at 8:09 AM Yu Zhang <yu.c.zhang@linux.intel.com> wrote:
>>
>> On Wed, Oct 14, 2020 at 11:26:44AM -0700, Ben Gardon wrote:
>>> The TDP MMU must be able to allocate paging structure root pages and track
>>> the usage of those pages. Implement a similar, but separate system for root
>>> page allocation to that of the x86 shadow paging implementation. When
>>> future patches add synchronization model changes to allow for parallel
>>> page faults, these pages will need to be handled differently from the
>>> x86 shadow paging based MMU's root pages.
>>>
>>> Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
>>> machine. This series introduced no new failures.
>>>
>>> This series can be viewed in Gerrit at:
>>>       https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
>>>
>>> Signed-off-by: Ben Gardon <bgardon@google.com>
>>> ---
>>>  arch/x86/include/asm/kvm_host.h |   1 +
>>>  arch/x86/kvm/mmu/mmu.c          |  29 +++++---
>>>  arch/x86/kvm/mmu/mmu_internal.h |  24 +++++++
>>>  arch/x86/kvm/mmu/tdp_mmu.c      | 114 ++++++++++++++++++++++++++++++++
>>>  arch/x86/kvm/mmu/tdp_mmu.h      |   5 ++
>>>  5 files changed, 162 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 6b6dbc20ce23a..e0ec1dd271a32 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -989,6 +989,7 @@ struct kvm_arch {
>>>        * operations.
>>>        */
>>>       bool tdp_mmu_enabled;
>>> +     struct list_head tdp_mmu_roots;
>>>  };
>>>
>>>  struct kvm_vm_stat {
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index f53d29e09367c..a3340ed59ad1d 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -144,11 +144,6 @@ module_param(dbg, bool, 0644);
>>>  #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
>>>                       | shadow_x_mask | shadow_nx_mask | shadow_me_mask)
>>>
>>> -#define ACC_EXEC_MASK    1
>>> -#define ACC_WRITE_MASK   PT_WRITABLE_MASK
>>> -#define ACC_USER_MASK    PT_USER_MASK
>>> -#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
>>> -
>>>  /* The mask for the R/X bits in EPT PTEs */
>>>  #define PT64_EPT_READABLE_MASK                       0x1ull
>>>  #define PT64_EPT_EXECUTABLE_MASK             0x4ull
>>> @@ -209,7 +204,7 @@ struct kvm_shadow_walk_iterator {
>>>            __shadow_walk_next(&(_walker), spte))
>>>
>>>  static struct kmem_cache *pte_list_desc_cache;
>>> -static struct kmem_cache *mmu_page_header_cache;
>>> +struct kmem_cache *mmu_page_header_cache;
>>>  static struct percpu_counter kvm_total_used_mmu_pages;
>>>
>>>  static u64 __read_mostly shadow_nx_mask;
>>> @@ -3588,9 +3583,13 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>>>               return;
>>>
>>>       sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
>>> -     --sp->root_count;
>>> -     if (!sp->root_count && sp->role.invalid)
>>> -             kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
>>> +
>>> +     if (kvm_mmu_put_root(sp)) {
>>> +             if (sp->tdp_mmu_page)
>>> +                     kvm_tdp_mmu_free_root(kvm, sp);
>>> +             else if (sp->role.invalid)
>>> +                     kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
>>> +     }
>>>
>>>       *root_hpa = INVALID_PAGE;
>>>  }
>>> @@ -3680,8 +3679,16 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>>>       hpa_t root;
>>>       unsigned i;
>>>
>>> -     if (shadow_root_level >= PT64_ROOT_4LEVEL) {
>>> -             root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
>>> +     if (vcpu->kvm->arch.tdp_mmu_enabled) {
>>> +             root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
>>> +
>>> +             if (!VALID_PAGE(root))
>>> +                     return -ENOSPC;
>>> +             vcpu->arch.mmu->root_hpa = root;
>>> +     } else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
>>> +             root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
>>> +                                   true);
>>> +
>>>               if (!VALID_PAGE(root))
>>>                       return -ENOSPC;
>>>               vcpu->arch.mmu->root_hpa = root;
>>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>>> index 74ccbf001a42e..6cedf578c9a8d 100644
>>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>>> @@ -43,8 +43,12 @@ struct kvm_mmu_page {
>>>
>>>       /* Number of writes since the last time traversal visited this page.  */
>>>       atomic_t write_flooding_count;
>>> +
>>> +     bool tdp_mmu_page;
>>>  };
>>>
>>> +extern struct kmem_cache *mmu_page_header_cache;
>>> +
>>>  static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
>>>  {
>>>       struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
>>> @@ -96,6 +100,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>>>       (PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
>>>                                               * PT64_LEVEL_BITS))) - 1))
>>>
>>> +#define ACC_EXEC_MASK    1
>>> +#define ACC_WRITE_MASK   PT_WRITABLE_MASK
>>> +#define ACC_USER_MASK    PT_USER_MASK
>>> +#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
>>> +
>>>  /* Functions for interpreting SPTEs */
>>>  static inline bool is_mmio_spte(u64 spte)
>>>  {
>>> @@ -126,4 +135,19 @@ static inline kvm_pfn_t spte_to_pfn(u64 pte)
>>>       return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
>>>  }
>>>
>>> +static inline void kvm_mmu_get_root(struct kvm_mmu_page *sp)
>>> +{
>>> +     BUG_ON(!sp->root_count);
>>> +
>>> +     ++sp->root_count;
>>> +}
>>> +
>>> +static inline bool kvm_mmu_put_root(struct kvm_mmu_page *sp)
>>> +{
>>> +     --sp->root_count;
>>> +
>>> +     return !sp->root_count;
>>> +}
>>> +
>>> +
>>>  #endif /* __KVM_X86_MMU_INTERNAL_H */
>>> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
>>> index b3809835e90b1..09a84a6e157b6 100644
>>> --- a/arch/x86/kvm/mmu/tdp_mmu.c
>>> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
>>> @@ -1,5 +1,7 @@
>>>  // SPDX-License-Identifier: GPL-2.0
>>>
>>> +#include "mmu.h"
>>> +#include "mmu_internal.h"
>>>  #include "tdp_mmu.h"
>>>
>>>  static bool __read_mostly tdp_mmu_enabled = false;
>>> @@ -29,10 +31,122 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>>>
>>>       /* This should not be changed for the lifetime of the VM. */
>>>       kvm->arch.tdp_mmu_enabled = true;
>>> +
>>> +     INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>>>  }
>>>
>>>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>>>  {
>>>       if (!kvm->arch.tdp_mmu_enabled)
>>>               return;
>>> +
>>> +     WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
>>> +}
>>> +
>>> +#define for_each_tdp_mmu_root(_kvm, _root)                       \
>>> +     list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
>>> +
>>> +bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
>>> +{
>>> +     struct kvm_mmu_page *sp;
>>> +
>>> +     sp = to_shadow_page(hpa);
>>> +
>>> +     return sp->tdp_mmu_page && sp->root_count;
>>> +}
>>> +
>>> +void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
>>> +{
>>> +     lockdep_assert_held(&kvm->mmu_lock);
>>> +
>>> +     WARN_ON(root->root_count);
>>> +     WARN_ON(!root->tdp_mmu_page);
>>> +
>>> +     list_del(&root->link);
>>> +
>>> +     free_page((unsigned long)root->spt);
>>> +     kmem_cache_free(mmu_page_header_cache, root);
>>> +}
>>> +
>>> +static void put_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
>>> +{
>>> +     if (kvm_mmu_put_root(root))
>>> +             kvm_tdp_mmu_free_root(kvm, root);
>>> +}
>>> +
>>> +static void get_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
>>> +{
>>> +     lockdep_assert_held(&kvm->mmu_lock);
>>> +
>>> +     kvm_mmu_get_root(root);
>>> +}
>>> +
>>> +static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
>>> +                                                int level)
>>> +{
>>> +     union kvm_mmu_page_role role;
>>> +
>>> +     role = vcpu->arch.mmu->mmu_role.base;
>>> +     role.level = vcpu->arch.mmu->shadow_root_level;
>>
>> role.level = level;
>> The role will be calculated for non root pages later.
> 
> Thank you for catching that Yu, that was definitely an error!
> I'm guessing this never showed up in my testing because I don't think
> the TDP MMU actually uses role.level for anything other than root
> pages.

I'll fix it up, thanks to both!

Paolo


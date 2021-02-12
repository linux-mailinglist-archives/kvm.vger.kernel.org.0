Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32F431A526
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhBLTPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhBLTPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 14:15:30 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928A9C061756
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 11:14:50 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id d7so190098otq.6
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 11:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=A9RqSgP87Al5N7r4wNTwTSkDFbyphCfYLvrQ6aInDRk=;
        b=L5U7YEPjxH6G8nAqeSl22q3t4kc9cMj0V5ZcpRLpNt5ygWxXRI3ai4ukdwx5B0hA3S
         5J5XVbQ0n5NG7fB8nIyycGr06gFKU3fGG0uvgArJkJMzCp9NnzHKQO73EhdFfMPHHR38
         Dqwltz9ZPxWhnrZj0rpgy5AmfI3g+dzzSKQ7N5LyQyvvon1nXvvlfsTxPqiR4H+7GKJe
         Uk2+w4Os4zl5CYMNXrKVoMCot74tyVzIehuVYoV3tccirX1laSx0PujItNqePBR1q5gv
         7iXUTNg4hHReoYaFffIcA+HJmy0YT14hlR8ENfDblDYyY618KrdIDI5xW02qFMGOGXJ2
         Vg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=A9RqSgP87Al5N7r4wNTwTSkDFbyphCfYLvrQ6aInDRk=;
        b=kQYCNqfVw3n9yHUJAC13tw9dN/bR0T0sYd/YYmagJPhpZ+aXREnhu6fozs0T3GCg9t
         m0zvlWvf9JMXUzhUWaIvz9si2VGFqWwoKjF5FccKp3pfmjopqQ8B44+OGb8zb86UzfDI
         VvYfi2mWStmsh/KN6jwbKyL1cwjPoR6nTRtU+Ii7OtMadPoHAOsxu1G5Y2NrnP+HjH59
         u8eAsOWammr6/vwzEgexYxhwa++wjwts168Vef5oJqAblLecHUEcY/GPepkm5CAIHMcy
         RHK/nSTVodqdOpzd+QkCl+VkCWWf8ap/Ilwod2RDazskQUxuQ7C7qKg4q3Ou/pwfYkC4
         g5vQ==
X-Gm-Message-State: AOAM531b4MbekFQoN0Vsyxf3+auyraDr7OoIGtmCw7U9j9dkPfguYRik
        1Z2mDCa70Wgpq2d68h7ABuNKiDANIuzcWbquMQK3AQ==
X-Google-Smtp-Source: ABdhPJyHUGrt4BzpIZGhfLTe31ciY2M3YXayULhRfj7BpsXoqqToMvRW7l98cOZfMUXRnLHhg9avxhJg+YTBLPKjel4=
X-Received: by 2002:a05:6830:56e:: with SMTP id f14mr3037587otc.85.1613157289747;
 Fri, 12 Feb 2021 11:14:49 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:9251:0:0:0:0 with HTTP; Fri, 12 Feb 2021 11:14:49
 -0800 (PST)
In-Reply-To: <YCbE+hJC8xeWnKRg@google.com>
References: <20210210212308.2219465-1-makarandsonare@google.com> <YCbE+hJC8xeWnKRg@google.com>
From:   Makarand Sonare <makarandsonare@google.com>
Date:   Fri, 12 Feb 2021 11:14:49 -0800
Message-ID: <CA+qz5sqFYrFj=0+kq9m4huwkpC6V8MV_vy5c05VNqMgCPw+fDg@mail.gmail.com>
Subject: Re: [RESEND PATCH ] KVM: VMX: Enable/disable PML when dirty logging
 gets enabled/disabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, pshier@google.com, jmattson@google.com,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> Currently, if enable_pml=1 PML remains enabled for the entire lifetime
>> of the VM irrespective of whether dirty logging is enable or disabled.
>> When dirty logging is disabled, all the pages of the VM are manually
>> marked dirty, so that PML is effectively non-operational. Clearing
>
> s/clearing/setting
>
> Clearing is also expensive, but that can't be optimized away with this
> change.

Thanks for catching the typo, it should be setting.

>
>> the dirty bits is an expensive operation which can cause severe MMU
>> lock contention in a performance sensitive path when dirty logging
>> is disabled after a failed or canceled live migration. Also, this
>> would break if some other code path clears the dirty bits in which
>> case, PML will actually start logging dirty pages even when dirty
>> logging is disabled incurring unnecessary vmexits when the PML buffer
>> becomes full. In order to avoid this extra overhead, we should
>> enable or disable PML in VMCS when dirty logging gets enabled
>> or disabled instead of keeping it always enabled.
>
>
> ...
>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 777177ea9a35e..eb6639f0ee7eb 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4276,7 +4276,7 @@ static void
>> vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>>  	*/
>>  	exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
>>
>> -	if (!enable_pml)
>> +	if (!enable_pml || !vcpu->kvm->arch.pml_enabled)
>>  		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
>
> The checks are unnecessary if PML is dynamically toggled, i.e. this snippet
> can
> unconditionally clear PML.  When setting SECONDARY_EXEC (below snippet),
> PML
> will be preserved in the current controls, which is what we want.

Assuming a new VCPU can be added at a later time after PML is already
enabled, should we clear
PML in VMCS for the new VCPU. If yes what will be the trigger for
setting PML for the new VCPU?

>
>>  	if (cpu_has_vmx_xsaves()) {
>> @@ -7133,7 +7133,8 @@ static void vmcs_set_secondary_exec_control(struct
>> vcpu_vmx *vmx)
>>  		SECONDARY_EXEC_SHADOW_VMCS |
>>  		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
>>  		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
>> -		SECONDARY_EXEC_DESC;
>> +		SECONDARY_EXEC_DESC |
>> +		SECONDARY_EXEC_ENABLE_PML;
>>
>>  	u32 new_ctl = vmx->secondary_exec_control;
>>  	u32 cur_ctl = secondary_exec_controls_get(vmx);
>> @@ -7509,6 +7510,19 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int
>> cpu)
>>  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
>>  				     struct kvm_memory_slot *slot)
>>  {
>> +	/*
>> +	 * Check all slots and enable PML if dirty logging
>> +	 * is being enabled for the 1st slot
>> +	 *
>> +	 */
>> +	if (enable_pml &&
>> +	    kvm->dirty_logging_enable_count == 1 &&
>> +	    !kvm->arch.pml_enabled) {
>> +		kvm->arch.pml_enabled = true;
>> +		kvm_make_all_cpus_request(kvm,
>> +			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
>> +	}
>
> This is flawed.  .slot_enable_log_dirty() and .slot_disable_log_dirty() are
> only
> called when LOG_DIRTY_PAGE is toggled in an existing memslot _and_ only the
> flags of the memslot are being changed.  This fails to enable PML if the
> first
> memslot with LOG_DIRTY_PAGE is created or moved, and fails to disable PML if
> the
> last memslot with LOG_DIRTY_PAGE is deleted.

Thanks for pointing out. If there is such a scenario, what do you
suggest to handle this?

>
>> +
>>  	if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
>>  		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
>>  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
>> @@ -7517,9 +7531,39 @@ static void vmx_slot_enable_log_dirty(struct kvm
>> *kvm,
>>  static void vmx_slot_disable_log_dirty(struct kvm *kvm,
>>  				       struct kvm_memory_slot *slot)
>>  {
>> +	/*
>> +	 * Check all slots and disable PML if dirty logging
>> +	 * is being disabled for the last slot
>> +	 *
>> +	 */
>> +	if (enable_pml &&
>> +	    kvm->dirty_logging_enable_count == 0 &&
>> +	    kvm->arch.pml_enabled) {
>> +		kvm->arch.pml_enabled = false;
>> +		kvm_make_all_cpus_request(kvm,
>> +			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
>> +	}
>> +
>>  	kvm_mmu_slot_set_dirty(kvm, slot);
>>  }
>
> ...
>
>>  #define kvm_err(fmt, ...) \
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index ee4ac2618ec59..c6e5b026bbfe8 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -307,6 +307,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm,
>> unsigned int req)
>>  {
>>  	return kvm_make_all_cpus_request_except(kvm, req, NULL);
>>  }
>> +EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
>>
>>  #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
>>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>> @@ -1366,15 +1367,24 @@ int __kvm_set_memory_region(struct kvm *kvm,
>>  	}
>>
>>  	/* Allocate/free page dirty bitmap as needed */
>> -	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
>> +	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES)) {
>>  		new.dirty_bitmap = NULL;
>> -	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
>> +
>> +		if (old.flags & KVM_MEM_LOG_DIRTY_PAGES) {
>> +			WARN_ON(kvm->dirty_logging_enable_count == 0);
>> +			--kvm->dirty_logging_enable_count;
>
> The count will be corrupted if kvm_set_memslot() fails.
>
> The easiest/cleanest way to fix both this and the refcounting bug is to
> handle
> the count in kvm_mmu_slot_apply_flags().  That will also allow making the
> dirty
> log count x86-only, and it can then be renamed to cpu_dirty_log_count to
> align
> with the
>
> We can always move/rename the count variable if additional motivation for
> tracking dirty logging comes along.

Thanks for pointing out. Will this solution take care of the scenario
where a memslot is created/deleted with LOG_DIRTY_PAGE?

>
>
>> +		}
>> +
>> +	} else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
>>  		r = kvm_alloc_dirty_bitmap(&new);
>>  		if (r)
>>  			return r;
>>
>>  		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>>  			bitmap_set(new.dirty_bitmap, 0, new.npages);
>> +
>> +		++kvm->dirty_logging_enable_count;
>> +		WARN_ON(kvm->dirty_logging_enable_count == 0);
>>  	}
>>
>>  	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
>> --
>> 2.30.0.478.g8a0d178c01-goog
>

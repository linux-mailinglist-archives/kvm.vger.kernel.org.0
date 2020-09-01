Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896CE259131
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgIAOro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 10:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727956AbgIAOPO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 10:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598969712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/DfDs0YbN/7MKpdNCaVZk0bDSA0PDgnc0VVkoK+qFXE=;
        b=IX1coVLjhU735GOeWyP0HjQrfLF+rBr8mEbvkAKvhX8F/EIEw69HxhGUelV3jHDZkaIeKJ
        0WrGfjd7w/fgD/kjWt9lcY/Z2cNis+UcXkZOWgXBuT7hy1IH66yUaF0Wj2MjpeTpf1Qt//
        OXopHZAK822BlQEHQPYR0L0UOozEkEY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-21mB2Ze9MSW5bMiwohMk-w-1; Tue, 01 Sep 2020 10:15:10 -0400
X-MC-Unique: 21mB2Ze9MSW5bMiwohMk-w-1
Received: by mail-wm1-f70.google.com with SMTP id f125so512978wma.3
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 07:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/DfDs0YbN/7MKpdNCaVZk0bDSA0PDgnc0VVkoK+qFXE=;
        b=Mq5xQMtXva1EGLMI/I5Xf9wJSgXrzJvV3MvqGUj6SOnct0/Yc3PX/U0obX7ueB3yXL
         e7uadL4zsiBf5vGR0+v+PTFtH80z0gjYCUGXidwUlGTmJwu5Gow4ZxrB/mxKCoLiFOfY
         TK5d3c0sYqI0rflUGTjGEN9FlMB/XcidfYxvAKTYmYlVrFETjeBiVtBlZgcI3/+rUQkQ
         g8xDdJE49R+gy5NJ4v4QrRq+9izQjDKatmyC7TP4fhiq8FsqtcC0ch04KxcnJh/afcDf
         eMviMjkiDhZPjDf4qWS4IE3vh4I/YWEhSzw8Q16Bl0uChqfJgWSuH9fZKDvGjB0IO1x0
         cw9w==
X-Gm-Message-State: AOAM5307ZhTu2/V1pO58zJjh6fIz/gbpsOmVC7mkMH/c8BTb/9fJybPR
        WcF5qNm5kHiy9yAyzBPkVOr3L4vyM0qRaqunKhDaGJbpVdIEUOXIviBwl9oZZkuSIYDGx5WSgYd
        GMqyvlDQ9nLMV
X-Received: by 2002:a7b:cf1a:: with SMTP id l26mr1951774wmg.164.1598969709729;
        Tue, 01 Sep 2020 07:15:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynTKWM5AKf3S04xOk9sKvqAO5U5wHWO0YNFIl1nxMHh97lCLEN2zHVi4jBplQ3fbKqb5yfTw==
X-Received: by 2002:a7b:cf1a:: with SMTP id l26mr1951735wmg.164.1598969709469;
        Tue, 01 Sep 2020 07:15:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w21sm2046602wmk.34.2020.09.01.07.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 07:15:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: x86: move kvm_vcpu_gfn_to_memslot() out of try_async_pf()
In-Reply-To: <20200814014014.GA4845@linux.intel.com>
References: <20200807141232.402895-1-vkuznets@redhat.com> <20200807141232.402895-2-vkuznets@redhat.com> <20200814014014.GA4845@linux.intel.com>
Date:   Tue, 01 Sep 2020 16:15:07 +0200
Message-ID: <87k0xdwplg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Fri, Aug 07, 2020 at 04:12:30PM +0200, Vitaly Kuznetsov wrote:
>> No functional change intended. Slot flags will need to be analyzed
>> prior to try_async_pf() when KVM_MEM_PCI_HOLE is implemented.
>

(Sorry it took me so long to reply. No, I wasn't hoping for Paolo's
magical "queued, thanks", I just tried to not read my email while on
vacation).

> Why?  Wouldn't it be just as easy, and arguably more appropriate, to add
> KVM_PFN_ERR_PCI_HOLE and update handle_abornmal_pfn() accordinaly?
>

Yes, we can do that, but what I don't quite like here is that
try_async_pf() does much more than 'trying async PF'. In particular, it
extracts 'pfn' and this is far from being obvious. Maybe we can rename
try_async_pf() somewhat smartly (e.g. 'try_handle_pf()')? Your
suggestion will make perfect sense to me then.

>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c         | 14 ++++++++------
>>  arch/x86/kvm/mmu/paging_tmpl.h |  7 +++++--
>>  2 files changed, 13 insertions(+), 8 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 862bf418214e..fef6956393f7 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4042,11 +4042,10 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>  				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
>>  }
>>  
>> -static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>> -			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
>> -			 bool *writable)
>> +static bool try_async_pf(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>> +			 bool prefault, gfn_t gfn, gpa_t cr2_or_gpa,
>> +			 kvm_pfn_t *pfn, bool write, bool *writable)
>>  {
>> -	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>>  	bool async;
>>  
>>  	/* Don't expose private memslots to L2. */
>> @@ -4082,7 +4081,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>>  	bool exec = error_code & PFERR_FETCH_MASK;
>>  	bool lpage_disallowed = exec && is_nx_huge_page_enabled();
>>  	bool map_writable;
>> -
>> +	struct kvm_memory_slot *slot;
>>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>>  	unsigned long mmu_seq;
>>  	kvm_pfn_t pfn;
>> @@ -4104,7 +4103,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>>  	smp_rmb();
>>  
>> -	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
>> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>> +
>> +	if (try_async_pf(vcpu, slot, prefault, gfn, gpa, &pfn, write,
>> +			 &map_writable))
>>  		return RET_PF_RETRY;
>>  
>>  	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
>> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
>> index 0172a949f6a7..5c6a895f67c3 100644
>> --- a/arch/x86/kvm/mmu/paging_tmpl.h
>> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
>> @@ -779,6 +779,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>>  	int write_fault = error_code & PFERR_WRITE_MASK;
>>  	int user_fault = error_code & PFERR_USER_MASK;
>>  	struct guest_walker walker;
>> +	struct kvm_memory_slot *slot;
>>  	int r;
>>  	kvm_pfn_t pfn;
>>  	unsigned long mmu_seq;
>> @@ -833,8 +834,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>>  	smp_rmb();
>>  
>> -	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
>> -			 &map_writable))
>> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, walker.gfn);
>> +
>> +	if (try_async_pf(vcpu, slot, prefault, walker.gfn, addr, &pfn,
>> +			 write_fault, &map_writable))
>>  		return RET_PF_RETRY;
>>  
>>  	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
>> -- 
>> 2.25.4
>> 
>

-- 
Vitaly


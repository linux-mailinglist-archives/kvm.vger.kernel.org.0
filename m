Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6C33DDBB6
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhHBPAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 11:00:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234518AbhHBPAH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 11:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627916397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZGliIfJBEHexOCPQGqPO8C8AjQrhwCqXvf0JbC+DPHo=;
        b=hVXa74XHlv52iqL2kBpfkNdzg+FybkvURsxVPIVr6gQetubg/tTfVM2DuyozHDZL8Djolj
        KoDtu9Spw63gIDombY8tyZEaio2KgTW7IBJjFjh2VeYWcWTlzPRq6uwbV/6s/2OKljSL6d
        GCCk2dPilzSn87IDnkQ0bS41rjMaZPQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-91hF76AEPTawjEEl__Vfaw-1; Mon, 02 Aug 2021 10:59:56 -0400
X-MC-Unique: 91hF76AEPTawjEEl__Vfaw-1
Received: by mail-wr1-f72.google.com with SMTP id d7-20020adffd870000b02901544ea2018fso3465709wrr.10
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 07:59:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZGliIfJBEHexOCPQGqPO8C8AjQrhwCqXvf0JbC+DPHo=;
        b=IYWp4I+qLmZ3d/sTgLFMwbeyFxMYVG3oe8kI2Nb6bjO49ve5VOIPXAYai/+t2XRiEP
         Qq7gD0rMhrj5/xTgg++wdPgGZUU36KLZjnbOTzhCmSau/2yuALZCWwF2dUIvvxgRXn5W
         3Km+adj2Nukt/+0x2fWrZQ5u2pWtGTY+BrwkNCXchqyNER9/BNHRUEBZcvBDTZNHKr0+
         HjfJsbR/YHDXBO7MFdDxBnF4zD9mfZTaY/jhalcamSoDmxG24r5j8LidcwqCJKO8Un2v
         w3l4HtSbKGKAXXPLSmLBzYmx1HW9g/Z4VSyvdjGpHKRolzXyXWiL+WtIUQ6sMlIeaYh8
         SK8g==
X-Gm-Message-State: AOAM532Xs/stIcaWJzbHJVu4VkvPnkNIkanOhoQP5LVTPmHuXwtz43AZ
        Mz7lXA/Exg88wSv7zPRineaqTnKBZpJraJZ6Pm9qHZqe3a8LrKXcLoEd1zNiYboIgqU4V5hAaHt
        IToqSMyL9eYBI
X-Received: by 2002:adf:80e8:: with SMTP id 95mr18150741wrl.388.1627916395556;
        Mon, 02 Aug 2021 07:59:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7+cjWAWN+T4atLoy+bwc7s+8haOi45vgtyaUXf4iYn94Yld31ccLtL9/CnIj87WUkeVI92g==
X-Received: by 2002:adf:80e8:: with SMTP id 95mr18150719wrl.388.1627916395363;
        Mon, 02 Aug 2021 07:59:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l9sm11422889wro.92.2021.08.02.07.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:59:54 -0700 (PDT)
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Rename __gfn_to_rmap to gfn_to_rmap
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210730223707.4083785-1-dmatlack@google.com>
 <20210730223707.4083785-6-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c513647b-5b3b-f65b-b69d-77714fa128e2@redhat.com>
Date:   Mon, 2 Aug 2021 16:59:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730223707.4083785-6-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/21 00:37, David Matlack wrote:
> gfn_to_rmap was removed in the previous patch so there is no need to
> retain the double underscore on __gfn_to_rmap.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 25 ++++++++++++-------------
>   1 file changed, 12 insertions(+), 13 deletions(-)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

apart from the extra mmu_audit.c changes.

Paolo

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 370a6ebc2ede..df493729d86c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1034,8 +1034,8 @@ static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
>   	return true;
>   }
>   
> -static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
> -					   const struct kvm_memory_slot *slot)
> +static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
> +					 const struct kvm_memory_slot *slot)
>   {
>   	unsigned long idx;
>   
> @@ -1060,7 +1060,7 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
>   	sp = sptep_to_sp(spte);
>   	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
>   	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> -	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
> +	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
>   	return pte_list_add(vcpu, spte, rmap_head);
>   }
>   
> @@ -1084,7 +1084,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
>   	slots = kvm_memslots_for_spte_role(kvm, sp->role);
>   
>   	slot = __gfn_to_memslot(slots, gfn);
> -	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
> +	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
>   
>   	__pte_list_remove(spte, rmap_head);
>   }
> @@ -1306,8 +1306,8 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>   		return;
>   
>   	while (mask) {
> -		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
> -					  PG_LEVEL_4K, slot);
> +		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
> +					PG_LEVEL_4K, slot);
>   		__rmap_write_protect(kvm, rmap_head, false);
>   
>   		/* clear the first set bit */
> @@ -1339,8 +1339,8 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>   		return;
>   
>   	while (mask) {
> -		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
> -					  PG_LEVEL_4K, slot);
> +		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
> +					PG_LEVEL_4K, slot);
>   		__rmap_clear_dirty(kvm, rmap_head, slot);
>   
>   		/* clear the first set bit */
> @@ -1406,7 +1406,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>   
>   	if (kvm_memslots_have_rmaps(kvm)) {
>   		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
> -			rmap_head = __gfn_to_rmap(gfn, i, slot);
> +			rmap_head = gfn_to_rmap(gfn, i, slot);
>   			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
>   		}
>   	}
> @@ -1506,9 +1506,8 @@ rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
>   {
>   	iterator->level = level;
>   	iterator->gfn = iterator->start_gfn;
> -	iterator->rmap = __gfn_to_rmap(iterator->gfn, level, iterator->slot);
> -	iterator->end_rmap = __gfn_to_rmap(iterator->end_gfn, level,
> -					   iterator->slot);
> +	iterator->rmap = gfn_to_rmap(iterator->gfn, level, iterator->slot);
> +	iterator->end_rmap = gfn_to_rmap(iterator->end_gfn, level, iterator->slot);
>   }
>   
>   static void
> @@ -1638,7 +1637,7 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
>   
>   	sp = sptep_to_sp(spte);
>   	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> -	rmap_head = __gfn_to_rmap(gfn, sp->role.level, slot);
> +	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
>   
>   	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
>   	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
> 


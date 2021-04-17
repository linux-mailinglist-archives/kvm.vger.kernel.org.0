Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD9436300C
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhDQMvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 08:51:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236430AbhDQMvJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 08:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZaTcXtyBPdVI0SxVxqAEtYLRW7IktHO5BV2EA4cxMMo=;
        b=Bcqvam9hlgHPTppmncGY7y4QsgDV0C2LENLVdl+Guc5XAw7A2qaUg9e6TaTZk4DW31tkBR
        JEavMRFiP3lB+pPwgLJy38GDLJk4jMR9EMDtOK8pSDOsRLWmK/Rppd3fRnXEmYTRGg91R9
        BcH0AGzWc37n2CqfyoGBjIloduS/Hqk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-HEPCvPvbM2eb3AD4lTXDHQ-1; Sat, 17 Apr 2021 08:50:41 -0400
X-MC-Unique: HEPCvPvbM2eb3AD4lTXDHQ-1
Received: by mail-ed1-f72.google.com with SMTP id m18-20020a0564025112b0290378d2a266ebso8585079edd.15
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 05:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZaTcXtyBPdVI0SxVxqAEtYLRW7IktHO5BV2EA4cxMMo=;
        b=KURQtXMoTQT2frPhFqA+k2mZsSxjPPLSlVPt0KdtVtDL68PIfxAtHnuLyHdG572DaT
         DpyXrRHvpXdgLDhFPBRtzHtJnKOGcCzNiZJzn3xXMgOye9kopIuJX0QceO2/PVzcbAj4
         MLVI6QXPay79frKArqhZpykxs1ZZy6ApmVBhl0xfGOavlbrrPXMKgntfFZNk1x/eKoUQ
         wpbP89QhMTG4knylWtSfZwx/8yKVDednW88hwV4ApeZXwelCJ1ZZb00Ao5kjsnqSTD8T
         fll7UQJjtJEas9N5kJDZOyRe2G4MHM8uMLWzmh4fdyAvUzmteP2i12nH3F2jx7OyNWlN
         VzlQ==
X-Gm-Message-State: AOAM532PhyxMWoeOdnbIrXDOcF3iaobiR+13Ydr3/u2fi7BOkUeaQ6SU
        qeebcyumT+OM6zV1PtP+njLdAlj56L/60KbaltFmD6+BHq9W2JC11Ct0qvElGUMqt6PgABn8dkj
        73rVDzyT8LI4b
X-Received: by 2002:a17:906:c29a:: with SMTP id r26mr12667255ejz.259.1618663840298;
        Sat, 17 Apr 2021 05:50:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIf7mi5DtpN2IQG233RbYf3mpawFrXCI+aHZoFvdgJevu/Q4WnkMS+P//lsbO1vapOn52cTg==
X-Received: by 2002:a17:906:c29a:: with SMTP id r26mr12667244ejz.259.1618663840159;
        Sat, 17 Apr 2021 05:50:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f20sm3141726ejw.36.2021.04.17.05.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:50:39 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Remove unused function declaration
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     wanghaibin.wang@huawei.com, jiangkunkun@huawei.com
References: <20210406063504.17552-1-zhukeqian1@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ceed9a2-fa5a-0b47-d4c2-8b16c1ef100a@redhat.com>
Date:   Sat, 17 Apr 2021 14:50:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210406063504.17552-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/21 08:35, Keqian Zhu wrote:
> kvm_mmu_slot_largepage_remove_write_access() is decared but not used,
> just remove it.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3768819693e5..9c0af0971c9f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1440,8 +1440,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   				   const struct kvm_memory_slot *memslot);
>   void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>   				   struct kvm_memory_slot *memslot);
> -void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
> -					struct kvm_memory_slot *memslot);
>   void kvm_mmu_zap_all(struct kvm *kvm);
>   void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
>   unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
> 

Queued, thanks.

Paolo


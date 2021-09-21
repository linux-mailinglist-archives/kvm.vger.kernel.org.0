Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1775413561
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 16:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhIUOch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 10:32:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233688AbhIUOcg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 10:32:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632234667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOX0Dc/uscmy0FcdNSM5vS8dhWPJhduTSx1fXAnSXC8=;
        b=FwYtxjDjVCw9V/TUF/Wb9IJf5yoNA8Doc6Rwg0J7vse7+RufmDQJJjvOeF0DyEU1DRwcHy
        qAP2qhZIbo1eI6rItaSjj+rOrRolqVENP08qnseiteVadyWk6DusflwTp2bSggqOLY9Ql+
        ZXwd5eU0oTZh+spYV+2JHR38D60ysU0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-wMzZUtTkN5-nAVIc6hrFEQ-1; Tue, 21 Sep 2021 10:31:06 -0400
X-MC-Unique: wMzZUtTkN5-nAVIc6hrFEQ-1
Received: by mail-wr1-f69.google.com with SMTP id e1-20020adfa741000000b0015e424fdd01so8527095wrd.11
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 07:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MOX0Dc/uscmy0FcdNSM5vS8dhWPJhduTSx1fXAnSXC8=;
        b=Xh2teThHU+MpxHAcVtyS41o6I9Uba0aJDdjf0Wh9dOs+MGSpAR0Sn7aDfDWEEhCv5p
         thNOL4GU07MZBjJZGdc4OyeQBv8ZeumjyPw937011T6e4uoXbEpkBIxRWR5vKvMmwuoB
         IsSOEGAAuL2ik5AXGRA9jXK7knh4ZPITXGGfbj1uKMBw1VPYn2Yt/f5ikZx9qruidpW9
         Brez4446CA0au5d4CfPtVzieRyXzjqRpPbWhZug8oJKKBGFNUbWGaN1eDk6CrIYsoMe6
         qZ4dufJd3HiFMZJhdVisARexhkZSZA9tYmWEFelyXIkjPQieU2upawGLP61BOXDvcCOy
         j5sg==
X-Gm-Message-State: AOAM531jse+bn/COe7SzfPtmug60NMx0JPJ98aVi3A2H1uEL6Utk68Hf
        7z1Zm+dy1SCBLdOrtAlUL6MiguCQjrQtVQqamiV6WR2JNxx6x0NeSMuOvag6GY3iksUMbjqH7BK
        /1SQy10e+Ouco
X-Received: by 2002:a5d:618c:: with SMTP id j12mr5290851wru.189.1632234664880;
        Tue, 21 Sep 2021 07:31:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEM4NkwElgrp8f4cKqvFX/IpJVIPqq7dPySdWEovhmE4HewFeU/2oUKAxYrjP8y0ckUQpo6w==
X-Received: by 2002:a5d:618c:: with SMTP id j12mr5290820wru.189.1632234664676;
        Tue, 21 Sep 2021 07:31:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r27sm19634987wrr.70.2021.09.21.07.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 07:31:04 -0700 (PDT)
Subject: Re: [PATCH] [backport for 4.19/5.4 stable] KVM: remember position in
 kvm->vcpus array
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20210921134815.17615-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <280d7fb4-a02a-f8db-8af0-b567699cea80@redhat.com>
Date:   Tue, 21 Sep 2021 16:31:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921134815.17615-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/21 15:48, Christian Borntraeger wrote:
> From: Radim Krčmář <rkrcmar@redhat.com>
> 
> Fetching an index for any vcpu in kvm->vcpus array by traversing
> the entire array everytime is costly.
> This patch remembers the position of each vcpu in kvm->vcpus array
> by storing it in vcpus_idx under kvm_vcpu structure.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [borntraeger@de.ibm.com]: backport to 4.19 (also fits for 5.4)
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   include/linux/kvm_host.h | 11 +++--------
>   virt/kvm/kvm_main.c      |  5 +++--
>   2 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8dd4ebb58e97..827f70ce0b49 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -248,7 +248,8 @@ struct kvm_vcpu {
>   	struct preempt_notifier preempt_notifier;
>   #endif
>   	int cpu;
> -	int vcpu_id;
> +	int vcpu_id; /* id given by userspace at creation */
> +	int vcpu_idx; /* index in kvm->vcpus array */
>   	int srcu_idx;
>   	int mode;
>   	u64 requests;
> @@ -551,13 +552,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
>   
>   static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
>   {
> -	struct kvm_vcpu *tmp;
> -	int idx;
> -
> -	kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
> -		if (tmp == vcpu)
> -			return idx;
> -	BUG();
> +	return vcpu->vcpu_idx;
>   }
>   
>   #define kvm_for_each_memslot(memslot, slots)	\
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a3d82113ae1c..86ef740763b5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2751,7 +2751,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   		goto unlock_vcpu_destroy;
>   	}
>   
> -	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
> +	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> +	BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
>   
>   	/* Now it's all set up, let userspace reach it */
>   	kvm_get_kvm(kvm);
> @@ -2761,7 +2762,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   		goto unlock_vcpu_destroy;
>   	}
>   
> -	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
> +	kvm->vcpus[vcpu->vcpu_idx] = vcpu;
>   
>   	/*
>   	 * Pairs with smp_rmb() in kvm_get_vcpu.  Write kvm->vcpus
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

The backport makes sense given the code in the stable branch now calls 
kvm_vcpu_get_idx more than it used to.

Paolo


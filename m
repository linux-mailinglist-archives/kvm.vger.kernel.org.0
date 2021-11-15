Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4134501E4
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 10:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhKOKCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 05:02:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230466AbhKOKCn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 05:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636970388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B/SvcVH7YGPEpdGy0kldgGpabVd0LqF8PKRRi3YrNP0=;
        b=OV0fmFC1X1F4fhZlZXh+EtFcYHf/ZIip1Q4FE6QGf6xMbXgXnu1X1xfKvby+r9wqVnUU1S
        Dp3ra/pzcxZ6OxK1ScNAK/hyKatbkBAEe38I+daUWFJUddOiWlvydoUotWUUd5c4klyjmg
        DJn45V8/0Zn5gHLtA1wJMrETCdvmGdE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-AmzmbT5CNKCWuWvw0l1v9A-1; Mon, 15 Nov 2021 04:59:46 -0500
X-MC-Unique: AmzmbT5CNKCWuWvw0l1v9A-1
Received: by mail-wr1-f71.google.com with SMTP id f3-20020a5d50c3000000b00183ce1379feso3331262wrt.5
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 01:59:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=B/SvcVH7YGPEpdGy0kldgGpabVd0LqF8PKRRi3YrNP0=;
        b=lXc40rSIJSBkqRWVo91WJ84SW//zTfZOGkxEqAYozozZT9t5T2LH8Ihd9FsvYk2P/J
         e7LluKqpaFNDkFFvJo4LiRHSAC7xQj1pzM63nVYbc5SD/Dcwjg0mKA4c1rC7lxeRKra6
         0Y5sTfVaGa51c8f5PpPygbuULsM31SI1xS3tY/kstaGzcKa59UcWltVHcccCGrgq9qlh
         d5aCeTML6y1QX+4BzNQT7MwZmwSXZX/AfJWv7E63z5Wd8FtaemuwcVKBQHAfU0YpXgWD
         A7Xla6wcMsmVuUe8gwPvGtAvz0XxEhCuTHZulbqAu8xyNN+W5r+yEKSoPwIYnQGLs42p
         2ybQ==
X-Gm-Message-State: AOAM531UCNS6pq1mgj6WJ5tewE3IU2SByt+EcRlKrOC7+G1ewN7AulPw
        xGF5es3xjxact6Mq3Eg8qXCUurLDTKNug6XRMZhDCD3hTNywIzZRKQ3gmevXAbJ+qZr4rHDfT+K
        iN1SNUT4gpVT9
X-Received: by 2002:a5d:6a4d:: with SMTP id t13mr45338958wrw.104.1636970385746;
        Mon, 15 Nov 2021 01:59:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxET7RTckB554LQIAx6+HrM6N8Dg2rkSK6DQZ3M5guhyRvwKp4nwnmtbibpn9DS93s70y3/RQ==
X-Received: by 2002:a5d:6a4d:: with SMTP id t13mr45338930wrw.104.1636970385596;
        Mon, 15 Nov 2021 01:59:45 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m20sm21093886wmq.11.2021.11.15.01.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 01:59:45 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vihas Mak <makvihas@gmail.com>, pbonzini@redhat.com
Cc:     seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix cocci warnings
In-Reply-To: <20211114164312.GA28736@makvihas>
References: <20211114164312.GA28736@makvihas>
Date:   Mon, 15 Nov 2021 10:59:43 +0100
Message-ID: <87o86leo34.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vihas Mak <makvihas@gmail.com> writes:

> change 0 to false and 1 to true to fix following cocci warnings:
>
>         arch/x86/kvm/mmu/mmu.c:1485:9-10: WARNING: return of 0/1 in function 'kvm_set_pte_rmapp' with return type bool
>         arch/x86/kvm/mmu/mmu.c:1636:10-11: WARNING: return of 0/1 in function 'kvm_test_age_rmapp' with return type bool
>
> Signed-off-by: Vihas Mak <makvihas@gmail.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 337943799..2fcea4a78 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1454,7 +1454,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  {
>  	u64 *sptep;
>  	struct rmap_iterator iter;
> -	int need_flush = 0;
> +	bool need_flush = false;
>  	u64 new_spte;
>  	kvm_pfn_t new_pfn;
>  
> @@ -1466,7 +1466,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  		rmap_printk("spte %p %llx gfn %llx (%d)\n",
>  			    sptep, *sptep, gfn, level);
>  
> -		need_flush = 1;
> +		need_flush = true;
>  
>  		if (pte_write(pte)) {
>  			pte_list_remove(kvm, rmap_head, sptep);
> @@ -1482,7 +1482,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  
>  	if (need_flush && kvm_available_flush_tlb_with_range()) {
>  		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> -		return 0;
> +		return false;
>  	}
>  
>  	return need_flush;
> @@ -1623,8 +1623,8 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  
>  	for_each_rmap_spte(rmap_head, &iter, sptep)
>  		if (is_accessed_spte(*sptep))
> -			return 1;
> -	return 0;
> +			return true;
> +	return false;
>  }
>  
>  #define RMAP_RECYCLE_THRESHOLD 1000

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

One minor remark: 'kvm_set_pte_rmapp()' handler is passed to
'kvm_handle_gfn_range()' which does

        bool ret = false;

        for_each_slot_rmap_range(...)
                ret |= handler(...);

and I find '|=' to not be very natural with booleans. I'm not sure it's
worth changing though.

-- 
Vitaly


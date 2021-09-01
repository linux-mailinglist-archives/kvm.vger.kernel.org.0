Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED33FE616
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 02:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242126AbhIAX3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 19:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238839AbhIAX3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 19:29:48 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBFFC061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 16:28:50 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id e16so165266pfc.6
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 16:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xnO4j3l8wgJkh+udehwpdOizZik5cmOQlEavHkKD14I=;
        b=cR3xbTcUYCXq2yoOsmEspRhLaJO0nhRFvKabyIOpQDKuImzIfWfB0ZS6A7fkLsSqvh
         IqbsElaLQZagzefg295QvN3rHWXa8FNfpUz3Z6sYq+/NvtYmEPcqO4zOs2KYR2cPSLMq
         poDNPxSc6wtpYpgY+vPI/Oe5oBaROvf1tBc4O2oHsnNacC8dCW/s5K7yEMrlUwrFpEv0
         ForMquYnyLQGbyCbEam/KOl3jQUcSjZ8kmsOLacN6udbb9AVFNyz99MKyhUA6llS8dX0
         55+YRa4wGvdy6Bo17uEeO5rsxxc9Wbti96oOw/CAeWfiUU/tKfcEO5fcIXoKgkvRV/EH
         Useg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xnO4j3l8wgJkh+udehwpdOizZik5cmOQlEavHkKD14I=;
        b=hCpbxvie1zWQIDmkMvGDONcSNJW0REeleQFG6/XGhs+F1eU2afQKvyWppdo46vQwg9
         vgrRayEkEecJ3kzxjepY6j0CSx8H+NjgQBY5ue0+mvfOZQuF/bV0A0CwKiP85zFnom1K
         f+WtfECuqXKkUmH1mgN/zO3VDQ5P8JYdPnDrwF2xTKdiAKVBW1y1YmGke82mju2piA15
         NkporT4JAqsHS5yUHQbPhwbqjo0jHaBfa6YmU/i4A/pKqK3oMmtE4qDK6nalzjO/qMtf
         tLv4jDTiXWsnAl3s45yLlHHMGYB6WGbhHz1e7SM6Go5e7sbbKBCeimA6CH0Z6+dTXnc3
         gBHw==
X-Gm-Message-State: AOAM532AnDOEwmW2WN6AyNhBfUF5Sd03vmCzHtHEDAZlPwfUUYvN6lvq
        EkQKYdMIIiXj6aQpeInh4iNO8Q==
X-Google-Smtp-Source: ABdhPJwbswGfJrA4PG3wXfULuymMHcJiKrpLfjeLLLhrkD3tOw1DXq3hjqOyvTnJrbpAY0rwMaTEyA==
X-Received: by 2002:a62:7c0d:0:b0:3fe:60d2:bce2 with SMTP id x13-20020a627c0d000000b003fe60d2bce2mr311221pfc.27.1630538930103;
        Wed, 01 Sep 2021 16:28:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ev12sm45651pjb.57.2021.09.01.16.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:28:49 -0700 (PDT)
Date:   Wed, 1 Sep 2021 23:28:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        peterx@redhat.com
Subject: Re: [PATCH 16/16] KVM: MMU: change tracepoints arguments to
 kvm_page_fault
Message-ID: <YTAMrQDY3eXY9lYO@google.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
 <20210807134936.3083984-17-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807134936.3083984-17-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 07, 2021, Paolo Bonzini wrote:
> @@ -377,9 +377,9 @@ TRACE_EVENT(
>  	),
>  
>  	TP_fast_assign(
> -		__entry->gfn = addr >> PAGE_SHIFT;
> -		__entry->pfn = pfn | (__entry->gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
> -		__entry->level = level;
> +		__entry->gfn = fault->addr >> PAGE_SHIFT;

Eww.  The existing code also bastardizes addr vs. gpa, but this just looks even
more wrong because we have fault->gfn.

Maybe do this as a prep patch at the beginning of the series?  And then use
fault->gfn directly.

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7d03e9b7ccfa..b159749300b5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -725,7 +725,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
        level = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn,
                                        huge_page_disallowed, &req_level);

-       trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
+       trace_kvm_mmu_spte_requested(gw->gfn << PAGE_SHIFT, gw->level, pfn);

        for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
                clear_sp_write_flooding_count(it.sptep);

> +		__entry->pfn = fault->pfn | (__entry->gfn & (KVM_PAGES_PER_HPAGE(fault->goal_level) - 1));

Similar thing here, it could use fault->gfn directly.

> +		__entry->level = fault->goal_level;
>  	),
>  
>  	TP_printk("gfn %llx pfn %llx level %d",

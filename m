Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA43DE279
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 00:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhHBW3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 18:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbhHBW3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 18:29:34 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A238FC0613D5
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 15:29:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k1so21350661plt.12
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 15:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9qmivmphespvuvyQ3MoQcp3D+LF94WdyvdfL2S659tE=;
        b=QTS5XBU/761TpN4U96Dh5MQybzFkqH146ItHsrUeAN+GIDp5GJqcYZ0UdTUXckdlFd
         cNSiuSkRgJEEX5Cd7UjrDqOBtgocNdFU/I3PUQFcfpmoYw/KaVpLDuPdZr/VKm/OJ+pd
         ssqtwWpblWCQsqftXO6LkljYpm3Ir+w0gPQG0sPn1mwWg+hVtYa2e47I/lHmQkuAwu2G
         V7YVQSgIMfDZ+58cTIu+g8+w7bdyKjVD38Om0pgPRF5wxFKJhnEycam6tDsVGpRSZ+rN
         xq5v/xOaU8NoAjmveoqSmYC+m6VmCUZ76IQxE1CLBrKsaZYOEg5yM5aqtpRbSO1LsWc6
         Vfag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9qmivmphespvuvyQ3MoQcp3D+LF94WdyvdfL2S659tE=;
        b=N/vk+i5LAMcznlfll2ia5PO5/v6EOPb6JKvTZtcLa+4MNTLOrro5wdmK63fha8BuI+
         tdF/TLQptyul9sG7HsFLVzKC4fNFGDI3ePuU4xngfT6a0Bb0+v0zrwcidH1KCuXm5PFh
         ZMsJpHTtmUuv8GnAMKh5iu0h1eMyJoMdpOY1QSNqcZMEKQ0B27RPLxUCthPsYic2u2Wo
         xXdnHoCCohHtEIpe/oFK2lCAIYDwy164rhOzQoiEUNlMeTpU+CQip7FJw+1+1MGX9XUr
         Y61YTiMcT/CzzRhtsffNHkBZTB/zsVaMB/6EyNY08mqCRWVmx5gwPA9y+TV/7O+DXVY6
         j5zw==
X-Gm-Message-State: AOAM533EIoFkEB0UqcO44YoQLqMlx1m4DgxCkDjCtNhrlBXg2/e3CXwC
        0CxchiWAXB5gynuVpJ0ZZNoqSQ==
X-Google-Smtp-Source: ABdhPJxNTeEN+USUY59x0OHcGeOKlwn8jz4ouYtbv2FZxQLVOv04gz5fLCya8zXjx2u4CxgyIA3AcA==
X-Received: by 2002:aa7:854a:0:b029:332:330e:1387 with SMTP id y10-20020aa7854a0000b0290332330e1387mr18564513pfn.67.1627943364007;
        Mon, 02 Aug 2021 15:29:24 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id y7sm12164953pfi.204.2021.08.02.15.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 15:29:23 -0700 (PDT)
Date:   Mon, 2 Aug 2021 22:29:19 +0000
From:   David Matlack <dmatlack@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v3 1/3] KVM: x86/mmu: Remove redundant spte present check
 in mmu_set_spte
Message-ID: <YQhxv3XO931lk7ny@google.com>
References: <20210730225939.3852712-1-mizhang@google.com>
 <20210730225939.3852712-2-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730225939.3852712-2-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 03:59:37PM -0700, Mingwei Zhang wrote:
> Drop an unnecessary is_shadow_present_pte() check when updating the rmaps
> after installing a non-MMIO SPTE.  set_spte() is used only to create
> shadow-present SPTEs, e.g. MMIO SPTEs are handled early on, mmu_set_spte()
> runs with mmu_lock held for write, i.e. the SPTE can't be zapped between
> writing the SPTE and updating the rmaps.
> 
> Opportunistically combine the "new SPTE" logic for large pages and rmaps.
> 
> No functional change intended.
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---

Reviewed-by: David Matlack <dmatlack@google.com>

>  arch/x86/kvm/mmu/mmu.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b888385d1933..442cc554ebd6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2690,15 +2690,13 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  
>  	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
>  	trace_kvm_mmu_set_spte(level, gfn, sptep);
> -	if (!was_rmapped && is_large_pte(*sptep))
> -		++vcpu->kvm->stat.lpages;
>  
> -	if (is_shadow_present_pte(*sptep)) {
> -		if (!was_rmapped) {
> -			rmap_count = rmap_add(vcpu, sptep, gfn);
> -			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
> -				rmap_recycle(vcpu, sptep, gfn);
> -		}
> +	if (!was_rmapped) {
> +		if (is_large_pte(*sptep))
> +			++vcpu->kvm->stat.lpages;
> +		rmap_count = rmap_add(vcpu, sptep, gfn);
> +		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
> +			rmap_recycle(vcpu, sptep, gfn);
>  	}
>  
>  	return ret;
> -- 
> 2.32.0.554.ge1b32706d8-goog
> 

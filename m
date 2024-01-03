Return-Path: <kvm+bounces-5531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B64B823080
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 16:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6271F23AB1
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 15:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C05C1A72A;
	Wed,  3 Jan 2024 15:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vQxfeUJP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF531A726
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28bd843b040so6262990a91.2
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 07:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704295556; x=1704900356; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jyAg9Br8Nfp+F7XG3LypiHibuTnp9g3rsu2rzNDgiC8=;
        b=vQxfeUJP4OBI8tvFTElOYvsnqkzFu3Ogo70fSZIfT0MkUzoUBCi1jEpoFjUhfefX2e
         Ua8Wg5F92gUSXVacaNA9lXeU0WJwsdhveo2O2IWBoxlvCYQRlgC9iX3Os+fwqzpxlXwh
         oH/uCBP8Wu6kzcPeH1S4E41QaRF2aaglGppElobvczb+qy1TTvnN5ocB886A39o19oSo
         AaSPldbB94dvkfOdVay9sXLKVgzH6JGqofj8KLaJ/cAZzZ6HsJUYh6JeDO/6XkEGTn55
         M2j8/t4MyIpvX79OygEf6Im9GfNR5DW7tDHGw4rlTvOhKNTPaqUVb2y+znd2VwH/9hzm
         IyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704295556; x=1704900356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jyAg9Br8Nfp+F7XG3LypiHibuTnp9g3rsu2rzNDgiC8=;
        b=rWcXTDpYwkPy4cCV1jA7uYVbczcExiQCC3l9pUSwj1JXPukvnZBVMC2T77yKqSq18j
         ulPJ4SAD4orShgrT7YyH9ekCnsxCuxiDmUXhj+Kova2O6Cd7QNGBZNJjSoH1sQiQSRKe
         ilTi9SQF6hi0Cj8rARNCJ/aKaDOFOK0jnMmjBTslDiIv/1GJe6QE6rdXD5K7qvkKQqlK
         5Rjx9nvCimXsX6lvWRucR2Mu60s20jZXKaULuAG1X1AcSl49+nDyLi9MDUKyaTrpIbWd
         aQ5gfVbyfZoNIJb+BQsZvThIgDL5hVXtOd6nNbokz/XThWLUdItyGohMcBYaIOM/SXXb
         khkA==
X-Gm-Message-State: AOJu0Yzz4bu47/3g7i9kkR8Elq+Ae+cxToEkrv94wWVSfjgsaUTfEy3f
	FcUNYGI3JDpvf+P2d4+QeW4QzJa5FLXCV94erA==
X-Google-Smtp-Source: AGHT+IHhTpaYGpgQpHvQ0g60BI1cFN4vA6M/+UtP9rici9znYVIWaM+UzJEJ3Jg0XMP+NTqvBmzAMeYQ+vM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:46d2:b0:28c:bb53:aa6d with SMTP id
 jx18-20020a17090b46d200b0028cbb53aa6dmr311360pjb.2.1704295556678; Wed, 03 Jan
 2024 07:25:56 -0800 (PST)
Date: Wed, 3 Jan 2024 07:25:55 -0800
In-Reply-To: <20240103123959.46994-1-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240103123959.46994-1-liangchen.linux@gmail.com>
Message-ID: <ZZV8gz7wSCZCX0GZ@google.com>
Subject: Re: [PATCH] KVM: x86: count number of zapped pages for tdp_mmu
From: Sean Christopherson <seanjc@google.com>
To: Liang Chen <liangchen.linux@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

+David

On Wed, Jan 03, 2024, Liang Chen wrote:
> Count the number of zapped pages of tdp_mmu for vm stat.

Why?  I don't necessarily disagree with the change, but it's also not obvious
that this information is all that useful for the TDP MMU, e.g. the pf_fixed/taken
stats largely capture the same information.

> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 6cd4dd631a2f..7f8bc1329aac 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -325,6 +325,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  	int i;
>  
>  	trace_kvm_mmu_prepare_zap_page(sp);
> +	++kvm->stat.mmu_shadow_zapped;

This isn't thread safe.  The TDP MMU can zap PTEs with mmu_lock held for read,
i.e. this needs to be an atomic access.  And tdp_mmu_unlink_sp() or even
tdp_unaccount_mmu_page() seems like a better fit for the stats update.

>  	tdp_mmu_unlink_sp(kvm, sp, shared);
>  
> -- 
> 2.40.1
> 


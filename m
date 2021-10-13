Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDFD42C93C
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 21:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhJMTC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 15:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238992AbhJMTCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 15:02:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12475C061570
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 12:00:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so5174415pjw.0
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 12:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aaUoe2HqAwSoBIWLt0xgSQTQ40cBeMUielEcufP4/18=;
        b=GW2jMZwU8wOTqx/EiG2noqdhjoDk+XhDglYsvot/QPsIM/NNBYHjZDCyG8TbPGRnRc
         kQNQ8DAIDjOJ9vt+RSHgbUoVY1otQYqDQlzMmXEWWyZ9SDExNwtQyZw9pfOZt7VD+273
         53582fKsg28uAzUpEco3Ns3So+OuIXV3GG5qFh0aM214GNFEKLaGP2zL3zpoFkbxIsNU
         FQ22zsDGWJvoqOj8D4jyNecuOssDc0FF5WUusrQUDtLaHkDtQdzJOG7HOhCEdOWKAuXW
         swYif2q4mddeIabmgHY8kTZ1/qgVE4Czpi3VQ6OOleuNmGe/bYGIACnODZbi+klC6QMM
         l6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aaUoe2HqAwSoBIWLt0xgSQTQ40cBeMUielEcufP4/18=;
        b=MIBLajDhUTUSRorqx8BH0B1IQKMchLzJpXeGgCkEyNkRynQ2sj4QNUEPejktjniqsf
         oaSVjz1NIwax/3ewZR2sby7OSvx182k/Hy/zfCxFDzpL0yOsPQtIrGyaEYSmszv5dVPr
         PoxTtZ+B6daI8+BRM6LUJegDFzJdrUcqaKbM4KMFq7R544I4TkVlA1yu5JHFgBcqMGhG
         rQ3VMgYoX6VkJQyYZxXe/2O6tuQbYwV2IpJOAWSEr6chLw2FM9rdPUtpTB6T14WbKM+u
         i0zA8cafHb94khs/WeHiCfEI7m505LaGW3FQvPP1coRd/9qJln/pVlSe9v/vN5Jn3f1D
         ZwMQ==
X-Gm-Message-State: AOAM53019Zt2OJ+joq/V7uunqYr9i3/3eUaCUUF7nXtOpKF+rcJ07Crm
        AbG0zOjAz9CaZwRIhqJ8qnb/aA==
X-Google-Smtp-Source: ABdhPJwAA1JunWkPVsAOhPeF2rn+KrqZGYn35/dJ95BSn03HUKc2sLWvPKxmtVZkShGRvMfo7URxFA==
X-Received: by 2002:a17:90a:191a:: with SMTP id 26mr1156732pjg.79.1634151621241;
        Wed, 13 Oct 2021 12:00:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pi9sm253839pjb.31.2021.10.13.12.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 12:00:20 -0700 (PDT)
Date:   Wed, 13 Oct 2021 19:00:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ajay Garg <ajaygargnsit@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: (64-bit x86_64 machine) : fix
 -frame-larger-than warnings/errors.
Message-ID: <YWcswAD9dmYun+sI@google.com>
References: <1631894159-10146-1-git-send-email-ajaygargnsit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1631894159-10146-1-git-send-email-ajaygargnsit@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 17, 2021, Ajay Garg wrote:
> From: ajay <ajaygargnsit@gmail.com>
> 
> Issue :
> =======
> 
> In "kvm_hv_flush_tlb" and "kvm_hv_send_ipi" methods, defining
> "u64 sparse_banks[64]" inside the methods (on the stack), causes the
> stack-segment-memory-allocation to go beyond 1024 bytes, thus raising the
> warning/error which breaks the build.
> 
> Fix :
> =====
> 
> Instead of defining "u64 sparse_banks [64]" inside the methods, we instead
> define this array in the (only) client method "kvm_hv_hypercall", and then
> pass the array (and its size) as additional arguments to the two methods.

> Doing this, we do not exceed the 1024 bytes stack-segment-memory-allocation,
> on any stack-segment of any method.

This is a hack, and it's not guaranteed to work, e.g. if the compiler decided to
inline the helpers, then presumably this problem would rear its head again.

However, I don't think this is a problem any more.  gcc-10 and clang-11 are both
comfortably under 1024, even if I force both helpers to be inlined.  Neither
function has variables that would scale with NR_CPUS (and I verified high number
of NR_CPUS for giggles).  Can you try reproducing the behavior on the latest
kvm/queue?  I swear I've seen this in the past, but I couldn't find a commit that
"fixed" any such warning.

If it does repro, can you provide your .config and compiler version?  Maybe your
compiler is doing somethign funky?

> Signed-off-by: ajay <ajaygargnsit@gmail.com>

The SoB needs your full name.

> ---
>  arch/x86/kvm/hyperv.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 232a86a6faaf..5340be93daa4 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1750,7 +1750,8 @@ struct kvm_hv_hcall {
>  	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];
>  };
>  
> -static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> +static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc,
> +                            bool ex, u64 *sparse_banks, u32 num_sparse_banks)


>  {
>  	int i;
>  	gpa_t gpa;
> @@ -1762,10 +1763,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>  	unsigned long *vcpu_mask;
>  	u64 valid_bank_mask;
> -	u64 sparse_banks[64];
>  	int sparse_banks_len;
>  	bool all_cpus;
>  
> +        memset(sparse_banks, 0, sizeof(u64) * num_sparse_banks);
> +

FWIW, the array size needs to be validated, there is other code in this function
that assumes it's at least 64 entries.

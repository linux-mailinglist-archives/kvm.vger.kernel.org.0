Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86917403A08
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351747AbhIHMkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 08:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351735AbhIHMkL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 08:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631104742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJk9DPikcEEEFmKWzBbvekDGUKQO1oc5fhwtnVuechI=;
        b=fgWFlSwgFVb5A24gLr1gyzfzUgF0RRZNPh4MXDuYMIl+Guj+FvQ84Tgl+wks2vp4/6nLYd
        9ZBL5MA95bEiBrrMoPp8i7dYUeDHWHay7+9rAArbBbu7LguUd3Fl8CSubqCQgFcvmHz+k+
        DLrECC4qvuYOydf2OoS0vJFpJtowLYg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-kuSR9GajOVqX2UTZ36UPeg-1; Wed, 08 Sep 2021 08:39:01 -0400
X-MC-Unique: kuSR9GajOVqX2UTZ36UPeg-1
Received: by mail-ed1-f70.google.com with SMTP id s15-20020a056402520f00b003cad788f1f6so988205edd.22
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 05:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qJk9DPikcEEEFmKWzBbvekDGUKQO1oc5fhwtnVuechI=;
        b=dsQjli4ly/lEScUGpYJTfFg2Sr/nC5NwtjmbEo2dgXkAGfE9Z5DNzLeuf2FJKuHPqI
         yq+ajvawO6jLH9/11CqOfWtZ0eukia31WA9zCjXcvkYqQIoHI5cu1M29yKi7YjvgwYTL
         XXgc3XVMkRhz3bZzn115CNQfyQ9RyLYQdS3eo9tsyKETVtZrDzvJwbVPv/u2mXwzbgri
         AOS5NpJ5SqyitltP0fQDdlTklvQS8aAMXaPB7+UAtG6tDcUznwXGDcpJ4VMR33I9xKRB
         xK2bZMgFQxpLQllBn/pGJ5I/WoluoJfARGCGa8VQeWHyQtQw3d/kioerTgTbQtRMGhyQ
         RQvQ==
X-Gm-Message-State: AOAM532KiktwAB3/E47vRXHtogqORPvzn9tBNLlht1vOEvWT9Bvfu/q8
        cIXIhChv1Es2lvGTnlC1E7LmgchM/9sEjrT+oaAB+GX9XPaLDCpQvf+g/GIgfClKUvp41OTZYAP
        rjPlX8niTdgIf
X-Received: by 2002:aa7:cfd2:: with SMTP id r18mr3792146edy.82.1631104740791;
        Wed, 08 Sep 2021 05:39:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjid3++di+F5iCU9+5CzYDTvq+wLZRd9DcKg7WpI/zFqCadUN/JE18oA3HheHdzPjP0LYM/w==
X-Received: by 2002:aa7:cfd2:: with SMTP id r18mr3792124edy.82.1631104740608;
        Wed, 08 Sep 2021 05:39:00 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id bm14sm1157297edb.71.2021.09.08.05.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 05:39:00 -0700 (PDT)
Date:   Wed, 8 Sep 2021 14:38:58 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v5 3/8] KVM: arm64: Simplify masking out MTE in feature
 id reg
Message-ID: <20210908123858.fqoltrkp3aodj4ly@gator>
References: <20210827101609.2808181-1-tabba@google.com>
 <20210827101609.2808181-4-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827101609.2808181-4-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 11:16:04AM +0100, Fuad Tabba wrote:
> Simplify code for hiding MTE support in feature id register when
> MTE is not enabled/supported by KVM.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1d46e185f31e..447acce9ca84 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1077,14 +1077,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
>  		break;
>  	case SYS_ID_AA64PFR1_EL1:
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
> -		if (kvm_has_mte(vcpu->kvm)) {
> -			u64 pfr, mte;
> -
> -			pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
> -			mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
> -			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), mte);
> -		}
> +		if (!kvm_has_mte(vcpu->kvm))
> +			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
>  		break;
>  	case SYS_ID_AA64ISAR1_EL1:
>  		if (!vcpu_has_ptrauth(vcpu))
> -- 
> 2.33.0.259.gc128427fd7-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>


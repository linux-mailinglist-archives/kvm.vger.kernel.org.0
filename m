Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ED63DFDF2
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 11:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbhHDJXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 05:23:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237088AbhHDJXa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 05:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628068996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UkRs2HbzdB4h7mTj8+qY8hBZF+eBXTP8p+8ea8LWKp8=;
        b=FWER3PUiYLJeyKlt+stoEJAsT93ZblfwBdX6ZSWC3WZ5TiqOX/looeyccUmR2tdvbzpecD
        fymCUoMjIZTwmW9VgMVsJ+5GzErKiTkEYjYSCMVia1Pe40/cuohTcxb/qAnIMjRTiewiFC
        BBQv6KU9+yvYF/QhvrnQtCPk4E4Uaek=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-wb4wyTnNOtG1oFsR391kWA-1; Wed, 04 Aug 2021 05:23:15 -0400
X-MC-Unique: wb4wyTnNOtG1oFsR391kWA-1
Received: by mail-ed1-f70.google.com with SMTP id d6-20020a50f6860000b02903bc068b7717so1147106edn.11
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 02:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UkRs2HbzdB4h7mTj8+qY8hBZF+eBXTP8p+8ea8LWKp8=;
        b=KOUZkLiazqbUqRxyuiZLVX2UJ51NJ8CAY13N35YVbsKbCguD9CsHE3jnf5b4SSwJBM
         xvjlVzqNfL4tDuDlLBbpVmCQk5CGV4SRl2u8F8mBy9fvAGefVjccllDm2hHzI/phEDrS
         vte6FHhw/wTb4BFQyPc1hIMUeeUFi/LxjvqYyTCJzFQu2WcgjHEDYLWNyappJYIIwbEI
         sM8RrOusZpFYmXlAWyd+cZPVP1uc7KimRypvC+KRto47DcG76EO6GDA8ss8zN05KJFcv
         O19IBbMbQBYwpLMzD3uBZDJadrplRDmnZeMFm/g4R8BLJC2GqbFOapc1FRWdTK2QuZQX
         Fyfg==
X-Gm-Message-State: AOAM533YwtVIk460/Y22+VSrgJdYgE/neqm3y6tHdjEdFeT32deIbGuJ
        8dx1DidV1H5GlLNBe4hCU+PNz2R4zr9QeQF0YtyiA2mBvYG2FINnnwqAPXQrN+GbMObIdPvXpu8
        ieSmsTVzAqObK
X-Received: by 2002:a50:a6d7:: with SMTP id f23mr31030943edc.164.1628068994307;
        Wed, 04 Aug 2021 02:23:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxE6m2UYvltRQ8Pgjp26MJaVNK+xKyPnxyh9OKvCZbbQ2+R1157cJg4uGkivonAtdYooD+rvg==
X-Received: by 2002:a50:a6d7:: with SMTP id f23mr31030924edc.164.1628068994149;
        Wed, 04 Aug 2021 02:23:14 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id i16sm706151edr.38.2021.08.04.02.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 02:23:13 -0700 (PDT)
Date:   Wed, 4 Aug 2021 11:23:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 11/21] KVM: arm64: Refactor update_vtimer_cntvoff()
Message-ID: <20210804092311.yhruuke6buiblrel@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-12-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804085819.846610-12-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 08:58:09AM +0000, Oliver Upton wrote:
> Make the implementation of update_vtimer_cntvoff() generic w.r.t. guest
> timer context and spin off into a new helper method for later use.
> Require callers of this new helper method to grab the kvm lock
> beforehand.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arch_timer.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 3df67c127489..c0101db75ad4 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -747,22 +747,32 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -/* Make the updates of cntvoff for all vtimer contexts atomic */
> -static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> +/* Make offset updates for all timer contexts atomic */
> +static void update_timer_offset(struct kvm_vcpu *vcpu,
> +				enum kvm_arch_timers timer, u64 offset)
>  {
>  	int i;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_vcpu *tmp;
>  
> -	mutex_lock(&kvm->lock);
> +	lockdep_assert_held(&kvm->lock);
> +
>  	kvm_for_each_vcpu(i, tmp, kvm)
> -		timer_set_offset(vcpu_vtimer(tmp), cntvoff);
> +		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
>  
>  	/*
>  	 * When called from the vcpu create path, the CPU being created is not
>  	 * included in the loop above, so we just set it here as well.
>  	 */
> -	timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
> +	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> +}
> +
> +static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->lock);
> +	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
>  	mutex_unlock(&kvm->lock);
>  }
>  
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>


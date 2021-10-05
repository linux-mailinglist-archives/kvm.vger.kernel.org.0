Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0904227B3
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbhJENZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:25:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58984 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234103AbhJENZc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:25:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633440221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cT7Qtyinns0zBAn2ayLQCXEWWojO35G+FtQtOxKscjM=;
        b=gw8B6QHEEMY3EV8oJrCzU+PS5aLTqvRTtlJpG//KGo52/+TgZzSxZlT8tiM2WKVCILTvDP
        gorztLSNd5/SAXmLc2vPzNQi95ZUqxjXfHIY/SKoY9hJBqm4T4d6R3XDHsYKulWqznLPWl
        KwdrBxqKf+Bn/YA5ilq1ccrheTkeFzY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-ZuOKrrKRP-ebTJ8asjeVYA-1; Tue, 05 Oct 2021 09:23:40 -0400
X-MC-Unique: ZuOKrrKRP-ebTJ8asjeVYA-1
Received: by mail-ed1-f71.google.com with SMTP id c8-20020a50d648000000b003daa53c7518so20324254edj.21
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cT7Qtyinns0zBAn2ayLQCXEWWojO35G+FtQtOxKscjM=;
        b=u6V/FQuPxl3lungkVj7VTC5HGrfju286k/NQpniv7ocYH/sWqQ4ggJXuvFm7soUtUz
         ckixYptYm1UkoHEZXRPUigfJWEgSBQOhQa/lDmjj9EFeCNwD8PAJ6SrtayZ0KuraOdAc
         6KizAWlJg1UoeO8FqgfELVugrFhmLx6t99KKDDrcydvJJY6RpyJrMDEFCyj1oY6KM7fb
         HxuncCbISz917nHGjbEi501QkBwyt1+zwqTAQJ3AA5pOtJmaoEIwehtHnHUB401/6Oiv
         bBEla/v/au9vsW8L346aF/IrOhSAF4b7JnK79Qpj83GCgGHIW3ZiZkbvyrPnUTYuJKKc
         jwXA==
X-Gm-Message-State: AOAM532uHLuL9LmyxLTqW9Ryud22kOc3mSZkyCN6/ztovh4I9AXoMXG5
        qURthU02gGR6Pd1XXIeplZE2wG2+eKgCBKM5qIm51ZDHm3d4T/dugKHALN3e8HuDuPDkGddJzEr
        pPaC1jppCHRnm
X-Received: by 2002:a17:906:a082:: with SMTP id q2mr24638235ejy.535.1633440219753;
        Tue, 05 Oct 2021 06:23:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwakvv7GWEI+W/r0KCyXEC2f4X0QMYDDyKl3xx8Uk4KQI3UQr5BIHMj+4kf9CTH/OjfA2NmQw==
X-Received: by 2002:a17:906:a082:: with SMTP id q2mr24638216ejy.535.1633440219608;
        Tue, 05 Oct 2021 06:23:39 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id w2sm8769794edj.44.2021.10.05.06.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:23:38 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:23:36 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 02/11] KVM: arm64: Clean up SMC64 PSCI filtering for
 AArch32 guests
Message-ID: <20211005132336.njnelrjkmtipzr5l@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-3-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:16:01PM +0000, Oliver Upton wrote:
> The only valid calling SMC calling convention from an AArch32 state is
> SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
> when called from AArch32 rather than comparing against known SMC64 PSCI
> functions.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index d46842f45b0a..310b9cb2b32b 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -208,15 +208,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
>  
>  static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
>  {
> -	switch(fn) {
> -	case PSCI_0_2_FN64_CPU_SUSPEND:
> -	case PSCI_0_2_FN64_CPU_ON:
> -	case PSCI_0_2_FN64_AFFINITY_INFO:
> -		/* Disallow these functions for 32bit guests */
> -		if (vcpu_mode_is_32bit(vcpu))
> -			return PSCI_RET_NOT_SUPPORTED;
> -		break;
> -	}
> +	/*
> +	 * Prevent 32 bit guests from calling 64 bit PSCI functions.
> +	 */
> +	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
> +		return PSCI_RET_NOT_SUPPORTED;
>  
>  	return 0;
>  }
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>


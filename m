Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0001F925E
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 10:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgFOI6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 04:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgFOI6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 04:58:14 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2E3C061A0E
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 01:58:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f185so13966440wmf.3
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 01:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5ShxQ/p8QgWJk316YAyJ/2tQifOc4oxip3xhjWlqJEQ=;
        b=HbVh+hzk5EMCxM8HGK4hG1KrtSz8Nm/Y6fwcA3KHzRcyUFMqNhJy20y/BVVd2vSQvW
         AErfOfpMe734o02wktzcMFgR2BX2dgnZYwJBZBldKTZIq5SUyVfg6nNP/80txEzIAfmr
         +gb9uCi7jZtYrv0+/5lGpjxNz/DoagX/I2qFwY72TakjZb6Sh35Zd0czsvw7EDfJ5z3k
         EN/5hItz0s1wsQl+L0hGFE+IoKsaUbQoG012t9KJh2NbSfJwm8+qau8Y2Q6Scr/2YEur
         DwiK8g9gUopMHDDNckOxXOcZH1JVHtGStDfFIanwt5BVtw+qlwkJWamTCGWX3ZrDsgTi
         aTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5ShxQ/p8QgWJk316YAyJ/2tQifOc4oxip3xhjWlqJEQ=;
        b=WG2qwwu7AyHvXR3mpihmvHB8dthSNj0x8x2Lyz31vIGdGpYz1bHwMRAVaUhd64HAQ3
         cfuwNqEYSxjfszoE0GwmhxxWkRGo69xBAz1lawpvmM5cfxaDsHSzfXZDCLiZia8TnBsN
         d9sWdxB5zsDtN54NTDk0629C/ONn0PIxZ40MOs9aQBeArnu5WxR9QLEDH1+1cG2CmJmp
         QRml/dMmfv9Wfgo+IDJM6+bisH9TI64zdbKPs9bxW91kTEwNHR+h+CYHSvryjwvFX1EU
         n2y9PtZrAXt3ecpcLYTBcLcIm4OGJAd9Mdl9HLH/12RK0njbxrtjzDyV6sXqJ9mTmoAm
         +QnQ==
X-Gm-Message-State: AOAM5327f9a1rzzg3/Cp9ARt9EUV8zI3gDFqNUluD0SCtb72DSuFo9sA
        ETqvOk88tXDpqSPaWxZl9FQwo0Nback=
X-Google-Smtp-Source: ABdhPJwLOxCm//URtwLoljmFofuNMfLd0PKuFSaN0kqqtlnaKFsHDaMnEqPiaGR8skUD0V+QZBoTjA==
X-Received: by 2002:a1c:7d4c:: with SMTP id y73mr11858831wmc.188.1592211491868;
        Mon, 15 Jun 2020 01:58:11 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id y80sm21776273wmc.34.2020.06.15.01.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 01:58:11 -0700 (PDT)
Date:   Mon, 15 Jun 2020 09:58:06 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 2/4] KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
Message-ID: <20200615085806.GE177680@google.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-3-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 09:19:52AM +0100, Marc Zyngier wrote:
> We currently prevent PtrAuth from even being built if KVM is selected,
> but VHE isn't. It is a bit of a pointless restriction, since we also
> check this at run time (rejecting the enabling of PtrAuth for the
> vcpu if we're not running with VHE).
> 
> Just drop this apparently useless restriction.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/Kconfig | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 31380da53689..d719ea9c596d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1516,7 +1516,6 @@ menu "ARMv8.3 architectural features"
>  config ARM64_PTR_AUTH
>  	bool "Enable support for pointer authentication"
>  	default y
> -	depends on !KVM || ARM64_VHE
>  	depends on (CC_HAS_SIGN_RETURN_ADDRESS || CC_HAS_BRANCH_PROT_PAC_RET) && AS_HAS_PAC
>  	# GCC 9.1 and later inserts a .note.gnu.property section note for PAC
>  	# which is only understood by binutils starting with version 2.33.1.
> @@ -1543,8 +1542,7 @@ config ARM64_PTR_AUTH
>  
>  	  The feature is detected at runtime. If the feature is not present in
>  	  hardware it will not be advertised to userspace/KVM guest nor will it
> -	  be enabled. However, KVM guest also require VHE mode and hence
> -	  CONFIG_ARM64_VHE=y option to use this feature.
> +	  be enabled.
>  
>  	  If the feature is present on the boot CPU but not on a late CPU, then
>  	  the late CPU will be parked. Also, if the boot CPU does not have

...and we just got the patch to let EL2 use the ptrauth instructions for
the save restore in hyp/entry.S!

Acked-by: Andrew Scull <ascull@google.com>

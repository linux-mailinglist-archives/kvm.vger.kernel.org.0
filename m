Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8D641B274
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbhI1O7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 10:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241406AbhI1O7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 10:59:54 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DA0C06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 07:58:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id z184-20020a1c7ec1000000b003065f0bc631so2583598wmc.0
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 07:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QW/iGDRyZchN8Mm3Lgfi04v5R4JX67d3vWd6I5nvOfo=;
        b=FvlIwZje7r3p4KVXKgsdwTakffjTJxcd4A9dlfMHkXtKs7DHBGoAvR8MW+KJ9f/hw2
         6Tut5KjpHd2FMxSXkoZTVrsglrVf2C/S98s+ca3WF2S7w/Vbw6acGa2JMSDs5nchXV5A
         CLIW6COY/gSYlO4B5aNuaPAXuzOxcC3FpDwEXWm6bhC+nENuW1x2aP/+T6Y0qckbS2Q8
         H0ytpN5VGVN6urXXLIIyQ7RSljWlhjuBqld1d9qCOWzfsPALe4kQ0dT7dIvbQuIt4yBx
         d2fDN5qZ2+7fPl1KAPFf5tvR4TxyVTEqVt4UaZjSO1GeCVEzcawSYUle2SD8VJBxqW06
         uTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QW/iGDRyZchN8Mm3Lgfi04v5R4JX67d3vWd6I5nvOfo=;
        b=K7hPinRFwC+SHAXxkGFUm/e7/XpgVbbvANbMI58TZKfwiY5HFg9Zbt90zcqY9KfRP9
         e7VZaTrntkfI3G5tA2ymGYNQKop9gzcvA2unpsife51tAhliK88p7LifT33WSxk6JzzI
         9gniC8l5YkDlj9sw+eFyVlZM8tpXK4FHxgBpavZjkHOEo7aV9co4OGzHLPbdqHBx0pKx
         E9Wy9rbj/1mb+7VU5NJpPoDqfnMQ/S3+WimTEfPxdwHUoNzkfADbJem6AGZb+fW/m6GC
         1OCUcgqLJHFxbwLopTqPHSNIaceD1yBLq7NiG5x8xK3HTIYT+yC2LSYzSelhxCYpR2dW
         31Dw==
X-Gm-Message-State: AOAM530mW15h3DGTyOkQHFHnV0KGtPfwX2CkFjrGhlb2xjQk+hZSirSJ
        lO2UK9fTzHffNDA20LCrLwQOHA==
X-Google-Smtp-Source: ABdhPJyAA3f06QGMTVpZuEqToVOc8cuAiYcICGxkpGqBtD1I5r+gyQ+DGMhDjtEeRgVh9SnNFt+29w==
X-Received: by 2002:a7b:ca58:: with SMTP id m24mr1846215wml.0.1632841093668;
        Tue, 28 Sep 2021 07:58:13 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id y18sm19438837wrq.6.2021.09.28.07.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:58:12 -0700 (PDT)
Date:   Tue, 28 Sep 2021 14:58:08 +0000
From:   David Brazdil <dbrazdil@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, ascull@google.com,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Allow KVM to be disabled from the command
 line
Message-ID: <YVMtgBw+qG713+4k@google.com>
References: <20210903091652.985836-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903091652.985836-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,
that all makes sense:

Reviewed-by: David Brazdil <dbrazdil@google.com>

> @@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
>  		return 0;
>  	}
>  
> -	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode()))
> +	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
> +		kvm_mode = KVM_MODE_DEFAULT;
>  		return 0;
> +	}
> +
> +	if (strcmp(arg, "none") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
nit: I noticed we check is_kernel_in_hyp_mode here for nvhe/none but for
protected it is checked in is_kvm_protected_mode. May be worth unifying?


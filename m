Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCEA485527
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 15:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241169AbiAEO7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 09:59:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236073AbiAEO7B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 09:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641394740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xuDXDZaYk8pGsNJOMGUKMDNxo2JBtvsfuoGsrVtjpq0=;
        b=Y6FwTjh5m43lNHsDUlpedDlXMsp7d3fu+DO/hGMymht0wvIzbZrjyEs5BB+Y9D5SF5Yab1
        N9nYyTcnHE8Ajl54Tkq0yKmmeQ0GEOUV8xQIm+z71xKUnf4f9GT8oTCuCb8EHZYRTlCVRU
        U8Y590jYDtlR1o5vrJAi+MrpDV05jbg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-bmXrRT6jOMi8jpP9Q-ltsg-1; Wed, 05 Jan 2022 09:58:58 -0500
X-MC-Unique: bmXrRT6jOMi8jpP9Q-ltsg-1
Received: by mail-wm1-f71.google.com with SMTP id l20-20020a05600c1d1400b003458e02cea0so1907727wms.7
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 06:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xuDXDZaYk8pGsNJOMGUKMDNxo2JBtvsfuoGsrVtjpq0=;
        b=Khn7yDRe5BwrQEjMD9SvhDMT/CNwn/vH6wRlyamlqBBn3lfkAKY7tBgeqZuI0TUzrv
         ulA/qX+ktFFpelJRVshe4SwDYWRXv6fZE9zm1RTT/4TjW+JAJHBh8M1LF3Xn3EEueOsw
         uIKIj8jdE7/HXhOpXEvYzSIL6OUFPkCR8Rqv/DZd+/lJfzJp7BMy9X0GzdOuGko5QK8S
         a6xFb45Ju11h/3JjofceHGtHcXx8xmZPSZ4baS2ZyGF0LpY45Zt0rg/lym0G3rXzSI0Z
         NQfspeKOwuiJJoUqK570CjTxwe8AB2SzBPTVH943aT5XFb9EJHFHb8OfAtvd2HLKDcXO
         qILQ==
X-Gm-Message-State: AOAM530ZDbeg89IducYxjr9k8dandaiCMmcBVHs2L9dod6gYHHLUpj/R
        SivsyfNWNGEAdcvQ1wjw5xuXWvEzGGWuSZLzyxF+OGFls9ixGKFC6Pf5SBPqL2aio07BBfLn5sg
        USMI1c3YI+zKJ
X-Received: by 2002:a5d:564f:: with SMTP id j15mr45520961wrw.366.1641394737665;
        Wed, 05 Jan 2022 06:58:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAIE48Rt6oCWt/TrKYOLRuPR/0b02qx5CUgTR/XXf3h6OjcPtM0vEG7RamhYrEag2pLW40KA==
X-Received: by 2002:a5d:564f:: with SMTP id j15mr45520954wrw.366.1641394737546;
        Wed, 05 Jan 2022 06:58:57 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id n9sm3237489wmq.37.2022.01.05.06.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 06:58:57 -0800 (PST)
Date:   Wed, 5 Jan 2022 15:58:55 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Eric Auger <eric.auger@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2] hw/arm/virt: KVM: Enable PAuth when supported by the
 host
Message-ID: <20220105145855.ca7vxeu3ubytdkna@gator>
References: <20220103180507.2190429-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103180507.2190429-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 03, 2022 at 06:05:07PM +0000, Marc Zyngier wrote:
> Add basic support for Pointer Authentication when running a KVM
> guest and that the host supports it, loosely based on the SVE
> support.
> 
> Although the feature is enabled by default when the host advertises
> it, it is possible to disable it by setting the 'pauth=off' CPU
> property. The 'pauth' comment is removed from cpu-features.rst,
> as it is now common to both TCG and KVM.
> 
> Tested on an Apple M1 running 5.16-rc6.
> 
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> * From v1:
>   - Drop 'pauth' documentation
>   - Make the TCG path common to both TCG and KVM
>   - Some tidying up
> 
>  docs/system/arm/cpu-features.rst |  4 ----
>  target/arm/cpu.c                 | 14 ++++----------
>  target/arm/cpu.h                 |  1 +
>  target/arm/cpu64.c               | 33 ++++++++++++++++++++++++++++----
>  target/arm/kvm64.c               | 21 ++++++++++++++++++++
>  5 files changed, 55 insertions(+), 18 deletions(-)
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew


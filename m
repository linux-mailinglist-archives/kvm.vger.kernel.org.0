Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5068A48B2D0
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 18:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244267AbiAKREy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 12:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244242AbiAKREx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 12:04:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9263AC06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 09:04:53 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q14so18175720plx.4
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 09:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IziS1hAgKQadL69QXaViOT6DgmiHKAQc9euIWkGIoUI=;
        b=tXTjGBpjm23u4JKksIcA/FWe9RSj4V1gYOjblXw2/F7rJAcNWZY+uNltp47DhhYtXz
         T9EQznFCNmJvkYCQs1ecJRrC96c3ZdNzuvjYu8pFXM/olW3IEcHqDfVGDObETkomJiMC
         /fucDD/OGNh3et5Ym6EABfQ7cRBUtqjNBwoDFwrg1QksxKf/A/v0kd7jllLVEsBzgCbc
         KGOiGJ85zGDWWxtkGMl2e2856B6OpBoYIBaGzHvU3i9qfFElZJInHccWbFceCs7uHFvS
         t7FTXT+1DboUTPlw5umhkXmLJpnXpGLH1eEUOjC8+8H6hLRRB1kMpDmGxp4/h5bOQuEa
         u47A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IziS1hAgKQadL69QXaViOT6DgmiHKAQc9euIWkGIoUI=;
        b=I3/tCuUaMDztN9u0X2h96l6PKPCJGy+F3oNL4DuFNzLx6FBJDHnRz2aQGHe9VPaH1w
         tq8T5cRS9EhlSLkIVTuGHuv85bk38LCP3+FAZewkY9OMSSGDB3+ykvk1jtP/ArbAqIWZ
         xtSBKTn6qwxZUqYxjSvGXa1OVnCcKRgEPcICaIeYVOc0iH9JcLMzvai5mgMoW7XMSJlY
         C+MLed+aI396K4f5zApspJx6ECuzO857si3icTQ6v8Ugt8JoD/yl7ojC6c6v20wdp57H
         HoQ3EkPrjIOI33MSiGxP2yA1bz6LViWEpiaB7UmX3f8y9kc8AE39psIk5cyzdVihDt0b
         r/Jw==
X-Gm-Message-State: AOAM530UQGjeNp+MpHld+gQj3TrYK/bNGt3uOKeuNU9ZXFHXUIDy2mdE
        9hLQCqoLZtmbse/ZvbBF8ZKDtQ==
X-Google-Smtp-Source: ABdhPJzAx1kJLw7IS6bxzSsChfp8XuiGKEOaojsvTh/bAYFGbEDNFC6KdafroKRlXtsfWMeb4kcqXA==
X-Received: by 2002:a17:90a:77c6:: with SMTP id e6mr4107555pjs.41.1641920692922;
        Tue, 11 Jan 2022 09:04:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s8sm11449911pfk.165.2022.01.11.09.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:04:52 -0800 (PST)
Date:   Tue, 11 Jan 2022 17:04:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Making the module parameter of vPMU more common
Message-ID: <Yd24sNBwa6i/yEgZ@google.com>
References: <20220111073823.21885-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111073823.21885-1-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, s/Making/Make.

On Tue, Jan 11, 2022, Like Xu wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c194a8cbd25f..bff2ff8cb35f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -187,6 +187,11 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
>  int __read_mostly pi_inject_timer = -1;
>  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  
> +/* Enable/disable PMU virtualization */
> +bool __read_mostly enable_pmu = true;
> +EXPORT_SYMBOL_GPL(enable_pmu);
> +module_param(enable_pmu, bool, 0444);

I'm definitely in favor of enable_pmu instead of pmu for the KVM, variable, but
I'd prefer we keep "pmu" for the module param, e.g. same as ept, vpid, etc...

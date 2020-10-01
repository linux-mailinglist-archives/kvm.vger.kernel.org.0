Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988152800B1
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 16:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbgJAOBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 10:01:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732435AbgJAOA7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 10:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601560858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6S44Cl1SWHyUe4fYYQfKjzqsq0aN4+O/1HZKr3HYiiY=;
        b=ACzUOMNx37HzSkgkPItSu5c/0r9rjaqXkFNpzGnVBuhiPpNuoxaT8L6cyMv+zoSy4wY74s
        IY9LBIGKm2e9GEbMyl81s3UZQYB9Hs/WPVlC0a9o+xJaAxOD5ISqcNBROUc/vU4syAf4dn
        P6NdLkE6iNA3AQOsmg9hmi0yXABx1lQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-q6n-6eHhP3KD9a9_BbAZnw-1; Thu, 01 Oct 2020 10:00:55 -0400
X-MC-Unique: q6n-6eHhP3KD9a9_BbAZnw-1
Received: by mail-wm1-f71.google.com with SMTP id y83so33001wmc.8
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 07:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6S44Cl1SWHyUe4fYYQfKjzqsq0aN4+O/1HZKr3HYiiY=;
        b=uTKN/EJoaZZBYKE1Eft1Q3RO9mGMv3jh6/NEP9ZwA6ItkfyVoECLZJfohkLYf8xbwa
         cAuylnlYPgXz6MzR6vO/ZlKbTN/Yg3JG8XEDVKLnkPyUWy30sPROC/bCy2zw5Vj3gFhr
         deXKcQU3YYboFRHcjFvqWV7/ZSKl/XjC5pEYHaQGR5HQ64IG+lSFxipaxuVJ7igwoqQz
         Ubv4+JHdfOLKOArR40y/FczK4YDSY3ZD9DtRfeoWkDSxFDReHanj04mhyK3Hd1OjdiiT
         XbQkGG0TUqhhOOJCIDvEIIQcBRe9DSmxiAUyrR9xkmIuqjrRmFsz1f3tlG2kzGEfDV+P
         co4Q==
X-Gm-Message-State: AOAM533tPNgtGGYxgJnK3eA65eVNM701zrHegzNMzx8JRwTqFaDrtu9g
        DqETnMKeYffsTznLTzFa2LttsJ8+tEEtl0loc1OzFs/252YBKal5QMPb6VmFUKjToX0cf0z5RjD
        ZTbryDnTl5vUp
X-Received: by 2002:adf:dd44:: with SMTP id u4mr8819544wrm.22.1601560854023;
        Thu, 01 Oct 2020 07:00:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYj/8ORDVYdNbRPeku5Fpyq8wvSyE05tvQI2eThYq+MXR17DDK2stsqrdhIqYW+td6JTxv3A==
X-Received: by 2002:adf:dd44:: with SMTP id u4mr8819515wrm.22.1601560853797;
        Thu, 01 Oct 2020 07:00:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u2sm10439301wre.7.2020.10.01.07.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 07:00:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] x86/kvm: hide KVM options from menuconfig when KVM is not compiled
In-Reply-To: <20201001112014.9561-1-mcroce@linux.microsoft.com>
References: <20201001112014.9561-1-mcroce@linux.microsoft.com>
Date:   Thu, 01 Oct 2020 16:00:52 +0200
Message-ID: <87a6x69hbf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Matteo Croce <mcroce@linux.microsoft.com> writes:

> From: Matteo Croce <mcroce@microsoft.com>
>
> Let KVM_WERROR depend on KVM, so it doesn't show in menuconfig alone.
>
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>

I'd even say

Fixes: 4f337faf1c55e ("KVM: allow disabling -Werror")

> ---
>  arch/x86/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index fbd5bd7a945a..f92dfd8ef10d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -66,6 +66,7 @@ config KVM_WERROR
>  	default y if X86_64 && !KASAN
>  	# We use the dependency on !COMPILE_TEST to not be enabled
>  	# blindly in allmodconfig or allyesconfig configurations
> +	depends on KVM
>  	depends on (X86_64 && !KASAN) || !COMPILE_TEST
>  	depends on EXPERT
>  	help

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


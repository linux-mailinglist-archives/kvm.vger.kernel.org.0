Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C373FE4F6
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344804AbhIAVal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343833AbhIAVak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:30:40 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C2FC061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:29:43 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id a13so1002911iol.5
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KGjRFCzfFxSnSrNaojtITxfWpjAOQrO+uEsac7dWTTA=;
        b=qjLS/Lwo+l0y/xWgb9Yqx3gwHHIqKU/h+4CZY2e91pjpHo2fM2km+R+Aq1kPhbzrnZ
         9qQlZ6aVuw/V8/m7LWoa9oAT13KmdbzLWMNmSSSK1j+h8xUuBVM3U75RfhDXnSCLx56l
         e50E1QwY4UL8edEAGNbUGfdr70SvdMu3IPDdZkNiQHr+/mypm6nHNYFwljYmDPTznfY6
         CAdSB9tO3n2qGOn4DB8Zi0LQ1+0R1iPSeFN/+weC7GkYwQede6i4CDzK8ATXfeahkA/b
         7rKQEF2qEPrKFEaL6vftzbbGLeCOo2drtmjnuxEOup5KXei3+jcr/OWCRJCHnHicLRIJ
         Rzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KGjRFCzfFxSnSrNaojtITxfWpjAOQrO+uEsac7dWTTA=;
        b=nps462ynfcd8L8D8ffN5L2tcvf5ArkSc7/m2hW3lPLiWNx+upSAYV9fF3qLG92KZHd
         RiWDJIS5Tpg7cqraSF6WGvaUaju1Mvd8B8HKI/6I4EDFoHhmTgiiW9bvmSPOpkZIsnvl
         +cWp4XMsCRysHS4Hf5no5SbuDZjVAwZt3ujXLo1XcTnORQihKzEWj60Gnc7Dnf5jrbWn
         Tors/GtyIkBO52Iqw0zyhH/oRyG68MdvqCV09xeZqPdQSOfkCtRmank917Fm5apHHUBg
         JYex3Ja8r5i7apfMjt/BN8fDoKStLwnzQI4vhD/6J5QUe4P2xdWDZJlASICMdXvgeJkd
         y87g==
X-Gm-Message-State: AOAM531yQK4tfEsyokDOViQUTYg8GroAQ7k8BmapcHE1nWdz2SGNQzQa
        C43iZC7TVTxowxwwcwzEsq0L1g==
X-Google-Smtp-Source: ABdhPJwpRXLaA5TjrnDxM/2gBhOTGH/MNrIduQT/kt54RpISuyy9Ge37m9qgVMQ0ILHqKPUEOUwsTw==
X-Received: by 2002:a02:908a:: with SMTP id x10mr1409251jaf.30.1630531782445;
        Wed, 01 Sep 2021 14:29:42 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id g12sm416700iok.32.2021.09.01.14.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 14:29:41 -0700 (PDT)
Date:   Wed, 1 Sep 2021 21:29:38 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 03/12] KVM: arm64: selftests: Add support for cpu_relax
Message-ID: <YS/wwkZu4lfqtmYx@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-4-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:03PM +0000, Raghavendra Rao Ananta wrote:
> Implement the guest helper routine, cpu_relax(), to yield
> the processor to other tasks.
> 
> The function was derived from
> arch/arm64/include/asm/vdso/processor.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 082cc97ad8d3..78df059dc974 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -191,6 +191,11 @@ asm(
>  	val;								  \
>  })
>  
> +static inline void cpu_relax(void)
> +{
> +	asm volatile("yield" ::: "memory");
> +}
> +
>  #define isb()		asm volatile("isb" : : : "memory")
>  #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
>  #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

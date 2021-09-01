Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C181D3FE614
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 02:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbhIAX1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 19:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbhIAX1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 19:27:54 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D20C061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 16:26:56 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b10so145366ioq.9
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 16:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rOUt9lzL9h2nq8MizjgBr+LfkDuELuuwWbBlNJOQ814=;
        b=jR/4VwVeeFqV1reopTHZE859VRG+CTWfBgJ8xN+yYGIx367PJ9Bws70Zg1EV1ucG2W
         Y2lFJoMSCpZf0ZOBx+NjhIwk4yEFfXdTmKpLSNameuBcxm0f3b2xsZjDWWLkXQzioQzB
         rdiu2pi+dfj/LlK0SlnX6FXxRO6MlVrubO0LNbHQ1f2H+r49vZAn5pbFbLXLrAIpkyvv
         0mbcwbkA1+xfcqzsopbM8IzOFTKlUOVzRZtTJtxfRnE1RlJMRGD/lXwDFs9D701+M4E3
         2garEAvPOF6McbV+BoD72/uphVFvhiZwvjqcrhncYz9MizgjNlM4Tikc2xVWnh6P+yPf
         Hg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rOUt9lzL9h2nq8MizjgBr+LfkDuELuuwWbBlNJOQ814=;
        b=NpvuPok3womh24et9Mm0Yh7o/CoEDENuyh5Nd30RC2iOuQ/EhosHgNtzVj26Jg0FIE
         2rG63NPgJRO1MgXT7HzKPpLDc+phZXVWRre0RhkzTTmfmMZML/U5ULVKMkAc5g+YXVi9
         GDsdKLOVf9XcK/cQx6m/JDP1y1KL/Y1Yk59oes1Ti0WRbJ5w5VpV+ufXA/ufZ1NGh8MU
         10kQ4LL0gF67edJQMSCbYdfCaIXXoUKI5se00y77KOEXTZRxYx5sgG/7FYKyhKxGoS8x
         LWBJSUBZIaGIVI3mYUOtNDmWH7ckUCCUvHdZT90HizBoxN4Wehr1k4Ti1fEtfvB4BQ90
         /pmA==
X-Gm-Message-State: AOAM531g5r8cgjHYVjwRmdORSlF9sPN1KAiDTg90o71Nh7JpD+9N2Yai
        Qv15S4osxzarY9gGC/+f9M7l3Q==
X-Google-Smtp-Source: ABdhPJzCa6eAMWUaKvrSDwb4bW983RzCXex8DdL6ys7hZpXkcFNe3o+vWqlq6lWO9U5Kc26/5lS5Gw==
X-Received: by 2002:a5d:9b99:: with SMTP id r25mr279115iom.104.1630538816261;
        Wed, 01 Sep 2021 16:26:56 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id q12sm14251ioh.20.2021.09.01.16.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:26:55 -0700 (PDT)
Date:   Wed, 1 Sep 2021 23:26:52 +0000
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
Subject: Re: [PATCH v3 06/12] KVM: arm64: selftests: Add support to disable
 and enable local IRQs
Message-ID: <YTAMPIBDSl1rJHUR@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-7-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-7-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:06PM +0000, Raghavendra Rao Ananta wrote:
> Add functions local_irq_enable() and local_irq_disable() to
> enable and disable the IRQs from the guest, respectively.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 78df059dc974..c35bb7b8e870 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -241,4 +241,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
>  #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
>  #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
>  
> +static inline void local_irq_enable(void)
> +{
> +	asm volatile("msr daifclr, #3" : : : "memory");
> +}
> +
> +static inline void local_irq_disable(void)
> +{
> +	asm volatile("msr daifset, #3" : : : "memory");
> +}
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

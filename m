Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9FF3FE4D8
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245636AbhIAVYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbhIAVY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:24:27 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71E6C061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:23:29 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id b4so697921ilr.11
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U3KFrpxU4d2fmsa0Mn7hWzZCFQgA1sH9j0f2Swqi3I4=;
        b=fRlBbRG00Jqh6wY8ay/vacNRJwhJuS8FG/s1/thQukVdCQCJZlOxZIPolWunH7C2aS
         akm7SCr0nYZMueozliPX04kjQ92ewCY0fr31acSvPe1QwCKnJCvV1jwaL0tMxKpEVxXy
         eI48fILum/Et8BgE8VkMExuJkjWvZcaUeP5lNHCm2rhQrDTujESJAzUdlAvLZgnYpI3q
         EGr23r8la80yjaBNhhUmog5qndDRkCqe8kDmXOEP8OzSm4v6/MqhrlrTMKGOq1MCr6tH
         4YLtyc5X2l5XKqzojqkHgqdXzoz41yjcj9Z5WLNn9001mORzWwl5LchRCco5+T+7dEvp
         aNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U3KFrpxU4d2fmsa0Mn7hWzZCFQgA1sH9j0f2Swqi3I4=;
        b=ZVxtftb8Im+estayuydPjuBrBWUcMGsXAO7nEyFvP27OLQDwih7ByxyrIViOamGpm+
         atAwFyebFQ+xD/jNnxny1Ai3Kx56hosxHkalVTI9C3AbNy+BvWbnlFVdAbfyGIRsYJdZ
         VTjlFcjSIrGk2ab52ZX8vhJJkbUrC5Nb36kqJQf1vo4Kf0hh0M+0j9M4HvCOoyE7Si1e
         oudJbHR21Cr33XWGitIqtidC2jblY4V37YJRpfydhwuxLu+iDDaZzxN1r8atWeBaz8gO
         zlWyukcENFTOvi19eE3C+GLsFUgLMUkD35LnyM29NL3iU1hLojCuSUfXa0h8n6OK9nXb
         ZE4A==
X-Gm-Message-State: AOAM530TAKLxx9AnsoTNBCDXZZc4XysDZVWpxidiHMAxWftcf8iEsV02
        vE7GJfheW/0bIGIsa3dXsW60jg==
X-Google-Smtp-Source: ABdhPJziw+f4QRZL4Kpj7Ibv9UlaRalcjNo2GmF90sZI6p2noJaakA4if8ogq5yuBsRPfvxTChZhRQ==
X-Received: by 2002:a05:6e02:531:: with SMTP id h17mr1051378ils.288.1630531409092;
        Wed, 01 Sep 2021 14:23:29 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id k21sm443809ioh.38.2021.09.01.14.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 14:23:28 -0700 (PDT)
Date:   Wed, 1 Sep 2021 21:23:25 +0000
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
Subject: Re: [PATCH v3 01/12] KVM: arm64: selftests: Add MMIO readl/writel
 support
Message-ID: <YS/vTVPi7Iam+ZXX@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-2-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-2-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:01PM +0000, Raghavendra Rao Ananta wrote:
> Define the readl() and writel() functions for the guests to
> access (4-byte) the MMIO region.
> 
> The routines, and their dependents, are inspired from the kernel's
> arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index c0273aefa63d..3cbaf5c1e26b 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -130,6 +130,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
>  	val;								  \
>  })
>  
> -#define isb()	asm volatile("isb" : : : "memory")
> +#define isb()		asm volatile("isb" : : : "memory")

Is this a stray diff?

Otherwise:

Reviewed-by: Oliver Upton <oupton@google.com>

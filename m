Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1537B173593
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 11:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgB1KrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 05:47:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726063AbgB1KrN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 05:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582886832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=by6qnbWXHvbfMve5jRvxpdLV2eFgarPImZ7pzkAFACI=;
        b=Dw10pNHUtxd5wfEnfLwub1Kw0GXIYOkmzEJCffe5jOFNvpsIudYj9zZdpy6bmaSrYKV87S
        n6fcYgqjOHexMcBkYGbClxoVJ1NSqSAiPluTP/nS5Ty03gIj/LHF1DRIy+GKZnSUAcpME8
        wUEC3pBancsPi1+LqdDqW532l6hz0lA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-uct7AZmtOWyLRurfLUM9Pg-1; Fri, 28 Feb 2020 05:47:10 -0500
X-MC-Unique: uct7AZmtOWyLRurfLUM9Pg-1
Received: by mail-wr1-f72.google.com with SMTP id s13so1159448wru.7
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 02:47:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=by6qnbWXHvbfMve5jRvxpdLV2eFgarPImZ7pzkAFACI=;
        b=DYplz76B74P2dgpVyB1x5qs/ArjKS/NWofYOXTCZcaPOsTzxLaAr9ZnU4t0Kvh0TVn
         +CehnsJkOIrm3HxctBA+UmLp1lgugKF1xo9pt8zqshK4p2R2lE1a6fh16PqWa+y2lZrH
         TUuDdw/mF+PMa37DGEz4eeXSnN2yXBSTwkjb0xQ2JuYq2PZrhrDRy92mMIdsFUCoySaM
         liZxW4GXatin/KhkXIX2xbW8v6qb6+40y0kDcS/gHXS67rG8wZfnyAxxqMfgIxEzB2Pz
         r5NLo/5WuN9KTpdyRjupCkol5jqa43khfSyLO/BJ80VhImRs5xYfZeiwFVbciORu2nTC
         l2MQ==
X-Gm-Message-State: APjAAAU7R2RO2K+hgZQUWWE2uWbbQLkwlpqUs438PfIs3/nWnrXJMmxM
        FSspjqEzIk8ng30Y7vsCo8I9NO07YE/vRXazjkeoTuGLM8Js+zudmeO170fNogJmagZNSVFnunh
        9p55og7WaCTzW
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr4308797wmk.160.1582886829211;
        Fri, 28 Feb 2020 02:47:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqz5y4mrS/flKBx5L1gDb3tgLLQMoczS1j4+xFLFc7QK89AHPXzLtC2JXXQ6xdqLZv0ycLtvwA==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr4308771wmk.160.1582886828876;
        Fri, 28 Feb 2020 02:47:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id h10sm1694142wml.18.2020.02.28.02.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 02:47:08 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.6
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Jeremy Cline <jcline@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20200225235223.12839-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <53886277-3081-f8a9-7750-5784a9af2e56@redhat.com>
Date:   Fri, 28 Feb 2020 11:47:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225235223.12839-1-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 00:52, Marc Zyngier wrote:
> Paolo,
> 
> This is a small update containing a number of fixes, the most important ones
> making sure we force the inlining of any helper that gets used by the EL2 code
> (James identified that some bad things happen with CLang and the Shadow Call
> Stack extention).
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 4a267aa707953a9a73d1f5dc7f894dd9024a92be:
> 
>   KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer (2020-01-28 13:09:31 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.6-1
> 
> for you to fetch changes up to e43f1331e2ef913b8c566920c9af75e0ccdd1d3f:
> 
>   arm64: Ask the compiler to __always_inline functions used by KVM at HYP (2020-02-22 11:01:47 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm fixes for 5.6, take #1
> 
> - Fix compilation on 32bit
> - Move  VHE guest entry/exit into the VHE-specific entry code
> - Make sure all functions called by the non-VHE HYP code is tagged as __always_inline
> 
> ----------------------------------------------------------------
> James Morse (3):
>       KVM: arm64: Ask the compiler to __always_inline functions used at HYP
>       KVM: arm64: Define our own swab32() to avoid a uapi static inline
>       arm64: Ask the compiler to __always_inline functions used by KVM at HYP
> 
> Jeremy Cline (1):
>       KVM: arm/arm64: Fix up includes for trace.h
> 
> Mark Rutland (1):
>       kvm: arm/arm64: Fold VHE entry/exit work into kvm_vcpu_run_vhe()
> 
>  arch/arm/include/asm/kvm_host.h          |  3 --
>  arch/arm64/include/asm/arch_gicv3.h      |  2 +-
>  arch/arm64/include/asm/cache.h           |  2 +-
>  arch/arm64/include/asm/cacheflush.h      |  2 +-
>  arch/arm64/include/asm/cpufeature.h      | 10 +++----
>  arch/arm64/include/asm/io.h              |  4 +--
>  arch/arm64/include/asm/kvm_emulate.h     | 48 ++++++++++++++++----------------
>  arch/arm64/include/asm/kvm_host.h        | 32 ---------------------
>  arch/arm64/include/asm/kvm_hyp.h         |  7 +++++
>  arch/arm64/include/asm/kvm_mmu.h         |  3 +-
>  arch/arm64/include/asm/virt.h            |  2 +-
>  arch/arm64/kvm/hyp/switch.c              | 39 ++++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  4 +--
>  virt/kvm/arm/arm.c                       |  2 --
>  virt/kvm/arm/trace.h                     |  1 +
>  15 files changed, 84 insertions(+), 77 deletions(-)
> 

Pulled, thanks.

Paolo


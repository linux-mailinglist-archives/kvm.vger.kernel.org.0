Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8141F271468
	for <lists+kvm@lfdr.de>; Sun, 20 Sep 2020 15:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgITNOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Sep 2020 09:14:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbgITNOg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Sep 2020 09:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600607675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gSKW12cZqUl1E+chwojz8nTsFE2FCtnzJEASLd/xV30=;
        b=F7YH5rpTFwGxQujfL308hHPW52wRUqgIgX5X+G2OExOPCAnABBH4g3/hwN/p9eV07AS34E
        6BClG/I4GZ6iOxVHokkTz4kOOQXU5V/XkcPMtQp9p5MaDscZkjfe969CL1FgNmRNEiPa27
        /peG+R1iJvnsj6EX9+R6AnLmCl5x0ok=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-OM8RSEkHOQ-xZsLDnjpgOQ-1; Sun, 20 Sep 2020 09:14:33 -0400
X-MC-Unique: OM8RSEkHOQ-xZsLDnjpgOQ-1
Received: by mail-wr1-f72.google.com with SMTP id l9so4562314wrq.20
        for <kvm@vger.kernel.org>; Sun, 20 Sep 2020 06:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gSKW12cZqUl1E+chwojz8nTsFE2FCtnzJEASLd/xV30=;
        b=QX77OnMl+sw2z2D74hs6Tc3m8G/6Jgz+/X6WRMFEvqp62Jjdr98UTrFRX1mMl5q9xd
         UNKr4Lfy1xQm6/Ot9WXhxVdYEQTh2BpkJ8Pav0Xe2V7q24TvfqSTa0bv8M9Dpdod4QH5
         /K51FHULBYuv1DFRrltf9dosYH5pxeXAKjR2qe+A59lep/jkjYHKoP37h3p6aYa0F3yn
         wgbmXhhxyijVtmIQ0VH4+vyVSnVVP2Q4eugAov51ANfwj8kAoNVJOIk9/10hDSiyn1Fe
         47iynScJTl+qdEHJ6acVlH+KZbzYyYxvP130Nji8qv3mO4YhcflGibnFV8P1CJAeAl1Q
         5tnQ==
X-Gm-Message-State: AOAM530P8S9I92Kncm+50wEq/AYk9zfiuBT22Mz38ajGaoGhATq1fIk9
        9aQaILcVC+FkVON0HuTOAFN7u8qyyVWAEAbX61IPeTo0cQw7nwo9xtSoMvCyFa2DSmduU8xGxBp
        OojnvdUS3JDQO
X-Received: by 2002:a1c:40a:: with SMTP id 10mr26038988wme.61.1600607671801;
        Sun, 20 Sep 2020 06:14:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy9mQ/XuFR3pCMbTHL8kPkRRUxwdVKzYostTWzZC+d7lZERoWWg3MPLZ+kxWK7UN4+gBtzdQ==
X-Received: by 2002:a1c:40a:: with SMTP id 10mr26038968wme.61.1600607671619;
        Sun, 20 Sep 2020 06:14:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:458b:b280:cf0:4acf? ([2001:b07:6468:f312:458b:b280:cf0:4acf])
        by smtp.gmail.com with ESMTPSA id n14sm13982479wmi.33.2020.09.20.06.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 06:14:31 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.9, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200918171651.1340445-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3705aa31-fd73-288b-98f1-b6bc02c94709@redhat.com>
Date:   Sun, 20 Sep 2020 15:14:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200918171651.1340445-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/20 19:16, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the latest set of fixes for 5.9. The first patch is pretty
> nasty, as a guest hitting this bug will have its vcpu stuck on a
> fault, without any hope of it being resolved. Embarrassing, and
> definitely a stable candidate. The second patch is only a cleanup
> after the first one.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 7b75cd5128421c673153efb1236705696a1a9812:
> 
>   KVM: arm64: Update page shift if stage 2 block mapping not supported (2020-09-04 10:53:48 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.9-2

Pulled, thanks.

Paolo

> 
> for you to fetch changes up to 620cf45f7a516bf5fe9e5dce675a652e935c8bde:
> 
>   KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite() (2020-09-18 18:01:48 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.9, take #2
> 
> - Fix handling of S1 Page Table Walk permission fault at S2
>   on instruction fetch
> - Cleanup kvm_vcpu_dabt_iswrite()
> 
> ----------------------------------------------------------------
> Marc Zyngier (2):
>       KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch
>       KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite()
> 
>  arch/arm64/include/asm/kvm_emulate.h    | 14 +++++++++++---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>  arch/arm64/kvm/mmu.c                    |  4 ++--
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 


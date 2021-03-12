Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BA83395FE
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 19:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhCLSQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 13:16:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232702AbhCLSP5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 13:15:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615572956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zT1uG5BRCkJ0aRoz3/NkmyhO11KSSWzsG6Lpm+NPJHg=;
        b=E1WfP6eD46DiH03eGsORZPJcNh7xRFFOidMLcTSjjVZ2o+9LIMJq+mQpuuzmbFGCk2cyMl
        T+XGvMHA98t3mqJy0SY9lhOhmkmMBz5NJxOZ9Encatruu/ivfuANFxLXCoEiupaKPSpGh3
        3nf1ZISphkKvlsv7F/uSvdo3Szc/zxk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-lI8hoOdsMtKNqMT_pjdjpg-1; Fri, 12 Mar 2021 13:15:54 -0500
X-MC-Unique: lI8hoOdsMtKNqMT_pjdjpg-1
Received: by mail-wr1-f70.google.com with SMTP id h30so11544463wrh.10
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 10:15:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zT1uG5BRCkJ0aRoz3/NkmyhO11KSSWzsG6Lpm+NPJHg=;
        b=b5UldoXkvPYV41ZJGt9atFzFYKqXlR+jxeguGiV/3WSNZXXSYvWTkMnN1E0IDICt5a
         jf59P6Fbw0kDCPEaHF1AJmuWnZlTyv6FyUF2NGWe5iZ8drEywblhAFqB5PcCiBdn5KEU
         HS5cCPoUFJUlr4dIoN73+wHGGY0Au0FYtC50nxOp7Q8Nv3md9jcnNaFZoC182K/nHmE5
         rD3Ndp+aCzh9Quo5jtzkx+Q7EgkMYIbdBqeckOJHO9V3wxjGjp3MRECKiS0Z23Q02XCa
         E7aC+SkHsNold9gOpRnOROId0YjF6OOcO3Gqzs2lrxKE41q41NyP+cK27DOTzJEyR2gq
         Hw0g==
X-Gm-Message-State: AOAM532srIY/4Fnprifskh7JlRt86YplLiFnhHAuq8CiKfU0xDwyxAkC
        kHLbHClVvvyxPwSHSBqj4DrhGAusuX5il/kfShOzhpEG479huBjm7Z3yxbrTaBrbAIhSt6dubmb
        SrGbSGv34Jd0F
X-Received: by 2002:a7b:c409:: with SMTP id k9mr14187054wmi.151.1615572953479;
        Fri, 12 Mar 2021 10:15:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzt4L3TBqWVhM4jskGZ84OnFOwnKLJkMoA4pYXvuOzXtxArZsbNlEHt10/qFmRlGX4GZynm/A==
X-Received: by 2002:a7b:c409:: with SMTP id k9mr14187031wmi.151.1615572953265;
        Fri, 12 Mar 2021 10:15:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i10sm8192851wrs.11.2021.03.12.10.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:15:52 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.12, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210312160003.3920996-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <638be040-7564-a65c-4138-62b21bff4402@redhat.com>
Date:   Fri, 12 Mar 2021 19:15:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210312160003.3920996-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/21 17:00, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the second batch of KVM/arm64 fixes for 5.12. The most notable
> item is the tidying up of the way we deal with the guest physical
> space, which had a couple of warts. The other patches address i-cache
> isolation between vcpus (they are supposed to be vcpu-private, but can
> not being so...), and a fix for a link-time issue that can occur with
> LTO.
> 
> Note that this time around, this pull request is on top of kvm/next,
> right after the patches you applied last week.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 357ad203d45c0f9d76a8feadbd5a1c5d460c638b:
> 
>    KVM: arm64: Fix range alignment when walking page tables (2021-03-06 04:18:41 -0500)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-2
> 
> for you to fetch changes up to 262b003d059c6671601a19057e9fe1a5e7f23722:
> 
>    KVM: arm64: Fix exclusive limit for IPA size (2021-03-12 15:43:22 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.12, take #2
> 
> - Fix a couple of branches that could be impossible to resolve at
>    link time when objects are far apart, such as with LTO
> - Mandate i-cache invalidation when two vcpus are sharing a physical CPU
> - Fail VM creation if the implicit IPA size isn't supported
> - Don't reject memslots that reach the IPA limit without breaching it
> 
> ----------------------------------------------------------------
> Marc Zyngier (3):
>        KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
>        KVM: arm64: Reject VM creation when the default IPA size is unsupported
>        KVM: arm64: Fix exclusive limit for IPA size
> 
> Sami Tolvanen (1):
>        KVM: arm64: Don't use cbz/adr with external symbols
> 
>   Documentation/virt/kvm/api.rst     |  3 +++
>   arch/arm64/include/asm/kvm_asm.h   |  4 ++--
>   arch/arm64/kvm/arm.c               |  7 ++++++-
>   arch/arm64/kvm/hyp/entry.S         |  6 ++++--
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 +++---
>   arch/arm64/kvm/hyp/nvhe/tlb.c      |  3 ++-
>   arch/arm64/kvm/hyp/vhe/tlb.c       |  3 ++-
>   arch/arm64/kvm/mmu.c               |  3 +--
>   arch/arm64/kvm/reset.c             | 12 ++++++++----
>   9 files changed, 31 insertions(+), 16 deletions(-)
> 

Pulled, thanks.

Paolo

